;= EARTHCITY =============================================================================
;*
Open issues

General
- Snipers in general
- Watchtower seems a bit awkward
- Too difficult across the board

e1
- Everyone goes into the rubble pile, misses the door
- Johnson is not reliably making his way to the top floor
- Is it too long? Should I prune a wave out?

e8
- Creep not driveable on normal

e11
- Grunt turrets on beach fort

e12
- Perhaps one, substantial blockade?

e13
- Seems to end before the Creeps reach the end
- Need something to keep the player around to finish fighting at the end


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


;- Stubs -----------------------------------------------------------------------

(script stub void c03_intro (print "c03_intro (cinematics didn't compile)"))
(script stub void chief_recovery_sequence (print "chief_recovery_sequence (cinematics didn't compile)"))


;= SINEMATICS ============================================================================

(script static void cinematic_intro
	(if (cinematic_skip_start)
		(begin
			(c03_intro)
		)
	)
	(cinematic_skip_stop)
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
	(sleep 30)
	(objectives_show_up_to 4)
)

(script dormant objective4_clear
	(objectives_finish_up_to 4)
)


;= MUSIC =================================================================================

(script dormant music_03a_01_start
	; Phantom comes in
	(print "music 03a_01 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_01" none 1.0)
)

(script dormant music_03a_01_stop
	; Hunters break through, or e3 begins
	(print "music 03a_01 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_01")
)

(script dormant music_03a_02_stop_alt
	; Switch back after a period
	(sleep two_minutes)
	(print "music 03a_02 stop alt")
	(sound_looping_set_alternate "scenarios\solo\03a_oldmombasa\03a_music\03a_02" false)
)

(script dormant music_03a_02_stop
	; Auto stop. If this doesn't stop it, another call to 03a_02_stop will
	(sleep one_minute)

	; Hunters dead or pushed through
	(print "music 03a_02 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_02")

	; And stop the alt stopper, if it's running
	(sleep_forever music_03a_02_stop_alt)
)

(script dormant music_03a_02_start_alt
	; Hunters break through
	(print "music 03a_02 start alt")
	(sound_looping_set_alternate "scenarios\solo\03a_oldmombasa\03a_music\03a_02" true)
	
	; Early stop
;	(wake music_03a_02_stop) Commented out for Marty
	(wake music_03a_02_stop_alt)
)

(script dormant music_03a_02_start
	; Johnson orders to open the door (e2 begins)
	(print "music 03a_02 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_02" none 1.0)
)

(script dormant music_03a_03_start
	; Johnson departs
	(print "music 03a_03 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_03" none 1.0)
)

(script dormant music_03a_03_stop
	; Ambush encounter (e5)
	(print "music 03a_03 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_03")
)

(script dormant music_03a_04_start
	; Marine greeting
	(print "music 03a_04 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_04" none 1.0)
)

(script dormant music_03a_04_stop
	; Hotel exit (e8)
	(print "music 03a_04 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_04")
)

(script dormant music_03a_05_start
	; Start of e9
	(sleep 60)
	(print "music 03a_05 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_05" none 1.0)
)

(script dormant music_03a_05_stop
	; Beach 1
	(print "music 03a_05 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_05")
)

(script dormant music_03a_06_start
	; Beach 1
	(print "music 03a_06 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_06" none 1.0)
)

(script dormant music_03a_06_stop
	; Beach 1
	(print "music 03a_06 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_06")
)

(script dormant music_03a_065_start
	; Beach 1
	(print "music 03a_065 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_065" none 1.0)
)

(script dormant music_03a_065_stop
	; Auto stop
	(sleep two_minutes)
	(print "music 03a_065 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_065")
)

(script dormant music_03a_065_start_alt
	(print "music 03a_065 start alt")
	(sound_looping_set_alternate "scenarios\solo\03a_oldmombasa\03a_music\03a_065" true)
	
	; Early stop
	(wake music_03a_065_stop)
)

(script dormant music_03a_066_start
	; Beach 1
	(print "music 03a_066 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_066" none 1.0)
)

(script dormant music_03a_067_start
	(print "music 03a_067 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_067" none 1.0)
)

(script dormant music_03a_067_stop
	(print "music 03a_067 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_067")
)

(script dormant music_03a_07_start
	; Creep chase begins
	(print "music 03a_07 start")
	(sound_looping_start "scenarios\solo\03a_oldmombasa\03a_music\03a_07" none 1.0)
)

(script dormant music_03a_07_stop
	; Creep chase ends, final encounter
	(print "music 03a_07 stop")
	(sound_looping_stop "scenarios\solo\03a_oldmombasa\03a_music\03a_07")
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
				(or
					(= (structure_bsp_index) 2)
					(volume_test_objects tv_dark_area0 (players))
					(volume_test_objects tv_dark_area1 (players))
					(volume_test_objects tv_dark_area2 (players))
					(volume_test_objects tv_dark_area3 (players))
				)
				(begin
					(game_can_use_flashlights true)
					(weapon_enable_warthog_chaingun_light true)
				)
				(begin
					(game_can_use_flashlights false)
					(weapon_enable_warthog_chaingun_light false)
				)
			)
		
			false
		)
		60
	)
)

;*
(script dormant loudspeakers
	(sleep_until
		; Check if anyone is close
	
		
	)
)
*;

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

(global boolean g_e13_creep_end0_free true)
(global boolean g_e13_creep_end1_free true)
(global boolean g_e13_creep_end2_free true)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e13_mars_continue
	(cs_go_to e13_mars_exit/p0)
	(cs_ignore_obstacles true)
	(cs_go_to e13_mars_exit/p1)
	(cs_ignore_obstacles false)
	(cs_go_to e13_mars_exit/p2)
)

(script command_script cs_e13_cov_creep0_unload
;	(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_l01")
;	(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_r01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_sc01")
	(ai_vehicle_exit ai_current_actor)
)

(script command_script cs_e13_cov_creep0_end0
	(cs_enable_pathfinding_failsafe true)
;	(cs_ignore_obstacles true)
;	(cs_vehicle_speed 0.5)
	(cs_go_to e13_cov_creep0_chase/first_end)
	(cs_face true e13_cov_creep0_chase/end_facing)
	(sleep 150)
	(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_unload)
)

(script command_script cs_e13_cov_creep0_end1
	(cs_enable_pathfinding_failsafe true)
;	(cs_ignore_obstacles true)
;	(cs_vehicle_speed 0.5)
	(cs_go_to e13_cov_creep0_chase/second_end)
	(cs_face true e13_cov_creep0_chase/end_facing)
	(sleep 150)
	(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_unload)
)

(script command_script cs_e13_cov_creep0_end2
	(cs_enable_pathfinding_failsafe true)
;	(cs_ignore_obstacles true)
;	(cs_vehicle_speed 0.5)
	(cs_go_to e13_cov_creep0_chase/third_end)
	(cs_face true e13_cov_creep0_chase/end_facing)
	(sleep 150)
	(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_unload)
)

(script command_script cs_e13_cov_creep0_drive1
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
;	(cs_ignore_obstacles true)
	(cs_go_to e13_cov_creep0_chase/p11)
	(cs_go_to e13_cov_creep0_chase/end)
	
	; Branch
	(cond
		((= g_e13_creep_end0_free true) (begin (cs_queue_command_script ai_current_actor cs_e13_cov_creep0_end0) (set g_e13_creep_end0_free false)))
		((= g_e13_creep_end1_free true) (begin (cs_queue_command_script ai_current_actor cs_e13_cov_creep0_end1) (set g_e13_creep_end1_free false)))
		((= g_e13_creep_end2_free true) (begin (cs_queue_command_script ai_current_actor cs_e13_cov_creep0_end2) (set g_e13_creep_end2_free false)))
	)
)

;*
(script command_script cs_e13_cov_creep0_drive0
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true)
;	(cs_go_by e13_cov_creep0_chase/p0 e13_cov_creep0_chase/p1)
;	(cs_go_by e13_cov_creep0_chase/p1 e13_cov_creep0_chase/p2)
	(cs_go_by e13_cov_creep0_chase/p2 e13_cov_creep0_chase/p2_0)
	(cs_ignore_obstacles false)
	(cs_go_by e13_cov_creep0_chase/p2_0 e13_cov_creep0_chase/p3)
	(cs_go_by e13_cov_creep0_chase/p3 e13_cov_creep0_chase/p4)
	(cs_vehicle_boost false)
	(cs_go_by e13_cov_creep0_chase/p4 e13_cov_creep0_chase/p5)
	(cs_vehicle_boost true)
	(cs_go_by e13_cov_creep0_chase/p5 e13_cov_creep0_chase/p5_1)
	(cs_go_by e13_cov_creep0_chase/p5_1 e13_cov_creep0_chase/p6)
	(cs_go_by e13_cov_creep0_chase/p6 e13_cov_creep0_chase/p7)
	(cs_go_by e13_cov_creep0_chase/p7 e13_cov_creep0_chase/p8)
	(cs_vehicle_boost false)
	(cs_go_by e13_cov_creep0_chase/p8 e13_cov_creep0_chase/p9_0)
	(cs_vehicle_boost true)
	(cs_go_by e13_cov_creep0_chase/p9_0 e13_cov_creep0_chase/p9_1)
	(cs_go_by e13_cov_creep0_chase/p9_1 e13_cov_creep0_chase/p10)
	(cs_go_to e13_cov_creep0_chase/p10 1.0)
)
*;

(script command_script cs_e13_cov_creep0_drive0
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_ignore_obstacles true)
	(cs_go_to e13_cov_creep0_chase/p2 1.0)
	(cs_ignore_obstacles false)
	(cs_go_to e13_cov_creep0_chase/p2_0 1.0)
	(cs_go_to e13_cov_creep0_chase/p3 1.0)
	(cs_go_to e13_cov_creep0_chase/p4 1.0)
	(cs_go_to e13_cov_creep0_chase/p5 1.0)
	(cs_go_to e13_cov_creep0_chase/p5_1 1.0)
	(cs_go_to e13_cov_creep0_chase/p6 1.0)
	(cs_go_to e13_cov_creep0_chase/p7 0.5)
	(cs_go_to e13_cov_creep0_chase/p8 1.0)
	(cs_go_to e13_cov_creep0_chase/p9_0 1.0)
	(cs_go_to e13_cov_creep0_chase/p9_1 1.0)
	(cs_go_to e13_cov_creep0_chase/p10 1.0)
)

(script command_script cs_e13_cov_creep0_0_decision
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
;	(cs_ignore_obstacles true)

	; Continue?
	(if
		; Continue if both leaders are dead
		(and
			(<= (ai_living_count e13_cov_creep0_1/creep0) 0)
			(<= (ai_living_count e13_cov_creep0_2/creep0) 0)
		)
		; Continue
		(begin
			(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_drive1)
			(ai_set_orders ai_current_squad e13_cov_creep0_defend)
		)
		
		; Stand and deliver
		(begin
			(cs_go_to e13_cov_creep0_mid/creep0_0_mid)
			(cs_vehicle_boost false)
			(cs_face true e13_cov_creep0_mid/creep0_0_mid_facing)
			(sleep 60)
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_l01")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_r01")
			(sleep 60)
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_sc01")
			(ai_vehicle_exit ai_current_actor)
			(sleep 30)
			(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost0))
		)
	)
)

(script command_script cs_e13_cov_creep0_1_decision
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
;	(cs_ignore_obstacles true)

	; Continue?
	(if
		; Continue if the other two are dead
		(and
			(<= (ai_living_count e13_cov_creep0_0/creep0) 0)
			(<= (ai_living_count e13_cov_creep0_2/creep0) 0)
		)
		; Continue
		(begin
			(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_drive1)
			(ai_set_orders ai_current_squad e13_cov_creep0_defend)
		)
		
		; Stand and deliver
		(begin
			(cs_go_to e13_cov_creep0_mid/creep0_1_mid)
			(cs_vehicle_boost false)
			(cs_face true e13_cov_creep0_mid/creep0_1_mid_facing)
			(sleep 60)
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_l01")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_r01")
			(sleep 60)
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_sc01")
			(ai_vehicle_exit ai_current_actor)
			(sleep 30)
			(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost1))
		)
	)
)

(script command_script cs_e13_cov_creep0_2_decision
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
;	(cs_ignore_obstacles true)

	; Continue?
	(if
		; Continue if neither of the other two are dead
		(and
			(> (ai_living_count e13_cov_creep0_0/creep0) 0)
			(> (ai_living_count e13_cov_creep0_1/creep0) 0)
		)
		; Continue
		(begin
			(cs_queue_command_script ai_current_actor cs_e13_cov_creep0_drive1)
			(ai_set_orders ai_current_squad e13_cov_creep0_defend)
		)
		
		; Stand and deliver
		(begin
			(cs_go_to e13_cov_creep0_mid/creep0_2_mid)
			(cs_vehicle_boost false)
			(cs_face true e13_cov_creep0_mid/creep0_2_mid_facing)
			(sleep 60)
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_l01")
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_p_r01")
			(sleep 60)
			(vehicle_unload (ai_vehicle_get ai_current_actor) "creep_sc01")
			(ai_vehicle_exit ai_current_actor)
			(sleep 30)
			(ai_vehicle_enter ai_current_actor (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost2))
		)
	)
)

(script command_script cs_e13_mars_warthog0_drive
	(cs_enable_pathfinding_failsafe true)
	(cs_abort_on_alert true)
	(cs_go_by e13_mars_warthog1_ketchup/p0 e13_mars_warthog1_ketchup/p1)	
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e13_end_clear
	(not (volume_test_objects tv_e13_end_area (ai_actors e13_cov)))
)

(script static boolean e13_waypoint1_clear
	(not (volume_test_objects tv_e13_waypoint1 (ai_actors e13_cov)))
)

(script static boolean e13_waypoint1
	(volume_test_objects tv_e13_waypoint1 (ai_actors ai_current_squad))
)

(script static boolean e13_waypoint0
	(volume_test_objects tv_e13_waypoint0 (ai_actors ai_current_squad))
)

(script static void e13_mars_exit
	(cs_run_command_script ai_current_squad cs_e13_mars_continue)
)


;- Event Controls --------------------------------------------------------------

(script dormant e13_navpoints
	; Tag the first Creep
	(activate_team_nav_point_object default player (ai_vehicle_get_from_starting_location e13_cov_creep0_0/creep0) 1.5)	

	; Sleep until it is dead, or Creep 1 is closer
	(sleep_until
		(or
			(<= (unit_get_health (ai_get_unit e13_cov_creep0_0/creep0)) 0)
			(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e13_cov_creep0_1/creep0)) (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e13_cov_creep0_0/creep0)))
			(volume_test_objects tv_e13_waypoint1 (players))
		)
	)

	; Advance
	(deactivate_team_nav_point_object player (ai_vehicle_get_from_starting_location e13_cov_creep0_0/creep0))	
	(activate_team_nav_point_object default player (ai_vehicle_get_from_starting_location e13_cov_creep0_1/creep0) 1.5)	

	; Sleep until it is dead, or Creep 2 is closer
	(sleep_until
		(or
			(<= (unit_get_health (ai_get_unit e13_cov_creep0_1/creep0)) 0)
			(< (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e13_cov_creep0_2/creep0)) (objects_distance_to_object (players) (ai_vehicle_get_from_starting_location e13_cov_creep0_1/creep0)))
			(volume_test_objects tv_e13_waypoint1 (players))
		)
	)

	; Advance
	(deactivate_team_nav_point_object player (ai_vehicle_get_from_starting_location e13_cov_creep0_1/creep0))	
	(activate_team_nav_point_object default player (ai_vehicle_get_from_starting_location e13_cov_creep0_2/creep0) 1.5)	

	; Sleep until it is dead, or we're at the midpoint
	(sleep_until
		(or
			(<= (unit_get_health (ai_get_unit e13_cov_creep0_2/creep0)) 0)
			(volume_test_objects tv_e13_waypoint1 (players))
		)
	)

	; Deactivate
	(deactivate_team_nav_point_object player (ai_vehicle_get_from_starting_location e13_cov_creep0_2/creep0))

	; If the last Creep is alive...
	(if (> (unit_get_health (ai_get_unit e13_cov_creep0_3/creep0)) 0)
		(begin
			(activate_team_nav_point_object default player (ai_vehicle_get_from_starting_location e13_cov_creep0_3/creep0) 1.5)	
			(sleep_until
				(or
					(<= (unit_get_health (ai_get_unit e13_cov_creep0_3/creep0)) 0)
					(volume_test_objects tv_e13_end_entrance (players))
				)
			)
		)
	)

	; Deactivate
	(deactivate_team_nav_point_object player (ai_vehicle_get_from_starting_location e13_cov_creep0_3/creep0))
)


;- Squad Controls --------------------------------------------------------------

(script dormant e13_cov_ghosts1_main
	(sleep_until 
		(volume_test_objects tv_e13_cov_creep0_6_begin (players)) 
		15
	)
	(ai_place e13_cov_ghosts1)
)

(script dormant e13_cov_creep0_ghost_aux
	(sleep_until 
		(volume_test_objects tv_e13_creep0_begin (players)) 
		15
	)
	
	; Load the Ghosts into the Creeps
	(vehicle_load_magic (ai_vehicle_get_from_starting_location e13_cov_creep0_0/creep0) "creep_sc01" (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location e13_cov_creep0_1/creep0) "creep_sc01" (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location e13_cov_creep0_2/creep0) "creep_sc01" (ai_vehicle_get_from_starting_location e13_cov_ghosts0/ghost2))

	; Unloads Ghosts from Creeps 
	(sleep_until
		(begin
			(if (<= (ai_living_count e13_cov_creep0_0/creep0) 0) (vehicle_unload (ai_vehicle_get_from_starting_location e13_cov_creep0_0/creep0) "creep_sc01"))
			(if (<= (ai_living_count e13_cov_creep0_1/creep0) 0) (vehicle_unload (ai_vehicle_get_from_starting_location e13_cov_creep0_1/creep0) "creep_sc01"))
			(if (<= (ai_living_count e13_cov_creep0_2/creep0) 0) (vehicle_unload (ai_vehicle_get_from_starting_location e13_cov_creep0_2/creep0) "creep_sc01"))
		
			; Loop forever (mission will end soon)
			false
		)
		60
	)
)

(script dormant e13_cov_creep0_main
	(sleep_until (volume_test_objects tv_e13_creep0_begin (players)))

	; Muzak
	(wake music_03a_067_stop)
	(wake music_03a_07_start)

	; Place the Creeps
	(ai_place e13_cov_ghosts0)
	(ai_place e13_cov_creep0_0)
	(ai_place e13_cov_creep0_1)
	(ai_place e13_cov_creep0_2)
	(sleep 2)
	
	; Load the Ghosts into the Creeps
	(wake e13_cov_creep0_ghost_aux)
	
	; Apply command scripts
	(cs_queue_command_script e13_cov_creep0_0/creep0 cs_e13_cov_creep0_0_decision)
	(cs_queue_command_script e13_cov_creep0_1/creep0 cs_e13_cov_creep0_1_decision)
	(cs_queue_command_script e13_cov_creep0_2/creep0 cs_e13_cov_creep0_2_decision)
	
	; Wait until we're into the tunnel for some dialog
	(sleep_until (volume_test_objects tv_e13_dialog (players)))
	(sleep (ai_play_line_on_object none 0590)) ; "Don't let them regroup"
	
	; Wake the navpoints if it's normal
;	(if (difficulty_normal) (wake e13_navpoints))
	
	; Wait till the player or creeps approach the second onramp
	(sleep_until 
		(volume_test_objects tv_e13_cov_creep0_reins0 (players)) 
		15
	)
	
	; Try to sneak in a save
	(game_save)
	
	; Spawn replacements
	(if 
		(or
			(<= (ai_living_count e13_cov_creep0_0/creep0) 0) 
			(<= (ai_living_count e13_cov_creep0_1/creep0) 0) 
			(<= (ai_living_count e13_cov_creep0_2/creep0) 0) 
		)
		(ai_place e13_cov_creep0_3)
	)
	
	; Sleep till the player approaches the end of the tunnel
	(sleep_until 
		(volume_test_objects tv_e13_cov_creep0_6_begin (players)) 
		15
	)

	; Muzak
	(wake music_03a_07_stop)

	; Try to sneak in a save
	(game_save)
	
	; Place the final encounter
	(ai_place e13_cov_creep0_6)
	(sleep 30)
	(object_dynamic_simulation_disable (ai_vehicle_get_from_starting_location e13_cov_creep0_6/creep0) true)
)

(script dormant e13_mars_warthog0_main
	(ai_migrate e12_mars_warthog0 e13_mars_warthog0)
	(ai_migrate e12_mars_warthog1 e13_mars_warthog0)
	(ai_disposable e13_mars_warthog0 false)
	(ai_renew e13_mars_warthog0)
	(cs_run_command_script e13_mars_warthog0 cs_e13_mars_warthog0_drive)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e13_main
	(sleep_until (volume_test_objects tv_e13_main_begin (players)) 10)
	(set g_e13_started true)
	(print "e13_main")
	(data_mine_set_mission_segment "e13_tunnel_convoy")
	(game_save)

	; Wake control scripts
	(wake e13_mars_warthog0_main)
	(wake e13_cov_creep0_main)
	(wake e13_cov_ghosts1_main)
)

(script static void test_tunnel_convoy
	(switch_bsp 2)
	(object_teleport (player0) e13_test)
	(ai_place e13_mars_warthog0)
	(if (not g_e13_started) (wake e13_main))
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

(script command_script cs_e12_mars_horrible_cleanup
	(if 
		(and
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 50)
			(not (unit_in_vehicle (ai_get_unit ai_current_actor)))
		)
		
		; Go away
		(ai_erase ai_current_actor)
	)
)

(script command_script cs_e12_cov_inf0_ghost_drop
	(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) true)
	(ai_vehicle_exit ai_current_actor)
)

