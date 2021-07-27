; B30 Mission Script
; --------------------

;========== Flavor Scripts ==========
(script dormant flavor_cutscene_ledge
	(sleep_until (volume_test_objects shaftA_ledge_trigger (players)) 5)
	(if (game_all_quiet) (cutscene_ledge))
	)

(script dormant crack_arrival
	(sleep_until (or (volume_test_objects crack_arrival_trigger (players))
				  global_shaftA_unlocked) 10)
	(if (not global_shaftA_unlocked) (ai_conversation crack_arrival))
	)

(script dormant shaftB_arrival
	(sleep_until (or global_shaftA_unlocked global_shaftA_known_locked))
	(sleep_until (or (volume_test_objects downed_trigger (players))
				  global_shaftA_unlocked) 10)
	(if (not global_shaftA_unlocked) (ai_conversation shaftB_arrival))
	)

;========== Continuous Scripts ==========
(script continuous cont_shaftA_entrance_inv
	(if global_shaftA_inv_active (ai_magically_see_players shaftA_entrance_inv))
;Make sure the script never triggers more than once every 2 seconds no matter what
	(sleep 60)
	)

(script continuous shafta_killer
	(sleep_until (volume_test_objects shafta_killer_trigger (players)) 5)
	(if (volume_test_objects shafta_killer_trigger (player0)) (damage_object "effects\damage effects\guaranteed explosion of doom" (player0)))
	(if (volume_test_objects shafta_killer_trigger (player1)) (damage_object "effects\damage effects\guaranteed explosion of doom" (player1)))
	)

;========== Beach Scripts ==========

