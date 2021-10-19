;Alpha Gas Giant!
;-------------------------------------------------------------------------------


;-------------------------------------------------------------------------------
;Global Scripts

;Before or after the cables are cut
(global boolean plummeting FALSE)

;Temp delay for all hack sentinel emitters
(global short sen_emitter_delay 120)

;Used to abort an AI out of a command script manually
(script command_script abort
	(cs_pause .1)
)

;Used to make an AI stand around and do nothing until alerted
(script command_script long_pause
	(cs_abort_on_alert TRUE)
	(sleep_forever)
)

;Called at the start of every encounter to make sure everything is kosher
(script static void initialize
	(garbage_collect_now)
	(ai_allegiance_remove sentinel covenant)
	(ai_allegiance_remove covenant sentinel)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
	(ai_allegiance_remove player sentinel)
	(ai_allegiance_remove player heretic)
	(game_save)
)

;-------------------------------------------------------------------------------
;Music

;Intro music
(script dormant music_intro
;	(sound_looping_start "sound\temp\music\level_music\..." none 1)
	(sleep 9000)
;	(sound_looping_stop "sound\temp\music\level_music\...")
)


;-------------------------------------------------------------------------------
;Kill Volumes

;Checks if player 1 is in a pit and kills him
(script continuous all_pit_killer_player0
	(if (OR (= (volume_test_objects vol_recycling_pit_kill (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_recycling_left_kill (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_recycling_right_kill (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_hangar_pit_kill_01 (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_hangar_pit_kill_02 (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_hangar_pit_kill_03 (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_hangar_pit_kill_04 (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_silo_pit_kill (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_underhangar_pit_kill_01 (list_get (players) 0)) TRUE)
		(OR (= (volume_test_objects vol_underhangar_pit_kill_02 (list_get (players) 0)) TRUE) 
		(OR (= (volume_test_objects vol_bottling_kill_pit_01 (list_get (players) 0)) TRUE) 
			(= (volume_test_objects vol_bottling_kill_pit_02 (list_get (players) 0)) TRUE))))))))))))
		(unit_kill (unit (list_get (players) 0)))
	)
)

;Checks if player 2 is in a pit and kills him
(script continuous all_pit_killer_player1
	(if (OR (= (volume_test_objects vol_recycling_pit_kill (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_recycling_left_kill (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_recycling_right_kill (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_hangar_pit_kill_01 (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_hangar_pit_kill_02 (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_hangar_pit_kill_03 (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_hangar_pit_kill_04 (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_silo_pit_kill (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_underhangar_pit_kill_01 (list_get (players) 1)) TRUE)
		(OR (= (volume_test_objects vol_underhangar_pit_kill_02 (list_get (players) 1)) TRUE) 
		(OR (= (volume_test_objects vol_bottling_kill_pit_01 (list_get (players) 1)) TRUE) 
			(= (volume_test_objects vol_bottling_kill_pit_02 (list_get (players) 1)) TRUE))))))))))))
		(unit_kill (unit (list_get (players) 0)))
	)
)

;Turns kill zones in cable room on or off, so you don't clip volumes in banshee
(global boolean in_cable_room FALSE)

;Checks if player 1 falls in cable room, then kills him
(script continuous cableroom_pit_killer_player0
	(sleep_until (= in_cable_room TRUE))
	(if (OR (= (volume_test_objects vol_cableroom_pit_kill_01 (list_get (players) 0)) TRUE) 
		(OR (= (volume_test_objects vol_cableroom_pit_kill_02 (list_get (players) 0)) TRUE) 
			(= (volume_test_objects vol_cableroom_pit_kill_03 (list_get (players) 0)) TRUE)))		
		(unit_kill (unit (list_get (players) 0)))
	)
)

;Checks if player 2 falls in cable room, then kills him
(script continuous cableroom_pit_killer_player1
	(sleep_until (= in_cable_room TRUE))
	(if (OR (= (volume_test_objects vol_cableroom_pit_kill_01 (list_get (players) 1)) TRUE) 
		(OR (= (volume_test_objects vol_cableroom_pit_kill_02 (list_get (players) 1)) TRUE) 
			(= (volume_test_objects vol_cableroom_pit_kill_03 (list_get (players) 1)) TRUE)))		
		(unit_kill (unit (list_get (players) 1)))
	)
)


;-------------------------------------------------------------------------------
;Rooftop

;Used to determine when scripted guy has hacked into the door and unlocked it 
(global boolean open_rec_center FALSE)

;Sends elite #1 to door in cool fashion
(script command_script SWAT_elite_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to landing_zone/flank01)
;	(cs_face TRUE landing_zone/entry)
	(cs_aim TRUE landing_zone/entry)
;	(sleep_until (= (volume_test_objects vol_entering_facility (players)) TRUE))
	(sleep_forever)
)

;Sends elite #2 to door in cool fashion
(script command_script SWAT_elite_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to landing_zone/flank02)
;	(cs_face TRUE landing_zone/entry)
	(cs_aim TRUE landing_zone/entry)
;	(sleep_until (= (volume_test_objects vol_entering_facility (players)) TRUE))
	(sleep_forever)
)

;Tells elite #3 to hack the door when the player arrives
(script command_script SWAT_elites_03
;	(cs_face TRUE landing_zone/entry)
;	(cs_face TRUE landing_zone/control)
	(sleep_until 
		(begin
			(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
			(= (volume_test_objects vol_entry_area (players)) TRUE)
		)
	)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
	(set open_rec_center TRUE) 
;	(cs_face FALSE landing_zone/entry)
;	(sleep 180)
;	(cs_go_to landing_zone/flank03)
;	(cs_face TRUE landing_zone/entry_inner)
;	(cs_aim TRUE landing_zone/entry_inner)
	(sleep_until (= (volume_test_objects vol_entering_facility (players)) TRUE))
;	(cs_face FALSE landing_zone/control)
	(ai_set_orders arm01_allies allies_rec_hide_01)
)

;Tells elite #4 to order the door hack
(script command_script SWAT_elites_04
;	(cs_face TRUE landing_zone/entry)
	(cs_aim TRUE landing_zone/entry)
	(sleep_until (= (volume_test_objects vol_entry_area (players)) TRUE))
	
	(print "SPEC-OPS ELITE: 'Prepare yourselves, men.'")
;	(cs_custom_animation objects\characters\elite\elite "combat:rifle:warn" 1 TRUE)
;	(sleep 60)
;	(print "SPEC-OPS ELITE: 'Quickly now.'")
	
	(sleep_until (OR (= open_rec_center TRUE) (= (object_get_health (list_get (ai_actors hacker) 0)) -1)))
	(print "SPEC-OPS ELITE: 'After you, Dervish.'")
;	(cs_face FALSE landing_zone/entry)
;	(cs_aim FALSE landing_zone/entry)
;	(sleep 180)
;	(cs_go_to landing_zone/flank04)
;	(cs_face TRUE landing_zone/entry_inner)
;	(cs_aim TRUE landing_zone/entry_inner)
	(sleep_until (= (volume_test_objects vol_entering_facility (players)) TRUE))
	(cs_aim FALSE landing_zone/entry)
	(ai_set_orders arm01_allies allies_rec_hide_01)
)

;Positions grunts outside entrance
(script command_script SWAT_grunt_01
;	(cs_face TRUE landing_zone/entry)
	(cs_aim TRUE landing_zone/entry)
	(sleep_until (= (volume_test_objects vol_entering_facility (players)) TRUE))
	(cs_aim FALSE landing_zone/entry)
	(ai_set_orders arm01_allies allies_rec_hide_01)
)
(script command_script SWAT_grunt_02
;	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (= (volume_test_objects vol_entry_area (players)) TRUE))
;	(sleep 60)
;	(cs_go_to landing_zone/grunt01)
;	(print "GRUNT: 'I'm throwing a grenade!'")
;	(cs_grenade landing_zone/frag 0)

;	(custom_animation (unit (ai_get_object allies_grunts_01/grunt02)) objects\characters\grunt\grunt "combat:pistol:throw_grenade" TRUE)
;	(sleep 60)
;	(bang)
	
;	(cs_face TRUE landing_zone/entry)
	(cs_aim TRUE landing_zone/entry)
	(sleep_until (= (volume_test_objects vol_entering_facility (players)) TRUE))
	(cs_aim FALSE landing_zone/entry)
	(ai_set_orders arm01_allies allies_rec_hide_01)
)
	
;Phantom flies off behind you
(script dormant phantom_dust_off
	(print "SPEC-OPS COMMANDER: 'Strike quiet and swift, Dervish...'")
	(sleep 90)
	(print "'...and we will decimate their forces.'")
;	(unit_custom_animation_at_frame 
;		(unit (ai_vehicle_get_from_starting_location intro_phantom/driver)) 
;			objects\vehicles\phantom\animations\04_intro\04_intro 
;				"phantom01_06b" TRUE 100)
	(sleep_until (= (unit_is_playing_custom_animation (unit (ai_vehicle_get_from_starting_location intro_phantom/driver))) FALSE))
	(ai_erase spec_ops_commander)
	(ai_erase intro_phantom)
)

;Overall script for deployment
(script dormant SWAT_deploy
;	(ai_place ally_turrets)
;	(sleep_until (= (volume_test_objects vol_entry_area (players)) TRUE))
	(wake phantom_dust_off)
	(sleep_until (OR (= open_rec_center TRUE) (= (object_get_health (list_get (ai_actors hacker) 0)) -1)))
	(device_operates_automatically_set rec_center_entry_ext TRUE) 
;	(device_set_power rec_center_entry_int 0)
;	(device_set_position_immediate rec_center_entry_int 1)
;	(device_set_power entry_sm_left 0)
;	(device_set_position_immediate entry_sm_left 1)
;	(device_set_power entry_sm_right 0)
;	(device_set_position_immediate entry_sm_right 1)
	(game_save)
)


;-------------------------------------------------------------------------------
;Recycling Plant

;Temp variables for controlling conveyors
(global short recycling_time 150)
(global boolean recycling_power_on FALSE)
(global boolean recycling_killer_on FALSE)

(script dormant recycler_initialize
	(object_create recycling_can_01)
	(object_teleport recycling_can_01 recycling_can_init_01)
	(object_create recycling_can_02)
	(object_teleport recycling_can_02 recycling_can_init_02)
	(object_create recycling_can_03)
	(object_teleport recycling_can_03 recycling_can_init_03)
	(object_create recycling_can_04)
	(object_teleport recycling_can_04 recycling_can_init_04)
	(object_create recycling_can_06)
	(object_teleport recycling_can_06 recycling_can_init_06)
	(object_create recycling_can_07)
	(object_teleport recycling_can_07 recycling_can_init_07)
	(object_create recycling_can_08)
	(object_teleport recycling_can_08 recycling_can_init_08)
	(object_create recycling_can_09)
	(object_teleport recycling_can_09 recycling_can_init_09)
	(object_create recycling_can_11)
	(object_teleport recycling_can_11 recycling_can_init_11)
	(object_create recycling_can_01)
	(object_teleport recycling_can_12 recycling_can_init_12)
	(object_create recycling_can_13)
	(object_teleport recycling_can_13 recycling_can_init_13)
	(object_create recycling_can_14)
	(object_teleport recycling_can_14 recycling_can_init_14)
)

;Spawns cans on lines A, B, and C
(script continuous recycling_can_spawner_A
	(sleep_until (= recycling_power_on TRUE))
	(if (= (list_count recycling_can_05) 0)
		(begin
			(object_create recycling_can_05)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_01) 0)
		(begin
			(object_create recycling_can_01)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_02) 0)
		(begin
			(object_create recycling_can_02)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_03) 0)
		(begin
			(object_create recycling_can_03)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_04) 0)
		(begin
			(object_create recycling_can_04)
			(sleep recycling_time)
		)
	)
)
(script continuous recycling_can_spawner_B
	(sleep_until (= recycling_power_on TRUE))
	(if (= (list_count recycling_can_10) 0)
		(begin
			(object_create recycling_can_10)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_06) 0)
		(begin
			(object_create recycling_can_06)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_07) 0)
		(begin
			(object_create recycling_can_07)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_08) 0)
		(begin
			(object_create recycling_can_08)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_09) 0)
		(begin
			(object_create recycling_can_09)
			(sleep recycling_time)
		)
	)
)
(script continuous recycling_can_spawner_C
	(sleep_until (= recycling_power_on TRUE))
	(if (= (list_count recycling_can_15) 0)
		(begin
			(object_create recycling_can_15)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_11) 0)
		(begin
			(object_create recycling_can_11)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_12) 0)
		(begin
			(object_create recycling_can_12)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_13) 0)
		(begin
			(object_create recycling_can_13)
			(sleep recycling_time)
		)
	)
	(if (= (list_count recycling_can_14) 0)
		(begin
			(object_create recycling_can_14)
			(sleep recycling_time)
		)
	)
)

(script continuous recycling_killer_new
	(object_destroy (list_get (volume_return_objects vol_recycling_pit_kill) 0))
	(sleep 150)	
)

;Checks for cans and destroys them when in pit
(script continuous recycling_killer_01
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_01) TRUE) 150)
	(object_destroy recycling_can_01)
)
(script continuous recycling_killer_02
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_02) TRUE) 150)
	(object_destroy recycling_can_02)
)
(script continuous recycling_killer_03
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_03) TRUE) 150)
	(object_destroy recycling_can_03)
)
(script continuous recycling_killer_04
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_04) TRUE) 150)
	(object_destroy recycling_can_04)
)
(script continuous recycling_killer_05
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_05) TRUE) 150)
	(object_destroy recycling_can_05)
)
(script continuous recycling_killer_06
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_06) TRUE) 150)
	(object_destroy recycling_can_06)
)
(script continuous recycling_killer_07
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_07) TRUE) 150)
	(object_destroy recycling_can_07)
)
(script continuous recycling_killer_08
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_08) TRUE) 150)
	(object_destroy recycling_can_08)
)
(script continuous recycling_killer_09
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_09) TRUE) 150)
	(object_destroy recycling_can_09)
)
(script continuous recycling_killer_10
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_10) TRUE) 150)
	(object_destroy recycling_can_10)
)
(script continuous recycling_killer_11
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_11) TRUE) 150)
	(object_destroy recycling_can_11)
)
(script continuous recycling_killer_12
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_12) TRUE) 150)
	(object_destroy recycling_can_12)
)
(script continuous recycling_killer_13
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_13) TRUE) 150)
	(object_destroy recycling_can_13)
)
(script continuous recycling_killer_14
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_14) TRUE) 150)
	(object_destroy recycling_can_14)
)
(script continuous recycling_killer_15
	(sleep_until (= recycling_killer_on TRUE))
	(sleep_until (= (volume_test_object vol_recycling_pit_kill recycling_can_15) TRUE) 150)
	(object_destroy recycling_can_15)
)

;Turns on can killers
(script dormant recycling_killers_go
	(wake recycling_killer_04)
	(wake recycling_killer_09)
	(wake recycling_killer_14)
	(sleep 30)
	(wake recycling_killer_03)
	(wake recycling_killer_08)
	(wake recycling_killer_13)
	(sleep 30)
	(wake recycling_killer_02)
	(wake recycling_killer_07)
	(wake recycling_killer_12)
	(sleep 30)
	(wake recycling_killer_01)
	(wake recycling_killer_06)
	(wake recycling_killer_11)
	(sleep 30)
	(wake recycling_killer_05)
	(wake recycling_killer_10)
	(wake recycling_killer_15)
	(set recycling_killer_on TRUE)
)

;Powers up the whole conveyor system and staggers spawning of cans
(script dormant recycling_power_up
	(wake recycler_initialize)
;	(wake recycling_killers_go)
	(wake recycling_can_spawner_C)
	(sleep (/ recycling_time 3))
	(wake recycling_can_spawner_A)
	(sleep (/ recycling_time 3))
	(wake recycling_can_spawner_B)
	(set recycling_power_on TRUE)
	
)

