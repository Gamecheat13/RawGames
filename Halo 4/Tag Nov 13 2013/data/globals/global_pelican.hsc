; =================================================================================================
; GLOBAL_PELICAN.HSC
; HOW TO USE:
; 	1. Open your scenario in Sapien
;	2. In the menu bar, open the "Scenarios" menu, then select "Add Mission Script"
;	3. Point the dialogue to this file: main\data\globals\global_pelican.hsc
; =================================================================================================
(global boolean b_debug_pelican TRUE)

(script static void	(f_load_pelican
								(vehicle pelican)		; phantom to load 
								(string load_side)		; how to load it 
								(ai load_squad_01)		; squads to load 
								(ai load_squad_02)
				)
	; place ai 
	(ai_place load_squad_01)
	(ai_place load_squad_02)
	;(ai_place load_squad_03)
	;(ai_place load_squad_04)
	(sleep 1)
	
	
	(cond
		; left 
		((= load_side "left")
						(begin
							(if b_debug_pelican (print "load pelican left..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_l")
							;(ai_vehicle_enter_immediate load_squad_02 pelican "phantom_p_lf")
							;(ai_vehicle_enter_immediate load_squad_03 pelican "phantom_p_ml_f")
							;(ai_vehicle_enter_immediate load_squad_04 pelican "phantom_p_ml_b")
						)
		)
		; right 
		((= load_side "right")
						(begin
							(if b_debug_pelican (print "load pelican right..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_r")
							;(ai_vehicle_enter_immediate load_squad_02 pelican "phantom_p_rf")
							;(ai_vehicle_enter_immediate load_squad_03 pelican "phantom_p_mr_f")
							;(ai_vehicle_enter_immediate load_squad_04 pelican "phantom_p_mr_b")
							
						)
		)
		; dual 
		((= load_side "dual")
						(begin
							(if b_debug_pelican (print "load pelican dual..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_l")
							(ai_vehicle_enter_immediate load_squad_02 pelican "pelican_p_r")
							;(ai_vehicle_enter_immediate load_squad_02 phantom "phantom_p_rf")
							;(ai_vehicle_enter_immediate load_squad_03 phantom "phantom_p_lb")
							;(ai_vehicle_enter_immediate load_squad_04 phantom "phantom_p_rb")
						)
		)
	)			
				
)


(script static void (f_unload_pelican_all	(vehicle pelican))
	(unit_open pelican)
	(sleep 60)
	(begin_random
		(begin
			(vehicle_unload pelican "pelican_p_l01")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_l02")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_l03")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_l04")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_l05")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r01")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r02")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r03")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r04")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload pelican "pelican_p_r05")
			(sleep (random_range 0 10))
		)
	)
)

; new pelican global scripts =======================================================================================================================================

(script static void (f_load_pelican_cargo
										(vehicle pelican)		; the phantom you are loading the cargo in to 
										(string load_type)	; 1 - single load    ---   2 - double load 
										(ai load_squad_01)		; first squad to load
										(ai load_squad_02)		; second squad to load 
				)
	; place ai 
	
	; load into fork 
	(cond
		((= load_type "large")	
						(begin
							(ai_place load_squad_01)
								(sleep 1)
							(vehicle_load_magic pelican "pelican_lc" (ai_vehicle_get_from_squad load_squad_01 0))
						)
		)
		((= load_type "small")	
						(begin
							(ai_place load_squad_01)
							(ai_place load_squad_02)
								(sleep 1)
							;(vehicle_load_magic pelican "pelican_lc_01" (ai_vehicle_get_from_squad load_squad_01 0))
							;(vehicle_load_magic pelican "pelican_lc_02" (ai_vehicle_get_from_squad load_squad_02 0))
						)
		)
	)
)

(script static void (f_unload_pelican_cargo
										(vehicle pelican)
										(string load_type)
				)
	; unload cargo seats 
	(cond
		((= load_type "large")	(vehicle_unload pelican "pelican_lc"))
		((= load_type "small")
								(begin_random
									(begin
										;(vehicle_unload pelican "pelican_lc_01")
										(sleep (random_range 15 30))
									)
									(begin
										;(vehicle_unload pelican "pelican_lc_02")
										(sleep (random_range 15 30))
									)
								)
		)
		;*
		((= load_type "small01")
								(vehicle_unload fork "pelican_lc_01")
		)
		((= load_type "small02")
								(vehicle_unload fork "pelican_lc_02")
		)
		*;
	)
)