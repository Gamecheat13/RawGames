;= EARTHCITY =============================================================================
;*

*;
;- Globals ---------------------------------------------------------------------

; Mission over?
(global boolean g_mission_over false)		; Mission over?

; Enough magic numbers
(global short 30_seconds 900)
(global short 45_seconds 900)
(global short one_minute 1800)
(global short two_minutes 3600)


;= DIALOG ================================================================================

; Encounter 1 - Rooftop defense

(script static void E1_JOHNSON_10
	(print "johnson: Can't stay here, they'll be all over us. This way.")
)

(script static void E1_JOHNSON_20
	(print "johnson: Well, if they didn't know we're here, they do now.")
)

(script static void E1_CORTANA_10
	(print "cortana: A Phantom... they must be checking the crash site first.")
)

(script static void E1_JOHNSON_30
	(print "johnson: Our Phantom is back! Heads down!")
)

(script static void E1_JOHNSON_40
	(print "johnson: There's our evac.")
	(if	(< (objects_distance_to_object (players) (ai_get_object e1_mars_johnson/johnson0)) 8.0)
		(sound_impulse_start "sound\dialog\levels\03_earthcity\mission\l03_0010_jon" (ai_get_object e1_mars_johnson/johnson0) 1.0)
		(sound_impulse_start_effect "sound\dialog\levels\03_earthcity\mission\l03_0010_jon" none 1.0 radio_default)
	)
	(sleep (sound_impulse_time "sound\dialog\levels\03_earthcity\mission\l03_0010_jon"))
)

(script static void E1_MIRANDA_10
	(print "miranda: Hang on, help is inbound")
)


(script static void E1_MIRANDA_20
	(print "miranda: you too, Johnson")
	(sound_impulse_start_effect "sound\dialog\levels\03_earthcity\mission\l03_0020_mir" none 1.0 radio_default)
	(sleep (sound_impulse_time "sound\dialog\levels\03_earthcity\mission\l03_0020_mir"))
)

(script static void E1_MIRANDA_30
	(print "miranda: move the wounded, then go camping")
	(sound_impulse_start_effect "sound\dialog\levels\03_earthcity\mission\l03_0030_mir" none 1.0 radio_default)
	(sleep (sound_impulse_time "sound\dialog\levels\03_earthcity\mission\l03_0030_mir"))
)

(script static void E1_JOHNSON_50
	(print "johnson: Chief, good luck.")
	(if	(< (objects_distance_to_object (players) (ai_get_object e1_mars_johnson/johnson0)) 8.0)
		(sound_impulse_start "sound\dialog\levels\03_earthcity\mission\l03_0040_jon" (ai_get_object e1_mars_johnson/johnson0) 1.0)
		(sound_impulse_start_effect "sound\dialog\levels\03_earthcity\mission\l03_0040_jon" none 1.0 radio_default)
	)
	(sleep (sound_impulse_time "sound\dialog\levels\03_earthcity\mission\l03_0040_jon"))
)


; Encounter 2 - Hunter intro

(script static void E2_CORTANA_10
	(print "cortana: And we get the fun job.")
)

(script static void E2_CORTANA_20
	(print "cortana: Ah, Hunters. I was wondering where they were")
)

(script static void E2_CORTANA_30
	(print "cortana: These Hunters appear to have better armor.")
	(print "cortana: Try to knock some of it off, then aim for the openings.")
)


; Encounter 5 - Neighborhood ambush

(script static void E5_GRUNT0_10
	(print "Grunt 1: Oh, shit!")
)

(script static void E5_GRUNT1_10
	(print "Grunt 2: Shut up! Quiet! Elite said be quiet, you idiot!")
)


; Encounter 6 - Hotel entrance

(script static void E6_MARINE_10
	(print "Marine: Chief! Sir!")
)

(script static void E6_MARINE_20
	(print "Marine: Glad to see you, sir. We saw a Pelican go down on the") 
	(print "Marine: other side of the hotel before the Covenant hit us.")
	(print "Marine: This way!")
)


; Encounter 8 - Hotel ambush

(script static void E7_MARINE_10
	(print "Marine: [harsh whisper] Incoming, don't let them see you.")
)


; Encounter 8 - Hotel exit

(script static void E8_MARINE_10
	(print "Marine: Chief! Glad you could make it, we weren't sure if you")
	(print "Marine: survived the landing.")
)

(script static void E8_CORTANA_10
	(print "Cortana: Lots of troops under that carrier. You're a badass.")
)


; Encounter 9 - Beach

(script static void E9_CORTANA_10
	(print "Cortana: That bridge is the most direct (land) route.")
)


; Encounter 10 - Beach fort

(script static void E10_MIRANDA_10
	(print "Miranda: Heads up, Chief, you have insertion pods coming.")
)


; Encounter 12 - Tunnel, first half

(script static void E12_CORTANA_10
	(print "Cortana: The Covenant are surprised that this is Earth. Like, duh.")
)


;= SINEMATICS ============================================================================

(script static void cinematic_intro
	(if (cinematic_skip_start)
		(begin
			(sleep 15)
			(fade_in 0 0 0 15)
			(sleep 15)

			; Act I
			(camera_set cinematic_test0 0)
			(sleep 60)
			(print "I'm a director, whee!")
			(sleep 90)
			(print "This is a story about this box")
			(sleep 60)
			(print "It is a nice box, but it has problems")
			(sleep 70)
			
			; Act II
			(camera_set cinematic_test1 0)
			(print "It is internally conflicted!")
			(sleep 45)
			(print "Drama!")
			(sleep 105)
			
			; Act III
			(camera_set cinematic_test2 0)
			(print "No Mr. Box!")
			(sleep 50)
			(print "You have so much to live for!")
			(sleep 50)
			(camera_set cinematic_test3 120)
			(print "Nooooooooo.....")
			(sleep 180)
			
			; Fin
			(print "Fin.")

			(fade_out 1 1 1 15)
			(sleep 15)
		)
	)
	(cinematic_skip_stop)
)

(script static void cinematic_bridge
	(if (cinematic_skip_start)
		(begin
			(fade_in 1 1 1 15)
			(sleep 15)

			(ai_enable false)
			(print "bridge cinematic")
			(object_create temp_bridge_johnson)
		
			(camera_set bridge_p0 0)
			(sleep 30)
			(camera_set bridge_p0_0 180)
			(sleep 130)
			(camera_set bridge_p1 0)
			(camera_set bridge_p1_0 90)
			(sleep 80)
			(camera_set bridge_p0 0)
			(camera_set bridge_p0_0 160)
			(sleep 80)
			(camera_set bridge_p2 0)
			(camera_set bridge_p2_0 90)
			(sleep 80)
			
			(object_create temp_bridge_ball)
			(camera_set bridge_p3 0)
			(sleep 80)
			
			(object_destroy temp_bridge_ball)
			(camera_set bridge_p4 0)
			(sleep 30)
			(print "rosebud...")
			(sleep 80)
			(effect_new "scenarios\test\earthcity\temp_junk\rosebud_grenade" temp_bridge_rosebud)
			(camera_set bridge_p5 0)
			(camera_set bridge_p6 150)
			(sleep 200)
			(camera_set bridge_p7 0)
			(sleep 20)
			(unit_kill temp_bridge_johnson)
			(camera_set bridge_p8 30)
			(sleep 70)
			(camera_set bridge_p9 0)
			(sleep 30)
			(object_create temp_bridge_tank)
			(sleep 150)
			(print "fin.")
			(sleep 60)
			
			(object_destroy temp_bridge_tank)
			(object_destroy temp_bridge_johnson)

			(ai_enable true)
			(fade_out 1 1 1 15)
			(sleep 15)
		)
	)
	(cinematic_skip_stop)
)

(script static void cinematic_outro
;	(if (cinematic_skip_start)
		(begin
			(sleep 15)
			(fade_in 0 0 0 15)
			(sleep 15)

			; Mission over!
			(print "mission over!")
			(print "mission over!")
			(print "mission over!")
			(sleep 60)
			(print "mission over!")
			(print "mission over!")
			(print "mission over!")
			(sleep 60)
			(print "mission over!")
			(print "mission over!")
			(print "mission over!")
			(sleep 60)
			
			; Fin
			(print "Fin.")

			(fade_out 1 1 1 15)
			(sleep 15)
		)
;	)
;	(cinematic_skip_stop)
)



;= THE SCARAB ============================================================================

(script static boolean scarab_in_view
	(volume_test_objects tv_scarab_in_view scarab)
)

(script static boolean scarab_in_range
	(volume_test_objects tv_scarab_in_range scarab)
)

(script static boolean scarab_advance_on_balcony
	(volume_test_objects tv_scarab_advance_on_balcony scarab)
)

(script static boolean scarab_climbing_over
	(volume_test_objects tv_scarab_climbing_over scarab)
)

(script static boolean scarab_passed_overhead
	(volume_test_objects tv_scarab_passed_overhead scarab)
)

(script static boolean scarab_beside_building2
	(volume_test_objects tv_scarab_beside_building2 scarab)
)

(script static boolean scarab_nearing_bridge0
	(volume_test_objects tv_scarab_nearing_bridge0 scarab)
)

(script static boolean scarab_below_bridge0
	(volume_test_objects tv_scarab_below_bridge0 scarab)
)

(script static boolean scarab_nearing_bridge1
	(volume_test_objects tv_scarab_nearing_bridge1 scarab)
)

(script static boolean scarab_below_bridge1
	(volume_test_objects tv_scarab_below_bridge1 scarab)
)

(script static boolean scarab_below_bridge2
	(volume_test_objects tv_scarab_below_bridge2 scarab)
)

(script static boolean scarab_below_bridge3
	(volume_test_objects tv_scarab_below_bridge3 scarab)
)

(script static boolean scarab_below_bridge4
	(volume_test_objects tv_scarab_below_bridge4 scarab)
)

(script dormant scarab_entry
	; Place the Scarab and start this ball rolling
	(object_create scarab)
	(device_set_position_immediate scarab 0.03)
	(device_set_position scarab 1.0)
	
	; Sequence of events
	(sleep_until (scarab_in_view) 10)
	(print "tv_scarab_in_view")
	(sleep_until (scarab_in_range) 10)
	(print "tv_scarab_in_range")
	(sleep_until (scarab_advance_on_balcony) 10)
	(print "tv_scarab_advance_on_balcony")
	(sleep_until (scarab_climbing_over) 10)
	(print "tv_scarab_climbing_over")
	(sleep_until (scarab_passed_overhead) 10)
	(print "tv_scarab_passed_overhead")
	(sleep_until (scarab_beside_building2) 10)
	(print "tv_scarab_beside_building2")
	
	; And stop (hack)
	(device_set_position scarab (device_get_position scarab))
)

(script dormant scarab_continue
	; Continue on your merry way
	(device_set_position scarab 1.0)
	
	; Sequence of events
	(sleep_until (scarab_nearing_bridge0) 10)
	(print "tv_scarab_nearing_bridge0")
	(sleep_until (scarab_below_bridge0) 10)
	(print "tv_scarab_below_bridge0")
	(sleep_until (scarab_nearing_bridge1) 10)
	(print "tv_scarab_nearing_bridge1")
	(sleep_until (scarab_below_bridge1) 10)
	(print "tv_scarab_below_bridge1")
	(sleep_until (scarab_below_bridge2) 10)
	(print "tv_scarab_below_bridge2")
	(sleep_until (scarab_below_bridge3) 10)
	(print "tv_scarab_below_bridge2")
	(sleep_until (scarab_below_bridge4) 10)
	(print "tv_scarab_below_bridge2")
)


;= ENCOUNTER 23 ==========================================================================
;*
The player paces the Scarab as it moves down the boulevard, and eventually 
boards it and kills its crew. The End.

Begins when the player passes through the second building
Ends when he kills the pilots, and the level ends

Marines
	e23_mars_inf0 - e22_mars_inf0, Marines who pace the Scarab
		(engage0) - Before the first bridge, as the Scarab is turning
		(engage1) - Between the first and second bridge
		(engage2) - At the corner of the first intersection
		(engage3) - At the opposite corner on the second intersection
		(engage4) - At the end of the ride
	e23_mars_inf1 - ODSTs who pace the Scarab on a separate path
		(engage0) - Waiting on the first bridge
		(engage1) - Waiting on the second bridge
		(engage2) - Going long and waiting on the fourth bridge
		(engage3) - Waiting on the fifth bridge
		(engage4) - End of the road
	e23_mars_inf2 - Marines and ODSTs who are used to reinforce inf0 and inf1
		_0 - Marines near the exit, using a rocket launcher
		_1 - A Marine using an AP turret
		_2 - A Marine sniper and spotter
		_3 - Marine reinforcements
		_4 - ODST reinforcements
	e23_mars_scorpions0 - Scorpions which ambush the Scarab and get blowed up

Covenant
	e23_cov_inf0 - Scarab deck defenders
		_0 - First wave of defenders
		_1 - Second wave
		_2 - Third wave
		_3 - Fourth wave
			(defense0) - Aggressive defense of the deck
			(cower0) - A more passive defense of the deck
	e23_cov_inf1 - Scarab interior defenders
		_0 - Defenders who come onto the deck
			(init) - Engaging the player on the deck
		_1 - The Scarab commander, an Ultra and co. who are the final defense
			(init) - Waiting for the player, in ambush
			(engage0) - Engaging the player all the way out onto the deck
			(retreat0) - Engaging the player only inside the Scarab
	e23_cov_pilots0 - The two Elite pilots of the Scarab

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e23_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e23_scarab
	; End the old script so that it doesn't hang if the player hard charges
	(sleep_forever scarab_entry)
	
	; And continue
	(wake scarab_continue)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e23_cov_pilots0_main
	(ai_place e23_cov_pilots0)
	
	; If the pilots die and the player remains, the mission ends
	(sleep_until 
		(and
			(< (ai_living_count e23_cov_inf0) 2)
			(> (player_count) 0)
		)
		20
	)
	
	; Mission over
;	(set g_mission_over true)
)

(script dormant e23_cov_inf1_main
	(sleep 1)
)

(script static boolean e23_cov_inf0_spawn_safe
	(and
		; Player not on scarab
		
		; Living count less than 2
		(< (ai_living_count e23_cov_inf0) 2)
		
		; Scarab between bridges
		(or
			(volume_test_objects tv_scarab_gap0 scarab)
			(volume_test_objects tv_scarab_gap1 scarab)
			(volume_test_objects tv_scarab_gap2 scarab)
			(volume_test_objects tv_scarab_gap3 scarab)
			(volume_test_objects tv_scarab_gap4 scarab)
			(volume_test_objects tv_scarab_gap5 scarab)
		)
	)
)

(script dormant e23_cov_inf0_main	
	; First wave
	(sleep_until (e23_cov_inf0_spawn_safe))
	(ai_place e23_cov_inf0_0)

	; Second wave
	(sleep_until (e23_cov_inf0_spawn_safe))
	(ai_place e23_cov_inf0_1)

	; Third wave
	(sleep_until (e23_cov_inf0_spawn_safe))
	(ai_place e23_cov_inf0_2)

	; Fourth wave
	(sleep_until (e23_cov_inf0_spawn_safe))
	(ai_place e23_cov_inf0_3)
)

(script dormant e23_mars_inf2_main
	(ai_place e23_mars_inf2_0)
	
	; Spawn the AP gunner
	(sleep_until 
		(or
			(volume_test_objects tv_e23_mars_inf2_1_begin (players)) 
			(scarab_below_bridge0)
		)
		15
	)
	(ai_place e23_mars_inf2_1)
	
	; Migrate the rocketeers
	(ai_migrate e23_mars_inf2_0 e23_mars_inf0)

	; Spawn the sniper
	(sleep_until 
		(or
			(volume_test_objects tv_e23_mars_inf2_2_begin (players)) 
			(scarab_below_bridge1)
		)
		15
	)
	(ai_place e23_mars_inf2_2)
	
	; Spawn the reinforcements
	(sleep_until 
		(or
			(volume_test_objects tv_e23_mars_inf2_reins (players)) 
			(scarab_below_bridge1)
		)
		15
	)
	(ai_place e23_mars_inf2_3 (- 3 (ai_living_count e23_mars_inf0)))
	(ai_place e23_mars_inf2_4 (- 3 (ai_living_count e23_mars_inf1)))
	(ai_migrate e23_mars_inf2_3 e23_mars_inf0)
	(ai_migrate e23_mars_inf2_4 e23_mars_inf1)

	; Migrate the gunner
	(ai_vehicle_exit e23_mars_inf2_1)
	(ai_migrate e23_mars_inf2_1 e23_mars_inf0)

	; Migrate the sniper
	(sleep_until (scarab_below_bridge2) 15)
	(ai_migrate e23_mars_inf2_2 e23_mars_inf0)
)

(script dormant e23_mars_inf1_main
	(ai_place e23_mars_inf1)
)

(script dormant e23_mars_inf0_main
	(ai_migrate e22_mars_inf1 e23_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e23_main
	(sleep_until (volume_test_objects tv_e23_main_begin (players)) 15)
	(set g_e23_started true)
	(print "e23_main")
	(game_save)

	; Wake control scripts
	(wake e23_mars_inf0_main)
	(wake e23_mars_inf1_main)
	(wake e23_mars_inf2_main)
	(wake e23_cov_inf0_main)
	(wake e23_cov_inf1_main)
	(wake e23_cov_pilots0_main)
	(wake e23_scarab)
	
	; Shut down
	
	; Clean up
)

(script static void test_scarab_boarding
	(switch_bsp 3)
	(sleep 1)
	(object_teleport (player0) e23_test)
	(if (not g_e23_started) (wake e23_main))
	
	; Get the scarab set up
	(object_create scarab)
	(device_set_position_immediate scarab 0.3223)
)


;= ENCOUNTER 22 ==========================================================================
;*
Marines hail the player from the building entrance, and then lead him up and 
through to witness the arrival of the Scarab. From there, they lead him to the
last section, where he fights the Scarab.

Begins when the player has destroyed the Cov vehicles, and approached the door
Ends when he exits the second building

Marines
	e22_mars_inf0 - Marines in the first building, including Perez
		(init) - Defending the door
		(advance0) - Defending the lobby
		(advance1) - Firing points in the upper hallway
	e22_mars_inf1 - Marines on the balcony, watching for the Scarab
	e22_mars_inf2 - Flavor Marines on the pedways
		(init) - Watching for the Scarab
		(cover) - Taking Cover in the building
	e22_mars_inf3 - Marines in the second building
	e22_mars_scorpions0 - Ill fated Scorpions, born to die by the Scarab

Covenant
	No Covenant here, just the Scarab

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e22_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e22_mars_dontshootme
	(cs_face_player true)
	(cs_force_combat_status 2)
	(sleep 8)
	(print "hey, stop shooting me!")
	(sleep 30000)
)