;Shuts off all these continuous scripts once you reach the hangar
(script dormant kill_recycling_hacks
	(sleep_forever recycling_can_spawner_A)
	(sleep_forever recycling_can_spawner_B)
	(sleep_forever recycling_can_spawner_C)
	(sleep_forever recycling_killer_01)
	(sleep_forever recycling_killer_02)
	(sleep_forever recycling_killer_03)
	(sleep_forever recycling_killer_04)
	(sleep_forever recycling_killer_05)
	(sleep_forever recycling_killer_06)
	(sleep_forever recycling_killer_07)
	(sleep_forever recycling_killer_08)
	(sleep_forever recycling_killer_09)
	(sleep_forever recycling_killer_10)
	(sleep_forever recycling_killer_11)
	(sleep_forever recycling_killer_12)
	(sleep_forever recycling_killer_13)
	(sleep_forever recycling_killer_14)
	(sleep_forever recycling_killer_15)
	(sleep_forever)
	(sleep_forever recycling_can_spawner_A)
	(sleep_forever recycling_can_spawner_B)
	(sleep_forever recycling_can_spawner_C)
	(sleep_forever recycling_killer_01)
	(sleep_forever recycling_killer_02)
	(sleep_forever recycling_killer_03)
	(sleep_forever recycling_killer_04)
	(sleep_forever recycling_killer_05)
	(sleep_forever recycling_killer_06)
	(sleep_forever recycling_killer_07)
	(sleep_forever recycling_killer_08)
	(sleep_forever recycling_killer_09)
	(sleep_forever recycling_killer_10)
	(sleep_forever recycling_killer_11)
	(sleep_forever recycling_killer_12)
	(sleep_forever recycling_killer_13)
	(sleep_forever recycling_killer_14)
	(sleep_forever recycling_killer_15)
)

;---

;Horrible hack to make 01 heretic do random patrol shit
(global boolean rec_center_heretic_01_cs TRUE)

(script command_script rec_center_heretic_01_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block02R_front rec_center_h01/block02R_rear)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script rec_center_heretic_01_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block02R_rear rec_center_h01/block02R_front)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script rec_center_heretic_01_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block02R_left rec_center_h01/block02R_right)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script rec_center_heretic_01_D
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block02R_right rec_center_h01/block02R_left)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script rec_center_heretic_01_E
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block02L_front rec_center_h01/block02L_rear)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script rec_center_heretic_01_F
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block02L_rear rec_center_h01/block02L_front)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script rec_center_heretic_01_G
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block02L_left rec_center_h01/block02L_right)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script rec_center_heretic_01_H
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block02L_right rec_center_h01/block02L_left)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script rec_center_heretic_01_I
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block01R_rear rec_center_h01/block01R_front)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script rec_center_heretic_01_J
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/block01L_rear rec_center_h01/block01L_front)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script rec_center_heretic_01_K
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/sen_tube_01R rec_center_h01/sen_tube_01R_pt)
	(cs_custom_animation objects\characters\elite\elite "combat:rifle:posing:var6" 1 TRUE)
)
(script command_script rec_center_heretic_01_L
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h01/sen_tube_01L rec_center_h01/sen_tube_01L_pt)
	(cs_custom_animation objects\characters\elite\elite "combat:rifle:posing:var6" 1 TRUE)
)

(script dormant rec_center_heretic_01_random
	(sleep_until
		(begin
			(begin_random
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_A)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_A) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_B)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_B) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_C)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_C) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_D)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_D) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_E)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_E) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_F)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_F) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_G)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_G) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_H)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_H) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_I)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_I) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_J)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_J) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_K)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_K) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
				(if rec_center_heretic_01_cs
					(begin
						(cs_run_command_script rec_center_heretic_01 rec_center_heretic_01_L)
  						(sleep_until (= (cs_command_script_running rec_center_heretic_01/h01 rec_center_heretic_01_L) FALSE))
						(set rec_center_heretic_01_cs FALSE)
 					)
				)
			)
			(set rec_center_heretic_01_cs TRUE)
			(= (ai_living_count rec_center_heretic_01) 0)
		)
	)
)

;Horrible hack to make 02 heretics do random patrol shit
(global boolean rec_center_heretic_02a_cs TRUE)
(global boolean rec_center_heretic_02b_cs TRUE)

(script command_script rec_center_heretic_02_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_entry_left rec_center_h02/face_entry_left)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_entry_left rec_center_h02/face_slope_left)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_entry_mid rec_center_h02/face_entry_mid)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_D
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_entry_mid rec_center_h02/face_slope_mid)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_E
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_entry_right rec_center_h02/face_entry_right)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_F
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_entry_right rec_center_h02/face_slope_right)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_G
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_slope_left rec_center_h02/face_slope_left)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_H
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_slope_left rec_center_h02/face_entry_left)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_I
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_slope_mid rec_center_h02/face_slope_mid)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_J
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_slope_mid rec_center_h02/face_entry_mid)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_K
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_slope_right rec_center_h02/face_slope_right)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_L
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h02/top_slope_right rec_center_h02/face_entry_right)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_02_M
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to rec_center_h02/nook_left)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script rec_center_heretic_02_N
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to rec_center_h02/nook_right)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)

(script dormant rec_center_heretic_02a_random
	(sleep_until
		(begin
			(begin_random
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_A)
						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_A) FALSE))
 						(set rec_center_heretic_02a_cs FALSE)
 						
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_B)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_B) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_C)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_C) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_D)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_D) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_E)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_E) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_F)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_F) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_G)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_G) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_H)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_H) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_I)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_I) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_J)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_J) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_K)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_K) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_L)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_L) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_M)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_M) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
				(if rec_center_heretic_02a_cs
					(begin
						(cs_run_command_script rec_center_heretic_02/h01 rec_center_heretic_02_N)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_02/h01 rec_center_heretic_02_N) FALSE))
						(set rec_center_heretic_02a_cs FALSE)
 					)
				)
			)
			(set rec_center_heretic_02a_cs TRUE)
			(= (ai_living_count rec_center_heretic_02) 0)
		)
	)
)

;Horrible hack to make 03 heretic do random patrol shit
(global boolean rec_center_heretic_03_cs TRUE)

(script command_script rec_center_heretic_03_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/corner_left rec_center_h03/corner_right)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_03_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/corner_right rec_center_h03/corner_left)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_03_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/machine_right_front rec_center_h03/machine_right_rear)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script rec_center_heretic_03_D
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/machine_right_rear rec_center_h03/machine_right_front)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script rec_center_heretic_03_E
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/machine_left_front rec_center_h03/machine_left_rear)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script rec_center_heretic_03_F
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/machine_left_rear rec_center_h03/machine_left_front)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)

(script dormant rec_center_heretic_03_random
	(sleep_until
		(begin
			(begin_random
				(if rec_center_heretic_03_cs
					(begin
						(cs_run_command_script rec_center_heretic_03/h01 rec_center_heretic_03_A)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_03/h01 rec_center_heretic_03_A) FALSE))
						(set rec_center_heretic_03_cs FALSE)
 					)
				)
				(if rec_center_heretic_03_cs
					(begin
						(cs_run_command_script rec_center_heretic_03/h01 rec_center_heretic_03_B)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_03/h01 rec_center_heretic_03_B) FALSE))
						(set rec_center_heretic_03_cs FALSE)
 					)
				)
				(if rec_center_heretic_03_cs
					(begin
						(cs_run_command_script rec_center_heretic_03/h01 rec_center_heretic_03_C)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_03/h01 rec_center_heretic_03_C) FALSE))
						(set rec_center_heretic_03_cs FALSE)
 					)
				)
				(if rec_center_heretic_03_cs
					(begin
						(cs_run_command_script rec_center_heretic_03/h01 rec_center_heretic_03_D)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_03/h01 rec_center_heretic_03_D) FALSE))
						(set rec_center_heretic_03_cs FALSE)
 					)
				)
				(if rec_center_heretic_03_cs
					(begin
						(cs_run_command_script rec_center_heretic_03/h01 rec_center_heretic_03_E)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_03/h01 rec_center_heretic_03_E) FALSE))
						(set rec_center_heretic_03_cs FALSE)
 					)
				)
				(if rec_center_heretic_03_cs
					(begin
						(cs_run_command_script rec_center_heretic_03/h01 rec_center_heretic_03_F)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_03/h01 rec_center_heretic_03_F) FALSE))
						(set rec_center_heretic_03_cs FALSE)
 					)
				)
			)
			(set rec_center_heretic_03_cs TRUE)
			(= (ai_living_count rec_center_heretic_03) 0)
		)
	)
)

;Horrible hack to make 04 heretics do random patrol shit
(global boolean rec_center_heretic_04a_cs TRUE)
(global boolean rec_center_heretic_04b_cs TRUE)

(script command_script rec_center_heretic_04_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/slope_top_left rec_center_h03/slope_bottom_left)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_04_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/slope_bottom_left rec_center_h03/slope_top_left)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_04_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/slope_top_right rec_center_h03/slope_bottom_right)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_04_D
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/slope_bottom_right rec_center_h03/slope_top_right)
	(sleep 90)
;	(cs_pause 2)
)
(script command_script rec_center_heretic_04_E
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/slope_mid_right rec_center_h03/slope_look_right)
	(cs_custom_animation objects\characters\elite\elite "combat:rifle:posing:var6" 1 TRUE)
)
(script command_script rec_center_heretic_04_F
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h03/slope_mid_left rec_center_h03/slope_look_left)
	(cs_custom_animation objects\characters\elite\elite "combat:rifle:posing:var6" 1 TRUE)
)

(script dormant rec_center_heretic_04a_random
	(sleep_until
		(begin
			(begin_random
				(if rec_center_heretic_04a_cs
					(begin
						(cs_run_command_script rec_center_heretic_04/h01 rec_center_heretic_04_C)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_04/h01 rec_center_heretic_04_C) FALSE))
						(set rec_center_heretic_04a_cs FALSE)
 					)
				)
				(if rec_center_heretic_04a_cs
					(begin
						(cs_run_command_script rec_center_heretic_04/h01 rec_center_heretic_04_D)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_04/h01 rec_center_heretic_04_D) FALSE))
						(set rec_center_heretic_04a_cs FALSE)
 					)
				)
				(if rec_center_heretic_04a_cs
					(begin
						(cs_run_command_script rec_center_heretic_04/h01 rec_center_heretic_04_E)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_04/h01 rec_center_heretic_04_E) FALSE))
						(set rec_center_heretic_04a_cs FALSE)
 					)
				)
			)
			(set rec_center_heretic_04a_cs TRUE)
			(= (ai_living_count rec_center_heretic_04) 0)
		)
	)
)
(script dormant rec_center_heretic_04b_random
	(sleep_until
		(begin
			(begin_random
				(if rec_center_heretic_04b_cs
					(begin
						(cs_run_command_script rec_center_heretic_04/h02 rec_center_heretic_04_A)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_04/h02 rec_center_heretic_04_A) FALSE))
						(set rec_center_heretic_04b_cs FALSE)
 					)
				)
				(if rec_center_heretic_04b_cs
					(begin
						(cs_run_command_script rec_center_heretic_04/h02 rec_center_heretic_04_B)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_04/h02 rec_center_heretic_04_B) FALSE))
						(set rec_center_heretic_04b_cs FALSE)
 					)
				)
				(if rec_center_heretic_04b_cs
					(begin
						(cs_run_command_script rec_center_heretic_04/h02 rec_center_heretic_04_F)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_04/h02 rec_center_heretic_04_F) FALSE))
						(set rec_center_heretic_04b_cs FALSE)
 					)
				)
			)
			(set rec_center_heretic_04b_cs TRUE)
			(= (ai_living_count rec_center_heretic_04) 0)
		)
	)
)

;Makes 05 heretic stare out window
(script command_script rec_center_heretic_05
	(cs_abort_on_alert TRUE)
	(cs_face TRUE rec_center_h06/big_window)
	(sleep_forever)
)

;Horrible hack to make 06 heretic do random patrol shit
(global boolean rec_center_heretic_06_cs TRUE)

(script command_script rec_center_heretic_06_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h06/window_right rec_center_h06/window_right_face)
;	(cs_pause 2)
	(sleep 90)
)
(script command_script rec_center_heretic_06_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h06/window_left rec_center_h06/window_left_face)
;	(cs_pause 2)
	(sleep 90)
)
(script command_script rec_center_heretic_06_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h06/console_right rec_center_h06/console_right_face)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script rec_center_heretic_06_D
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face rec_center_h06/console_left rec_center_h06/console_left_face)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)

(script dormant rec_center_heretic_06_random
	(sleep_until
		(begin
			(begin_random
				(if rec_center_heretic_06_cs
					(begin
						(cs_run_command_script rec_center_heretic_06/h01 rec_center_heretic_06_A)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_06/h01 rec_center_heretic_06_A) FALSE))
						(set rec_center_heretic_06_cs FALSE)
 					)
				)
				(if rec_center_heretic_06_cs
					(begin
						(cs_run_command_script rec_center_heretic_06/h01 rec_center_heretic_06_B)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_06/h01 rec_center_heretic_06_B) FALSE))
						(set rec_center_heretic_06_cs FALSE)
 					)
				)
				(if rec_center_heretic_06_cs
					(begin
						(cs_run_command_script rec_center_heretic_06/h01 rec_center_heretic_06_C)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_06/h01 rec_center_heretic_06_C) FALSE))
						(set rec_center_heretic_06_cs FALSE)
 					)
				)
				(if rec_center_heretic_06_cs
					(begin
						(cs_run_command_script rec_center_heretic_06/h01 rec_center_heretic_06_D)
 						(sleep_until (= (cs_command_script_running rec_center_heretic_06/h01 rec_center_heretic_06_D) FALSE))
						(set rec_center_heretic_06_cs FALSE)
 					)
				)
			)
			(set rec_center_heretic_06_cs TRUE)
			(= (ai_living_count rec_center_heretic_06) 0)
		)
	)
)

;---

;Sends in sentinels if the heretics are alerted
(script dormant rec_center_sentinel_reinforce
	(sleep_until (> (ai_combat_status rec_center_heretics) ai_combat_status_idle))
	(print "HERETIC: 'We need sentinels!'")
	(sleep 90)
	(if (= (volume_test_objects_all vol_recycling_start (players)) TRUE)
		(begin
			(ai_place rec_center_sentinels_01 1)
			(sleep 90)
			(ai_place rec_center_sentinels_01 1)
			(sleep 90)
			(ai_place rec_center_sentinels_01 1)
			(sleep 90)
			(ai_place rec_center_sentinels_01 1)
			(sleep_until (= (volume_test_objects_all vol_recycling_start (players)) FALSE))
			(ai_set_orders rec_center_sentinels_01 rec_center_s_wave_02)
			(sleep_until (< (ai_living_count rec_center_sentinels_01) 1))
			(ai_place rec_center_sentinels_02 1)
			(sleep 90)
			(ai_place rec_center_sentinels_02 1)
			(sleep 90)
			(ai_place rec_center_sentinels_02 1)
			(sleep 90)
			(ai_place rec_center_sentinels_02 1)
		)
		(begin
			(ai_place rec_center_sentinels_02 1)
			(sleep 90)
			(ai_place rec_center_sentinels_02 1)
			(sleep 90)
			(ai_place rec_center_sentinels_02 1)
			(sleep 90)
			(ai_place rec_center_sentinels_02 1)
		)
	)
)

;Calls up allies once your cover is blown
(script dormant rec_center_allies_engage
	(sleep_until (OR (= (ai_living_count rec_center_heretic_07) 0) 
		(> (ai_combat_status rec_center_heretics) ai_combat_status_idle)))
;	(sleep 60)
	(if (> (ai_living_count arm01_allies) 0)
		(begin
			(print "SPEC-OPS ELITE: 'Move it, men!'")
			(ai_set_orders arm01_allies allies_rec_center)
			(ai_allegiance_remove heretic covenant)
			(ai_allegiance_remove covenant heretic)
		)
	)
)

;Keeps your allies moving up behind you as you clear the area silently
(script dormant rec_center_allies_advance_01
	(sleep_until (AND (= (ai_combat_status rec_center_heretics) ai_combat_status_idle)
		(AND (= (ai_living_count rec_center_heretic_01) 0) 
		(= (ai_living_count rec_center_heretic_02) 0))))
	(ai_set_orders arm01_allies allies_rec_hide_02)
)
(script dormant rec_center_allies_advance_02
	(sleep_until (AND (= (ai_combat_status rec_center_heretics) ai_combat_status_idle)
		(AND (= (ai_living_count rec_center_heretic_03) 0) 
		(= (ai_living_count rec_center_heretic_04) 0))))
	(ai_set_orders arm01_allies allies_rec_hide_03)
)
(script dormant rec_center_allies_advance_03
	(sleep_until (AND (= (ai_combat_status rec_center_heretics) ai_combat_status_idle)
		(AND (= (ai_living_count rec_center_heretic_05) 0) 
		(= (ai_living_count rec_center_heretic_06) 0))))
	(ai_set_orders arm01_allies allies_rec_hide_04)
)

