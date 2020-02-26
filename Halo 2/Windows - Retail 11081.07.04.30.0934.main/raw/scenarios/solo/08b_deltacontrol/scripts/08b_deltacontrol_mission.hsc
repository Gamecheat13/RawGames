;= DELTACONTROL ==========================================================================
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

; Characters
(global unit g_cov_commander none)			; The commander actor reference


;- Stubs -----------------------------------------------------------------------

(script stub void c08_intra1 (print "c08_intra1 (cinematics didn't compile)"))
(script stub void c08_intra2 (print "c08_intra2 (cinematics didn't compile)"))
(script stub void c08_intra3 (print "c08_intra3 (cinematics didn't compile)"))
(script stub void x09 (print "x09 (cinematics didn't compile)"))

(script stub void tartarus_boss_fight (print "tartarus_boss_fight (external scripts didn't compile)"))


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


;= SINEMATICS ============================================================================

(script static void cinematic_intro
	(if (cinematic_skip_start)
		(begin
			(c08_intra1)
		)
	)
	(cinematic_skip_stop)
)

(script static void cinematic_johnson_ledge
	(if (cinematic_skip_start)
		(begin
			(c08_intra2)
		)
	)
	(cinematic_skip_stop)
)

(script static void cinematic_tartarus_fight
	(if (cinematic_skip_start)
		(begin
			(c08_intra3)
		)
	)
	(cinematic_skip_stop)
)

(script static void cinematic_epilogue
	; NOT SKIPPABLE! AHHHAHAHAHA! EAT MY ASS, YOU EPILOGUE SKIPPING BASTARDS!
	(x09)
)


;= OBJECTIVES ============================================================================

(script dormant objective0_set
	(sleep 30)
	(objectives_show_up_to 0)
)

(script dormant objective0_clear
	(objectives_finish_up_to 0)
)

(script dormant objective1_set
	(sleep 30)
	(objectives_show_up_to 1)
)

(script dormant objective1_clear
	(objectives_finish_up_to 1)
)

(script dormant objective2_set
	(sleep 30)
	(objectives_show_up_to 2)
)

(script dormant objective2_clear
	(objectives_finish_up_to 2)
)

(script dormant objective3_set
	(sleep 30)
	(objectives_show_up_to 3)
)

(script dormant objective3_clear
	(objectives_finish_up_to 3)
)

(script dormant objective4_set
	(sleep 180)
	(objectives_show_up_to 4)
)

(script dormant objective4_clear
	(objectives_finish_up_to 4)
)


;= MUSIC =================================================================================

(script dormant music_08b_01_stop
	(print "music 08b_01 stop")
	(sound_looping_stop "scenarios\solo\08b_deltacontrol\08b_music\08b_01")
)

(script dormant music_08b_01_start_alt
	(print "music 08b_01 start alt")
	(sound_looping_set_alternate "scenarios\solo\08b_deltacontrol\08b_music\08b_01" true)
)

(script dormant music_08b_01_start
	(print "music 08b_01 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_01" none 1.0)
)

(script dormant music_08b_02_stop
	(print "music 08b_02 stop")
	(sound_looping_stop "scenarios\solo\08b_deltacontrol\08b_music\08b_02")
)

(script dormant music_08b_02_start
	(print "music 08b_02 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_02" none 1.0)
)

(script dormant music_08b_03_stop
	(print "music 08b_03 stop")
	(sound_looping_stop "scenarios\solo\08b_deltacontrol\08b_music\08b_03")
)

(script dormant music_08b_03_start
	(print "music 08b_03 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_03" none 1.0)
)

(script dormant music_08b_04_stop
	(print "music 08b_04 stop")
	(sound_looping_stop "scenarios\solo\08b_deltacontrol\08b_music\08b_04")
)

(script dormant music_08b_04_start
	(print "music 08b_04 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_04" none 1.0)
)

(script dormant music_08b_05_stop
	(print "music 08b_05 stop")
	(sound_looping_stop "scenarios\solo\08b_deltacontrol\08b_music\08b_05")
)

(script dormant music_08b_05_start_alt
	(print "music 08b_05 start alt")
	(sound_looping_set_alternate "scenarios\solo\08b_deltacontrol\08b_music\08b_05" true)
)

(script dormant music_08b_05_start
	(print "music 08b_05 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_05" none 1.0)
)

(script dormant music_08b_06_start
	(print "music 08b_06 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_06" none 1.0)
)

(script dormant music_08b_07_start
	(print "music 08b_07 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_07" none 1.0)
)

(script dormant music_08b_08_start
	(print "music 08b_08 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_08" none 1.0)
)

(script dormant music_08b_09_stop
	(print "music 08b_09 stop")
	(sound_looping_stop "scenarios\solo\08b_deltacontrol\08b_music\08b_09")
)

(script dormant music_08b_09_start_alt
	(print "music 08b_09 start alt")
	(sound_looping_set_alternate "scenarios\solo\08b_deltacontrol\08b_music\08b_09" true)
)

(script dormant music_08b_09_start
	(print "music 08b_09 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_09" none 1.0)
)

(script dormant music_08b_10_stop
	(print "music 08b_10 stop")
	(sound_looping_stop "scenarios\solo\08b_deltacontrol\08b_music\08b_10")
)

(script dormant music_08b_10_start
	(print "music 08b_10 start")
	(sound_looping_start "scenarios\solo\08b_deltacontrol\08b_music\08b_10" none 1.0)
)

;= THE SCARAB(S) =========================================================================
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
	(device_animate_position scarab 1.0 6.5 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_var0_no_block
	(print "scarab_idle_var0")
	(device_set_position_track scarab combat:idle:var0 g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
)
(script static void scarab_idle_to_walk_front
	(print "scarab_idle_to_walk_front")
	(device_set_position_track scarab combat:idle:2:walk_front g_scarab_interpolation)
	(device_animate_position scarab 1.0 3 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_var0
	(print "scarab_walk_front_var0")
	(device_set_position_track scarab combat:walk_front:var0 g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_walk_front_to_idle
	(print "scarab_walk_front_to_idle")
	(device_set_position_track scarab combat:walk_front:2:idle g_scarab_interpolation)
	(device_animate_position scarab 1.0 3 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_15_left
	(print "scarab_idle_turn_15_left")
	(device_set_position_track scarab combat:turn_15_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_15_right
	(print "scarab_idle_turn_15_right")
	(device_set_position_track scarab combat:turn_15_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_15_right_slow
	(print "scarab_idle_turn_15_right_slow")
	(device_set_position_track scarab combat:turn_15_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_22_left
	(print "scarab_idle_turn_22_left")
	(device_set_position_track scarab combat:turn_22_left g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_22_right
	(print "scarab_idle_turn_22_right")
	(device_set_position_track scarab combat:turn_22_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
)
(script static void scarab_idle_turn_22_right_slow
	(print "scarab_idle_turn_22_right_slow")
	(device_set_position_track scarab combat:turn_22_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
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
(script static void scarab_idle_turn_45_right_slow
	(print "scarab_idle_turn_45_right_slow")
	(device_set_position_track scarab combat:turn_45_right g_scarab_interpolation)
	(device_animate_position scarab 1.0 6 0 0 true)
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
(script static void scarab_walk_front_turn_22_right
	(print "scarab_walk_front_turn_22_right")
	(device_set_position_track scarab combat:walk_front_turn_22_right g_scarab_interpolation)
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
(script static void scarab_gun_open_up
	(device_set_overlay_track scarab combat:fire_open)
	(device_animate_overlay scarab 1.0 3.5 0 0)
)
(script static void scarab_gun_fire_up
	(device_set_overlay_track scarab combat:fire)
	(device_animate_overlay scarab 1.0 6 0 0)
)
(script static void scarab_gun_close_up
	(device_set_overlay_track scarab combat:fire_close)
	(device_animate_overlay scarab 1.0 3.5 0 0)
)
(script static void scarab_gun_open_down
	(device_set_overlay_track scarab combat:fire_down_open)
	(device_animate_overlay scarab 1.0 3.5 0 0)
)
(script static void scarab_gun_fire_down
	(device_set_overlay_track scarab combat:fire_down)
	(device_animate_overlay scarab 1.0 6 0 0)
)
(script static void scarab_gun_fire_down_abort
	(device_animate_overlay scarab 0.0 3 0 0)
)
(script static void scarab_gun_close_down
	(device_set_overlay_track scarab combat:fire_down_close)
	(device_animate_overlay scarab 1.0 3.5 0 0)
)


;= ENCOUNTER 13 ==========================================================================
;*
The player pops open a tin of Whup Ass on Tartarus.
I get to take a vacation.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e13_cov_inf0 - Elites assisting you in the battle
		_0 - Regular Elites with plasma rifles
		_1 - Special Elites (Spec Op, Councilor, Zealot) with plasma swords

Marines
	e13_mars_johnson - Johnson riding around with a Covenant sniper rifle
	e13_mars_miranda - Miranda riding around and watching the fight with 343

Prophets
	e13_pro_tartarus - Mr. Mohawk
	e13_pro_inf0 - Brutes assisting Tartarus
		_0 - Honor Guard Brutes initally with him
		_1 - Regular Brutes who filter in to replace them

Sentinels
	e13_sen_monitor - 343 flying around, checking things out

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e13_started false)			; Encounter has been activated?


;*
(global short g_e13_tartarus_lives_remaining 2)


;- Command Scripts -------------------------------------------------------------

(script static boolean e13_rotors_blocking_elites
	(or
		; First rotor
		(and
			(> (device_get_position e13_rotors) 0.3)
			(< (device_get_position e13_rotors) 0.4)
		)
		
		; Second rotor
		(and
			(> (device_get_position e13_rotors) 0.8)
			(< (device_get_position e13_rotors) 0.9)
		)
	)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e13_order_cycle
	(sleep_until
		(begin
			(ai_set_orders e13_cov_inf0 e13_cov_inf0_engage2)
			(sleep 150)
			(ai_set_orders e13_pro_inf0 e13_pro_inf0_engage0)
			(sleep 750)
		
			(ai_set_orders e13_cov_inf0 e13_cov_inf0_engage3)
			(sleep 150)
			(ai_set_orders e13_pro_inf0 e13_pro_inf0_engage1)
			(sleep 750)
		
			(ai_set_orders e13_cov_inf0 e13_cov_inf0_engage0)
			(sleep 150)
			(ai_set_orders e13_pro_inf0 e13_pro_inf0_engage2)
			(sleep 750)
		
			(ai_set_orders e13_cov_inf0 e13_cov_inf0_engage1)
			(sleep 150)
			(ai_set_orders e13_pro_inf0 e13_pro_inf0_engage3)
			(sleep 750)
		
			; Behold: the infinite respawner
			false
		)
		1
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e13_sen_monitor_main
	(ai_place e13_sen_monitor)
	(ai_disregard (ai_actors e13_sen_monitor) true)
)

(script dormant e13_pro_tartarus_main
	(ai_place e13_pro_tartarus)
	
	; Make Tartarus invincible
	(object_cannot_die (ai_get_object e13_pro_tartarus/tartarus0) true)

	; The many lives of Tartarus
	(sleep_until
		(begin
			; If he's weakened to the point of death, renew him and decrement his lives
			(if (<= (object_get_health (ai_get_object e13_pro_tartarus/tartarus0)) 0.05)
				(begin
					; Renew him
					(ai_renew e13_pro_tartarus)
					
					; Decrement his lives
					(set g_e13_tartarus_lives_remaining (- g_e13_tartarus_lives_remaining 1))
					
					; Do his recovery stuff
					(print "tartarus freaks out")
				)
			)
		
			; Loop until he's out of lives, or dead
			(or
				(<= g_e13_tartarus_lives_remaining 0)
				(<= (ai_living_count e13_pro_tartarus) 0)
			)
		)
	)
	
	; Make him not so invincible
	(object_cannot_die (ai_get_object e13_pro_tartarus/tartarus0) false)
	
	; Wait until he's dead
	(sleep_until (<= (ai_living_count e13_pro_tartarus) 0))
	
	; Dramatic pause, then mission over
	(sleep 60)
	(set g_mission_over true)
)

(script dormant e13_pro_inf0_main
	(ai_place e13_pro_inf0_0)

	; Respawner
	(sleep_until
		(begin
			(if (<= (ai_living_count e13_pro_inf0) 2)
				(ai_place e13_pro_inf0_1 1)
			)
		
			; Behold: the infinite respawner
			false
		)
		150
	)
)

(script dormant e13_mars_miranda_main
	(ai_place e13_mars_miranda)
)

(script dormant e13_mars_johnson_main
	(ai_place e13_mars_johnson)
)

(script dormant e13_cov_inf0_main
	
	
	; Respawner
	(sleep_until
		(begin
			(if (<= (ai_living_count e13_cov_inf0) 2)
				; Randomly place a cool guy or a chump
				(if 
					(and
						(= (random_range 0 3) 0)
						(<= (ai_living_count e13_cov_inf0_1) 0)
					)
					(ai_place e13_cov_inf0_1 1)
					(ai_place e13_cov_inf0_0 1)
				)
			)
		
			; Behold: the infinite respawner
			false
		)
		150
	)
)


;- Init and Cleanup ------------------------------------------------------------
*;
(script dormant e13_main
	(set g_e13_started true)
	(game_save)
	(print "e13_main")
	(data_mine_set_mission_segment "e13_control_room")
	
	; Lock the door
	(device_operates_automatically_set e12_door0 false)
	
	; Take it away, Jaime
	(tartarus_boss_fight)
	(wake objective3_clear)
	(set g_mission_over true)
)

(script dormant e13_cinematic_main
	(sleep_until
		(or
			(volume_test_objects tv_e13_cutscene_trigger1 (players))
			(and
				(volume_test_objects tv_e13_cutscene_trigger0 (players))
				(objects_can_see_flag (players) e13_cutscene_trigger 15)
			)
		)
		15
	)
	
	; Fade out
	(cinematic_fade_to_white)
	
	; Stash the players around the corner
	(object_teleport (player0) player0_stash)
	(object_teleport (player1) player1_stash)
	
	; Do it! Do it now!
	(cinematic_tartarus_fight)
	; What are you waiting for? Do it!
	
	; For Mat and Co.
	(sound_suppress_ambience_update_on_revert)
	(sound_class_set_gain amb 0 0)
	(sleep 1)
	(sound_class_set_gain amb 1 15)

	; Switch back in
	(switch_bsp_by_name "deltacontrolroom_bsp4")
	
	; Wake the encounter
	(wake e13_main)
	
	; Fade back in
	(cinematic_fade_from_white)
)


;= ENCOUNTER 12 ==========================================================================
;*
The player recieves reinforcements, and heads into the control room, 
encountering resistence along the way.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e12_cov_inf0 - Allies dropped off by e12_cov_phantom0
		_0 - Left side
		_1 - Right side
			(init) - Wait for the player near the entrance
			(advance0) - Move up halfway
			(advance1) - Move up to the opposite door
			(engage0_left/right) - Fighting from the entrance
			(engage1_left/right) - Advancing to flank the first platform
			(engage2_left/right) - Advancing to flank the second platform
			(wait) - Wait by the door, if they're still alive
	e12_cov_phantom0 - An Elite Phantom which drops off allies

Prophets
	e12_pro_inf0 - Brute defenders
		_0 - Token resistance right at the start, on the center platform
		_1 - Initial wave
		_2 - Second wave
			(defend0) - Defending the center platform, controlling the room
			(defend1) - Defending from further back, using the turrets
			(defend2) - Last ditch defense at the door

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e12_started false)			; Encounter has been activated?
(global boolean g_e12_pro_inf0_1_berserk false)	


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e12_cov_phantom0_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e12_cov_phantom0_entry/p0)
	(cs_fly_by e12_cov_phantom0_entry/p1)
	(cs_vehicle_boost true)
	(cs_fly_by e12_cov_phantom0_entry/p1_1)
	(cs_vehicle_boost false)
	
	; Continue in
	(cs_fly_by e12_cov_phantom0_entry/p1_2)
	(cs_fly_to e12_cov_phantom0_entry/p2)
	(cs_face true e12_cov_phantom0_entry/p2_facing)
	(cs_fly_to e12_cov_phantom0_entry/p3 1.0)
	
	; Unload
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) true)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_a01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_a02")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_a03")
	(sleep 45)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_b01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_b02")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_b03")
	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) false)

	; Move clear
	(cs_face false e12_cov_phantom0_entry/p2_facing)
	(cs_fly_to e12_cov_phantom0_entry/p4)
	(cs_face true e12_cov_phantom0_entry/p4_facing)
	
	; Allow combat
	(cs_enable_targeting true)
	(cs_enable_moving true)
	
	; Wait until the BSP swaps, then erase
	(sleep_until (= (structure_bsp_index) 2) 15)
	(ai_erase ai_current_squad)
)

(script command_script cs_e12_pro_inf0_1_wait
	(cs_crouch true)
	(sleep_until (ai_trigger_test e12_pro_inf0_sighted_player e12_pro_inf0) 15)
)

(script command_script cs_e12_pro_inf0_wait0
	(cs_crouch true)
	(cs_face true e12_patrol/s0)
	(sleep_until (> (device_get_position e12_door0) 0) 15)
	
	; Open fire and start backpedaling
	(cs_shoot_point true e12_patrol/s0)
	(sleep 30)
	(cs_go_to e12_patrol/p0)
	(sleep 30)
)

(script command_script cs_e12_pro_inf0_wait1
	(cs_crouch true)
	(cs_face true e12_patrol/s1)
	(sleep_until (> (device_get_position e12_door0) 0) 15)
	
	; Open fire and start backpedaling
	(cs_shoot_point true e12_patrol/s1)
	(sleep 30)
	(cs_go_to e12_patrol/p1)
	(sleep 30)
)

(script command_script cs_e12_cov_inf0_look
	(cs_face_player true)
	(sleep_forever)
)

(script command_script cs_e12_cov_inf0_follow
	(sleep 1)
)

(script command_script cs_e12_pro_inf0_captain
	(cs_enable_targeting true)
	(cs_enable_moving true)
	(sleep_until (> (ai_combat_status ai_current_actor) ai_combat_status_active))

	; Play his line
	(cs_enable_moving false)
	(cs_look_player true)
	(sleep (random_range 15 30))
	(print "cpn: do not let them enter!")
	(sleep (ai_play_line ai_current_actor 0940))
	(sleep 20)
	(cs_enable_moving true)
	(print "cpn: tartar sauce must complete his tasty condiments")
	(sleep (ai_play_line ai_current_actor 0950))
)

(script command_script cs_e12_pro_inf0_berserker
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(sleep_until (> (ai_combat_status ai_current_actor) ai_combat_status_active))
	(sleep (random_range 0 30))
	(ai_berserk ai_current_actor true)
)

(script command_script cs_e12_cov_banshee0_entry
	(object_cannot_die (ai_vehicle_get ai_current_actor) true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_fly_to e12_cov_banshees0/p2 5)
	(cs_vehicle_boost false)
	(cs_fly_to e12_cov_banshees0/p2 0.5)
	(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) true)
	(ai_vehicle_exit ai_current_actor)
	(sleep 30)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e12_pro_inf0_main
	(sleep_until (= (structure_bsp_index) 2) 15)
;	(ai_place e12_pro_inf0_0)

	; Wait until the player is well into the room
	(sleep_until (volume_test_objects tv_e12_chamber_entered (players)) 15)
;	(device_operates_automatically_set e12_door1 true)
	(ai_place e12_pro_inf0_1)

	; Music
	(wake music_08b_09_start)

	; Wait until they're all inside
;	(sleep_until (volume_test_objects_all tv_e12_antechamber (ai_actors e12_pro_inf0_1)) 15)	
;	(device_operates_automatically_set e12_door1 false)
	
	; Wait for reins...
	(sleep_until
		(and
			(<= (ai_living_count e12_pro_inf0) 1)
			(<= (device_get_position e12_door1) 0)
		)
	)
	
	; Checkpoint
	(game_save_no_timeout)
	
	; Unlock the door and send in the reins
;	(device_operates_automatically_set e12_door1 true)
	(ai_place e12_pro_inf0_2)

	; Music
	(wake music_08b_09_start_alt)
	(wake music_08b_10_start)

	; Wait until they're all inside
;	(sleep_until (volume_test_objects_all tv_e12_antechamber (ai_actors e12_pro_inf0_2)) 15)	
;	(device_operates_automatically_set e12_door1 false)

	; Wait until they're dead... all dead...
	(sleep_until
		(or
			(<= (ai_living_count e12_pro_inf0) 0)
			(volume_test_objects tv_e13_cutscene_trigger0 (players))
		)
		15
	)
;	(device_operates_automatically_set e12_door1 true)
	(device_one_sided_set e12_door1 false)
	(device_closes_automatically_set e12_door1 false)
	(device_set_position e12_door1 1.0)

	; Music
	(wake music_08b_09_stop)
	(wake music_08b_10_stop)
)

(script dormant e12_pro_inf0_ender
	(sleep_until (volume_test_objects tv_e12_pro_inf0_end (players)) 15)
	(sleep_forever e12_pro_inf0_main)

	; Lock the door open
	(device_one_sided_set e12_door1 false)
	(device_closes_automatically_set e12_door1 false)
	(device_set_position e12_door1 1.0)

	; Music
	(wake music_08b_09_stop)
	(wake music_08b_10_stop)
)

(script dormant e12_cov_phantom0_main
	(ai_place e12_cov_phantom0)
)

(script dormant e12_cov_banshees0_main
	; Wait until...
	(sleep_until
		(or
			(volume_test_objects tv_e12_ledge (players))
			(volume_test_objects tv_e12_cov_banshee0_begin (players))
			
			; Or, if neither player is in a vehicle...
			(not (player_in_vehicle))
		)
		15
	)
	
	; If the player is on the ledge, just stop now
	(if (volume_test_objects tv_e12_ledge (players)) (sleep_forever))
	
	; Wait until the player isn't looking, then send one it
	(sleep_until 
		(not (objects_can_see_flag (players) e12_cov_banshees0_spawn 80.0))
		15
	)
	
	; Send in the Banshee
	(ai_place e12_cov_banshees0)
	
	; Sleep for a bit
	(sleep_until (player_in_vehicle) 30 450)
	
	; If the player is in a vehicle, we're done
	(if (player_in_vehicle) (sleep_forever))
	
	; Otherwise, put a nav point on this one
	(activate_team_nav_point_object default player (ai_vehicle_get_from_starting_location e12_cov_banshees0/banshee0) 1)	

	; Wait until the player is in a vehicle
	(sleep_until (player_in_vehicle))
	(deactivate_team_nav_point_object player (ai_vehicle_get_from_starting_location e12_cov_banshees0/banshee0))	
)

(script dormant e12_cov_inf0_main
	(sleep_until (> (ai_spawn_count e12_cov_phantom0) 0) 5)
	
	; Place the appropriate Elites
	(ai_place e12_cov_inf0_0)
	(ai_place e12_cov_inf0_1/elite0)
	(ai_place e12_cov_inf0_1/elite1)
	(if (not (game_is_cooperative)) (ai_place e12_cov_inf0_1/elite2))
	(sleep 2)
	
	; Load them into the Phantom
	(ai_vehicle_enter_immediate e12_cov_inf0_0 (ai_vehicle_get e12_cov_phantom0/phantom0) "phantom_p_a")
	(ai_vehicle_enter_immediate e12_cov_inf0_1 (ai_vehicle_get e12_cov_phantom0/phantom0) "phantom_p_b")

	; When the player lands on the ledge, everyone look at him
	(sleep_until (volume_test_objects tv_e12_ledge (players)) 15)
	
	; Look at the player
	(cs_run_command_script e12_cov_inf0 cs_e12_cov_inf0_look)

	; Advance with him (sucks that I have to do this here, but the orders aren't yet active)
	(sleep_until (volume_test_objects tv_e12_ledge_entrance (players)) 15)
	(cs_run_command_script e12_cov_inf0 cs_e12_cov_inf0_follow)
	(ai_set_orders e12_cov_inf0 e12_cov_inf0_advance0)
	(sleep_until (volume_test_objects tv_e12_swap_room_halfway (players)) 15)
	(ai_set_orders e12_cov_inf0 e12_cov_inf0_advance1)
	
	; Wait till the BSP swaps
	(sleep_until (= (structure_bsp_index) 2))
	
	; Migrate them if necessary
	(ai_teleport_to_starting_location_if_outside_bsp e12_cov_inf0_0)
	(ai_teleport_to_starting_location_if_outside_bsp e12_cov_inf0_1)

	; Then divide the Elites
	(sleep_until (> (device_get_position e12_door0) 0) 15)
	(ai_set_orders e12_cov_inf0_0 e12_cov_inf0_engage0_right)
	(ai_set_orders e12_cov_inf0_1 e12_cov_inf0_engage0_left)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e12_main
	(set g_e12_started true)
	(game_save)
	(print "e12_main")
	(data_mine_set_mission_segment "e12_control_antechamber")
	
	; Chapter title
	(wake chapter_title2)
	
	; Objectives
	(wake objective2_clear)
	(wake objective3_set)
	
	; Wake subsequent scripts
	(wake e13_cinematic_main)

	; Wake control scripts
;	(wake e12_cov_inf0_main)
;	(wake e12_cov_phantom0_main)
	(wake e12_cov_banshees0_main)
	(wake e12_pro_inf0_main)
	(wake e12_pro_inf0_ender)
	
	; Sleep until the BSP swap
	(sleep_until (= (structure_bsp_index) 2))
	(game_save)
	
	; Partial shut down
	(sleep_forever e12_cov_banshees0_main)
	(deactivate_team_nav_point_object player (ai_vehicle_get_from_starting_location e12_cov_banshees0/banshee0))
	
	; Shut down
	(sleep_until g_e13_started)
	(sleep_forever e12_cov_inf0_main)
	(sleep_forever e12_cov_phantom0_main)
	(sleep_forever e12_pro_inf0_main)
	(ai_erase e12_cov)
	(ai_erase e12_pro)
)

(script static void test_antechamber
	(switch_bsp 2)
	(object_teleport (player0) e12_test)
	(if (not g_e12_started) (wake e12_main))
)


;= ENCOUNTER 11 ==========================================================================
;*
The engages in a vehicle brawl around the entrance of the control room.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites

Prophets
	e11_pro_wraiths0 - Wraiths dropped off by the Phantoms
		_0 - The first of two Wraiths dropped off by e11_pro_phantoms0_0
		_1 - The second, via e11_pro_phantoms0_1
	e11_pro_wraiths1 - Wraiths stationed on the buttresses
		_0 - One of them
		_1 - And so on...
		_2 - "
		_3 - "
			(init) - On guard. No firing points, though.
	e11_pro_phantoms0 - Phantoms which drop off additional Wraiths, then depart
	e11_pro_ghosts0 - Ghosts which skirmish around the Scarab (mostly fodder)
	e11_pro_spectre0 - Spectres which prowl on the beach
	e11_pro_banshees0 - Banshees which 

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e11_started false)			; Encounter has been activated?
(global boolean g_e11_door_open false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e11_pro_phantom0_0_main
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_fly_by e11_pro_phantom0_0/p00)
	(cs_vehicle_boost false)
	(cs_fly_by e11_pro_phantom0_0/p0)
	(cs_fly_to e11_pro_phantom0_0/p1)
	(cs_fly_to_and_face e11_pro_phantom0_0/p2 e11_pro_phantom0_1/p1_facing 0.5)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_lc")
	(ai_braindead e11_pro_wraith0_0 false)
	(sleep 30)
	(cs_fly_to_and_face e11_pro_phantom0_0/p1 e11_pro_phantom0_0/p3 0.5)

	; And exit
	(cs_fly_by e11_pro_phantom0_0/p3)
	(cs_fly_by e11_pro_phantom0_0/p4)
	(cs_vehicle_boost true)
	(cs_fly_by e11_pro_phantom0_0/p5)
	(ai_erase ai_current_squad)
)

(script command_script cs_e11_pro_phantom0_1_main
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_fly_by e11_pro_phantom0_1/p00)
	(cs_vehicle_boost false)
	(cs_fly_by e11_pro_phantom0_1/p0)
	(cs_fly_to_and_face e11_pro_phantom0_1/p1 e11_pro_phantom0_1/p1_facing)
	(cs_fly_to_and_face e11_pro_phantom0_1/p2 e11_pro_phantom0_1/p1_facing 0.5)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_lc")
	(ai_braindead e11_pro_wraith0_1 false)
	(sleep 30)
	(cs_fly_to_and_face e11_pro_phantom0_1/p1 e11_pro_phantom0_1/p3 0.5)

	; And exit
	(cs_fly_by e11_pro_phantom0_1/p3)
	(cs_fly_by e11_pro_phantom0_1/p4)
	(cs_vehicle_boost true)
	(cs_fly_by e11_pro_phantom0_1/p5)
	(ai_erase ai_current_squad)
)

(script command_script cs_e11_attack_scarab
	(cs_abort_on_combat_status ai_combat_status_clear_los)

	; Enable combat behaviors
	(cs_enable_moving true)

	; Select some part of the Scarab and open fire
;	(cs_approach scarab 25.0 500.0 500.0)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_shoot_point true scarab_air/joint0)
					(sleep (random_range 90 180))
					(cs_shoot_point false scarab_air/joint0)
				)
				(begin
					(cs_shoot_point true scarab_air/joint1)
					(sleep (random_range 90 180))
					(cs_shoot_point false scarab_air/joint1)
				)
				(begin
					(cs_shoot_point true scarab_air/joint2)
					(sleep (random_range 90 180))
					(cs_shoot_point false scarab_air/joint2)
				)
				(begin
					(cs_shoot_point true scarab_air/joint3)
					(sleep (random_range 90 180))
					(cs_shoot_point false scarab_air/joint3)
				)
			)
		
			; Loop forever
			false
		)
	)
)

