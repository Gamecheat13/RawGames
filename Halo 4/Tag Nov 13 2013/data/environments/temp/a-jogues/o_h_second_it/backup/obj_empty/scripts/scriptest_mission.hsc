(global ai v_sur_phantom sq_phantom)

(script startup su_test_startup
	(print "Scripts Active")
	(sleep_until (volume_test_players tv_elites) 1)
	(print "Spawn Elites")
	(ai_place selites_1)
	
	(sleep_until (volume_test_players tv_phantom) 1)
	(print "Spawn Phantom")
	(ai_place sq_phantom)
  (f_load_phantom v_sur_phantom "dual" sq_ph_flyby_2 sq_ph_flyby_1 none none)
	(cs_fly_to sq_phantom/driver TRUE ps_flight_path/p0)
	(cs_fly_to sq_phantom/driver TRUE ps_flight_path/p1)			
	(f_unload_phantom v_sur_phantom "dual")
	(sleep 150)
	(cs_fly_to sq_phantom/driver TRUE ps_flight_path/p2)
	(cs_fly_to sq_phantom/driver TRUE ps_flight_path/p3)

  (sleep_until (volume_test_players tv_phantom_2) 1)
	(print "Awaken Phantom")
	(cs_fly_to sq_phantom/driver TRUE ps_flight_path/p2)
	(cs_fly_to sq_phantom/driver TRUE ps_flight_path/p4)
)