;Overall script for recycling center
(script dormant recycling_center_start
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects_all vol_recycling_start (players)) TRUE)))
	(ai_allegiance heretic covenant)
	(ai_allegiance covenant heretic)
	(wake recycling_power_up)
	(game_save)
	(ai_place rec_center_heretic_01)
	(wake rec_center_heretic_01_random)
	(ai_place rec_center_heretic_02)
	(cs_run_command_script rec_center_heretic_02 long_pause)
;	(wake rec_center_heretic_02a_random)
;	(wake rec_center_heretic_02b_random)
	(ai_place rec_center_heretic_03)
	(wake rec_center_heretic_03_random)
	(ai_place rec_center_heretic_04)
	(wake rec_center_heretic_04a_random)
	(wake rec_center_heretic_04b_random)
	(ai_place rec_center_heretic_05)
	(cs_run_command_script rec_center_heretic_05 rec_center_heretic_05)
	(ai_place rec_center_heretic_06)
	(wake rec_center_heretic_06_random)
	(ai_place rec_center_heretic_07)
	(cs_run_command_script rec_center_heretic_07 long_pause)
	(wake rec_center_sentinel_reinforce)
	(wake rec_center_allies_advance_01)
	(wake rec_center_allies_advance_02)
	(wake rec_center_allies_advance_03)
	(wake rec_center_allies_engage)
)


;-------------------------------------------------------------------------------
;Hangar

;Staggers spawning of sentinels, and does it by side
(script static void hangar_sentinels_spawn
	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
		(ai_place hangar_sentinels_wave_01R 1)
		(ai_place hangar_sentinels_wave_01L 1)
	)
	(sleep 120)
	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
		(ai_place hangar_sentinels_wave_01R 1)
		(ai_place hangar_sentinels_wave_01L 1)
	)
	(sleep 120)
	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
		(ai_place hangar_sentinels_wave_01R 1)
		(ai_place hangar_sentinels_wave_01L 1)
	)
	(sleep 120)
	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
		(ai_place hangar_sentinels_wave_01R 1)
		(ai_place hangar_sentinels_wave_01L 1)
	)
;	(sleep 120)
;	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
;		(ai_place hangar_sentinels_wave_01R 1)
;		(ai_place hangar_sentinels_wave_01L 1)
;	)
;	(sleep 120)
;	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
;		(ai_place hangar_sentinels_wave_01R 1)
;		(ai_place hangar_sentinels_wave_01L 1)
;	)
)

;Sends in sentinels if the heretics are alerted
(script dormant hangar_sentinel_reinforce
	(sleep_until (> (ai_combat_status hangar_heretics) ai_combat_status_idle))
	(print "HERETIC: 'We need sentinels!'")
	(sleep 90)
	(hangar_sentinels_spawn)
)

;Elite tells you he and your allies will wait at the top until needed
(script command_script hangar_ally_intro
	(print "ELITE: 'Go ahead, Dervish.'")
	(sleep 60)
	;check ally count?
	(print "ELITE: 'We'll be right behind you.'")
	(ai_set_orders arm01_allies standby_hangar_elev) 
)

;Allies wait for you to go down, then follow once encounter is alerted
(script dormant hangar_allies_reinforce
	(sleep_until (AND (= (device_get_position elev_hangar) 0) 
		(= (volume_test_objects vol_hangar_elev_bottom (players)) FALSE)))
	(device_set_position elev_hangar 1)
	(sleep_until (= (device_get_position elev_hangar) 1))
	(sleep_until (OR (= (ai_living_count hangar_heretics) 0) 
		(> (ai_combat_status hangar_heretics) ai_combat_status_idle)))
	;check ally count?	
	(print "SPEC-OPS ELITE: 'We're coming, Dervish!'")
	(ai_set_orders arm01_allies get_on_hangar_elev)
	(sleep_until (= (volume_test_objects_all vol_on_hangar_lift_top (ai_actors arm01_allies)) TRUE) 30 150)
;	(sleep 60)
	(device_set_position elev_hangar 0)
	(sleep_until (= (device_get_position elev_hangar) 0))
	(ai_set_orders arm01_allies allies_all_hangar)
)

;Overall script for hangar, the first time through
(script dormant hangar_firsttime_start
;	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_elev_to_hangar (players)) TRUE)))
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_on_hangar_lift_top (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
	(wake kill_recycling_hacks)
	(game_save)

	(if (> (ai_living_count initial_allies_elites) 1)
		(cs_run_command_script allies_elites_01/elite04 hangar_ally_intro)
		(cs_run_command_script hacker hangar_ally_intro)
	)
	(ai_renew all_allies)
	(ai_place hangar_heretic_01)
	(ai_place hangar_heretic_02)
	(ai_place hangar_heretic_03)
	(ai_place hangar_heretic_04)
	(ai_place hangar_heretic_05)
	(ai_place hangar_heretic_06)
	(ai_place hangar_heretic_07)
	(wake hangar_sentinel_reinforce)
	(sleep_until (< (device_get_position elev_hangar) 1))
	(if (> (ai_living_count arm01_allies) 0)
		(begin
			(ai_renew all_allies)
			(wake hangar_allies_reinforce)
		)
	)
	(sleep_until (= (device_get_position elev_hangar) 0))
	(game_save)
	(sleep_until (OR (= (ai_strength hangar_heretics) 0) 
		(AND (= (ai_combat_status hangar_heretics) ai_combat_status_idle) 
		(= (volume_test_objects vol_hangar_center_exit (players)) TRUE))) 30 9000)
	(device_operates_automatically_set hangar_exit TRUE)
)


;-------------------------------------------------------------------------------
;Corridors to Under Hangar

;Horrible hacks to make first hall heretics do random patrol shit
(global boolean first_hall_heretic_01_cs TRUE)

(script command_script first_hall_heretic_01_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/box_A first_hallway/box)
	(cs_custom_animation objects\characters\elite\elite "crouch:rifle:land_hard" 1 TRUE)
)
(script command_script first_hall_heretic_01_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/box_B first_hallway/box)
	(cs_custom_animation objects\characters\elite\elite "crouch:rifle:land_hard" 1 TRUE)
)
(script command_script first_hall_heretic_01_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/box_C first_hallway/box)
	(cs_custom_animation objects\characters\elite\elite "crouch:rifle:land_hard" 1 TRUE)
)
(script command_script first_hall_heretic_01_D
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/corner1_A first_hallway/corner1_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script first_hall_heretic_01_E
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/corner1_B first_hallway/corner1_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)

(script dormant first_hall_heretic_01_random
	(sleep_until
		(begin
			(begin_random
				(if first_hall_heretic_01_cs
					(begin
						(cs_run_command_script first_hall_heretic_01/h01 first_hall_heretic_01_A)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_01/h01 first_hall_heretic_01_A) FALSE))
						(set first_hall_heretic_01_cs FALSE)
 					)
				)
				(if first_hall_heretic_01_cs
					(begin
						(cs_run_command_script first_hall_heretic_01/h01 first_hall_heretic_01_B)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_01/h01 first_hall_heretic_01_B) FALSE))
						(set first_hall_heretic_01_cs FALSE)
 					)
				)
				(if first_hall_heretic_01_cs
					(begin
						(cs_run_command_script first_hall_heretic_01/h01 first_hall_heretic_01_C)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_01/h01 first_hall_heretic_01_C) FALSE))
						(set first_hall_heretic_01_cs FALSE)
 					)
				)
				(if first_hall_heretic_01_cs
					(begin
						(cs_run_command_script first_hall_heretic_01/h01 first_hall_heretic_01_D)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_01/h01 first_hall_heretic_01_D) FALSE))
						(set first_hall_heretic_01_cs FALSE)
 					)
				)
				(if first_hall_heretic_01_cs
					(begin
						(cs_run_command_script first_hall_heretic_01/h01 first_hall_heretic_01_E)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_01/h01 first_hall_heretic_01_E) FALSE))
						(set first_hall_heretic_01_cs FALSE)
 					)
				)
			)
			(set first_hall_heretic_01_cs TRUE)
			(OR (> (ai_combat_status first_hall_heretic_01) ai_combat_status_idle) 
				(= (ai_living_count first_hall_heretic_01) 0))
		)
	)
)

(global boolean first_hall_heretic_02_cs TRUE)

(script command_script first_hall_heretic_02_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/corner1_A first_hallway/corner1_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script first_hall_heretic_02_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/corner1_B first_hallway/corner1_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script first_hall_heretic_02_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/corner2_A first_hallway/corner2_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script first_hall_heretic_02_D
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face first_hallway/corner2_B first_hallway/corner2_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)

(script dormant first_hall_heretic_02_random
	(sleep_until
		(begin
			(begin_random
				(if first_hall_heretic_02_cs
					(begin
						(cs_run_command_script first_hall_heretic_02/h02 first_hall_heretic_02_A)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_02/h02 first_hall_heretic_02_A) FALSE))
						(set first_hall_heretic_02_cs FALSE)
 					)
				)
				(if first_hall_heretic_02_cs
					(begin
						(cs_run_command_script first_hall_heretic_02/h02 first_hall_heretic_02_B)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_02/h02 first_hall_heretic_02_B) FALSE))
						(set first_hall_heretic_02_cs FALSE)
 					)
				)
				(if first_hall_heretic_02_cs
					(begin
						(cs_run_command_script first_hall_heretic_02/h02 first_hall_heretic_02_C)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_02/h02 first_hall_heretic_02_C) FALSE))
						(set first_hall_heretic_02_cs FALSE)
 					)
				)
				(if first_hall_heretic_02_cs
					(begin
						(cs_run_command_script first_hall_heretic_02/h02 first_hall_heretic_02_D)
 						(sleep_until (= (cs_command_script_running first_hall_heretic_02/h02 first_hall_heretic_02_D) FALSE))
						(set first_hall_heretic_02_cs FALSE)
 					)
				)
			)
			(set first_hall_heretic_02_cs TRUE)
			(OR (> (ai_combat_status first_hall_heretic_02) ai_combat_status_idle) 
				(= (ai_living_count first_hall_heretic_02) 0))
		)
	)
)

(script dormant first_hall_allies
	(ai_set_orders arm01_allies allies_first_hall_01)
	(sleep_until (OR (= (ai_living_count first_hall_heretic_01) 0) 
		(= (volume_test_objects vol_first_hall_01 (players)) TRUE)))
	(ai_set_orders arm01_allies allies_first_hall_02)
)

(script dormant first_hall_reinforce
	(sleep_until (> (ai_combat_status first_hall_heretics) ai_combat_status_idle))
	(ai_place first_hall_heretic_03)
	(ai_set_orders arm01_allies allies_halls_hangar_to_under)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
)

;Overall script for halls leading to under hangar, the first time through
(script dormant to_underhangar_firsttime
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_hangar_reenter (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(ai_renew all_allies)
	(ai_allegiance heretic covenant)
	(ai_allegiance covenant heretic)	
;	(ai_set_orders arm01_allies allies_halls_hangar_to_under)
	
	(ai_place first_hall_heretic_01)
	(wake first_hall_heretic_01_random)
	(ai_place first_hall_heretic_02)
	(wake first_hall_heretic_02_random)
	(wake first_hall_reinforce)
	(wake first_hall_allies)
)


;-------------------------------------------------------------------------------
;Under Hangar

;A bunch of booleans to track the hacked sentinel emitters in here
(global boolean underhangar_emit_start FALSE)
(global boolean underhangar_emit_now FALSE)
(global boolean underhangar_emit_01_alive TRUE)
(global boolean underhangar_emit_02_alive TRUE)
(global boolean underhangar_emit_03_alive TRUE)
(global boolean underhangar_emit_04_alive TRUE)
(global boolean underhangar_emit_05_alive TRUE)

;Randomly spits out sentinels until all are destroyed
(script static void random_underhangar_emit
	(begin_random
		(if (AND underhangar_emit_now underhangar_emit_01_alive)
			(begin
				(ai_place underhangar_sentinels_01)
				(set underhangar_emit_now FALSE)
			)
		)
		(if (AND underhangar_emit_now underhangar_emit_02_alive)
			(begin
				(ai_place underhangar_sentinels_02)
				(set underhangar_emit_now FALSE)
			)
		)
		(if (AND underhangar_emit_now underhangar_emit_03_alive)
			(begin
				(ai_place underhangar_sentinels_03)
				(set underhangar_emit_now FALSE)
			)
		)
		(if (AND underhangar_emit_now underhangar_emit_04_alive)
			(begin
				(ai_place underhangar_sentinels_04)
				(set underhangar_emit_now FALSE)
			)
		)
		(if (AND underhangar_emit_now underhangar_emit_05_alive)
			(begin
				(ai_place underhangar_sentinels_05)
				(set underhangar_emit_now FALSE)
			)
		)
	)
)

;Tells emitters to make a new sentinel whenever the total goes under 2
(script continuous underhangar_emit_checker
	(sleep_until (= underhangar_emit_start TRUE))
	(if (< (ai_living_count underhangar_sentinels) 2)
		(begin
			(sleep_until 
				(begin
					(sleep sen_emitter_delay)
					(set underhangar_emit_now TRUE)
					(random_underhangar_emit)
					(> (ai_living_count underhangar_sentinels) 2)
				)
			)
		)
	)
	(sleep sen_emitter_delay)
)

;Destroy emitter geometry and sets them as dead
(script dormant underhangar_emit_killer_01
	(sleep_until (= (object_get_health underhangar_emit_01) 0))
	(object_destroy underhangar_emit_01)
	(set underhangar_emit_01_alive FALSE)
)	
(script dormant underhangar_emit_killer_02
	(sleep_until (= (object_get_health underhangar_emit_02) 0))
	(object_destroy underhangar_emit_02)
	(set underhangar_emit_02_alive FALSE)
)	
(script dormant underhangar_emit_killer_03
	(sleep_until (= (object_get_health underhangar_emit_03) 0))
	(object_destroy underhangar_emit_03)
	(set underhangar_emit_03_alive FALSE)
)	
(script dormant underhangar_emit_killer_04
	(sleep_until (= (object_get_health underhangar_emit_04) 0))
	(object_destroy underhangar_emit_04)
	(set underhangar_emit_04_alive FALSE)
)	
(script dormant underhangar_emit_killer_05
	(sleep_until (= (object_get_health underhangar_emit_05) 0))
	(object_destroy underhangar_emit_05)
	(set underhangar_emit_05_alive FALSE)
)	

;Overall script for under hangar, the first time through
(script dormant underhangar_firsttime_start

	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_underhangar_from_top (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(ai_renew all_allies)
	(ai_set_orders arm01_allies allies_underhangar)
	(ai_place underhangar_sentinels_initial)

	(set underhangar_emit_start TRUE)
	(wake underhangar_emit_killer_01)
	(wake underhangar_emit_killer_02)
	(wake underhangar_emit_killer_03)
	(wake underhangar_emit_killer_04)
	(wake underhangar_emit_killer_05)
)


;-------------------------------------------------------------------------------
;Corridors to Bottling Plant

;Horrible hacks to make second hall heretics do random patrol shit
(global boolean 2nd_hall_heretic_01_cs TRUE)

(script command_script 2nd_hall_heretic_01_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/corner1_A second_hallway/corner1_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script 2nd_hall_heretic_01_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/corner1_B second_hallway/corner1_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script 2nd_hall_heretic_01_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to second_hallway/nook1)
	(sleep 90)
)
(script command_script 2nd_hall_heretic_01_D
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to second_hallway/door1)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script 2nd_hall_heretic_01_E
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to second_hallway/entry)
	(sleep 90)
)

(script dormant 2nd_hall_heretic_01_random
	(sleep_until
		(begin
			(begin_random
				(if 2nd_hall_heretic_01_cs
					(begin
						(cs_run_command_script second_hall_heretic_01/h01 2nd_hall_heretic_01_A)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_01/h01 2nd_hall_heretic_01_A) FALSE))
						(set 2nd_hall_heretic_01_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_01_cs
					(begin
						(cs_run_command_script second_hall_heretic_01/h01 2nd_hall_heretic_01_B)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_01/h01 2nd_hall_heretic_01_B) FALSE))
						(set 2nd_hall_heretic_01_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_01_cs
					(begin
						(cs_run_command_script second_hall_heretic_01/h01 2nd_hall_heretic_01_C)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_01/h01 2nd_hall_heretic_01_C) FALSE))
						(set 2nd_hall_heretic_01_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_01_cs
					(begin
						(cs_run_command_script second_hall_heretic_01/h01 2nd_hall_heretic_01_D)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_01/h01 2nd_hall_heretic_01_D) FALSE))
						(set 2nd_hall_heretic_01_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_01_cs
					(begin
						(cs_run_command_script second_hall_heretic_01/h01 2nd_hall_heretic_01_E)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_01/h01 2nd_hall_heretic_01_E) FALSE))
						(set 2nd_hall_heretic_01_cs FALSE)
 					)
				)
			)
			(set 2nd_hall_heretic_01_cs TRUE)
			(OR (> (ai_combat_status second_hall_heretic_01) ai_combat_status_idle) 
				(= (ai_living_count second_hall_heretic_01) 0))
		)
	)
)