(script command_script cs_e12_cov_inf0_0_ghost0
	(sleep_until (>= (ai_combat_status e12_cov_inf0_0) ai_combat_status_active) 15)
	(cs_vehicle_boost true)
	(cs_go_to e12_patrol/p0_2)
)

(script command_script cs_e12_cov_inf0_0_patrol0
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_enable_looking true)
	(sleep_until
		(begin
			; p0
			(cs_go_to e12_patrol/p0_0)
			(sleep (random_range 30 60))

			; p1
			(cs_go_to e12_patrol/p0_1)
			(sleep (random_range 30 60))			
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e12_scarab_gunner
	(cs_shoot_point true e12_scarab/p0)
	(sleep 165)
)

(script command_script cs_e12_mars_warthog0_cleanup
	(if (not (volume_test_object tv_e12_mars_warthog0_preserve (ai_get_object ai_current_actor)))
		(ai_erase ai_current_actor)
	)
)

(script command_script cs_e12_ghosts_entry
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_moving true)
	(cs_vehicle_boost true)
	(sleep 150)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

; Lame ass single pass compiler
(script dormant e12_cov_ghosts0_main
	(sleep_until (volume_test_objects tv_e12_scarab_begin (players)) 15)
	(sleep_until (volume_test_objects tv_e12_cov_ghosts0_begin (players)) 15)
	(ai_place e12_cov_ghosts0)
)

(script static void scarab_walk_front_var0
	(print "scarab_walk_front_var0")
	(device_set_position_track tunnel_scarab combat:walk_front:var0 0)
	(device_animate_position tunnel_scarab 1.0 4 0 0 true)
	(sleep_until (>= (device_get_position tunnel_scarab) 1.0) 1)
)

(script dormant e12_event_warthog
	; Stuff rains down into the tunnel
	(object_create e12_warthog0)
	(object_set_velocity e12_warthog0 11 0 0.25)
)

(script dormant e12_event_scarab_gun
	; Create the gun, load it
	(object_create e12_scarab_gun)

	; Fire.
	(weapon_hold_trigger e12_scarab_gun 0 true)
	(sleep 90)
	(weapon_hold_trigger e12_scarab_gun 0 false)
	
	; Kick start the Ghosts
	(wake e12_cov_ghosts0_main)
	
	; Erase it
	(sleep 60)
	(object_destroy e12_scarab_gun)
)

(script dormant e12_event_scarab
	(sleep_until (volume_test_objects tv_e12_scarab_begin (players)) 8)
	
	; Send in the dead Warthog
	(wake e12_event_warthog)
	(sleep 26)
	
	; Do the gun events
	(wake e12_event_scarab_gun)

	; Music 
	(wake music_03a_066_start)
	(wake music_03a_067_start)
	
	; Scarab walks overhead
	(object_create tunnel_scarab)
	(pvs_set_object tunnel_scarab)
	
	; Walk to your end
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(scarab_walk_front_var0)
	(if (volume_test_objects tv_e12_scarab_begin (players))	(scarab_walk_front_var0))
	(if (volume_test_objects tv_e12_scarab_begin (players))	(scarab_walk_front_var0))
	(if (volume_test_objects tv_e12_scarab_begin (players))	(scarab_walk_front_var0))
	(if (volume_test_objects tv_e12_scarab_begin (players))	(scarab_walk_front_var0))
	(if (volume_test_objects tv_e12_scarab_begin (players))	(scarab_walk_front_var0))
	(if (volume_test_objects tv_e12_scarab_begin (players))	(scarab_walk_front_var0))
	(if (volume_test_objects tv_e12_scarab_begin (players))	(scarab_walk_front_var0))
	(if (volume_test_objects tv_e12_scarab_begin (players))	(scarab_walk_front_var0))
	
	; Destroy
	(object_destroy tunnel_scarab)
)

(script dormant e12_cortana_dialog
	(sleep 30)
	(sleep (ai_play_line_on_object none 0070)) ; "I've been analyzing..."
	(sleep 20)
	(sleep (ai_play_line_on_object none 0080)) ; "etc"
)


;- Squad Controls --------------------------------------------------------------

(script dormant e12_cov_creep0_main
	(sleep_until (volume_test_objects tv_e12_cov_inf0_5_begin (players)) 10)
	(ai_place e12_cov_creep0)
)

(script dormant e12_cov_inf0_main
	(ai_place e12_cov_inf0_0)
	
	; Second group, drag back the first
	(sleep_until (volume_test_objects tv_e12_cov_inf0_2_begin (players)) 10)
	(game_save)
	(ai_disposable e12_cov_inf0_0 true)
	(ai_place e12_cov_inf0_1)
;	(ai_migrate e12_cov_inf0_0 e12_cov_inf0_1)
	
	; Third group, and fourth group, after the jump
	(sleep_until (volume_test_objects tv_e12_cov_inf0_3_begin (players)) 10)
	(ai_disposable e12_cov_inf0_1 true)
	(ai_place e12_cov_inf0_2)
	(sleep_until (volume_test_objects tv_e12_cov_inf0_6_begin (players)) 10)
	(game_save)
	(ai_disposable e12_cov_inf0_2 true)
	(ai_place e12_cov_inf0_6)
	
	; Last blockade before the Scarab
	(sleep_until (volume_test_objects tv_e12_cov_inf0_4_begin (players)) 10)
	(game_save)
	(ai_place e12_cov_inf0_4)
	
	; Move the buggers back
	(sleep_until (volume_test_objects tv_e12_cov_inf0_6_migrate (players)) 10)
	(ai_migrate e12_cov_inf0_6 e12_cov_inf0_4)
	
	; More disposable
	(sleep_until (volume_test_objects tv_e12_scarab_begin (players)) 8)
	(ai_disposable e12_cov_inf0_4 true)

	; Past the Scarab
	(sleep_until (volume_test_objects tv_e12_cov_inf0_5_begin (players)) 10)
	(game_save)
;	(ai_place e12_cov_inf0_5)
)

(script dormant e12_mars_inf1_main
	(sleep_until (volume_test_objects tv_e12_mars_inf1_begin (players)) 15)
	(ai_place e12_mars_inf1)
)

(script dormant e12_mars_inf0_main
	(sleep 1)
	; TODO
	; Or maybe not...
)

(script dormant e12_mars_warthog1_main
	(sleep_until (volume_test_objects tv_e12_mars_warthog1_begin (players)) 10)
	
	; Try cleaning up obsolete Marines
	(cs_run_command_script e12_mars_warthog0 cs_e12_mars_horrible_cleanup)
	(sleep 15)
	
	; Spawn more if necessary
	(if (<= (ai_living_count e12_mars_warthog0) 2)
		(ai_place e12_mars_warthog1)
	)
)

(script dormant e12_mars_warthog0_main
	(ai_migrate e11_mars_warthog0 e12_mars_warthog0)
	(ai_renew e12_mars_warthog0)
	(ai_disposable e12_mars_warthog0 false)
	
	; Wait until the BSP swaps
	(sleep_until (= (structure_bsp_index) 2))
	
	; Clean things out
	(cs_run_command_script e12_mars_warthog0 cs_e12_mars_warthog0_cleanup)
	
	; Wait for it...
	(sleep 15)
	(game_save)
	(if (< (ai_living_count e12_mars_warthog0) 4)
		(ai_place e12_mars_warthog0)
	)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e12_main
	(sleep_until (volume_test_objects tv_e12_main_begin (players)) 15)
	(set g_e12_started true)
	(print "e12_main")
	(data_mine_set_mission_segment "e12_tunnel_blockades")
	(game_save)

	; Chapter title
	(wake chapter_title2)
	
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

	; Condemn the AI
	(ai_disposable e12_cov true)	
)

(script static void test_tunnel_blockades
	(switch_bsp 2)
	(object_teleport (player0) e12_test)
	(if (not g_e12_started) (wake e12_main))
)


;= ENCOUNTER 11 ==========================================================================
;*
An encounter at the entrance to the tunnel section, where the player encounters
a roadblock, Ghosts, and insertion pods.

Begins when the player gets close to the end of the beach.
Ends when the Covenant are dead or the player moves into the tunnel.

Marines
	e11_mars_warthog0 - e10_mars_warthog0, plus a spare if necessary
		(engage0) - Killing everything around the beach structure
		(engage1) - Halfway up the beach, sparring with Phantom
		(engage2) - Killing around the exit
		(continue) - When everything is dead, what is left to fear?
	e11_mars_inf0 - Marines caught on top of the bunker
		(init) - Holed up until the player helps them
		(advance0) - Moving off the top once e11_cov_inf0 is dead

Covenant
	e11_cov_inf0 - Covenant lurking around the beach structure
		(init)
	e11_cov_inf1 - Elites delivered by insertion pod
		_0 - Elites delivered near the beach structure
			(init) - Attempting to take the beach structure
		_1 - Elites delivered near the exit
			(init) - Attempting to defend the exit
	e11_cov_inf2 - Sniper in the watchtower at the end of the beach
		(init)
	e11_cov_ghosts0 - Ghosts harassing along the beach
		_0 - Ghosts initially present by the fort
		_1 - Ghosts coming from the tunnel
	e11_cov_phantom0 - A Creep which arrives from the tunnel to defend entrance
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
(global boolean g_e11_cov_phantom0_leaving false)
(global vehicle g_e8_warthog none)				; I fucking hate.
(global vehicle g_e10_warthog none) 			; Hate.

(global boolean g_e10_cov_phantom0_leaving false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e11_cov_phantom0_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to e11_cov_phantom0/p0 1.0)
	(cs_fly_to_and_face e11_cov_phantom0/p1 e11_cov_phantom0/p2 1.0)
	(cs_fly_to_and_face e11_cov_phantom0/p2 e11_cov_phantom0/p3)
	(cs_fly_by e11_cov_phantom0/p3)
	(ai_erase ai_current_squad)
)

(script command_script cs_e11_cov_inf0_shoot0
	(cs_abort_on_damage true)
	(cs_shoot_point true e11_patrol/s0)
	(sleep (random_range 30_seconds one_minute))
)

(script command_script cs_e11_cov_inf0_shoot1
	(cs_abort_on_damage true)
	(cs_shoot_point true e11_patrol/s1)
	(sleep_until
		(begin
			(cs_go_to e11_patrol/p1)
			(sleep (random_range 60 90))
			(cs_go_to e11_patrol/p0)
			(sleep (random_range 90 120))
			
			; Loop forever
			false
		)
		30
		30_seconds
	)
)

(script command_script cs_e11_cov_inf0_shoot2
	(cs_abort_on_damage true)
	(cs_shoot_point true e11_patrol/s2)
	(sleep (random_range 30_seconds one_minute))
)

(script command_script cs_e11_cov_ghosts0_entry
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_and_face e11_cov_ghosts0/p0 e11_cov_ghosts0/p1)
	(cs_vehicle_boost true)
	(cs_go_to e11_cov_ghosts0/p1)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e11_cov_phantom0_leaving
	(= g_e11_cov_phantom0_leaving true)
)


;- Insertion Pods --------------------------------------------------------------

(global effect g_e11_pod_impact_effect "effects\scenarios\solo\earthcity\e11_insertion_pod_impact")

(script dormant e11_cov_inf1_0_insertion0
	(ai_place e11_cov_inf1_0/elite0)
	(object_create e11_pod0_inserter)
	(objects_attach e11_pod0_inserter "pod_attach" (ai_vehicle_get e11_cov_inf1_0/elite0) "pod_attach")
	(sleep 1)
	(device_set_position e11_pod0_inserter 1.0)
	(sleep_until (>= (device_get_position e11_pod0_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e11_pod_impact_effect (ai_vehicle_get e11_cov_inf1_0/elite0) "pod_attach")	
	(objects_detach e11_pod0_inserter (ai_vehicle_get e11_cov_inf1_0/elite0))
	(object_destroy e11_pod0_inserter)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get e11_cov_inf1_0/elite0) "door" 500)
	(sleep 30)
	(ai_vehicle_exit e11_cov_inf1_0/elite0)
)

(script dormant e11_cov_inf1_0_insertion1
	(ai_place e11_cov_inf1_0/elite1)
	(object_create e11_pod1_inserter)
	(objects_attach e11_pod1_inserter "pod_attach" (ai_vehicle_get e11_cov_inf1_0/elite1) "pod_attach")
	(sleep 1)
	(device_set_position e11_pod1_inserter 1.0)
	(sleep_until (>= (device_get_position e11_pod1_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e11_pod_impact_effect (ai_vehicle_get e11_cov_inf1_0/elite1) "pod_attach")	
	(objects_detach e11_pod1_inserter (ai_vehicle_get e11_cov_inf1_0/elite1))
	(object_destroy e11_pod1_inserter)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get e11_cov_inf1_0/elite1) "door" 500)
	(sleep 30)
	(ai_vehicle_exit e11_cov_inf1_0/elite1)
)

(script dormant e11_cov_inf1_0_insertion2
	(ai_place e11_cov_inf1_0/elite2)
	(object_create e11_pod2_inserter)
	(objects_attach e11_pod2_inserter "pod_attach" (ai_vehicle_get e11_cov_inf1_0/elite2) "pod_attach")
	(sleep 1)
	(device_set_position e11_pod2_inserter 1.0)
	(sleep_until (>= (device_get_position e11_pod2_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e11_pod_impact_effect (ai_vehicle_get e11_cov_inf1_0/elite2) "pod_attach")	
	(objects_detach e11_pod2_inserter (ai_vehicle_get e11_cov_inf1_0/elite2))
	(object_destroy e11_pod2_inserter)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get e11_cov_inf1_0/elite2) "door" 500)
	(sleep 30)
	(ai_vehicle_exit e11_cov_inf1_0/elite2)
)

(script dormant e11_cov_inf1_1_insertion0
	(ai_place e11_cov_inf1_1/elite0)
	(object_create e11_pod3_inserter)
	(objects_attach e11_pod3_inserter "pod_attach" (ai_vehicle_get e11_cov_inf1_1/elite0) "pod_attach")
	(sleep 1)
	(device_set_position e11_pod3_inserter 1.0)
	(sleep_until (>= (device_get_position e11_pod3_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e11_pod_impact_effect (ai_vehicle_get e11_cov_inf1_1/elite0) "pod_attach")	
	(objects_detach e11_pod3_inserter (ai_vehicle_get e11_cov_inf1_1/elite0))
	(object_destroy e11_pod3_inserter)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get e11_cov_inf1_1/elite0) "door" 500)
	(sleep 30)
	(ai_vehicle_exit e11_cov_inf1_1/elite0)
)

(script dormant e11_cov_inf1_1_insertion1
	(ai_place e11_cov_inf1_1/elite1)
	(object_create e11_pod4_inserter)
	(objects_attach e11_pod4_inserter "pod_attach" (ai_vehicle_get e11_cov_inf1_1/elite1) "pod_attach")
	(sleep 1)
	(device_set_position e11_pod4_inserter 1.0)
	(sleep_until (>= (device_get_position e11_pod4_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e11_pod_impact_effect (ai_vehicle_get e11_cov_inf1_1/elite1) "pod_attach")	
	(objects_detach e11_pod4_inserter (ai_vehicle_get e11_cov_inf1_1/elite1))
	(object_destroy e11_pod4_inserter)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get e11_cov_inf1_1/elite1) "door" 500)
	(sleep 30)
	(ai_vehicle_exit e11_cov_inf1_1/elite1)
)

(script dormant e11_cov_inf1_1_insertion2
	(ai_place e11_cov_inf1_1/elite2)
	(object_create e11_pod5_inserter)
	(objects_attach e11_pod5_inserter "pod_attach" (ai_vehicle_get e11_cov_inf1_1/elite2) "pod_attach")
	(sleep 1)
	(device_set_position e11_pod5_inserter 1.0)
	(sleep_until (>= (device_get_position e11_pod5_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e11_pod_impact_effect (ai_vehicle_get e11_cov_inf1_1/elite2) "pod_attach")	
	(objects_detach e11_pod5_inserter (ai_vehicle_get e11_cov_inf1_1/elite2))
	(object_destroy e11_pod5_inserter)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get e11_cov_inf1_1/elite2) "door" 500)
	(sleep 30)
	(ai_vehicle_exit e11_cov_inf1_1/elite2)
)

(script dormant e11_cov_inf1_1_insertion3
	(ai_place e11_cov_inf1_1/elite3)
	(object_create e11_pod6_inserter)
	(objects_attach e11_pod6_inserter "pod_attach" (ai_vehicle_get e11_cov_inf1_1/elite3) "pod_attach")
	(sleep 1)
	(device_set_position e11_pod6_inserter 1.0)
	(sleep_until (>= (device_get_position e11_pod6_inserter) 1.0) 1)
	(effect_new_on_object_marker g_e11_pod_impact_effect (ai_vehicle_get e11_cov_inf1_1/elite3) "pod_attach")	
	(objects_detach e11_pod6_inserter (ai_vehicle_get e11_cov_inf1_1/elite3))
	(object_destroy e11_pod6_inserter)
	
	(sleep (random_range 20 45))
	(object_damage_damage_section (ai_vehicle_get e11_cov_inf1_1/elite3) "door" 500)
	(sleep 30)
	(ai_vehicle_exit e11_cov_inf1_1/elite3)
)

(script dormant e11_warthog_approach_horn
	(print "honk")
	(sound_looping_start "sound\vehicles\warthog\warthog_horn\warthog_horn" (ai_vehicle_get_from_starting_location e11_mars_warthog0/warthog0) 1.5)
	(sleep 30)
	(sound_looping_stop "sound\vehicles\warthog\warthog_horn\warthog_horn")
)

(script command_script cs_e11_warthog_approach
	; Approach!
	(cs_approach_player 10.0 100.0 100.0)
	(wake e11_warthog_approach_horn)
	(cs_vehicle_speed 0.5)
	(cs_approach_player 5.0 100.0 100.0)

	; Sleep until the player is far away or in a vehicle
	(sleep_until
		(or
			(player_in_vehicle)
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 10)
			(not (unit_in_vehicle (ai_get_unit ai_current_actor)))
		)
	)
)


;- Event Controls --------------------------------------------------------------

(script dormant e11_miranda_dialog
	(sleep (ai_play_line_on_object none 0560)) ; "Chief, pods inbound"
	(game_save)
)

(script dormant e11_dialog
	(sleep 150)
	(sleep_until 
		(and
			(objects_can_see_flag (players) e11_cov_inf1_entry 15)
			(volume_test_objects_all tv_e11_area (players))
		)
	)
;	(sleep (ai_play_line_on_object none 0570)) ; "Perfect, they've cleared us a way in"
	
	; Wait until the player is near the entrance
	(sleep_until (volume_test_objects tv_e11_tunnel_entrance (players)))
	(ai_play_line_on_object none 0580) ; "This tunnel goes to..."
)

(script dormant e11_navpoint
	(sleep_until (> (objects_distance_to_flag (players) e11_tunnel_entrance) 50) 30 30_seconds)
	(print "navpoint up")
	(activate_team_nav_point_flag default player e11_tunnel_entrance 0)	
)

(script dormant e11_navpoint_kill
	(sleep_until (volume_test_objects tv_e11_tunnel_entrance (players)) 15)
	
	; Shutdown the dialogue prompts
	(sleep_forever e11_navpoint)
	(print "navpoint down")
	(deactivate_team_nav_point_flag player e11_tunnel_entrance)
)

;- Squad Controls --------------------------------------------------------------

(script dormant e11_cov_phantom0_main
	(sleep_until 
		;(volume_test_objects tv_e11_area (ai_actors e10_cov_phantom0))	
		g_e10_cov_phantom0_leaving
		15
	)
	
	; Set the orders
	(ai_set_orders e10_cov_phantom0 e11_cov_phantom0_init)

	; Wait for it to leave
	(sleep_until 
		(or
			; My guns are gone
			(>= (object_model_targets_destroyed (ai_vehicle_get e10_cov_phantom0/phantom0) "target_front") 2) 	
			
			; Body vitality low
			(<= (object_get_health (ai_vehicle_get e10_cov_phantom0/phantom0)) 0.05) 
			
			; For the Ghosts to spawn
			(> (ai_spawn_count e11_cov_ghosts0_1) 0)
		)
		
		; Or a timeout
		30
		one_minute
	)
	
	; Wait for it to leave
	(sleep_until 
		(or
			; My guns are gone
			(>= (object_model_targets_destroyed (ai_vehicle_get e10_cov_phantom0/phantom0) "target_front") 2) 	
			
			; Body vitality low
			(<= (object_get_health (ai_vehicle_get e10_cov_phantom0/phantom0)) 0.05) 
		)

		; Or a timeout
		30
		one_minute
	)
	
	; Send it out
	(set g_e11_cov_phantom0_leaving true)
	(cs_run_command_script e10_cov_phantom0/phantom0 cs_e11_cov_phantom0_exit)

	; Attempt a save 
	(sleep 120)
	(game_save)
	
	; Pop up a navpoint for the exit, if necessary
	(wake e11_navpoint)
	(wake e11_navpoint_kill)
)

(script dormant e11_cov_ghosts0_main
	(ai_migrate e10_cov_ghosts0 e11_cov_ghosts0_0)

	; Place the first group of Ghosts, minus any survivors from last encounter
	(ai_place e11_cov_ghosts0_0 (pin (- 3 (ai_living_count e11_cov_ghosts0_0)) 0 2))
	
	; When the Ghosts are worn out, send reins
	(sleep_until (<= (ai_living_count e11_cov_ghosts0) 0))
	
	; Attempt a save 
	(game_save)

	; Wait 30 seconds, and then until it's safe to spawn
	(sleep 30_seconds)
	(sleep_until (volume_test_objects_all tv_e11_area (players)))
	(ai_place e11_cov_ghosts0_1)
	
	; Once more, when the Ghosts are worn out, send reins
	(sleep_until (<= (ai_living_count e11_cov_ghosts0) 0))

	; Attempt a save 
	(game_save)

	; Wait 30 seconds, and then until it's safe to spawn
	(sleep 30_seconds)
	(sleep_until (volume_test_objects_all tv_e11_area (players)))
	(ai_place e11_cov_ghosts0_1)
)

