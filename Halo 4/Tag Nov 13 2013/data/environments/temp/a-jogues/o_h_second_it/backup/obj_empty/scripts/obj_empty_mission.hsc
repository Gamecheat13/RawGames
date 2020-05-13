(global short s_objcon_checker 5)
(global ai v_sur_phantom_01 sq_phantom)
(global string s_sur_drop_side_01 "dual")


(script startup objective_heaven
 (wake f_check_trigger)
 ;(wake f_phantom_fly)
 
 
)

(script dormant f_check_trigger
	
	
	(sleep_until (volume_test_players tv_front) 1)
	(print "objective control : FRONT")
	(set s_objcon_checker 10)
	
	(sleep_until (volume_test_players tv_middle) 1)
	(print "objective control : MIDDLE")
	(set s_objcon_checker 25)
	
)

(script dormant f_phantom_fly
	(ai_place sq_phantom)
	;(set v_sur_phantom_01 (ai_vehicle_get_from_starting_location sq_phantom/phantom))

	
	(cs_fly_to sq_phantom/phantom TRUE fly/p0)
	(cs_fly_to sq_phantom/phantom TRUE fly/p1)
	
	;(cs_fly_to_and_face fly/p1 fly/face 1)
		(sleep 15)

			; ========= DROP DUDES HERE =============================
			
			(f_load_phantom
							v_sur_phantom_01
							"dual"
							sq_loader				
							sq_loader_2
						sq_loader_3
							sq_loader_4
			)
	
		(cs_fly_to sq_phantom/phantom TRUE fly/p2)
			(f_unload_phantom
							v_sur_phantom_01
							"dual"
			)
			;(cs_fly_to sq_gp_phantom_1/driver TRUE ps_gp_phantom_1/p3)
)