(global boolean 2nd_hall_heretic_02_cs TRUE)

(script command_script 2nd_hall_heretic_02_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/door2 second_hallway/door2_face)
	(sleep 90)
)
(script command_script 2nd_hall_heretic_02_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/console1 second_hallway/console1_face)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script 2nd_hall_heretic_02_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/console2 second_hallway/console2_face)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)

(script dormant 2nd_hall_heretic_02_random
	(sleep_until
		(begin
			(begin_random
				(if 2nd_hall_heretic_02_cs
					(begin
						(cs_run_command_script second_hall_heretic_02/h02 2nd_hall_heretic_02_A)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_02/h02 2nd_hall_heretic_02_A) FALSE))
						(set 2nd_hall_heretic_02_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_02_cs
					(begin
						(cs_run_command_script second_hall_heretic_02/h02 2nd_hall_heretic_02_B)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_02/h02 2nd_hall_heretic_02_B) FALSE))
						(set 2nd_hall_heretic_02_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_02_cs
					(begin
						(cs_run_command_script second_hall_heretic_02/h02 2nd_hall_heretic_02_C)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_02/h02 2nd_hall_heretic_02_C) FALSE))
						(set 2nd_hall_heretic_02_cs FALSE)
 					)
				)
			)
			(set 2nd_hall_heretic_02_cs TRUE)
			(OR (> (ai_combat_status second_hall_heretic_02) ai_combat_status_idle) 
				(= (ai_living_count second_hall_heretic_02) 0))
		)
	)
)

(global boolean 2nd_hall_heretic_03_cs TRUE)

(script command_script 2nd_hall_heretic_03_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to second_hallway/door3)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 1 TRUE)
)
(script command_script 2nd_hall_heretic_03_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/corner2_A second_hallway/corner2_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script 2nd_hall_heretic_03_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/corner2_B second_hallway/corner2_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)

(script dormant 2nd_hall_heretic_03_random
	(sleep_until
		(begin
			(begin_random
				(if 2nd_hall_heretic_03_cs
					(begin
						(cs_run_command_script second_hall_heretic_03/h03 2nd_hall_heretic_03_A)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_03/h03 2nd_hall_heretic_03_A) FALSE))
						(set 2nd_hall_heretic_03_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_03_cs
					(begin
						(cs_run_command_script second_hall_heretic_03/h03 2nd_hall_heretic_03_B)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_03/h03 2nd_hall_heretic_03_B) FALSE))
						(set 2nd_hall_heretic_03_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_03_cs
					(begin
						(cs_run_command_script second_hall_heretic_03/h03 2nd_hall_heretic_03_C)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_03/h03 2nd_hall_heretic_03_C) FALSE))
						(set 2nd_hall_heretic_03_cs FALSE)
 					)
				)
			)
			(set 2nd_hall_heretic_03_cs TRUE)
			(OR (> (ai_combat_status second_hall_heretic_03) ai_combat_status_idle) 
				(= (ai_living_count second_hall_heretic_03) 0))
		)
	)
)

(global boolean 2nd_hall_heretic_04_cs TRUE)

(script command_script 2nd_hall_heretic_04_A
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to second_hallway/exit)
	(sleep 90)
)
(script command_script 2nd_hall_heretic_04_B
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/corner3_A second_hallway/corner3_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)
(script command_script 2nd_hall_heretic_04_C
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_alert TRUE)
	(cs_go_to_and_face second_hallway/corner3_B second_hallway/corner3_face)
	(cs_custom_animation objects\characters\elite\elite "patrol:rifle:kick" 1 TRUE)
)

(script dormant 2nd_hall_heretic_04_random
	(sleep_until
		(begin
			(begin_random
				(if 2nd_hall_heretic_04_cs
					(begin
						(cs_run_command_script second_hall_heretic_04/h04 2nd_hall_heretic_04_A)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_04/h04 2nd_hall_heretic_04_A) FALSE))
						(set 2nd_hall_heretic_04_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_04_cs
					(begin
						(cs_run_command_script second_hall_heretic_04/h04 2nd_hall_heretic_04_B)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_04/h04 2nd_hall_heretic_04_B) FALSE))
						(set 2nd_hall_heretic_04_cs FALSE)
 					)
				)
				(if 2nd_hall_heretic_04_cs
					(begin
						(cs_run_command_script second_hall_heretic_03/h03 2nd_hall_heretic_04_C)
 						(sleep_until (= (cs_command_script_running second_hall_heretic_04/h04 2nd_hall_heretic_04_C) FALSE))
						(set 2nd_hall_heretic_04_cs FALSE)
 					)
				)
			)
			(set 2nd_hall_heretic_04_cs TRUE)
			(OR (> (ai_combat_status second_hall_heretic_04) ai_combat_status_idle) 
				(= (ai_living_count second_hall_heretic_04) 0))
		)
	)
)

(script dormant second_hall_allies
	(ai_set_orders arm01_allies allies_2nd_hall_01)
	(sleep_until (OR (= (ai_living_count second_hall_heretic_01) 0) 
		(= (volume_test_objects vol_2nd_hall_01 (players)) TRUE)))
	(if (= (ai_combat_status second_hall_heretics) ai_combat_status_idle)	
		(ai_set_orders arm01_allies allies_2nd_hall_02)
	)
	(sleep_until (OR (= (ai_living_count second_hall_heretic_02) 0) 
		(= (volume_test_objects vol_2nd_hall_02 (players)) TRUE)))
	(if (= (ai_combat_status second_hall_heretics) ai_combat_status_idle)	
		(ai_set_orders arm01_allies allies_2nd_hall_03)
	)
	(sleep_until (OR (= (ai_living_count second_hall_heretic_03) 0) 
		(= (volume_test_objects vol_2nd_hall_03 (players)) TRUE)))
	(if (= (ai_combat_status second_hall_heretics) ai_combat_status_idle)	
		(ai_set_orders arm01_allies allies_2nd_hall_04)
	)
)

(script dormant second_hall_reinforce_01
	(sleep_until (> (ai_combat_status second_hall_heretic_01) ai_combat_status_idle))
	(ai_place second_hall_heretic_05)
	(ai_set_orders arm01_allies allies_under_to_bottling_01)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
)

(script dormant second_hall_reinforce_02
	(sleep_until (> (ai_combat_status second_hall_heretic_02) ai_combat_status_idle))
	(ai_place second_hall_heretic_06)
	(ai_set_orders arm01_allies allies_under_to_bottling_02)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
)

(script dormant second_hall_reinforce_03
	(sleep_until (> (ai_combat_status second_hall_heretic_03) ai_combat_status_idle))
	(ai_place second_hall_heretic_07)
	(ai_set_orders arm01_allies allies_under_to_bottling_03)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
)

(script dormant second_hall_reinforce_04
	(sleep_until (> (ai_combat_status second_hall_heretic_04) ai_combat_status_idle))
	(ai_set_orders arm01_allies allies_under_to_bottling_04)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
)

;Overall script for halls to bottling plant, the first time through
(script dormant to_bottling

	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(ai_renew all_allies)
	(ai_allegiance heretic covenant)
	(ai_allegiance covenant heretic)
	
	(ai_place second_hall_heretic_01)
	(wake 2nd_hall_heretic_01_random)
	(ai_place second_hall_heretic_02)
	(wake 2nd_hall_heretic_02_random)
	(ai_place second_hall_heretic_03)
	(wake 2nd_hall_heretic_03_random)
	(ai_place second_hall_heretic_04)
	(wake 2nd_hall_heretic_04_random)
	(ai_place second_hall_heretic_08)
	(cs_run_command_script second_hall_heretic_08 long_pause)
	
	(wake second_hall_reinforce_01)
	(wake second_hall_reinforce_02)
	(wake second_hall_reinforce_03)
	(wake second_hall_reinforce_04)
	(wake second_hall_allies)
	
;	(ai_set_orders arm01_allies allies_under_to_bottling)

;temporary way of stopping any surviving emitters in last room
	(set underhangar_emit_start FALSE)
)


;-------------------------------------------------------------------------------
;Bottling Plant Entry and Main Hall

;Staggers spawning of sentinels
(script static void bottling_plant_sentinels_spawn
	(ai_place bottling_sentinels_01 1)
	(sleep 90)
	(ai_place bottling_sentinels_01 1)
	(sleep 90)
	(ai_place bottling_sentinels_01 1)
	(sleep 90)
	(ai_place bottling_sentinels_01 1)
	(sleep 90)
	(ai_place bottling_sentinels_01 1)
)

;Spawn sentinels when the heretics are alerted
(script dormant bottling_sentinels_reinforce
	(sleep_until (> (ai_combat_status bottling_heretics) ai_combat_status_idle))
	(print "HERETIC: 'We need sentinels!'")
	(sleep 90)
	(bottling_plant_sentinels_spawn)
	(sleep_until (OR (= (volume_test_objects vol_bottling_mid02 (players)) TRUE) (< (ai_living_count bottling_sentinels_01) 3)))
	(ai_set_orders bottling_sentinels_01 bottling_s_wave_02)
)

;Heretics retreat when numbers drop and are alerted
(script dormant bottling_plant_heretics_mon
	(sleep_until (AND (> (ai_combat_status bottling_heretics) ai_combat_status_idle)
		(OR (= (volume_test_objects vol_bottling_mid01 (players)) TRUE) (< (ai_strength bottling_heretics_02) .5))))
	(ai_migrate bottling_heretics_02 bottling_heretics_03)
)

;Overall script for first half of bottling plant, the first time through
(script dormant bottling_firsttime_start

	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_bottling_enter (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)
	(ai_renew all_allies)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
	
	(game_save)
	
	(ai_set_orders arm01_allies allies_bottling)
	(ai_place bottling_heretics_02)
	(ai_place bottling_heretics_03)
	(wake bottling_plant_heretics_mon)
	(wake bottling_sentinels_reinforce)
)


;-------------------------------------------------------------------------------
;Bottling Plant Back Passage and Overlook Room

;Used to break heretics out of command scripts when I want the stealth stuff to end
(global boolean bottling_stealth_over FALSE)

;Scripted heretics chat with heretic leader and then turn on you
(script command_script heretics_back_passage
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(cs_face_object TRUE (list_get (ai_actors heretic_leader_02) 0)) 
	(sleep_until (= bottling_stealth_over TRUE))
	(cs_face_object FALSE (list_get (ai_actors heretic_leader_02) 0)) 
	(cs_aim_player TRUE)
)

;Scripted heretic leader runs away when he sees you
(script command_script hl_retreat_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(sleep_until (= (volume_test_objects vol_bottling_back (players)) TRUE))
;	(cs_face_player TRUE)
;	(cs_custom_animation objects\characters\elite\elite "combat:rifle:warn" 1 TRUE)
	(print "HL: 'Assassins!'")
	(set bottling_stealth_over TRUE)
;	(sleep 30)
;	(cs_face_player FALSE)
	(cs_go_to bottling_plant/p1)
)

;Scripted heretic leader flies away
(script command_script hl_retreat_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(cs_go_to bottling_plant/p3)
	(cs_face TRUE bottling_plant/p2)
	(cs_custom_animation objects\characters\elite\elite "combat:rifle:warn" 1 TRUE)
	(print "HL: 'Go get him, guys!'")
	(device_operates_automatically_set viewroom_exit01_bsp0 TRUE) 
	(device_operates_automatically_set viewroom_exit02_bsp0 TRUE) 
	(ai_set_orders bottling_heretics_05 bottling_h_wave_06)
	(sleep 30)
	(cs_face FALSE bottling_plant/p2)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_01/center) FALSE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location ledge_banshees_01/center))
	(cs_fly_to airspace/p0 5)
)

;oh dear lord is this temp (trying to animate a phantom on course)
(script dormant temp_phantom_course
	(ai_place allied_phantom_01)
	(objects_attach test_me center (ai_vehicle_get_from_starting_location allied_phantom_01/driver) phantom_large_cargo)
	(device_set_position test_me .035)
)

;Encounter in short hall between bottling plant and view room
(script dormant bottling_back_passage
	(ai_place heretic_leader_02)
	(object_cannot_take_damage (ai_actors heretic_leader_02))
	(cs_run_command_script heretic_leader_02 hl_retreat_01)
	(ai_place bottling_heretics_04)
	(cs_run_command_script bottling_heretics_04 heretics_back_passage)
	(sleep_until (= (volume_test_objects vol_hl_delete_02 (ai_actors heretic_leader_02)) TRUE))
	(ai_erase heretic_leader_02)
	(print "he's gone!")
)

;Seeing heretics fighting flood out on ledge
(script dormant bottling_overlook
	(ai_place ledge_banshees_01)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_01/center))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_01/left))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_01/right))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_01/center) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_01/left) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_01/right) TRUE)
	(ai_place bottling_heretics_05)
	(ai_place heretic_leader_03)
	(object_cannot_take_damage (ai_actors heretic_leader_03))
	(sleep_until (= (volume_test_objects vol_hl_delete_02 (players)) TRUE))
	(cs_run_command_script heretic_leader_03 hl_retreat_02)
	(sleep_until (= (volume_test_objects vol_hl_delete_03 (ai_actors heretic_leader_03)) TRUE))
	(ai_erase heretic_leader_03)
	(print "he's gone!")
)

;Staggers spawning of sentinels in bottling plant overlook
(script dormant bottling_overlook_reinforce
	(ai_place bottling_sentinels_03 1)
	(sleep 120)
	(ai_place bottling_sentinels_03 1)
	(sleep 120)
	(ai_place bottling_sentinels_03 1)
	(sleep 120)
	(ai_place bottling_sentinels_03 1)
)

(script dormant bring_in_da_phantom
	(sleep_until (OR (= (volume_test_objects vol_arm_01_return (players)) TRUE) (= (volume_test_objects vol_bottling_return_01r (players)) TRUE)))
	(wake temp_phantom_course)
)

;Overall script for second half of bottling plant, the first time through
(script dormant bottling_plant_end

	(sleep_until (= (volume_test_objects vol_bottling_mid03 (players)) TRUE))

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(wake bring_in_da_phantom)
	(wake bottling_back_passage)

	(sleep_until (= (volume_test_objects vol_bottling_back (players)) TRUE))
	(game_save)
	(wake bottling_overlook)

	(sleep_until (= (volume_test_objects vol_hl_delete_02 (players)) TRUE))

	(sleep_until (< (ai_living_count bottling_heretics_05) 2))
	(game_save)
	(wake bottling_overlook_reinforce)
)


;-------------------------------------------------------------------------------
;Banshee Dogfight 1

;Sets up a temporary nav beacon on your phantom
(script dormant temp_nav_beacon
	(activate_team_nav_point_object default_red player (list_get (ai_actors allied_phantom_01) 0) 0)
)

;Your phantom picks up any surviving allies from the first arm
(script dormant retrieve_allies
	(print "The Phantom picks up surviving allies...")
;	(ai_place_in_vehicle allies_elites_03 allied_phantom_01)
;	(ai_place_in_vehicle allies_grunts_03 allied_phantom_01)
;	(ai_vehicle_enter_immediate allies_grunts_03 (ai_vehicle_get_from_starting_location allied_phantom_01/driver) phantom_p)
;	(ai_vehicle_enter_immediate allies_elites_03 (ai_vehicle_get_from_starting_location allied_phantom_01/driver) phantom_p)
;	(ai_vehicle_enter_immediate allies_grunts_01 (ai_vehicle_get_from_starting_location allied_phantom_01/driver) phantom_p)
;	(ai_vehicle_enter_immediate allies_elites_01 (ai_vehicle_get_from_starting_location allied_phantom_01/driver) phantom_p)
)

;A pointless attempt at flying the phantom by command script
(script command_script phantom_path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by airspace/ph01 2) 
	(cs_fly_by airspace/ph02 2) 
	(cs_fly_by airspace/ph03 2) 
	(cs_fly_by airspace/ph04 2) 
	(cs_fly_by airspace/ph05 2) 
	(cs_fly_by airspace/ph06 2) 
	(cs_fly_by airspace/ph07 2) 
)

