;= Globals =====================================================================

; Debugging
(global boolean debug true)

; Flags for Jaime
(global boolean global_core_intro false)
(global boolean global_core_perez false)
(global boolean global_core_sarge false)
(global boolean global_core_creeps false)
(global boolean global_core_phantom false)

; Stubs for Joe
(script stub void outro (print "STUB outro"))

; Stubs for me!
(script stub void e4_end (print "STUB e4_end"))


;= Cinematics Filth ============================================================

(script static void e3_451_ODST
	(sound_impulse_start sound\e3\dialog\E3_451_ODST (ai_get_object e1_mars_inf1/odst0) 1)	
	(print "ODST: Grunts down low!")
)

;*(script static void e7_470_ODST
	(sound_impulse_start sound\e3\dialog\E3_470_ODST (ai_get_object e1_mars_inf1/odst0) 1)	
	(print "ODST: Incoming!")
)*;

(script static void e7_531_ODST
	(sound_impulse_start sound\e3\dialog\E3_531_ODST none 1)	
	(print "ODST: Hostiles right!")
)

;*(script static void e7_532_ODST
	(sound_impulse_start sound\e3\dialog\E3_532_ODST (ai_get_object e1_mars_inf1/odst0) 1)	
	(print "ODST: They're flanking!")
)*;

;*(script static void e7_540_ODST
	(sound_impulse_start sound\e3\dialog\E3_540_ODST (ai_get_object e1_mars_inf1/odst0) 1)	
	(print "ODST: Jackals moving up!")
)*;

(script static void e5_572_ODST
	(sound_impulse_start sound\e3\dialog\E3_572_ODST (ai_get_object e1_mars_inf0/odst1) 1)	
	(print "ODST: Let's go! Move up!")
)

;*(script static void e7_580_ODST
	(sound_impulse_start sound\e3\dialog\E3_580_ODST (ai_get_object e1_mars_inf0/odst1) 1)	
	(print "ODST: Eyes front!")
)*;

(script static void e7_590_ODST
	(sound_impulse_start sound\e3\dialog\E3_590_ODST (ai_get_object e1_mars_inf0/odst1) 1)	
	(print "ODST: Fire in the hole! Tell Dave!")
)

(script static void e5_591_ODST
	(sound_impulse_start sound\e3\dialog\E3_591_ODST (ai_get_object e1_mars_inf0/odst1) 1)
	(print "ODST: Frag and clear!")
)

(script static void e5_592_ODST
	(sound_impulse_start sound\e3\dialog\E3_592_ODST (ai_get_object e1_mars_inf0/odst1) 1)
	(print "ODST: Clean it out!")
)

(script static void e7_601_ODST
	(sound_impulse_start sound\e3\dialog\E3_601_ODST (list_get (ai_actors e7_mars_odst_cameo) 0) 1)	
	(print "ODST: Go, Sir! We got your back!")
)

(script static void e7_610_DRIVER
	(sound_impulse_start sound\e3\dialog\E3_610_DRIVER (ai_get_object e7_mars_warthog0/driver) 1)
	(print "DRIVER: I could use a gunner, Sir!")
)

(script static void e7_620_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_620_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: C'mon baby, we're gonna lose 'em!")
)

(script static void e7_630_DRIVER
	(sound_impulse_start sound\e3\dialog\E3_630_DRIVER (ai_get_object e7_mars_warthog0/driver) 1)	
	(print "DRIVER: Take the shot!")
)

(script static void e7_640_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_640_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: Go around!")
)

(script static void e7_650_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_650_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: That's the way, yeah!")
)

(script static void e7_651_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_651_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: Boom, baby!")
)

(script static void e8_661_DRIVER
	(sound_impulse_start sound\e3\dialog\E3_661_DRIVER (ai_get_object e7_mars_warthog0/driver) 1)
	(print "DRIVER: You keeping score?")
)

(script static void e8_662_DRIVER
	(sound_impulse_start sound\e3\dialog\E3_662_DRIVER (ai_get_object e7_mars_warthog0/driver) 1)
	(print "DRIVER: That better buff out!")
)

(script static void e8_663_DRIVER
	(sound_impulse_start sound\e3\dialog\E3_663_DRIVER (ai_get_object e7_mars_warthog0/driver) 1)
	(print "DRIVER: Man, I just washed this thing!")
)

(script static void e8_671_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_671_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: That's one!")
)

(script static void e8_672_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_672_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: That's two!")
)

(script static void e8_673_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_673_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: Who's for more!")
)

(script static void e8_680_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_680_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: Ghosts! Making a break for it!")
)

(script static void e8_690_DRIVER
	(sound_impulse_start sound\e3\dialog\E3_690_DRIVER (ai_get_object e7_mars_warthog0/driver) 1)
	(print "DRIVER: I got em!")
)

(script static void e8_700_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_700_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: You trying to get us killed?")
)

(script static void e8_705_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_705_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: You wanna let me drive?")
)

(script static void e8_710_COR
	(sound_impulse_start sound\e3\dialog\E3_710_COR none 1)	
	(print "CORTANA: A Phantom!")
)

(script static void e8_720_DRIVER
	(sound_impulse_start sound\e3\dialog\E3_720_DRIVER (ai_get_object e7_mars_warthog0/driver) 1)
	(print "DRIVER: Hang on!")
)

(script static void e9_730_COR
	(sound_impulse_start sound\e3\dialog\E3_730_COR none 1)	
	(print "CORTANA: Look out!")
)

(script static void e9_740_DRIVER
	(sound_impulse_start sound\e3\dialog\E3_740_DRIVER (ai_get_object e7_mars_warthog0/driver) 1)
	(print "DRIVER: Agh!")
)

(script static void e9_750_PASSENGER
	(sound_impulse_start sound\e3\dialog\E3_750_PASSENGER (ai_get_object e7_mars_warthog0/passenger) 1)
	(print "PASSENGER: Uhn!")
)

(script static void e10_760_COR
	(sound_impulse_start sound\e3\dialog\E3_760_COR none 1)
	(print "CORTANA: Brutes!")
)

(script static void e10_770_COR
	(sound_impulse_start sound\e3\dialog\E3_770_COR none 1)
	(print "CORTANA: Ghosts! To your right!")
)

(script static void e10_771_COR
	(sound_impulse_start sound\e3\dialog\E3_771_COR none 1)
	(print "CORTANA: Wait for it...")
)

(script static void e10_772_COR
	(sound_impulse_start sound\e3\dialog\E3_772_COR none 1)
	(print "CORTANA: Nice!")
)

(script static void e10_780_COR
	(sound_impulse_start sound\e3\dialog\E3_780_COR none 1)
	(print "CORTANA: See if you can draw them off.")
)

(script static void e10_790_COR
	(sound_impulse_start sound\e3\dialog\E3_790_COR none 1)
	(print "CORTANA: The Marines won't stand a chance...")
)


;= Generic Command Scripts =====================================================

(script command_script cs_just_die
	(cs_die 0)
)


;- Generic Scripts -------------------------------------------------------------

(script continuous warthog0_safety_net
	; Sleep a moment
	(sleep 5)
	
	; If the player isn't in his vehicle, fix that
	(vehicle_load_magic (ai_vehicle_get e7_mars_warthog0/driver) "warthog_g" (player0))
)


;= Outro =======================================================================
;- Init ------------------------------------------------------------------------

(script dormant outro_init
	; Spew
	(sleep_until (volume_test_objects tv_outro_start (players)) 5)
	(garbage_collect_now)
	(if debug (print "outro_init"))
	
	; Run Joe's outro
	(outro)
)


;= e10 - Ghost Jacking =========================================================
;- Globals ---------------------------------------------------------------------

(global boolean g_e10_player_killed_two_brutes false)
(global boolean g_e10_player_has_boarded false)
(global boolean g_e10_phantom_should_move false)
(global vehicle g_e10_jacked_ghost_hack chief_ghost)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e10_player_has_boarded
	(= g_e10_player_has_boarded true)
)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e10_ghost0_entry
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_face_player true) 
	(cs_go_to e10_ghosts_entry/jack_me 1.0)
	(sleep 32000)
)

(script command_script cs_e10_ghost0_jacked
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e10_ghosts_entry/riding1 1.0)
	(cs_go_to e10_ghosts_entry/riding2 0.0)
)

(script command_script cs_e10_ghost1_entry
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_targeting true)
	(cs_shoot true)
	(cs_go_to e10_ghosts_entry/p0 1.0)
	(cs_go_to e10_ghosts_entry/p1 1.0)
	(cs_go_to e10_ghosts_entry/p2 1.0)
	(cs_go_to e10_ghosts_entry/p3 1.0)
)

(script command_script cs_e10_phantom0_entry
	(cs_vehicle_speed 0.6)
	(cs_fly_to_and_face e10_phantom0_entry/p0 e10_phantom0_entry/p1_facing)
	(cs_fly_to_and_face e10_phantom0_entry/p1 e10_phantom0_entry/p1_facing)
	(cs_pause 5.0)
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)
	(sleep_until g_e10_phantom_should_move 5)
	(vehicle_hover (ai_vehicle_get ai_current_actor) false)
	(cs_face true e10_phantom0_entry/p2_facing)
	(cs_fly_to e10_phantom0_entry/p2)
	(cs_pause 5.0)
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)
)

(script command_script cs_e10_phantom0_gunner
	(cs_shoot false)
	(cs_enable_targeting false)
	(sleep_until g_e10_player_has_boarded)
	(sleep 45)
	(ai_magically_see_object ai_current_squad (player0))
)


;- Action ----------------------------------------------------------------------

(script dormant e10_jacking_cymbals
	; Love adding stuff like this post RC
	(player_action_test_reset)
	(sleep_until (player_action_test_jump) 2)
	(sleep 25)
	(sound_looping_start sound\e3\music\brute_cymbal_2\brute_cymbal_2 none 1)	
)

(script dormant e10_ghost_jacking
	; Ghost warning
	(e10_770_COR)
	
	; Mr. McHackenheimer is in da haus!
	(sleep_until
		(<= (objects_distance_to_object (player0) (ai_vehicle_get e10_cov_ghosts0/driver0)) 10)
		1		; Test reeeealy fast
	)
	
	; Cortana starts bitchin'...
	(e10_771_COR)
	
	; Sleep until we're even closer
	(sleep_until
		(<= (objects_distance_to_object (player0) (ai_vehicle_get e10_cov_ghosts0/driver0)) 2.5)
		1		; Test reeeealy fast
	)
	
	; Get the ghost
	(set g_e10_jacked_ghost_hack (ai_vehicle_get e10_cov_ghosts0/driver0))

	; Slam the player in, change the brute's command script
	(vehicle_load_magic g_e10_jacked_ghost_hack "ghost_b_l" (player0))

	; Wake the cymbals script
	(wake e10_jacking_cymbals)

	; Dialog
	(sleep 15)
	(e10_772_COR)

	; Sleep then run a command script
	(cs_run_command_script e10_cov_ghosts0/driver0 cs_e10_ghost0_jacked)

	; Make note of our success
	(set g_e10_phantom_should_move true)
	
	; Sleep until we're in the driver's seat
	(sleep_until (vehicle_test_seat g_e10_jacked_ghost_hack "ghost_d" (player0)) 5)
	
	; Make note of our success
	(set g_e10_player_has_boarded true)
	
	; Dialog
	(sleep 20)
	(e10_790_COR)
	(sleep 80)
	(e10_780_COR)
)


;- Setup -----------------------------------------------------------------------

(script static void e10_setup
	;PREDICTION grunts and jackals
	(object_type_predict objects\vehicles\phantom\phantom)
	(object_type_predict objects\characters\brute\brute)
	;END PREDICTION

	; Place the AI
	(ai_place e10_cov_phantom0)
	(ai_place e10_cov_ghosts0)
	(sleep 5)
	
	; Load the Phantom's gunner
	(vehicle_load_magic (ai_vehicle_get e10_cov_phantom0/driver) "phantom_g_r" (ai_actors e10_cov_phantom0/gunner))
		
	; Render the player's ghost invincible
	(object_cannot_take_damage (ai_vehicle_get e10_cov_ghosts0/driver0))
	
	; Command scripts
	(cs_run_command_script e10_cov_phantom0/driver cs_e10_phantom0_entry)
	(cs_run_command_script e10_cov_phantom0/gunner cs_e10_phantom0_gunner)
	(cs_run_command_script e10_cov_ghosts0/driver0 cs_e10_ghost0_entry)
	(cs_run_command_script e10_cov_ghosts0/driver1 cs_e10_ghost1_entry)
	
	; Wake actions
	(wake e10_ghost_jacking)
)

(script static void e10_cleanup
	; Delete the AI
	(ai_erase e10_cov)
)


;- Init ------------------------------------------------------------------------

(script dormant e10_init
	; Spew
	(sleep_until (volume_test_objects tv_e10_init (players)))
	(sleep_until g_e10_player_killed_two_brutes 5 1350)							; Can timeout
	(sleep_until (objects_can_see_object (player0) e10_triggger_car 15.0))	; I spel gud
	(garbage_collect_now)
	(if debug (print "e10_init"))

	; Run scripts
	(e10_setup)
	
	; Cleanup
	(sleep_until (volume_test_objects tv_outro_start (players)))
	(sleep 30)
	(e10_cleanup)
)

(script static void e10_test
	(e10_cleanup)
	(sleep 5)
	(e10_setup)
)


;= e9 - Brute Ambush ===========================================================
;- Order Scripts ---------------------------------------------------------------
;- Command Scripts -------------------------------------------------------------

(script command_script cs_e9_cov_brute_charge
	(cs_abort_on_damage true)
	(cs_go_to e9_brute_charge/p0)
)

(script command_script cs_e9_cov_brute_charge1
	(cs_abort_on_damage true)
	(cs_go_to e9_brute_charge/p1)
)

(script command_script cs_e9_cov_brute2_left
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_targeting true)
	(cs_shoot true)
	(cs_go_to e9_brute_charge/flank_left)
)

(script command_script cs_e9_cov_brute2_right
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_targeting true)
	(cs_shoot true)
	(cs_go_to e9_brute_charge/flank_right)
)

(script command_script cs_e9_cov_brute2_center
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_targeting true)
	(cs_shoot true)
	(cs_go_to e9_brute_charge/center)
	(sleep 32000)
)

(script command_script cs_e9_cov_brute2_abort
	(cs_crouch false)
)

(script command_script cs_e9_brute_driver_melee
	; Hit on frame 29
	(cs_custom_animation "objects\characters\brute\brute" "warthog_b_hood:d_melee" 1.0 true)
)

(script command_script cs_e9_brute_passenger_melee
	; Hit on frame 18
	(cs_custom_animation "objects\characters\brute\brute" "warthog_b_hood:p_melee" 1.0 true)
)