(script command_script cs_e22_mars0_crouch
	(cs_queue_command_script ai_current_actor cs_e22_mars_dontshootme)
	(cs_abort_on_damage true)
	(cs_force_combat_status 3)
	(cs_crouch true)
	(sleep 30000)
)

(script command_script cs_e22_mars0_stand
	(cs_queue_command_script ai_current_actor cs_e22_mars_dontshootme)
	(cs_abort_on_damage true)
	(cs_look_player true)
	(cs_force_combat_status 3)
	(sleep 30000)
)

(script command_script cs_e22_mars0_perez
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 3)
	(cs_go_to e22_mars_inf0_perez/p0)
	(cs_face_player true)
	
	; Wait till the player gets close, then move to the next point
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 2.0) 5)
	(print "blah blah blah")
	(sleep 30)
	(ai_set_orders e22_mars_inf0 e22_mars_inf0_advance0)	; TODO: Put this in a better spot
	(sleep 30)
	(cs_face_player false)
	(cs_go_to e22_mars_inf0_perez/p1)
	
	; If the player isn't close, face him and wait
	(if (> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3.0)
		(begin
			(cs_face_player true)
			(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 2.0) 5)	
		)
	)
	
	; Continue to the last firing point
	(cs_face_player false)
	(cs_go_to e22_mars_inf0_perez/p2)
	(cs_look_player true)
)

(script command_script cs_e22_mars_inf1_crouch
	(cs_force_combat_status 3)
	(cs_crouch true)
	(cs_face true e22_mars_inf1/scarab_entry)
	(sleep_until (scarab_climbing_over) 10)
	(print "marines scramble")
	(sleep_until (scarab_passed_overhead) 10)
	(sleep (random_range 20 40))
	(cs_go_to e22_mars_inf1/p0)
)

(script command_script cs_e22_mars_inf1_marine1
	(cs_force_combat_status 3)
	(cs_crouch true)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 11.0) 5)
	(cs_face_player true)
	(cs_crouch false)
	(print "inf1/marine1: Sir, this way!")
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 7.0) 5)
)

(script command_script cs_e22_mars_inf2_crouch
	(cs_force_combat_status 3)
	(cs_crouch true)
	(cs_face true e22_mars_inf1/scarab_entry)
	(sleep_until (scarab_in_range) 10)
	(cs_face false e22_mars_inf1/scarab_entry)
	(cs_shoot true scarab)
	(sleep_until (ai_trigger_test e22_mars_scorpions0_one_left e22_mars_scorpions0))
	(sleep (random_range 20 60))
)

(script command_script cs_e22_mars_scorpion0
	(cs_force_combat_status 3)
	(cs_face true e22_mars_inf1/scarab_entry) ; TODO: Change this to face scarab
	(cs_go_to e22_mars_scorpions0/p0)
	(sleep_until (scarab_in_range) 10)
	(cs_face false e22_mars_inf1/scarab_entry)
	(cs_shoot true scarab)
	(sleep 30000)
)

(script command_script cs_e22_mars_scorpion1
	(cs_force_combat_status 3)
	(cs_face true e22_mars_inf1/scarab_entry) ; TODO: Change this to face scarab
	(sleep_until (scarab_in_range) 10)
	(cs_face false e22_mars_inf1/scarab_entry)
	(cs_shoot true scarab)
	(sleep 30000)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e22_nasty_player_synch
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 5)
	
	; Teleport up the player
	(volume_teleport_players_not_inside tv_e22_no_teleport e22_nasty_player_synch)
)

(script dormant e22_scarab_entry
	; Wait till the player is inside to arm the trigger, then trigger
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 10)
	(sleep_until (volume_test_objects tv_e22_scarab_entry_begin (players)) 10)
	
	; Get the ball rolling
	(wake scarab_entry)
)

;- Squad Controls --------------------------------------------------------------

(script dormant e22_mars_inf0_main
	(sleep_until (volume_test_objects tv_e22_main_begin (players)) 15)
	(ai_place e22_mars_inf0)
	
	; Migrate other actors, have them exit any vehicles
	(ai_migrate e21_mars_warthog0 e22_mars_inf0)
	(ai_vehicle_exit e22_mars_inf0)
	
	; Unlock the door
	; TODO: Make this real
	(object_destroy e22_door0_dummy)
	
	; Apply a few command scripts (just a few)
	(cs_run_command_script e22_mars_inf0/perez cs_e22_mars0_perez)
	(cs_run_command_script e22_mars_inf0/guard0 cs_e22_mars0_crouch)
	(cs_run_command_script e22_mars_inf0/guard1 cs_e22_mars0_stand)
	(cs_run_command_script e22_mars_inf0/guard2 cs_e22_mars0_stand)
	(cs_run_command_script e22_mars_inf0/medic0 cs_e22_mars0_stand)
	(cs_run_command_script e22_mars_inf0/medic1 cs_e22_mars0_stand)
	(cs_run_command_script e22_mars_inf0/wounded0 cs_e22_mars0_stand)
	(cs_run_command_script e22_mars_inf0/wounded1 cs_e22_mars0_stand)
	
	; Wait until Perez or the player is up in the stairwell
	(sleep_until 
		(or
			(volume_test_objects tv_e22_stairwell (players)) 
			(volume_test_objects tv_e22_stairwell (ai_get_object e22_mars_inf0/perez)) 
		)
		15
	)
	(ai_set_orders e22_mars_inf0 e22_mars_inf0_advance1)
	
	; Wait until the player has moved on, and then is clear of the stairwell Marines
	(sleep_until (volume_test_objects tv_e22_mars_inf3_begin (players)) 10)
	(sleep_until (not (volume_test_objects tv_e22_mars_inf0_visible (players))))
	
	; Delete inf0, aside from Perez
	(ai_erase e22_mars_inf0/guard0)
	(ai_erase e22_mars_inf0/guard1)
	(ai_erase e22_mars_inf0/guard2)
	(ai_erase e22_mars_inf0/medic0)
	(ai_erase e22_mars_inf0/medic1)
	(ai_erase e22_mars_inf0/wounded0)
	(ai_erase e22_mars_inf0/wounded1)
)

(script dormant e22_mars_inf1_main
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 10)
	(ai_place e22_mars_inf1)
	
	; Command scripts
	(cs_run_command_script e22_mars_inf1/lieutenant cs_e22_mars_inf1_crouch)
	(cs_run_command_script e22_mars_inf1/marine0 cs_e22_mars_inf1_crouch)
	(cs_run_command_script e22_mars_inf1/marine1 cs_e22_mars_inf1_crouch)
	
	; Wait until the Scarab is about to climb up
	(sleep_until (scarab_climbing_over) 10)
	
	; Make the Marines respond
	(print "omg teh scarab!!11")
	
	; Wait until it has finished climbing overhead
	(sleep_until (scarab_passed_overhead) 10)
	
	; Once the Scarab has passed overhead, continue
	(cs_run_command_script e22_mars_inf1/marine1 cs_e22_mars_inf1_marine1)
	
	; TODO: Remove that door
	(object_destroy e22_door1_dummy)
)

(script dormant e22_mars_inf2_main
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 10)
	(ai_place e22_mars_inf2)
	
	; Command scripts
	(cs_run_command_script e22_mars_inf2 cs_e22_mars_inf2_crouch)

	; Wait until the player has moved on, and then is clear
	(sleep 900)
	(sleep_until (not (volume_test_objects tv_e22_mars_inf2_visible (players))))
	(ai_erase e22_mars_inf2)
)

(script dormant e22_mars_inf3_main
	(sleep_until (volume_test_objects tv_e22_mars_inf3_begin (players)) 10)
)

(script dormant e22_mars_scorpions0_main
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 10)
	(ai_place e22_mars_scorpions0)
	
	; Command scripts
	(cs_run_command_script e22_mars_scorpions0/scorpion0 cs_e22_mars_scorpion0)
	(cs_run_command_script e22_mars_scorpions0/scorpion1 cs_e22_mars_scorpion1)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e22_main
	(set g_e22_started true)
	(print "e22_main")
	(game_save)
	(garbage_collect_now)

	; Wake subsequent scripts
	(wake e23_main)

	; Wake control scripts
	(wake e22_scarab_entry)
	(wake e22_nasty_player_synch)
	(wake e22_mars_inf0_main)
	(wake e22_mars_inf1_main)
	(wake e22_mars_inf2_main)
	(wake e22_mars_inf3_main)
	(wake e22_mars_scorpions0_main)
	
	; Shut down
	(sleep_until g_e23_started)
	(sleep_forever e22_scarab_entry)
	(sleep_forever e22_nasty_player_synch)
	(sleep_forever e22_mars_inf0_main)
	(sleep_forever e22_mars_inf1_main)
	(sleep_forever e22_mars_inf2_main)
	(sleep_forever e22_mars_inf3_main)
	(sleep_forever e22_mars_scorpions0_main)
)

(script static void test_scarab_intro
	(switch_bsp 3)
	(sleep 1)
	(object_teleport (player0) e22_test)
	(object_destroy scarab)
	(if (not g_e22_started) (wake e22_main))
)


;= ENCOUNTER 21 ==========================================================================
;*
As the player rounds the corner, he sees a Covenant force bombarding a building.
He engages this force, and in doing so rescues the Marines in that building,
who then lead him inside.

Begins when the player approaches the last corner.
Ends when the Covenant are dead and he enters the building.

Marines
	e21_mars_warthog0 - e20_mars_warthog0
		(phantoms) - Engaging the Phantoms if they're alive
		(ghosts) - Engaging the Ghosts if they're alive but Phantoms aren't
		(wraiths) - Engaging the Wraiths if everything else is dead
	e21_mars_inf0 - Respawning Marines on the cover loop
		(init) - Engaging the Creep, waiting for reins
	e21_mars_inf1 - Marines inside the building
		(init) - Cowering near the building entrance
		(engage0) - Stepping out of cover

Covenant
	e21_cov_inf0 - Infantry who emerge onto the pedways
		(init) - Bold positions far out on the pedways, near stairs
		(retreat) - Positions closer to the tunnel
	e21_cov_wraith0 - Wraiths shelling the building
		(retreat) - When one Wraith dies, move back
		_0 - Wraith on the right side
			(init) - Halfway up the road
		_1 - Wraith on the left side, being dropped off by e21_cov_phantom0
			(init) - Closer to the entrance road
			(withdraw) - When damaged, move back to the building
	e21_cov_ghosts0 - Ghosts covering the Wraiths
		_0 - Ghosts initially present
		_1 - Ghosts which arrive with e21_cov_phantom1
			(guard0) - Guarding near the Wraiths
			(guard1) - Guarding near the building if Wraiths die
			(engage) - Engage the player if he's in the boulevard
		_2 - Ghosts behind the building
			(init) - Helping e12_cov_creep0 until they see the player
	e21_cov_phantom0 - Phantom which drops off e21_cov_wraith0_1
		(init) - Fighting with the player near the boulevard entrance
	e21_cov_phantom1 - Phantom which drops off e21_cov_ghosts0_1
		(init) - Fighting with the player in the boulevard
	e21_cov_creep0 - Creep crew which is skirmishing with e21_mars_inf0
		(init) - Skirmishing with e21_mars_inf0

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e21_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e21_cov_wraiths0_bombard
	(cs_abort_on_damage true)
	(sleep_until (<= (ai_living_count e21_cov_wraiths0) 1))
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e21_cov_creep0_main
	; Sleep until the player is nearby
	(sleep_until 
		(or
			(volume_test_objects tv_e21_cov_creep0_main (players)) 
			(volume_test_objects tv_e21_cov_inf0_unsafe (players)) 		
		)	
	15)
	(ai_place e21_cov_creep0)
)

(script dormant e21_cov_phantom1_main
	; Sleep until both Wraiths are dead, or the infantry is dead, or a timeout
	(sleep_until 
		(or
			(<= (ai_living_count e21_cov_wraiths0) 0) 
			(<= (ai_living_count e21_cov_inf0) 0) 
		)
		30
		2700
	)

	; Place the second Phantom
	(ai_place e21_cov_phantom1)
	
	; When both Wraiths are dead, leave
	(sleep_until (<= (ai_living_count e21_cov_wraiths0) 0))
	(sleep 300)
	(ai_erase e21_cov_phantom1)
	(print "second phantom retreats")
	
	; Wait until the ghosts are dead
	(sleep_until 
		(and
			(< (ai_living_count e21_cov_ghosts0) 2)
			(<= (ai_fighting_count e21_cov_ghosts0) 0)
		)
		15
		two_minutes
	)

	; Wake the next encounter
	(wake e22_main)
)

(script dormant e21_cov_inf0_main
	; Sleep until it's safe to spawn, then spawn
	(sleep_until (not (volume_test_objects tv_e21_cov_inf0_unsafe (players))) 15)
	(ai_place e21_cov_inf0)

	; Wait until the infantry is dead, or a timeout
	(sleep_until 
		(and
			(<= (ai_living_count e21_cov_inf0) 5) 
			(<= (ai_fighting_count e21_cov_inf0) 0) 
		)
		30
		2700
	)
)

(script dormant e21_cov_phantom0_main
	(ai_place e21_cov_phantom0)
	
	; Sleep until the Phantom is mostly dead, then tell it to retreat
	(sleep_until 
		(or
			(< (object_get_health (ai_vehicle_get e21_cov_phantom0/phantom0)) 0.25) 
			(<= (ai_living_count e21_cov_wraiths0) 0)
		)
		15
	)
	(sleep 300)
	; TODO: Phantom retreats
	(ai_erase e21_cov_phantom0)
	(print "first phantom retreats")
	
	; Wait until it is gone and the Ghosts are dead
	(sleep_until 
		(and
			(<= (ai_living_count e21_cov_phantom0) 0)
			(<= (ai_fighting_count e21_cov_ghosts0) 0)
		)
		15
	)
	
	; Bring out the infantry
	(wake e21_cov_inf0_main)
	
	; Send in the next Phantom
	(wake e21_cov_phantom1_main)
)

(script dormant e21_cov_ghosts0_main
	(ai_place e21_cov_ghosts0_0)
	
	; Sleep until the player is nearby
	(sleep_until (volume_test_objects tv_e21_cov_inf0_unsafe (players)) 15)
	
	; Then place the next set of Ghosts, and promptly tell them to exit their vehicles
	(ai_place e21_cov_ghosts0_2 (- 3 (ai_living_count e21_cov_ghosts0)))
	(sleep 30)
	(ai_vehicle_exit e21_cov_ghosts0_2)
	
	; Wait until the Ghosts are depleted
	(sleep_until 
		(and
			(< (ai_living_count e21_cov_ghosts0) 2)
			(<= (ai_fighting_count e21_cov_ghosts0) 0)
		)
		15
		two_minutes
	)
	
	; If Phantom 1 hasn't yet been placed...
	(if (<= (ai_spawn_count e21_cov_phantom1) 0)
		; Sleep until it arrives, then place two more Ghosts
		(begin
			(sleep_until (> (ai_spawn_count e21_cov_phantom1) 0))
			(ai_place e21_cov_ghosts0_1)
			; TODO: Load them into the Phantom
		)
	)
)

(script dormant e21_cov_wraiths0_main
	(ai_place e21_cov_wraiths0)
	(cs_run_command_script e21_cov_wraiths0 cs_e21_cov_wraiths0_bombard)
)

(script dormant e21_mars_warthog0_main
	(ai_migrate e20_mars_warthog0 e21_mars_warthog0)
	(ai_migrate e20_mars_inf0 e21_mars_warthog0)
)

(script dormant e21_mars_inf1_main
	(sleep_until (volume_test_objects tv_e21_mars_inf1_begin (players)) 15)
	(ai_place e21_mars_inf1)
)

(script dormant e21_mars_inf0_main
	; Infinite respawner! Well, not really...
	(sleep_until 
		(begin
			; Is our count less than 2, and the player not nearby?
			(if
				(and
					(< (ai_living_count e21_mars_inf0) 2)
					(< (ai_spawn_count e21_mars_inf0) 10)
					(not (volume_test_objects tv_e21_mars_inf0_unsafe (players)))
				)
				
				; Then place a Marine
				(ai_place e21_mars_inf0 1)
			)
			
			; End when e22 begins, or we exceed some limit
			(or
				(< (ai_spawn_count e21_mars_inf0) 10)
				g_e22_started
			)
		)
	)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e21_main
	(sleep_until (volume_test_objects tv_e21_main_begin (players)) 15)
	(set g_e21_started true)
	(print "e21_main")
	(game_save)
	(garbage_collect_now)

	; Wake subsequent scripts
	; Wakes e22_main via e21_cov_phantom1_main

	; Wake control scripts
	(wake e21_cov_creep0_main)
	(wake e21_cov_phantom0_main)
	(wake e21_cov_ghosts0_main)
	(wake e21_cov_wraiths0_main)
	(wake e21_mars_warthog0_main)
	(wake e21_mars_inf0_main)
	(wake e21_mars_inf1_main)
	
	; Shut down
	(sleep_until g_e22_started)
	(sleep_forever e21_cov_creep0_main)
	(sleep_forever e21_cov_phantom0_main)
	(sleep_forever e21_cov_ghosts0_main)
	(sleep_forever e21_cov_wraiths0_main)
	(sleep_forever e21_mars_warthog0_main)
	(sleep_forever e21_mars_inf0_main)
	(sleep_forever e21_mars_inf1_main)
	
	; Clean up
	(sleep_until g_e23_started)
	(ai_erase e21_mars)
	(ai_erase e21_cov)
)

(script static void test_hospital_seige
	(switch_bsp 3)
	(sleep 1)
	(object_teleport (player0) e21_test)
	(object_destroy scarab)
	(ai_place e21_mars_warthog0)
	(if (not g_e21_started) (wake e21_main))
)


