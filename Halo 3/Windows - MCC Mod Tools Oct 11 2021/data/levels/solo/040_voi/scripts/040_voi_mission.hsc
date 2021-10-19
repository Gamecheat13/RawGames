;*********************************************************************;
;General
;*********************************************************************;
(global boolean editor FALSE)
(global boolean debug FALSE)
(global boolean g_play_cinematics TRUE)
(global boolean g_cortana_playing FALSE)
(global short testNum 0)
(global short testNum02 0)
(global short wave 1)
(global short waveMax 0)
(global vehicle testVehicle NONE)
(global ai testAI NONE)
(global ai testAI02 NONE)
(global boolean g_scarab_dead FALSE)
(global boolean g_bfg_longsword FALSE)

; insertion point index 
(global short g_insertion_index 0)

;Used to abort an AI out of a command script manually
(script command_script abort
	(cs_pause .1)
)

;Used to make an AI pause and do nothing
(script command_script pause_forever
	(sleep_forever)
)

;Used to make an AI pause and do nothing
(script command_script moving_looking_cs
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep_forever)
)

;screen shakes
(script static void screen_shake_small_impact
	(player_effect_set_max_rotation 0 1 1)   
	(player_effect_start (real_random_range .2 .3) 0)
	(sleep (random_range 20 40))
	(player_effect_stop 0)
)

;game_save
(script static void call_game_save
	(game_save)
)


;*********************************************************************;
;Intro
;*********************************************************************;

;Attaches fires and things to wrecks in tunnel
(script dormant intro_tumble_tire

	(if (= (random_range 0 3) 0)
		(begin
			(sleep_until (volume_test_players vol_intro_flyby) 5)
			(object_create intro_tire)
			(object_set_velocity intro_tire 4.8 0 0)
		)
	)
)

;Script some Phantoms to fly overhead with a Wraith
(script dormant intro_flyby
	(sleep_until (volume_test_players vol_intro_flyby) 5)
	(print "flyby go!")
	(ai_place intro_cov_ships)
	(ai_disregard (ai_actors intro_cov_ships) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location intro_cov_ships/phantom01) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location intro_cov_ships/phantom02) TRUE)
	(sleep 1)
	(cs_run_command_script intro_cov_ships cov_flyby_banshee)
	(sleep 1)
	(cs_run_command_script intro_cov_ships/phantom01 cov_flyby_wraith)
	(cs_run_command_script intro_cov_ships/phantom02 cov_flyby_wraith)
	(flock_create "intro_banshees")
	(flock_create "intro_hornets")
	;(wake md_int_flyby)
)

(script command_script cov_flyby_wraith
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles true)
	(begin_random
		(cs_vehicle_speed_instantaneous 2.8)
		(cs_vehicle_speed_instantaneous 3)
		(cs_vehicle_speed_instantaneous 3.4)
		(cs_vehicle_speed_instantaneous 4)
	)
	(cs_vehicle_boost false)
	(cs_fly_by intro_pts/cov02 8)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cov_flyby_banshee
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles true)
	(cs_vehicle_boost true)
	(cs_fly_to intro_pts/cov01)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

;parks the troop hog out of the gauss' way
(script command_script intro_hog_drive_02
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_vehicle_speed .7)
	(sleep_until (volume_test_objects vol_drive_intro_end (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01)))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving FALSE)
	(cs_enable_looking FALSE)
	(cs_abort_on_damage TRUE)
	(cs_vehicle_speed .7)
	(cs_go_to intro_pts/troop01)
	(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) TRUE)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "")
	(ai_migrate intro_troop_hogs02 init_allies)
	(if (= (game_is_cooperative) TRUE)
		(wake intro_move_HUD)
	)
	;(wake intro_hog_unload)
)

(script command_script intro_hog_drive_03
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_vehicle_speed .7)
	(sleep_until (volume_test_objects vol_drive_intro_end (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01)))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving FALSE)
	(cs_enable_looking FALSE)
	(cs_abort_on_damage TRUE)
	(cs_vehicle_speed .7)
	(cs_go_to intro_pts/troop02)
	(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) TRUE)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "")
	(ai_migrate intro_troop_hogs init_allies_brass)
	(if (= (game_is_cooperative) TRUE)
		(wake intro_move_HUD)
	)
	;(wake intro_hog_unload)
)

(script dormant intro_hog_unload
	(vehicle_unload (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "")
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) TRUE)
	(sleep (random_range 10 40))
	(vehicle_unload (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "")
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) TRUE)
	;(wake md_int_storm)
)

;player movement and HUD
(script dormant intro_move_HUD
	;(player_enable_input TRUE)
	(player_disable_movement FALSE)
	(wake objective_1_set)
	(chud_cinematic_fade 1 0.5)
)

;Main script for the intro space
(script dormant intro
	(data_mine_set_mission_segment "040_10_intro")
	(player_disable_movement TRUE)
	(wake sc_bridge_cruiser)
	(wake gauss_nav_intro)
	;(wake intro_flyby)
	(set wave 1)
	
	;cinematic lighting
	(wake gs_cinematic_lights)
	
	(if (= (game_coop_player_count) 4)
		(begin
			(print "4 player coop")
			(ai_place intro_hog)
			(ai_place intro_troop_hogs)
			(ai_place intro_troop_hogs02)
			(ai_place init_allies_brass)
			(ai_place init_allies 3)
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_p" (player0))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_p" (player1))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p" (player2))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (player3))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_p_b" (ai_get_object init_allies_brass/sgt))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p_r" (ai_get_object init_allies_brass/female))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p_b" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_d" (list_get (ai_actors init_allies) 0))
		)
	)
	(if (= (game_coop_player_count) 3)
		(begin
			(print "3 player coop")
			(ai_place intro_hog)
			(ai_place intro_troop_hogs)
			(ai_place intro_troop_hogs02)
			(ai_place init_allies_brass)
			(ai_place init_allies 4)
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_p" (player0))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_p" (player1))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p" (player2))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_p_b" (ai_get_object init_allies_brass/sgt))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p_r" (ai_get_object init_allies_brass/female))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_d" (list_get (ai_actors init_allies) 0))
		)
	)
	(if (= (game_coop_player_count) 2)
		(begin
			(print "2 player coop")
			(ai_place intro_hog)
			(ai_place intro_troop_hogs)
			(ai_place intro_troop_hogs02)
			(ai_place init_allies_brass)
			(ai_place init_allies 5)
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_p" (player0))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_p" (player1))
			
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_p_b" (ai_get_object init_allies_brass/sgt))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p" (ai_get_object init_allies_brass/female))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p_r" (list_get (ai_actors init_allies) 0))
		)
	)
	
	(if (= (game_is_cooperative) FALSE)
		(begin
			(ai_place intro_hog)
			(ai_place intro_troop_hogs)
			(ai_place intro_troop_hogs02)
			(ai_place init_allies_brass)
			(ai_place init_allies 6)
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_p" (player0))

			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_p" (ai_get_object init_allies_brass/sgt))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p" (ai_get_object init_allies_brass/female))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_d" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs02/driver01) "warthog_p_r" (list_get (ai_actors init_allies) 0))
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location intro_troop_hogs/driver01) "warthog_p_b" (list_get (ai_actors init_allies) 0))
		)
	)
	(cs_run_command_script (ai_get_driver intro_hog/driver) hog_speed)
	(cs_run_command_script (ai_get_driver intro_troop_hogs/driver01) intro_hog_drive_02)
	(cs_run_command_script (ai_get_driver intro_troop_hogs02/driver01) intro_hog_drive_03)

	; fade in 
	(sleep 60)
	(sound_class_set_gain "" 1 60)

	; Edit sound channels, other stuff here
	(camera_control off)
	(sleep 30)
	
	;music
	(wake music_040_01)
	(set g_music_040_01 TRUE)
	
	; Restore player control
	;(player_enable_input TRUE)
	(player_camera_control TRUE)
	(cinematic_fade_to_title)
	(wake 040_title1)
	(wake intro_tumble_tire)
	(sleep_until (not (any_players_in_vehicle)))
	(wake intro_hog_unload)
	(wake intro_nav_exit)
	(game_save)
	(sleep_until (= (current_zone_set_fully_active) 1) 5)
	(game_save)
)

;Cleanup script for the intro
(script dormant intro_cleanup
	(sleep_until (volume_test_players vol_tank_room_a_exit))
	(sleep_forever intro)
	(sleep_forever intro_flyby)
	(sleep_forever gauss_nav_intro)
	;(object_destroy intro_phantom_01)
	;(object_destroy intro_phantom_02)
	;(object_destroy intro_wraith)
	(flock_delete "intro_banshees")
	(flock_delete "intro_hornets")
)

;*********************************************************************;
;Factory A
;*********************************************************************;

;Controls the middleentrance to the room
(script dormant factory_a_door_in
	;*
	(device_set_power factory_a_entry02 1)
	(sleep_until (<= (device_get_position factory_a_entry02) 0))
	(print "door primed")
	(device_group_set_immediate tank_room_a_entry_buttons 0)
	(device_operates_automatically_set factory_a_entry02 1)
	(device_group_change_only_once_more_set tank_room_a_entry_buttons TRUE)
	*;

	;(sleep_forever gauss_ram_fix)
	(sleep_until (>= (device_get_power factory_a_entry02) 1))
	(device_set_power factory_a_entry02_switch 0)
	(device_set_power factory_a_entry02_switch02 0)
	(game_save)
)

;Marines hit buttons if player doesn't
(script dormant button_pusher01
	(sleep_until (<= (ai_task_count factory_a_covenant_obj/factory_a_button_guard02) 2))
	(sleep 60)
	;*
	(sleep_until
		(or 
			(any_players_in_vehicle)
			(<= (device_get_power factory_a_entry02_switch) 0)
		)
	)
	*;
	(if (>= (device_get_power factory_a_entry02_switch) 1)
		;(cs_run_command_script (object_get_ai (list_get (ai_actors intro_troop_hogs) 0)) button_pusher01_cs)
		(begin
			;(vs_cast (object_get_ai (list_get (ai_actors factory_a_allies_obj/tank_room_a_gate) 0)) TRUE 2 "")
			(vs_cast factory_a_allies_obj/tank_room_a_gate TRUE 2 "")
			(vs_enable_pathfinding_failsafe (vs_role 1) TRUE)
			(vs_abort_on_damage TRUE)
			;(vs_enable_looking (vs_role 1) TRUE)
			;(vs_enable_moving (vs_role 1) TRUE)
			;(vs_enable_targeting (vs_role 1) TRUE)
			(vs_go_to (vs_role 1) TRUE factory_arm_a/buttonpush01b)
			(vs_enable_moving (vs_role 1) FALSE)
			(vs_go_to (vs_role 1) TRUE factory_arm_a/buttonpush01c)
			(sleep_until (<= (ai_task_count factory_a_covenant_obj/factory_a_button_guard02) 0))
			(vs_go_to (vs_role 1) TRUE factory_arm_a/buttonpush01)
			(device_set_power factory_a_entry02 1)
			(vs_release_all)
		)
	)
)

(script dormant button_pusher02
	(sleep_until
		(or 	
			(any_players_in_vehicle)
			(volume_test_players vol_faa_button02)
			(>= (device_group_get factory_a_middle_buttons) 1)
		)
	)
	(if (<= (device_group_get factory_a_middle_buttons) 0)
		;(cs_run_command_script (object_get_ai (list_get (ai_actors intro_troop_hogs) 0)) button_pusher02_cs)
		(begin
			(print "Looking for button pusher")
			(vs_cast factory_a_allies_obj/left_behind TRUE 2 "")
			;(vs_cast (object_get_ai (list_get (ai_actors factory_a_allies_obj/left_behind) 0)) TRUE 2 "")
			(vs_enable_pathfinding_failsafe intro_troop_hogs TRUE)
			(vs_abort_on_damage TRUE)
			;(vs_enable_looking intro_troop_hogs TRUE)
			;(vs_enable_targeting intro_troop_hogs TRUE)
			(print "I'll get the door, Chief")
			(vs_go_to (vs_role 1) TRUE factory_arm_a/buttonpush02)
			(device_set_position factory_a_middle_switch02 1)
			(vs_release_all)
		)
	)
)

(script dormant button_pusher03
	(sleep_until
		(or 
			(any_players_in_vehicle)
			;(>= (device_get_power lakebed_a_entry_door) 1)
			FALSE
		)
	)
	(if (<= (device_get_position lakebed_a_entry_door) 0)
		;(cs_run_command_script (object_get_ai (list_get (ai_actors intro_troop_hogs) 0)) button_pusher02_cs)
		(begin
			(vs_cast (object_get_ai (list_get (ai_actors intro_troop_hogs) 0)) TRUE 2 "")
			(vs_enable_pathfinding_failsafe intro_troop_hogs TRUE)
			(vs_enable_moving intro_troop_hogs TRUE)
			(vs_go_to (vs_role 1) TRUE factory_arm_a/buttonpush03)
			(device_set_position lakebed_a_entry_switch 1)
			(vs_release_all)
		)
	)
)

;Controls the middle big door
(script dormant factory_a_door_middle
	(sleep_until 
		(or
			(> (device_get_position factory_a_middle_switch) 0)
			(> (device_get_position factory_a_middle_switch02) 0)
			
		)
	)
	(device_set_position factory_a_entry02_switch 1)
	(ai_set_task_condition factory_a_covenant_obj/faa_cov_init FALSE)
	(ai_magically_see factory_a_covenant_obj factory_a_allies_obj)
)


(script dormant gauss_ram_fix
	(sleep_until (volume_test_object vol_factory_a_room02_entry (ai_vehicle_get_from_starting_location intro_hog/driver)))
	(print "guass rammed")
	(sleep_until (<= (device_get_position factory_a_entry02) 0))
	(device_group_set_immediate tank_room_a_entry_buttons 1)
	(device_operates_automatically_set factory_a_entry02 1)
	(device_set_power factory_a_entry02_switch 0)
	(device_set_power factory_a_entry02_switch02 0)
)

(script dormant faa_ghosts
	(ai_place tank_a_cov_ghosts)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_a_cov_ghosts/driver01) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_a_cov_ghosts/driver02) TRUE)
	(sleep_until (<= (ai_living_count factory_a_covenant_obj) 5))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_a_cov_ghosts/driver01) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_a_cov_ghosts/driver02) FALSE)
	(ai_enter_squad_vehicles all_enemies)
)

(script static void scare_grunts
	;dialog
	(wake md_faa_cov_flee)
	;(sleep_until (>= (ai_combat_status tank_room_a_init_right) ai_combat_status_alert))
	(sleep_until (volume_test_players vol_faa))
	(cs_run_command_script factory_a_jackals01 alert_jacks_cs)
	(wake factory_a_door_in)
)

(script dormant faa_intro_jackals
	(sleep 90)
	(ai_place factory_a_jackals03)
	(cs_run_command_script factory_a_jackals03 scare_jackals_cs)
)

(script command_script scare_jackals_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to factory_arm_a/jackal01a)
	(cs_go_to factory_arm_a/jackal01b)
)

(script command_script scare_grunts_cs
;	(cs_start_to factory_arm_a/grunt_scare)
	(sleep 90)
)

(script command_script alert_jacks_cs
	(cs_force_combat_status ai_combat_status_alert)
)

(script command_script faa_fallback_cs
	;(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_damage TRUE)
	(cs_go_to factory_arm_a/fallback01)
)

(script dormant faa_entry_door_closer
	;give time for hog to get through door
	(sleep (* 30 11))
	(print "hog in?")
	(sleep_until (volume_test_players vol_tank_room_a_exit))
	(device_group_change_only_once_more_set faa_entry_buttons FALSE)
	(device_set_position factory_a_entry 0)
	;allow garbage collection of AA wraith in Lakebed A
	(sleep_until (<= (device_get_position factory_a_entry) 0) 5)
	;(prepare_to_switch_to_zone_set faa_lakea)
	(zone_set_trigger_volume_enable begin_zone_set:faa_lakea TRUE)
	(faa_coop_teleport)
	(sleep_until (= (current_zone_set_fully_active) -1) 5)
	(sleep (* 30 10))
	(zone_set_trigger_volume_enable zone_set:faa_lakea TRUE)
	(device_set_power lakebed_a_entry_switch 1)
	(ai_disposable intro_tunnel_obj TRUE)
)

(script dormant faa_objective_control
	(ai_set_objective init_allies factory_a_allies_obj)
	(ai_set_objective allied_vehicles factory_a_allies_obj)
	(sleep_until
		(or
			(<= (ai_living_count init_allies) 1)
			(< (device_get_position factory_a_entry) 1)
		)
	)
	(if (<= (ai_living_count init_allies) 1)
		(ai_set_objective init_allies_brass factory_a_allies_obj)
	)
)

(script static void faa_coop_teleport
	(print "teleport backup")
	(if (volume_test_object vol_faa_coop_teleport (player0)) (object_teleport (player0) faa_coop_teleport_player0))
	(if (volume_test_object vol_faa_coop_teleport (player1)) (object_teleport (player1) faa_coop_teleport_player1))
	(if (volume_test_object vol_faa_coop_teleport (player2)) (object_teleport (player2) faa_coop_teleport_player2))
	(if (volume_test_object vol_faa_coop_teleport (player3)) (object_teleport (player3) faa_coop_teleport_player3))
)

(script dormant faa_quiet
	(ai_dialogue_enable FALSE)
	(sleep_until (>= (ai_combat_status factory_a_covenant_obj) 4))
	(print "enabling marine comabat dialog")
	(ai_dialogue_enable TRUE)
)

(script dormant faa_saves
	(sleep_until
		(and
			(<= (ai_living_count factory_a_init_grunts01) 0)
			(<= (ai_living_count factory_a_init_grunts02) 0)
			(<= (ai_living_count factory_a_jackals01) 0)
			(<= (ai_living_count factory_a_jackals02) 0)
		)
	)
	(game_save)
)

