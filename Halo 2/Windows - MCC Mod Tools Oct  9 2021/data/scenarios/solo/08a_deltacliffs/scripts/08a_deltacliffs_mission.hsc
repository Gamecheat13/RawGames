;= DELTACLIFFS ===========================================================================
;*

*;
;- Globals ---------------------------------------------------------------------

; Mission over?
(global boolean g_mission_over false)		; Mission over?

; No more magic numbers (well, fewer anyway)
(global short 15_seconds 450)
(global short 30_seconds 900)
(global short 45_seconds 900)
(global short one_minute 1800)
(global short two_minutes 3600)

; Special characters (whee, hackerific)
(global unit g_cov_stealth_major none)
(global unit g_cov_gold_elite none)

; Alarm level for initial infantry encounters
(global short g_brute_alarm_level 0)


;- Stubs -----------------------------------------------------------------------

(script stub void c08_intro (print "c08_intro (cinematics failed to compile)"))
(script stub void c08_intra1 (print "c08_intro (cinematics failed to compile)"))


;= MISC ==================================================================================

(script static boolean player_in_vehicle
	(or
		(unit_in_vehicle (unit (player0)))
		(and 
			(game_is_cooperative)
			(unit_in_vehicle (unit (player1)))
		)
	)
)

(script static boolean players_in_vehicle
	(and
		(unit_in_vehicle (unit (player0)))
		(or 
			(not (game_is_cooperative))
			(unit_in_vehicle (unit (player1)))
		)
	)
)


;= SINEMATICS ============================================================================

(script static void cinematic_intro
	(if (cinematic_skip_start)
		(begin
			(c08_intro)
		)
	)
	(cinematic_skip_stop)
)

(script static void cinematic_outro
	(if (cinematic_skip_start)
		(begin
			(c08_intra1)
		)
	)
	(cinematic_skip_stop)
)


;= OBJECTIVES ============================================================================

(script dormant objective0_set
	(sleep 30)
	(print "new objective set: Defend yourself from the Brutes")
	(objectives_show_up_to 0)
)

(script dormant objective0_clear
	(print "objective complete: Defend yourself from the Brutes")
	(objectives_finish_up_to 0)
)

(script dormant objective1_set
	(sleep 30)
	(print "new objective set: Exact vengeance on the traitor Brutes")
	(objectives_show_up_to 1)
)

(script dormant objective1_clear
	(print "objective complete: Exact vengeance on the traitor Brutes")
	(objectives_finish_up_to 1)
)

(script dormant objective2_set
	(sleep 30)
	(print "new objective set: Continue to the canyon floor")
	(objectives_show_up_to 2)
)

(script dormant objective2_clear
	(print "objective complete: Continue to the canyon floor")
	(objectives_finish_up_to 2)
)

(script dormant objective3_set
	(sleep 30)
	(print "new objective set: Raze the Brute encampment")
	(objectives_show_up_to 3)
)


;= MUSIC =================================================================================

(script dormant music_08a_01_stop
	(print "music 08a_01 stop")
	(sound_looping_stop "scenarios\solo\08a_deltacliffs\08a_music\08a_01")
)

(script dormant music_08a_01_start_alt
	(print "music 08a_01 start alt")
	(sound_looping_set_alternate "scenarios\solo\08a_deltacliffs\08a_music\08a_01" true)
)

(script dormant music_08a_01_start
	(print "music 08a_01 start")
	(sound_looping_start "scenarios\solo\08a_deltacliffs\08a_music\08a_01" none 1.0)
)

(script dormant music_08a_02_stop
	(print "music 08a_02 stop")
	(sound_looping_stop "scenarios\solo\08a_deltacliffs\08a_music\08a_02")
)

(script dormant music_08a_02_start
	(print "music 08a_02 start")
	(sound_looping_start "scenarios\solo\08a_deltacliffs\08a_music\08a_02" none 1.0)
)

(script dormant music_08a_03_stop
	(print "music 08a_03 stop")
	(sound_looping_stop "scenarios\solo\08a_deltacliffs\08a_music\08a_03")
)

(script dormant music_08a_03_start_alt
	(print "music 08a_01 start alt")
	(sound_looping_set_alternate "scenarios\solo\08a_deltacliffs\08a_music\08a_03" true)
)

(script dormant music_08a_03_start
	(print "music 08a_03 start")
	(sound_looping_start "scenarios\solo\08a_deltacliffs\08a_music\08a_03" none 1.0)
)

(script dormant music_08a_04_start
	(print "music 08a_04 start")
	(sound_looping_start "scenarios\solo\08a_deltacliffs\08a_music\08a_04" none 1.0)
)

(script dormant music_08a_05_start
	(print "music 08a_05 start")
	(sound_looping_start "scenarios\solo\08a_deltacliffs\08a_music\08a_05" none 1.0)
)


;= CHAPTER TITLES ========================================================================

(script dormant chapter_title0
	(sleep 30)
	(cinematic_set_title title0)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

(script dormant chapter_title1
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

(script dormant chapter_title2
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)


;= ENCOUNTER 10 ==========================================================================
;*
The Dervish storms into a Brute encampment, complete with armory, and does
battle with the Brutes and a Phantom.

Begins when the player nears the bottom of the ski run.
Ends when the player exits kidney C.

Elites
	e10_cov_ghosts0 - e9_cov_ghosts0, Dervish's Elite allies
		(init) - Raise hell in the kidney
		(follow0) - Dismount and follow the Dervish
		(cower0) - When the Phantom shows up, cower
		(follow1) - Follow the Dervish after the Phantom dies
	e10_cov_inf0 - Insertion pod reinforcements
		(init) - Advance up to the bridge

Prophets
	e10_pro_inf0 - Brutes on the ground
		_0 - Brutes initially near the water, walking towards the ramp
			(init)
		_1 - Brutes who rush up to defend the archway
			(init)
	e10_pro_inf1 - Brutes on the upper level
		_0 - Brutes initially present near the ramp
		_1 - Brutes who first emerge from the armory, one with rocket launcher
			(init) - Guarding on top of the archway
		_2 - Brute reinforcements
			(defend0) - Defending along the upper level
	e10_pro_inf2 - Brutes guarding the exit
		(init) - Bold and out of cover, supported by the Phantom
		(retreat0) - Retreated back to the tunnel entrance
		(retreat1) - Retreating back into the tunnel
	e10_pro_wraith0 - A Wraith in the second section
		(init) - Blissfully unaware
		(engage0) - Guarding the water side
		(engage1) - Guarding the other side
	e10_pro_phantom0 - The Phantom
	e10_pro_ghosts0 - Ghosts at the end
		_0 - Ghosts bursting out from the exit
		_1 - Ghosts dropped off by the Phantom
			(init)

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e10_started false)			; Encounter has been activated?
(global short g_e10_pro_inf1_2_count 4)

(global unit g_e10_weapon_scene0_actor none) 		; You really don't need to know


;- Order Scripts ---------------------------------------------------------------

(script static boolean e10_player_dismounted
	(or
		(not (unit_in_vehicle (unit (player0))))
		(not (unit_in_vehicle (unit (player1))))
	)
)

(script static boolean e10_pro_inf_alerted
	(or
		(>= (ai_combat_status e10_pro_inf0) ai_combat_status_certain)
		(>= (ai_combat_status e10_pro_inf1) ai_combat_status_certain)
	)
)

(script static boolean e10_player_holding_launcher
	(unit_has_weapon (unit (player0)) "objects\weapons\support_high\rocket_launcher\rocket_launcher.weapon")
)

(script static boolean e10_pro_phantom0_should_retreat
	(or
		(>= (object_model_targets_destroyed (ai_vehicle_get e10_pro_phantom0/phantom0) "target_front") 3) 	
		(<= (object_get_health (ai_vehicle_get e10_pro_phantom0/phantom0)) 0.05) 
	)
)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e10_pro_phantom0_entry
	(cs_fly_by e10_pro_phantom0_entry/p0)
	(cs_fly_by e10_pro_phantom0_entry/p1)
	(cs_fly_to e10_pro_phantom0_entry/p2)
	(cs_fly_by e10_pro_phantom0_entry/p3)
	(cs_enable_targeting true)
	
	; If we're carrying Ghosts, drop them off
	(if (> (ai_spawn_count e10_pro_ghosts0_1) 0)
		(begin
			(cs_fly_to e10_pro_phantom0_entry/p3_1 0.5)
			(sleep 20)
			(vehicle_unload (ai_vehicle_get e10_pro_phantom0/phantom0) "phantom_sc")
			(sleep 40)
			(cs_fly_by e10_pro_phantom0_entry/p3)
		)
	)
	(cs_enable_moving true)

	; Sleep until the guns are destroyed, or a timeout
	(sleep_until 
		(e10_pro_phantom0_should_retreat) 
		30 
		one_minute
	)

	; Flee!
	(cs_enable_moving false)
	(cs_enable_targeting false)
	(cs_fly_to e10_pro_phantom0_entry/p3)
	(cs_fly_by e10_pro_phantom0_entry/p2)
	(cs_fly_by e10_pro_phantom0_entry/p4)
	(ai_erase ai_current_squad)
)

(script command_script cs_e10_weapon_scene0
	(cs_enable_pathfinding_failsafe true)
	(set g_e10_weapon_scene0_actor (ai_get_unit ai_current_actor))
	
	; Go to a point and look at the rocket launchers
	(cs_go_to e10_armory/p0)
	(cs_look true e10_armory/rocket_launchers)
	(sleep 10)
	(print "elite: what vulgar weapons")
	(ai_play_line ai_current_actor 0500)
	(sleep 30)
	(cs_look_player true)
	(sleep 45)
)

(script command_script cs_e10_weapon_scene1
	; Look at the Phantom
	(cs_look_object true (ai_vehicle_get e10_pro_phantom0/phantom0))
	(sleep 30)
	(cs_look_player true)
	(sleep 15)
	(print "elite: perhaps I spoke too soon")
	(sleep (ai_play_line_at_player ai_current_actor 0510))
)

(script command_script cs_e10_pro_inf1_0_patrol0
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_looking true)
	(sleep_until
		(begin
			; p0
			(cs_go_to e10_patrol/p0)
			(cs_enable_looking false)
			(cs_look true e10_patrol/f0)
			(sleep (random_range 90 120))
			(cs_look false e10_patrol/f0)
			(cs_enable_looking true)

			; p1
			(cs_go_to e10_patrol/p1)
			(cs_enable_looking false)
			(cs_look true e10_patrol/f1)
			(sleep (random_range 90 120))
			(cs_look false e10_patrol/f1)
			(cs_enable_looking true)
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e10_pro_inf1_0_patrol1
	(cs_abort_on_combat_status ai_combat_status_active)
	(sleep_until
		(begin
			; Shoot the point a bit
			(cs_go_to e10_patrol/p2)
			(cs_movement_mode ai_movement_combat)
			(cs_aim true e10_patrol/s0)
			(cs_look true e10_patrol/s0)
			(sleep (random_range 30 60))
			(cs_shoot_point true e10_patrol/s0)
			(sleep (random_range 60 150))
			(cs_shoot_point false e10_patrol/s0)
			(cs_look false e10_patrol/s0)
			(cs_aim false e10_patrol/s0)
			
			; Have a look
			(cs_movement_mode ai_movement_patrol)
			(cs_go_to e10_patrol/p3)
			(cs_look true e10_patrol/f1)
			(sleep (random_range 90 120))
			(cs_look false e10_patrol/f1)

			; Loop forever
			false
		)
	)
)

(script command_script cs_e10_pro_ghosts0_entry
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e10_pro_ghosts0/p0)
)


;- Entry Pods ------------------------------------------------------------------

(global effect g_e10_pod_impact_effect "effects\scenarios\solo\earthcity\e11_insertion_pod_impact")

