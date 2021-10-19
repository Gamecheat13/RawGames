(global boolean debug TRUE)
(global boolean g_ch_14_cortana_talk FALSE)

(script static void fx_test_fp_hero
	(player_enable_input FALSE)
	(player_disable_movement TRUE)
	(player_camera_control FALSE)
	(unit_drop_support_weapon (player0))
	(sleep 1)
	(object_set_velocity (player0) 4)
	(player_control_lock_gaze (player0) inner_sanctum_pts/p0 70)
;	(sleep_until (objects_can_see_flag (player0) trapped_corty_flag 7) 1 60)
	(sleep 30)
;	(unit_lower_weapon (player0) 30) 
;	(sleep 30)

	(gs_lower_weapon)
	(sleep 60)
	(unit_start_first_person_custom_animation (player0) objects\characters\masterchief\fp\weapons\melee\fp_rescue_cortana\fp_rescue_cortana "first_person:rescue" TRUE)

	(sleep_until (= (unit_is_playing_custom_first_person_animation (player0)) FALSE) 1)
	(unit_stop_first_person_custom_animation (player0))
	(unit_raise_weapon (player0) 0)
	(sleep 30)
	(gs_lower_weapon)
	(sleep 150)
	(player_control_unlock_gaze (player0))
	(unit_raise_weapon (player0) 30)
	(player_camera_control TRUE)
	(player_disable_movement FALSE)
	(player_enable_input TRUE)
)

(script static void gs_lower_weapon
	(unit_lower_weapon (player0) 30)
	(unit_lower_weapon (player1) 30)
	(unit_lower_weapon (player2) 30)
	(unit_lower_weapon (player3) 30)
)


;====================================================================================================================================================================================================
;==================================== REACTOR (RETURN) ==============================================================================================================================================
;====================================================================================================================================================================================================
(global boolean reactor_blown FALSE)

(script static void fx_test_reactors
    (switch_zone_set e)
    (sleep 30)
    (object_teleport (player0) hallway_5_rev_p1)
    (wake fx_test_enc_reactor_return)
)

(script dormant fx_test_enc_reactor_return
	;(data_mine_set_mission_segment "110_120_reactor_rev")
	;(if debug (print "enc_reactor_return"))

	(object_create_anew blockage_01)
	(object_create_anew blockage_02)
	(device_set_power pylon_switch_01 1)
;	(object_destroy pylon_04x)
	;(wake reactor_rev_spawning)

	(sleep_until (= (device_group_get pylons) 1))
	(hud_deactivate_team_nav_point_flag player switch_flag)
	(device_set_power pylon_switch_01 0)
	
	(sleep_until 
		(AND
			(= (device_get_position pylon_01) 1)
			(= (device_get_position pylon_02) 1)
			(= (device_get_position pylon_03) 1)
		)
	)
	(hud_activate_team_nav_point_flag player pylon_01_flag 0)
	(hud_activate_team_nav_point_flag player pylon_02_flag 0)
	(hud_activate_team_nav_point_flag player pylon_03_flag 0)
	(wake pylon_01_mon)
	(wake pylon_02_mon)
	(wake pylon_03_mon)
	(object_destroy pylon_01)
	(object_create pylon_01x)
	(object_destroy pylon_02)
	(object_create pylon_02x)
	(object_destroy pylon_03)
	(object_create pylon_03x)
	(if
		(or
			(difficulty_heroic)
			(difficulty_legendary)
		)
			(begin
				(object_create bubble_01)
				(objects_attach pylon_01x "center" bubble_01 "center")
				(object_create bubble_02)
				(objects_attach pylon_02x "center" bubble_02 "center")
				(object_create bubble_03)
				(objects_attach pylon_03x "center" bubble_03 "center")
			)
	)
		
	(sleep_until
		(AND
			(<= (object_get_health pylon_01x) 0)
			(<= (object_get_health pylon_02x) 0)
			(<= (object_get_health pylon_03x) 0)
		)
	)
	(set reactor_blown TRUE)
	
	(sleep 210)
	(wake alarm_loop)
	(wake random_distant_booms)
	(wake random_near_booms)
	(wake invisible_timer)	

	(sleep 1)

	(device_set_power door_reactor_escape 1)
	(device_set_position door_reactor_escape 1)
	
	(sleep_until (= (device_get_position door_reactor_escape) 1) 1)
	(device_set_power door_reactor_escape 0)

;	(sleep_until (= (volume_test_players vol_hallway_4_rev_start) TRUE))
;	(ai_place reactor_rev_pure_ender 1)
)