(script dormant e11_cov_inf2_main
	(ai_place e11_cov_inf2)
	
	; Wait till the player is closer, then raise the tower
	(sleep_until 
		(or
	 		(volume_test_objects tv_e11_on_fort (players))
			(< (objects_distance_to_flag (players) e11_cov_inf1_entry) 40) 
		)
		10
	)
	(device_group_set_immediate e11_watchtower0 1.0)
)

(script dormant e11_cov_inf1_main
	(sleep_until 
	 	(or
	 		(volume_test_objects tv_e11_on_fort (players))
	 		(volume_test_objects tv_e11_near_exit (players))
	 	)
	 	10
	)
	(sleep 30)
	 
	; If the player is not near the exit...
	(if (not (volume_test_objects tv_e11_near_exit (players)))
	 	; He's not, so send in inf1_0
	 	(begin
	 		; Wait until he's looking at the exit
	 		(sleep_until 
	 			(objects_can_see_flag (players) e11_cov_inf1_entry 25)
	 			60
	 			300
	 		)
	 		
	 		; Send them in
	 		(wake e11_cov_inf1_0_insertion0)
	 		(sleep 20)
	 		(wake e11_cov_inf1_0_insertion1)
	 		(sleep 10)
	 		(if (< (ai_living_count covenant) 10) (wake e11_cov_inf1_0_insertion2))
	 	)
	)
	 
	; Wait till he's near the exit to send in the rest
	(sleep_until 
	 	(volume_test_objects tv_e11_near_exit (players))
	 	10
	)
	
	; Send in the pods
	(wake e11_cov_inf1_1_insertion0)
	(sleep 15)
	(wake e11_cov_inf1_1_insertion1)
	(sleep 7)
	(if (< (ai_living_count covenant) 10) (wake e11_cov_inf1_1_insertion2))
	(sleep 25)
	(if (< (ai_living_count covenant) 10) (wake e11_cov_inf1_1_insertion3))
)

(script dormant e11_cov_inf0_main
	(ai_place e11_cov_inf0)
)

(script dormant e11_mars_inf0_main
	(if (not (game_is_cooperative))
		(ai_place e11_mars_inf0 (pin (- 3 (ai_living_count marines)) 1 2))
	)
)

(script dormant e11_mars_warthog0_main
	; Migrate people over
	(ai_migrate e10_mars_warthog0 e11_mars_warthog0)
	(ai_migrate e10_mars_inf0 e11_mars_warthog0)
	(ai_renew e11_mars_warthog0)
	(ai_disposable e11_mars_warthog0 false)

	; Wait until the players aren't in vehicles, and the original Warthog is nowhere in the second half
	(sleep_until
		(and
			(not (player_in_vehicle))
			(or
				(not (volume_test_object tv_beach g_e8_warthog))
				(<= (object_get_health g_e8_warthog) 0)
			)
			(or
				(not (volume_test_object tv_beach g_e10_warthog))
				(<= (object_get_health g_e10_warthog) 0)
			)
		)
	)
	
	; Wait a bit longer, and then until the area is clear
	(sleep 15_seconds)
	(sleep_until
		(not (volume_test_objects tv_e11_mars_warthog0_unsafe (players)))
	)
	
	; Place the reins
	(ai_place e11_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e11_warthog_for_the_masses
	(sleep 300)
	(object_create warthog_for_the_masses)
	(sleep 2)
	(object_cannot_die warthog_for_the_masses true)
)

(script dormant e11_main
	(sleep_until (volume_test_objects tv_e11_main_begin (players)) 15)
	(set g_e11_started true)
	(print "e11_main")
	(data_mine_set_mission_segment "e11_tunnel_entrance")
	(game_save)
	;(garbage_collect_now)

	; Clear the last, set the next objective
	(wake objective3_clear)
	(wake objective4_set)

	; Wake control scripts
	(wake e11_mars_inf0_main)
	(wake e11_mars_warthog0_main)
;	(wake e11_cov_inf0_main)
	(wake e11_cov_inf1_main)
	(wake e11_cov_inf2_main)
	(wake e11_cov_ghosts0_main)
	(wake e11_cov_phantom0_main)
	(wake e11_dialog)
	(wake e11_miranda_dialog)
	(wake e11_warthog_for_the_masses)
	
	; Shut down
	(sleep_until g_e12_started)
	(sleep_forever e11_mars_inf0_main)
	(sleep_forever e11_mars_warthog0_main)
	(sleep_forever e11_cov_inf0_main)
	(sleep_forever e11_cov_inf1_main)
	(sleep_forever e11_cov_inf2_main)
	(sleep_forever e11_cov_ghosts0_main)
	(sleep_forever e11_cov_phantom0_main)
	(sleep_forever e11_dialog)
	
	; Condemn the AI
	(ai_disposable e11_cov true)	

	; Clean up
	(sleep_until g_e13_started)
	(ai_erase e11_mars)
	(ai_erase e11_cov)
)

(script static void test_tunnel_entrance
	(switch_bsp 1)
	(object_teleport (player0) e11_test)
	(ai_place e11_mars_warthog0)
	(if (not g_e11_started) (wake e11_main))

	; Get the other scripts running
	(if (not g_e12_started) (wake e12_main))
)


;= ENCOUNTER 10 ==========================================================================
;*
Another beach encounter. Too tired to be witty. It's for my own benefit anyway.

Begins when the player exits the building bypass.
Ends when the Covenant are dead or the player moves past.

Marines
	e10_mars_warthog0 - e9_mars_warthog0, plus a spare if necessary
		(engage0) - Engage e10_cov_inf0 until they are dead
		(engage1) - Engage e10_cov_inf1 until they are dead
		(cower) - Staying back up one the beach while e10_cov_phantom0 is around
		(engage2) - Engaging e10_cov_ghosts0 if they're alive
		(continue) - Continue up the beach

Covenant
	e10_cov_inf0 - Entrenched Covenant
		(init) - Defending the outpost
	e10_cov_inf1 - Covenant on the gun
		(init) - Defending the gun
	e10_cov_ghosts0 - Ghosts dropped off by...
		_0 - Ghosts dropped off
		_1 - Reinforcements
			(engage0) - Engaging while numbers are high
			(cower0) - Retreating back near the Phantom when not
	e10_cov_phantom0 - A Phantom which lurks over the exit after dropping Ghosts
		(init) - Defending the exit

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e10_started false)		; Encounter has been activated?
(global boolean g_e10_cov_phantom0_arrived false)
(global boolean g_e10_cov_ghosts0_unloaded false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e10_cov_guntower_shoot
	; Loop
	(sleep_until
		(begin
			(begin_random
				; Bombard point 0
				(begin
					(cs_shoot_point true e10_cov_guntower/p0)
					(sleep (random_range 125 200))
				)
			
				; Bombard point 1
				(begin
					(cs_shoot_point true e10_cov_guntower/p1)
					(sleep (random_range 125 200))
				)			
			
				; Bombard point 2
				(begin
					(cs_shoot_point true e10_cov_guntower/p2)
					(sleep (random_range 125 200))
				)			
			)
		
			; Loop
			(or
				(<= (ai_strength ai_current_actor) 0.65)
				(<= (ai_strength ai_current_squad) 0.5)
			)
		)
	)
	
	; Get out
	(ai_vehicle_exit ai_current_actor)
)

(script command_script cs_e10_cov_phantom0_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_fly_by e10_cov_phantom0/p0)
	(cs_vehicle_boost false)
	(cs_fly_to e10_cov_phantom0/p1)
	(set g_e10_cov_phantom0_arrived true)
	(cs_fly_to_and_face e10_cov_phantom0/p2 e10_cov_phantom0/p2_facing 0.5)
	(cs_face true e10_cov_phantom0/p2_facing)
	(sleep 30)
	
	; Unload
	(set g_e10_cov_ghosts0_unloaded true)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc")
)

(script command_script cs_e10_cov_phantom0_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_face true e10_cov_phantom0/p2_facing)
	(cs_fly_to e10_cov_phantom0/p3 1.0)
	(cs_fly_to e10_cov_phantom0/p4 1.0)
	(sleep_until g_e11_started)
)

(script command_script cs_e10_cov_inf0_patrol1
	(cs_abort_on_combat_status ai_combat_status_visible)
	(sleep_until
		(begin
			; p0
			(cs_go_to e10_patrol/p2)
			(cs_look true e10_patrol/f0)
			(sleep (random_range 30 60))
			(cs_look false e10_patrol/f0)

			; p1
			(cs_go_to e10_patrol/p3)
			(sleep (random_range 30 60))			
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e10_cov_inf0_patrol0
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_enable_looking true)
	(sleep_until
		(begin
			; p0
			(cs_go_to e10_patrol/p0)
			(cs_look true e10_patrol/f0)
			(sleep (random_range 30 60))
			(cs_look false e10_patrol/f0)

			; p1
			(cs_go_to e10_patrol/p1)
			(sleep (random_range 30 60))			
			
			; Loop forever
			false
		)
	)
)

(script dormant e10_warthog_approach_horn
	(print "honk")
	(sound_looping_start "sound\vehicles\warthog\warthog_horn\warthog_horn" g_e10_warthog 1.5)
	(sleep 30)
	(sound_looping_stop "sound\vehicles\warthog\warthog_horn\warthog_horn")
)

(script command_script cs_e10_warthog_approach
	; Approach!
	(cs_approach_player 10.0 100.0 100.0)
	(wake e10_warthog_approach_horn)
	(cs_vehicle_speed 0.5)
	(cs_approach_player 5.0 100.0 100.0)

	; Sleep until the player is far away or in a vehicle
	(sleep_until
		(or
			(player_in_vehicle)
			(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 10)
			(not (unit_in_vehicle (ai_get_unit ai_current_actor)))
		)
	)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e10_cov_phantom0_threat
	(and
		g_e10_cov_phantom0_arrived
		(not g_e10_cov_phantom0_leaving)
	)
)


;- Event Controls --------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e10_cov_phantom0_main
	(sleep_until
		(or
			; Encounter is worn down
			(<= (ai_strength e10_cov) 0.4)
			
			; Player charging
			(volume_test_objects tv_e10_cov_phantom0_begin (players))
		)
		15
	)
	
	; Place the Phantom
	(ai_place e10_cov_phantom0)
	
	; Wait until it is unloaded
	(sleep_until g_e10_cov_ghosts0_unloaded)
	
	; Wait until...
	(sleep_until 
		(or
			; The Ghosts are dead
			(and
				(> (ai_spawn_count e10_cov_ghosts0_1) 0)
				(<= (ai_living_count e10_cov_ghosts0) 0)
			)
			
			; My guns are gone
			(>= (object_model_targets_destroyed (ai_vehicle_get e10_cov_phantom0/phantom0) "target_front") 3) 	
			
			; Body vitality low
			(<= (object_get_health (ai_vehicle_get e10_cov_phantom0/phantom0)) 0.05) 
		
			; Player started next encounter
			g_e11_started
		)

		; Or a timeout
		30
		one_minute
	)
	
	; Depart
	(set g_e10_cov_phantom0_leaving true)
	
	; Send it over
	(ai_set_orders e10_cov_phantom0 e10_cov_phantom0_retreat0)
	(cs_run_command_script e10_cov_phantom0/phantom0 cs_e10_cov_phantom0_exit)
	
	; Czechpoint
	(sleep 120)
	(game_save)
)

(script dormant e10_cov_ghosts0_main
	; Lazy
	(ai_place e10_cov_ghosts1)

	; Wait for the Phantom
	(sleep_until (> (ai_spawn_count e10_cov_phantom0) 0))
	(ai_place_in_vehicle e10_cov_ghosts0_0 e10_cov_phantom0)
	
	; Wait until one is dead
	(sleep_until 
		(and
			g_e10_cov_ghosts0_unloaded
			(<= (ai_living_count e10_cov_ghosts0) 1)
		)
	)
	
	; Place the reins
	(ai_place e10_cov_ghosts0_1)
)

(script dormant e10_cov_inf1_main
	(ai_place e10_cov_inf1)
	
	; Load up the gunner
	(ai_vehicle_reserve e10_guntower0 true)
;	(ai_vehicle_enter_immediate e10_cov_inf1/gunner0 e10_guntower0 "guntower_d")
;	(cs_run_command_script e10_cov_inf1/gunner0 cs_e10_cov_guntower_shoot)
)

(script dormant e10_cov_inf0_main
	(ai_place e10_cov_inf0)
)