;Main script for Factory A
(script dormant factory_a_start
	(sleep_until (volume_test_players vol_tank_room_a_start) 5)
	(wake faa_quiet)
	(set wave 2)
	;(ai_place tank_room_a_init_right)
	(sleep_until (> (device_get_position factory_a_entry) 0) 5)
	(data_mine_set_mission_segment "040_20_factory_a")
	
	;music
	(set g_music_040_01 FALSE)
	(wake music_040_02)
	(set g_music_040_02 TRUE)
	
	(wake intro_cleanup)
	(wake gauss_nav_factory_a)
	(wake truth_channel)
	(ai_place factory_a_init_grunts01)
	(ai_place factory_a_init_grunts02)
	(ai_place factory_a_jackals01)
	(ai_place factory_a_jackals02)
	;(wake faa_intro_jackals)
	(sleep_until
		(or
			(volume_test_players vol_faa)
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (players))
		)
	)
	(wake faa_saves)
	(wake faa_entry_door_closer)
	(wake factory_a_door_middle)
	;(wake gauss_ram_fix)
	(wake button_pusher01)
	(sleep_until (volume_test_players vol_faa))
	(wake faa_objective_control)
	
	;dialog
	(wake md_faa_door_hint_01a)
	
	(sleep_until
		(or
			(volume_test_players vol_tank_room_a_exit)
			(<= (ai_task_count factory_a_covenant_obj/tank_room_combat01) 1)
		)
	)
	(ai_place tank_room_a_rein_front)
	(ai_place tank_room_a_commander)
	(ai_place tank_room_a_commander02)
	(ai_place tank_room_a_com_jacks)
	(if (not (difficulty_legendary))
		(wake button_pusher02)
	)
	;(sleep_until (> (device_get_position factory_a_middle) 0))
	(data_mine_set_mission_segment "040_21_factory_a02")
	
	(wake faa_ghosts)
	(wake faa_nav_exit)
	(sleep_until (<= (ai_living_count all_enemies) 0))
	(sleep_until (= (current_zone_set_fully_active) 2))
	(wake button_pusher03)
	(game_save)
)

;Cleanup scripts for factory A
(script dormant factory_a_cleanup
	(sleep_until (volume_test_players vol_factory_b_start))
	(sleep_forever factory_a_start)
	(sleep_forever factory_a_door_in)
	(sleep_forever factory_a_door_middle)
	(sleep_forever faa_ghosts)
	(sleep_forever button_pusher01)
	(sleep_forever button_pusher02)
	(sleep_forever button_pusher03)
	(sleep_forever faa_saves)
	(device_set_power factory_a_entry02 1)
	(device_set_power factory_a_entry02_switch 0)
	;(device_set_power factory_a_middle 1)
	(device_set_position factory_a_middle 1)
	(device_one_sided_set factory_a_entry TRUE) 
)

(script static void factory_a_garbage
	(add_recycling_volume factory_a_garbage 0 0)
)

;*********************************************************************;
;Lakebed A
;*********************************************************************;

(script command_script marine_waste
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(sleep_until
		(begin
			(sleep (random_range 30 150))
			(cs_shoot_point TRUE lakebed_a_targets/waste01)
			(<= (ai_living_count lakebed_a_allies/inf_init) 0)
		)
	)
)

;used to test when wraith can waste marines
(script static boolean unleash_ground_wraith
	(or
		(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0)
		(volume_test_players vol_lakebed_a_end)
		(and
			(>= (ai_task_status lakebed_a_covenant_obj/center_structure) ai_task_status_exhausted)
			(<= (ai_task_count lakebed_a_covenant_obj/ghosts_gate) 2)
		)
	)
)

(script command_script lakebed_a_wraiths_cheapshot
	(sleep (random_range 0 60))
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(sleep (random_range 90 200))
	(cs_run_command_script ai_current_actor lakebed_a_wraiths_shoot)
)

(script command_script lakebed_a_ground_wraiths_shoot
	(cs_run_command_script lake_a_cov_end_wraith/gunner01 abort)
	(cs_enable_moving TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_a_targets/gw01)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_a_targets/gw02)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_a_targets/gw03)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_a_targets/gw04)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_a_targets/gw05)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_a_targets/gw06)
				)
			)
			FALSE
		)
	)
)

(script dormant lakebed_a_wraith_magic
	(sleep_until
		(begin
			(ai_magically_see lakebed_a_wraith_01 lake_a_hornets)
			(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0)
		)
	100)
)

;Scripts Wraiths to shoot in the air... at stuff
(script command_script lakebed_a_wraiths_shoot
	(cs_run_command_script lakebed_a_wraith_01/gunner01 abort)
	;(cs_enable_moving TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(sleep (random_range 30 80))
					(cs_shoot_point TRUE lakebed_a_targets/p0)
				)
				(begin
					(sleep (random_range 30 80))
					(cs_shoot_point TRUE lakebed_a_targets/p1)
				)
				(begin
					(sleep (random_range 30 80))
					(cs_shoot_point TRUE lakebed_a_targets/p2)
				)
				(begin
					(sleep (random_range 30 80))
					(cs_shoot_point TRUE lakebed_a_targets/p3)
				)
			)
			(>= (ai_task_count lakebed_a_allies/hornets_gate) 1)
		)
	)
	
	(print "wraith breaking command script")
)

(script command_script center_def_run
	(cs_run_command_script lake_a_def_center/rocket_man rocket_man)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status ai_combat_status_active)
	(sleep 1)
	(cs_go_to lakebed_a/p3)
)

(script command_script rocket_man
	(cs_aim_object TRUE lakebed_a_init_phantoms/driver01)
	(sleep 100)
	(cs_shoot TRUE lakebed_a_init_phantoms/driver01)
	(sleep 10)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(sleep_until (<= (ai_task_count lakebed_a_covenant_obj/center_structure) 0))
	(cs_enable_targeting FALSE)
	(sleep_forever)
)

(script dormant center_allies
	(ai_place lake_a_def_center)
	;(unit_doesnt_drop_items (ai_get_object lake_a_def_center/rocket_man))
	(wake lake_a_rocket_drop)
	(sleep_until
		(begin
			(ai_renew lake_a_def_center/01)
			(ai_renew lake_a_def_center/02)
			(ai_renew lake_a_def_center/03)
			(ai_renew lake_a_def_center/04)
			(sleep 10)
			;renew until allies capture center
			(or
				(volume_test_players vol_lakebed_a_bridge)
				(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0)
				(<= (ai_strength lakebed_a_covenant_obj/center_gate) .6)
			)
		)
	)
	(print "def is on its own!")
)


(script dormant lake_a_rocket_drop
	(sleep_until (<= (ai_living_count lake_a_def_center/rocket_man) 0))
	(unit_kill (ai_vehicle_get_from_starting_location lake_a_def_center/rocket_man))
)

(script dormant lake_a_center_saves
	(sleep_until
		(begin
			(sleep_until (and
				(volume_test_players_all vol_lake_a_center_saves)
				(game_safe_to_save))
			)
		(game_save)
		(sleep (* 30 90))
		FALSE
		)
	)
)

(script static void lake_a_center_cap
	(sleep_until (<= (ai_task_count lakebed_a_covenant_obj/center_structure) 0))
	(data_mine_set_mission_segment "040_31_lakebed_a02")
	;(game_save)
	(wake lake_a_center_saves)
	(print "putting all allies into allies obj & looking for rocket man")
	(ai_set_objective lakebed_a_def lakebed_a_allies)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location lake_a_def_troop_hog/driver) FALSE)
	(sleep 10)
	;the following looks for a marine on the bridge and then tells him to grab a RocketL from the center structure
	(set testNum 0)
	(if (and 
			(not (vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "" (list_get (ai_actors lakebed_a_allies) 0)))
			(volume_test_object vol_lakebed_a_bridge (list_get (ai_actors lakebed_a_allies) 0))
		)
		;if marine 0 is on bridge:
		(cs_run_command_script (object_get_ai (list_get (ai_actors lakebed_a_allies) 0)) center_capture)
		;else, find marine on bridge:
		(begin
			(sleep_until
				(begin
					(set testNum (+ testNum 1))
					(if (>= testNum 15)
						(set testNum 0)
					)
					;(print "testNum +1")
					(and 
						(not (vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "" (list_get (ai_actors lakebed_a_allies) testNum)))
						(volume_test_object vol_lakebed_a_bridge (list_get (ai_actors lakebed_a_allies) testNum))
					)
				)
			)
			(cs_run_command_script (object_get_ai (list_get (ai_actors lakebed_a_allies) testNum)) center_capture)
		)
	)
	(sleep 1)
	(set testNum 0)
)

(script command_script center_capture
	(print "revenge of the rocket man!")
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep 1)
	(if (volume_test_object vol_lake_a_RL lake_a_RL)
		(cs_go_to lakebed_a/rocket_man)
	)
	(if (volume_test_object vol_lake_a_RL lake_a_RL)
		(begin
			(cs_crouch TRUE)
			(sleep 20)
			(object_destroy lake_a_RL)
			(unit_add_equipment ai_current_actor rocket_man true true)
			(sleep 20)
			(cs_crouch FALSE)
		)
	)
)

(script command_script phantom_init_drop01
	(cs_enable_pathfinding_failsafe TRUE)
	;(cs_enable_targeting TRUE)
	(cs_fly_to lakebed_a/phantom01a)
	(unit_set_maximum_vitality lake_a_def_center/rocket_man 10 0)
	(unit_set_current_vitality lake_a_def_center/rocket_man 10 0)
	;(cs_enable_looking TRUE)
	;(cs_enable_moving TRUE)
	(sleep 60)
	;(cs_enable_moving false)
	(cs_fly_to lakebed_a/phantom01c 1)
	(sleep 30)
	(ai_trickle_via_phantom lakebed_a_init_phantoms/driver01 lake_a_cov_center)
	;(sleep 90)
	(ai_trickle_via_phantom lakebed_a_init_phantoms/driver01 lake_a_cov_center_grunts)
	(sleep_until
		(or
			(<= (ai_living_count lake_a_def_center/rocket_man) 0)
			(volume_test_players vol_lakebed_a_bridge)
		)
	30 (* 30 6))
	;(cs_enable_moving false)
	(sleep (random_range 0 60))
	(cs_run_command_script ai_current_actor lakea_phantom_exit)
)

(script command_script phantom_prevent
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (not (volume_test_players vol_lakebed_a_end)))
	(sleep 1000)
	(cs_run_command_script ai_current_actor lakea_phantom_exit)
)

(script command_script phantom_drop_rein_ghosts
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by lakebed_a/phantom_guide01 8)
	(cs_vehicle_boost TRUE)
	(cs_fly_by lakebed_a/phantom_guide02 8)
	(cs_vehicle_boost FALSE)
	(cs_fly_to lakebed_a/phantom02a 1)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc02")
	(cs_run_command_script ai_current_actor lakea_phantom_exit)
	(sleep 90)
	(print "killing surfers")
	(lake_a_surfer_kill)
)

(script command_script lake_a_wraith_drop_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by lakebed_a/phantom_guide01 8)
	(cs_vehicle_boost TRUE)
	(cs_fly_by lakebed_a/phantom_guide02 8)
	(cs_vehicle_boost FALSE)
	(cs_fly_to lakebed_a/phantom_end 1)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location lakebed_a_end_phantom/driver) "phantom_lc")
	(if (not (>= (ai_task_status lakebed_a_covenant_obj/center_structure) ai_task_status_exhausted))
		(cs_run_command_script lake_a_cov_end_wraith lakebed_a_ground_wraiths_shoot)
		(cs_run_command_script lake_a_cov_end_wraith abort)
	)
	;*
	(object_set_phantom_power (ai_vehicle_get_from_starting_location lakebed_a_end_phantom/driver) TRUE)
	(if
		(or
			(difficulty_heroic)
			(difficulty_legendary)
			(difficulty_normal)
			TRUE
		)
		(ai_trickle_via_phantom lakebed_a_end_phantom/driver lake_a_cov_end)
	)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location lakebed_a_end_phantom/driver) FALSE)
	*;
	(sleep 60)
	(cs_fly_to lakebed_a/phantom_end02)
	(cs_run_command_script ai_current_actor lakea_phantom_exit)
	(sleep 90)
	(print "killing surfers")
	(lake_a_surfer_kill)
)

(script dormant lake_a_wraith_drop
	(sleep_until (or
		(volume_test_players vol_lake_a_bed)
		(volume_test_players vol_lake_a_topback)
		)
	)
	;(sleep_until (<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0))
	(sleep_until (<= (ai_task_count lakebed_a_covenant_obj/phantoms) 0))
	(ai_place lakebed_a_end_phantom)
	(ai_place lake_a_cov_end_wraith)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_a_end_phantom/driver) "phantom_lc" (ai_vehicle_get_from_starting_location lake_a_cov_end_wraith/driver01))
	(cs_run_command_script lakebed_a_end_phantom/driver lake_a_wraith_drop_cs)
	(sleep 30)
	(cs_run_command_script lake_a_cov_end_wraith pause_forever)
)

(script command_script lakea_phantom_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to lakebed_a/phantom_guide_high)
	(lake_a_surfer_kill)
	(cs_fly_to lakebed_a/phantom_exit_high)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script static void lake_a_surfer_kill
	(print "killing surfers")
	(if (volume_test_object vol_lake_a_surf (player0)) (unit_kill (player0)))
	(if (volume_test_object vol_lake_a_surf (player1)) (unit_kill (player1)))
	(if (volume_test_object vol_lake_a_surf (player2)) (unit_kill (player2)))
	(if (volume_test_object vol_lake_a_surf (player3)) (unit_kill (player3)))
)

(script dormant lake_a_big_door_closer
	(sleep_until (volume_test_players vol_lake_a_doorcheck))
	(device_group_change_only_once_more_set factory_a_middle_buttons FALSE)
	(device_set_position factory_a_middle02 0)
)

(script dormant lake_a_ghost_rein
	(sleep_until (>= (ai_living_count lake_a_cov_end_wraith) 1))
	(sleep_until (<= (ai_task_count lakebed_a_covenant_obj/phantoms) 0))
	(sleep_until 
		(or 
			FALSE
			(<= (ai_task_count lakebed_a_covenant_obj/ghosts_gate) 2)
			;(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0)
			;(<= (ai_task_count lakebed_a_covenant_obj/ground_wraith_gate) 0)
			
		)
	)
	(if (>= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 1)
		(begin
			(print "rein ghosts")
			(sleep (random_range 20 60))
			(ai_place lakebed_a_ghosts02_phantom)
			(ai_place lakebed_a_rein_ghosts)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_a_ghosts02_phantom/driver01) "phantom_sc01" (ai_vehicle_get_from_starting_location lakebed_a_rein_ghosts/driver01))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_a_ghosts02_phantom/driver01) "phantom_sc02" (ai_vehicle_get_from_starting_location lakebed_a_rein_ghosts/driver02))
			(cs_run_command_script lakebed_a_ghosts02_phantom/driver01 phantom_drop_rein_ghosts)
		)
	)
)

(script dormant lake_a_banshee_control
	(ai_place lake_a_banshees01)
	(ai_set_targeting_group lake_a_banshees01 1)
	(cs_run_command_script lake_a_banshees01 lake_a_banshees_entry_cs)
	(sleep_until
		(begin
			(if (<= (ai_living_count lake_a_banshees01) 0)
				(begin
					(ai_place lake_a_banshees01)
					(ai_set_targeting_group lake_a_banshees01 1)
					(cs_run_command_script lake_a_banshees01 lake_a_banshees_entry_cs)
				)
			)
			(sleep 90)
			(or 
				(<= (ai_living_count lake_a_hornets) 0)
				(<= (ai_living_count lake_a_cov_end_wraith) 0)
			)
		)
	)
)

(script command_script lake_a_banshees_entry_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(sleep (random_range 120 150))
)

(script command_script lake_a_banshees_exit_cs
	(sleep (random_range 30 110))
	(cs_fly_to lakebed_a/banshee01)
	(cs_vehicle_boost TRUE)
	(cs_enable_moving FALSE)
	(cs_enable_looking FALSE)
	(cs_fly_to lakebed_a/banshee02)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant lake_a_hornets
	(ai_place lake_a_hornets)
	(ai_set_targeting_group lake_a_hornets 1)
	(sleep_until 
		(begin
			(if (<= (ai_living_count lake_a_hornets) 0)
				(ai_place lake_a_hornets)
			)
			(ai_set_targeting_group lake_a_hornets 1)
			(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0)
		)
	500)
	;(sleep_until (<= (ai_living_count lake_a_banshees01) 0))
	(ai_set_targeting_group lake_a_hornets -1)
)

(script command_script lake_a_hornet_init_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep 90)
	;(cs_enable_moving FALSE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(sleep (random_range 30 80))
					(cs_shoot_point TRUE lakebed_a_targets/hornet01a)
				)
				(begin
					(sleep (random_range 30 80))
					(cs_shoot_point TRUE lakebed_a_targets/hornet01b)
				)
				(begin
					(sleep (random_range 30 80))
					(cs_shoot_point TRUE lakebed_a_targets/hornet01c)
				)
			)
			FALSE
		)
	)
	
)

(script dormant lake_a_saves01
	(sleep_until (<= (ai_task_count lakebed_a_covenant_obj/ground_wraith_gate) 0))
	(sleep_until
		(begin
			(sleep_until (and
				(volume_test_players vol_lake_a_saves01)
				(game_safe_to_save))
			)
		(game_save)
		(sleep (* 30 90))
		FALSE
		)
	)
)