;- Action ----------------------------------------------------------------------

(script dormant e9_send_in_the_brutes
	; Wait until we have SOME fighters...
	(sleep_until (> (ai_living_count e9_cov_brute_fighting_player) 0))
	
	; Wash, rise, repeat
	(sleep_until (<= (ai_living_count e9_cov_brute_fighting_player) 0) 5 300)
	(cs_run_command_script e9_cov_brutes2/brute2 cs_e9_cov_brute_charge)
	(ai_migrate e9_cov_brutes2/brute2 e9_cov_brute_fighting_player)	; Brute on the first warthog's hood
	(ai_set_orders e9_cov_brute_fighting_player e9_cov_brute_fight_player)
	(if (< (ai_living_count e9_cov_brutes) 4) (ai_place e9_cov_brutes3) )	; Replenish stocks
	
	(sleep_until (<= (ai_living_count e9_cov_brute_fighting_player) 0) 5 300)
	(cs_run_command_script e9_cov_brutes1/brute0 cs_e9_cov_brute_charge1)
	(ai_migrate e9_cov_brutes1/brute0 e9_cov_brute_fighting_player)	; Brute on the second warthog's hood
	(ai_set_orders e9_cov_brute_fighting_player e9_cov_brute_fight_player)
	(if (< (ai_living_count e9_cov_brutes) 4) (ai_place e9_cov_brutes3) )	; Replenish stocks
	
	; We can send in the ghosts now
	(set g_e10_player_killed_two_brutes true)
	
	; Continue sending in brutes
	(sleep_until (<= (ai_living_count e9_cov_brute_fighting_player) 0) 5 300)
	(cs_run_command_script e9_cov_brutes1/brute1 cs_e9_cov_brute_charge1)
	(ai_migrate e9_cov_brutes1/brute1 e9_cov_brute_fighting_player)
	(ai_set_orders e9_cov_brute_fighting_player e9_cov_brute_fight_player)
	(if (< (ai_living_count e9_cov_brutes) 4) (ai_place e9_cov_brutes3) )	; Replenish stocks

	(sleep_until (<= (ai_living_count e9_cov_brute_fighting_player) 0) 5 300)
	(cs_run_command_script e9_cov_brutes2/brute1 cs_e9_cov_brute_charge)
	(ai_migrate e9_cov_brutes2/brute1 e9_cov_brute_fighting_player)	; Brute on the second warthog's gunner
	(ai_set_orders e9_cov_brute_fighting_player e9_cov_brute_fight_player)
	(if (< (ai_living_count e9_cov_brutes) 4) (ai_place e9_cov_brutes3) )	; Replenish stocks
	
	(sleep_until (<= (ai_living_count e9_cov_brute_fighting_player) 0) 5 300)
	(cs_run_command_script e9_cov_brutes2/brute0 cs_e9_cov_brute_charge)
	(ai_migrate e9_cov_brutes2/brute0 e9_cov_brute_fighting_player)
	(ai_set_orders e9_cov_brute_fighting_player e9_cov_brute_fight_player)
	(if (< (ai_living_count e9_cov_brutes) 4) (ai_place e9_cov_brutes3) )	; Replenish stocks
)

(script dormant e9_dialog
	;TODO fix hacks
	(e9_730_COR)
	
	(sleep 20)
	
	(object_create_anew boarder_brute0)
	(objects_attach (ai_vehicle_get e7_mars_warthog0/driver) "board hood" boarder_brute0 "")
	(custom_animation boarder_brute0 objects\characters\brute\brute "w_hood_stand_idle" false)
	
	(object_create_anew boarder_brute1)
	(objects_attach (ai_vehicle_get e8_mars_warthog1/driver) "board hood" boarder_brute1 "")
	(custom_animation boarder_brute1 objects\characters\brute\brute "w_hood_stand_idle" false)
	
	(object_create_anew boarder_brute2)
	(objects_attach (ai_vehicle_get e8_mars_warthog2/driver) "board hood" boarder_brute2 "")
	(custom_animation boarder_brute2 objects\characters\brute\brute "w_hood_stand_idle" false)
	
	(sleep 8)
	(e9_740_DRIVER)
	(cs_run_command_script e7_mars_warthog0/passenger cs_just_die)
	(cs_run_command_script e8_mars_warthog1/gunner cs_just_die)
	(sleep 10)
	(e9_750_PASSENGER)
)

(script dormant e9_brutes0_main
	; Sleep to make us sync with the other brutes
	(sleep 190)
	
	; Disengage the safety net
	(sleep_forever warthog0_safety_net)
	
	; What the hell, delete something
	(object_destroy_containing "e9_scenery_pb")

	; Place the brutes
	(ai_place e9_cov_brutes0)
	(object_cannot_take_damage (ai_actors e9_cov_brutes0))

	; Load them
	(vehicle_load_magic e9_phantom0 "phantom_p_r05" (ai_actors e9_cov_brutes0/brute0))	
	(object_set_shadowless (ai_get_object e9_cov_brutes0/brute0) true)
	
	; Sleep until we drop on the player
	(sleep_until (volume_test_objects tv_e9_warthog0_jackable (ai_vehicle_get e7_mars_warthog0/driver)) 5)

	; Drop the brutes
	(ai_exit_vehicle e9_cov_brutes0/brute0)
	
	; Sleep until Brute0 out of the vehicle
	(sleep_until (not (vehicle_test_seat_list e9_phantom0 "phantom_p_r05" (ai_actors e9_cov_brutes0/brute0))) 2)
	
	; Dialog, pause
	(e9_730_COR)
	(sleep 10)
	
	; Load him, bring in the camera
	(vehicle_load_magic (ai_vehicle_get e7_mars_warthog0/driver) "warthog_b_hood" (ai_actors e9_cov_brutes0/brute0))
	(sound_looping_start sound\e3\music\brute_cymbal_1\brute_cymbal_1 none 1)	
	(object_set_shadowless (ai_get_object e9_cov_brutes0/brute0) false)
	(sleep 10)
	(unit_set_prefer_tight_camera_track (ai_vehicle_get e7_mars_warthog0/driver) true)
	(sleep 20)

	; Pause, then kill the passenger
	(cs_run_command_script e9_cov_brutes0/brute0 cs_e9_brute_passenger_melee)
	(sleep 18)	; 18 ticks till he connects
	(e9_750_PASSENGER)	; Dialog
	(unit_exit_vehicle (ai_get_unit e7_mars_warthog0/passenger) 2)

	; Ride it to the end
	(sleep_until (volume_test_objects tv_e9_warthog0_end (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	
	;PREDICTION grunts and jackals
	(object_type_predict objects\weapons\rifle\battle_rifle\battle_rifle)
	(object_type_predict objects\weapons\rifle\dual_smg\dual_smg\battle_rifle)
	(object_type_predict objects\charaters\masterchief\fp\fp)
	 ;END PREDICTION

	; Pause, then kill the driver, unload the Chief
	(cs_run_command_script e9_cov_brutes0/brute0 cs_e9_brute_driver_melee)

	; Unload the Chief
	(sleep 10)
	(unit_exit_vehicle (unit (player0)))
	
	; 10 + 19 = 29 ticks till he connect
	(sleep 19)
	(e9_740_DRIVER)
	(unit_exit_vehicle (ai_get_unit e7_mars_warthog0/driver) 2)
	(object_can_take_damage (ai_actors e9_cov_brutes0))

	; Pause, then exit the Brute
	(sleep 70)
	(unit_exit_vehicle (ai_get_unit e9_cov_brutes0/brute0))

	; Immediately load this brute into the Brute Fung Ku encounter
	(ai_migrate e9_cov_brutes0/brute0 e9_cov_brute_fighting_player)
	(ai_set_orders e9_cov_brute_fighting_player e9_cov_brute_fight_player)
)

(script dormant e9_brutes1_main
	; Sleep until we can jack the Warthog
	(sleep_until (volume_test_objects tv_e9_warthog0_jackable (ai_vehicle_get e8_mars_warthog1/driver)) 5)

	; Place the Brutes
	(ai_place e9_cov_brutes1)
	(sleep 5)
	
	; Load the warthogs, artlessly
	(vehicle_load_magic (ai_vehicle_get e8_mars_warthog1/driver) "warthog_b_hood" (ai_actors e9_cov_brutes1/brute0))

	; Sleep until we've arrived
	(sleep_until (volume_test_objects tv_e9_warthog1_end (ai_vehicle_get e8_mars_warthog1/driver)) 5 300)

	; Exit the vehicle
	(unit_exit_vehicle (ai_get_unit e9_cov_brutes1/brute0))
	(sleep 1)
	
	; Kill the human vermin
	(ai_kill e8_mars_warthog1)
)

(script dormant e9_brutes2_main
	; Place the brutes, make them invincible
	(ai_place e9_cov_brutes2)
	(object_cannot_take_damage (ai_actors e9_cov_brutes2/brute0))
	(object_cannot_take_damage (ai_actors e9_cov_brutes2/brute1))
	(object_cannot_take_damage (ai_actors e9_cov_brutes2/brute2))
	(object_cinematic_collision (ai_get_object e9_cov_brutes2/brute0) true)
	(object_cinematic_collision (ai_get_object e9_cov_brutes2/brute1) true)
	(object_cinematic_collision (ai_get_object e9_cov_brutes2/brute2) true)
	(sleep 5)

	; Load them
	(vehicle_load_magic e9_phantom0 "phantom_p_l06" (ai_actors e9_cov_brutes2/brute1))	
	(vehicle_load_magic e9_phantom0 "phantom_p_r06" (ai_actors e9_cov_brutes2/brute2))	
	(object_set_shadowless (ai_get_object e9_cov_brutes2/brute1) true)
	(object_set_shadowless (ai_get_object e9_cov_brutes2/brute2) true)

	; Wait for the dropship to arrive
	(sleep 200)

	; PVS hack
	(object_pvs_clear)

	; Load the third brute
	(vehicle_load_magic e9_phantom0 "phantom_p_l05" (ai_actors e9_cov_brutes2/brute0))	
	
	; Drop the first two brutes, wait a sec, and drop the next
	(ai_exit_vehicle e9_cov_brutes2/brute1)
	(ai_exit_vehicle e9_cov_brutes2/brute2)
	
	; Send the two Brutes to the sides
	(cs_run_command_script e9_cov_brutes2/brute1 cs_e9_cov_brute2_left)
	(cs_run_command_script e9_cov_brutes2/brute2 cs_e9_cov_brute2_right)

	; Drop the boarder
	(sleep 8)
	(ai_exit_vehicle e9_cov_brutes2/brute0)
	(cs_run_command_script e9_cov_brutes2/brute0 cs_e9_cov_brute2_center)
	
	; Restore shadows
	(object_set_shadowless (ai_get_object e9_cov_brutes2/brute1) false)
	(object_set_shadowless (ai_get_object e9_cov_brutes2/brute2) false)

	; Dialog 
	(sleep 20)
	(e10_760_COR)	; Brutes!

	; Sleep until close, board vehicle
	(sleep_until
		(<= (objects_distance_to_object (ai_actors e9_cov_brutes2/brute0) (ai_vehicle_get e8_mars_warthog2/driver)) 2)
		1
	)
	
	; Abort all command scripts
	(cs_run_command_script e9_cov_brutes2/brute0 cs_e9_cov_brute2_abort)
	
	; Load him, make him vulnerable
	(vehicle_load_magic (ai_vehicle_get e8_mars_warthog2/driver) "warthog_b_hood" (ai_actors e9_cov_brutes2/brute0))
	(object_can_take_damage (ai_actors e9_cov_brutes2/brute0))
	(object_can_take_damage (ai_actors e9_cov_brutes2/brute1))
	(object_can_take_damage (ai_actors e9_cov_brutes2/brute2))
	(object_cinematic_collision (ai_get_object e9_cov_brutes2/brute0) false)
	(object_cinematic_collision (ai_get_object e9_cov_brutes2/brute1) false)
	(object_cinematic_collision (ai_get_object e9_cov_brutes2/brute2) false)

	; Kill the gunner
	(sleep 10)
	(ai_kill e8_mars_warthog2/gunner)
	
	; Wait until arrival, then kill the driver
	(sleep_until (volume_test_objects tv_e9_warthog2_dies (ai_vehicle_get e8_mars_warthog2/driver)) 5)
	
	; Swing, and connect
	(cs_run_command_script e9_cov_brutes2/brute0 cs_e9_brute_driver_melee)
	(sleep 29)	; 29 ticks till he connect
	(unit_exit_vehicle (ai_get_unit e8_mars_warthog2/driver) 2)
	
	; Wait a moment, then exit
	(sleep 15)
	(unit_exit_vehicle (ai_get_unit e9_cov_brutes2/brute0))
)

(script dormant e9_cov_phantom_overflight
	; PVS hack
	(object_pvs_set_object e9_pvs_hack)
	
	; Place the AI
	(ai_place e9_cov_phantom0)

	; Place the dropship
	(object_create_anew e9_phantom0)
	(object_cannot_take_damage e9_phantom0)
	(vehicle_hover e9_phantom0 true)
	(sleep 5)
	
	; Load them
	(vehicle_load_magic e9_phantom0 "phantom_d" (ai_actors e9_cov_phantom0/driver))
	(vehicle_load_magic e9_phantom0 "phantom_g_r" (ai_actors e9_cov_phantom0/gunner))
	
	; Run the custom animation
	(custom_animation e9_phantom0 "objects\vehicles\phantom\animations\E3\e3" "phantom02pass" false)
	(vehicle_engine_hack e9_phantom0 true 1.0)

	; Neuter the gunner
	(cs_run_command_script e9_cov_phantom0/gunner cs_e10_phantom0_gunner)
	
	; Throttle off
	(sleep 360)
	(vehicle_engine_hack e9_phantom0 true 0.25)
)


;- Setup -----------------------------------------------------------------------
;- Init ------------------------------------------------------------------------

(script static void e9_cleanup
	; Erase AI
	(ai_erase e9_cov)
	
	; Erase objects
	(object_destroy e9_phantom0)
)

(script dormant e9_init
	; Spew
	(sleep_until (volume_test_objects tv_e9_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)
	(if debug (print "e9_init"))

	; FLAG for Jaime
	(set global_core_phantom true)

	; Make the Warthogs damageable again
	; TODO position this better
	(object_can_take_damage (ai_actors e7_mars_warthog0))
	(object_can_take_damage (ai_vehicle_get e7_mars_warthog0/driver))
	(unit_impervious (ai_vehicle_get e7_mars_warthog0/driver) false)

	; Wake encounter scripts
	(wake e9_send_in_the_brutes)
	(wake e9_cov_phantom_overflight)
	
	; Run brute scripts
	(wake e9_brutes0_main)
	(wake e9_brutes1_main)
	(wake e9_brutes2_main)
	
	; Cleanup
	(sleep_until (volume_test_objects tv_outro_start (players)))
	(sleep 30)
	(e9_cleanup)
)


;= e8 - Vehicle Skirmish =======================================================
;- Globals ---------------------------------------------------------------------

(global boolean e8_warthog1_should_continue false)		; Teleport ahead and rendezvous
(global boolean e8_warthog1_should_follow false)		; Fall in behind the player's Warthog 0
(global long g_e8_warthog0_kills 0)							; How many kills the warthog has at the start of e8


;- Order Scripts ---------------------------------------------------------------

(script command_script cs_e8_warthog0_start
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_and_face e8_warthog0_rail_start/p0 e8_warthog0_rail_start/p0_facing)
	(cs_go_to e8_warthog0_rail_start/p1 1.0)
	(cs_go_to_and_face e8_warthog0_rail_start/p2 e8_warthog0_rail_start/p3)
	(cs_go_to e8_warthog0_rail_start/p3 1.0)
	(cs_pause 32000)
)

(script command_script cs_e8_warthog0_cont
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_and_face e8_warthog0_rail_cont/p0 e8_warthog0_rail_cont/p0_facing)
	
	; Slip in a line of dialog
	(e8_705_PASSENGER)
	
	; Continue
	(cs_go_to_and_face e8_warthog0_rail_cont/p1 e8_warthog0_rail_cont/p1_facing)
	(cs_go_to_and_face e8_warthog0_rail_cont/p2 e8_warthog0_rail_cont/p2_facing)
	(cs_go_to_and_face e8_warthog0_rail_cont/p3 e8_warthog0_rail_cont/p3_facing)
	(cs_go_to_and_face e8_warthog0_rail_cont/p4 e8_warthog0_rail_cont/p4_facing)
	(cs_go_to_and_face e8_warthog0_rail_cont/p5 e8_warthog0_rail_cont/p6)
;	(cs_go_to_and_face e8_warthog0_rail_cont/p6 e8_warthog0_rail_cont/p7)
	(cs_go_to_and_face e8_warthog0_rail_cont/p7 e8_warthogs_to_brutes/p0)
	
	; Move over to the common end
	(cs_go_to_and_face e8_warthogs_to_brutes/p0 e8_warthogs_to_brutes/p0_facing)
	(cs_go_to_and_face e8_warthogs_to_brutes/p1 e8_warthogs_to_brutes/p2)
	(cs_go_to_and_face e8_warthogs_to_brutes/p2 e8_warthogs_to_brutes/p3)
	(cs_go_to_and_face e8_warthogs_to_brutes/p3 e8_warthogs_to_brutes/p4)
	(cs_go_to_and_face e8_warthogs_to_brutes/p4 e8_warthogs_to_brutes/p4_facing)
	(cs_go_to_and_face e8_warthogs_to_brutes/p5 e8_warthogs_to_brutes/p6)
	(cs_go_to e8_warthogs_to_brutes/p6 1.0)
)

(script command_script cs_e8_warthog0_end
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e8_warthog_finales/player_0 1.0)
	(cs_go_to e8_warthog_finales/player_1 1.0)
	(cs_go_to e8_warthog_finales/player_2 1.0)
)

(script command_script cs_e8_warthog1_start
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed_instantaneous 8.0)			; hack
	(cs_go_to e8_warthog1_rail_start/hack 1.0)	; hack
	(cs_vehicle_speed 1.0)								; hack
	(cs_go_to_and_face e8_warthog1_rail_start/p0 e8_warthog1_rail_start/p1)
	(cs_go_to e8_warthog1_rail_start/p1_1 0.5)
	(cs_go_to_and_face e8_warthog1_rail_start/p2 e8_warthog1_rail_start/p3)
	(cs_go_to e8_warthog1_rail_start/p3 0.0)
	(cs_pause 32000)
)