;Temp phantom path using device machine
(script dormant temp_phantom_path
	(device_set_position test_me 1)
)

;Overall script for the first banshee dogfight
(script dormant dogfight_firsttime_start
	(sleep_until (AND (= plummeting FALSE) (OR 
			(OR (= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (list_get (players) 0))) TRUE)
				(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (list_get (players) 0))) TRUE))
			(OR (= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (list_get (players) 1))) TRUE)
				(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (list_get (players) 1))) TRUE)))))


;	(ai_erase all_enemies)
	(garbage_collect_now)
	
	(device_operates_automatically_set rec_center_entry_ext TRUE)

	(game_save)
	(wake retrieve_allies)
	(wake temp_nav_beacon)
;	(cs_run_command_script allied_phantom_01 phantom_path)
	(wake temp_phantom_path)
	(ai_place dogfight01_cell_01)
	(ai_place allied_banshees)
	(ai_place dogfight01_turrets)
	(ai_place arm_02_lz_turrets)
	(ai_prefer_target (ai_actors allied_phantom_01) TRUE)
	
	(sleep_until
		(begin
			(ai_place dogfight01_cell_01 1)
			(sleep_until (OR (> (device_get_position test_me) .2) (< (ai_living_count dogfighters_01) 3)))
			(> (device_get_position test_me) .2)
		)
	)

	(ai_migrate dogfight01_cell_01 dogfight01_cell_02)
	(ai_set_orders allied_banshees dogfight01_cell_02)

	(sleep_until
		(begin
			(ai_place dogfight01_cell_02 1)
			(sleep_until (OR (> (device_get_position test_me) .29) (< (ai_living_count dogfighters_01) 3)))
			(> (device_get_position test_me) .29)
		)
	)

	(ai_migrate dogfight01_cell_02 dogfight01_cell_03)
	(ai_set_orders allied_banshees dogfight01_cell_03)

	(sleep_until
		(begin
			(ai_place dogfight01_cell_03 1)
			(sleep_until (OR (> (device_get_position test_me) .39) (< (ai_living_count dogfighters_01) 3)))
			(> (device_get_position test_me) .39)
		)
	)

	(ai_migrate dogfight01_cell_03 dogfight01_cell_04)
	(ai_set_orders allied_banshees dogfight01_cell_04)

	(sleep_until
		(begin
			(ai_place dogfight01_cell_04 1)
			(sleep_until (OR (> (device_get_position test_me) .53) (< (ai_living_count dogfighters_01) 3)))
			(> (device_get_position test_me) .53)
		)
	)

	(ai_migrate dogfight01_cell_04 dogfight01_cell_05)
	(ai_set_orders allied_banshees dogfight01_cell_05)

	(sleep_until
		(begin
			(ai_place dogfight01_cell_05 1)
			(sleep_until (OR (> (device_get_position test_me) .65) (< (ai_living_count dogfighters_01) 3)))
			(> (device_get_position test_me) .65)
		)
	)

	(ai_migrate dogfight01_cell_05 dogfight01_cell_06)
	(ai_set_orders allied_banshees dogfight01_cell_06)

	(sleep_until
		(begin
			(ai_place dogfight01_cell_06 1)
			(sleep_until (OR (> (device_get_position test_me) .7) (< (ai_living_count dogfighters_01) 3)))
			(> (device_get_position test_me) .7)
		)
	)

	(sleep_until (> (device_get_position test_me) .85))
	(ai_vehicle_exit allied_phantom_01 phantom_p)
	(ai_place allies_elites_03)
	(ai_place allies_grunts_03)
)

;Temp script to jump to dogfight
(script dormant phantom_time
	(ai_place ledge_banshees_01)
;	(ai_place allied_phantom_01)
	(wake temp_phantom_course)
	(sleep_until (= (device_get_position test_me) .035))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (list_get (players) 0))
)


;-------------------------------------------------------------------------------
;Arm 2 LZ

;Changes ally orders when a player is on the ground in the LZ
(script dormant arm_02_lz_order_change
	(sleep_until (OR 
		(AND (= (volume_test_object vol_arm_02_lz (list_get (players) 0)) TRUE) 
		(= (unit_in_vehicle (unit (list_get (players) 0))) FALSE))
		(AND (= (volume_test_object vol_arm_02_lz (list_get (players) 1)) TRUE) 
		(= (unit_in_vehicle (unit (list_get (players) 1))) FALSE))))
	(ai_set_orders allies_elites_03 allies_arm02_lz)
	(ai_set_orders allies_grunts_03 allies_arm02_lz)
)

;Overall script for the research arm LZ
(script dormant arm_02_lz_start
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_arm_02_lz (players)) TRUE)))

	(game_save)
	(wake arm_02_lz_order_change)
	(ai_place arm_02_lz_heretics)
)


;-------------------------------------------------------------------------------
;Arm 2 Entry

;Previews the juggernaut down below
(script dormant juggernaut_preview
	(ai_place disposal_entry_juggernaut)
	(object_cannot_take_damage (ai_actors disposal_entry_juggernaut))
	(ai_place disposal_entry_heretics)
;	(sleep_until (< (ai_living_count disposal_entry_heretics) 3))
;	(ai_set_orders disposal_entry_heretics jug_preview_02)
;	(sleep_until (= (ai_living_count disposal_entry_heretics) 0))
;	(ai_set_orders disposal_entry_juggernaut jug_preview_end)
;	(sleep_until (= (volume_test_objects vol_jug_preview_end (ai_actors disposal_entry_juggernaut)) TRUE))
;	(ai_erase disposal_entry_juggernaut)

;temp
	(sleep 60)
	(print "Heretics below fight something HUGE!")
	(sleep 60)
	(print "They die one by one!")
	(ai_kill disposal_entry_heretics/h1)
	(sleep 60)
	(ai_kill disposal_entry_heretics/h2)
	(sleep 60)
	(ai_kill disposal_entry_heretics/h3)
	(sleep 60)
	(ai_kill disposal_entry_heretics/h4)
	(sleep 60)
	(print "And then the creature disappears...")
	(ai_erase disposal_entry_juggernaut)
)

;Overall script for the research arm entry
(script dormant arm_02_entry_start
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_entering_research (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)

	(ai_set_orders arm02_allies allies_disposal)
	
;	(object_teleport (list_get (ai_actors allies_elites_03) 0) arm02_tp_elite)
;	(object_teleport (list_get (ai_actors allies_grunts_03) 0) arm02_tp_grunt01)
;	(object_teleport (list_get (ai_actors allies_grunts_03) 1) arm02_tp_grunt02)
	
	(deactivate_team_nav_point_object player (list_get (ai_actors allied_phantom_01) 0))
	(game_save)
	(wake juggernaut_preview)
)


;-------------------------------------------------------------------------------
;Disposal Chamber

;Wait this long before giving up on lagging allies
(global boolean ditch_initial_allies FALSE)
(script dormant initial_ally_delay
	(sleep 150)
	(set ditch_initial_allies TRUE)
)

;Some variables to manage my holodrone scene
(global boolean holo_drone_arrived FALSE)
(global boolean hl_done_talking FALSE)
(global boolean done_shooting_holo FALSE)

;Flying in a temp holo probe
(script command_script holo_drone_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot FALSE)
	(cs_fly_by disposal_chamber/p0)
;	(cs_fly_by disposal_chamber/p1)
;	(cs_fly_by disposal_chamber/p2)
;	(cs_fly_by disposal_chamber/p3)
;	(cs_fly_by disposal_chamber/p4)
	(cs_fly_to disposal_chamber/p5 .5)
	(set holo_drone_arrived TRUE)
	(sleep_forever)
)

;Your allies react to the massacre in this room
(script command_script corpse_react
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0010_se1 NONE 1)
;	(print "ELITE: 'What happened here?'")
)

;Your grunt allies shoot the hologram
(script command_script hologram_shoot
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0020_sg1 NONE 1)
;	(print "GRUNTS: 'see!!  Heretic!'")
	(cs_shoot TRUE (list_get (ai_actors hl_hologram) 0))
	(sleep 90)
	(cs_shoot FALSE (list_get (ai_actors hl_hologram) 0))
	(sleep 90)
	(set done_shooting_holo TRUE)
)

;Your elite buddy reacts to the hologram
(script command_script hologram_react
	(sleep 120)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0030_soc NONE 1)
;	(print "ELITE: 'Hold your fire!  Hold your fire!'")
)

;The hologram speaks!
(script command_script hologram_talk_01
	(cs_face_player TRUE)
	(sleep_until (OR (= (volume_test_objects vol_disposal_all (ai_actors allies_grunts_03)) FALSE) (= done_shooting_holo TRUE)))
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0040_her NONE 1)
;	(print "HL: 'I wondered who the Prophets would send to silence me.'")
;	(print "HL: 'A Dervish.  I'm flattered.'")
	(sleep_forever)
)

;Your elite buddy reacts to what the hologram just said
(script command_script holotalk_react_01
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0050_soc NONE 1)
;	(print "ELITE: 'He's using a holo-drone.'")
;	(print "ELITE: 'He must be close!'")
	(sleep 100)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0060_soc NONE 1)
;	(print "ELITE: 'Come out.  So we may kill you.'")
)

;The hologram reacts to the elite's response
(script command_script hologram_talk_02
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0070_her NONE 1)
	(custom_animation (unit (ai_get_object hl_hologram/HL)) objects\characters\elite\elite "combat:rifle:berserk" TRUE)
;	(print "HL: 'Ha, ha, ha, ha!'")
;	(print "HL: 'Get in line.'")
	(sleep 150)
	(set hl_done_talking TRUE)
	(sleep_forever)
)

;Script controlling in-game cinematic
(script static void heretic_leader_holo_scene
	(cs_run_command_script allies_elites_03 corpse_react)
	(ai_place holo_drone)
	(object_cannot_take_damage (ai_actors holo_drone))
	(cs_run_command_script holo_drone holo_drone_arrives)
	(sleep_until (= holo_drone_arrived TRUE) 30 450)
	(ai_erase holo_drone) 
	(ai_place hl_hologram)
	(object_cannot_take_damage (ai_actors hl_hologram))
	(cs_run_command_script hl_hologram long_pause)
	(if (= (volume_test_objects vol_disposal_all (ai_actors allies_grunts_03)) TRUE)
		(if (> (ai_living_count allies_grunts_03) 1)
			(begin
				(cs_run_command_script allies_grunts_03/grunt01 hologram_shoot)
				(if (= (volume_test_objects vol_disposal_all (ai_actors allies_elites_03)) TRUE)
					(cs_run_command_script allies_elites_03 hologram_react)
				)
			)
			(begin
				(cs_run_command_script allies_grunts_03 hologram_shoot)
				(if (= (volume_test_objects vol_disposal_all (ai_actors allies_elites_03)) TRUE)
					(cs_run_command_script allies_elites_03 hologram_react)
				)
			)
		)
	)
	(sleep_until (OR (= (volume_test_objects vol_disposal_all (ai_actors allies_grunts_03)) FALSE) (= done_shooting_holo TRUE)))
	(cs_run_command_script hl_hologram hologram_talk_01)
	(sleep 270)
	(if (= (volume_test_objects vol_disposal_all (ai_actors allies_elites_03)) TRUE)
		(begin
			(cs_run_command_script allies_elites_03 holotalk_react_01)
			(sleep 180)
			(cs_run_command_script hl_hologram hologram_talk_02)
			(sleep_until (= hl_done_talking TRUE))
		)
	)	
)

;---

;Fakes reanimation of the corpses by infection forms
(script static void fake_reanim
	(ai_place disposal_infection_01 1)
	(ai_magically_see_object disposal_infection_01 (list_get (players) 0))
	(sleep 60)
	(ai_place disposal_infection_01 1)
	(sleep 60)
	(ai_place disposal_infection_01 1)
	(sleep 60)
	(ai_place disposal_infection_01 1)

;	(sleep 300)

;	(object_destroy_containing "corpse")

;	(ai_place disposal_combatforms_01 1)
;	(sleep 30)
;	(ai_place disposal_combatforms_01 1)
;	(sleep 30)
;	(ai_place disposal_combatforms_01 1)
;	(sleep 30)
;	(ai_place disposal_combatforms_01 1)
;	(sleep 30)
;	(ai_place disposal_combatforms_01 1)
;	(sleep 30)
;	(ai_place disposal_combatforms_01 1)
;
	(sleep 120)
	(ai_place disposal_infection_02 1)
	(sleep 30)
	(ai_place disposal_infection_02 1)
)

;Ally reaction to flood
(script command_script flood_reaction
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0080_se1 NONE 1)
	(sleep 45)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0090_soc NONE 1)
)