(script dormant e10_mars_warthog0_main
	; Migrate old squads in
	(ai_migrate e9_mars_test e10_mars_warthog0)
	(ai_migrate e9_mars_warthog0 e10_mars_warthog0)
	(ai_renew e10_mars_warthog0)
	(ai_disposable e10_mars_warthog0 false)
	
	; Wait until the players aren't in vehicles, and the original Warthog is nowhere in the second half
	(sleep_until
		(and
			(not (player_in_vehicle))
			(or
				(not (volume_test_object tv_beach g_e8_warthog))
				(<= (object_get_health g_e8_warthog) 0)
			)
		)
	)
	
	; Wait a bit longer, and then until the area is clear
	(sleep 15_seconds)
	(sleep_until
		(not (volume_test_objects tv_e10_mars_warthog0_unsafe (players)))
	)
	
	; Place the reins
	(ai_place e10_mars_warthog0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e10_main
	(sleep_until 
		(or
			(volume_test_objects tv_e10_early_begin (players)) 
			(volume_test_objects tv_e10_main_begin (players)) 
		)
		16
	)
	(game_save)

	; Ok, for real now
	(sleep_until (volume_test_objects tv_e10_main_begin (players)) 15)
	(set g_e10_started true)
	(print "e10_main")
	(data_mine_set_mission_segment "e10_beach_fort")
	;(garbage_collect_now)

	; Wake control scripts
	(wake e10_mars_warthog0_main)
	(wake e10_cov_inf0_main)
	(wake e10_cov_inf1_main)
	(wake e10_cov_ghosts0_main)
	(wake e10_cov_phantom0_main)
	
	; Shut down
	(sleep_until g_e11_started)
	(sleep_forever e10_mars_warthog0_main)
	(sleep_forever e10_cov_inf0_main)
	(sleep_forever e10_cov_inf1_main)
	(sleep_forever e10_cov_ghosts0_main)
	
	; Condemn the AI
	(ai_disposable e10_cov true)	
	(ai_disposable e10_cov_phantom0 false)	
)

(script static void test_beach_fort
	(switch_bsp 1)
	(object_teleport (player0) e10_test)
	(ai_place e10_mars_test)
	(if (not g_e10_started) (wake e10_main))

	; Get the other scripts running
	(if (not g_e11_started) (wake e11_main))
	(if (not g_e12_started) (wake e12_main))
)


;= ENCOUNTER 9 ===========================================================================
;*
An encounter on the beach with a dug-in Creep and crew, followed by more 
skirmishing with infantry.

Begins when the player sights the visibility blocker building.
Ends when the Covenant are dead or the player moves past.

Marines
	e9_mars_warthog0 - e8_mars_warthog0
		(advance0) - Advance up the beach

Covenant
	e9_cov_shadow0 - A Creep and crew dug in at the building bypass
		(init) - Defending around the Creep
		(cower) - Defending deeper under cover
	e9_cov_inf0 - Infantry en route to reinforce e9_cov_shadow0, but are too late
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

(script command_script cs_e9_cov_guntower_shoot
	(cs_force_combat_status 3)

	; Loop
	(sleep_until
		(begin
			(begin_random
				; Bombard point 0
				(begin
					(cs_shoot_point true e9_cov_guntower/p0)
					(sleep (random_range 125 200))
				)
			
				; Bombard point 1
				(begin
					(cs_shoot_point true e9_cov_guntower/p1)
					(sleep (random_range 125 200))
				)			
			
				; Bombard point 2
				(begin
					(cs_shoot_point true e9_cov_guntower/p2)
					(sleep (random_range 125 200))
				)			
			)
		
			; Loop until...
			(or
				(<= (ai_strength ai_current_actor) 0.65)
				(<= (ai_strength ai_current_squad) 0.5)
			)
		)
	)
	
	; Get out and fight
	(ai_vehicle_exit ai_current_actor)
)

(script command_script cs_e9_cov_guntower_abort
	(cs_crouch false)
)

(script command_script cs_e9_beach_chatter_scene
	; "Man, I love the beach!"
	(cs_switch marine0)
	(cs_play_line 0520)
	(sleep 15)
	
	; "Hope you packed a suit"
	(cs_switch marine1)
	(cs_play_line 0530)
	(sleep 10)
	
	; Stop here if the combat status isn't low enough
	(if (< (ai_combat_status ai_current_squad) ai_combat_status_active)
		(begin			
			; "Hell no!"
			(cs_switch marine0)
			(cs_play_line 0540)
			(sleep 15)
		)
	)
	
	; Have Cortana cut in if they are
	(if (>= (ai_combat_status ai_current_squad) ai_combat_status_active)
		(begin			
			; "Cut the chatter"
			(ai_play_line_on_object none 0550)
		)
	)
)

(script command_script cs_e9_cov_inf1_2_patrol
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_enable_looking true)
	(sleep_until
		(begin
			; p0
			(cs_go_to e9_patrol/p2)
			(sleep (random_range 30 60))

			; p1
			(cs_go_to e9_patrol/p3)
			(sleep (random_range 30 60))			
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e9_cov_inf1_0_patrol
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_enable_looking true)
	(sleep_until
		(begin
			; p0
			(cs_go_to e9_patrol/p0)
			(cs_look true e9_patrol/f0)
			(sleep (random_range 30 60))
			(cs_look false e9_patrol/f0)

			; p1
			(cs_go_to e9_patrol/p1)
			(sleep (random_range 30 60))			
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e9_warthog_abort
	(sleep 1)
)

(script dormant e9_warthog_approach_horn
	(print "honk")
	(sound_looping_start "sound\vehicles\warthog\warthog_horn\warthog_horn" g_e8_warthog 1.5)
	(sleep 30)
	(sound_looping_stop "sound\vehicles\warthog\warthog_horn\warthog_horn")
)

(script command_script cs_e9_warthog_follow
	(cs_enable_pathfinding_failsafe true)
		
	; Approach the player until he is in the vehicle
	(cs_enable_moving false)
	(sleep_until
		(begin
			; Approach!
			(cs_approach_player 10.0 100.0 100.0)
			(wake e9_warthog_approach_horn)
			(cs_vehicle_speed 0.5)
			(cs_approach_player 5.0 100.0 100.0)

			; Sleep until the player is far away or in a vehicle
			(sleep_until
				(or
					(player_in_vehicle)
					(> (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 8)
					(not (unit_in_vehicle (ai_get_unit ai_current_actor)))
				)
			)

			; Until the player is in a vehicle
			(or
				(player_in_vehicle)
				(not (unit_in_vehicle (ai_get_unit ai_current_actor)))
			)
		)
		30
		two_minutes
	)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e9_cortana_dialog
	(sleep_until
		(or
			(objects_can_see_flag (players) e9_dialog_trigger 25)
			(volume_test_objects tv_e9_dialogue (players))
		)
		5
		30_seconds
	)
	(sleep 15)
	(print "Highest concentration under carrier")
	(sleep (ai_play_line_on_object none 0050)) 
	(sleep 15)
	(sleep_until
		(or
			(objects_can_see_flag (players) e9_dialog_trigger 25)
			(volume_test_objects tv_e9_dialogue (players))
		)
		5
		150
	)
	(print "That bridge is the best route")
	(sleep (ai_play_line_on_object none 0060))

	; Wait until we're on the beach
	(sleep_until (volume_test_objects tv_e9_main_begin (players)))
	(sleep_until (ai_scene e9_beach_chatter_scene cs_e9_beach_chatter_scene e9_mars_warthog0) 30 300)
)

(script dormant e9_warthog_navpoint
	(sleep_until (> (ai_spawn_count e8_mars_warthog0) 0))

	; If the player isn't in a vehicle...
	(if (not (player_in_vehicle))
		; Put a nav point on the Warthog
		(activate_team_nav_point_object default player g_e8_warthog 1)	
	)
)

(script dormant e9_warthog_navpoint_kill
	; Wait until the Warthog is dead, or the player is in a vehicle
	(sleep_until
		(or
			(player_in_vehicle)
			(<= (unit_get_health g_e8_warthog) 0)
		)
	)
	(deactivate_team_nav_point_object player g_e8_warthog)
)

(script dormant e9_retreat_checkpoint0
	(sleep_until (volume_test_objects tv_e9_retreat_checkpoint (players)) 30_seconds)
	(game_save)
)

(script dormant e9_retreat_checkpoint1
	(sleep_forever e9_retreat_checkpoint0)
	(sleep_until (volume_test_objects tv_e9_retreat_checkpoint (players)) 30_seconds)
	(game_save)
)

(script dormant e9_music
	(wake music_03a_05_start)
	
	; Wait until the player is entering combat
	(sleep_until (volume_test_objects tv_beach (players)))
	(wake music_03a_05_stop)
	(wake music_03a_06_start)
	
	; Wait until the player is near the exit
	(sleep_until (volume_test_objects tv_e9_near_entrance (players)))
	(wake music_03a_06_stop)
	(wake music_03a_065_start)

	; Wait more
	(sleep_until (volume_test_objects tv_e10_music (players)))
	(sleep 150)
	(wake music_03a_065_start_alt)
	
	; Wait for e11, or the natural timeout
	(sleep_until g_e11_started)
	(wake music_03a_065_stop)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e9_cov_inf1_main
	(ai_place e9_cov_inf1_2 (pin (- 10 (ai_living_count covenant)) 0 1))
	(sleep_until (volume_test_objects tv_e9_main_begin (players)) 15)

	; Place them
	(ai_place e9_cov_inf1_0 (pin (- 10 (ai_living_count covenant)) 1 3))
	(ai_place e9_cov_inf1_1 (pin (- 10 (ai_living_count covenant)) 1 2))
	
	; Load up the gunner
	(ai_vehicle_reserve e9_guntower0 true)
;	(ai_vehicle_enter_immediate e9_cov_inf1_1/gunner0 e9_guntower0 "guntower_d")
;	(cs_run_command_script e9_cov_inf1_1/gunner0 cs_e9_cov_guntower_shoot)
	
	; When they're all dead, try for a save
	(sleep_until (<= (ai_living_count e9_cov_inf1) 0))
	(game_save)
)

(script dormant e9_cov_inf0_main
	(sleep_until 
		(or
			(volume_test_objects tv_e9_near_entrance (players)) 
			(> (ai_spawn_count e9_cov_ghosts0) 0)
		)
		30
	)
	(sleep_until 
		(or
			(volume_test_objects tv_e9_near_entrance (players)) 
			(<= (ai_living_count e9_cov_inf1) 1)
		)
		15
	)
	(ai_place e9_cov_inf0 (pin (- 10 (ai_living_count e9_cov)) 3 7))

	; Retreat checkpoint
	(wake e9_retreat_checkpoint0)
)

(script dormant e9_cov_shadow0_main
	(sleep_until
		(volume_test_objects tv_e9_retreat_checkpoint (players))
		15
	)
	(ai_place e9_cov_shadow0)
)

(script dormant e9_cov_ghosts0_main
;	(ai_migrate e8_cov_ghosts0 e9_cov_ghosts0)
;	(ai_place e9_cov_ghosts0 (pin (- 1 (ai_living_count e9_cov_ghosts0)) 0 1))

	; Wait for the first turret to be depleted, or for the player's charge
	(sleep_until 
		(and
			(<= (ai_living_count e9_cov_ghosts0) 0)
			(or
				(volume_test_objects tv_e9_near_entrance (players)) 
				(volume_test_objects tv_e9_bypass (players)) 
				(<= (ai_living_count e9_cov_inf1) 3)
			)
		)
		15
	)
	(ai_place e9_cov_ghosts0)
	
	; Retreat checkpoint
	(wake e9_retreat_checkpoint0)
	
	; Migrate them back if necessary
	(sleep_until
		(volume_test_objects tv_e9_bypass (players))
		15
	)
	(ai_migrate e9_cov_ghosts0 e10_cov_ghosts0_0)
)

(script dormant e9_mars_warthog0_main
	; Wait until the player is nowhere near
	(sleep_until
		(not (volume_test_objects tv_e8_vehicle_spawn_area (players)))
	)

	; Send out a second Warthog
;	(ai_place e9_mars_warthog0)

	; Wait until the last encounter Warthog is placed
	(sleep_until 
		(> (ai_spawn_count e8_mars_warthog0) 0)
		30
	)
	
	; Migrate the Warthog
	(ai_migrate e8_mars_warthog0 e9_mars_warthog0)
	(ai_renew e9_mars_warthog0)
	(ai_disposable e9_mars_warthog0 false)

	; Blow away any pending command scripts
	(cs_run_command_script e9_mars_warthog0 cs_e9_warthog_abort)

	; Migrate x individuals
;*	(sleep_until
		(begin
			; If the source squad is depleted or the dest squad is full...
			(if
				(or
					(<= (ai_living_count e8_mars_inf0) 0)
					(>= (ai_living_count e9_mars_warthog0) 2)
				)

				; Bail out if this condition is true, by returning true
				(= 1 1)
				
				; Otherwise...
				(begin
					(print "migrated an actor")
					(ai_attach_units (unit (list_get (ai_actors e8_mars_inf0) 0)) e9_mars_warthog0)
					
					; And return false
					(= 1 0)
				)
			)
		)
	)
*;
	; Get into the Warthog
	(ai_vehicle_reserve_seat g_e8_warthog "warthog_d" false)
	(ai_vehicle_enter e9_mars_warthog0 g_e8_warthog "warthog_d")

	; If there's no player in the vehicle...
	(if (not (player_in_vehicle))
		; Wait until there's someone in the driver's seat
		(begin
			(sleep_until (vehicle_test_seat_list g_e8_warthog "warthog_d" (ai_actors e9_mars)) 30 900)
			
			; Get the driver, have him run a command script
			(cs_run_command_script (object_get_ai (vehicle_driver g_e8_warthog)) cs_e9_warthog_follow)
		)
	)

;*	; Catch up, if the player isn't already in a vehicle
	(if (not (player_in_vehicle))
		(if (not (ai_scene e9_warthog_ketchup cs_e9_warthog_follow e9_mars_warthog0))
			; If the Scene failed, just unreserve the vehicle
			(ai_vehicle_reserve_seat g_e8_warthog "warthog_d" false)
		)	
	)

	; Unreserve after a time anyway
	(sleep 300)
*;
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e9_main
	(sleep_until (volume_test_objects tv_e9_main_begin (players)) 15)
	(set g_e9_started true)
	(print "e9_main")
	(data_mine_set_mission_segment "e9_beach_infantry")
	(game_save_no_timeout)	; TODO: Fix this
	;(garbage_collect_now)

	; Muzak
	(wake e9_music)

	; Chapter title
	(wake chapter_title1)
	
	; Set the next objective
	(wake objective3_set)

	; Wake control scripts
	(wake e9_cov_inf0_main)
	(wake e9_cov_inf1_main)
	(wake e9_cov_ghosts0_main)
	(wake e9_cov_shadow0_main)
	(wake e9_mars_warthog0_main)
	(wake e9_cortana_dialog)
	(wake e9_warthog_navpoint)
	(wake e9_warthog_navpoint_kill)
	(wake e9_music)
	
	; Shut down
	(sleep_until g_e10_started)
	(sleep_forever e9_cov_inf0_main)
	(sleep_forever e9_cov_inf1_main)
	(sleep_forever e9_cov_ghosts0_main)
	(sleep_forever e9_cov_shadow0_main)
	(sleep_forever e9_mars_warthog0_main)
	(sleep_forever e9_cortana_dialog)
	(sleep_forever e9_retreat_checkpoint0)
	(sleep_forever e9_retreat_checkpoint1)
	
	; Condemn the AI
	(ai_disposable e9_cov true)	

	; Clean up
	(sleep_until g_e12_started)
	(ai_erase e9_mars)
	(ai_erase e9_cov)
)

(script static void test_beach_infantry
	(switch_bsp 1)
	(object_teleport (player0) e9_test)
	(ai_place e9_mars_test)
	(if (not g_e9_started) (wake e9_main))

	; Get the other scripts running
	(if (not g_e10_started) (wake e10_main))
	(if (not g_e11_started) (wake e11_main))
	(if (not g_e12_started) (wake e12_main))
)


;= ENCOUNTER 8 ===========================================================================
;*
The hotel exit, version 3. The player emerges and is soon engaged by a Phantom,
and then bears witness to the arrival of a Warthog pursued by two Ghosts

Begins when the player exits the hotel.
Ends when the player has a Warthog and moves down onto the beach.

Marines
	e8_mars_inf0 - e7_mars_inf0
		(init) - Exposed positions near the door
		(cower0) - Cowering in the building while the Phantom drops off
		(engage0) - Engaging the troops dropped off from the building
		(wait) - Points on the street, around the Warthog
	e8_mars_warthog0 - A Warthog which arrives pursued by e8_cov_ghosts0
		(init) - Positions in the rubble
		(continue) - Down onto the beach when the Ghosts are dead and player is on board

Covenant
	e8_cov_inf0 - Grunts left behind to draw the player into the building ruin
		(init) - Freaking out and running around
	e8_cov_inf1 - Infantry dropped off by the Phantom
		(init) - Coming across past the hotel exit
		(advance0) - Rooting guys out
	e8_cov_phantom0 - Phantom which cruises in and drops off e8_cov_inf1
		(init) - Lurking around for a few seconds, then backing off
	e8_cov_ghosts0 - Ghosts which engage the player around these parts
		_0 - The two chasing the Warthog
		_1 - The two which come up off the beach
			(init) - Engaging the building positions
			(retreat0) - Retreat down onto the beach and pray for death

Open Issues

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e8_started false)			; Encounter has been activated?
(global boolean g_e8_cov_phantom0_arrived false)
(global boolean g_e8_cov_phantom0_leaving false)
(global boolean g_e8_cov_inf1_unloaded false)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e8_cov_phantom0_arrived
	(= g_e8_cov_phantom0_arrived true)
)

(script static boolean e8_cov_phantom0_leaving
	(= g_e8_cov_phantom0_leaving true)
)

(script static boolean e8_cov_ghosts0_nearby
	(volume_test_objects tv_e8_area (ai_actors e8_cov_ghosts0))
)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e8_warthog_intro_scene
	(cs_look_player true)
	(ai_play_line_at_player ai_current_actor 0510) ; "Special delivery"
)

(script command_script cs_e8_mars_warthog0_entry
	(cs_enable_pathfinding_failsafe true)
	(object_cannot_take_damage (ai_actors ai_current_squad))
	(cs_go_by e8_mars_warthog0_entry/p0 e8_mars_warthog0_entry/p1)
	(sound_looping_start "sound\vehicles\warthog\warthog_horn\warthog_horn" (ai_vehicle_get ai_current_actor) 1.5)
	(cs_go_to e8_mars_warthog0_entry/p1)
	(sound_looping_stop "sound\vehicles\warthog\warthog_horn\warthog_horn")
	(object_can_take_damage (ai_actors ai_current_squad))
	
	; Unload the driver and passenger
	(vehicle_unload (ai_vehicle_get ai_current_actor) "warthog_p")

	; More honking
	(sleep 10)
	(sound_looping_start "sound\vehicles\warthog\warthog_horn\warthog_horn" (ai_vehicle_get ai_current_actor) 1.5)
	(sleep 8)
	(sound_looping_stop "sound\vehicles\warthog\warthog_horn\warthog_horn")
	(sleep 5)
	(sound_looping_start "sound\vehicles\warthog\warthog_horn\warthog_horn" (ai_vehicle_get ai_current_actor) 1.5)
	(sleep 10)
	(sound_looping_stop "sound\vehicles\warthog\warthog_horn\warthog_horn")

	; Unload the driver
	(vehicle_unload (ai_vehicle_get ai_current_actor) "warthog_d")

	; Reserve the seat
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0) "warthog_d" true)
)

(script command_script cs_e8_cov_phantom0_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e8_cov_phantom0_entry/p0)
	(cs_fly_to e8_cov_phantom0_entry/p1_1 1.0)
	(cs_face true e8_cov_phantom0_entry/p1_facing)
	(sleep 60)
	
	; Drop people off
	(set g_e8_cov_phantom0_arrived true)
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) true)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_a")
	(sleep 90)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_b")
	(sleep 90)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_c")
	(set g_e8_cov_inf1_unloaded true)
	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) false)
	(sleep 120)
	(cs_face false e8_cov_phantom0_entry/p1_facing)
	(set g_e8_cov_phantom0_leaving true)
	(cs_fly_by e8_cov_phantom0_entry/p2)
	(cs_fly_by e8_cov_phantom0_entry/p3)
	(cs_fly_by e8_cov_phantom0_entry/p4)
	(cs_fly_by e8_cov_phantom0_entry/p5)
	(ai_erase ai_current_squad)
)

(script command_script cs_e8_cov_ghosts0_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_go_to e8_cov_ghosts0_entry/p0)

	; Continue on in
;	(cs_abort_on_combat_status ai_combat_status_visible)
;	(cs_start_to e8_cov_ghosts0_entry/p1)
	(sleep (random_range 0 30))
;	(cs_enable_targeting true)
	(cs_vehicle_boost false)
;	(sleep_until (not (cs_moving)))
)

(script command_script cs_e8_mars_inf0_no_assholes
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_abort_on_damage true)

	; Look at the fucking Phantom, Jesus H. Christ, IT'S SHOOTING AT YOU
	(sleep (random_range 15 45))
	(ai_magically_see ai_current_squad e8_cov_phantom0)
	(cs_aim_object true (ai_vehicle_get e8_cov_phantom0/phantom0))
	(sleep_until g_e8_cov_phantom0_arrived)
)

(script command_script cs_e8_cov_inf2_patrol2
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_abort_on_damage true)
	(cs_enable_looking true)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to e8_patrol/p2)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_go_to e8_patrol/p3)
					(sleep (random_range 30 60))
				)
				(begin
					(cs_go_to e8_patrol/p4)
					(sleep (random_range 30 60))
				)
			)
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e8_cov_inf2_patrol1
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_abort_on_damage true)
	(cs_enable_looking true)
	(sleep_until
		(begin
			; p0
			(cs_go_to e8_patrol/p0)
			(cs_look true e8_patrol/f0)
			(sleep (random_range 30 60))
			(cs_look false e8_patrol/f0)

			; p1
			(cs_go_to e8_patrol/p1)
			(sleep (random_range 30 60))			
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e8_cov_inf2_patrol0
	(cs_abort_on_combat_status ai_combat_status_uninspected)
	(cs_abort_on_damage true)
	(cs_look_object true (ai_get_object e8_cov_inf2/grunt0))
	(sleep_forever)
)


;- Event Controls --------------------------------------------------------------

(script dormant e8_warthog_scene
	; Run the scene
	(sleep_until 
		(or
			(ai_scene e8_warthog_intro_scene cs_e8_warthog_intro_scene e8_mars_warthog0/warthog0)
			(<= (ai_living_count e8_mars_warthog0/warthog0) 0)
		)
		5
		two_minutes
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e8_cov_ghosts0_main
	; Wait until the Warthog is placed
	(sleep_until (> (ai_spawn_count e8_mars_warthog0) 0) 15)
	(sleep 180)
	(sleep_until
		(not (volume_test_objects tv_e8_vehicle_spawn_area (players)))
	)
	(ai_place e8_cov_ghosts0_0 1)
	
	; Place the second set of Ghosts
	(sleep_until
		(<= (ai_living_count e8_cov_ghosts0) 0)
	)
	
	; Send then in if it's safe
	(sleep_until
		(not (volume_test_objects tv_e8_vehicle_spawn_area (players)))
	)
	(ai_place e8_cov_ghosts0_0 (pin (- 10 (ai_living_count covenant)) 0 2))
)

(script dormant e8_cov_phantom0_main
	(ai_place e8_cov_phantom0)
)

(script dormant e8_cov_inf2_main
	; Wait until the player is close
	(sleep_until
		(volume_test_objects tv_e8_cov_inf2_begin (players))
		15
	)
	(ai_place e8_cov_inf2 (pin (- 10 (ai_living_count e8_cov)) 1 4))
	
	; Save point
	(sleep_until
		(<= (ai_living_count e8_cov_inf2) 0)
	)
	(game_save)
)

(script dormant e8_cov_inf1_main
	; Wait until the Phantom is placed
	(sleep_until (> (ai_spawn_count e8_cov_phantom0) 0))
	(ai_place_in_vehicle e8_cov_inf1 e8_cov_phantom0)
)

(script dormant e8_cov_inf0_main
	(ai_place e8_cov_inf0)
)

(script dormant e8_mars_warthog0_main
	(sleep_until
		(or
			g_e9_started
			(and
				g_e8_cov_inf1_unloaded
				(<= (ai_living_count e8_cov_inf1) 5)
				(= (structure_bsp_index) 1)
			)
		)
		15
		one_minute
	)
	
	; Wait until the player is nowhere near
	(sleep_until
		(and
			(= (structure_bsp_index) 1)
			(not (volume_test_objects tv_e8_vehicle_spawn_area (players)))
		)
	)

	; Send in Der Haug
	(ai_place e8_mars_warthog0)
	
	; Cache the fucking unit
	(sleep 3)
	(set g_e8_warthog (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0))
	
	; Wake the scene
	(wake e8_warthog_scene)
	
	; Failsafe
	(sleep 450)
	(object_can_take_damage (ai_actors e8_mars_warthog0))
	
	; Unreserve the seat as soon as the player is in a vehicle
	(sleep_until
		(or
			(and
				(player_in_vehicle)
				(<= (ai_living_count e8_cov_inf1) 0)
			)
			g_e9_started
		)
	)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location e8_mars_warthog0/warthog0) "warthog_d" false)

	; Kick start e9
	(if (not g_e9_started) (wake e9_main))
)

(script dormant e8_mars_inf0_main
	; Migrate old squads over
	(ai_migrate e7_mars_inf0 e8_mars_inf0)
	(ai_renew e8_mars_inf0)
	(ai_disposable e8_mars_inf0 false)

	; When the Grunts are dead, see the Phantom instead of being ASSHOLES
	(sleep_until
		(and
			(> (ai_spawn_count e8_cov_inf0) 0)
			(<= (ai_living_count e8_cov_inf0) 0)
		)
	)
	(cs_run_command_script e8_mars_inf0 cs_e8_mars_inf0_no_assholes)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e8_main
	(sleep_until (volume_test_objects tv_e8_main_begin (players)) 15)
	(set g_e8_started true)
	(print "e8_main")
	(data_mine_set_mission_segment "e8_hotel_exit")
	(game_save)

	; Muzak
	(wake music_03a_04_stop)

	; Clear the last objective
	(wake objective2_clear)

	; Wake subsequent scripts
	(wake e9_main)
	(wake e10_main)
	(wake e11_main)

	; Wake control scripts
	(wake e8_mars_inf0_main)
	(wake e8_cov_inf0_main)
	(wake e8_cov_inf1_main)
	(wake e8_cov_inf2_main)
	(wake e8_cov_phantom0_main)
	(wake e8_cov_ghosts0_main)
	(wake e8_mars_warthog0_main)
	
	; Condemn the AI
	(sleep_until g_e9_started)
	(ai_disposable e8_cov true)	
	(ai_disposable e8_cov_phantom0 false)	

	; Shut down
	(sleep_until g_e10_started)
	(sleep_forever e8_mars_inf0_main)
	(sleep_forever e8_cov_inf0_main)
	(sleep_forever e8_cov_inf1_main)
	(sleep_forever e8_cov_inf2_main)
	(sleep_forever e8_cov_phantom0_main)
	(sleep_forever e8_cov_ghosts0_main)
	(sleep_forever e8_mars_warthog0_main)

	; Condemn the Marines
	(ai_disposable e8_mars true)	
)

(script static void test_hotel_exit
	(switch_bsp 1)
	(object_teleport (player0) e8_test)
	(ai_place e8_mars_inf0)
	(if (not g_e8_started) (wake e8_main))

	; Get the other scripts running
	(if (not g_e12_started) (wake e12_main))
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


;- Order Scripts ---------------------------------------------------------------

(script static boolean oes_e7_spring_ambush
	(and
		(or
			(volume_test_objects tv_e7_cov_inf0_spring_ambush (ai_actors e7_cov_inf0))
			(>= (ai_combat_status e7_cov_inf0) ai_combat_status_certain)
		)
		(> (ai_spawn_count e7_cov_inf0) 0)
	)
)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e7_hide
	(cs_abort_on_combat_status ai_combat_status_visible)
	(cs_enable_moving true)
	(cs_look true e7_hallway_ambush/f0)
	(cs_aim true e7_hallway_ambush/f0)
	(sleep_until (oes_e7_spring_ambush))
)


(script command_script cs_e7_cov_inf0_entry
	(cs_ignore_obstacles true)
	(cs_look true e7_hallway_ambush/cov1)
	(cs_aim true e7_hallway_ambush/cov1)
	(cs_go_to e7_hallway_ambush/cov0)
	(cs_go_to e7_hallway_ambush/cov1)
)

(script command_script cs_e7_abort
	(cs_crouch false)
)

(script command_script cs_e7_hotel_hall_scene0
	(cs_play_line 0470) ; "Stay out of sight!"
)

(script command_script cs_e7_hotel_hall_scene1
	(cs_play_line 0480) ; "Surprise!"
)


;- Squad Controls --------------------------------------------------------------

(script dormant e7_cov_inf0_main
	; Wait for the player or Marines to arrive
	(sleep_until 
		(volume_test_objects tv_e7_cov_inf0_init (players))
		15
	)
	
	; Explosion
;	(effect_new "effects\objects\weapons\grenade\plasma_grenade\detonation" e7_door_breaker0)
;	(sleep 5)
;	(effect_new "effects\scenarios\solo\earthcity\e2_wall_breaker" e7_door_breaker0)
	
	; Some gunfire
	(sleep 15)
	(object_create e7_gun0)
	(weapon_hold_trigger e7_gun0 0 true)
	(sleep 10)
	(weapon_hold_trigger e7_gun0 0 false)
	(sleep 10)
	(weapon_hold_trigger e7_gun0 0 true)
	(sleep 10)
	(weapon_hold_trigger e7_gun0 0 false)
	
	; Pause, then place the Covenant, let the orders do the rest
	(ai_place e7_cov_inf0)

	; Another gunfire burst
	(sleep 20)
	(weapon_hold_trigger e7_gun0 0 true)
	(sleep 8)
	(weapon_hold_trigger e7_gun0 0 false)
	(object_destroy e7_gun0)

	; I feel dirty
	(sleep_until
		(begin
			; If there's a player or AI in the hall, make the AI non blind
			(if 
				(or
					(volume_test_objects tv_e7_hall (players))
					(volume_test_objects tv_e7_hall (ai_actors e7_mars))
					(player_flashlight_on)
				)
				(ai_set_blind e7_cov_inf0 false)
				(ai_set_blind e7_cov_inf0 true)			
			)
		
			; Abort with the ambush
			(oes_e7_spring_ambush)
		)
		2
	)

	; Ambush sprung
	(cs_run_command_script e7_cov_inf0 cs_e7_abort)
	(ai_set_blind e7_cov_inf0 false)
)

