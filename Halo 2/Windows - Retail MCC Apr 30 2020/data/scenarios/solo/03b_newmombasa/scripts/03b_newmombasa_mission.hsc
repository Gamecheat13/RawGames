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


;- Stubs -----------------------------------------------------------------------

(script stub void c03_intra1 (print "c03_intra1 (cinematics didn't compile)"))
(script stub void x03 (print "x03 (cinematics didn't compile)"))


;= CHAPTER TITLES ========================================================================

(script dormant chapter_title0
	(sleep 30)
	
	; Is it legendary?
	(if (difficulty_legendary)
		(cinematic_set_title title0_legendary)
		
		; Nope. Is it Heroic?
		(if (difficulty_heroic)
			; Yes, it is
			(cinematic_set_title title0_heroic)

			; Nope, so it must be normal
			(cinematic_set_title title0_normal)
		)
	)
	
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


;= SINEMATICS ============================================================================

(script static void cinematic_intro
	(if (cinematic_skip_start)
		(c03_intra1)
	)
	(cinematic_skip_stop)
)

(script static void cinematic_outro
	(if (cinematic_skip_start)
		(x03)
	)
	(cinematic_skip_stop)
)


;= OBJECTIVES ============================================================================

(script dormant objective0_set
	(sleep 90)
	(objectives_show_up_to 0)
)

(script dormant objective0_clear
	(objectives_finish_up_to 0)
)

(script dormant objective1_set
	(sleep_until (volume_test_objects tv_e17_objectives (players)) 15)
	(sleep 30)
	(objectives_show_up_to 1)
)

(script dormant objective1_clear
	(objectives_finish_up_to 1)
)

(script dormant objective2_set
	(sleep 300)
	(objectives_show_up_to 2)
)

(script dormant objective2_clear
	(objectives_finish_up_to 2)
)

(script dormant objective3_set
	(sleep 30)
	(objectives_show_up_to 3)
)


;= MUSIC =================================================================================

(script dormant music_03b_01_stop
	(print "music 03b_01 stop")
	(sound_looping_stop "scenarios\solo\03b_newmombasa\03b_music\03b_01")
)

(script dormant music_03b_01_start_alt
	(print "music 03b_01 start alt")
	(sound_looping_set_alternate "scenarios\solo\03b_newmombasa\03b_music\03b_01" true)
)

(script dormant music_03b_01_start
	(print "music 03b_01 start")
	(sound_looping_start "scenarios\solo\03b_newmombasa\03b_music\03b_01" none 1.0)
)

(script dormant music_03b_02_stop
	(print "music 03b_02 stop")
	(sound_looping_stop "scenarios\solo\03b_newmombasa\03b_music\03b_02")
)

(script dormant music_03b_02_start
	(print "music 03b_02 start")
	(sound_looping_start "scenarios\solo\03b_newmombasa\03b_music\03b_02" none 1.0)
)

(script dormant music_03b_03_stop
	(print "music 03b_03 stop")
	(sound_looping_stop "scenarios\solo\03b_newmombasa\03b_music\03b_03")
)

(script dormant music_03b_03_start
	(print "music 03b_03 start")
	(sound_looping_start "scenarios\solo\03b_newmombasa\03b_music\03b_03" none 1.0)
)

(script dormant music_03b_04_stop
	(print "music 03b_04 stop")
	(sound_looping_stop "scenarios\solo\03b_newmombasa\03b_music\03b_04")
)

(script dormant music_03b_04_start_alt
	(sleep_until (volume_test_objects tv_scarab (players)) 15)
	(print "music 03b_04 start alt")
	(sound_looping_set_alternate "scenarios\solo\03b_newmombasa\03b_music\03b_04" true)
)

(script dormant music_03b_04_start
	(sleep_until (volume_test_objects tv_e23_entry_door (players)) 15)
	(print "music 03b_04 start")
	(sound_looping_start "scenarios\solo\03b_newmombasa\03b_music\03b_04" none 1.0)
)


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

(script dormant flashlight_control
	(sleep_until
		(begin
			; Is the player in a dark section?
			(if 
				(volume_test_objects tv_dark_area0 (players))
				(game_can_use_flashlights true)
				(game_can_use_flashlights false)
			)
		
			false
		)
		60
	)
)

(script dormant scarab_no_save ; pbertone 9/23 
	(sleep_until
		(begin
			(sleep_until (volume_test_objects tv_scarab_no_save (players)) 5)
			(game_save_cancel)
			(print "game save canceled")
		false)
	1)
)
;= THE SCARAB ============================================================================
;- Globals ---------------------------------------------------------------------

(global boolean g_e23_scarab_arrived false)				; Scarab has finished previous encounters
(global boolean g_e23_scarab_climbed_down false)		; Scarab climbed down from the buildings
(global boolean g_e23_scarab_before_bridge0 false)		; Scarab has started ducking under Bridge 0
(global boolean g_e23_scarab_under_bridge0 false)		; Scarab is under Bridge 0
(global boolean g_e23_scarab_before_bridge1 false)		; Scarab has started ducking under Bridge 1
(global boolean g_e23_scarab_under_bridge1 false)		; Scarab is under Bridge 1
(global boolean g_e23_scarab_before_bridge2 false)		; Scarab has started ducking under Bridge 2
(global boolean g_e23_scarab_under_bridge2 false)		; Scarab is under Bridge 2
(global boolean g_e23_scarab_after_bridge2 false)		; Scarab is past Bridge 2
(global boolean g_e23_scarab_after_turn false)			; Scarab has finished turning
(global boolean g_e23_scarab_arrived_at_end false)		; Scarab has arrived at the endpoint


;- Gun Loaders -----------------------------------------------------------------

(script command_script cs_scarab_load_main_gun
	(object_hide (ai_get_object ai_current_actor) true)
	(vehicle_load_magic (unit (object_at_marker scarab "primary_trigger")) "scarab_turret_d" (ai_get_object ai_current_actor))
	(sleep_forever)
)

(script command_script cs_scarab_load_upper_gun
	(object_hide (ai_get_object ai_current_actor) true)
	(vehicle_load_magic (unit (object_at_marker scarab "t_f_turret")) "scarab_turret_d" (ai_get_object ai_current_actor))
)

(script command_script cs_scarab_load_rear_gun
	(object_hide (ai_get_object ai_current_actor) true)
	(vehicle_load_magic (unit (object_at_marker scarab "t_b_turret")) "scarab_turret_d" (ai_get_object ai_current_actor))
	(sleep_forever)
)
;*
(script command_script cs_scarab_load_right_gun0
	(object_hide (ai_get_object ai_current_actor) true)
	(vehicle_load_magic (unit (object_at_marker scarab "side_gun_fr")) "scarab_turret_d" (ai_get_object ai_current_actor))
	(cs_enable_targeting true)
	(sleep_forever)
)

(script command_script cs_scarab_load_right_gun1
	(object_hide (ai_get_object ai_current_actor) true)
	(vehicle_load_magic (unit (object_at_marker scarab "side_gun_br")) "scarab_turret_d" (ai_get_object ai_current_actor))
	(cs_enable_targeting true)
	(sleep_forever)
)

(script command_script cs_scarab_load_left_gun0
	(object_hide (ai_get_object ai_current_actor) true)
	(vehicle_load_magic (unit (object_at_marker scarab "side_gun_fl")) "scarab_turret_d" (ai_get_object ai_current_actor))
	(cs_enable_targeting true)
	(sleep_forever)
)

(script command_script cs_scarab_load_left_gun1
	(object_hide (ai_get_object ai_current_actor) true)
	(vehicle_load_magic (unit (object_at_marker scarab "side_gun_bl")) "scarab_turret_d" (ai_get_object ai_current_actor))
	(cs_enable_targeting true)
	(sleep_forever)
)
*;

;- Deadreck Pieces -------------------------------------------------------------

(global real g_scarab_interpolation 0.25)
(script static void scarab_idle_var0
	(print "scarab_idle_var0")
	(device_set_position_track scarab combat:idle:var0 g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_firing
	(print "scarab_idle_var0")
	(device_set_position_track scarab combat:idle:var0 g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_to_walk_front
	(print "scarab_idle_to_walk_front")
	(device_set_position_track scarab combat:idle:2:walk_front g_scarab_interpolation)
	(device_animate_position scarab 1.0 3 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_to_walk_front_fast
	(print "scarab_idle_to_walk_front")
	(device_set_position_track scarab combat:idle:2:walk_front g_scarab_interpolation)
	(device_animate_position scarab 1.0 2 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_var0
	(print "scarab_walk_front_var0")
	(device_set_position_track scarab combat:walk_front:var0 g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_var0_fast
	(print "scarab_walk_front_var0")
	(device_set_position_track scarab combat:walk_front:var0 g_scarab_interpolation)
	(device_animate_position scarab 1.0 (/ 80.0 30.0) 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_low_var0
	(print "scarab_walk_front_low_var0")
	(device_set_position_track scarab combat:walk_front:var0 g_scarab_interpolation)
	(device_animate_position scarab 1.0 8 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_to_idle
	(print "scarab_walk_front_to_idle")
	(device_set_position_track scarab combat:walk_front:2:idle g_scarab_interpolation)
	(device_animate_position scarab 1.0 3 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_to_idle_fast
	(print "scarab_walk_front_to_idle")
	(device_set_position_track scarab combat:walk_front:2:idle g_scarab_interpolation)
	(device_animate_position scarab 1.0 2 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_22_left
	(print "scarab_idle_turn_22_left")
	(device_set_position_track scarab combat:turn_22_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_45_left
	(print "scarab_idle_turn_45_left")
	(device_set_position_track scarab combat:turn_45_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_45_right
	(print "scarab_idle_turn_45_right")
	(device_set_position_track scarab combat:turn_45_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_turn_15_left
	(print "scarab_walk_front_turn_15_left")
	(device_set_position_track scarab combat:walk_front_turn_15_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_turn_15_right
	(print "scarab_walk_front_turn_15_right")
	(device_set_position_track scarab combat:walk_front_turn_15_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_turn_22_left
	(print "scarab_walk_front_turn_22_left")
	(device_set_position_track scarab combat:walk_front_turn_22_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_turn_45_left
	(print "scarab_walk_front_turn_45_left")
	(device_set_position_track scarab combat:walk_front_turn_45_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_turn_45_right
	(print "scarab_walk_front_turn_45_right")
	(device_set_position_track scarab combat:walk_front_turn_45_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_to_walk_low
	(print "scarab_walk_front_to_walk_low")
	(device_set_position_track scarab combat:walk_front:2:walk_narrow_front g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_low_to_walk_front
	(print "scarab_walk_narrow_to_walk_front")
	(device_set_position_track scarab combat:walk_narrow_front:2:walk_front g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_low_var0
	(print "scarab_walk_narrow_var0")
	(device_set_position_track scarab combat:walk_narrow_front:var0 g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_to_twist_5_left
	(print "scarab_idle_to_twist_5_right")
	(device_set_position_track scarab combat:idle_to_twist_5_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 1.5 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_to_twist_5_right
	(print "scarab_idle_to_twist_5_right")
	(device_set_position_track scarab combat:idle_to_twist_5_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 1.5 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_twist_5_left
	(print "scarab_twist_5_left")
	(device_set_position_track scarab combat:twist_5_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_twist_5_left_firing
	(print "scarab_twist_5_left")
	(device_set_position_track scarab combat:twist_5_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_twist_5_right
	(print "scarab_twist_5_right")
	(device_set_position_track scarab combat:twist_5_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_twist_5_right_firing
	(print "scarab_twist_5_right")
	(device_set_position_track scarab combat:twist_5_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_twist_5_left_to_idle
	(print "scarab_twist_5_left_to_idle")
	(device_set_position_track scarab combat:twist_5_left_to_idle g_scarab_interpolation)
	(device_animate_position scarab 1.0 1.5 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_twist_5_right_to_idle
	(print "scarab_twist_5_left_to_idle")
	(device_set_position_track scarab combat:twist_5_right_to_idle g_scarab_interpolation)
	(device_animate_position scarab 1.0 1.5 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_gun_open_instant
	(device_set_overlay_track scarab combat:fire_open)
	(device_animate_overlay scarab 1.0 0.05 0 0)
)
(script static void scarab_gun_open
	(device_set_overlay_track scarab combat:fire_open)
	(device_animate_overlay scarab 1.0 3.5 0 0)
)
(script static void scarab_gun_fire
	(device_set_overlay_track scarab combat:fire)
	(device_animate_overlay scarab 1.0 6 0 0)
)
(script static void scarab_gun_close
	(device_set_overlay_track scarab combat:fire_close)
	(device_animate_overlay scarab 1.0 3.5 0 0)
)
(script static void scarab_gun_open_down_instant
	(device_set_overlay_track scarab combat:fire_down_open)
	(device_animate_overlay scarab 1.0 0.05 0 0)
)
(script static void scarab_gun_open_down
	(device_set_overlay_track scarab combat:fire_down_open)
	(device_animate_overlay scarab 1.0 3.5 0 0)
)
(script static void scarab_gun_fire_down
	(device_set_overlay_track scarab combat:fire_down)
	(device_animate_overlay scarab 1.0 6 0 0)
)
(script static void scarab_gun_close_down
	(device_set_overlay_track scarab combat:fire_down_close)
	(device_animate_overlay scarab 1.0 3.5 0 0)
)


;= ENCOUNTER 23 ==========================================================================
;*
The player paces the Scarab as it moves down the boulevard, and eventually 
boards it and kills its crew. The End.

Begins when the player passes through the second building
Ends when he kills the pilots, and the level ends

Marines
	e23_mars_inf0 - e22_mars_inf0, Scarab pacing squad B
		(init) - Getting a view of the Scarab near the door
		(bridge1) - Moving back to the second bridge
		(bridge2) - At the edge of the bridge
		(endpoint0) - At the endpoint
	e23_mars_inf1 - ODSTs, Scarab pacing squad A, starts on the first bridge
		(bridge0) - Starting on the first bridge
		(bridge2) - Moving back to the third bridge
		(endpoint0) - At the final boarding point
	e23_mars_pelican0 - A Pelican which takes a shot at the Scarab

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

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e23_started false)		; Encounter has been activated?

(global boolean g_e23_mars_pelican0_appeared false)	; Pelican has appeared and can open fire
(global boolean g_e23_scarab_active true)			; Have the pilots stopped piloting?

(global short g_e23_target_pelican -1)	; Which Pelican is being fired at?
(global boolean g_e23_mars_pelican2_2_active false)


;- Command Scripts -------------------------------------------------------------

;*
(script command_script cs_e23_mars_pelican1_0_entry
	(cs_vehicle_boost true)
	(cs_fly_to e23_mars_pelican1_entry/p0)
	(ai_erase ai_current_squad)
)

(script command_script cs_e23_mars_pelican1_1_entry
	(cs_vehicle_boost true)
	(cs_fly_to e23_mars_pelican1_entry/p1)
	(ai_erase ai_current_squad)
)

(script command_script cs_e23_mars_pelican0_entry0
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)

	; Wait for the Scarab
	(sleep_until g_e23_scarab_after_turn 5)

	; Move in
	(cs_face_object true scarab)
	(cs_fly_to e23_mars_pelican0_entry/p0_0 1.0)
	(set g_e23_mars_pelican0_appeared true)
	
	; Wait a moment...
	(sleep 90)
	
	; Bail out before the Scarab shoots it down
	(cs_fly_to e23_mars_pelican0_entry/p0_2)

	; Go into the loop
	(sleep_until
		(begin
			; Wait until the Scarab is not targeting us
			(sleep_until (not (= g_e23_target_pelican 0)) 10)
			(cs_fly_to e23_mars_pelican0_entry/p0_1 2.0)
			
			; Loop indefinitely
			false
		)
		1
	)
)

(script command_script cs_e23_mars_pelican0_evade0
	(sleep (random_range 0 15))

	; Evade!
	(cs_face true e23_mars_pelican0_entry/f0)
	(cs_fly_to e23_mars_pelican0_entry/p0_2 2.0)
	(cs_fly_to e23_mars_pelican0_entry/p0_3 2.0)
	(sleep_until (not (= g_e23_target_pelican 0)) 10)
)

(script command_script cs_e23_mars_pelican0_entry1
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)

	; Wait for the Scarab
	(sleep_until g_e23_scarab_after_turn 5)

	; Move in
	(cs_face_object true scarab)
	(cs_fly_to e23_mars_pelican0_entry/p1_0 1.0)
	
	; Wait a moment...
	(sleep 90)
	
	; Bail out before the Scarab shoots it down
	(cs_fly_to e23_mars_pelican0_entry/p1_2)

	; Go into the loop
	(sleep_until
		(begin
			; Wait until the Scarab is not targeting us
			(sleep_until (not (= g_e23_target_pelican 1)) 10)
			(cs_fly_to e23_mars_pelican0_entry/p1_1 2.0)
			
			; Loop indefinitely
			false
		)
		15
	)
)

(script command_script cs_e23_mars_pelican0_evade1
	(sleep (random_range 0 15))

	; Evade!
	(cs_face true e23_mars_pelican0_entry/f1)
	(cs_fly_to e23_mars_pelican0_entry/p1_2 2.0)
	(cs_fly_to e23_mars_pelican0_entry/p1_3 2.0)
	(sleep_until (not (= g_e23_target_pelican 1)) 10)
)

(script command_script cs_e23_mars_pelican0_gunners0
	(sleep_until g_e23_mars_pelican0_appeared 5)

	; Shoot if the player isn't on the Scarab
	(if (not (volume_test_objects tv_scarab (players)))
		(cs_shoot_point true e22_scarab_target/target)
	)
	(sleep 90)
	(cs_shoot_point false e22_scarab_target/target)
	
	; Pot shots
	(sleep_until
		(begin
			; Wait until the Scarab is not targeting us
			(sleep_until (not (= g_e23_target_pelican 1)) 10)
			(if (not (volume_test_objects tv_scarab (players)))
				(begin
					(cs_shoot_point true e22_scarab_target/leg0)
					(sleep (random_range 30 60))
					(cs_shoot_point false e22_scarab_target/leg0)
				)
			)
		
			; Loop until the Scarab deactivates
			(not g_e23_scarab_active)
		)
		30_seconds
		two_minutes
	)
)

(script command_script cs_e23_mars_pelican0_gunners1
	(sleep_until g_e23_mars_pelican0_appeared 5)
	(sleep 300)

	; Pot shots
	(sleep_until
		(begin
			; Wait until the Scarab is not targeting us
			(sleep_until (not (= g_e23_target_pelican 1)) 10)
			(if (not (volume_test_objects tv_scarab (players)))
				(begin
					(cs_shoot_point true e22_scarab_target/leg1)
					(sleep (random_range 30 60))
					(cs_shoot_point false e22_scarab_target/leg1)
				)
			)
		
			; Loop until the Scarab deactivates
			(not g_e23_scarab_active)
		)
		30_seconds
		two_minutes
	)
)
*;

(script command_script cs_e23_mars_pelican2_0_entry
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e23_mars_pelican2_flyby/p0)
	(cs_fly_by e23_mars_pelican2_flyby/p1)
	(object_destroy (ai_vehicle_get ai_current_actor))
	(ai_erase ai_current_actor)
)

(script command_script cs_e23_mars_pelican2_1_entry
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e23_mars_pelican2_flyby/p2)
	(cs_fly_by e23_mars_pelican2_flyby/p3)
	(object_destroy (ai_vehicle_get ai_current_actor))
	(ai_erase ai_current_actor)
)

(script command_script cs_e23_mars_pelican2_gunners0
	(sleep 60)
	(if (not (volume_test_objects tv_scarab (players))) 
		(cs_shoot_point true e22_scarab_target/leg1)
	)
	(sleep 60)
	(cs_shoot_point false e22_scarab_target/leg1)
	(sleep 1)
	(ai_erase ai_current_actor)
)

(script command_script cs_e23_mars_pelican2_gunners1
	(sleep 120)
	(if (not (volume_test_objects tv_scarab (players))) 
		(cs_shoot_point true e22_scarab_target/leg0)
	)
	(sleep 60)
	(cs_shoot_point false e22_scarab_target/leg0)
	(sleep 1)
	(ai_erase ai_current_actor)
)

(script command_script cs_e23_mars_pelican2_2_entry
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e23_mars_pelican2_flyby/p4)
	(cs_vehicle_boost false)
	(cs_face true e23_mars_pelican2_flyby/f0)
	(cs_fly_to e23_mars_pelican2_flyby/p5)
	
	; Arm the gunners
	(if g_e23_scarab_after_turn
		(begin
			(cs_run_command_script e23_mars_pelican2/gunner0 cs_e23_mars_pelican2_gunners0)
			(cs_run_command_script e23_mars_pelican2/gunner1 cs_e23_mars_pelican2_gunners1)
		)
	)
	
	; Approach the turning point
	(cs_fly_by e23_mars_pelican2_flyby/p6 16)
	(set g_e23_mars_pelican2_2_active false)
	
	; Swing around!
	(cs_face false e23_mars_pelican2_flyby/f0)
	(cs_face true e23_mars_pelican2_flyby/p7)
	(cs_fly_by e23_mars_pelican2_flyby/p6 2)
	(cs_face false e23_mars_pelican2_flyby/p7)
	
	; Bug out
	(cs_fly_by e23_mars_pelican2_flyby/p7)
	(cs_vehicle_boost true)
	(cs_fly_by e23_mars_pelican2_flyby/p8)
	(cs_fly_by e23_mars_pelican2_flyby/p1)
	(object_destroy (ai_vehicle_get ai_current_actor))
	(ai_erase ai_current_actor)
)

(script command_script cs_e23_mars_inf1_shoot
	(sleep_until g_e23_scarab_climbed_down 15)
	(sleep (random_range 10 30))

	; Open fire
	(cs_enable_moving true)
	(sleep_until
		(begin
			(cs_shoot true (list_get (ai_actors e23_cov_inf0) (random_range 0 (list_count (ai_actors e23_cov_inf0)))))
			(sleep (random_range 45 75))
		
			; Loop until the Scarab is about to pass under
			g_e23_scarab_before_bridge0
		)
		15
	)
	
	; Get out of the vehicles and go
	(ai_vehicle_exit ai_current_actor)
)

(script command_script cs_e23_mars_inf0_shoot
	(sleep_until g_e23_scarab_under_bridge0 15)
	(sleep (random_range 100 120))

	; Open fire
	(sleep_until
		(begin
			(cs_shoot true (list_get (ai_actors e23_cov_inf0) (random_range 0 (list_count (ai_actors e23_cov_inf0)))))
			(sleep (random_range 45 75))
		
			; Loop until the Scarab is about to pass under
			g_e23_scarab_before_bridge1
		)
		15
	)
)

(script command_script cs_e23_cov_inf1_pilot_exit
	(objects_detach scarab (ai_get_object ai_current_actor))
	
	; Break out of the animation
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "scarab_d_r:any:any:exit" true)
	(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
	(unit_stop_custom_animation (ai_get_unit ai_current_actor))
	
	; Can die again
	(object_cannot_die (ai_get_object ai_current_actor) false)
)

(script command_script cs_e23_cov_inf1_pilot0
	(object_cannot_die (ai_get_object ai_current_actor) true)
	(cs_queue_command_script ai_current_actor cs_e23_cov_inf1_pilot_exit)
	(cs_abort_on_damage true)
	(custom_animation_loop (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "scarab_d_r:any:any:idle:var0" false)

	; Hook him up
	(objects_attach scarab "scarab_d_l" (ai_get_object ai_current_actor) "")
	(sleep_until 
		(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 7)
		10
	)
	(objects_detach scarab (ai_get_object ai_current_actor))
	(sleep_until 
		(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)
		10
	)
)

(script command_script cs_e23_cov_inf1_pilot1
	(object_cannot_die (ai_get_object ai_current_actor) true)
	(cs_queue_command_script ai_current_actor cs_e23_cov_inf1_pilot_exit)
	(cs_abort_on_damage true)
	(custom_animation_loop (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "scarab_d_r:any:any:idle:var0" false)

	; Hook him up
	(objects_attach scarab "scarab_d_r" (ai_get_object ai_current_actor) "")
	(sleep_until 
		(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 7)
		10
	)
	(objects_detach scarab (ai_get_object ai_current_actor))
	(sleep_until 
		(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)
		10
	)
)
;*
(script command_script cs_e23_scarab_shoot_pelican0
	(set g_e23_target_pelican 0)
	
	; Tell the Pelican to evade (yuck)
	(cs_stack_command_script e23_mars_pelican0_0/pelican0 cs_e23_mars_pelican0_evade0)
	
	; Shoot
	(cs_shoot_point true e23_mars_pelican0_entry/p0_1)
	(sleep 165)
	(set g_e23_target_pelican -1)
)

(script command_script cs_e23_scarab_shoot_pelican1
	(set g_e23_target_pelican 1)
	
	; Tell the Pelican to evade (yuck)
	(cs_stack_command_script e23_mars_pelican0_1/pelican0 cs_e23_mars_pelican0_evade1)
	
	; Shoot
	(cs_shoot_point true e23_mars_pelican0_entry/p1_1)
	(sleep 165)
	(set g_e23_target_pelican -1)
)
*;
(script command_script cs_e23_scarab_upper_gun
	; Shoot
	(cs_shoot true (ai_vehicle_get e23_mars_pelican0_1/pelican0))
	(sleep 120)
)

(global object g_target none)
(script command_script cs_best_cs_ever
	(cs_approach g_target 0.5 5 50)
	(sleep_until
		(begin
			(cs_crouch true)
			(sleep 8)
			(cs_crouch false)
			(sleep 8)
			false
		)
		1
	)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e23_scarab_before_bridge0
	(= g_e23_scarab_before_bridge0 true)
)

(script static boolean e23_scarab_before_bridge1
	(= g_e23_scarab_before_bridge1 true)
)

(script static boolean e23_scarab_before_bridge2
	(= g_e23_scarab_before_bridge2 true)
)

(script static boolean e23_scarab_after_bridge2
	(= g_e23_scarab_after_bridge2 true)
)

(script static boolean e23_scarab_after_turn
	(= g_e23_scarab_after_turn true)
)


;- Event Controls --------------------------------------------------------------
;*
(script dormant scarab_left_gunner0_main
	(ai_place scarab_gunners/left_gunner0)
	
	; Wait until the gun is destroyed
	(sleep_until
		(or
			(object_model_target_destroyed (object_at_marker scarab "side_gun_bl") "target_front")
			g_e23_scarab_arrived_at_end
		)
	)
	
	; Erase the gunner
	(ai_erase scarab_gunners/left_gunner0)
)

(script dormant scarab_left_gunner1_main
	(ai_place scarab_gunners/left_gunner1)
	
	; Wait until the gun is destroyed
	(sleep_until
		(or
			(object_model_target_destroyed (object_at_marker scarab "side_gun_bl") "target_front")
			g_e23_scarab_arrived_at_end
		)
	)
	
	; Erase the gunner
	(ai_erase scarab_gunners/left_gunner1)
)

(script dormant scarab_right_gunner0_main
	(ai_place scarab_gunners/right_gunner0)
	
	; Wait until the corner or the gun is destroyed
	(sleep_until
		(or
			(object_model_target_destroyed (object_at_marker scarab "side_gun_fr") "target_front")
			g_e23_scarab_after_turn
		)
	)
	
	; Erase the gunner
	(ai_erase scarab_gunners/right_gunner0)
)

(script dormant scarab_right_gunner1_main
	(ai_place scarab_gunners/right_gunner1)
	
	; Wait until the corner or the gun is destroyed
	(sleep_until
		(or
			(object_model_target_destroyed (object_at_marker scarab "side_gun_br") "target_front")
			g_e23_scarab_after_turn
		)
	)
	
	; Erase the gunner
	(ai_erase scarab_gunners/right_gunner1)
)
*;
(script dormant scarab_upper_gunner_main
	(ai_place scarab_gunners/upper_gunner)
	(sleep 5)
	(cs_run_command_script scarab_gunners/upper_gunner cs_e23_scarab_upper_gun)
)

(script dormant e23_scarab
	(wake scarab_no_save) ; pbertone 9/23 

	; Force PVS
	(pvs_set_object scarab)
	
	; Unload the gun
	(ai_erase scarab_gunners/main_gunner)
	
	; Walk down off the building
	(device_set_position_track scarab finale_climb_off_buildings g_scarab_interpolation)
	(device_animate_position scarab 1.0 (/ 401.0 30.0) 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
	(set g_e23_scarab_climbed_down true)
	
	; Wait for the player, if he was lagging behind
	(sleep_until g_e23_started 1)
	
	; Walk down the main straightaway
	(scarab_walk_front_var0)
	
	; First bridge
	(set g_e23_scarab_before_bridge0 true)
	(scarab_walk_front_to_walk_low)
	(scarab_walk_low_var0)
	(scarab_walk_low_var0)
	(set g_e23_scarab_under_bridge0 true)
	
	; Activate the right side guns
;	(wake scarab_right_gunner0_main)
;	(wake scarab_right_gunner1_main)
		
	; Bridge intra 0
; Old	(scarab_walk_low_var0) ;(scarab_walk_low_to_walk_front)
; Old	(scarab_walk_low_var0) ;(scarab_walk_front_var0)
	(if (difficulty_legendary)
		(begin
			(scarab_walk_low_to_walk_front)
			(scarab_walk_front_var0)
		)
		(begin
			(scarab_walk_low_var0)
			(scarab_walk_low_var0)
		)
	)
	
	; Second bridge
	(set g_e23_scarab_before_bridge1 true)
; Old	(scarab_walk_low_var0) ;(scarab_walk_front_to_walk_low)
	(if (difficulty_legendary)
		(scarab_walk_front_to_walk_low)
		(scarab_walk_low_var0)
	)
	(scarab_walk_low_var0)
	(scarab_walk_low_var0)
	(set g_e23_scarab_under_bridge1 true)
; Old	(scarab_walk_low_var0) ;(scarab_walk_low_to_walk_front)
	(if (difficulty_legendary)
		(scarab_walk_low_to_walk_front)
		(scarab_walk_low_var0)
	)

	; Bridge intra 1
; Old	(scarab_walk_low_var0) ;(scarab_walk_front_var0)
	(if (difficulty_legendary)
		(scarab_walk_front_var0)
		(scarab_walk_low_var0)
	)
	
	; Third bridge
	(set g_e23_scarab_before_bridge2 true)
; Old	(scarab_walk_low_var0) ;(scarab_walk_front_to_walk_low)
; Old	(scarab_walk_low_var0) ;<none>
	(if (difficulty_legendary)
		(scarab_walk_front_to_walk_low)
		(begin
			(scarab_walk_low_var0)
			(scarab_walk_low_var0)
		)
	)
	(scarab_walk_low_var0)
	(scarab_walk_low_var0)
	(set g_e23_scarab_under_bridge2 true)
	(scarab_walk_low_to_walk_front)
	(set g_e23_scarab_after_bridge2 true)
	
	; Arrive at the turn
	(scarab_walk_front_to_idle)
	
	; Wait for the player
	(sleep_until 
		(volume_test_objects tv_e23_scarab_corner_continue (players))
		1
	)
	
	; Try to slip in a checkpoint
	(game_save)
	
	; Turn
	(scarab_idle_turn_22_left)
	(scarab_idle_turn_45_left)
	
	; Activate the left side guns
;	(wake scarab_left_gunner0_main)
;	(wake scarab_left_gunner1_main)

	; Finish the turn
	(set g_e23_scarab_after_turn true)
	(scarab_idle_turn_22_left)
	
	; Load the upper gun
;	(wake scarab_upper_gunner_main)

	; End walk
	(scarab_idle_to_walk_front)
	(scarab_walk_front_var0)
	(scarab_walk_front_turn_15_left)
; Old	;(scarab_walk_front_var0)
; Old	(scarab_walk_front_turn_15_right)
; Old	(scarab_walk_front_var0) ;<NONE>
	
	; Straighten out
	(if (difficulty_legendary)
		(begin
			(scarab_walk_front_var0)
			(scarab_walk_front_turn_15_right)
		)
		(begin
			(scarab_walk_front_turn_15_right)
			(scarab_walk_front_var0)
		)
	)

	; Inject a line of dialogue
	(print "cortana: It can't go any further this way. We have it trapped!")
	(ai_play_line_on_object none 2030)

	; Load the main gun
;	(ai_place scarab_gunners/main_gunner) ;REVIEW
	
	; Pause at the end, look around
	(scarab_walk_front_to_idle)
	(set g_e23_scarab_arrived_at_end true)
	(scarab_gun_open)
	(scarab_idle_var0)
	
	; Loop indefinitely in the endpoint sequences
	(sleep_until
		(begin
			; Fire at random Pelicans
			(begin_random
				; Pelican 0
				(if g_e23_scarab_active
					(begin
						; Take aim
						(if g_e23_scarab_active (scarab_idle_to_twist_5_right))
					
						; Tell the gunner to fire on it
;*						(if g_e23_scarab_active 
							(begin
								(scarab_gun_fire)
								(cs_stack_command_script scarab_gunners/main_gunner cs_e23_scarab_shoot_pelican0)
								(scarab_twist_5_right_firing)
							)
						)
*;
						; Move back
						(if g_e23_scarab_active (if (= (random_range 0 2) 0) (scarab_twist_5_right)))
						(if g_e23_scarab_active (scarab_twist_5_right_to_idle))
					)
				)
				
				; Pelican 1
				(if g_e23_scarab_active
					(begin
						; Take aim
						(if g_e23_scarab_active (scarab_idle_to_twist_5_left))
					
						; Tell the gunner to fire on it
;*						(if g_e23_scarab_active 
							(begin
								(scarab_gun_fire)
								(cs_stack_command_script scarab_gunners/main_gunner cs_e23_scarab_shoot_pelican1)
								(scarab_twist_5_left_firing)
							)
						)
*;
						; Move back
						(if g_e23_scarab_active (if (= (random_range 0 2) 0) (scarab_twist_5_left)))
						(if g_e23_scarab_active (scarab_twist_5_left_to_idle))
					)
				)
			)
			
			(not g_e23_scarab_active)
		)
		1
	)
)

(script dormant e23_ultra_dialogue
	; Wait for the ultra to engage the player
	(sleep_until 
		(>= (ai_combat_status e23_cov_inf1_0) ai_combat_status_clear_los)
	)
	
	; And wait for them to calm down a bit again
	(sleep_until 
		(<= (ai_combat_status e23_cov_inf1_0) ai_combat_status_active)
	)

	; Speak!
	(print "cortana: Careful Chief, that Elite was an Ultra! And those pilots are no pushovers either!!")
	(ai_play_line_on_object none 2050)
)

(script dormant e23_ultra_dialogue_kill
	(sleep_until (<= (ai_living_count e23_cov_inf1_0/ultra0) 0) 15)
	
	; Shutdown the dialogue prompts
	(sleep_forever e23_ultra_dialogue)
)

(script dormant e23_dialogue_boarding
	(sleep 30)
	(print "cortana: Chief, you're going to have to board the Scarab!")
	(ai_play_line_on_object none 2020)
	
	; Wait longer
	(sleep 600)
	(print "cortana: We can't do anything more to that Scarab from here")
	(ai_play_line_on_object none 2040)
	(sleep 75)
	(activate_team_nav_point_object default player scarab 8.5)	
)

(script dormant e23_dialogue_boarding_kill
	(sleep_until 
		(or
			g_mission_over
			(volume_test_objects tv_scarab (players)) 
		)
		15
	)
	
	; Shutdown the dialogue prompts
	(sleep_forever e23_dialogue_boarding)
	(deactivate_team_nav_point_object player scarab)
)

(script dormant e23_best_cs_ever
	; Only on legendary
	(if (not (difficulty_legendary)) (sleep_forever))
	
	; Only one out of 10 times
	(if (not (= (random_range 0 10) 0)) (sleep_forever))
	
	; Do it. Do it now.
	(set g_target (player0))
	(sleep_until
		(<= (object_get_health g_target) 0)
		10
	)
	
	; Do it
	(cs_run_command_script e23_cov_inf1_0/ultra0 cs_best_cs_ever)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e23_cov_inf1_main
	; Wait for the Scarab
	(sleep_until g_e23_scarab_climbed_down 5)

	; Wait for the player to board
	(sleep_until (volume_test_objects tv_scarab_stairwell (players)) 15)
	
	; Place the defenders
	(ai_place e23_cov_inf1_1)
	(ai_place e23_cov_inf1_0 (pin (- 4 (ai_living_count e23_cov_inf0)) 1 3))
	
	; Dialogue hooks
	(wake e23_ultra_dialogue)
	(wake e23_ultra_dialogue_kill)
	
	; Etc
	(wake e23_best_cs_ever)
	
	; Wait for the pilots to both be done, then deactivate the Scarab
	(sleep_until
		(and
			(not (cs_command_script_queued e23_cov_inf1_1/pilot0 cs_e23_cov_inf1_pilot0))
			(not (cs_command_script_queued e23_cov_inf1_1/pilot1 cs_e23_cov_inf1_pilot1))
		)
	)
	
	; Deactivate the Scarab
	(set g_e23_scarab_active false)
	
	; Wait for them to be dead
	(sleep_until (<= (ai_living_count e23_cov_inf1) 0)) 
	(set g_mission_over true)
)

(script dormant e23_cov_inf0_main
	; Wait for the Scarab
	(sleep_until g_e23_scarab_climbed_down 5)
	(ai_place e23_cov_inf0_0)
	
	; Pause and spawn
	(sleep_until 
		(or
			g_e23_scarab_under_bridge1
			(<= (ai_living_count e23_cov_inf0) 2)
			(volume_test_objects tv_scarab_interior (players)) 
		)
		15
	)
	(ai_place e23_cov_inf0_1 (pin (- 6 (ai_living_count e23_cov_inf0)) 0 4))
	
	; Pause and spawn
	(sleep_until 
		(or
			g_e23_scarab_under_bridge2
			(<= (ai_living_count e23_cov_inf0) 2)
			(volume_test_objects tv_scarab_interior (players)) 
		)
		15
	)
	(ai_place e23_cov_inf0_2 (pin (- 6 (ai_living_count e23_cov_inf0)) 0 3))

	; Pause and spawn
	(sleep_until 
		(or
			g_e23_scarab_arrived_at_end
			(<= (ai_living_count e23_cov_inf0) 2)
			(volume_test_objects tv_scarab_interior (players)) 
		)
		15
	)
	(ai_place e23_cov_inf0_3 (pin (- 6 (ai_living_count e23_cov_inf0)) 0 2))

	; Pause and spawnw
	(sleep_until 
		(or
			g_e23_scarab_arrived_at_end
			(volume_test_objects tv_scarab (players)) 
		)
		15
	)
	(ai_place e23_cov_inf0_4 (pin (- 6 (ai_living_count e23_cov_inf0)) 0 5))
	
	; Sneak in a save
	(game_save)

	; Wait until they're roughed up
	(sleep_until 
		(<= (ai_living_count e23_cov_inf0) 2)
	)
	
	; Wait the boarding prompts
	(wake e23_dialogue_boarding)
	(sleep 10)
	(wake e23_dialogue_boarding_kill)

	; Wait until they're dead, then try another checkpoint
	(sleep_until 
		(<= (ai_living_count e23_cov_inf0) 0)
	)
	(game_save)
)

(script dormant e23_mars_pelican2_main
	(sleep_until 
		(volume_test_objects tv_e23_mars_pelican0_begin (players))
		15
	)

	; Begin the loop
	(sleep_until
		(begin
			(begin_random
				(begin
					(ai_place e23_mars_pelican2/pelican0)
					(sleep (random_range 60 90))
					(sleep_until (< (ai_living_count e23_mars_pelican2) 2))
				)
				(begin
					(ai_place e23_mars_pelican2/pelican1)
					(sleep (random_range 60 90))
					(sleep_until (< (ai_living_count e23_mars_pelican2) 2))
				)
				(begin
					(ai_place e23_mars_pelican2/pelican0)
					(sleep (random_range 60 90))
					(sleep_until (< (ai_living_count e23_mars_pelican2) 2))
				)
				(begin
					(ai_place e23_mars_pelican2/pelican1)
					(sleep (random_range 60 90))
					(sleep_until (< (ai_living_count e23_mars_pelican2) 2))
				)
				(begin
					(ai_place e23_mars_pelican2/pelican2)
					(ai_place e23_mars_pelican2/gunner0)
					(ai_place e23_mars_pelican2/gunner1)
					(sleep 1)
					
					; Load them
					(vehicle_load_magic (ai_vehicle_get e23_mars_pelican2/pelican2) "pelican_g_pod" (ai_get_object e23_mars_pelican2/gunner0))
					(vehicle_load_magic (ai_vehicle_get e23_mars_pelican2/pelican2) "pelican_g_pod" (ai_get_object e23_mars_pelican2/gunner1))
					
					; Head out
					(set g_e23_mars_pelican2_2_active true)
					(sleep_until (not g_e23_mars_pelican2_2_active))
					(sleep_until (< (ai_living_count e23_mars_pelican2) 2))
				)
			)
			
			; Loop until the mission has ended
			g_mission_over
		)
	)
)

(script dormant e23_mars_pelican1_main
	(sleep_until 
		(volume_test_objects tv_e23_mars_pelican1_begin (players))
		15
	)

	; Place and send
	(ai_place e23_mars_pelican1_0)
;	(cs_run_command_script e23_mars_pelican1_0/pelican0 cs_e23_mars_pelican1_0_entry)
	(sleep 60)
	(ai_place e23_mars_pelican1_1)
;	(cs_run_command_script e23_mars_pelican1_1/pelican0 cs_e23_mars_pelican1_1_entry)
)

(script dormant e23_mars_pelican0_main
	(sleep_until 
		(or
			(volume_test_objects tv_e23_mars_pelican0_begin (players))
			g_e23_scarab_under_bridge1
		)
		15
	)

	; Place the Pelican
	(ai_place e23_mars_pelican0)
	
	; Load them
	(ai_vehicle_enter_immediate e23_mars_pelican0_0/gunner0 (ai_vehicle_get e23_mars_pelican0_0/pelican0) "pelican_g_pod")
	(ai_vehicle_enter_immediate e23_mars_pelican0_0/gunner1 (ai_vehicle_get e23_mars_pelican0_0/pelican0) "pelican_g_pod")
	(ai_vehicle_enter_immediate e23_mars_pelican0_1/gunner0 (ai_vehicle_get e23_mars_pelican0_1/pelican0) "pelican_g_pod")
	(ai_vehicle_enter_immediate e23_mars_pelican0_1/gunner1 (ai_vehicle_get e23_mars_pelican0_1/pelican0) "pelican_g_pod")
)

(script dormant e23_mars_inf1_main
	(ai_migrate e22_mars_inf1 e23_mars_inf1)
;	(ai_migrate e22_mars_inf0/perez e23_mars_inf1)
	(ai_place e23_mars_inf1 (- 3 (ai_living_count e23_mars_inf1)))
)

(script dormant e23_mars_inf0_main
	(ai_place e23_mars_inf0) ; Reduced from 3 spawned to 1
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e23_main
	(sleep_until (volume_test_objects tv_e23_main_begin (players)) 15)
	(set g_e23_started true)
	(print "e23_main")
	(data_mine_set_mission_segment "e23_scarab_boarding")
	(game_save)
	
	; Remove the gun on legendary (guns are for wusses)
	(if (difficulty_legendary) (object_destroy e23_gun))
	
	; Music
	(wake music_03b_04_start)
	(wake music_03b_04_start_alt)
	
	; Kill volumes
	(kill_volume_enable kill_e23_0)
	(kill_volume_enable kill_e23_1)
	(kill_volume_enable kill_e23_2)

	; Wake control scripts
;	(wake e23_mars_inf0_main)
	(wake e23_mars_inf1_main)
;	(wake e23_mars_pelican0_main)
;	(wake e23_mars_pelican1_main)
	(wake e23_mars_pelican2_main)
	(wake e23_cov_inf0_main)
	(wake e23_cov_inf1_main)
	
	; Shut down
	
	; Clean up
)

(script static void test_scarab_boarding
	(object_teleport (player0) e23_test)

	; Get the scarab set up
	(object_create scarab)
	(pvs_set_object scarab)
	(object_teleport scarab e23_scarab_start)
	(set g_e23_scarab_arrived true)

	(if (not g_e23_started) (wake e23_main))
	(wake e23_scarab)	
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

(global boolean g_e22_started false)			; Encounter has been activated?

(global boolean g_e22_scarab_visible false)			; The scarab is visible
(global boolean g_e22_scarab_appeared false)		; The scarab has rounded the corner
(global boolean g_e22_scarab_advancing false)		; The scarab has started his advance
(global boolean g_e22_scarab_before_climb false)	; The scarab is about to climb
(global boolean g_e22_scarab_started_climb false)	; The scarab has started to climb
(global boolean g_e22_scarab_mid_climb false)		; The scarab is directly overhead
(global boolean g_e22_scarab_past_climb false)		; The scarab has passed overhead

(global boolean g_e22_done_street_cleanup false)

(global boolean g_e22_scorpion_asplode false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e22_mars1_go
	(cs_enable_pathfinding_failsafe true)
	(ai_vehicle_exit ai_current_actor)
	(cs_go_to e22_mars_inf1/p0)
)

(script command_script cs_e22_mars1_lieutenant
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_looking false)

	; Look out towards the Scarab
	(cs_look true e22_mars_inf1/scarab_entry)
	
	; Wait for the player to enter
	(sleep_until (volume_test_objects tv_e22_scarab_entry_begin (players)) 10)
	(cs_look_player true)
	
	; Wait for the player to get closer
	(sleep_until 
		(and
			(> (device_get_position e22_door3) 0.0)
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3.5)
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
		)
		5
	)
	(sleep 30)
	(print "lt: when I asked for reinforcements...")
	(sleep (- (ai_play_line ai_current_actor 0770) 75)) ; "When I asked for reins..."

	; Have the other Marine interject
;	(ai_play_line e22_mars_inf1/marine0 0780) (print "gnr: sarge!")

	; Look back
	(cs_look true e22_scarab_target/target)
	(sleep 55)
	(cs_aim true e22_scarab_target/target)
	(sleep 27)
	(cs_crouch true)
	
	; Line
	(sleep (ai_play_line ai_current_actor 8030)) (print "lf: we got trouble")
;	(cs_start_to e22_mars_inf1/lt_backpedal)

	; More lines
	(sleep_until (<= (ai_living_count e22_mars_scorpions0) 0) 15)
	(sleep 60)
	(print "gnr: alright, this is the shit")
	(sleep (- (ai_play_line e22_mars_inf1/marine0 8060) 30)) 
	
	; Look at him
	(cs_look_object true (ai_get_object e22_mars_inf1/marine0))
	(sleep 45)
	(print "lt: marine, did I give you permission to bitch?")
	(sleep (ai_play_line ai_current_actor 8010)) 
	(cs_look true e22_scarab_target/target)
	(cs_movement_mode ai_movement_combat)
	(cs_aim true e22_scarab_target/target)

	; Sleep until it's about to climb
	(sleep_until g_e22_scarab_before_climb 5)
	(print "lt: I don't think it's stopping")
	(ai_play_line ai_current_actor 0790) 
	
	; Sleep until it's past
	(sleep_until g_e22_scarab_mid_climb 5)
	(cs_crouch false)
	(sleep 90)	
	(ai_play_line ai_current_actor 8040) (print "lt: That thing is starting to piss me off")
	(sleep 100)

	; Stop looking at the Scarab
	(cs_aim false e22_scarab_target/target)
	(cs_face_player true)
	
	; Release the hounds!
	(ai_play_line ai_current_actor 0830) (print "lt: Marines, time to kill us a Scarab")
	(cs_look_player false)
	(sleep 30)
	
	; Move on
	(cs_enable_looking true)
	(cs_start_to e22_mars_inf1/p0)
	
	; Have the others follow
	(sleep 20)
	(cs_run_command_script e22_mars_inf1/marine0 cs_e22_mars1_go)
	(sleep 20)
	(cs_run_command_script e22_mars_inf0/perez cs_e22_mars1_go)
	
	; Give the objective
	(wake objective3_set)
)

(script command_script cs_e22_mars0_crouch
	(cs_enable_dialogue true)
	(cs_movement_mode ai_movement_combat)
	(cs_crouch true)
	(cs_look_player true)
	(sleep_forever)
)

(script command_script cs_e22_mars0_stand
	(cs_enable_dialogue true)
	(cs_movement_mode ai_movement_patrol)
	(cs_look_player true)
	(sleep_forever)
)

(script command_script cs_e22_mars0_perez
	(cs_enable_pathfinding_failsafe true)
	(cs_face_player true)
	(cs_go_to e22_mars_inf0_perez/p0)

	; Approach the player for hailing
	(cs_start_approach_player 3 20 35)
	(print "perez: hey chief!")
	
	; Wait until the player isn't in a vehicle
	(sleep_until 
		(not (players_in_vehicle))
		10
	)
	
	; Get up closer
	(cs_approach_player 1.5 5 10)
	(cs_face_player true)
	(sleep (- (ai_play_line_at_player ai_current_actor 0710) 30))	; "Sir? Cpl Perez, A-company"
	(cs_face_player false)
	(cs_enable_looking true)

	; Head inside
	(cs_start_to e22_mars_inf0_perez/p1)
	(sleep 45)
	(cs_look_player true)
	
	; Keep talking
	(print "the lt. got hit")
	(sleep (ai_play_line ai_current_actor 0730)) ; "The lieutenat got hit"
	(sleep 15)
	
	; Cortana asks her line
	(print "who in charge")
	(sleep (- (ai_play_line_on_object none 0740) 30)) ; "Who's in charge now?"
	(cs_look_player true)
	(sleep 45)
	
	; Stop and turn
	(sleep_until (not (cs_moving)) 5)
	(cs_face_player true)
	(sleep (ai_play_line_at_player ai_current_actor 0750)) ; "Sgt Banks, he's upstairs"
		
	; Continue to the last point
	(cs_face_player false)
	(cs_look_player false)
	(cs_enable_looking true)
	(cs_start_to e22_mars_inf0_perez/p2)
	
	; Keep chatting
	(print "c'mon, I'll show you")
	(ai_play_line ai_current_actor 0760) ; "C'mon I'll show you"
	
	; Arrival
	(sleep 20)
	(sleep_until (not (cs_moving)) 5)
	(cs_look_player true)
)

(script command_script cs_e22_mars_inf1_crouch
	(cs_crouch true)
	(cs_face true e22_scarab_target/target)
	(cs_aim true e22_scarab_target/target)
	(sleep_until g_e22_scarab_advancing 5)
	(sleep 150)
	
	; Open fire
	(cs_shoot_point true e22_scarab_target/target)
	
	; Stop and exit
	(sleep_until g_e22_scarab_before_climb 5)
	(cs_shoot_point false e22_scarab_target/target)
	(ai_vehicle_exit ai_current_actor)
	(sleep_until g_e22_scarab_mid_climb 5)
	(sleep 20)
	(cs_crouch false)
	(sleep_until g_e22_scarab_past_climb 5)
	(sleep (random_range 20 40))
	(cs_go_to e22_mars_inf1/p0)
)

(script command_script cs_e22_mars_inf1_marine1
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 3)

	; Move outside
	(cs_start_to e22_mars_inf1/p1)
	(cs_look true e22_mars_scorpions0/scarab_target)

	; Wait for the player to get close enough to beckon
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 11.0) 5)
	(cs_face_player true)
	(ai_play_line_at_player ai_current_actor 0840)

	; Turn and head back in
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 4.0) 5)
	(cs_face_player false)
	(cs_go_to e22_mars_inf1/p0)
)

(script command_script cs_e22_mars_inf2_marine_end
	(cs_face true e22_scarab_target/target)
	(cs_crouch true)
	(sleep_until g_e22_scarab_mid_climb 5)
	(cs_crouch false)
	(sleep_until g_e22_scarab_past_climb 5)
	(cs_force_combat_status 2)
	(sleep_forever)
)

(script command_script cs_e22_mars_inf2_marine0
	(cs_force_combat_status 3)
	(cs_crouch true)
	(sleep_until g_e22_scarab_appeared 5)
	(sleep (random_range 30 45))

	; Fire
	(cs_shoot_point true e22_scarab_target/target)
	(sleep_until g_e22_scarab_advancing 5)
	(sleep (random_range 120 150))
	
	; Retreat
	(cs_shoot_point false e22_scarab_target/target)
	(cs_crouch false)
	(cs_go_to e22_mars_inf2/p0)
	(cs_run_command_script ai_current_actor cs_e22_mars_inf2_marine_end)
)

(script command_script cs_e22_mars_inf2_marine1
	(cs_force_combat_status 3)
	(sleep_until g_e22_scarab_appeared 5)
	(sleep (random_range 30 45))

	; Fire
	(cs_shoot_point true e22_scarab_target/target)
	(sleep_until g_e22_scarab_advancing 5)
	(sleep (random_range 120 150))
	
	; Retreat
	(cs_shoot_point false e22_scarab_target/target)
	(ai_vehicle_exit ai_current_actor)
	(cs_crouch false)
	(cs_go_to e22_mars_inf2/p1)
	(cs_run_command_script ai_current_actor cs_e22_mars_inf2_marine_end)
)

(script command_script cs_e22_mars_inf2_marine2
	(cs_force_combat_status 3)
	(cs_crouch true)
	(sleep_until g_e22_scarab_appeared 5)
	(sleep (random_range 30 45))

	; Fire
	(cs_shoot_point true e22_scarab_target/target)
	(sleep_until g_e22_scarab_advancing 5)
	(sleep (random_range 180 210))
	
	; Retreat
	(cs_shoot_point false e22_scarab_target/target)
	(cs_crouch false)
	(cs_go_to e22_mars_inf2/p2)
	(cs_run_command_script ai_current_actor cs_e22_mars_inf2_marine_end)
)

(script command_script cs_e22_mars_inf2_marine3
	(cs_force_combat_status 3)
	(sleep_until g_e22_scarab_appeared 5)
	(sleep (random_range 30 45))

	; Fire
	(cs_shoot_point true e22_scarab_target/target)
	(sleep_until g_e22_scarab_advancing 5)
	(sleep (random_range 180 210))
	
	; Retreat
	(cs_shoot_point false e22_scarab_target/target)
	(ai_vehicle_exit ai_current_actor)
	(cs_crouch false)
	(cs_go_to e22_mars_inf2/p3)
	(cs_run_command_script ai_current_actor cs_e22_mars_inf2_marine_end)
)

(script command_script cs_e22_mars_inf2_marine4
	(cs_force_combat_status 3)
	(cs_crouch true)
	(sleep_until g_e22_scarab_appeared 5)
	(sleep (random_range 30 45))

	; Fire
	(cs_shoot_point true e22_scarab_target/target)
	(sleep_until g_e22_scarab_advancing 5)
	(sleep (random_range 240 270))
	
	; Retreat
	(cs_shoot_point false e22_scarab_target/target)
	(cs_crouch false)
	(cs_go_to e22_mars_inf2/p4)
	(cs_run_command_script ai_current_actor cs_e22_mars_inf2_marine_end)
)

(script command_script cs_e22_mars_scorpion0
	(cs_force_combat_status 3)
	(cs_aim true e22_scarab_target/target)
	(sleep_until g_e22_scarab_visible 5)

	; Fire
	(cs_shoot_point true e22_scarab_target/target)
	(sleep_until g_e22_scorpion_asplode 5)
	(unit_kill (ai_vehicle_get ai_current_actor)) ;REVIEW
)

(script command_script cs_e22_scarab_main_gun
	(cs_shoot true (ai_vehicle_get e22_mars_scorpions0/scorpion0))
;	(sleep 165)
	(sleep 120)
	(set g_e22_scorpion_asplode true) ;REVIEW
	(sleep 45)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e22_scarab_climbing_events
	; Awakened when the scarab is about to climb the building
	(sleep 45)	
	(set g_e22_scarab_started_climb true)
	(print "g_e22_scarab_started_climb ")

	; Mid climb
	(sleep 100)
	(set g_e22_scarab_mid_climb true)
	(print "g_e22_scarab_mid_climb ")

	; TODO: Footfall dust shakes
	(print "todo: boom boom dust shakes")

	; Post climb
	(sleep 90)
	(set g_e22_scarab_past_climb true)
	(print "g_e22_scarab_past_climb ")
)

(script dormant e22_scarab_advancing_events
	; Awakened when the scarab begins advancing on the building
	(set g_e22_scarab_advancing true)
	(print "g_e22_scarab_advancing ")
	
	; Destroy back half of Bridge 0
	(sleep 259)
	(object_damage_damage_section e22_bridge0_2 "main" 1.0)
	(object_damage_damage_section e22_bridge0_3 "main" 1.0)
	(object_damage_damage_section e22_bridge0_4 "main" 1.0)
	(object_damage_damage_section e22_bridge0_5 "main" 1.0)
	(sleep 2)
	(object_damage_damage_section e22_bridge0_0 "main" 1.0)
	(object_damage_damage_section e22_bridge0_1 "main" 1.0)
	
	; Destroy Bridge 1
	(sleep 118)
	(object_damage_damage_section e22_bridge1_2 "main" 1.0)
	(sleep 1)
	(object_damage_damage_section e22_bridge1_0 "main" 1.0)
	(object_damage_damage_section e22_bridge1_1 "main" 1.0)
	(object_damage_damage_section e22_bridge1_3 "main" 1.0)
	(object_damage_damage_section e22_bridge1_4 "main" 1.0)
	(sleep 1)
	(object_damage_damage_section e22_bridge1_5 "main" 1.0)
	(object_damage_damage_section e22_bridge1_6 "main" 1.0)
	(sleep 1)
	(object_damage_damage_section e22_bridge1_7 "main" 1.0)
	(object_damage_damage_section e22_bridge1_8 "main" 1.0)
	(object_damage_damage_section e22_bridge1_9 "main" 1.0)
	
	; Destroy Bridge 2
	(sleep 19)
	(object_damage_damage_section e22_bridge2_0 "main" 1.0)
	(sleep 1)
	(object_damage_damage_section e22_bridge2_3 "main" 1.0)
	(object_damage_damage_section e22_bridge2_5 "main" 1.0)
	(sleep 1)
	(object_damage_damage_section e22_bridge2_1 "main" 1.0)
	(object_damage_damage_section e22_bridge2_2 "main" 1.0)
	(object_damage_damage_section e22_bridge2_4 "main" 1.0)

	; Before the climb
	(sleep 30)
	(set g_e22_scarab_before_climb true)
	(print "g_e22_scarab_before_climb ")
)

(script dormant e22_scarab_appearance_events
	; Awakened when the scarab is first created
	(sleep 60)
	(set g_e22_scarab_visible true)
	(sleep 180)
	(set g_e22_scarab_appeared true)
	(print "g_e22_scarab_appeared ")
)

(script dormant e22_scarab_intro_gun
	(object_create e22_scarab_gun)
	(weapon_hold_trigger e22_scarab_gun 0 true)
	(sleep 45)
	(weapon_hold_trigger e22_scarab_gun 0 false)
	(sleep 60)
	(object_destroy e22_scarab_gun)
)

(script dormant e22_scarab
	; Wait till the player is inside to arm the trigger, then trigger
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 10)
	(sleep_until (volume_test_objects tv_e22_scarab_entry_begin (players)) 10)
	
	; Create and start firing the gun
	(wake e22_scarab_intro_gun)
	
	; Chapter title
	(wake chapter_title2)
	
	; Pause
	(sleep 50)

	; Load up the main gunner
	(ai_place scarab_gunners/main_gunner)
	
	; Create the Scarab, set the PVS, and teleport it to the location
	(object_create_anew scarab)
	(object_teleport scarab e22_scarab_start)
	(pvs_set_object scarab)
	
	; Have it enter
	(wake e22_scarab_appearance_events)
	(scarab_gun_open_down_instant)
	(device_set_position_track scarab finale_enter 0)
	(device_animate_position scarab 1.0 (/ 266.0 30.0) 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)

	; STAND AND DELIVER
	(cs_stack_command_script scarab_gunners/main_gunner cs_e22_scarab_main_gun)
	(scarab_gun_fire_down)
	(scarab_idle_firing)

	; Continue in
	(wake e22_scarab_advancing_events)
	(scarab_idle_to_walk_front_fast)
	(scarab_walk_front_var0_fast)
	(scarab_gun_close_down)
	(scarab_walk_front_var0_fast)
	(scarab_walk_front_var0_fast)
	(scarab_walk_front_var0_fast)
	(scarab_walk_front_var0_fast)

	; Mount that building. Rawr.
	(wake e22_scarab_climbing_events)
	(device_set_position_track scarab finale_climb_on_buildings g_scarab_interpolation)
	(device_animate_position scarab 1.0 (/ 446.0 30.0) 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)

	; Flag that we're done and have arrived
	(set g_e23_scarab_arrived true)
	
	; Twist in place
	(begin_random
		(if (not g_e23_started)
			(begin
				(scarab_idle_to_twist_5_right)
				(scarab_twist_5_right_to_idle)
			)
		)
		(if (not g_e23_started)
			(begin
				(scarab_idle_to_twist_5_left)
				(scarab_twist_5_left_to_idle)
			)
		)
	)
	
	; Continue
	(wake e23_scarab)
)

(script dormant e22_nasty_player_synch
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 5)
	
	; Teleport up the player
	(volume_teleport_players_not_inside tv_e22_no_teleport e22_nasty_player_synch)
	
	; Clean the streets!
	(sleep_until
		; Is there a vehicle in this volume?
		(if
			(> (list_count (volume_return_objects_by_type tv_e22_street_cleanup 2)) 0)
			
			; There is something, so delete it
			(begin
				; Destroy!
				(object_destroy (list_get (volume_return_objects_by_type tv_e22_street_cleanup 2) 0))
			
				; Return false so the loop doesn't end
				(= 1 0)
			)
			
			; There isn't anything, just return True so the loop ends
			(= 1 1)		
		)
		1
	)
	
	; And garbage collect
	(garbage_collect_unsafe)
	
	; Flag the cleanup as done so that we can spawn the Scorpion
	(set g_e22_done_street_cleanup true)
)

(script dormant e22_objective
	; Clear the objective when the player enters the building
	(sleep_until (volume_test_objects tv_e22_scarab_entry_begin (players)) 5)
	(wake objective2_clear)

	; Wait until the scarab is passed overhead
	(sleep_until g_e22_scarab_past_climb)
	(wake objective3_set)
)

(script dormant e22_dialogue
	; Wait for the player to stray
	(sleep_until 
		(volume_test_objects tv_e22_away_from_building (players)) 
		5
		30_seconds
	)
	
	; Have Cortana prompt him back in
	(ai_play_line_on_object none 2000) ; "There's a command post in..."
	(sleep 75)
	
	; Slap a nav point on it, for good measure
	(activate_team_nav_point_flag default player e22_navpoint 0)	
	
	; Wait longer
	(sleep_until 
		(volume_test_objects tv_e22_near_building (players)) 
		5
		450
	)
	
	; If the player isn't in the volume, prompt him again
	(if (not (volume_test_objects tv_e22_near_building (players)))
		(ai_play_line_on_object none 2010) ; "There's a command post in..."
	)
)

(script dormant e22_dialogue_kill
	(sleep_until 
		(or
			g_e23_started
			(volume_test_objects tv_e22_main_begin (players)) 
		)
		10
	)
	
	; Kill the dialogue script
	(sleep_forever e22_dialogue)
	
	; Wait for him to get closer
	(sleep_until 
		(or
			g_e23_started
			(volume_test_objects tv_e22_doorway (players)) 
		)
		10
	)
	
	; Remove the nav point
	(deactivate_team_nav_point_flag player e22_navpoint)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e22_mars_inf3_main
	(sleep_until (volume_test_objects tv_e22_mars_inf3_begin (players)) 10)
)

(script dormant e22_mars_inf2_main
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 10)
	(ai_place e22_mars_inf2)
	
	; Erase the old, faux e22_mars_inf2
	(ai_erase e21_mars_pelican1)
	
	; Command scripts
	(cs_run_command_script e22_mars_inf2/marine0 cs_e22_mars_inf2_marine0)
	(cs_run_command_script e22_mars_inf2/marine1 cs_e22_mars_inf2_marine1)
	(cs_run_command_script e22_mars_inf2/marine2 cs_e22_mars_inf2_marine2)
	(cs_run_command_script e22_mars_inf2/marine3 cs_e22_mars_inf2_marine3)
	(cs_run_command_script e22_mars_inf2/marine4 cs_e22_mars_inf2_marine4)
)

(script dormant e22_mars_inf1_main
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 10)
	(ai_place e22_mars_inf1/lieutenant)
	(ai_place e22_mars_inf1/marine0)
	
	; Give Banks a comm pack
	(object_set_permutation (ai_get_object e22_mars_inf1/lieutenant) "comm_pack" "on")
	
	; Wait until it has finished climbing overhead
	(sleep_until g_e22_scarab_past_climb 5)

	; Unlock the upper door
	(device_operates_automatically_set e22_door1 true)
	(device_operates_automatically_set e22_door2 true)
	(device_closes_automatically_set e22_door1 false)
	(device_closes_automatically_set e22_door2 false)
	(device_set_position e22_door1 1.0)
	(device_set_position e22_door2 1.0)
	
	; Once the Scarab has passed overhead, place the guide marine
	(ai_place e22_mars_inf1/marine1)

	; If the Sarge is dead (fucking player), send them along
	(if (<= (ai_living_count e22_mars_inf1/lieutenant) 0)
		(begin
			(cs_run_command_script e22_mars_inf1/marine0 cs_e22_mars1_go)
			(cs_run_command_script e22_mars_inf0/perez cs_e22_mars1_go)
		)
	)
)

(script dormant e22_mars_inf0_main
	; Unlock, open the door
	(device_set_position e22_door0 1.0)
	(device_operates_automatically_set e22_door0 true)
	(ai_place e22_mars_inf0/perez)
	(ai_place e22_mars_inf0/guard0)
	(ai_place e22_mars_inf0/guard2)

	; Place the rest
	(sleep_until (volume_test_objects tv_e22_main_begin (players)) 15)
	(ai_place e22_mars_inf0/guard1)
	(ai_place e22_mars_inf0/medic0)
	
	; Migrate other actors, have them exit any vehicles
	(ai_migrate e21_mars_warthog0 e22_mars_inf0)
	(ai_vehicle_exit e22_mars_inf0)
		
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
)

(script dormant e22_mars_scorpions0_main
	(sleep_until g_e22_done_street_cleanup 10)
	(ai_place e22_mars_scorpions0)
	
	; Command scripts
	(cs_run_command_script e22_mars_scorpions0/scorpion0 cs_e22_mars_scorpion0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e22_main
	(set g_e22_started true)
	(print "e22_main")
	(data_mine_set_mission_segment "e22_scarab_intro")
	(game_save)
	;(garbage_collect_now)

	; Wake subsequent scripts
	(wake e23_main)
	
	; Music
	(wake music_03b_03_stop)

	; Wake control scripts
	(wake e22_nasty_player_synch)
	(wake e22_mars_inf0_main)
	(wake e22_mars_inf1_main)
	(wake e22_mars_inf2_main)
	(wake e22_mars_inf3_main)
	(wake e22_mars_scorpions0_main)
	(wake e22_scarab)
	(wake e22_objective)
	(wake e22_dialogue)
	(wake e22_dialogue_kill)
	
	; Shut down
	(sleep_until g_e23_started)
	(sleep_forever e22_nasty_player_synch)
	(sleep_forever e22_mars_inf0_main)
	(sleep_forever e22_mars_inf1_main)
	(sleep_forever e22_mars_inf2_main)
	(sleep_forever e22_mars_inf3_main)
	(sleep_forever e22_mars_scorpions0_main)
	(sleep_forever e22_dialogue)
)

(script static void test_scarab_intro
	(switch_bsp 1)
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

(global boolean g_e21_cov_phantom0_retreating false)	; Is the Phantom retreating?
(global boolean g_e21_cov_phantom1_retreating false)	; Is the Phantom retreating?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e21_cov_phantom0_bombard
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_definite)
	
	; Bombard the building
	(sleep_until
		(begin
			(begin_random
				(begin (cs_shoot_point true e21_cov_bombard/p5) (sleep 120))
				(begin (cs_shoot_point true e21_cov_bombard/p6) (sleep 120))
				(begin (cs_shoot_point true e21_cov_bombard/p7) (sleep 120))
				(begin (cs_shoot_point true e21_cov_bombard/p8) (sleep 120))
			)
		
			; Loop forever, the main script will break us out
			false
		)
	)
)

(script command_script cs_e21_cov_wraiths0_bombard
	(cs_abort_on_damage true)
	
	; Bombard the building
	(sleep_until
		(begin
			(begin_random
				(begin (cs_shoot_point true e21_cov_bombard/p0) (sleep 60))
				(begin (cs_shoot_point true e21_cov_bombard/p1) (sleep 60))
				(begin (cs_shoot_point true e21_cov_bombard/p2) (sleep 60))
			)
		
			; Loop forever, the main script will break us out
			false
		)
	)
)

(script command_script cs_e21_cov_abort_bombard
	(sleep 1)
)

(script command_script cs_e21_cov_phantom1_entry
	(cs_fly_by e21_cov_phantom1_entry/p0)
	(cs_fly_by e21_cov_phantom1_entry/p1)
	(cs_fly_to e21_cov_phantom1_entry/p2)
	(sleep 15)
	(cs_fly_to e21_cov_phantom1_entry/p3 0.5)

	; Unload the Ghosts
	(sleep 30)
	(begin_random
		(begin (vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc01") (sleep 15))
		(begin (vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc02") (sleep 15))
	)
	(sleep 15)
)

(script command_script cs_e21_cov_phantom_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e21_cov_phantom_exit/p0)
	(cs_fly_to e21_cov_phantom_exit/p1)
	(cs_fly_to e21_cov_phantom_exit/p2 0.5)
	(ai_erase ai_current_squad)
)

(script command_script cs_e21_mars_pelican0_entry
	(cs_fly_by e21_mars_pelican0_entry/p0)
	(cs_fly_to e21_mars_pelican0_entry/p1 0.5)
	(cs_face true e21_mars_pelican0_entry/p1_facing)
	(sleep_forever)
)

(script command_script cs_e21_mars_pelican0_exit
	(cs_fly_by e21_mars_pelican0_entry/p2)
	(cs_fly_by e21_mars_pelican0_entry/p3)
	(cs_vehicle_boost true)
	(cs_fly_by e21_mars_pelican0_entry/p4)
	(cs_fly_by e21_mars_pelican0_entry/p5)
	(ai_erase ai_current_squad)
)

(script command_script cs_e21_mars_pelican1_entry
	(cs_fly_by e21_mars_pelican1_entry/p0)
	(cs_fly_by e21_mars_pelican1_entry/p0_1)
	(cs_fly_by e21_mars_pelican1_entry/p0_2)
	(cs_fly_to e21_mars_pelican1_entry/p1 0.5)
	(cs_face true e21_mars_pelican1_entry/p1_facing)
	(sleep 30)

	; Unload the Marines
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p")

	(sleep 180)
	(cs_face false e21_mars_pelican1_entry/p1_facing)
	(cs_fly_by e21_mars_pelican1_entry/p2)
	(cs_fly_by e21_mars_pelican1_entry/p3)
	(cs_vehicle_boost true)
	(cs_fly_by e21_mars_pelican1_entry/p4)
	(cs_fly_by e21_mars_pelican1_entry/p5)
	(object_destroy (ai_vehicle_get ai_current_actor))
	(ai_erase ai_current_actor)
)

(script command_script cs_e21_mars_inf1_exit
	(cs_go_to e21_mars_inf1/p0)
	(ai_erase ai_current_actor)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e21_cov_phantom1_retreating
	(= g_e21_cov_phantom1_retreating true)
)

(script static boolean e21_cov_phantom0_retreating
	(= g_e21_cov_phantom0_retreating true)
)


;- Event Controls --------------------------------------------------------------

(script dormant e21_dialog
	(sleep_until 
		(volume_test_objects tv_e21_boulevard1 (players)) 
		15
	)
	(sleep (ai_play_line_on_object none 0690)) ; "Marines trapped in that building"
	(sleep 10)
	(sleep (ai_play_line_on_object none 0700)) ; "Concentrate on the Wraiths"
)


;- Squad Controls --------------------------------------------------------------

(script dormant e21_cov_creep0_main
	; Sleep until the player is nearby
	(sleep_until 
		(or
			(volume_test_objects tv_e21_cov_creep0_main (players)) 
			(volume_test_objects tv_e21_cov_inf0_unsafe (players)) 		
		)	
		15
	)
	(ai_place e21_cov_creep0)
)

(script dormant e21_cov_phantom1_main
	(sleep_until 
		(<= (ai_living_count e21_cov_wraiths0) 1)
		30
		two_minutes
	)
	
	; Place the Phantom
	(ai_place e21_cov_phantom1)
	
	; Load the Ghosts into it
	(ai_place e21_cov_ghosts0_0)
	(sleep 2)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location e21_cov_phantom1/phantom0) "phantom_sc01" (ai_vehicle_get_from_starting_location e21_cov_ghosts0_0/ghost0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location e21_cov_phantom1/phantom0) "phantom_sc02" (ai_vehicle_get_from_starting_location e21_cov_ghosts0_0/ghost1))

	; Send it in
	(cs_run_command_script e21_cov_phantom1/phantom0 cs_e21_cov_phantom1_entry)
	
	; Sleep until we should retreat
	(sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get e21_cov_phantom1/phantom0)) 0.05) 
			(>= (object_model_targets_destroyed (ai_vehicle_get e21_cov_phantom1/phantom0) "target_front") 3)
		)
		10
		one_minute
	)
	
	; Book
	(set g_e21_cov_phantom1_retreating true)
	(cs_run_command_script e21_cov_phantom1/phantom0 cs_e21_cov_phantom_exit) 
)

;*
(script dormant e21_cov_phantom0_main
	(ai_place e21_cov_phantom0)
	(cs_run_command_script e21_cov_phantom0 cs_e21_cov_phantom0_bombard)
	
	; Break the Phantom out of the command script when people become aware of
	; the player
	(sleep_until
		(or
			(ai_trigger_test generic_player_sighted e21_cov_phantom0)
			(<= (ai_living_count e21_cov_wraiths0) 1)
		)
		10
	)
	
	; Break out
	(cs_run_command_script e21_cov_phantom0 cs_e21_cov_abort_bombard)
	
	; Sleep until we should retreat
	(sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get e21_cov_phantom0/phantom0)) 0.05) 
			(>= (object_model_targets_destroyed (ai_vehicle_get e21_cov_phantom0/phantom0) "target_front") 3)
		)
		10
		one_minute
	)
	
	; Book
	(set g_e21_cov_phantom0_retreating true)
	(cs_run_command_script e21_cov_phantom0/phantom0 cs_e21_cov_phantom_exit) 
)
*;

(script dormant e21_cov_wraiths0_main
	(ai_place e21_cov_wraiths0_0)
	(ai_place e21_cov_wraiths0_1)
	
	; Reserve them so that Marines don't climb in
	(sleep 2)
	(ai_vehicle_reserve (ai_vehicle_get e21_cov_wraiths0_0/wraith0) true)
	(ai_vehicle_reserve (ai_vehicle_get e21_cov_wraiths0_1/wraith0) true)

	; Wait for one of the other Wraiths to be destroyed
	(sleep_until 
		(or
			(<= (ai_living_count e21_cov_wraiths0) 1)
			(volume_test_objects tv_e21_cov_wraith0_2_unsafe (players))
		)
		15
	)
	
	; Spawning conditions
;*	(sleep_until
		(or
			; Phantom 0 retreating
			g_e21_cov_phantom0_retreating
			
			; Player in spawn zone
			(volume_test_objects tv_e21_cov_wraith0_2_unsafe (players))
		)
	)
	*;
		
	; Spawn the appropriate number of additional Wraiths
	(if (not (volume_test_objects tv_e21_cov_wraith0_2_unsafe (players))) 
		(ai_place e21_cov_wraiths0_2 (pin (- 2 (ai_living_count e21_cov_wraiths0)) 0 1))
	)

	; Reserve them so that Marines don't climb in
	(sleep 2)
	(ai_vehicle_reserve (ai_vehicle_get e21_cov_wraiths0_2/wraith0) true)
	
	; Wake the Phantom
	(wake e21_cov_phantom1_main)
)

(script dormant e21_cov_inf0_main
	(ai_place e21_cov_inf0)
)

(script dormant e21_mars_pelican1_main
	(sleep_until g_e21_cov_phantom1_retreating)
	(sleep 60)

	; Send in the cavalry
	(ai_place e21_mars_pelican1)
	(cs_run_command_script e21_mars_pelican1/pelican0 cs_e21_mars_pelican1_entry)
)

(script dormant e21_mars_pelican0_main
	(sleep_until g_e21_cov_phantom1_retreating)

	; Send in the cavalry
	(ai_place e21_mars_pelican0/pelican0)
	(cs_run_command_script e21_mars_pelican0/pelican0 cs_e21_mars_pelican0_entry)
	
	; Load up the Scorpion
	(ai_place e21_mars_pelican0/scorpion0)
	(vehicle_load_magic (ai_vehicle_get e21_mars_pelican0/pelican0) "pelican_lc" (ai_vehicle_get_from_starting_location e21_mars_pelican0/scorpion0))

	; Wait for the player to enter the building, then depart (or never hang around to being with)
	(sleep_until (volume_test_objects tv_e22_begin_scarab_sequence (players)) 15)
	(cs_run_command_script e21_mars_pelican0/pelican0 cs_e21_mars_pelican0_exit)
)

(script dormant e21_mars_warthog0_main
	(ai_migrate e20_mars_warthog0 e21_mars_warthog0)
	(ai_migrate e20_mars_warthog1 e21_mars_warthog0)
)

(script dormant e21_mars_inf1_main
	(sleep_until g_e21_cov_phantom0_retreating 15)
	(ai_place e21_mars_inf1)
	(ai_disregard (ai_actors e21_mars_inf1) true)
	
	; Wait until e22 starts, then go away
	(sleep_until g_e22_started)
	(cs_run_command_script e21_mars_inf1 cs_e21_mars_inf1_exit)
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
				(>= (ai_spawn_count e21_mars_inf0) 10)
				g_e22_started
			)
		)
	)
)

(script dormant e21_main_end_condition
	(sleep_until g_e21_cov_phantom1_retreating)
	(sleep_until
		(and
			(<= (ai_living_count e21_cov_ghosts0) 0)
			(<= (ai_living_count e21_cov_wraiths0) 0)
		)
		30
		one_minute
	)
	
	; Wake the next encounter
	(wake e22_main)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e21_main
	(sleep_until (volume_test_objects tv_e21_main_begin (players)) 15)
	(set g_e21_started true)
	(print "e21_main")
	(data_mine_set_mission_segment "e21_hospital_seige")
	(game_save)
	;(garbage_collect_now)

	; Wake subsequent scripts
	; Wakes e22_main via e21_main_end_condition
	(wake e21_main_end_condition)

	; Wake control scripts
	(wake e21_mars_warthog0_main)
;	(wake e21_mars_inf0_main)
;	(wake e21_mars_inf1_main)
	(wake e21_mars_pelican0_main)
	(wake e21_mars_pelican1_main)
	(wake e21_cov_inf0_main)
	(wake e21_cov_wraiths0_main)
;	(wake e21_cov_phantom0_main)
;	(wake e21_cov_phantom1_main) Called by e21_cov_wraiths0_main
	(wake e21_dialog)
	
	; Shut down
	(sleep_until g_e22_started)
	(sleep_forever e21_mars_warthog0_main)
	(sleep_forever e21_mars_inf0_main)
	(sleep_forever e21_mars_inf1_main)
	(sleep_forever e21_cov_creep0_main)
	(sleep_forever e21_cov_wraiths0_main)
;	(sleep_forever e21_cov_phantom0_main)
	(sleep_forever e21_cov_phantom1_main)
	(sleep_forever e21_dialog)
	
	; Condemn
	(ai_disposable e21_cov true)
	(ai_disposable e21_cov_phantom0 false)
	(ai_disposable e21_cov_phantom1 false)
)

(script static void test_hospital_seige
	(switch_bsp 1)
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
	(ai_migrate e19_cov_ghosts0 e20_cov_ghosts0)
	(ai_place e20_cov_ghosts0)
)

(script dormant e20_mars_warthog1_main
	(ai_place e20_mars_warthog1)
	(if (> (ai_living_count e20_mars_warthog0) 1)
		; Trim the fat
		(ai_erase e20_mars_warthog1/spare)
	)
)

(script dormant e20_mars_warthog0_main
	; Migrate over previous squads
	(ai_migrate e19_mars_warthog0 e20_mars_warthog0)
	(wake e20_mars_warthog1_main)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e20_main
	(sleep_until (volume_test_objects tv_e20_main_begin (players)) 15)
	(set g_e20_started true)
	(print "e20_main")
	(data_mine_set_mission_segment "e20_road_skirmish")
	(game_save)
	;(garbage_collect_now)

	; Music
	(wake music_03b_03_start)

	; Wake control scripts
	(wake e20_mars_warthog0_main)
	(wake e20_cov_ghosts0_main)
	
	; Shut down
	(sleep_until g_e21_started)

	; Condemn
	(ai_disposable e20_cov true)
)

(script static void test_road_skirmishes
	(switch_bsp 1)
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

(script command_script cs_e19_cov_ghosts0_1_entry1
	(cs_vehicle_boost true)
	(cs_go_to e19_cov_ghosts0_1/p2)
	(cs_go_to e19_cov_ghosts0_1/p3)
	(sleep 60)
)

(script command_script cs_e19_cov_ghosts0_1_entry0
	(cs_vehicle_boost true)
	(cs_go_to e19_cov_ghosts0_1/p0)
	(cs_go_to e19_cov_ghosts0_1/p1)
	(sleep 60)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e19_cov_ghosts0_main
	; Migrate Ghosts over
	(ai_migrate e18_cov_ghosts0 e19_cov_ghosts0_0)

	; Wait for it...
	(sleep_until (volume_test_objects tv_e19_player_advanced (players)) 15)
	(ai_place e19_cov_ghosts0_0)
	
	; Respawner
	(sleep_until
		(begin
			(if (<= (ai_living_count e19_cov_ghosts0) 0)
				; We need to respawn
				(begin
					(sleep 300)
					(sleep_until (not (volume_test_objects tv_e19_cov_ghosts0_1_unsafe (players))))
					(ai_place e19_cov_ghosts0_1)
				)
			)
		
			; Spawn limit
			(>= (ai_spawn_count e19_cov_ghosts0) 6)
		)
	)
)

(script dormant e19_cov_wraiths0_main
	(ai_place e19_cov_wraiths0_0)
)

(script dormant e19_cov_inf0_main
	(ai_place e19_cov_inf0)
)

(script dormant e19_mars_inf0_main
	; Wait until the previous Covenant are dead or the player has advanced
	; Migrate squads into this one
	(ai_migrate e18_mars_inf0 e19_mars_warthog0)
	(ai_migrate e18_mars_warthog0 e19_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e19_main
	(sleep_until 
		(or
			(volume_test_objects tv_e19_main_begin0 (players)) 
			(volume_test_objects tv_e19_main_begin1 (players)) 
		)
		15
	)
	(set g_e19_started true)
	(print "e19_main")
	(data_mine_set_mission_segment "e19_park")
	(game_save)
	;(garbage_collect_now)

	; Manual visibility, rah.
	(object_create_anew e19_tree0)
	(object_create_anew e19_tree1)
	
	; Wake control scripts
	(wake e19_mars_inf0_main)
	(wake e19_cov_inf0_main)
	(wake e19_cov_wraiths0_main)
	(wake e19_cov_ghosts0_main)
	
	; Shut down
	(sleep_until g_e20_started)
	(sleep_forever e19_mars_inf0_main)
	(sleep_forever e19_cov_inf0_main)
	(sleep_forever e19_cov_wraiths0_main)
	(sleep_forever e19_cov_ghosts0_main)
	
	; Condemn
	(ai_disposable e19_cov true)
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
	e18_cov_ghosts0 - Ghosts guarding the exit
		(init) - Guarding the exit, retreating when injured

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e18_started false)			; Encounter has been activated?
(global short g_e18_orbit_count 0)
(global short g_e18_cov_inf2_spawn_max 5)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e18_mars_warthog0_orbit
	(sleep_until
		(begin
			(cs_go_by e18_mars_warthog0_orbit/p4 e18_mars_warthog0_orbit/p5)
			(cs_go_by e18_mars_warthog0_orbit/p5 e18_mars_warthog0_orbit/p6)
			(cs_go_by e18_mars_warthog0_orbit/p6 e18_mars_warthog0_orbit/p0)
			(cs_go_by e18_mars_warthog0_orbit/p0 e18_mars_warthog0_orbit/p1)
			(cs_go_by e18_mars_warthog0_orbit/p1 e18_mars_warthog0_orbit/p2)
			(cs_go_by e18_mars_warthog0_orbit/p2 e18_mars_warthog0_orbit/p3)
			(cs_go_by e18_mars_warthog0_orbit/p3 e18_mars_warthog0_orbit/p4)
			
			; Is the player in the Warthog?
			(if 
				(or
					(vehicle_test_seat_list (ai_vehicle_get ai_current_actor) "warthog_g" (players))
					(vehicle_test_seat_list (ai_vehicle_get ai_current_actor) "warthog_p" (players))
				)
				; Increment the loops
				(set g_e18_orbit_count (+ g_e18_orbit_count 1))
			)
			
			; Loop until the infantry is pretty much dead
			(or
				g_e19_started
				(<= (ai_living_count e18_cov_inf1_1) 0)
				(>= g_e18_orbit_count 2)
				
			)
		)
		1
	)
)

(global boolean g_e18_mars_warthog0_spoke false)
(script command_script cs_e18_mars_warthog0_approach0
	(cs_approach_player 5.0 50.0 50.0)
	
	; Play line
	(if (not g_e18_mars_warthog0_spoke)
		(begin
			(ai_play_line_at_player ai_current_actor 8000) (print "could use a gunner, sir!")
			(set g_e18_mars_warthog0_spoke true)
		)
	)

	; Wait for the player to climb in, or move away
	(sleep_until 
		(or
			(> (objects_distance_to_object (ai_actors e18_mars_warthog0/warthog0) (player0)) 7.0)
			(unit_in_vehicle (unit (player0)))
		)
		15
		600
	)
)

(script command_script cs_e18_mars_warthog0_approach1
	(cs_approach_player 5.0 50.0 50.0)
	
	; Play line
	(if (not g_e18_mars_warthog0_spoke)
		(begin
			(ai_play_line_at_player ai_current_actor 8000) (print "could use a gunner, sir!")
			(set g_e18_mars_warthog0_spoke true)
		)
	)

	; Wait for the player to climb in, or move away
	(sleep_until 
		(or
			(> (objects_distance_to_object (ai_actors e18_mars_warthog0/warthog0) (player1)) 7.0)
			(unit_in_vehicle (unit (player1)))
		)
		15
		600
	)
)

(script command_script cs_e18_mars_warthog0_abort
	(sleep 1)
)

(script command_script cs_e18_cov_inf0_sniper0
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_dangerous)
	(cs_aim_object true (ai_vehicle_get e18_mars_warthog0/warthog0))
	(sleep_forever)
)

(script command_script cs_e18_cov_inf2_1_entry0
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_go_to e18_cov_inf2_entry/p0)
	(cs_go_to e18_cov_inf2_entry/p1)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Scripts ---------------------------------------------------------------

(script dormant e18_scarab_main
	; Create the Scarab, set the PVS, and teleport it to the location
	(object_create_anew scarab)
	(object_teleport scarab e18_scarab_start)
	(pvs_set_object scarab)

	; Do the idle loop
	(sleep_until
		(begin
			(device_set_position_track scarab park_idle 0)
			(device_animate_position scarab 1.0 (/ 119.0 30.0) 0 0 true)
			(sleep_until (>= (device_get_position scarab) 1.0) 1)

			; Loop until the player has moved up
			(volume_test_objects tv_e19_scarab_withdraws (players))
		)
		1
		30_seconds
	)
	
	; Send him out
	(device_set_position_track scarab park_exit 0)
	(device_animate_position scarab 1.0 (/ 831.0 30.0) 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)

	; Deadreck
	(scarab_walk_front_var0)
	(scarab_walk_front_turn_22_left)
	(scarab_walk_front_turn_22_left)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_to_idle)
	(scarab_idle_turn_45_right)
	(scarab_idle_turn_45_right)
	(scarab_idle_to_walk_front)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_to_idle)
	
	; Bibi
	(object_destroy scarab)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e18_cov_ghosts0_main
	(sleep_until
		(or
			(<= (ai_living_count e18_cov_inf1_1) 0)
			(volume_test_objects tv_e19_main_begin1 (players))
		)
	)
	(if (not (volume_test_objects tv_e19_main_begin1 (players))) (ai_place e18_cov_ghosts0))
)

(script static void e18_cov_inf2_spawn
	; Is the player in the second half?
	(if (volume_test_objects tv_e18_second_half (players))
		; He is. If he's clear...
		(if (not (volume_test_objects tv_e18_cov_inf2_1_unsafe1 (players)))
			(ai_place e18_cov_inf2_1/sniper1)
		)
		
		; He is not. If he's clear...
		(if (not (volume_test_objects tv_e18_cov_inf2_1_unsafe0 (players)))
			(ai_place e18_cov_inf2_1/sniper0)
		)
	)
)

(script dormant e18_cov_inf2_main
	(ai_place e18_cov_inf2_0)
	
	; Set the spawn limits!
	(if (difficulty_heroic) (set g_e18_cov_inf2_spawn_max 8))
	(if (difficulty_legendary) (set g_e18_cov_inf2_spawn_max 12))
	
	; Spawn more snipers
	(sleep_until
		(begin
			; Do we need to spawn?
			(if 
				(or
					; There are none left
					(< (ai_living_count e18_cov_inf2) 1)

					; There are less than two, and the others are depleted
					(and
						(< (ai_living_count e18_cov_inf1) 5)
						(< (ai_living_count e18_cov_inf2) 2)
					)
					
					; It's legendary, there are less than 3, and the others are depleted
					(and
						(difficulty_legendary)
						(< (ai_living_count e18_cov_inf1) 4)
						(< (ai_living_count e18_cov_inf2) 2)
					)
				)
				
				; Spawn one
				(begin
					(e18_cov_inf2_spawn)

					; Random pause, to throw off spawn campers
					(sleep (random_range 60 300))
				)
			)
		
			; Encounter over, or spawn limit reached
			(>= (ai_spawn_count e18_cov_inf2) g_e18_cov_inf2_spawn_max)
		)
	)
)

(script dormant e18_cov_inf1_main
	(ai_place e18_cov_inf1)
)

(script dormant e18_cov_inf0_main
	(ai_place e18_cov_inf0)
)

(script dormant e18_mars_warthog0_main
	(ai_place e18_mars_warthog0)
	
	; The Warthog is running the orbit, and will do so until e18_cov_inf1 is dead
	; While it is running the orbit, if a player is close and not in a vehicle,
	; then stop and try to load him
	(sleep_until
		(begin		
			; If the player is nearby...
			(if
				; Player 0 is nearby and not in a vehicle
				(and
					(< (objects_distance_to_object (ai_actors e18_mars_warthog0/warthog0) (player0)) 6.0)
					(not (unit_in_vehicle (unit (player0))))
				)
				
				; He is, stack the command script
				(begin
					(cs_stack_command_script e18_mars_warthog0/warthog0 cs_e18_mars_warthog0_approach0)
					(sleep_until (not (unit_in_vehicle (ai_get_unit e18_mars_warthog0/warthog0))) 30 900) ; Pause to prevent multiple invocations
				)
					
				; Otherwise, is player 1 is nearby and not in a vehicle
				(if
					(and
						(game_is_cooperative)
						(< (objects_distance_to_object (ai_actors e18_mars_warthog0/warthog0) (player1)) 6.0)
						(not (unit_in_vehicle (unit (player1))))
					)				

					; He is, stack the command script
					(begin
						(cs_stack_command_script e18_mars_warthog0/warthog0 cs_e18_mars_warthog0_approach1)
						(sleep_until (not (unit_in_vehicle (ai_get_unit e18_mars_warthog0/warthog0))) 30 900) ; Pause to prevent multiple invocations
					)
				)
			)
			
			; Loop until we're not in a vehicle (e19 will shut us down)
			(not (unit_in_vehicle (ai_get_unit e18_mars_warthog0/warthog0)))
		)
		15
	)
	
	; End the command script
	(print "omg?")
	(cs_run_command_script e18_mars_warthog0/warthog0 cs_e18_mars_warthog0_abort)
)

(script dormant e18_mars_inf0_main
	; Migrate squads into this one
	(ai_migrate e17_mars_inf0 e18_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e18_key
	(if (not (difficulty_legendary)) (sleep_forever))
	(object_create key)
	(sleep_until 
		(or
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	)
	(ice_cream_flavor_stock 9) ; Mmmm, pineapple
)

(script dormant e18_main
	(sleep_until (volume_test_objects tv_e18_main_begin (players)) 15)
	(set g_e18_started true)
	(print "e18_main")
	(data_mine_set_mission_segment "e18_park")
	(game_save)

	; Kill, they shriek, kill!
	(kill_volume_enable kill_e18_0)
	
	; Manual visibility, rah.
	(object_destroy e19_tree0)
	(object_destroy e19_tree1)
	
	; Chapter title
	(wake chapter_title1)
		
	; Objectives
	(wake objective1_clear)
	(wake objective2_set)

	; Wake subsequent scripts
	(wake e19_main)
	(wake e20_main)
	(wake e21_main)

	; Wake control scripts
	(wake e18_mars_inf0_main)
	(wake e18_mars_warthog0_main)
	(wake e18_cov_inf0_main)
	(wake e18_cov_inf1_main)
	(wake e18_cov_inf2_main)
	(wake e18_cov_ghosts0_main)
	(wake e18_scarab_main)
	(wake e18_key)
	
	; Shut down
	(sleep_until g_e19_started)
	(sleep_forever e18_mars_inf0_main)
	(sleep_forever e18_mars_warthog0_main)
	(sleep_forever e18_cov_inf0_main)
	(sleep_forever e18_cov_inf1_main)
	(sleep_forever e18_cov_inf2_main)
	(sleep_forever e18_cov_ghosts0_main)

	; Condemn
	(ai_disposable e18_cov true)
)

(script static void test_park
	(switch_bsp 1)
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
		(follow) - Once the player crests the second wall, follow him

Covenant
	e17_cov_inf0 - Elites in the water who try to flush the player out
		_0 - Initial group
		_1 - Reinforcements from behind the second wall
			(init) - On the semi near the first wall
			(section0) - Watching section 0
			(section1) - Watching section 1
			(section2) - Watching section 2
			(section3) - Watching section 3
	e17_cov_inf1 - Elites and Jackal spotters on the sides
		_0 - Initial group on the first wall
		_1 - Reinforcements behind the first door
			(init) - Watching from the first wall
			(section0) - Watching section 0
			(section1) - Watching section 1
			(section2) - Watching section 2
			(section3) - Watching section 3
	e17_cov_inf2 - Elites and Jackals on the end wall
		(init)

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e17_started false)		; Encounter has been activated?
(global boolean g_e17_mars_warthog0_arrived false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e17_mars_inf0_drive
	(cs_enable_pathfinding_failsafe true)
	(object_cannot_die (ai_get_object e17_mars_inf0/warthog0) true)
	(object_cannot_die (ai_get_object e17_mars_inf0/passenger0) true)
	(cs_go_to e17_mars_inf0_entry/p0)		

	; Honk at the player
	(sleep_until 
		(or
			(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 13)
			(volume_test_objects tv_e17_near_first_wall (players))
		)
		15
		one_minute
	)
	(sound_looping_start "sound\vehicles\warthog\warthog_horn\warthog_horn" (ai_vehicle_get ai_current_actor) 1.5)
	(sleep 5)
	(sound_looping_stop "sound\vehicles\warthog\warthog_horn\warthog_horn")
	(sleep 5)
	(sound_looping_start "sound\vehicles\warthog\warthog_horn\warthog_horn" (ai_vehicle_get ai_current_actor) 1.5)
	(sleep 15)
	(sound_looping_stop "sound\vehicles\warthog\warthog_horn\warthog_horn")
	
	; Wait for the player
	(sleep_until 
		(or
			(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 10)
			(<= (ai_strength ai_current_actor) 0.5)
			(<= (ai_strength ai_current_squad) 0.75)
			(volume_test_objects tv_e17_first_wall_approach (players))
		)		
	 	15
	 	600
	 )
	 
	; Continue
	(cs_go_by e17_mars_inf0_entry/p0_1 e17_mars_inf0_entry/p1)
	(cs_go_to e17_mars_inf0_entry/p1)
	(set g_e17_mars_warthog0_arrived true)
	(sleep 20)
	(object_cannot_die (ai_get_object e17_mars_inf0/warthog0) false)
	(object_cannot_die (ai_get_object e17_mars_inf0/passenger0) false)
	(ai_vehicle_exit e17_mars_inf0/warthog0)
	(ai_vehicle_exit e17_mars_inf0/passenger0)
)

(script command_script cs_e17_shotgun_scene
	; Hail the chief
	(print "marine: hey, sir!")
	
	; Approach
	(cs_approach_player 1.0 10.0 15.0)
	
	; Wait until we've arrived
	(sleep (ai_play_line_at_player ai_current_actor 0640)) ; "It's tight quarters, use this"

	; Sleep until we've been given a different weapon, or the player is gone
	(sleep_until
		(or
			(not (unit_has_weapon (ai_get_unit ai_current_actor) "objects\weapons\rifle\shotgun\shotgun.weapon"))
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 5)
		)
		15
		one_minute
	)
)

(script command_script cs_e17_cov_inf0_0_turret0
	(cs_enable_pathfinding_failsafe true)
	(cs_deploy_turret e17_turrets/p0)
)

(script command_script cs_e17_cov_ghost0_entry0
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_vehicle_boost true)
	(cs_go_to e17_cov_ghost0_entry/p0)
	(sleep 30)
	(cs_vehicle_boost false)
	(cs_go_to e17_cov_ghost0_entry/p0 0.1)
	(cs_face true e17_cov_ghost0_entry/p1)
	(sleep 60)
	(cs_vehicle_boost true)
	(cs_face false e17_cov_ghost0_entry/p1)
	(cs_go_to e17_cov_ghost0_entry/p1)
	(sleep 30)
	(cs_vehicle_boost false)
)

(script command_script cs_e17_mars_selective_migrate
	; If you're in a vehicle and not too far away...
	(if
		(and
			(unit_in_vehicle (ai_get_unit ai_current_actor))
			(volume_test_object tv_e17_migration_area (ai_get_object ai_current_actor))
			(<= (ai_living_count e17_mars_inf0) 2)
		)
		; Migrate over
		(ai_migrate ai_current_actor e17_mars_inf0)
	)
)

(script command_script cs_e17_cov_inf0_2_ambush
	(cs_abort_on_combat_status ai_combat_status_dangerous)
	(cs_abort_on_damage true)
	(cs_crouch true)
	(cs_enable_looking true)	
	(sleep_until
		(or
			(volume_test_object tv_e17_section3 (ai_get_object ai_current_actor))
			(< (ai_strength ai_current_squad) 1.0)
		)
		10
	)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e17_door0_open
	(>= (device_get_position e17_door0) 0.5)
)

(script static boolean e17_door1_open
	(>= (device_get_position e17_door1) 0.5)
)

(script static boolean e17_mars_warthog0_can_wait
	(or
		g_e17_mars_warthog0_arrived
		(volume_test_objects tv_e17_on_first_wall (players))
	)
)


;- Event Controls --------------------------------------------------------------

(script dormant e17_doors_main
	(device_set_position e17_door1 1.0)

	; Wait for the player to cross certain trigger volumes, then open the doors
	(sleep_until (volume_test_objects tv_e17_section2 (players)) 15)
	(device_set_position e17_door0 1.0)
)

(script dormant e17_shotgun_scene
	(sleep_until 
		(ai_scene e17_shotgun_scene cs_e17_shotgun_scene e17_mars_inf0/passenger0)
		5
		two_minutes
	)
)

(script dormant e17_dialog
	(sleep_until (volume_test_objects tv_e17_on_first_wall (players)) 15)
	(sleep (ai_play_line_on_object none 0650)) ; "Your armor is airtight"
	(sleep 20)
	(sleep_until (volume_test_objects tv_e17_section0 (players)) 15)
	(sleep_until (game_safe_to_save) 30 one_minute)
	(ai_play_line_on_object none 0660) ; "You can crouch under the water"
)


;- Squad Controls --------------------------------------------------------------

(script dormant e17_cov_inf2_main
	(sleep_until (volume_test_objects tv_e17_near_first_wall (players)) 15)
	(ai_place e17_cov_inf2_0)
	(sleep_until (volume_test_objects tv_e17_cov_inf2_1_begin (players)) 15)
	(ai_place e17_cov_inf2_1)
	(sleep_until (volume_test_objects tv_e17_section2 (players)) 15)
	(ai_place e17_cov_inf2_2)
	(sleep_until (volume_test_objects tv_e17_section3 (players)) 15)
	(ai_place e17_cov_inf2_3 (pin (- 3 (ai_living_count e17_cov_inf2)) 0 1))
)

(script dormant e17_cov_inf1_main
	(ai_place e17_cov_inf1_0)
)

(script dormant e17_cov_inf0_aux
	(sleep_until (volume_test_objects tv_e17_cov_inf0_2_init (players)) 15)
	(ai_place e17_cov_inf0_2)
	(sleep_until (volume_test_objects tv_e17_near_second_wall (players)) 15)
	(if (difficulty_legendary) (ai_place e17_cov_inf0_3))
)

(script dormant e17_cov_inf0_main
	; Try to slip in a save point
	(sleep_until (volume_test_objects tv_e17_near_first_wall (players)) 15)
	(wake e17_cov_inf0_aux)
	(game_save)
	
	; Music
	(wake music_03b_02_stop)
	
	; Wait for the player to commit
	(sleep_until 
		(volume_test_objects tv_e17_on_first_wall (players)) 
		15
	)
	(ai_place e17_cov_inf0_0)
	
	; Is the player in section 1? If necessary, spawn reins
	(sleep_until (volume_test_objects tv_e17_section1 (players)) 15)
	(if (<= (ai_living_count e17_cov_inf0) 4)
		(ai_place e17_cov_inf0_1)
	)

	; Is the player in section 1? If necessary, spawn reins
	(sleep_until (volume_test_objects tv_e17_section2 (players)) 15)

	; But first, a save point
	(game_save)
	(sleep 30)

	; Reins
	(if (<= (ai_living_count e17_cov_inf0) 4)
		(ai_place e17_cov_inf0_1)
	)

	; Is the player in section 1? If necessary, spawn reins
	(sleep_until (volume_test_objects tv_e17_section3 (players)) 15)
	(if (<= (ai_living_count e17_cov_inf0) 4)
		(ai_place e17_cov_inf0_1)
	)
)

(script dormant e17_mars_inf0_main
	; Migrate over any spares
	(cs_run_command_script e16_mars_inf0 cs_e17_mars_selective_migrate)
	(sleep 15)
	
	; Place the squad and send them in
	(ai_place e17_mars_inf0)
	(ai_vehicle_reserve (ai_vehicle_get e17_mars_inf0/warthog0) true)
	
	; Make the old ones disposable
	(ai_disposable e16_mars true)
	
	; Start the shotgun scene
	(wake e17_shotgun_scene)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e17_main
	(sleep_until (volume_test_objects tv_e17_main_begin (players)) 15)
	(set g_e17_started true)
	(print "e17_main")
	(data_mine_set_mission_segment "e17_flooded_tunnel")
	(game_save)
	;(garbage_collect_now)
	
	; Objectives
	(wake objective0_clear)
	(wake objective1_set)

	; Wake control scripts
	(wake e17_mars_inf0_main)
	(wake e17_cov_inf0_main)
	(wake e17_cov_inf1_main)
	(wake e17_cov_inf2_main)
	(wake e17_doors_main)
;	(wake e17_dialog)
	
	; Shut down
	(sleep_until g_e18_started)
	(sleep_forever e17_mars_inf0_main)
	(sleep_forever e17_cov_inf0_main)
	(sleep_forever e17_cov_inf1_main)
	(sleep_forever e17_cov_inf2_main)
	(sleep_forever e17_doors_main)
	(sleep_forever e17_dialog)

	; Condemn
	(ai_disposable e17_cov true)
)

(script static void test_flooded_tunnel
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
	e16_cov_wraiths1 - Wraiths who emerge to defend the toll booths (Wave 3)
		(init) - Engaging the player
	e16_cov_ghosts0 - Ghosts advancing up to engage the player
		_0 - Four initially placed Ghosts arriving in two waves
		_1 - Reinforcements from the tunnel
			(init) - Engaging the player
			(retreat) - Retreating if e16_cov_wraiths0_1 is dead
	e16_cov_ghosts1 - Ghosts defending the toll booths (Wave 1)
		(engage) - Sallying forth to engage
		(retreat) - Behaving more defensively if when battered
	e16_cov_banshees0 - Banshees harrassing the player overhead
		_0 - Banshees who appear after the Phantoms depart
		_1 - Reinforcements (Wave 0, 2)
			(init) - Harrassing the player from above

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e16_started false)		; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e16_cov_ghosts0_advance1
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_enable_targeting true)
	(cs_go_to e16_cov_ghosts0_advance/start)
	(cs_go_to e16_cov_ghosts0_advance/p0)
	(cs_go_to e16_cov_ghosts0_advance/p5)
	(cs_go_to e16_cov_ghosts0_advance/p6)
	(cs_go_to e16_cov_ghosts0_advance/p7)
	(cs_go_to e16_cov_ghosts0_advance/p8)
)

(script command_script cs_e16_cov_ghosts0_advance0
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_enable_targeting true)
	(cs_go_to e16_cov_ghosts0_advance/start)
	(cs_go_to e16_cov_ghosts0_advance/p0)
	(cs_go_to e16_cov_ghosts0_advance/p1)
	(cs_go_to e16_cov_ghosts0_advance/p2)
	(cs_go_to e16_cov_ghosts0_advance/p3)
	(cs_go_to e16_cov_ghosts0_advance/p4)
)

(script command_script cs_e16_cov_banshee_boost0
	(cs_vehicle_boost true)
	(cs_fly_by e16_cov_banshees0/p0)
	(cs_fly_by e16_cov_banshees0/p1)
	(sleep (random_range 30 60))	
)

(script command_script cs_e16_cov_banshee_boost1
	(cs_vehicle_boost true)
	(cs_fly_by e16_cov_banshees0/p2)
	(cs_fly_by e16_cov_banshees0/p3)
	(sleep (random_range 30 60))	
)

(script command_script cs_e16_cov_inf0_last_stand
;	(cs_abort_on_combat_status ai_combat_status_dangerous)
	(cs_abort_on_damage true)
	(cs_enable_targeting true)

	; Face the player
	(cs_face_player true)
	(cs_crouch true)
	
	; Wait until...
	(sleep_until
		(or
			; Player is close
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 12)

			; We're damaged
			(<= (ai_strength ai_current_actor) 0.9)
			(<= (ai_strength ai_current_squad) 0.5)
		)
	)
)