;============================= reactor (return) secondary scripts ===================================================================================================================================
;	a = .4
;	b = -3.8
;	c = 10

;escalates frequency of explosions over five minutes
(global real elapsed_time 0)
(global real boom_delay 0)
(script dormant invisible_timer
	(sleep_until
		(begin
			(set elapsed_time (+ elapsed_time .0167))
			(set boom_delay (+ (* .4 elapsed_time elapsed_time) (* -3.8 elapsed_time) 10))
			(or
				(> elapsed_time 5)
				(< boom_delay 1)
			)
		)
	30)
	(set elapsed_time 5)
	(set boom_delay 1)
)

;additional camera shake and rumble for explosions you can't see/feel
(script dormant random_distant_booms
	(sleep_until
		(begin
			(player_effect_set_max_rotation (real_random_range 0 1) (real_random_range 0 1) (real_random_range 0 1))
			(player_effect_set_max_rumble (real_random_range .5 1) (real_random_range .5 1))
			(player_effect_start (real_random_range 0.1 .35) (real_random_range 0.5 1))
			(player_effect_stop (real_random_range 2 3))
			(sleep (random_range (* 10 boom_delay) (* 60 boom_delay)))
			FALSE
		)
	)
)

;function for random explosion type
(global short random_boom 0)
(script static void (random_near_boom (point_reference boom_set))
	(sleep (random_range (* 1 boom_delay) (* 6 boom_delay)))
	(set random_boom (random_range 1 5))
	(if (= random_boom 1)
		(effect_new_random fx\scenery_fx\explosions\high_charity_explosion_medium\high_charity_explosion_medium.effect boom_set)
	)
	(if (= random_boom 2)
		(effect_new_random fx\scenery_fx\explosions\high_charity_explosion_medium\high_charity_explosion_medium.effect boom_set)
	)
	(if (= random_boom 3)
		(effect_new_random fx\scenery_fx\explosions\high_charity_explosion_large\high_charity_explosion_large.effect boom_set)
	)
	(if (= random_boom 4)
		(effect_new_random fx\scenery_fx\explosions\high_charity_explosion_large\high_charity_explosion_large.effect boom_set)
	)
)

