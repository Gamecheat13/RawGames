; =============================================================================================================
; =============================================================================================================
; =============================================================================================================
(global boolean b_debug_extras TRUE)
;*
== LOAD PARAMETERS ==

1 - LEFT 
2 - RIGHT 
3 - DUAL 
4 - OUT THE CHUTE 

*;
;*
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
							(if b_debug_extras (print "load fork left..."))
							(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_l")
						)
		)
		; right 
		((= load_side "right")
						(begin
							(if b_debug_extras (print "load fork right..."))
							(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_r")
							(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_r")
							(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_r")
							(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_r")
							
						)
		)
		; dual 
		((= load_side "dual")
						(begin
							(if b_debug_extras (print "load fork dual..."))
							(ai_vehicle_enter_immediate load_squad_01 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_02 fork "fork_p_l")
							(ai_vehicle_enter_immediate load_squad_03 fork "fork_p_r")
							(ai_vehicle_enter_immediate load_squad_04 fork "fork_p_r")
						)
		)
		
		((= load_side "any")
						(begin
							(if b_debug_extras (print "load fork any..."))
							(ai_vehicle_enter_immediate load_squad_01 fork "fork_p")
							(ai_vehicle_enter_immediate load_squad_02 fork "fork_p")
							(ai_vehicle_enter_immediate load_squad_03 fork "fork_p")
							(ai_vehicle_enter_immediate load_squad_04 fork "fork_p")
						)
		)
	)
)

; call this script when the phantom is in place to drop off all the ai ====================================================================
(script static void (f_unload_fork
										(vehicle fork)
										(string drop_side)
				)
	
	(if b_debug_extras (print "opening fork..."))
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
							(f_unload_fork_left fork)
							(f_unload_fork_right fork)
							(sleep 75)
						)
		)
	)
	
	(if b_debug_extras (print "closing fork..."))
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
	)
)
*;
; call this script to load up the phantom before flying it into position ================================================================
(script static void	(f_load_phantom
								(vehicle phantom)		; phantom to load 
								(string load_side)		; how to load it 
								(ai load_squad_01)		; squads to load 
								(ai load_squad_02)
								(ai load_squad_03)
								(ai load_squad_04)
				)
				
	; place ai 
	(ai_place load_squad_01)
	(ai_place load_squad_02)
	(ai_place load_squad_03)
	(ai_place load_squad_04)
		(sleep 1)
	
	
	(cond
		; left 
		((= load_side "left")
						(begin
							(if b_debug_extras (print "load phantom left..."))
							(ai_vehicle_enter_immediate load_squad_01 phantom "phantom_p_lb")
							(ai_vehicle_enter_immediate load_squad_02 phantom "phantom_p_lf")
							(ai_vehicle_enter_immediate load_squad_03 phantom "phantom_p_ml_f")
							(ai_vehicle_enter_immediate load_squad_04 phantom "phantom_p_ml_b")
						)
		)
		; right 
		((= load_side "right")
						(begin
							(if b_debug_extras (print "load phantom right..."))
							(ai_vehicle_enter_immediate load_squad_01 phantom "phantom_p_rb")
							(ai_vehicle_enter_immediate load_squad_02 phantom "phantom_p_rf")
							(ai_vehicle_enter_immediate load_squad_03 phantom "phantom_p_mr_f")
							(ai_vehicle_enter_immediate load_squad_04 phantom "phantom_p_mr_b")
							
						)
		)
		; dual 
		((= load_side "dual")
						(begin
							(if b_debug_extras (print "load phantom dual..."))
							(ai_vehicle_enter_immediate load_squad_01 phantom "phantom_p_lf")
							(ai_vehicle_enter_immediate load_squad_02 phantom "phantom_p_rf")
							(ai_vehicle_enter_immediate load_squad_03 phantom "phantom_p_lb")
							(ai_vehicle_enter_immediate load_squad_04 phantom "phantom_p_rb")
						)
		)
		
		((= load_side "any")
						(begin
							(if b_debug_extras (print "load phantom any..."))
							(ai_vehicle_enter_immediate load_squad_01 phantom "phantom_p")
							(ai_vehicle_enter_immediate load_squad_02 phantom "phantom_p")
							(ai_vehicle_enter_immediate load_squad_03 phantom "phantom_p")
							(ai_vehicle_enter_immediate load_squad_04 phantom "phantom_p")
						)
		)
		; dual 
		;*
		((= load_side "chute")
						(begin
							(if b_debug_extras (print "load phantom chute..."))
							(ai_vehicle_enter_immediate load_squad_01 phantom "phantom_pc_a")
							(ai_vehicle_enter_immediate load_squad_02 phantom "phantom_pc_b")
							(ai_vehicle_enter_immediate load_squad_03 phantom "phantom_pc_c")
							(ai_vehicle_enter_immediate load_squad_04 phantom "phantom_pc_d")
						)
		)
		*;
	)
)

(script static void (f_load_phantom_cargo
										(vehicle phantom)		; the phantom you are loading the cargo in to 
										(string load_number)	; 1 - single load    ---   2 - double load 
										(ai load_squad_01)		; first squad to load 
										(ai load_squad_02)		; second squad to load 
				)
	; place ai 
	
	; load into phantom 
	(cond
		((= load_number "single")	
						(begin
							(ai_place load_squad_01)
								(sleep 1)
							(vehicle_load_magic phantom "phantom_lc" (ai_vehicle_get_from_squad load_squad_01 0))
						)
		)
		((= load_number "double")	
						(begin
							(ai_place load_squad_01)
							(ai_place load_squad_02)
								(sleep 1)
							(vehicle_load_magic phantom "phantom_sc01" (ai_vehicle_get_from_squad load_squad_01 0))
							(vehicle_load_magic phantom "phantom_sc02" (ai_vehicle_get_from_squad load_squad_02 0))
						)
		)
	)
)