(script command_script cs_e16_cov_phantom0_entry
	(cs_vehicle_boost true)
	(sleep 135)
)

(script command_script cs_e16_cov_phantom0_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to_and_face e16_cov_phantom0/p0 e16_cov_phantom0/p1 1.0)
	(cs_fly_by e16_cov_phantom0/p1)
	(cs_vehicle_boost true)
	(cs_fly_by e16_cov_phantom0/p2)
	(ai_erase ai_current_squad)
)

(script command_script cs_e16_cov_wraiths1_entry
	(cs_enable_moving true)
	(cs_vehicle_boost true)
	(sleep 180)
)

(script command_script cs_e16_cov_ghosts1_entry
	(cs_enable_moving true)
	(cs_vehicle_boost true)
	(sleep 150)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e16_cov_phantom0_main
	(sleep_until (<= (ai_living_count e16_cov_wraiths1) 0))
	(ai_place e16_cov_phantom0)
	
	; Wait for it
	(sleep_until 
		(or
			(<= (object_get_health (ai_vehicle_get e16_cov_phantom0/phantom0)) 0.05) 
			(>= (object_model_targets_destroyed (ai_vehicle_get e16_cov_phantom0/phantom0) "target_front") 2) 			
		)
		30 
	)
	
	; Send the second one packing
	(cs_run_command_script e16_cov_phantom0/phantom0 cs_e16_cov_phantom0_exit)
)