(script command_script cs_e11_attack_scarab_behavior
	; Enable combat behaviors
	(cs_enable_moving true)
	(cs_enable_targeting true)

	; Loop forever
	(sleep_until
		(begin
			; Wait until combat status is low
			(sleep_until (<= (ai_combat_status ai_current_actor) ai_combat_status_active))
			
			; Tell them to attack the Scarab
			(cs_stack_command_script ai_current_actor cs_e11_attack_scarab)
		
			; Forever
			false
		)
	)
)

(script command_script cs_e11_pro_wraiths1_shoot
	(cs_abort_on_combat_status ai_combat_status_clear_los)

	; Enable combat behaviors
	(cs_enable_moving true)

	; Select some part of the Scarab and open fire
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_shoot_point true scarab_air/joint0)
					(sleep (random_range 90 180))
					(cs_shoot_point false scarab_air/joint0)
				)
				(begin
					(cs_shoot_point true scarab_air/joint1)
					(sleep (random_range 90 180))
					(cs_shoot_point false scarab_air/joint1)
				)
				(begin
					(cs_shoot_point true scarab_air/joint2)
					(sleep (random_range 90 180))
					(cs_shoot_point false scarab_air/joint2)
				)
				(begin
					(cs_shoot_point true scarab_air/joint3)
					(sleep (random_range 90 180))
					(cs_shoot_point false scarab_air/joint3)
				)
			)
		
			; Loop forever
			false
		)
	)
)

(script command_script cs_e11_pro_wraiths1_bombard
	; Enable combat behaviors
	(cs_enable_moving true)
	(cs_enable_targeting true)

	; Loop forever
	(sleep_until
		(begin
			; Wait until combat status is low
			(sleep_until (<= (ai_combat_status ai_current_actor) ai_combat_status_active))
			
			; Tell them to attack the Scarab
			(cs_stack_command_script ai_current_actor cs_e11_pro_wraiths1_shoot)
		
			; Forever
			false
		)
	)
)

(script command_script cs_e11_ghost_door0_entry
	(cs_enable_pathfinding_failsafe true)
	
	; Open the door and head through
	(cs_go_to_and_face e11_door_entry/p0 e11_door_entry/p1)
	(sleep_until 
		(begin
			(device_set_position e11_door0 1.0)
			(>= (device_get_position e11_door0) 1.0) 
		)
		10
	)
	(cs_go_by e11_door_entry/p1 e11_door_entry/p2)
	(cs_vehicle_boost true)
	(cs_go_to e11_door_entry/p2)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(sleep 120)
	(object_can_take_damage (ai_get_object ai_current_actor))

	; Start attacking the Scarab
	(cs_run_command_script ai_current_actor cs_e11_attack_scarab_behavior)
)

(script command_script cs_e11_spectre_door0_entry
	(cs_enable_pathfinding_failsafe true)
	
	; That stink is fear. I can smell it.
	(ai_vehicle_reserve_seat (ai_vehicle_get ai_current_actor) "spectre_p_l" true)
	
	; Open the door and head through
	(cs_go_to_and_face e11_door_entry/p0 e11_door_entry/p1)
	(sleep_until 
		(begin
			(device_set_position e11_door0 1.0)
			(>= (device_get_position e11_door0) 1.0) 
		)
		10
	)
	(cs_go_by e11_door_entry/p1 e11_door_entry/p2)
	(cs_vehicle_boost true)
	(cs_go_to e11_door_entry/p2)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(sleep 120)
	(object_can_take_damage (ai_get_object ai_current_actor))

	; Start attacking the Scarab
	(cs_run_command_script ai_current_actor cs_e11_attack_scarab_behavior)
)

(script command_script cs_e11_pro_banshees0_0_entry
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_vehicle_boost true)
	(sleep 90)
	(cs_enable_moving true)
	(sleep 150)
)

(script command_script cs_e11_pro_banshees0_1_entry
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_vehicle_boost true)
	(cs_fly_by e11_pro_banshees0_1_entry/p0)
	(cs_enable_moving true)
	(sleep 150)
)

(script command_script cs_e11_scarab_main_gun_shoot
	(cs_shoot_point true e11_scarab_gunners/p0)
	(sleep 165)
)

(script command_script cs_e11_cov_banshees0_die
	(ai_kill ai_current_actor)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e11_pro_phantom0_0_retreat
	(or
		; Beaten up
		(<= (object_get_health (ai_vehicle_get e11_pro_phantom0_0/phantom0)) 0.05) 
		
		; Or the guns are all destroyed
		(>= (object_model_targets_destroyed (ai_vehicle_get e11_pro_phantom0_0/phantom0) "target_front") 3) 
	)
)

(script static boolean e11_pro_phantom0_1_retreat
	(or
		; Beaten up
		(<= (object_get_health (ai_vehicle_get e11_pro_phantom0_1/phantom0)) 0.05) 
		
		; Or the guns are all destroyed
		(>= (object_model_targets_destroyed (ai_vehicle_get e11_pro_phantom0_1/phantom0) "target_front") 3) 
	)
)

(script static short e11_pro_wraiths1_living_count
	(+ 
		(if (> (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_0/wraith)) 0)
			1
			0
		)
		(if (> (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_1/wraith)) 0)
			1
			0
		)
		(if (> (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_2/wraith)) 0)
			1
			0
		)
		(if (> (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_3/wraith)) 0)
			1
			0
		)
	)
)

(script static boolean e11_pro_wraiths1_weakened
	(<= (e11_pro_wraiths1_living_count) 2)
)

(script static boolean e11_door_blocked
	; The door is considered blocked if someone is running a command script through it
	(or
		(cs_command_script_queued e11_pro_ghosts0 cs_e11_ghost_door0_entry)
		(cs_command_script_queued e11_pro_spectres0 cs_e11_spectre_door0_entry)
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e11_pro_phantom1_main
	(sleep_until
		(and
			(not (objects_can_see_flag (players) e11_pro_phantom1_spawn 80.0))
			(<= (ai_living_count e11_pro_phantom0_0) 0) 
			(<= (ai_living_count e11_pro_wraith0_0) 0) 
		)
		30
	)
	
	; Load in the Wraiths
	(ai_place_in_vehicle e11_pro_wraith0_1 e11_pro_phantom0_1)
	(ai_braindead e11_pro_wraith0_1 true)
)

(script dormant e11_pro_phantom0_main
	; Wait for the player to be back in the canyon
	(sleep_until g_e11_door_open)
	(sleep_until
		(not (volume_test_objects tv_e11_outer_cove (players)))
		30
	)

	; Send it in
	(ai_place e11_pro_phantom0_0)
	
	; Load in the Wraiths
	(ai_place_in_vehicle e11_pro_wraith0_0 e11_pro_phantom0_0)
	(ai_braindead e11_pro_wraith0_0 true)
)

(script dormant e11_pro_banshees0_main
	; Wait until all but one of the Wraiths are dead
	(sleep_until (<= (e11_pro_wraiths1_living_count) 2))
	
	; Banshee respawner
	(sleep_until
		(begin
			; If the living count is depleted...
			(if
				(<= (ai_living_count e11_pro_banshees0) 0)
				
				; Until there are two...
				(sleep_until
					(begin
						; Is the player outside the cove? Spawn accordingly
						(if (volume_test_objects tv_e11_outer_cove (players))
							(ai_place e11_pro_banshees0_1 1)
							(ai_place e11_pro_banshees0_0 1)
						)
						
						; Two total
						(>= (ai_living_count e11_pro_banshees0) 2)
					)
					60
				)
			)
		
			; Limit number of Banshees that can spawn
			(>= (ai_spawn_count e11_pro_banshees0) 10)
		)
		450
	)
)
	
(script dormant e11_pro_spectres0_main
	; Wait until all but one of the Wraiths are dead, and the Banshees have been
	; savaged a bunch
	(sleep_until 
		(and
			(<= (e11_pro_wraiths1_living_count) 1)
			(> (ai_spawn_count e11_pro_banshees0) 6)
		)
	)
	
	; Ghost respawner
	(sleep_until
		(begin
			; If the living count is less than 1 and no player is near the door
			(if
				(and
					(< (ai_living_count e11_pro_spectres0) 2)
					(> (objects_distance_to_object (players) e11_door0) 50)
				)
				
				; Spawn one
				(begin
					; Wait till the door is clear
					(sleep_until (not (e11_door_blocked)) 5)
					(if (= (structure_bsp_index) 0) (ai_place e11_pro_spectres0))
				)
			)
		
			; Spawn at most 3 Spectres (with two crew members each)
			(>= (ai_spawn_count e11_pro_spectres0) 6)
		)
		150
	)
)

(script dormant e11_pro_ghosts0_main
	(sleep_until g_e11_door_open)

	; Wait until all of the Wraiths are dead
	(sleep_until (<= (e11_pro_wraiths1_living_count) 0))
	
	; Ghost respawner
	(sleep_until
		(begin
			; If the living count is less than 2 and no player is near the door
			(if
				(and
					(< (ai_living_count e11_pro_ghosts0) 3)
					(> (objects_distance_to_object (players) e11_door0) 50)
				)
				
				; Spawn one
				(begin
					; Wait till the door is clear
					(sleep_until (not (e11_door_blocked)) 5)
					(if (= (structure_bsp_index) 0) (ai_place e11_pro_ghosts0 1))
				)
			)
		
			; Spawn at most 16 Ghosts
			(>= (ai_spawn_count e11_pro_ghosts0) 16)
		)
		150
	)
)

(script dormant e11_pro_wraith_checkpoints
	(sleep_until (<= (e11_pro_wraiths1_living_count) 3) 61)
	(game_save)
	(sleep_until (<= (e11_pro_wraiths1_living_count) 2) 61)
	(game_save)
	(sleep_until (<= (e11_pro_wraiths1_living_count) 1) 61)
	(game_save)
	(sleep_until (<= (e11_pro_wraiths1_living_count) 0) 61)
	(game_save)
)

(script dormant e11_pro_wraith1_main
	(sleep_until (volume_test_objects tv_e11_pro_wraiths1_begin (players)) 15)

	; Place the Wraiths
;	(ai_place e11_pro_wraith1)
	
	; Wake the other scripts which depend on the Wraith living count
;	(wake e11_pro_ghosts0_main)
;	(wake e11_pro_spectres0_main)
	(wake e11_pro_wraith_checkpoints)

;*	This child grew out of my control, and so, I had to kill it
	; Yay for script driven LOD :\
	(sleep_until
		(begin
			; For each Wraith:
			; If the Wraith is alive...
			(if (> (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_0/wraith)) 0)
				; The Wraiths is alive. Is the player nearby?
				(if 
					(or
						; The living count is 2 or less
						(and
							(<= (ai_living_count e11_pro_wraith1) 2)
							(< (ai_spawn_count e11_pro_wraith1_0) 1)
						)
					
						; The player is close
						(and
							(> (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e11_pro_wraith1_0/wraith)) 0)
							(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e11_pro_wraith1_0/wraith)) 50)
						)
					)
					
					; The player is close. If there is no driver, create and load him
					(if (<= (ai_living_count e11_pro_wraith1_0/driver) 0)
						(begin
							(ai_place e11_pro_wraith1_0/driver)
							(ai_vehicle_enter_immediate e11_pro_wraith1_0/driver (ai_vehicle_get_from_starting_location e11_pro_wraith1_0/wraith))
						)
					)
					
					; The player is far. If there is a driver, erase him
					(if (> (ai_living_count e11_pro_wraith1_0/driver) 0)
						(ai_erase e11_pro_wraith1_0/driver)
					)
				)
			)
			
			(if (> (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_1/wraith)) 0)
				; The Wraiths is alive. Is the player nearby?
				(if 
					(or
						; The living count is 2 or less
						(and
							(<= (ai_living_count e11_pro_wraith1) 2)
							(< (ai_spawn_count e11_pro_wraith1_1) 1)
						)
					
						; The player is close
						(and
							(> (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e11_pro_wraith1_1/wraith)) 0)
							(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e11_pro_wraith1_1/wraith)) 50)
						)
					)
					
					; The player is close. If there is no driver, create and load him
					(if (<= (ai_living_count e11_pro_wraith1_1/driver) 0)
						(begin
							(ai_place e11_pro_wraith1_1/driver)
							(ai_vehicle_enter_immediate e11_pro_wraith1_1/driver (ai_vehicle_get_from_starting_location e11_pro_wraith1_1/wraith))
						)
					)
					
					; The player is far. If there is a driver, erase him
					(if (> (ai_living_count e11_pro_wraith1_1/driver) 0)
						(ai_erase e11_pro_wraith1_1/driver)
					) 
				)
			)
			
			(if (> (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_2/wraith)) 0)
				; The Wraiths is alive. Is the player nearby?
				(if 
					(or
						; The living count is 2 or less
						(and
							(<= (ai_living_count e11_pro_wraith1) 2)
							(< (ai_spawn_count e11_pro_wraith1_2) 1)
						)
					
						; The player is close
						(and
							(> (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e11_pro_wraith1_2/wraith)) 0)
							(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e11_pro_wraith1_2/wraith)) 50)
						)
					)
					
					; The player is close. If there is no driver, create and load him
					(if (<= (ai_living_count e11_pro_wraith1_2/driver) 0)
						(begin
							(ai_place e11_pro_wraith1_2/driver)
							(ai_vehicle_enter_immediate e11_pro_wraith1_2/driver (ai_vehicle_get_from_starting_location e11_pro_wraith1_2/wraith))
						)
					)
					
					; The player is far. If there is a driver, erase him
					(if (> (ai_living_count e11_pro_wraith1_2/driver) 0)
						(ai_erase e11_pro_wraith1_2/driver)
					) 
				)
			)
			
			(if (> (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_3/wraith)) 0)
				; The Wraiths is alive. Is the player nearby?
				(if 
					(or
						; The living count is 2 or less
						(and
							(<= (ai_living_count e11_pro_wraith1) 2)
							(< (ai_spawn_count e11_pro_wraith1_3) 1)
						)
					
						; The player is close
						(and
							(> (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e11_pro_wraith1_3/wraith)) 0)
							(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e11_pro_wraith1_3/wraith)) 50)
						)
					)
					
					; The player is close. If there is no driver, create and load him
					(if (<= (ai_living_count e11_pro_wraith1_3/driver) 0)
						(begin
							(ai_place e11_pro_wraith1_3/driver)
							(ai_vehicle_enter_immediate e11_pro_wraith1_3/driver (ai_vehicle_get_from_starting_location e11_pro_wraith1_3/wraith))
						)
					)
					
					; The player is far. If there is a driver, erase him
					(if (> (ai_living_count e11_pro_wraith1_3/driver) 0)
						(ai_erase e11_pro_wraith1_3/driver)
					) 
				)
			)
					
			; Loop until the Wraiths are all dead
			(and
				(<= (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_0/wraith)) 0)
				(<= (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_1/wraith)) 0)
				(<= (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_2/wraith)) 0)
				(<= (unit_get_health (ai_vehicle_get_from_starting_location e11_pro_wraith1_3/wraith)) 0)
			)
		)
		30
	)
	*;
	
	; Place two Wraiths
	(ai_place e11_pro_wraith1_0)
	(ai_place e11_pro_wraith1_1)
	
	; Sleep until they're dead
	(sleep_until (<= (ai_living_count e11_pro_wraith1) 0))
	
	; Start up the Phantom scripts
	(wake e11_pro_phantom0_main)
)