(script dormant mission_beach_lz
	(sleep_until (or (> 6 (ai_living_count beach_lz/camp_toon))
				  (volume_test_objects beach_lz_rock (players))) 5 delay_dawdle)
	(ai_defend beach_lz/camp_toon)
	(sleep_until (volume_test_objects beach_lz_rock (players)) 5 delay_dawdle)
	(ai_migrate beach_lz_marine/left_marine_toon beach_lz_marine/left_marine_rock)
	(ai_migrate beach_lz_marine/right_marine_toon beach_lz_marine/right_marine_rock)

	(sleep_until (or (> 2 (ai_living_count beach_lz/camp_toon))
				  (volume_test_objects beach_lz_camp (players))) 5 delay_dawdle)
	(ai_retreat beach_lz/camp_toon)
	(sleep_until (volume_test_objects beach_lz_camp (players)) 5 delay_dawdle)
	(ai_migrate beach_lz_marine/left_marine_toon beach_lz_marine/left_marine_camp)
	(ai_migrate beach_lz_marine/right_marine_toon beach_lz_marine/right_marine_camp)

	(sleep_until (or (> 7 (ai_living_count beach_lz/base_toon))
				  (volume_test_objects beach_lz_base_attack (players))) 5 delay_dawdle)
	(ai_defend beach_lz/base_toon)
	(sleep_until (volume_test_objects beach_lz_base_attack (players)) 5 delay_dawdle)
	(ai_migrate beach_lz_marine/left_marine_toon beach_lz_marine/left_marine_base_attack)
	(ai_migrate beach_lz_marine/right_marine_toon beach_lz_marine/right_marine_base_attack)

	(sleep_until (or (> 3 (ai_living_count beach_lz/base_toon))
				  (volume_test_objects beach_lz_base (players))) 5 delay_dawdle)
	(ai_defend beach_lz/base_toon)
	(sleep_until (volume_test_objects beach_lz_base (players)) 5 delay_dawdle)
	(ai_migrate beach_lz_marine/left_marine_toon beach_lz_marine/marine_base)
	(ai_migrate beach_lz_marine/right_marine_toon beach_lz_marine/marine_base)

	(sleep 60)
	(ai_timer_expire beach_lz/arch_toon)
	(sleep_until (volume_test_objects beach_lz_arch_attack (players)) 5 delay_dawdle)
	(ai_migrate beach_lz_marine beach_lz_marine/marine_arch_attack)

	(sleep_until (or (> 5 (ai_living_count beach_lz/arch_toon))
				  (volume_test_objects beach_lz_arch (players))) 5 delay_dawdle)
	(ai_defend beach_lz/arch_toon)
	(sleep_until (volume_test_objects beach_lz_arch (players)) 5 delay_dawdle)
	(ai_migrate beach_lz_marine beach_lz_marine/marine_arch)

	(sleep_until (or (> 3 (ai_living_count beach_lz/arch_toon))
				  (volume_test_objects beach_lz_arch_back (players))) 5 delay_dawdle)
	(ai_retreat beach_lz/arch_toon)
	(ai_migrate beach_lz_marine beach_lz_marine/marine_arch_back)

	(sleep_until (= 0 (ai_living_count beach_lz/arch_toon)) 5 delay_lost)
	(if (< 1 (ai_living_count beach_lz_marine)) (wake save_beach_lz))
	(set play_music_b30_01 false)

	(object_create hog_pelican)
	(unit_set_enterable_by_player hog_pelican 0)
	(object_teleport hog_pelican hog_pelican_flag_1)
	(object_create jeep)
;	(object_create jeep_gunner)
;	(unit_enter_vehicle jeep_gunner jeep "W-gunner")
	(unit_enter_vehicle jeep hog_pelican "cargo")
	(recording_play_and_hover hog_pelican hog_pelican_in)
	(sleep 60)
	(ai_conversation jeep_delivery)

	(sleep (recording_time hog_pelican))
	(sleep_until (not (volume_test_objects jeep_delivery (players))) 10)
	(unit_exit_vehicle jeep)
	(sleep 30)
	(activate_team_nav_point_object "default_red" player jeep .5)

;	(ai_attach jeep_gunner beach_lz_marine)
	(sleep 30)

	(vehicle_hover hog_pelican 0)
	(recording_play_and_delete hog_pelican hog_pelican_out)

	(sleep_until (< 4 (ai_conversation_status jeep_delivery)) 1)
	(ai_conversation jeep_load)

	(sleep_until (< 1 (ai_conversation_line jeep_load)) 1)
	(ai_go_to_vehicle beach_lz_marine jeep "gunner")
	(ai_go_to_vehicle beach_lz_marine jeep "passenger")
	(sleep_until (or (not (volume_test_objects_all beach_lz (players)))
				  (vehicle_test_seat_list jeep W-driver (players))))
	(deactivate_team_nav_point_object player jeep)

;	(sleep_until (= 0 (ai_going_to_vehicle jeep)) delay_dawdle)
	(sleep_until (< 4 (ai_conversation_status jeep_load)) 1)
	(sleep_until (= (ai_going_to_vehicle jeep) 0) 1 delay_dawdle)
	(ai_conversation jeep_go)
	(sleep 45)
	(set mark_map true)
	(objects_predict shaftA_cship)
	(objects_predict (ai_actors beach_slab))
	(objects_predict (ai_actors shaftA_entrance))
	
	(sleep_until global_shaftA_switched)
	(ai_kill beach_lz_marine)
	)

(script dormant mission_beach
	(ai_place beach_crack)
	(wake save_beach_crack)
	(ai_place beach_pass)
	(wake save_beach_pass)
	(ai_place beach_slab)
	(wake save_beach_slab)
	
;	(sleep_until (or (volume_test_objects beach_1 (players))
;				  (volume_test_objects beach_2 (players))) 1)
;	(if (volume_test_objects beach_1 (players)) (set mark_beach_ghost_pass true))
;	(object_create ghost_cship)
;	(if mark_beach_ghost_pass (object_teleport ghost_cship ghost_cship_flag_1) (object_teleport ghost_cship ghost_cship_flag_2))
;	(vehicle_hover ghost_cship 1)
;	(unit_close ghost_cship)
;	(object_create beach_ghost_1)
;	(object_create beach_ghost_2)
;	(ai_place beach_ghost/pilot_1)
;	(ai_braindead beach_ghost/pilot_1 1)
;	(ai_place beach_ghost/pilot_2)
;	(ai_braindead beach_ghost/pilot_2 1)
;	(vehicle_load_magic beach_ghost_1 "" (ai_actors beach_ghost/pilot_1))
;	(vehicle_load_magic beach_ghost_2 "" (ai_actors beach_ghost/pilot_2))
;	(unit_enter_vehicle beach_ghost_1 ghost_cship "cargo_ghost01")
;	(unit_enter_vehicle beach_ghost_2 ghost_cship "cargo_ghost02")
;
;	(sleep_until (or (volume_test_objects beach_1c (players))
;				  (volume_test_objects beach_2c (players))
;				  (objects_can_see_object (players) ghost_cship 25)) 1 delay_dawdle)
;	(unit_exit_vehicle beach_ghost_2)
;	(sleep 60)
;	(unit_exit_vehicle beach_ghost_1)
;	(ai_magically_see_players beach_ghost)
;	(ai_braindead beach_ghost 0)
;	(ai_follow_target_players beach_ghost)
;	(sleep 30)
;	(vehicle_hover ghost_cship 0)
;	(if mark_beach_ghost_pass (recording_play_and_delete ghost_cship ghost_cship_exit_1) (recording_play_and_delete ghost_cship ghost_cship_exit_2))
	)