(script dormant e16_cov_wraiths1_main
	(sleep_until 
		(or
			(volume_test_objects tv_e16_toll_plaza (players))
			(<= (+ (ai_living_count e16_cov_ghosts1) (ai_living_count e16_cov_banshees0)) 1)
		)
	)
	(ai_place e16_cov_wraiths1)
	
	; Send in the Phantom
;	(wake e16_cov_phantom0_main)
)

(script dormant e16_cov_ghosts1_main
	(sleep_until 
		(or
			(volume_test_objects tv_e16_toll_plaza (players))
			(<= (ai_living_count e16_cov_banshees0) 1)
		)
	)
	(ai_place e16_cov_ghosts1 (- 3 (ai_living_count e16_cov_ghosts0)))
)

(script dormant e16_cov_banshees0_main
	; Migrate the banshees down the bridge
	(ai_migrate e15_cov_banshees0 e16_cov_banshees0_0)
	
	; Wait for the player to advance
	(sleep_until (volume_test_objects tv_e16_bridge_end (players)) 15)
	
	; Send in Wave 0
	(ai_place e16_cov_banshees0_1 (- 3 (ai_living_count e16_cov_banshees0)))
	
	; Dialogue
	(sleep 150)
	(ai_play_line_on_object none 0620) ; "That's quite the welcoming party"
	
	; Music
	(wake music_03b_01_start_alt)

	; Wake Wave 1 (ghosts)
	(game_save)
	(wake e16_cov_ghosts1_main)
	
	; Wait until the Ghosts have spawned, then died
	(sleep_until 
		(and
			(> (ai_spawn_count e16_cov_ghosts1) 0)
			(<= (+ (ai_living_count e16_cov_ghosts1) (ai_living_count e16_cov_banshees0)) 1)
		)
	)
	
	; Send in Wave 1
	(game_save)
	(ai_place e16_cov_banshees0_1)
	
	; Wake final waves
	(wake e16_cov_wraiths1_main)
)