(script dormant e7_mars_inf0_main
	; Migrate them over
	(ai_migrate e6_mars_inf1/marine0 e7_mars_inf0)
	(ai_migrate e6_mars_inf1/marine1 e7_mars_inf0)
	(ai_renew e7_mars_inf0)
	(ai_disposable e7_mars_inf0 false)
	
	; Migrate x individuals
	(sleep_until
		(begin
			; If the source squad is depleted or the dest squad is full...
			(if
				(or
					(<= (ai_living_count e6_mars_inf0) 0)
					(>= (ai_living_count e7_mars_inf0) 3)
				)

				; Bail out if this condition is true, by returning true
				(= 1 1)
				
				; Otherwise...
				(begin
					(print "migrated an actor")
					(ai_attach_units (unit (list_get (ai_actors e6_mars_inf0) 0)) e7_mars_inf0)
					
					; And return false
					(= 1 0)
				)
			)
		)
	)
	
	; Wait for the Covenant to arrive, the break command scripts
	(sleep_until (> (ai_spawn_count e7_cov_inf0) 0) 10)
	(cs_run_command_script e7_mars_inf0 cs_e7_hide)

	; Disregard the Marines
	(ai_disregard (ai_actors e7_mars_inf0) true)

	; Run the scene
	(ai_scene e7_hotel_hall_scene0 cs_e7_hotel_hall_scene0 e7_mars_inf0)
	
	; Wait to spring the ambush
	(sleep_until (oes_e7_spring_ambush) 2)
	(cs_run_command_script e7_mars_inf0 cs_e7_abort)
	
	; Regard the Marines
	(ai_disregard (ai_actors e7_mars_inf0) false)
;	(ai_scene e7_hotel_hall_scene1 cs_e7_hotel_hall_scene1 e7_mars_inf0)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e7_main
	(sleep_until (volume_test_objects tv_e7_main_begin (players)) 15)
	(set g_e7_started true)
	(print "e7_main")
	(data_mine_set_mission_segment "e7_hotel_hall")
	(game_save)
	;(garbage_collect_now)
	
	; Flashlight training
	(player_training_activate_flashlight)

	; Wake control scripts
	(wake e7_mars_inf0_main)
	(wake e7_cov_inf0_main)
	
	; Do some prediction for e8
	(sleep_until (= (structure_bsp_index) 1) 1)
	(camera_predict_resources_at_point e8_prediction)	
	
	; Condemn the AI
	(ai_disposable e7_cov true)	

	; Shut down
	(sleep_until g_e9_started)
	(sleep_forever e7_mars_inf0_main)
	(sleep_forever e7_cov_inf0_main)
	
	; Clean up
	(sleep_until g_e10_started)
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
	e6_mars_inf2 - Marines who proceed through the hotel, additional reins
		(init) - Cowering behind cover

Covenant
	e6_cov_inf0 - An infantry squad using a turret on the hotel entrance
		(init) - Firing on the entrance
		(alert_left) - Alerted and fighting, tending to the left
		(alert_right) - Alerted and fighting, tending to the right
		(pursuit) - Give chase if the player charges the hotel
	e6_cov_inf1 - Grunts up above the fight, thinking they're clever
		(init) - Watching the fight below


Open Issues
- Need Covenant Plasma Cannon
- Need pinned and wounded poses for Marines
- Need Medic Marine

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e6_started false)			; Encounter has been activated?


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e6_mars_inf1_odst
	(sleep_until
		(begin
			; Stop shooting and crouch
			(cs_shoot false (ai_get_object ai_current_actor))
			(sleep 4)
			(if (< (object_get_health (ai_get_object ai_current_actor)) 0.5)  (cs_crouch true))
			(sleep_until (>= (object_get_health (ai_get_object ai_current_actor)) 0.49) 5)

			; Uncrouch and shoot
			(cs_crouch false)			
			(sleep 15)
			(cs_shoot true (list_get (ai_actors e6_cov_inf0) (random_range 0 (list_count (ai_actors e6_cov_inf0)))))
		
			; Wait until I'm damaged or the targets are dead
			(sleep_until 
				(or
					(< (object_get_health (ai_get_object ai_current_actor)) 0.5) 
					(<= (ai_living_count e6_cov_inf0) 0)
				)
				5
				60
			)
			
			; Loop until the Covenant are dead
			(<= (ai_living_count e6_cov_inf0) 0)
		)
		15
	)
)

(script command_script cs_e6_mars_inf1_cower
	(cs_crouch true)
	(sleep_forever)
)

(script command_script cs_e6_mars_inf0_1_cower
	(cs_crouch true)
	(sleep_until (volume_test_objects tv_e6_hotel_entrance (players)))
)

(script command_script cs_e6_mars_inf1_abort
	(sleep 1)
)

(script command_script cs_e6_mars_inf1_lead
	(cs_enable_looking true)
	(sleep_until
		(begin
			; If the player is in the trigger volume, go inside
			(if (volume_test_objects tv_e6_hotel_vicinity (players))
				; Go inside
				(begin
					(cs_enable_looking true)
					(cs_face_player false)
					(cs_start_to e6_mars_inf1_lead/p1)
					(sleep_until (not (volume_test_objects tv_e6_hotel_vicinity (players))))
				)
				
				; Come back outside
				(begin
					(cs_enable_looking false)
					(cs_face_player true)
					(cs_start_to e6_mars_inf1_lead/p0)
					(sleep_until (volume_test_objects tv_e6_hotel_vicinity (players)))
				)
			)
		
			; Loop forever
			false
		)
		15
	)
)

(script command_script cs_e6_hotel_greeting_scene
	; Move out
	(cs_enable_targeting false)
	(cs_look_player true)
	(cs_start_to e6_mars_inf1_lead/p0)

	; Wait for him to get closer
	(sleep_until (<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 7) 15)
	(sleep (ai_play_line_at_player ai_current_actor 8070)) ; "Chief, glad you could make it!"
	(cs_movement_mode ai_movement_patrol)
	
	; Approach the player
	(cs_look_player false)
	(cs_enable_looking true)
	(cs_approach_player 2 5.0 10.0)
	(sleep (ai_play_line_at_player ai_current_actor 0460))	; "Crash site's on the other side, Chief."
	
	; Muzak
	(wake music_03a_04_start)

	; Head inside
	(cs_movement_mode ai_movement_combat)
	(cs_go_to e6_mars_inf1_lead/p1)
;*	(sleep_until 
		(<= (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 3) 
		15
		60
	)
*;
	; Have him follow along
	(cs_queue_command_script ai_current_actor cs_e6_mars_inf1_lead)
)

(script command_script cs_e6_hotel_grunt_scene
	(cs_play_line 0430)	; "Us safe up here!"
)

(script command_script cs_e6_hotel_rescue_scene
	(cs_play_line 0450)	; "Quick, draw them away!"
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script static boolean e6_cov_inf0_not_a_threat
	(and
		(<= (ai_living_count e6_cov) 4) 
		(<= (ai_fighting_count e6_cov) 0) 
	)
)

(script dormant e6_cov_inf1_main
	; Only run these guys if the player comes up top
	(if (not (volume_test_objects tv_e6_main_begin2 (players))) (sleep_forever))
	(ai_place e6_cov_inf1)
	
	; Run the scene
	(sleep_until 
		(ai_scene e6_hotel_grunt_scene cs_e6_hotel_grunt_scene e6_cov_inf1)
		30 
		two_minutes
	)
)

(script dormant e6_cov_inf0_main
	(ai_place e6_cov_inf0_2)
	(ai_place e6_cov_inf0_0 (pin (- 10 (ai_living_count covenant)) 1 2))
	(ai_place e6_cov_inf0_1 (pin (- 10 (ai_living_count covenant)) 0 2))
)

(script dormant e6_mars_inf1_main
	(ai_place e6_mars_inf1)
	
	; TODO: Get rid of this
	; Sleep until the Covenant are dead or the player is near
	(sleep_until 
		(or
			(volume_test_objects tv_e6_hotel_vicinity (players))
			(e6_cov_inf0_not_a_threat)
		)
		10
	)

	; Run the scene
	(sleep_until
		(or
			(ai_scene e6_hotel_greeting_scene cs_e6_hotel_greeting_scene e6_mars_inf1/marine0)
			(<= (ai_living_count e6_mars_inf1/marine0) 0)
			(volume_test_objects tv_e6_hotel_entrance (players))
		)
		5
	)

	; Have the other ODST break out
	(sleep 20)
	(cs_run_command_script e6_mars_inf1/marine1 cs_e6_mars_inf1_abort)
	
	; Try to sneak in a save
	(game_save)
	
	; Wait for it...
	(sleep_until
		(volume_test_objects tv_e6_hotel_entrance (players))
		15
	)
	(cs_run_command_script e6_mars_inf1/marine0 cs_e6_mars_inf1_abort)	
)

(script dormant e6_mars_inf0_main
	(ai_migrate e5_mars_inf0 e6_mars_inf0)
	(ai_renew e6_mars_inf0)
	(ai_disposable e6_mars_inf0 false)
	
	; Wait until the Covenant are active
	(sleep_until (> (ai_spawn_count e6_cov_inf0) 0))
	
	; Place more Marines if we need them
	(ai_place e6_mars_inf0_1 (- 2 (ai_living_count e6_mars_inf0)))
	(ai_migrate e6_mars_inf0_1 e6_mars_inf0)
	(ai_renew e6_mars_inf0)
	(ai_disposable e6_mars_inf0 false)

	; Run the scene
;*	(sleep_until 
		(ai_scene e6_hotel_rescue_scene cs_e6_hotel_rescue_scene e6_mars_inf0) 
		30
		one_minute
	)
	*;
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e6_main
	(sleep_until 
		(or
			(volume_test_objects tv_e6_main_begin0 (players))
			(volume_test_objects tv_e6_main_begin1 (players))
			(volume_test_objects tv_e6_main_begin2 (players))
		)
		15
	)
	(set g_e6_started true)
	(print "e6_main")
	(data_mine_set_mission_segment "e6_hotel_entrance")
	(game_save)
	;(garbage_collect_now)
	
	; Muzak failsafe
	(wake music_03a_03_stop)

	; Wake subsequent scripts
	(wake e7_main)

	; Wake control scripts
	(wake e6_mars_inf0_main)
	(wake e6_mars_inf1_main)
	(wake e6_cov_inf0_main)
	(wake e6_cov_inf1_main)
	
	; Condemn the AI
	(sleep_until g_e7_started)
	(ai_disposable e6_cov true)	

	; Shut down
	(sleep_until (= (structure_bsp_index) 1))
	(sleep_forever e6_mars_inf0_main)
	(sleep_forever e6_mars_inf1_main)
	(sleep_forever e6_cov_inf0_main)
	(sleep_forever e6_cov_inf1_main)
	
	; Clean up
	(sleep_until (= (structure_bsp_index) 1))
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
)


;= ENCOUNTER 5b ==========================================================================

(global boolean g_e5b_started false)
(global boolean g_e5b_finished false)

; Nothing to see here
(script static void e5b_reset_player
	(fade_out 1 1 1 5)
	(sleep 5)
	(object_teleport (player0) e5b_return)
	(unit_add_equipment (unit (player0)) wimpy true true)
	(sleep 5)
	(fade_in 1 1 1 5)
	(sleep 5)
)

(script dormant e5b_resetter
	(sleep_until
		(begin
			; Teleport if necessary
			(if (not (volume_test_object tv_e5b_bounds (player0)))
				(e5b_reset_player)
			)
			
			; Loop until finished
			g_e5b_finished
		)
	)
)

(script dormant e5b_inf0_main
	(ai_place e5b_cov_inf0 1)
	(ai_set_active_camo e5b_cov_inf0 true)
	(sleep 90)
	(ai_set_active_camo e5b_cov_inf0 false)
	(ai_magically_see_object e5b_cov_inf0 (player0))
	(sleep_until (<= (ai_living_count e5b_cov_inf0) 0))
	(garbage_collect_now)
	
	; Wave 2
	(ai_place e5b_cov_inf0 2)
	(ai_set_active_camo e5b_cov_inf0 true)
	(sleep 90)
	(ai_set_active_camo e5b_cov_inf0 false)
	(ai_magically_see_object e5b_cov_inf0 (player0))
	(sleep_until (<= (ai_living_count e5b_cov_inf0) 0))
	(garbage_collect_now)
	
	; Wave 3
	(ai_place e5b_cov_inf0 3)
	(ai_set_active_camo e5b_cov_inf0 true)
	(sleep 90)
	(ai_set_active_camo e5b_cov_inf0 false)
	(ai_magically_see_object e5b_cov_inf0 (player0))
	(sleep_until (<= (ai_living_count e5b_cov_inf0) 0))
	(garbage_collect_now)
	
	; Wave 4
	(ai_place e5b_cov_inf0 4)
	(ai_set_active_camo e5b_cov_inf0 true)
	(sleep 90)
	(ai_set_active_camo e5b_cov_inf0 false)
	(ai_magically_see_object e5b_cov_inf0 (player0))
	(sleep_until (<= (ai_living_count e5b_cov_inf0) 0))
	(garbage_collect_now)
	
	; Wave 5
	(ai_place e5b_cov_inf0 5)
	(ai_set_active_camo e5b_cov_inf0 true)
	(sleep 90)
	(ai_set_active_camo e5b_cov_inf0 false)
	(ai_magically_see_object e5b_cov_inf0 (player0))
	(sleep_until (<= (ai_living_count e5b_cov_inf0) 0))
	(garbage_collect_now)
	
	; Wave 6
	(ai_place e5b_cov_inf0 6)
	(ai_set_active_camo e5b_cov_inf0 true)
	(sleep 90)
	(ai_set_active_camo e5b_cov_inf0 false)
	(ai_magically_see_object e5b_cov_inf0 (player0))
	(sleep_until (<= (ai_living_count e5b_cov_inf0) 0))
	(garbage_collect_now)
	
	; Wave 7
	(ai_place e5b_cov_inf0 7)
	(ai_set_active_camo e5b_cov_inf0 true)
	(sleep 90)
	(ai_set_active_camo e5b_cov_inf0 false)
	(ai_magically_see_object e5b_cov_inf0 (player0))
	(sleep_until (<= (ai_living_count e5b_cov_inf0) 0))
	(garbage_collect_now)
	
	; You win!
	(set g_e5b_finished true)
	(ice_cream_flavor_stock 5) ; Daddy!
)

(script dormant e5b_main
	; Some things shut this down immediately
	(if 
		(or
			(game_is_cooperative)
			(not (difficulty_legendary))
			(not (= 0 (random_range 0 7)))
		)
		(sleep_forever)
	)
	
	; If the player is nearby, create the key
	(sleep_until (volume_test_objects tv_e5b_main (players)) 15)

	; Here is the horrible part
	(game_save_cancel)
	(game_save)
	(sleep_until (not (game_saving)) 1)
	(if (not (game_reverted))
		; Do it. Do it now.
		(begin			
			; Shut down e5
			(set g_e5b_started true)
		
			; Create the key
			(object_create key)
			
			; Wait until someone picks it up...
			(sleep_until 
				(and
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
					(volume_test_object tv_e5b_main (player0))
				)
				5
			)
		
			; Teleport the player...
			(sleep 30)
			(e5b_reset_player)
			
			; Start things up
			(wake e5b_inf0_main)
			(wake e5b_resetter)
		)
	)
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

Covenant
	e5_cov_inf0 - Initial Jackal presence
		(init)
	e5_cov_inf1 - Reinforcements, the main course
		_0 - Elite and Grunts from the left side
		_1 - Elite and Grunts from the right side
		_2 - Elite and Grunts from far back, left side
		_3 - Ditto, right side
	e5_cov_inf2 - Rooftop defenders in the second section

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e5_started false)			; Encounter has been activated?
(global boolean g_e5_cov_inf1_done false)
(global short g_e5_cov_inf1_max 10)
(global short g_e5_cov_inf1_spawn_delay 30)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e5_cov_inf0_guard0
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(sleep_until 
		(begin
			(begin_random
				(begin
					(cs_aim true e5_cov_ambush/look0)
					(sleep (random_range 100 150))
				)
				(begin
					(cs_aim true e5_cov_ambush/look1)
					(sleep (random_range 45 90))
				)
				(begin
					(cs_aim true e5_cov_ambush/look2)
					(sleep (random_range 45 90))
				)
			)
		
			; Sleep forever
			false
		)
		5
	)
)

(script command_script cs_e5_cov_inf0_wait
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_crouch true)
	(sleep_until (ai_trigger_test e5_cov_inf0_ambush_sprung ai_current_squad) 5)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e5_cov_inf0_ambush_trigger
	(or
;		(<= (ai_living_count e5_cov_inf0_0) 0)
		(volume_test_objects tv_e5_ambush_trigger0 (players))
		(volume_test_objects tv_e5_ambush_trigger1 (players))
		(volume_test_objects tv_e5_ambush_trigger2 (players))
	)
)

(script static boolean e5_cov_inf1_done
	(= g_e5_cov_inf1_done true)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e5_cov_inf4_main
	(ai_migrate e4_cov_inf1 e5_cov_inf4)
)

(script dormant e5_cov_inf3_main
	(if (not (difficulty_legendary)) (sleep_forever))
	(sleep_until 
		(volume_test_objects tv_e5_player_advanced (players))
	)
	(if (< (ai_living_count covenant) 15) (ai_place e5_cov_inf3))
)

(script dormant e5_cov_inf2_main
	(sleep_until 
		(volume_test_objects tv_e5_player_advanced (players))
	)
	(if (< (ai_living_count covenant) 15) (ai_place e5_cov_inf2))
)

(script static void e5_cov_inf1_0_spawn
	(print "e5_cov_inf1_0_spawn")
	(if 
		(and
			(<= (ai_living_count e5_cov_inf1) 1)
			(not (volume_test_objects tv_e5_cov_inf1_unsafe0 (players)))
			(not (volume_test_objects tv_e5_cov_inf1_done (players)))
		)
		(begin
			(ai_place e5_cov_inf1_0 (pin (- 7 (ai_living_count e5_cov)) 0 4))
			(ai_set_orders e5_cov_inf1_0 e5_cov_inf1_0_init)
		)
	)
	(sleep_until
		(or
			(<= (ai_living_count e5_cov_inf1) 1)
			(volume_test_objects tv_e5_cov_inf1_done (players))
		)
	)
	(sleep_until
		(volume_test_objects tv_e5_cov_inf1_done (players))
		30
		g_e5_cov_inf1_spawn_delay
	)
)

(script static void e5_cov_inf1_1_spawn
	(print "e5_cov_inf1_1_spawn")
	(if 
		(and
			(<= (ai_living_count e5_cov_inf1) 1)
			(not (volume_test_objects tv_e5_cov_inf1_unsafe1 (players)))
			(not (volume_test_objects tv_e5_cov_inf1_done (players)))
		)
		(begin
			(ai_place e5_cov_inf1_1 (pin (- 7 (ai_living_count e5_cov)) 0 4))
			(ai_set_orders e5_cov_inf1_1 e5_cov_inf1_1_init)
		)
	)
	(sleep_until
		(or
			(<= (ai_living_count e5_cov_inf1) 1)
			(volume_test_objects tv_e5_cov_inf1_done (players))
		)
	)
	(sleep_until
		(volume_test_objects tv_e5_cov_inf1_done (players))
		30
		g_e5_cov_inf1_spawn_delay
	)
)

(script dormant e5_cov_inf1_main
	; Migrate the stealth guys over
	(ai_migrate e4_cov_inf2 e5_cov_inf1_1)
	
	; Wait until the ambush is sprung
	(sleep_until 
		(volume_test_objects tv_e5_advanced0 (players))
		15
	)
	
	; Know our limits. There is a price you cannot pay.
	(if (difficulty_heroic) 
		(begin
			(set g_e5_cov_inf1_max 16)
			(set g_e5_cov_inf1_spawn_delay 15)
		)
	)
	(if (difficulty_legendary) 
		(begin
			(set g_e5_cov_inf1_max 30)
			(set g_e5_cov_inf1_spawn_delay 5)
		)
	)

	; Begin the encounter proper
	(sleep_until
		(begin
			; Do we need more?
			(if (volume_test_objects tv_e5_main_begin0 (players))
				(e5_cov_inf1_0_spawn)
				(e5_cov_inf1_1_spawn)
			)
			(if (not (volume_test_objects tv_e5_main_begin0 (players)))
				(e5_cov_inf1_0_spawn)
				(e5_cov_inf1_1_spawn)
			)
			(if (not g_e5b_started) (game_save))
		
			; Loop until the player has pushed forward or the limit is reached
			(or
				(>= (+ (ai_spawn_count e5_cov_inf1_0) (ai_spawn_count e5_cov_inf1_1)) g_e5_cov_inf1_max)
				(volume_test_objects tv_e5_cov_inf1_done (players))
			)
		)
	)
	
	; Flag it as done
	(set g_e5_cov_inf1_done true)
)

(script dormant e5_cov_inf0_main
	(ai_place e5_cov_inf0_0/sniper0)
;	(ai_place e5_cov_inf0_1)
	
	; Wait for it...
	(sleep_until 
		(or
			(< (ai_living_count e5_cov_inf0) 1)
			(volume_test_objects tv_e5_advanced1 (players))
		)
	)
	(if (< (ai_living_count covenant) 15) (ai_place e5_cov_inf0_0/sniper1))

	(sleep_until 
		(or
			(< (ai_living_count e5_cov_inf0) 2)
			(volume_test_objects tv_e5_advanced1 (players))
		)
	)
	(if (< (ai_living_count covenant) 15) (ai_place e5_cov_inf0_0/sniper2))

	(sleep_until 
		(or
			(< (ai_living_count e5_cov_inf0) 2)
			(volume_test_objects tv_e5_advanced1 (players))
		)
	)
	(if (< (ai_living_count covenant) 15) (ai_place e5_cov_inf0_0/sniper3))
)