;========== ShaftA Scripts ==========

(script dormant mission_shaftA_banshee
;	(ai_force_active beach_banshee 1)
;	(object_create shaftA_banshee_1)
;	(unit_set_enterable_by_player shaftA_banshee_1 0)
;	(object_create shaftA_banshee_2)
;	(unit_set_enterable_by_player shaftA_banshee_2 0)
;	(ai_place beach_banshee/pilot_1)
;	(ai_place beach_banshee/pilot_2)
;	(vehicle_load_magic shaftA_banshee_1 "" (ai_actors beach_banshee/pilot_1))
;	(vehicle_load_magic shaftA_banshee_2 "" (ai_actors beach_banshee/pilot_2))
;	(object_teleport shaftA_banshee_1 shaftA_banshee_flag_1)
;	(object_teleport shaftA_banshee_2 shaftA_banshee_flag_2)
;	(ai_force_active beach_banshee 1)
;	(ai_command_list beach_banshee/pilot_1 beach_banshee_1)
;	(ai_command_list beach_banshee/pilot_2 beach_banshee_2)
	(sleep 90)
;	(ai_magically_see_players beach_banshee)
;	(ai_follow_target_players beach_banshee)
	)

(script dormant mission_shaftA_lock
;The shaftB scripts follow the same format as the ShaftA ones.
;Gives the Player the obj of shaftB
	(if global_shaftA_unlocked (sleep -1))
	(ai_place shaftA_locked)
	(ai_command_list shaftA_locked/locker_elite shaftA_lock_1)
	(ai_braindead shaftA_locked/locker_elite 1)
;	(object_cannot_take_damage (list_get (ai_actors shaftA_locked/locker_elite) 0))

	(sleep_until (volume_test_objects shaftA_window (players)))
	(if global_shaftA_unlocked (sleep -1))
	(ai_conversation_stop shaftA_entered)
	(ai_conversation shaftA_lock_alert)

	(sleep_until (or (> 4 (ai_living_count shaftA_locked))
				  (volume_test_objects shaftA_slam (players))
				  (volume_test_objects shaftA_entrance (players))) 1 delay_blink)
;	(ai_command_list_advance shaftA_locked/locker_elite)
	
	(sleep_until (or (volume_test_objects shaftA_slam (players))
				  (volume_test_objects shaftA_entrance (players))) 1 delay_blink)

	(device_set_position shafta_lock_door 0)
	(sleep delay_blink)
;	(ai_command_list_advance shaftA_locked/locker_elite)

	(sleep_until (or (volume_test_objects shaftA_entrance (players))
				  (< (- (ai_living_count shaftA_locked) (ai_living_count shaftA_locked/locker_elite)) 1)) 1 delay_late)
	(set global_shaftA_known_locked true)
	(sleep 30)
	(wake save_shaftA_locked)
	(ai_conversation shaftA_known_locked)
	(sleep_until (< 4 (ai_conversation_status shaftA_known_locked)) 1)
	(set mark_override true)

;	(sleep_until (> (ai_command_list_status (ai_actors shaftA_locked/locker_elite)) 4) 1 delay_late)
	(ai_erase shaftA_locked/locker_elite)

;	(sleep_until (not (volume_test_objects shaftA_beach (players))) 10)
;	(wake mission_shaftA_banshee)
	)