(script command_script cs_e8_warthog1_cont
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_teleport e8_warthog1_rail_cont/p0 e8_warthog1_rail_cont/p0_facing)
	(cs_vehicle_speed_instantaneous 2.0)				; hack
	(cs_go_to e8_warthog1_rail_cont/hack 1.0)			; hack
	(cs_vehicle_speed 1.0)									; hack
	(cs_go_to_and_face e8_warthog1_rail_cont/p1 e8_warthog1_rail_cont/p1_facing)
	(cs_pause 3.0)
	
	; Pause me
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)
)

(script command_script cs_e8_warthog1_end
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_pause 1.75)
	(object_can_take_damage (ai_actors ai_current_actor))
	(object_can_take_damage (ai_vehicle_get ai_current_actor))
	(cs_go_to_and_face e8_warthog_finales/warthog1_1 e8_warthog_finales/warthog1_2)
	(cs_go_to_and_face e8_warthog_finales/warthog1_2 e8_warthog_finales/warthog1_3)
	(cs_go_to e8_warthog_finales/warthog1_3 1.0)
	(cs_go_to e8_warthog_finales/warthog1_4 1.0)
)

(script command_script cs_e8_warthog2_start
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed_instantaneous 8.0)			; hack
	(cs_go_to e8_warthog2_rail_start/hack 1.0)	; hack
	(cs_vehicle_speed 1.0)								; hack
	(cs_go_to_and_face e8_warthog2_rail_start/p0 e8_warthog2_rail_start/p0_facing)

	; Move over to the common end
	(cs_go_to_and_face e8_warthogs_to_brutes/p0 e8_warthogs_to_brutes/p0_facing)
	(cs_go_to_and_face e8_warthogs_to_brutes/p1 e8_warthogs_to_brutes/p2)
	(cs_go_to_and_face e8_warthogs_to_brutes/p2 e8_warthogs_to_brutes/p3)
	(cs_go_to_and_face e8_warthogs_to_brutes/p3 e8_warthogs_to_brutes/p4)
	(cs_go_to_and_face e8_warthogs_to_brutes/p4 e8_warthogs_to_brutes/p4_facing)
	(cs_go_to_and_face e8_warthogs_to_brutes/p5 e8_warthogs_to_brutes/p6)
	(cs_go_to e8_warthogs_to_brutes/p6 1.0)
)

(script command_script cs_e8_warthog2_end
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(object_can_take_damage (ai_actors ai_current_actor))
	(object_can_take_damage (ai_vehicle_get ai_current_actor))
	(cs_go_to e8_warthog_finales/warthog2_0 1.0)
	(cs_go_to e8_warthog_finales/warthog2_1 1.0)
)

(script command_script cs_e8_phantom_overflight
	(cs_enable_looking false)
;	(object_set_velocity (ai_vehicle_get ai_current_actor) 25)
	(cs_fly_by e8_phantom_overflight/p1)
	(cs_fly_to e8_phantom_overflight/p2)
	(cs_look true e8_phantom_overflight/p0)
	(cs_pause 32000)
)

(script command_script cs_e8_cov_creep0_rail
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e8_cov_creep0/p0 1.0)
	(cs_go_to e8_cov_creep0/p1 1.0)
	(cs_go_to e8_cov_creep0/p2 1.0)
	(unit_kill (ai_vehicle_get ai_current_actor))
	; I lament your short, tragic life
)

(script command_script cs_e8_ghost0_rail
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e8_ghost0_rail/p0 1.0)
;	(cs_go_to e8_ghost0_rail/p1 1.0)
	(cs_go_to e8_ghost0_rail/p6 1.0)
	(cs_enable_targeting true)
	(cs_shoot true)
	(sleep 60)
	(ai_erase ai_current_actor)
;	(cs_go_to e8_ghost0_rail/p2 1.0)
;	(cs_go_to e8_ghost0_rail/p3 1.0)
;	(cs_go_to e8_ghost0_rail/p5 1.0)
;	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e8_ghost1_rail
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e8_ghost1_rail/p0 1.0)
	(cs_go_to e8_ghost1_rail/p1 1.0)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e8_ghost2_rail
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e8_ghost2_rail/p0 1.0)
	(cs_go_to e8_ghost2_rail/p1 1.0)
	(cs_go_to e8_ghost2_rail/p3 1.0)
	(cs_go_to e8_ghost2_rail/p4 1.0)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e8_ghost3_rail
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e8_ghost2_rail/p0 1.0)
	(cs_go_to e8_ghost2_rail/p1 1.0)
	(cs_go_to e8_ghost2_rail/p3 1.0)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e8_ghost4_rail
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true)
	(cs_go_to e8_ghost3_rail/p0 1.0)
	(cs_go_to e8_ghost3_rail/p1 1.0)
	(cs_go_to e8_ghost3_rail/p2 1.0)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e8_ghost5_rail
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true)
	(cs_go_to e8_ghost3_rail/p3 1.0)
	(cs_go_to e8_ghost3_rail/p4 1.0)
	(cs_go_to e8_ghost3_rail/p5 1.0)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e8_ghost6_rail
	(cs_ignore_obstacles true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true)
	(cs_vehicle_speed_instantaneous 8)
	(cs_go_to_and_face e8_ghost4_rails/p0 e8_ghost4_rails/p1)
	(cs_go_to_and_face e8_ghost4_rails/p1 e8_ghost4_rails/p1_1)
	(cs_go_to_and_face e8_ghost4_rails/p1_1 e8_ghost4_rails/p2)
	(cs_go_to e8_ghost4_rails/p2 1.0)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e8_ghost7_rail
	(cs_ignore_obstacles true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true)
	(cs_vehicle_speed_instantaneous 8)
	(cs_go_to e8_ghost4_rails/p3 1.0)
	(cs_go_to e8_ghost4_rails/p4 1.0)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e8_cov_inf0_flee
	(cs_set_style "retreating")
	(cs_go_to e8_roadkill/p0)
	(cs_go_to e8_roadkill/p1)
	(ai_erase ai_current_actor)
)

(script command_script cs_e8_phantom_shoot
	(cs_force_combat_status 4)
	(cs_enable_targeting true)
	(cs_shoot false)
	(sleep 120)
	(cs_shoot true (ai_vehicle_get e8_mars_warthog2/driver))
	(sleep 150)
)


;- Action ----------------------------------------------------------------------

(script dormant e8_mars_warthog0_dialog0
	; The player's warthog rail
	; Sleep until the first run-down-grunts are placed and then one is killed
	(sleep_until (> (ai_living_count e8_cov_inf0) 0))

	; Sleep until we've killed one
	(sleep_until (> (vehicle_count_bipeds_killed (ai_vehicle_get e7_mars_warthog0/driver)) g_e8_warthog0_kills) 5)
	
	; Dialog
	(sleep 10)
	(e8_662_DRIVER)
	(sleep 40)
	
	; Sleep until the Ghosts emerge
	(sleep_until (volume_test_objects tv_e8_ghosts_emerged (ai_vehicle_get e8_cov_ghosts0/driver0)) 5)

	; Dialog
	(sleep 10)
	(e8_680_PASSENGER)
	(sleep 50)
	(e8_690_DRIVER)
)

(script dormant e8_mars_warthog0_dialog1
	; Sleep until the creep is placed and then killed
	(sleep_until (> (ai_living_count e8_cov_creep0/driver) 0) 5)
	(sleep_until (<= (ai_living_count e8_cov_creep0/driver) 0) 5)
	
	; Score keeping
	(sleep 20)
	(e8_661_DRIVER)
	
	; Sleep until the next Ghost is alive, then dead
	(sleep_until (> (ai_living_count e8_cov_ghosts1) 0) 5)
	(sleep_until (<= (ai_living_count e8_cov_ghosts1) 1) 5)
	(sleep 15)
	(e8_671_PASSENGER)
	
	; And the next one
	(sleep_until (<= (ai_living_count e8_cov_ghosts1) 0) 5)
	(sleep 15)
	(e8_672_PASSENGER)
	
	; Sleep until the last Ghosts are placed
	(sleep_until (> (ai_living_count e8_cov_ghosts3) 0) 5)
	(sleep 45)
	(e8_673_PASSENGER)

	; PREDICT
	(object_type_predict objects\vehicles\phantom\phantom)
	; PREDICT
)