(script dormant e5_mars_inf0_main
	; Migrate them over
	(ai_migrate e4_mars_inf0 e5_mars_inf0)
	(ai_renew e5_mars_inf0)
	(ai_disposable e5_mars_inf0 false)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e5_main
	(sleep_until 
		(or
			(volume_test_objects tv_e5_main_begin0 (players))
			(volume_test_objects tv_e5_main_begin1 (players))
			(volume_test_objects tv_e5_main_begin2 (players))
		)
	)
	(set g_e5_started true)
	(print "e5_main")
	(data_mine_set_mission_segment "e5_neighborhood")
	(if (not g_e5b_started) (game_save))
	;(garbage_collect_now)

	; Muzak failsafe
	(wake music_03a_03_stop)

	; Wake control scripts
	(wake e5_mars_inf0_main)
	(wake e5_cov_inf0_main)
	(wake e5_cov_inf1_main)
	(wake e5_cov_inf2_main)
	(wake e5_cov_inf3_main)
	(wake e5_cov_inf4_main)
		
	; Condemn the AI
	(sleep_until g_e6_started)
	(ai_disposable e5_cov true)	

	; Shut down
	(sleep_until (or (= (structure_bsp_index) 1) g_e5b_started))
	(sleep_forever e5_mars_inf0_main)
	(sleep_forever e5_cov_inf0_main)
	(sleep_forever e5_cov_inf1_main)
	(sleep_forever e5_cov_inf2_main)
	(sleep_forever e5_cov_inf3_main)
	
	; Clean up
	(sleep_until (or (= (structure_bsp_index) 1) g_e5b_started))
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
		(engage1) - Advance further
		(wait2) - Wait at the exit once e4_cov_inf1_1 is dead

Covenant
	e4_cov_inf0_0 - Assorted Covenant infantry bunkering in the alleyway
	e4_cov_inf0_1 - Reinforcements
		(init) - Bunker in alleyway
		(regroup) - Regroup towards the end of the alleyway
	e4_cov_inf1 - Buggers moving along rooftops, dropping in from above
		_0 - Initial group
		_1 - Second wave
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

(script command_script cs_e4_cov_inf0_0_patrol0
	(cs_abort_on_combat_status ai_combat_status_active)
	(sleep_until
		(begin
			; p0
			(cs_go_to e4_patrol/p2)
			(cs_enable_looking false)
			(cs_look true e4_patrol/f0)
			(sleep (random_range 60 90))
			(cs_look false e4_patrol/f0)
			(cs_enable_looking true)

			; p1
			(cs_go_to e4_patrol/p3)
			(cs_enable_looking false)
			(cs_look true e4_patrol/f0)
			(sleep (random_range 60 90))
			(cs_look false e4_patrol/f0)
			(cs_enable_looking true)
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e4_cov_inf0_0_patrol1
	(cs_abort_on_combat_status ai_combat_status_active)
	(sleep_until
		(begin
			; p0
			(cs_go_to e4_patrol/p4)
			(cs_enable_looking false)
			(cs_look true e4_patrol/f0)
			(sleep (random_range 60 90))
			(cs_look false e4_patrol/f0)
			(cs_enable_looking true)

			; p1
			(cs_go_to e4_patrol/p5)
			(cs_enable_looking false)
			(cs_look true e4_patrol/f0)
			(sleep (random_range 60 90))
			(cs_look false e4_patrol/f0)
			(cs_enable_looking true)
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e4_cov_inf0_2_patrol0
	(cs_abort_on_combat_status ai_combat_status_active)
	(sleep_until
		(begin
			; p0
			(cs_go_to e4_patrol/p0)
			(cs_enable_looking false)
			(cs_look true e4_patrol/f0)
			(sleep (random_range 60 90))
			(cs_look false e4_patrol/f0)
			(cs_enable_looking true)

			; p1
			(cs_go_to e4_patrol/p1)
			(cs_enable_looking false)
			(cs_look true e4_patrol/f0)
			(sleep (random_range 60 90))
			(cs_look false e4_patrol/f0)
			(cs_enable_looking true)
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e4_cov_inf0_1_patrol0
	(cs_abort_on_combat_status ai_combat_status_active)
	(sleep_until
		(begin
			; p0
			(cs_go_to e4_patrol/p6)
			(cs_enable_looking false)
			(cs_look true e4_patrol/f0)
			(sleep (random_range 60 90))
			(cs_look false e4_patrol/f0)
			(cs_enable_looking true)

			; p1
			(cs_go_to e4_patrol/p7)
			(cs_enable_looking false)
			(cs_look true e4_patrol/f1)
			(sleep (random_range 45 60))
			(cs_look false e4_patrol/f1)
			(cs_enable_looking true)
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e4_cov_inf2_lurk
	(cs_crouch true)
	(cs_abort_on_damage true)
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(sleep_until
		(or
			(>= (ai_combat_status ai_current_squad) ai_combat_status_clear_los)
			(volume_test_objects tv_e4_cov_inf2_begin (players))
		)
		15
	)
)


;- Order Scripts ---------------------------------------------------------------
;- Squad Controls --------------------------------------------------------------

(script dormant e4_cov_snipers0_main
	(ai_place e4_cov_snipers0_0)
	(ai_place e4_cov_snipers0_1)
	
	; Wait for one sniper to die, or for the advance
	(sleep_until 
		(or
			(< (ai_living_count e4_cov_snipers0) 3)
			(volume_test_objects tv_e4_cov_inf1_main_begin (players))
		)
	)
	
	; Send in the low sniper
	(if (< (ai_living_count e4_cov_snipers0) 3) (ai_place e4_cov_snipers0_2/sniper0))
	
	; Wait again
	(sleep_until 
		(or
			(< (ai_living_count e4_cov_snipers0) 3)
			(volume_test_objects tv_e4_player_moved_up (players))
		)
	)
	
	; Again and again
	(sleep_until 
		(or
			(< (ai_living_count e4_cov_snipers0) 3)
			(volume_test_objects tv_e4_player_moved_up (players))
		)
	)
	(if (< (ai_living_count e4_cov_snipers0) 3) (ai_place e4_cov_snipers0_2/sniper1))
	(sleep_until 
		(or
			(< (ai_living_count e4_cov_snipers0) 3)
			(volume_test_objects tv_e4_player_moved_up (players))
		)
	)
	(if (< (ai_living_count e4_cov_snipers0) 3) (ai_place e4_cov_snipers0_2/sniper2))
	
	; Checkpoint
	(sleep_until 
		(<= (ai_living_count e4_cov_snipers0) 0)
	)
	(game_save)
)

(script dormant e4_cov_inf2_main
	(if (difficulty_normal) (sleep_forever))
	(sleep_until 
		(volume_test_objects tv_e4_player_moved_up (players)) 
		15
	)
	(if 
		(and
			(difficulty_legendary)
			(= (random_range 0 3) 0)
		)
		(ai_place e4_cov_inf2 (pin (- 8 (ai_living_count e4_cov)) 1 3))
		(ai_place e4_cov_inf2 (pin (- 8 (ai_living_count e4_cov)) 1 2))	
	)
	
	; Checkpoint
	(sleep_until 
		(or
			(<= (ai_living_count e4_cov_inf2) 0)
			g_e5_started
		)
	)
	(game_save)
)

(script dormant e4_cov_inf1_main
	(sleep_until 
		(or
			(volume_test_objects tv_e4_player_moved_up (players)) 
			(<= (ai_living_count e4_cov_snipers0_0) 1) 
		)
		15
	)
	(ai_place e4_cov_inf1_0 (pin (- 7 (ai_living_count e4_cov)) 2 4))

	; Respawn a few
	(sleep_until
		(begin
			(if 
				(and
					(< (ai_living_count e4_cov) 6)
					(not (volume_test_objects tv_e4_end_of_street (players)))
				)
				(ai_place e4_cov_inf1_0 2)
			)
		
			; Until enough have spawned
			(or
				(>= (ai_spawn_count e4_cov_inf1) 8)
				(volume_test_objects tv_e4_end_of_street (players))
			)
		)
		90
	)
)

(script dormant e4_cov_inf0_main
	; Sleep until the player has moved up
	(sleep_until 
		(or
			(volume_test_objects tv_e4_player_moved_up (players))
			(and
				(<= (ai_living_count e4_cov_snipers0_1) 0) 
				(<= (ai_living_count e4_cov_snipers0_2) 1)
			)
		)
		15
	)
	(ai_place e4_cov_inf0_0 (pin (- 8 (ai_living_count e4_cov)) 0 2))
	
	; Wait until reins are needed
	(sleep_until 
		(or
			(volume_test_objects tv_e4_player_moved_up (players))
			(<= (ai_living_count e4_cov_inf0_0) 0) 
		)
		15
	)
	
	; If the player isn't in the volume, replenish the jackals
	(if (not (volume_test_objects tv_e4_player_moved_up (players)))
		(ai_place e4_cov_inf0_1 (pin (- 8 (ai_living_count e4_cov)) 0 2))
	)
)

(script dormant e4_mars_inf0_main
	; Migrate the Marines over
	(ai_migrate e3_mars_inf0 e4_mars_inf0)
	(ai_migrate e3_mars_inf1 e4_mars_inf0)
	(ai_renew e4_mars_inf0)
	(ai_disposable e4_mars_inf0 false)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e4_main
	(sleep_until (volume_test_objects tv_e4_main_begin (players)))
	(set g_e4_started true)
	(print "e4_main")
	(data_mine_set_mission_segment "e4_sniper_alley")
	(game_save)
	;(garbage_collect_now)

	; Muzak failsafe
	(wake music_03a_03_start)

	; Wake subsequent scripts
	(wake e5_main)
	(wake e5b_main)

	; Set the next objective
	(wake objective1_clear)
	(wake objective2_set)

	; Wake control scripts
	(wake e4_mars_inf0_main)
	(wake e4_cov_inf0_main)
	(wake e4_cov_inf1_main)
	(wake e4_cov_inf2_main)
	(wake e4_cov_snipers0_main)
	
	; Shut down
	(sleep_until (or g_e5_started g_e6_started))
	(sleep_forever e4_mars_inf0_main)
	(sleep_forever e4_cov_inf0_main)
	(sleep_forever e4_cov_inf1_main)
	(sleep_forever e4_cov_snipers0_main)
	
	; Condemn the AI
	(ai_disposable e4_cov true)	
)

(script static void test_sniper_alley
	(object_teleport (player0) e4_test)
	(ai_place e4_mars_inf0)
	(if (not g_e4_started) (wake e4_main))

	; Get the other scripts running
	(if (not g_e6_started) (wake e6_main))
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
)


;= ENCOUNTER 3 ===========================================================================
;*
An infantry squad is fortifying the crushed highway section, retreating
before the player's advance.

Begins when the player approaches the highway.
Ends when the Covenant are dead and Johnson is evac'ed.

Marines
	e3_mars_inf0 - e2_mars_inf0
		(wait) - Wait and watch until the player opens hostilities
		(engage) - Step out and engage e3_cov_inf0_2
		(advance0) - Advance up to the edge of the highway pieces
		(advance1) - Attack more aggressively once the sniper is dead
		(advance2) - Move in and mop up the remaining Covenant
	e3_mars_johnson - e2_mars_johnson
		(wait) - Wait for the player to open hostilities
		(snipe0) - Countersnipe
		If Johnson doesn't have a rifle, he uses inf0 orders

Covenant
	e3_cov_inf0_0 - The marching infantry
		(init) - Head to and hold the street crossing
		(retreat0) - Cower in alley after being weakened
	e3_cov_inf0_1 - Sniper above the corner
		(init) - Stand and snipe
	e3_cov_inf0_2 - e2_cov_inf0 + Jackals at the very entrance
		(init) - Guarding the entrance
		(flee0) - Flee back to the other side of the highway

Open Issues

*;
;- Globals ---------------------------------------------------------------------

(global boolean g_e3_started false)			; Encounter has been activated?

(global boolean g_e3_mars_pelican0_arrived false)
(global boolean g_e3_mars_pelican0_landed false)
(global boolean g_e3_johnson_should_load false)
(global boolean g_e3_johnson_in_pelican false)

(global short g_e3_cov_inf0_0_limit 12)


;- Event Controls --------------------------------------------------------------
;- Command Scripts -------------------------------------------------------------

(script command_script cs_e3_sniper_intro_scene
	(ai_play_line ai_current_actor 0370) ; "Snipers suxor"
)

(script dormant e3_mars_sniper_scene
	; Begin the scene
	(sleep_until 
		(ai_scene e3_sniper_intro_scene cs_e3_sniper_intro_scene e3_mars)
		30 
		450
	)
)

(script command_script cs_e3_cov_inf0_1_intro
	(cs_crouch true)
	(cs_face true e3_cov_sniper/p0)
	(sleep_until (>= (ai_combat_status ai_current_actor) ai_combat_status_certain) 10)
	(sleep 15)
	(cs_shoot_point true e3_cov_sniper/p0)
	
	; Wake the shooting scene
	(wake e3_mars_sniper_scene)
	
	; Fire again
	(sleep 30)
	(cs_shoot_point true e3_cov_sniper/p1)
	(sleep 90)
)

(script command_script cs_e3_cov_inf0_1_patrol0
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_looking false)
	(sleep_until
		(begin
			(begin_random
				(begin (cs_look true e3_patrol/f0) (sleep (random_range 60 90)))
				(begin (cs_look true e3_patrol/f1) (sleep (random_range 60 90)))
				(begin (cs_look true e3_patrol/f2) (sleep (random_range 60 90)))
				(begin (cs_look true e3_patrol/f3) (sleep (random_range 60 90)))
			)
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e3_mars_pelican0_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_face true e3_mars_evac/p2)
	(cs_fly_to e3_mars_evac/p0)
	(set g_e3_mars_pelican0_arrived true)
	(sleep 45)
	(cs_fly_to e3_mars_evac/p1)
	(cs_fly_to e3_mars_evac/p3 1.0)
	(set g_e3_mars_pelican0_landed true)
	(sleep_forever)
)

(script command_script cs_e3_mars_pelican0_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 0.5)
	(cs_fly_to e3_mars_evac/p4 1)
	(sleep 30)
	(cs_vehicle_speed 1)
	(cs_fly_by e3_mars_evac/p2)
	(ai_erase ai_current_squad)
)

(script command_script cs_e3_mars_johnson_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e3_mars_evac/johnson0)
	
	; Wait here until we should load
	(cs_enable_targeting true)
	(sleep_until g_e3_johnson_should_load 5)

	; Walk over
	(cs_movement_mode ai_movement_patrol)
	(cs_face_object true (ai_get_object e3_mars_pelican0/pelican0))
	(cs_go_to e3_mars_evac/johnson1)
	
	; Face the player and wave
	(cs_face_player true)
	(sleep_until 
		(or
			(objects_can_see_object (ai_get_object ai_current_actor) (player0) 10)
			(and
				(game_is_cooperative)
				(objects_can_see_object (ai_get_object ai_current_actor) (player1) 10)
			)
		)
		1
	)
	(sleep_until (objects_can_see_object (players) (ai_get_object ai_current_actor) 15) 2 30)

	; Dialogue
	(sleep 20)
	(ai_play_line_at_player e3_mars_johnson 0970) ; "Johnson: Bye Chief, off to wuss."
		
	; Wave
	(sleep 20)
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\marine\marine" "combat:rifle:wave" true)
	(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
)

(script command_script cs_e3_mars_johnson_slam
	(cs_go_to e3_mars_evac/johnson1)
	(ai_vehicle_enter_immediate ai_current_actor (ai_vehicle_get e3_mars_pelican0/pelican0) "pelican_e")
)

(script command_script cs_e3_mars_inf1_ride
	(sleep_until g_e3_mars_pelican0_landed 5)
	(ai_vehicle_exit ai_current_actor)
	(cs_enable_targeting true)
	(cs_enable_moving true)
	(sleep 60)
	(if g_e4_started 
		(ai_migrate ai_current_actor e4_mars_inf0)
		(ai_migrate ai_current_actor e3_mars_inf0)
	)
)

(script command_script cs_e3_mars_johnson_teleport
	(cs_teleport e3_mars_evac/johnson_teleport0 e3_mars_evac/johnson_teleport1)
)


;- Order Scripts ---------------------------------------------------------------

(script static boolean e3_mars_pelican0_arrived
	(= g_e3_mars_pelican0_arrived true)
)

(script static boolean e3_mars_johnson_loaded
	(= g_e3_johnson_in_pelican true)
)

(script static boolean e3_cov_inf0_0_should_regroup
	(or
		g_e4_started
		(and
			(>= (ai_spawn_count e3_cov_inf0_0) g_e3_cov_inf0_0_limit)
			(<= (ai_living_count e3_cov_inf0_0) 4)
		)
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e3_cov_inf0_main
	(ai_place e3_cov_inf0_0)
	(ai_place e3_cov_inf0_1)
	
	; Wait until they've died a bit, send in a token reinforcement
	(sleep_until 
		(or
			(<= (ai_living_count e3_cov_inf0) 2)
			(volume_test_objects tv_e3_crossing_street (players))
		)
		15
	)
	(ai_place e3_cov_inf0_2)
)

(script dormant e3_mars_pelican0_main
	; Wait until the Covenant are driven back or the player has advanced
	(sleep_until 
		(or
			g_e4_started
			(volume_test_objects tv_e3_mars_pelican0_begin (players))
			(and
				(> (ai_spawn_count e3_cov_inf0) 0)
				(<= (ai_living_count e3_cov_inf0) 2)
			)
		)
		30
		two_minutes
	)

	; Cruise on in
	(ai_place e3_mars_pelican0)
	(cs_run_command_script e3_mars_pelican0/pelican0 cs_e3_mars_pelican0_entry)
	
	; Wait until Johnson is on board
	(sleep_until g_e3_johnson_in_pelican 5)
	
	; And exit
	(cs_run_command_script e3_mars_pelican0/pelican0 cs_e3_mars_pelican0_exit)
)

(script dormant e3_mars_inf1_main
	; Wait until dropship has spawned
	(sleep_until (> (ai_spawn_count e3_mars_pelican0) 0))
	
	; Place them
	(ai_place e3_mars_inf1 (pin (- 3 (ai_living_count e3_mars_inf0)) 0 3))
	(ai_vehicle_enter_immediate e3_mars_inf1 (ai_vehicle_get e3_mars_pelican0/pelican0) "pelican_p_r")
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
	(ai_renew e3_mars_inf0)
	(ai_disposable e3_mars_inf0 false)
	
	; Wait until Johnson is loaded, then migrate over anyone who might be in 
	; his squad
	(sleep_until g_e3_johnson_in_pelican)
	(ai_migrate e3_mars_johnson e3_mars_inf0)
	(ai_disposable e3_mars_inf0 false)
)

(script dormant e3_mars_johnson_main
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
	(ai_migrate e1_mars_johnson e3_mars_johnson)
	(ai_migrate e2_mars_johnson e3_mars_johnson)
	(ai_disposable e3_mars_johnson false)
	
	; Wait until the pelican spawns
	(sleep_until (> (ai_spawn_count e3_mars_pelican0) 0) 15)

	; If necessary, teleport Johnson in
	(if (not (volume_test_objects tv_e3_johnson_required (ai_actors e3_mars_johnson)))
		(begin
			(sleep_until (not (volume_test_objects tv_e3_johnson_teleport_unsafe (players))))
			(cs_run_command_script e3_mars_johnson cs_e3_mars_johnson_teleport)
		)
	)

	; Wait for the Pelican
	(sleep_until g_e3_mars_pelican0_arrived 15)
	
	; Clear last objective
	(wake objective1_clear)
	
	; Go to the Pelican, evac, etc.
	(cs_run_command_script e3_mars_johnson cs_e3_mars_johnson_exit)
	
	; Dialog
	(sleep (ai_play_line_on_object none 0940)) ; "Miranda: Johnson, I'm giving you the bird"
	(sleep 20)
	(sleep (ai_play_line e3_mars_johnson 0950)) ; "Johnson: wtf."
	(sleep 15)
	(sleep (ai_play_line_on_object none 0960)) ; "Miranda: My pelicans etc"

	; Load him up
	(set g_e3_johnson_should_load true)
	(sleep_until (not (cs_command_script_queued e3_mars_johnson cs_e3_mars_johnson_exit)) 1)
	(ai_vehicle_enter e3_mars_johnson (ai_vehicle_get e3_mars_pelican0/pelican0) "pelican_e")
	
	; Wait till Johnson is gone
	(sleep_until
		(vehicle_test_seat_list (ai_vehicle_get e3_mars_pelican0/pelican0) "pelican_e" (ai_actors e3_mars_pelican0))
		30
		300
	)
	
	; Saving throw
	(if (not (vehicle_test_seat_list (ai_vehicle_get e3_mars_pelican0/pelican0) "pelican_e" (ai_actors e3_mars_pelican0)))
		(cs_run_command_script e3_mars_johnson cs_e3_mars_johnson_slam)
	)
	
	; Check again...
	(sleep_until
		(vehicle_test_seat_list (ai_vehicle_get e3_mars_pelican0/pelican0) "pelican_e" (ai_actors e3_mars_pelican0))
		30
		30_seconds
	)
	(set g_e3_johnson_in_pelican true)
	
	; Game save
	(game_save)
	
	; Set the next objective
	(wake objective2_set)

	; Muzak
	(wake music_03a_03_start)
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
	(data_mine_set_mission_segment "e3_highway_underpass")
	(game_save)
	;(garbage_collect_now)
	
	; Muzak failsafe
	(wake music_03a_01_stop)
	(wake music_03a_02_stop)
	
	; Set the next objective
	(wake objective1_set)
	
	; Wake subsequent scripts
	(wake e4_main)
	(wake e6_main)

	; Wake control scripts
	(wake e3_mars_inf0_main)
	(wake e3_mars_inf1_main)
	(wake e3_mars_johnson_main)
	(wake e3_mars_pelican0_main)
	(wake e3_cov_inf0_main)
	
	; Shut down
	(sleep_until (or g_e4_started g_e6_started))
	(sleep_forever e3_mars_inf0_main)
	(sleep_forever e3_mars_inf1_main)
	(sleep_forever e3_cov_inf0_main)
	(sleep_forever e3_mars_sniper_scene)
	
	; Condemn the AI
	(ai_disposable e3_cov true)	
)

(script static void test_marching_infantry
	(object_teleport (player0) e3_test)
	(ai_place e3_mars_inf0)
	(ai_place e3_mars_johnson)
	(object_cannot_take_damage (ai_actors e3_mars_johnson))
	(if (not g_e3_started) (wake e3_main))

	; Get the other scripts running
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
)


;= ENCOUNTER 2 ===========================================================================
;*
As the Eagle prepares to depart with Johnson, the player is beset by a pair of
Hunters, who smash through an adjacent building.

Begins when the player is near the Eagle.
Ends when the Hunters are dead.

Marines
	e2_mars_inf0 - e1_mars_inf0 + e1_mars_inf2
		(init) - Gather and watch the Hunters exit
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
(global boolean g_e2_door_breached false)
(global boolean g_e2_cov_hunters0_active false)


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e2_cov_hunters0_taunt
	(set g_e2_cov_hunters0_active true)
	(cs_abort_on_damage true)
	(if (> (ai_strength ai_current_actor) 0.98) 
		(begin
			(custom_animation (ai_get_unit ai_current_actor) "objects\characters\hunter\hunter" "combat:unarmed:shakefist" true)
			(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
		)
	)
)

(script command_script cs_e2_cov_hunters0_0_entry
	(cs_queue_command_script ai_current_actor cs_e2_cov_hunters0_taunt)
	(sleep 220)
	(cs_force_combat_status 2)
	(cs_ignore_obstacles true)
	(cs_abort_on_damage true)
	(cs_look_player true)
	(cs_go_to e2_cov_hunters0_entry/p0_1)
	(cs_face_player true)
	(cs_movement_mode ai_movement_combat)
	
	; Wait for it...
	(sleep_until 
		(or
			(player_in_vehicle)
			(<= (objects_distance_to_object (ai_actors ai_current_squad) (player0)) 3.0) 
			(and
				(game_is_cooperative)
				(<= (objects_distance_to_object (ai_actors ai_current_squad) (player1)) 3.0) 
			)
			(and
				(ai_trigger_test generic_player_fired ai_current_squad)
				(objects_can_see_flag (players) e2_cov_hunters0_entry 20)
			)
			(< (ai_strength ai_current_squad) 0.98) 
		)
		5
		120
	)

	; Taunt him
	(if
		(not
			(or
				(player_in_vehicle)
				(<= (objects_distance_to_object (ai_actors ai_current_squad) (player0)) 3.0) 
				(and
					(game_is_cooperative)
					(<= (objects_distance_to_object (ai_actors ai_current_squad) (player1)) 3.0) 
				)
			(and
				(ai_trigger_test generic_player_fired ai_current_squad)
				(objects_can_see_flag (players) e2_cov_hunters0_entry 20)
			)
				(< (ai_strength ai_current_squad) 0.98) 
			)
		)
		(begin
			(custom_animation (ai_get_unit ai_current_actor) "objects\characters\hunter\hunter" "combat:unarmed:taunt" true)
			(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
		)
	)

	; Wait for the end
	(sleep_until 
		(or
			(player_in_vehicle)
			(<= (objects_distance_to_object (ai_actors ai_current_squad) (player0)) 4.0) 
			(and
				(game_is_cooperative)
				(<= (objects_distance_to_object (ai_actors ai_current_squad) (player1)) 4.0) 
			)
			(and
				(ai_trigger_test generic_player_fired ai_current_squad)
				(objects_can_see_flag (players) e2_cov_hunters0_entry 20)
			)
			(< (ai_strength ai_current_squad) 0.98) 
		)
		5
		120
	)
)

(script command_script cs_e2_cov_hunters0_1_entry
	(cs_queue_command_script ai_current_actor cs_e2_cov_hunters0_taunt)
	(sleep 220)
	(cs_force_combat_status 2)
	(cs_ignore_obstacles true)
	(cs_abort_on_damage true)
	(cs_look_player true)
	(cs_go_to e2_cov_hunters0_entry/p1)
	(cs_face_player true)
	(sleep_until 
		(or
			(player_in_vehicle)
			(<= (objects_distance_to_object (ai_actors ai_current_squad) (player0)) 4.0) 
			(and
				(game_is_cooperative)
				(<= (objects_distance_to_object (ai_actors ai_current_squad) (player1)) 4.0) 
			)
			(and
				(ai_trigger_test generic_player_fired ai_current_squad)
				(objects_can_see_flag (players) e2_cov_hunters0_entry 20)
			)
			(< (ai_strength ai_current_squad) 1) 
		)
		5
		240
	)
)

(script command_script cs_e2_cov_inf0_watch
	(cs_abort_on_damage true)

	; Wait for it...
	(sleep_until
		(or
			(volume_test_objects tv_e2_hunters_bypassed (players))
			(ai_trigger_test e2_cov_hunters0_active e2_cov_hunters0)
		)
		15
	)
)

(script command_script cs_e2_mars_johnson0_dialogue0
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\marine\marine" "combat:rifle:hold" true)
	(sleep 10)
	(sleep (ai_play_line e2_mars_johnson 0930)) ; "Johnson: Hah."
)

(script command_script cs_e2_mars_johnson0_watch
	(cs_go_to e2_mars_watch/p1)
	(cs_aim true e2_mars_watch/watch)
	
	; Wait till we actually have some Hunters
	(sleep_until g_e2_door_breached)
	
	; Look at them instead
	(cs_aim_object true (ai_get_object e2_cov_hunters0/hunter0))
	
	; Wait for it...
	(sleep_until
		g_e2_cov_hunters0_active
		10
		30_seconds
	)
)

(script command_script cs_e2_mars_inf0_watch
	(cs_go_to_nearest e2_mars_inf0_positions)
	(cs_crouch true)
	
	; Wait till we actually have some Hunters
	(sleep_until g_e2_door_breached)
	
	; Look at them instead
	(cs_aim_object true (ai_get_object e2_cov_hunters0/hunter0))
	
	; Wait for it...
	(sleep_until
		g_e2_cov_hunters0_active
		10
		30_seconds
	)
)

(script command_script cs_e2_mars_continue
	; Go to the nearest
	(cs_go_to_nearest e2_mars_wait)
	
	; Look at the player
	(cs_face_player true)
	
	; Wait until he's advanced or he's nearby
	(sleep_until
		(or
			(ai_trigger_test generic_player_within_4wu e2_mars)
			(ai_trigger_test e2_cov_hunters0_bypassed e2_mars)
			g_e3_started
		)
		15
	)
)


;- Order Scripts ---------------------------------------------------------------
;- Event Controls --------------------------------------------------------------

(script dormant e2_dialog
	(sleep 75)
;	(ai_play_line e2_mars_johnson 0920) ; "Nevermind"

	; Wait for the Hunters to spawn and appear
	(sleep_until g_e2_door_breached)
	(sleep 120)
	
	(sleep (ai_play_line_on_object none 0340)) ; "Cortana: Hunters"
	(cs_run_command_script e2_mars_johnson cs_e2_mars_johnson0_dialogue0)

	; If the Hunters are undamaged after thirty seconds...
	(sleep_until (<= (ai_strength e2_cov_hunters0) 0.8) 30 30_seconds)
	(if (not (<= (ai_strength e2_cov_hunters0) 0.8))
		(ai_play_line_on_object none 0350) ; "Cortana: Aim for the gaps in their armor"
	)
	
	; Wait until they're dead
	(sleep_until (<= (ai_living_count e2_cov_hunters0) 0))
	(sleep 60)

	; Cortana talks to second squad
	(sleep (ai_play_line_on_object none 0280)) ; "Cortana: Second squad, this is Cortana..."
	(sleep 25)
	(sleep (ai_play_line_on_object none 0290)) ; "Sarge: We're operational"
	(sleep 20)
	(ai_play_line_on_object none 0300) ; "Cortana: Find a hole"

	; For AO version
	;(sleep 60)
	;(dialog_0205_tgh) ; "Yes ma'am. Hey private, drop trou and bend over"
	;(print "music begin: bow chicka wow wow")
)


;- Squad Controls --------------------------------------------------------------

(script dormant e2_cov_inf0_main
	(ai_place e2_cov_inf0)
)

(script dormant e2_cov_hunters0_main
	; Wait until the player is looking at the door, or a timeout
	(sleep_until
		(objects_can_see_flag (players) e2_wall_tap 30)
		15
		one_minute
	)

	; Foresee the future
	(sound_impulse_predict "sound\materials\hard\metal_thin\metal_thin_large")
	(sound_impulse_predict "sound\visual_effects\explosion_medium_metal_bits")

	; Knock knock, destroy the wall
	(sleep 30)
	(device_set_position e2_hunter_door 0.5)
	(sound_impulse_start "sound\materials\hard\metal_thin\metal_thin_large" e2_hunter_door_sound_source 1.0)
	(object_damage_damage_section e2_hunter_door "body_hit0" 1.1)
	(object_create e2_hunter_smoke)
	(sleep 60)
	
	; Begin the dialog here
	(wake e2_dialog)
	(wake objective0_clear)

	; Place the hunters and run their introduction command scripts
	(ai_place e2_cov_hunters0)

	; Smash open the door
	(sleep 60)
	(device_set_position e2_hunter_door 1.0)
	(sound_impulse_start "sound\materials\hard\metal_thin\metal_thin_large" e2_hunter_door_sound_source 1.0)
	(object_damage_damage_section e2_hunter_door "body_hit1" 1.1)
	(sleep 160)
	(device_set_position_immediate e2_hunter_door 0.01)
	(sound_impulse_start "sound\visual_effects\explosion_medium_metal_bits" e2_hunter_door_sound_source 1.0)
	(sleep 1)
	(object_damage_damage_section e2_hunter_door "body_main" 1.1)
	(sleep 1)
	(device_set_position_immediate e2_hunter_door 1)
	(object_destroy e2_hunter_smoke)
	
	; Signal the breach
	(set g_e2_door_breached true)
	
	; Muzak
	(wake music_03a_01_stop)
	(wake music_03a_02_start_alt)
		
	; Sleep until they're dead, or the player has run through
	(sleep_until 
		(or
			(<= (ai_living_count e2_cov_hunters0) 0)
			g_e3_started
		)
	)
	
	; Set the next objective
	(wake objective1_set)
	
	; Try to sneak in a save point
	(game_save)
	
	; Muzak
	(wake music_03a_02_stop)
)

(script dormant e2_mars_inf0_main
	; Migrate squads into this one
	(ai_migrate e1_mars_inf0 e2_mars_inf0)
	(ai_migrate e1_mars_inf1 e2_mars_inf0)
	(ai_renew e2_mars_inf0)
	(ai_disposable e2_mars_inf0 false)	

	; Tell them to watch the door as it is banged on and broken open
	(cs_run_command_script e2_mars_inf0 cs_e2_mars_inf0_watch)
)

(script dormant e2_mars_johnson_main
	(ai_migrate e1_mars_johnson e2_mars_johnson)
	(ai_disposable e2_mars_johnson false)	
	(cs_run_command_script e2_mars_johnson cs_e2_mars_johnson0_watch)
	
	; Once the Hunters are dead, move on
	(sleep_until (> (ai_spawn_count e2_cov_hunters0) 0))
	(sleep_until (<= (ai_living_count e2_cov_hunters0) 0))
	(cs_run_command_script e2_mars cs_e2_mars_continue)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e2_main
	(sleep_until
		(and
			(volume_test_objects tv_e2_main_begin (players))
			(not (volume_test_objects_all tv_e2_main_begin_exclude (players)))
		)
		15
	)	
	(set g_e2_started true)
	(print "e2_main")
	(data_mine_set_mission_segment "e2_hunter_intro")
	(game_save)
	;(garbage_collect_now)
	
	; Wake control scripts
	(wake e2_cov_hunters0_main)
	(wake e2_mars_inf0_main)
	(wake e2_mars_johnson_main)
;	(wake e2_cov_inf0_main)
	
	; Shut down
	(sleep_until g_e3_started)
	(sleep_forever e2_mars_inf0_main)
	(sleep_forever e2_mars_johnson_main)
	(sleep_forever e2_cov_inf0_main)
	(sleep_forever e2_cov_hunters0_main)
	(sleep_forever e2_dialog)
	
	; Condemnification
	(ai_disposable e2_cov true)
)

(script static void test_hunter_intro
	(object_teleport (player0) e2_test)
	(ai_place e2_mars_inf0)
	(ai_place e2_mars_johnson)
	(if (not g_e2_started) (wake e2_main))

	; Get the other scripts running
	(if (not g_e3_started) (wake e3_main))
	(if (not g_e8_started) (wake e8_main))
	(if (not g_e12_started) (wake e12_main))
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
			(advance0) - Moving to the corner before going in
			(advance1) - Advancing into the atrium and first tier
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

(global boolean g_e1_cov_inf2_wave0 true)				; Used for dialog permutes
(global boolean g_e1_cov_phantom0_1_arrived false)		; Has the second Phantom arrived?
(global boolean g_e1_cov_phantom0_1_retreating false)	; Has the second Phantom started to back off?
(global boolean g_e1_cov_inf4_0_arrived false)			; Has that squad been dropped off by the Phantom?

(global boolean g_e1_mars_pelican0_appeared false) 		; The Pelican has appeared and opened fire
(global boolean g_e1_mars_pelican0_departing false) 	; The Pelican is leaving the area


;- Command Scripts -------------------------------------------------------------

(script command_script cs_e1_mars_pelican0_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_face true e1_mars_pelican/p0_facing)
	(cs_fly_to e1_mars_pelican/p0)
	
	; We've appeared
	(set g_e1_mars_pelican0_appeared true)
	
	; Continue
	(cs_face false e1_mars_pelican/p1_facing)
	(cs_fly_to e1_mars_pelican/p1)
	(sleep 75)
	
	; Dialog
	(print "pilot: looks too tight down there")
	(sleep (ai_play_line_on_object none 0900))
	(set g_e1_mars_pelican0_departing true)
	
	; Continue
	(cs_vehicle_speed 0.75)
	(cs_fly_to e1_mars_pelican/p2 0.5)
	(sleep 60)
	(cs_face false e1_mars_pelican/p1_facing)
	(cs_fly_by e1_mars_pelican/p3)
	(set g_e1_mars_pelican0_departing true)
	(cs_fly_by e1_mars_pelican/p4 1.0)
	(ai_erase ai_current_squad)
)

(script command_script cs_e1_mars_johnson_finale
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to e1_mars_johnson_finale/p0)
	(sleep_until (> (ai_spawn_count e2_cov_hunters0) 0))
	(sleep 90)
)

(script command_script cs_e1_mars_johnson_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_crouch true)
	(sleep 105)
	(cs_crouch false)
	(sleep (ai_play_line ai_current_actor 0850))
	
	; Sleep until the player is up on his feet
	(sleep 15)
	
	; Head out
	(sleep (ai_play_line ai_current_actor 0110))
;	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\marine\marine" "combat:rifle:advance" true)
;	(sleep (unit_get_custom_animation_time (ai_get_unit ai_current_actor)))
	(sleep 10)
	(cs_go_to e1_mars_entry/p2)
)

(script command_script cs_e1_mars_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_crouch true)
	
	; Sleep until the player is up on his feet
	(sleep 120)
	(cs_crouch false)
	(cs_go_to e1_mars_entry/p4)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(sleep 300)
)

(script command_script cs_e1_mars_entry0
	(cs_enable_pathfinding_failsafe true)
	(cs_crouch true)
	
	; Sleep until the player is up on his feet
	(sleep 120)
	(cs_crouch false)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(sleep 300)
)

(script command_script cs_e1_cov_phantom0_0_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e1_cov_phantom0_0_entry/p0)
	(cs_fly_to e1_cov_phantom0_0_entry/p1)
	(ai_erase ai_current_squad)
)

(script command_script cs_e1_cov_phantom0_1_entry
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_by e1_cov_phantom0_1_entry/p0)
	(cs_face true e1_cov_phantom0_1_entry/p1_facing)
	(set g_e1_cov_phantom0_1_arrived true)	; Signal that the Phantom has arrived
	(cs_fly_to e1_cov_phantom0_1_entry/p1 1.0)
	(sleep 15)
	(cs_vehicle_speed 0.66)
	(cs_fly_to e1_cov_phantom0_1_entry/p2)
	(cs_fly_to_and_face e1_cov_phantom0_1_entry/p3 e1_cov_phantom0_1_entry/p3_facing 0.5)
	(cs_face true e1_cov_phantom0_1_entry/p3_facing)
	
	; Drop the passengers off
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) true)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_a")
	(sleep 60)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_b")
	(sleep 60)
	(set g_e1_cov_inf4_0_arrived true)
	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) false)
	
	; Move into combat position
	(cs_fly_to e1_cov_phantom0_1_entry/p4 0.5)
	(sleep 150)
	
	; And head out
	(cs_vehicle_speed 0.4)
	(cs_face false e1_cov_phantom0_1_entry/p3_facing)
	(cs_fly_by e1_cov_phantom0_1_entry/p5 1.0)
	(set g_e1_cov_phantom0_1_retreating true)
	(cs_vehicle_speed 0.75)
	(cs_fly_by e1_cov_phantom0_1_entry/p6)
	(cs_vehicle_speed 1.0)
	(cs_fly_by e1_cov_phantom0_1_entry/p7)
	(ai_erase ai_current_squad)
)

(script command_script cs_e1_cov_inf0_grunt0
	; Send him cruising in to investigate the crash
	(cs_enable_dialogue true)
	(cs_movement_mode ai_movement_combat)
	(cs_start_to e1_patrol/grunt0)
	
	; Sleep until he's seen an enemy
	(sleep_until 
		(or
			(not (cs_moving))
			(>= (ai_combat_status ai_current_actor) ai_combat_status_visible)
		)
		10
	)
	
	; This is pretty confusing for the Grunt
	(cs_approach (ai_get_object ai_current_actor) 0.1 0.1 0.1)
	
	; Wait for half a second, or until combat status is danger
	(sleep_until
		(>= (ai_combat_status ai_current_actor) ai_combat_status_dangerous)
		3
		25
	)
	
	; Run for it
	(cs_movement_mode ai_movement_flee)
	(cs_go_to e1_patrol/grunt1)
)

(script command_script cs_e1_cov_inf0_0_patrol0
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_looking true)
	(sleep_until
		(begin
			(begin_random
				(cs_go_to e1_patrol/p0)
				(begin (cs_go_to e1_patrol/p1) (sleep (random_range 30 60)))
				(begin (cs_go_to e1_patrol/p2) (sleep (random_range 30 60)))
			)			
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e1_cov_inf0_0_patrol1
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_looking true)
	(sleep_until
		(begin
			(cs_go_to e1_patrol/p3) (sleep (random_range 30 60))
			(cs_go_to e1_patrol/p4) (sleep (random_range 30 60))
			
			; Loop forever
			false
		)
	)
)

(script command_script cs_e1_cov_inf0_3_patrol0
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_looking true)
	(sleep_until
		(begin
			(begin_random
				(begin (cs_go_to e1_patrol/p7) (sleep (random_range 30 60)))
				(begin (cs_go_to e1_patrol/p8) (sleep (random_range 30 60)))
				(begin (cs_go_to e1_patrol/p9) (sleep (random_range 30 60)))
			)			
			
			; Loop forever
			false
		)
	)
)