;Main script for lakebed A
(script dormant lakebed_a_start
	(flock_create "lake_a_banshees")
	(flock_create "lake_a_hornets")
	(flock_create "lake_a_phantoms")
	(flock_create "lake_a_bashee_excort01")
	(flock_create "lake_a_bashee_excort02")
	(flock_create "lake_a_banshees_ark")
	(sleep_until (volume_test_players vol_lakebed_a_start) 5)
	(print "LakeBed A start")
	(wake factory_a_cleanup)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_a_cov_ghosts/driver01) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_a_cov_ghosts/driver02) TRUE)
	;(ai_vehicle_reserve (ai_vehicle_get_from_starting_location tank_a_cov_ghosts/driver03) TRUE)
	
	;===skull===
	(wake gs_create_primary_skull)
	
	;wait until player opens door
	(sleep_until (> (device_get_position lakebed_a_entry_door) 0) 1)
	(data_mine_set_mission_segment "040_30_lakebed_a")
	
	;make sure this zone set stays loaded by disabling only zone set triggers
	(zone_set_trigger_volume_enable begin_zone_set:faa_lakea FALSE)
	(zone_set_trigger_volume_enable zone_set:faa_lakea FALSE)
	(prepare_to_switch_to_zone_set faa_lakea_fab)
	
	(ai_place lakebed_a_wraith_01)
	(ai_set_targeting_group lakebed_a_wraith_01/driver01 1)
	(wake lakebed_a_wraith_magic)
	(sleep 1)
	(ai_place lakebed_a_init_chopper01)
	(sleep 1)
	(ai_place lakebed_a_init_chopper02)
	(sleep 1)
	(wake lake_a_hornets)
	
	;dialog
	(wake md_lake_a_radio_sitrep)
	
	(game_save)
	(wake center_allies)
	
	(print "allies updating objs")
	(ai_set_objective allied_infantry lakebed_a_allies)
	(ai_set_objective allied_vehicles lakebed_a_allies)
	(wake lake_a_big_door_closer)
	(ai_disposable intro_tunnel_obj TRUE)
	(ai_disposable factory_a_covenant_obj TRUE)

	(ai_place lake_a_cov_center02)
	(sleep 1)
	(ai_place lakebed_a_init_phantoms)
	(cs_run_command_script lakebed_a_init_phantoms/driver01 phantom_init_drop01)

	(sleep 1)
	(cs_run_command_script lake_a_def_center/rocket_man rocket_man)
	(object_set_persistent (ai_vehicle_get_from_starting_location lakebed_a_wraith_01/driver01) TRUE)
	(wake lake_a_ghost_rein)
	(wake lake_a_wraith_drop)

	(sleep_until (<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0))
	(if
		(or
			(difficulty_heroic)
			(difficulty_legendary)
		)
		(begin
			(flock_stop "lake_a_banshees")
			;(wake lake_a_banshee_control)
			(ai_place lake_a_banshees01)
			(cs_run_command_script lake_a_banshees01 lake_a_banshees_entry_cs)
		)
	)
	(factory_a_garbage)
	(sound_looping_set_alternate levels\solo\040_voi\music\040_music_03 TRUE)
	(wake objective_1_clear)
	(wake md_laa_wraith_dead)
	(sleep_until (not (volume_test_players vol_lakebed_a_platform)))
	(device_set_position lakebed_a_entry_door 0)
	;give time for door to close
	(sleep 90)
	(game_save)
	(sleep_until (and
		(<= (ai_living_count lakebed_a_covenant_obj) 10)
		(<= (ai_task_count lakebed_a_covenant_obj/ghosts_gate) 2))
	)
	(switch_zone_set faa_lakea_fab)
	(sleep 20)
	(game_save)
	(ai_place lake_a_cov_end_grunts)
	(if (<= (ai_task_count lakebed_a_covenant_obj/ground_wraith_gate) 0)
		(ai_place lake_a_cov_end)
	)
	(print "fab door opening")
	(device_set_position factory_b_entry_door 1)
	(wake laa_nav_exit)
	(wake lake_a_saves01)
)

;Cleanup scripts for lakebed A
(script dormant lakebed_a_cleanup
	(sleep_forever lakebed_a_start)
	(sleep_forever gauss_nav_factory_a)
	(sleep_forever lake_a_banshee_control)
	(sleep_forever lake_a_center_saves)
	(sleep_forever lake_a_saves01)

	(flock_delete "lake_a_banshees")
	(flock_delete "lake_a_hornets")
	(flock_delete "lake_a_phantoms")
	(flock_delete "lake_a_bashee_excort01")
	(flock_delete "lake_a_bashee_excort02")
	(flock_delete "lake_a_banshees_ark")
	
	(object_set_persistent (ai_vehicle_get_from_starting_location lakebed_a_wraith_01/driver01) FALSE)
	(ai_disposable lake_a_hornets TRUE)
	(ai_disposable lake_a_banshees01 TRUE)
	(sleep 30)
	(kill_volume_enable kill_all_lakebed_a)
	(sleep 30)
	(lakebed_a_garbage)
	(kill_volume_disable kill_all_lakebed_a)
)

(script static void lakebed_a_garbage
	(add_recycling_volume lakebed_a_garbage 0 0)
)

;*********************************************************************;
;Factory B
;*********************************************************************;
(script dormant fab_ai_setup
	(ai_magically_see factory_b_cov_init factory_b_turrets)
	(sleep_until
		(begin
			(ai_renew factory_b_cov_init)
			(ai_renew factory_b_allies01)
			(ai_renew factory_b_turrets)
			FALSE
		)
	)
)

(script command_script fab_turret_shoot_cs
	(sleep_until
		(begin
			(cs_shoot_point TRUE factory_b/turret_shoot01)
			(sleep (random_range 0 200))
			(cs_shoot_point TRUE factory_b/turret_shoot02)
			(sleep (random_range 0 120))
			(cs_shoot_point TRUE factory_b/turret_shoot03)
			(sleep (random_range 0 120))
			FALSE
		)
	)
)

(script dormant fab_objectives
	(sleep_until
		(or
			(volume_test_players vol_fab)
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_p" (players))
		)
	)
	(ai_set_objective lakebed_a_allies/win factory_b_allies_obj)
	(ai_set_objective lakebed_a_allies/win_vehicle factory_b_allies_obj)
	(ai_set_objective lake_a_cov_end factory_b_cov_obj)
)

(script dormant factory_b_middle_doors
	(sleep_until (<= (ai_task_count factory_b_cov_obj/inf) 0))
	(sleep (random_range 30 50))
	(if (<= (device_get_position factory_b_entry02) 0)
		(begin
			(wake md_fab_hog_door)
			(sleep 90)
			(device_set_position factory_b_entry02 1)
			;*
			(device_set_power factory_b_entry02 1)
			(device_set_position factory_b_entry02 1)
			(device_set_power factory_b_entry02_side_low 1)
			(device_set_position factory_b_entry02_side_low 1)
			*;
		)
	)
)

(script dormant factory_b_combat_freeze
;this fuction is used to preserve combat if player ventures too far ahead
	(sleep_until
		(begin
			(sleep_until (volume_test_players vol_factory_b_tunnel))
			(sleep 10)
			(print "freezing combat")
			;(ai_cannot_die factory_b_cov_obj/combat_freeze TRUE)
			(sleep_until (not (volume_test_players vol_factory_b_tunnel)))
			(print "un-freezing combat")
			(ai_cannot_die all_enemies FALSE)
			FALSE
		)
	)
)

(script dormant wraith_blocker_fix
	;(sleep_until (volume_test_objects vol_lakebeda_wraithblock (ai_vehicle_get_from_starting_location lake_a_cov_end_wraith/driver01)))
	;(print "wraith blocking")
	(sleep_until
		(or
			(volume_test_players vol_pump_room_b_up_b)
			(volume_test_players vol_factory_b_center)
			(= wave 2)
		)
	)
	(unit_kill (ai_vehicle_get_from_starting_location lake_a_cov_end_wraith/driver01))
	(sleep_until (not (objects_can_see_object (players) (ai_vehicle_get_from_starting_location lake_a_cov_end_wraith/driver01) 30)))
	(object_destroy (ai_vehicle_get_from_starting_location lake_a_cov_end_wraith/driver01))
)

(script command_script factory_b_phantom_exit
	(print "final phantom inbound")
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to factory_b/phantom_exit)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant bugger_spawn
	(print "spawn buggers")
	(ai_place factory_b_cov_bugs01)
	(sleep 30)
	
	;dialog
	(print "dialog: buggers!!... fall back!!!")
	
	(sleep_until
		(begin
			(ai_place factory_b_cov_bugs02)
			(sleep 5)
			(sleep_until (<= (ai_living_count all_enemies) 12) 5)
			;keep spawning more buggers until buggers in exiting task
			(>= (ai_living_count factory_b_cov_obj/bugger_exit) 1)
		)
	)
	(print "buggers done")
	(cs_run_command_script factory_b_cov_bugs01 bugger_exit)
	(cs_run_command_script factory_b_cov_bugs02 bugger_exit)
	(cs_run_command_script factory_b_cov_bugs03 bugger_exit)
	(sleep 60)
	(cs_run_command_script factory_b_phantom/driver01 factory_b_phantom_exit)
	
	;music
	(set g_music_040_05 FALSE)
)

(script command_script bugger_exit
;	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)
	(sleep (random_range 30 120))
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)
	(cs_enable_moving FALSE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_fly_to factory_b/bugger_exit01)
					(cs_fly_to factory_b/bugger_exit_final)
					(ai_erase ai_current_actor)
				)
				(begin
					(cs_fly_to factory_b/bugger_exit02)
					(cs_fly_to factory_b/bugger_exit_final)
					(ai_erase ai_current_actor)
				)
				(begin
					(cs_fly_to factory_b/bugger_exit03)
					(cs_fly_to factory_b/bugger_exit_final)
					(ai_erase ai_current_actor)
				)
			)
			(begin_random
				(begin
					(cs_fly_to factory_b/bugger_exit_guide01)
					(cs_run_command_script ai_current_actor bugger_exit)
				)
				(begin
					(cs_fly_to factory_b/bugger_exit_guide02)
					(cs_run_command_script ai_current_actor bugger_exit)
				)
			)
			FALSE
		)
			
	)
)

(script static void test_buggers
	(gs_camera_bounds_off)
	(ai_place factory_b_phantom)
	(cs_run_command_script factory_b_phantom/driver01 pause_forever)
	;(sleep 30)
	;(cs_run_command_script factory_b_phantom/driver01 factory_b_phantom_exit)
	(wake bugger_spawn)
	
	;this was the old way of switching zones
	;(wake zone_set_lab_go)
)

(script dormant fab_turret_exit
	(sleep_until
		(or
			(<= (ai_task_count factory_b_cov_obj/inf) 0)
			(>= (ai_task_count factory_b_cov_obj/buggers_arrive_gate) 1)
		)
	)
	(sleep 60)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location factory_b_turrets/turret01) TRUE)
	(vehicle_unload (ai_vehicle_get_from_starting_location factory_b_turrets/turret01) "")
)

(script command_script goose_pause
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (unit_in_vehicle ai_current_actor))
	(cs_enable_moving FALSE)
	(sleep_forever)
)

(script dormant fab_entry_door_closer

	;wait til player is in center, then shut fab entry door
	(sleep_until (volume_test_players vol_factory_b_center) 5)
	(device_group_change_only_once_more_set fab_entry_buttons FALSE)
	(device_set_position factory_b_entry_door 0)
	(sleep_until (<= (device_get_position factory_b_entry_door) 0) 5)
	
	;when fab entry door closed, cleanup Lakebed A
	(fab_coop_teleport)
	(wake lakebed_a_cleanup)
	
	;when player advances into tunnel, start moving bugger cov out
	(sleep_until (volume_test_players vol_factory_b_tunnel) 5)
	(sleep_forever bugger_spawn)
	(cs_run_command_script factory_b_phantom/driver01 factory_b_phantom_exit)
	(cs_run_command_script factory_b_cov_bugs01 bugger_exit)
	(cs_run_command_script factory_b_cov_bugs02 bugger_exit)
	(cs_run_command_script factory_b_cov_bugs03 bugger_exit)
	
	;wait until phantom gone (or 5 seconds), then enable zone switch
	(sleep_until (<= (ai_living_count factory_b_phantom) 0) 5 (* 30 5))
	(print "preparing to swich to lakeb zone set")
	(zone_set_trigger_volume_enable begin_zone_set:fab_lakeb TRUE)
	(sleep_until (= (current_zone_set_fully_active) 5) 1)
	(device_set_position lakebed_b_entry_door 1)
	(ai_erase lake_a_def_center)
)

(script static void fab_coop_teleport
	(print "teleport backup")
	(if (or (volume_test_object vol_fab_coop_teleport01 (player0)) (volume_test_object vol_fab_coop_teleport02 (player0))) 
		(object_teleport (player0) fab_coop_teleport_player0)
	)
	(if (or (volume_test_object vol_fab_coop_teleport01 (player1)) (volume_test_object vol_fab_coop_teleport02 (player1))) 
		(object_teleport (player1) fab_coop_teleport_player1)
	)
	(if (or (volume_test_object vol_fab_coop_teleport01 (player2)) (volume_test_object vol_fab_coop_teleport02 (player2))) 
		(object_teleport (player2) fab_coop_teleport_player2)
	)
	(if (or (volume_test_object vol_fab_coop_teleport01 (player3)) (volume_test_object vol_fab_coop_teleport02 (player3))) 
		(object_teleport (player3) fab_coop_teleport_player3)
	)
)

(script dormant fab_button_pusher
	;Make sure entry door closed and give enough time for cleanup of irrelevant allies
	(sleep_until (<= (device_get_position factory_b_entry_door) 0))
	(sleep 30)
	(if (<= (device_group_get factory_b_middle_buttons) 0)
		;(cs_run_command_script (object_get_ai (list_get (ai_actors intro_troop_hogs) 0)) button_pusher02_cs)
		(begin
			(vs_cast (object_get_ai (list_get (ai_actors factory_b_allies_obj/bugger_fight) 0)) TRUE 2 "")
			(vs_enable_pathfinding_failsafe factory_b_allies_obj/bugger_fight TRUE)
			(vs_enable_looking factory_b_allies_obj/bugger_fight TRUE)
			(vs_enable_targeting factory_b_allies_obj/bugger_fight TRUE)
			(print "I'll get the door, Chief")
			(vs_go_to (vs_role 1) TRUE factory_b/buttonpush)
			(device_set_position factory_b_middle_switch 1)
			(vs_release_all)
		)
	)
)

(script command_script fab_goose_pass_cs
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (unit_in_vehicle ai_current_actor))
	(print "in vehicle")
	(cs_enable_moving FALSE)
	(sleep_forever)
)

;Main script for Factory Arms B
(script dormant factory_b_start
	;Wait until door opens
	(sleep_until (> (device_get_position factory_b_entry_door) 0) 5)
	;(sleep_until (> (device_get_position lakebed_b_entry_switch) 0))
	(sleep_until (volume_test_players vol_factory_b_init) 5)
	(data_mine_set_mission_segment "040_40_factory_b")
	(print "Factory Arms B start")
	(wake fab_objectives)
	
	;music
	(set g_music_040_04 FALSE)
	(game_save)

	;re-enforce a max num of 6 marines
	(set wave 1)
	(set testNum (- 4 (ai_living_count lakebed_a_allies)))
	(if (< testNum 2) (set testNum 2))
	(sleep 1)

	;if gauss hog is still alive
	;(if (not (<= (object_get_health (ai_vehicle_get_from_starting_location intro_hog/driver)) 0))
	;	(wake gauss_nav_factory_b)
	;)
	
	(ai_disposable lakebed_a_covenant_obj TRUE)
	
	(ai_place factory_b_cov_init)
	(ai_place factory_b_cov_init02)
	;(ai_place factory_b_injured)
	(ai_place factory_b_allies01 testNum)
	(ai_place factory_b_turrets)
	(cs_run_command_script factory_b_turrets fab_turret_shoot_cs)
	(ai_place factory_b_phantom)
	(cs_run_command_script factory_b_phantom/driver01 pause_forever)
	(ai_disregard (ai_actors factory_b_phantom) TRUE)
	(wake fab_ai_setup)
	(wake factory_b_middle_doors)
	(wake cor_fab)
	
	;dialog
	(wake md_fab_new_rahrah)
	(sleep_until (volume_test_players vol_fab_entryroom))
	(sleep_forever fab_ai_setup)
	(cs_run_command_script factory_b_turrets abort)
	(wake md_fab_new_contact)

	;(wake fab_turret_exit)
	(if (<= (ai_task_count factory_b_cov_obj/inf) 8)
		(ai_place factory_b_cov_init03)
	)
	
	;====== ZONE SET CONTROL ======
	(wake fab_entry_door_closer)

	(sleep_until (volume_test_players vol_factory_b_buginit) 5)
	(print "Encounter:Buggers")
	(data_mine_set_mission_segment "040_41_factory_b02")
	(game_save)
	(object_create bugger_glass_break)
	(sleep 10)
	(object_destroy bugger_glass_break)
	
	;sleep until cov_inf are dead, or player advances, or the player looks up at the phantom
	(sleep_until
		(or
			(<= (ai_task_count factory_b_cov_obj/inf) 0)
			(volume_test_players vol_factory_b_buginit03)
			(objects_can_see_object (player0) (ai_vehicle_get_from_starting_location factory_b_phantom/driver01) 30)
		)
	)
	;See if we can get player to look up
	(sleep_until 
		(or
			(objects_can_see_object (player0) (ai_vehicle_get_from_starting_location factory_b_phantom/driver01) 50)
			(> (device_get_position factory_b_middle) 0)
		)
	1 (* 30 12))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location factory_b_turrets/turret01) TRUE)
	(vehicle_unload (ai_vehicle_get_from_starting_location factory_b_turrets/turret01) "")
	(ai_disregard (ai_actors factory_b_phantom) FALSE)
	(lakebed_a_garbage)
	(wake bugger_spawn)
	(wake fab_button_pusher)
	
	;music
	(wake music_040_05)
	(set g_music_040_05 TRUE)
	
	;dialog
	(wake md_fab_mar_buggers)
	
	;this was the old way of switching zones
	;(wake zone_set_lab_go)
	
	(sleep_until (> (device_get_position factory_b_middle) 0) 1)
	;Geese:
	(print "Mongoose Intro")
	(ai_place factory_b_allies_goose_init)
	(cs_run_command_script factory_b_allies_goose_init pause_forever)
	;(cs_run_command_script factory_b_allies_goose_init/goose04 abort)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose01) "mongoose_p" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose02) "mongoose_p" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_p" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose04) "mongoose_p" TRUE)
	(ai_place factory_b_allies_goose_pass)
	(cs_run_command_script factory_b_allies_goose_pass/sniper01 pause_forever)
	(cs_run_command_script factory_b_allies_goose_pass/sniper02 pause_forever)
	(cs_run_command_script factory_b_allies_goose_pass/rocket01 pause_forever)
	(ai_vehicle_enter factory_b_allies_goose_pass/rocket02 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose04) "mongoose_p")
	;(device_set_position tank_room_b_exit02 1)
	(sleep_until 
		(and
			(volume_test_players vol_factory_b_tunnel_end)
			(not g_cortana_playing)
		)
	)
	(wake md_fab_goose)
	;(device_set_position factory_b_middle 0)
	(sleep_forever bugger_spawn)
	
	(game_save)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_d" FALSE)
	(cs_run_command_script factory_b_allies_goose_pass/sniper01 abort)
	(cs_run_command_script factory_b_allies_goose_pass/sniper02 abort)
	(cs_run_command_script factory_b_allies_goose_pass/rocket01 abort)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose01) "mongoose_p" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose02) "mongoose_p" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_p" FALSE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose04) "mongoose_p" FALSE)
	(ai_vehicle_enter factory_b_allies_goose_pass/rocket01 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_p")
	(ai_vehicle_enter factory_b_allies_goose_pass/sniper01 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose02) "mongoose_p")
	(ai_vehicle_enter factory_b_allies_goose_pass/sniper02 (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose01) "mongoose_p")
	;(cs_run_command_script factory_b_allies_goose_pass fab_goose_pass_cs)
	
	(if (= (game_is_cooperative) FALSE)
	;single player
	(sleep_until 
		(or 
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose01) "mongoose_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose02) "mongoose_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_d" (players))
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose04) "mongoose_d" (players))
			(volume_test_players vol_lakebed_b_ledge)
		)
	)
	;coop
	(sleep_until (volume_test_players vol_lakebed_b_ledge))
	)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location factory_b_allies_goose_init/goose03) "mongoose_d" FALSE)
	(cs_run_command_script factory_b_allies_goose_init abort)
	(ai_set_objective allied_goose lakebed_b_allies)
	(ai_set_objective factory_b_allies_obj/hog_goose lakebed_b_allies)
	(ai_enter_squad_vehicles all_allies)
	(wake md_punch_hard)
)