(script dormant e10_pod0_insertion
	(ai_place e10_cov_inf0/elite0)
	(object_create e10_pod0_inserter)
	(objects_attach e10_pod0_inserter "pod_attach" (ai_vehicle_get e10_cov_inf0/elite0) "pod_attach")
	(sleep 1)
	(device_set_position e10_pod0_inserter 1.0)
	(sleep_until (>= (device_get_position e10_pod0_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e10_pod_impact_effect (ai_vehicle_get e10_cov_inf0/elite0) "pod_attach")	
	(objects_detach e10_pod0_inserter (ai_vehicle_get e10_cov_inf0/elite0))
	(object_destroy e10_pod0_inserter)
	
	(sleep (random_range 20 45))
	(ai_vehicle_exit e10_cov_inf0/elite0)
	(sleep 10)
	(object_damage_damage_section (ai_vehicle_get e10_cov_inf0/elite0) "door" 500)
)

(script dormant e10_pod1_insertion
	(ai_place e10_cov_inf0/elite1)
	(object_create e10_pod1_inserter)
	(objects_attach e10_pod1_inserter "pod_attach" (ai_vehicle_get e10_cov_inf0/elite1) "pod_attach")
	(sleep 1)
	(device_set_position e10_pod1_inserter 1.0)
	(sleep_until (>= (device_get_position e10_pod1_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e10_pod_impact_effect (ai_vehicle_get e10_cov_inf0/elite1) "pod_attach")	
	(objects_detach e10_pod1_inserter (ai_vehicle_get e10_cov_inf0/elite1))
	(object_destroy e10_pod1_inserter)
	
	(sleep (random_range 20 45))
	(ai_vehicle_exit e10_cov_inf0/elite1)
	(sleep 10)
	(object_damage_damage_section (ai_vehicle_get e10_cov_inf0/elite1) "door" 500)
)

(script dormant e10_pod2_insertion
	(ai_place e10_cov_inf0/elite2)
	(object_create e10_pod2_inserter)
	(objects_attach e10_pod2_inserter "pod_attach" (ai_vehicle_get e10_cov_inf0/elite2) "pod_attach")
	(sleep 1)
	(device_set_position e10_pod2_inserter 1.0)
	(sleep_until (>= (device_get_position e10_pod2_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e10_pod_impact_effect (ai_vehicle_get e10_cov_inf0/elite2) "pod_attach")	
	(objects_detach e10_pod2_inserter (ai_vehicle_get e10_cov_inf0/elite2))
	(object_destroy e10_pod2_inserter)
	
	(sleep (random_range 20 45))
	(ai_vehicle_exit e10_cov_inf0/elite2)
	(sleep 10)
	(object_damage_damage_section (ai_vehicle_get e10_cov_inf0/elite2) "door" 500)
)

(script dormant e10_pod3_insertion
	(ai_place e10_cov_inf0/elite3)
	(object_create e10_pod3_inserter)
	(objects_attach e10_pod3_inserter "pod_attach" (ai_vehicle_get e10_cov_inf0/elite3) "pod_attach")
	(sleep 1)
	(device_set_position e10_pod3_inserter 1.0)
	(sleep_until (>= (device_get_position e10_pod3_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e10_pod_impact_effect (ai_vehicle_get e10_cov_inf0/elite3) "pod_attach")	
	(objects_detach e10_pod3_inserter (ai_vehicle_get e10_cov_inf0/elite3))
	(object_destroy e10_pod3_inserter)
	
	(sleep (random_range 20 45))
	(ai_vehicle_exit e10_cov_inf0/elite3)
	(sleep 10)
	(object_damage_damage_section (ai_vehicle_get e10_cov_inf0/elite3) "door" 500)
)


;- Event Scripts ---------------------------------------------------------------

(script dormant e10_weapon_scene
	(sleep_until
		(and
			(volume_test_objects tv_e10_armory (players))
			(volume_test_objects tv_e10_armory (ai_actors e10_cov_inf0))
		)
	)
	
	; Start the scene
	(sleep_until
		(ai_scene e10_weapon_scene0 cs_e10_weapon_scene0 e10_cov_inf0)
		15
	)
	
	; Followup
	(sleep_until 
		(not (volume_test_objects tv_e10_armory (players))) 
		15
	)
	
	; Start the scene
	(sleep_until
		(ai_scene e10_weapon_scene1 cs_e10_weapon_scene1 (object_get_ai g_e10_weapon_scene0_actor))
		15
	)
)

(script dormant e10_fallback_checkpoint0
	(sleep_until (volume_test_objects tv_e10_armory (players)))
	(game_save)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e10_pro_phantom0_main
	(sleep_until 
		(or
			(volume_test_objects tv_e10_armory_entrance (players)) 
			(volume_test_objects tv_e10_second_half (players)) 
		)
		15
	)
	(game_save)
	
	; Send in the Phantom
	(ai_place e10_pro_phantom0)
	(cs_run_command_script e10_pro_phantom0/phantom0 cs_e10_pro_phantom0_entry)
	
	; If the Wrait is dead, load it with some Ghosts
	(if (<= (ai_living_count e10_pro_wraith0) 0)
		(ai_place_in_vehicle e10_pro_ghosts0_1 e10_pro_phantom0)
	)
)

(script dormant e10_pro_ghosts0_main
	(sleep_until 
		(volume_test_objects tv_e10_pro_inf2_retreat0 (players)) 
		15
	)
	(ai_place e10_pro_ghosts0_0)
	
	; If the player is in the exit, send one more Ghost through
	(sleep_until 
		(volume_test_objects tv_e10_pro_inf2_retreat2 (players)) 
		15
	)
	(ai_place e10_pro_ghosts0_0)
)

(script dormant e10_pro_wraith0_main
	(ai_place e10_pro_wraith0)
	
	; When both Wraiths are dead, checkpoint
	(sleep_until 
		(<= (ai_living_count e10_pro_wraith0) 0) 
		15
	)
	(game_save)
)

(script dormant e10_pro_inf3_main
	(ai_place e10_pro_inf3 1)
	
	; Place two more
	(sleep_until 
		(volume_test_objects tv_e10_bridge (players)) 
		15
	)
	(ai_place e10_pro_inf3)

	; Place two more
	(sleep_until 
		(volume_test_objects tv_e10_second_half (players)) 
		15
	)
	(ai_place e10_pro_inf3 (- 2 (ai_living_count e10_pro_inf3)))
	
	; Move their orders back
	(ai_set_orders e10_pro_inf3 e10_pro_inf3_retreat0)
)	

(script dormant e10_pro_inf2_main
	(sleep_until 
		(or
			(volume_test_objects tv_e10_armory_entrance (players)) 
			(volume_test_objects tv_e10_second_half (players)) 
		)
		15
	)
	
	; Wait for the player to advance or for the Wraith to be dead
	(sleep_until
		(or
			(<= (ai_living_count e10_pro_wraith0_1) 0)
			(volume_test_objects tv_e10_pro_inf2_retreat0 (players)) 
		)
		15
	)
	(ai_place e10_pro_inf2_0 (pin (- 7 (ai_living_count prophets)) 2 4))

	; Spawn reinforcements as the player advances
	(sleep_until (volume_test_objects tv_e10_pro_inf2_retreat0 (players)) 15)
	
	; Start up the fallback guard
	(wake e10_fallback_checkpoint0)

	; Continue
	(sleep 60)
	(ai_place e10_pro_inf2_1 (pin (- 7 (ai_living_count prophets)) 0 4))
	(sleep_until (volume_test_objects tv_e10_near_exit (players)) 15)
	(ai_place e10_pro_inf2_1 (pin (- 7 (ai_living_count prophets)) 0 4))
	(sleep_until (volume_test_objects tv_e10_pro_inf2_retreat2 (players)) 15)
	(ai_place e10_pro_inf2_1 (pin (- 7 (ai_living_count prophets)) 0 4))
)

(script dormant e10_pro_inf1_main
	(ai_place e10_pro_inf1_0)
	
	; Wait until alerted, send in the reins
	(sleep_until (e10_pro_inf_alerted))
	(sleep_until (volume_test_objects tv_e10_inf1_1_init (players)) 15 300)
	(ai_place e10_pro_inf1_1)
	
	; Wait until he's upstairs
	(sleep_until (volume_test_objects tv_e10_inf1_2_init (players)) 15)

	; Difficulty tweaker
	(if (difficulty_normal) (set g_e10_pro_inf1_2_count 3))
	
	; Sleep until he can get a checkpoint, or he's near the armory
	(sleep_until
		(or
			(game_safe_to_save)
			(volume_test_objects tv_e10_pro_inf1_do_or_die (players))
		)
		15
	)
	(game_save)

	; Reinforcements respawner
	(sleep_until
		(begin
			; If necessary, spawn
			(if (<= (ai_living_count e10_pro_inf1) 2)
				(begin
					; Spawn and pause
					(game_save)
					(sleep_until (volume_test_objects tv_e10_armory_entrance (players)) 15 450)
					(ai_place e10_pro_inf1_2 (pin (- 4 (ai_living_count e10_pro_inf1)) 1 g_e10_pro_inf1_2_count))
					(set g_e10_pro_inf1_2_count (- g_e10_pro_inf1_2_count 1))
				)
			)
		
			; End when we've spawned enough, or the player is too far ahead
			(or
				(<= g_e10_pro_inf1_2_count 0)
				(volume_test_objects tv_e10_armory_entrance (players))
			)
		)
		15
	)
	
	; If the player is in the armory at this point, he's probably hard charging, so mark the Brutes as disposable
	(if (volume_test_objects tv_e10_armory_entrance (players))
		(ai_disposable e10_pro_inf1 true)
	)
		
	; Checkpoint
	(sleep_until (<= (ai_living_count e10_pro_inf1) 0))
	(game_save)
)

(script dormant e10_pro_inf0_main
	(ai_place e10_pro_inf0_0)

	; Slip in a save
	(sleep_until 
		(or
			(volume_test_objects tv_e10_armory_entrance (players)) 
			(volume_test_objects tv_e10_second_half (players)) 
		)
		15
	)
	(game_save)
)

(script dormant e10_cov_inf0_main
	; Wait until he's on the bridge, and then until the Wraith is dead
	(sleep_until (volume_test_objects tv_e10_bridge (players)) 15)
	(sleep_until (<= (ai_living_count e10_pro_wraith0_0) 0))
	
	; Send in the pods
	(wake e10_pod0_insertion)
	(sleep 30)
	(wake e10_pod1_insertion)
	;(sleep 8)
	;(wake e10_pod2_insertion)
	;(sleep 15)
	;(wake e10_pod3_insertion)
	
	; Wake the scene
	(wake e10_weapon_scene)
)

(script dormant e10_cov_ghosts0_main
	(ai_migrate e9_cov_ghosts0 e10_cov_ghosts0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e10_key
	(if (not (difficulty_legendary)) (sleep_forever))
	(object_create key)
	(sleep_until 
		(or
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	)
	(ice_cream_flavor_stock 7) ; Ghost
)

(script dormant e10_main
	(sleep_until (volume_test_objects tv_e10_main_begin (players)) 15)
	(set g_e10_started true)
	(print "e10_main")
	(data_mine_set_mission_segment "e10_brute_camp")
	(game_save)
	;(garbage_collect_now)
	
	; Music
	(wake music_08a_04_start)
	
	; Chapter titles
	(wake chapter_title2)
		
	; Objectives
	(wake objective2_clear)
	(wake objective3_set)
	
	; Wake subsequent scripts
	(wake e10_cov_ghosts0_main)
	(wake e10_cov_inf0_main)
	(wake e10_pro_inf0_main)
	(wake e10_pro_inf1_main)
	(wake e10_pro_inf2_main)
	(wake e10_pro_inf3_main)
	(wake e10_pro_ghosts0_main)
	(wake e10_pro_wraith0_main)
	(wake e10_key)

	; More music when the player exits
	(sleep_until 
		(and
			(volume_test_objects tv_e10_exit_door (players))
			(> (device_get_position e10_exit_door) 0)
		)
		15
	)
)

(script static void test_brute_camp
	(object_teleport (player0) e10_test)
	(ai_place e10_cov_ghosts0)
	(if (not g_e10_started) (wake e10_main))
	(ai_place e9_pro_inf3)
)


;= ENCOUNTER 9 ===========================================================================
;*
The player goes bombing down a long ravine.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e9_cov_ghosts0 - e8_cov_ghosts0, allied Ghosts

Prophets
	e9_pro_inf0 - Jackals near the top of the run
		(init)
	e9_pro_inf1 - Brutes halfway down, waiting in ambush
		(init)
	e9_pro_inf2 - Jackals supporting them
		(init)

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e9_started false)				; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e9_pro_inf1_trap
	(cs_enable_dialogue true)
	(cs_abort_on_damage true)
	(cs_face_object true e9_trap_target0)
	(sleep_until (volume_test_objects tv_e9_trap_trigger0 (players)) 5)
	(cs_face_object false e9_trap_target0)

	; Fire on the first trap
	(cs_shoot true e9_trap_target0)
	(sleep_until 
		(or
			(<= (object_get_health e9_trap_target0) 0) 
			(volume_test_objects tv_e9_trap_trigger1 (players))
		)
		2
	)

	; Pause once that trap is triggered
	(cs_shoot false e9_trap_target0)
	(sleep_until (volume_test_objects tv_e9_trap_trigger1 (players)) 5)

	; Hit the second target
	(cs_shoot true e9_trap_target1)
	(sleep_until 
		(<= (object_get_health e9_trap_target1) 0) 
		2
		30
	)

	(sleep (random_range 20 60))
)

(script command_script cs_e9_pro_inf1_abort
	(sleep 1)
)

(script command_script cs_e9_pro_phantom0_overflight
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e9_pro_phantom0/p0)
	(cs_fly_by e9_pro_phantom0/p1)
	(cs_fly_by e9_pro_phantom0/p2)
	(cs_fly_by e9_pro_phantom0/p3)
	(ai_erase ai_current_squad)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e9_weather_control
	(weather_stop 120)	
	(sleep_until (volume_test_objects tv_e9_first_drop (players)) 15)
	(weather_stop 90)
	(sleep_until (volume_test_objects tv_e9_trap_trigger1 (players)) 15)
	(weather_stop 60)
	(sleep_until (volume_test_objects tv_e9_pro_inf3_begin (players)) 15)
	(weather_stop 30)
	(sleep_until (volume_test_objects tv_e10_entrance (players)) 15)
	(weather_stop 15)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e9_pro_phantom0_main
	(ai_place e9_pro_phantom0)
)

(script dormant e9_pro_inf3_main
	(sleep_until (volume_test_objects tv_e9_pro_inf3_begin (players)) 15)
	(game_save)
	(ai_place e9_pro_inf3)
)

(script dormant e9_pro_inf2_main
	(sleep_until (volume_test_objects tv_e9_first_drop (players)) 15)
	(ai_place e9_pro_inf2 (pin (- 10 (ai_living_count prophets)) 2 4))
)

(script dormant e9_pro_inf1_main
	(sleep_until (volume_test_objects tv_e9_first_drop (players)) 15)
	(ai_place e9_pro_inf1)
	
	; Start their command scripts
	(cs_run_command_script e9_pro_inf1 cs_e9_pro_inf1_trap)
	
	; Break them out if necessary
	(sleep_until (volume_test_objects tv_e9_trap_trigger0 (players)) 5)
	(sleep_until (< (ai_strength e9_pro_inf1) 0.9) 15 300)	
	(cs_run_command_script e9_pro_inf1 cs_e9_pro_inf1_abort)
)

(script dormant e9_pro_inf0_main
	(ai_place e9_pro_inf0_0 (pin (- 10 (ai_living_count prophets)) 0 2))
	(ai_place e9_pro_inf0_1 (pin (- 10 (ai_living_count prophets)) 0 2))
	
	; Checkpoint
	(sleep_until
		(or
			(volume_test_objects tv_e9_trap_trigger0 (players))
			(<= (ai_living_count e9_pro_inf0) 0)
		)
		5
	)
	(game_save)
	
	; Resume
	(sleep_until (volume_test_objects tv_e9_trap_trigger0 (players)) 5)
	(ai_place e9_pro_inf0_2 (pin (- 10 (ai_living_count prophets)) 0 2))
)

(script dormant e9_cov_ghosts0_main
	(ai_place e9_cov_ghosts0)
	
	; Migrate over the survivors once everyone is mostly dead
	(sleep_until 
		(and
			(<= (ai_living_count e8_pro_spectre0) 0)
			(<= (ai_living_count e8_pro) 2)
		)
	)
	(ai_migrate e8_cov_inf0 e9_cov_ghosts0)
	(ai_migrate e8_cov_ghosts0 e9_cov_ghosts0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e9_main
	(sleep_until (volume_test_objects tv_e9_main_begin (players)) 15)
	(set g_e9_started true)
	(print "e9_main")
	(data_mine_set_mission_segment "e9_ski_run")
	(game_save)
	;(garbage_collect_now)
	
	; Music
	(wake music_08a_03_stop)

	; Wake subsequent scripts
	(wake e10_main)

	; Wake control scripts
	(wake e9_cov_ghosts0_main)
	(wake e9_pro_inf0_main)
	(wake e9_pro_inf1_main)
	(wake e9_pro_inf2_main)
	(wake e9_pro_inf3_main)
	(wake e9_pro_phantom0_main)
	(wake e9_weather_control)
	
	; Shut down
	(sleep_until g_e10_started)
	(sleep_forever e9_pro_inf0_main)
	(sleep_forever e9_pro_inf1_main)
	(sleep_forever e9_pro_inf2_main)
	(sleep_forever e9_pro_inf3_main)
	(sleep_forever e9_pro_phantom0_main)
	
	; Condemn
	(ai_disposable e9_pro true)
	(ai_disposable e9_pro_phantom0 false)
)

(script static void test_ski_run
	(object_teleport (player0) e9_test)
	(ai_place e9_cov_ghosts0)
	(if (not g_e9_started) (wake e9_main))
)


;= ENCOUNTER 8 ===========================================================================
;*
The player and his Ghost allies engage a Shadow in the second kidney section.

Begins when the player enters the second kidney.
Ends when the player enters the ski run.

Elites
	e8_cov_ghosts0 - e7_cov_ghosts0, allied Ghosts, PLUS reins when actually placed
		(init) - Free roam over the canyon
		(continue) - Continue on

Prophets
	e8_pro_inf0 - Jackals, snipers on the central cover
		(init)
	e8_pro_inf1 - Defenders on the barricade cover
		_0 - Initial Jackals
		_1 - Heavily armed Brute reinforcements
			(init)
	e8_pro_spectre0 - Brute Shadow lurking in the kidney
		(init) - Idle in the middle
		(engage) - Engaging over the whole kidney
		(follow) - Follow the player if he flees into the ski run

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e8_started false)				; Encounter has been activated?


;- Order Scripts ---------------------------------------------------------------
;- Command Scripts -------------------------------------------------------------

(script command_script cs_e8_cov_inf0_init
	; Wait until you see the player
	(cs_enable_dialogue true)
	(cs_movement_mode ai_movement_patrol)
	(ai_disregard (ai_get_object ai_current_actor) true)
	(cs_enable_looking true)
	
	; When you see the player, freak out and hide
	(sleep_until
		(ai_trigger_test generic_player_sighted ai_current_squad)
		10
	)
	(cs_movement_mode ai_movement_flee)
	(cs_enable_moving true)
	
	; Wait until the Spectre is dead, or the player is near, some period of time
	(sleep_until (volume_test_objects tv_e8_spectre_begin (players)) 15)
	(sleep_until
		(or
			(and
				(> (ai_spawn_count e8_pro_spectre0) 0)
				(<= (ai_living_count e8_pro_spectre0) 1)
			)
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 2)
		)
		10
		450
	)
	
	; Fight back
	(sleep (random_range 0 45))
	(cs_movement_mode ai_movement_combat)
	
	; Man the turret
	(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_starting_location e8_cov_inf0/turret0))
	(ai_disregard (ai_get_object ai_current_actor) false)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e8_pro_spectre0_main
	(sleep 30)
	(sleep_until 
		(or
			(volume_test_objects tv_e8_exit (players))
			(<= (ai_living_count e8_pro) 2)
		)
		15
	)
	(ai_place e8_pro_spectre0)
	(sleep 1)
	(ai_vehicle_reserve_seat (ai_vehicle_get e8_pro_spectre0/starting_locations_0) "spectre_p_l" true)
	
	; Music 
	(wake music_08a_03_start_alt)
	
	; Ideal end trigger (backup in e9_main)
	(sleep_until (<= (ai_living_count e8_pro_spectre0) 0))
	(wake music_08a_03_stop)
)

(script dormant e8_pro_inf2_main
	(ai_place e8_pro_inf2)
)

(script dormant e8_pro_inf1_main
	(ai_place e8_pro_inf1_0)
	
	; If the Shadow is dead, the barricades are dead, or the initial blockade are dead...
	(sleep_until
		(or
			(<= (ai_living_count e8_pro_inf1) 0)
			(volume_test_objects tv_e8_exit (players))
		)
	)
	
	; Send in an appropriate number of reinforcements
	(ai_place e8_pro_inf1_1 (- 4 (ai_living_count e8_pro_inf1)))
)

(script dormant e8_pro_inf0_main
	(ai_place e8_pro_inf0)
)

(script dormant e8_cov_inf0_main
	(ai_place e8_cov_inf0 (pin (- 6 (ai_living_count covenant)) 4 6)) ; REVEIW

	; Reserved them
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e8_cov_inf0/ghost0) true)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e8_cov_inf0/ghost1) true)

	; Unreserve them
	(sleep_until (volume_test_objects tv_e9_main_begin (players)) 15)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e8_cov_inf0/ghost0) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e8_cov_inf0/ghost1) false)
)