(script dormant flavor_shaftA_entrance_cship
;Create a dropship, wait for the Player to see it and then make it leave
	(object_create shaftA_cship)
	(object_teleport shaftA_cship shaftA_cship_flag)
	(vehicle_hover shaftA_cship 1)

	(sleep_until (or (volume_test_objects beach_5 (players))
				  (volume_test_objects beach_3 (players))) 10)
	(vehicle_hover shaftA_cship 0)
	(cond ((volume_test_objects beach_5 (players)) (recording_play_and_delete shaftA_cship shaftA_cship_exit_arch))
		 ((volume_test_objects beach_3 (players)) (recording_play_and_delete shaftA_cship shaftA_cship_exit_pass))
		 (true (recording_play_and_delete shaftA_cship shaftA_cship_exit_pass))
		 )
	(sleep 60)
	(unit_close shaftA_cship)
	)

(script dormant flavor_shaftA_inv_cship
;Create a dropship, wait for the Player to see it and then make it leave
	(ai_kill shaftA_entrance)
	(if (volume_test_objects shaftA_platform jeep) (object_destroy jeep))
	(sleep 1)
	(object_create shaftA_inv_cship)
	(object_teleport shaftA_inv_cship shaftA_inv_cship_flag)
	(vehicle_hover shaftA_inv_cship 1)

	(sleep_until (volume_test_objects shaftA_entrance (players)) 10)
	(sleep 30)
	(vehicle_hover shaftA_inv_cship 0)
	(recording_play_and_delete shaftA_inv_cship shaftA_inv_cship_exit)
	(sleep 60)
	(unit_close shaftA_inv_cship)
	)
	
(script dormant obj_shaftA_goal
	(sleep_until (= 1 (device_group_get map_position)) 1)
	(switch_bsp 1)
	(volume_teleport_players_not_inside shaftA_control shaftA_control_teleflag)
	(set global_shaftA_switched true)
	(if (cinematic_skip_start) (cutscene_map))
	(cinematic_skip_stop)
	(device_set_position_immediate holohalo_1 1)

	(device_set_position_immediate shaftA_lock_door 1)
;	(sleep_until (< 4 (ai_conversation_status shaftA_switch)) 1)
	(sleep_until (volume_test_objects shaftA_entrance (players)) 1 300)
	(set mark_leave true)
	(wake save_shaftA_switched)

	(sleep_until (volume_test_objects shaftA_entrance (players)) 10)
	(ai_conversation evac_1)
	(set play_music_b30_06 true)

	(wake flavor_shaftA_inv_cship)
	(ai_place shaftA_entrance_inv/exterior_stealth_elite)
	(ai_braindead shaftA_entrance_inv 1)
	(ai_set_blind shaftA_entrance_inv 1)
	(set global_timer (+ 90 (game_time)))

	(sleep_until (volume_test_objects shaftA_entrance_inv (players)) 1 90)
	(ai_braindead shaftA_entrance_inv 0)

	(sleep 60)
	(ai_set_blind shaftA_entrance_inv 0)
	(ai_place shaftA_entrance_inv/interior_stealth_elite)
	(set global_shaftA_inv_active true)

	(sleep 210)
	(object_create extraction_pelican)
	(object_beautify extraction_pelican on)
	(object_teleport extraction_pelican extraction_pelican_flag_1)
	(recording_play_and_hover extraction_pelican extraction_pelican_1)

	(sleep (recording_time extraction_pelican))
	
	(sleep_until (or (vehicle_test_seat_list extraction_pelican "P-riderLF" (players))
				  (vehicle_test_seat_list extraction_pelican "P-riderRF" (players))) 1)
	(if (game_is_cooperative) (sleep_until (and (vehicle_test_seat_list extraction_pelican "P-riderLF" (players))
									    (vehicle_test_seat_list extraction_pelican "P-riderRF" (players))) 1))
	(set play_music_b30_06 false)
	(player_enable_input 0)
	(ai_braindead shaftA_entrance_inv 1)
	(object_destroy shafta_inv_cship)
	(object_destroy lid_cship)
 
   (if (mcc_mission_segment "cine5_final") (sleep 1))              
   
	(if (cinematic_skip_start) (cutscene_extraction_exit))
	(cinematic_skip_stop)
	(game_won)
	)