(script dormant e11_cov_banshees0_main
	; If the player has no vehicle at this point...
	(if (not (players_in_vehicle))
		(ai_place e11_cov_banshees0)
	)
)


;- Event Scripts ---------------------------------------------------------------

(script dormant e11_navpoint
	; Wait until the player is far away, or a timeout
	(sleep_until
		(> (objects_distance_to_flag (players) e11_exit_door) 185)
		60
		one_minute
	)
	
	; Create the nav point
	(activate_team_nav_point_flag default player e11_exit_door 0)	
)

(script dormant e11_navpoint_kill
	(sleep_until (volume_test_objects tv_e12_ledge (players)))
	(sleep_forever e11_navpoint)
	(deactivate_team_nav_point_flag player e11_exit_door)	
)


;- Scarab Scripts --------------------------------------------------------------

(global boolean g_e11_door_should_open false)
(script dormant e11_door_opening
	(sleep_until g_e11_door_should_open 10)
	(sleep 120)
	
	; Open the door
	(effect_new "effects\scenarios\solo\deltacontrolroom\scarab_attack_deltacontrol" e11_door_explosion)
	(object_destroy e11_exit_door)

	; Let everyone else know
	(set g_e11_door_open true)
	(sleep 30)
	
	; Nav point scripts
	(wake e11_navpoint)
	(wake e11_navpoint_kill)
)

(global boolean g_e11_player_warned false)
(global boolean g_e11_player_saw_door false)
(global short g_e11_shot_counter 0)
(script dormant e11_scarab_main
	(pvs_set_object scarab)
	
	; Start things
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_turn_22_left)
	(scarab_walk_front_turn_15_right)
	(scarab_walk_front_to_idle)
	
	; Door shooting sequence
	; Open the gun
	(scarab_gun_open_up)

	; Wait until the player is here
	(sleep_until
		(begin
			(scarab_idle_var0)
			(volume_test_objects tv_e11_outer_cove (players))
		)
		1
	)
	
	; Dialogue
	(print "johnson: stay clear of the door")
	(sleep (ai_play_line_on_object none 0840))
	(sleep_until (not (volume_test_objects tv_e11_exit_vicinity (players))) 10 45)
	
	; Warning sequence
	(if (volume_test_objects tv_e11_exit_vicinity (players))
		(begin
			(print "johnson: you trying to get killed?")
			(sleep (ai_play_line_on_object none 0860))
			(sleep_until (not (volume_test_objects tv_e11_exit_vicinity (players))) 10 60)
		)
	)
	(if (volume_test_objects tv_e11_exit_vicinity (players))
		(begin
			(print "johnson: What? Do I have to spell it out for you? Move!")
			(sleep (ai_play_line_on_object none 0870))
			(sleep_until (not (volume_test_objects tv_e11_exit_vicinity (players))) 10 60)

			(if (volume_test_objects tv_e11_exit_vicinity (players))
				; Start counting
				(begin
					(print "johnson: Listen, I'm gonna count to three.")
					(sleep (ai_play_line_on_object none 0880))
					(sleep_until (not (volume_test_objects tv_e11_exit_vicinity (players))) 10 30)
					
					; Player still there
					(if (volume_test_objects tv_e11_exit_vicinity (players))
						; 1...
						(begin
							(print "johnson: One...")
							(sleep (ai_play_line_on_object none 0890))
							(sleep_until (not (volume_test_objects tv_e11_exit_vicinity (players))) 10 45)
		
							; Player still there
							(if (volume_test_objects tv_e11_exit_vicinity (players))
								; 2...
								(begin
									(print "johnson: Two...")
									(sleep (ai_play_line_on_object none 0900))
									(sleep_until (not (volume_test_objects tv_e11_exit_vicinity (players))) 10 60)
									
									; Player still there
									(if (volume_test_objects tv_e11_exit_vicinity (players))
										; Blast away
										(begin
											(print "johnson: Don't say I didn't warn you!")
											(sleep (ai_play_line_on_object none 0910))
										)
						
										; Player moved clear
										(begin
											(sleep 20)
											(print "johnson: Good! Now stay put!")
											(sleep (ai_play_line_on_object none 0920))
											(set g_e11_player_warned true)
										)
									)
								)
				
								; Player moved clear
								(begin
									(sleep 20)
									(print "johnson: Good! Now stay put!")
									(sleep (ai_play_line_on_object none 0920))
									(set g_e11_player_warned true)
								)
							)
						)
		
						; Player moved clear
						(begin
							(sleep 20)
							(print "johnson: Good! Now stay put!")
							(sleep (ai_play_line_on_object none 0920))
							(set g_e11_player_warned true)
						)
					)
				)
				
				; Player moved clear
				(begin
					(sleep 25)
					(print "johnson: Good! Now stay put!")
					(sleep (ai_play_line_on_object none 0920))
					(set g_e11_player_warned true)
				)
			)
		)
	)
	
	; If the player is back in the trigger volume and was warned...
	(sleep 30)
	(if 
		(and
			g_e11_player_warned
			(volume_test_objects tv_e11_exit_vicinity (players))
		)
		
		; Yeah, that's funny
		(begin
			(print "johnson: Yeah, that's real funny. I'm still shooting.")
			(sleep (ai_play_line_on_object none 0930))
		)
		
		; Fire away
		(begin
			(print "johnson: Hey bastards, knock knock!")
			(sleep (ai_play_line_on_object none 0850))
		)
	)
	
	; Music
	(wake music_08b_07_start)
	(wake music_08b_08_start)

	; Firing loop--shoot at the door until it's open
	(wake e11_door_opening)
	(sleep_until
		(begin
			; Fire!
			(scarab_gun_fire_up)
			(cs_stack_command_script scarab_gunners/main_gunner cs_e11_scarab_main_gun_shoot)
			
			; Increment the shot counter
			(set g_e11_shot_counter (+ g_e11_shot_counter 1))
			
			; Check if the player is looking
			(if (objects_can_see_flag (players) e11_exit_door 25.0)
				(set g_e11_player_saw_door true)
			)
			
			; Should this blast open the door?
			; Loop until the shot counter hits 2 and the player has seen, or it hits 4
			(if
				(or
					(>= g_e11_shot_counter 4)
					(and
						g_e11_player_saw_door
						(>= g_e11_shot_counter 2)
					)
				)
				(set g_e11_door_should_open true)
			)
			
			; Idle while he's firing
			(scarab_idle_firing)
			
			; Loop until the door should be opened
			g_e11_door_should_open
		)
		1
	)
	
	; Johnson celebrates (I can't believe we didn't record a line for this)
	(scarab_gun_close_up)
	
	; Next encounter
	(wake e12_main)
	
	; Advance closer to cover the approach
	(scarab_idle_to_walk_front)
	(scarab_walk_front_var0)
	(scarab_walk_front_to_idle)
	
	; Turn askew
	(scarab_idle_turn_22_left)
	(scarab_idle_turn_22_left)
	
	; Clear the PVS
	(pvs_clear)
	
	; Idle loop
	(sleep_until
		(begin
			(scarab_idle_var0)
			
			; Forever!
			false
		)
		1
	)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e11_key
	(if (not (difficulty_legendary)) (sleep_forever))
	(object_create key)
	(sleep_until 
		(or
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	)
	(ice_cream_flavor_stock 8) ; Black eye
)

(script dormant e11_main
	(sleep_until (volume_test_objects tv_e11_main_begin (players)) 15)
	(set g_e11_started true)
	(game_save)
	(print "e11_main")
	(data_mine_set_mission_segment "e11_scarab_boardings")
	
	; Disable the kill volume at the bottom of the ledge
	(kill_volume_disable kill_e8_0)
	
	; Wake subsequent scripts
	; e12_main awakened by e11_scarab

	; Wake control scripts
	(wake e11_pro_banshees0_main)
	(wake e11_pro_wraith1_main)
	(wake e11_cov_banshees0_main)
	(wake e11_key)
	
	; Shut down
	(sleep_until (= (structure_bsp_index) 2))
	(sleep_forever e11_pro_wraith1_main)
	(sleep_forever e11_pro_banshees0_main)
	(sleep_forever e11_pro_phantom0_main)
	(sleep_forever e11_pro_phantom1_main)
	(sleep_forever e11_pro_ghosts0_main)	; REVIEW
	(sleep_forever e11_pro_spectres0_main)	; REVIEW
	(sleep_forever e11_pro_wraith_checkpoints)
	(ai_erase e11_pro)
	(ai_erase e11_cov)
	
	; Clean up
;	(sleep_until )
)


;= ENCOUNTER 9 ===========================================================================
;*
Riding through the canyon on the Scarab.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites

Marines
	e9_mars_inf0 - Marines riding on the Scarab

Prophets
	e9_pro_inf0 - Turrets on the latter ledges
	e9_pro_inf3 - Brutes dropped off from Phantoms
		_0 - First group, with e9_pro_phantom0
		_1 - Second group, with e9_pro_phantom1
	e9_pro_phantom0 - First of two Phantoms which attack the Scarab
	e9_pro_phantom1 - Second of two Phantoms which attack you
	e9_pro_spectres0 - A pair of Spectres which roam the canyon, looking for love
		(engage0) - First bend of the canyon
		(engage1) - Second bend
		(engage2) - End of the canyon, by the ledge

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e9_started false)			; Encounter has been activated?
(global boolean g_e9_pro_phantom0_unloaded false)	; Has the Phantom dropped its Brutes?
(global boolean g_e9_pro_phantom0_retreating false)	; Has the Phantom started its retreat?
(global boolean g_e9_pro_phantom1_retreating false)	; Has the Phantom started its retreat?

(global boolean g_e9_scarab_started false)	; Scarab started the e9 run
(global boolean g_e9_scarab_near_first_bend false)	; Near the first canyon bend
(global boolean g_e9_scarab_near_second_bend false)	; Near the second canyon bend
(global boolean g_e9_scarab_at_second_bend false)	; Stopped in the second canyon bend
(global boolean g_e9_scarab_stepping_down false)	; Scarab stepping down


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e9_pro_phantom0_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to_and_face e9_pro_phantom0_exit/p0 e9_pro_phantom0_exit/p1 1.0)
	(cs_fly_to_and_face e9_pro_phantom0_exit/p0_1 e9_pro_phantom0_exit/p1)
	(cs_vehicle_boost true)
	(cs_fly_by e9_pro_phantom0_exit/p1)
	(cs_fly_by e9_pro_phantom0_exit/p2)
	(ai_erase ai_current_squad)
)

(script command_script cs_e9_pro_phantom0_entry
	; Move in
	(cs_fly_to e9_pro_phantom0_entry/p0)
	(cs_fly_to e9_pro_phantom0_entry/p1)
	(cs_fly_to e9_pro_phantom0_entry/p2 1.0)

	; Wait for the Scarab to arrive
	(sleep_until g_e9_scarab_at_second_bend 15)
	
	; Move in to make the first drop
	(cs_fly_to_and_face scarab_air/dropship_p1 scarab_air/dropship_p1_facing)
	(cs_vehicle_speed 0.25)
	(sleep_until
		(begin
			(cs_fly_to_and_face scarab_air/dropship_p1 scarab_air/dropship_p1_facing 3)
			false
		)
		3
		60
	)
	
	; Drop
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_a")

	; Wait for a bit
	(sleep_until
		(begin
			(cs_fly_to_and_face scarab_air/dropship_p1 scarab_air/dropship_p1_facing 3)
			false
		)
		3
		300
	)
	
	; Announce that we're done unloading
	(set g_e9_pro_phantom0_unloaded true)
)

(script command_script cs_e9_pro_banshees0_entry
	(cs_vehicle_boost true)
	(sleep 120)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e9_pro_spectres0_main
	(sleep_until
		(or
			(volume_test_objects tv_e9_second_bend (players))
			g_e9_scarab_started
		)
		15
	)

	; Only place one
	(ai_place e9_pro_spectres0_0)

	; That stink is fear. I can smell it.
	(sleep 1)
	(ai_vehicle_reserve_seat (ai_vehicle_get e9_pro_spectres0_0/spectre0) "spectre_p_l" true)
	
	; Wait until the player is at the end or the count has been reduced
	(sleep_until
		(or
			(volume_test_objects tv_e9_second_bend (players))
			(<= (ai_living_count e9_pro_spectres0) 1)
		)
		15
	)
	
	; Place another two
	(ai_place e9_pro_spectres0_1)

	; That stink is fear. I can smell it.
	(sleep 1)
	(ai_vehicle_reserve_seat (ai_vehicle_get e9_pro_spectres0_1/starting_locations_0) "spectre_p_l" true)
)

(script dormant e9_pro_phantom0_main
	(sleep_until g_e9_scarab_near_second_bend 15)
	(ai_place e9_pro_phantom0)

	; When all guns are gone, or after a timeout...
	(sleep_until g_e9_pro_phantom0_unloaded)
	(sleep_until 
		(or
			(>= (object_model_targets_destroyed (ai_vehicle_get e9_pro_phantom0/phantom0) "target_front") 3) 
			(<= (object_get_health (ai_vehicle_get e9_pro_phantom0/phantom0)) 0.05) 
		)
		15
		450
	)
	
	; Signal the retreat
	(set g_e9_pro_phantom0_retreating true)
	(cs_run_command_script e9_pro_phantom0/phantom0 cs_e9_pro_phantom0_exit)
	
	; Johnson gets all smart alecky
	(sleep 150)
	(if
		(or
			(>= (object_model_targets_destroyed (ai_vehicle_get e9_pro_phantom0/phantom0) "target_front") 3) 
			(<= (object_get_health (ai_vehicle_get e9_pro_phantom0/phantom0)) 0.05) 
		)
		(begin
			(print "johnson: now I know why you have the fancy armor")
			(ai_play_line_on_object none 0690)
		)
	)
)

(script dormant e9_pro_banshees0_main
	(sleep_until g_e9_scarab_near_first_bend)

	; Spawner!
	(sleep_until
		(begin
			; Spawn more if appropriate
			(if
				(or
					; Living count reduced to 0
					(<= (ai_living_count e9_pro_banshees0) 0)
					
					; Living count reduced to 1, and the turrets are mostly dead
					(and
						(<= (ai_living_count e9_pro_banshees0) 1)
						(<= (ai_living_count e9_pro_inf0) 2)		
						(<= (ai_living_count e9_pro_spectres0) 0)		
					)
				)
				(ai_place e9_pro_banshees0 1)
			)
		
			; Loop until a limit is reached, or the player has moved on
			(or
				(>= (ai_spawn_count e9_pro_banshees0) 6)
				(volume_test_objects tv_e9_pro_banshees0_stop (players))
				g_e9_scarab_stepping_down
			)
		)
		60
	)
	
	; Move on
	(ai_migrate e9_pro_banshees0 e11_pro_banshees0_1)
)

(script dormant e9_pro_inf3_main
	; Wait for the first Phantom, and it load them up
	(sleep_until (> (ai_living_count e9_pro_phantom0) 0))
	(ai_place_in_vehicle e9_pro_inf3_0 e9_pro_phantom0)
)

(script dormant e9_pro_inf0_main
	(ai_place e9_pro_inf0)
)


;- Scarab Scripts --------------------------------------------------------------

(script dormant e9_scarab_navpoint
	(sleep_until
		(begin
			; If the player is close, deactivate
			(if (< (objects_distance_to_object (players) scarab) 40)
				(deactivate_team_nav_point_object player scarab)
			)
			
			; If he's far, activate
			(if (> (objects_distance_to_object (players) scarab) 60)
				(activate_team_nav_point_object default player scarab 10)	
			)
		
			; Until the door is opened
			g_e11_door_open
		)
		140
	)
	
	; Deactivate the point
	(deactivate_team_nav_point_object player scarab)
)