;- Event Scripts ---------------------------------------------------------------
;*
(script continuous e1_crashed_pelican
	(sleep_until (not (volume_test_objects tv_e1_crashed_pelican (players))))
	(object_destroy crashed_pelican)
	(sleep_until (volume_test_objects tv_e1_crashed_pelican (players)))
	(object_create crashed_pelican)	
)
*;

;- Order Scripts ---------------------------------------------------------------

(script static boolean johnson_has_sniping_weapon
	(or
		(unit_has_weapon (ai_get_unit e1_mars_johnson/johnson0) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon")
		(unit_has_weapon (ai_get_unit e1_mars_johnson/johnson0) "objects\weapons\rifle\battle_rifle\battle_rifle.weapon")
	)
)

(script static boolean e1_cov_inf0_grunts_alerted
	(or
		(>= (ai_combat_status e1_cov_inf0_0/grunt1) ai_combat_status_alert)
		(>= (ai_combat_status e1_cov_inf0_0/grunt2) ai_combat_status_alert)
		(>= (ai_combat_status e1_cov_inf0_1) ai_combat_status_alert)
	)
)


;- e1_cov_inf2 Respawner Support -----------------------------------------------

(script static boolean e1_cov_inf2_under_limit
	(< g_e1_cov_inf2_spawned g_e1_cov_inf2_limit)
)

(script static boolean e1_cov_inf2_spawn_ready
	(and
		(<= (ai_living_count e1_cov_inf2) 1)
		(<= (ai_fighting_count e1_cov_inf2) 0)
	)
)

(script static void e1_cov_inf2_sleep_until_respawn
	; Sleep until they're ready to respawn, or two minutes, timeout
	(sleep_until (e1_cov_inf2_spawn_ready) 31 two_minutes)
	
	; Pause unless the player is on the rooftops
	(sleep_until (volume_test_objects tv_e1_on_building (players)) 30 150)
)

;*
(script static void e1_cov_inf2_7_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_4_unsafe (players)))
		(begin
			; Fire off a checkpoint
			(game_save)
			(sleep 5)
		
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_7 (min 5 (- 10 (ai_living_count e1_cov_inf2))))
			(ai_set_orders e1_cov_inf2_7 e1_cov_inf2_7_init)
			(sleep 2)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_7)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Dialog
			(sleep 60)
			(ai_play_line e1_mars_johnson/johnson0 0270) ; "Buggers, over the rooftops"

			; Wait for the next wave
			(e1_cov_inf2_sleep_until_respawn)
		)
	)
)
*;