;= ENCOUNTER 20 ==========================================================================
;*
A few Marines taking out a Ghost in the street outside the park.

Begins when the player exits the park
Ends shortly thereafter

Marines
	e20_mars_inf0 - Two Marines near an overturned Warthog, one with rockets
		(init) - Fending off the Ghosts from the curb
		(advance0) - Moving out into the street near their Warthog
	e20_mars_warthog0 - e19_mars_warthog0
		(init) - Helping take out the Ghosts

Covenant
	e20_cov_ghosts0 - Two Ghosts which the Marines take out
		(init) - Engaging the Marines

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e20_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e20_cov_ghosts0_main
	(ai_place e20_cov_ghosts0)
	(ai_kill e20_cov_ghosts0/ghost1)
)

(script dormant e20_mars_inf0_main
	(ai_place e20_mars_inf0)
	
	; Mark the Warthog as out of bounds
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e20_mars_inf0/warthog0) true)
	
	; Once the Ghost is dead, then you can have it back
	(ai_trigger_test e20_cov_ghosts0_dead e20_cov_ghosts0)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e20_mars_inf0/warthog0) false)
)

(script dormant e20_mars_warthog0_main
	; Migrate over previous squads
	(ai_migrate e19_mars_warthog0 e20_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e20_main
	(sleep_until (volume_test_objects tv_e20_main_begin (players)) 15)
	(set g_e20_started true)
	(print "e20_main")
	(game_save)
	(garbage_collect_now)

	; Wake subsequent scripts

	; Wake control scripts
	(wake e20_mars_warthog0_main)
	(wake e20_mars_inf0_main)
	(wake e20_cov_ghosts0_main)
	
	; Shut down
	
	; Clean up
)

(script static void test_road_skirmishes
	(switch_bsp 3)
	(sleep 1)
	(object_teleport (player0) e20_test)
	(object_destroy scarab)
	(ai_place e20_mars_warthog0)
	(wake e20_main)
	(wake e21_main)
)


;= ENCOUNTER 19 ==========================================================================
;*
As the player nears the Scarab, it departs, leaving the player behind with a
pair of Wraiths and a few waves of Ghosts.

Begins shortly after the player switches into the park BSP.
Ends when the player leaves the park.

Marines
	e19_mars_warthog0 - e18_mars_inf0 + e18_mars_warthog0
		(wraiths) - Engaging both Wraiths
		(wraith0) - Engaging only Wraith 0 after Wraith 1 is dead
		(wraith1) - Engaging only Wraith 1 after Wraith 0 is dead
		(ghosts) - Engaging any Ghosts

Covenant
	e19_cov_wraiths0 - Two Wraiths at the end of the park
		_0 - Wraith up on the platform
			(init) - Engaging the player
		_1 - Wraith down by the exit
			(init) - Engaging the player
	e19_cov_ghosts0 - Ghosts which sally forth to engage the player
		_0 - Ghosts from the exit
		_1 - Ghosts which arrive via Phantom
			(init) - Engaging anywhere in the park


*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e19_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e19_cov_ghosts0_main
	(sleep_until (volume_test_objects tv_e19_player_advanced (players)) 15)
	(ai_place e19_cov_ghosts0_0)
	
	; Wait to respawn
	(sleep_until (<= (ai_living_count e19_cov_ghosts0) 0))
	(sleep 300)
	
	; TODO: Wait until the spawn area is clear
	
	; TODO: Phantom arrival sequence
	(print "A phantom drops off the next two Ghosts")
	(ai_place e19_cov_ghosts0_1)
)

(script dormant e19_cov_wraiths0_main
	(ai_place e19_cov_wraiths0)
	
	; TODO: Make them shooting at the same things as the Scarab
	(ai_set_blind e19_cov_wraiths0 true)
	(ai_set_deaf e19_cov_wraiths0 true)
	
	(sleep_until (volume_test_objects tv_e19_scarab_withdraws (players)) 15)
	(ai_set_blind e19_cov_wraiths0 false)
	(ai_set_deaf e19_cov_wraiths0 false)
)

(script dormant e19_mars_inf0_main
	; Wait until the previous Covenant are dead or the player has advanced
	(sleep_until 
		(or 
			(<= (ai_living_count e18_cov) 0)
			(volume_test_objects tv_e19_player_advanced (players)) 
		)
		15
	)

	; Migrate squads into this one
	(ai_migrate e18_mars_inf0 e19_mars_warthog0)
	(ai_migrate e18_mars_warthog0 e19_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e19_main
	(sleep_until (volume_test_objects tv_e19_main_begin (players)) 15)
	(set g_e19_started true)
	(print "e19_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e19_mars_inf0_main)
	(wake e19_cov_wraiths0_main)
	(wake e19_cov_ghosts0_main)
	
	; Shut down
	(sleep_until g_e20_started)
	(sleep_forever e19_mars_inf0_main)
	(sleep_forever e19_cov_wraiths0_main)
	(sleep_forever e19_cov_ghosts0_main)
	
	; Clean up
	(sleep_until g_e21_started)
	(ai_erase e19_mars)
	(ai_erase e19_cov)
)


;= ENCOUNTER 18 ==========================================================================
;*
As the player enters the park, he encounters a small Covenant infantry force
attacking a boxed in Warthog. The Scarab enters the park in a cinematic moment,
but has no impact on the encounter.

Begins when the player switches into the park BSP.
Ends when the Covenant turrets are dead.

Marines
	e18_mars_inf0 - e17_mars_inf0
		(init) - Holding positions until e18_cov_inf0 are alerted or dead
		(advance0) - Engaging around the outer ring
		(advance1) - Engaging the mid harp platform
		(advance2) - Engaging the Covenant on the center position
	e18_mars_warthog0 - Gauss rifle warthog crew
		(init) - Engaging Covenant in the upper park

Covenant
	e18_cov_inf0 - Covenant manning turrets on the outer ring
		(init) - Standing guard, firing on visible Marines
	e18_cov_inf1 - Covenant on the center structures
		_0 - Covenant on the center platform
			(init) - Fending off the Marines
		_1 - Covenant on the harp halfway platform
			(init) - Fending off the Marines, retreating when weakened

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e18_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e18_mars_warthog0_orbit
	(cs_vehicle_speed 2.0)
	(sleep_until
		(begin
			(cs_go_by e18_mars_warthog0_orbit/p0 e18_mars_warthog0_orbit/p1)
			(cs_go_by e18_mars_warthog0_orbit/p1 e18_mars_warthog0_orbit/p2)
			(cs_go_by e18_mars_warthog0_orbit/p2 e18_mars_warthog0_orbit/p3)
			(cs_go_by e18_mars_warthog0_orbit/p3 e18_mars_warthog0_orbit/p4)
			(cs_go_by e18_mars_warthog0_orbit/p4 e18_mars_warthog0_orbit/p5)
			(cs_go_by e18_mars_warthog0_orbit/p5 e18_mars_warthog0_orbit/p6)
			(cs_go_by e18_mars_warthog0_orbit/p6 e18_mars_warthog0_orbit/p0)
			
			; Loop forever
			false
		)
		15
	)
)

(script command_script cs_e18_mars_warthog0_wait
	(sleep_until (vehicle_test_seat_list (ai_vehicle_get ai_current_actor) "warthog_g" (players)) 15)
;*	(sleep_until 
		(or
			(unit_in_vehicle (player0))
			(unit_in_vehicle (player1))
		)
	)
*;
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e18_cov_inf1_main
	(ai_place e18_cov_inf1)
)

(script dormant e18_cov_inf0_main
	(ai_place e18_cov_inf0)
)

(script dormant e18_mars_warthog0_main
	(ai_place e18_mars_warthog0)
	(cs_run_command_script e18_mars_warthog0/warthog0 cs_e18_mars_warthog0_orbit)
	
	; Wait until the player is very close, or the Covenant are dead and the 
	; player is pretty close
	(sleep_until
		(or
			; The player is very close
			(<= (objects_distance_to_object (players) (ai_vehicle_get e18_mars_warthog0/warthog0)) 4.0)
			
			; The player is moderately close at the Covenant are dead
			(and
				(<= (objects_distance_to_object (players) (ai_vehicle_get e18_mars_warthog0/warthog0)) 8.0)
				(<= (ai_living_count e18_cov) 1)
			)
		)
		15
	)
	
	; End the orbit, do the dialog
	(cs_run_command_script e18_mars_warthog0/warthog0 cs_e18_mars_warthog0_wait)
)

(script dormant e18_mars_inf0_main
	; Migrate squads into this one
	(ai_migrate e17_mars_inf0 e18_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e18_main
	(sleep_until (volume_test_objects tv_e18_main_begin (players)) 15)
	(set g_e18_started true)
	(print "e18_main")
	(game_save)
	(garbage_collect_now)
	
	; TODO: Remove this
	(object_destroy scarab)

	; Wake subsequent scripts
	(wake e19_main)
	(wake e20_main)
	(wake e21_main)

	; Wake control scripts
	(wake e18_mars_inf0_main)
	(wake e18_mars_warthog0_main)
	(wake e18_cov_inf0_main)
	(wake e18_cov_inf1_main)
	
	; Shut down
	(sleep_until g_e20_started)
	(sleep_forever e18_mars_inf0_main)
	(sleep_forever e18_mars_warthog0_main)
	(sleep_forever e18_cov_inf0_main)
	(sleep_forever e18_cov_inf1_main)
	
	; Clean up
	(sleep_until g_e21_started)
	(ai_erase e18_mars)
	(ai_erase e18_cov)
)

(script static void test_park
	(switch_bsp 3)
	(object_teleport (player0) e18_test)
	(ai_place e18_mars_inf0)
	(if (not g_e18_started) (wake e18_main))
)


;= ENCOUNTER 17 ==========================================================================
;*
At the end of the tunnel, the player encounters a flooded section, and must
fight through on foot. As a consolation, we give him a new weapon, the shotgun.

Begins when the player re-enters the tunnels.
Ends when the player moves into the BSP swap section.

Marines
	e17_mars_inf0 - Marines in a Warthog, + e16_mars_inf0
		(init) - Killing defenders near first wall
		(wait) - Standing on guard near the wall
		(advance0) - Advancing up onto the first wall
		(advance1) - Once the turret is dead, bolder positions
		(follow) - Once the player crests the second wall, follow him

Covenant
	e17_cov_inf0 - Elites who plunge into the water after you
		_0 - Elite up on the first wall
			(init) - Lurking on the front wall
		_1 - Elites initially on the back wall
		_2 - Reinforcements
			(init) - Lurking on the walls until alerted
			(engage0) - Engaging the player in the water near the front wall
			(engage1) - Retreating and engaging near the rear wall
	e17_cov_inf1 - Jackals on the walls
		_0 - Jackals on the first wall
			(init) - Defending on the wall
		_1 - Jackals and an AP turret on the back wall
			(init) - Defending on the wall
	e17_cov_inf2 - And Buggers!
		(init) - Idling near the back wall until alerted
	e17_cov_inf3 - GRUNTS! WILL THE MADNESS NEVER STOP?!
		(init) - Attempting (in vain) to defend the rear wall

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e17_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e17_mars_inf0_drive
	(cs_enable_pathfinding_failsafe true)
	(cs_go_by e17_mars_inf0_entry/p0 e17_mars_inf0_entry/p1 0.35)
	(cs_go_to e17_mars_inf0_entry/p1 0)
	(sleep 20)
	(ai_vehicle_exit e17_mars_inf0/warthog0)
	(ai_vehicle_exit e17_mars_inf0/passenger0)
)

(script command_script cs_e17_mars_inf0_shotgunner
	(if (> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3.0) (cs_go_to e17_mars_inf0_entry/shotgun_end))
	(cs_face_player true)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3.0) 5)
	(print "here, I'll die so you can take my gun!")
	(sleep 30)
	(print "Someday we'll be able to just swap aiiiiieeeee....")
	(sleep 30)
	(ai_kill ai_current_actor)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e17_cov_inf3_main
	(sleep_until (volume_test_objects tv_e17_on_back_wall (players)) 15)
	(ai_place e17_cov_inf3)
)

(script dormant e17_cov_inf2_main
	(ai_place e17_cov_inf2)
)

(script dormant e17_cov_inf1_main
	(ai_place e17_cov_inf1)
)

(script dormant e17_cov_inf0_main
	(ai_place e17_cov_inf0_0)
	(ai_place e17_cov_inf0_1)
	
	; Wait until the initial group has been weakened, or the player has pushed
	(sleep_until 
		(or
			(ai_trigger_test e17_cov_inf0_weakened e17_cov_inf0_0)
			(volume_test_objects tv_e17_near_back_wall (players)) 
		)	
		15
	)

	; Place reinforcements
	(ai_place e17_cov_inf0_2)
)

(script dormant e17_mars_inf0_main
	; Place the squad and send them in
	(ai_place e17_mars_inf0)
	(ai_vehicle_reserve (ai_vehicle_get e17_mars_inf0/warthog0) true)
	(cs_run_command_script e17_mars_inf0/warthog0 cs_e17_mars_inf0_drive)

	; Wait for the Covenant on the first wall to be dead, then run shotgunner
	(sleep_until (<= (ai_living_count e17_cov_inf1_0) 0) 15)
	(cs_run_command_script e17_mars_inf0/passenger0 cs_e17_mars_inf0_shotgunner)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e17_main
	(sleep_until (volume_test_objects tv_e17_main_begin (players)) 15)
	(set g_e17_started true)
	(print "e17_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e17_mars_inf0_main)
	(wake e17_cov_inf0_main)
	(wake e17_cov_inf1_main)
	(wake e17_cov_inf2_main)
	(wake e17_cov_inf3_main)
	
	; Shut down
	(sleep_until g_e18_started)
	(sleep_forever e17_mars_inf0_main)
	(sleep_forever e17_cov_inf0_main)
	(sleep_forever e17_cov_inf1_main)
	(sleep_forever e17_cov_inf2_main)
	(sleep_forever e17_cov_inf3_main)
	
	; Clean up
	(sleep_until g_e20_started)
	(ai_erase e17_mars)
	(ai_erase e17_cov)
)

(script static void test_flooded_tunnel
	(switch_bsp 2)
	(sleep 1)
	(object_teleport (player0) e17_test)
	(object_create e17_test_tank)
	(if (not g_e17_started) (wake e17_main))

	; Get the other scripts running
	(if (not g_e18_started) (wake e18_main))
)



;= ENCOUNTER 16 ==========================================================================
;*
As the player travels down the first tunnel section he encounters and blows
past several small throwaway encounters.

Begins when the player enters the tunnels.
Ends when the moves into the next tunnel section.

Marines
	e16_mars_inf0 - e15_mars_inf0
		(init) - Observing from near the crest of the bridge
		(advance0) - Advancing up the bridge once it's cleared
		(advance1) - Advancing up to the toll booths once they're secured
		(follow) - Following the player once the Covenant are dead

Covenant
	e16_cov_wraiths0 - Wraiths advancing up the bridge to engage the player
		_0 - Wraiths (and Phantoms) being dropped off by aforementioned Phantoms
		_1 - Reinforcements from the tunnel
			(init) - Engaging the player
	e16_cov_wraiths1 - Wraiths who emerge to defend the toll booths
		(init) - Engaging the player
	e16_cov_ghosts0 - Ghosts advancing up to engage the player
		_0 - Four initially placed Ghosts arriving in two waves
		_1 - Reinforcements from the tunnel
			(init) - Engaging the player
			(retreat) - Retreating if e16_cov_wraiths0_1 is dead
	e16_cov_ghosts1 - Ghosts defending the toll booths
		(engage) - Sallying forth to engage
		(retreat) - Behaving more defensively if when battered
	e16_cov_ubers - Uberchassis! Driven by Grunts, with Buggers riding atop them
		(init) - Charging out to engage the player
	e16_cov_banshees0 - Banshees harrassing the player overhead
		_0 - Banshees who appear after the Phantoms depart
		_1 - Reinforcements from behind
			(init) - Harrassing the player from above

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e16_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e16_cov_banshees0_main
	(ai_place e16_cov_banshees0_0)
	(sleep 15)
	(ai_magically_see_object e16_cov_banshees0_0 (player0))
	
	; Wait until the first two are dead, then spawn two more
	(sleep_until (<= (ai_living_count e16_cov_banshees0_0) 0))
	(sleep 600)
	(ai_place e16_cov_banshees0_1)
)

(script dormant e16_cov_ubers0_main
	(sleep 1)
)

(script dormant e16_cov_wraiths1_main
	(sleep_until (volume_test_objects tv_e16_bridge_end (players)) 15)
	(ai_place e16_cov_wraiths1)
)

(script dormant e16_cov_ghosts1_main
	(sleep_until (volume_test_objects tv_e16_bridge_end (players)) 15)
	(ai_place e16_cov_ghosts1)
	
	; Sleep until diminished, then an additional 30 seconds or until the player
	; hard charges, then respawn
	(sleep_until (<= (ai_living_count e16_cov_ghosts0_0) 1))
	(sleep_until (volume_test_objects tv_e16_tunnel (players)) 15 900)
	(ai_place e16_cov_ghosts1)
)

(script dormant e16_cov_ghosts0_main
	(ai_place e16_cov_ghosts0_0)
	
	; Sleep until they're diminished
	(sleep_until 
		(or
			(volume_test_objects tv_e16_toll_plaza (players))
			(<= (ai_living_count e16_cov_ghosts0_0) 1)
		)
	)
	(ai_place e16_cov_ghosts0_1 (- 2 (ai_living_count e16_cov_ghosts0_0)))
)

(script dormant e16_cov_wraiths0_main
	; TODO: Make these Phantoms real
	(object_create e16_phantom0_dummy)
	(object_create e16_phantom1_dummy)

	; Place the first two Wraiths
	(ai_place e16_cov_wraiths0_0)
	
	; Make the Phantoms depart
	; TODO: Make this real
	(sleep 150)
	(print "phantoms fly away")
	(object_destroy e16_phantom0_dummy)
	(object_destroy e16_phantom1_dummy)
	
	; Sleep until one of the Wraiths is dead, then place the reinforcement
	(sleep_until 
		(or
			(volume_test_objects tv_e16_toll_plaza (players))
			(<= (ai_living_count e16_cov_wraiths0_0) 1)
		)
	)
	(ai_place e16_cov_wraiths0_1 (- 2 (ai_living_count e16_cov_wraiths0_0)))
)