;scripting explosions as you run out of the ship
(script dormant random_near_booms
	(sleep_until
		(begin
			(if (< (objects_distance_to_flag (players) near_reactor_01) 25)
				(begin_random
					(random_near_boom escape_reactor_01)
					(random_near_boom escape_reactor_02)
					(random_near_boom escape_reactor_03)
					(random_near_boom escape_reactor_04)
					(random_near_boom escape_reactor_07)
					(random_near_boom escape_hall4_01)
				)
			)
			(if (< (objects_distance_to_flag (players) near_reactor_02) 25)
				(begin_random
					(random_near_boom escape_reactor_01)
					(random_near_boom escape_reactor_02)
					(random_near_boom escape_reactor_03)
					(random_near_boom escape_reactor_04)
					(random_near_boom escape_reactor_05)
					(random_near_boom escape_reactor_06)
					(random_near_boom escape_reactor_07)
				)
			)
			(if (< (objects_distance_to_flag (players) near_hall4_01) 25)
				(begin_random
					(random_near_boom escape_reactor_07)
					(random_near_boom escape_hall4_01)
					(random_near_boom escape_hall4_02)
					(random_near_boom escape_hall4_03)
					(random_near_boom escape_hall4_04)
				)
			)
			(if (< (objects_distance_to_flag (players) near_hall4_02) 25)
				(begin_random
					(random_near_boom escape_hall4_01)
					(random_near_boom escape_hall4_02)
					(random_near_boom escape_hall4_03)
					(random_near_boom escape_hall4_04)
					(random_near_boom escape_hall4_05)
				)
			)
			(if (< (objects_distance_to_flag (players) near_hall4_03) 25)
				(begin_random
					(random_near_boom escape_hall4_04)
					(random_near_boom escape_hall4_05)
					(random_near_boom escape_hall4_06)
					(random_near_boom escape_cafe_01)
				)
			)
			(if (< (objects_distance_to_flag (players) near_bridge_01) 25)
				(begin_random
					(random_near_boom escape_hall4_06)
					(random_near_boom escape_cafe_01)
					(random_near_boom escape_cafe_02)
					(random_near_boom escape_cafe_03)
					(random_near_boom escape_cafe_04)
					(random_near_boom escape_cafe_05)
					(random_near_boom escape_cafe_06)
					(random_near_boom escape_cafe_07)
					(random_near_boom escape_cafe_08)
					(random_near_boom escape_cafe_09)
					(random_near_boom escape_cafe_11)
				)
			)
			(if (< (objects_distance_to_flag (players) near_bridge_02) 25)
				(begin_random
					(random_near_boom escape_cafe_01)
					(random_near_boom escape_cafe_02)
					(random_near_boom escape_cafe_03)
					(random_near_boom escape_cafe_04)
					(random_near_boom escape_cafe_05)
					(random_near_boom escape_cafe_06)
					(random_near_boom escape_cafe_07)
					(random_near_boom escape_cafe_08)
					(random_near_boom escape_cafe_09)
					(random_near_boom escape_cafe_10)
					(random_near_boom escape_cafe_11)
				)
			)
			(if (< (objects_distance_to_flag (players) near_bridge_03) 25)
				(begin_random
					(random_near_boom escape_cafe_01)
					(random_near_boom escape_cafe_04)
					(random_near_boom escape_cafe_05)
					(random_near_boom escape_cafe_06)
					(random_near_boom escape_cafe_07)
					(random_near_boom escape_cafe_08)
					(random_near_boom escape_cafe_09)
					(random_near_boom escape_cafe_10)
					(random_near_boom escape_halls23_01)
				)
			)
			(if (< (objects_distance_to_flag (players) near_bridge_04) 25)
				(begin_random
					(random_near_boom escape_cafe_10)
					(random_near_boom escape_halls23_01)
					(random_near_boom escape_halls23_02)
					(random_near_boom escape_halls23_03)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_01) 25)
				(begin_random
					(random_near_boom escape_halls23_02)
					(random_near_boom escape_halls23_03)
					(random_near_boom escape_halls23_04)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_02) 25)
				(begin_random
					(random_near_boom escape_halls23_02)
					(random_near_boom escape_halls23_03)
					(random_near_boom escape_halls23_04)
					(random_near_boom escape_halls23_05)
					(random_near_boom escape_halls23_06)
					(random_near_boom escape_halls23_07)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_03) 25)
				(begin_random
					(random_near_boom escape_halls23_03)
					(random_near_boom escape_halls23_04)
					(random_near_boom escape_halls23_05)
					(random_near_boom escape_halls23_06)
					(random_near_boom escape_halls23_07)
					(random_near_boom escape_halls23_08)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_04) 25)
				(begin_random
					(random_near_boom escape_halls23_04)
					(random_near_boom escape_halls23_05)
					(random_near_boom escape_halls23_06)
					(random_near_boom escape_halls23_07)
					(random_near_boom escape_halls23_08)
				)
			)
			(if (< (objects_distance_to_flag (players) near_halls23_05) 25)
				(begin_random
					(random_near_boom escape_halls23_05)
					(random_near_boom escape_halls23_06)
					(random_near_boom escape_halls23_07)
					(random_near_boom escape_halls23_08)
					(random_near_boom escape_pel_hill_01)
				)
			)
			(if (< (objects_distance_to_flag (players) near_pel_hill_01) 25)
				(begin_random
					(random_near_boom escape_halls23_07)
					(random_near_boom escape_halls23_08)
					(random_near_boom escape_pel_hill_01)
					(random_near_boom escape_pel_hill_02)
					(random_near_boom escape_pel_hill_03)
					(random_near_boom escape_pel_hill_04)
					(random_near_boom escape_pel_hill_08)
				)
			)
			(if (< (objects_distance_to_flag (players) near_pel_hill_01) 25)
				(begin_random
					(random_near_boom escape_pel_hill_01)
					(random_near_boom escape_pel_hill_02)
					(random_near_boom escape_pel_hill_03)
					(random_near_boom escape_pel_hill_04)
					(random_near_boom escape_pel_hill_05)
					(random_near_boom escape_pel_hill_06)
					(random_near_boom escape_pel_hill_07)
					(random_near_boom escape_pel_hill_08)
				)
			)
			FALSE
		)
	1)
)