;Cleanup scripts for Pump Room B
(script dormant factory_b_cleanup
	(sleep_until (volume_test_players vol_lakebed_b_ledge))
	(ai_disposable factory_b_cov_obj TRUE)
	;(sleep_forever factory_b_start)
	(sleep_forever wraith_blocker_fix)
	(sleep_forever factory_b_middle_doors)
	(device_one_sided_set factory_b_entry_door TRUE)
)

(script static void factory_b_garbage
	(add_recycling_volume factory_b_garbage 0 0)
)

;*********************************************************************;
;Lakebed B
;*********************************************************************;
(script dormant crane_ctrl
	(sleep_until
		(begin
			(sleep_until
				(or
					(>= (device_get_position crane_elevator_left) 1)
					(>= (device_get_position crane_elevator_right) 1)
				)
			)
			(sleep 60)
			(sleep_until 
				(not 
					(or 
						(volume_test_players vol_lakebed_b_crane_left)
						(volume_test_players vol_lakebed_b_crane_right)
					)
				)
			)
			(device_set_position crane_switch_left 0)
			(device_set_position crane_switch_right 0)
			FALSE
		)
	)
)

(script dormant lake_a_big_door_closer02
	(sleep_until (volume_test_players vol_lake_b_doorcheck))
	(device_set_position tank_room_b_exit02 0)
)

;COVENANT RE-ENFORCEMENT SCRIPTS========================================

(script static void lakebed_b_cov_drop_ghosts_go
	(print "rein ghosts")
	(set wave (+ wave 1))
	(lakebed_b_garbage)
	(ai_place lakebed_b_phantoms)
	(ai_set_targeting_group lakebed_b_phantoms 1)
	(ai_place lakebed_b_cov_rein_back_ghosts)
	(ai_place lakebed_b_cov_rein_front_ghosts)
	(ai_renew all_allies)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_b_phantoms/driver01) "phantom_sc01" (ai_vehicle_get_from_starting_location lakebed_b_cov_rein_back_ghosts/driver01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_b_phantoms/driver01) "phantom_sc02" (ai_vehicle_get_from_starting_location lakebed_b_cov_rein_back_ghosts/driver02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_b_phantoms/driver02) "phantom_sc01" (ai_vehicle_get_from_starting_location lakebed_b_cov_rein_front_ghosts/driver01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_b_phantoms/driver02) "phantom_sc02" (ai_vehicle_get_from_starting_location lakebed_b_cov_rein_front_ghosts/driver02))
	(cs_run_command_script lakebed_b_phantoms/driver02 lakebed_b_cov_drop_ghosts01_cs)
	(cs_run_command_script lakebed_b_phantoms/driver01 pause_forever)
	(sleep 100)
	(cs_run_command_script lakebed_b_phantoms/driver01 lakebed_b_cov_drop_ghosts02_cs)
)

(script static void test_lakebed_b_phantoms
	(ai_set_task_condition lakebed_b_covenant_obj/dumb_init FALSE)
	(wake lakeb_BFG_go)
	(sleep 30)
	(ai_place lakebed_b_phantoms)
	(ai_set_targeting_group lakebed_b_phantoms 1)
	(ai_place lakebed_b_cov_rein_back_ghosts)
	(ai_place lakebed_b_cov_rein_front_ghosts)
	(ai_renew all_allies)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_b_phantoms/driver01) "phantom_sc01" (ai_vehicle_get_from_starting_location lakebed_b_cov_rein_back_ghosts/driver01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_b_phantoms/driver01) "phantom_sc02" (ai_vehicle_get_from_starting_location lakebed_b_cov_rein_back_ghosts/driver02))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_b_phantoms/driver02) "phantom_sc01" (ai_vehicle_get_from_starting_location lakebed_b_cov_rein_front_ghosts/driver01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location lakebed_b_phantoms/driver02) "phantom_sc02" (ai_vehicle_get_from_starting_location lakebed_b_cov_rein_front_ghosts/driver02))
	(cs_run_command_script lakebed_b_phantoms/driver02 lakebed_b_cov_drop_ghosts01_cs)
	(cs_run_command_script lakebed_b_phantoms/driver01 pause_forever)
	(sleep 100)
	(cs_run_command_script lakebed_b_phantoms/driver01 lakebed_b_cov_drop_ghosts02_cs)
)

(script command_script lakebed_b_cov_drop_ghosts01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by lakebed_b/phantom_init 8)
	(cs_vehicle_boost FALSE)
	(cs_fly_to lakebed_b/phantom_backhalf_ghosts 1)
	(cs_enable_targeting TRUE)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc02")
	(sleep 60)
	(cs_enable_targeting FALSE)
	(cs_run_command_script ai_current_actor lakeb_phantom_exit)
)

(script command_script lakebed_b_cov_drop_ghosts02_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by lakebed_b/phantom_init 8)
	(cs_vehicle_boost FALSE)
	(cs_fly_to lakebed_b/phantom_fronthalf_guide)
	(cs_fly_to lakebed_b/phantom_fronthalf_ghosts02 1)
	(cs_enable_targeting TRUE)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc01")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_sc02")
	(sleep 60)
	(cs_fly_to lakebed_b/phantom_fronthalf_guide)
	(cs_enable_targeting FALSE)
	(cs_run_command_script ai_current_actor lakeb_phantom_exit)
)

(script command_script lakeb_phantom_exit
;script used to usher the phantoms out of the area
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to lakebed_b/phantom_guide_high)
	(lake_b_surfer_kill)
	(cs_fly_by lakebed_b/phantom_guide_high02 8)
	(cs_vehicle_boost TRUE)
	(cs_fly_to lakebed_b/phantom_exit_high 2)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script static void lake_b_surfer_kill
	(print "killing surfers")
	(if (volume_test_object vol_lake_b_surf (player0)) (unit_kill (player0)))
	(if (volume_test_object vol_lake_b_surf (player1)) (unit_kill (player1)))
	(if (volume_test_object vol_lake_b_surf (player2)) (unit_kill (player2)))
	(if (volume_test_object vol_lake_b_surf (player3)) (unit_kill (player3)))
)

(script static void lake_b_surfer_kill02
	(print "killing surfers")
	(if (volume_test_object vol_lake_b_surf02 (player0)) (unit_kill (player0)))
	(if (volume_test_object vol_lake_b_surf02 (player1)) (unit_kill (player1)))
	(if (volume_test_object vol_lake_b_surf02 (player2)) (unit_kill (player2)))
	(if (volume_test_object vol_lake_b_surf02 (player3)) (unit_kill (player3)))
)

;Scripts Wraiths to bombard the other factory arm
(script command_script lakebed_b_wraiths_shoot
	;(cs_enable_moving TRUE)
	;(cs_abort_on_damage TRUE)
	(sleep_until
		(begin
			(begin_random
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_b_targets/p0)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_b_targets/p1)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_b_targets/p2)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_b_targets/p3)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_b_targets/p4)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_b_targets/p5)
				)
				(begin
					(sleep (random_range 30 150))
					(cs_shoot_point TRUE lakebed_b_targets/p6)
				)
			)
			(<= (ai_strength ai_current_actor) .2)
		)
	)
	(print "AA wraith breaking script")
)

;==== BFG ===
(script static void lakeb_BFG_aim
	(device_animate_overlay lakeb_bfg_base (real_random_range .332 .334) (random_range 2 3) .1 .1)
	;(device_animate_overlay bfg_turret (random_range 0 1) (random_range 2 3) .1 .1)
	(sleep 60)
)

(script dormant lakeb_BFG_shoot
	(sleep_until
		(begin
			(print "LakeB BFG shoot")
			(lakeb_BFG_aim)
			(lakeb_BFG_shoot_anim)
			(if (>= (ai_living_count scarab) 1)
				(sleep 200)
			)
			(sleep (random_range 10 30))
			FALSE
		)
	)
)

(script static void lakeb_BFG_shoot_anim
	(device_animate_overlay lakeb_bfg_turret 1 3 0 0)
	(sleep 90)
	(device_animate_overlay lakeb_bfg_turret 0 0 0 0)
)

(script static void bfg_shake_fx
	(screen_shake_small_impact)
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_dust_fall_small\human_dust_fall_small.effect" office_fx01)
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_dust_fall_small\human_dust_fall_small.effect" office_fx02)
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_dust_fall_small\human_dust_fall_small.effect" office_fx03)
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_dust_fall_small\human_dust_fall_small.effect" fab_fx01)
	(effect_new_random "fx\scenery_fx\ceiling_dust\human_dust_fall_small\human_dust_fall_small.effect" fab_fx02)
)

(script dormant lakeb_BFG_go
	(object_create lakeb_bfg_base)
	(object_create lakeb_bfg_turret)
	(objects_attach lakeb_bfg_base "turret" lakeb_bfg_turret "")
	(device_set_position_track lakeb_bfg_base position 0)
	(device_set_overlay_track lakeb_bfg_base power)
	(device_set_position_track lakeb_bfg_turret position 0)
	(device_set_overlay_track lakeb_bfg_turret power)
	(device_animate_overlay lakeb_bfg_base .333 0 0 0)
	(device_animate_overlay lakeb_bfg_turret 0 0 0 0)
	(wake lakeb_BFG_shoot)
)

(script dormant lakeb_BFG_cleanup
	(sleep_forever lakeb_BFG_shoot)
	(object_destroy lakeb_bfg_base)
	(object_destroy lakeb_bfg_turret)
)

(script dormant lakeb_aa_preference
	(sleep_until
		(begin
			(ai_prefer_target_ai lakebed_b_allies/vehicles lakebed_b_covies TRUE)
			(sleep 1)
			(ai_prefer_target_ai lakebed_b_allies/player_vehicles lakebed_b_covies FALSE)
			(sleep 90)
			(<= (ai_task_count lakebed_b_covenant_obj/wraith_gate) 0)
		)
	)
)

(script command_script lake_b_hornet_init_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep 90)
	(cs_face TRUE lakebed_b_targets/hornet01a)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_enable_moving FALSE)
					(sleep (random_range 30 80))
					(cs_shoot_point TRUE lakebed_b_targets/hornet01a)
					(cs_enable_moving TRUE)
				)
				(begin
					(cs_enable_moving FALSE)
					(sleep (random_range 30 80))
					
					(cs_shoot_point TRUE lakebed_b_targets/hornet01b)
					(cs_enable_moving TRUE)
				)
				(begin
					(cs_enable_moving FALSE)
					(sleep (random_range 30 80))
					
					(cs_shoot_point TRUE lakebed_b_targets/hornet01c)
					(cs_enable_moving TRUE)
				)
			)
			FALSE
		)
	)
	
)
;*
(script dormant lake_b_banshee_control
	(sleep_until (>= (ai_living_count scarab) 1))
	(if (<= (ai_living_count lakebed_b_banshees01) 1)
		(begin
			(lakebed_b_garbage)
			(ai_place lakebed_b_banshees01)
			(ai_magically_see lakebed_b_wraith_01 lakebed_b_hornets01)
			(ai_magically_see lakebed_b_wraith_02 lakebed_b_hornets01)
			(ai_set_targeting_group lakebed_b_banshees01 1)
			(ai_set_targeting_group lakebed_b_hornets01 1)
		)
	)
	(sleep_until (<= (ai_task_count lakebed_b_covenant_obj/banshee_gate) 0))
	(ai_set_targeting_group lakebed_b_hornets01 -1)
)
*;
(script dormant lake_b_hornet_control
	(sleep_until
		(begin
			(ai_place lakebed_b_hornets01)
			(if (>= (ai_living_count lakebed_b_wraiths) 1)
				(ai_set_targeting_group lakebed_b_hornets01 1)
				(ai_set_targeting_group lakebed_b_hornets01 -1)
			)
			(ai_magically_see lakebed_b_wraith_01 lakebed_b_hornets01)
			(ai_magically_see lakebed_b_wraith_02 lakebed_b_hornets01)
			(sleep_until (<= (ai_living_count lakebed_b_hornets01) 0))
			(lakebed_b_garbage)
			(sleep (random_range 100 200))
			FALSE
		)
	)
)

(script command_script lake_b_pelican01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by lakebed_b/pelican01a)
	(cs_vehicle_boost TRUE)
	(cs_fly_by lakebed_b/pelican01b 8)
	(cs_vehicle_boost FALSE)
	(cs_face TRUE lakebed_b/pelican01_face)
	(cs_fly_to lakebed_b/pelican01c 1)
	
	;(if (<= (ai_task_count lakebed_b_allies/cov_dead_vehicles) 5)
	;	(begin
			(ai_place lake_b_goose02/driver01)
			(ai_place lake_b_goose02_drivers/driver01)
			(ai_place lake_b_goose02_drivers/pass01)
			(ai_vehicle_enter_immediate lake_b_goose02_drivers/driver01 (ai_vehicle_get_from_starting_location lake_b_goose02/driver01) "mongoose_d")
			(ai_vehicle_enter_immediate lake_b_goose02_drivers/pass01 (ai_vehicle_get_from_starting_location lake_b_goose02/driver01) "mongoose_p")
	;	)
	;)
	(if (<= (ai_task_count lakebed_b_allies/cov_dead_vehicles) 3)
		(begin
			(ai_place lake_b_goose02/driver02)
			(ai_place lake_b_goose02_drivers/driver02)
			(ai_place lake_b_goose02_drivers/pass02)
			(ai_vehicle_enter_immediate lake_b_goose02_drivers/driver02 (ai_vehicle_get_from_starting_location lake_b_goose02/driver02) "mongoose_d")
			(ai_vehicle_enter_immediate lake_b_goose02_drivers/pass02 (ai_vehicle_get_from_starting_location lake_b_goose02/driver02) "mongoose_p")
		)
	)
	
	(unit_open (ai_vehicle_get ai_current_actor))
	(cs_run_command_script (ai_get_driver lake_b_goose02/driver01) pause_forever)
	(cs_run_command_script (ai_get_driver lake_b_goose02/driver02) pause_forever)
	(sleep 80)
	(cs_run_command_script (ai_get_driver lake_b_goose02/driver01) lake_b_goose_cs)
	(sleep 30)
	(cs_run_command_script (ai_get_driver lake_b_goose02/driver02) lake_b_goose_cs)
	(sleep 60)
	;(sleep 150)
	
	
	(unit_close (ai_vehicle_get ai_current_actor))
	(cs_fly_to lakebed_b/pelican01d 1)
	(lake_b_surfer_kill02)
	(sleep_until (>= (ai_living_count scarab) 1))
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep 110)
)

(script command_script lake_b_goose_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_vehicle_exit TRUE)
	(cs_vehicle_speed_instantaneous 6)
	(cs_go_to lakebed_b/goose01a 1)
)

(script static void test_lakeb_pelicans
	(ai_place lakebed_b_pelicans01)
	(cs_run_command_script lakebed_b_pelicans01/driver01 lake_b_pelican01_cs)
)