(script dormant e8_cov_ghosts0_main
	(ai_migrate e7_cov_ghosts0 e8_cov_ghosts0)
	(ai_migrate e7_cov_ghosts1 e8_cov_ghosts0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e8_main
	(sleep_until (volume_test_objects tv_e8_main_begin (players)) 15)
	(set g_e8_started true)
	(print "e8_main")
	(data_mine_set_mission_segment "e8_kidney1")
	(game_save)
	;(garbage_collect_now)
	
	; Start the rain falling over the next two minutes
	(weather_start 120)
	
	; Wake subsequent scripts
	(wake e9_main)

	; Wake control scripts
	(wake e8_cov_inf0_main)
	(wake e8_cov_ghosts0_main)
	(wake e8_pro_inf0_main)
	(wake e8_pro_inf1_main)
	(wake e8_pro_inf2_main)
	(wake e8_pro_spectre0_main)
	
	; Shut down
	(sleep_until g_e9_started)
;	(sleep_forever e8_cov_inf0_main)
	(sleep_forever e8_cov_ghosts0_main)
	(sleep_forever e8_pro_inf0_main)
	(sleep_forever e8_pro_inf1_main)
	(sleep_forever e8_pro_inf2_main)
	(sleep_forever e8_pro_spectre0_main)
	
	; Condemn
	(ai_disposable e8_pro true)
)


;= ENCOUNTER 7 ===========================================================================
;*
The player and his allies intervene to save some Elites in the first kidney
canyon section.

Begins when the player enters the kidney.
Ends when the player enters the next kidney.

Elites
	e7_cov_ghosts0 - e6_cov_ghosts0, allied Ghosts
		(init) - Engaging all forces
		(continue) - Continuing to the next kidney

Prophets
	e7_pro_inf0	- Initial defenses
		(defend0) - Defending among the trees
		_0 - Defenders at the first blockade
			(init) - At the first rock
		_1 - Defenders at the second point, with a turret
			(init) - At the second rock
	e7_pro_inf1 - Respawning defenders
		_0 - Wave from very close around the corner
		_1 - Wave from further back around the corner
		_2 - Wave from the Ghost ledge
			(defend0) - Defending the front half
			(defend1) - Defending the back half
	e7_pro_inf2 - Snipers

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e7_started false)				; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e7_cov_grunt0
	(cs_movement_mode ai_movement_patrol)
	(ai_disregard (ai_get_object ai_current_actor) true)
	(cs_enable_looking true)

	; Patrol until they see the player
	(sleep_until
		(or
			(ai_trigger_test generic_player_sighted ai_current_squad)
			(>= (ai_combat_status e7_pro_inf0_0) ai_combat_status_active)
		)
		15
	)
	
	; Look at the player as realization dawns...
	(cs_enable_dialogue true)
	(cs_face_player true)
	(sleep (random_range 25 45))
	
	; Freak out and hide
	(cs_movement_mode ai_movement_flee)
	(cs_face_player false)
	(cs_enable_looking true)
	(cs_go_to e7_patrol/p0_2)
	
	; Wait until the Brutes are dead
	(sleep_until 
		(and
			(not (vehicle_test_seat_list (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost0) "c_turret_ap_d" (ai_actors e7_pro_inf0)))
			(not (volume_test_objects tv_e7_grunts_unsafe (ai_actors e7_pro_inf0))) 
		)
		60
	)
	
	; Calm down
	(cs_movement_mode ai_movement_combat)
	(sleep (random_range 25 45))
	
	; Load up
	(ai_disregard (ai_get_object ai_current_actor) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost0) false)
	(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost0))
)

(script command_script cs_e7_cov_grunt1
	(cs_movement_mode ai_movement_patrol)
	(ai_disregard (ai_get_object ai_current_actor) true)
	(cs_enable_looking true)
	
	; Patrol until they see the player
	(sleep_until
		(or
			(ai_trigger_test generic_player_sighted ai_current_squad)
			(>= (ai_combat_status e7_pro_inf0_0) ai_combat_status_active)
		)
		15
	)
	
	; Look at the player as realization dawns...
	(cs_enable_dialogue true)
	(cs_face_player true)
	(sleep (random_range 25 45))
	
	; Freak out and hide
	(cs_movement_mode ai_movement_flee)
	(cs_face_player false)
	(cs_enable_looking true)
	(cs_go_to e7_patrol/p1_2)
	
	; Wait until the Brutes are dead
	(sleep_until 
		(and
			(not (vehicle_test_seat_list (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost0) "c_turret_ap_d" (ai_actors e7_pro_inf0)))
			(not (volume_test_objects tv_e7_grunts_unsafe (ai_actors e7_pro_inf0))) 
		)
		60
	)
	
	; Calm down
	(cs_movement_mode ai_movement_combat)
	(sleep (random_range 25 45))
	
	; Load up
	(ai_disregard (ai_get_object ai_current_actor) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost1) false)
	(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost1))
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e7_pro_inf2_main
	(ai_place e7_pro_inf2)
)

(script static void e7_pro_inf1_spawn
	; Try waiting for a few seconds to do the ideal spawn
	(sleep_until (not (volume_test_objects tv_e7_pro_inf1_0_unsafe (players))) 10 60)

	; First choice, around the corner
	(if (not (volume_test_objects tv_e7_pro_inf1_0_unsafe (players)))
		(ai_place e7_pro_inf1_0)
		
		; Else, around the corner unless the player is camping
		(if (not (volume_test_objects tv_e7_end_section (players)))
			(ai_place e7_pro_inf1_1)
			
			; Failing that, then try the last spot
			(if (not (volume_test_objects tv_e7_pro_inf1_2_unsafe (players)))
				(ai_place e7_pro_inf1_2)
			)
		)
	)
)

(script dormant e7_pro_inf1_main
	; Wait until the player moves up, or inf0 is dead
	(sleep_until 
		(or
			(<= (ai_living_count e7_pro_inf0) 1)
			(volume_test_objects tv_e7_middle_section (players)) 
		)
		15
	)
	
	; Migrate back the first squad
	(ai_migrate e7_pro_inf0 e7_pro_inf1_0)

	; Begin the respawner
	(sleep_until
		(begin
			; Respawn as necessary
			(if (<= (ai_living_count e7_pro_inf) 2)
				(e7_pro_inf1_spawn)
			)
		
			; Loop until...
			(or
				(volume_test_objects tv_e8_main_begin (players))
				(>= (ai_spawn_count e7_pro_inf1) 16)
			)
		)
		15
	)
)