(script static void e1_cov_inf2_6_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_1_unsafe (players)))
		(begin
			; Fire off a checkpoint
			(game_save)
			(sleep 5)
		
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_6 (min 5 (- 10 (ai_living_count e1_cov_inf2))))
			(ai_set_orders e1_cov_inf2_6 e1_cov_inf2_engage0)
			(sleep 2)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_5)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
;*			; Dialog
			(sleep 150)
			(if g_e1_cov_inf2_wave0
				(ai_play_line e1_mars_johnson/johnson0 0250) ; "Across the street, on buildings"
				(ai_play_line e1_mars_johnson/johnson0 0260) ; "Across the street, on buildings"
			)
*;
			; Wait for the next wave
			(e1_cov_inf2_sleep_until_respawn)
		)
	)
)

(script static void e1_cov_inf2_5_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_5_unsafe (players)))
		(begin
			; Fire off a checkpoint
			(game_save)
			(sleep 5)
		
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_5 (min 5 (- 10 (ai_living_count e1_cov_inf2))))
			(ai_set_orders e1_cov_inf2_5 e1_cov_inf2_5_init)
			(sleep 2)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_5)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Dialog
			(sleep 120)
			(if g_e1_cov_inf2_wave0
				(ai_play_line e1_mars_johnson/johnson0 0210) ; "We got Jackals, courtyard"
;				(ai_play_line e1_mars_johnson/johnson0 0220) ; "Jackals, courtyard"
			)

			; Wait for the next wave
			(e1_cov_inf2_sleep_until_respawn)
		)
	)
)

;*
(script static void e1_cov_inf2_4_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_4_unsafe (players)))
		(begin
			; Fire off a checkpoint
			(game_save)
			(sleep 5)
		
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_4 (min 5 (- 10 (ai_living_count e1_cov_inf2))))
			(ai_set_orders e1_cov_inf2_4 e1_cov_inf2_4_init)
			(sleep 2)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_4)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Dialog
			(sleep 60)
			(if g_e1_cov_inf2_wave0
				(ai_play_line e1_mars_johnson/johnson0 0190) ; "Right side, in the street"
;				(ai_play_line e1_mars_johnson/johnson0 0200) ; "Right side, in the street"
			)

			; Wait for the next wave
			(e1_cov_inf2_sleep_until_respawn)
		)
	)
)
*;

(script static void e1_cov_inf2_3_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_3_unsafe (players)))
		(begin
			; Fire off a checkpoint
			(game_save)
			(sleep 5)
		
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_3 (min 5 (- 10 (ai_living_count e1_cov_inf2))))
			(ai_set_orders e1_cov_inf2_3 e1_cov_inf2_engage0)
			(sleep 2)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_3)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Dialog
			(sleep 120)
			(if g_e1_cov_inf2_wave0
				(ai_play_line e1_mars_johnson/johnson0 0170) ; "Left side, in the street"
;				(ai_play_line e1_mars_johnson/johnson0 0180) ; "Left side, in the street"
			)

			; Wait for the next wave
			(e1_cov_inf2_sleep_until_respawn)
		)
	)
)
;*
(script static void e1_cov_inf2_2_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_2_unsafe (players)))
		(begin
			; Fire off a checkpoint
			(game_save)
			(sleep 5)
		
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_2 (min 5 (- 10 (ai_living_count e1_cov_inf2))))
			(ai_set_orders e1_cov_inf2_2 e1_cov_inf2_2_init)
			(sleep 2)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_2)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Dialog
			(sleep 60)
			(ai_play_line e1_mars_johnson/johnson0 0140) ; "Heads up, on the buildings"

			; Wait for the next wave
			(e1_cov_inf2_sleep_until_respawn)
		)
	)
) *;

(script static void e1_cov_inf2_1_spawn
	; If player isn't in the unsafe volume...
	(if (not (volume_test_objects tv_e1_cov_inf2_1_unsafe (players)))
		(begin
			; Fire off a checkpoint
			(game_save)
			(sleep 5)
		
			; Place the squad and increment the counter
			(ai_place e1_cov_inf2_1 (min 5 (- 10 (ai_living_count e1_cov_inf2))))
			(ai_set_orders e1_cov_inf2_1 e1_cov_inf2_engage0)
			(sleep 2)
			(ai_magically_see e1_mars_johnson e1_cov_inf2_1)
			(set g_e1_cov_inf2_spawned (+ g_e1_cov_inf2_spawned 1))
			
			; Dialog
			(sleep 90)
			(if (not g_e1_cov_inf2_wave0)
				(ai_play_line e1_mars_johnson/johnson0 0150) ; "Across street, low"
;				(ai_play_line e1_mars_johnson/johnson0 0160) ; "Across street, low"
			)

			; Wait for the next wave
			(e1_cov_inf2_sleep_until_respawn)
		)
	)
)


;- Squad Controls --------------------------------------------------------------

(script dormant e1_mars_pelican0_main
	(sleep_until
		(and
			(> (ai_spawn_count e1_cov_inf4_1) 0)
			(<= (ai_living_count e1_cov_inf4) 3)
		)
	)
	
	; Spawn and send in the Pelican
	(ai_place e1_mars_pelican0)
	(ai_vehicle_enter_immediate e1_mars_pelican0/gunner0 (ai_vehicle_get e1_mars_pelican0/pelican0) "pelican_g")
	(ai_vehicle_enter_immediate e1_mars_pelican0/gunner1 (ai_vehicle_get e1_mars_pelican0/pelican0) "pelican_g_rear")
	
	; Apply the command scripts
	(cs_run_command_script e1_mars_pelican0/pelican0 cs_e1_mars_pelican0_entry)
	
	; Wait for the Pelican to be gone
	(sleep_until 
		g_e1_mars_pelican0_departing
		30
	)
	
	; Wake the hunter encounter
	(wake e2_main)
)

(script dormant e1_cov_phantom0_main
	(sleep_until 
		(volume_test_objects tv_e1_main_area_entrance (players))
		5
	) 
	(sleep_until 
		(e1_cov_inf0_grunts_alerted)
		30
		30_seconds
	) 

	; Phantom overflight
	(ai_place e1_cov_phantom0_0)
	(cs_run_command_script e1_cov_phantom0_0/phantom0 cs_e1_cov_phantom0_0_entry)
	
	; Pause the script here. It will be restarted by e1_cov_inf2_main
	(sleep_forever)
	
	; Once it is reawakened, send in the Phantom
	(ai_place e1_cov_phantom0_1)
	
	; Muzak
	(wake music_03a_01_start)
)

(global short g_e1_cov_snipers0_limit 2)
(script dormant e1_cov_snipers0_main
	(if (difficulty_legendary) (set g_e1_cov_snipers0_limit 5))

	; Spawn some snipers
	(begin_random
		; Sniper 0
		(if (< (ai_spawn_count e1_cov_snipers0) g_e1_cov_snipers0_limit)
			(if (not (volume_test_objects tv_e1_cov_sniper0_0_unsafe (players))) 
				(begin
					(ai_place e1_cov_snipers0/sniper0)
					(game_save)
					(sleep_until (<= (ai_living_count e1_cov_snipers0) 0))
					(sleep (random_range one_minute two_minutes))
				)
			)
		)
		
		; Sniper 1
		(if (< (ai_spawn_count e1_cov_snipers0) g_e1_cov_snipers0_limit)
			(if (not (volume_test_objects tv_e1_cov_sniper0_1_unsafe (players))) 
				(begin
					(ai_place e1_cov_snipers0/sniper1)
					(game_save)
					(sleep_until (<= (ai_living_count e1_cov_snipers0) 0))
					(sleep (random_range one_minute two_minutes))
				)
			)
		)
		
		; Sniper 2
		(if (< (ai_spawn_count e1_cov_snipers0) g_e1_cov_snipers0_limit)
			(if (not (volume_test_objects tv_e1_cov_sniper0_2_unsafe (players))) 
				(begin
					(ai_place e1_cov_snipers0/sniper2)
					(game_save)
					(sleep_until (<= (ai_living_count e1_cov_snipers0) 0))
					(sleep (random_range one_minute two_minutes))
				)
			)
		)
		
		; Sniper 3
		(if (< (ai_spawn_count e1_cov_snipers0) g_e1_cov_snipers0_limit)
			(if (not (volume_test_objects tv_e1_cov_sniper0_3_unsafe (players))) 
				(begin
					(ai_place e1_cov_snipers0/sniper3)
					(game_save)
					(sleep_until (<= (ai_living_count e1_cov_snipers0) 0))
					(sleep (random_range one_minute two_minutes))
				)
			)
		)
		
		; Sniper 4
		(if (< (ai_spawn_count e1_cov_snipers0) g_e1_cov_snipers0_limit)
			(if (not (volume_test_objects tv_e1_cov_sniper0_3_unsafe (players))) 
				(begin
					(ai_place e1_cov_snipers0/sniper4)
					(game_save)
					(sleep_until (<= (ai_living_count e1_cov_snipers0) 0))
					(sleep (random_range one_minute two_minutes))
				)
			)
		)
	)
)

(script dormant e1_cov_inf4_main
	(sleep_until (> (ai_spawn_count e1_cov_phantom0_1) 0) 10)
	
	; Load up the first wave for the Phantom to drop off
	(if (difficulty_heroic) (ai_place_in_vehicle e1_cov_inf4_0/elite1 e1_cov_phantom0_1))
	(if (difficulty_legendary) (ai_place_in_vehicle e1_cov_inf4_2 e1_cov_phantom0_1))
	(ai_place_in_vehicle e1_cov_inf4_0 e1_cov_phantom0_1)
	
	; Wait until that group is dead, then spawn the next wave
	(sleep_until g_e1_cov_inf4_0_arrived)
	(sleep 300)
	(sleep_until 
		(and
			(<= (ai_living_count e1_cov_inf4) 2)
			(not (volume_test_objects tv_e1_cov_inf4_1_unsafe (players)))
		)
		30
		two_minutes
	)
	(ai_place e1_cov_inf4_1 (pin (- 6 (ai_living_count e1_cov_inf4)) 2 5))
)

(script dormant e1_cov_inf3_main
	; Send in the teasers
	(ai_place e1_cov_inf3_2)

	; Wait for the player to look
	(sleep_until
		(and
			(<= (ai_strength e1_cov_inf3_2) 0.75)
			(objects_can_see_flag (players) e1_cov_inf3_entrance 25)
		)
		5
		30_seconds
	)
	
	; Send them in
	(ai_place e1_cov_inf3_0 (- 5 (ai_living_count e1_cov_inf3)))
	(sleep 30)
	(ai_play_line e1_mars_johnson/johnson0 0270)
	
	; Respawn a few
	(sleep_until
		(begin
			(if (< (ai_living_count e1_cov_inf3) 3)
				(ai_place e1_cov_inf3_1 2)
			)
		
			; Until enough have spawned
			(>= (ai_spawn_count e1_cov_inf3) 10)
		)
	)
	
	; Survivors charge
	(ai_set_orders e1_cov_inf3 e1_cov_inf3_advance0)
)

(script dormant e1_cov_inf2_main
	(sleep_until 
		; Everyone dead
		(and
			(<= (ai_living_count e1_cov_inf1) 1)
			(> (ai_spawn_count e1_cov_inf1) 0)
		)
		30
		one_minute
	)
		
	; Wait till we're ready to spawn waves
	(e1_cov_inf2_sleep_until_respawn)
	
	; Set the wave count
	(set g_e1_cov_inf2_spawned 0)
	(set g_e1_cov_inf2_limit 2)
	(if (difficulty_heroic) (set g_e1_cov_inf2_limit 2))
	(if (difficulty_legendary) (set g_e1_cov_inf2_limit 3))
	
	; Start up the snipers
	(if (not (difficulty_normal)) (wake e1_cov_snipers0_main))
	
	; Ground waves
	(begin_random 
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_1_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_3_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_6_spawn))
	)
	
	; Wait till we're ready to spawn another wave
	(e1_cov_inf2_sleep_until_respawn)
	
	; Sneak in a save
	(game_save)
	(sleep 60)
	
	; Send in the courtyard wave
	(e1_cov_inf2_5_spawn)
	
	; Wait till we're ready to spawn waves
	(sleep_until 
		(and
			(<= (ai_living_count e1_cov_inf2) 1)
			(<= (ai_fighting_count e1_cov_inf2) 0)
		)
	)
	
	; Bugger interlude
	(garbage_collect_now)
	(game_save)
	(sleep 15)
	(wake e1_cov_inf3_main)
	(sleep 30)
	
	; Wait until inf3 interlude is finished
	(sleep_until 
		(and
			(> (ai_spawn_count e1_cov_inf3_1) 0)
			(<= (ai_living_count e1_cov_inf3) 2)
			(<= (ai_fighting_count e1_cov_inf3) 0)
		)
		30
		two_minutes
	)
	(ai_disposable e1_cov_inf3 true)

	; Save first
	(game_save)
	(sleep 30)
	(garbage_collect_now)
		
	; Move onto the second dialog set
	(set g_e1_cov_inf2_wave0 false)
	
	; Set the wave count
	(set g_e1_cov_inf2_spawned 0)
	(set g_e1_cov_inf2_limit 2)
	(if (difficulty_heroic) (set g_e1_cov_inf2_limit 3))
	(if (difficulty_legendary) (set g_e1_cov_inf2_limit 3))
	
	; Spawn the waves
	(begin_random 
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_1_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_3_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_5_spawn))
		(if (e1_cov_inf2_under_limit) (e1_cov_inf2_6_spawn))
	)
	
	; Wait till we're ready to spawn another wave
	(e1_cov_inf2_sleep_until_respawn)
	
	; Save first
	(game_save)
	(sleep 30)
		
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
	(game_save)
	(sleep 120)
	
	; Wait until the player isn't in a spot to see them spawn
	(sleep_until (not (volume_test_objects tv_e1_cov_inf1_unsafe (players))))
	
	; Place the infantry over the rooftops
	(ai_place e1_cov_inf1)
	(ai_magically_see e1_cov_inf1 e1_mars)
)

(script dormant e1_cov_inf0_main
	(sleep_until 
		(or
			(volume_test_objects tv_e1_crash_area_exit (players))
			(volume_test_objects tv_e1_main_area_entrance (players))
			(volume_test_objects tv_e1_prediction (players))
		)
		5
	) 
	
	; Predict that first grunt
	(object_type_predict "objects\characters\grunt\grunt")
	(camera_predict_resources_at_point e1_prediction)	
	
	; We now resume your regularly scheduled broadcast
	(sleep_until 
		(or
			(volume_test_objects tv_e1_crash_area_exit (players))
			(volume_test_objects tv_e1_main_area_entrance (players))
		)
		5
	) 
	(ai_place e1_cov_inf0_0)
	(ai_place e1_cov_inf0_3)
	
	; Wait until the existing unit count is depleted or the player is charging
	(sleep_until 
		(or
			(<= (ai_living_count e1_cov_inf0) 3)
			(volume_test_objects tv_e1_cov_inf0_1_begin (players))
		)
		15
	)
	(ai_place e1_cov_inf0_1/grunt0)
	
	; Wait until the existing unit count is depleted or the player is charging
	(sleep_until 
		(or
			(<= (ai_living_count e1_cov_inf0) 3)
			(volume_test_objects tv_e1_cov_inf0_1_begin (players))
		)
		15
	)
	(ai_place e1_cov_inf0_1/grunt1)
	
	; Wait until the existing unit count is depleted or the player is charging
	(sleep_until 
		(or
			(<= (ai_living_count e1_cov_inf0_3) 0)
			(volume_test_objects tv_e1_cov_inf0_2_begin (players))
		)
		15
	)
	
	; Place the next group
	(ai_place e1_cov_inf0_2)
	(sleep 5)
	(ai_magically_see e1_cov_inf0_2 e1_mars_inf0)

	; Wake the next squads
	(wake e1_cov_inf1_main)
	(wake e1_cov_inf2_main)
)

(script dormant e1_mars_inf1_main
	(ai_place e1_mars_inf1)
	
	; Initial command script
;	(cs_run_command_script e1_mars_inf1/marine0 cs_e1_mars_inf1_0_entry)
;	(cs_run_command_script e1_mars_inf1/marine1 cs_e1_mars_inf1_1_entry)
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
;	(ai_set_orders e1_mars_inf0 e1_mars_inf0_guard0)
)

(script dormant e1_mars_johnson_main
	(ai_place e1_mars_johnson)
	(object_cannot_die (ai_get_object e1_mars_johnson/johnson0) true)
	
	; Initial command script
	(cs_run_command_script e1_mars_johnson cs_e1_mars_johnson_entry)

	; Wait until the player has pacified the building
	(sleep_until
		(and
			(> (ai_spawn_count e1_cov_inf0_2) 0)
			(<= (ai_living_count e1_cov_inf0_2) 0)
		)
	)
	
	; Wait until Johnson is up stairs, or a timeout
	(sleep_until
		(volume_test_objects tv_e1_on_building (ai_actors e1_mars_johnson))
		30
		450
	)
	
	; Dialogue
	(sleep (ai_play_line e1_mars_johnson/johnson0 0120)) (print "They know we're here")

	; Sneak in a save
	(game_save)
	(wake objective0_set)
	
	; Wait for the first wave
	(sleep_until (> (ai_spawn_count e1_cov_inf1) 0))	
	(sleep 60)
	(ai_play_line e1_mars_johnson/johnson0 0130) ; "Yep, here they come!"
	
	; Sleep until the first Phantom appears
	(sleep_until (> (ai_spawn_count e1_cov_phantom0_0) 0))	

	; Sleep until the second Phantom returns
	(sleep_until g_e1_cov_phantom0_1_arrived)	

	; Dialog
	(sleep 60)
	(sleep (ai_play_line e1_mars_johnson/johnson0 0890)) ; "Our Phantom is back!"
;	(sleep 30)
;	(sleep (ai_play_line_on_object none 0310)) ; "Hang tight"
;	(sleep 10)
;	(sleep (ai_play_line e1_mars_johnson/johnson0 0320)) ; "You heard her! Grab dirt!"

	; Wait for the second Phantom to retreat
	(sleep_until g_e1_mars_pelican0_appeared 15)

	; Head out to the Finale
	(cs_run_command_script e1_mars_johnson cs_e1_mars_johnson_finale)
	
	; Wait for the Pelican to depart, or a timeout
	(sleep_until g_e1_mars_pelican0_departing 3 one_minute)
	(sleep 20)
	
	; Dialog
	(sleep (ai_play_line e1_mars_johnson/johnson0 0910)) ; "Copy that. Someone satchel that gate"
	
	; Muzak
	(wake music_03a_02_start)
)


;- Init and Cleanup ------------------------------------------------------------

(script dormant e1_key
	(object_create e1_ghost_key)
	(sleep_until 
		(or
			(and
				(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
				(volume_test_object tv_e1_ghost_key (player0))
			)
			(and
				(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
				(volume_test_object tv_e1_ghost_key (player1))
			)
		)
	)
	(ice_cream_flavor_stock 6) ; Blind
)

(script dormant e1_main
	(set g_e1_started true)
	(print "e1_main")
	(data_mine_set_mission_segment "e1_rooftop_defense")
	
	; Wake subsequent scripts
;	e2_main awakened in e1_mars_pelican0_main
	(wake e3_main)
	(wake e8_main)
	(wake e12_main)

	; Wake control scripts
	(wake e1_mars_johnson_main)
	(wake e1_mars_inf0_main)
	(wake e1_mars_inf1_main)
	(wake e1_cov_inf0_main)
	(wake e1_cov_phantom0_main)
	(wake e1_mars_pelican0_main)
	(wake e1_key)
	
	; Early shut down
	(sleep_until g_e2_started)
	(sleep_forever e1_cov_snipers0_main)
	
	; Shut down
	(sleep_until g_e3_started)
	(sleep_forever e1_mars_johnson_main)
	(sleep_forever e1_mars_inf0_main)
	(sleep_forever e1_mars_inf1_main)
	(sleep_forever e1_cov_inf0_main)
	(sleep_forever e1_cov_inf1_main)
	(sleep_forever e1_cov_inf2_main)
	(sleep_forever e1_cov_inf3_main)
	(sleep_forever e1_cov_inf4_main)
	(sleep_forever e1_cov_phantom0_main)
	
	; Condemn the AI
	(ai_disposable e1_cov true)	
	(ai_disposable e1_cov_phantom0 false)	
	
	; Clean up
;	(sleep_until (or g_e4_started g_e6_started))
;	(ai_erase e1_mars)
;	(ai_erase e1_cov)
)


;= MISSION MAIN ==========================================================================

(script dormant mission_start
	; This is pretty gross
	(wake flashlight_control)
	
	; Run the cinematics
	(cinematic_snap_to_black)
	(cinematic_intro)

	; Wake the first encounter
	(wake e1_main)

	; Bring the camera in
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(chief_recovery_sequence)
	
	; Initial chapter title
	(wake chapter_title0)
	
	; Initial checkpoint
	(sleep 150)
	(game_save)

	; Wait for the mission to end
	(sleep_until (volume_test_objects tv_mission_end (players)) 8)
	(set g_mission_over true)

	; For playtests
	(playtest_mission)
	(sleep 15)
	
	; Sound fade for Marty
	(sound_class_set_gain "" 0 15)
	
	; End cinematic goes here
	(cinematic_fade_to_white)
	(sleep 15)
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
	(if (> (player_count) 0) (start))
)