(script dormant e9_scarab_main
	(pvs_set_object scarab)

	; On normal, start up the nav point
	(if (difficulty_normal) (wake e9_scarab_navpoint))

	; Continue
	(set g_e9_scarab_started true)
	(scarab_idle_to_walk_front)
	(scarab_walk_front_turn_22_right)
	(scarab_walk_front_turn_15_right)
	(scarab_walk_front_turn_15_left)
	(scarab_walk_front_turn_15_left)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)

	; Come to a stop and turn
	(scarab_walk_front_to_idle)
	
	; Turn and move on
	(scarab_idle_turn_22_left)
	(scarab_idle_turn_45_left)
	(scarab_idle_turn_22_left)
	
	; Continue
	(scarab_idle_to_walk_front)
	(scarab_walk_front_var0)
	
	; Continue
	(set g_e9_scarab_near_first_bend true)
	(scarab_walk_front_turn_15_right)
	(scarab_walk_front_turn_15_right)
	(scarab_walk_front_turn_45_right)
	(scarab_walk_front_turn_45_right)
	(set g_e9_scarab_near_second_bend true)
	(scarab_walk_front_turn_15_right)
	(scarab_walk_front_turn_15_left)
	(scarab_walk_front_turn_22_left)
	
	; Continue
	(scarab_walk_front_turn_22_left)
	(scarab_walk_front_turn_45_left)
	
	; Come to a stop and turn as Phantoms attack
	(set g_e9_scarab_at_second_bend true)
	(scarab_walk_front_to_idle)
	(scarab_idle_turn_22_left)
	(scarab_idle_turn_22_left)
	(sleep_until
		(begin
			(scarab_idle_var0)
		
			; Phantom is retreating, and the Brutes are ousted
			(and
				true ;g_e9_pro_phantom0_retreating
				(not (volume_test_objects tv_scarab (ai_actors e9_pro_inf3)))
			)
		)
		1
	)

	; Continue to the lip
	(scarab_idle_to_walk_front)
	(scarab_walk_front_turn_15_left)
	(scarab_walk_front_turn_15_left)
	(scarab_walk_front_turn_22_right)
	
	; Moment of truth--step down
	(set g_e9_scarab_stepping_down true)
	(device_set_position_track scarab delta_canyon_step_down g_scarab_interpolation)
	(device_animate_position scarab 1.0 (/ 350.0 30.0) 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
	
	; Continue to the gateway
	(scarab_walk_front_turn_22_right)
	(scarab_walk_front_turn_15_left)
	(scarab_walk_front_var0)
	
	; Continue
	(wake e11_scarab_main)
)

(script static void e9_scarab_test
	(object_teleport scarab e9_scarab)
	(wake e9_scarab_main)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e9_main
	(sleep_until
		(or
			(volume_test_objects tv_e9_main_begin (players))
			g_e9_scarab_started
		)
		15
	)
	(set g_e9_started true)
	(game_save)
	(print "e9_main")
	(data_mine_set_mission_segment "e9_scarab_canyon")
	
	; Wake control scripts
	(wake e9_pro_inf0_main)
	(wake e9_pro_inf3_main)
	(wake e9_pro_spectres0_main)
;	(wake e9_pro_phantom0_main)
	(wake e9_pro_banshees0_main)
	
	; Condemn
	(sleep_until g_e11_started)
	(ai_disposable e9_pro true)

	; Shut down
	(sleep_until g_e12_started)
	(sleep_forever e9_pro_inf0_main)
	(sleep_forever e9_pro_inf3_main)
	(sleep_forever e9_pro_spectres0_main)
	(sleep_forever e9_pro_banshees0_main)
	
	; Clean up
;	(sleep_until )
)

(script static void test_scarab_canyon
	(object_teleport scarab e9_scarab)
	(wake e9_main)
	(sleep 1)
	(wake e9_main)
	(wake e11_main)
)


;= ENCOUNTER 8 ===========================================================================
;*
Riding through the cove and canyon on the Scarab.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e8_cov_inf0 - Covenant infantry on the Scarab
		(init) - Defending the deck

Marines
	e8_mars_inf0 - Marine infantry on the Scarab
		(init) - Defending the deck, closer to the door

Prophets
	e8_pro_wraiths0 - Wraiths on the ground, engaging the Scarab
		_0 - One of them
			(init) - Positions well protected from the Scarab
		_1 - Another
			(init) - Positions well protected from the Scarab
		_2 - You guessed it, a third
			(init) - Positions well protected from the Scarab

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e8_started false)			; Encounter has been activated?

(global boolean g_e8_cov_banshees0_greeted false)	; One of the Banshee pilots has greeted the player
(global short g_e8_mars_inf0_living_count 3)
(global short g_e8_target_wraith -1)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e8_pro_phantom0_exit
	; Move into engagement range
	(cs_fly_by e8_pro_phantom0_exit/p0)
	(cs_fly_by e8_pro_phantom0_exit/p1)
	(cs_fly_by e8_pro_phantom0_exit/p2)
	(ai_erase ai_current_squad)
)

(script command_script cs_e8_cov_banshee0_entry0
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	
	; Fly in
	(cs_vehicle_boost true)
	(sleep 80)
	(cs_fly_by e8_cov_banshees0_entry/p0_0)
	(cs_fly_by e8_cov_banshees0_entry/p0_1 15)
	(cs_vehicle_boost false)
	(cs_fly_to e8_cov_banshees0_entry/p0_1 2)
	
	; Exit and leave the banshee for the player
	(sleep 15)
	(ai_vehicle_exit ai_current_actor)
	(object_can_take_damage (ai_get_object ai_current_actor))
	(cs_ignore_obstacles false)
	(cs_face_player true)
	
	; Approach the player
	(sleep_until 
		(or
			(and
				(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
				(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)
			)
			g_e8_cov_banshees0_greeted
		)
	)
	
	; Greet him if we haven't already greeted
	(if (not g_e8_cov_banshees0_greeted)
		(begin
			(print "elite: take my banshee")
			(set g_e8_cov_banshees0_greeted true)
			(sleep (ai_play_line_at_player ai_current_actor 0800))
		)
	)
	
	; Wait until the player has moved away or is in the Banshee
	(sleep_until 
		(or
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 10)
			(players_in_vehicle)
		)
	)

	; Head on your way
	(cs_go_to e8_cov_banshees0_entry/exit0)

	; Wait until no players are near
	(sleep_until 
		(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 40)
	)
	(ai_erase ai_current_actor)
)

(script command_script cs_e8_cov_banshee0_entry1
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	
	; Fly in
	(cs_vehicle_boost true)
	(sleep 70)
	(cs_fly_by e8_cov_banshees0_entry/p1_0)
	(cs_fly_by e8_cov_banshees0_entry/p1_1 15)
	(cs_vehicle_boost false)
	(cs_fly_to e8_cov_banshees0_entry/p1_1 2)
	
	; Exit and leave the banshee for the player
	(sleep 15)
	(ai_vehicle_exit ai_current_actor)
	(object_can_take_damage (ai_get_object ai_current_actor))
	(cs_ignore_obstacles false)
	(cs_face_player true)
	
	; Approach the player
	(sleep_until 
		(or
			(and
				(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
				(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)
			)
			g_e8_cov_banshees0_greeted
		)
	)
	
	; Greet him if we haven't already greeted
	(if (not g_e8_cov_banshees0_greeted)
		(begin
			(print "elite: take my banshee")
			(set g_e8_cov_banshees0_greeted true)
			(sleep (ai_play_line_at_player ai_current_actor 0800))
		)
	)
	
	; Wait until the player has moved away or is in the Banshee
	(sleep_until 
		(or
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 10)
			(players_in_vehicle)
		)
	)

	; Head on your way
	(cs_go_to e8_cov_banshees0_entry/exit0)

	; Wait until no players are near
	(sleep_until 
		(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 40)
	)
	(ai_erase ai_current_actor)
)

(script command_script cs_e8_cov_banshee0_entry2
	(cs_ignore_obstacles true)
	(cs_enable_pathfinding_failsafe true)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	
	; Fly in
	(cs_vehicle_boost true)
	(sleep 70)
	(cs_fly_by e8_cov_banshees0_entry/p2_0)
	(cs_fly_by e8_cov_banshees0_entry/p2_1 15)
	(cs_vehicle_boost false)
	(cs_fly_to e8_cov_banshees0_entry/p2_1 2)
	
	; Exit and leave the banshee for the player
	(sleep 15)
	(ai_vehicle_exit ai_current_actor)
	(object_can_take_damage (ai_get_object ai_current_actor))
	(cs_ignore_obstacles false)
	(cs_face_player true)
	
	; Approach the player
	(sleep_until 
		(or
			(and
				(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 0)
				(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3)
			)
			g_e8_cov_banshees0_greeted
		)
	)
	
	; Greet him if we haven't already greeted
	(if (not g_e8_cov_banshees0_greeted)
		(begin
			(print "elite: take my banshee")
			(set g_e8_cov_banshees0_greeted true)
			(sleep (ai_play_line_at_player ai_current_actor 0800))
		)
	)
	
	; Wait until the player has moved away or is in the Banshee
	(sleep_until 
		(or
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 10)
			(players_in_vehicle)
		)
	)

	; Head on your way
	(cs_go_to e8_cov_banshees0_entry/exit1)

	; Wait until no players are near
	(sleep_until 
		(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 40)
	)
	(ai_erase ai_current_actor)
)

(script command_script cs_e8_cov_banshee0_flyby
	(cs_enable_pathfinding_failsafe true)
	(cs_ignore_obstacles true)
	(cs_vehicle_boost true)
	(sleep 100)
	(cs_fly_by e8_cov_banshees0_entry/p3)
	(cs_fly_by e8_cov_banshees0_entry/p4)
	(object_destroy (ai_vehicle_get ai_current_actor))
	(sleep 1)	
	(ai_erase ai_current_actor)	
)

(script command_script cs_e8_pro_wraith0_0_bombard
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_face_object true scarab)
	
	; Move into position, fire on the Scarab continuously
	(sleep_until
		(begin
			; Move into position
			(cs_go_to e8_pro_wraiths0_bombard/p0_0)
			
			; Fire on the Scarab
			(cs_shoot_point true scarab/target_right)

			; Until we're the target
			(sleep_until (= g_e8_target_wraith 0) 10)
			
			; Move back behind cover
			(cs_shoot_point false scarab/target_right)
			(cs_go_to e8_pro_wraiths0_bombard/p0_1)
			(sleep (random_range 180 210))
			
			; Loop forever
			false
		)
		1
	)
)

(script command_script cs_e8_pro_wraith0_1_bombard
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_face_object true scarab)
	
	; Move into position, fire on the Scarab continuously
	(sleep_until
		(begin
			; Move into position
			(cs_go_to e8_pro_wraiths0_bombard/p1_0)
			
			; Fire on the Scarab
			(cs_shoot_point true scarab/target_left)

			; Until we're the target
			(sleep_until (= g_e8_target_wraith 1) 10)
			
			; Move back behind cover
			(cs_shoot_point false scarab/target_left)
			(cs_go_to e8_pro_wraiths0_bombard/p1_1)
			(sleep (random_range 180 210))
			
			; Loop forever
			false
		)
		1
	)
)

(script command_script cs_e8_pro_wraith0_2_bombard
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_face_object true scarab)
	
	; Move into position, fire on the Scarab continuously
	(sleep_until
		(begin
			; Move into position
			(cs_go_to e8_pro_wraiths0_bombard/p2_0)
			
			; Fire on the Scarab
			(cs_shoot_point true scarab/target_left)

			; Until we're the target
			(sleep_until (= g_e8_target_wraith 2) 10)
			
			; Move back behind cover
			(cs_shoot_point false scarab/target_left)
			(cs_go_to e8_pro_wraiths0_bombard/p2_1)
			(sleep (random_range 180 210))
			
			; Loop forever
			false
		)
		1
	)
)

(script command_script cs_e8_scarab_main_gun_idle
	(sleep_forever)
)

(script command_script cs_e8_scarab_main_gun_shoot0
	(cs_shoot_point true e8_scarab_gunners/p0)
	(sleep 75)
	(if (volume_test_objects tv_e8_scarab_fire_unsafe (players))
		(begin
			(scarab_gun_fire_down_abort)
			(cs_shoot_point false e8_scarab_gunners/p0)
		)
	)
	(sleep 90)
)

(script command_script cs_e8_scarab_main_gun_shoot1
	(cs_shoot_point true e8_scarab_gunners/p1)
	(sleep 75)
	(if (volume_test_objects tv_e8_scarab_fire_unsafe (players))
		(begin
			(scarab_gun_fire_down_abort)
			(cs_shoot_point false e8_scarab_gunners/p1)
		)
	)
	(sleep 90)
)

(script command_script cs_e8_scarab_main_gun_shoot2
	(cs_shoot_point true e8_scarab_gunners/p2)
	(sleep 75)
	(if (volume_test_objects tv_e8_scarab_fire_unsafe (players))
		(begin
			(scarab_gun_fire_down_abort)
			(cs_shoot_point false e8_scarab_gunners/p2)
		)
	)
	(sleep 90)
)

(script command_script cs_e8_mars_johnson_init
	(cs_enable_dialogue true)
	
	; Cannot die! And pretty too!
	(object_cannot_die (ai_get_object ai_current_actor) true)
	(object_cinematic_lod (ai_get_object ai_current_actor) true)

	; Load him
	(ai_vehicle_enter_immediate ai_current_actor (unit (object_at_marker scarab "scarab_d_l")) "scarab_d_r")
	
	; Idle
	(cs_look_player true)
	(sleep_forever)
)

(script command_script cs_e8_mars_inf0_emerge
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to scarab/p2)
)

(script command_script cs_e8_mars_inf0_retreat
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to scarab/p0)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e8_scarab_main
	(pvs_set_object scarab)
;	(object_teleport scarab e8_scarab)
	
	(print "Hide main gunner")
	(object_hide (object_at_marker scarab "primary_trigger") true)
	
	; Back it out
	(device_set_position_track scarab delta_ledge_exit 0)
	(device_animate_position scarab 1.0 (/ 1.0 30.0) 0 0 true)
	(sleep 3)
	
	; Place the door
	(object_create scarab_door)
	(objects_attach scarab "plasma_door" scarab_door "")

	; Load up the gunners
	(ai_place scarab_gunners/main_gunner)
	(vehicle_load_magic (unit (object_at_marker scarab "primary_trigger")) "scarab_turret_d" (ai_get_object scarab_gunners/main_gunner))
;	(vehicle_load_magic (unit (object_at_marker scarab "t_f_turret")) "scarab_turret_d" (ai_get_object scarab_gunners/upper_gunner))
;	(vehicle_load_magic (unit (object_at_marker scarab "t_b_turret")) "scarab_turret_d" (ai_get_object scarab_gunners/rear_gunner))
	(cs_run_command_script scarab_gunners/main_gunner cs_e8_scarab_main_gun_idle)

	; Turn towards the canyon
	(scarab_idle_var0)
	(scarab_idle_turn_22_right_slow)
	(scarab_idle_turn_45_right_slow)

	; Open up the gun
	(scarab_idle_turn_22_right_slow)
	(scarab_gun_open_down)
	(scarab_idle_turn_15_right_slow)

	; First shot
	(set g_e8_target_wraith 1)
	(scarab_idle_to_twist_5_left)
	(scarab_gun_fire_down)
	(cs_stack_command_script scarab_gunners/main_gunner cs_e8_scarab_main_gun_shoot1)
	(scarab_twist_5_left_firing)
			
	; Fire at the Wraiths until they're dead, most likely by the player's help
	(sleep_until
		(begin
			(begin_random
				; Fire at Wraith0
				(if (> (ai_living_count e8_pro_wraiths0_0) 0)
					(begin						
						; Turn to the right if necessary
						(if (not (= g_e8_target_wraith 0))
							(begin
								(scarab_twist_5_left_to_idle)
								(scarab_idle_to_twist_5_right)
							)
							
							; If it's not necessary, then just pause
							(begin
								(scarab_twist_5_right)
							)
						)
						
						; Call the target
						(set g_e8_target_wraith 0)
						
						; Fire!
						(if (not (volume_test_objects tv_e8_scarab_fire_unsafe (players)))
							(begin
								(scarab_gun_fire_down)
								(cs_stack_command_script scarab_gunners/main_gunner cs_e8_scarab_main_gun_shoot0)
								(scarab_twist_5_right_firing)
							)
						)
					)
				)
				
				; Fire at Wraith1
				(if (> (ai_living_count e8_pro_wraiths0_1) 0)
					(begin						
						; Turn to the left if necessary
						(if (= g_e8_target_wraith 0)
							(begin
								(scarab_twist_5_right_to_idle)
								(scarab_idle_to_twist_5_left)
							)
							
							; If it's not necessary, then just pause
							(begin
								(scarab_twist_5_left)
							)
						)
						
						; Call the target
						(set g_e8_target_wraith 1)
						
						; Fire!
						(if (not (volume_test_objects tv_e8_scarab_fire_unsafe (players)))
							(begin
								(scarab_gun_fire_down)
								(cs_stack_command_script scarab_gunners/main_gunner cs_e8_scarab_main_gun_shoot1)
								(scarab_twist_5_left_firing)
							)
						)
					)
				)
				
				; Fire at Wraith2
				(if (> (ai_living_count e8_pro_wraiths0_2) 0)
					(begin						
						; Turn to the left if necessary
						(if (= g_e8_target_wraith 0)
							(begin
								(scarab_twist_5_right_to_idle)
								(scarab_idle_to_twist_5_left)
							)
							
							; If it's not necessary, then just pause
							(begin
								(scarab_twist_5_left)
							)
						)
						
						; Call the target
						(set g_e8_target_wraith 2)
						
						; Fire!
						(if (not (volume_test_objects tv_e8_scarab_fire_unsafe (players)))
							(begin
								(scarab_gun_fire_down)
								(cs_stack_command_script scarab_gunners/main_gunner cs_e8_scarab_main_gun_shoot2)
								(scarab_twist_5_left_firing)
							)
						)
					)
				)
			)

			; The Wraiths are dead
			(<= (ai_living_count e8_pro_wraiths0) 0)
		)
		1
	)
	
	; Close the gun
	(scarab_gun_close_down)
;	(scarab_idle_var0)
	
	; Twist back straight
	(if (= g_e8_target_wraith 0)
		(scarab_twist_5_right_to_idle)
		(scarab_twist_5_left_to_idle)
	)	
	
	; Turn into place
	(scarab_idle_turn_15_left)
	
	; Move on
	(wake e9_scarab_main)
)


(script dormant e8_wraith_dialogue
	; Sleep until one of them is dead
	(sleep_until (<= (ai_living_count e8_pro_wraiths0) 2))
	(sleep 30)
	(print "johnson: hah, how do YOU like it?")
	(ai_play_line_on_object none 0660)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e8_pro_wraiths0_main
	; Wait until the player is in vehicle or near the exit
	(sleep_until
		(or
			(players_in_vehicle)
			(volume_test_objects tv_e8_exit (players))
		)
		30
		450
	)
	
	; Place the Wraiths, our erstwhile adversaries
	(ai_place e8_pro_wraiths0)
	
	; Dialogue thread
	(wake e8_wraith_dialogue)
	
	; Go into bombardment mode
	(sleep_until
		(begin
			; If combat status for a Wraith has fallen, go into bombardment
			(if 
				(and
					(<= (ai_combat_status e8_pro_wraiths0_0) ai_combat_status_active)
					(not (cs_command_script_queued e8_pro_wraiths0_0 cs_e8_pro_wraith0_0_bombard))
				)
				(begin
					(print "wraith0 bombard")
					(cs_run_command_script e8_pro_wraiths0_0 cs_e8_pro_wraith0_0_bombard)
				)
			)
			
			; Wraith 1
			(if 
				(and
					(<= (ai_combat_status e8_pro_wraiths0_1) ai_combat_status_active)
					(not (cs_command_script_queued e8_pro_wraiths0_1 cs_e8_pro_wraith0_1_bombard))
				)
				(begin
					(print "wraith1 bombard")
					(cs_run_command_script e8_pro_wraiths0_1 cs_e8_pro_wraith0_1_bombard)
				)
			)

			; Wraith 2
			(if 
				(and
					(<= (ai_combat_status e8_pro_wraiths0_2) ai_combat_status_active)
					(not (cs_command_script_queued e8_pro_wraiths0_2 cs_e8_pro_wraith0_2_bombard))
				)
				(begin
					(print "wraith2 bombard")
					(cs_run_command_script e8_pro_wraiths0_2 cs_e8_pro_wraith0_2_bombard)
				)
			)

			; The Wraiths are dead
			(<= (ai_living_count e8_pro_wraiths0) 0)
		)
	)
	
	; Checkpoint
	(sleep 60)
	(game_save)
)

