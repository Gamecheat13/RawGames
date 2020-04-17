; =================================================================================================
; GLOBAL_FORK.HSC
; HOW TO USE:
; 	1. Open your scenario in Sapien
;	2. In the menu bar, open the "Scenarios" menu, then select "Add Mission Script"
;	3. Point the dialogue to this file: main\data\globals\global_fork.hsc
; =================================================================================================
(global boolean b_debug_fork true)

;*
== LOAD PARAMETERS ==
LEFT, RIGHT, DEFAULT, LEFT_FULL, RIGHT_FULL, FULL
*;

(script static void (f_load_fork
								(vehicle fork)
								(string load_side)
								(ai load_squad_01)
								(ai load_squad_02)
								(ai load_squad_03)
								(ai load_squad_04)
				)
				
	(ai_place load_squad_01)
	(ai_place load_squad_02)
	(ai_place load_squad_03)
	(ai_place load_squad_04)
		(sleep 1)
		
	
	(cond
		; left 
		((= load_side "left")
						(begin
							(if b_debug_fork (print "load fork left..."))
							(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_l")
						)
		)
		; right 
		((= load_side "right")
						(begin
							(if b_debug_fork (print "load fork right..."))
							(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_r")
							(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_r")
							(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_r")
							(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_r")
							
						)
		)
		; dual 
		((= load_side "dual")
						(begin
							(if b_debug_fork (print "load fork dual..."))
							(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_r")
							(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_r")
						)
		)
		
		((= load_side "any")
						(begin
							(if b_debug_fork (print "load fork any..."))
							(ai_vehicle_enter_immediate load_squad_01 fork "fork_p")
							(ai_vehicle_enter_immediate load_squad_02 fork "fork_p")
							(ai_vehicle_enter_immediate load_squad_03 fork "fork_p")
							(ai_vehicle_enter_immediate load_squad_04 fork "fork_p")
						)
		)
	)
)

(script static void (f_load_fork_cargo
										(vehicle fork)		; the phantom you are loading the cargo in to 
										(string load_type)	; 1 - single load    ---   2 - double load 
										(ai load_squad_01)		; first squad to load
										(ai load_squad_02)		; second squad to load 
										(ai load_squad_03)		; third squad to load 
				)
	; place ai 
	
	; load into fork 
	(cond
		((= load_type "large")	
						(begin
							(ai_place load_squad_01)
								(sleep 1)
							(vehicle_load_magic fork "fork_lc" (ai_vehicle_get_from_squad load_squad_01 0))
						)
		)
		((= load_type "small")	
						(begin
							(ai_place load_squad_01)
							(ai_place load_squad_02)
							(ai_place load_squad_03)
								(sleep 1)
							(vehicle_load_magic fork "fork_sc01" (ai_vehicle_get_from_squad load_squad_01 0))
							(vehicle_load_magic fork "fork_sc02" (ai_vehicle_get_from_squad load_squad_02 0))
							(vehicle_load_magic fork "fork_sc03" (ai_vehicle_get_from_squad load_squad_03 0))
						)
		)
	)
)

; call this script when the fork is in place to drop off all the ai ====================================================================
(script static void (f_unload_fork
										(vehicle fork)
										(string drop_side)
				)
	
	(if b_debug_fork (print "opening fork..."))
	(unit_open fork)
	(sleep 30)
	; determine how to unload the phantom 
	(cond
		((= drop_side "left")	
						(begin
							(f_unload_fork_left fork)
							(sleep 75)
						)
		)

		((= drop_side "right")	
						(begin
							(f_unload_fork_right fork)
							(sleep 75)
						)
		)

		((= drop_side "dual")
						(begin
							(f_unload_fork_all fork)
							(sleep 75)
						)
		)
	)
	
	(if b_debug_fork (print "closing fork..."))
	(unit_close fork)	
)


(script static void (f_unload_fork_left	(vehicle fork))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_l1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l8")
			(sleep (random_range 0 10))
		)
	)
)

(script static void (f_unload_fork_right (vehicle fork))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_r1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r8")
			(sleep (random_range 0 10))
		)
	)
)

(script static void (f_unload_fork_all	(vehicle fork))
	(begin_random
		(begin
			(vehicle_unload fork "fork_p_l1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_l8")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r1")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r2")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r3")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r4")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r5")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r6")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r7")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload fork "fork_p_r8")
			(sleep (random_range 0 10))
		)
	)
)

(script static void (f_unload_fork_cargo
										(vehicle fork)
										(string load_type)
				)
	; unload cargo seats 
	(cond
		((= load_type "large")	(vehicle_unload fork "fork_lc"))
		((= load_type "small")
								(begin_random
									(begin
										(vehicle_unload fork "fork_sc01")
										(sleep (random_range 15 30))
									)
									(begin
										(vehicle_unload fork "fork_sc02")
										(sleep (random_range 15 30))
									)
									(begin
										(vehicle_unload fork "fork_sc03")
										(sleep (random_range 15 30))
									)
								)
		)
		((= load_type "small01")
								(vehicle_unload fork "fork_sc01")
		)
		((= load_type "small02")
								(vehicle_unload fork "fork_sc02")
		)
		((= load_type "small03")
								(vehicle_unload fork "fork_sc03")
		)
	)
)