(script dormant e16_cov_ghosts0_main
	(ai_place e16_cov_ghosts0_0)
	
	; Respawner
	(sleep_until
		(begin
			; Respawn if necessary
			(if 
				(or
					(and
						(<= (ai_living_count e16_cov_wraiths0) 0)
						(< (ai_living_count e16_cov_ghosts0) 4)
					)
					(< (ai_living_count e16_cov_ghosts0) 3)
				)
				(begin
					(ai_place e16_cov_ghosts0_1 1)					
				)
			)
			
			; Loop until
			(or
				(volume_test_objects tv_e16_bridge_end (players))
				(>= (ai_spawn_count e16_cov_ghosts0) 10)
			)
		)
		90
	)
	
	; Put in a save
	(game_save)
)

(script dormant e16_cov_wraiths0_main
	; Nasty, incestuous relationship between encounters :(
	(sleep_until (> (ai_spawn_count e16_cov_wraiths0) 0 ))

	; Sleep until the Wraiths are dead
	(sleep_until 
		(or
			(volume_test_objects tv_e16_toll_plaza (players))
			(<= (ai_living_count e16_cov_wraiths0_0) 0)
		)
	)
	
	; Try a save
	(game_save)
)

(script dormant e16_cov_inf0_main
	(sleep_until (volume_test_objects tv_e16_tunnel (players)) 15)

	; Try a game save
	(game_save)
	(sleep 15)
	
	; Music
	(wake music_03b_01_stop)
	(wake music_03b_02_start)
	
	; Get on with it!
;	(ai_place e16_cov_inf0_0 (pin (- 5 (ai_living_count e16_cov)) 1 5))

	; More meat for the grinder
	(sleep_until (volume_test_objects tv_e16_cov_inf0_1_begin (players)) 15)
	(ai_place e16_cov_inf0_1 (pin (- 9 (ai_living_count e16_cov_inf0)) 0 2))
	(sleep_until (volume_test_objects tv_e16_cov_inf0_2_begin (players)) 15)
	(ai_place e16_cov_inf0_2 (pin (- 9 (ai_living_count e16_cov_inf0)) 0 1))
)

(script dormant e16_mars_inf0_main
	(ai_migrate e15_mars_inf0 e16_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e16_main
	(sleep_until (volume_test_objects tv_e16_main_begin (players)) 15)
	(set g_e16_started true)
	(print "e16_main")
	(data_mine_set_mission_segment "e16_bridge_descent")
	(game_save)
	;(garbage_collect_now)

	; Wake control scripts
	(wake e16_mars_inf0_main)
	(wake e16_cov_inf0_main)
	(wake e16_cov_wraiths0_main)
	(wake e16_cov_ghosts0_main)
;	(wake e16_cov_wraiths1_main)
;	(wake e16_cov_ghosts1_main)
	(wake e16_cov_banshees0_main)
	
	; Shut down
	(sleep_until g_e17_started)
	(sleep_forever e16_mars_inf0_main)
	(sleep_forever e16_cov_inf0_main)
	(sleep_forever e16_cov_wraiths0_main)
	(sleep_forever e16_cov_ghosts0_main)
	(sleep_forever e16_cov_wraiths1_main)
	(sleep_forever e16_cov_ghosts1_main)
	(sleep_forever e16_cov_banshees0_main)
	
	; Condemn
	(ai_disposable e16_cov true)

	; Clean up
	(sleep_until (= (structure_bsp_index) 1))
	(ai_erase e16_mars)
	(ai_erase e16_cov)
)

(script static void test_bridge_descent
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

(script command_script cs_e15_cov_phantom0_1_entry
	(cs_vehicle_boost true)
	(cs_fly_by e15_cov_phantom0_1_entry/p0)
	(cs_vehicle_boost false)
	(cs_fly_to e15_cov_phantom0_1_entry/p2)
)

(script command_script cs_e15_cov_phantom0_1_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; If the Wraith is still alive...
	(if (> (ai_living_count e16_cov_wraiths0_0/wraith1) 0)
		(begin
;			(cs_fly_to_and_face e15_cov_phantom0_1_entry/p3 e15_cov_phantom0_1_entry/p4)
			(cs_fly_by e15_cov_phantom0_1_entry/p4)
		
			(cs_face_player true)
			(cs_fly_to e15_cov_phantom0_1_entry/p5 1.0)
			(cs_fly_to e15_cov_phantom0_1_entry/p6 0.5)
	
			; If the player isn't in the way...
			(if (not (volume_test_objects tv_e15_phantom_drop_zone1 (players)))
			; Drop the Wraith
				(begin
					(sleep 75)
					(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_lc")
					(sleep 20)
				)
			)
			
			; Book
			(cs_face_player false)
			(cs_fly_by e15_cov_phantom0_1_entry/p5 1.0)
			(cs_fly_to_and_face e15_cov_phantom0_1_entry/p7_1 e15_cov_phantom0_1_entry/p8)
		)
		
		; It is not
		(cs_fly_by e15_cov_phantom0_1_entry/p7)
	)
	
	; Continue along
	(cs_fly_to e15_cov_phantom0_1_entry/p8)
	(cs_fly_to_and_face e15_cov_phantom0_1_entry/p8 e15_cov_phantom0_1_entry/p9 1.0)
	(cs_vehicle_boost true)
	(cs_fly_by e15_cov_phantom0_1_entry/p9)
	
	; Bi bi
	(ai_erase ai_current_squad)
)

(script command_script cs_e15_cov_phantom0_0_entry
	(cs_vehicle_boost true)
	(cs_fly_by e15_cov_phantom0_0_entry/p0)
	(cs_vehicle_boost false)
	(cs_fly_to e15_cov_phantom0_0_entry/p2)
)

(script command_script cs_e15_cov_phantom0_0_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)

	; If the Wraith is still alive...
	(if (> (ai_living_count e16_cov_wraiths0_0/wraith0) 0)
		(begin
			(cs_fly_by e15_cov_phantom0_0_entry/p4)
			(cs_fly_to e15_cov_phantom0_0_entry/p5 1.0)

			(cs_face_player true)
			(cs_fly_to e15_cov_phantom0_0_entry/p6 0.5)
			
			; If the player isn't in the way...
			(if (not (volume_test_objects tv_e15_phantom_drop_zone0 (players)))		
				; Drop the Wraith
				(begin
					(sleep 75)
					(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_lc")
					(sleep 20)
				)
			)
			
			; Book
			(cs_face_player false)
			(cs_fly_by e15_cov_phantom0_0_entry/p5 1.0)
			(cs_fly_to_and_face e15_cov_phantom0_0_entry/p7 e15_cov_phantom0_0_entry/p8 1.0)
		)
	)
	
	; Continue out
	(cs_fly_to_and_face e15_cov_phantom0_0_entry/p3 e15_cov_phantom0_0_entry/p8 0.5)
	(cs_fly_by e15_cov_phantom0_0_entry/p8)
	(cs_fly_to_and_face e15_cov_phantom0_0_entry/p8 e15_cov_phantom0_0_entry/p9 1.0)
	(cs_vehicle_boost true)
	(cs_fly_by e15_cov_phantom0_0_entry/p9)
	
	; Bi bi
	(ai_erase ai_current_squad)
)

(script command_script cs_e15_cov_phantom1_entry
	(cs_vehicle_boost true)
	(cs_fly_by e15_overflights/p0)
	(ai_erase ai_current_squad)
)

(script command_script cs_e15_cov_banshee0_0_entry
	(cs_vehicle_boost true)
	(cs_fly_by e15_overflights/p1)
)

(script command_script cs_e15_cov_banshee0_1_entry
	(cs_vehicle_boost true)
	(cs_fly_by e15_overflights/p2)
)

(script command_script cs_e15_mars_inf0_unload
	; If our number is two and I don't have a rocket launcher, get out
	(if 
		(and
			(> (ai_living_count e15_mars_inf0) 1)
			(not (unit_has_weapon (ai_get_unit ai_current_actor) "objects\weapons\support_high\rocket_launcher\rocket_launcher.weapon"))
		)
		(begin
			(sleep 30)
			(ai_vehicle_exit ai_current_actor)
		)
	)
)

(script command_script cs_e15_mars_inf0_init
	(cs_enable_targeting true)
	(cs_crouch true)
	
	; Wait until the player is close
	(sleep_until
		(or
			g_e16_started
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 8)
		)
		15
	)
)

(script command_script cs_e15_mars_inf0_abort
	(sleep 1)
)


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

(script dormant e15_cov_banshees0_main
	(ai_place e15_cov_banshees0)
	(cs_run_command_script e15_cov_banshees0/banshee0 cs_e15_cov_banshee0_0_entry)
	(cs_run_command_script e15_cov_banshees0/banshee1 cs_e15_cov_banshee0_1_entry)
;	(sleep 15)
;	(ai_magically_see_object e15_cov_banshees0 (player0))
)

(script dormant e15_cov_wraith1_main
	; I really hate this :(
	(sleep 2)
	(ai_place e16_cov_wraiths0_0/wraith1)
	(ai_braindead e16_cov_wraiths0_0/wraith1 true)
	(sleep 2)
	(vehicle_load_magic (ai_vehicle_get e15_cov_phantom0_1/phantom0) "phantom_lc" (ai_vehicle_get e16_cov_wraiths0_0/wraith1))

	; Wait till the vehicle should be dead, or has been dropped off
	(sleep_until
		(or
			(<= (ai_living_count e16_cov_wraiths0_0/wraith1) 0)
			(not (unit_in_vehicle (ai_vehicle_get e16_cov_wraiths0_0/wraith1)))
		)
	)
	
	; Tell the Phantom to release it and allow it to fight again, if it's alive
	(vehicle_unload (ai_vehicle_get e15_cov_phantom0_1/phantom0) "phantom_lc")
	(ai_braindead e16_cov_wraiths0_0/wraith1 false)
)

(script dormant e15_cov_wraith0_main
	(sleep 2)
	(ai_place e16_cov_wraiths0_0/wraith0)
	(ai_braindead e16_cov_wraiths0_0/wraith0 true)
	(sleep 2)
	(vehicle_load_magic (ai_vehicle_get e15_cov_phantom0_0/phantom0) "phantom_lc" (ai_vehicle_get e16_cov_wraiths0_0/wraith0))

	; Wait till the vehicle should be dead, or has been dropped off
	(sleep_until
		(or
			(<= (ai_living_count e16_cov_wraiths0_0/wraith0) 0)
			(not (unit_in_vehicle (ai_vehicle_get e16_cov_wraiths0_0/wraith0)))
		)
	)
	
	; Tell the Phantom to release it and allow it to fight again, if it's alive
	(vehicle_unload (ai_vehicle_get e15_cov_phantom0_0/phantom0) "phantom_lc")
	(ai_braindead e16_cov_wraiths0_0/wraith0 false)
)

(script dormant e15_cov_phantom1_main
	(ai_place e15_cov_phantom1)
	
	; Music
	(sleep_until
		(<= (objects_distance_to_object (players) (ai_vehicle_get e15_cov_phantom1/phantom0)) 20)
		5
		30_seconds
	)
	
	; Music
	(wake music_03b_01_start)
	(sleep 10)
	(game_save_no_timeout)
)

(script dormant e15_cov_phantom0_main
	(sleep_until (volume_test_objects tv_e15_cov_phantoms0_begin (players)) 15)
	(ai_place e15_cov_phantom0_0)
	
	; Load the Wraith
;	(wake e15_cov_wraith0_main)
	
	; Sleep until one Phantom is damaged or dead (or a timeout)
	(sleep_until 
		(or
			g_e16_started
			(<= (object_get_health (ai_vehicle_get e15_cov_phantom0_0/phantom0)) 0.05) 
			(>= (object_model_targets_destroyed (ai_vehicle_get e15_cov_phantom0_0/phantom0) "target_front") 2) 			
;			(<= (ai_living_count e16_cov_wraiths0_0/wraith0) 0)
		)
		30 
		one_minute
	)
	
	; Send the first Phantom packing
	(cs_queue_command_script e15_cov_phantom0_0/phantom0 cs_e15_cov_phantom0_0_exit)
	
	; Place the second Phantom
	(ai_place e15_cov_phantom0_1)

	; :(
	(wake e15_cov_wraith1_main)

	; Sleep until the Phantom is damaged or dead (or a timeout)
	(sleep_until 
		(or
			g_e16_started
			(<= (object_get_health (ai_vehicle_get e15_cov_phantom0_1/phantom0)) 0.05) 
			(>= (object_model_targets_destroyed (ai_vehicle_get e15_cov_phantom0_1/phantom0) "target_front") 2) 			
			(<= (ai_living_count e16_cov_wraiths0_0/wraith1) 0)
		)
		30 
		one_minute
	)
	
	; Send the second one packing
	(cs_queue_command_script e15_cov_phantom0_1/phantom0 cs_e15_cov_phantom0_1_exit)
)

(script dormant e15_cov_inf2_main
	(ai_place e15_cov_inf2_0)
	
	; Sleep until the player has advanced up
	(sleep_until (volume_test_objects tv_e15_cov_inf1_spring (players)) 15)
	
	; Place more, if there is room
	(ai_place e15_cov_inf2_1 (- 10 (ai_living_count e15_cov))) 
)

(script dormant e15_cov_inf1_main
	(sleep_until (volume_test_objects tv_e15_cov_inf1_spring (players)) 15)
	(ai_place e15_cov_inf1)
	
	; Launch the buggers
	(sleep 5)
	(object_set_velocity (ai_get_object e15_cov_inf1/bugger0) 2 0 5)
	(object_set_velocity (ai_get_object e15_cov_inf1/bugger1) 2 0 5)
	(object_set_velocity (ai_get_object e15_cov_inf1/bugger2) 3 0 6)
	(object_set_velocity (ai_get_object e15_cov_inf1/bugger3) 2 0 5)
	(object_set_velocity (ai_get_object e15_cov_inf1/bugger4) 3 0 6)
	(object_set_velocity (ai_get_object e15_cov_inf1/bugger5) 2 0 5)
)

(script dormant e15_cov_inf0_main
	(ai_place e15_cov_inf0)
)

(script dormant e15_mars_inf0_main
	(ai_migrate e14_mars_inf0 e15_mars_inf0)
	(ai_place e15_mars_inf0 (pin (- 3 (ai_living_count e15_mars_inf0)) 1 2))
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e15_main
	(sleep_until (volume_test_objects tv_e15_main_begin (players)) 15)
	(set g_e15_started true)
	(print "e15_main")
	(data_mine_set_mission_segment "e15_bridge_summit")
	(game_save)
	;(garbage_collect_now)

	; Wake control scripts
	(wake e15_mars_inf0_main)
;	(wake e15_cov_inf0_main)
;	(wake e15_cov_inf1_main)
;	(wake e15_cov_inf2_main)
	(wake e15_cov_phantom0_main)
	(wake e15_cov_phantom1_main)
	(wake e15_cov_banshees0_main)

	; Shut down
	(sleep_until g_e17_started)
	(sleep_forever e15_mars_inf0_main)
	(sleep_forever e15_cov_inf0_main)
	(sleep_forever e15_cov_inf1_main)
	(sleep_forever e15_cov_inf2_main)
	(sleep_forever e15_cov_phantom0_main)
	(sleep_forever e15_cov_banshees0_main)
	
	; Condemn
	(ai_disposable e15_cov true)
	(ai_disposable e15_cov_phantom0 false)	
)

(script static void test_bridge_summit
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
	e14_mars_inf0 - Marines moving up the side of the bridge
		(engage0) - Engaging at the first blockade
		(engage1) - Engaging at the second blockade
		(engage2) - etc
		(engage3) - etc
		(engage4) - etc
		(engage5) - etc

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
	; Allow the Wraiths to move
	(cs_enable_moving true)
	
	; Go into the bombardment loop
	(sleep_until 
		(begin
			; If the player is in a vehicle, fire at him
			(if (unit_in_vehicle (unit (player1))) (cs_shoot true (player1)))
			(if (unit_in_vehicle (unit (player0))) (cs_shoot true (player0)))
			
			; Do this for few seconds
			(sleep_until (volume_test_objects tv_e14_blockade4 (players)) 15 150)
			
			; Stop firing
			(cs_shoot false (player0))
			(cs_shoot false (player1))
			
			; Sleep for a while
			(sleep_until (volume_test_objects tv_e14_blockade4 (players)) 15 300)
			
			; Bombard until this condition is met
			(volume_test_objects tv_e14_blockade4 (players))
		)
	)
)

(script command_script cs_e14_mars_pelican0
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 0.25)

	; Wait till the player is in a vehicle, or he's moved up
	(sleep_until 
		(or
			(volume_test_objects tv_e14_mars_inf0_advance (players))
			(player_in_vehicle)
		)
		15
	)
;*	(cs_fly_to_and_face e14_mars_pelican0/p0 e14_mars_pelican0/p1 1.0)

	; Wait for the player at each step
	(cs_vehicle_speed 0.5)
	(sleep_until (volume_test_objects tv_e14_mars_inf0_advance (players)) 15)
	(cs_fly_to_and_face e14_mars_pelican0/p1 e14_mars_pelican0/p2)
	(sleep_until (volume_test_objects tv_e14_blockade0 (players)) 15)
	(cs_fly_to_and_face e14_mars_pelican0/p2 e14_mars_pelican0/p3)
	(sleep_until (volume_test_objects tv_e14_blockade1 (players)) 15)
	(cs_fly_to e14_mars_pelican0/p3)
	
	; Johnson says "ciao"
	(sleep_until (volume_test_objects tv_e14_blockade2 (players)) 15)
	(cs_vehicle_speed 1.0)
	(cs_fly_by e14_mars_pelican0/p4)
*;	(cs_vehicle_speed 1.0)
	(cs_fly_by e14_mars_pelican0/p8)
	(cs_fly_to_and_face e14_mars_pelican0/p6 e14_mars_pelican0/p7)
	
	; Zoom
	(cs_vehicle_boost true)
	(cs_fly_by e14_mars_pelican0/p6)
	(cs_fly_by e14_mars_pelican0/p7)
	(ai_erase ai_current_squad)
)

(script command_script cs_e14_cov_ghosts0_advance0
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_enable_targeting true)
	(cs_go_to e14_cov_ghosts0_advance/p0)
	(cs_go_to e14_cov_ghosts0_advance/p1)
	(cs_go_to e14_cov_ghosts0_advance/p2)
	(cs_go_to e14_cov_ghosts0_advance/p3)
	(cs_go_to e14_cov_ghosts0_advance/p4)
	(cs_go_to e14_cov_ghosts0_advance/p5)
	(cs_go_to e14_cov_ghosts0_advance/p6)
)

(script command_script cs_e14_cov_ghosts0_advance1
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_enable_targeting true)
	(cs_go_to e14_cov_ghosts0_advance/p3)
	(cs_go_to e14_cov_ghosts0_advance/p4)
	(cs_go_to e14_cov_ghosts0_advance/p5)
;	(cs_go_to e14_cov_ghosts0_advance/p6)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e14_cov_snipers0_main
	(sleep 1)
)

(script dormant e14_cov_wraiths0_main
	(ai_place e14_cov_wraiths0/wraith0)
	
	; Wait until the player is up to one of the blockades
	(sleep_until (volume_test_objects tv_e14_blockade0 (players)) 15)
	(cs_run_command_script e14_cov_wraiths0 cs_e14_cov_wraiths0_bombard)
)

(script dormant e14_cov_ghosts1_main
	(sleep 1)
)

(script dormant e14_cov_ghosts0_main
	; Place the first group
	(ai_place e14_cov_ghosts0_0)

	; Spawn at the blockades
	(sleep_until (volume_test_objects tv_e14_blockade0 (players)) 15)
	(ai_place e14_cov_ghosts0_1 (pin (- 4 (ai_living_count e14_cov_ghosts0)) 0 2))
	(sleep_until (volume_test_objects tv_e14_blockade1 (players)) 15)
	(ai_place e14_cov_ghosts0_1 (pin (- 4 (ai_living_count e14_cov_ghosts0)) 0 2))
	(sleep_until (volume_test_objects tv_e14_blockade2 (players)) 15)
	(ai_place e14_cov_ghosts0_1 (pin (- 4 (ai_living_count e14_cov_ghosts0)) 0 2))
	(sleep_until (volume_test_objects tv_e14_blockade3 (players)) 15)
	(ai_place e14_cov_ghosts0_1 (pin (- 4 (ai_living_count e14_cov_ghosts0)) 0 2))
	(sleep_until (volume_test_objects tv_e14_blockade4 (players)) 15)
	(ai_place e14_cov_ghosts0_1 (pin (- 4 (ai_living_count e14_cov_ghosts0)) 0 2))
	(sleep_until (volume_test_objects tv_e14_blockade5 (players)) 15)
	(ai_place e14_cov_ghosts0_1 (pin (- 4 (ai_living_count e14_cov_ghosts0)) 0 2))
)

(script dormant e14_mars_pelican0_main
	(ai_place e14_mars_pelican0)
	(object_cannot_take_damage (ai_actors e14_mars_pelican0))

	; Load them up
	(ai_vehicle_enter_immediate e14_mars_pelican0/gunner0 (ai_vehicle_get e14_mars_pelican0/pelican0) "pelican_g")
	(ai_vehicle_enter_immediate e14_mars_pelican0/johnson0 (ai_vehicle_get e14_mars_pelican0/pelican0) "pelican_g_rear")
)

(script dormant e14_mars_inf0_main
	(ai_place e14_mars_inf0)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location e14_mars_inf0/scorpion0) "scorpion_d" true)
	
	; If it's coop, drop the Hog too
	(if (game_is_cooperative) 
		(begin
			(ai_place e14_mars_inf0/warthog0)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location e14_mars_inf0/warthog0) "warthog_d" true)
		)
		(begin
			(ai_place e14_mars_inf0/warthog1)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location e14_mars_inf0/warthog1) "warthog_d" true)
		)
	)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e14_main
	(set g_e14_started true)
	(print "e14_main")
	(data_mine_set_mission_segment "e14_bridge_ascent")
	(game_save)
	;(garbage_collect_now)

	; Voices in my head say kill
	(kill_volume_enable kill_e14_0)
	
	; Objectives
	(wake objective0_set)
	
	; Wake subsequent scripts
	(wake e15_main)
	(wake e16_main)
	(wake e17_main)
	(wake e18_main)

	; Wake control scripts
	(wake e14_mars_inf0_main)
	(wake e14_mars_pelican0_main)
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

	; Condemn
	(ai_disposable e14_cov true)
)