(script dormant lakebed_b_cov_drop_ghosts
	(lakebed_b_cov_drop_ghosts_go)
	(sleep_until (and
		(<= (ai_living_count lakebed_b_covenant_obj/ghosts) 2)
		(<= (ai_living_count lakebed_b_covenant_obj/choppers) 1)
		(<= (ai_living_count lakebed_b_covenant_obj/phantoms) 0)
		(<= (ai_living_count lakebed_b_phantoms) 0)
		;(any_players_in_vehicle)
		)
	)
	(lakebed_b_cov_drop_ghosts_go)
	(wake lake_b_zone_switch)
)

(script dormant lake_b_zone_switch
	(if (= (game_is_cooperative) FALSE)
		;if not coop
		(sleep_until (and
			(not (volume_test_players vol_lakebed_b_entryprox))
			(not (volume_test_players vol_fab)))
		)
		;if coop
		(sleep_until (volume_test_players vol_scarab_coop_test))
	)
	(device_set_position lakebed_b_entry_door 0)
	(sleep_until (<= (device_get_position lakebed_b_entry_door) 0))
	(scarab_coop_teleport)
	(zone_set_trigger_volume_enable begin_zone_set:scarab TRUE)
	(sleep (* 30 15))
	(sleep_until (<= (ai_task_count lakebed_b_covenant_obj/wraith_gate) 0) 5)
	;(sleep_until (>= wave waveMax) 5)
	(sleep_until (<= (ai_living_count lakebed_b_covenant_obj/phantoms) 0) 5)
	(switch_zone_set scarab)
	(sleep 30)
	(device_set_power lakebed_b_exit 1)
	(device_set_position lakebed_b_exit 1)
)

;===========================
;Lakebed B
;===========================
(script dormant lakebed_b_start
	(flock_create "lake_b_banshees")
	(flock_create "lake_b_hornets")
	(flock_create "lake_b_phantoms")
	(flock_create "lake_b_bashee_excort01")
	(flock_create "lake_b_bashee_excort02")
	(sleep_until (volume_test_players vol_lakebed_b_start) 5)
	(print "lakebed b start")
	(data_mine_set_mission_segment "040_50_lakebed_b")
	(ai_set_objective allied_goose lakebed_b_allies)
	(wake lakeb_BFG_go)
	;(cs_run_command_script factory_b_allies_goose_init abort)
	(sleep 1)
	(wake factory_b_cleanup)
	(wake crane_ctrl)
	(set waveMax 3)
	(ai_place lake_b_def_center)
	(ai_place lake_b_def_turrets)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location lake_b_def_turrets/turret01) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location lake_b_def_turrets/turret02) TRUE)
	(ai_place lakebed_b_ghosts)
	(ai_place lakebed_b_wraith_01)
	(ai_place lakebed_b_wraith_02)
	(ai_set_targeting_group lakebed_b_wraith_01/driver01 1)
	(ai_set_targeting_group lakebed_b_wraith_02/driver01 1)
	(wake lake_b_hornet_control)
	(object_set_persistent (ai_vehicle_get_from_starting_location lakebed_b_wraith_01/driver01) TRUE)
	(object_set_persistent (ai_vehicle_get_from_starting_location lakebed_b_wraith_02/driver01) TRUE)
	
	(sleep_until (volume_test_players vol_lakebed_b_ledge))
	(factory_b_garbage)
	(game_save)
	(ai_place lakebed_b_cov_inf)
	(ai_disposable factory_b_allies_obj TRUE)
	(wake lake_a_big_door_closer02)
	;(wake lakeb_aa_preference)
	(set wave 1)
	(sleep 90)
	(wake lakebed_b_cov_drop_ghosts)
	
	(sleep_until (<= (ai_task_count lakebed_b_covenant_obj/wraith_gate) 2))
	;(wake lake_b_zone_switch)
	(wake md_lab_wraith01)
	;(ai_place lakebed_b_banshees01)
	;(ai_set_targeting_group lakebed_b_banshees01 1)
	(game_save)
	
	(sleep_until (<= (ai_task_count lakebed_b_covenant_obj/wraith_gate) 0))
	(print "AA wraiths are dead")
	(ai_enter_squad_vehicles all_allies)
	(ai_place lakebed_b_banshees01)
	(ai_set_targeting_group lakebed_b_hornets01 -1)
	(wake objective_2_clear)
	(game_save)
	(lakebed_b_garbage)
)

;*********************************************************************;
;Scarab
;*********************************************************************;
(script dormant scarab_allies_backup
	(sleep 60)
	(sleep_until
		(begin
			(if (<= (ai_task_count lakebed_b_allies/scarab_init) 1)
				(begin
					(if (not (volume_test_players_all vol_lake_b_backup_area))
						(ai_place lake_b_allies_backup)
					)
					(sleep 1)
					(ai_enter_squad_vehicles all_allies)
				)
			)
			(sleep_until (<= (ai_task_count lakebed_b_allies/scarab_init) 1))
			(<= (ai_living_count scarab) 0)
		)
	)		
)

(script command_script scarab_shoot
	(cs_face TRUE scarab_shoot/p3)
	(sleep 90)
	(begin_random
		(begin
			(cs_shoot_point TRUE scarab_shoot/p0)
			(sleep (random_range 60 160))
			;(cs_run_command_script scarab abort)
		)
		(begin
			(cs_shoot_point TRUE scarab_shoot/p1)
			(sleep (random_range 60 160))
			;(cs_run_command_script scarab abort)
		)
		(begin
			(cs_shoot_point TRUE scarab_shoot/p2)
			(sleep (random_range 60 160))
			;(cs_run_command_script scarab abort)
		)
		(begin
			(cs_shoot_point TRUE scarab_shoot/p3)
			(sleep (random_range 60 160))
			;(cs_run_command_script scarab abort)
		)
		(cs_run_command_script ai_current_actor abort)
	)
)

(script command_script scarab_shoot_front
	(begin_random
		(cs_run_command_script ai_current_actor abort)
		(cs_run_command_script ai_current_actor scarab_shoot)
		(sleep 80)
	)
)

(script command_script scarab_shoot_present
	(cs_face TRUE scarab_shoot/p3)
	(begin_random
		(begin
			(cs_shoot_point TRUE scarab_shoot/p0)
			(sleep (random_range 60 160))
			;(cs_run_command_script scarab abort)
		)
		(begin
			(cs_shoot_point TRUE scarab_shoot/p1)
			(sleep (random_range 60 160))
			;(cs_run_command_script scarab abort)
		)
		(begin
			(cs_shoot_point TRUE scarab_shoot/p2)
			(sleep (random_range 60 160))
			;(cs_run_command_script scarab abort)
		)
		(begin
			(cs_shoot_point TRUE scarab_shoot/p3)
			(sleep (random_range 60 160))
			;(cs_run_command_script scarab abort)
		)
	)
	(print "present waiting")
	(sleep_until (not (or (volume_test_players vol_lakebed_b_crane_left)(volume_test_players vol_lakebed_b_crane_right))) 30 (* 30 20))
	(print "present done fgamewaiting")
	(cs_go_to scarab_patrol/middle01)
)

(script command_script scarab_present_right
	(print "present right")
	(cs_enable_pathfinding_failsafe TRUE)
	;(cs_face TRUE scarab_shoot/p3)
	(cs_go_to2 scarab_patrol/P0 1)
	(print "finished goto point Right")
	;(cs_go_to scarab_patrol/Right01)
	(cs_run_command_script scarab/driver01 scarab_shoot_present)
)

(script command_script scarab_present_left
	(print "present left")
	(cs_enable_pathfinding_failsafe TRUE)
	;(cs_go_to scarab_patrol/Left01)
	(cs_go_to scarab_patrol/P1)
	(print "finished goto point Left")
	;(cs_face TRUE scarab_shoot/p3)
	(cs_run_command_script scarab/driver01 scarab_shoot_present)
)

(script dormant scarab_present
	(sleep_until
		(begin
			(sleep_until (or (volume_test_players vol_scarab_crane_left)(volume_test_players vol_scarab_crane_right)))
			(if (volume_test_players vol_scarab_crane_right)
				(cs_run_command_script scarab/driver01 scarab_present_right)
				(cs_run_command_script scarab/driver01 scarab_present_left)
			)
			(sleep_until (not (or (volume_test_players vol_scarab_crane_left)(volume_test_players vol_scarab_crane_right))))
			(<= (ai_living_count scarab) 0)
		)
	)
)

(script static void scarab_coop_teleport
	(print "teleport backup")
	(if 
		(and (volume_test_object vol_scarab_coop_teleport01 (player0))
			(not (volume_test_object vol_scarab_coop_teleport02 (player0)))
		) 
		(object_teleport (player0) scarab_coop_teleport_player0)
	)
	(if 
		(and (volume_test_object vol_scarab_coop_teleport01 (player1))
			(not (volume_test_object vol_scarab_coop_teleport02 (player1)))
		) 
		(object_teleport (player1) scarab_coop_teleport_player1)
	)
	(if 
		(and (volume_test_object vol_scarab_coop_teleport01 (player2))
			(not (volume_test_object vol_scarab_coop_teleport02 (player2)))
		) 
		(object_teleport (player2) scarab_coop_teleport_player2)
	)
	(if 
		(and (volume_test_object vol_scarab_coop_teleport01 (player3))
			(not (volume_test_object vol_scarab_coop_teleport02 (player3)))
		) 
		(object_teleport (player3) scarab_coop_teleport_player3)
	)
)

(script dormant scarab_saves
	(sleep_until (volume_test_players vol_scarab))
	(print "player on scarab")
	
	;dialog
	(sleep_forever md_lab_mar_scarab_hints_03)
	(wake md_lab_mar_scarab_hints_04)
	
	(game_save)
	(sleep_until
		(begin
			(sleep_until (volume_test_players vol_scarab_top))
			(print "trying to save on scarab")
			(game_save)
			(sleep_until (not (volume_test_players vol_scarab_top)))
			(sleep 300)
			(<= (ai_living_count scarab) 0)
		)
	)
)

;===========================
;Scarab
;===========================
(script dormant scarab_start
	(sleep_until 
		(and
			(<= (ai_living_count lakebed_b_covenant_obj/phantoms) 0)
			;(<= (ai_living_count lakebed_b_covenant_obj) 6)
			TRUE
		)
	)
	(sleep_until (<= (ai_task_count lakebed_b_covenant_obj/ghostandchoppers) 0) 30 (* 30 30))
	;(wake md_lab_something_big)
	(wake md_lab_wraith02)
	(ai_place lakebed_b_pelicans01)
	(ai_cannot_die lakebed_b_pelicans01 TRUE)
	(cs_run_command_script lakebed_b_pelicans01/driver01 lake_b_pelican01_cs)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location lake_b_def_turrets/turret01) FALSE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location lake_b_def_turrets/turret02) FALSE)
	(ai_enter_squad_vehicles all_allies)
	(game_save)
	(sleep (* 30 15))
	(sleep_until (<= (ai_task_count lakebed_b_covenant_obj/ground_gate) 5) 30 (* 30 15))
	(flock_stop "lake_b_banshees")
	(lakebed_b_garbage)
	(print "scarab encounter ready")
	(game_save)
	(wake scarab_saves)
	;(sleep_until (volume_test_players vol_lakebed_b_persp) 5 (* 30 20))
	(if (= (game_insertion_point_get) 0) (wake 040_title2))
	(game_insertion_point_unlock 1)
	(sleep_until (>= (ai_living_count scarab) 1))
	(wake md_scarab_get_off)
	
	(sleep_until (<= (ai_living_count scarab) 0) 5)
	(set g_scarab_dead TRUE)
	;(wake scarab_death)
	(ai_kill lakebed_b_scarab_brutes)
	(ai_kill lakebed_b_scarab_brutes02)
	(ai_kill lakebed_b_scarab_grunts)
	(wake lakebed_b_cleanup)
	(wake objective_3_clear)
	(wake lake_b_nav_exit)
	
	;music
	(wake music_040_09)
	(set g_music_040_09 TRUE)
	(game_save)
	
	(device_operates_automatically_set lakebed_b_exit FALSE)
	(device_closes_automatically_set lakebed_b_exit FALSE)
	(device_set_position lakebed_b_exit 1)
	(device_operates_automatically_set lakebed_b_exit02 FALSE)
	(device_closes_automatically_set lakebed_b_exit02 FALSE)
	(device_set_position lakebed_b_exit02 1)
	(device_set_position lakebed_b_exit03 1)
	
	;dialog
	(sleep_forever md_lab_mar_scarab_hints_01)
	(sleep_forever md_lab_mar_scarab_hints_03)
	(sleep_forever md_lab_mar_scarab_hints_04)
	(wake md_lab_mar_scarab_dead)
	(sleep (* 30 5))
	(wake md_lab_few_pelicans)
	
	(sleep_until (volume_test_players vol_lakebed_b_end_advance))
	(ai_vehicle_exit lakebed_b_allies/scarab_dead)
	(wake md_cor_mar_locked_down)
)

;Cleanup scripts for Lakebed B
(script dormant lakebed_b_cleanup
	;(sleep_forever lake_b_banshee_control)
	(sleep_forever scarab_present)
	(sleep_forever scarab_saves)
	(sleep_forever lakebed_b_cov_drop_ghosts)
	(sleep_until (= (current_zone_set) 7) 5)
	(ai_disposable lakebed_b_allies TRUE)
	(ai_disposable lakebed_b_covenant_obj TRUE)
	(lakebed_b_garbage02)
	(object_set_persistent (ai_vehicle_get_from_starting_location lakebed_b_wraith_01/driver01) FALSE)
	(object_set_persistent (ai_vehicle_get_from_starting_location lakebed_b_wraith_02/driver01) FALSE)
	(wake lakeb_BFG_cleanup)
	(sleep_forever crane_ctrl)
	(sleep_forever lake_b_hornet_control)
	(flock_delete "lake_b_banshees")
	(flock_delete "lake_b_hornets")
	(flock_delete "lake_b_phantoms")
	(flock_delete "lake_b_bashee_excort01")
	(flock_delete "lake_b_bashee_excort02")
)

(script static void lakebed_b_garbage
	(add_recycling_volume lakebed_b_garbage 20 5)
	(sleep (* 30 5))
)

(script static void lakebed_b_garbage02
	(add_recycling_volume lakebed_b_garbage 0 0)
)

;*********************************************************************;
;Cortana Office
;*********************************************************************;
(script dormant office_arbiter_arrives
;(script static void test
;(set g_scarab_dead TRUE)
	(ai_place cortana_office_pelican01)
	(ai_cannot_die cortana_office_pelican01 TRUE)
	(ai_place cortana_office_arbiter)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location cortana_office_pelican01/driver01) "pelican_p_l05" (ai_actors cortana_office_arbiter))
	(cs_run_command_script cortana_office_pelican01/driver01 office_pelican01_cs)
)

(script command_script office_pelican01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by lakebed_b/office_pelican01a)
	(cs_vehicle_boost TRUE)
	(cs_fly_by lakebed_b/office_pelican01b 8)
	(cs_vehicle_boost FALSE)
	(cs_fly_to lakebed_b/office_pelican01c)
	(cs_face TRUE lakebed_b/office_pelican01_face)
	(cs_fly_to lakebed_b/office_pelican01d 1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(sleep 60)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_p_l05")
	(sleep 90)
	
	(wake md_arb_entrance)
	(unit_close (ai_vehicle_get ai_current_actor))
	(cs_fly_to lakebed_b/office_pelican01c)
	(cs_face FALSE lakebed_b/office_pelican01_face)
	;(sleep_forever)
)

(script static void office_coop_teleport
	(print "teleport backup")
	(if (and (not (volume_test_object vol_office_coop_teleport_not01 (player0))) (not (volume_test_object vol_office_coop_teleport_not02 (player0))))
		(object_teleport (player0) office_coop_teleport_player0)
	)
	(if (and (not (volume_test_object vol_office_coop_teleport_not01 (player1))) (not (volume_test_object vol_office_coop_teleport_not02 (player1))))
		(object_teleport (player1) office_coop_teleport_player1)
	)
	(if (and (not (volume_test_object vol_office_coop_teleport_not01 (player2))) (not (volume_test_object vol_office_coop_teleport_not02 (player2))))
		(object_teleport (player2) office_coop_teleport_player2)
	)
	(if (and (not (volume_test_object vol_office_coop_teleport_not01 (player3))) (not (volume_test_object vol_office_coop_teleport_not02 (player3))))
		(object_teleport (player3) office_coop_teleport_player3)
	)
)

(script static void test_office
	(wake object_management)
	(ai_place cortana_office_allies01)
	(ai_place cortana_office_allies02)
	(ai_place cortana_office_civs01)
)

(script dormant cortana_office_start
	(data_mine_set_mission_segment "040_70_cortana_office")
	(wake cor_ware)
	(ai_place cortana_office_allies)
	(ai_place cortana_office_allies01)
	(if (= (game_is_cooperative) FALSE)
		(wake office_arbiter_arrives)
	)
	(sleep_until (volume_test_players vol_office_start))
	(ai_set_objective all_allies office_marines_obj)
	(sleep_forever md_lab_joh_back_inside)
	(ai_place cortana_office_allies02)
	(ai_place cortana_office_civs01)
	;(ai_place cortana_office_civs02)
	;(sleep 60)
	;(wake md_cor_mar_locked_down)
	(sleep_until (volume_test_players vol_office_doorclose) 5)
	(device_set_position lakebed_b_exit 0)
	(ai_bring_forward (ai_get_object cortana_office_arbiter/arbiter) 4)
	(sleep_until (<= (device_get_position lakebed_b_exit) 0))
	(office_coop_teleport)
)


;*********************************************************************;
;Warehouse
;*********************************************************************;
(script command_script warehouse_alert_brutes_cs
	(cs_force_combat_status ai_combat_status_alert)
)