(script dormant mission_shaftA
	(ai_place shaftA_entrance)
	(wake flavor_shaftA_entrance_cship)
;	(wake obj_shaftA_tickle)
	(wake obj_shaftA_goal)

	(sleep_until (volume_test_objects shaftA_beach (players)) 10)
	(set global_shaftA_beach_start true)
	(set play_music_b30_01 false)
	(set play_music_b30_02 true)
	(sleep 90)
	(ai_conversation shaftA_arrival)
	(sleep_until (or (> (ai_conversation_status shaftA_arrival) 4)
				  (> (ai_status shaftA_entrance) 3)
				  (volume_test_objects shaftA_platform (players))) 1)
	(ai_conversation_stop shaftA_arrival)
	(sleep_until (volume_test_objects shaftA_platform (players)) 10)
	(set global_shaftA_platform_start true)
;	(deactivate_team_nav_point_flag player shaftA_entrance_flag)
	(ai_retreat shaftA_entrance/beach)
	(ai_retreat shaftA_entrance/ledge)

	(sleep_until (or (and (volume_test_objects shaftA_entrance (players))
					  (> 4 (ai_status shaftA_entrance/interior)))
				  (= 0 (ai_living_count shaftA_entrance/interior))
				  (volume_test_objects shaftA_entrance_past (players))
				  (volume_test_objects beach_3 (players))
				  (volume_test_objects beach_5 (players))) 1 delay_lost)
	(wake mission_shaftA_lock)
;	(set global_shaftA_entrance_start true)

	(set play_music_b30_02 false)
	(sleep 30)
	(ai_conversation shaftA_entered)
	(sleep_until (< 4 (ai_conversation_status shaftA_entered)) 1)
	(set mark_activate true)

	(sleep_until (volume_test_objects shaftA_unlocked (players)))
	(set global_shaftA_descent_start true)
	(set play_music_b30_032 true)
	(wake save_shaftA_beam_enter)
	(ai_place shaftA_beam)

	(show_hud 0)
	(cinematic_show_letterbox 1)
	(sleep 30)
	(cinematic_set_title down)
	(sleep 150)
	(if (not test_ledge) (cinematic_show_letterbox 0))
	(if (not test_ledge) (show_hud 1))

	(wake save_shaftA_beam)
	(wake save_shaftA_u_enter)
	(ai_place shaftA_u)
	(wake save_shaftA_u)
	(wake save_shaftA_mind_enter)
	(ai_place shaftA_mind)
	(wake save_shaftA_mind)
	(wake save_shaftA_ante_enter)
	(ai_place shaftA_ante)

	(sleep_until (volume_test_objects shaftA_jig (players)) 10 delay_lost)
	(set play_music_b30_032 false)

	(sleep_until (volume_test_objects shaftA_jig (players)) 1)
	(if (not global_shaftA_switched) (ai_conversation shaftA_descent))
	
	(sleep_until (and (= 0 (ai_living_count shaftA_ante/rein_elite))
				   (volume_test_objects shaftA_switch (players))) 10)
	(if (not global_shaftA_switched) (ai_conversation shaftA_switchit))
	)

(script dormant mission_shaftA_inv
;This mission script starts off normally, but since timing is so important to
;this script, it has lots of volume tests that most scripts would not have.
;Luckily, if any of the tests fail, the level does not break.
	(sleep_until global_shaftA_switched)
;Wait until the Player flips the switch and then waits until he starts up the ramp
	(sleep_until (or (volume_test_objects shaftA_booth (players))
			  	  (volume_test_objects shaftA_ramp (players))) 10)
	(game_save_no_timeout)
	(sleep 3)
	(ai_place shaftA_ramp_inv)
	(wake save_shaftA_ramp_inv)
	(sleep 90)
	(set play_music_b30_05 true)

	(sleep_until (volume_test_objects shaftA_mind (players)) 10)
	(wake save_shaftA_mind_inv)
;Compensate for jones and his safe save requirements
	(sleep 1)
	(ai_place shaftA_mind_inv)
	(ai_migrate shaftA_mind shaftA_mind_inv)

	(sleep_until (volume_test_objects shaftA_jig (players)) 10)
	(wake save_shaftA_jig_inv)
;jones
	(sleep 1)
	(ai_place shaftA_jig_inv)
	(set play_music_b30_05_alt true)

	(sleep_until (volume_test_objects shaftA_u (players)) 10)
	(wake save_shaftA_u_inv)
;jones
	(sleep 1)
	(ai_place shaftA_u_inv)
	(ai_migrate shaftA_u shaftA_u_inv)

	(sleep_until (volume_test_objects shaftA_beam (players)) 10)
	(set play_music_b30_05_alt false)
	(wake save_shaftA_beam_inv)
;jones
	(sleep 1)
	(ai_place shaftA_beam_inv)
	(ai_migrate shaftA_beam shaftA_beam_inv)

	(sleep_until (volume_test_objects shaftA_unlocked (players)) 10)
	(set play_music_b30_05 false)
	(ai_place shaftA_locked/locker_elite)
	(ai_magically_see_players shaftA_locked)
	)