(script dormant e8_mars_warthog0_main
	; Remember the Warthog's kills
	(set g_e8_warthog0_kills (vehicle_count_bipeds_killed (ai_vehicle_get e7_mars_warthog0/driver)))

	; Have the Warthog continue to the first intersection
	(cs_queue_command_script e7_mars_warthog0/driver cs_e8_warthog0_start)
	(garbage_collect_now)

	; Sleep until the Warthog has arrived
	(sleep_until (volume_test_objects tv_e8_warthog0_should_cont (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(sleep 30)

	; Have the Warthog continue all the way to the Brutes
	(cs_run_command_script e7_mars_warthog0/driver cs_e8_warthog0_cont)
	(cs_queue_command_script e7_mars_warthog0/driver cs_e8_warthog0_end)
)

;(global long gtest 88)
(script dormant e8_mars_warthog1_main
	; Sleep until it's time to appear
	(sleep_until (volume_test_objects tv_e8_warthog1_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)

	; PVS hack
	(object_pvs_set_object e9_pvs_hack)
	
	; Place the Warthog
	(ai_place e8_mars_warthog1)

	; Pause while we load
	(sleep 30)
	
	; Make them invincible
	(object_cannot_take_damage (ai_actors e8_mars_warthog1))
	(object_cannot_take_damage (ai_vehicle_get e8_mars_warthog1/driver))
	(unit_impervious (ai_vehicle_get e8_mars_warthog1/driver) true)
	
	; Have the Warthog continue to the first intersection
	(cs_run_command_script e8_mars_warthog1/driver cs_e8_warthog1_start)

	; Sleep until it's time to teleport ahead
	(sleep_until (volume_test_objects tv_e8_ghosts1_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	
	; Place the tents back
	(object_create_anew triage_tent_1)
	(object_create_anew triage_tent_2)

	; PVS hack
	(object_pvs_clear)
	
	; Pause while the Ghosts catch up, so that it ramps off this Warthog gloriously
;	(sleep gtest)
	(sleep 88)
	
	; Have the Warthog teleport ahead and pull out into the intersection
	(cs_run_command_script e8_mars_warthog1/driver cs_e8_warthog1_cont)
	
	; Wait till we're in the boarding area
	(sleep_until (volume_test_objects tv_e8_warthog1_return (ai_vehicle_get e7_mars_warthog0/driver)) 5)

	; Have the Warthog teleport way ahead and get Bruted
	(object_teleport (ai_vehicle_get e8_mars_warthog1/driver) e8_warthog1_teleport)
	(vehicle_hover (ai_vehicle_get e8_mars_warthog1/driver) false)
	(sleep 3)
	(cs_run_command_script e8_mars_warthog1/driver cs_e8_warthog1_end)	
)

(script dormant e8_mars_warthog2_main
	; Sleep
	(sleep_until (volume_test_objects tv_e8_warthog2_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)

	; Place
	(ai_place e8_mars_warthog2)
	(sleep 30)
	
	; Make them invincible
	(object_cannot_take_damage (ai_actors e8_mars_warthog2))
	(object_cannot_take_damage (ai_vehicle_get e8_mars_warthog2/driver))
	(unit_impervious (ai_vehicle_get e8_mars_warthog2/driver) true)
	
	; Run the command scripts
	(cs_run_command_script e8_mars_warthog2/driver cs_e8_warthog2_start)
	(cs_queue_command_script e8_mars_warthog2/driver cs_e8_warthog2_end)
)

(script dormant e8_cov_ghosts4_init
	; Sleep
	(sleep_until (volume_test_objects tv_e8_ghosts4_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)

	; Place
	(ai_place e8_cov_ghosts4)
	(sleep 30)
	
	; Run the command scripts
	(cs_run_command_script e8_cov_ghosts4/driver0 cs_e8_ghost6_rail)
	(cs_run_command_script e8_cov_ghosts4/driver2 cs_e8_ghost7_rail)
)

(script dormant e8_cov_ghosts3_init
	; Sleep
	(sleep_until (volume_test_objects tv_e8_ghosts3_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)

	; Place
	(ai_place e8_cov_ghosts3)
	
	; Run the command scripts
	(cs_run_command_script e8_cov_ghosts3/driver0 cs_e8_ghost4_rail)
	(cs_run_command_script e8_cov_ghosts3/driver1 cs_e8_ghost5_rail)
)

(script dormant e8_cov_ghosts1_init
	; Sleep
	(sleep_until (volume_test_objects tv_e8_ghosts1_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)

	; Place
	(ai_place e8_cov_ghosts1)
	
	; Run the command scripts
	(cs_run_command_script e8_cov_ghosts1/driver0 cs_e8_ghost2_rail)
	(cs_run_command_script e8_cov_ghosts1/driver1 cs_e8_ghost3_rail)
)

(script dormant e8_cov_ghosts0_init
	; Sleep
	(sleep_until (volume_test_objects tv_e8_ghosts0_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)
	
	; Place
	(ai_place e8_cov_ghosts0)
	(sleep 5)
	
	; Get them off to a good start
	(object_set_velocity (ai_vehicle_get e8_cov_ghosts0/driver0) 10 0 1)
	(object_set_velocity (ai_vehicle_get e8_cov_ghosts0/driver1) 10 0 1)
	
	; Run the command scripts
	(cs_run_command_script e8_cov_ghosts0/driver0 cs_e8_ghost0_rail)
	(cs_run_command_script e8_cov_ghosts0/driver1 cs_e8_ghost1_rail)
)

(script dormant e8_cov_creep0_init
	; Sleep
	(sleep_until (volume_test_objects tv_e8_creep0_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)
	
	; Clear some stuff
	(object_destroy_containing "e8_scenery_pc")

	; We can clean up the infantry from before now
	(ai_erase e8_cov_inf0)
	(ai_erase e8_cov_inf1)

	;PREDICTION
	(object_type_predict objects\vehicles\creep\creep)
	(object_type_predict objects\vehicles\warthog\warthog)
	(camera_predict mission_predict_1)
	;END PREDICTION

	; Place
	(ai_place e8_cov_creep0)
	(sleep 5)
	
	; Get them off to a good start
	(object_set_velocity (ai_vehicle_get e8_cov_creep0/driver) 5 0 1)
	
	; Run the command scripts
	(cs_run_command_script e8_cov_creep0/driver cs_e8_cov_creep0_rail)
)

(script dormant e8_cov_inf_init
	; Sleep
	(sleep_until (volume_test_objects tv_e8_cov_inf_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)
	
	;PREDICTION
	(object_type_predict objects\vehicles\ghost\ghost)
	;END PREDICTION

	; Place
	(ai_place e8_cov_inf0)
	(ai_place e8_cov_inf1)

	; And flee
	(cs_run_command_script e8_cov_inf0 cs_e8_cov_inf0_flee)
	
	; Sleep until we should flee
	(sleep_until (< (ai_strength e8_cov_inf1) 0.5) 5)
	(cs_run_command_script e8_cov_inf1 cs_e8_cov_inf0_flee)
)

(script dormant e8_cov_phantom_overflight
	; Spew
	(sleep_until (volume_test_objects tv_e8_phantom_overflight (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(garbage_collect_now)

	; Clean the tents, and the corpses
	(object_destroy triage_tent_1)
	(object_destroy triage_tent_2)
	(object_destroy_containing "e8_scenery_corpse")

	; Place vehicle
	(object_create_anew e8_phantom0)
	(object_cannot_take_damage e8_phantom0)
	
	; Place the AI
	(ai_place e8_cov_phantom0)
	(object_cannot_take_damage (ai_actors e8_cov_phantom0))
	(sleep 2)
	
	; Load the AI
	(vehicle_load_magic e8_phantom0 "phantom_d" (ai_actors e8_cov_phantom0/driver))
	(vehicle_load_magic e8_phantom0 "phantom_g_r" (ai_actors e8_cov_phantom0/gunner))

	; Run the custom animation, hack the engine
	(custom_animation e8_phantom0 "objects\vehicles\phantom\animations\E3\e3" "phantom01pass" false)
	(vehicle_engine_hack e8_phantom0 true 1.0)

	; Give him magical sight of the front Warthog
	(ai_magically_see_squad e8_cov_phantom0 e8_mars_warthog2)

	; Apply the command script
	(cs_run_command_script e8_cov_phantom0/gunner cs_e8_phantom_shoot)
	
	; Sleep for a moment
	(sleep 70)
	
	; Dialog
	(e8_710_COR)
	
	; More dialog
	(sleep 30)
	(e8_720_DRIVER)

	; Cleanup
	(sleep_until (volume_test_objects tv_e8_phantom0_cleanup (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(ai_erase e8_cov_phantom0)
	(object_destroy e8_phantom0)
)


;- Setup -----------------------------------------------------------------------

(script static void e8_end
	; End it all
	(sleep_forever e8_cov_inf_init)
	(sleep_forever e8_cov_ghosts0_init)
	(sleep_forever e8_cov_ghosts1_init)
	(sleep_forever e8_cov_ghosts3_init)
	(sleep_forever e8_cov_ghosts4_init)
	(sleep_forever e8_cov_creep0_init)
	(sleep_forever e8_mars_warthog0_main)
	(sleep_forever e8_mars_warthog1_main)
	(sleep_forever e8_mars_warthog2_main)
	(sleep_forever e8_mars_warthog0_dialog0)
	(sleep_forever e8_mars_warthog0_dialog1)
	(sleep_forever e8_cov_phantom_overflight)
)

(script static void e8_cleanup
	; End the scripts
	(e8_end)

	; Delete actors
	(ai_erase e8_cov)
	(ai_erase e8_mars)
)


;- Init ------------------------------------------------------------------------

(script dormant e8_init
	; Spew
	(sleep_until (volume_test_objects tv_e8_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(if debug (print "e8_init"))

	; Place the debris in the field hospital
	(object_create_anew_containing "e8_scenery")
	
	; Wake the scripts
	(wake e8_cov_inf_init)
	(wake e8_mars_warthog0_dialog0)
	(wake e8_mars_warthog0_main)	; Note: The player's Warthog rail
	(wake e8_mars_warthog1_main)
	(sleep 6)	; Stagger
	(wake e8_mars_warthog0_dialog1)
	(wake e8_cov_ghosts0_init)
	(wake e8_cov_ghosts1_init)
	(wake e8_cov_creep0_init)
	(wake e8_cov_ghosts4_init)
	(sleep 6)	; Stagger
	(wake e8_mars_warthog2_main)
	(wake e8_cov_ghosts3_init)
	(wake e8_cov_phantom_overflight)

	; FLAG for Jaime
	(set global_core_creeps true)
	
	; Sleep until cleanup
	(sleep_until (volume_test_objects tv_e8_cleanup (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(object_destroy_containing "e8_scenery")
)

(script static void e8_test
	; Place the warthog
	(ai_place e7_mars_warthog0)
	(sleep 5)
	
	; Teleport them and load the player
	(object_teleport (ai_vehicle_get e7_mars_warthog0/driver) e8_test_allies)
	(vehicle_load_magic (ai_vehicle_get e7_mars_warthog0/driver) "warthog_g" (player0))

	; Wakey
	(wake e8_init)
	(wake e9_init)
	(wake e10_init)
)

(script dormant e9_test		; I'm lost, can you help me find my way home?
	; Place the warthogs
	(ai_place e7_mars_warthog0)
	(ai_place e8_mars_warthog1)
	(ai_place e8_mars_warthog2)
	(sleep 5)
	
	; Teleport them and load the player
	(object_teleport (ai_vehicle_get e7_mars_warthog0/driver) e9_test_warthog0)
	(vehicle_load_magic (ai_vehicle_get e7_mars_warthog0/driver) "warthog_g" (player0))
	(object_teleport (ai_vehicle_get e8_mars_warthog1/driver) e9_test_warthog1)
	(object_teleport (ai_vehicle_get e8_mars_warthog2/driver) e9_test_warthog2)
	
	; Run the command scripts
	(cs_run_command_script e7_mars_warthog0/driver cs_e8_warthog0_end)
	(cs_run_command_script e8_mars_warthog1/driver cs_e8_warthog1_end)
	(cs_run_command_script e8_mars_warthog2/driver cs_e8_warthog2_end)
)


;= e7 - Warthog Pursuit ========================================================
;- Globals ---------------------------------------------------------------------

(global boolean e7_warthog0_could_use_gunner false)
(global boolean e7_transports_should_leave false) ; DEPRECATED
(global boolean e7_warthog0_should_advance false)		; Warthog 0 should step up
(global boolean e7_warthog1_should_advance false)		; Warthog 1 should step up
(global boolean e7_warthog0_should_continue false)		; Warthog 0 should chase
(global boolean e7_warthog1_should_continue false)		; Warthog 1 should chase


;- Order Scripts ---------------------------------------------------------------

(script command_script cs_e7_warthog0_entry
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_and_face e7_warthog0/entry0 e7_warthog0/entry1)
	(cs_go_to_and_face e7_warthog0/entry1 e7_warthog0/entry2)
	(cs_go_to_and_face e7_warthog0/entry2 e7_warthog0/entry3)
	(set e7_warthog0_could_use_gunner true)
	(cs_pause 32000)
)

(script command_script cs_e7_warthog0_pursuit0
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e7_warthog0/pursuit0 0.5)
	(cs_pause 32000)
)

(script command_script cs_e7_warthog0_pursuit1
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_and_face e7_warthog0/pursuit1 e7_warthog0/pursuit1_1)
;	(cs_go_to_and_face e7_warthog0/pursuit1_1 e7_warthog0/pursuit2)
	(cs_go_to_and_face e7_warthog0/pursuit2 e7_warthog0/pursuit3)
	(cs_go_by e7_warthog0/pursuit3 e7_warthog0/pursuit4 0.75)
	(cs_go_to_and_face e7_warthog0/pursuit4 e7_warthog0/pursuit5)
	(cs_go_by e7_warthog0/pursuit4_1 e7_warthog0/pursuit5 1.0)
	(cs_go_by e7_warthog0/pursuit5 e7_warthog0/pursuit6 1.0)
	(cs_go_to_and_face e7_warthog0/pursuit6 e7_warthog0/pursuit8)
	(cs_go_to_and_face e7_warthog0/pursuit9 e7_warthog0/pursuit10)
	(cs_pause 2.0)
)

(script command_script cs_e7_warthog1_entry
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_and_face e7_warthog1/entry0_1 e7_warthog1/entry0)
	(cs_go_to_and_face e7_warthog1/entry0 e7_warthog1/entry1)
	(cs_go_to_and_face e7_warthog1/entry1 e7_warthog1/pursuit0)
	(cs_pause 32000)
)

(script command_script cs_e7_warthog1_pursuit0
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e7_warthog1/pursuit0 0.2)
	(cs_pause 32000)
)

(script command_script cs_e7_warthog1_pursuit1
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e7_warthog1/pursuit1 0.75)
	(cs_go_to e7_warthog1/pursuit1_1 1.0)
	(cs_go_to e7_warthog1/pursuit4 1.0)
	(cs_go_to e7_warthog1/pursuit5 1.0)
	(cs_go_to e7_warthog1/pursuit6 0.2)
	(cs_go_to e7_warthog1/pursuit7 0.0)
	(cs_pause 32000)
)

(script command_script cs_e7_mars_odst_cameo
	; Run custom animation
	; Lock him in place
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:601" 0 true)
	
	; Erase him for me
	(cs_pause 15)
	(ai_erase ai_current_actor)
)

(script command_script cs_e7_neuter_passenger
	(cs_shoot false)
	(sleep 32000)
)


;- Action ----------------------------------------------------------------------

(script dormant e7_odst_cameo
	; Place him
	(ai_place e7_mars_odst_cameo)
		
	; Sleep appropriately
	(sleep 60)
	
	; Run command script, say dialog
	(cs_run_command_script e7_mars_odst_cameo cs_e7_mars_odst_cameo)
	(e7_601_ODST)
)

(script dormant e7_warthog0_dialog
	; Sleep until we could use a gunner
	(sleep_until e7_warthog0_could_use_gunner 5)
	(e7_610_DRIVER)
	
	; Prediction hack
	(object_type_predict_high objects\characters\masterchief\masterchief)
	
	; Wake ODST cameo
	(wake e7_odst_cameo)

	; Sleep until the player is loaded
	(sleep_until (vehicle_test_seat (ai_vehicle_get e7_mars_warthog0/driver) "warthog_g" (player0)))

	; Wait till Warthog 0 begins to move up
	(sleep_until e7_warthog0_should_continue 5)
	
	; Play some dialog 
	(sleep 30)
	(if (> (ai_living_count e6_cov_transport2/driver) 0) (e7_630_DRIVER))
	
	; Sleep until transport2 is dead
	(sleep_until (<= (ai_living_count e6_cov_transport2/driver) 0) 5)
	
	; Play some more dialog
	(sleep 10)
	(e7_650_PASSENGER)
	
	; Sleep until transport1 is dead
	(sleep_until (<= (ai_living_count e6_cov_transport1/driver) 0) 5)
	
	; Play some more dialog
	(sleep 20)
	(e7_651_PASSENGER)
)

(script dormant e7_warthog0_chase_main
	; Do the dialog in parallel
	(wake e7_warthog0_dialog)

	; Bring the warthog in
	(cs_run_command_script e7_mars_warthog0/driver cs_e7_warthog0_entry)
	(garbage_collect_now)

	; Wait until I should advance
	(sleep_until e7_warthog0_should_advance 5)
	
	; Pause before advancing
	(sleep 90)

	; If the player isn't loaded already, load him, engage the safety net
	(vehicle_load_magic (ai_vehicle_get e7_mars_warthog0/driver) "warthog_g" (player0))
	(wake warthog0_safety_net)

	; Continue the run
	(cs_run_command_script e7_mars_warthog0/driver cs_e7_warthog0_pursuit0)
	(cs_run_command_script e7_mars_warthog0/passenger cs_e7_neuter_passenger)
	(garbage_collect_now)
	
	; Sleep until I should continue
	(sleep_until e7_warthog0_should_continue 5)
	
	; Tell Warthog 1 to continue
	(set e7_warthog1_should_continue true)

	; Pause a moment, then continue chasing the Creeps
	(sleep 30)
	(cs_run_command_script e7_mars_warthog0/driver cs_e7_warthog0_pursuit1)	
	(garbage_collect_now)
)

(script dormant e7_warthog1_chase_main
	; Bring the warthog in
	(cs_run_command_script e7_mars_warthog1/driver cs_e7_warthog1_entry)

	; Wait until I should advance
	(sleep_until e7_warthog1_should_advance 5)
	
	; Pause before advancing, to give the transport time to move up
	(sleep 20)

	; Continue the run
	(cs_run_command_script e7_mars_warthog1/driver cs_e7_warthog1_pursuit0)
	
	; Wait until I should continue
	(sleep_until e7_warthog1_should_continue 5)

	; Pause before continuing, to give Warthog 0 time to catch up
	(sleep 30)

	; Finish the transports
	(cs_run_command_script e7_mars_warthog1/driver cs_e7_warthog1_pursuit1)	
)



;- Setup -----------------------------------------------------------------------

(script static void e7_setup
	; Place the props
	(object_create_containing "e7_scenery")
	
	; Place the AI
	(ai_place e7_mars_warthog0)
	(ai_place e7_mars_warthog1)
	(sleep 5)
	
	; Render them Joe-proof
	(object_cannot_take_damage (ai_actors e7_mars_warthog0))
	(object_cannot_take_damage (ai_actors e7_mars_warthog1))
	(object_cannot_take_damage (ai_vehicle_get e7_mars_warthog0/driver))
	(object_cannot_take_damage (ai_vehicle_get e7_mars_warthog1/driver))
	(unit_impervious (ai_vehicle_get e7_mars_warthog0/driver) true)
	(unit_impervious (ai_vehicle_get e7_mars_warthog1/driver) true)

	; Wake scripts
	(wake e7_warthog0_chase_main)
	(wake e7_warthog1_chase_main)
)

(script static void e7_cleanup
	; Place the props
	(object_destroy_containing "e7_scenery")

	; Erase the AI
	(ai_erase e7_mars_warthog1)
)


;- Init ------------------------------------------------------------------------

(script dormant e7_init 
	; Sleep 2 seconds to synch with e6
	(sleep 60)

	; Garbage collect
	(garbage_collect_now)
	
	; Setup
	(e7_setup)

	; Sleep until we should clean up
	(sleep_until (volume_test_objects tv_e7_cleanup (player0)) 5)
	(e7_cleanup)
)


;= e6 - Fleeing Covenant =======================================================
;- Order Scripts ---------------------------------------------------------------

(script command_script cs_e6_transport2_exit
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 0.6)
	(cs_go_to_and_face e6_transports/p0 e6_transports/p1)
	(cs_vehicle_speed 1.0)
	(cs_go_to e6_transports/transport2_vulnerable)
	(object_can_take_damage (ai_actors ai_current_squad))
	(object_can_take_damage (ai_vehicle_get ai_current_actor))
	(unit_impervious (ai_actors ai_current_squad) false)
	(unit_impervious (ai_vehicle_get ai_current_actor) false)
	(cs_go_to e6_transports/transport2_dies)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e6_transport1_exit
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 0.6)
	(cs_go_to_and_face e6_transports/p0 e6_transports/p1)
	(cs_vehicle_speed 1.0)
	(cs_go_to e6_transports/p1)
	(object_can_take_damage (ai_actors ai_current_squad))
	(object_can_take_damage (ai_vehicle_get ai_current_actor))
	(unit_impervious (ai_actors ai_current_squad) false)
	(unit_impervious (ai_vehicle_get ai_current_actor) false)
	(cs_teleport e6_transports/transport1_return e6_transports/transport1_dies)
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)
	(cs_pause 32000)
)

(script command_script cs_e6_transport1_end
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(vehicle_hover (ai_vehicle_get ai_current_actor) false)
	(cs_go_to e6_transports/transport1_dies)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e6_transport0_exit
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 1.0)
	(cs_go_to e6_transports/transport0_vulnerable)
	(object_can_take_damage (ai_actors ai_current_squad))
	(object_can_take_damage (ai_vehicle_get ai_current_actor))
	(unit_impervious (ai_actors ai_current_squad) false)
	(unit_impervious (ai_vehicle_get ai_current_actor) false)
	(cs_go_to e6_transports/transport0_dies)
	(unit_kill (ai_vehicle_get ai_current_actor))
)

(script command_script cs_e6_load_transport0
	(cs_force_combat_status 3)
	(cs_go_to_vehicle (ai_vehicle_get e6_cov_transport0/driver))
)

(script command_script cs_e6_load_transport1
	(cs_force_combat_status 3)
	(cs_go_to_vehicle (ai_vehicle_get e6_cov_transport1/driver))
)

(script command_script cs_e6_load_transport2
	(cs_force_combat_status 3)
	(cs_go_to_vehicle (ai_vehicle_get e6_cov_transport2/driver))
)

(script command_script cs_e6_transport_wait
	(cs_enable_looking false)
	(cs_enable_targeting false)
	(cs_aim true e6_transports/start_look)
	(cs_pause 32000)
)

(script command_script cs_e6_form_phalanx
	(cs_go_to e6_jackal_phalanx/form)
	(cs_crouch true)
	(cs_formation 5 e6_cov_inf0 e6_jackal_phalanx/form e6_jackal_phalanx/form_facing)
)

(script command_script cs_e6_halt_phalanx
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_shoot true)
	(cs_crouch true)
	(sleep 32000)
)

(script command_script cs_e6_break_phalanx
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e6_jackal_phalanx/retreat)
)

(script command_script cs_e6_fodder_jackals
	(cs_force_combat_status 3)
	(cs_ignore_obstacles true)
	(cs_go_to e6_fodder/jackals_flee)
)


;- Action ----------------------------------------------------------------------

(script dormant e6_transports_cont
	; Sleep until it's time
	(sleep_until (volume_test_objects tv_e6_transports_cont (ai_vehicle_get e7_mars_warthog0/driver)) 5)

	; Delete the gun pieces
	(object_destroy_containing "e6_scenery_gun")

	; Place the AI
	(ai_place e6_cov_transport0)

	; Make it invincible
	(object_cannot_take_damage (ai_actors e6_cov_transport0/driver))
	(object_cannot_take_damage (ai_vehicle_get e6_cov_transport0/driver))
	(unit_impervious (ai_actors e6_cov_transport0/driver) true)
	(unit_impervious (ai_vehicle_get e6_cov_transport0/driver) true)

	; Start it on its way, and send the second one on its way too
	(cs_run_command_script e6_cov_transport0/driver cs_e6_transport0_exit)
	(cs_run_command_script e6_cov_transport1/driver cs_e6_transport1_end)
)

(script dormant e6_transports_start
	; Sleep 2 seconds to synch with e7
	(sleep 60)

	; Sleep until it's time
	(sleep 220)
	
	; Order the second transport to leave, then tell Warthog 1 to advance
	(cs_run_command_script e6_cov_transport1/driver cs_e6_transport1_exit)
	(set e7_warthog1_should_advance true)

	; Pause between transport1 and transport2
	(sleep 50)
	
	; Order the third transport to leave, then tell Warthog 0 to advance
	(cs_run_command_script e6_cov_transport2/driver cs_e6_transport2_exit)
	(set e7_warthog0_should_advance true)
	
	; Pause until transport 2 has moved up far enough
	(sleep 180)
	
	; Tell Warthog 0 to continue
	(set e7_warthog0_should_continue true)
)

(script dormant e6_cov_inf1_and_inf2_main
	; Sleep
	(sleep_until (volume_test_objects tv_e6_cov_inf1_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(ai_place e6_cov_inf1)

	; Sleep
	(sleep_until (volume_test_objects tv_e6_cov_inf2_init (ai_vehicle_get e7_mars_warthog0/driver)) 5)
	(ai_place e6_cov_inf2)
)

(script dormant e6_cov_inf0_main
	; Place the Jackals
	(sleep 2)	; Stagger loads
	(ai_place e6_cov_inf0)
	(sleep 2)
	
	; Render them invincible, so that they hold formation
	(object_cannot_take_damage (ai_actors e6_cov_inf0))
	(unit_impervious (ai_actors e6_cov_inf0) true)

	; Give them magical sight of the player
	(ai_magically_see_object e6_cov_inf0 (player0))

	; Form phalanx
	(cs_run_command_script e6_cov_inf0/leader cs_e6_form_phalanx)
	
	; Sleep until they should break
	(sleep_until (volume_test_objects tv_e6_warthogs_arrived (ai_vehicle_get e7_mars_warthog1/driver)) 5)

	; Render them pervious (hee hee), so that they die properly
	(object_can_take_damage (ai_actors e6_cov_inf0))
	(unit_impervious (ai_actors e6_cov_inf0) false)

	; Have them dig in and hold position
	(cs_run_command_script e6_cov_inf0 cs_e6_halt_phalanx)
	(cs_run_command_script e6_cov_inf0/leader cs_e6_halt_phalanx)

	; Sleep until we're driven off
	(sleep_until (< (ai_strength e6_cov_inf0) 0.45) 5)
	(cs_run_command_script e6_cov_inf0 cs_e6_break_phalanx)
	
	; Sleep for a minute
	(sleep 1800)
	
	; Delete them
	(ai_erase e6_cov_inf0)
)


;- Setup -----------------------------------------------------------------------

(script static void e6_setup
	; Place the AI
	(ai_place e6_cov_transport1)
	(ai_place e6_cov_transport2)
	(sleep 2)

	; Make the transports invincible and impervious
	(object_cannot_take_damage (ai_actors e6_cov_transport1/driver))
	(object_cannot_take_damage (ai_actors e6_cov_transport2/driver))
	(object_cannot_take_damage (ai_vehicle_get e6_cov_transport1/driver))
	(object_cannot_take_damage (ai_vehicle_get e6_cov_transport2/driver))
	(unit_impervious (ai_actors e6_cov_transport1/driver) true)
	(unit_impervious (ai_actors e6_cov_transport2/driver) true)
	(unit_impervious (ai_vehicle_get e6_cov_transport1/driver) true)
	(unit_impervious (ai_vehicle_get e6_cov_transport2/driver) true)

	; Command scripts
	(cs_run_command_script e6_cov_transport1 cs_e6_load_transport1)
	(cs_run_command_script e6_cov_transport2 cs_e6_load_transport2)
	(cs_run_command_script e6_cov_transport1/driver cs_e6_transport_wait)
	(cs_run_command_script e6_cov_transport2/driver cs_e6_transport_wait)
	
	; Wake action
	(wake e6_transports_start)
	(wake e6_transports_cont)
)

(script static void e6_cleanup
	; Erase the props
	(object_destroy_containing "e6_scenery")

	; Erase AI
	(ai_erase e6_cov)
)


;- Init ------------------------------------------------------------------------

(script dormant e6_init
	; Sleep for scenery
	(sleep_until (volume_test_objects tv_e6_scenery (players)))

	; Place the props, delete others
	(object_create_anew_containing "e6_scenery_")
	(object_create_anew e3_unwanted_light)
	(object_destroy e4_gun_smoke)
	
	; Sleep
	(sleep_until (volume_test_objects tv_e6_init (players)))

	;PREDICTION grunts and jackals
	(object_type_predict objects\vehicles\creep\creep)
	(object_type_predict objects\vehicles\warthog\warthog)
	(object_type_predict objects\charaters\marine\marine)
	;END PREDICTION

	; Spew
	(garbage_collect_now)
	(if debug (print "e6_init"))

	; Wake Subsequent encounters
	(wake e7_init)

	; Wake other scripts
	(wake e6_cov_inf0_main)
	(wake e6_cov_inf1_and_inf2_main)

	; Run scripts
	(e6_setup)
	
	; Sleep until it's safe to clean
	(sleep_until (volume_test_objects tv_e6_cleanup (players)))
	(e6_cleanup)
)

(script static void e6_test
	(object_teleport (player0) e6_test)
	(wake e6_init)
)


;= e5 - Jackal Phalanx =========================================================
;- Globals ---------------------------------------------------------------------

(global boolean g_e5_bombs_away false)
(global boolean g_e5_turret_exploded false)


;- Commmand Scripts ------------------------------------------------------------

(script command_script cs_e5_cov_inf_gather
	(cs_force_combat_status 3)
	(cs_go_by e5_retreat/p0 e5_retreat/p1)
)

(script command_script cs_e5_cov_cave_suppress_left
	(cs_force_combat_status 4)
	(cs_enable_moving true)
	(cs_shoot true e5_cave_suppress_left)
	(sleep 60)
	(cs_abort_on_damage true)
	(sleep 1800)
)

(script command_script cs_e5_cov_cave_suppress_right
	(cs_force_combat_status 4)
	(cs_enable_moving true)
	(cs_shoot true e5_cave_suppress_right)
	(sleep 60)
	(cs_abort_on_damage true)
	(sleep 1800)
)


;- Action ----------------------------------------------------------------------

(script dormant e5_cov_inf5_main
	; Run this immediately
	; Place the native AI
	(ai_place e5_cov_inf5)
)


;- Setup -----------------------------------------------------------------------

(script dormant e5_cov_cave_setup
	; Sleep
	(sleep_until (volume_test_objects tv_e5_cave_init (players)))

	; Place the AI
	(ai_place e5_cov_cave)
	
	; Give them magical sight of the ODSTs
	(ai_magically_see_squad e5_cov_inf3 e1_mars_inf1)
	(ai_magically_see_squad e5_cov_inf4 e1_mars_inf1)
	
	; Give them command scripts
	(cs_run_command_script e5_cov_inf4 cs_e5_cov_cave_suppress_left)
	(cs_run_command_script e5_cov_inf3 cs_e5_cov_cave_suppress_right)
)

(script dormant e5_cov_phalanx_setup
	; Place the AI
	(ai_place e5_cov_inf0)
)

(script static void e5_cleanup
	; End scripts
	; Erase AI
	(ai_erase e5_cov)
	
	; Erase objects
	(object_destroy_containing "e5_scenery")
)


;- Init ------------------------------------------------------------------------

(script dormant e5_init
	; Spew
	(sleep_until 
		(and
			g_e5_turret_exploded
			(volume_test_objects tv_e5_init (players))
		)
	)
	(if debug (print "e5_init"))
	(garbage_collect_now)

	; Run scripts
	(wake e5_cov_inf5_main)
	(wake e5_cov_cave_setup)

	; Sleep until it's safe to clean up my mess
	(sleep_until (volume_test_objects tv_e5_cleanup (players)))
	(e5_cleanup)
)


;= e4 - Sarge Rushers ==========================================================
;- Globals ---------------------------------------------------------------------

(global boolean g_e4_bombers_can_come_in false)


;- Commmand Scripts ------------------------------------------------------------

(script command_script cs_e4_cov_inf_gather
	(cs_go_to e4_forced_march/gather)
)

(script command_script cs_e4_cov_inf_charge
	(cs_go_to e4_forced_march/charge)
)

(script command_script cs_e4_cov_inf_retreat
	(cs_go_to e4_forced_march/car)
)

(script command_script cs_e4_cov_inf_left_advance
	(cs_go_to e4_forced_march/left_advance)
)

(script command_script cs_e4_cov_inf_hostiles_right
	(cs_go_to e4_forced_march/hostiles_right)
)

(script command_script cs_e4_cov_inf_right_advance
	(cs_go_to e4_forced_march/right_advance)
)

(script command_script cs_e4_cov_inf_car
	(cs_go_to e4_forced_march/car)
	(object_can_take_damage (ai_actors ai_current_actor))
)


;- Order Scripts ---------------------------------------------------------------

(script static void oes_e4_cov_inf_gather
	(cs_run_command_script ai_current_squad cs_e4_cov_inf_gather)
)

(script static void oes_e4_cov_inf_charge
	(cs_run_command_script ai_current_squad cs_e4_cov_inf_charge)
)

(script static void oes_e4_cov_inf_retreat
	(cs_run_command_script ai_current_squad cs_e4_cov_inf_retreat)
)

(script static void oes_e4_cov_inf_left_advance
	(cs_run_command_script ai_current_squad cs_e4_cov_inf_left_advance)
)

(script static void oes_e4_cov_inf_right_advance
	(cs_run_command_script ai_current_squad cs_e4_cov_inf_right_advance)
)


;- Action ----------------------------------------------------------------------

(global boolean g_e4_cov_grunt_wave_go false)
(script static void joe_grunt_wave_begins
	; Allow the first wave to charge
	;(set g_e4_cov_inf0_charge true)
	(set g_e4_cov_grunt_wave_go true)
)

(script static boolean e4_cov_need_more_guys
	(and
		g_e4_cov_grunt_wave_go
		(< (ai_living_count e4_cov_rush) 4)
	)
)

(script continuous e4_garbage_collecter
	(garbage_collect_now)
	(sleep 150)
)

(script dormant e4_ODST_dialog
	; Wait till there are hostiles right
	(sleep_until (> (ai_living_count e4_cov_inf4) 0) 5)
	(sleep 100)
	(e7_531_ODST)	; Hostiles right!
)

(script dormant e4_cov_inf10_main
	; Sleep until the turret has exploded
	(sleep_until g_e5_turret_exploded 5)
	
	; Sleep in sync with the ODSTs
	(sleep 90)
	
	; Place the AI
	(ai_place e4_cov_inf10)
)

(script dormant e4_cov_grunts_behind_car
	; Sleep until Joe is looking at the hostiles to his right
	(sleep_until (objects_can_see_object (player0) e4_hostiles_facing_object 20.0) 5)
	
	; Place the grunts
	(ai_place e4_cov_car_grunts0)
	
	; Run command script
	(cs_run_command_script e4_cov_car_grunts0 cs_e4_cov_inf_car)
	
	; Sleep until these grunts are dead, or worst case, 15 seconds
	(sleep_until (<= (ai_living_count e4_cov_car_grunts0) 0) 30 450)
	
	; Sleep another two seconds
	(sleep 60)
	
	; Set the global so that Joe's bombers can come in
	(set g_e4_bombers_can_come_in true)
)

(script dormant e4_cov_grunt_wave_lite
	; Wake the collector
	(wake e4_garbage_collecter)
	
	; Wake the dialog
	(wake e4_ODST_dialog)

	; Place the first squad
	(ai_place e4_cov_inf0)
	
	; Sleep, place, wash rinse repeat
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf1)
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf2)
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf3)
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf6)
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf4)
	(cs_run_command_script e4_cov_inf4 cs_e4_cov_inf_hostiles_right)
		
	; Interlude: exploding car, and the Grunts who take it
	(wake e4_cov_grunts_behind_car)
	
	; Continue
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf5)
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf7)
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf8)
	(sleep_until (e4_cov_need_more_guys))
	(garbage_collect_now)
	(ai_place e4_cov_inf9)
	
	; End the adjucts
	(sleep_forever e4_ODST_dialog)
)

(script dormant e4_grunt_wave_override
	; Sleep until bombs are away
	(sleep_until g_e5_turret_exploded 5)

	; Kill the waves
	(sleep_forever e4_cov_grunt_wave_lite)
	(sleep_forever e4_ODST_dialog)
	
	; Migrate remaining e4 Covenant into a rear squad, make them retreat
	(ai_migrate e4_cov_rush e5_cov_inf5)
	(ai_set_orders e5_cov_inf5 e5_cov_inf5_init)
	(cs_run_command_script e5_cov_inf5 cs_e5_cov_inf_gather)
	
	; Stun the mofos
	(damage_objects "effects\damage_effects\stun_giant" (ai_actors e5_cov_inf5))
)

(script static void dtest
	(damage_objects "effects\damage_effects\stun_giant" (ai_actors e5_cov_inf5))
)

(script static void dtest2
	(damage_objects "objects\vehicles\warthog\damage_effects\warthog_gauss_bullet" (ai_actors e5_cov_inf5))
)

(script static boolean joe_bombers_can_enter
	(= g_e4_bombers_can_come_in true)
)

(script static void joe_turret_exploded
	(set g_e5_turret_exploded true)
)


;- Setup -----------------------------------------------------------------------

(script static void e4_end
	; End scripts
	(sleep_forever e4_garbage_collecter)
	(sleep_forever e4_ODST_dialog)
	(sleep_forever e4_cov_grunt_wave_lite)
	(sleep_forever e4_grunt_wave_override)
	(sleep_forever e4_cov_inf10_main)
)

(script static void e4_cleanup
	; End the scripts
	(e4_end)
	
	; Erase the AI
	(ai_erase e4_cov)
)


;- Init ------------------------------------------------------------------------

(script dormant e4_init
	; Shut down scripts
	(sleep_forever e4_garbage_collecter)

	; Spew
	(sleep_until (volume_test_objects tv_e4_init (players)))
	(if debug (print "e4_init"))

	; Cleanup misc crap
	(object_destroy_containing "e2b_scenery")

	; Wake the grunt wave script
	(wake e4_cov_grunt_wave_lite)
	(wake e4_grunt_wave_override)
	(wake e4_cov_inf10_main)
	
	; Sleep, then cleanup
	(sleep_until (volume_test_objects tv_e4_cleanup (players)))
	(e4_cleanup)
)

(script static void e4_test
	(object_teleport (player0) e4_test)
	(wake e4_cov_grunt_wave_lite)
	(wake e4_grunt_wave_override)
	(sleep 90)
	(joe_grunt_wave_begins)
)


;= e3 - Sarge Pinners ==========================================================
;- Order Scripts ---------------------------------------------------------------
;- Command Scripts -------------------------------------------------------------

(script command_script e3_cov_inf1_run_and_shoot
	; Run up into position, and shoot at target
	(cs_go_to e3_cov_inf1_attack/p0)
	(cs_shoot true e3_sarge_suppress)

	; COntinue
	(cs_go_to e3_cov_inf1_attack/p0_1)
	(cs_shoot false e3_sarge_suppress)
		
	; Continue on our way
	(cs_go_to e3_cov_inf1_attack/p1)

	; Whoops, I died!
	(ai_erase ai_current_actor)
)

(script command_script e3_cov_inf1_run
	; Run up into position
	(cs_go_to e3_cov_inf1_attack/p0)
	(cs_go_to e3_cov_inf1_attack/p1)

	; Whoops, I died!
	(ai_erase ai_current_actor)
)

(script command_script e3_cov_inf1_run_direct
	; Run up into position
	(cs_go_to e3_cov_inf1_attack/p1)

	; Whoops, I died!
	(ai_erase ai_current_actor)
)

(script command_script e3_cov_grunt0_stalking_sarge
	(cs_abort_on_damage true)
	(cs_crouch true)
	(cs_go_to e3_cov_sarge_stalkers/p0)
)

(script command_script e3_cov_grunt1_stalking_sarge
	(cs_abort_on_damage true)
	(cs_crouch true)
	(cs_go_to e3_cov_sarge_stalkers/p1)
)

(script command_script e3_cov_grunt2_stalking_sarge
	(cs_abort_on_damage true)
	(cs_crouch true)
	(cs_go_to e3_cov_sarge_stalkers/p2)
)

(script command_script e3_cov_grunt3_stalking_sarge
	(cs_abort_on_damage true)
	(cs_crouch true)
	(cs_go_to e3_cov_sarge_stalkers/p3)
)

(script command_script e3_cov_grunt4_stalking_sarge
	(cs_abort_on_damage true)
	(cs_crouch true)
	(cs_go_to e3_cov_sarge_stalkers/p4)
)

(script command_script e3_cov_grunt5_stalking_sarge
	(cs_abort_on_damage true)
	(cs_crouch true)
	(cs_go_to e3_cov_sarge_stalkers/p5)
)

(script command_script cs_e3_cov_abort_stalking
	(cs_force_combat_status 3)
	(cs_crouch false)
)

(script static void oes_e3_abort_stalking
	(cs_run_command_script ai_current_squad cs_e3_cov_abort_stalking)
)


;- Action ----------------------------------------------------------------------

(script dormant e3_cov_inf2_init
	(sleep_until (volume_test_objects tv_e3_cov_inf2_init (players)))
	
	; Place the AI
	(ai_place e3_cov_inf2)
	
	; Run the command scripts
	(cs_run_command_script e3_cov_inf2/grunt0 e3_cov_grunt3_stalking_sarge)
	(cs_run_command_script e3_cov_inf2/grunt1 e3_cov_grunt4_stalking_sarge)
	(cs_run_command_script e3_cov_inf2/grunt2 e3_cov_grunt5_stalking_sarge)

	; Make the ODST's aware of these guys
	(ai_magically_see_squad e1_mars_inf0 e3_cov_inf0)
	(ai_magically_see_squad e1_mars_inf1 e3_cov_inf2)
	
	; Sleep until damaged, then break
	(sleep_until 
		(or
			(< (ai_strength e3_cov_inf2) 0.95)
			(volume_test_objects tv_e4_init (players))
		) 
		5
	)
	(cs_run_command_script e3_cov_inf2 cs_e3_cov_abort_stalking)
	
	; Sleep until we should be deleted
	(sleep_until (volume_test_objects tv_e4_init (players)))
	(ai_kill_silent e3_cov_inf2)
)

(script dormant e3_cov_inf0_init
	; Place the AI
	(ai_place e3_cov_inf0)
	
	; Run the command scripts
	(cs_run_command_script e3_cov_inf0/grunt0 e3_cov_grunt0_stalking_sarge)
	(cs_run_command_script e3_cov_inf0/grunt1 e3_cov_grunt1_stalking_sarge)
	(cs_run_command_script e3_cov_inf0/grunt2 e3_cov_grunt2_stalking_sarge)
	
	; Sleep until damaged, then break
	(sleep_until 
		(or
			(< (ai_strength e3_cov_inf0) 0.95)
			(volume_test_objects tv_e4_init (players))
		) 
		5
	)
	(cs_run_command_script e3_cov_inf0 cs_e3_cov_abort_stalking)
	
	; Sleep until we should be deleted
	(sleep_until (volume_test_objects tv_e4_init (players)))
	(ai_kill_silent e3_cov_inf0)
)


;- Setup -----------------------------------------------------------------------

(script static void e3_setup
	; Place the props
	(object_create_anew_containing "e3_scenery")
	(object_create_anew_containing "e5_scenery")
	(object_create_anew e3_ap_turret0)
	
	; Unshadow the turret
	(object_set_shadowless e3_ap_turret0 true)
	
	; Clean up a light that we don't want
	(object_destroy e3_unwanted_light)

	; Place the AI
	(ai_place e3_cov_inf1)
	
	; Magical sight
	(ai_magically_see_squad e3_cov_inf1 e1_mars_inf0)
	
	; Command scripts
	(cs_run_command_script e3_cov_inf0/grunt0 e3_cov_grunt0_stalking_sarge)
	(cs_run_command_script e3_cov_inf0/grunt1 e3_cov_grunt1_stalking_sarge)
	(cs_run_command_script e3_cov_inf0/grunt2 e3_cov_grunt2_stalking_sarge)
	(cs_run_command_script e3_cov_inf1/grunt0 e3_cov_inf1_run_and_shoot)
	(cs_run_command_script e3_cov_inf1/grunt1 e3_cov_inf1_run)
	(cs_run_command_script e3_cov_inf1/grunt2 e3_cov_inf1_run_and_shoot)
)

(script static void e3_cleanup
	; End scripts
	(sleep_forever e3_cov_inf2_init)
	
	; Erase AI
	(ai_erase e3_cov)
	
	; Erase objects
	(object_destroy_containing "e3_scenery")
	(object_destroy e3_ap_turret0)
)


;- Init ------------------------------------------------------------------------

(script dormant e3_init
	; Spew
	(sleep_until (volume_test_objects tv_e3_init (players)))
	(if debug (print "e3_init"))

	; FLAG for Jaime
	(set global_core_perez true)
	
	; Clean up some orphaned stuff
	(object_destroy_containing "e2_scenery")
	(object_destroy triage_tent_1)
	(object_destroy triage_tent_2)

	; Wake scripts
	(wake e3_cov_inf0_init)
	(wake e3_cov_inf2_init)

	; Run scripts
	(e3_setup)
	
	; Sleep until we cleanup
	(sleep_until (volume_test_objects tv_e3_cleanup (players)))
	(e3_cleanup)
)


;= e1 - ODST Escort ============================================================
;- Globals ---------------------------------------------------------------------

(global boolean g_e1_odsts_begin_cave_advance false)	; ODSTs should advance to the cave
(global boolean g_e1_odsts_return false)					; The ODSTs should return and gather at the hospital entrance
(global boolean g_e1_odsts_enter_hospital false)		; This should be false and set to true by Joe
(global boolean g_e1_mars_safe_to_go false)				; This should be false and set to true by Joe


;- Order Scripts ---------------------------------------------------------------

(script static boolean e1_odst_cave_advance0_done
	(volume_test_objects_all tv_e1_odst_cave_advance0 (ai_actors e1_mars_odsts))
)

(script static boolean e1_odst_cave_advance1_done
	(volume_test_objects_all tv_e1_odst_cave_advance1 (ai_actors e1_mars_odsts))
)


;- Command Scripts -------------------------------------------------------------

(script command_script e1_odst_left0_entry
	(cs_ignore_obstacles true)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_odst_entry/entry0)
	(cs_teleport e1_odst_entry/left0_temp_storage e1_odst_entry/entry0)
	(cs_pause 32000)
)

(script command_script e1_odst_left1_entry
	(cs_ignore_obstacles true)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_odst_entry/entry0)
	(cs_teleport e1_odst_entry/left1_temp_storage e1_odst_entry/entry0)
	(cs_pause 32000)
)

(script command_script e1_odst_right0_entry
	(cs_ignore_obstacles 1)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_odst_entry/entry0)
	(cs_teleport e1_odst_entry/right0_temp_storage e1_odst_entry/entry0)
	(cs_pause 32000)
)

(script command_script e1_odst_left0_entry_return
	(cs_teleport e1_odst_entry/left0_return e1_odst_entry/entry_left0)
	(cs_go_to e1_odst_entry/entry_left0)
	(cs_face true e1_odst_entry/entry_left_look)
	(cs_crouch true)
	(cs_pause 32000)
)

(script command_script e1_odst_left1_entry_return
	(cs_teleport e1_odst_entry/left1_return e1_odst_entry/entry_left1)
	(cs_go_to e1_odst_entry/entry_left1)
	(cs_face true e1_odst_entry/entry_left_look)
	(cs_pause 32000)
)

(script command_script e1_odst_right0_entry_return
	(cs_teleport e1_odst_entry/right0_return e1_odst_entry/entry_right0)
	(cs_go_to e1_odst_entry/entry_right0)
	(cs_face true e1_odst_entry/entry_right_look)
	(cs_pause 32000)
)

(script command_script e1_odst_left0_entry_cont
	(cs_crouch true)
	(cs_ignore_obstacles true)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_pause 2.0)
	(cs_crouch false)
	(cs_go_to e1_odst_entry/entry2)
	(cs_aim true e1_odst_entry/stair_look)
	(cs_go_to e1_odst_entry/entry3)
	(cs_aim true e1_odst_entry/dest_look)
	(cs_go_to e1_odst_entry/dest_left0) 
	(cs_pause 32000)
)

(script command_script e1_odst_left1_entry_cont
	(cs_ignore_obstacles true)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_odst_entry/entry2)
	(cs_aim true e1_odst_entry/stair_look)
	(cs_go_to e1_odst_entry/entry3)
	(cs_aim true e1_odst_entry/dest_look)
	(cs_go_to e1_odst_entry/dest_left1) 
	(cs_pause 32000)
)

(script command_script e1_odst_right0_entry_cont
	(cs_ignore_obstacles 1)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_pause 0.5)
	(cs_go_to e1_odst_entry/entry2)
	(cs_aim true e1_odst_entry/stair_look)
	(cs_go_to e1_odst_entry/entry3)
	(cs_aim true e1_odst_entry/dest_look)
	(cs_go_to e1_odst_entry/dest_right0)
	(cs_crouch 1) 
	(cs_pause 32000)
)

