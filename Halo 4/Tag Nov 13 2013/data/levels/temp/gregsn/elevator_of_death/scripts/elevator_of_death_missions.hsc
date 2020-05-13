; 0 = no volume
; 1 = giant volume
; 2 = machine volume
; 3 = vehicle volume
(global short g_player_in_volume 0)
(global boolean g_player_selection_underway TRUE)
(global short g_player_countdown 300)
(global boolean g_phantom_attack FALSE)
(global boolean g_phantom_ready FALSE)
(global boolean g_phantom_attack_done FALSE)

(script startup moving_object_test
	;; wait a bit
	(wake make_be_hold_position)
	(sleep 1)
	(print "blah!")
	(sleep (* 30 5))
	(object_wake_physics phil)
	(wake ready_the_phantom)
)

(script continuous player_choose_platform

	; sleep for one second
	(sleep (* 30 1))
			
	(if g_player_selection_underway 
		( begin

			; if the player is not in a volume, look for us to enter one
			(if (= g_player_in_volume 0) 
				( begin
					; giant
					(if (= (volume_test_players tv_player_on_giant) 1) 
						( begin
							(print "player entered giant volume.. counting down")
							(set g_player_in_volume 1)
							(set g_player_countdown 10)
						)
					)
					; device
					(if (= (volume_test_players tv_player_on_machine) 1) 
						( begin
							(print "player entered machine volume.. counting down")
							(set g_player_in_volume 2)
							(set g_player_countdown 10)
						)
					)
					; vehicle
					(if (= (volume_test_players tv_player_on_vehicle) 1) 
						( begin
							(print "player entered vehicle volume.. counting down")
							(set g_player_in_volume 3)
							(set g_player_countdown 10)
						)
					)
				)
			)

			; if the player is in a volume, check for exit
			(cond
				;((= g_player_in_volume 0) (print "get to a platform")) 
				((= g_player_in_volume 1) 
					(begin
						(if (= (volume_test_players tv_player_on_giant) 0) 
							( begin
								(print "player exited giant volume.. stopping counting down")
								(set g_player_in_volume 0)
							)
						)
					)
				)
				((= g_player_in_volume 2) 
					(begin
						(if (= (volume_test_players tv_player_on_machine) 0) 
							( begin
								(print "player exited machine volume.. stopping counting down")
								(set g_player_in_volume 0)
							)
						)
					)
				)
				((= g_player_in_volume 3) 
					(begin
						(if (= (volume_test_players tv_player_on_vehicle) 0) 
							( begin
								(print "player exited vehicle volume.. stopping counting down")
								(set g_player_in_volume 0)
							)
						)
					)
				)
			)
			
			; if the player is in a volume, update the countdown
			(if (!= g_player_in_volume 0)
				(begin
					(cond
						((= g_player_in_volume 1) (set g_player_countdown (- g_player_countdown 1 )))
						((= g_player_in_volume 2) (set g_player_countdown (- g_player_countdown 1 )))
						((= g_player_in_volume 3) (set g_player_countdown (- g_player_countdown 1 )))
					)
					(cond
						((= g_player_countdown 0) (print "countdown= 0" ))
						((= g_player_countdown 1) (print "countdown= 1" ))
						((= g_player_countdown 2) (print "countdown= 2" ))
						((= g_player_countdown 3) (print "countdown= 3" ))
						((= g_player_countdown 4) (print "countdown= 4" ))
						((= g_player_countdown 5) (print "countdown= 5" ))
						((= g_player_countdown 6) (print "countdown= 6" ))
						((= g_player_countdown 7) (print "countdown= 7" ))
						((= g_player_countdown 8) (print "countdown= 8" ))
						((= g_player_countdown 9) (print "countdown= 9" ))
						((= g_player_countdown 10) (print "countdown= 10" ))
					)
				)
			)
			
			; check for the end of the countdown
			(if (= g_player_countdown 0)
				(begin
					(set g_player_countdown 0)
					(print "countdown complete!")
					
					(cond
						((= g_player_in_volume 1) 
							(begin
								(print "## launch giant ###")
								(wake trigger_giant_ride)
								(set g_player_selection_underway FALSE)
								;(sleep_forever)
							)
						)
						((= g_player_in_volume 2) 
							(begin
								(print "## launch machine ###")
								(wake trigger_machine_ride)
								(set g_player_selection_underway FALSE)
								;(sleep_forever)
							)
						)
						((= g_player_in_volume 3) 
							(begin
								(print "## launch vehicle ###")
								(wake trigger_vehicle_ride)
								(set g_player_selection_underway FALSE)

								;(sleep_forever)
							)
						)
					)
				)
			)	
		)
	)
	
	(if (= g_player_selection_underway 0)
		( begin
			(print "phantom waiting until ready")
			(sleep_until (= g_phantom_ready true))
			(print "phantom waiting to attack")
			(sleep_until (= g_phantom_attack true))

			(print "phantom attacking!")
			(set g_phantom_ready false)
			(set g_phantom_attack_done false)
			(cs_fly_to squads_2/spawn_points_0 TRUE point_set_phantom_0/p4)

			;; drop the squad on the proper reference frame
			(cond
				((= g_player_in_volume 1) 
					(begin
						(print "## attacking giant ###")
						(cs_fly_to squads_2/spawn_points_0 TRUE phantom_deploy_points/giant)
					)
				)
				((= g_player_in_volume 2) 
					(begin
						(print "## attacking device machine ###")
						(cs_fly_to squads_2/spawn_points_0 TRUE phantom_deploy_points/machine)
					)
				)
				((= g_player_in_volume 3) 
					(begin
						(print "## attacking vehicle ###")
						(cs_fly_to squads_2/spawn_points_0 TRUE phantom_deploy_points/vehicle)
					)
				)
			)

			(sleep (* 30 2))
			;;drop off guys 1
			(print "phantom dropping off squad")
			(ai_vehicle_exit squads_3)
			(sleep (* 30 5))
			(set g_phantom_attack_done true)
			
			; retreat
			(print "phantom retreat")
			(cs_fly_to squads_2/spawn_points_0 TRUE point_set_phantom_0/p1)
			(cs_fly_to squads_2/spawn_points_0 TRUE point_set_phantom_0/p3)
			
			; wait for that squad to die
			(sleep_until (<= (ai_living_count squads_3) 1))
			
			; spawn a new squad
			(ai_place squads_3)
			(ai_place_in_vehicle squads_3 squads_2)

			(set g_phantom_ready true)
		)
	)

)