(script dormant e8_cov_banshees0_main
;	(ai_place e8_cov_banshees0/banshee3)
;	(sleep 30)
	(ai_place e8_cov_banshees0/banshee1)
	(sleep 60)
	(ai_place e8_cov_banshees0/banshee0)
	(sleep 90)
	(ai_place e8_cov_banshees0/banshee2)
;	(ai_place e8_cov_banshees0/banshee4)

	; Wait until the player is in a Banshee
	(sleep_until
		(or
			(players_in_vehicle)
			(volume_test_objects tv_e8_exit (players))
		)
	)
	(wake music_08b_06_start)
	
	; Bestow upon the unworthy player a checkpoint
	(game_save)
)

(script static boolean e8_mars_inf0_should_activate
	(or
		(volume_test_objects tv_scarab (players))
	
		; The Marines and their DEADLY ENEMIES!
		(volume_test_objects tv_scarab (ai_actors e9_pro_inf3))
	)
)

(script dormant e8_mars_inf0_main
	(sleep 30)
	(ai_place e8_mars_inf0)

	; Loop de loop
	(sleep_until 
		(begin
			; If a player is on the Scarab...
			(if (e8_mars_inf0_should_activate)
				; He is
				(begin
					; If there are no Marines...
					(if (<= (ai_living_count e8_mars_inf0) 0)
						; Spawn some
						(ai_place e8_mars_inf0 g_e8_mars_inf0_living_count)
						
						; Otherwise, just send them out
						(begin
							(cs_run_command_script e8_mars_inf0 cs_e8_mars_inf0_emerge)
							(cs_run_command_script e8_mars_inf0/johnson cs_e8_mars_johnson_init)
						)
					)

					; And wait until no players are on the Scarab
					(sleep_until (not (e8_mars_inf0_should_activate)))
				)
				
				; If he's not, and there are Marines...
				(if (> (ai_living_count e8_mars_inf0) 0)
					(begin
						; Store their number
						(set g_e8_mars_inf0_living_count (ai_living_count e8_mars_inf0))
						
						; And send them back inside
						(cs_run_command_script e8_mars_inf0 cs_e8_mars_inf0_retreat)
						
						; Wait until they're all inside, or the player is back...
						(sleep_until
							(or
								(e8_mars_inf0_should_activate)
								(volume_test_objects_all tv_scarab_interior (ai_actors e8_mars_inf0))
							)
						)
						
						; Erase them, if the player isn't here...
						(if (not (e8_mars_inf0_should_activate)) 
							(ai_erase e8_mars_inf0)
						)
					)
				)
			)
			
			; Loop forever
			false
		)
	)
)

(script dormant e8_cov_inf0_main
;	(ai_migrate e7_cov_inf0 e8_cov_inf0)
	(sleep 1)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e8_main
	(set g_e8_started true)
	(game_save)
	(print "e8_main")
	(data_mine_set_mission_segment "e8_scarab_cove")
	
	; Disable the kill volume at the bottom of the ledge
	(kill_volume_disable kill_e8_0)
	
	; Update objectives
	(wake objective1_clear)
	(wake objective2_set)
	
	; Wake subsequent scripts
	(wake e9_main)
	(wake e11_main)
	
	; Place the spare banshees
	(object_create e8_banshee0)
	(object_create e8_banshee1)

	; Wake control scripts
	(wake e8_cov_inf0_main)
	(wake e8_cov_banshees0_main)
;	(wake e8_mars_inf0_main)
	(wake e8_pro_wraiths0_main)
	(wake e8_scarab_main)
	
	; Condemn
	(sleep_until g_e9_started)
	(ai_disposable e8_cov true)

	; Shut down
;	(sleep_until )
	
	; Clean up
;	(sleep_until )
)

(script static void test_scarab_ride
	(object_teleport scarab e8_scarab)
	(if (not g_e8_started) (wake e8_main))
)

(script dormant scarab_test_loop
	(sleep_until
		(begin
			; e8
			(object_create_anew scarab)
			(pvs_set_object scarab)
		
;			(device_set_position_track scarab delta_ledge_wait 0)

			; Exit
			(device_set_position_track scarab delta_ledge_exit 0)
			(device_animate_position scarab 1.0 (/ 90.0 30.0) 0 0 true)
			(sleep_until (>= (device_get_position scarab) 1.0) 1)

			; Come to a stop, then turn
			(scarab_idle_var0)
			(scarab_idle_turn_22_right)
			(scarab_idle_turn_45_right)
			(scarab_idle_turn_22_right)
			
			; Idle for a bit longer as Phantoms attack
			(scarab_idle_var0)				
			
			; Continue
			(scarab_idle_to_walk_front)
			(scarab_walk_front_turn_22_right)
			(scarab_walk_front_turn_15_right)
			(scarab_walk_front_turn_15_left)
			(scarab_walk_front_turn_15_left)
			(scarab_walk_front_var0)
			(scarab_walk_front_var0)
		
			; Come to a stop and turn
			(scarab_walk_front_to_idle)
			
			; e9
			; Turn and move on
			(scarab_idle_turn_22_left)
			(scarab_idle_turn_45_left)
			(scarab_idle_turn_22_left)
			
			; Continue
			(scarab_idle_to_walk_front)
			(scarab_walk_front_var0)
						
			; Continue
			(scarab_walk_front_turn_15_right)
			(scarab_walk_front_turn_15_right)
			(scarab_walk_front_turn_45_right)
			(scarab_walk_front_turn_45_right)
			(scarab_walk_front_turn_15_right)
			(scarab_walk_front_turn_15_left)
			(scarab_walk_front_turn_22_left)
			
			; Continue
			(scarab_walk_front_turn_22_left)
			(scarab_walk_front_turn_45_left)
			
			; Come to a stop and turn as Phantoms attack
			(scarab_walk_front_to_idle)
			(scarab_idle_turn_22_left)
			(scarab_idle_turn_22_left)
			(scarab_idle_var0)				

			; Continue to the lip
			(scarab_idle_to_walk_front)
			(scarab_walk_front_turn_15_left)
			(scarab_walk_front_turn_15_left)
			(scarab_walk_front_turn_22_right)
		
			; Moment of truth--step down
			(device_set_position_track scarab delta_canyon_step_down 0)
			(device_animate_position scarab 1.0 (/ 350.0 30.0) 0 0 true)
			(sleep_until (>= (device_get_position scarab) 1.0) 1)
			(scarab_walk_front_var0)
		
			; loop forever
			false
		)
		1
	)
)


;= ENCOUNTER 7 ===========================================================================
;*
The ledge where several Brutes are guarding Johnson and his Marines.

Elites
	e7_cov_inf0 - Elites from previous encounters
		(init) - Wait for the Dervish
		(engage0) - Engage the Brutes
	e7_cov_hunters0 - Hunters from previous encounters
		(init) - Wait for the Dervish
		(engage0) - Engage the Brutes

Prophets
	e7_pro_inf0 - The Brute captain and his entourage
		(init) - Fighting back against the Elites

Marines
	e7_mars_inf0 - Johnson and his Marines
		(init) - Hauling ass onto the Scarab

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e7_started false)			; Encounter has been activated?

(global boolean g_e7_mars_johnson_go false)
(global boolean g_e7_mars_johnson_aboard false)
(global boolean g_e7_pro_captain_done false)
(global boolean g_e7_pro_sentry_alerted false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e7_mars_inf0_wait
	(ai_disregard (ai_get_object ai_current_actor) true)
	(custom_animation_loop (ai_get_unit ai_current_actor) "objects\characters\marine\deltacontrol\deltacontrol" "kneel_unarmed" false)	

	; Wait for it...
	(sleep_until g_e7_mars_johnson_go 3)
	(sleep 15)
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\marine\deltacontrol\deltacontrol" "kneel_to_idle_pistol" false)	
	(cs_enable_moving true)
	(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
	(ai_disregard (ai_get_object ai_current_actor) false)
)

(script command_script cs_e7_mars_inf0_johnson
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(unit_impervious (ai_get_unit ai_current_actor) true)
	(ai_disregard (ai_get_object ai_current_actor) true)
	(cs_enable_pathfinding_failsafe true)
	(custom_animation_relative_loop (ai_get_unit ai_current_actor) "objects\characters\marine\deltacontrol\deltacontrol" "kneel_unarmed_johnson" false anchor_intra2)	
	
	; Rouse the others
	(sleep_until g_e7_mars_johnson_go 3)
	(print "johnson: go go go!")
	(ai_play_line ai_current_actor 3000)
	
	; Climb onto the gun
	(custom_animation_relative (ai_get_unit ai_current_actor) "objects\characters\marine\deltacontrol\deltacontrol" "kneel_2_scarab" false anchor_intra2)	
	(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
	(set g_e7_mars_johnson_aboard true)

	; Cruise on in
	(cs_go_to scarab/p0)
;	(ai_erase ai_current_actor)
)

(script command_script cs_e7_pro_inf0_wait
	(sleep_until (> (device_get_position e7_door0) 0) 5)

	; Begin
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_abort_on_damage true)
	
	; Look at Johnson
	(cs_look_object true (ai_get_object e7_mars_inf0/johnson0))

	; Until the sentry is alerted
	(sleep_until g_e7_pro_sentry_alerted 10)
	
	; Magical sight
	(ai_magically_see_object ai_current_squad (player0))
	(cs_force_combat_status 4)
)

(script command_script cs_e7_pro_inf0_captain_alert
	; Look at the player
	(cs_aim_player true)
	(sleep 20)
	(print "cpn: elites!")
	(sleep (ai_play_line ai_current_actor 0400))
	(set g_e7_mars_johnson_go true)
	(object_cannot_die (ai_get_object ai_current_actor) false)
)

(script command_script cs_e7_pro_inf0_captain
	; Queue up the alert script
	(cs_queue_command_script ai_current_actor cs_e7_pro_inf0_captain_alert)

	; Wait for the door
	(sleep_until (> (device_get_position e7_door0) 0) 5)

	; Begin
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_abort_on_damage true)
	(object_cannot_die (ai_get_object ai_current_actor) true)
	
	; Tartarus' line
	(print "tar: mine will do. kill the others.")
	(sleep (ai_play_line_on_object none 0050))
	(sleep 20)
	
	; Brute lines
	(print "cpn: yes chieftan.")
	(sleep (ai_play_line ai_current_actor 0060))
	
	; Look at Johnson
	(cs_look_object true (ai_get_object e7_mars_inf0/johnson0))
	(sleep 20)
	
	; Line
	(print "cpn: A day's rations says I do this in one cut.")
	(sleep (ai_play_line ai_current_actor 0070))
	(cs_start_to e7_pro_inf0_sentry/p1) ; Lazy
	(sleep 20)
	
	; Start the sentry
	(set g_e7_pro_captain_done true)
	
	; Other Brute's line
	(print "guard: two cuts, at least")
	(sleep (ai_play_line e7_pro_inf0/guard0 0090))
	(sleep 20)
	
	; Line
	(print "cpn: Done!")
	(sleep (ai_play_line ai_current_actor 0100))
	(sleep_until g_e7_pro_sentry_alerted 10)
	
	; Magical sight
	(ai_magically_see_object ai_current_squad (player0))
	(cs_force_combat_status 4)
)

(script command_script cs_e7_pro_inf0_sentry0_alerted
	(print "sentry: wait, movement!")
	(sleep (ai_play_line ai_current_actor 0110))
	(set g_e7_pro_sentry_alerted true)
	
	; Magical sight
	(ai_magically_see_object ai_current_squad (player0))
	(cs_force_combat_status 4)
)

(script command_script cs_e7_pro_inf0_sentry0
	(cs_abort_on_damage true)
	
	; Wait for it...
	(sleep_until
		(or
			g_e7_pro_captain_done
			(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 5)
		)
		10
	)
	
	; Look...
	(cs_look true e7_pro_inf0_sentry/look0)
	(sleep 45)
	(cs_face true e7_pro_inf0_sentry/look1)
	(sleep 60)
	
	; Queue up the movement
	(cs_queue_command_script ai_current_actor cs_e7_pro_inf0_sentry0_alerted)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e7_mars_inf0_main
	(ai_place e7_mars_inf0)
	
	; Wait for the alarm to be raised
	(sleep_until 
		(volume_test_objects tv_e7_on_ledge (players))
		3
	)

	; Force things
	(set g_e7_pro_sentry_alerted true)
	(set g_e7_mars_johnson_go true)
)

(script dormant e7_pro_inf0_main
	(ai_place e7_pro_inf0)
	(ai_prefer_target (ai_actors e7_cov) true)
)

(script dormant e7_cov_hunters0_main
	
	(sleep 1)
)

(script dormant e7_cov_inf0_main
	; Rather do this elsewhere, but...
	(ai_migrate e6_cov_hunters0 e7_cov_hunters0)

	; Migrate x individuals
	(sleep_until
		(begin
			; If the source squad is depleted or the dest squad is full...
			(if
				(<= (ai_living_count e6_cov) 0)

				; Bail out if this condition is true, by returning true
				(= 1 1)
				
				; Otherwise...
				(begin
					; If there's still room, migrate an actor
					(if (< (ai_living_count e7_cov_inf0) 2)
						(begin
							(print "migrated an actor")
							(ai_migrate (object_get_ai (list_get (ai_actors e6_cov) 0)) e7_cov_inf0)
						)
					)
					
					; And return false
					(= 1 0)
				)
			)
		)
	)
)


;- Scarab Scripts --------------------------------------------------------------

(global short g_e7_mars_living_count 0)
(script startup e7_scarab_main
	(pvs_set_object scarab)

	; Set the Scarab into its position, then go to sleep
	(device_set_position_track scarab delta_ledge_idle 0)
	(device_animate_position scarab 1.0 2 0 0 true)
	(pvs_clear)

	; Wait for Johnson to make his move
	(sleep_until g_e7_mars_johnson_aboard 2)
	
	; Activate the PVS
	(pvs_set_object scarab)

	; Rear back
	(device_set_position_track scarab delta_ledge_rear_back 0)
	(device_animate_position scarab 1.0 (/ 70.0 30.0) 0 0 true)
	(sleep_until (>= (device_get_position scarab) 1.0) 1)
	
	; Idle
	(sleep_until
		(begin
			(device_set_position_track scarab delta_ledge_rear_idle 0)
			(device_animate_position scarab 1.0 (/ 120.0 30.0) 0 0 true)
			(sleep_until (>= (device_get_position scarab) 1.0) 1)
		
			; Wait for the Brutes to be dead and the game to be safe
			(and
				(= (structure_bsp_index) 0)
				(not (volume_test_objects tv_e7_brute_area (ai_actors e7_pro_inf0)))
				(game_safe_to_save)
			)
		)
		5
	)
	
	; Fade out for cinematic
	(cinematic_fade_to_white)

	; Remove the Marines
	(ai_erase e7_mars)

	; Hide the Scarab
	(object_destroy scarab)
	
	; Stash the players
	(object_teleport (player0) player0_e8_stash)
	(object_teleport (player1) player1_e8_stash)
	(object_cannot_take_damage (players))
	(object_hide (player0) true)
	(object_hide (player1) true)

	; Run the cinematic
	(cinematic_johnson_ledge)
	
	; For Mat and Co.
	(sound_suppress_ambience_update_on_revert)
	(sound_class_set_gain amb 0 0)
	(sleep 1)
	(sound_class_set_gain amb 1 15)

	; Restore the players
	(object_teleport (player0) player0_e8_start)
	(object_teleport (player1) player1_e8_start)
	(object_can_take_damage (players))
	(object_hide (player0) false)
	(object_hide (player1) false)

	; Restore the Scarab
	(object_create scarab)
	(pvs_set_object scarab)
	(device_set_position_track scarab delta_ledge_idle 0)
	
	; And continue
	(wake e8_main)

	; Fade in
	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white_bars)
	
	; Chapter title
	(wake chapter_title1)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e7_main
	(sleep_until 
		(and
			(= (structure_bsp_index) 0) 
			(volume_test_objects tv_e7_main_begin (players)) 
		)
		15
	)
	(set g_e7_started true)
	(game_save)
	(print "e7_main")
	(data_mine_set_mission_segment "e7_scarab_ledge")
	
	; Shut down the weather
	(weather_stop 0)
	
	; Unlock the door
	(device_operates_automatically_set e7_door0 true)
	
	; Music
	(wake music_08b_05_stop)
	
	; Wake subsequent scripts
	; e8_main woken by e7_scarab_main

	; Wake control scripts
	(wake e7_cov_inf0_main)
	(wake e7_cov_hunters0_main)
	(wake e7_pro_inf0_main)
	(wake e7_mars_inf0_main)
	
	; Condemn
	(sleep_until g_e8_started)
	(ai_disposable e7_cov true)
	(ai_disposable e7_pro true)
	
	; Shut down
	(sleep_until g_e9_started)
	(sleep_forever e7_cov_inf0_main)
	(sleep_forever e7_cov_hunters0_main)
	(sleep_forever e7_pro_inf0_main)
	(sleep_forever e7_mars_inf0_main)

	; Clean up
;	(sleep_until )
)

(script static void test_scarab_boarding
	(object_teleport (player0) e7_test)
	(ai_place e7_cov_inf0)
	(ai_place e7_cov_hunters0)
	(if (not g_e7_started) (wake e7_main))
)


;= ENCOUNTER 6 ===========================================================================
;*
A room where Elites and Hunters are imprisoned, waiting for you to free them.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e6_cov_inf0 - e5_cov_inf0, Elite allies
		(init) - Waiting in the elbow room
		(advance0) - Creeping into the Hunter room
		(engage0) - Engaging the jailors
		(follow) - Follow the Dervish
	e6_cov_inf1 - Imprisoned Elites
		_0 - Elite in first cell
		_1 - Elite in second cell
		_2 - Two Elites in a corner cell
		_3 - A zealot in the third cell
	e6_cov_hunters0 - e5_cov_hunters0, or imprisoned Hunter allies
		(init) - Waiting in the Elbow room
		(advance0) - Walking up to the entrance of the Hunter room
		(engage0) - Engage the jailors from the entrance
		(engage1) - Engage the jailors from the right side (if freed)
		(follow) - Follow the Dervish

Prophets
	e6_pro_inf0 - Jailors
		_0 - A group of Brutes
		_1 - Jackals on the upper level
		_2 - Brute reinforcements from the door
			(init) - Engaging in the room
			(retreat) - Regroup back by the door

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e6_started false)			; Encounter has been activated?


;- Order Scripts ---------------------------------------------------------------

(script static boolean e6_room_cleared
	(and
		(<= (ai_living_count e6_pro) 0)
;		(< (object_get_health e6_jail_shield0) 0)
		(< (object_get_health e6_jail_shield1) 0)
		(< (object_get_health e6_jail_shield2) 0)
;		(< (object_get_health e6_jail_shield3) 0)
		(< (object_get_health e6_jail_shield4) 0)
;		(< (object_get_health e6_jail_shield5) 0)
	)
)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e6_destroy_door0
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_certain)

	; Go to and wreck the door
	(if (>= (object_get_health e6_jail_shield0) 0) 
		(begin 
			(cs_start_to cs_e6_hunter_room/near_shield0)
			(sleep_until
				(or
					(not (cs_moving))
					(< (object_get_health e6_jail_shield0) 0)
				)
				15
			)
			(if (>= (object_get_health e6_jail_shield0) 0) (cs_shoot_point true cs_e6_hunter_room/shield0))
			(sleep_until (< (object_get_health e6_jail_shield0) 0) 15 150)
			(cs_shoot_point false cs_e6_hunter_room/shield0)
		)
	)
)

(script command_script cs_e6_destroy_door1
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_certain)

	; Go to and wreck the door
	(if (>= (object_get_health e6_jail_shield1) 0) 
		(begin 
			(cs_start_to cs_e6_hunter_room/near_shield1)
			(sleep_until
				(or
					(not (cs_moving))
					(< (object_get_health e6_jail_shield1) 0)
				)
				15
			)
			(if (>= (object_get_health e6_jail_shield1) 0) (cs_shoot_point true cs_e6_hunter_room/shield1))
			(sleep_until (< (object_get_health e6_jail_shield1) 0) 15 150)
			(cs_shoot_point false cs_e6_hunter_room/shield1)
		)
	)
)