(script command_script e1_odst_left0_failsafe0
	(cs_teleport e1_odst_entry/dest_left0 e1_odst_entry/dest_look)
	(cs_aim true e1_odst_entry/dest_look)
	(cs_pause 65000)
)

(script command_script e1_odst_left1_failsafe0
	(cs_teleport e1_odst_entry/dest_left1 e1_odst_entry/dest_look)
	(cs_aim true e1_odst_entry/dest_look)
	(cs_pause 65000)
)

(script command_script e1_odst_right0_failsafe0
	(cs_teleport e1_odst_entry/dest_right0 e1_odst_entry/dest_look)
	(cs_aim true e1_odst_entry/dest_look)
	(cs_crouch 1)
	(cs_pause 65000)
)

(script command_script e1_mars_inf2_left0_entry
	(cs_ignore_obstacles 1)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_mars_inf2_entry/left0)
	(cs_aim true e1_mars_inf2_entry/left_end_look)
	(cs_go_to e1_mars_inf2_entry/left_end0)
	(cs_crouch true)
	(cs_pause 65000)
)

(script command_script e1_mars_inf2_left1_entry
	(cs_ignore_obstacles 1)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_mars_inf2_entry/left0)
	(cs_aim true e1_mars_inf2_entry/left_end_look)
	(cs_go_to e1_mars_inf2_entry/left_end1)
	(cs_crouch true)
	(cs_pause 65000)
)