(script dormant e7_pro_inf0_main
	(ai_place e7_pro_inf0_0 (pin (- 10 (ai_living_count prophets)) 1 3))
	(ai_place e7_pro_inf0_1)
)

(script dormant e7_cov_ghosts1_main
	(ai_place e7_cov_ghosts1 (pin (- 4 (ai_living_count e7_cov_ghosts0)) 2 4))

	; Reserved them
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost0) true)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost1) true)

	; Unreserve them
	(sleep_until (not (volume_test_objects tv_e7_grunts_unsafe (ai_actors e7_pro_inf0))) 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost0) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e7_cov_ghosts1/ghost1) false)
)

(script dormant e7_cov_ghosts0_main
	(ai_migrate e6_cov e7_cov_ghosts0)
	
	; Start the Grunts
	(wake e7_cov_ghosts1_main)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e7_main
	(sleep_until 
		(or
			(volume_test_objects tv_e7_main_begin0 (players)) 
			(volume_test_objects tv_e7_main_begin1 (players)) 
		)
		15
	)
	(set g_e7_started true)
	(print "e7_main")
	(data_mine_set_mission_segment "e7_kidney0")
	(game_save)
	;(garbage_collect_now)
	
	; Music
	(wake music_08a_03_start)
	
	; Wake subsequent scripts
	(wake e8_main)

	; Wake control scripts
	(wake e7_cov_ghosts0_main)
	(wake e7_pro_inf0_main)
	(wake e7_pro_inf1_main)
	(wake e7_pro_inf2_main)
	
	; Shut down
	(sleep_until g_e8_started)
	(sleep_forever e7_cov_ghosts0_main)
	(sleep_forever e7_cov_ghosts1_main)
	(sleep_forever e7_pro_inf0_main)
	(sleep_forever e7_pro_inf1_main)
	(sleep_forever e7_pro_inf2_main)
	
	; Condemn
	(sleep_until g_e8_started)
	(ai_disposable e7_pro true)
)

(script static void test_kidney0
	(object_teleport (player0) e7_test)
	(if (not g_e7_started) (wake e7_main))
	(sleep 1)
	(drop "objects\vehicles\ghost\ghost")
)


;= ENCOUNTER 6 ===========================================================================
;*
The Brutes attempt an ambush, and the Dervish gets a Ghost.

Begins when the player switches back to the exterior BSP
Ends when the player has a ghost and enters kidney A

Elites
	e6_cov_inf0 - e5_cov_inf0
		(init) - Waiting at the door until the player exits
		(advance0) - Engaging just outside the door
		(advance1) - Under the rock arch
		(continue) - Continue with the player
	e6_cov_inf1 - Stealth Elites over the cliff tops
		(init) - Moving up to the ledge and firing on e6_pro_creep0
		(advance0) - Moving down when e6_pro_creep0 is weakened
	e6_cov_ghosts0 - Ghosts waiting for the player's use
		(follow0) - Load into the Ghosts and follow the player
	e6_cov_gold_elite - e5_cov_gold_elite
		(chopchop) - Engage everyone in the universe

Prophets
	e6_pro_inf0 - Infantry defenders
		_0 - Brutes covering the door
			(init) - Defending under the gun tower
		_1 - Buggers who pop up over the ledge
			(init) - Engaging before and on the gun tower
	e6_pro_creep0 - A Creep and crew who enter from the kidneys
		(init) - Move in and engage
	e6_pro_phantoms0 - Phantoms for shooting at

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e6_started false)				; Encounter has been activated?

(global boolean g_e6_pro_inf1_arrived false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e6_weapon_scene
	(sleep (ai_play_line_at_player ai_current_actor 0480))
)

(script dormant e6_weapon_scene
	(sleep_until
		(or
			(ai_scene e6_weapon_scene cs_e6_weapon_scene e6_cov)
			(<= (ai_living_count e6_pro_inf1) 0)
		)
		15
		two_minutes
	)
	
	; Try again if they're dead
	(sleep_until
		(ai_scene e6_weapon_scene cs_e6_weapon_scene e6_cov)
		15
		300
	)
)

(script command_script cs_e6_pro_phantom0_entry
	(cs_vehicle_boost true)
	(cs_fly_by e6_pro_phantom0_entry/p0)
	(cs_vehicle_boost false)
	(cs_fly_by e6_pro_phantom0_entry/p0_1)
	(cs_fly_to_and_face e6_pro_phantom0_entry/p1 e6_pro_phantom0_entry/p2 1.0)
	
	; Move in and drop
	(cs_vehicle_speed 0.5)
	(cs_fly_to e6_pro_phantom0_entry/p2 0.5)
	
	; Empty passengers
	(sleep_until 
		(or
			(ai_trigger_test e6_player_exited_onto_ledge e6_pro_inf1)	; REVIEW
			g_e7_started
			(volume_test_objects tv_e6_ledge0 (players))
			(volume_test_objects tv_e6_ledge1 (players))
		)
		15
	)
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) true)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_a")
	(sleep 100)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_b")
	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) false)
	(set g_e6_pro_inf1_arrived true)
	
	; Wake the weapon scene
	(wake e6_weapon_scene)

	; Back out
	(cs_vehicle_speed 1.0)
	(cs_fly_to_and_face e6_pro_phantom0_entry/p3 e6_pro_phantom0_entry/p2)
)


(script command_script cs_e6_pro_phantom0_exit
	(cs_fly_to_and_face e6_pro_phantom0_exit/p0 e6_pro_phantom0_exit/p1)
	(cs_vehicle_boost true)
	(cs_fly_to e6_pro_phantom0_exit/p1)
	(ai_erase ai_current_squad)
)


(script command_script cs_e6_pro_inf0_1_firing
	(cs_abort_on_damage true)
	(cs_aim true e6_pro_inf0_ambush/p0)
	(cs_crouch true)

	; Wait for the door to open a crack
	(sleep_until (> (device_get_position e6_ghost_ledge_door) 0) 15)
	(cs_enable_dialogue true)
	(sleep 15)
	(cs_aim false e6_pro_inf0_ambush/p0)
	
	; Open fire
	(cs_enable_targeting true)
	(sleep_until 
		(or
			(volume_test_objects tv_e6_on_ledge0 (players))
			(< (ai_strength ai_current_squad) 0.95)
		)
		10
		90 ; Timeout after 5 seconds
	)
	
	; Wait another two seconds
	(sleep_until 
		(< (ai_strength ai_current_squad) 0.95)
		10
		60 ; Timeout after 5 seconds
	)
)

(script command_script cs_e6_pro_inf0_0_firing
	(cs_abort_on_damage true)
	(cs_aim true e6_pro_inf0_ambush/p0)

	; Wait for the door to open a crack
	(sleep_until (> (device_get_position e6_ghost_ledge_door) 0) 15)
	(cs_enable_dialogue true)
	(sleep 15)
	(cs_aim false e6_pro_inf0_ambush/p0)
	
	; Open fire
	(cs_enable_targeting true)
	(sleep_until 
		(or
			(volume_test_objects tv_e6_on_ledge0 (players))
			(< (ai_strength ai_current_squad) 0.95)
		)
		10
		90 ; Timeout after 5 seconds
	)
)

(script command_script cs_e6_pro_inf1_entry
	(cs_vehicle_boost true)
	(cs_go_to e6_pro_inf1_entry/p0)
	(ai_vehicle_exit ai_current_actor)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e6_pro_phantom0_should_retreat
	(or
		(>= (object_model_targets_destroyed (ai_vehicle_get e6_pro_phantom0/phantom0) "target_front") 3) 	
		(<= (object_get_health (ai_vehicle_get e6_pro_phantom0/phantom0)) 0.05) 
	)
)


;- Event Scripts ---------------------------------------------------------------

(script dormant e6_objectives
	; Wait until the Phantom has spawned, then left, or the player has charged
	(sleep_until (> (ai_spawn_count e6_pro_phantom0) 0))
	(sleep_until 
		(or
			(e6_pro_phantom0_should_retreat)
			(volume_test_objects tv_e7_main_begin0 (players))
			(volume_test_objects tv_e7_main_begin1 (players))
		)
	)
	
	; Clear and set
	(wake objective1_clear)
	(wake objective2_set)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e6_pro_phantom0_main
	; Wait for the door to open, then for the player to exit (or a timeout)
	(sleep_until (> (device_get_position e6_ghost_ledge_door) 0) 15)
	(sleep_until
		(volume_test_objects tv_e6_on_ledge0 (players))
		15
		210
	)
	
	; Send in the Phantom
	(ai_place e6_pro_phantom0)
	
	; Wait for him to leave
	(sleep_until g_e6_pro_inf1_arrived)
	(sleep_until
		(or
			g_e7_started
			(>= (object_model_targets_destroyed (ai_vehicle_get e6_pro_phantom0/phantom0) "target_front") 3) 
			(<= (object_get_health (ai_vehicle_get e6_pro_phantom0/phantom0)) 0.05)
			(and
				g_e6_pro_inf1_arrived
				(<= (ai_living_count e6_pro_inf1) 0)
			)
		)
	)
	(cs_run_command_script e6_pro_phantom0/phantom0 cs_e6_pro_phantom0_exit)
)

(script dormant e6_pro_inf1_main
	(sleep_until
		(volume_test_objects tv_e6_pro_inf1_begin (players))
		15
	)
	(ai_place e6_pro_inf1 (pin (- 6 (ai_living_count e6_pro_inf0)) 2 6))
)

(script dormant e6_pro_inf0_main
	(ai_place e6_pro_inf0)
	(sleep 6)
	(objects_predict (ai_actors e6_pro_inf0))
)

(script dormant e6_cov_ghosts0_main
	(ai_place e6_cov_ghosts0)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e6_cov_ghosts0/ghost0) true)
;	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e6_cov_ghosts0/ghost1) true)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e6_cov_ghosts0/ghost2) true)
;	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e6_cov_ghosts0/ghost3) true)
	
	; Wait until the they're all dead!
	(sleep_until g_e6_pro_inf1_arrived)
	(sleep_until
		(or
			(and
				(<= (ai_living_count e6_pro_inf0) 0)
				(<= (ai_living_count e6_pro_inf1) 0)
				(> (ai_spawn_count e6_pro_inf1) 0)
			)
			g_e7_started
			(player_in_vehicle)
		)
		30
		two_minutes
	)
	
	; Free them!
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e6_cov_ghosts0/ghost0) false)
;	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e6_cov_ghosts0/ghost1) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e6_cov_ghosts0/ghost2) false)
;	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location e6_cov_ghosts0/ghost3) false)
	
	; Grab the Elites
	(ai_migrate e6_cov_inf0 e6_cov_ghosts0)
	(ai_migrate e6_cov_gold_elite e6_cov_ghosts0)
	(ai_enter_squad_vehicles e6_cov_ghosts0)
	
	; Music, ideal trigger (backup trigger in e7_main
	(sleep_until (player_in_vehicle))
	(wake music_08a_03_start)
)

(script dormant e6_cov_gold_elite_main
	(ai_migrate e5_cov_gold_elite e6_cov_gold_elite)
	(ai_teleport_to_starting_location_if_outside_bsp e6_cov_gold_elite)
)

(script dormant e6_cov_inf1_main
;*	(sleep_until
		(> (ai_combat_status e6_pro_creep0) ai_combat_status_certain)
	)
	(sleep 300)
	
	; Send in the elites
	(ai_place e6_cov_inf1 (pin (- 2 (ai_living_count e6_cov)) 0 2))
	
	; When everyone is dead, migrate them
	(sleep_until
		(<= (ai_living_count e6_pro) 0)
	)
	(ai_migrate e6_cov_inf1 e6_cov_ghosts0)
	*;
	(sleep 1)
)

(script dormant e6_cov_grunts0_main
	(ai_migrate e5_cov_grunts0 e6_cov_grunts0)
	(ai_teleport_to_starting_location_if_outside_bsp e6_cov_grunts0)
)