(script command_script cs_e6_destroy_door2
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_certain)

	; Go to and wreck the door
	(if (>= (object_get_health e6_jail_shield2) 0) 
		(begin 
			(cs_start_to cs_e6_hunter_room/near_shield2)
			(sleep_until
				(or
					(not (cs_moving))
					(< (object_get_health e6_jail_shield2) 0)
				)
				15
			)
			(if (>= (object_get_health e6_jail_shield2) 0) (cs_shoot_point true cs_e6_hunter_room/shield2))
			(sleep_until (< (object_get_health e6_jail_shield2) 0) 15 150)
			(cs_shoot_point false cs_e6_hunter_room/shield2)
		)
	)
)

(script command_script cs_e6_destroy_door3
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_certain)

	; Go to and wreck the door
	(if (>= (object_get_health e6_jail_shield3) 0) 
		(begin 
			(cs_start_to cs_e6_hunter_room/near_shield3)
			(sleep_until
				(or
					(not (cs_moving))
					(< (object_get_health e6_jail_shield3) 0)
				)
				15
			)
			(if (>= (object_get_health e6_jail_shield3) 0) (cs_shoot_point true cs_e6_hunter_room/shield3))
			(sleep_until (< (object_get_health e6_jail_shield3) 0) 15 150)
			(cs_shoot_point false cs_e6_hunter_room/shield3)
		)
	)
)

(script command_script cs_e6_destroy_door4
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_certain)

	; Go to and wreck the door
	(if (>= (object_get_health e6_jail_shield4) 0) 
		(begin 
			(cs_start_to cs_e6_hunter_room/near_shield4)
			(sleep_until
				(or
					(not (cs_moving))
					(< (object_get_health e6_jail_shield4) 0)
				)
				15
			)
			(if (>= (object_get_health e6_jail_shield4) 0) (cs_shoot_point true cs_e6_hunter_room/shield4))
			(sleep_until (< (object_get_health e6_jail_shield4) 0) 15 150)
			(cs_shoot_point false cs_e6_hunter_room/shield4)
		)
	)
)

(script command_script cs_e6_destroy_door5
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_combat_status ai_combat_status_certain)

	; Go to and wreck the door
	(if (>= (object_get_health e6_jail_shield5) 0) 
		(begin 
			(cs_start_to cs_e6_hunter_room/near_shield5)
			(sleep_until
				(or
					(not (cs_moving))
					(< (object_get_health e6_jail_shield5) 0)
				)
				15
			)
			(if (>= (object_get_health e6_jail_shield5) 0) (cs_shoot_point true cs_e6_hunter_room/shield5))
			(sleep_until (< (object_get_health e6_jail_shield5) 0) 15 150)
			(cs_shoot_point false cs_e6_hunter_room/shield5)
		)
	)
)

(script command_script cs_e6_release_captives
	; Abort if alerted
	(cs_abort_on_combat_status ai_combat_status_certain)

	; Wreck a door if someone else isn't on the job already
	(if 
		(and
			(>= (object_get_health e6_jail_shield4) 0)
			(not (cs_command_script_queued ai_current_squad cs_e6_destroy_door4))
		)
		(begin
			(cs_stack_command_script ai_current_actor cs_e6_destroy_door4)
			(sleep 30)
		)
	)

;*	(if 
		(and
			(>= (object_get_health e6_jail_shield5) 0)
			(not (cs_command_script_queued ai_current_squad cs_e6_destroy_door5))
		)
		(begin
			(cs_stack_command_script ai_current_actor cs_e6_destroy_door5)
			(sleep 30)
		)
	)
*;
	(if 
		(and
			(>= (object_get_health e6_jail_shield1) 0)
			(not (cs_command_script_queued ai_current_squad cs_e6_destroy_door1))
		)
		(begin
			(cs_stack_command_script ai_current_actor cs_e6_destroy_door1)
			(sleep 30)
		)
	)

	(if 
		(and
			(>= (object_get_health e6_jail_shield2) 0)
			(not (cs_command_script_queued ai_current_squad cs_e6_destroy_door2))
		)
		(begin
			(cs_stack_command_script ai_current_actor cs_e6_destroy_door2)
			(sleep 30)
		)
	)
;*
	(if 
		(and
			(>= (object_get_health e6_jail_shield3) 0)
			(not (cs_command_script_queued ai_current_squad cs_e6_destroy_door3))
		)
		(begin
			(cs_stack_command_script ai_current_actor cs_e6_destroy_door3)
			(sleep 30)
		)
	)
	
	(if 
		(and
			(>= (object_get_health e6_jail_shield0) 0)
			(not (cs_command_script_queued ai_current_squad cs_e6_destroy_door0))
		)
		(begin
			(cs_stack_command_script ai_current_actor cs_e6_destroy_door0)
			(sleep 30)
		)
	)
	*;
)

(script command_script cs_e6_jailbreak_behavior
	; Allow combat
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_enable_dialogue true)

	; Loop until...
	(sleep_until
		(begin
			; If we're not certain, break doors
			(if 
				(and
					(not (unit_has_weapon (ai_get_unit ai_current_actor) "objects\weapons\melee\energy_blade\energy_blade.weapon"))
					(< (ai_combat_status ai_current_actor) ai_combat_status_certain)
				)
				(cs_stack_command_script ai_current_actor cs_e6_release_captives)
			)
			
			; Until room cleared, or we have an energy sword, in which case we're useless
			(or
				(e6_room_cleared)
				(unit_has_weapon (ai_get_unit ai_current_actor) "objects\weapons\melee\energy_blade\energy_blade.weapon")
			)
		)
		60
	)
)
;*
(script command_script cs_e6_cov_inf1_0_init
	; Make the AI ignore them
	(ai_disregard (ai_get_object ai_current_actor) true)

	; Sleep until we've seen the player or our door is destroyed
	(sleep_until 
		(or
			(>= (ai_combat_status e6_pro) ai_combat_status_active)
			(< (object_get_health e6_jail_shield0) 0)
		)
		15
	)
	(cs_ignore_obstacles true)
	(cs_go_to cs_e6_hunter_room/elite0_approach)
	
	; The look at the player
	(cs_look_player true)
	
	; Sleep until my door is open
	(sleep_until 
		(begin
			; Taunt and rage!
			(begin_random
				; Cheer
				(if (>= (object_get_health e6_jail_shield0) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:cheer" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield0) 0) 10 (random_range 90 150))
					)
				)

				; Fist
				(if (>= (object_get_health e6_jail_shield0) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:shakefist" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield0) 0) 10 (random_range 90 150))
					)
				)				

				; Warn
				(if (>= (object_get_health e6_jail_shield0) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:warn" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield0) 0) 10 (random_range 90 150))
					)
				)				

				; Wave
				(if (>= (object_get_health e6_jail_shield0) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:wave" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield0) 0) 10 (random_range 90 150))
					)
				)				
			)
		
			; Until the door is open
			(or
				(< (object_get_health e6_jail_shield0) 0)
				(<= (ai_living_count e6_pro) 0)
			)
		)
		15
	)
	(sleep_until 
		(< (object_get_health e6_jail_shield0) 0)
		15
	)
	
	; It's go time
	(ai_disregard (ai_get_object ai_current_actor) false)
	
	; Queue up the jailbreak behavior
	(cs_queue_command_script ai_current_actor cs_e6_jailbreak_behavior)
)
*;

(script command_script cs_e6_cov_inf1_1_init
	; Make the AI ignore them
	(ai_disregard (ai_get_object ai_current_actor) true)

	; Sleep until we've seen the player or our door is destroyed
	(sleep_until 
		(or
			(>= (ai_combat_status e6_pro) ai_combat_status_active)
			(< (object_get_health e6_jail_shield1) 0)
		)
		15
	)
	(cs_ignore_obstacles true)
	(cs_go_to cs_e6_hunter_room/elite1_approach)
	
	; The look at the player
	(cs_look_player true)
	
	; Sleep until my door is open
	(sleep_until 
		(begin
			; Taunt and rage!
			(begin_random
				; Cheer
				(if (>= (object_get_health e6_jail_shield1) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:cheer" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield1) 0) 10 (random_range 90 150))
					)
				)

				; Fist
				(if (>= (object_get_health e6_jail_shield1) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:shakefist" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield1) 0) 10 (random_range 90 150))
					)
				)				

				; Warn
				(if (>= (object_get_health e6_jail_shield1) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:warn" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield1) 0) 10 (random_range 90 150))
					)
				)				

				; Wave
				(if (>= (object_get_health e6_jail_shield1) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:wave" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield1) 0) 10 (random_range 90 150))
					)
				)				
			)
		
			; Until the door is open
			(or
				(< (object_get_health e6_jail_shield1) 0)
				(<= (ai_living_count e6_pro) 0)
			)
		)
		15
	)
	(sleep_until 
		(< (object_get_health e6_jail_shield1) 0)
		15
	)
	
	; It's go time
	(ai_disregard (ai_get_object ai_current_actor) false)
	
	; Queue up the jailbreak behavior
	(cs_queue_command_script ai_current_actor cs_e6_jailbreak_behavior)
)

(script command_script cs_e6_cov_inf1_2_init
	; Make the AI ignore them
	(ai_disregard (ai_get_object ai_current_actor) true)

	; Sleep until we've seen the player or our door is destroyed
	(sleep_until 
		(or
			(>= (ai_combat_status e6_pro) ai_combat_status_active)
			(< (object_get_health e6_jail_shield2) 0)
		)
		15
	)
	(cs_ignore_obstacles true)
	(cs_go_to cs_e6_hunter_room/elite2_approach)
	
	; The look at the player
	(cs_look_player true)
	
	; Sleep until my door is open
	(sleep_until 
		(begin
			; Taunt and rage!
			(begin_random
				; Cheer
				(if (>= (object_get_health e6_jail_shield2) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:cheer" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield2) 0) 10 (random_range 90 150))
					)
				)

				; Fist
				(if (>= (object_get_health e6_jail_shield2) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:shakefist" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield2) 0) 10 (random_range 90 150))
					)
				)				

				; Warn
				(if (>= (object_get_health e6_jail_shield2) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:warn" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield2) 0) 10 (random_range 90 150))
					)
				)				

				; Wave
				(if (>= (object_get_health e6_jail_shield2) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:wave" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield2) 0) 10 (random_range 90 150))
					)
				)				
			)
		
			; Until the door is open
			(or
				(< (object_get_health e6_jail_shield2) 0)
				(<= (ai_living_count e6_pro) 0)
			)
		)
		15
	)
	(sleep_until 
		(< (object_get_health e6_jail_shield2) 0)
		15
	)
	
	; It's go time
	(ai_disregard (ai_get_object ai_current_actor) false)
	
	; Queue up the jailbreak behavior
	(cs_queue_command_script ai_current_actor cs_e6_jailbreak_behavior)
)

;*
(script command_script cs_e6_cov_inf1_3_init
	; Make the AI ignore them
	(ai_disregard (ai_get_object ai_current_actor) true)

	; Sleep until we've seen the player or our door is destroyed
	(sleep_until 
		(or
			(>= (ai_combat_status e6_pro) ai_combat_status_active)
			(< (object_get_health e6_jail_shield3) 0)
		)
		15
	)
	(cs_ignore_obstacles true)
	(cs_go_to cs_e6_hunter_room/elite3_approach)
	
	; The look at the player
	(cs_look_player true)
	
	; Sleep until my door is open
	(sleep_until 
		(begin
			; Taunt and rage!
			(begin_random
				; Cheer
				(if (>= (object_get_health e6_jail_shield3) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:cheer" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield3) 0) 10 (random_range 90 150))
					)
				)

				; Fist
				(if (>= (object_get_health e6_jail_shield3) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:shakefist" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield3) 0) 10 (random_range 90 150))
					)
				)				

				; Warn
				(if (>= (object_get_health e6_jail_shield3) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:warn" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield3) 0) 10 (random_range 90 150))
					)
				)				

				; Wave
				(if (>= (object_get_health e6_jail_shield3) 0)
					(begin
						(custom_animation (ai_get_unit ai_current_actor) "objects\characters\elite\elite" "combat:pistol:wave" true)
						(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
						(sleep_until (< (object_get_health e6_jail_shield3) 0) 10 (random_range 90 150))
					)
				)				
			)
		
			; Until the door is open
			(or
				(< (object_get_health e6_jail_shield3) 0)
				(<= (ai_living_count e6_pro) 0)
			)
		)
		15
	)
	(sleep_until 
		(< (object_get_health e6_jail_shield3) 0)
		15
	)
	
	; It's go time
	(ai_disregard (ai_get_object ai_current_actor) false)
	
	; Queue up the jailbreak behavior
	(cs_queue_command_script ai_current_actor cs_e6_jailbreak_behavior)
)
*;

(script command_script cs_e6_cov_hunters0_0_init
	; Make the AI ignore them
	(ai_disregard (ai_get_object ai_current_actor) true)

	; Sleep until we've seen the player or our door is destroyed
	(sleep_until 
		(or
			(ai_trigger_test generic_player_sighted ai_current_squad)
			(< (object_get_health e6_jail_shield4) 0)
		)
		15
	)
	
	; The look at the player
	(cs_look_player true)
	
	; Sleep until my door is open
	(sleep_until (< (object_get_health e6_jail_shield4) 0) 15)
	
	; Stop looking at the player, stop being disregarded, get combat ready
	(ai_disregard (ai_get_object ai_current_actor) false)
	(cs_force_combat_status 4)
	(cs_look_player false)
	
	; If the other door isn't open...
;*	(if (> (object_get_health e6_jail_shield5) 0)
		(begin
			; Move out
			(cs_enable_pathfinding_failsafe true)
			(cs_go_to cs_e6_hunter_room/hunter0_0)
		
			; Shoot until it's dead
			(cs_shoot_point true cs_e6_hunter_room/shield5)
			(sleep_until (< (object_get_health e6_jail_shield5) 0) 15 150)
		)
	)
*;
	
	; Queue up the jailbreak behavior
	(cs_queue_command_script ai_current_actor cs_e6_jailbreak_behavior)
)

;*
(script command_script cs_e6_cov_hunters0_1_init
	; Make the AI ignore them
	(ai_disregard (ai_get_object ai_current_actor) true)

	; Sleep until we've seen the player or our door is destroyed
	(sleep_until 
		(or
			(ai_trigger_test generic_player_sighted ai_current_squad)
			(< (object_get_health e6_jail_shield5) 0)
		)
		15
	)
	
	; The look at the player
	(cs_look_player true)
	
	; Sleep until my door is open
	(sleep_until (< (object_get_health e6_jail_shield5) 0) 15)
	
	; Stop looking at the player, stop being disregarded, get combat ready
	(ai_disregard (ai_get_object ai_current_actor) false)
	(cs_force_combat_status 4)
	(cs_look_player false)
	
	; If the other door isn't open...
	(if (> (object_get_health e6_jail_shield4) 0)
		(begin
			; Move out
			(cs_enable_pathfinding_failsafe true)
			(cs_go_to cs_e6_hunter_room/hunter1_0)
		
			; Shoot until it's dead
			(cs_shoot_point true cs_e6_hunter_room/shield4)
			(sleep_until (< (object_get_health e6_jail_shield4) 0) 15 150)
		)
	)
	
	; Queue up the jailbreak behavior
	(cs_queue_command_script ai_current_actor cs_e6_jailbreak_behavior)
)
*;

(script command_script cs_e6_jailbreak_scene
	(ai_play_line ai_current_actor 0610) ; "Free our bros, death to the fuzz!"
)


;- Squad Controls --------------------------------------------------------------

(script dormant e6_pro_inf0_main
	(ai_place e6_pro_inf0_0)
	(ai_place e6_pro_inf0_1)
	
	; Sleep until they're alerted or depleted
	(sleep_until 
		(or
			(> (ai_combat_status e6_pro_inf0) ai_combat_status_clear_los)
			(<= (ai_living_count e6_pro_inf0_0) 2)
		)
		15
	)
	
	; Music!
	(wake music_08b_05_start_alt)

	; Sleep until the Brutes have been beaten down
	(sleep_until (<= (ai_living_count e6_pro_inf0_0) 2))
	
	; Unlock the door, send in the reins
	(ai_place e6_pro_inf0_2)
	(sleep 15)
	(device_operates_automatically_set e6_door0 true)
)

(script dormant e6_cov_hunters0_main
	(ai_migrate e5_cov_hunters0 e6_cov_hunters0)

	; If we have a pair, we're done
	(if (>= (ai_living_count e6_cov_hunters0) 2)
		(sleep_forever)
	)
	
	; Otherwise, place two more, apply their command scripts
	(ai_place e6_cov_hunters0)
;	(cs_run_command_script e6_cov_hunters0/hunter0 cs_e6_cov_hunters0_0_init)
;	(cs_run_command_script e6_cov_hunters0/hunter1 cs_e6_cov_hunters0_1_init)
	
	; Set their orders appropriately for freed Hunters
	(ai_set_orders e6_cov_hunters0 e6_cov_hunters0_engage1)
)

(script dormant e6_cov_inf1_main
;	(ai_place e6_cov_inf1_0)
	(ai_place e6_cov_inf1_1)
	(ai_place e6_cov_inf1_2)
;	(ai_place e6_cov_inf1_3)

	; Run their command scripts
;	(cs_run_command_script e6_cov_inf1_0 cs_e6_cov_inf1_0_init)
;	(cs_run_command_script e6_cov_inf1_1 cs_e6_cov_inf1_1_init)
;	(cs_run_command_script e6_cov_inf1_2 cs_e6_cov_inf1_2_init)
;	(cs_run_command_script e6_cov_inf1_3 cs_e6_cov_inf1_3_init)
)

(script dormant e6_cov_inf0_main
	(ai_migrate e5_cov_inf0 e6_cov_inf0)
	
	; Wait until we're inside the main room
	(sleep_until
		(volume_test_objects tv_e6_main_room (ai_actors e6_cov_inf0))		
	)
	
	; Try running the scene
	(sleep_until 
		(ai_scene e6_jailbreak_scene cs_e6_jailbreak_scene e6_cov_inf0)
		30
		300
	)
	
	; Wait until the Brute reins are spawned, then dead
	(sleep_until 
		(and
			(> (ai_spawn_count e6_pro_inf0_2) 0)
			(<= (ai_living_count e6_pro_inf0_2) 0)
		)
	)
	
	; Release prisoners
	(cs_run_command_script e6_cov_inf0 cs_e6_jailbreak_behavior)	

	; Wait until the room is cleared
	(sleep_until (e6_room_cleared))
	(game_save)
		
	; Migrate everyone
	(ai_migrate e6_cov_inf1 e6_cov_inf0)
	(ai_set_orders e6_cov_inf0 e6_cov_inf0_continue)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e6_main
	(sleep_until (volume_test_objects tv_e6_main_begin (players)) 15)
	(set g_e6_started true)
	(game_save)
	(print "e6_main")
	(data_mine_set_mission_segment "e6_jail")
	
	; Music
	(wake music_08b_05_start)
	
	; Wake subsequent scripts
	(wake e7_main)

	; Wake control scripts
	(wake e6_cov_inf0_main)
	(wake e6_cov_inf1_main)
	(wake e6_cov_hunters0_main)
	(wake e6_pro_inf0_main)
	
	; Shut down
	(sleep_until g_e7_started)
	(sleep_forever e6_cov_inf0_main)
	(sleep_forever e6_cov_inf1_main)
	(sleep_forever e6_cov_hunters0_main)
	(sleep_forever e6_pro_inf0_main)
	
	; Condemn
	(ai_disposable e6_pro true)
)

(script static void test_hunter_room
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e6_test)
	(ai_place e6_cov_inf0)
	(if (not g_e6_started) (wake e6_main))
)


;= ENCOUNTER 5 ===========================================================================
;*

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e5_cov_inf0 - e4_cov_inf0, Elite allies
		(init) - One quarter of the way
		(advance0) - Halfway up
		(cower0) - Cower from the Phantom
		(advance1) - Three quarters of the way
		(continue) - Continue to the Hunter room
	e5_cov_hunters0 - e4_cov_hunters0, Hunter allies
		(init) - One quarter of the way
		(advance0) - Halfway up
		(advance1) - Three quarters
		(continue) - Continue to Hunter room
	e5_cov_grunts0 - Hapless Grunts who flee
	e5_cov_banshees0 - Banshees which drive off e5_pro_phantom0

Prophets
	e5_pro_inf0 - Jackals defending partway up the the bridge
		(init) - Just past halfway
		(retreat0) - Just before halfway
		(retreat1) - At three quarters
	e5_pro_inf1 - A sniper at the end of the bridge
		(init)
	e5_pro_inf2 - Buggers who mass as e5_pro_inf0 dies off
		(init) - Gathering near the door
		(engage) - Engage when the player get too close
	e5_pro_inf3 - A few last ditch Brutes
		(init)
	e5_pro_phantom0 - A Phantom which arrives to harass the player
		(init)

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e5_started false)			; Encounter has been activated?