(script command_script e1_mars_inf2_right0_entry
	(cs_ignore_obstacles 1)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_mars_inf2_entry/right0)
	(cs_aim true e1_mars_inf2_entry/right_end_look)
	(cs_go_to e1_mars_inf2_entry/right_end0)
	(cs_crouch true)
	(cs_pause 65000)
)

(script command_script e1_mars_inf2_right1_entry
	(cs_ignore_obstacles 1)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_mars_inf2_entry/right0)
	(cs_aim true e1_mars_inf2_entry/right_end_look)
	(cs_go_to e1_mars_inf2_entry/right_end1)
	(cs_crouch true)
	(cs_pause 65000)
)

(script command_script e1_odst_left0_advance_sarge
	(cs_ignore_obstacles 1)
	(cs_enable_pathfinding_failsafe true)
	(cs_pause 0.5)
	(cs_enable_looking false)
	(cs_go_to e1_odst_advance_to_sarge/p0)
	(cs_aim 1 e1_odst_advance_to_sarge/look)
;	(cs_go_to e1_odst_advance_to_sarge/p1)
	(cs_go_to e1_odst_advance_to_sarge/left_end0)
	(e3_451_ODST)	; Dialog, "Grunts down low!"
	(cs_crouch 1)
	(cs_aim 0 e1_odst_advance_to_sarge/look)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_left1_advance_sarge
	(cs_ignore_obstacles 1)
	(cs_enable_pathfinding_failsafe true)
	(cs_pause 1.0)
	(cs_enable_looking false)
	(cs_go_to e1_odst_advance_to_sarge/p0)
	(cs_aim 1 e1_odst_advance_to_sarge/look)
;	(cs_go_to e1_odst_advance_to_sarge/p1)
	(cs_go_to e1_odst_advance_to_sarge/left_end1)
	(cs_aim 0 e1_odst_advance_to_sarge/look)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_right0_advance_sarge
	(cs_ignore_obstacles 1)
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_looking false)
	(cs_go_to e1_odst_advance_to_sarge/p0)
	(cs_aim 1 e1_odst_advance_to_sarge/look)
	(cs_go_to e1_odst_advance_to_sarge/p1)
	(cs_aim 0 e1_odst_advance_to_sarge/look)
	(cs_go_to e1_odst_advance_to_sarge/right_end0)