;placeholder alarm loop sound using scarab alarm
(global sound alarm_ring sound\device_machines\scarab\scarab_alarm.sound)
(script dormant alarm_loop
	(sleep_until 
		(AND
			(= (volume_test_object vol_reactor_goo pylon_01x) TRUE)
			(= (volume_test_object vol_reactor_goo pylon_02x) TRUE)
			(= (volume_test_object vol_reactor_goo pylon_03x) TRUE)
		)
	30 180)
	(sleep_until
		(begin
			(sound_impulse_start sound\device_machines\hc_reactor_pylons\hc_alarm.sound NONE 1) 
			(sleep 60)
			FALSE
		)
	)
)

;hactacular scripts for destroying the pylons
(global effect babam objects\weapons\grenade\plasma_grenade\fx\detonation.effect)
(global effect kasploosh fx\scenery_fx\explosions\covenant_explosion_large\covenant_explosion_large.effect)
(global effect kaboom objects\vehicles\wraith\fx\destruction\trans_hull_destroyed.effect)
(global effect kablooie objects\vehicles\wraith\fx\destruction\trans_mortar_destroyed.effect)
(global short pylon_countdown 5)
(global short pylon_delay 0)
(global short pylon_total 0)
(global boolean pylon_bam FALSE)
(script static void (blow_pylon_x (object which_pylon))
	(sound_looping_start "sound\device_machines\hc_reactor_pylons\pylon_windup\pylon_windup.sound_looping" which_pylon 1)
	(sleep (- (* 7 30) pylon_total))
	(object_damage_damage_section which_pylon "core" 1)
	(set pylon_countdown 5)
	(set pylon_delay 0)
	(set pylon_total 0)
	(set pylon_bam FALSE)
	(sound_looping_stop "sound\device_machines\hc_reactor_pylons\pylon_windup\pylon_windup.sound_looping")
)

(global short pylon_count 3)
(script dormant pylon_01_mon
	(sleep_until (<= (object_get_health pylon_01x) 0))
	(hud_deactivate_team_nav_point_flag player pylon_01_flag)
	(objects_detach pylon_01x bubble_01)
	(sleep 1)
	(object_destroy bubble_01)
	(blow_pylon_x pylon_01x)
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound" pylon_01x 1)
	
	(sleep_until (= (volume_test_object vol_reactor_goo pylon_01x) TRUE) 1 180)
	(sound_impulse_stop "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound")
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_boom_dist.sound" pylon_01x 1)
;	(effect_new_on_object_marker kasploosh pylon_01x "center")
	(set pylon_count (- pylon_count 1))
	
	(sleep_until (= (volume_test_players vol_pylon_01) FALSE))
	(game_save)
)
(script dormant pylon_02_mon
	(sleep_until (<= (object_get_health pylon_02x) 0))
	(hud_deactivate_team_nav_point_flag player pylon_02_flag)
	(objects_detach pylon_02x bubble_02)
	(sleep 1)
	(object_destroy bubble_02)
	(blow_pylon_x pylon_02x)
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound" pylon_02x 1)
	
	(sleep_until (= (volume_test_object vol_reactor_goo pylon_02x) TRUE) 1 180)
	(sound_impulse_stop "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound")
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_boom_dist.sound" pylon_02x 1)
;	(effect_new_on_object_marker kasploosh pylon_02x "center")
	(set pylon_count (- pylon_count 1))

	(sleep_until (= (volume_test_players vol_pylon_02) FALSE))
	(game_save)
)
(script dormant pylon_03_mon
	(sleep_until (<= (object_get_health pylon_03x) 0))
	(hud_deactivate_team_nav_point_flag player pylon_03_flag)
	(objects_detach pylon_03x bubble_03)
	(sleep 1)
	(object_destroy bubble_03)
	(blow_pylon_x pylon_03x)
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound" pylon_03x 1)
	
	(sleep_until (= (volume_test_object vol_reactor_goo pylon_03x) TRUE) 1 180)
	(sound_impulse_stop "sound\device_machines\hc_reactor_pylons\pylon_shudders\pylon_shudders.sound")
	(sound_impulse_start "sound\device_machines\hc_reactor_pylons\pylon_boom_dist.sound" pylon_03x 1)
;	(effect_new_on_object_marker kasploosh pylon_03x "center")
	(set pylon_count (- pylon_count 1))

	(sleep_until (= (volume_test_players vol_pylon_03) FALSE))
	(game_save)
)