(script dormant make_be_hold_position
	(sleep_until (volume_test_players player_start_trig) 1)
	(print "player is here!")
)

(script dormant trigger_giant_ride
	(play_animation_on_object plate move)
	
	(sleep (* 30 20))
	(pause_animation_on_object plate)

	(set g_phantom_attack true)

		
	(print "trigger_giant_ride complete")
)

(script dormant trigger_machine_ride
	(device_set_position_track plate_machine move 1)

	(print "play to hold point")
	(device_animate_position plate_machine 0.05 60 10 10 TRUE)	
	(sleep (* 30 60))
	(set g_phantom_attack true)
	(sleep (* 30 5))

	; move to the next position and attack again
	(sleep_until (= g_phantom_attack_done true))
	(set g_phantom_attack false)
	(device_animate_position plate_machine 0.1 60 10 10 TRUE)	
	(sleep (* 30 60))
	(set g_phantom_attack true)
	(sleep (* 30 5))

	; move to the next position and attack again
	(sleep_until (= g_phantom_attack_done true))
	(set g_phantom_attack false)
	(device_animate_position plate_machine 0.05 60 10 10 TRUE)	
	(sleep (* 30 60))
	(set g_phantom_attack true)
	(sleep (* 30 5))

	(print "trigger_machine_ride complete")
)

(script dormant trigger_vehicle_ride
	;; place the pelican
	(ai_place pelican_driver)
	(sleep (* 30 2))
	(print "pelican_driver spawning!")
	(cs_fly_to pelican_driver/spawn_points_0 TRUE pelican_points/p0)
	(cs_fly_to pelican_driver/spawn_points_0 TRUE pelican_points/p1)
	(set g_phantom_attack true)
		

)

(script dormant ready_the_phantom
	;; place the phantom
	(ai_place squads_2)
	(ai_set_blind squads_2/spawn_points_0 TRUE)
	(print "phantom spawning!")

	;; place guys and put them in vehicle
	(ai_place squads_3)
	(ai_place_in_vehicle squads_3 squads_2)

	;; fly around tower
	(cs_fly_to squads_2/spawn_points_0 TRUE point_set_phantom_0/p0)
	(cs_fly_to squads_2/spawn_points_0 TRUE point_set_phantom_0/p1)
	(cs_fly_to squads_2/spawn_points_0 TRUE point_set_phantom_0/p3)

	(set g_phantom_ready true)
	(print "phantom ready")
)