;Overall script for the disposal chamber
(script dormant disposal_chamber_start
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_entering_research (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(ai_renew all_allies)

;	(object_create_containing "corpse")
	(ai_place disposal_combatforms_01)
	(ai_kill_silent disposal_combatforms_01)

;	(ai_dialogue_enable FALSE)

	(ai_allegiance sentinel covenant)
	(ai_allegiance covenant sentinel)
	(ai_allegiance heretic covenant)
	(ai_allegiance covenant heretic)
	(ai_allegiance player sentinel)
	(ai_allegiance player heretic)
	(sleep_until (= (volume_test_objects_all vol_disposal_bottom (players)) TRUE))
	(wake initial_ally_delay)
	(sleep_until (= (volume_test_objects_all vol_disposal_all (ai_actors arm02_allies)) TRUE) 30 300)

	(device_set_position disposal_entry_int 0)
	(device_set_position arm02_entry_int 0)

	(heretic_leader_holo_scene)

	(ai_erase hl_hologram)	
	(game_save)
	(sleep 60)
	(print "There's some scuttling in the walls...")
	(sleep 60)
	
	(if (> (ai_living_count arm02_allies) 0)
		(cs_run_command_script allies_elites_03 flood_reaction)
	)
	
;	(ai_dialogue_enable TRUE)

	(fake_reanim)
;	(sleep_until (> (ai_living_count disposal_combatforms_01) 0))
;	(sleep_until (= (ai_living_count disposal_combatforms_01) 0))
	(sleep_until (< (ai_strength disposal_infection_01) .25))
	(device_operates_automatically_set disposal_exit TRUE)
	(ai_allegiance_remove sentinel covenant)
	(ai_allegiance_remove covenant sentinel)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
	(ai_allegiance_remove player sentinel)
	(ai_allegiance_remove player heretic)
)


;-------------------------------------------------------------------------------
;Specimen Storage

;Controls the pausing of the elevator
(global boolean spec_elev_resume FALSE)

;Attaching elevator parts
(script dormant elev_construct
;	(device_set_position_immediate elev 1)
;	(object_create crane)
	(objects_attach elev center crane crane_center)
;	(object_create arm)
	(objects_attach crane crane_hinge arm arm_hinge)
;	(object_create tray01)
	(objects_attach elev tray01 tray01 can_exit)
;	(object_create tray02)
	(objects_attach elev tray02 tray02 can_exit)
;	(object_create tray03)
	(objects_attach elev tray03 tray03 can_exit)
;	(object_create tray04)
	(objects_attach elev tray04 tray04 can_exit)
;	(object_create tray05)
	(objects_attach elev tray05 tray05 can_exit)
;	(object_create tray06)
	(objects_attach elev tray06 tray06 can_exit)
;	(object_create tray07)
	(objects_attach elev tray07 tray07 can_exit)
;	(object_create tray08)
	(objects_attach elev tray08 tray08 can_exit)
;	(object_create tray09)
	(objects_attach elev tray09 tray09 can_exit)
;	(object_create tray10)
	(objects_attach elev tray10 tray10 can_exit)
;	(object_create can01)
;	(objects_attach tray04 can_exit can01 can_base)
;	(device_set_position_immediate tray04 .333)
;	(object_create can02)
;	(objects_attach tray06 can_exit can02 can_base)
;	(device_set_position_immediate tray06 .333)
;	(object_create can03)
;	(objects_attach tray10 can_exit can03 can_base)
;	(device_set_position_immediate tray10 .333)
;	(objects_detach tray04 can01)
;	(objects_detach tray06 can02)
;	(objects_detach tray10 can03)
)

;Moves the elevator and its associated parts
(script dormant elev_go
	
	(sleep_until (= spec_elev_resume TRUE))
	
	(device_set_position elev .25)
	(sleep_until (= (device_get_position elev) .25))
	
	(device_set_position crane 1)
	(sleep_until (= (device_get_position crane) 1) 30 120)
	(device_set_position arm .1)
	(sleep_until (= (device_get_position arm) .1) 30 300)
	(object_create can04)
	(objects_attach arm can_entry can04 can_base)
	(object_create can05)
	(objects_attach can04 can_top can05 can_base)
	(device_set_position arm .75)
	(sleep_until (= (device_get_position arm) .75) 30 300)
	(objects_detach arm can04)
	(objects_detach can04 can05)
	(objects_attach tray03 can_exit can05 can_base)
	(objects_attach can05 can_base can04 can_top)
	(device_set_position arm 1)
	(sleep_until (= (device_get_position arm) 1) 30 300)
	(device_set_position_immediate arm 0)
	(device_set_position tray03 .667)
	(sleep_until (= (device_get_position tray03) .667) 30 150)
	(objects_detach can05 can04)
	(objects_detach tray03 can05)
	
	(sleep_until (= spec_elev_resume TRUE))
	
	(device_set_position elev .65)
	(sleep_until (= (device_get_position elev) .65))
	
	(device_set_position crane 0)
	(sleep_until (= (device_get_position crane) 0) 30 120)
	(device_set_position arm .1)
	(sleep_until (= (device_get_position arm) .1) 30 300)
	(object_create can06)
	(objects_attach arm can_entry can06 can_base)
;	(object_create can05)
;	(objects_attach can04 can_top can05 can_base)
	(device_set_position arm .75)
	(sleep_until (= (device_get_position arm) .75) 30 300)
	(objects_detach arm can06)
;	(objects_detach can04 can05)
	(objects_attach tray07 can_exit can06 can_base)
;	(objects_attach can05 can_base can04 can_top)
	(device_set_position arm 1)
	(sleep_until (= (device_get_position arm) 1) 30 300)
	(device_set_position_immediate arm 0)
	(device_set_position tray07 .333)
	(sleep_until (= (device_get_position tray07) .333) 30 150)
	(objects_detach tray07 can06)

	(sleep_until (= spec_elev_resume TRUE))

	(device_set_position elev .9)
	(sleep_until (= (device_get_position elev) .9))

	(device_set_position crane .5)
	(sleep_until (= (device_get_position crane) .5) 30 120)
	(device_set_position arm .1)
	(sleep_until (= (device_get_position arm) .1) 30 300)
	(object_create can07)
	(objects_attach arm can_entry can07 can_base)
	(object_create can08)
	(objects_attach can07 can_top can08 can_base)
	(device_set_position arm .75)
	(sleep_until (= (device_get_position arm) .75) 30 300)
	(objects_detach arm can07)
	(objects_detach can07 can08)
	(objects_attach tray05 can_exit can08 can_base)
	(objects_attach can08 can_base can07 can_top)
	(device_set_position arm 1)
	(sleep_until (= (device_get_position arm) 1) 30 300)
	(device_set_position_immediate arm 0)
	(device_set_position tray05 .667)
	(sleep_until (= (device_get_position tray05) .667) 30 150)
	(objects_detach can08 can07)
	(objects_detach tray05 can08)

	(sleep_until (= spec_elev_resume TRUE))

	(device_set_position elev 1)
	(sleep_until (= (device_get_position elev) 1))
	
;	(device_set_position tray05 0)
;	(device_set_position tray07 0)
;	(device_set_position tray03 0)
;	(device_set_position tray04 0)
;	(device_set_position tray06 0)
;	(device_set_position tray10 0)
)

;Elevator start scripts
(script dormant spec_elev_start
	(wake elev_construct)
	(sleep_until (volume_test_objects vol_specimen_storage (players)))
	(wake elev_go)
)

;Variables to control hack sentinel emitters
(global boolean silo_emit_top_start FALSE)
(global boolean silo_emit_mid01_start FALSE)
(global boolean silo_emit_mid02_start FALSE)
(global boolean silo_emit_bot_start FALSE)

(global boolean silo_emit_now_top FALSE)
(global boolean silo_emit_now_mid01 FALSE)
(global boolean silo_emit_now_mid02 FALSE)
(global boolean silo_emit_now_bot FALSE)

(global boolean silo_emit_01_alive TRUE)
(global boolean silo_emit_02_alive TRUE)
(global boolean silo_emit_03_alive TRUE)
(global boolean silo_emit_04_alive TRUE)
(global boolean silo_emit_05_alive TRUE)
(global boolean silo_emit_06_alive TRUE)
(global boolean silo_emit_07_alive TRUE)
(global boolean silo_emit_08_alive TRUE)

;Randomly spawn sentinels at topmost level
(script static void random_silo_emit_top
	(begin_random
		(if (AND silo_emit_now_top silo_emit_01_alive)
			(begin
				(ai_place silo_sentinels_01)
				(set silo_emit_now_top FALSE)
			)
		)
		(if (AND silo_emit_now_top silo_emit_02_alive)
			(begin
				(ai_place silo_sentinels_02)
				(set silo_emit_now_top FALSE)
			)
		)
	)
)

;Randomly spawn sentinels at second topmost level
(script static void random_silo_emit_mid01
	(begin_random
		(if (AND silo_emit_now_mid01 silo_emit_03_alive)
			(begin
				(ai_place silo_sentinels_03)
				(set silo_emit_now_mid01 FALSE)
			)
		)
		(if (AND silo_emit_now_mid01 silo_emit_04_alive)
			(begin
				(ai_place silo_sentinels_04)
				(set silo_emit_now_mid01 FALSE)
			)
		)
	)
)

;Randomly spawn sentinels at second bottommost level
(script static void random_silo_emit_mid02
	(begin_random
		(if (AND silo_emit_now_mid02 silo_emit_05_alive)
			(begin
				(ai_place silo_sentinels_05)
				(set silo_emit_now_mid02 FALSE)
			)
		)
		(if (AND silo_emit_now_mid02 silo_emit_06_alive)
			(begin
				(ai_place silo_sentinels_06)
				(set silo_emit_now_mid02 FALSE)
			)
		)
	)
)

;Randomly spawn sentinels at bottommost level
(script static void random_silo_emit_bot
	(begin_random
		(if (AND silo_emit_now_bot silo_emit_07_alive)
			(begin
				(ai_place silo_sentinels_07)
				(set silo_emit_now_bot FALSE)
			)
		)
		(if (AND silo_emit_now_bot silo_emit_08_alive)
			(begin
				(ai_place silo_sentinels_08)
				(set silo_emit_now_bot FALSE)
			)
		)
	)
)

;Decides when to spawn at topmost level
(script continuous silo_emit_checker_top
	(sleep_until (= silo_emit_top_start TRUE))
	(if (< (ai_living_count silo_sentinels_top) 2)
		(begin
			(sleep_until 
				(begin
					(sleep sen_emitter_delay)
					(set silo_emit_now_top TRUE)
					(random_silo_emit_top)
					(> (ai_living_count silo_sentinels_top) 2)
				)
			)
		)
	)
	(sleep sen_emitter_delay)
)

;Decides when to spawn at second topmost level
(script continuous silo_emit_checker_mid01
	(sleep_until (= silo_emit_mid01_start TRUE))
	(if (< (ai_living_count silo_sentinels_mid01) 2)
		(begin
			(sleep_until 
				(begin
					(sleep sen_emitter_delay)
					(set silo_emit_now_mid01 TRUE)
					(random_silo_emit_mid01)
					(> (ai_living_count silo_sentinels_mid01) 2)
				)
			)
		)
	)
	(sleep sen_emitter_delay)
)

;Decides when to spawn at second bottommost level
(script continuous silo_emit_checker_mid02
	(sleep_until (= silo_emit_mid02_start TRUE))
	(if (< (ai_living_count silo_sentinels_mid02) 2)
		(begin
			(sleep_until 
				(begin
					(sleep sen_emitter_delay)
					(set silo_emit_now_mid02 TRUE)
					(random_silo_emit_mid02)
					(> (ai_living_count silo_sentinels_mid02) 2)
				)
			)
		)
	)
	(sleep sen_emitter_delay)
)

;Decides when to spawn at bottommost level
(script continuous silo_emit_checker_bot
	(sleep_until (= silo_emit_bot_start TRUE))
	(if (< (ai_living_count silo_sentinels_bot) 2)
		(begin
			(sleep_until 
				(begin
					(sleep sen_emitter_delay)
					(set silo_emit_now_bot TRUE)
					(random_silo_emit_bot)
					(> (ai_living_count silo_sentinels_bot) 2)
				)
			)
		)
	)
	(sleep sen_emitter_delay)
)

;Remove hack emitters when destroyed
(script dormant silo_emit_killer_01
	(sleep_until (= (object_get_health silo_emit_01) 0))
	(object_destroy silo_emit_01)
	(set silo_emit_01_alive FALSE)
)	
(script dormant silo_emit_killer_02
	(sleep_until (= (object_get_health silo_emit_02) 0))
	(object_destroy silo_emit_02)
	(set silo_emit_02_alive FALSE)
)	
(script dormant silo_emit_killer_03
	(sleep_until (= (object_get_health silo_emit_03) 0))
	(object_destroy silo_emit_03)
	(set silo_emit_03_alive FALSE)
)	
(script dormant silo_emit_killer_04
	(sleep_until (= (object_get_health silo_emit_04) 0))
	(object_destroy silo_emit_04)
	(set silo_emit_04_alive FALSE)
)	
(script dormant silo_emit_killer_05
	(sleep_until (= (object_get_health silo_emit_05) 0))
	(object_destroy silo_emit_05)
	(set silo_emit_05_alive FALSE)
)	
(script dormant silo_emit_killer_06
	(sleep_until (= (object_get_health silo_emit_06) 0))
	(object_destroy silo_emit_06)
	(set silo_emit_06_alive FALSE)
)	

(script dormant silo_emit_killer_07
	(sleep_until (= (object_get_health silo_emit_07) 0))
	(object_destroy silo_emit_07)
	(set silo_emit_07_alive FALSE)
)	
(script dormant silo_emit_killer_08
	(sleep_until (= (object_get_health silo_emit_08) 0))
	(object_destroy silo_emit_08)
	(set silo_emit_08_alive FALSE)
)	

;Keeps spawning flood in hall until you enter it
(script dormant silo_hall_flood_spawner
	(sleep_until 
		(begin
			(ai_place silo_flood_02 1)
			(sleep_until (OR (= (volume_test_objects vol_leaving_silo (players)) TRUE) (< (ai_living_count silo_flood_02) 2)))	
			(= (volume_test_objects vol_leaving_silo (players)) TRUE)
		)
	)
)

;Overall script for the specimen storage chamber
(script dormant silo_start
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_silo_enter (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)
	(ai_allegiance_remove sentinel covenant)
	(ai_allegiance_remove covenant sentinel)
	(ai_allegiance_remove heretic covenant)
	(ai_allegiance_remove covenant heretic)
	(ai_allegiance_remove player sentinel)
	(ai_allegiance_remove player heretic)

	(game_save)

	(ai_renew all_allies)
	(ai_set_orders arm02_allies allies_silo)

	(wake spec_elev_start)

	(ai_place silo_sentinels_initial)
	(set silo_emit_top_start TRUE)
	(wake silo_emit_killer_01)
	(wake silo_emit_killer_02)
	(wake silo_emit_killer_03)
	(wake silo_emit_killer_04)
	(wake silo_emit_killer_05)
	(wake silo_emit_killer_06)
	(wake silo_emit_killer_07)
	(wake silo_emit_killer_08)

	(ai_place silo_flood_01)
	(sleep_until (AND (= (ai_living_count silo_flood_01) 0) (= (volume_test_objects vol_specimen_storage (players)) TRUE)))
	(sleep 60)
	(set spec_elev_resume TRUE)
	(ai_migrate silo_sentinels_top silo_sentinels_mid01)
	(game_save)
	
	(sleep_until (> (device_get_position elev) .2))
	(set silo_emit_mid01_start TRUE)
	(set silo_emit_top_start FALSE)
	(ai_place silo_flood_01)
	(sleep_until (AND (= (ai_living_count silo_flood_01) 0) (= (volume_test_objects vol_specimen_storage (players)) TRUE)))
	(sleep 60)
	(set spec_elev_resume TRUE)
	(ai_migrate silo_sentinels_mid01 silo_sentinels_mid02)
	(game_save)
	
	(sleep_until (> (device_get_position elev) .6))
	(set silo_emit_mid02_start TRUE)
	(set silo_emit_mid01_start FALSE)
	(ai_place silo_flood_01)
	(sleep_until (AND (= (ai_living_count silo_flood_01) 0) (= (volume_test_objects vol_specimen_storage (players)) TRUE)))
	(sleep 60)
	(set spec_elev_resume TRUE)
	(ai_migrate silo_sentinels_mid02 silo_sentinels_bot)
	(game_save)

	(sleep_until (> (device_get_position elev) .85))
	(set silo_emit_bot_start TRUE)
	(set silo_emit_mid02_start FALSE)
	(ai_place silo_flood_01)
	(sleep_until (AND (= (ai_living_count silo_flood_01) 0) (= (volume_test_objects vol_specimen_storage (players)) TRUE)))
	(sleep 60)
	(set spec_elev_resume TRUE)
	(ai_set_orders silo_sentinels_bot silo_s_wave_05)
	(game_save)

	(sleep_until (> (device_get_position elev) .9))
	(ai_place silo_flood_02)
	(wake silo_hall_flood_spawner)
	(set silo_emit_bot_start FALSE)
	(ai_set_orders silo_flood_01 silo_all)
)


;-------------------------------------------------------------------------------
;Corridor to Flood Lab

;Overall script for the halls leading to the lab
(script dormant to_flood_lab
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_hall_to_lab (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(ai_renew all_allies)
	(ai_set_orders arm02_allies allies_lab_upper)
)


;-------------------------------------------------------------------------------
;Flood Lab

;
(script dormant flood_lab_start
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_lab_enter (players)) TRUE)))
	(set silo_emit_bot_start FALSE)

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(ai_place lab_heretics_01)
	(ai_place lab_combatforms_01)
	(ai_place lab_carriers_01)
	(ai_place lab_infection_01)
	(ai_place lab_infection_02)
	(sleep_until (= (volume_test_objects vol_lab_floor (players)) TRUE))
	(ai_set_orders arm02_allies allies_lab_lower)
	(sleep_until (AND (AND (= (ai_living_count lab_flood) 0) (= (ai_living_count lab_heretics) 0)) 
				(= (volume_test_objects vol_lab_floor (players)) TRUE)) 30 4000)
	(ai_place lab_heretics_above)
	(sleep_until (= (objects_can_see_object (players) (list_get (ai_actors lab_heretics_above) 0) 40) TRUE) 30 1800)
	(sleep 60)
	(ai_place lab_juggernaut_above)
	
	(print "A Juggernaut attacks the heretics above!")
	(sleep 60)
	(print "They die one by one!")
	(ai_kill lab_heretics_above/h1)
	(sleep 60)
	(ai_kill lab_heretics_above/h2)
	(sleep 60)
	(ai_kill lab_heretics_above/h3)
	(sleep 60)
	(ai_kill lab_heretics_above/h4)
	(sleep 60)
	(print "And then the Juggernaut attacks you!")
	(sleep 60)

	(sleep_until (= (ai_living_count lab_heretics_above) 0))
	(sleep 60)

	(print "More Flood appear as you fight...")
	(ai_place lab_combatforms_02)
	(ai_place lab_carriers_02)
	(ai_place lab_infection_02)
	(sleep_until (< (ai_living_count lab_flood) 3) 30 4000)
	
;	(sleep_until (< (ai_strength lab_juggernaut_above) .5))
	(print "And you're still fighting the Juggernaut...")
	(ai_place lab_combatforms_02)
	(ai_place lab_carriers_02)
	(ai_place lab_infection_02)
	
	(sleep_until (< (ai_living_count lab_flood) 3) 30 4000)
	(print "And now it's dead.  Wheee!")
	(ai_erase lab_juggernaut_above)
	
	(sleep_until (= (ai_living_count lab_flood) 0) 30 4000)
	(device_operates_automatically_set lab_exit_int TRUE)
	(device_operates_automatically_set lab_exit_ext TRUE)
	(ai_place lab_heretics_02)
)	

;-------------------------------------------------------------------------------
;Bridge

(script command_script banshee_bridge_strafe
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by airspace2/b01 2) 
	(cs_fly_by airspace2/b02 2) 
	(cs_fly_by airspace2/b03 2)
;	(cs_shoot TRUE (list_get (players) 0))
;	(sleep 30)
;	(cs_fly_by airspace2/b04 2)
;	(cs_fly_by airspace2/b05 2)
)