(script dormant e6_cov_inf0_main
	(ai_migrate e5_cov_inf0 e6_cov_inf0)
	(ai_teleport_to_starting_location_if_outside_bsp e6_cov_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e6_main
	(sleep_until 
		(and
			(volume_test_objects tv_e6_main_begin (players))
			(= (structure_bsp_index) 0)
		)
		15
	)
	(set g_e6_started true)
	(print "e6_main")
	(data_mine_set_mission_segment "e6_ghost_ledge")
	(game_save)
	
	; Unlock the door
	(device_operates_automatically_set e6_ghost_ledge_door true)

	; Chapter titles
	(wake chapter_title1)
		
	; Wake subsequent scripts
	(wake e7_main)

	; Wake control scripts
	(wake e6_cov_inf0_main)
;	(wake e6_cov_inf1_main)
	(wake e6_cov_gold_elite_main)
	(wake e6_cov_ghosts0_main)
	(wake e6_cov_grunts0_main)
	(wake e6_pro_inf0_main)
	(wake e6_pro_inf1_main)	
;	(wake e6_pro_phantom0_main)
	
	; Condemn
	(sleep_until g_e7_started)
	(ai_disposable e6_pro true)
	(ai_disposable e6_pro_phantom0 false)
)

(script static void test_ghost_ledge
	(object_teleport (player0) e6_test)
	(ai_place e6_cov_inf0)
	(ai_place e6_cov_gold_elite)
	(if (not g_e6_started) (wake e6_main))
)


;= ENCOUNTER 5 ===========================================================================
;*
Another ramp room, this time with a better prepared defense.

Begins when the player enters the ramp hall.
Ends when the player leaves the room.

Elites
	e5_cov_inf0 - e4_cov_inf0
		(init) - More cautious positions along the ledge
		(advance0) - Advance onto the ground floor
		(advance1) - Advance into the BSP swap room
	e5_cov_gold_elite - e4_cov_gold_elite
		(init) - More cautious than usual, creeping down the ramp
		(killomatic) - The usual
		(advance0) - Advance into the BSP swap room

Prophets
	e5_pro_inf0 - Initial defenders
		(init) - Defending the door
	e5_pro_inf1 - Reinforcements from the exit
		(init) - Charging the ledge
		(retreat0) - Beaten back down

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e5_started false)				; Encounter has been activated?
(global short g_e5_grunts_released 0)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e5_cov_gold_elite_creep
	(cs_enable_dialogue true)
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e5_cov_gold_elite_creep/p0)
	(cs_crouch true)
	
	; Wait until the Brutes are being engaged
	(sleep_until (>= (ai_combat_status e5_pro_inf0) ai_combat_status_dangerous))
	(sleep 60)
	(cs_go_to e5_cov_gold_elite_creep/p1)
	
	; Keep waiting, the main script will break him out
	(sleep_forever)
)

(script command_script cs_e5_cov_gold_elite_attack
	(cs_crouch false)
)

(script command_script cs_e5_cov_grunts0_cower
	(cs_movement_mode ai_movement_flee)

	; Make everyone ignore them
	(ai_disregard ai_current_actor true)
	
	; Sleep until our enemies are dead, or we're being abused
	(sleep_until
		(or
			(< (ai_living_count e5_pro) 3)
			(<= (ai_strength e5_cov_grunts0) 0.8)
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0.75)
			(>= g_e5_grunts_released 2)
		)
		15
	)
	(set g_e5_grunts_released (+ g_e5_grunts_released 1))
	(cs_enable_dialogue true)
	(cs_look_player true)
	(sleep (random_range 15 45))

	; Make them part of the fight again
	(ai_disregard ai_current_actor false)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e5_pro_inf1_main
	(sleep_until
		(or	
			(volume_test_objects tv_e5_exit (players))
			(and
				(<= (ai_living_count e5_pro_inf0) 3)
				(> (ai_spawn_count e5_pro_inf0) 0)
			)
		)
		20
	)
	
	; Place reinforcements from the exit
	(ai_place e5_pro_inf1 (pin (- 10 (ai_living_count prophets)) 1 4))
)

(script dormant e5_pro_inf0_main
	(ai_place e5_pro_inf0 (pin (- 10 (ai_living_count prophets)) 2 6))
	
	; Lock down the turets
	(ai_vehicle_reserve (ai_vehicle_get e5_pro_inf0/turret0) true)
)

(script dormant e5_cov_grunts0_main
	(ai_place e5_cov_grunts0 (pin (- 10 (+ (ai_living_count covenant) (ai_living_count prophets))) 1 5))
)

(script dormant e5_cov_gold_elite_main
	(ai_migrate e4_cov_gold_elite e5_cov_gold_elite)
	(ai_renew e5_cov_gold_elite)
	
	; Have him sneak up
	(cs_run_command_script e5_cov_gold_elite cs_e5_cov_gold_elite_creep)
	
	; Sleep until he's been damaged, or the player advanced
	(sleep_until
		(or
			(< (ai_strength e5_cov_gold_elite) 1.0)
			(< (ai_strength e5_pro_inf0) 0.5)
			(volume_test_objects tv_e5_lower_level (players))
		)
		5
	)
	
	; Break him out
	(cs_run_command_script e5_cov_gold_elite cs_e5_cov_gold_elite_attack)
	(ai_set_orders e5_cov_gold_elite e5_cov_gold_elite_killomatic)
)

(script dormant e5_cov_inf0_main
	(ai_migrate e4_cov_inf0 e5_cov_inf0)
	(ai_renew e5_cov_inf0)

	; Place some Grunts
	(wake e5_cov_grunts0_main)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e5_main
	(sleep_until (volume_test_objects tv_e5_main_begin (players)) 15)
	(set g_e5_started true)
	(print "e5_main")
	(data_mine_set_mission_segment "e5_ramp_room1")
	(game_save)
	;(garbage_collect_now)
	
	; Wake subsequent scripts

	; Wake control scripts
	(wake e5_cov_inf0_main)
	(wake e5_cov_gold_elite_main)
	(wake e5_pro_inf0_main)
	(wake e5_pro_inf1_main)
	
	; Shut down
	(sleep_until g_e6_started)
	(sleep_forever e5_cov_inf0_main)
	(sleep_forever e5_cov_gold_elite_main)
	(sleep_forever e5_pro_inf0_main)
	(sleep_forever e5_pro_inf1_main)
	
	; Condemn
	(ai_disposable e5_pro true)
)

(script static void test_ramp_room2
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e5_test)
	(ai_place e5_cov_inf0)
	(ai_place e5_cov_gold_elite)
	(if (not g_e5_started) (wake e5_main))
	(if (not g_e6_started) (wake e6_main))
)


;= ENCOUNTER 4 ===========================================================================
;*
The Dervish and his allies enter a room with three large steps down. Murderosity
ensues.

Begins when the player enters the room.
Ends when everyone is dead or the player has left the room.

Elites
	e4_cov_inf0 - e3_cov_inf0, plus reinforcements at the bottom
		(init) - Positions on the top level
		(advance0) - Positions on the second ledge
		(advance1) - Positions on the third ledge
		(advance2) - Positions on the ground by the door
		(follow) - Follow the player once everyone is dead
	e4_cov_gold_elite - e3_cov_gold_elite
		(advance0) - Positions on the second ledge
		(advance1) - Positions on the third ledge
		(advance2) - Positions on the ground by the door
		(continue) - Continue on his merry way

Prophets
	e4_pro_inf0 - Initial defenders
		_0 - Jackals on second ledge
			(init) - Defend in vain
		_1 - Buggers on the rafters
			(init) - Fighting from the rafters
	e4_pro_inf1 - Brutes on the third ledge
		(init) - Defend in vain
	e4_pro_inf2 - Door defenders
		_0 - Brutes who guard the door
			(init) - Defending the door
			(follow) - Follow the player into the next room if he rushes past
		_1 - Buggers who head for the rafters
			(init) - Fighting from the rafters

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e4_started false)				; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e4_alarm_scene
	(cs_switch "brute0")
	(sleep (ai_play_line ai_current_actor 0450))

	; Go rouse the pack
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e4_alarm_scene/p0)
	(sleep (ai_play_line ai_current_actor 0400))
	(sleep (- (ai_play_line ai_current_actor 0440) 30))
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e4_pro_inf2_main
	(sleep_until (volume_test_objects tv_e4_first_step (players)) 15)
	(ai_place e4_pro_inf2_0 (pin (- 10 (ai_living_count prophets)) 1 4))
	
	; Run the scene
	(sleep 150)
	(sleep_until 
		(or
			(ai_scene e4_alarm_scene cs_e4_alarm_scene e4_pro_inf0)
			(<= (ai_living_count e4_pro_inf2_0) 0)
		)
		15
	)
)

(script dormant e4_pro_inf1_main
	(sleep_until (volume_test_objects tv_e4_second_step (players)) 15)
	(game_save)
	(sleep 15)
	(ai_place e4_pro_inf1 (pin (- 10 (ai_living_count prophets)) 1 4))
)

(script dormant e4_pro_inf0_main
	(ai_place e4_pro_inf0_0 (pin (- 10 (ai_living_count prophets)) 1 5))
)

(script dormant e4_cov_gold_elite_main
	(ai_migrate e3_cov_gold_elite e4_cov_gold_elite)
	(ai_renew e4_cov_gold_elite)
)

(script dormant e4_cov_inf0_main
	(ai_migrate e3_cov_inf0 e4_cov_inf0)
	(ai_renew e4_cov_inf0)
	
	; If necessary, spawn reins
	(sleep_until 
		(volume_test_objects tv_e4_first_step (players))
		15
	)

	; And then wait until the living count is reduced, or the player is charging
	(sleep_until 
		(or
			(volume_test_objects tv_e4_ground_floor_exit (players))
			(<= (ai_fighting_count e4_pro) 2)
		)		
		15
	)
	
	; Place reins if necessary
	(device_operates_automatically_set e4_door0 true)
	(ai_place e4_cov_inf0 (pin (- 3 (ai_living_count covenant)) 1 3))
	(ai_set_orders e4_cov_inf0 e4_cov_inf0_advance2)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e4_main
	(sleep_until (volume_test_objects tv_e4_pre_main (players)) 15)
	(game_save)
	(sleep_until (volume_test_objects tv_e4_main_begin (players)) 15)
	(set g_e4_started true)
	(print "e4_main")
	(data_mine_set_mission_segment "e4_step_room")
	;(garbage_collect_now)
	
	; Wake subsequent scripts
	(wake e5_main)

	; Wake control scripts
	(wake e4_cov_inf0_main)
	(wake e4_cov_gold_elite_main)
	(wake e4_pro_inf0_main)
	(wake e4_pro_inf1_main)
	(wake e4_pro_inf2_main)
	
	; Shut down
	(sleep_until g_e5_started)
	(sleep_forever e4_cov_inf0_main)
	(sleep_forever e4_cov_gold_elite_main)
	(sleep_forever e4_pro_inf0_main)
	(sleep_forever e4_pro_inf1_main)
	(sleep_forever e4_pro_inf2_main)
	
	; Condemn
	(ai_disposable e4_pro true)
)


;= ENCOUNTER 3 ===========================================================================
;*
A ramp room between the cylinder room and the step room.

Begins when the player enters the ramp hall.
Ends when the player leaves the room.

Elites
	e3_cov_inf0 - e2_cov_inf0
		(init) - Positions on the ledge
		(advance0) - Move down when Brutes are dead
		(advance1) - Advance into step room
	e3_cov_gold_elite - e2_cov_gold_elite
		(murder) - Kill everything in this room
		(continue) - Continue to the next one
	e3_cov_grunt0 - A hapless grunt who illustrates their plight

Prophets
	e3_pro_inf0 - Door defenders
		_0 - Pair of Brutes
			(init) - Defending the door
		_1 - Half a dozen Jackals
			(init) - Defending the door
			(retreat) - Retreat into the step room when weakened

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e3_started false)				; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e3_alarm_scene
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e3_alarm_scene/p0)
	(sleep (ai_play_line ai_current_actor 0410))
	(sleep (ai_play_line ai_current_actor 0440))
)

(script command_script cs_e3_cov_grunts0_cower
	(cs_movement_mode ai_movement_flee)
	(sleep_until 
		(and
		; Player close and...
			(ai_trigger_test generic_player_within_2wu ai_current_squad)
			(or
				; Brutes gone
				(not (volume_test_objects tv_e3_lower_level (ai_actors e3_pro_inf0)))
				
				; Taken damage
				(<= (ai_strength ai_current_squad) 0.5)
			)
		)
	)
	(cs_look_player true)
	(print "grunt scene")
	(ai_play_line_at_player ai_current_actor 0460)
	(sleep_forever)
)

(script command_script cs_e3_cov_gold_elite_charge
	(cs_enable_dialogue true)
	(cs_go_to e3_sword_elites/p0)
	(cs_go_to e3_sword_elites/p1)
	(cs_jump 10 4)
)

(script command_script cs_e3_cov_stealth_major_charge
	(cs_enable_pathfinding_failsafe true)
	(ai_set_active_camo ai_current_actor true)
	(cs_go_to e3_sword_elites/p2)
	(cs_go_to e3_sword_elites/p3)
	(ai_set_active_camo ai_current_actor false)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e3_pro_inf1_main
	; Wait to get closer to the door
	(sleep_until 
		(and
			(> (device_get_position e3_exit_door) 0)
			(volume_test_objects tv_e3_near_exit (players)) 
		)
		15
	)
	(ai_place e3_pro_inf1)
)

(script dormant e3_pro_inf0_main
	(sleep 5)
	(ai_place e3_pro_inf0_0)
	(ai_place e3_pro_inf0_1 (pin (- 8 (ai_living_count prophets)) 1 4))
	
	; Run the scene
	(sleep_until 
		(or
			(ai_scene e3_alarm_scene cs_e3_alarm_scene e3_pro_inf0)
			(<= (ai_living_count e3_pro_inf0) 0)
		)
		15
	)
)

(script dormant e3_cov_grunts0_main
	(ai_place e3_cov_grunts0)
	
	; Make everyone ignore him
	(ai_disregard (ai_actors e3_cov_grunts0) true)
	
	; Run his command script
	(cs_run_command_script e3_cov_grunts0 cs_e3_cov_grunts0_cower)
)