;========== ShaftB Scripts ==========

(script dormant flavor_lid_cship
;Create a dropship, wait for the Player to see it and then make it leave
	(object_create lid_cship)
	(object_teleport lid_cship lid_cship_flag)
	(vehicle_hover lid_cship 1)

	(sleep_until (volume_test_objects valley_mouth (players)) 10)
	(vehicle_hover lid_cship 0)
	(recording_play_and_delete lid_cship lid_cship_exit)
	(sleep 60)
	(unit_close lid_cship)
	)

(script static void cutscene_shaftB_goal
   (if (mcc_mission_segment "cine2_map_room") (sleep 1))              

	(player_enable_input 0)
	(fade_out 0 0 0 30)

	(object_pvs_activate shafta_lock_door)
	(device_set_position shafta_lock_door 0)
	(ai_place unlock_elite)
	(object_teleport (list_get (ai_actors unlock_elite) 0) locker_elite_flag)

	(sleep 30)
	(cinematic_start)
	(show_hud 0)
	(camera_control on)

	(camera_set shaft_switch_1 0)
	(sleep 90)
	
	(camera_set shaft_switch_2 180)
	(fade_in 0 0 0 60)
	(sleep 60)
	(device_set_position shafta_lock_door 1)
	(sleep 30)
	(ai_command_list unlock_elite shaftA_unlock_1)
	(if global_shaftA_known_locked (ai_conversation shaftB_switch_known) (ai_conversation shaftB_switch_unknown))
	(sleep (camera_time))
	(sleep 60)
	(fade_out 0 0 0 30)
	(object_pvs_activate none)

	(sleep 30)
	(camera_control off)
	(fade_in 0 0 0 30)
	(sleep 30)
	(player_enable_input 1)
	(cinematic_set_title override)
	(sleep 150)
	(show_hud 1)
	(cinematic_stop)

	(set mark_activate_2 true)
	(ai_erase unlock_elite)
	)

(script dormant mission_shaftB
;This script activates the shaftB encounters.
	(sleep_until (volume_test_objects valley_entrance (players)))
	(set global_valley_entrance_start true)
	(ai_place valley_crack)
	(wake save_valley_crack)
	(ai_place valley_lid)
	(wake save_valley_lid)

	(sleep_until (volume_test_objects valley_mouth (players)))
	(set global_valley_mouth_start true)
	(ai_place valley_mouth)
	(ai_place valley_canyon)
	(wake save_valley_canyon)
	
	(sleep_until (volume_test_objects valley_back (players)))
	(set global_valley_back_start true)
;	(deactivate_team_nav_point_flag player shaftB_entrance_flag)
	(ai_place shaftB_entrance)

	(sleep_until (volume_test_objects shaftB_entrance (players)) 10)
	(set play_music_b30_03 true)
	(set global_shaftB_entrance_start true)
	(ai_place shaftB_wide)
	(wake save_shaftB_wide)

	(sleep_until (volume_test_objects shaftB_control (players)))
	(if global_shaftA_known_locked (ai_conversation shaftB_switchit_known) (ai_conversation shaftB_switchit_unknown))

	(sleep_until (= 0 (device_group_get shaftB_switch_position)) 1)
	(set play_music_b30_03_alt true)
	(switch_bsp 0)
	(volume_teleport_players_not_inside shaftB_control shaftB_control_teleflag)
	(ai_erase shaftA_locked)
	(sleep 1)
	(cutscene_shaftB_goal)
	(set global_shaftA_unlocked true)

	(wake save_shaftB_switched)
	(set play_music_b30_03_alt false)
	(set play_music_b30_03 false)
	(ai_kill valley_crack)
	(ai_kill valley_lid)
	(ai_kill valley_mouth)
	(ai_kill valley_canyon)
	(ai_kill shaftB_entrance)
	(ai_retreat shaftB_wide)

	(ai_place shaftB_wide_inv)
	(ai_place valley_lid_inv)
	(ai_erase shaftA_entrance/platform)
	(ai_place shaftA_entrance_again)
	(wake flavor_lid_cship)
	)