(script static void bridge_flood_spawn
	(begin_random
		(if (< (ai_living_count bridge_flood) 6)
			(ai_place bridge_combatforms (- (random_range 0 6) (ai_living_count bridge_flood)))
		)
		(if (< (ai_living_count bridge_flood) 6)
			(ai_place bridge_carriers (- (random_range 0 6) (ai_living_count bridge_flood)))
		)
	)
)

(global boolean bridge_final_gone FALSE)

(script dormant wraparound_right
	(sleep_until (AND (= bridge_final_gone FALSE) (= (volume_test_objects vol_wrap_right_01 (players)) TRUE)))
	(ai_place bridge_heretics_R_01)
	(bridge_flood_spawn)
	(sleep_until (AND (= bridge_final_gone FALSE) (= (volume_test_objects vol_wrap_right_03 (players)) TRUE)))
	(ai_place bridge_heretics_R_02)
	(bridge_flood_spawn)
	(sleep_until (AND (= bridge_final_gone FALSE) (= (volume_test_objects vol_wrap_final (players)) TRUE)))
	(set bridge_final_gone TRUE)
	(ai_place bridge_heretics_final)
)

(script dormant wraparound_left
	(sleep_until (AND (= bridge_final_gone FALSE) (= (volume_test_objects vol_wrap_left_01 (players)) TRUE)))
	(ai_place bridge_heretics_L_01)
	(bridge_flood_spawn)
	(sleep_until (AND (= bridge_final_gone FALSE) (= (volume_test_objects vol_wrap_left_03 (players)) TRUE)))
	(ai_place bridge_heretics_L_02)
	(bridge_flood_spawn)
	(sleep_until (AND (= bridge_final_gone FALSE) (= (volume_test_objects vol_wrap_final (players)) TRUE)))
	(set bridge_final_gone TRUE)
	(ai_place bridge_heretics_final)
)

(script dormant phantom_pilot_bitching
	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\mission\l04_0100_elp NONE 1 radio_default)
;	(print "PHANTOM PILOT: 'Leader! The storm is about to hit!'")
;	(print "PHANTOM PILOT: 'We cannot maintain our position!'")
	(sleep 150)
	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\mission\l04_0110_soc NONE 1 radio_default)
)

(script dormant bridge_start
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_reach_bridge (players)) TRUE)))
	
	(garbage_collect_now)
	(game_save)

	(ai_place bridge_runners)
	(ai_place bridge_infection)
		
;	(sleep_until (= (volume_test_objects vol_on_bridge (players)) TRUE))
;	(ai_place bridge_strafer)
;	(cs_run_command_script bridge_strafer banshee_bridge_strafe)
;	(ai_place allied_phantom_02)
;	(vehicle_hover (ai_vehicle_get_from_starting_location allied_phantom_02/driver) TRUE)
;	(ai_place_in_vehicle allies_elites_03 allied_phantom_02) 
;	(ai_place_in_vehicle allies_grunts_03 allied_phantom_02)
;	(sleep 60)
;	(ai_vehicle_exit allies_elites_03) 
;	(ai_vehicle_exit allies_grunts_03) 

	(device_operates_automatically_set control_room_ext TRUE)

	(sleep_until (= (volume_test_objects vol_on_bridge (players)) TRUE))

;	(ai_erase all_enemies)
	(garbage_collect_now)
	(game_save)
	
	(wake wraparound_right)
	(wake wraparound_left)
	(wake phantom_pilot_bitching)
	(ai_renew all_allies)
	(sleep 150)
	(ai_place allied_phantom_02)
	(sleep 30)
	(ai_place allies_elites_04)
	(ai_place allies_grunts_04)
	(ai_migrate allies_elites_03 allies_elites_04)
	(ai_migrate allies_grunts_03 allies_grunts_04)
)


;-------------------------------------------------------------------------------
;Control Room

;Scripts heretic leader to run into shelter foyer and lower shield
(script command_script heretic_leader_holes_up
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(cs_go_to control_room/p0)
	(cs_face_player TRUE)
	(cs_look_player TRUE)
;	(cs_aim_player TRUE)
	(device_set_position shield 0)
	(sleep_forever)
)

;Spec-ops boys' parting dialogue
(script command_script spec_op_farewell_01
	(sleep 240)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0150_se1 NONE 1)
)
(script command_script spec_op_farewell_02
	(sleep 330)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0160_se2 NONE 1)
)

(script command_script spec_op_comm_farewell
	(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0120_soc NONE 1)
	(sleep 450)
	(if (OR (unit_has_weapon (unit (list_get (players) 0)) "objects\weapons\melee\energy_blade\energy_blade") 
		(unit_has_weapon (unit (list_get (players) 1)) "objects\weapons\melee\energy_blade\energy_blade"))
		(begin
			(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0140_soc NONE 1)
		)
		(begin
			(sound_impulse_start sound\dialog\levels\04_gasgiant\mission\l04_0130_soc NONE 1)
		)
	)
)

(script dormant control_room_start
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_control_enter (players)) TRUE)))

	(device_set_power control_up_switch_01 0)
	(device_operates_automatically_set lab_exit_ext FALSE)
	(device_set_position_immediate shield 1)

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)

	(ai_renew all_allies)
	(ai_set_orders core_allies allies_control)
	(ai_place heretic_leader_control)
	(object_cannot_take_damage (ai_actors heretic_leader_control))
	(cs_run_command_script heretic_leader_control heretic_leader_holes_up)

	(device_operates_automatically_set control_bot_spawnroom TRUE)
	(ai_place control_flood_wave_01)
	(ai_place control_sentinels_wave_01)

	(sleep_until 
		;(AND 
		;		(AND (= (objects_can_see_object (players) control_shield_door 40) TRUE) (= (volume_test_objects vol_near_shield (players)) TRUE))
				(AND (= (ai_living_count control_flood_wave_01) 0) (= (ai_living_count control_sentinels_wave_01) 0))
		;)
	)

	(cinematic_fade_to_white)

	(device_set_position_immediate shield 1)
	(ai_erase heretic_leader_control)
	(object_teleport (player0) player0_hide)
	(object_teleport (player1) player1_hide)
	
	(if (cinematic_skip_start)
		(begin
			(C04_intra1)
		)
	)
	(cinematic_skip_stop)

	(object_teleport (player0) player0_control)
	(object_teleport (player1) player1_control)
	(device_set_position_immediate control_shield_door 0)
	(ai_place control_elites_cinematic)
	(ai_place control_commander_cinematic)
	(object_cannot_take_damage (ai_actors control_commander_cinematic))
	(ai_set_orders core_allies allies_wraparound)
	
	(device_set_power control_up_switch_01 1)

	(cinematic_fade_from_white)

	(cs_run_command_script control_commander_cinematic/spec_ops_comm spec_op_comm_farewell)
	(cs_run_command_script control_elites_cinematic/elite01 spec_op_farewell_01)
	(cs_run_command_script control_elites_cinematic/elite02 spec_op_farewell_02)

	(game_save)
	(ai_place control_infection)
	(sleep 600)
;	(device_operates_automatically_set control_bot_spawnroom TRUE)
	(ai_place control_flood_wave_01)
	(sleep_until (= (volume_test_objects vol_control_middle (players)) TRUE))
	(ai_place control_flood_wave_02_combat)
	(ai_place control_flood_wave_02_carriers)
	(sleep_until (= (volume_test_objects vol_control_perimeter (players)) TRUE))
	(ai_place control_flood_wave_03)
	(ai_place control_sentinels_wave_03)
)


;-------------------------------------------------------------------------------
;Cable Room

(script static void cam_shake
	(player_effect_set_max_rotation 0 2 2)
	(player_effect_start .5 0)
	(player_effect_stop 1.5)
)

(global short cable_var 0)

(script dormant cable_01
	(sleep_until (= (object_get_health cable01) 0))
	(set cable_var (+ cable_var 1))
	(if (< cable_var 3)
		(begin
			(cam_shake)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
		)
		(begin
			(cam_shake)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_two "none" 1)
			(sleep 450)
			(sound_looping_start sound\ambience\alphagasgiant\interior_implode\interior_implode "none" 1)
		)
	)
)

(script dormant cable_02
	(sleep_until (= (object_get_health cable02) 0))
	(set cable_var (+ cable_var 1))
	(if (< cable_var 3)
		(begin
			(cam_shake)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
		)
		(begin
			(cam_shake)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_two "none" 1)
			(sleep 450)
			(sound_looping_start sound\ambience\alphagasgiant\interior_implode\interior_implode "none" 1)
		)
	)
)

(script dormant cable_03
	(sleep_until (= (object_get_health cable03) 0))
	(set cable_var (+ cable_var 1))
	(if (< cable_var 3)
		(begin
			(cam_shake)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
		)
		(begin
			(cam_shake)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_two "none" 1)
			(sleep 450)
			(sound_looping_start sound\ambience\alphagasgiant\interior_implode\interior_implode "none" 1)
		)
	)
)

(script dormant cable_end_01
	(sleep_until
		(begin
			(if (< (ai_living_count cable_enders_01) 3)
				(ai_place cable_room_combatforms_01 (- (random_range 0 3) (ai_living_count cable_enders_01)))
			)
;			(if (< (ai_living_count cable_enders_01) 3)
;				(ai_place cable_room_infection_01 (- (random_range 0 3) (ai_living_count cable_enders_01)))
;			)			
			(= (object_get_health cable01) 0)
		)
	)
)

(script dormant cable_end_02
	(sleep_until
		(begin
			(if (< (ai_living_count cable_enders_02) 3)
				(ai_place cable_room_combatforms_02 (- (random_range 0 3) (ai_living_count cable_enders_02)))
			)
;			(if (< (ai_living_count cable_enders_02) 3)
;				(ai_place cable_room_infection_02 (- (random_range 0 3) (ai_living_count cable_enders_02)))
;			)			
			(= (object_get_health cable02) 0)
		)
	)
)

(script dormant cable_end_03
	(sleep_until
		(begin
			(if (< (ai_living_count cable_enders_03) 3)
				(ai_place cable_room_combatforms_03 (- (random_range 0 3) (ai_living_count cable_enders_03)))
			)
;			(if (< (ai_living_count cable_enders_03) 3)
;				(ai_place cable_room_infection_03 (- (random_range 0 3) (ai_living_count cable_enders_03)))
;			)			
			(= (object_get_health cable03) 0)
		)
	)
)

(script continuous cable_sentinel_spawner
	(sleep_until (= in_cable_room TRUE))
	(sleep_until (AND (< (ai_living_count cable_room_sentinels) 3) (= (volume_test_objects vol_cable_room_all (players)) TRUE)))
	(ai_place cable_room_sentinels)
)

(script dormant cable_room_start
;	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_going_down (players)) TRUE)))
;	(switch_bsp 4)
	(sleep_until (AND (= plummeting FALSE) (= (volume_test_objects vol_cableroom_center (players)) TRUE)))
	
	(wake cableroom_pit_killer_player0)
	(if (= (list_count (players)) 2)
		(wake cableroom_pit_killer_player1)
	)
	(device_set_power control_up_switch_02 0)
	(set in_cable_room TRUE)
	
	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\mission\l04_0170_soc NONE 1 radio_default)

;	(ai_erase all_enemies)
	(garbage_collect_now)
	
	(game_save)
	(wake cable_01)
	(wake cable_02)
	(wake cable_03)
	(wake cable_end_01)
	(wake cable_end_02)
	(wake cable_end_03)
;	(ai_place cable_room_combatforms_01)
;	(ai_place cable_room_combatforms_03)
;	(ai_place cable_room_carriers_02)
	(ai_place cable_room_heretics_01)
	(ai_place cable_room_heretics_02)
	(ai_place cable_room_heretics_03)
	(sleep_until (AND (= (object_get_health cable01) 0)
			(AND (= (object_get_health cable02) 0) (= (object_get_health cable03) 0))))
	(sleep_forever cable_sentinel_spawner)
	(set plummeting TRUE)
	(device_set_power control_up_switch_02 1)
	
	(game_save)

	(sleep_until (= (volume_test_objects vol_going_down (players)) TRUE))

	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\mission\l04_0180_soc NONE 1 radio_default)

	(device_set_power control_up_switch_01 0)
	(set in_cable_room FALSE)
)

;-------------------------------------------------------------------------------
;Control Room Return

(script dormant cable_room_return
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_control_return (players)) TRUE)))
	(device_set_position control_shield_door 1)

	(sleep_forever cableroom_pit_killer_player0)
	(if (= (list_count (players)) 2)
		(sleep_forever cableroom_pit_killer_player1)
	)
	
	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\mission\l04_0190_soc NONE 1 radio_default)

;	(ai_erase all_enemies)
	(garbage_collect_now)
	(game_save)
	
	(device_operates_automatically_set control_room_ext FALSE)
;	(device_operates_automatically_set control_room_int FALSE)
	
	(ai_place control_return_sentinels_01)
	(sleep_until (= (volume_test_objects vol_control_return_perimeter (players)) TRUE))
	(ai_place control_return_heretics_02)
	(sleep 90)
	(ai_place control_return_flood_02)
	(sleep_until (= (volume_test_objects vol_control_middle (players)) TRUE))
	(ai_place control_return_sentinels_03)
	(ai_migrate control_return_sentinels_01 control_return_sentinels_03)
	(ai_place control_return_heretics_04)
	(device_set_position elev_control_down 1)
	(device_set_power control_down_switch_01 1)
	(device_set_power control_down_switch_02 1)
	(device_operates_automatically_set control_bot_spawnroom TRUE)
	(ai_place control_return_flood_04)
)	

;-------------------------------------------------------------------------------
;Power Core

(script command_script hl_retreat_04
	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_look_player TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location ledge_banshees_02/center))
	(cs_fly_to airspace3/p0 1)
)

(script dormant power_core_start
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_power_core_enter (players)) TRUE)))
	(device_operates_automatically_set hl_ledge_ext TRUE)

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(ai_place power_core_sentinels_01)
	(ai_place power_core_heretics_01)
	(sleep_until (OR (< (ai_strength power_core_heretics_01) .25) (= (volume_test_objects vol_power_core_midway (players)) TRUE)))
	(ai_place power_core_heretics_02)
	(ai_migrate power_core_heretics_01 power_core_heretics_02)
	(ai_place power_core_combatforms_02)
	(ai_place power_core_carriers_02)
	(sleep_until (OR (< (ai_strength power_core_heretics_02) .25) (= (volume_test_objects vol_power_core_bottom (players)) TRUE)))
	(ai_place power_core_heretics_03)
	(ai_migrate power_core_heretics_02 power_core_heretics_03)
	(ai_place power_core_sentinels_03)
	(ai_migrate power_core_sentinels_01 power_core_sentinels_03)
	(sleep_until (= (volume_test_objects vol_power_core_exit (players)) TRUE))
	(ai_place ledge_banshees_02)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_02/center))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_02/left))
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_02/right))
;	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_02/center) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_02/left) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_02/right) TRUE)
	(ai_place heretic_leader_04)
	(object_cannot_take_damage (ai_actors heretic_leader_04))
	(cs_run_command_script heretic_leader_04 hl_retreat_04)
	(sleep_until (= (volume_test_objects vol_arm_01_return (ai_actors heretic_leader_04)) TRUE))
	(ai_erase heretic_leader_04)
	(print "he's gone!")
)

;-------------------------------------------------------------------------------
;Banshee Dogfight 2

;Kills player if he falls out of banshee
(script dormant banshee_killer_00
	(sleep_until (= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d" (unit (list_get (players) 0))) FALSE))
	(unit_kill (unit (list_get (players) 0)))
)
(script dormant banshee_killer_01
	(sleep_until (= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_02/left) "banshee_d" (unit (list_get (players) 1))) FALSE))
	(unit_kill (unit (list_get (players) 1)))
)

;Slam the player into a banshee and reverse gravity!
(script dormant banshee_slam
	(if (= (list_count (players)) 2)
		(begin
			(vehicle_load_magic (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d" (list_get (players) 0))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location ledge_banshees_02/left) "banshee_d" (list_get (players) 1))
			(sleep 60)
			(physics_set_gravity -2)
			(wake banshee_killer_00)
			(wake banshee_killer_01)
		)
		(begin
			(vehicle_load_magic (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d" (list_get (players) 0))
			(sleep 60)
			(physics_set_gravity -2)			
			(wake banshee_killer_00)
		)
	)
)

(script dormant dogfight_secondtime_start
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_power_core_ledge (players)) TRUE)))
	(sound_looping_stop sound\ambience\alphagasgiant\interior_implode\interior_implode)
	(sound_looping_start sound\ambience\alphagasgiant\falling_exterior\falling_exterior NONE 1)

	(device_operates_automatically_set control_room_ext FALSE)
	(device_operates_automatically_set rec_center_entry_ext FALSE)
	(device_operates_automatically_set lab_exit_ext FALSE)
	(device_operates_automatically_set arm_02_entry_ext FALSE)
	(device_operates_automatically_set banshee_ledge_access_01 FALSE)
	(device_operates_automatically_set banshee_ledge_access_02 FALSE)

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(wake banshee_slam)
	(ai_place dogfighters_finale)
	(activate_team_nav_point_object default_red player banshee_ledge_access_01 0)
)

