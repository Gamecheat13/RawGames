(script startup lighting_reference_timwil
	(print "hiho!")
	(alert all)

)

(script static void (alert (string biped_name))

	(kill_active_scripts)
	
;CARTER
	(if (= biped_name "carter")
		
		(custom_animation_loop carter "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
		
	)
	
;KAT
	(if (= biped_name "kat")
		
		(custom_animation_loop kat "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
		
	)
	
;JORGE
	(if (= biped_name "jorge")
		
		(custom_animation_loop jorge "objects\characters\spartan_jorge\spartan_jorge" "alert:turret:idle" false)
		
	)
	
;EMILE
	(if (= biped_name "emile")
		
		(begin
			(custom_animation_loop emile "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
			(custom_animation_loop emile_knifeless "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
		)
		
	)
	
;JUN
	(if (= biped_name "jun")
		
		(custom_animation_loop jun "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
		
	)
	
;PLAYER
	(if (= biped_name "player")
		
		(custom_animation_loop player "objects\characters\spartans\spartans" "alert:rifle:idle" false)
		
	)
	
;ALL
	(if (= biped_name "all")
		
		(begin
			(custom_animation_loop carter "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
			(custom_animation_loop kat "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
		(custom_animation_loop jorge "objects\characters\spartan_jorge\spartan_jorge" "alert:turret:idle" false)
			(custom_animation_loop emile "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
			(custom_animation_loop emile_knifeless "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
			(custom_animation_loop jun "objects\characters\spartans_ai\spartans_ai" "alert:rifle:idle" false)
			(custom_animation_loop player "objects\characters\spartans\spartans" "alert:rifle:idle" false)
		)
		
	)
)

(script static void reset_units

	(kill_active_scripts)
	(unit_stop_custom_animation carter)
	(unit_stop_custom_animation kat)
	(unit_stop_custom_animation jorge)
	(unit_stop_custom_animation emile)
	(unit_stop_custom_animation emile_knifeless)
	(unit_stop_custom_animation jun)
	(unit_stop_custom_animation player)

)

(script static void renew_units

	(kill_active_scripts)
	(object_create_anew carter)
	(object_create_anew kat)
	(object_create_anew jorge)
	(object_create_anew emile)
	(object_create_anew emile_knifeless)
	(object_create_anew jun)
	(object_create_anew player)

)