(script dormant e3_cov_gold_elite_main
	(ai_migrate e2_cov_gold_elite e3_cov_gold_elite)
	(ai_renew e3_cov_gold_elite)
	
	; Have him run and leap down on the enemy
	(cs_run_command_script e3_cov_gold_elite cs_e3_cov_gold_elite_charge)
)

(script dormant e3_cov_inf0_main
	(ai_migrate e2_cov_inf0 e3_cov_inf0)
	(ai_renew e3_cov_inf0)
	
	; Send in the stealth major
	(cs_run_command_script (object_get_ai g_cov_stealth_major) cs_e3_cov_stealth_major_charge)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e3_main
	(sleep_until (volume_test_objects tv_e3_main_begin (players)) 15)
	(set g_e3_started true)
	(print "e3_main")
	(data_mine_set_mission_segment "e3_ramp_room0")
	(game_save)
	;(garbage_collect_now)
	
	; Wake subsequent scripts
	(wake e4_main)

	; Wake control scripts
	(wake e3_cov_inf0_main)
	(wake e3_cov_gold_elite_main)
	(wake e3_cov_grunts0_main)
	(wake e3_pro_inf0_main)
	(wake e3_pro_inf1_main)
	
	; Shut down
	(sleep_until g_e4_started)
	(sleep_forever e3_cov_inf0_main)
	(sleep_forever e3_cov_gold_elite_main)
	(sleep_forever e3_cov_grunts0_main)
	(sleep_forever e3_pro_inf0_main)
	(sleep_forever e3_pro_inf1_main)

	; Condemn
	(ai_disposable e3_pro true)
)

(script static void test_ramp_room1
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e3_test)
	(ai_place e3_cov_inf0)
	(set g_cov_stealth_major (ai_get_unit e3_cov_inf0/stealth_major))
	(ai_place e3_cov_gold_elite)
	(if (not g_e3_started) (wake e3_main))
)


;= ENCOUNTER 2 ===========================================================================
;*
Fortified with allies, the Dervish forges on to punish more Brutes in the dual
cylinder room.

Begins when the player enters the BSP swap room.
Ends when the player exits the cylinder room.

Elites
	e2_cov_inf0 - e1_cov_inf1 + e1_cov_inf2
		(init) - Controlling first cylinder
		(advance0) - Controlling second cylinder
		(advance1) - Controlling ramp corner
		(advance2) - Controlling exit
		(follow) - Follow the player
	e2_cov_gold_elite - e1_cov_inf2/gold0, the Gold Elite
		(init) - Move into the room, flanking
		-> continue on using e2_cov_inf0's orders
	e2_cov_grunts0 - Hapless Grunts who flee as soon as they see the player
		(init) - Watching from the ledge
		(flee) - Flee in terror

Prophets
	e2_pro_inf0 - Brutes and Jackals on the first cylinder
		(init) - Defending the first cylinder
	e2_pro_inf1 - Brutes and Jackals on the second cylinder
	e2_pro_inf2 - Jackals on the rock path
	e2_pro_inf3 - Brutes and Buggers at the exit

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e2_started false)				; Encounter has been activated?
(global boolean g_e2_safe_to_migrate_inf2 false) 	; Is it safe to migrate e1_cov_inf2?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e2_alarm_scene
	; Brute 0 tells the other to go raise the alarm
	(cs_switch "brute0")
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(sleep (ai_play_line_at_player ai_current_actor 0420))
	(sleep (ai_play_line_at_player ai_current_actor 0430))	
	(cs_enable_dialogue true)
	
	; Brute 1 goes and does it
	(cs_switch "brute1")
	(cs_enable_moving false)
	(cs_enable_targeting true)
	(cs_enable_pathfinding_failsafe true)
	(cs_start_to e2_alarm_scene/p0)
	
	; Wait until he's arrived or it's dead
	(sleep_until 
		(or
			(not (cs_moving))
			(<= (object_get_health e2_antennae) 0)
		)
		5
	)

	; Take control again
	(cs_enable_targeting false)

	; Is the antennae still alive?
	(if (> (object_get_health e2_antennae) 0)
		; The anntennae is still alive
		(begin
			; Operate the panel
			(cs_face_object true e2_antennae)
			(print "brute1 operates the antennae")
			
			; Do so for two seconds, or until the antennae is destroyed
			(sleep_until
				(<= (object_get_health e2_antennae) 0)
				5
				60
			)
			
			; If the antennae is still alive...
			(if (> (object_get_health e2_antennae) 0)
				; Successful alarm raised
				(begin
					(set g_brute_alarm_level (+ g_brute_alarm_level 1))
				)

				; The antennae was destroyed
				(begin
					(print "brute1 growls")
					(sleep 20)
				)				
			)
		)
		
		; The antennae was destroyed
		(begin
			(print "brute1 growls")
			(sleep 20)
		)
	)
)

(script command_script cs_e2_cov_grunts0_flee
	(cs_enable_dialogue true)
	(cs_face_player true)
	(sleep (random_range 0 60))
	(cs_face_player false)
	(cs_movement_mode ai_movement_flee)

	; Random flee
	(sleep_until
		(begin
			(begin_random
				; Random p0
				(begin
					(ai_renew ai_current_actor)
					(cs_start_to e2_cov_grunts_flee/p0)
					(sleep_until
						(or
							(not (cs_moving))
							(< (object_get_health (ai_get_object ai_current_actor)) 1.0)
							(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 1)
						)
						5
					)
				)
		
				; Random p1
				(begin
					(ai_renew ai_current_actor)
					(cs_start_to e2_cov_grunts_flee/p1)
					(sleep_until
						(or
							(not (cs_moving))
							(< (object_get_health (ai_get_object ai_current_actor)) 1.0)
							(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 1)
						)
						5
					)
				)
		
				; Random p2
				(begin
					(ai_renew ai_current_actor)
					(cs_start_to e2_cov_grunts_flee/p2)
					(sleep_until
						(or
							(not (cs_moving))
							(< (object_get_health (ai_get_object ai_current_actor)) 1.0)
							(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 1)
						)
						5
					)
				)
		
				; Random p3
				(begin
					(ai_renew ai_current_actor)
					(cs_start_to e2_cov_grunts_flee/p3)
					(sleep_until
						(or
							(not (cs_moving))
							(< (object_get_health (ai_get_object ai_current_actor)) 1.0)
							(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 1)
						)
						5
					)
				)
		
				; Random p4
				(begin
					(ai_renew ai_current_actor)
					(cs_start_to e2_cov_grunts_flee/p4)
					(sleep_until
						(or
							(not (cs_moving))
							(< (object_get_health (ai_get_object ai_current_actor)) 1.0)
							(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 1)
						)
						5
					)
				)
		
				; Random p5
				(begin
					(ai_renew ai_current_actor)
					(cs_start_to e2_cov_grunts_flee/p5)
					(sleep_until
						(or
							(not (cs_moving))
							(< (object_get_health (ai_get_object ai_current_actor)) 1.0)
							(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 1)
						)
						5
					)
				)
			)

			; Loop unit you're close to a unit
			(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 1)
		)
	)

	; Regard him
	(ai_disregard (ai_get_object ai_current_actor) false)
	(ai_migrate ai_current_actor e2_cov_inf0)
)

(script command_script cs_e2_cov_grunts0_abort
	(if (<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 2)
		(cs_crouch true)
		(sleep_until (> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 4))
	)
)

(script command_script cs_e2_cov_gold_elite_charge0
	(cs_enable_moving true)
	(cs_enable_looking true)
	(sleep_until (= (structure_bsp_index) 1))
	(cs_enable_moving false)
	(cs_enable_looking false)
	(ai_play_line ai_current_actor 0370)	
	(cs_go_to e2_sword_elites/p0)
	(cs_enable_dialogue true)
	(cs_start_to e2_sword_elites/p1)
	(sleep_until
		(or
			(not (cs_moving))
			(<= (objects_distance_to_object (ai_actors e2_pro_inf0) (ai_get_object ai_current_actor)) 2)
		)
	)
)

(script command_script cs_e2_cov_stealth_elite_charge0
	(cs_enable_moving true)
	(cs_enable_looking true)
	(sleep_until (= (structure_bsp_index) 1))
	(cs_enable_moving false)
	(cs_enable_looking false)
	(ai_renew ai_current_actor)
	(ai_set_active_camo ai_current_actor true)
	(cs_go_to e2_sword_elites/p2)

	; Hunker down
	(cs_crouch true)
	(cs_face true e2_sword_elites/p1)
	(cs_start_to e2_sword_elites/p3)
	(sleep_until
		(or
			(<= (objects_distance_to_object (ai_actors e2_pro_inf0) (ai_get_object ai_current_actor)) 2)
			(<= (ai_strength ai_current_actor) 0.75)
			(<= (ai_living_count e2_pro_inf0) 1)
		)
	)
	(ai_set_active_camo ai_current_actor false)
)


;- Order Scripts ---------------------------------------------------------------

(script static void e2_cov_sword_elites_charge0
	(cs_run_command_script e2_cov_gold_elite cs_e2_cov_gold_elite_charge0)
	(cs_run_command_script (object_get_ai g_cov_stealth_major) cs_e2_cov_stealth_elite_charge0)
)


;- Scene Scripts ---------------------------------------------------------------

(script dormant e2_alarm_scene
	; Wait till the Brutes have been alerted
	(sleep_until (>= (ai_combat_status e2_pro_inf0) ai_combat_status_visible) 15)
	
	; Try to engage the scene for up to 10 seconds
	(sleep_until
		(ai_scene e2_alarm_scene cs_e2_alarm_scene e2_pro_inf0)
		15
		300
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e2_pro_inf3_main
	; Wait for the player to advance, or for inf1 to be depleted
	(sleep_until 
		(or
			(and
				(> (ai_spawn_count e2_pro_inf1) 0)
				(<= (ai_living_count e2_pro_inf1) 0)
			)
			(volume_test_objects tv_e2_pro_inf3_begin (players))
		)
	)
	(ai_place e2_pro_inf3 (pin (- 9 (ai_living_count prophets)) 2 6))

	; Wait for and attempt a game save after these guys
	(sleep_until 
		(and
			(<= (ai_living_count e2_pro_inf3) 0)
			(game_safe_to_save)
		)
	)
	(game_save)
)

(script dormant e2_pro_inf2_main
	; Wait, for performance reasons
	(sleep_until 
		(or
			(<= (ai_living_count e2_pro_inf0) 2)
			(volume_test_objects tv_e2_pro_inf1_begin (players))
		)
	)

	; Send out the Jackals
	(ai_place e2_pro_inf2)
)

(script dormant e2_pro_inf1_main
	; Wait for the player to advance, or for inf0 to be depleted
	(sleep_until 
		(or
			(<= (ai_living_count e2_pro_inf0) 0)
			(volume_test_objects tv_e2_pro_inf1_begin (players))
		)
	)

	; Try to slip in a save
	(game_save)
	(sleep 15)

	; Place reins
	(ai_place e2_pro_inf1 (pin (- 6 (ai_living_count e2_pro_inf0)) 0 4))
)

(script dormant e2_pro_inf0_main
	(ai_place e2_pro_inf0)
	(wake e2_alarm_scene)
)

(script dormant e2_cov_grunts0_main
	(ai_place e2_cov_grunts0)
	
	; Make everyone ignore them
	(ai_disregard (ai_actors e2_cov_grunts0) true)
	
	; Sleep until the trigger has fired
	(sleep_until (ai_trigger_test generic_player_sighted e2_cov_grunts0) 5)
	(sleep (ai_play_line_at_player e2_cov_grunts0/grunt0 0330))

	; Scatter
	(cs_run_command_script e2_cov_grunts0 cs_e2_cov_grunts0_flee)
	(sleep 300)
	
	; Wait until the Brutes are dead...
	(sleep_until
		(and
			(<= (ai_living_count e2_pro) 4)
			(<= (ai_fighting_count e2_pro) 0)
		)
	)
	
	; Ally them with the player
	(cs_run_command_script e2_cov_grunts0 cs_e2_cov_grunts0_abort)
	(ai_disregard (ai_actors e2_cov_grunts0) false)
	(ai_migrate e2_cov_grunts0 e2_cov_inf0)
)

(script dormant e2_cov_gold_elite_main
	(sleep_until g_e2_safe_to_migrate_inf2)

	; First, migrate over gold elite
	(ai_migrate e1_cov_inf2/gold_elite e2_cov_gold_elite)

	; Then migrate the rest
	(ai_migrate e1_cov_inf2 e2_cov_inf0)
	
	; Teleport them if necessary
	(sleep 5)
	(ai_teleport_to_starting_location_if_outside_bsp e2_cov_inf0)
	(ai_teleport_to_starting_location_if_outside_bsp e2_cov_gold_elite)
	(ai_renew e2_cov_gold_elite)
)

(script dormant e2_cov_inf1_main
	; Sleep until reins might be needed
	(sleep_until (volume_test_objects tv_e2_pro_inf1_begin (players)) 15)
	
	; Music
	(wake music_08a_02_stop)
	
	; Wait for reins to be necessary
	(sleep_until (<= (ai_living_count e2_cov) 1))
	(sleep_until (not (volume_test_objects tv_e2_cov_inf1_unsafe (players))) 15)

	; Place them
	(ai_place e2_cov_inf1)
	
	; Move them into the main group
	(ai_migrate e2_cov_inf1 e2_cov_inf0)
)

(script dormant e2_cov_inf0_main
	(sleep_until (> (ai_spawn_count e1_cov_inf1) 0))
	(ai_migrate e1_cov_inf1 e2_cov_inf0)
	
	; Teleport them if necessary
	(sleep_until (= (structure_bsp_index) 1) 15)
	(ai_teleport_to_starting_location_if_outside_bsp e2_cov_inf0)
	(ai_renew e2_cov_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e2_main
	(sleep_until (= (structure_bsp_index) 1) 15)
	(set g_e2_started true)
	(print "e2_main")
	(data_mine_set_mission_segment "e2_cylinder_room")
	(game_save)
	;(garbage_collect_now)
	
	; Music
	(wake music_08a_01_stop)
	(wake music_08a_02_start)
	
	; Wake subsequent scripts
	(wake e3_main)

	; Wake control scripts
	(wake e2_cov_inf0_main)
	(wake e2_cov_inf1_main)
	(wake e2_cov_gold_elite_main)
	(wake e2_cov_grunts0_main)
	(wake e2_pro_inf0_main)	
	(wake e2_pro_inf1_main)
	(wake e2_pro_inf2_main)
	(wake e2_pro_inf3_main)
	
	; Shut down
	(sleep_until (volume_test_objects tv_e2_main_end (players)) 15)
	(sleep_forever e2_cov_inf0_main)
	(sleep_forever e2_cov_inf1_main)
	(sleep_forever e2_cov_gold_elite_main)
	(sleep_forever e2_cov_grunts0_main)
	(sleep_forever e2_pro_inf0_main)
	(sleep_forever e2_pro_inf1_main)
	(sleep_forever e2_pro_inf2_main)
	(sleep_forever e2_pro_inf3_main)
	
	; Condemn
	(ai_disposable e2_pro true)

	; Clean up
;	(sleep_until )
)

(script static void test_cylinder_room
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e2_test)
	(ai_place e2_cov_inf0)
	(set g_cov_stealth_major (ai_get_unit e2_cov_inf0/stealth_major))
	(ai_place e2_cov_gold_elite)
	(if (not g_e2_started) (wake e2_main))
)


;= ENCOUNTER 1 ===========================================================================
;*
The Dervish has teleported near the scene of a massacre, and must arm himself
and move stealthily through a wooded outcropping.

Begins at the start of the level.
Ends when the Dervish enters the first BSP swap.

Elites
	e1_cov_inf0 - Impaled Elite who doesn't do much except talk and die
	e1_cov_inf1 - Trio of Stealth Elites, including Stealth Major
		(init) - Positioning but not engaging
		(engage0) - Engaging the Brutes
		(wait0) - Waiting at the door for the Dervish
		(follow0) - Following the Dervish
	e1_cov_inf2 - Elite reinforcements via e1_cov_phantom0, including Gold Elite
		(init) - Charging into the BSP swap zone
	e1_cov_phantom0 - Ill fated Phantom which delivers e1_cov_inf2

Prophets
	e1_pro_inf0 - Brutes roaming around, molesting dead Elites
		_0 - Lone Brute patrol
		_1 - Dual Brute patrol
		_2 - Guards near ramp
			(init) - Idle, roaming around and molesting corpses
			(alert) - Alerted, free roam
		_3 - Guards near door
			(init) - Standing guard near the door
	e1_pro_inf1 - Brute captain, arriving from the entrance
		(init) - Active in the clearing and a short ways into the paths

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e1_started false)				; Encounter has been activated?