;-------------------------------------------------------------------------------
;Bottling Plant Return

(script dormant banshee_unslam
	(if (= (list_count (players)) 2)
		(begin
			(sleep_forever banshee_killer_00)
			(sleep_forever banshee_killer_01)
			(vehicle_unload (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d")
			(vehicle_unload (ai_vehicle_get_from_starting_location ledge_banshees_02/left) "banshee_d")
			(object_teleport (player0) bottling_return_player0)
			(object_teleport (player1) bottling_return_player1)
			(physics_set_gravity 1)
			
		)
		(begin
			(sleep_forever banshee_killer_00)
			(vehicle_unload (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d")
			(object_teleport (player0) bottling_return_player0)
			(physics_set_gravity 1)
		)
	)
)

(script dormant bottling_return_s_respawner
	(sleep_until (< (ai_strength bottling_return_sentinels_03) .25))
	(ai_place bottling_return_sentinels_04)
)

(script dormant bottling_return_cf_respawner
	(sleep_until (< (ai_strength bottling_return_combatforms_03) .25))
	(ai_place bottling_return_combatforms_04)
)

(script dormant bottling_return_ca_respawner
	(sleep_until (< (ai_strength bottling_return_carriers_03) .25))
	(ai_place bottling_return_carriers_04)
)

(script dormant bottling_return_banshee_end
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_arm_01_return (players)) TRUE)))
	(wake banshee_unslam)
	(deactivate_team_nav_point_object player banshee_ledge_access_01)
)

(script dormant bottling_secondtime_start
	(wake bottling_return_banshee_end)
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_bottling_return_01r (players)) TRUE)))
	(sound_looping_start sound\ambience\alphagasgiant\interior_implode\interior_implode NONE 1)
	(sound_looping_stop sound\ambience\alphagasgiant\falling_exterior\falling_exterior)

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)
	(ai_place bottling_return_sentinels_01)
	(ai_place bottling_return_flood_01)
	(sleep_until (OR (< (ai_strength bottling_return_flood_01) .25) (= (volume_test_objects vol_bottling_return_02 (players)) TRUE)))
	(ai_place bottling_return_combatforms_02)
	(ai_place bottling_return_carriers_02)
	(sleep_until (= (volume_test_objects vol_bottling_mid03 (players)) TRUE))
	(ai_place bottling_return_sentinels_03)
	(ai_place bottling_return_combatforms_03)
	(ai_place bottling_return_carriers_03)
	(wake bottling_return_s_respawner)
	(wake bottling_return_cf_respawner)
	(wake bottling_return_ca_respawner)
)

;-------------------------------------------------------------------------------
;Corridors to Under Hangar Return

(script dormant bottling_to_under_spawner_01
	(sleep_until 
		(begin
			(ai_place second_hall_flood_01 1)
			(sleep_until (OR (= (volume_test_objects vol_2nd_hall_02 (players)) TRUE) (< (ai_living_count second_hall_flood_01) 2)))	
			(= (volume_test_objects vol_2nd_hall_02 (players)) TRUE)
		)
	)
)

(script dormant bottling_to_under_spawner_02
	(sleep_until 
		(begin
			(ai_place second_hall_flood_02 1)
			(sleep_until (OR (= (volume_test_objects vol_2nd_hall_01 (players)) TRUE) (< (ai_living_count second_hall_flood_02) 2)))	
			(= (volume_test_objects vol_2nd_hall_01 (players)) TRUE)
		)
	)
)

(script dormant bottling_to_under_spawner_03
	(sleep_until 
		(begin
			(ai_place second_hall_flood_03 1)
			(sleep_until (OR (= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE) (< (ai_living_count second_hall_flood_03) 2)))	
			(= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE)
		)
	)
)

(script dormant to_underhangar_secondtime
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_bottling_enter (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)
	(game_save)
	
	(wake bottling_to_under_spawner_01)
	(sleep_until (= (volume_test_objects vol_2nd_hall_02 (players)) TRUE))
	(wake bottling_to_under_spawner_02)
	(sleep_until (= (volume_test_objects vol_2nd_hall_01 (players)) TRUE))
	(wake bottling_to_under_spawner_03)
)

;-------------------------------------------------------------------------------
;Under Hangar Return

(script dormant underhangar_secondtime_start
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)
	(game_save)
	
	(set underhangar_emit_start TRUE)
	(ai_place underhangar_return_flood_01)
	(sleep_until (= (volume_test_objects vol_underhangar_return_01 (players)) TRUE))
	(ai_place underhangar_return_flood_02)
	(sleep_until (= (volume_test_objects vol_underhangar_return_02 (players)) TRUE))
	(ai_place underhangar_return_flood_03)
)

;-------------------------------------------------------------------------------
;Corridors to Hangar Return

(script dormant to_hangar_secondtime
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_underhangar_from_top (players)) TRUE)))

;	(ai_erase all_enemies)
	(garbage_collect_now)
	(game_save)
	
	(ai_place first_hall_flood_01 4)

)

;-------------------------------------------------------------------------------
;Hangar Return Boss Battle

(global boolean boss_fight_begin FALSE)
(global boolean more_hl_orders FALSE)
(global boolean more_holo1_orders FALSE)
(global boolean more_holo2_orders FALSE)
(global boolean hl_holo1_alive TRUE)
(global boolean hl_holo2_alive TRUE)
(global object heretic_leader none)

(script static void heretic_leader_reposition
	(begin_random
		(if (= more_hl_orders TRUE)
			(begin
				(ai_set_orders boss_fight_heretic_leader boss_fight_hl_center)
				(set more_hl_orders FALSE)
			)
		)
		(if (= more_hl_orders TRUE)
			(begin
				(ai_set_orders boss_fight_heretic_leader boss_fight_hl_left)
				(set more_hl_orders FALSE)
			)
		)
		(if (= more_hl_orders TRUE)
			(begin
				(ai_set_orders boss_fight_heretic_leader boss_fight_hl_right)
				(set more_hl_orders FALSE)
			)
		)
		(if (= more_holo1_orders TRUE)
			(begin
				(ai_set_orders boss_fight_hl_hologram_01 boss_fight_hl_center)
				(set more_holo1_orders FALSE)
			)
		)
		(if (= more_holo1_orders TRUE)
			(begin
				(ai_set_orders boss_fight_hl_hologram_01 boss_fight_hl_left)
				(set more_holo1_orders FALSE)
			)
		)
		(if (= more_holo1_orders TRUE)
			(begin
				(ai_set_orders boss_fight_hl_hologram_01 boss_fight_hl_right)
				(set more_holo1_orders FALSE)
			)
		)
		(if (= more_holo2_orders TRUE)
			(begin
				(ai_set_orders boss_fight_hl_hologram_02 boss_fight_hl_center)
				(set more_holo2_orders FALSE)
			)
		)
		(if (= more_holo2_orders TRUE)
			(begin
				(ai_set_orders boss_fight_hl_hologram_02 boss_fight_hl_left)
				(set more_holo2_orders FALSE)
			)
		)
		(if (= more_holo2_orders TRUE)
			(begin
				(ai_set_orders boss_fight_hl_hologram_02 boss_fight_hl_right)
				(set more_holo2_orders FALSE)
			)
		)
	)
)

(script continuous heretic_leader_order_switcher
	(sleep_until (= boss_fight_begin TRUE))
	(set more_hl_orders TRUE)
	(heretic_leader_reposition)
	(sleep 150)
	(set more_holo1_orders TRUE)
	(heretic_leader_reposition)
	(sleep 150)
	(set more_holo2_orders TRUE)
	(heretic_leader_reposition)
	(sleep 150)
)

(script continuous boss_fight_end_checker
	(sleep_until (= boss_fight_begin TRUE))
		
	(if (AND hl_holo1_alive (= (ai_living_count boss_fight_hl_hologram_01) 0))
		(begin
			(print "You merely killed a hologram...")
			(set hl_holo1_alive FALSE)
		)
	)
	(if (AND hl_holo2_alive (= (ai_living_count boss_fight_hl_hologram_02) 0))
		(begin
			(print "You merely killed a hologram...")
			(set hl_holo2_alive FALSE)
		)
	)
	(if (= (ai_living_count boss_fight_heretic_leader) 0)
		(begin
			(set boss_fight_begin FALSE)
			(ai_erase boss_fight_hl_hologram_01)
			(ai_erase boss_fight_hl_hologram_02)
			(sleep 60)
			
			(cinematic_fade_to_white)
			
			(object_teleport (player0) player0_hide)
			(object_teleport (player1) player1_hide)
			
			(object_destroy heretic_leader)
			(ai_erase monitor)
			
			(if (cinematic_skip_start)
				(begin
					(C04_outro2)
				)
			)
			(cinematic_skip_stop)

			(game_won)

;			(print "You killed the heretic leader!")
;			(sleep 60)
;			(print "You're awesome!")
;			(sleep 60)
;			(print "Everybody likes you!")
		)
	)
)

(script continuous boss_fight_cf_respawner
	(sleep_until (= boss_fight_begin TRUE))
	(sleep_until (< (ai_living_count boss_fight_combatforms) 3))
	(sleep_until (= boss_fight_begin TRUE))
	(ai_place boss_fight_combatforms 2)
)

(script continuous boss_fight_ca_respawner
	(sleep_until (= boss_fight_begin TRUE))
	(sleep_until (< (ai_living_count boss_fight_carriers) 3))
	(sleep_until (= boss_fight_begin TRUE))
	(ai_place boss_fight_carriers 2)
)

(script continuous boss_fight_s_respawner
	(sleep_until (= boss_fight_begin TRUE))
	(sleep_until (< (ai_living_count boss_fight_sentinels) 2))
	(sleep_until (= boss_fight_begin TRUE))
	(ai_place boss_fight_sentinels 2)
)

(script dormant hangar_secondtime_start
	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_hangar_reenter (players)) TRUE)))

	(device_operates_automatically_set hangar_exit TRUE)
	(device_operates_automatically_set hangar_exit TRUE)

;	(ai_erase all_enemies)
	(garbage_collect_now)

	(game_save)

	(ai_place heretic_leader_hangar)
	(cs_run_command_script heretic_leader_hangar long_pause)
	(object_cannot_take_damage (ai_actors heretic_leader_hangar))

	(sleep_until (AND (= plummeting TRUE) (= (volume_test_objects vol_hangar_cutscene_start (players)) TRUE)))

	(cinematic_fade_to_white)

	(ai_erase heretic_leader_hangar)
	(object_teleport (player0) player0_hide)
	(object_teleport (player1) player1_hide)

	(if (cinematic_skip_start)
		(begin
			(C04_outro1)
		)
	)
	(cinematic_skip_stop)

	(object_teleport (player0) player0_hangar)
	(object_teleport (player1) player1_hangar)

	(ai_place monitor)
	(ai_place boss_fight_heretic_leader)
	(set heretic_leader (ai_get_object boss_fight_heretic_leader/hl))
	(ai_place boss_fight_hl_hologram_01)
	(ai_place boss_fight_hl_hologram_02)
	(ai_place boss_fight_combatforms 4)
	(ai_place boss_fight_carriers 4)
	(ai_place boss_fight_sentinels 4)

	(cinematic_fade_from_white)

	(game_save)
	
	(set boss_fight_begin TRUE)
)

;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

;temp teleporting stuff

(script static void teleport_banshee
	(ai_place ledge_banshees_01)
	(object_teleport (player0) banshee_ledge_player0)
	(object_teleport (player1) banshee_ledge_player1)
	(wake temp_phantom_course)
)
(script static void teleport_research
	(object_teleport (player0) research_player0)
	(object_teleport (player1) research_player1)
	(ai_place arm02_allies)
;	(switch_bsp 5)
)
(script static void teleport_control
	(switch_bsp 0)
	(object_teleport (player0) control_entry_player0)
	(object_teleport (player1) control_entry_player1)
	(device_operates_automatically_set control_room_ext TRUE)
)
(script static void teleport_plummet
	(set plummeting TRUE)
	(switch_bsp 3)
	(object_teleport (player0) after_plummet_player0)
	(object_teleport (player1) after_plummet_player1)
	(wake cable_room_return)
	(device_set_position_immediate control_shield_door 1)
	(device_set_position_immediate shield 1)
	(device_set_power control_up_switch_01 0)
)
(script static void teleport_return
	(set plummeting TRUE)
	(switch_bsp 3)
	(object_teleport (player0) bottling_return_player0)
	(object_teleport (player1) bottling_return_player1)
	(device_operates_automatically_set viewroom_exit01_bsp0 TRUE)
)
(script static void teleport_boss
	(set plummeting TRUE)
	(switch_bsp 3)
	(object_teleport (player0) boss_player0)
	(object_teleport (player1) boss_player1)
)

;temp
(script dormant intro_messages
	(sleep 60)
	(print "Don't kill these guys!")
	(sleep 60)
	(print "They're your allies!")
	(sleep 120)
	(print "Oh, and pretend that shotgun is a sword.")
	(sleep 120)
	(print "So try to use it at melee range only.")
)

;Startup scripts
(script startup mission	

;Cutscene stuff

	(cinematic_snap_to_black)	
	(if (= (volume_test_objects vol_arm_01_return (players)) TRUE)
		(begin
			
			(if (cinematic_skip_start)
				(begin
					(X04)
				)
			)
			(cinematic_skip_stop)

			(if (cinematic_skip_start)
				(begin
					(C04_intro)
				)
			)
			(cinematic_skip_stop)

		)
	)
	
;Mission stuff

	(ai_allegiance player covenant)
	(ai_allegiance sentinel heretic)	
	(ai_allegiance heretic sentinel)
	
	(device_set_position_immediate elev_hangar 1)
	(object_create elev_crate_01)
	(object_create elev_crate_02)

	(sleep_forever cableroom_pit_killer_player0)
	(if (= (list_count (players)) 1)
		(begin
			(sleep_forever all_pit_killer_player1)
			(sleep_forever cableroom_pit_killer_player1)
		)
	)
	(wake kill_recycling_hacks)

	(ai_place intro_phantom)
	(unit_custom_animation_at_frame 
		(unit (ai_vehicle_get_from_starting_location intro_phantom/driver)) 
			objects\vehicles\phantom\animations\04_intro\04_intro 
				"phantom01_06b" TRUE 100)

	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)

	(ai_place intro_elites)
	(cs_run_command_script intro_elites/elite01 SWAT_elite_01)
	(cs_run_command_script intro_elites/elite02 SWAT_elite_02)

	(ai_place allies_elites_01)
	(cs_run_command_script allies_elites_01/elite04 SWAT_elites_04)
	(ai_place hacker)
	(cs_run_command_script hacker SWAT_elites_03)

	(ai_place allies_grunts_01)
	(cs_run_command_script allies_grunts_01/grunt01 SWAT_grunt_01)
	(cs_run_command_script allies_grunts_01/grunt02 SWAT_grunt_02)

	(ai_place spec_ops_commander)
	(ai_vehicle_enter_immediate spec_ops_commander (ai_vehicle_get_from_starting_location intro_phantom/driver) phantom_p_r06)

	(cinematic_fade_from_white)

	(wake SWAT_deploy)
;	(wake intro_messages)
	(wake recycling_center_start)
	(wake hangar_firsttime_start)
	(wake to_underhangar_firsttime)
	(wake underhangar_firsttime_start)
	(wake to_bottling)
	(wake bottling_firsttime_start)
	(wake bottling_plant_end)
	(wake dogfight_firsttime_start)
	(wake arm_02_lz_start)
	(wake arm_02_entry_start)
	(wake disposal_chamber_start)
	(wake silo_start)
	(wake to_flood_lab)
	(wake flood_lab_start)
	(wake bridge_start)
	(wake control_room_start)
	(wake cable_room_start)
	(wake cable_room_return)
	(wake power_core_start)
	(wake dogfight_secondtime_start)
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
)