(script dormant e16_mars_inf0_main
	(ai_migrate e15_mars_inf0 e16_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e16_main
	(sleep_until (volume_test_objects tv_e16_main_begin (players)) 15)
	(set g_e16_started true)
	(print "e16_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e16_mars_inf0_main)
	(wake e16_cov_wraiths0_main)
	(wake e16_cov_ghosts0_main)
	(wake e16_cov_wraiths1_main)
	(wake e16_cov_ghosts1_main)
	(wake e16_cov_ubers0_main)
	(wake e16_cov_banshees0_main)
	
	; Shut down
	(sleep_until g_e17_started)
	(sleep_forever e16_mars_inf0_main)
	(sleep_forever e16_cov_wraiths0_main)
	(sleep_forever e16_cov_ghosts0_main)
	(sleep_forever e16_cov_wraiths1_main)
	(sleep_forever e16_cov_ghosts1_main)
	(sleep_forever e16_cov_ubers0_main)
	(sleep_forever e16_cov_banshees0_main)
	
	; Clean up
	(sleep_until g_e18_started)
	(ai_erase e16_mars)
	(ai_erase e16_cov)
)

(script static void test_bridge_descent
	(switch_bsp 2)
	(sleep 1)
	(object_teleport (player0) e16_test)
	(ai_place e16_mars_inf0)
	(if (not g_e16_started) (wake e16_main))

	; Get the other scripts running
	(if (not g_e17_started) (wake e17_main))
	(if (not g_e18_started) (wake e18_main))
)



;= ENCOUNTER 15 ==========================================================================
;*
As the player reaches the crest of the bridge, he is set upon by Phantoms and
infantry ambushes.

Begins when the player kills and passes the Wraiths.
Ends when he begins the bridge descent.

Marines
	e15_mars_inf0 - e14_mars_inf0
		(follow) - Advancing up along the left side

Covenant
	e15_cov_inf0 - Infantry dropped off by the Phantoms, on either side
		(init) - Engaging from the sides of the bridge
	e15_cov_inf1 - Buggers which swarm the player from a hole in the bridge
		(init) - Hiding behind cover
		(ambush) - Attacking the Scorpion
	e15_cov_inf2 - Grunts who try to swarm the tank
		_0 - First group, before hole
			(init) - Hiding behind cover
			(ambush) - Attacking the Scorpion
		_1 - Second group, after hole
			(init) - Hiding behind cover
			(ambush) - Attacking the Scorpion
	e15_cov_phantoms0 - Phantoms which arrive to drop off e15_cov_inf0
		_0 - Left hand Phantom
			(covering) - Lurking below the bridge level
			(engaging) - Attacking the Scorpion
		_1 - Right hand Phantom
			(covering) - Lurking below the bridge level
			(engaging) - Attacking the Scorpion

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e15_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------

(script static void oes_e14_blind
	(ai_set_blind ai_current_squad true)
	(ai_set_deaf ai_current_squad true)
)

(script static void oes_e14_unblind
	(ai_set_blind ai_current_squad false)
	(ai_set_deaf ai_current_squad false)
)


;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e15_cov_phantom0_main
	(ai_place e15_cov_phantom0_0)
	
	; Sleep until one Phantom is damaged or dead (or a timeout)
	(sleep_until (< (ai_strength e15_cov_phantom0_0) 0.25) 30 900)
	
	; Place the second Phantom
	(ai_place e15_cov_phantom0_1)
)

(script dormant e15_cov_inf2_main
	(ai_place e15_cov_inf2_0)
	
	; Sleep until the player has advanced up
	(sleep_until (volume_test_objects tv_e15_cov_inf1_spring (players)) 15)
	
	; Place more, if there is room
	(ai_place e15_cov_inf2_1 (- 10 (ai_living_count e15_cov))) 
)

(script dormant e15_cov_inf1_main
	(ai_place e15_cov_inf1)
)

(script dormant e15_cov_inf0_main
	(sleep 1)
)

(script dormant e15_mars_inf0_main
	(ai_migrate e14_mars_inf0 e15_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e15_main
	(sleep_until (volume_test_objects tv_e15_main_begin (players)) 15)
	(set g_e15_started true)
	(print "e15_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e15_mars_inf0_main)
;	(wake e15_cov_inf0_main)
	(wake e15_cov_inf1_main)
;	(wake e15_cov_inf2_main)
;	(wake e15_cov_phantom0_main)
	
	; Shut down
	(sleep_until g_e16_started)
	(sleep_forever e15_mars_inf0_main)
	(sleep_forever e15_cov_inf0_main)
	(sleep_forever e15_cov_inf1_main)
	(sleep_forever e15_cov_inf2_main)
	(sleep_forever e15_cov_phantom0_main)
	
	; Clean up
	(sleep_until g_e17_started)
	(ai_erase e15_mars)
	(ai_erase e15_cov)
)

(script static void test_bridge_summit
	(switch_bsp 2)
	(sleep 1)
	(object_teleport (player0) e15_test)
	(ai_place e15_mars_inf0)
	(if (not g_e15_started) (wake e15_main))

	; Get the other scripts running
	(if (not g_e16_started) (wake e16_main))
	(if (not g_e17_started) (wake e17_main))
	(if (not g_e18_started) (wake e18_main))
)


;= ENCOUNTER 14 ==========================================================================
;*
The player is given a tank and ascends the bridge with it, laying waste to 
Ghosts and Wraiths.

Begins when the player emerges onto the Bridge.
Ends when the player kills the Wraiths.

Marines
	e14_mars_inf0 - Marines moving up the side of the bridge, following player
		(follow0) - Following the player
		(hold) - Wait when the player arrives near the Wraiths
		(follow1) - Continue following after the Wraiths die

Covenant
	e14_cov_ghosts0 - Ghosts streaming down the bridge to die by fire
		_0 - Ghosts initially halfway up the bridge, to get the ball rolling
		_1 - Ghosts respawning beyond the crest
			(engage0) - Engage the player at the first blockade
			(engage1) - At the second blockade
			(engage2) - Etc.
			(engage3) - Etc.
			(engage4) - Etc.
			(engage5) - At the last blockade and behind
	e14_cov_ghosts1 - Ghosts and Elites waiting to ambush the player
		(init) - Alert and lying in wait
		(engage) - Ambush sprung, engage from behind
	e14_cov_wraiths0 - Wraiths shelling the player
		(init) - Shelling near the last blockade
		(retreat) - Moving further back after one Wraith is dead
	e14_cov_snipers - Snipers needling the Scorpion
		(init) - Just plunking away at the approaching Scorpion

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e14_started false)		; Encounter has been activated?
(global short g_e14_ghost_respawn_limit 8)	; The maximum Ghost respawn count


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e14_cov_wraiths0_bombard
	(cs_enable_moving true)
	(cs_shoot true (player0))
	(sleep_until (volume_test_objects tv_e14_blockade4 (players)) 15)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e14_cov_snipers0_main
	(sleep 1)
)

(script dormant e14_cov_wraiths0_main
	(ai_place e14_cov_wraiths0)
	(cs_run_command_script e14_cov_wraiths0 cs_e14_cov_wraiths0_bombard)
)

(script dormant e14_cov_ghosts1_main
	(sleep 1)
)

(script dormant e14_cov_ghosts0_main
	; Increase the limit accordingly
	(if (difficulty_heroic) (set g_e14_ghost_respawn_limit (+ g_e14_ghost_respawn_limit 2)))
	(if (difficulty_legendary) (set g_e14_ghost_respawn_limit (+ g_e14_ghost_respawn_limit 4)))

	; Place the first group
	(ai_place e14_cov_ghosts0_0)
	
	; Respawn Ghosts
	(sleep_until
		(begin
			; If there are less than 2 ghosts and we've not exceeded the limit
			(if
				(and
					(<= (ai_living_count e14_cov_ghosts0) 1)
					(<= (ai_spawn_count e14_cov_ghosts0) g_e14_ghost_respawn_limit)
				)
				(ai_place e14_cov_ghosts0_1)
			)
			
			; Continue looping until this condition is met
			(or
				(> (ai_spawn_count e14_cov_ghosts0) g_e14_ghost_respawn_limit)
				(volume_test_objects tv_e14_blockade5 (players))
			)
		)
		15
	)
)

(script dormant e14_mars_inf0_main
	(ai_place e14_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e14_main
	(set g_e14_started true)
	(print "e14_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e14_mars_inf0_main)
	(wake e14_cov_ghosts0_main)
	(wake e14_cov_ghosts1_main)
	(wake e14_cov_wraiths0_main)
	(wake e14_cov_snipers0_main)
	
	; Shut down
	(sleep_until g_e15_started)
	(sleep_forever e14_mars_inf0_main)
	(sleep_forever e14_cov_ghosts0_main)
	(sleep_forever e14_cov_ghosts1_main)
	(sleep_forever e14_cov_wraiths0_main)
	(sleep_forever e14_cov_snipers0_main)
	
	; Clean up
	(sleep_until g_e16_started)
	(ai_erase e14_mars)
	(ai_erase e14_cov)
)

(script static void test_bridge_ascent
	(switch_bsp 2)
	(sleep 1)
	(object_teleport (player0) e14_test)
	(if (not g_e14_started) (wake e14_main))

	; Get the other scripts running
	(if (not g_e15_started) (wake e15_main))
	(if (not g_e16_started) (wake e16_main))
	(if (not g_e17_started) (wake e17_main))
	(if (not g_e18_started) (wake e18_main))
)


;= BRIDGE CUTSCENE =======================================================================
;- Globals ---------------------------------------------------------------------

(global boolean g_cinematic_bridge_started false)

;- Init and Cleanup ------------------------------------------------------------

(script dormant cinematic_bridge_main
	(sleep_until (volume_test_objects tv_cutscene_bridge_main_begin (players)) 15)
	(set g_cinematic_bridge_started true)

	; Cinematic prep
	(cinematic_fade_to_white)
	(cinematic_stash_players)
	
	; Run cinematic
	(cinematic_bridge)
	
	; Do setup
	(cinematic_unstash_players)
	
	; Start the next encounters
	(wake e14_main)
	(wake e15_main)
	(wake e16_main)
	(wake e17_main)
	(wake e18_main)
	
	; Finish cutscene
	(cinematic_fade_from_white)
)


;= ENCOUNTER 13 ==========================================================================
;*
An encounter which has the player and an allied Warthog chasing a convoy of
Creeps down the last section of the tunnel.

Begins when the player enters the second tunnel section.
Ends when the player moves out onto the bridge.

Marines
	e13_mars_warthog0 - e12_mars_warthog0 + e12_mars_warthog1
		(follow0) - Follow e13_cov_creep0_0 until it is dead
		(follow1) - Ditto for e13_cov_creep0_1
		(follow2) - Et cetera.
		(follow3) - Et cetera.
		(follow4) - Et cetera.
		(follow5) - Et cetera.
		(end_run) - If all the creeps are dead, end run engagement
		(continue) - Continue once the Covenant are dead

Covenant
	e13_cov_creep0 - Creep convoy moving through the tunnel
		_0 - The first Creep the player will kill
		_1 - The second Creep the player will kill
		_2 - Et cetera.
		_3 - Et cetera.
		_4 - Et cetera.
		_5 - Et cetera.
		_6 - Backup Creeps, defenders at the end of the tunnel
		_7 - Backup Creeps, defenders at the end of the tunnel
			(defend) - Defending at the end of the tunnel
	e13_cov_ghosts0 - A squad consisting of the Ghosts loaded into the Creeps
		(init) - Defending at the end of the tunnel

Open Issues
- Need real Creep damage
- Need pathfinding fix to ignore receding obstacles
- Need physics model for cargo creep
- Need pathfinding fix for cargo creep
- Need proper creep seats

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e13_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e13_cov_creep0_drive_fast
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 2.0)
	(cs_ignore_obstacles true)
;	(cs_ignore_obstacles false)
	(cs_go_to e13_cov_creep0_chase/p1)
)

(script command_script cs_e13_cov_creep0_drive
	(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_drive_fast)
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 0.5)
	(cs_ignore_obstacles true)
;	(cs_ignore_obstacles false)
	(cs_go_to e13_cov_creep0_chase/p1)
)

(script command_script cs_e13_cov_creep0_unload
	(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_l01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_r01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_sc01")
	(ai_vehicle_exit ai_current_actor)
)

(script command_script cs_e13_cov_creep0_first_end
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_vehicle_speed 0.5)
	(cs_go_to e13_cov_creep0_chase/first_end)
	(cs_face true e13_cov_creep0_chase/p1_facing)
	(sleep 150)
	(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_unload)
)

(script command_script cs_e13_cov_creep0_second_end
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_vehicle_speed 0.5)
	(cs_go_to e13_cov_creep0_chase/second_end)
	(cs_face true e13_cov_creep0_chase/p1_facing)
	(sleep 150)
	(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_unload)
)

(script command_script cs_e13_cov_creep0_third_end
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_vehicle_speed 0.5)
	(cs_go_to e13_cov_creep0_chase/third_end)
	(cs_face true e13_cov_creep0_chase/p1_facing)
	(sleep 150)
	(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_unload)
)

(script command_script cs_e13_mars_warthog0_drive
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_alert true)
	(cs_go_to e13_cov_creep0_chase/p1)	
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e13_cov_creep0_main
	(ai_place e13_cov_ghosts0)
	(ai_place e13_cov_creep0_0)
	(ai_place e13_cov_creep0_1)
	(ai_place e13_cov_creep0_2)
	
	; Load the Ghosts into the Creeps
	(vehicle_load_magic (ai_vehicle_get_from_starting_location e13_cov_creep0_0/creep0) "creep_sc01" (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location e13_cov_creep0_1/creep0) "creep_sc01" (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location e13_cov_creep0_2/creep0) "creep_sc01" (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost2))
	
	; Apply command scripts
	(cs_run_command_script e13_cov_creep0_0/creep0 cs_e13_cov_creep0_drive)
	(cs_run_command_script e13_cov_creep0_1/creep0 cs_e13_cov_creep0_drive)
	(cs_run_command_script e13_cov_creep0_2/creep0 cs_e13_cov_creep0_drive)
	
	; Wait till the player or creeps approach the second onramp
	(sleep_until 
		(or
			(volume_test_objects tv_e13_cov_creep0_reins (players)) 
			(volume_test_objects tv_e13_cov_creep0_reins (ai_actors e13_cov_creep0)) 
		)
		15
	)
	
	; If drivers are dead, spawn replacements
	(if (<= (ai_living_count e13_cov_creep0_0/creep0) 0) (ai_place e13_cov_creep0_3))
	(if (<= (ai_living_count e13_cov_creep0_1/creep0) 0) (ai_place e13_cov_creep0_4))
	(if (<= (ai_living_count e13_cov_creep0_2/creep0) 0) (ai_place e13_cov_creep0_5))
	(cs_run_command_script e13_cov_creep0_3/creep0 cs_e13_cov_creep0_drive)
	(cs_run_command_script e13_cov_creep0_4/creep0 cs_e13_cov_creep0_drive)
	(cs_run_command_script e13_cov_creep0_5/creep0 cs_e13_cov_creep0_drive)
	
	; Sleep till the player or the Creeps approach the end of the tunnel
	(sleep_until 
		(or
			(volume_test_objects tv_e13_cov_creep0_6_begin (players)) 
			(volume_test_objects tv_e13_cov_creep0_6_begin (ai_actors e13_cov_creep0)) 
		)
		15
	)

	; Queue up the ending scripts
	(cs_queue_command_script e13_cov_creep0_0/creep0 cs_e13_cov_creep0_third_end)
	(cs_queue_command_script e13_cov_creep0_1/creep0 cs_e13_cov_creep0_second_end)
	(cs_queue_command_script e13_cov_creep0_2/creep0 cs_e13_cov_creep0_first_end)
	(cs_queue_command_script e13_cov_creep0_3/creep0 cs_e13_cov_creep0_third_end)
	(cs_queue_command_script e13_cov_creep0_4/creep0 cs_e13_cov_creep0_second_end)
	(cs_queue_command_script e13_cov_creep0_5/creep0 cs_e13_cov_creep0_first_end)

	; Place reinforcements as necessary
	(if (<= (ai_living_count e13_cov) 8) (ai_place e13_cov_creep0_7))
	(ai_place e13_cov_creep0_6)
)