(global unit g_e1_wounded_elite none)
(global boolean g_e1_cov_inf0_should_die false)
(global boolean g_e1_pro_inf0_searching false)		; The Captain has ordered the search
(global boolean g_e1_pro_inf1_was_alerted false)	; The Captain was alerted
(global boolean g_e1_stealth_major_done false)
(global boolean g_e1_zealot_revealed false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e1_pro_inf0_0_patrol0
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_uninspected)
	
	; Shoot the first elite
	(cs_go_to e1_pro_inf0_0_patrol/p0)
	(cs_aim_object true e1_elite0)
	(ai_play_line_at_player ai_current_actor 0230)
	(sleep 15)
	(cs_aim_object false e1_elite0)
	(cs_shoot true e1_elite0) 
	(sleep 30)
	(cs_shoot false e1_elite0)
	(sleep (random_range 30 60))
	
	; Shoot the next elite
	(cs_go_to e1_pro_inf0_0_patrol/p1)
	(cs_aim_object true e1_elite1)
	(sleep (random_range 60 90))
	(cs_aim_object false e1_elite1)
	(cs_shoot true e1_elite1) 
	(sleep 30)
	(cs_shoot false e1_elite1)
	(sleep (random_range 30 60))
	
	; Peer around the corner
	(cs_go_to e1_pro_inf0_0_patrol/p2)
	(cs_look true e1_pro_inf0_0_patrol/p2_look0)
	(sleep (random_range 45 75))
	(cs_look true e1_pro_inf0_0_patrol/p2_look1)
	(sleep (random_range 60 90))
	(cs_look false e1_pro_inf0_0_patrol/p2_look1)

	; Go camping
	(cs_go_to e1_pro_inf0_0_patrol/p3)
	(cs_face true e1_pro_inf0_0_patrol/p3_look0)
	(sleep (random_range 210 300))
	(cs_face true e1_pro_inf0_0_patrol/p3_look1)
)

(script command_script cs_e1_pro_inf0_1_patrol0
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_uninspected)
	
	; Go gaze at the ocean
	(cs_go_to e1_pro_inf0_1_patrol/p0)
	(sleep 30)
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\brute\brute" "patrol:any:any:posing:var1" true)
	(sleep (ai_play_line ai_current_actor 0240))
	(sleep 25)
	(ai_play_line e1_pro_inf0_1_1/brute0 0250)
	(sleep (random_range 90 120))

	; Shoot the next elite
	(cs_go_to e1_pro_inf0_1_patrol/p1)
	(cs_aim_object true e1_elite2)
	(sleep (random_range 60 90))
	(cs_aim_object false e1_elite2)
	(cs_shoot true e1_elite2) 
	(sleep 30)
	(cs_shoot false e1_elite2)
	(sleep (random_range 30 60))
	
	; One of the other Brutes comments 
	(if (> (ai_living_count e1_pro_inf0_0) 0)
		(begin
			(sleep (ai_play_line e1_pro_inf0_0/brute0 0260))
	
			; He replies
			(ai_play_line e1_pro_inf0_1/brute0 0270)
		)
	)
	
	; Look up the aisle
	(cs_face true e1_pro_inf0_1_patrol/p1_look0)
	(sleep (random_range 60	90))
	(cs_face false e1_pro_inf0_1_patrol/p1_look0)
	
	; Loop
	(sleep_until
		(begin
			; Look at the captain
			(cs_go_to e1_pro_inf0_1_patrol/p2)	
			(cs_face true e1_pro_inf0_1_patrol/p2_look0)
			(sleep (random_range 210 300))
			(cs_face false e1_pro_inf0_1_patrol/p2_look0)
			
			; Go back to the first aisle
			(cs_go_to e1_pro_inf0_1_patrol/p1)	
			(cs_face true e1_pro_inf0_1_patrol/p1_look0)
			(sleep (random_range 210 300))
			(cs_face false e1_pro_inf0_1_patrol/p1_look0)
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e1_pro_inf0_1_patrol1
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_uninspected)

	; Shoot the next elite
	(cs_go_to e1_pro_inf0_2_patrol/p0)
	(cs_aim_object true e1_elite3)
;	(ai_play_line_at_player ai_current_actor 0210)
	(sleep (random_range 60 90))
	(cs_aim_object false e1_elite3)
	(cs_shoot true e1_elite3) 
	(sleep 30)
	(cs_shoot false e1_elite3)
	(sleep (random_range 30 60))

	; Shoot the next elite
	(cs_go_to e1_pro_inf0_2_patrol/p1)
	(cs_aim_object true e1_elite4)
;	(ai_play_line_at_player ai_current_actor 0220)
	(sleep (random_range 60 90))
	(cs_aim_object false e1_elite4)
	(cs_shoot true e1_elite4) 
	(sleep 30)
	(cs_shoot false e1_elite4)
	(sleep (random_range 30 60))

	; Shoot the next elite
	(cs_aim_object true e1_elite5)
	(sleep (random_range 90 120))
	(cs_aim_object false e1_elite4)
	(cs_shoot true e1_elite4) 
	(sleep 30)
	(cs_shoot false e1_elite4)
	(sleep (random_range 30 60))
)