(script dormant warehouse_brute_intro
	(ai_place ware_cov_brutes01)
	(ai_place ware_cov_brutes01a)
	(sleep 1)
	(ai_set_blind ware_cov_brutes01 TRUE)
	(ai_set_deaf ware_cov_brutes01 TRUE)
	;(ai_set_blind ware_cov_brutes01a TRUE)
	;(ai_set_deaf ware_cov_brutes01a TRUE)
	(sleep 60)
	(ai_set_blind ware_cov_brutes01 FALSE)
	(ai_set_deaf ware_cov_brutes01 FALSE)
	;(sleep 50)
	;(ai_set_blind ware_cov_brutes01a FALSE)
	;(ai_set_deaf ware_cov_brutes01a FALSE)
)

(script command_script warehouse_marine_flee
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status ai_combat_status_active)
	(cs_go_to_and_face warehouse/p0 warehouse/p2)
	(cs_shoot TRUE ware_cov_brutes01/leader)
)

(script command_script warehouse_marine_flee02
	(cs_enable_pathfinding_failsafe TRUE)
	;(cs_force_combat_status ai_combat_status_active)
	(cs_go_to warehouse/p1)
)

(script dormant warehouse_turret
	(ai_place ware_turret01)
	;(object_cannot_take_damage (ai_vehicle_get_from_starting_location ware_turret01/driver01))
	(sleep_until (<= (ai_task_count ware_cov_obj/brute_init) 0))
	(ai_enter_squad_vehicles all_allies)
)

(script command_script warehouse_chieftain_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to warehouse/cheif01a)
	;*
	(cs_enable_targeting  TRUE)
	(cs_enable_looking TRUE)
	(sleep 60)
	(cs_enable_targeting FALSE)
	(cs_enable_looking FALSE)
	*;
	(cs_go_to worker_pts/cheif01b)
)

(script dormant warehouse_marine_spawner
	(ai_erase_inactive all_allies 0)
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count ware_hum_obj) 3))
			(print "spawning more marines")
			(ai_place ware_marines01)
			(sleep_until 
				(and
					(not (volume_test_object vol_warehouse_marine01 (player0)))
					(not (volume_test_object vol_warehouse_marine01 (player1)))
					(not (volume_test_object vol_warehouse_marine01 (player2)))
					(not (volume_test_object vol_warehouse_marine01 (player3)))
					(objects_can_see_flag (players) flag_warehouse_marine01 30)
				)
			100)
			FALSE
		)
	)
)

(script dormant warehouse_brute_backup
	(sleep_until (<= (ai_task_count ware_cov_obj/ware_brute_gate) 5))
	(print "spawning brute backup")
	(ai_place ware_cov_brutes_backup)
)

(script command_script warehouse_hunter_cs
	(object_cannot_take_damage hunter_coil)
	(sleep_until 
		(or
			(and
				(<= (ai_task_count ware_cov_obj/ware_brute_gate) 0)
				(volume_test_players vol_warehouse_hunters02)
				(objects_can_see_object (players) hunter_coil 30)
			)
			(volume_test_players vol_warehouse_hunters03)
		)
	1 (* 30 8))
	;(cs_run_command_script ware_cov_hunters/hunter02 abort)
	;(sleep 1)
	(ai_place ware_hum_civ03)
	(sleep 30)
	(object_can_take_damage hunter_coil)
	(cs_shoot TRUE hunter_coil)
	
	;music
	(wake music_040_11)
	(wake music_040_12)
	
	(sleep_until (<= (object_get_health hunter_coil) 0) 10 120)
	(ai_disregard (ai_actors ware_hum_civ01) FALSE)
	(ai_disregard (ai_actors ware_hum_civ02) FALSE)
)

(script dormant warehouse_saves01
	(sleep_until
		(begin
			(sleep_until (and
				(volume_test_players vol_warehouse_saves01)
				(game_safe_to_save))
			)
		(game_save)
		(sleep (* 30 90))
		FALSE
		)
	)
)

(script dormant warehouse_saves02
	(sleep_until
		(begin
			(sleep_until (and
				(volume_test_players vol_warehouse_saves02)
				(game_safe_to_save))
			)
		(game_save)
		(sleep (* 30 90))
		FALSE
		)
	)
)

(script dormant ware_door_closer	
	(device_operates_automatically_set warehouse_entry_small FALSE)
	(device_set_position warehouse_entry_small 0)
	(sleep_until (<= (device_get_position warehouse_entry_small) 0) 5)
	(zone_set_trigger_volume_enable begin_zone_set:ware_worker TRUE)
	(sleep (* 30 7))
	(zone_set_trigger_volume_enable zone_set:ware_worker TRUE)
	(sleep_until (>= (current_zone_set_fully_active) 8) 5)
	(device_set_position ware_exit_door 1)
	(device_set_position ware_exit_door_small 1)
	
)

(script dormant warehouse_start
	(sleep_until (volume_test_players vol_warehouse_init) 5)
	(print "warehouse start")
	(data_mine_set_mission_segment "040_80_warehouse")
	(ai_bring_forward (ai_get_object cortana_office_arbiter/arbiter) 6)
	(ai_place ware_brutes_init)
	(wake warehouse_turret)
	(ai_place ware_hum_marines_a)
	(ai_place ware_hum_marines_b)
	(ai_magically_see ware_hum_marines_a ware_brutes_init)
	(ai_set_objective arbiter ware_hum_obj)
	(ai_disposable cortana_office_allies02 TRUE)
	(game_save)
	
	(sleep_until (volume_test_players vol_warehouse_brutes01) 1)
	(ai_place ware_hum_101)
	(ai_disregard (ai_actors ware_hum_101) TRUE)
	(ai_place ware_hum_marines_flee)
	(unit_set_current_vitality ware_hum_marines_flee/shotgun01 5 0)
	(wake vig_war_sgt_brute_pack)
	;(cs_run_command_script ware_hum_marines_flee/shotgun01 warehouse_marine_flee)
	(cs_run_command_script ware_hum_marines_flee/marine02 warehouse_marine_flee02)
	(wake warehouse_brute_intro)
	(sleep_until (volume_test_players vol_warehouse_brutes02) 5)
	(wake ware_door_closer)
	(wake ware_nav_exit)
	(ai_disregard (ai_actors ware_hum_101) FALSE)
	(wake warehouse_saves01)
	(wake vig_ware_brute02)
	(sleep 1)
	(wake warehouse_marine_spawner)
	;(wake warehouse_brute_backup)
	(sleep_until (volume_test_players vol_warehouse_brutes02b) 5)
	;(ai_disregard (ai_actors ware_hum_201) FALSE)
	
	(set testNum (- 4 (ai_task_count ware_hum_obj/civ_scared_gate)))
	(sleep 1)
	(ai_place ware_hum_civ01 testNum)
	(sleep 1)
	(set testNum 0)
	(ai_disregard (ai_actors ware_hum_civ01) TRUE)
	;(ai_place ware_hum_civ02)
	;(ai_disregard (ai_actors ware_hum_civ02) TRUE)
	
	(sleep_until (volume_test_players vol_warehouse_hunters01) 1)
	(sleep_until (> (device_get_position ware_exit_door) 0) 5)
	(ai_disregard (ai_actors ware_hum_civ01) FALSE)
	;(ai_disregard (ai_actors ware_hum_civ02) FALSE)
	;(sleep_forever warehouse_brute_backup)
	;(ai_set_objective all_enemies worker_cov_obj)
	;(sleep 1)
	;(cs_run_command_script ware_cov_brutes02/chief warehouse_chieftain_cs)
	;(sleep 60)
	;(ai_disregard (ai_actors ware_hum_civ02) TRUE)
	(data_mine_set_mission_segment "040_81_hunters")
	(ai_set_objective ware_cov_obj/ware_brute_gate worker_cov_obj)
	(ai_place ware_cov_hunters)
	(wake md_hunter_hints)
	(object_damage_damage_section worker_forklift "forklift" 1)
	(cs_run_command_script ware_cov_hunters warehouse_hunter_cs)
	(ai_bring_forward (ai_get_object cortana_office_arbiter/arbiter) 6)
	(game_save)
	(sleep_forever warehouse_saves01)
	(wake warehouse_saves02)
	
	(sleep_until (<= (ai_living_count ware_cov_hunters) 0))
	(sleep_forever warehouse_saves02)
	(game_save)
)

;Cleanup scripts for warehouse
(script dormant warehouse_cleanup
	(print "temp")
	(sleep_forever warehouse_turret)
)

(script static void warehouse_garbage
	(add_recycling_volume warehouse_garbage 0 0)
)

;*********************************************************************;
;Worker Town
;*********************************************************************;
(script command_script worker_phantom01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to worker_pts/phantom01a)
	(ai_trickle_via_phantom work_cov_phantom01/driver01 work_cov_grunts01)
	(cs_fly_to worker_pts/phantom01b)
	(cs_fly_to worker_pts/phantom01c)
	(cs_fly_to worker_pts/phantom01d)
	(cs_fly_to worker_pts/phantom01e)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script worker_banshees01_cs
	(cs_vehicle_boost TRUE)
	(sleep 400)
	(object_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant worker_banshees
	(ai_place work_cov_banshees01)
	(cs_run_command_script work_cov_banshees01 worker_banshees01_cs)
	(sleep 60)
	(ai_place work_cov_banshees01 1)
	(cs_run_command_script work_cov_banshees01 worker_banshees01_cs)
	(sleep 40)
	(ai_place work_cov_banshees01 1)
	(cs_run_command_script work_cov_banshees01 worker_banshees01_cs)
)

(script dormant worker_marine_spawner
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count worker_marines_obj) 3))
			(print "spawning BFG marines")
			(ai_place worker_marines01)
			(sleep 10)
			;(sleep_until (not (volume_test_players vol_worker_marine01)))
			FALSE
		)
	)
	(sleep_until
		(begin
			(sleep_until (and
				(<= (ai_living_count worker_marines_obj) 3)
				(volume_test_players vol_bfg_advance))
			)
			(print "spawning BFG marines02")
			(ai_place bfg_marines02)
			(sleep 100)
			;(sleep_until (not (volume_test_players vol_worker_marine01)))
			(volume_test_players vol_bfg_advance)
		)
	)
)

(script dormant worker_start
	(print "worker town start")
	(flock_create "worker_banshees")
	;(flock_create "worker_hornets")
	(flock_create "worker_phantoms")
	(flock_create "worker_banshees_line")
	(flock_create "worker_banshees_line02")
	(wake BFG_go)
	;(ai_place work_cov_phantom01)
	;(cs_run_command_script work_cov_phantom01/driver01 worker_phantom01_cs)
	(ai_place work_cov_grunts01)
	(ai_place work_cov_chief)
	(ai_place work_cov_grunts02)
	(sleep_until (volume_test_players vol_worker_entry) 5)
	(data_mine_set_mission_segment "040_90_worker")
	(wake truth_channel_worker)
	(wake worker_banshees)
	(wake warehouse_cleanup)
	(flock_create "worker_hornets")
	(flock_create "worker_banshees02")
	;(flock_create "worker_phantoms02")
	;(flock_stop "worker_banshees")
	(flock_stop "worker_phantoms")
	(flock_stop "worker_banshees_line")
	(flock_stop "worker_banshees_line02")
	(ai_set_objective all_allies worker_marines_obj)
	(ai_set_objective ware_cov_obj worker_cov_obj)
	;(wake md_work_mir_single_ship)
	(sleep_forever warehouse_marine_spawner)
	(wake worker_marine_spawner)
	(sleep_until (or
		(volume_test_players vol_worker_middle_start)
		(<= (ai_task_count worker_cov_obj/cov_inf) 5))
	)
	(print "spawning yard")
	(ai_place work_cov_brute01)
	(ai_place work_cov_grunts03)
	(ai_place work_cov_yardcov01)
;	(wake cor_worker)
	(sleep_until (volume_test_players vol_worker_middle) 5)
	(wake change_zone_set_bfg)
	;*
	(if (<= (ai_living_count work_cov_chief/chief) 0)
		;if chief dead spawn a sniper brute
		;(ai_place work_cov_brute_backup/snipe)
		;if cheif not_dead spawn a brute shot brute
		(ai_place work_cov_brute_backup/bs)
	)
	*;
)

;*********************************************************************;
;BFG
;*********************************************************************;
(script command_script bfg_phantom01_cs
	(cs_enable_pathfinding_failsafe TRUE)
	;(cs_enable_targeting TRUE)
	(cs_fly_to bfg_pts/phantom01a)
	(cs_fly_to bfg_pts/phantom01b)
)

(script command_script bfg_banshees_init_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(sleep 80)
	(cs_enable_moving TRUE)
	(sleep (random_range 50 100))
)

(script command_script bfg_banshee_passive_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	;(sleep 120)
	(cs_enable_moving TRUE)
	;(sleep 120)
	;(cs_vehicle_boost FALSE)
	(sleep_forever)
)

(script dormant bfg_banshees
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count bfg_cov_banshees01) 0))
			(ai_place bfg_cov_banshees01)
			FALSE
		)
	)
)

(script dormant bfg_banshees_passive
	(sleep_until (and
		(<= (ai_task_count bfg_cov_obj/inf_gate) 1)
		(<= (ai_living_count bfg_cov01/chief) 0))
	)
	(print "RL marines")
	(ai_place bfg_marines_RL)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_run_command_script bfg_cov_banshees bfg_banshee_passive_cs)
					(cs_run_command_script bfg_cov_banshees01/driver01 abort)
					(sleep (random_range 80 150))
				)
				(begin
					(cs_run_command_script bfg_cov_banshees bfg_banshee_passive_cs)
					(cs_run_command_script bfg_cov_banshees01/driver02 abort)
					(sleep (random_range 80 150))
				)
				(begin
					(cs_run_command_script bfg_cov_banshees bfg_banshee_passive_cs)
					(cs_run_command_script bfg_cov_banshees01/driver03 abort)
					(sleep (random_range 80 150))
				)
			)
			FALSE
		)
	)
)

(script dormant bfg_marine_spawner
	(sleep_until
		(begin
			(sleep_until (and 
				(<= (ai_living_count bfg_marines_obj) 5)
				(volume_test_players_all vol_bfg_marine01))
			)
			(print "spawning more marines")
			(ai_place bfg_marines01)
			(sleep 10)
			FALSE
		)
	)
)

(script dormant bfg_marine_spawner02
	(sleep_until
		(begin
			(sleep_until (and 
				(<= (ai_living_count bfg_marines_obj) 5)
				(volume_test_players_all vol_bfg_marine02))
			)
			(print "spawning more marines")
			(ai_place bfg_marines01)
			(sleep 10)
			(and 
				(<= (ai_living_count bfg_cov01/chief) 0)
				(<= (ai_task_count bfg_cov_obj/inf_gate) 2)
			)
		)
	)
	(sleep 100)
	(sleep_until (volume_test_players_all vol_bfg_marine02))
	(game_save)
	(print "RL marines")
	(ai_place bfg_marines_RL)
	(ai_place bfg_cov_banshees02)
	(cs_run_command_script bfg_cov_banshees02 bfg_banshees_init_cs)
)

(script command_script bfg_shoot_core_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until
		(begin
			(sleep_until (>= (device_get_position bfg_base) 1))
			(cs_enable_looking FALSE)
			(cs_enable_targeting FALSE)
			(cs_enable_moving FALSE)
			;(cs_aim TRUE bfg_pts/bfg_weak)
			(cs_shoot_point TRUE bfg_pts/bfg_weak)
			(sleep_until (<= (device_get_position bfg_base) 0) 5)
			;(cs_aim FALSE bfg_pts/bfg_weak)
			(cs_shoot_point FALSE bfg_pts/bfg_weak)
			(cs_enable_looking TRUE)
			(cs_enable_targeting TRUE)
			(cs_enable_moving TRUE)
			(<= (object_get_health bfg_base) .2)
		)
	)
)

;======
;BFG controls
;======

(script static void BFG_aim
	(device_animate_overlay bfg_base (real_random_range .44 .47) (random_range 2 3) .1 .1)
	;(device_animate_overlay bfg_turret (random_range 0 1) (random_range 2 3) .1 .1)
	(sleep 60)
)


(script static void BFG_fire
	(print "BFG fire")
	;(sound_impulse_start sound\weapons\covy_gun_tower\c_gun_tower_charge bfg_base 3)
	(effect_new_on_object_marker "objects\levels\shared\bfg\fx\firing_fx\bfg_foot_dust.effect" bfg_base "fx_foot")
	(BFG_shoot_anim)
)

(script static void BFG_shoot_anim
	(device_animate_overlay bfg_turret 1 3 0 0)
	(sleep 60)
	(BFG_vent)
	(print "vent done")
	(device_animate_overlay bfg_turret 0 0 0 0)
)

(script static void BFG_vent
	(device_animate_position bfg_base 1 .35 0.2 .5 TRUE)
	(sleep (random_range 20 40))
	;look around to keep it moving:
	(device_animate_overlay bfg_base (real_random_range .4 .43) (random_range 2 5) .5 .5)
	;(device_animate_overlay bfg_turret (random_range 0 1) (random_range 2 5) .1 .1)
	;call effects
	(if (volume_test_players vol_bfg_marine02)
		;if player is near the bfg
		(sleep 140)
		;if player is trying to kill bfg for afar- fuck that shit!
		(sleep 60)
	)
	;(device_set_position_track bfg_base position 0)
	(if (> (object_get_health bfg_base) 0)
		(device_animate_position bfg_base 0 1.2 0.25 1 true)
		;(device_animate_position bfg_base 0 1.2 0 1 true)
	)
)

(script dormant BFG_go
	(object_create bfg_turret)
	(objects_attach bfg_base "turret" bfg_turret "")
	(device_set_position_track bfg_base position 0)
	(device_set_overlay_track bfg_base power)
	(device_set_position_track bfg_turret position 0)
	(device_set_overlay_track bfg_turret power)
	(device_animate_overlay bfg_base .4 0 0 0)
	(device_animate_overlay bfg_turret 0 0 0 0)
	(wake BFG_shoot)
)