;= MISSION MAIN ==========================================================================

(script dormant mission_start
	; This is pretty gross
	(wake flashlight_control)
	
	; Protect the players
	(object_cannot_take_damage (players))
	(object_hide (player0) true)
	(object_hide (player1) true)

	; Run the cinematics
	(cinematic_snap_to_white) ; pbertone (changed to cinematic_snap_to_white) 9/21 
	(cinematic_intro)
	
	; Teleport the players into their starting locations, unprotect them
	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)
	(object_hide (player0) false)
	(object_hide (player1) false)
	(object_can_take_damage (players))
		
	; Wake the first encounter
	(wake e14_main)
	
	; Fade in
	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white_bars)

	; Initial chapter title
	(wake chapter_title0)
		
	; Wait for the mission to end
	(sleep_until g_mission_over 8)
	(wake music_03b_04_stop)
	(sleep 60)
	
	; For playtests
	(playtest_mission)
	(sleep 15)
	
	; Fade out, run the cinematic
	(cinematic_fade_to_white)
	
	; Cleanup!
	(object_cannot_take_damage (players))
	(object_hide (player0) true)
	(object_hide (player1) true)
	(object_teleport (player0) player0_end)
	(object_teleport (player1) player1_end)
	(object_destroy scarab)
	(ai_erase e23_cov)
	(ai_erase e23_mars)
	
	; Run the cinematic
	(cinematic_outro)
	
	; Winnar!
	(game_won)
)

(script static void start
	(wake mission_start)
)

(script startup mission_main
	; Necessary startup stuff
	(ai_allegiance player human)
	(ai_allegiance covenant prophet)
	
	; Clear objectives
	(objectives_clear)
	
	; Begin the mission
	; Comment this out when you're testing individual encounters
	(if (> (player_count) 0 ) (start))
)