(global short g_e5_pro_inf2_limit 7)		; How many buggers to spawn?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e5_pro_phantom0_entry
	(cs_fly_to_and_face e5_pro_phantom0/p0 e5_pro_phantom0/p1)
	(cs_fly_by e5_pro_phantom0/p1)
)

(script command_script cs_e5_pro_phantom0_exit
	(cs_fly_to_and_face e5_pro_phantom0/p2 e5_pro_phantom0/p2_facing)
	(cs_fly_by e5_pro_phantom0/p3)
	(cs_vehicle_boost true)
	(cs_fly_by e5_pro_phantom0/p4)
	(ai_erase ai_current_squad)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e5_pro_phantom0_main
	(sleep_until (volume_test_objects tv_e5_pro_phantom0_begin (players)) 15)
	(ai_place e5_pro_phantom0)
	
	; Wait until it should retreat
	(sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get e5_pro_phantom0/phantom0)) 0.05) 
			(>= (object_model_targets_destroyed (ai_vehicle_get e5_pro_phantom0/phantom0) "target_front") 3) 
			(volume_test_objects tv_e7_main_begin (players))
		)
		30
		one_minute
	)
	(cs_run_command_script e5_pro_phantom0/phantom0 cs_e5_pro_phantom0_exit)
)

(script dormant e5_pro_inf3_main
	(sleep_until (volume_test_objects tv_e5_pro_inf3_init (players)) 15)
	(ai_place e5_pro_inf3)
)

(script dormant e5_pro_inf2_main
	; Respawn these guys as the Jackals die off
	(sleep_until
		(begin
			; If the sum of the encounter is too low...
			(if
				(< 
					(+ 
						(ai_living_count e5_pro_inf0)
						(ai_living_count e5_pro_inf1)
						(ai_living_count e5_pro_inf2)
					)
					g_e5_pro_inf2_limit
				)
				
				; If so, spawn an actor
				(ai_place e5_pro_inf2 1)
			)
			
			; Loop until the player is near the door, or the spawn count of
			; the buggers is too great
			(or
				(volume_test_objects tv_e5_bridge_exit (players))
				(>= (ai_spawn_count e5_pro_inf2) g_e5_pro_inf2_limit)
			)
		)
		30
	)
)

(script dormant e5_pro_inf1_main
	(ai_place e5_pro_inf1)
)

(script dormant e5_pro_inf0_main
	(ai_place e5_pro_inf0)
)

(script dormant e5_cov_hunters0_main
	; Wait until they've moved on from the previous encounter
	(sleep_until 
		(and
			(<= (ai_living_count e4_pro_inf0) 0)
			(<= (ai_living_count e4_pro_inf1) 0)
			(<= (ai_living_count e4_pro_inf3) 0)
		)
	)
	(sleep_until (= (structure_bsp_index) 1) 15)
	(sleep_until (= (structure_bsp_index) 0) 15)
	
	; Migrate them, teleport them
	(ai_migrate e4_cov_hunters0 e5_cov_hunters0)
	(ai_teleport_to_starting_location_if_outside_bsp e5_cov_hunters0)
)

(script dormant e5_cov_inf0_main
	; Wait until they've moved on from the previous encounter
	(sleep_until 
		(and
			(<= (ai_living_count e4_pro_inf0) 0)
			(<= (ai_living_count e4_pro_inf1) 0)
			(<= (ai_living_count e4_pro_inf3) 0)
		)
	)
	(sleep_until (= (structure_bsp_index) 1) 15)
	(sleep_until (= (structure_bsp_index) 0) 15)
	
	; Migrate them, teleport them
	(ai_migrate e4_cov_inf0 e5_cov_inf0)
	(ai_teleport_to_starting_location_if_outside_bsp e5_cov_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e5_main
	(sleep_until 
		(and
			(volume_test_objects tv_e5_main_begin (players))
			(= (structure_bsp_index) 0)
		)
		15
	)
	(set g_e5_started true)
	(game_save)
	(print "e5_main")
	(data_mine_set_mission_segment "e5_bridge")
	
	; Calm down the weather
	(weather_change_intensity 0 0.5)
	
	; Wake subsequent scripts
	(wake e6_main)

	; Wake control scripts
	(wake e5_cov_inf0_main)
	(wake e5_cov_hunters0_main)
	(wake e5_pro_inf0_main)
	(wake e5_pro_inf1_main)
	(wake e5_pro_inf2_main)
	(wake e5_pro_phantom0_main)
	
	; Shut down
	(sleep_until g_e6_started)
	(sleep_forever e5_cov_inf0_main)
	(sleep_forever e5_cov_hunters0_main)
	(sleep_forever e5_pro_inf0_main)
	(sleep_forever e5_pro_inf1_main)
	(sleep_forever e5_pro_inf2_main)
	(sleep_forever e5_pro_phantom0_main)
	
	; Condemn
	(ai_disposable e5_pro true)
	(ai_disposable e5_pro_phantom0 false)
)

(script static void test_bridge
	(object_teleport (player0) e5_test)
	(ai_place e5_cov_inf0)
	(ai_place e5_cov_hunters0)
	(if (not g_e5_started) (wake e5_main))
)


;= ENCOUNTER 4 ===========================================================================
;*

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e4_cov_inf0 - e3_cov_inf0, Elite allies
		(init) - Just a bit past the first ledge
		(advance0) - Advance up to near the turrets
		(advance1) - Advance up to the corner
		(advance2) - Advance up to the second ledge
		(continue) - Continue to the bridge
	e4_cov_hunters0 - e3_cov_hunters0, Hunter allies
		(init) - Fighting from the first ledge
		(advance0) - Advance up to the corner
		(advance1) - Advance up to the second ledge
		(continue) - Continue to the bridge

Prophets
	e4_pro_inf0 - A squad of Brutes which holds the second ledge
		(init) - Fighting across the gap with e4_cov_hunters0
		(defend0) - Bunker
		(defend1) - Defend from the ramp
	e4_pro_inf1 - A squad of Brutes which holds the generator
		(init) - Fighting across the gap with e4_cov_inf0
		(advance0) - Advance up to the turrets
		(retreat0) - Retreat to the corner
		(retreat1) - Retreat to the base of the ramp
	e4_pro_inf2 - Buggers which reinforce the corner
		(init) - Engaging at the corner
	e4_pro_inf3 - Jacakals which reinforce the exit
		(init) - Defending around the ramp

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e4_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------
;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e4_music
	(sleep_until (volume_test_objects tv_e4_halfway (players)) 15)
	(wake music_08b_04_start)
	(sleep 2)
	(game_save)
	
	(sleep_until (volume_test_objects tv_e4_main_shutdown (players)) 15)
	(wake music_08b_03_stop)
	(wake music_08b_04_stop)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e4_pro_inf3_main
	(sleep_until 
		(or
			(volume_test_objects tv_e4_corner (players)) 
			(<= (ai_living_count e4_pro_inf0) 0)
			(<= (ai_living_count e4_pro_inf1) 0)
		)
		15
	)
	(ai_place e4_pro_inf3 (- 6 (ai_living_count e4_pro_inf0)))
)

(script dormant e4_pro_inf2_main
	(sleep_until 
		(or
			(volume_test_objects tv_e4_corner (players)) 
			(<= (ai_living_count e4_pro_inf0) 0)
			(<= (ai_living_count e4_pro_inf1) 0)
		)
		15
	)
	(ai_place e4_pro_inf2)
)

(script dormant e4_pro_inf1_main
	(ai_place e4_pro_inf1)
)

(script dormant e4_pro_inf0_main
	(ai_place e4_pro_inf0)
)

(script dormant e4_cov_hunters0_main
	(ai_migrate e3_cov_hunters0 e4_cov_hunters0)
)

(script dormant e4_cov_inf0_main
	(ai_migrate e3_cov_inf0 e4_cov_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e4_main
	(sleep_until (volume_test_objects tv_e4_main_begin (players)) 15)
	(set g_e4_started true)
	(game_save)
	(print "e4_main")
	(data_mine_set_mission_segment "e4_generator_room")
	
	; Music 
	(wake music_08b_03_start)
	
	; Wake subsequent scripts
	(wake e5_main)

	; Wake control scripts
	(wake e4_cov_inf0_main)
	(wake e4_cov_hunters0_main)
	(wake e4_pro_inf0_main)
	(wake e4_pro_inf1_main)
;	(wake e4_pro_inf2_main)
	(wake e4_pro_inf3_main)
	(wake e4_music)
	
	; Shut down
	(sleep_until (volume_test_objects tv_e4_main_shutdown (players)) 15)
	(sleep_forever e4_cov_inf0_main)
	(sleep_forever e4_cov_hunters0_main)
	(sleep_forever e4_pro_inf0_main)
	(sleep_forever e4_pro_inf1_main)
	(sleep_forever e4_pro_inf2_main)
	(sleep_forever e4_pro_inf3_main)
	
	; Clean up
	(sleep_until g_e5_started)
	(ai_disposable e4_pro true)
)

(script static void test_generator_cave
	(switch_bsp 1)
	(sleep 1)
	(object_teleport (player0) e4_test)
	(ai_place e4_cov_inf0)
	(ai_place e4_cov_hunters0)
	(if (not g_e4_started) (wake e4_main))
)


;= ENCOUNTER 3 ===========================================================================
;*

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e3_cov_inf0
		(advance0) - Advance to the door entrance
		(advance1) - Wait for the Hunters to enter, then fall in behind
		(advance2) - Wait for the player to move up, or after a timeout
		(advance3) - Advance up the ramp
	e3_cov_hunters0
		(init)
		(advance0) - Advance up the ramp
		(continue) - Continue when everyone is dead

Prophets

Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e3_started false)			; Encounter has been activated?
(global boolean g_e3_hunters_rise false)
(global boolean g_e3_hunter0_go false)
(global boolean g_e3_hunter1_go false)
(global boolean g_e3_hunter0_arrived false)
(global boolean g_e3_hunter1_arrived false)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e3_cov_hunters0_break
	(or
		(and
			(> (ai_spawn_count e3_pro_inf0) 0)
			(<= (ai_living_count e3_pro_inf0_0) 1)
		)
		(volume_test_objects tv_e3_player_advance2 (players))
	)
)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e3_cov_hunters0_0
	(cs_crouch true)
	(cs_look_player true)
	(unit_impervious (ai_get_unit ai_current_actor) true)
	(object_cannot_die (ai_get_object ai_current_actor) true)
	
	; Wait until the Elite stands down
	(sleep_until
		(or
			g_e3_hunters_rise
			(volume_test_objects tv_e3_player_advance0 (players))
		)
		5
	)
	(sleep 20)
	(cs_crouch false)
		
	; Sleep until the Elite is finished addressing the player, or he rushes up
	(sleep_until
		(or
			g_e3_hunter0_go
			(volume_test_objects tv_e3_player_advance0 (players))
		)
		5
	)
	
	; Have them rise and continue into the next room
	(cs_ignore_obstacles true)
	(cs_look_player false)
	(cs_enable_looking true)
	(cs_start_to e3_intro_bsp0/p0)
	(sleep_until
		(and
			(not (cs_moving))
			(= (structure_bsp_index) 1)
		)
		5
	)
		
	; Continue into the next room
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e3_intro_bsp1/p0)
	(cs_crouch true)
	(cs_enable_targeting true)
	(cs_go_to e3_intro_bsp1/p1_0)
	
	; Wait until they should break and engage
	(sleep_until
		(e3_cov_hunters0_break)
		15
		30_seconds
	)

	; Make him mortal again
	(set g_e3_hunter0_arrived true)
	(ai_renew ai_current_actor)
	(unit_impervious (ai_get_unit ai_current_actor) false)
	(object_cannot_die (ai_get_object ai_current_actor) false)
)

(script command_script cs_e3_cov_hunters0_1
	(cs_crouch true)
	(cs_look_player true)
	(unit_impervious (ai_get_unit ai_current_actor) true)
	(object_cannot_die (ai_get_object ai_current_actor) true)
		
	; Wait until the Elite stands down
	(sleep_until
		(or
			g_e3_hunters_rise
			(volume_test_objects tv_e3_player_advance0 (players))
		)
		5
	)
	(sleep 30)
	(cs_crouch false)

	; Sleep until the Elite is finished addressing the player, or he rushes up
	(sleep_until
		(or
			g_e3_hunter1_go
			(volume_test_objects tv_e3_player_advance0 (players))
		)
		5
	)
		
	; Have them rise and continue into the next room
	(cs_ignore_obstacles true)
	(cs_look_player false)
	(cs_enable_looking true)
	(cs_start_to e3_intro_bsp0/p1)
	(sleep_until
		(and
			(not (cs_moving))
			(= (structure_bsp_index) 1)
		)
		5
	)
	
	; Continue into the next room
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e3_intro_bsp1/p0)
	(cs_crouch true)
	(cs_enable_targeting true)
	(cs_go_to e3_intro_bsp1/p1_1)
	
	; Wait until they should break and engage
	(sleep_until
		(e3_cov_hunters0_break)
		15
		30_seconds
	)

	; Make him mortal again
	(set g_e3_hunter1_arrived true)
	(ai_renew ai_current_actor)
	(unit_impervious (ai_get_unit ai_current_actor) false)
	(object_cannot_die (ai_get_object ai_current_actor) false)
)

(script command_script cs_e3_cov_inf0_0
	(cs_enable_pathfinding_failsafe true)
	(cs_crouch true)
	(cs_look_player true)
	
	; Wait for it
	(sleep_until
		(> (device_get_position e2_exit_door) 0.1)
		5
	)
	
	; Rise and address the player
	(cs_crouch false)
	(set g_e3_hunters_rise true)
	(print "elite: hold your fire!")
	(sleep (ai_play_line_at_player ai_current_actor 0560)) ; "Hold your fire"
	
	; Jump on the crate
	(cs_jump_to_point 1 2.25)
	(sleep 25)
	
	; Look at the first Hunter
	(print "elite: the hunters rawk")
	(ai_play_line_at_player ai_current_actor 0570) ; "The Hunters have come to our aid"
	(sleep 20)
	(cs_look_object true (ai_get_object e3_cov_hunters0/hunter0))
	(sleep 40)
	(set g_e3_hunter0_go true)
	(cs_look_object true (ai_get_object e3_cov_hunters0/hunter1))
	(sleep 30)
	(set g_e3_hunter1_go true)
	
	; Step off
	(cs_look_object false (ai_get_object e3_cov_hunters0/hunter1))
	(cs_enable_looking true)
	(cs_move_in_direction -20 .5 0)

	; Follow along
	(cs_start_to e3_intro_bsp0/p2)
	(sleep_until
		(and
			(not (cs_moving))
			(= (structure_bsp_index) 1)
		)
		5
	)
	(cs_go_to e3_intro_bsp1/p0)
	
	; Wait for the Hunters
	(sleep_until
		(and
			g_e3_hunter0_arrived
			g_e3_hunter1_arrived
		)
	)
	(cs_go_to e3_intro_bsp1/p2)
)

(script command_script cs_e3_cov_inf0_init
	(cs_crouch true)
	(cs_look_player true)
	
	; Wait for it
	(sleep_until
		(> (device_get_position e2_exit_door) 0)
		5
	)
	
	; Rise and regard the player
	(sleep 30)
	(cs_crouch false)
	(sleep_until
		(volume_test_objects tv_e3_player_advance0 (players))
		15
		200 ; Timeout for polite players
	)
)

(script command_script cs_e3_pro_inf2_idle
	(cs_crouch true)
	(sleep_until (>= (ai_combat_status ai_current_actor) ai_combat_status_active) 3)
	(cs_crouch false)
	(cs_go_to e3_intro_bsp1/p3)
)

(script command_script cs_e3_weapon_scene
	(cs_play_line 0580)	; "More human weapons? Savages"
)


;- Event Scripts ---------------------------------------------------------------

(script dormant e3_weapon_scene
	(sleep_until
		(ai_scene e3_weapons_scene cs_e3_weapon_scene e3_cov)
	)
)

(script dormant e3_objective_failsafe
	(sleep_until
		(> (device_get_position e2_exit_door) 0)
		5
		30
	)
	(wake objective1_set)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e3_pro_inf2_main
	(sleep_until (= (structure_bsp_index) 1) 5)
	(ai_place e3_pro_inf2)
)

(script dormant e3_pro_inf1_main
	(sleep_until (volume_test_objects tv_e3_pro_inf1_begin (players)) 15)
	(ai_place e3_pro_inf1)
)

(script dormant e3_pro_inf0_main
	(sleep_until (volume_test_objects tv_e3_pro_inf0_begin (players)) 15)
	(ai_place e3_pro_inf0_0)
	
	; Wait to place reins
	(sleep_until 
		(or
			(volume_test_objects tv_e3_player_advance2 (players))
			(<= (ai_living_count e3_pro_inf0) 2)
		)
		15
	)
	
	; Place reins
	(ai_place e3_pro_inf0_1 (pin (- 7 (ai_living_count e3_pro_inf0)) 2 4))
)
	
(script dormant e3_cov_hunters0_main
	(ai_place e3_cov_hunters0)
	
	; Run their command scripts
	(cs_run_command_script e3_cov_hunters0/hunter0 cs_e3_cov_hunters0_0)
	(cs_run_command_script e3_cov_hunters0/hunter1 cs_e3_cov_hunters0_1)
)

(script dormant e3_cov_inf0_main
	(ai_place e3_cov_inf0)
	
	; Wait until the door is open
	(sleep_until
		(> (device_get_position e2_exit_door) 0)
		5
		30
	)
	
	; Music
	(wake music_08b_02_stop)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e3_main
	(sleep_until (volume_test_objects tv_e3_main_begin (players)) 15)
	(set g_e3_started true)
	(game_save)
	(print "e3_main")
	(data_mine_set_mission_segment "e3_ramp_room")
	
	; Wake subsequent scripts
	(wake e4_main)

	; Wake control scripts
	(wake e3_cov_inf0_main)
	(wake e3_cov_hunters0_main)
	(wake e3_pro_inf0_main)
;	(wake e3_pro_inf1_main)
;	(wake e3_pro_inf2_main)
	(wake e3_objective_failsafe)
	
	; Shut down
	(sleep_until g_e4_started)
	(sleep_forever e3_cov_inf0_main)
	(sleep_forever e3_cov_hunters0_main)
	(sleep_forever e3_pro_inf0_main)
	(sleep_forever e3_pro_inf1_main)
	(sleep_forever e3_pro_inf2_main)
	
	; Condemn
	(ai_disposable e3_pro true)
	
	; Clean up
	(sleep_until g_e5_started)
	(ai_erase e3_cov)
	(ai_erase e3_pro)
)

(script static void test_ramp_room
	(object_teleport (player0) e3_test)
	(if (not g_e3_started) (wake e3_main))
	(device_operates_automatically_set e2_exit_door true)
)


;= ENCOUNTER 2 ===========================================================================
;*
The player drives his Wraith UP MY ASS.

Begins when the player enters the room.
Ends when the player leaves the room.

Elites
	e2_cov_wraith0 - 
	e2_cov_spectre0 - 

Prophets
	e2_pro_inf0 - Infantry near the door, who move out to attempt to board
		(init) - Near the door
		(engage0) - Perimeter positions
	e2_pro_ghosts0 - Sneaky Ghosts
		_0 - Ghosts near the entrance
			(init) - Cautiously bunkering until the player is past
			(engage0) - Loading up and going to it
		_1 - Ghosts near the Scarab
			(init) - Ditto
			(engage0) - "
	e2_pro_wraith0 - Wraiths guarding the exit
		_0 - Initially active defender
			(init) - Guarding the outer exit perimeter
		_1 - Initially dormant defender
			(init) - Guarding the exit
	e2_pro_phantom0 - Phantoms who come in low and pop up over the water
		_0 - First Phantom
		_1 - Second Phantom
			(init) - Engaging from above the water


Open Issues

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e2_started false)			; Encounter has been activated?


;- Event Scripts ---------------------------------------------------------------