(script dormant e13_mars_warthog0_main
	(ai_migrate e12_mars_warthog0 e13_mars_warthog0)
	(ai_migrate e12_mars_warthog1 e13_mars_warthog0)
	(cs_run_command_script e13_mars_warthog0 cs_e13_mars_warthog0_drive)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e13_main
	(sleep_until (volume_test_objects tv_e13_main_begin (players)) 10)
	(set g_e13_started true)
	(print "e13_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e13_cov_creep0_main)
	(wake e13_mars_warthog0_main)
	
	; Shut down
	(sleep_until g_e14_started)
	(sleep_forever e13_cov_creep0_main)
	(sleep_forever e13_mars_warthog0_main)
	
	; Clean up
	(sleep_until g_e14_started) ; TODO: Make this less aggressive
	(ai_erase e13_mars)
	(ai_erase e13_cov)
)

(script static void test_tunnel_convoy
	(switch_bsp 2)
	(sleep 1)
	(object_teleport (player0) e13_test)
	(ai_place e13_mars_warthog0)
	(if (not g_e13_started) (wake e13_main))

	; Get the other scripts running
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 12 ==========================================================================
;*
As the player travels down the first tunnel section he encounters and blows
past several small throwaway encounters.

Begins when the player enters the tunnels.
Ends when the moves into the next tunnel section.

Marines
	e12_mars_warthog0 - e11_mars_warthog0
		(drive) - Haul ass down the tunnel, smashing through barricades
		(engage) - Engage nearby enemies
		(continue) - Continue past e12_cov_inf1 once they're dead
	e12_mars_warthog1 - A Warthog and three Marines at the end of the tunnel
		(init) - Enter the tunnel and wait for the player
		(follow) - Follow the player
	e12_mars_inf0 - Marines left over from e12_mars_warthog0, who remain behind
		(init) - Standing on guard near the tunnel entrance
	e12_mars_inf1 - A Marine resupply near the Scarab
		(init) - Hunkered down and defending

Covenant
	e12_cov_inf0_0 - The first roadblock the player encounters
	e12_cov_inf0_1 - The second
	e12_cov_inf0_2 - Et cetera
	e12_cov_inf0_3 - Et cetera
	e12_cov_inf0_4 - Et cetera
	e12_cov_inf0_5 - Et cetera
		(init) - Standing on guard at your firing points
	e12_cov_creep0 - Creep crew at the end of the tunnel, final roadblock
		(init) - Standing guard
	e12_cov_ghosts0 - Ghosts in the wrecked human convoy section
		(init) - Engage the player in the wide tunnel
		(follow) - Follow the player if he flees, up to e12_mars_warthog1 intro

Open Issues:
- Need plasma cannon
- Scarab leg
- TODO: Dust cloud effect, tumbling debris for Scarab leg
- TODO: Improve Ghosts chasing player into onramp, Marine Warthog
- TODO: Add a Ghost and pilot near e12_cov_inf0_1
- Need real Creep damage
- Need fixes for AP turret physics so that they can be rammed
- Need Buggers perching and boarding

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e12_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e12_event_scarab
	(sleep_until (volume_test_objects tv_e12_scarab_begin (players)) 8)
	
	; TODO: Make this real
	(print "EVENT: Scarab enters view, leg smashes down into tunnel")
	(print "EVENT: Marine drivers slam on the brakes, reverse")
)

(script dormant e12_cortana_dialog
	(sleep 60)
	(E12_CORTANA_10)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e12_cov_ghosts0_main
	(sleep_until (volume_test_objects tv_e12_cov_ghosts0_begin (players)) 15)
	(ai_place e12_cov_ghosts0)
	
	; TODO: Magical awareness of the e12_mars_inf1
)

(script dormant e12_cov_creep0_main
	(sleep_until (volume_test_objects tv_e12_mars_warthog1_begin (players)) 10)
	(ai_place e12_cov_creep0)
)

(script dormant e12_cov_inf0_main
	(ai_place e12_cov_inf0_0)
	
	; Sleep then place successive squads
	(sleep_until (volume_test_objects tv_e12_cov_inf0_1_begin (players)) 10)
	(ai_place e12_cov_inf0_1)
	(sleep_until (volume_test_objects tv_e12_cov_inf0_2_begin (players)) 10)
	(ai_place e12_cov_inf0_2)
	(sleep_until (volume_test_objects tv_e12_cov_inf0_3_begin (players)) 10)
	(ai_place e12_cov_inf0_3)
	(sleep_until (volume_test_objects tv_e12_cov_inf0_4_begin (players)) 10)
	(ai_place e12_cov_inf0_4)
	(sleep_until (volume_test_objects tv_e12_cov_inf0_5_begin (players)) 10)
	(ai_place e12_cov_inf0_5)
)

(script dormant e12_mars_inf1_main
	(sleep_until (volume_test_objects tv_e12_mars_inf1_begin (players)) 15)
	(ai_place e12_mars_inf1 (- 4 (ai_living_count e12_mars_warthog0)))
)

(script dormant e12_mars_inf0_main
	(sleep 1)
	; TODO
)

(script dormant e12_mars_warthog1_main
	(sleep_until (volume_test_objects tv_e12_mars_warthog1_begin (players)) 10)
	(ai_place e12_mars_warthog1)
)

(script dormant e12_mars_warthog0_main
	(ai_migrate e11_mars_warthog0 e12_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e12_main
	(sleep_until (volume_test_objects tv_e12_main_begin (players)) 15)
	(set g_e12_started true)
	(print "e12_main")
	(game_save)
	(garbage_collect_now)

	; Wake subsequent scripts
	(wake e13_main)

	; Wake control scripts
	(wake e12_cov_inf0_main)
	(wake e12_cov_creep0_main)
	(wake e12_cov_ghosts0_main)
	(wake e12_mars_warthog0_main)
	(wake e12_mars_warthog1_main)
	(wake e12_mars_inf0_main)
	(wake e12_mars_inf1_main)
	(wake e12_event_scarab)
	(wake e12_cortana_dialog)
	
	; Shut down
	(sleep_until g_e13_started)
	(sleep_forever e12_cov_inf0_main)
	(sleep_forever e12_cov_creep0_main)
	(sleep_forever e12_cov_ghosts0_main)
	(sleep_forever e12_mars_warthog0_main)
	(sleep_forever e12_mars_warthog1_main)
	(sleep_forever e12_mars_inf0_main)
	(sleep_forever e12_mars_inf1_main)
	(sleep_forever e12_event_scarab)
	(sleep_forever e12_cortana_dialog)
	
	; Clean up
	(sleep_until g_e14_started)
	(ai_erase e12_mars)
	(ai_erase e12_cov)
)

(script static void test_tunnel_blockades
	(switch_bsp 2)
	(sleep 1)
	(object_teleport (player0) e12_test)
	(ai_place e12_mars_warthog0)
	(if (not g_e12_started) (wake e12_main))

	; Get the other scripts running
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 11 ==========================================================================
;*
An encounter at the entrance to the tunnel section, where the player encounters
a roadblock, Ghosts, and insertion pods.

Begins when the player gets close to the end of the beach.
Ends when the Covenant are dead or the player moves into the tunnel.

Marines
	e11_mars_warthog0 - e10_mars_warthog0 + e10_mars_inf0
		(engage0) - Engaging the beach structure, until it is clear
		(engage1) - Engaging the Ghosts + beach structure
		(engage2) - Engaging the Creep
		(rout) - Clearing out e11_cov_inf1 and engaging e11_cov_creep0
		(continue) - When everyone is dead, who is left to fear?

Covenant
	e11_cov_inf0 - Covenant on the beach structure
		_0 - An AP turret and Sniper on top
		_1 - Elite and Grunts inside
			(init) - Defending on top of the structure
			(cower) - Cowering inside when sniper dies
	e11_cov_inf1 - Elites delivered by insertion pod
		(init) - Attacking from their landing zone, structure, tunnel
		(regroup) - Attacking from the tunnel entrance only
	e11_cov_ghosts0_0 - Empty Ghosts near the entrance
	e11_cov_ghosts0_1 - A pair of Ghosts which arrive from the tunnel
		(init) - Full beach, engaging player
	e11_cov_creep0 - A Creep which arrives from the tunnel to defend entrance
		(init) - Defending the tunnel entrance

Open Issues:
- Need better Marine sniper behavior
- Need Grunt Plasma Cannon
- Need real insertion pods, landing effects
- ENV: Need real tunnel wall fragments, art for tunnel entrance
- Need more mobile Warthog drivers to properly test them
- Need real water to assess impact
- Spawn bunker defenders later
- Reserve spare Ghosts until first three Ghosts are dead (prevent Ghost overload)

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e11_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e11_cov_creep0_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e11_cov_creep0_entry/p0)
	(sleep 30)
	(ai_vehicle_exit ai_current_actor)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean oes_e11_cov_inf0_sniper_dead
	(and
		(<= (ai_living_count e11_cov_inf0_0/sniper0) 0)
		(<= (ai_living_count e11_cov_inf0_0/grunt0) 0)		
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e11_cov_creep0_main
	(sleep_until 
		(or
			(volume_test_objects tv_e11_tunnel_entrance (players)) 
			(and
				(> (ai_spawn_count e11_cov_inf1) 0)
				(<= (ai_living_count e11_cov_inf1) 1)
			)
		)	
		15
	)
	(ai_place e11_cov_creep0)
	(cs_run_command_script e11_cov_creep0/creep0 cs_e11_cov_creep0_entry)
)

(script dormant e11_cov_ghosts0_main
	; Place the first Ghost and reserve the spares
	(ai_place e11_cov_ghosts0_0)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e11_cov_ghosts0_0/ghost1) true)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e11_cov_ghosts0_0/ghost2) true)
	
	; Place the next two Ghosts when the player gets close
	(sleep_until (volume_test_objects tv_e11_closer (players)) 15)
	(sleep_until (<= (ai_living_count e11_cov_ghosts0_0) 0) 15)
	(ai_place e11_cov_ghosts0_1)
	
	; When those ghosts are depleted, unreserve the two spares
	(sleep_until (<= (ai_living_count e11_cov_ghosts0_0) 0) 15)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e11_cov_ghosts0_0/ghost1) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e11_cov_ghosts0_0/ghost2) false)
)

(script dormant e11_cov_inf1_main
	; Sleep until the player is close
	(sleep_until (< (objects_distance_to_flag (players) e11_cov_inf1_entry) 35) 10)
	
	; TODO: Make this real
	(print "Insertion pods streak in, slam into beach")
	
	; Send in the pods
	(effect_new "effects\impact\explosion_small\frag_grenade\tough_terrain_sand" e11_pod0)
	(object_create e11_pod0)
	(sleep 15)
	(effect_new "effects\impact\explosion_small\frag_grenade\tough_terrain_sand" e11_pod1)
	(object_create e11_pod1)
	(sleep 7)
	(effect_new "effects\impact\explosion_small\frag_grenade\tough_terrain_sand" e11_pod2)
	(object_create e11_pod2)
	(sleep 25)
	(effect_new "effects\impact\explosion_small\frag_grenade\tough_terrain_sand" e11_pod3)
	(object_create e11_pod3)
	(sleep 7)
	(effect_new "effects\impact\explosion_small\frag_grenade\tough_terrain_sand" e11_pod4)
	(object_create e11_pod4)
	(sleep 7)
	(effect_new "effects\impact\explosion_small\frag_grenade\tough_terrain_sand" e11_pod5)
	(object_create e11_pod5)
	(sleep 60)
	(ai_place e11_cov_inf1)
)

(script dormant e11_cov_inf0_main
	(ai_place e11_cov_inf0_0)

	; Place more when the player gets closer
	(sleep_until (volume_test_objects tv_e11_closer (players)) 15)
	(ai_place e11_cov_inf0_1 (pin (- 6 (ai_living_count e10_cov)) 0 4))
)

(script dormant e11_mars_warthog0_main
	; Wait until the last group of Covenant are dead
	(sleep_until (<= (ai_living_count e10_cov_inf1) 0) 30 two_minutes)
	
	; Migrate people over
	(ai_migrate e10_mars_warthog0 e11_mars_warthog0)
	(ai_migrate e10_mars_inf0 e11_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e11_main
	(sleep_until (volume_test_objects tv_e11_main_begin (players)) 15)
	(set g_e11_started true)
	(print "e11_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e11_cov_inf0_main)
	(wake e11_cov_inf1_main)
	(wake e11_cov_ghosts0_main)
	(wake e11_cov_creep0_main)
	(wake e11_mars_warthog0_main)
	
	; Shut down
	(sleep_until g_e12_started)
	(sleep_forever e11_cov_inf0_main)
	(sleep_forever e11_cov_inf1_main)
	(sleep_forever e11_cov_ghosts0_main)
	(sleep_forever e11_cov_creep0_main)
	(sleep_forever e11_mars_warthog0_main)
	
	; Clean up
	(sleep_until g_e13_started)
	(ai_erase e11_mars)
	(ai_erase e11_cov)
)

(script static void test_tunnel_entrance
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e11_test)
	(ai_place e11_mars_warthog0)
	(if (not g_e11_started) (wake e11_main))

	; Get the other scripts running
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 10 ==========================================================================
;*
An encounter around a small, entrenched Covenant position just past the
visibility building.

Begins when the player exits the building bypass.
Ends when the Covenant are dead or the player moves past.

Marines
	e10_mars_warthog0 - e9_mars_warthog0
		(engage0) - Engage e10_cov_inf0 until they are dead
		(engage1) - Engage e10_cov_inf1 until they are dead
		(continue) - Continue up the beach
	e10_mars_inf0 - Marines nearby, engaging the entrenched e9_cov_inf0
		(init) - Dug in and engaging
		(advance0) - Storming the e10_cov_inf0 position and flushing them out
		(advance2) - Storming the e10_cov_inf1 position and flushing them out

Covenant
	e10_cov_inf0 - Entrenched Covenant engaging e10_mars_inf0
		(init) - Defending the outpost
	e10_cov_inf1 - Covenant on the gun
		(init) - Defending the gun

Open Issues
- Need Grunt Plasma Cannon
- Need more mobile Warthog drivers to properly test them
- Need real water to assess impact
- Marines kill first tower defenders and advance too quickly

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e10_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e10_miranda_dialog
	(sleep_until
		(and
			(> (ai_spawn_count e10_cov) 0)
			(<= (ai_living_count e10_cov) 0)
		)
		30
		30_seconds
	)
	(sleep 150)
	(E10_MIRANDA_10)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e10_cov_inf1_main
	(ai_place e10_cov_inf1)
	
	; TODO: Load one of the Elites into the gunner control
)

(script dormant e10_cov_inf0_main
	(ai_place e10_cov_inf0)
)

(script dormant e10_mars_inf0_main
	(ai_place e10_mars_inf0)
)

(script dormant e10_mars_warthog0_main
	; Migrate old squads in
	(ai_migrate e9_mars_warthog0 e10_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e10_main
	(sleep_until (volume_test_objects tv_e10_main_begin (players)) 15)
	(set g_e10_started true)
	(print "e10_main")
	(game_save_no_timeout)	; TODO: Fix this
	(garbage_collect_now)

	; Wake control scripts
	(wake e10_cov_inf0_main)
	(wake e10_cov_inf1_main)
	(wake e10_mars_inf0_main)
	(wake e10_mars_warthog0_main)
	(wake e10_miranda_dialog)
	
	; Shut down
	(sleep_until g_e11_started)
	(sleep_forever e10_cov_inf0_main)
	(sleep_forever e10_cov_inf1_main)
	(sleep_forever e10_mars_inf0_main)
	(sleep_forever e10_mars_warthog0_main)
	(sleep_forever e10_miranda_dialog)
	
	; Clean up
	(sleep_until g_e12_started)
	(ai_erase e10_mars)
	(ai_erase e10_cov)
)

(script static void test_beach_fort
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e10_test)
	(ai_place e10_mars_warthog0)
	(if (not g_e10_started) (wake e10_main))

	; Get the other scripts running
	(if (not g_e11_started) (wake e11_main))
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 9 ===========================================================================
;*
An encounter on the beach with a dug-in Creep and crew, followed by more 
skirmishing with infantry.

Begins when the player sights the visibility blocker building.
Ends when the Covenant are dead or the player moves past.

Marines
	e9_mars_warthog0 - e8_mars_warthog0
		(advance0) - Advance up the beach until alerted
		(engage0) - Engage enemies around the gun tower
		(engage1) - Engage enemies around the bypass entrance
		(engage2) - Engage enemies in the bypass

Covenant
	e9_cov_creep0 - A Creep and crew dug in at the building bypass
		(init) - Defending around the Creep
		(cower) - Defending deeper under cover
	e9_cov_inf0 - Infantry en route to reinforce e9_cov_creep0, but are too late
		(init) - Advancing to reinforce
		(scatter) - When engaged, use nearby firing points
	e9_cov_inf1 - Infantry manning the gun tower
		(init) - Defending around the guntower

Open Issues
- Need goal points for proper progression up beach
- TODO: Place cover along the wall for Marines
- ENV: Need doorway for investigating Covenant
- TODO: Dead marines near doorway, ammo cache
- TODO: CS for investigating Covenant
- Need better/fixed Warthog drivers to properly test them
- Need real water to assess impact

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e9_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e9_cortana_dialog
	(sleep 30)
	(E9_CORTANA_10)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e9_cov_inf1_main
	(ai_place e9_cov_inf1)
)

(script dormant e9_cov_inf0_main
	(sleep_until (volume_test_objects tv_e9_near_entrance (players)) 15)
	(ai_place e9_cov_inf0)
	(sleep_until (volume_test_objects tv_e9_bypass (players)) 15)
	(ai_place e9_cov_inf0 (- 8 (ai_living_count e9_cov_inf0)))
)

(script dormant e9_cov_creep0_main
	(ai_place e9_cov_creep0)
)

(script dormant e9_mars_warthog0_main
	(ai_place e9_mars_warthog0)

	; Wait until the Wraith from last encounter is dead, or the player is
	; hard charging
	(sleep_until 
		(or
			(<= (ai_living_count e8_cov_wraith0) 0)
			(volume_test_objects tv_e9_near_entrance (players))
		)
		15
	)

	; Migrate any old units in
	(ai_migrate e8_mars_warthog0 e9_mars_warthog0)
	(ai_migrate e8_mars_inf0 e9_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e9_main
	(sleep_until (volume_test_objects tv_e9_main_begin (players)) 15)
	(set g_e9_started true)
	(print "e9_main")
	(game_save_no_timeout)	; TODO: Fix this
	(garbage_collect_now)

	; Wake control scripts
	(wake e9_cov_inf0_main)
	(wake e9_cov_inf1_main)
	(wake e9_cov_creep0_main)
	(wake e9_mars_warthog0_main)
	(wake e9_cortana_dialog)
	
	; Shut down
	(sleep_until g_e10_started)
	(sleep_forever e9_cov_inf0_main)
	(sleep_forever e9_cov_inf1_main)
	(sleep_forever e9_cov_creep0_main)
	(sleep_forever e9_mars_warthog0_main)
	(sleep_forever e9_cortana_dialog)
	
	; Clean up
	(sleep_until g_e12_started)
	(ai_erase e9_mars)
	(ai_erase e9_cov)
)

(script static void test_beach_infantry
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e9_test)
	(ai_place e9_mars_test)
	(if (not g_e9_started) (wake e9_main))

	; Get the other scripts running
	(if (not g_e10_started) (wake e10_main))
	(if (not g_e11_started) (wake e11_main))
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 8 ===========================================================================
;*
The hotel exit, which is where surivors from the downed Pelican are making a 
last stand, attacked by Covenant vehicles.

Begins when the player exits the hotel.
Ends when the player has a Warthog and moves down onto the beach.

Marines
	e8_mars_inf0 - e7_mars_inf0
		(init) - Holding positions in the door until the player makes his move
		(advance0) - Attacking nearby turret, killing it and pausing briefly
		(advance1) - Advancing to the next turret, killing it, and pausing
		(advance2) - Advancing to the third turret, killing it
	e8_mars_warthog0 - Crew of the Warthog, pinned down in building
		(init) - Holed up in the building, bunkering
		(reinforced) - Turrets, Creeps destroyed, more exposed positions
		(reclaiming) - Fighting down near Warthog, using its gun
		(attack0) - Clearing the street
		(attack1) - Following the Wraith on the beach
		(continue) - Advance up the beach if the Wraith dies

Covenant
	e8_cov_inf0_0 - First Grunt gunner
	e8_cov_inf0_1 - Second gunner and the infantry supporting it
	e8_cov_inf0_2 - Third gunner and the infantry supporting it
		(init) - Using the turrets agains e8_mars_warthog0
	e8_cov_inf1 - An Elite Major and a pair of Grunts, watching the situation
		(init) - Observing the situation, fending off the player
	e8_cov_creep0_0 - Parked Creep, crew attacking Warthog
	e8_cov_creep0_1 - Approaching Creep, crew riding and disembarking
		(init) - In positions around the Warthog
		(retreat) - In positions closer to the building, under better cover
	e8_cov_wraith0 - Wraith and flavor Phantom on beach
		(init) - On beach, shelling targets
		(engaged) - Directly engaged by the Warthog on the beach
		(retreat) - Retreat further up the beach, to the chokepoint
	e8_cov_ghost0 - A pair of Ghosts, reinforcing the area
		(init) - Fighting near building
	e8_cov_hunters0 - A pair of Hunters on Legendary, making things harder
		(init) - Fighting near Warthog

Open Issues
- Need target preference setting for properly setting up encounter
- Need real "imagine target" functionality
- ENV: Need more poops, cover, more real geometry
- Need fix for Wraith not firing
- TODO: Command scripts for Ghost entries
- Need flying Phantom for Phantom moving away from downed Pelican
- Need Creep seat exit animations for Grunts and Elites
- TODO: Need properly destroyable Creep, damage seats
- Need Grunt Plasma Cannon
- TODO: Fix FRG Grunt firing parameters
- Need Holding Fire style for observing Commander, Grunts
- Need "haughtily observing" pose for commander
- Need "stealthy" style for Marines taking out turrets

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e8_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e8_cov_creep0_1_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 0.5)
	(cs_go_to e8_cov_creep0_1_entry/p0)
	(cs_go_to e8_cov_creep0_1_entry/p1)
	(sleep 30)
	(ai_vehicle_exit ai_current_actor)
	(ai_vehicle_exit e8_cov_creep0_1/passenger0)
	(ai_vehicle_exit e8_cov_creep0_1/passenger1)
	(ai_vehicle_exit e8_cov_creep0_1/passenger2)
	(ai_vehicle_exit e8_cov_creep0_1/passenger3)
	(sleep 30)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean oes_e8_cov_creep0_has_gunner
	(or
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location e8_cov_creep0_0/creep0) "creep_g" (ai_actors e8_cov))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location e8_cov_creep0_1/creep0) "creep_g" (ai_actors e8_cov))
	)
)