;	(cs_crouch 1)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_left0_failsafe1
	(cs_teleport e1_odst_advance_to_sarge/left_end0 e1_odst_advance_to_sarge/look)
	(cs_aim true e1_odst_advance_to_sarge/look)
	(cs_crouch 1)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_left1_failsafe1
	(cs_teleport e1_odst_advance_to_sarge/left_end1 e1_odst_advance_to_sarge/look)
	(cs_aim true e1_odst_advance_to_sarge/look)
	(cs_crouch 1)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_right0_failsafe1
	(cs_teleport e1_odst_advance_to_sarge/right_end0 e1_odst_advance_to_sarge/look)
	(cs_aim true e1_odst_advance_to_sarge/look)
	(cs_crouch 1)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_left0_cover_sarge
	(cs_enable_pathfinding_failsafe true)
	(cs_pause 0.75)
	(cs_go_to e1_odst_cover_sarge/left_end0)
	(cs_aim 1 e1_odst_cover_sarge/left_end_look)
	(cs_crouch 1)
	(cs_enable_targeting true)
	(cs_pause 32000)
)

(script command_script e1_odst_left1_cover_sarge
	(cs_enable_pathfinding_failsafe true)
	(cs_pause 0.75)
	(cs_go_to e1_odst_cover_sarge/left_end1)
	(cs_aim 1 e1_odst_cover_sarge/left_end_look)
	(cs_crouch 1)
	(cs_enable_targeting true)
	(cs_pause 32000)
)

(script command_script e1_odst_right0_cover_sarge
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_odst_cover_sarge/right_end0)
	(cs_aim 1 e1_odst_cover_sarge/right_end_look)
	(cs_crouch 1)
	(cs_enable_targeting true)
	(cs_pause 32000)
)

(script command_script e1_odst_left0_sarge_fight
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_odst_cover_sarge/left0_fight)
	(cs_crouch true)
	(cs_enable_targeting true)
	(sleep 32000)
)

(script command_script e1_odst_left1_sarge_fight
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_odst_cover_sarge/left1_fight)
;	(cs_crouch 1)
	(cs_enable_targeting true)
	(sleep 32000)
)

(script command_script e1_odst_right0_sarge_fight
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_odst_cover_sarge/right0_fight)
	(cs_crouch true)
	(cs_enable_targeting true)
	(sleep 32000)
)

(script command_script e1_odst_left0_cave_prep
	; Set flags
	(cs_ignore_obstacles 1)
	(cs_enable_looking false)
	(cs_enable_targeting false)

	; Teleport, and hold
	(cs_teleport e1_odst_through_cave/left0_start e1_odst_through_cave/left0_start_facing)
	(cs_enable_moving false)

	; Run animation
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:greande:idl" 0 true)
	(sleep 32000)
)

(script command_script e1_odst_left1_cave_prep
	; Set flags
	(cs_ignore_obstacles 1)
	(cs_enable_looking false)
	(cs_enable_targeting false)

	; Teleport, and hold
	(cs_teleport e1_odst_through_cave/left1_start e1_odst_through_cave/left1_start_facing)
	(cs_enable_moving false)
	
	; Run animation
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:591:idle" 0 true)
	(sleep 32000)
)

(script command_script e1_odst_right0_cave_prep
	; Set flags
	(cs_ignore_obstacles 1)

	; Teleport, and hold
	(cs_teleport e1_odst_through_cave/right0_start e1_odst_through_cave/start_facing)
	(cs_enable_looking true)
	(cs_enable_targeting false)
	(cs_enable_moving false)
	(cs_crouch true)

	; Run animation
	(sleep 32000)
)

(script command_script e1_odst_left0_grenade_throw
	; Create the grenade
	(object_create_anew e1_odst_grenade)

	; Run the animation
	(sleep 30)
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:grenade:tos" 0 true)
	(sleep 14)
	(objects_attach (ai_get_object ai_current_actor) "left_hand" e1_odst_grenade "")
	(sleep 10)
	(object_destroy e1_odst_grenade)
	(effect_new "effects\bursts\frag_grenade_toss" e1_odst_grenade_release)

	; Jaime's stunning grunt!
	(sleep 20)
	(ai_place e5_cov_inf_stunning_grunts)
;	(effect_new "effects\explosions\large_explosion" e1_odst_grenade_release)
	(sleep 18)

	; Resume crouching
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:greande:idl" 0 true)
	(sleep 32000)
)

(script command_script e1_odst_left1_grenade_throw
	; Speak the dialog
	(e5_591_ODST)

	; Order the throw
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:591" 1 true)
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:591:idle" 0 true)
	(sleep 70)
	
	; Speak the dialog
	(e5_592_ODST)
	
	; Order the advance
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:592" 1 true)
	(cs_custom_animation objects\characters\marine\marine_cinematics\marine_cinematics "sin:marine:odst:591:idle" 0 true)
	(sleep 32000)
)

(script command_script e1_odst_right0_grenade_throw
	; Stop firing
	(cs_pause 32000)
)

