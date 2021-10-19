(script startup sandbox_main
	; Set up the turrets
	(print "hi")
;	(wake volume_test)
	(vehicle_auto_turret turret_north0 tv_turret_north0 159.0 169.0 5.0) 
	(vehicle_auto_turret turret_north1 tv_turret_north1 166.4 176.4 5.0)
	(vehicle_auto_turret turret_side0 tv_turret_side0 171.5 181.5 5.0)
	(vehicle_auto_turret turret_south0 tv_turret_south0 160.2 170.2 5.0)
	(vehicle_auto_turret turret_south1 tv_turret_south1 171.0 181.0 5.0) 
	(vehicle_auto_turret turret_side1 tv_turret_side1 174.0 184.0 5.0)
	
	
)
(script continuous sandbox_main_collection
	(add_recycling_volume garbage 30 30)
	(sleep 900)
)

(script dormant volume_test
	(sleep_until
		(begin
			(cond
				((volume_test_players tv_turret_north0)
					(print "tv_turret_north0")
				)
				((volume_test_players tv_turret_north1)
					(print "tv_turret_north1")
				)
				((volume_test_players tv_turret_side0)
					(print "tv_turret_side0")
				)
				((volume_test_players tv_turret_side1)
					(print "tv_turret_side1")
				)
				((volume_test_players tv_turret_south0)
					(print "tv_turret_south0")
				)
				((volume_test_players tv_turret_south1)
					(print "tv_turret_south1")
				)											
			)
	FALSE)
	)
)