(script static boolean oes_e8_mars_warthog0_reclaimed
	(or
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0) "warthog_d" (players))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0) "warthog_g" (players))
		(vehicle_test_seat_list (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0) "warthog_p" (players))
	)
)

(script static void oes_e8_remove_target_hack
	(ai_erase e8_mars_TARGET)
)

;- Event Controls --------------------------------------------------------------

(script dormant e8_cortana_dialog
	(sleep 30)
	(E8_CORTANA_10)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e8_cov_hunters0_main
	(sleep 1)
	; TODO: This
)

(script dormant e8_cov_wraith0_main
	(sleep_until 
		(or
			(and
				(> (ai_spawn_count e8_cov_ghost0) 0)
				(<= (ai_living_count e8_cov_ghost0) 1)
			)
			(volume_test_objects tv_e8_cov_wraith0_begin (players))
		)
		15
	)
	
	; Send in the Wraith
	(ai_place e8_cov_wraith0)
	
	; Begin shelling
;	(cs_run_command_script e8_cov_wraith0 cs_e8_cov_wraith0_shelling)
)

(script dormant e8_cov_ghost0_main
	(sleep_until 
		(and
			(not (oes_e8_cov_creep0_has_gunner))
			(<= (ai_living_count e8_cov) 5)
			(<= (ai_fighting_count e8_cov) 1)
		)
	)
	
	; Place the Ghosts, send them in
	(ai_place e8_cov_ghost0)
)

(script dormant e8_cov_creep0_main
;	(ai_place e8_cov_creep0_0)
	(ai_place e8_cov_creep0_1)
	
	; Run command scripts
	(cs_run_command_script e8_cov_creep0_1/creep0 cs_e8_cov_creep0_1_entry)
)

(script dormant e8_cov_inf1_main
	(ai_place e8_cov_inf1)
)

(script dormant e8_cov_inf0_main
	(ai_place e8_cov_inf0_0)
	(ai_place e8_cov_inf0_1)
)

(script dormant e8_mars_warthog0_main
	; Place these guys and then make everyone hate them
	(ai_place e8_mars_warthog0)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0))
	(ai_prefer_target (ai_actors e8_mars_warthog0) true)
	
	; Reserve the seat
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0) true) 
	
	; TODO: Remove this
	(ai_place e8_mars_TARGET)
	(object_cannot_take_damage (ai_actors e8_mars_TARGET))
	(unit_impervious (ai_get_unit e8_mars_TARGET) true)

	; Wait until the player has been sighted, then change preferences
	(sleep_until (ai_trigger_test e8_cov_sighted_player e8_cov))
	(ai_prefer_target (ai_actors e8_mars_warthog0) false)
	
	; Wait until the player is in the Warthog
	(sleep_until (oes_e8_mars_warthog0_reclaimed))
	
	; Un-reserve it, and make it vulnerable to damage
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0) false) 
	(object_can_take_damage (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0))
)

(script dormant e8_mars_inf0_main
	; Migrate old squads over
	(ai_migrate e7_mars_inf0 e8_mars_inf0)
	
	; Once the turrets are dead, or the Warthog is reclaimed, migrate over
	(sleep_until
		(or
			(<= (ai_living_count e8_cov_inf0) 0)
			(oes_e8_mars_warthog0_reclaimed)
		)
	)
	(ai_migrate e8_mars_inf0 e8_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e8_main
	(sleep_until (volume_test_objects tv_e8_main_begin (players)) 15)
	(set g_e8_started true)
	(print "e8_main")
	(game_save)
	(garbage_collect_now)
	
	; Wake subsequent scripts
	(wake e9_main)
	(wake e10_main)
	(wake e11_main)

	; Wake control scripts
	(wake e8_mars_inf0_main)
	(wake e8_mars_warthog0_main)
	(wake e8_cov_inf0_main)
	(wake e8_cov_inf1_main)
	(wake e8_cov_creep0_main)
	(wake e8_cov_ghost0_main)
	(wake e8_cov_wraith0_main)
	(wake e8_cortana_dialog)
;	(if (difficulty_legendary) (wake e8_cov_hunters0_main))
	
	; Shut down
	(sleep_until g_e9_started)
	(sleep_forever e8_mars_inf0_main)
	(sleep_forever e8_mars_warthog0_main)
	(sleep_forever e8_cov_inf0_main)
	(sleep_forever e8_cov_inf1_main)
	(sleep_forever e8_cov_creep0_main)
	(sleep_forever e8_cov_ghost0_main)
	(sleep_forever e8_cov_wraith0_main)
	(sleep_forever e8_cortana_dialog)
	
	; Clean up
	(sleep_until g_e10_started)
	(ai_erase e8_mars)
	(ai_erase e8_cov)
)

(script static void test_hotel_exit
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e8_test)
	(ai_place e8_mars_inf0)
	(if (not g_e8_started) (wake e8_main))

	; Get the other scripts running
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 7 ===========================================================================
;*
A short encounter in the hotel interior, an ambush in the hallway on a group
of Covenant reinforcements.

Begins when the player enters the hotel.
Ends when the Covenant are dead.

Marines
	e7_mars_inf0 - e6_mars_inf0 + e6_mars_inf1/marine0
		(follow) - Follow the Chief
		(hide) - Hide from e7_cov_inf0
		(attack) - Attack e7_cov_inf0

Covenant
	e7_cov_inf0 - The unsuspecting Covenant who burst into the hallway
		(init) - Headed down the hallway
		(scramble) - A panicked attempt to fight back

Open Issues
- TODO: Add dialog, including Covenant dialog
- TODO: Ammo, weapons cache
- Need real ambushing behaviors
- ENV: Need door and explosion effects for end of hall

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e7_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e7_abort
	(sleep 1)
)


;- Order Scripts ---------------------------------------------------------------

(script static void oes_e7_blind
	(ai_set_blind ai_current_squad true)
	(ai_set_deaf ai_current_squad true)
)

(script static void oes_e7_unblind
	(ai_set_blind ai_current_squad false)
	(ai_set_deaf ai_current_squad false)
)

(script static boolean oes_e7_cov_inf0_arrived
	(volume_test_objects tv_e7_cov_inf0_spring_ambush (ai_actors e7_cov_inf0))
)


;- Squad Controls --------------------------------------------------------------

(script dormant e7_cov_inf0_main
	; Wait for the player or Marines to arrive
	(sleep_until 
		(or
			(volume_test_objects tv_e7_cov_inf0_init (players))
			(volume_test_objects tv_e7_cov_inf0_init (ai_actors e7_mars_inf0))
		)
		15
	)
	
	; Explosion
	; TODO: Make this real
	(effect_new "effects\objects\weapons\grenade\plasma_grenade\detonation" e7_door_breaker0)
	(sleep 5)
	(effect_new "scenarios\test\earthcity\temp_junk\e2_wall_breaker" e7_door_breaker0)
	
	; Pause, then place the Covenant
	(ai_place e7_cov_inf0)
)