;========== Crash Script ==========

(script dormant mission_crash
	(sleep_until global_shaftA_unlocked 1)
	(sleep_until (volume_test_objects shaftB_control_hall (players)) 1)
	(set play_music_b30_031 true)
	(ai_conversation downed_enter)

	(sleep_until (volume_test_objects shaftB_wide (players)) 1)
	(set play_music_b30_031_alt true)
	(object_create downed_dropship)
	(object_create downed_hog)
	(object_create downed_boulder_1)
	(object_create downed_boulder_2)
	(object_create downed_boulder_3)
	(object_create downed_rl_1)
	(object_create downed_rlammo_1)
	(object_create downed_rlammo_2)
	(object_create downed_rlammo_3)
	(object_create downed_ar_1)
	(object_create downed_arammo_1)
	(object_create downed_arammo_2)
	(object_create downed_arammo_3)
	(object_create downed_health_1)
	(object_create downed_health_2)
	(object_create downed_marine_1)
	(object_create downed_marine_2)
	(object_create downed_marine_3)
	(object_create downed_plammo_1)
	(object_create downed_plammo_2)
	(object_create_containing downed_smolder)
	(ai_place downed)

	(sleep_until (volume_test_objects shaftB_entrance_inv (players)) 1)
	(set play_music_b30_031_alt false)
	(set play_music_b30_031 false)

	(sleep_until (or (volume_test_objects downed_trigger (players))
				  (volume_test_objects downed_trigger_2 (players))
				  (objects_can_see_object (players) downed_dropship 5)) 1)
	(ai_conversation downed_seen)

;	(ai_follow_target_disable beach_ghost)
;	(object_create beach_ghost_3)
;	(object_create beach_ghost_4)
;	(ai_place beach_ghost/pilot_3)
;	(ai_place beach_ghost/pilot_4)
;	(vehicle_load_magic beach_ghost_3 "" (ai_actors beach_ghost/pilot_3))
;	(vehicle_load_magic beach_ghost_4 "" (ai_actors beach_ghost/pilot_4))

;	(sleep_until (or (volume_test_objects valley_entrance (players))
;				  (volume_test_objects downed_trigger (players))) 1)
;	(sleep 240)
;
;	(sleep_until (volume_test_objects downed_trigger (players)) 1)
;	(ai_force_active beach_ghost 1)
;	(ai_magically_see_players beach_ghost)
;	(ai_follow_target_players beach_ghost)
	)