; call this script when the phantom is in place to drop off all the ai ====================================================================
(script static void (f_unload_phantom
										(vehicle phantom)
										(string drop_side)
				)
	
	(if b_debug_extras (print "opening phantom..."))
	(unit_open phantom)
	(sleep 30)
	; determine how to unload the phantom 
	(cond
		((= drop_side "left")	
						(begin
							(f_unload_ph_left phantom)
							(sleep 45)
							(f_unload_ph_mid_left phantom)
							(sleep 75)
						)
		)

		((= drop_side "right")	
						(begin
							(f_unload_ph_right phantom)
							(sleep 45)
							(f_unload_ph_mid_right phantom)
							(sleep 75)
						)
		)

		((= drop_side "dual")
						(begin
							(f_unload_ph_left phantom)
							(f_unload_ph_right phantom)
							(sleep 75)
						)
		)
		((= drop_side "chute")
						(begin
							(f_unload_ph_chute phantom)
							(sleep 75)
						)
		)
	)
	
	(if b_debug_extras (print "closing phantom..."))
	(unit_close phantom)
	
)

; you never have to call these scripts directly ===========================================================================================
(script static void (f_unload_ph_left
										(vehicle phantom)
				)
	; randomly evacuate the two sides 
	(begin_random
		(begin
			(vehicle_unload phantom "phantom_p_lf")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload phantom "phantom_p_lb")
			(sleep (random_range 0 10))
		)
	)
)
(script static void (f_unload_ph_right
										(vehicle phantom)
				)
	; randomly evacuate the two sides 
	(begin_random
		(begin
			(vehicle_unload phantom "phantom_p_rf")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload phantom "phantom_p_rb")
			(sleep (random_range 0 10))
		)
	)
)
(script static void (f_unload_ph_mid_left
										(vehicle phantom)
				)
	; randomly evacuate the two sides 
	(begin_random
		(begin
			(vehicle_unload phantom "phantom_p_ml_f")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload phantom "phantom_p_ml_b")
			(sleep (random_range 0 10))
		)
	)
)
(script static void (f_unload_ph_mid_right
										(vehicle phantom)
				)
	; randomly evacuate the two sides 
	(begin_random
		(begin
			(vehicle_unload phantom "phantom_p_mr_f")
			(sleep (random_range 0 10))
		)
		(begin
			(vehicle_unload phantom "phantom_p_mr_b")
			(sleep (random_range 0 10))
		)
	)
)
(script static void (f_unload_ph_chute
										(vehicle phantom)
				)
	; turn on phantom power 
	(object_set_phantom_power phantom TRUE)
	
	; poop dudes out the chute 
	;*
	(if (vehicle_test_seat phantom "phantom_pc_a")	
									(begin
										(vehicle_unload phantom "phantom_pc_a")
										(sleep 120)
									)
	)
	(if (vehicle_test_seat phantom "phantom_pc_b")	
									(begin
										(vehicle_unload phantom "phantom_pc_b")
										(sleep 120)
									)
	)
	(if (vehicle_test_seat phantom "phantom_pc_c")	
									(begin
										(vehicle_unload phantom "phantom_pc_c")
										(sleep 120)
									)
	)
	(if (vehicle_test_seat phantom "phantom_pc_d")	
									(begin
										(vehicle_unload phantom "phantom_pc_d")
										(sleep 120)
									)
	)
	*;
	
	; turn off phantom power 
	(object_set_phantom_power phantom FALSE)
									
)

(script static void (f_unload_phantom_cargo
										(vehicle phantom)
										(string load_number)
				)
	; unload cargo seats 
	(cond
		((= load_number "single")	(vehicle_unload phantom "phantom_lc"))
		((= load_number "double")
								(begin_random
									(begin
										(vehicle_unload phantom "phantom_sc01")
										(sleep (random_range 15 30))
									)
									(begin
										(vehicle_unload phantom "phantom_sc02")
										(sleep (random_range 15 30))
									)
								)
		)
	)
)

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
							(if b_debug_extras (print "load phantom left..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_l")
							;(ai_vehicle_enter_immediate load_squad_02 pelican "phantom_p_lf")
							;(ai_vehicle_enter_immediate load_squad_03 pelican "phantom_p_ml_f")
							;(ai_vehicle_enter_immediate load_squad_04 pelican "phantom_p_ml_b")
						)
		)
		; right 
		((= load_side "right")
						(begin
							(if b_debug_extras (print "load phantom right..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_r")
							;(ai_vehicle_enter_immediate load_squad_02 pelican "phantom_p_rf")
							;(ai_vehicle_enter_immediate load_squad_03 pelican "phantom_p_mr_f")
							;(ai_vehicle_enter_immediate load_squad_04 pelican "phantom_p_mr_b")
							
						)
		)
		; dual 
		((= load_side "dual")
						(begin
							(if b_debug_extras (print "load phantom dual..."))
							(ai_vehicle_enter_immediate load_squad_01 pelican "pelican_p_l")
							(ai_vehicle_enter_immediate load_squad_02 pelican "pelican_p_r")
							;(ai_vehicle_enter_immediate load_squad_02 phantom "phantom_p_rf")
							;(ai_vehicle_enter_immediate load_squad_03 phantom "phantom_p_lb")
							;(ai_vehicle_enter_immediate load_squad_04 phantom "phantom_p_rb")
						)
		)
	)			
				
)

;*
(script static void f_load_pelican_test
	(ai_place test_pelican)
	(f_load_pelican (ai_vehicle_get_from_starting_location test_pelican/pilot) "dual" evac_marines NONE)
)
*;