(script dormant e7_mars_inf0_main
	; Migrate them over
	(ai_migrate e6_mars_inf0 e7_mars_inf0)
	(ai_migrate e6_mars_inf1/marine0 e7_mars_inf0)
	
	; Wait for the Covenant to arrive, the break command scripts
	(sleep_until (> (ai_spawn_count e7_cov_inf0) 0) 10)
	(sleep 5)
	(cs_run_command_script e7_mars_inf0 cs_e7_abort)
	(sleep 15)
	(E7_MARINE_10)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e7_main
	(sleep_until (volume_test_objects tv_e7_main_begin (players)) 15)
	(set g_e7_started true)
	(print "e7_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e7_mars_inf0_main)
	(wake e7_cov_inf0_main)
	
	; Shut down
	(sleep_until g_e8_started)
	(sleep_forever e7_mars_inf0_main)
	(sleep_forever e7_cov_inf0_main)
	
	; Clean up
	(sleep_until g_e9_started)
	(ai_erase e7_mars)
	(ai_erase e7_cov)
)

(script static void test_hotel_hall
	(object_teleport (player0) e7_test)
	(ai_place e7_mars_inf0)
	(if (not g_e7_started) (wake e7_main))

	; Get the other scripts running
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 6 ===========================================================================
;*
A Covenant force is pounding away at a hotel service entrance, pinning down a
handful of surviving Marines. The player gets around behind them, to see if they
like it better that way. Ahhhhn.

Begins when the player approaches the neighborhood exit.
Ends when the player enters the hotel and the Covenant are dead.

Marines
	e6_mars_inf0 - e5_mars_inf0
		(follow) - Follow the player, remaining out of sight of e6_cov_inf0
		(attack) - Attack e6_cov_inf0 when they see the player
		(advance) - Advance into the hotel, checking on bodies
	e6_mars_inf1 - Marines holed up in the hotel
		(init) - Cowering behind cover
	e6_mars_inf2 - Marines holed up in the hotel, reinforcements for the player
		(init) - Cowering behind cover

Covenant
	e6_cov_inf0 - An infantry squad using a turret on the hotel entrance
		(init) - Firing on the entrance
		(alert_left) - Alerted and fighting, tending to the left
		(alert_right) - Alerted and fighting, tending to the right
		(pursuit) - Give chase if the player charges the hotel

Open Issues
- Need Covenant Plasma Cannon
- Need real "imagine target" functionality
- Need pinned and wounded poses for Marines
- Need Medic Marine
- TODO: Hunters?

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e6_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e6_mars_inf1_cower
	(cs_crouch true)
	(sleep 30000)
)

(script command_script cs_e6_mars_inf2_cower
	(cs_crouch true)
	(sleep_until (volume_test_objects tv_e6_hotel_entrance (players)))
)

(script command_script cs_e6_mars_inf1_uncover
	(cs_face_object true (player0))
	(if (volume_test_objects tv_e6_hotel_vicinity (players))
		(cs_go_to cs_e6_mars_inf1_lead/p3)
		(cs_go_to cs_e6_mars_inf1_lead/p4)
	)
	(sleep 30000)
)

(script command_script cs_e6_mars_inf1_lead
	; Go to each point, and wait for the player if he's not near or past
	(cs_go_to cs_e6_mars_inf1_lead/p0)
	(if (not (volume_test_objects tv_e6_lead0 (players))) (cs_face_object true (player0)))
	(sleep_until (volume_test_objects tv_e6_lead0 (players)) 5)
	(cs_face_object false (player0))
	(cs_go_to cs_e6_mars_inf1_lead/p1)
	(if (not (volume_test_objects tv_e6_lead1 (players))) (cs_face_object true (player0)))
	(sleep_until (volume_test_objects tv_e6_lead1 (players)) 5)
	(cs_face_object false (player0))
	(cs_go_to cs_e6_mars_inf1_lead/p2)
	(sleep 25)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script static boolean e6_cov_inf0_not_a_threat
	(and
		(<= (ai_living_count e6_cov) 4) 
		(<= (ai_fighting_count e6_cov) 2) 
	)
)

(script dormant e6_cov_inf0_main
	(ai_place e6_cov_inf0)

	; TODO: Remove this, replace with an imagined target
	(ai_place e6_cov_TARGET)
	(object_cannot_take_damage (ai_actors e6_cov_TARGET))
	(unit_impervious (ai_get_unit e6_cov_TARGET) true)
	(ai_magically_see e6_cov_inf0 e6_cov_TARGET)
	(sleep_until (e6_cov_inf0_not_a_threat) 10)
	(ai_erase e6_cov_TARGET)
)

(script dormant e6_mars_inf2_main
	(sleep_until 
		(or
			(volume_test_objects tv_e6_hotel_vicinity (players))
			(e6_cov_inf0_not_a_threat)
		)
	)

	; If necessary, place more Marines
	(ai_place e6_mars_inf2 (- 3 (+ (ai_living_count e5_mars_inf0) (ai_living_count e6_mars_inf0))))
	(cs_run_command_script e6_mars_inf2 cs_e6_mars_inf2_cower)
	
	; Move them into inf0, to keep things neat
	(sleep_until (volume_test_objects tv_e6_hotel_entrance (players)))
	(ai_migrate e6_mars_inf2 e6_mars_inf0)
)

(script dormant e6_mars_inf1_main
	(ai_place e6_mars_inf1)
	(cs_run_command_script e6_mars_inf1 cs_e6_mars_inf1_cower)
	
	; Sleep until the Covenant are dead or the player is near
	(sleep_until 
		(or
			(volume_test_objects tv_e6_hotel_vicinity (players))
			(e6_cov_inf0_not_a_threat)
		)
		10
	)

	(sleep 20)	; Pause so that he doesn't just run right out
	(cs_run_command_script e6_mars_inf1/marine0 cs_e6_mars_inf1_uncover)

	; Hail the Chief
	(sleep_until (<= (objects_distance_to_object (players) (ai_get_object e6_mars_inf1/marine0)) 6) 15)
	(E6_MARINE_10)
	(sleep 45)
	
	; Once the player is close, continue dialog
	(sleep_until (<= (objects_distance_to_object (players) (ai_get_object e6_mars_inf1/marine0)) 3) 15)
	(E6_MARINE_20)
	
	; And send him down the hall
	(sleep 120)
	(cs_run_command_script e6_mars_inf1/marine0 cs_e6_mars_inf1_lead)
)

(script dormant e6_mars_inf0_main
	; Wait until the neighborhood is mostly clear
	(sleep_until
		(and
			(<= (ai_living_count e5_cov) 5)
			(<= (ai_fighting_count e5_cov) 0)
		)
		15
		one_minute
	)

	; Migrate
	(ai_migrate e5_mars_inf0 e6_mars_inf0)	
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e6_main
	(sleep_until 
		(or
			(volume_test_objects tv_e6_main_begin0 (players))
			(volume_test_objects tv_e6_main_begin1 (players))
			(volume_test_objects tv_e6_main_begin2 (players))
		)
	)
	(set g_e6_started true)
	(print "e6_main")
	(game_save)
	(garbage_collect_now)
	
	; Wake subsequent scripts
	(wake e7_main)

	; Wake control scripts
	(wake e6_mars_inf0_main)
	(wake e6_mars_inf1_main)
	(wake e6_mars_inf2_main)
	(wake e6_cov_inf0_main)
	
	; Shut down
	(sleep_until g_e8_started)
	(sleep_forever e6_mars_inf0_main)
	(sleep_forever e6_mars_inf1_main)
	(sleep_forever e6_mars_inf2_main)
	(sleep_forever e6_cov_inf0_main)
	
	; Clean up
	(sleep_until g_e9_started)
	(ai_erase e6_mars)
	(ai_erase e6_cov)
)

(script static void test_hotel_entrance
	(object_teleport (player0) e6_test)
	(ai_place e6_mars_inf0)
	(if (not g_e6_started) (wake e6_main))

	; Get the other scripts running
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 5 ===========================================================================
;*
The player is ambushed by the Covenant in a nearby neighborhood space, but if 
he's paying attention, he can catch them off guard instead.

Begins when the player enters the neighborhood.
Ends when the Covenant are dead.

Marines
	e5_mars_inf0 - e4_mars_inf0
		(follow) - Follow the Chief, cautiously, until Covenant alerted
		(engage0) - Engage, but stay clear of the turret
		(engage1) - Engage more freely once the turret is dead
		(wait) - Wait until the player has pushed ahead into the next section
		(engage2) - Engage the Covenant in the second section, vs e5_cov_inf2
		(engage3) - Engage the Covenant in the second section

Covenant
	e5_cov_inf0 - An Elite and Grunts waiting in ambush
		(init) - Waiting in ambush
		(engage) - Engaging once alerted
	e5_cov_inf1_0 - An Elite, Jackals waiting to block exit
	e5_cov_inf1_1 - A turret Grunt, waiting to block exit
		(init) - Block the exit
	e5_cov_inf2 - Elites, Buggers, and Grunts entering via rooftop
		(init) - Engage in the second neighborhood section

Open Issues
- Ambushing behavior should be real, not artificial and forced via CS
- Need Grunt Plasma Cannon
- Need Marine Holding Fire style
- TODO: Make Marines notice pistol, notice Grunt, look meaningfully at player
- TODO: Damage permutes on railings

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e5_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e5_cov_inf0_wait
	(cs_abort_on_damage true)
	(cs_crouch true)
	(sleep_until (ai_trigger_test e5_cov_inf0_ambush_sprung e5_mars_inf0) 5)
)

(script command_script cs_e5_cov_inf0_grunt0
	(cs_go_to e5_cov_ambush/inf0_grunt0_p0)
	(sleep 30)
	(object_create_anew e5_cov_inf0_pistol)
	(E5_GRUNT0_10)
	(sleep 20)
	(cs_force_combat_status 3)
	(cs_go_to e5_cov_ambush/inf0_grunt0_p1)
	(E5_GRUNT1_10)
	(sleep_until (ai_trigger_test e5_cov_inf0_ambush_sprung e5_mars_inf0) 5)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e5_cov_inf2_main
	(sleep_until 
		(or
			(volume_test_objects tv_e5_player_advanced (players))
			(and
				(<= (ai_living_count e5_cov_inf0) 3)
				(<= (ai_fighting_count e5_cov_inf0) 0)
			)
		)
	)
	(ai_place e5_cov_inf2)
)

(script dormant e5_cov_inf1_main
	; Wait until the ambush is sprung
	(sleep_until (ai_trigger_test e5_cov_inf0_ambush_sprung e5_mars_inf0) 15)
	(ai_place e5_cov_inf1)
	(ai_magically_see e5_cov_inf1 e5_mars_inf0)
)

(script dormant e5_cov_inf0_main
	; Place ambushers based on how many survivors are present in the alley
	; Place between 4 and 8 guys
	(ai_place e5_cov_inf0 (pin (- 10 (ai_living_count e4_cov)) 4 8))

	; Tell the Grunt to run and do his thing, queue up the wait script for all
	(cs_run_command_script e5_cov_inf0 cs_e5_cov_inf0_wait)
	
	; Give them magical awareness of the Marines, so that they're ready
	(ai_magically_see e5_cov_inf0 e5_mars_inf0)
	
	; The Grunt's pistol drops
	(cs_run_command_script e5_cov_inf0/grunt0 cs_e5_cov_inf0_grunt0)
)

(script dormant e5_mars_inf0_main
	; Sleep until the previous Covenant are dealt with
	(sleep_until 
		(and
			(<= (ai_living_count e4_cov) 5) 
			(<= (ai_fighting_count e4_cov) 0) 
		)
		15 
		1800
	)
	
	; Migrate them over
	(ai_migrate e4_mars_inf0 e5_mars_inf0)
	
	; Make them blind for a moment, until the ambush is sprung
	; TODO: Make this better
	(ai_set_blind e5_mars_inf0 true)
	(sleep_until (ai_trigger_test e5_cov_inf0_ambush_sprung e5_mars_inf0) 15)
	(ai_set_blind e5_mars_inf0 false)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e5_main
	(sleep_until 
		(or
			(volume_test_objects tv_e5_main_begin0 (players))
			(volume_test_objects tv_e5_main_begin1 (players))
		)
	)
	(set g_e5_started true)
	(print "e5_main")
	(game_save)
	(garbage_collect_now)

	; Wake control scripts
	(wake e5_mars_inf0_main)
	(wake e5_cov_inf0_main)
	(wake e5_cov_inf1_main)
	(wake e5_cov_inf2_main)
	
	; Shut down
	(sleep_until g_e6_started)
	(sleep_forever e5_mars_inf0_main)
	(sleep_forever e5_cov_inf0_main)
	(sleep_forever e5_cov_inf1_main)
	(sleep_forever e5_cov_inf2_main)
	
	; Clean up
	(sleep_until g_e8_started)
	(ai_erase e5_mars)
	(ai_erase e5_cov)
)

(script static void test_neighborhood
	(object_teleport (player0) e5_test)
	(ai_place e5_mars_inf0)
	(if (not g_e5_started) (wake e5_main))

	; Get the other scripts running
	(if (not g_e6_started) (wake e6_main))
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 4 ===========================================================================
;*
Several snipers are covering a Covenant held alleyway, which the player must
advance through.

Begins when the player enters the alleyway.
Ends when the player enters the neighborhood.

Marines
	e4_mars_inf0 - e3_mars_inf0
		(wait0) - Wait before second corner, clear of e4_cov_sniper0_1
		(wait1) - Wait before third corner, clear of e4_cov_sniper0_0
		(engage0) - Once snipers are dead, follow player, engage e4_cov_inf0

Covenant
	e4_cov_inf0_0 - Assorted Covenant infantry bunkering in the alleyway
	e4_cov_inf0_1 - Reinforcements
		(init) - Bunker in alleyway
		(regroup) - Regroup towards the end of the alleyway
	e4_cov_inf1 - Buggers moving along rooftops, dropping in from above
		(init) - Engaging the player from above
	e4_cov_sniper0_0 - Two snipers at end of street
		(init) - Sit and snipe
	e4_cov_sniper0_1 - Sniper above second corner
		(init) - Sit and snipe
	e4_cov_sniper0_2 - Sniper at perpendicular street
		(init) - Sit and snipe

Open Issues
- Jackals need to fire sniper rifle properly
- Need Covenant sniper rifle to accurately assess impact, balance
- ENV: Need to restore alley end sniper cover
- ENV: Need to change ramp/drain to stairs
- TODO: Damage permutes on railings

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e4_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e4_cov_snipers0_main
	(ai_place e4_cov_snipers0)
)

(script dormant e4_cov_inf1_main
	(sleep_until (volume_test_objects tv_e4_cov_inf1_main_begin (players)))
	(ai_place e4_cov_inf1)
)

(script dormant e4_cov_inf0_main
	(ai_place e4_cov_inf0_0)

	; Sleep until the player has moved up
;	(sleep_until (volume_test_objects tv_e4_player_moved_up (players)))
	
	; If we need reinforcements, place them
;	(ai_place e4_cov_inf0_1 (- 7 (ai_living_count e4_cov_inf0)))
)

(script dormant e4_mars_inf0_main
	; Sleep until the Marines are done fighting, in case the player is charging,
	; or timeout after two minutes, just in case
	(sleep_until 
		(and
			(<= (ai_living_count e3_cov_inf0) 5) 
			(<= (ai_fighting_count e3_cov_inf0) 0) 
		)
		15 
		3600
	)
	
	; Migrate the Marines over
	(ai_migrate e3_mars_inf0 e4_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e4_main
	(sleep_until (volume_test_objects tv_e4_main_begin (players)))
	(set g_e4_started true)
	(print "e4_main")
	(game_save)
	(garbage_collect_now)

	; Wake subsequent scripts
	(wake e5_main)

	; Wake control scripts
	(wake e4_mars_inf0_main)
	(wake e4_cov_inf0_main)
	(wake e4_cov_inf1_main)
	(wake e4_cov_snipers0_main)
	
	; Shut down
	(sleep_until g_e6_started)
	(sleep_forever e4_mars_inf0_main)
	(sleep_forever e4_cov_inf0_main)
	(sleep_forever e4_cov_inf1_main)
	(sleep_forever e4_cov_snipers0_main)
	
	; Clean up
	(sleep_until g_e7_started)
	(ai_erase e4_mars)
	(ai_erase e4_cov)
)

(script static void test_sniper_alley
	(object_teleport (player0) e4_test)
	(ai_place e4_mars_inf0)
	(if (not g_e4_started) (wake e4_main))

	; Get the other scripts running
	(if (not g_e6_started) (wake e6_main))
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 3 ===========================================================================
;*
An infantry squad is marching along below the highway, giving the player an
opportunity to hit them before they dig in.

Begins when the player approaches the highway.
Ends when the Covenant are dead.

Marines
	e3_mars_inf0 - e3_mars_inf0
		(wait) - Wait and watch until the player opens hostilities
		(attack0) - Attack the Covenant but stay clear of the sniper
		(attack1) - Attack more aggressively once the sniper is dead
		(rout) - Move in and mop up the remaining Covenant

Covenant
	e3_cov_inf0_0 - The marching infantry
		(init) - Head to and bunker at the first alley corner
		(cower) - Cower after being weakened
	e3_cov_inf0_1 - Sniper above the corner
		(init) - Stand and snipe
	e3_cov_ghosts0 - Flavor Ghosts on the highway

Open Issues
- Don't have real Grunt plasma turret
- AI can't move single file properly
- Don't have (cs_abort_on_fight ), so actors don't respond properly
- Uberchassis don't explode properly
- Need to call out sniper better
- CODE: Elites not driving Ghosts, flavor Ghosts cannot run command script

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e3_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e3_cov_inf0_0_entry
	(cs_go_to e3_cov_inf0_0_entry/p0)
	(cs_go_to e3_cov_inf0_0_entry/p1)
)

(script command_script cs_e3_cov_inf0_0_continue
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e3_cov_inf0_0_entry/p2)
	(ai_erase ai_current_actor)
)

(script command_script cs_e3_cov_inf0_0_abort
	(cs_abort_on_alert true)
)

(script command_script cs_e3_cov_ghosts0_driveby
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 3)
	(cs_go_to e3_cov_ghosts0_driveby/p0)
	(cs_go_to e3_cov_ghosts0_driveby/p1)
	(ai_erase ai_current_actor)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e3_cov_ghosts0_main
	(ai_place e3_cov_ghosts0)
	(cs_run_command_script e3_cov_ghosts0 cs_e3_cov_ghosts0_driveby)
)

(script dormant e3_cov_inf0_main
	; Place the Covenant, and tell the infantry to march
	(ai_place e3_cov_inf0)
	(cs_run_command_script e3_cov_inf0_0/elite1 cs_e3_cov_inf0_0_entry)
	(cs_queue_command_script e3_cov_inf0_0/elite0 cs_e3_cov_inf0_0_continue)
	(cs_run_command_script e3_cov_inf0_0/grunt0 cs_e3_cov_inf0_0_entry)
	(cs_run_command_script e3_cov_inf0_0/grunt1 cs_e3_cov_inf0_0_entry)
	(cs_run_command_script e3_cov_inf0_0/grunt2 cs_e3_cov_inf0_0_entry)
	
	; Abort command scripts if we have been alerted
	(sleep_until (>= (ai_combat_status e3_cov_inf0_0) ai_combat_status_active) 15)
	(cs_run_command_script e3_cov_inf0_0 cs_e3_cov_inf0_0_abort)
)

(script dormant e3_mars_inf0_main
	; Wait until the hunters are dead
	(sleep_until 
		(or
			(<= (ai_living_count e2_cov_hunters0) 0)
			(volume_test_objects tv_e3_crossing_street (players))
		)
		30
		one_minute
	)
	
	; Migrate in earlier squads
	(ai_migrate e2_mars_inf0 e3_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e3_main
	(sleep_until 
		(or
			(volume_test_objects tv_e3_main_begin0 (players))
			(volume_test_objects tv_e3_main_begin1 (players))
		)
	)
	(set g_e3_started true)
	(print "e3_main")
	(game_save)
	(garbage_collect_now)
	
	; Wake subsequent scripts
	(wake e4_main)
	(wake e6_main)

	; Wake control scripts
	(wake e3_mars_inf0_main)
	(wake e3_cov_inf0_main)
	(wake e3_cov_ghosts0_main)
	
	; Shut down
	(sleep_until (or g_e4_started g_e6_started))
	(sleep_forever e3_mars_inf0_main)
	(sleep_forever e3_cov_inf0_main)
	(sleep_forever e3_cov_ghosts0_main)
	
	; Clean up
	(sleep_until g_e7_started)
	(ai_erase e3_mars)
	(ai_erase e3_cov)
)

(script static void test_marching_infantry
	(object_teleport (player0) e3_test)
	(ai_place e3_mars_inf0)
	(if (not g_e3_started) (wake e3_main))

	; Get the other scripts running
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 2 ===========================================================================
;*
As the Eagle prepares to depart with Johnson, the player is beset by a pair of
Hunters, who smash through an adjacent building.

Begins when the player is near the Eagle.
Ends when the Hunters are dead.

Marines
	e2_mars_inf0 - e1_mars_inf0 + e1_mars_inf2
		(cower) - Cower from the two Hunters
		(follow) - Once the Hunters are dead, follow the player

Covenant
	e2_cov_hunters0 - The Hunters which smash through the building
		(init) - Engage the player
		(follow) - If the player charges past them, follow the player
	e2_cov_inf0 - Jackals blocking the escape route
		(init) - Bunker near the building exit
		(flee) - Run away once the Hunters are dead

Open Issues
- Hunters don't take real damage, can't balance encounter properly
- Don't have real holdfire style for Marines
- Hunters not fighting properly, spend too much time in melee animations
- ART: Don't have real door for Hunters to break in
- SOUND: Don't have real sounds for Hunters breaking in door

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e2_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e2_cov_hunters0_0_entry
	(cs_force_combat_status 2)
	(cs_ignore_obstacles true)
	(cs_abort_on_damage true)
	(cs_look_player true)
	(cs_go_to e2_cov_hunters0_entry/p0)
	(sleep_until 
		(or
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3.0) 
			(< (ai_strength ai_current_squad) 0.9) 
		)
		5
	)
)

(script command_script cs_e2_cov_hunters0_1_entry
	(cs_force_combat_status 2)
	(cs_ignore_obstacles true)
	(cs_abort_on_damage true)
	(cs_look_player true)
	(cs_go_to e2_cov_hunters0_entry/p1)
	(sleep_until 
		(or
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3.0) 
			(< (ai_strength ai_current_squad) 0.9) 
		)
		5
	)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e2_cov_inf0_main
	(ai_place e2_cov_inf0)
)

(script dormant e2_mars_inf0_main
	; Migrate squads into this one
	(ai_migrate e1_mars_inf0 e2_mars_inf0)
	(ai_migrate e1_mars_inf2 e2_mars_inf0)
	
	; Sleep until we have Hunters
	(sleep_until (> (ai_spawn_count e2_cov_hunters0) 0))
	
	; Make them aware of the Hunters
	(ai_magically_see e2_mars_inf0 e2_cov_hunters0)
)

(script dormant e2_cov_hunters0_main
	; Knock knock, destroy the wall
	(sleep 30)
	(effect_new "scenarios\test\earthcity\temp_junk\e2_wall_tap" e2_wall_tap)
	(sleep 60)
	(E2_CORTANA_10)
	(sleep 60)
	(effect_new "scenarios\test\earthcity\temp_junk\e2_wall_tap" e2_wall_tap)
	(sleep 160)
	(object_destroy e2_hunter_door)
	(sleep 1)
	(effect_new "scenarios\test\earthcity\temp_junk\e2_wall_breaker" e2_wall_breaker)
	(sound_impulse_start "sound\visual_effects\explosion_large_object_trail" e2_door 0.5)

	; Place the hunters and run their introduction command scripts
	(ai_place e2_cov_hunters0)
	(cs_run_command_script e2_cov_hunters0/hunter0 cs_e2_cov_hunters0_0_entry)
	(cs_run_command_script e2_cov_hunters0/hunter1 cs_e2_cov_hunters0_1_entry)
	
	; Make them disregard the Marines
	(ai_disregard (ai_actors e2_mars_inf0) true)
	
	; Have Cortana identify them
	(sleep 120)
	(E2_CORTANA_20)
	
	; Sleep until they're dead, regard the Marines (I butcher grammar)
	(sleep_until (<= (ai_living_count e2_cov_hunters0) 0))
	(ai_disregard (ai_actors e2_mars_inf0) false)
	
	; Try to sneak in a save point, too
	(game_save)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e2_main
	(set g_e2_started true)
	(print "e2_main")
	(game_save)
	(garbage_collect_now)
	
	; Change music
	(print "music: start")

	; Wake control scripts
	(wake e2_cov_hunters0_main)
	(wake e2_mars_inf0_main)
	(wake e2_cov_inf0_main)
	
	; Shut down
	(sleep_until g_e3_started)
	(sleep_forever e2_mars_inf0_main)
	(sleep_forever e2_cov_inf0_main)
	(sleep_forever e2_cov_hunters0_main)
	
	; Clean up
	(sleep_until g_e8_started)
	(ai_erase e2_mars)
	(ai_erase e2_cov)
)

(script static void test_hunter_intro
	(object_teleport (player0) e2_test)
	(ai_place e2_mars_inf0)
	(if (not g_e2_started) (wake e2_main))

	; Get the other scripts running
	(if (not g_e3_started) (wake e3_main))
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
	(if (not g_cinematic_bridge_started) (wake cinematic_bridge_main))
)


;= ENCOUNTER 1 ===========================================================================
;*
The Chief has crash landed in an old section of New Mombassa. He and several
Marines take refuge in a nearby building as the Covenant attack.

Begins at the start of the level.
Ends when Marines are evacuated.