(script dormant BFG_shoot
	(sleep_until
		(begin
			(print "BFG shoot 1st phase")
			(begin
				(sleep (random_range 50 80))
				(BFG_fire)
			)
			(volume_test_players vol_worker_bfgtest)
		)
	)
	
	;shooting down the longsword
	(device_animate_overlay bfg_base .4 1.5 .5 .5)
	(sleep 45)
	(print "BFG ready for longsword")
	(sleep_until g_bfg_longsword 1)
	(print "BFG longsword GO!")
	(wake vig_crashing_longsword)
	(BFG_fire)
	
	(sleep_until
		(begin
			(print "BFG shoot 1st phase")
			(begin
				(sleep (random_range 50 110))
				(BFG_fire)
			)
			(>= (ai_task_count bfg_cov_obj/fallback01) 1)
		)
	)
	(sleep_until
		(begin
			(print "BFG shoot 2nd phase")
			(begin
				(sleep (random_range 50 80))
				(BFG_fire)
			)
			(<= (ai_living_count bfg_cov01/chief) 0)
		)
	)
	(sleep_until
		(begin
			(print "BFG shoot 3rd phase")
			(begin
				(sleep (random_range 10 30))
				(BFG_fire)
			)
			FALSE
		)
	)
)

(script dormant BFG_saves01
	(sleep_until
		(begin
			(sleep_until (and
				(volume_test_players vol_bfg_gamesave01)
				(game_safe_to_save))
			)
		(game_save)
		(sleep (* 30 90))
		(<= (object_get_health bfg_base) 0)
		)
	)
)

(script dormant sky_ambient_cleanup
	(object_destroy ark_cruiser_01)
	(object_destroy ark_cruiser_02)
	(object_destroy flak_human)
	(object_destroy flak_cov)
	(flock_delete "worker_banshees")
	(flock_delete "worker_phantoms")
	(flock_delete "worker_banshees_line")
	(flock_delete "worker_banshees_line02")
	(flock_delete "worker_hornets")
	(flock_delete "worker_banshees02")
	
	(object_destroy lightning01)
	(object_destroy lightning02)
	(object_destroy lightning03)
	(object_destroy lightning04)
	(object_destroy lightning_big01)
	(object_destroy lightning_big02)
	(object_destroy lightning_big03)
)

(script dormant BFG_damage
	(sleep_until (<= (object_get_health bfg_base) 0) 5)
	(if (= (game_is_cooperative) FALSE)
		(object_cannot_take_damage (players))
	)
	(wake objective_4_clear)
	(sleep_forever BFG_start)
	(sleep_forever md_bfg_joh_hints)
	(sleep 10)
	
	(hud_deactivate_team_nav_point_flag player nav_bfg_core)
	(effect_new "fx\scenery_fx\explosions\covenant_explosion_medium\covenant_explosion_medium.effect" bfg_dead_fx01)
	(sleep 9)
	(effect_new "fx\scenery_fx\explosions\covenant_explosion_medium\covenant_explosion_medium.effect" bfg_dead_fx02)
	(sleep 7)
	(effect_new "fx\scenery_fx\explosions\covenant_explosion_large\covenant_explosion_large.effect" bfg_dead_fx03)
	
	(cinematic_fade_to_black)
	
		; player cannot die 
		(object_cannot_die (player0) TRUE)
		(object_cannot_die (player1) TRUE)
		(object_cannot_die (player2) TRUE)
		(object_cannot_die (player3) TRUE)
	
	(kill_volume_enable kill_bfg_cin_start)
	(unit_kill ware_cov_hunters)
	(ai_erase cortana_office_arbiter)
	(ai_erase bfg_cov_obj/banshees)
	(wake BFG_cleanup)
	(wake sky_ambient_cleanup)
	(switch_zone_set bfg)
	(sound_class_set_gain amb 0 10)
	(sleep 10)
	(add_recycling_volume vol_bfg_garbage 0 0)
	(kill_volume_disable kill_bfg_cin_start)
	
	(game_award_level_complete_achievements)
	
	(data_mine_set_mission_segment "040lb_Cov_Flee")
	(if g_play_cinematics
		(begin
			(if (cinematic_skip_start)
				(begin
					(print "040lb_cov_flee")
					(040lb_cov_flee)
				)
			)
			(cinematic_skip_stop)
		)
		;else
		(begin
			(print "skipping '040lb_cov_flee' cinematic")
		)
	)
	; turn of game sounds 
	(sound_class_set_gain "" 0 0)

	; cleanup cinematic 
	(040lb_cov_flee_cleanup)
	
	(sleep 5)
	(end_mission)
)

(script dormant change_zone_set_bfg
	(device_set_position ware_exit_door 0)
	(device_set_position ware_exit_door_small 0)
	(sleep_until (<= (device_get_position ware_exit_door) 0) 5)
	(sleep_until (<= (device_get_position ware_exit_door_small) 0) 5)
	(bfg_coop_teleport)
	(zone_set_trigger_volume_enable begin_zone_set:bfg TRUE)
)

(script static void bfg_coop_teleport
	(print "teleport backup")
	(if (volume_test_object vol_bfg_coop_teleport (player0)) (object_teleport (player0) bfg_coop_teleport_player0))
	(if (volume_test_object vol_bfg_coop_teleport (player1)) (object_teleport (player1) bfg_coop_teleport_player1))
	(if (volume_test_object vol_bfg_coop_teleport (player2)) (object_teleport (player2) bfg_coop_teleport_player2))
	(if (volume_test_object vol_bfg_coop_teleport (player3)) (object_teleport (player3) bfg_coop_teleport_player3))
)

(script dormant BFG_start
	(print "BFG start")
	(data_mine_set_mission_segment "040_100_bfg")
	(warehouse_garbage)
	(game_save)
	;(sleep_until (volume_test_players vol_bfg_init) 1)
	(sleep_until
		(or
			(objects_can_see_object (players) bfg_base 30)
			(volume_test_players vol_bfg_init)
		)
	1)
	(set g_bfg_longsword TRUE)
	(sleep_until (volume_test_players vol_bfg_init) 5)
	(ai_bring_forward (ai_get_object cortana_office_arbiter/arbiter) 6)
	;(wake 040_title3)
	(ai_place bfg_cov_banshees01)
	(cs_run_command_script bfg_cov_banshees01 bfg_banshees_init_cs)
	(ai_disregard (ai_actors bfg_cov_banshees01) TRUE)
	;(wake bfg_banshees)
	;(wake br_ark_is_bad)
	(wake BFG_damage)
	(ai_set_objective all_enemies bfg_cov_obj)
	(ai_set_objective all_allies bfg_marines_obj)
	(sleep_until (volume_test_players vol_bfg_init02) 5)
	(sleep_forever worker_marine_spawner)
	;(wake md_bfg_joh_straight_ahead)
	(ai_place bfg_cov_grunts01)
	(ai_place bfg_cov_grunts01b)
	;(ai_place bfg_cov_snipes01)
	(ai_place bfg_cov01)
	(ai_place bfg_cov03)
	(sleep 1)
	(ai_magically_see_object bfg_cov_obj (player0))
	(wake bfg_marine_spawner)
	(sleep_until (volume_test_players vol_bfg_middle_hill))
	(wake BFG_saves01)
	(ai_place bfg_cov_grunts01c)
	;(ai_place bfg_marines01)
	;(ai_place test_bfg_phantom)
	(game_save)
	(sleep_until (volume_test_players vol_bfg_entry))
	(data_mine_set_mission_segment "040_101_bfg02")
	(sleep_forever bfg_marine_spawner)
	(wake bfg_marine_spawner02)
	(game_save)
	(ai_place bfg_cov_grunts02a)
	(ai_place bfg_cov_grunts02b)
	(ai_place bfg_cov05)
	(sleep_until (<= (ai_task_count bfg_cov_obj/inf_gate) 0))
	(sleep (* 30 4))
	(wake md_bfg_joh_hints)
)

(script dormant BFG_cleanup
	(sleep_forever BFG_shoot)
	(sleep_forever BFG_saves01)
	(sleep_forever bfg_marine_spawner)
	(sleep_forever bfg_marine_spawner02)
	(sleep_forever bfg_banshees)
	
	(sleep 50)
	(print "killing AI")
	(ai_kill_silent bfg_cov_obj)
)

;*********************************************************************;
;Ally Following/Driving Stuff
;*********************************************************************;
(script command_script warehouse_brute_run
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status ai_combat_status_active)
	(cs_go_to warehouse/p2)
)

(script command_script warehouse_brute_flee
	(cs_enable_targeting true)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(sleep 50)
	(cs_enable_targeting false)
	(cs_enable_moving false)
	(cs_enable_looking false)
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status ai_combat_status_active)
	(cs_go_to warehouse/p3)
	(sleep_forever)
)

;====================================================
;These scripts move the gauss hog through the mission
;====================================================
(script dormant gauss_nav_intro
	;wait until gauss driver/player is in intro position:
	(sleep_until (volume_test_object vol_intro_start (ai_vehicle_get_from_starting_location intro_hog/driver)))
	
	;if ai is driving the hog, steer him to point
	(if (>= (ai_living_count (ai_get_driver intro_hog/driver)) 1)
		(cs_run_command_script (ai_get_driver intro_hog/driver) gauss_nav_intro_cs)
	)
	
	;wait player is near switch is active and hog has a driver
	(sleep_until 
		(and
			(or
				(volume_test_players vol_tank_room_a_start)
				(= wave 2)
			)
			(>= (ai_living_count (ai_get_driver intro_hog/driver)) 1)
		)
	)
	(print "player near switch")
	(cs_run_command_script (ai_get_driver intro_hog/driver) abort)
	(sleep 10)
	(cs_run_command_script (ai_get_driver intro_hog/driver) gauss_nav_intro02_cs)
)

(script dormant gauss_nav_factory_a
	;wait until player hits switch:
	(sleep_until (> (device_get_position factory_a_entry) 0))
	(sleep_until 
		(and
			(or
				(volume_test_players vol_faa)
				(vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" (players))
			)
			(>= (ai_living_count (ai_get_driver intro_hog/driver)) 1)
		)
	)
	(print "player entered FAA and hog has driver")
	(cs_run_command_script (ai_get_driver intro_hog/driver) abort)
	(sleep 10)
	(cs_run_command_script (ai_get_driver intro_hog/driver) gauss_nav_factoryA01)

	
	;wait until 2nd door open and gauss driver to exist:
	(sleep_until (<= (device_get_position factory_a_entry02) 0))
	(sleep_until 
		(and
			(>= (device_get_position factory_a_entry02) .5)
			(>= (ai_living_count (ai_get_driver intro_hog/driver)) 1)
		)
	)
	(print "player opened 2nd door and gauss has driver")
	(cs_run_command_script (ai_get_driver intro_hog/driver) abort)
	(sleep 10)
	(cs_run_command_script (ai_get_driver intro_hog/driver) gauss_nav_factoryA01b)
	
	;dialog
	(sleep (random_range 0 30))
	(wake md_faa_door_go)
	
	;wait until big middle door open:
	(sleep_until 
		(and
			(> (device_get_position factory_a_entry02) 0)
			(> (device_get_position factory_a_middle) 0)
			(>= (ai_living_count (ai_get_driver intro_hog/driver)) 1)
		)
	)
	(print "middle door open and hog has driver")
	(cs_run_command_script (ai_get_driver intro_hog/driver) abort)
	(sleep 10)
	(cs_run_command_script (ai_get_driver intro_hog/driver) gauss_nav_factoryA01c)
	
	;dialog
	(sleep (random_range 0 30))
	(wake md_faa_door_go_02)
	
	;wait until encounter progresses to push cov into factory A tunnel and gauss driver to exist:
	(sleep_until 
		(and
			(> (device_get_position factory_a_middle) .75)
			(>= (ai_living_count (ai_get_driver intro_hog/driver)) 1)
		)
	)
	(print "cov falling back and hog has driver")
	(cs_run_command_script (ai_get_driver intro_hog/driver) abort)
	(sleep 10)
	(cs_run_command_script (ai_get_driver intro_hog/driver) gauss_nav_factoryA02)
	
	;wait until most factory cov are dead and gauss driver to exist:
	(sleep_until 
		(and
			(<= (ai_living_count factory_a_covenant_obj) 8)
			(>= (ai_living_count (ai_get_driver intro_hog/driver)) 1)
		)
	)
	(print "factory A cov most dead and gauss has driver")
	(cs_run_command_script (ai_get_driver intro_hog/driver) abort)
	(sleep 10)
	(cs_run_command_script (ai_get_driver intro_hog/driver) gauss_nav_factoryA03)
)

(script command_script gauss_nav_intro_cs
	(cs_abort_on_vehicle_exit TRUE)
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_ignore_obstacles true)
	(print "moving gausshog into entry position")
	(cs_vehicle_speed .5)
	(cs_go_to intro_pts/gauss00)
	(cs_go_to intro_pts/gauss01)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "warthog_p")
	(wake intro_move_HUD)
	(sleep_forever)
)

(script command_script gauss_nav_intro02_cs
	(cs_abort_on_damage TRUE)
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_ignore_obstacles TRUE)
	(print "moving gausshog into entry position pt2")
	(cs_vehicle_speed .3)
	(cs_go_to intro_pts/gauss01b 2)
	(sleep_until (<= (ai_living_count (ai_get_driver intro_hog/driver)) 0))
	(print "aborting command script")
	(cs_run_command_script ai_current_actor abort)
)

(script command_script gauss_nav_factoryA01
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_ignore_obstacles true)
	(sleep 30)
	(print "moving gausshog into factoryA")
	(cs_vehicle_speed .2)
	(cs_go_to intro_pts/gauss02 2)
	(cs_go_to factory_arm_a/gauss01)
	(cs_go_to factory_arm_a/gauss02)
	(sleep 30)
	(ai_set_deaf factory_a_covenant_obj/faa_cov_init FALSE)
	(sleep_forever)
)

(script command_script gauss_nav_factoryA01b
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_ignore_obstacles true)
	(sleep (random_range 10 70))
	(print "moving gausshog into factoryA pt2")
	(cs_vehicle_speed .3)
	(cs_go_to factory_arm_a/gauss01b)
	(sleep_forever)
)

(script command_script gauss_nav_factoryA01c
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_ignore_obstacles true)
	(sleep (random_range 10 70))
	(print "moving gausshog into factoryA pt3")
	(cs_vehicle_speed .2)
	(cs_go_to factory_arm_a/gauss01c)
	(sleep_forever)
)

(script command_script gauss_nav_factoryA02
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_ignore_obstacles true)
	(sleep (random_range 10 70))
	(print "moving gausshog into factoryA pt4")
	(cs_vehicle_speed .2)
	(cs_go_to factory_arm_a/gauss03)
	(sleep_forever)
)

(script command_script gauss_nav_factoryA03
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_ignore_obstacles true)
	(sleep (random_range 0 30))
	(print "moving gausshog to end of factory A")
	(cs_vehicle_speed .3)
	(cs_go_to factory_arm_a/gauss04)
	(sleep_forever)
)

(script dormant gauss_reserve
	(vehicle_unload (ai_vehicle_get_from_starting_location intro_hog/driver) "")
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location intro_hog/driver) TRUE)
	(sleep_until (or
		(volume_test_players vol_lakebed_a_end)
		(unit_in_vehicle (unit (player0))))
	)
	(print "un-reserving gauss hog")
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location intro_hog/driver) FALSE)
;	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_g" FALSE)
;	(if (= (game_difficulty_get) easy)
		;if easy, free up hog
;		(ai_vehicle_reserve (ai_vehicle_get_from_starting_location intro_hog/driver) FALSE)
		;if not easy, wait a while to free hog
;		(begin
;			(sleep_until (<= (ai_living_count lakebed_a_cov_vehicles) 5) 30 (* 30 25))
;			(ai_vehicle_reserve (ai_vehicle_get_from_starting_location intro_hog/driver) FALSE)
;		)
;	)
)

(script command_script gauss_nav_lakeA_init
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	;(cs_ignore_obstacles TRUE)
	(cs_vehicle_speed .2)
	(cs_go_to lakebed_a/gauss01 1)
	(cs_go_to lakebed_a/gauss01b 1)
	(sleep_forever)
)

(script command_script gauss_nav_lakeA_top
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_vehicle_speed .5)
	(sleep 30)
	;if player is driving, cancel command scripts:
	(if (vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (players))
		(cs_run_command_script ai_current_actor abort)
	)
	;if AI are in lakebed:
	(if (volume_test_objects vol_lake_a_bed (ai_vehicle_get_from_starting_location intro_hog/driver))
		(cs_run_command_script ai_current_actor gauss_nav_lakeA_bed)
	)
	;if AI is passenger or gunner, wait til hog is kinda in the back of the pier to abort AI gun/pass:
	(if (not (vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (ai_actors ai_current_actor)))
		(begin
			(sleep_until (volume_test_objects vol_lake_a_topback (ai_vehicle_get_from_starting_location intro_hog/driver)))
			(if (<= (ai_task_status lakebed_a_covenant_obj/center_flank) ai_task_status_inactive)
				(begin
					(cs_enable_targeting TRUE)
					(cs_enable_looking TRUE)
				)
			)
			(sleep_until (>= (ai_task_status lakebed_a_covenant_obj/center_flank) ai_task_status_exhausted))
			(cs_enable_targeting FALSE)
			(cs_enable_looking FALSE)
			(sleep_until (volume_test_objects vol_lake_a_topback02 (ai_vehicle_get_from_starting_location intro_hog/driver)))
			(cs_run_command_script ai_current_actor abort)
		)
	)
	;if hog is still in factory A:
	(if (volume_test_objects vol_faa (ai_vehicle_get_from_starting_location intro_hog/driver))
		(cs_go_to lakebed_a/gauss01)
	)
	;start testing to see where cov are:
	(if (<= (ai_task_status lakebed_a_covenant_obj/center_flank) ai_task_status_inactive)
		(cs_go_to lakebed_a/gauss02)
	)
	(if (>= (ai_task_count lakebed_a_covenant_obj/center_flank_fallback) 1)
		(cs_go_to lakebed_a/gauss07)
	)

	;if gauss not already in bridge area:
	(if (not (volume_test_objects vol_lakebed_a_bridge (ai_vehicle_get_from_starting_location intro_hog/driver)))
		(begin
			(print "gauss hog moving to bridge")
			(cs_go_to lakebed_a/gauss04)
			(cs_go_to lakebed_a/gauss03 1)
			(cs_enable_targeting TRUE)
			(cs_enable_looking TRUE)
			(sleep_until (or
				(volume_test_players vol_lakebed_a_end)
				(volume_test_players vol_lake_a_bed)
				(any_players_in_vehicle))
			)
			;(if (not (unit_in_vehicle (unit (player0))))
			;	(wake gauss_reserve)
			;	(sleep 90)
			;)
		)
	)
)