(script command_script cs_e1_cov_inf0_scene
	; Custom animation
	(custom_animation_loop (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:unarmed:mortal_wound" false)		

	; Make him weak
	(unit_set_maximum_vitality (ai_get_unit ai_current_actor) 5 0)
	
	; Wait till the player gets close
	(sleep_until 
		(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)
	)
	
	; Regard the player
	(cs_look_player true)
	
	; Speak
	(sleep (ai_play_line_at_player ai_current_actor 0200))
	(sleep 45)
	(set g_e1_cov_inf0_should_die true)
	(unit_stop_custom_animation (ai_get_unit ai_current_actor))
	(sleep_forever)
)

(script command_script cs_e1_stealth_major_scene
	(ai_set_active_camo ai_current_actor false)
	(cs_go_to e1_watch_pods/p1)
	(if (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 5)
		(cs_look_player true)
		(cs_look true e1_zealot/p1)
	)
	(print "stealth: by the prophets...")
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:sword:posing:var1" true)
	(sleep (ai_play_line_at_player ai_current_actor 0300))
	(sleep 20)
	(sleep_until 
		(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 5) 
		10
		450
	)
	
	; Ultimatum
	(cs_face_player true)
	(sleep 30)
	(sleep_until 
		(or
			(objects_can_see_object (ai_get_object ai_current_actor) (player0) 10)
			(and
				(game_is_cooperative)
				(objects_can_see_object (ai_get_object ai_current_actor) (player1) 10)
			)
		)
		1
		30
	)
	(print "stealth: they have shed our brother's blood...")
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:sword:posing:var4" true)
	(sleep (ai_play_line_at_player ai_current_actor 0310))

	; Music, ideal trigger (backup trigger on e2_main)
	(wake music_08a_02_start)

	; Continue
	(set g_e1_stealth_major_done true)
	(sleep_forever)
)

(script command_script cs_e1_watch_pods
	(sleep 15)
	(cs_go_to_nearest e1_watch_pods/p0)
	(cs_look_object true (ai_vehicle_get e1_cov_inf2/gold_elite))
	(cs_face_object true (ai_vehicle_get e1_cov_inf2/gold_elite))
	
	; Wait until the hatch pops
	(sleep_until g_e1_zealot_revealed 10)
	(print "stealth: a zealot? so much for stealth...")
	(sleep (ai_play_line_at_player ai_current_actor 0320)) 
)

(script command_script cs_e1_zealot_intro
	(cs_look true e1_zealot/p0)
	(sleep 25)
	(ai_play_line ai_current_actor 0330)
	(print "zealot: over so soon? bah")
	(cs_look true e1_zealot/p1)
	(sleep 30)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Scripts ---------------------------------------------------------------

(global effect g_e1_pod_impact_effect "effects\scenarios\solo\earthcity\e11_insertion_pod_impact")

(script dormant e1_pod0_insertion
	(ai_place e1_cov_inf2/gold_elite)
	(object_create e1_pod0_inserter)
	(objects_attach e1_pod0_inserter "pod_attach" (ai_vehicle_get e1_cov_inf2/gold_elite) "pod_attach")
	(sleep 1)
	(device_set_position e1_pod0_inserter 1.0)
	(sleep_until (>= (device_get_position e1_pod0_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e1_pod_impact_effect (ai_vehicle_get e1_cov_inf2/gold_elite) "pod_attach")	
	(objects_detach e1_pod0_inserter (ai_vehicle_get e1_cov_inf2/gold_elite))
	(object_destroy e1_pod0_inserter)
	
	(sleep (random_range 20 45))
	(set g_e1_zealot_revealed true)
	(sleep_until (= (structure_bsp_index) 0))
	(ai_vehicle_exit e1_cov_inf2/gold_elite)
	(sleep 10)
	(object_damage_damage_section (ai_vehicle_get e1_cov_inf2/gold_elite) "door" 500)
)

(script dormant e1_pod1_insertion
	(ai_place e1_cov_inf2/elite1)
	(object_create e1_pod1_inserter)
	(objects_attach e1_pod1_inserter "pod_attach" (ai_vehicle_get e1_cov_inf2/elite1) "pod_attach")
	(sleep 1)
	(device_set_position e1_pod1_inserter 1.0)
	(sleep_until (>= (device_get_position e1_pod1_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e1_pod_impact_effect (ai_vehicle_get e1_cov_inf2/elite1) "pod_attach")	
	(objects_detach e1_pod1_inserter (ai_vehicle_get e1_cov_inf2/elite1))
	(object_destroy e1_pod1_inserter)
	
	(sleep (random_range 20 45))
	(sleep_until (= (structure_bsp_index) 0))
	(ai_vehicle_exit e1_cov_inf2/elite1)
	(sleep 10)
	(object_damage_damage_section (ai_vehicle_get e1_cov_inf2/elite1) "door" 500)
)

(script dormant e1_pod2_insertion
	(ai_place e1_cov_inf2/elite2)
	(object_create e1_pod2_inserter)
	(objects_attach e1_pod2_inserter "pod_attach" (ai_vehicle_get e1_cov_inf2/elite2) "pod_attach")
	(sleep 1)
	(device_set_position e1_pod2_inserter 1.0)
	(sleep_until (>= (device_get_position e1_pod2_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e1_pod_impact_effect (ai_vehicle_get e1_cov_inf2/elite2) "pod_attach")	
	(objects_detach e1_pod2_inserter (ai_vehicle_get e1_cov_inf2/elite2))
	(object_destroy e1_pod2_inserter)
	
	(sleep (random_range 20 45))
	(sleep_until (= (structure_bsp_index) 0))
	(ai_vehicle_exit e1_cov_inf2/elite2)
	(sleep 10)
	(object_damage_damage_section (ai_vehicle_get e1_cov_inf2/elite2) "door" 500)
	(sleep 30)
	
	; Safe to migrate them now
	(set g_e2_safe_to_migrate_inf2 true)
)

(script dormant e1_objectives
	; When the pinned Elite dies, or the Brutes see the player, assign the objective
	(sleep 150)
	(sleep_until 
		(or
			(<= (ai_living_count e1_cov_inf0) 0)
			(> (ai_combat_status e1_pro) ai_combat_status_active)
		)
		30
		one_minute
	)
	
	; Set the opening objective
	(wake objective0_set)
	
	; Wait till the zealot arrives
	(sleep_until (> (ai_living_count e1_cov_inf2) 0) 15)
	(sleep 150)
	(wake objective0_clear)
	(wake objective1_set)	
)

(script dormant e1_guns_aux
	; Filthy dirty playerses, we hates them...
	(sleep_until (volume_test_objects tv_e1_area_entrance (players)) 15)
	(object_create e1_gun4)
	(sleep 1)
	(weapon_hold_trigger e1_gun4 0 true)
	(sleep 10)
	(weapon_hold_trigger e1_gun4 0 false)
	(sleep 1)
	(object_destroy e1_gun4)
)

(script dormant e1_guns
	(wake e1_guns_aux)

	; Brute shots
	(object_create e1_gun0)
	(object_create e1_gun1)
	(sleep 1)
	(weapon_hold_trigger e1_gun0 0 true)
	(sleep 5)
	(weapon_hold_trigger e1_gun0 0 false)
	(object_destroy e1_gun0)
	(sleep 15)
	(weapon_hold_trigger e1_gun1 0 true)
	(sleep 5)
	(weapon_hold_trigger e1_gun1 0 false)
	(sleep 1)
	(object_destroy e1_gun1)

	; Plasma rifle burst
	(sleep 90)
	(object_create e1_gun2)
	(sleep 1)
	(weapon_hold_trigger e1_gun2 0 true)
	(sleep 15)
	(weapon_hold_trigger e1_gun2 0 false)
	(sleep 1)
	(object_destroy e1_gun2)

	; And one more
	(sleep 60)
	(object_create e1_gun3)
	(sleep 1)
	(weapon_hold_trigger e1_gun3 0 true)
	(sleep 30)
	(weapon_hold_trigger e1_gun3 0 false)
	(sleep 90)
	(weapon_hold_trigger e1_gun3 0 true)
	(sleep 20)
	(weapon_hold_trigger e1_gun3 0 false)
	(sleep 1)
	(object_destroy e1_gun3)
)

(script dormant e1_music_aux
	(sleep_until (volume_test_objects tv_e1_third_wall (players)) 15)

	; Music
	(wake music_08a_01_start_alt)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e1_pro_inf1_main
	(sleep_until (volume_test_objects tv_e1_second_wall (players)) 15)
	(wake e1_music_aux)

	; Place the captain
	(ai_place e1_pro_inf1)
	
	; Wait until he's alerted, dead, or a timeout
	(sleep_until 
		(or
			(>= (ai_combat_status e1_pro_inf1) ai_combat_status_clear_los)
			(<= (ai_living_count e1_pro_inf1) 0)
		)
		30
		30_seconds
	)
	(print "alerted")
	
	; Was the Captain alerted?
	(if (>= (ai_combat_status e1_pro_inf1) ai_combat_status_clear_los)
		(set g_e1_pro_inf1_was_alerted true)
	)
	
	; Wait until he's calmed down
	(sleep_until (<= (ai_combat_status e1_pro_inf1) ai_combat_status_active) 10)
	(sleep_until (<= (ai_combat_status e1_pro_inf1) ai_combat_status_alert) 10 240)
	(print "alerted")
	
	; If the Captain is still alive, and his cohorts are too...
	(if
		(and
			(> (ai_living_count e1_pro_inf1) 0)
			(> (ai_living_count e1_pro_inf0) 0)
		)
		(begin
			; The Captain makes the Brutes go see what's going on
			(if g_e1_pro_inf1_was_alerted
				(begin
					(print "cpn: he's just an elite--kill him!")
					(ai_play_line e1_pro_inf1/brute0 0290)
					(sleep 20)
					(custom_animation (ai_get_unit e1_pro_inf1/brute0) "objects\characters\brute\brute" "combat:support:hold" true)
					(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
				)
				(ai_play_line e1_pro_inf1/brute0 0280)
			)
			
			; Send out the Brutes
			(sleep 30)
			(ai_set_orders e1_pro_inf0 e1_pro_inf0_search)
			(set g_e1_pro_inf0_searching true)
		)
	)
)

(script dormant e1_pro_inf0_main
	(sleep_until (volume_test_objects tv_e1_pro_inf0_begin (players)) 15)
	(ai_place e1_pro_inf0_0)
	(ai_place e1_pro_inf0_1)
	(ai_place e1_pro_inf0_1_1)
	
	; Command scripts
	(cs_run_command_script e1_pro_inf0_0 cs_e1_pro_inf0_0_patrol0)
	(cs_run_command_script e1_pro_inf0_1/brute0 cs_e1_pro_inf0_1_patrol0)
	(cs_run_command_script e1_pro_inf0_1_1/brute0 cs_e1_pro_inf0_1_patrol1)
	
	; Wait till the player moves up a bit, or the first three are dead
	(sleep_until 
		(or
			(<= (ai_living_count e1_pro_inf0) 0)
			(volume_test_objects tv_e1_second_wall (players)) 
		)
		15
	)
	
	; Pause a moment...
	(sleep 15)
	(ai_place e1_pro_inf0_2)
	(ai_place e1_pro_inf0_3)

	; Wait until they're dead
	(sleep_until 
		(<= (ai_living_count e1_pro_inf0) 0)
		15
	)

	; Try to save
	(game_save)
)

(script dormant e1_cov_inf2_main
	(sleep_until (volume_test_objects tv_e1_exit (players)) 15)

	; Wait for the major to be done talking
	(sleep_until
		(or
			g_e1_stealth_major_done
	
			; Player misbehaving clause
			(and
				(> (ai_spawn_count e1_cov_inf1) 0)
				(<= (ai_living_count e1_cov_inf1) 0)
			)
		)
	)
	
	; Wait until we're in this BSP
	(sleep_until (= (structure_bsp_index) 0))

	; Place the captain
	(wake e1_pod0_insertion)
	(sleep 60)
	(wake e1_pod1_insertion)
	(sleep 15)
	(wake e1_pod2_insertion)
	
	; If the Brutes are dead, have the zealot complain
	(sleep_until (not (unit_in_vehicle (ai_get_unit e1_cov_inf2/gold_elite))) 15)
	(sleep 15)
	(if (<= (ai_living_count e1_pro) 0)
		(cs_run_command_script e1_cov_inf2/gold_elite cs_e1_zealot_intro)
	)
	
	; When he's in the exit volume...
	(sleep_until (volume_test_objects tv_e1_exit (ai_get_object e1_cov_inf2/gold_elite)) 15)
	
	; If the Dervish has moved on, call for him to wait
	(if (volume_test_objects tv_e1_ledge (players))
		; He has not, invite him along
		(begin
			(print "zlt: there are brutes to kill!")
			(ai_play_line e1_cov_inf2/gold_elite 0340)
		)
		
		; He has, call for him to wait up
		(begin
			(print "zlt: wait up!")
			(ai_play_line e1_cov_inf2/gold_elite 0350)
		)
	)
)

(script dormant e1_cov_inf1_main
	(sleep_until 
		(or
			(and
				(> (ai_spawn_count e1_pro_inf1) 0)
				(<= (ai_living_count e1_pro_inf0) 0)
			)
			(volume_test_objects tv_e1_exit (players))
		)
		15 
	)
		
	; Spawn
	(ai_place e1_cov_inf1)
	(set g_cov_stealth_major (ai_get_unit e1_cov_inf1/stealth_major))
	
	; Greeting scene
	(sleep_until
		(or
			(ai_scene e1_stealth_major_scene cs_e1_stealth_major_scene e1_cov_inf1)
			(> (ai_spawn_count e1_cov_inf2) 0)
		)
		10
	)
	
	; Wait for the insertion pods to spawn
	(sleep_until
		(and
			(<= (ai_living_count e1_pro) 0)
			(> (ai_spawn_count e1_cov_inf2) 0)
		)
		5
	)
	
	; Watch the pods come in
	(cs_run_command_script e1_cov_inf1 cs_e1_watch_pods)
)

(script dormant e1_cov_inf0_main
	(ai_place e1_cov_inf0)
	(ai_disregard (ai_actors e1_cov_inf0) true)
	(set g_e1_wounded_elite (ai_get_unit e1_cov_inf0))

	; Sray him. Sray him dead.
	(unit_kill g_e1_wounded_elite)
	(sleep 13)
	(biped_ragdoll g_e1_wounded_elite)

	; Wait until the player picks up his sword
	(sleep_until
		(or
			(unit_has_weapon (unit (player0)) "objects\weapons\melee\energy_blade\energy_blade.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\melee\energy_blade\energy_blade.weapon")
		)
		10
		one_minute
	)
	
	; Croak out your lines
	(sleep 20)
	(print "corpse: the brutes...")
	(sleep (ai_play_line_on_object g_e1_wounded_elite 0200))

	; Save point after he buys it
	(sleep 30)
	(game_save)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e1_main
	(set g_e1_started true)
	(print "e1_main")
	(data_mine_set_mission_segment "e1_stealthy_insertion")
	
	; Wake subsequent scripts
	(wake e2_main)

	; Wake control scripts
	(wake e1_cov_inf0_main)
	(wake e1_cov_inf1_main)
	(wake e1_cov_inf2_main)
	(wake e1_pro_inf0_main)
	(wake e1_pro_inf1_main)
	(wake e1_objectives)
	(wake e1_guns)
	
	; Condemn
	(sleep_until g_e2_started)
	(ai_disposable e1_pro true)
	
	; Shut down
	(sleep_until g_e3_started)
	(sleep_forever e1_cov_inf0_main)
	(sleep_forever e1_cov_inf1_main)
	(sleep_forever e1_cov_inf2_main)
	(sleep_forever e1_pro_inf0_main)
	(sleep_forever e1_pro_inf1_main)
	(sleep_forever e1_objectives)
	(sleep_forever e1_guns)
	
	; Clean up
;	(sleep_until (or g_e4_started g_e6_started))
)


;= MISSION MAIN ==========================================================================

(script dormant mission_start
	(sound_class_set_gain amb 1 5) ; pbertone 9/23 
	; Music
	(wake music_08a_01_start)
	(sleep 2)
	
	; Protect the players
	(object_cannot_take_damage (players))
	(object_hide (player0) true)
	(object_hide (player1) true)

	; Snap out
	(cinematic_snap_to_white)

	; Run the cinematics
	(cinematic_intro)
	
	; Teleport the players into their starting locations, unprotect them
	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)
	(object_hide (player0) false)
	(object_hide (player1) false)
	(object_can_take_damage (players))
	
	; Fade in

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white_bars)

	; Chapter titles
	(wake chapter_title0)
		
	; Wake the key encounters
	(wake e1_main)
	(wake e6_main)
	
	; Wait for the mission to end
	(sleep_until (volume_test_objects tv_mission_end (players)) 15)
	(wake music_08a_05_start)
		
	; For playtests
	(playtest_mission)
	(sleep 15)
	
	; Fade to white and win
	(cinematic_fade_to_white)
	
	; Get the player clear
	(if (unit_in_vehicle (unit (player0)))
		(object_teleport (object_get_parent (player0)) player0_end)
		(object_teleport (player0) player0_end)
	)
	(if (unit_in_vehicle (unit (player1)))
		(object_teleport (object_get_parent (player1)) player1_end)
		(object_teleport (player1) player1_end)
	)
	(object_hide (player0) false)
	(object_hide (player1) false)
	(object_cannot_take_damage (players))
	(sleep 5)
	
	; Run the cinematic
	(cinematic_outro)
	(sleep 5)
	(game_won)
)

(script static void start
	(wake mission_start)
)

(script startup mission_main
	(sound_class_set_gain amb 0 0) ; pbertone 9/23 

	; Necessary startup stuff
	(ai_allegiance player covenant)
	(weather_stop 0)
	
	; Clear objectives
	(objectives_clear)
	
	; Begin the mission
	; Comment this out when you're testing individual encounters
	(if (> (player_count) 0 ) (start))
)