Marines
	e1_mars_johnson - Johnson
		(init) - Sniping from the courtyard
		(advance0) - Moving onto the first tier once e1_cov_inf0 is weakened
		(advance1) - Moving onto the second tier once e1_cov_inf0 is dead
		(retreat0) - Retreating into the atrium when e1_cov_phantom0_1 arrives
	e1_mars_inf0 - ODSTs
		(init - Fighting from the courtyard
		(advance0) - Moving into the atrium
		(advance1) - Moving onto the first tier
		(advance2) - Defending on the second tier
		(retreat0) - Retreating into the atrium when e1_cov_phantom0_1 arrives
		(guard0) - Covering Johnson and pilots as they evac
	e1_mars_inf1 - Pelican pilots
		(init) - Fighting in the courtyard, cautious and sticking to the walls
		(advance0) - Moving into the atrium
		(advance1) - Defending on the first tier
	e1_mars_inf2 - Reinforcements riding on e1_mars_falcon0
		(init) - Covering Johnson and the pilots in the courtyard
	e1_mars_falcon0 - Falcon which drives off e1_cov_phantom0 and evacs Johnson

Covenant
	e1_cov_inf0 - Covenant initially defending building
		_0 - Grunts initially on the ground floor inside
			(init) - Defending the atrium
		_1 - Grunts initially on the first tier
			(init) - Defending the tier
			(retreat0) - Retreating into the atrium, first tier
		_2 - Elite and Grunts who spawn towards the back of the first tier
			(init) - Defending the first tier
			(retreat0) - Retreating onto the second tier, growing timid
	e1_cov_inf1 - Covenant wave which comes over the rooftops across street
		(init) - Engaging from the rooftops
		(retreat0) - Retreat after 30 seconds or a good beating
	e1_cov_inf2 - Waves of Covenant attacking across the street
		_0 - Elites and Grunts blasting out the front central door
		_1 - Elites and Jackals from the central back alcove
		_2 - Elites and Buggers over the rooftops
			(init) - Briefly firing from the rooftops before advancing
		_3 - Elites and Grunts from the left side street
		_4 - Elites and Buggers over the Hunter building
			(init) - Fighting in the courtyard before advancing
		_5 - Elites and Jackals from the courtyard
			(init) - Fighting in the courtyard before advancing
		_6 - Elites and Grunts dropping down into the alcove
			(engage0) - Engaging from the street
			(advance0) - Advancing into the atrium and first tier
		_7 - Buggers over the rooftops
			(init) - Firing from the rooftops before advancing
	e1_cov_inf3 - A wave of Covenant which attacks over the adjacent rooftops
		(init) - Briefly firing from the rooftops
		(advance0) - Dropping onto and fighting on the first tier
	e1_cov_inf4 - Covenant dropped off by and accompanying the Phantom
		_0 - Elites and Grunts dropped off by Phantom
		_1 - Elites and Jackals who enter from the crashed Pelican route
			(init) - Attacking into the atrium
			(advance0) - Advance aggressively if strong and after a time
			(retreat0) - Runaway!
	e1_cov_phantom0 - Phantoms which fly over and attack the atrium building
		_0 - A Phantom which just flies over
		_1 - The "same" Phantom, returned to engage the player
			(init) - Hovering over the courtyard, covering the atrium building

Open Issues
- Need flying vehicles to set up Phantom and Falcon correctly
- Need to supply more ammo here
- Elites come over rooftop too fast, fall to deaths
- ENV: Benches need hints set up so that the AI can pathfind correctly
- ENV: Need Pelican crash space so I can set up initial entry
- CODE: AI needs initial awareness off player so that they attack properly
- CODE: Need AI<->player weapon swapping
- CODE: Pathfinding around overhangs, or else I'll use nutblockers
- ART: Need real doors
- ART: Need Falcon, animations

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e1_started false)				; Encounter has been activated?

(global short g_e1_cov_inf2_spawned 0)			; How many waves have spawned?
(global short g_e1_cov_inf2_limit 0)			; How many waves to spawn?

(global boolean g_e1_hack_phantom_leaves false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e1_mars_johnson_falcon
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_mars_load_falcon/p0)
	(sleep 30000)
)

(script command_script cs_e1_mars_johnson_teleport
	(cs_teleport e1_mars_load_falcon/p0 e1_mars_load_falcon/p0)
)

(script command_script cs_e1_mars_inf1_falcon
	(cs_enable_pathfinding_failsafe true)
	; TODO: Make this real
	(cs_go_to e1_mars_load_falcon/p1)
	(ai_erase ai_current_actor)
)

(script command_script cs_e1_mars_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_go_to e1_mars_entry/p0)
)


;- Order Scripts ---------------------------------------------------------------
;- e1_cov_inf2 Respawner Support -----------------------------------------------

(script static boolean e1_cov_inf2_under_limit
	(< g_e1_cov_inf2_spawned g_e1_cov_inf2_limit)
)

(script static boolean e1_cov_inf2_spawn_ready
	(and
		(<= (ai_living_count e1_cov_inf2) 2)
		(<= (ai_fighting_count e1_cov_inf2) 0)
	)
)

(script static void e1_cov_inf2_7_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_4_unsafe (players)))
		(begin
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_7)
			(sleep 10)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_7)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Wait for the next wave
			(sleep_until (e1_cov_inf2_spawn_ready))
		)
	)
)

(script static void e1_cov_inf2_6_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_2_unsafe (players)))
		(begin
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_6)
			(sleep 10)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_6)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Wait for the next wave
			(sleep_until (e1_cov_inf2_spawn_ready))
		)
	)
)

(script static void e1_cov_inf2_5_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_5_unsafe (players)))
		(begin
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_5)
			(sleep 10)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_5)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Wait for the next wave
			(sleep_until (e1_cov_inf2_spawn_ready))
		)
	)
)

(script static void e1_cov_inf2_4_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_4_unsafe (players)))
		(begin
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_4)
			(sleep 10)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_4)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Wait for the next wave
			(sleep_until (e1_cov_inf2_spawn_ready))
		)
	)
)

(script static void e1_cov_inf2_3_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_3_unsafe (players)))
		(begin
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_3)
			(sleep 10)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_3)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Wait for the next wave
			(sleep_until (e1_cov_inf2_spawn_ready))
		)
	)
)

(script static void e1_cov_inf2_2_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_2_unsafe (players)))
		(begin
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_2)
			(sleep 10)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_2)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Wait for the next wave
			(sleep_until (e1_cov_inf2_spawn_ready))
		)
	)
)

(script static void e1_cov_inf2_1_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_1_unsafe (players)))
		(begin
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_1)
			(sleep 10)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_1)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Wait for the next wave
			(sleep_until (e1_cov_inf2_spawn_ready))
		)
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e1_cov_phantom0_main
	; Phantom overflight
	; TODO: Make this real
	(print "phantom flies overhead")
	(sleep 120)
	
	; Pause the script here. It will be restarted by e1_cov_inf2_main
	(sleep_forever)
	
	; Once it is reawakened, send in the Phantom
	; TODO: Make this real
	(print "phantom returns, flying in")
	(sleep 60)
	(ai_place e1_cov_phantom0_1)
	
	; Wait until the Phantom should leave
	; TODO: Make this real
	(sleep_until g_e1_hack_phantom_leaves 10)
	
	; Send the Phantom out
	(print "phantom limps away")
	(ai_braindead e1_cov_phantom0_1 true)
	(sleep 120)
	(ai_erase e1_cov_phantom0)
)

(script dormant e1_cov_inf4_main
	; Wait until e1_cov_phantom0_1 has been placed
	(sleep_until (> (ai_spawn_count e1_cov_phantom0_1) 0) 10)
	
	; Load up the first wave for the Phantom to drop off
	; TODO: Make this real
	(sleep 120)
	(ai_place e1_cov_inf4_0)
	
	; Wait until that group is dead, then spawn the next wave
	(sleep_until 
		(and
			(<= (ai_living_count e1_cov_inf4) 2)
			(<= (ai_fighting_count e1_cov_inf4) 0)
			(not (volume_test_objects tv_e1_cov_inf4_1_unsafe (players)))
		)
		30
		one_minute
	)
	(ai_place e1_cov_inf4_1 (- 6 (ai_living_count e1_cov_inf4)))
	
	; When the Phantom leaves, retreat
	; TODO: Make this real
	(sleep_until g_e1_hack_phantom_leaves 10)
	(ai_set_orders e1_cov_inf4 e1_cov_inf4_retreat0)
	
	; Delete them when it's convenient
	(sleep_until
		(and
			(volume_test_objects_all tv_e1_cov_inf4_retreat (ai_actors e1_cov_inf4))
			(not (volume_test_objects tv_e1_cov_inf4_1_unsafe (players)))
		)
		15
	)
	(ai_erase e1_cov_inf4)
)

(script dormant e1_cov_inf3_main
	(ai_place e1_cov_inf3)
)

(script dormant e1_cov_inf2_main
	(sleep_until 
		(and
			(<= (ai_living_count e1_cov_inf1) 1)
			(> (ai_spawn_count e1_cov_inf1) 0)
		)
		30
		1350	; Timeout after 45 seconds, just after inf1 retreats
	)
	
	; Send out the first group with a bang
	(effect_new "scenarios\test\earthcity\temp_junk\e2_wall_breaker" e1_door_breaker)
	(sound_impulse_start "sound\visual_effects\explosion_large_object_trail" e1_door 0.3)
	(sleep 30)
	(ai_place e1_cov_inf2_0)
	
	; Wait till we're ready to spawn waves
	(sleep_until (e1_cov_inf2_spawn_ready))
	(garbage_collect_now)
	
	; Set the wave count
	(set g_e1_cov_inf2_spawned 0)
	(set g_e1_cov_inf2_limit 1)
	(if (difficulty_heroic) (set g_e1_cov_inf2_limit 2))
	(if (difficulty_legendary) (set g_e1_cov_inf2_limit 3))
	
	; Spawn the waves
	(begin_random 
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_1_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_2_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_3_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_4_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_6_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_7_spawn))
	)
	
	; Wait till we're ready to spawn another wave
	(sleep_until (e1_cov_inf2_spawn_ready))
	(garbage_collect_now)
	
	; Send in the courtyard wave
	(e1_cov_inf2_5_spawn)
	
	; Wait till we're ready to spawn waves
	(sleep_until (e1_cov_inf2_spawn_ready))
	(garbage_collect_now)
	
	; Set the wave count
	(set g_e1_cov_inf2_spawned 0)
	(set g_e1_cov_inf2_limit 1)
	(if (difficulty_heroic) (set g_e1_cov_inf2_limit 2))
	(if (difficulty_legendary) (set g_e1_cov_inf2_limit 2))
	
	; Spawn the waves
	(begin_random 
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_1_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_2_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_3_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_4_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_6_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_7_spawn))
	)
	
	; Wait till we're ready to spawn another wave
	(sleep_until (e1_cov_inf2_spawn_ready))
	(garbage_collect_now)
	
	; Save first
	(game_save)
	(sleep 30)
	
	; Wake inf3 interlude
	(wake e1_cov_inf3_main)
	
	; Wait until inf3 interlude is finished
	(sleep_until 
		(and
			(> (ai_spawn_count e1_cov_inf3) 0)
			(<= (ai_living_count e1_cov_inf3) 2)
			(<= (ai_fighting_count e1_cov_inf3) 0)
		)
	)
	
	; Wake the Phantom interlude
	(wake e1_cov_phantom0_main)

	; Reset the wave count
	(set g_e1_cov_inf2_spawned 0)
	(set g_e1_cov_inf2_limit 2)
	(if (difficulty_heroic) (set g_e1_cov_inf2_limit 3))
	(if (difficulty_legendary) (set g_e1_cov_inf2_limit 4))

	; Spawn the waves
	(begin_random 
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_1_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_2_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_3_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_4_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_5_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_6_spawn))
	)
	
	; Reawaken the Phantom interlude and final infantry group
	(wake e1_cov_phantom0_main)
	(wake e1_cov_inf4_main)
)

(script dormant e1_cov_inf1_main
	(sleep_until 
		(and
			(> (ai_spawn_count e1_cov_inf0_2) 0)
			(<= (ai_living_count e1_cov_inf0) 1)
			(<= (ai_fighting_count e1_cov_inf0) 0)
		)
		30
	)
	
	; Pause to let the player catch his breath
	(sleep 120)
	
	; Place the infantry over the rooftops
	(ai_place e1_cov_inf1)
	(ai_magically_see e1_cov_inf1 e1_mars)
	
	; 45 seconds later, delete them
	(sleep 1350)
	(ai_erase e1_cov_inf1)
)

(script dormant e1_cov_inf0_main
	(ai_place e1_cov_inf0_0)
	(ai_place e1_cov_inf0_1)
	
	; Wait until the existing unit count is depleted or the player is charging
	(sleep_until 
		(or
			(<= (ai_living_count e1_cov_inf0) 1)
			(volume_test_objects tv_e1_cov_inf0_2_begin (players))
		)
		15
	)
	
	; Place the next group
	(ai_place e1_cov_inf0_2)
	(ai_magically_see e1_cov_inf0_2 e1_mars_inf0)

	; Wake the next squads
	(wake e1_cov_inf1_main)
	(wake e1_cov_inf2_main)
)

(script dormant e1_mars_falcon0_main
	; Wait until inf4 is finished
	(sleep_until 
		(and
			(> (ai_spawn_count e1_cov_inf4_1) 0)
			(<= (ai_living_count e1_cov_inf4_1) 2)
			(<= (ai_fighting_count e1_cov_inf4_1) 0)
		)
	)
	
	; Place the Falcon and send it in, shooting up the Phantom
	; TODO: Make this real
	(print "blam, something hits the Phantom")
	(sleep 90)
	(print "blam, something hits the Phantom")
	(set g_e1_hack_phantom_leaves true)	
	(print "falcon flies in")
	(sleep 150)
	(print "falcon has arrived")
	(object_create e1_mars_falcon0_temp)
	
	; TODO: Make this real
	(ai_place e1_mars_inf2 (- 3 (ai_living_count e1_mars_inf0)))
)

(script dormant e1_mars_inf1_main
	(ai_place e1_mars_inf1)
	
	; Sleep until the second Phantom has lived and died
	(sleep_until 
		(and
			(> (ai_spawn_count e1_cov_phantom0_1) 0)
			(<= (ai_living_count e1_cov_phantom0_1) 0)
		)
	)

	; Head out to the Falcon
	(cs_run_command_script e1_mars_inf1 cs_e1_mars_inf1_falcon)
)

(script dormant e1_mars_inf0_main
	(ai_place e1_mars_inf0)
	
	; Sleep until the second Phantom has lived and died
	(sleep_until 
		(and
			(> (ai_spawn_count e1_cov_phantom0_1) 0)
			(<= (ai_living_count e1_cov_phantom0_1) 0)
		)
	)

	; Take up guard positions on the tier
	(ai_set_orders e1_mars_inf0 e1_mars_inf0_guard0)
)

(script dormant e1_mars_johnson_main
	(ai_place e1_mars_johnson)
	(object_cannot_take_damage (ai_actors e1_mars_johnson))
	
	; Dialog
	(E1_JOHNSON_10)
	
	; Sleep until e1_cov_inf0 are dead or subdued
	(sleep_until 
		(and
			(> (ai_spawn_count e1_cov_inf0_2) 0)
			(<= (ai_living_count e1_cov_inf0) 1)
			(<= (ai_fighting_count e1_cov_inf0) 0)
		)
		30
	)
	
	; Dialog
	(E1_JOHNSON_20)
	
	; Sleep until the second Phantom returns
	(sleep_until (> (ai_spawn_count e1_cov_phantom0_1) 0))	

	; Dialog
	(sleep 60)
	(E1_JOHNSON_30)
	(sleep 60)
	(E1_MIRANDA_10)
	
	; Sleep until the second Phantom has lived and died
	(sleep_until 
		(and
			(> (ai_spawn_count e1_cov_phantom0_1) 0)
			(<= (ai_living_count e1_cov_phantom0_1) 0)
		)
	)

	; Head out to the Falcon
	(cs_run_command_script e1_mars_johnson cs_e1_mars_johnson_falcon)
	(E1_JOHNSON_40)
	
	; Wait until Johnson has arrived
	(sleep_until (volume_test_objects tv_e1_near_falcon (ai_actors e1_mars_johnson)) 15 one_minute)
	
	; If Johnson hasn't arrived yet (ie. we timed out), teleport him
	(if (not (volume_test_objects tv_e1_near_falcon (ai_actors e1_mars_johnson))) (cs_run_command_script e1_mars_johnson cs_e1_mars_johnson_teleport))
	
	; Johnson has his exchange with Miranda
	; TODO: Make all of this real
	(print "johnson and miranda discuss life")
	(sleep 150)
	(print "johnson decides to go camping.")
	
	; Johnson takes off
	(E1_JOHNSON_50)
	(sleep 30)
	(ai_erase e1_mars_johnson)
	(object_destroy e1_mars_falcon0_temp)
	
	; Wake the hunter encounter
	(wake e2_main)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e1_main
	(set g_e1_started true)
	(print "e1_main")
	
	; Wake subsequent scripts
;	e2_main awakened in e1_mars_johnson_main
	(wake e3_main)
	(wake e8_main)
	(wake e12_main)

	; Wake control scripts
	(wake e1_mars_johnson_main)
	(wake e1_mars_inf0_main)
	(wake e1_mars_inf1_main)
	(wake e1_cov_inf0_main)
	(wake e1_mars_falcon0_main)
	
	; Shut down
	(sleep_until g_e3_started)
	(sleep_forever e1_mars_johnson_main)
	(sleep_forever e1_mars_inf0_main)
	(sleep_forever e1_mars_inf1_main)
	(sleep_forever e1_mars_falcon0_main)
	(sleep_forever e1_cov_inf0_main)
	(sleep_forever e1_cov_inf1_main)
	(sleep_forever e1_cov_inf2_main)
	(sleep_forever e1_cov_inf3_main)
	(sleep_forever e1_cov_inf4_main)
	(sleep_forever e1_cov_phantom0_main)
	
	; Clean up
	(sleep_until (or g_e4_started g_e6_started))
	(ai_erase e1_mars)
	(ai_erase e1_cov)
)


;= MISSION MAIN ==========================================================================

(script dormant mission_start
	; Run the cinematics
	(cinematic_snap_to_black)
;	(cinematic_intro)
	(cinematic_fade_from_white)
	
	; Wake the cinematic scripts
	(wake cinematic_bridge_main)
	
	; Wake the first encounter
	(wake e1_main)
	
	; Wait for the mission to end
	(sleep_until g_mission_over 8)
	(cinematic_outro)
	(game_won)
)

(script static void start
	(wake mission_start)
)

(script startup mission_main
	; Necessary startup stuff
	(ai_allegiance player human)
	
	; Begin the mission
	; Comment this out when you're testing individual encounters
	(if (> (player_count) 0 ) (start))
)