(script command_script e1_odst_left0_enter_cave
	; Set flags
	(cs_ignore_obstacles 1)
	(cs_enable_moving false)
	(cs_stop_custom_animation)

	; Head into the cave
	(cs_go_to e1_odst_through_cave/left0_0)
	(cs_crouch true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_left1_enter_cave
	; Set flags
	(cs_ignore_obstacles 1)
	(cs_enable_moving false)
	(cs_stop_custom_animation)

	; Head into the cave
	(cs_go_to e1_odst_through_cave/left1_0)
	(cs_crouch true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_right0_enter_cave
	; Set flags
	(cs_ignore_obstacles 1)
	(cs_enable_moving false)

	; Head into the cave
	(cs_go_to e1_odst_through_cave/right0_0)
	(cs_crouch true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_left0_exit_cave
	; Set flags
	(cs_ignore_obstacles 1)

	; If we need to, teleport
	(if (not (volume_test_objects tv_e1_odst_cave_positions (ai_actors ai_current_actor)))
		; Teleport, and pause for a moment
		(cs_teleport e1_odst_through_cave/left0_0 e1_odst_through_cave/cave_facing)
		(cs_pause 0.1)
	)

	; Head out the cave
	(cs_pause 0.1)
	(cs_go_to e1_odst_through_cave/exit0)
	(cs_go_to e1_odst_through_cave/left0_end)
	(cs_crouch true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_left1_exit_cave
	; Set flags
	(cs_ignore_obstacles 1)

	; If we need to, teleport
	(if (not (volume_test_objects tv_e1_odst_cave_positions (ai_actors ai_current_actor)))
		; Teleport, and pause for a moment
		(cs_teleport e1_odst_through_cave/left1_0 e1_odst_through_cave/cave_facing)
		(cs_pause 0.1)
	)

	; Head out the cave
	(cs_pause 0.5)
	(cs_go_to e1_odst_through_cave/exit0)
	(cs_go_to e1_odst_through_cave/left1_end)
	(cs_crouch true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_right0_exit_cave
	; Set flags
	(cs_ignore_obstacles 1)

	; If we need to, teleport
	(if (not (volume_test_objects tv_e1_odst_cave_positions (ai_actors ai_current_actor)))
		; Teleport, and pause for a moment
		(cs_teleport e1_odst_through_cave/right0_0 e1_odst_through_cave/cave_facing)
		(cs_pause 0.1)
	)

	; Head out the cave
	(cs_pause 0.6)
	(cs_go_to e1_odst_through_cave/exit0)
	(cs_go_to e1_odst_through_cave/right0_end)
	(cs_crouch true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_moving false)
	(sleep 32000)
)

(script command_script e1_odst_begin_cave_advance0
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 3)
	(cs_go_to e1_odst_advance_to_cave/p0)
	(cs_move_in_direction 45.0 1.0 0.0)
)

(script command_script e1_odst_begin_cave_advance1
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 3)
	(cs_go_to e1_odst_advance_to_cave/p1)
	(cs_go_to e1_odst_advance_to_cave/p0)
	(cs_move_in_direction 45.0 1.0 0.0)
)

(script command_script e1_release_cs_deathgrip
	(cs_pause 0.1)
)


;- Action ----------------------------------------------------------------------

(script dormant e1_mars_failsafe0
	; This failsafe makes sure the ODSTs have arrived with the player, in the event that one gets hung up on something
	(sleep_until (volume_test_objects tv_e1_failsafe0 (players)))
	
	; Check if the first ODST has not arrived
	(if (not (volume_test_objects tv_e1_failsafe0_odst_positions (ai_actors e1_mars_inf0/odst0)))
		; If not, run the failsafe
		(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_failsafe0)
	)
	
	; Check if the second ODST has not arrived
	(if (not (volume_test_objects tv_e1_failsafe0_odst_positions (ai_actors e1_mars_inf0/odst1)))
		; If not, run the failsafe
		(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_failsafe0)
	)
	
	; Check if the third ODST has not arrived
	(if (not (volume_test_objects tv_e1_failsafe0_odst_positions (ai_actors e1_mars_inf1/odst0)))
		; If not, run the failsafe
		(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_failsafe0)
	)
)

(script dormant e1_mars_failsafe1
	; This failsafe makes sure the ODSTs have arrived with the player, in the event that one gets hung up on something
	(sleep_until (volume_test_objects tv_e1_failsafe1 (players)))
	
	; Overrides any previous failsafes
	(sleep_forever e1_mars_failsafe0)
	
	; Check if the first ODST has not arrived
	(if (not (volume_test_objects tv_e1_failsafe1_odst_positions (ai_actors e1_mars_inf0/odst0)))
		; If not, run the failsafe
		(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_failsafe1)
	)
	
	; Check if the second ODST has not arrived
	(if (not (volume_test_objects tv_e1_failsafe1_odst_positions (ai_actors e1_mars_inf0/odst1)))
		; If not, run the failsafe
		(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_failsafe1)
	)
	
	; Check if the third ODST has not arrived
	(if (not (volume_test_objects tv_e1_failsafe1_odst_positions (ai_actors e1_mars_inf1/odst0)))
		; If not, run the failsafe
		(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_failsafe1)
	)
)

(script dormant e1_mars_follow_through_cave
	; Wait until the player is close enough to teleport them in
	(sleep_until (volume_test_objects tv_e1_cave_prep (players)))
	
	; Teleport them up
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_cave_prep)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_cave_prep)
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_cave_prep)
	
	; Make the forward guy impervious, so he's not getting reamed
	(unit_impervious (ai_actors e1_mars_inf0) true)

	; Wait until the player makes his move
	(sleep_until (volume_test_objects tv_e1_cave_go (players)))
	
	; Kill the fuck out of those fucking Covenant fuckers
	(ai_kill_silent e3_cov)
	(ai_kill_silent e4_cov)
	(ai_kill_silent e5_cov_inf5)
	
	; Wait until the player is looking at the ODST, with a timeout
	(sleep_until (objects_can_see_object (player0) (ai_get_object e1_mars_inf0/odst1) 10.0) 5 60)
	(sleep 20)
	
	; Throw the grenade
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_grenade_throw)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_grenade_throw)
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_grenade_throw)
	
	; Sleep until it has blown
	(sleep 70)

	; Send in the first ODST
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_enter_cave)
	
	; Wait, then send in the next
	(sleep 90)
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_enter_cave)

	; Wait, then send in the last
	(sleep 10)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_enter_cave)
	
	; Pervious them
	(unit_impervious (ai_actors e1_mars_inf0) false)
)

(script dormant e1_mars_follow_to_cave
	; Sleep
	(sleep_until g_e5_turret_exploded 5)

	; Pause while we wait for the flash to go away
	(sleep 100)
	
	; Dialog
	(e5_572_ODST)
	
	; FLAG for Jaime
	(set global_core_sarge true)

	; Give the ODSTs another command script to get them on their way
	(cs_run_command_script e1_mars_inf0 e1_odst_begin_cave_advance1)
	(cs_run_command_script e1_mars_inf1 e1_odst_begin_cave_advance0)
	
	; And then change their orders
	(ai_set_orders e1_mars_inf0 e1_mars_inf0_cave_advance0)
	(ai_set_orders e1_mars_inf1 e1_mars_inf0_cave_advance0)
	
	; The orders will handle it from here
)

(script dormant e1_mars_follow_to_sarge
	; Wait until the player makes his move and it's safe to go
	(sleep_until g_e1_mars_safe_to_go 5)
	(sleep_until (volume_test_objects tv_e1_advance_sarge (players)))
	
	; End the first failsafe, it is no longer needed
	(sleep_forever e1_mars_failsafe0)
	
	; Go go go, advance to Sarge
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_advance_sarge)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_advance_sarge)
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_advance_sarge)
	
	; Continue down the ramp once the Grunts are dead
	(sleep_until (volume_test_objects tv_e3_init (players)))
	(sleep_until (<= (ai_living_count e3_cov_stalkers) 1))

	; End the second failsafe, it is no longer needed
	(sleep_forever e1_mars_failsafe1)
	
	; Continue
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_cover_sarge)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_cover_sarge)
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_cover_sarge)

	; Sleep until the Grunt wave begins
;	(sleep_until g_e4_cov_inf0_charge)
	(sleep_until g_e4_cov_grunt_wave_go)
	
	; Release control to the AI, and apply the orders (just to be sure)
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_sarge_fight)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_sarge_fight)
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_sarge_fight)
	(ai_set_orders e1_mars_inf0 e1_mars_inf0_cover_sarge)
	(ai_set_orders e1_mars_inf1 e1_mars_inf1_cover_sarge)

	; Make them pervious (is that a word?)
	(unit_impervious (ai_actors e1_mars_inf0) false)
	(unit_impervious (ai_actors e1_mars_inf1) false)
)

(script dormant e1_mars_init
	; Place the AI
	(ai_place e1_mars_inf0)
	(ai_place e1_mars_inf1)
	
	; Render them invincible and impervious
	(object_cannot_take_damage (ai_actors e1_mars_inf0))
	(object_cannot_take_damage (ai_actors e1_mars_inf1))
	(unit_impervious (ai_actors e1_mars_inf0) true)
	(unit_impervious (ai_actors e1_mars_inf1) true)

	; Command scripts
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_entry)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_entry)
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_entry)
	
	; Sleep until our cue to return
	(sleep_until g_e1_odsts_return 5)

	; Command scripts
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_entry_return)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_entry_return)
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_entry_return)
	
	; Sleep until we continue
	(sleep_until g_e1_odsts_enter_hospital 5)

	; Continue
	(cs_run_command_script e1_mars_inf0/odst0 e1_odst_left0_entry_cont)
	(cs_run_command_script e1_mars_inf0/odst1 e1_odst_left1_entry_cont)
	(cs_run_command_script e1_mars_inf1/odst0 e1_odst_right0_entry_cont)
)

(script static void joe_odsts_enter_hospital
	(set g_e1_odsts_enter_hospital true)
)

(script static void joe_odsts_head_for_sarge
	(set g_e1_mars_safe_to_go true)
)

(script static void joe_odsts_head_for_cave
	(set g_e1_odsts_begin_cave_advance true)
)

(script static void joe_odsts_return
	(set g_e1_odsts_return true)
)

(script static void joe_bombs_away
	(set g_e5_bombs_away true)
)


;- Setup -----------------------------------------------------------------------

(script dormant e1_mars_inf2
	; Place the AI
	(ai_place e1_mars_inf2)
	
	; Command scripts
	(cs_run_command_script e1_mars_inf2/left0 e1_mars_inf2_left0_entry)
	(cs_run_command_script e1_mars_inf2/left1 e1_mars_inf2_left1_entry)
	(cs_run_command_script e1_mars_inf2/right0 e1_mars_inf2_right0_entry)
	(cs_run_command_script e1_mars_inf2/right1 e1_mars_inf2_right1_entry)

	; Wait till the player can't see them
	(sleep_until (volume_test_objects tv_e1_street (players)))
	
	; Purge them
	(ai_erase e1_mars_inf2)
)

(script static void e1_end
	; Sleep scripts
	(sleep_forever e1_mars_init)
	(sleep_forever e1_mars_failsafe0)
	(sleep_forever e1_mars_failsafe1)
	(sleep_forever e1_mars_follow_to_sarge)
	(sleep_forever e1_mars_follow_through_cave)
	(sleep_forever e1_mars_inf2)
	(sleep_forever e1_mars_follow_to_cave)
)

(script static void e1_cleanup
	; End scripts
	(e1_end)

	; Erase props
	(object_destroy_containing "e1_scenery")

	; Erase AI
	(ai_erase e1_mars)
)


;- Init ------------------------------------------------------------------------

(script dormant e1_init
	; Spew
	(if debug (print "e1_init"))

	; Wakey
	(wake e1_mars_init)
	(wake e1_mars_follow_to_sarge)
	(wake e1_mars_follow_to_cave)
	(wake e1_mars_follow_through_cave)
	(wake e1_mars_failsafe0)
	(wake e1_mars_failsafe1)
	
	; Sleep, then clean
	(sleep_until (volume_test_objects tv_e1_cleanup (players)))
	(e1_cleanup)
)

(script static void e1_test
	(object_destroy_containing "medic")
	(wake e1_init)
)


;= e0 - Hospital Flavor ========================================================
;- Command Scripts -------------------------------------------------------------

(global boolean g_e0_warthog0_passenger_exit false)
(script command_script cs_e0_warthog0_driver
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 3)
	(cs_go_to e0_warthog0/driver_pickup 1.0)
	(set g_e0_warthog0_passenger_exit true)
	(cs_pause 3)
	(cs_go_to_and_face e0_warthog0/driver_dest e0_warthog0/driver_dest_facing)
	(ai_erase ai_current_squad)
)

(script command_script cs_e0_warthog0_gunner
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 3)
	(cs_go_to e0_warthog0/gunner_load)
	(cs_go_to_vehicle (ai_vehicle_get e0_mars_warthog0/driver))
;	(vehicle_load_magic (ai_vehicle_get e0_mars_warthog0/driver) "warthog_g" (ai_get_unit ai_current_actor))
	(sleep 32000)
)

(script command_script cs_e0_warthog0_passenger
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 3)
	(cs_pause 1.0)
	(ai_exit_vehicle ai_current_actor)
	(cs_go_to e0_warthog0/passenger_p0)
	(cs_go_to e0_warthog0/passenger_erase)
	(ai_erase ai_current_actor)
)


;- Action ----------------------------------------------------------------------

(script dormant e0_mars_warthog0_main
	; Place the actors
	(ai_place e0_mars_warthog0)
	(sleep 5)
	
	; Run the command scripts on driver and gunner
	(cs_run_command_script e0_mars_warthog0/driver cs_e0_warthog0_driver)
	(cs_run_command_script e0_mars_warthog0/gunner cs_e0_warthog0_gunner)
	
	; Sleep until passenger should exit
	(sleep_until g_e0_warthog0_passenger_exit 2)
	
	; Give the passenger his command script
	(cs_run_command_script e0_mars_warthog0/passenger cs_e0_warthog0_passenger)
	
	; Sleep until we should cleanup
	(sleep_until (volume_test_objects tv_e0_cleanup (players)))
	(ai_erase e0_mars_warthog0)
)

(script static void joe_field_hospital_warthog_go
	(wake e0_mars_warthog0_main)
)


;= Ambient Explosions ==========================================================

(script continuous ambient_flak_explosions	
	(sleep 5)
	(begin_random
		(begin (effect_new effects\explosions\c_flak_explosion ambient_flak0) (sleep (random_range 20 60)))
		(begin (effect_new effects\explosions\c_flak_explosion ambient_flak1) (sleep (random_range 20 60)))
		(begin (effect_new effects\explosions\c_flak_explosion ambient_flak2) (sleep (random_range 20 60)))
		(begin (effect_new effects\explosions\c_flak_explosion ambient_flak3) (sleep (random_range 20 60)))
		(begin (effect_new effects\explosions\c_flak_explosion ambient_flak4) (sleep (random_range 20 60)))
	)
)

(script continuous ambient_gun_tower_explosions
	(sleep 5)
	(begin_random
		(begin (effect_new effects\bursts\guntower_burst ambient_blast0) (sleep (random_range 150 200)))
		(begin (effect_new effects\bursts\guntower_burst ambient_blast1) (sleep (random_range 150 200)))
		(begin (effect_new effects\bursts\guntower_burst ambient_blast2) (sleep (random_range 150 200)))
	)
)

(script static void joe_begin_flak
	(wake ambient_flak_explosions)
)

(script static void joe_end_flak
	(sleep_forever ambient_flak_explosions)
)

(script static void joe_begin_guntower_blasts
	(wake ambient_gun_tower_explosions)
)

(script static void joe_end_guntower_blasts
	(sleep_forever ambient_gun_tower_explosions)
)


;= Main ========================================================================

(global boolean g_joe_called_mission_start false)
(script startup mission_main
	; Shutdown scripts
	(sleep_forever e4_garbage_collecter)
	(sleep_forever warthog0_safety_net)
	(sleep_forever ambient_flak_explosions)
	(sleep_forever ambient_gun_tower_explosions)

	; Erase the fires
	(object_destroy_containing "_fire")
	(object_destroy_containing "bastard_joes_tunnel_lights")	; hee hee

	; Startup stuff
	(ai_allegiance human player)
	(object_cannot_take_damage (player0))
	
	; Sleep until Joe says Goe
	(sleep_until g_joe_called_mission_start 2)

	; Rise and shine!
	(wake e1_init)
	(wake e3_init)
	(wake e4_init)
	(wake e5_init)
	(wake e6_init)
	; e7 woken by e6
	(wake e8_init)
	(wake e9_init)
	(wake e10_init)
;	(wake outro_init)	Joe handles this now
		
	; FLAG for Jaime
	(set global_core_intro true)
)

(script static void joe_mission_start
	(set g_joe_called_mission_start true)	; No more double dipping for Joe
)


;= Misc ========================================================================

(script static boolean player_near_ai
	(and
		(> (objects_distance_to_object (ai_actors ai_current_squad) (list_get (players) 0)) 0)
		(<= (objects_distance_to_object (ai_actors ai_current_squad) (list_get (players) 0)) 15)
	)
)

(script static void oda
	(object_destroy_all)
)