;========== Main Script ==========
(script startup cutscene_insertion
   (if (mcc_mission_segment "cine1_intro") (sleep 1))              
	
	(sound_looping_start sound\sinomatixx_foley\b30_insertion_foley none 1)
	(sound_class_set_gain vehicle .3 0)
	
	(fade_out 0 0 0 0)
	(cinematic_start)
	(show_hud 0)
	(camera_control on)
	(wake music_b30)
	
	(set play_music_b30_01 true)
	
	(fade_in 0 0 0 60)
	(camera_set insertion_1b 0)
	(sleep 60)
	
	(object_create insertion_pelican_1)
	(object_create insertion_pelican_2)
	
	(object_beautify insertion_pelican_1 on)
	
	(ai_place beach_lz_marine)
	(ai_place beach_lz)
	(unit_enter_vehicle (player0) insertion_pelican_1 "P-riderLF")
	(unit_enter_vehicle (player1) insertion_pelican_2 "P-riderLF")
	(vehicle_load_magic insertion_pelican_1 "rider" (ai_actors beach_lz_marine/left_marine))
	(vehicle_load_magic insertion_pelican_2 "rider" (ai_actors beach_lz_marine/right_marine))
	
	(object_teleport insertion_pelican_1 insertion_pelican_flag_1)
	(recording_play_and_hover insertion_pelican_1 insertion_pelican_1_in)
	(object_teleport insertion_pelican_2 insertion_pelican_flag_2)
	(recording_play_and_hover insertion_pelican_2 insertion_pelican_2_in)
	
	(objects_predict insertion_pelican_1)
	(objects_predict insertion_pelican_2)
	(objects_predict (ai_actors beach_lz_marine))
	(objects_predict (ai_actors beach_lz))
	(object_type_predict "scenery\c_storage\c_storage")
	(object_type_predict "scenery\c_uplink\c_uplink")
	(object_type_predict "scenery\c_field_generator\c_field_generator")

;	(player_effect_set .025 0 0 0)
;	<max translation>, <max rotation>, <left rumble>, <right rumble>
;	(player_effect_play 1 2 6.5 0)
;	<intensity>, <attack (seconds)>, <sustain (seconds)>, <decay (seconds)>
	
	(camera_set insertion_2a 120)
	(sleep 60)
	(camera_set insertion_2b 90)
	(sleep 90)
	(camera_set_relative insertion_3 0 insertion_pelican_1)
	(sleep 90)
	(fade_in 1 1 1 30)
	(camera_control off)
	(sleep 15)
	(cinematic_set_title insertion)
	(sleep 30)
	(sound_impulse_start sound\dialog\b30\B30_insert_010_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\b30\B30_insert_010_Cortana))

	(sleep 30)
	(sound_impulse_start sound\dialog\b30\B30_insert_020_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\b30\B30_insert_020_Cortana))
	
	(sleep (max 0 (- (recording_time insertion_pelican_1) 900)))
	(sound_impulse_start sound\dialog\b30\B30_insert_030_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\b30\B30_insert_030_Pilot))
	
	(sleep (max 0 (- (recording_time insertion_pelican_1) 300)))
	(sound_impulse_start sound\dialog\b30\B30_insert_040_Pilot none 1)
		(sleep (sound_impulse_time sound\dialog\b30\B30_insert_040_Pilot))
	(sleep (max 0 (- (recording_time insertion_pelican_1) 120)))
	(cinematic_stop)
	(show_hud 1)

	(unit_exit_vehicle (player0))
	(unit_exit_vehicle (player1))
	(unit_set_enterable_by_player insertion_pelican_1 0)
	(unit_set_enterable_by_player insertion_pelican_2 0)
;	(sleep 30)
;	(sound_impulse_start sound\dialog\b30\B30_insert_060_Cortana none 1)

	(set global_mission_start true)
	
	(sound_class_set_gain vehicle 1 2)

	(sleep 60)
	(vehicle_unload insertion_pelican_2 "rider")
	(sound_impulse_start sound\dialog\b30\B30_insert_050_Sarge2 none 1)

	(sleep 30)
	(vehicle_unload insertion_pelican_1 "rider")
	
	(sleep_until (not (volume_test_objects mission_start (players))))
	(vehicle_hover insertion_pelican_1 0)
	(recording_play_and_delete insertion_pelican_1 insertion_pelican_1_out)

	(sleep 120)
	(vehicle_hover insertion_pelican_2 0)
	(sleep (recording_time insertion_pelican_2))
	(recording_play_and_delete insertion_pelican_2 insertion_pelican_2_out)
	)

(script startup main_b30
	(ai_allegiance player human)
	(wake objectives_b30)
	(sleep 90)
	(set mark_lz true)
	(sleep_until global_mission_start)
	(wake save_mission_start)
	(wake mission_beach_lz)

	(sleep_until (or (volume_test_objects beach_1 (players))
				  (volume_test_objects beach_2 (players))) 1 delay_lost)
	(wake mission_beach)
	(wake mission_shaftA)
	(wake mission_shaftB)
	(wake mission_crash)
	(wake mission_shaftA_inv)
	(wake flavor_cutscene_ledge)
	(wake crack_arrival)
	(wake shaftB_arrival)
	)