(script command_script gauss_nav_lakeA_bed
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(sleep 30)
	
	;if player is driving, cancel the command script
	(if (vehicle_test_seat_list (ai_vehicle_get_from_starting_location intro_hog/driver) "warthog_d" (players))
		(cs_run_command_script ai_current_actor abort)
	)
	(cs_go_to lakebed_a/gauss04)
	(cs_go_to lakebed_a/gauss03)
)

(script command_script gauss_nav_factoryB01
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_ignore_obstacles true)
	(print "moving gausshog into facory B entry position")
	(cs_go_to lakebed_a/gauss_end)
	(cs_vehicle_speed .8)
	(cs_go_to factory_b/gauss01)
	(sleep_until (<= (ai_living_count (ai_get_driver intro_hog/driver)) 0))
	(print "aborting command script")
	(cs_run_command_script ai_current_actor abort)
)

(script command_script gauss_nav_factoryB02
	(cs_abort_on_vehicle_exit TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_ignore_obstacles true)
	(cs_vehicle_speed .6)
	(print "moving gausshog into facory B center")
	(cs_go_to factory_b/gauss01)
	;(sleep_until (>= (device_get_position factory_b_entry02) .3))
	;(sleep 30)
	(cs_vehicle_speed .4)
	(cs_go_to factory_b/gauss02)
)

(script command_script hog_speed
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_enable_moving true)
	;(cs_vehicle_speed 1)
	;(sleep 150)
	(cs_vehicle_speed .7)
	(sleep_forever)
)

;*********************************************************************;
;Objective Scripts
;*********************************************************************;
(script dormant objective_1_set
	(sleep 30)
	(print "new objective set:")
	(print "Located and eliminate Anti_air Wraith in the 1st area")
	(objectives_show_up_to 0)
	(cinematic_set_chud_objective obj_0)
)

(script dormant objective_1_clear
	(print "objective complete:")
	(print "Located and eliminate Anti_air Wraith in the 1st area")
	(objectives_finish_up_to 0)
)

(script dormant objective_2_set
	(sleep 30)
	(print "new objective set:")
	(print "Located and eliminate Anti_air Wraith in the 2nd area")
	(objectives_show_up_to 1)
	(cinematic_set_chud_objective obj_1)
)

(script dormant objective_2_clear
	(print "objective complete:")
	(print "Located and eliminate Anti_air Wraith in the 2nd area")
	(objectives_finish_up_to 1)
)

(script dormant objective_3_set
	(sleep 30)
	(print "new objective set:")
	(print "Destroy Covenant Scarab")
	(objectives_show_up_to 2)
	(cinematic_set_chud_objective obj_2)
)

(script dormant objective_3_clear
	(print "objective complete:")
	(print "Destroy Covenant Scarab")
	(objectives_finish_up_to 2)
)

(script dormant objective_4_set
	(sleep 30)
	(print "new objective set:")
	(print "Destroy Conenant Air Defense Cannon")
	(objectives_show_up_to 3)
	(cinematic_set_chud_objective obj_3)
)

(script dormant objective_4_clear
	(print "objective complete:")
	(print "Destroy Conenant Air Defense Cannon")
	(objectives_finish_up_to 3)
)

;*********************************************************************;
;Nav Point Scripts
;*********************************************************************;
(script dormant intro_nav_exit
	(sleep_until (> (device_get_position factory_a_entry) 0) 30 (* 120 30))
	(if (not (> (device_get_position factory_a_entry) 0))
		(begin
			(Hud_activate_team_nav_point_flag player nav_intro_exit 0)
			(sleep_until (> (device_get_position factory_a_entry) 0) 1)
			(Hud_deactivate_team_nav_point_flag player nav_intro_exit)
		)
	)
)

(script dormant faa_nav_exit
	(sleep_until
		(or
			(> (device_get_position lakebed_a_entry_door) 0)
			(<= (ai_living_count all_enemies) 0)
		)
	)
	(sleep_until (> (device_get_position lakebed_a_entry_door) 0) 30 (* 120 30))
	(if (not (> (device_get_position lakebed_a_entry_door) 0))
		(begin
			(Hud_activate_team_nav_point_flag player nav_faa_exit 0)
			(sleep_until (> (device_get_position lakebed_a_entry_door) 0) 1)
			(Hud_deactivate_team_nav_point_flag player nav_faa_exit)
		)
	)
)

(script dormant laa_nav_exit
	;wait until most guys dead
	(sleep_until (<= (ai_living_count lakebed_a_covenant_obj) 5))
	;if players not in laa, forget it
	(if (not (volume_test_players vol_lakebed_a))
		(sleep_forever)
	)
	;start giving them 2 min to get to the end
	(sleep_until (volume_test_players vol_drive_lakedbed_a_end) 30 (* 120 30))
	;if they're still in laa but not at the end, give them nav point
	(if 
		(and 
			(volume_test_players vol_lakebed_a)
			(not (volume_test_players vol_drive_lakedbed_a_end))
		)
		(begin
			(Hud_activate_team_nav_point_flag player nav_laa_exit 0)
			(sleep_until (volume_test_players vol_drive_lakedbed_a_end))
			(Hud_deactivate_team_nav_point_flag player nav_laa_exit)
		)
	)
)

(script dormant lake_b_nav_exit
	(sleep_until (volume_test_players vol_office_start) 30 (* 30 50))
	(if (not (volume_test_players vol_office_start))
		(begin
			(Hud_activate_team_nav_point_flag player nav_lake_b_exit 0)
			(sleep_until (volume_test_players vol_office_start) 5)
			(Hud_deactivate_team_nav_point_flag player nav_lake_b_exit)
		)
	)
)

(script dormant ware_nav_exit
	(sleep_until (>= (ai_living_count ware_cov_hunters) 1) 30 (* 30 50))
	(if (not (>= (ai_living_count ware_cov_hunters) 1))
		(begin
			(Hud_activate_team_nav_point_flag player nav_ware_exit 0)
			(sleep_until (>= (ai_living_count ware_cov_hunters) 1) 5)
			(Hud_deactivate_team_nav_point_flag player nav_ware_exit)
		)
	)
	(sleep_until (<= (ai_living_count ware_cov_hunters) 0))
	(if (volume_test_players vol_warehouse_backhalf)
	(begin
		(sleep_until (volume_test_players vol_ware_nav_exit) 5 (* 30 50))
		(if (not (volume_test_players vol_ware_nav_exit))
			(begin
				(Hud_activate_team_nav_point_flag player nav_ware_exit 0)
				(sleep_until (volume_test_players vol_ware_nav_exit) 5)
				(Hud_deactivate_team_nav_point_flag player nav_ware_exit)
			)
		)
	)
	)
)

;*********************************************************************;
;Object Management Scripts
;*********************************************************************;
(script dormant object_management
	(sleep_until (> (player_count) 0) 1)
	(if (= (current_zone_set_fully_active) 0)
		(begin
			(object_create_folder scenery_intro)
			(object_create_folder crates_intro)
			(object_create_folder vehicles_intro)
			(object_create_folder effects_intro)
			
			;(object_destroy_folder effects_intro)
			(object_destroy_folder effects_laa)
			(object_destroy_folder effects_worker)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 1) 1)
	;intro_faa
	(if (= (current_zone_set_fully_active) 1)
		(begin
			(object_create_folder scenery_faa)
			(object_create_folder crates_faa)
			
			(object_destroy_folder effects_intro)
			;(object_destroy_folder effects_laa)
			(object_destroy_folder effects_worker)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 2) 1)
	;faa_lakea
	(if (= (current_zone_set_fully_active) 2)
		(begin
			(object_create_folder scenery_laa)
			(object_create_folder crates_laa)
			
			(object_destroy_folder effects_intro)
			;(object_destroy_folder effects_laa)
			(object_create_folder effects_worker)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 3) 1)
	;faa_lakea_fab
	(if (= (current_zone_set_fully_active) 3)
		(begin
			(object_destroy_folder scenery_intro)
			(object_destroy_folder crates_intro)
			(object_destroy_folder vehicles_intro)
			(object_destroy_folder effects_intro)
			(sleep 1)
			(object_create_folder scenery_fab)
			(object_create_folder crates_fab)
			
			(object_destroy_folder effects_intro)
			;(object_destroy_folder effects_laa)
			;(object_destroy_folder effects_worker)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 5) 1)
	;fab_lakeb
	(if (= (current_zone_set_fully_active) 5)
		(begin
			(object_destroy_folder scenery_faa)
			(object_destroy_folder crates_faa)
			(object_destroy_folder scenery_laa)
			(object_destroy_folder crates_laa)
			(object_destroy_folder effects_laa)
			(sleep 1)
			(object_create_folder scenery_lab)
			(object_create_folder crates_lab)
			
			(object_destroy_folder effects_intro)
			(object_destroy_folder effects_laa)
			(object_destroy_folder effects_worker)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 6) 1)
	;scarab
	(if (= (current_zone_set_fully_active) 6)
		(begin
			(object_destroy_folder scenery_fab)
			(object_destroy_folder crates_fab)
			(sleep 1)
			(object_create_folder scenery_office)
			(object_create_folder crates_office)
			
			(object_create_folder effects_worker)
			(object_destroy_folder effects_intro)
			(object_destroy_folder effects_laa)
		)
	)

	(sleep_until (>= (current_zone_set_fully_active) 7) 1)
	;ware
	(if (= (current_zone_set_fully_active) 7)
		(begin
			(object_destroy_folder scenery_lab)
			(object_destroy_folder crates_lab)
			(sleep 1)
			(object_create_folder scenery_ware)
			(object_create_folder crates_ware)
			
			(object_destroy_folder effects_intro)
			(object_destroy_folder effects_laa)
			(object_destroy_folder effects_worker)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 8) 1)
	;ware_worker
	(if (= (current_zone_set_fully_active) 8)
		(begin
			(object_destroy_folder scenery_office)
			(object_destroy_folder crates_office)
			(sleep 1)
			(object_create_folder scenery_worker)
			(object_create_folder crates_worker)
			(object_create_folder effects_worker)
			
			(object_destroy_folder effects_intro)
			(object_destroy_folder effects_laa)
			;(object_destroy_folder effects_worker)
		)
	)
	
	(sleep_until (>= (current_zone_set_fully_active) 9) 1)
	;ware_worker
	(if (= (current_zone_set_fully_active) 9)
		(begin
			(object_destroy_folder scenery_ware)
			(object_destroy_folder crates_ware)
			
			(object_destroy_folder effects_intro)
			(object_destroy_folder effects_laa)
			;(object_destroy_folder effects_worker)
		)
	)
)

;*********************************************************************;
;Main Mission Script
;*********************************************************************;
(script static void start
	; fade out 
	(fade_out 0 0 0 0)

	; if game is allowed to start do this 
	(cond
		((= (game_insertion_point_get) 0) (ins_intro))
		((= (game_insertion_point_get) 1) (ins_scarab))
	)
)
			



(script startup mission_voi
	(print_difficulty)
	
	; fade to black 
	(fade_out 0 0 0 0)
	(sound_class_set_gain "" 0 0)
	
	; hide the players 
	(object_hide (player0) TRUE)
	(object_hide (player1) TRUE)
	(object_hide (player2) TRUE)
	(object_hide (player3) TRUE)
	
	; set allegiances 
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	(ai_allegiance human covenant)
	
	; the game can use flashlights 
	(game_can_use_flashlights TRUE)
	
	;HUD
	(chud_show_fire_grenades FALSE)
	
	; wake global scripts 
	(wake gs_camera_bounds)
	
	; wake object management scripts
	(wake object_management)
	
	;this sometimez gets fucked up cuz of the intro
	(player_disable_movement FALSE)
	
	;zone set trigger disable
	(zone_set_trigger_volume_enable begin_zone_set:faa_lakea FALSE)
	(zone_set_trigger_volume_enable zone_set:faa_lakea FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:fab_lakeb FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:scarab FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:bfg FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:ware_worker FALSE)
	(zone_set_trigger_volume_enable zone_set:ware_worker FALSE)
	
	;kill volume setup
	(kill_volume_disable kill_all_lakebed_a)
	(kill_volume_disable kill_bfg_cin_start)

	; === INSERTION POINT TEST =====================================================
	(if	(and
			(not editor)
			(> (player_count) 0)
		)
		(start)
		
		; if the game is NOT allowed to start do this 
		(begin 
			(cinematic_fade_to_gameplay)
			(gs_camera_bounds_off)
		)
	)
	; === INSERTION POINT TEST =====================================================

		;====
			;Begin voi introduction
			(sleep_until (>= g_insertion_index 1) 1)
			(if (<= g_insertion_index 1) (wake intro))
		
		;====
			;Begin Factory A
			(sleep_until	(or
							(= (current_zone_set_fully_active) 1)
							(>= g_insertion_index 2)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 2) (wake factory_a_start))
			
		;====
			;Begin Lakebed A
			(sleep_until	(or
							(= (current_zone_set_fully_active) 2)
							(>= g_insertion_index 3)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 3) (wake lakebed_a_start))
		
		;====
			;Begin Factory B
			(sleep_until	(or
							(= (current_zone_set_fully_active) 3)
							(>= g_insertion_index 4)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 4) (wake factory_b_start))
		
		;====
			;Begin Lakebed B 
			(sleep_until	(or
							(= (current_zone_set_fully_active) 5)
							(>= g_insertion_index 5)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 5) (wake lakebed_b_start))
		
		;====
			;Begin Scarab
			(sleep_until	(or
							(= (current_zone_set_fully_active) 6)
							(>= g_insertion_index 6)
						)
			1)
				; wake encounter script 
				(if (<= g_insertion_index 6) (wake scarab_start))
		
		;====
			;Begin Cortana Office
			(sleep_until	(or
							g_scarab_dead
							(>= g_insertion_index 7)
						)
			1)
				; wake encounter script 
			(if (<= g_insertion_index 7) (wake cortana_office_start))

		;====
			;Begin Warehouse 
			(sleep_until	(or
							(= (current_zone_set_fully_active) 7)
							(>= g_insertion_index 8)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 8) (wake warehouse_start))
			
		;====
			;Begin Worker Town 
			(sleep_until	(or
							(= (current_zone_set_fully_active) 8)
							(>= g_insertion_index 9)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 9) (wake worker_start))
			
		;====
			;Begin BFG 
			(sleep_until	(or
							(= (current_zone_set_fully_active) 9)
							(>= g_insertion_index 10)
						)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 10) (wake BFG_start))

)

;====================================================================================================================================================================================================
;=============================== CAMERA BOUNDS ======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_camera_bounds
                ; turn on all camera bounds 
                (gs_camera_bounds_on)
                
                ; factory a  <- this is the same sleep you use for determining when to spawn the guys past the second door in factory a
                (sleep_until
                                (or
                                                (volume_test_players vol_tank_room_a_exit)
                                                (<= (ai_task_count factory_a_covenant_obj/tank_room_combat01) 1)
                                )
                )
                                (soft_ceiling_enable camera_fa_01 FALSE)
                             
                (sleep_until (volume_test_players vol_factory_b_init))
                ; factory b  <- this is the same sleep you use for determining when to spawn the guys past the second door in factory b
                (sleep_until 
                                (or
                                                (volume_test_players vol_factory_b_buginit)
                                                (and 
                                                                (>= (device_get_position factory_b_entry02) 1)
                                                                (volume_test_players vol_factory_b_buginit02)
                                                )
                                )
                )
                                (soft_ceiling_enable camera_fb_01 FALSE)
)                              
                                
(script static void gs_camera_bounds_off                            
                (print "turn off camera bounds")

                ; factory a
                (soft_ceiling_enable camera_fa_01 FALSE)
                ; factory b
                (soft_ceiling_enable camera_fb_01 FALSE)

)                              

(script static void gs_camera_bounds_on                             
                (print "turn on camera bounds")

                ; factory a
                (soft_ceiling_enable camera_fa_01 TRUE)
                ; factory b
                (soft_ceiling_enable camera_fb_01 TRUE)

)


;====================================================================================================================================================================================================
;=============================== CINEMATIC LIGHTING =================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_cinematic_lights
	(cinematic_light_object ark "" lighting_ark light_anchor)
	(cinematic_light_object ark_cruiser_01 "" lighting_ships light_anchor)
	(cinematic_light_object ark_cruiser_02 "" lighting_ships light_anchor)
	(cinematic_light_object truth_ship "" lighting_ships light_anchor)
	(cinematic_light_object storm "" lighting_storm light_anchor)
	(cinematic_light_object clouds_ark "" lighting_clouds light_anchor)
	(cinematic_lighting_rebuild_all)
)                         