(script dormant e2_dialogue
	; Wait until the player is looking at the Scarab, game is safe, or a timeout
	(sleep_until 
		(and
			(objects_can_see_object (players) scarab 15.0)
			(game_safe_to_save)
		)
		15
		300
	)
	(sleep_until 
		(objects_can_see_object (players) scarab 15.0)
		15
		30_seconds
	)

	; Dialogue
	(sleep (ai_play_line_at_player (object_get_ai g_cov_commander) 0520)) ; "There, that Scarab..."

	; And do it again
	(sleep_until 
		(and
			(objects_can_see_object (players) e2_exit_door 15.0)
			(game_safe_to_save)
		)
		15
		300
	)
	(sleep_until 
		(objects_can_see_object (players) e2_exit_door 15.0)
		15
		30_seconds
	)
	
	; Dialogue
	(sleep (ai_play_line_at_player (object_get_ai g_cov_commander) 0530)) ; "At the end of the beach is a door..."
	(game_save)
	
	; Objectives
	(wake objective0_clear)
	(wake objective1_set)

	; Wait for the Wraiths to be dead
	(sleep_until
		(and
			(> (ai_spawn_count e2_pro_wraith0) 0)
			(<= (ai_living_count e2_pro_wraith0) 0)
			(volume_test_objects tv_e2_near_perimeter (players))
			(game_safe_to_save)
		)
	)
	
	; More dialogue
	(sleep (ai_play_line_at_player (object_get_ai g_cov_commander) 0540)) ; "I'll cover your back"
)

(script dormant e2_door_unlocker
	; Wait until the Wraiths are dead, and then unlock the door
	(sleep_until
		(and
			(> (ai_spawn_count e2_pro_wraith0) 0)
			(<= (ai_living_count e2_pro_wraith0) 0)
		)
	)
	
	; And for the player to be close
	(sleep_until (volume_test_objects tv_e3_main_begin (players)) 15)
	
	; Unlock exit door
	(device_operates_automatically_set e2_exit_door true) 
)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e2_pro_phantom0_0_entry
	(cs_fly_to e2_pro_phantom0_0/p0)
	(cs_fly_to_and_face e2_pro_phantom0_0/p1 e2_pro_phantom0_0/p1_facing)
)

(script command_script cs_e2_pro_phantom0_0_exit
	(cs_fly_to_and_face e2_pro_phantom0_0/p1 e2_pro_phantom0_0/p1_facing)
	(cs_fly_to_and_face e2_pro_phantom0_0/p1 e2_pro_phantom0_0/p2 0.5)
	(cs_fly_to_and_face e2_pro_phantom0_0/p2 e2_pro_phantom0_0/p3 1)
	(cs_vehicle_boost true)
	(cs_fly_by e2_pro_phantom0_0/p3)
	(ai_erase ai_current_squad)
)


;- Order Scripts ---------------------------------------------------------------

(script static void e2_pro_ghosts0_enter
	(ai_enter_squad_vehicles ai_current_squad)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e2_pro_phantoms0_main
	(ai_place e2_pro_phantom0_0)
	
	; Wait until it should retreat
	(sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get e2_pro_phantom0_0/phantom0)) 0.05) 
			(>= (object_model_targets_destroyed (ai_vehicle_get e2_pro_phantom0_0/phantom0) "target_front") 3) 
		)
		30
		one_minute
	)
	
	; Retreat
	(cs_run_command_script e2_pro_phantom0_0/phantom0 cs_e2_pro_phantom0_0_exit)
	
	; Music
	(wake music_08b_01_stop)
	(wake music_08b_02_start)
)

(script dormant e2_pro_wraiths0_main
	(sleep 150)
	(sleep_until 
		(or
			(volume_test_objects tv_e2_pro_wraiths0_begin (players)) 
			(<= (ai_living_count e2_pro_phantom0) 0) 
		)
		15
	)
	(ai_place e2_pro_wraith0)
	
	(sleep_until (<= (ai_living_count e2_pro_wraith0) 0))
	(game_save)
)

(script dormant e2_pro_ghosts0_main
	(ai_place e2_pro_ghosts0)
)

(script dormant e2_pro_inf0_main
	(sleep_until (volume_test_objects tv_e2_near_perimeter (players)) 15)
	(ai_place e2_pro_inf0)
	
	(sleep_until (<= (ai_living_count e2_pro_inf0) 0))
	(game_save)
)

(script dormant e2_cov_wraith0_main
	(ai_migrate e1_cov_wraiths0 e2_cov_wraith0)
)

(script dormant e2_cov_spectre0_main
	(ai_migrate e1_cov_spectre0 e2_cov_spectre0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e2_main
	(sleep_until (volume_test_objects tv_e2_main_begin (players)) 15)
	(set g_e2_started true)
	(game_save)
	(print "e2_main")
	(data_mine_set_mission_segment "e2_scarab_cove")
	
	; Wake subsequent scripts
	(wake e3_main)

	; Wake control scripts
	(wake e2_cov_spectre0_main)
	(wake e2_cov_wraith0_main)
	(wake e2_pro_inf0_main)
;	(wake e2_pro_ghosts0_main)
	(wake e2_pro_wraiths0_main)
	(wake e2_pro_phantoms0_main)
	(wake e2_dialogue)
	(wake e2_door_unlocker)
	
	; Condemn
	(sleep_until g_e3_started)
	(ai_disposable e2_pro true)
	(ai_disposable e2_pro_phantom0 false)
	
	; Shut down
	(sleep_until g_e4_started)
	(sleep_forever e2_cov_spectre0_main)
	(sleep_forever e2_cov_wraith0_main)
	(sleep_forever e2_pro_inf0_main)
	(sleep_forever e2_pro_ghosts0_main)
	(sleep_forever e2_pro_wraiths0_main)
	(sleep_forever e2_pro_phantoms0_main)
	
	; More condemning
	(ai_disposable e2_cov true)
)

(script static void test_scarab_cove
	(object_teleport (player0) e2_test)
	(if (not g_e2_started) (wake e2_main))
	(ai_place e2_cov_wraith0)
	(ai_place e2_cov_spectre0)
)


;= ENCOUNTER 1 ===========================================================================
;*
The Dervish starts off with a Wraith, and promptly puts it to good use against
Brute Ghosts and Jackal gun emplacements in the canyon.

Begins at the start of the level.
Ends when the Dervish nears the canyon exit.

Elites
	e1_cov_wraiths0 - Allied Covenant Wraiths, initially two in number
		(folllow) - Follow the Dervish
	e1_cov_spectre0 - Allied Covenant Specter
		() - Eh, just use the Wraith orders above :)

Prophets
	e1_pro_ghosts0 - Ghosts which form packs to harass the Wraiths
		_0 - Ghosts around the first bend
		_1 - Ghosts around the second bend
		_2 - Ghosts around the final bend
			(engage0) - The first front, engaging in the first leg of the canyon
			(regroup0) - Regrouping around the first bend
			(engage1) - The second front, in the second leg of the canyon
			(regroup1) - Regroup around the second bend
			(engage2) - The third front, in the third leg
			(regroup2) - Regroup at the cove entrance
				...
	e1_pro_inf0 - Sniper and mortar teams on ledges and rocks
		_0 - First team on the first ledge
			(init)
		_1 - Second team, on the second ledge
			(init)

Open Issues
- Need flying vehicles to set up Phantom correctly

*;

;- Globals ---------------------------------------------------------------------

(global boolean g_e1_started false)			; Encounter has been activated?

(global short g_e1_ghosts_weak 1)			; Ghosts considered weak when <=
(global short g_e1_ghosts_strong 3)			; Ghosts considered strong when >=
(global short g_e1_ghosts_per_leg 10)		; The most ghosts spawned per leg


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e1_pro_phantom0_exit
	(cs_fly_to_and_face e1_pro_phantom0_exit/p0 e1_pro_phantom0_exit/p1 1.0)
	(cs_fly_by e1_pro_phantom0_exit/p1)
	(cs_fly_by e1_pro_phantom0_exit/p2)
	(cs_fly_to_and_face e1_pro_phantom0_exit/p3 e1_pro_phantom0_exit/p4)
	(cs_vehicle_boost true)
	(cs_fly_by e1_pro_phantom0_exit/p4)
	(ai_erase ai_current_squad)
)

(script command_script cs_e1_pro_phantom0_entry
	(cs_fly_by e1_pro_phantom0_entry/p0)
	(cs_fly_to_and_face e1_pro_phantom0_entry/p1 e1_pro_phantom0_entry/p1_facing 0.5)
	(cs_fly_to e1_pro_phantom0_entry/p2 0.5)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_lc")
	(ai_braindead e1_pro_wraith0 false)
	(sleep 30)
	(cs_fly_by e1_pro_phantom0_entry/p1 0.5)
	(cs_fly_to_and_face e1_pro_phantom0_exit/p0 e1_pro_phantom0_exit/p1 1.0)
	(cs_fly_by e1_pro_phantom0_exit/p1)
	(cs_fly_by e1_pro_phantom0_exit/p2)
	(cs_fly_to_and_face e1_pro_phantom0_exit/p3 e1_pro_phantom0_exit/p4)
	(cs_vehicle_boost true)
	(cs_fly_by e1_pro_phantom0_exit/p4)
	(ai_erase ai_current_squad)
)

(script command_script cs_e1_cov_spectre0_init
	(cs_go_to e1_cov_spectre0_entry/p0)
	(ai_overcomes_oversteer ai_current_actor true) 

	(cs_face true e1_cov_spectre0_entry/p1)
	(sleep_until
		(or
			(and
				(players_in_vehicle)
				(unit_in_vehicle g_cov_commander)
			)
			(volume_test_objects tv_e1_canyon_entry (players))
		)
		10	
	)
	(ai_overcomes_oversteer ai_current_actor false) 
	(cs_face false e1_cov_spectre0_entry/p1)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location e1_cov_spectre0/spectre0))
)

(script command_script cs_e1_cov_spectre0_passenger
	; Hey check me out!
	(cs_look_player true)
	(cs_face_player true)
	(sleep_until
		(and
			(players_in_vehicle)
			(unit_in_vehicle g_cov_commander)
		)
		10
	)
	(cs_look_player false)
	(cs_face_player false)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location e1_cov_spectre0/spectre0))
)

(script command_script cs_e1_cov_commander0_legendary
	(cs_face_player true)
	
	; Wait for the player to enter a vehicle...
	(sleep_until
		(or
			; Both in vehicle
			(players_in_vehicle)
			
			; Player is far away...
			(volume_test_objects tv_e1_canyon_entry (players))
		)
		15
	)	
	(cs_look_player false)
	(cs_face_player false)
)
	
(script command_script cs_e1_cov_commander0_init
	; Climb out of the Wraith
	(ai_vehicle_exit ai_current_actor)

	; Wait until we're out of the vehicle
	(sleep_until (not (unit_in_vehicle (ai_get_unit ai_current_actor))) 5)
	
	; Approach the player
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_cov_spectre0_entry/soc_p0)
	(cs_face_player true)
	
	; Wait for the player to enter a vehicle...
	(sleep_until
		(or
			; Is the player in the Wraith, or are both players in a vehicle?
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location e1_cov_wraiths0_0/wraith0) "wraith_d" (players))

			; Both in vehicle
			(players_in_vehicle)
			
			; Player is far away...
			(volume_test_objects tv_e1_canyon_entry (players))
		)
		15
	)	
	(cs_look_player false)
	(cs_face_player false)

	; Was it the Wraith?
	(if (vehicle_test_seat_list (ai_vehicle_get_from_starting_location e1_cov_wraiths0_0/wraith0) "wraith_d" (players))
		; It was the Wraith, go take a seat in the Specter. If the gunner seat is occupied...
		(cs_go_to_vehicle (ai_vehicle_get_from_starting_location e1_cov_spectre0/spectre0))

		; It wasn't the Wraith, reclaim the Wraith
		(cs_go_to_vehicle (ai_vehicle_get_from_starting_location e1_cov_wraiths0_0/wraith0))
	)
)

(script command_script cs_e1_pro_ghosts0_2_entry0
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_go_to e1_pro_ghosts0_entry/p8)
)

(script command_script cs_e1_pro_ghosts0_2_entry1
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_go_to e1_pro_ghosts0_entry/p9)
	(cs_go_to e1_pro_ghosts0_entry/p10)
)

(script command_script cs_e1_pro_ghosts0_1_entry0
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_go_to e1_pro_ghosts0_entry/p5)
)

(script command_script cs_e1_pro_ghosts0_1_entry1
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_go_to e1_pro_ghosts0_entry/p6)
	(cs_go_to e1_pro_ghosts0_entry/p7)
)

(script command_script cs_e1_pro_ghosts0_0_entry0
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_go_to e1_pro_ghosts0_entry/p0)
)

(script command_script cs_e1_pro_ghosts0_0_entry1
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_vehicle_boost true)
	(cs_go_to e1_pro_ghosts0_entry/p2)
	(cs_go_to e1_pro_ghosts0_entry/p3)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e1_pro_ghosts0_weak
	(<= (+ (ai_living_count e1_pro_ghosts0) (ai_living_count e1_pro_wraith0)) g_e1_ghosts_weak)
)

(script static boolean e1_pro_ghosts0_strong
	(>= (+ (ai_living_count e1_pro_ghosts0) (ai_living_count e1_pro_wraith0)) g_e1_ghosts_strong)
)


;- Event Controls --------------------------------------------------------------

(script dormant e1_weather
	(sleep_until (volume_test_objects tv_e1_advance0 (players)) 16)
	(weather_change_intensity 60 0.4)
	(sleep_until (volume_test_objects tv_e1_advance1 (players)) 16)
	(weather_change_intensity 60 0.7)
	(sleep_until (volume_test_objects tv_e1_advance2 (players)) 16)
	(weather_change_intensity 60 1.0)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e1_pro_phantom0_main
	(sleep_until (volume_test_objects tv_e1_advance1 (players)) 15)
;	(ai_place e1_pro_phantom0)
;	(sleep 2)
;	(ai_place_in_vehicle e1_pro_wraith0 e1_pro_phantom0)
;	(ai_braindead e1_pro_wraith0 true)
	(ai_place e1_pro_wraith0)
	
	; Wait for the retreat
;*	(sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get e1_pro_phantom0/phantom0)) 0.05) 
			(>= (object_model_targets_destroyed (ai_vehicle_get e1_pro_phantom0/phantom0) "target_front") 3) 
			(volume_test_objects tv_e1_advance3 (players))
		)
		30
		one_minute
	)
	(cs_run_command_script e1_pro_phantom0/phantom0 cs_e1_pro_phantom0_exit)
*;
	; Music
	(sleep_until (volume_test_objects tv_e1_advance3 (players)) 15)
	(wake music_08b_01_start_alt)
)

(script dormant e1_pro_ghosts0_main
	(sleep_until (volume_test_objects tv_e1_canyon_entry (players)) 15)

	; Place the first batch
	(ai_place e1_pro_ghosts0_0)

	; Spawn guys from here until the player is near
	(sleep_until
		(begin
			; If we're weak...
			(if (e1_pro_ghosts0_weak)
				; Spawn until we're strong, overspawned, or player advanced
				(sleep_until
					(begin
						; Spawn a ghost
						(ai_place e1_pro_ghosts0_0 1)
					
						; Condition: strong, overspawned, advanced
						(or
							(e1_pro_ghosts0_strong)
							(>= (ai_spawn_count e1_pro_ghosts0_0) g_e1_ghosts_per_leg)
							(volume_test_objects tv_e1_advance0 (players))
						)
					)
				)
			)
		
			; End if the player has advanced
			(volume_test_objects tv_e1_advance0 (players))			
		)
	)
	
	; Save
	(game_save_no_timeout)
	
	; Spawn guys from the next point until the player is near
	(sleep_until
		(begin
			; If we're weak...
			(if (e1_pro_ghosts0_weak)
				; Spawn until we're strong, overspawned, or player advanced
				(sleep_until
					(begin
						; Spawn a ghost
						(ai_place e1_pro_ghosts0_1 1)
					
						; Condition: strong, overspawned, advanced
						(or
							(e1_pro_ghosts0_strong)
							(>= (ai_spawn_count e1_pro_ghosts0_1) g_e1_ghosts_per_leg)
							(volume_test_objects tv_e1_advance2 (players))
						)
					)
				)
			)
		
			; End if the player has advanced
			(volume_test_objects tv_e1_advance2 (players))			
		)
	)

	; Save (if we're lucky)
	(game_save_no_timeout)
	
	; Spawn guys from the last point until the player is near
	(sleep_until
		(begin
			; If we're weak...
			(if (e1_pro_ghosts0_weak)
				; Spawn until we're strong, overspawned, or player advanced
				(sleep_until
					(begin
						; Spawn a ghost
						(ai_place e1_pro_ghosts0_2 1)
					
						; Condition: strong, overspawned, advanced
						(or
							(e1_pro_ghosts0_strong)
							(>= (ai_spawn_count e1_pro_ghosts0_2) g_e1_ghosts_per_leg)
							(volume_test_objects tv_e1_advance4 (players))
						)
					)
				)
			)
		
			; End if the player has advanced
			(volume_test_objects tv_e1_advance4 (players))			
		)
	)

	; Save (if we're lucky)
	(game_save)
)

(script dormant e1_pro_inf0_main
	(sleep_until (volume_test_objects tv_e1_advance1 (players)))
	(ai_place e1_pro_inf0_0)
)

(script dormant e1_cov_spectre0_main
	(ai_place e1_cov_spectre0)
	(sleep 10)
	(object_type_predict "objects\vehicles\spectre\spectre")
)

(script dormant e1_cov_wraiths0_main
	(ai_place e1_cov_wraiths0_0) ; Player 0's wraith
	
	; Setup the commander
	(object_cannot_die (ai_get_object e1_cov_wraiths0_0/wraith0) true)
	(set g_cov_commander (ai_get_unit e1_cov_wraiths0_0/wraith0))
	
	; If not legendary, tell him to get out and offer up his Wraith
	(if (difficulty_legendary)
		(begin
			(unit_set_enterable_by_player (ai_vehicle_get e1_cov_wraiths0_0/wraith0) false)
			(cs_run_command_script e1_cov_wraiths0_0/wraith0 cs_e1_cov_commander0_legendary)
		)
		(cs_run_command_script e1_cov_wraiths0_0/wraith0 cs_e1_cov_commander0_init)
	)

	; Wait for the player to enter a vehicle or to hit the trigger volume
	(sleep_until 
		(or
			(players_in_vehicle)
			(volume_test_objects tv_e1_canyon_entry (players))
		)
		15
	)
	
	; Music
	(wake music_08b_01_start)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e1_main
	(set g_e1_started true)
	(print "e1_main")
	(data_mine_set_mission_segment "e1_wraith_canyon")

	; Objectives
	(wake objective0_set)

	; Wake subsequent scripts
	(wake e2_main)

	; Wake control scripts
	(wake e1_cov_wraiths0_main)
	(wake e1_cov_spectre0_main)
	(wake e1_pro_ghosts0_main)
	(wake e1_pro_phantom0_main)
	(wake e1_pro_inf0_main)
	(wake e1_weather)
	
	; Condemn
	(sleep_until g_e2_started)
	(ai_disposable e1_pro true)
	(ai_disposable e1_pro_phantom0 false)
	
	; Shut down
	(sleep_until g_e3_started)
	(sleep_forever e1_cov_wraiths0_main)
	(sleep_forever e1_pro_ghosts0_main)
	(sleep_forever e1_pro_phantom0_main)
	(sleep_forever e1_pro_inf0_main)
)


;= MISSION MAIN ==========================================================================

(script dormant mission_start
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
	
	; Wake the key encounters
	(wake e1_main)
	
	; Fade in
	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 15)
	(cinematic_fade_from_white_bars)
	
	; Chapter titles
	(wake chapter_title0)
	
	; Wait for the mission to end
	(sleep_until g_mission_over 5)
	
	; For playtests
	(playtest_mission)
	(sleep 15)
	
	; Fade to white and win
	(object_cannot_take_damage (players))
;	(cinematic_fade_to_white) ; Jaime does this is (tartarus_boss_fight)

	; Stash the players around the corner
	(object_teleport (player0) player0_stash)
	(object_teleport (player1) player1_stash)
	
	; Run the cinematic
	(cinematic_epilogue)
	(game_won)
)

(script static void start
	(wake mission_start)
)

(script startup mission_main
	; Necessary startup stuff
	(ai_allegiance player covenant)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	
	; Weather
	(weather_start 0)
	(weather_change_intensity 0 0.1)
	
	; Kill volumes
	(kill_volume_disable kill_e13_0)
	
	; Begin the mission
	; Comment this out when you're testing individual encounters
	(if (> (player_count) 0 ) (start))
)

