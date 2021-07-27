;	A30 Mission Script
; ============================

(global boolean global_extraction false)

(script continuous gotohell_beatch
	(sleep_until (volume_test_objects gotohell (players)) delay_dawdle)
	(if (volume_test_objects gotohell (players)) (player_enable_input 0))

	(sleep_until (not (volume_test_objects gotohell (players))) delay_dawdle)
	(if (not (volume_test_objects gotohell (players))) (player_enable_input 1))
	)

(script continuous tutorial_sniper
	(if (or (game_is_cooperative)
		   (not (= (game_difficulty_get) normal))
		   (unit_solo_player_integrated_night_vision_is_active))
		(sleep -1))
	(sleep_until (unit_has_weapon_readied (player0) "weapons\sniper rifle\sniper rifle") 1)
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text tutorial_sniper_1);Press %action to exit the cryo-tube

	(sleep_until (or (not (unit_has_weapon_readied (player0) "weapons\sniper rifle\sniper rifle"))
				  (unit_solo_player_integrated_night_vision_is_active)) 1)
	(player_action_test_reset)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	)

(script static void mission_extraction_cliff_skip
	(ai off)
	(object_beautify foehammer_cliff on)
	(camera_control on)
	(cinematic_start)
	(camera_set cliff_extraction_1 0)
	(object_teleport (player1) cliff_hide_flag)
	(fade_in 0 0 0 15)
	
	(sound_looping_start sound\sinomatixx\a30_ext_cliff_foley none 1)
	(sleep 2)
	(sound_looping_start sound\sinomatixx\a30_ext_cliff_music none 1)
	(sleep 13)
	
	(vehicle_hover foehammer_cliff 0)
	(recording_play_and_delete foehammer_cliff foehammer_cliff_out)
	(camera_set cliff_extraction_2 500)
	(sleep 100)
	(sound_impulse_start sound\dialog\a30\A30_extract_060_Cortana none 1)
	(sleep (sound_impulse_time sound\dialog\a30\A30_extract_060_Cortana))
	(print "cortana done")
	(sleep (- (camera_time) 30))
	(fade_out 0 0 0 30)
	(sleep 77)
	)

; 	Filthy cinematic "build" script...please don't delete
(script static void cliff_build
	(switch_bsp 1)
	(game_speed 5)
	(object_destroy foehammer_cliff)
	(object_create foehammer_cliff)
	(unit_set_enterable_by_player foehammer_cliff 0)
	(object_teleport foehammer_cliff foehammer_cliff_flag)
	(recording_play_and_hover foehammer_cliff foehammer_cliff_in)
	(sleep (recording_time foehammer_cliff))
	(game_speed 1)
	(print "foehammer done")
	)

(script dormant mission_extraction_cliff
	(object_create foehammer_cliff)
	(unit_set_enterable_by_player foehammer_cliff 0)
	(object_teleport foehammer_cliff foehammer_cliff_flag)
	(recording_play_and_hover foehammer_cliff foehammer_cliff_in)

	(sound_impulse_start sound\dialog\a30\A30_extract_010_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_extract_010_Cortana))
	(sound_impulse_start sound\dialog\a30\A30_extract_020_Pilot none 1)
		(sleep (+ 30 (sound_impulse_time sound\dialog\a30\A30_extract_020_Pilot)))
	(sound_impulse_start sound\dialog\a30\A30_extract_030_Cortana none 1)
		(sleep (+ 30 (sound_impulse_time sound\dialog\a30\A30_extract_030_Cortana)))
	(sound_impulse_start sound\dialog\a30\A30_extract_040_Cortana none 1)
		(sleep (+ 60 (sound_impulse_time sound\dialog\a30\A30_extract_040_Cortana)))

	(ai_migrate cliff_marine cliff_marine/waiting_marine)

	(sleep (recording_time foehammer_cliff))
	(sound_impulse_start "sound\dialog\a30\A30_1141_Cortana" none 1)
	(activate_team_nav_point_object "default_red" player foehammer_cliff 1)

	(ai_go_to_vehicle cliff_marine foehammer_cliff "riderLB")
	(ai_go_to_vehicle cliff_marine foehammer_cliff "riderRB")
	(ai_go_to_vehicle cliff_marine foehammer_cliff "riderLM")
	(ai_go_to_vehicle cliff_marine foehammer_cliff "riderRM")

	(unit_set_enterable_by_player foehammer_cliff 1)
	(sleep (sound_impulse_time "sound\dialog\a30\A30_1141_Cortana"))
	(sound_impulse_start sound\dialog\a30\A30_extract_050_Pilot none 1)
	
	(set global_timer (+ (game_time) delay_lost))
	(if (game_is_cooperative) (sleep_until (or (vehicle_test_seat_list foehammer_cliff "P-riderLF" (players))
									   (vehicle_test_seat_list foehammer_cliff "P-riderRF" (players))
									   (< global_timer (game_time))) 1 delay_lost)
						 (sleep_until (or (vehicle_test_seat_list foehammer_cliff "P-riderLF" (players))
									   (vehicle_test_seat_list foehammer_cliff "P-riderRF" (players))
									   (< global_timer (game_time))) 1 delay_lost))
	(deactivate_team_nav_point_object player foehammer_cliff)
	(player_enable_input 0) 
	(fade_out 0 0 0 15)
	(sleep 30)
	(ai_erase_all)
	(vehicle_load_magic foehammer_cliff "P-riderLF" (player0))
	(vehicle_load_magic foehammer_cliff "P-riderRF" (player1))

   (if (mcc_mission_segment "cine3_final1") (sleep 1))              

	(if (cinematic_skip_start) (mission_extraction_cliff_skip))
	(cinematic_skip_stop)
	(game_won)
	)

(script static void mission_extraction_rubble_skip
	(ai off)
	(object_beautify foehammer_rubble on)
	(camera_control on)
	(cinematic_start)
	(camera_set rubble_extraction_1 0)
	(object_teleport (player1) rubble_hide_flag)
	(fade_in 0 0 0 15)
	
	(sound_looping_start sound\sinomatixx\a30_ext_rubble_foley none 1)
	(sleep 8)
	(sound_looping_start sound\sinomatixx\a30_ext_rubble_music none 1)
	(sleep 7)

	(vehicle_hover foehammer_rubble 0)
	(recording_play_and_delete foehammer_rubble foehammer_rubble_out)
	(camera_set rubble_extraction_2 350)
	(sleep 60)
	(sound_impulse_start sound\dialog\a30\A30_extract_060_Cortana none 1)
	(sleep (sound_impulse_time sound\dialog\a30\A30_extract_060_Cortana))
	(print "cortana done")
	(sleep (- (camera_time) 30))
	(fade_out 0 0 0 30)
	(sleep 65)
	)
	
; 	Filthy cinematic "build" script...please don't delete
(script static void rubble_build
	(switch_bsp 1)
	(game_speed 5)
	(object_destroy foehammer_rubble)
	(object_create foehammer_rubble)
	(unit_set_enterable_by_player foehammer_rubble 0)
	(object_teleport foehammer_rubble foehammer_rubble_flag)
	(recording_play_and_hover foehammer_rubble foehammer_rubble_in)
	(sleep (recording_time foehammer_rubble))
	(game_speed 1)
	(print "foehammer done")
	)

(script dormant mission_extraction_rubble
	(object_create foehammer_rubble)
	(unit_set_enterable_by_player foehammer_rubble 0)
	(object_teleport foehammer_rubble foehammer_rubble_flag)
	(recording_play_and_hover foehammer_rubble foehammer_rubble_in)

	(sound_impulse_start sound\dialog\a30\A30_extract_010_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_extract_010_Cortana))
	(sound_impulse_start sound\dialog\a30\A30_extract_020_Pilot none 1)
		(sleep (+ 30 (sound_impulse_time sound\dialog\a30\A30_extract_020_Pilot)))
	(sound_impulse_start sound\dialog\a30\A30_extract_030_Cortana none 1)
		(sleep (+ 30 (sound_impulse_time sound\dialog\a30\A30_extract_030_Cortana)))
	(sound_impulse_start sound\dialog\a30\A30_extract_040_Cortana none 1)
		(sleep (+ 60 (sound_impulse_time sound\dialog\a30\A30_extract_040_Cortana)))

	(ai_migrate rubble_marine rubble_marine/waiting_marine)

	(sleep (recording_time foehammer_rubble))
	(sound_impulse_start "sound\dialog\a30\A30_1141_Cortana" none 1)
	(activate_team_nav_point_object "default_red" player foehammer_rubble 1)

	(ai_go_to_vehicle rubble_marine foehammer_rubble "riderLB")
	(ai_go_to_vehicle rubble_marine foehammer_rubble "riderRB")
	(ai_go_to_vehicle rubble_marine foehammer_rubble "riderLM")
	(ai_go_to_vehicle rubble_marine foehammer_rubble "riderRM")

	(unit_set_enterable_by_player foehammer_rubble 1)
	(sleep (sound_impulse_time "sound\dialog\a30\A30_1141_Cortana"))
	(sound_impulse_start sound\dialog\a30\A30_extract_050_Pilot none 1)

	(set global_timer (+ (game_time) delay_lost))
	(if (game_is_cooperative) (sleep_until (or (vehicle_test_seat_list foehammer_rubble "P-riderLF" (players))
									   (vehicle_test_seat_list foehammer_rubble "P-riderRF" (players))
									   (< global_timer (game_time))) 1 delay_lost)
						 (sleep_until (or (vehicle_test_seat_list foehammer_rubble "P-riderLF" (players))
									   (vehicle_test_seat_list foehammer_rubble "P-riderRF" (players))
									   (< global_timer (game_time))) 1 delay_lost))
	(deactivate_team_nav_point_object player foehammer_rubble)
	(player_enable_input 0) 
	(fade_out 0 0 0 15)
	(sleep 30)
	(ai_erase_all)
	(vehicle_load_magic foehammer_rubble "P-riderLF" (player0))
	(vehicle_load_magic foehammer_rubble "P-riderRF" (player1))

   (if (mcc_mission_segment "cine3_final2") (sleep 1))              
   
	(if (cinematic_skip_start) (mission_extraction_rubble_skip))
	(cinematic_skip_stop)
	(game_won)
	)

(script static void mission_extraction_river_skip
	(ai off)
	(object_beautify foehammer_river on)
	(camera_control on)
	(cinematic_start)
	(camera_set river_extraction_1 0)
	(object_teleport (player1) river_hide_flag)
	(fade_in 0 0 0 15)

	(sound_looping_start sound\sinomatixx\a30_ext_river_foley none 1)
	(sleep 8)
	(sound_looping_start sound\sinomatixx\a30_ext_river_music none 1)
	(sleep 7)

	(vehicle_hover foehammer_river 0)
	(recording_play_and_delete foehammer_river foehammer_river_out)
	(camera_set river_extraction_2 600)
	(sleep 200)
	(sound_impulse_start sound\dialog\a30\A30_extract_060_Cortana none 1)
	(sleep (sound_impulse_time sound\dialog\a30\A30_extract_060_Cortana))
	(print "cortana done")
	(sleep (- (camera_time) 30))
	(fade_out 0 0 0 30)
	(sleep 144)
	)
	
; 	Filthy cinematic "build" script...please don't delete
(script static void river_build
	(switch_bsp 1)
	(game_speed 5)
	(object_destroy foehammer_river)
	(object_create foehammer_river)
	(unit_set_enterable_by_player foehammer_river 0)
	(object_teleport foehammer_river foehammer_river_flag)
	(recording_play_and_hover foehammer_river foehammer_river_in)
	(sleep (recording_time foehammer_river))
	(game_speed 1)
	(print "foehammer done")
	)

(script dormant mission_extraction_river
	(object_create foehammer_river)
	(unit_set_enterable_by_player foehammer_river 0)
	(object_teleport foehammer_river foehammer_river_flag)
	(recording_play_and_hover foehammer_river foehammer_river_in)

	(sound_impulse_start sound\dialog\a30\A30_extract_010_Cortana none 1)
		(sleep (sound_impulse_time sound\dialog\a30\A30_extract_010_Cortana))
	(sound_impulse_start sound\dialog\a30\A30_extract_020_Pilot none 1)
		(sleep (+ 30 (sound_impulse_time sound\dialog\a30\A30_extract_020_Pilot)))
	(sound_impulse_start sound\dialog\a30\A30_extract_030_Cortana none 1)
		(sleep (+ 30 (sound_impulse_time sound\dialog\a30\A30_extract_030_Cortana)))
	(sound_impulse_start sound\dialog\a30\A30_extract_040_Cortana none 1)
		(sleep (+ 60 (sound_impulse_time sound\dialog\a30\A30_extract_040_Cortana)))

	(ai_migrate river_marine river_marine/waiting_marine)

	(sleep (recording_time foehammer_river))
	(sound_impulse_start "sound\dialog\a30\A30_1141_Cortana" none 1)
	(activate_team_nav_point_object "default_red" player foehammer_river 1)

	(ai_go_to_vehicle river_marine foehammer_river "riderLB")
	(ai_go_to_vehicle river_marine foehammer_river "riderRB")
	(ai_go_to_vehicle river_marine foehammer_river "riderLM")
	(ai_go_to_vehicle river_marine foehammer_river "riderRM")

	(unit_set_enterable_by_player foehammer_river 1)
	(sleep (sound_impulse_time "sound\dialog\a30\A30_1141_Cortana"))
	(sound_impulse_start sound\dialog\a30\A30_extract_050_Pilot none 1)
	
	(set global_timer (+ (game_time) delay_lost))
	(if (game_is_cooperative) (sleep_until (or (vehicle_test_seat_list foehammer_river "P-riderLF" (players))
									   (vehicle_test_seat_list foehammer_river "P-riderRF" (players))
									   (< global_timer (game_time))) 1 delay_lost)
						 (sleep_until (or (vehicle_test_seat_list foehammer_river "P-riderLF" (players))
									   (vehicle_test_seat_list foehammer_river "P-riderRF" (players))
									   (< global_timer (game_time))) 1 delay_lost))
	(deactivate_team_nav_point_object player foehammer_river)
	(player_enable_input 0) 
	(fade_out 0 0 0 15)
	(sleep 30)
	(ai_erase_all)
	(vehicle_load_magic foehammer_river "P-riderLF" (player0))
	(vehicle_load_magic foehammer_river "P-riderRF" (player1))

   (if (mcc_mission_segment "cine3_final3") (sleep 1))              
   
	(if (cinematic_skip_start) (mission_extraction_river_skip))
	(cinematic_skip_stop)
	(game_won)
	)

;========== Banshee Scripts ==========
;*
(script static void final_banshee_river
	(set play_music_a30_07 true)
	(object_create final_banshee_1)
	(unit_set_enterable_by_player final_banshee_1 0)
	(ai_place final_banshee/river_pilot_1)
	(vehicle_load_magic final_banshee_1 "driver" (ai_actors final_banshee/river_pilot_1))
	(object_teleport final_banshee_1 river_flag_1)
	(objects_predict final_banshee_1)

	(object_create final_banshee_2)
	(unit_set_enterable_by_player final_banshee_2 0)
	(ai_place final_banshee/river_pilot_2)
	(vehicle_load_magic final_banshee_2 "driver" (ai_actors final_banshee/river_pilot_2))

	(object_teleport final_banshee_2 river_flag_2)
	(ai_magically_see_players final_banshee)

	(sleep_until (=  0 (ai_living_count final_banshee)) 1)
	(set play_music_a30_07 false)
	)

(script static void final_banshee_cliff
	(set play_music_a30_07 true)
	(object_create final_banshee_1)
	(unit_set_enterable_by_player final_banshee_1 0)
	(ai_place final_banshee/cliff_pilot_1)
	(vehicle_load_magic final_banshee_1 "driver" (ai_actors final_banshee/cliff_pilot_1))
	(object_teleport final_banshee_1 cliff_flag_1)
	(objects_predict final_banshee_1)

	(object_create final_banshee_2)
	(unit_set_enterable_by_player final_banshee_2 0)
	(ai_place final_banshee/cliff_pilot_2)
	(vehicle_load_magic final_banshee_2 "driver" (ai_actors final_banshee/cliff_pilot_2))
	(object_teleport final_banshee_2 cliff_flag_2)
	(ai_magically_see_players final_banshee)

	(sleep_until (=  0 (ai_living_count final_banshee)) 1)
	(set play_music_a30_07 false)
	)

(script static void final_banshee_rubble
	(set play_music_a30_07 true)
	(object_create final_banshee_1)
	(unit_set_enterable_by_player final_banshee_1 0)
	(ai_place final_banshee/rubble_pilot_1)
	(vehicle_load_magic final_banshee_1 "driver" (ai_actors final_banshee/rubble_pilot_1))
	(object_teleport final_banshee_1 rubble_flag_1)
	(objects_predict final_banshee_1)

	(object_create final_banshee_2)
	(unit_set_enterable_by_player final_banshee_2 0)
	(ai_place final_banshee/rubble_pilot_2)
	(vehicle_load_magic final_banshee_2 "driver" (ai_actors final_banshee/rubble_pilot_2))
	(object_teleport final_banshee_2 rubble_flag_2)
	(ai_magically_see_players final_banshee)

	(sleep_until (=  0 (ai_living_count final_banshee)) 1)
	(set play_music_a30_07 false)
	)
*;

;========== Landing Zone Scripts ==========

(script dormant mission_lz_banshee
	(object_create pass_banshee_1)
	(unit_set_enterable_by_player pass_banshee_1 0)
	(ai_place lz_banshee/pilot_1)
	(vehicle_load_magic pass_banshee_1 "driver" (ai_actors lz_banshee/pilot_1))
	(object_teleport pass_banshee_1 lz_banshee_simple_flag_1)
	(ai_command_list lz_banshee/pilot_1 lz_banshee_1)

	(object_create pass_banshee_2)
	(unit_set_enterable_by_player pass_banshee_2 0)
	(ai_place lz_banshee/pilot_2)
	(vehicle_load_magic pass_banshee_2 "driver" (ai_actors lz_banshee/pilot_2))
	(object_teleport pass_banshee_2 lz_banshee_simple_flag_2)
	(objects_predict pass_banshee_1)

	(ai_command_list lz_banshee/pilot_2 lz_banshee_2)
	(sleep 90)
	(ai_magically_see_players lz_banshee)
	
	(sleep_until (or (< (ai_strength lz_banshee) .6)
				  (volume_test_objects pass_mouth (players))) 1 delay_fail)
	(sleep 90)
	(ai_command_list lz_banshee/pilot_1 lz_banshee_3)
	(ai_command_list lz_banshee/pilot_2 lz_banshee_3)

	(set mark_lz_banshee true)
	)

(script dormant mission_lz_dropship
	(object_create lz_cship)
	(unit_close lz_cship)
	(ai_place lz_search/cship_toon)
	(ai_braindead lz_search 1)
	(vehicle_load_magic lz_cship "passenger" (ai_actors lz_search/cship_toon))
	(object_teleport lz_cship lz_cship_flag)
	(recording_play_and_hover lz_cship lz_cship_enter)
	(objects_predict lz_cship)

	(sleep (max 0 (- (recording_time lz_cship) 750)))
	(ai_conversation lz_cship_enter)
	(sleep_until (< 4 (ai_conversation_status lz_cship_enter)) 1)

	(sleep (recording_time lz_cship))
	(cond ((volume_test_objects lz_bridge (players)) (ai_conversation lz_cship_danger))
		 ((volume_test_objects lz_landing (players)) (ai_conversation lz_cship_danger))
		 (true (ai_conversation lz_cship_safe))
		 )
	(set play_music_a30_01_alt true)

	(vehicle_hover lz_cship 0)
	(recording_play_and_hover lz_cship lz_cship_landing_drop)

	(sleep (max 0 (- (recording_time lz_cship) 60)))
	(unit_open lz_cship)

	(sleep 60)
	(begin_random
		(begin (vehicle_unload lz_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload lz_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload lz_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload lz_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload lz_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload lz_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload lz_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload lz_cship "cd-passengerr04") (sleep 5))
		)
	(ai_braindead lz_search 0)

	(sleep 120)
	(vehicle_hover lz_cship 0)
	(recording_play_and_delete lz_cship lz_cship_landing_exit)
	(sleep 30)
	(unit_close lz_cship)
	(object_set_collideable lz_cship 0)
	(set play_music_a30_01 false)

	(sleep_until (= (ai_living_count lz_search) 0) 1)
	(set mark_lz_dropship true)
	)

(script dormant mission_lz
	(sleep_until (or (volume_test_objects plant_trigger (players))
				  (volume_test_objects lz_bridge (players))) 1 delay_dawdle)
	(sleep_until (or (< 4 (ai_conversation_status intro_1))
				  (volume_test_objects lz_bridge (players))) 1)
	(ai_conversation lz_prompt_1)

	(sleep_until (or (< 4 (ai_conversation_status lz_prompt_1))
				  (volume_test_objects lz_bridge (players))) 1)
	(set mark_evade true)
	(set play_music_a30_01 true)

	(sleep_until (or (volume_test_objects plant_trigger (players))
				  (volume_test_objects lz_bridge (players))) 1)
	(if (volume_test_objects plant_trigger (players)) (ai_conversation flavor_plant))
	(if (volume_test_objects plant_trigger (players)) (sleep_until (or (< 4 (ai_conversation_status flavor_plant))
				  (volume_test_objects lz_bridge (players))) 1))

	(wake mission_lz_dropship)

	(sleep_until (or mark_lz_dropship
				  (volume_test_objects lz_ledge_safe (players))) 1)
	(wake mission_lz_banshee)

	(sleep_until (or mark_lz_banshee
				  (volume_test_objects lz_ledge (players))) 1)
	(ai_migrate lz_search/cship_toon lz_search/search_low)

	(sleep_until (volume_test_objects lz_pass (players)) 1)
	(ai_place lz_search/pass_grunt)
	(ai_place lz_search/pass_elite)
	(objects_predict (ai_actors lz_search))
	)

;========== First Scripts ==========

(script dormant obj_first_abandon
	(set mark_protect true)
	(sleep_until (or global_first_end
				  (and (< 0 (player_count))
					  (not (or (volume_test_objects first_structure_1 (players))
							 (volume_test_objects first_structure_2 (players)))))) 15)
	(if (not global_first_end) (ai_conversation first_abandon))
	)

(script dormant obj_first_all_killed
	(sleep_until (or global_first_end
				  (< 0 (ai_living_count first_marine))) 15)

	(sleep_until (or global_first_end
				  (= 0 (ai_living_count first_marine))))
	(sleep 60)
	(if (not global_first_end) (begin (sleep_until (game_safe_to_speak) 1 delay_dawdle) (ai_conversation first_all_killed)))
	)

(script dormant mission_first_defend
	(sleep_until global_first_wave_1 5)
	(sleep_until (volume_test_objects_all first_defend (players)) 15)
	(ai_retreat first_wave/wave_1_attack_toon)
	(set global_first_wave_1_defend true)
	
	(sleep_until global_first_wave_2 5)
	(sleep_until (volume_test_objects_all first_defend (players)) 15)
	(ai_retreat first_wave/wave_2_attack_toon)
	(set global_first_wave_2_defend true)

	(sleep_until global_first_wave_3 5)
	(sleep_until (volume_test_objects_all first_defend (players)) 15)
	(ai_retreat first_wave/wave_3_attack_toon)
	(set global_first_wave_3_defend true)

	(sleep_until global_first_wave_4 5)
	(sleep_until (volume_test_objects_all first_defend (players)) 15)
	(ai_retreat first_wave/wave_4_attack_toon)
	(set global_first_wave_4_defend true)

	(sleep_until global_first_wave_5 5)
	(sleep_until (volume_test_objects_all first_defend (players)) 15)
	(ai_retreat first_wave/wave_5_attack_toon)
	(set global_first_wave_5_defend true)
	
	(sleep_until global_first_wave_6 5)
	(sleep_until (volume_test_objects_all first_defend (players)) 15)
	(ai_retreat first_wave/wave_6_attack_toon)
	(set global_first_wave_6_defend true)
	)

(script dormant mission_first_retreat
	(sleep_until global_first_wave_1_defend 5)
	(sleep_until (volume_test_objects_all first_retreat (players)) 15)
	(ai_retreat first_wave/wave_1_defend_toon)
	
	(sleep_until global_first_wave_2_defend 5)
	(sleep_until (volume_test_objects_all first_retreat (players)) 15)
	(ai_retreat first_wave/wave_2_defend_toon)

	(sleep_until global_first_wave_3_defend 5)
	(sleep_until (volume_test_objects_all first_retreat (players)) 15)
	(ai_retreat first_wave/wave_3_defend_toon)

	(sleep_until global_first_wave_4_defend 5)
	(sleep_until (volume_test_objects_all first_retreat (players)) 15)
	(ai_retreat first_wave/wave_4_defend_toon)

	(sleep_until global_first_wave_5_defend 5)
	(sleep_until (volume_test_objects_all first_retreat (players)) 15)
	(ai_retreat first_wave/wave_5_defend_toon)

	(sleep_until global_first_wave_6_defend 5)
	(sleep_until (volume_test_objects_all first_retreat (players)) 15)
	(ai_retreat first_wave/wave_6_defend_toon)
	)

(script dormant mission_first_marine
	(sleep_until (or global_first_wave_5
				  (and (!= (game_difficulty_get) normal) global_first_wave_2)
				  (and (> .7 (ai_living_fraction first_marine/right_toon))
					  (> .7 (ai_living_fraction first_marine/left_toon)))
				  (or (> .3 (ai_living_fraction first_marine/right_toon))
				  	 (> .3 (ai_living_fraction first_marine/left_toon)))) 15)
	(ai_defend first_marine)
	
	(sleep 90)
	(wake mission_first_defend)

	(sleep 90)
	(sleep_until (or (and (!= (game_difficulty_get) normal) global_first_wave_3)
				  global_first_wave_6
				  (and (> .3 (ai_living_fraction first_marine/right_toon))
					  (> .3 (ai_living_fraction first_marine/left_toon)))) 15)

	(sleep 90)
	(ai_retreat first_marine)
	(if global_first_end (sleep -1))
	(ai_conversation first_retreat)
	
	(sleep 45)
	(wake mission_first_retreat)

	(sleep_until (= 0 (ai_living_fraction first_marine)) 15)
	(if global_first_end (sleep -1))
	(ai_maneuver_enable first_wave 0)
	(ai_follow_target_players first_wave)
	)

(script dormant mission_first_wave_1
	(object_create pass_cship)
	(ai_place first_wave/wave_1_lz_toon)
	(objects_predict (ai_actors first_wave))
	(ai_braindead first_wave/wave_1_lz_toon 1)
	(vehicle_load_magic pass_cship "passenger" (ai_actors first_wave/wave_1_lz_toon))
	(object_teleport pass_cship pass_cship_flag)
	(vehicle_hover pass_cship 1)

	(sleep_until (volume_test_objects first_trigger_1 (players)) 5)
	(sleep 90)
	(ai_braindead first_wave/wave_1_lz_toon 0)
	(ai_playfight first_wave 1)
	(ai_playfight first_marine 1)
	(begin_random
		(begin (vehicle_unload pass_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload pass_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload pass_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload pass_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload pass_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload pass_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload pass_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload pass_cship "cd-passengerr04") (sleep 5))
		)
	(set global_first_wave_1 true)

	(sleep 60)
	(vehicle_hover pass_cship 0)
	(recording_play_and_delete pass_cship back_cship_exit)
	(sleep 30)
	(unit_close pass_cship)
	(object_set_collideable pass_cship 0)

	(if (not (volume_test_objects first_back_lz (players))) (ai_retreat first_wave/wave_1_lz_grunt))
	(sleep 90)
	(if (not (volume_test_objects first_back_lz (players))) (ai_retreat first_wave/wave_1_lz_toon))
	(sleep_until (not (volume_test_objects first_arrival (players))) 15)
	(ai_playfight first_wave 0)
	(ai_playfight first_marine 0)
	(ai_migrate first_wave/wave_1_lz_grunt first_wave/wave_1_attack)
	(sleep 240)
	(ai_migrate first_wave/wave_1_lz_elite first_wave/wave_1_attack)
 	)

(script dormant mission_first_wave_2
	(object_create fort_cship)
	(unit_close fort_cship)
	(ai_place first_wave/wave_2_lz_toon)
	(ai_disregard (ai_actors first_wave/wave_2_lz_toon) 1)
	(ai_braindead first_wave/wave_2_lz_toon 1)
	(vehicle_load_magic fort_cship "passenger" (ai_actors first_wave/wave_2_lz_toon))
	(object_teleport fort_cship fort_cship_flag)
	(recording_play_and_hover fort_cship fort_cship_enter)
	(objects_predict fort_cship)

;	(sleep_until (< 4 (ai_conversation_status first_welcome)) 1)
	(sleep 30)
	(sleep (recording_time fort_cship))

	(if (> (ai_living_count first_marine) 1) (sound_impulse_start "sound\dialog\a30\A30_210_Bisenti" none 1))
		(sleep (sound_impulse_time "sound\dialog\a30\A30_210_Bisenti"))
	(ai_disregard (ai_actors first_wave/wave_2_lz_toon) 0)
	(ai_magically_see_encounter first_marine first_wave)
	(ai_migrate first_marine/base_toon first_marine/base_fort)
	(ai_migrate first_marine/left_toon first_marine/left_fort)
	(ai_migrate first_marine/right_toon first_marine/right_fort)

	(sleep_until (not (volume_test_objects first_fort_lz (players))) 15 delay_dawdle)
	(vehicle_hover fort_cship 0)
	(recording_play_and_hover fort_cship fort_cship_drop)

	(sleep (max 0 (- (recording_time fort_cship) 60)))
	(unit_open fort_cship)
	(ai_braindead first_wave/wave_2_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload fort_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerr04") (sleep 5))
		)
	(set global_first_wave_2 true)

	(sleep 120)
	(sleep_until (not (volume_test_objects first_structure_back (players))) 15 delay_dawdle)
	(vehicle_hover fort_cship 0)
	(recording_play_and_delete fort_cship fort_cship_exit)
	(sleep 30)
	(unit_close fort_cship)
	(object_set_collideable fort_cship 0)

	(sleep_until (not (volume_test_objects first_fort_lz (players))) 15)
	(ai_migrate first_wave/wave_2_grunt first_wave/wave_2_attack_left)
	(ai_migrate first_wave/wave_2_jackal first_wave/wave_2_attack_right)
	(ai_magically_see_players first_wave)
	(ai_magically_see_encounter first_wave first_marine)
	(sleep 240)
	(ai_migrate first_wave/wave_2_lz_toon first_wave/wave_2_attack_left)
	)

(script dormant mission_first_wave_3
	(object_create pipe_cship)
	(unit_close pipe_cship)
	(ai_place first_wave/wave_3_lz_toon)
	(ai_disregard (ai_actors first_wave/wave_3_lz_toon) 1)
	(ai_braindead first_wave/wave_3_lz_toon 1)
	(vehicle_load_magic pipe_cship "passenger" (ai_actors first_wave/wave_3_lz_toon))
	(object_teleport pipe_cship pipe_cship_flag)
	(recording_play_and_hover pipe_cship pipe_cship_enter)
	(objects_predict pipe_cship)

	(sleep (recording_time pipe_cship))
	(if (> (ai_living_count first_marine) 1) (sound_impulse_start "sound\dialog\a30\A30_210_Fitzgerald" none 1))
		(sleep (sound_impulse_time "sound\dialog\a30\A30_210_Fitzgerald"))

	(ai_disregard (ai_actors first_wave/wave_3_lz_toon) 0)
	(ai_magically_see_encounter first_marine first_wave)
	(ai_migrate first_marine/base_toon first_marine/base_pipe)
	(ai_migrate first_marine/left_toon first_marine/left_pipe)
	(ai_migrate first_marine/right_toon first_marine/right_pipe)

	(sleep_until (not (volume_test_objects first_pipe_lz (players))) 15 delay_dawdle)
	(vehicle_hover pipe_cship 0)
	(recording_play_and_hover pipe_cship pipe_cship_drop)

	(sleep (max 0 (- (recording_time pipe_cship) 60)))
	(unit_open pipe_cship)
	(ai_braindead first_wave/wave_3_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload pipe_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerr04") (sleep 5))
		)
	(set global_first_wave_3 true)

	(sleep 120)
	(sleep_until (not (volume_test_objects first_structure_back (players))) 15 delay_dawdle)
	(vehicle_hover pipe_cship 0)
	(recording_play_and_delete pipe_cship pipe_cship_exit)

	(sleep_until (not (volume_test_objects first_pipe_lz (players))) 15)
	(sleep 30)
	(unit_close pipe_cship)
	(object_set_collideable pipe_cship 0)

	(ai_migrate first_wave/wave_3_grunt first_wave/wave_3_attack_left)
	(ai_magically_see_players first_wave)
	(ai_magically_see_encounter first_wave first_marine)
	(sleep 240)
	(ai_migrate first_wave/wave_3_lz_toon first_wave/wave_3_attack_right)
	)

(script dormant mission_first_wave_4
	(object_create back_cship)
	(unit_close back_cship)
	(ai_place first_wave/wave_4_lz_toon)
	(ai_disregard (ai_actors first_wave/wave_4_lz_toon) 1)
	(ai_braindead first_wave/wave_4_lz_toon 1)
	(vehicle_load_magic back_cship "passenger" (ai_actors first_wave/wave_4_lz_toon))
	(object_teleport back_cship back_cship_flag)
	(recording_play_and_hover back_cship back_cship_enter)
	(objects_predict back_cship)

	(sleep (recording_time back_cship))
	(if (> (ai_living_count first_marine) 1) (sound_impulse_start "sound\dialog\a30\A30_220_Bisenti" none 1))
		(sleep (sound_impulse_time "sound\dialog\a30\A30_220_Bisenti"))
	(ai_disregard (ai_actors first_wave/wave_4_lz_toon) 0)
	(ai_magically_see_encounter first_marine first_wave)
	(ai_migrate first_marine/base_toon first_marine/base_back)
	(ai_migrate first_marine/left_toon first_marine/left_back)
	(ai_migrate first_marine/right_toon first_marine/right_back)

	(sleep_until (not (volume_test_objects first_back_lz (players))) 15 delay_dawdle)
	(vehicle_hover back_cship 0)
	(recording_play_and_hover back_cship back_cship_drop)

	(sleep (max 0 (- (recording_time back_cship) 60)))
	(unit_open back_cship)

	(ai_braindead first_wave/wave_4_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload back_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload back_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload back_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload back_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload back_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload back_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload back_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload back_cship "cd-passengerr04") (sleep 5))
		)
	(set global_first_wave_4 true)

	(sleep 120)
	(sleep_until (not (volume_test_objects first_structure_front (players))) 15 delay_dawdle)
	(vehicle_hover back_cship 0)
	(recording_play_and_delete back_cship back_cship_exit)
	(sleep 30)
	(unit_close back_cship)
	(object_set_collideable back_cship 0)

	(sleep_until (not (volume_test_objects first_back_lz (players))) 15)
	(ai_migrate first_wave/wave_4_grunt first_wave/wave_4_attack)
	(ai_magically_see_players first_wave)
	(ai_magically_see_encounter first_wave first_marine)
	(sleep 240)
	(ai_migrate first_wave/wave_4_lz_toon first_wave/wave_4_attack)
	)

(script dormant mission_first_wave_5
	(object_create pipe_cship)
	(unit_close pipe_cship)
	(ai_place first_wave/wave_5_lz_toon)
	(ai_disregard (ai_actors first_wave/wave_5_lz_toon) 1)
	(ai_braindead first_wave/wave_5_lz_toon 1)
	(vehicle_load_magic pipe_cship "passenger" (ai_actors first_wave/wave_5_lz_toon))
	(object_teleport pipe_cship pipe_cship_flag)
	(recording_play_and_hover pipe_cship pipe_cship_enter)
	(objects_predict pipe_cship)

	(sleep (recording_time pipe_cship))
	(ai_disregard (ai_actors first_wave/wave_5_lz_toon) 0)
	(ai_magically_see_encounter first_marine first_wave)

	(sleep_until (not (volume_test_objects first_pipe_lz (players))) 15 delay_dawdle)
	(vehicle_hover pipe_cship 0)
	(recording_play_and_hover pipe_cship pipe_cship_drop)

	(sleep (max 0 (- (recording_time pipe_cship) 60)))
	(unit_open pipe_cship)
	(ai_braindead first_wave/wave_5_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload pipe_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload pipe_cship "cd-passengerr04") (sleep 5))
		)
	(set global_first_wave_5 true)

	(sleep 120)
	(sleep_until (not (volume_test_objects first_structure_back (players))) 15 delay_dawdle)
	(vehicle_hover pipe_cship 0)
	(recording_play_and_delete pipe_cship pipe_cship_exit)
	(sleep 30)
	(unit_close pipe_cship)
	(object_set_collideable pipe_cship 0)

	(sleep_until (not (volume_test_objects first_pipe_lz (players))) 15)
	(ai_migrate first_wave/wave_5_grunt first_wave/wave_5_attack_right)
	(ai_migrate first_wave/wave_5_elite first_wave/wave_5_attack_left)
	(ai_magically_see_players first_wave)
	(ai_magically_see_encounter first_wave first_marine)
	(sleep 240)
	(ai_migrate first_wave/wave_5_lz_toon first_wave/wave_5_attack_right)
	)

(script dormant mission_first_wave_6
	(object_create fort_cship)
	(unit_close fort_cship)
	(ai_place first_wave/wave_6_lz_toon)
	(ai_disregard (ai_actors first_wave/wave_6_lz_toon) 1)
	(ai_braindead first_wave/wave_6_lz_toon 1)
	(vehicle_load_magic fort_cship "passenger" (ai_actors first_wave/wave_6_lz_toon))
	(object_teleport fort_cship fort_cship_flag)
	(recording_play_and_hover fort_cship fort_cship_enter)
	(objects_predict fort_cship)

	(sleep (recording_time fort_cship))
;	(if (> (ai_living_count first_marine) 1) (sound_impulse_start "sound\dialog\a30\A30_220_Fitzgerald" none 1))
;		(sleep (sound_impulse_time "sound\dialog\a30\A30_220_Fitzgerald"))
	(ai_disregard (ai_actors first_wave/wave_6_lz_toon) 0)
	(ai_magically_see_encounter first_marine first_wave)

	(sleep_until (not (volume_test_objects first_fort_lz (players))) 15 delay_dawdle)
	(vehicle_hover fort_cship 0)
	(recording_play_and_hover fort_cship fort_cship_drop)

	(sleep (max 0 (- (recording_time fort_cship) 60)))
	(unit_open fort_cship)

	(ai_braindead first_wave/wave_6_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload fort_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload fort_cship "cd-passengerr04") (sleep 5))
		)
	(set global_first_wave_6 true)

	(sleep 120)
	(sleep_until (not (volume_test_objects first_structure_back (players))) 15 delay_dawdle)
	(vehicle_hover fort_cship 0)
	(recording_play_and_delete fort_cship fort_cship_exit)
	(sleep 30)
	(unit_close fort_cship)
	(object_set_collideable fort_cship 0)

	(sleep_until (not (volume_test_objects first_fort_lz (players))) 15)
	(ai_migrate first_wave/wave_6_grunt first_wave/wave_6_attack_left)
	(ai_migrate first_wave/wave_6_jackal first_wave/wave_6_attack_right)
	(ai_magically_see_players first_wave)
	(ai_magically_see_encounter first_wave first_marine)
	(sleep 240)
	(ai_migrate first_wave/wave_6_lz_toon first_wave/wave_6_attack_left)
	)

(script continuous cont_first_kill
	(sleep_until test_first_kill 10)
	(sleep_until (not (objects_can_see_object (players) (list_get (ai_actors first_wave) 0) 40)) 10)
	(sleep 75)
	(if (not (objects_can_see_object (players) (list_get (ai_actors first_wave) 0) 40)) (object_destroy (list_get (ai_actors first_wave) 0)))
	)

(script dormant objective_cave
	(activate_team_nav_point_object "default_red" player jeep .5)
	
	(sleep_until (or (volume_test_objects cave_entrance (players))
				  (vehicle_test_seat_list jeep W-driver (players))) 5 delay_lost)
	(if (not (vehicle_test_seat_list jeep W-driver (players))) (ai_conversation cave_no_jeep))

	(sleep_until (vehicle_test_seat_list jeep W-driver (players)))
	(deactivate_team_nav_point_object player jeep)
	(sleep 45)
	(sleep_until (not (volume_test_objects_all first_drop (players))) 1 delay_late)
	(if (and (not (game_is_cooperative))
		    (= normal (game_difficulty_get)))
	    (if (player0_joystick_set_is_normal) (display_scenario_help 3) (display_scenario_help 4)))

	(sleep_until (or (not (volume_test_objects_all first_drop (players)))
				  (volume_test_objects cave_entrance (players))) 1 delay_late)
	(set play_music_a30_04 true)

	(sleep_until (volume_test_objects cave_entrance (players)) 1 delay_lost)
	(if (not (volume_test_objects cave_entrance (players))) (activate_team_nav_point_flag "default_red" player cave_nav_flag 0))
	(if (not (volume_test_objects cave_entrance (players))) (ai_conversation cave_prompt))

	(sleep_until (volume_test_objects cave_entrance (players)) 1)
	(ai_conversation cave_entrance)
	(deactivate_team_nav_point_flag player cave_nav_flag)

	(sleep_until (volume_test_objects cave_driving (players)) 5)
	(ai_conversation first_driving)

	(sleep_until (volume_test_objects cave_pretzel (players)) 5)
	(set play_music_a30_04 false)
	)

(script dormant mission_first
	(sleep_until (volume_test_objects first_arrival (players)) 5)
	(if (game_safe_to_speak) (ai_conversation first_arrival))
	(wake save_first_arrival)
	(ai_place first_marine)
	(objects_predict (ai_actors first_marine))
	(wake mission_first_wave_1)

	(sleep_until global_first_wave_1 5)
	(wake obj_first_all_killed)

	(sleep_until (> 3 (ai_living_count first_wave)) 15)
	(sleep_until (= 0 (ai_living_count first_wave)) 15 delay_fail)
	(if (< 0 (ai_living_count first_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))

	(ai_kill first_wave)
	(wake save_first_wave_1)
	(set play_music_a30_02 true)
	(ai_migrate first_marine/base_toon first_marine/base_search)
	(ai_migrate first_marine/left_toon first_marine/left_welcome)
	(ai_migrate first_marine/right_toon first_marine/right_search)

	(ai_conversation first_welcome)

	(sleep_until (< 2 (ai_conversation_status first_welcome)) 1)
	(wake mission_first_wave_2)

	(sleep_until (< 4 (ai_conversation_status first_welcome)) 1)
	(wake mission_first_marine)
	(wake obj_first_abandon)
	(wake save_first_welcome)
	(ai_migrate first_marine/left_toon first_marine/left_search)

	(sleep_until global_first_wave_2 5)
	(set play_music_a30_02 false)

	(sleep_until (> 3 (ai_living_count first_wave)) 15)
	(wake mission_first_wave_3)

	(if (< 2 (ai_living_count first_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
	(wake save_first_wave_2)

	(ai_migrate first_marine/base_toon first_marine/base_search)
	(ai_migrate first_marine/left_toon first_marine/left_search)
	(ai_migrate first_marine/right_toon first_marine/right_search)

	(sleep_until global_first_wave_3 5)
	(sleep_until (> 3 (ai_living_count first_wave)) 15)
	(wake mission_first_wave_4)

	(if (< 2 (ai_living_count first_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
	(wake save_first_wave_3)

	(ai_migrate first_marine/base_toon first_marine/base_search)
	(ai_migrate first_marine/left_toon first_marine/left_search)
	(ai_migrate first_marine/right_toon first_marine/right_search)

	(sleep_until global_first_wave_4 5)
	(sleep_until (> 3 (ai_living_count first_wave)) 15)
	(wake save_first_wave_4)
	(wake mission_first_wave_5)

	(sleep_until global_first_wave_5 5)
	(set play_music_a30_03 true)
	(wake mission_first_wave_6)
	
	(sleep_until global_first_wave_6 5)

	(sleep_until (> 6 (ai_living_count first_wave)) 15 delay_lost)
	(ai_maneuver_enable first_wave 0)
	(ai_follow_target_players first_wave)
	(ai_magically_see_players first_wave)
	(set play_music_a30_03_alt true)

	(sleep_until (= 0 (ai_living_count first_wave)) 15 delay_fail)
	(if (< 0 (ai_living_count first_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
;ADD Combat state check
	(sleep delay_calm)
	(set play_music_a30_03_alt false)
	(set play_music_a30_03 false)
	(set global_first_end true)
	(set test_first_kill true)
	(wake save_first_wave_6)
	(ai_migrate first_marine first_marine/waiting_marine_1)

	(object_create foehammer_first)
	(unit_set_enterable_by_player foehammer_first 0)
	(object_create jeep)
	(if (not (game_is_cooperative)) (object_create gunner))
	(if (not (game_is_cooperative)) (unit_enter_vehicle gunner jeep "W-gunner"))
	(ai_attach gunner first_marine/left_back)
	(unit_enter_vehicle jeep foehammer_first "cargo")
	(object_teleport foehammer_first foehammer_first_flag)
	(recording_play_and_hover foehammer_first foehammer_first_in)
	(objects_predict foehammer_first)

	(ai_conversation first_evac_1)

	(sleep_until (or (= 0 (recording_time foehammer_first))
				  (< 4 (ai_conversation_status first_evac_1))) 1)
	(object_create lifeboat_1)
	(object_teleport lifeboat_1 lifeboat_1_flag)
	(recording_play_and_delete lifeboat_1 lifeboat_1_in)
	(object_create lifeboat_3)
	(object_teleport lifeboat_3 lifeboat_3_flag)
	(recording_play_and_delete lifeboat_3 lifeboat_3_in)
	(object_create lifeboat_2)
	(object_teleport lifeboat_2 lifeboat_2_flag)
	(recording_play_and_delete lifeboat_2 lifeboat_2_in)
	
	(ai_conversation_stop first_evac_1)
	(ai_conversation first_evac_2)

	(sleep 210)
	(ai_migrate first_marine first_marine/waiting_marine_2)
	(sleep (recording_time foehammer_first))

	(wake objective_cave)

	(sleep_until (< 4 (ai_conversation_status first_evac_2)) 1)
 	(sleep_until (not (volume_test_objects first_drop (players))) 1)
 	(unit_exit_vehicle jeep)

	(sleep 15)
	(ai_conversation first_evac_3)
	(set mark_search true)
	(vehicle_hover foehammer_first 0)
	(recording_play_and_hover foehammer_first foehammer_first_drop)
	(sleep_until (< 4 (ai_conversation_status first_evac_3)) 1)
 	(ai_conversation first_evac_4)

	(sleep (recording_time foehammer_first))
	(set global_first_foehammer_waiting true)

	(set global_first_marine_rescued true)
	(wake save_first_waiting)
	(if (not (game_is_cooperative)) (ai_go_to_vehicle first_marine jeep "gunner"))
	(if (not (game_is_cooperative)) (ai_go_to_vehicle first_marine jeep "passenger"))
	(ai_go_to_vehicle first_marine foehammer_first "rider")

	(sleep_until (= 0 (ai_going_to_vehicle foehammer_first)) 45)
	(vehicle_hover foehammer_first 0)
	(recording_play_and_delete foehammer_first foehammer_first_exit)
	)

;========== Cave Scripts ==========

(script dormant obj_cave_prompt
	(sleep_until (> 4 (- (ai_living_count cave_floor) (ai_living_count cave_floor/plank_toon))) 15)
	(sleep_until (= 0 (- (ai_living_count cave_floor) (ai_living_count cave_floor/plank_toon))) 15 delay_lost)
	(sleep_until (volume_test_objects bridge_edge (players)) 5 delay_lost)

	(sleep_until (game_safe_to_speak) 15)
 	(if (and (= (structure_bsp_index) 0) (= 0 (device_group_get bridge_control_position))) (ai_conversation cave_bridge_prompt))
	)

(script static void cutscene_bridge
	(ai off)
	(player_enable_input 0)

   (if (mcc_mission_segment "cine2_activating_lightbridge") (sleep 1))              
   
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_teleport (player0) player0_bridge_base)
	(object_teleport (player1) player1_bridge_base)
	
	(object_destroy chief)
	(object_destroy rifle)
	
	(object_create chief)
	(object_create rifle)
	
	(object_teleport chief chief_push_base)
	(objects_attach chief "right hand" rifle "")
	
	(object_beautify chief true)
	
	(custom_animation chief cinematics\animations\chief\level_specific\b30\b30 "b30holomapshort" false)
	
	(camera_control on)
	(cinematic_start)

	(camera_set bridge_glory_2a 0)
	(camera_set bridge_glory_2b 120)

	(fade_in 1 1 1 15)
	
	(sleep 120)
	
	(sound_looping_start sound\sinomatixx\a30_bridge_music none 1)
	
	(camera_set bridge_glory_1a 0)

	(device_set_position bridge 1)
	
	(camera_set bridge_glory_1b 300)
	(sleep 150)
	(camera_set bridge_glory_1c 300)
	(sleep 150)
	(camera_set bridge_glory_1d 180)
	(sleep 90)
	(camera_set bridge_glory_1e 200)
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_destroy chief)
	(object_destroy rifle)
	
	(object_teleport (player0) player0_bridge_done)
	(object_teleport (player1) player1_bridge_done)
	
	(camera_control off)
	(cinematic_stop)
	(fade_in 1 1 1 15)
	(wake save_cave_bridge)
	(player_enable_input 1)
	(ai on)
	)

(script dormant mission_cave
	(sleep_until (volume_test_objects cave_floor_entrance (players)) 15)
	(if (and (game_is_cooperative) (not (or (vehicle_test_seat_list jeep W-gunner (players)) (vehicle_test_seat_list jeep W-passenger (players))))) (volume_teleport_players_not_inside cave_floor_entrance cave_flag))
	(wake save_cave_floor_enter)
	(ai_place cave_floor)
	(objects_predict (ai_actors cave_floor))
	(wake obj_cave_prompt)
	(set play_music_a30_05 true)	

	(sleep_until (or (volume_test_objects cave_gap (players))
				  (< 0 (device_group_get bridge_control_position))) 1)
	(ai_timer_expire cave_floor/plank_elite)
	(set play_music_a30_05_alt true)	

	(sleep_until (< 0 (device_group_get bridge_control_position)) 1 delay_late)
	(set play_music_a30_05_alt false)

	(sleep_until (< 0 (device_group_get bridge_control_position)) 1)
	(set play_music_a30_05 false)
	(if (game_all_quiet) (cutscene_bridge))

	(sleep_until (volume_test_objects cave_floor_exit (players)) 15)
	(wake save_cave_floor_exit)
	(ai_conversation second_driving)

	(sleep_until (= (structure_bsp_index) 1))
	(device_set_position_immediate bridge 0)
	)

;========== Cliff Scripts ==========
(script dormant obj_cliff_abandon
	(deactivate_team_nav_point_flag player cliff_nav_flag)
	(deactivate_team_nav_point_flag player rubble_nav_flag)
	(deactivate_team_nav_point_flag player river_nav_flag)
	(ai_conversation cliff_prompt)
	(sleep_until (not (volume_test_objects_all cliff_all (players))) 15)
	(cond (global_two_marine_rescued (ai_conversation cliff_abandon_final))
		 (global_cliff_dead (sleep -1))
		 (global_cliff_all_killed (ai_conversation cliff_abandon_killed))
		 (global_cliff_welcome (ai_conversation cliff_abandon_welcome))
		 (true (ai_conversation cliff_abandon)))
;coop If it starts to be a problem that two players can run all over, fix it here
	)

(script dormant obj_cliff_all_killed
	(sleep_until (or global_cliff_end
				  (= 0 (ai_living_count cliff_marine))) 15)
	(sleep 60)
	(if (not global_cliff_end) (set global_cliff_all_killed true))
	(if (and (volume_test_objects cliff_all (players)) (not global_cliff_end)) (ai_conversation cliff_all_killed))
	(if (not (and global_river_end global_rubble_end)) (set global_cliff_end true))
	)
	

(script dormant obj_cliff_arrival
	(sleep_until (volume_test_objects cliff_arrival (players)) 15)
	(if (not global_cliff_welcome) (ai_conversation cliff_arrival))
	(wake save_cliff_arrival)
	)

(script continuous cont_cliff_kill
	(sleep_until test_cliff_kill 10)
	(sleep_until (not (objects_can_see_object (players) (list_get (ai_actors cliff_wave) 0) 40)) 10)
	(sleep 75)
	(if (not (objects_can_see_object (players) (list_get (ai_actors cliff_wave) 0) 40)) (object_destroy (list_get (ai_actors cliff_wave) 0)))
	)

(script dormant mission_cliff_marine
	(sleep_until (or (< (ai_living_fraction cliff_wave) .5)
				  (volume_test_objects cliff_right_fort_first_floor (players))
				  (volume_test_objects cliff_left_fort_first_floor (players))) 5)
	(if (not (volume_test_objects cliff_inside_left_bottom (players))) (sound_impulse_start "sound\dialog\a30\a30_540_cortana" none 1))
	(sleep (sound_impulse_time "sound\dialog\a30\a30_540_cortana" ))

	(ai_timer_expire cliff_wave/left_fort_inside_grunt)
	(ai_timer_expire cliff_wave/right_fort_inside_grunt)

	(sleep_until (or (< (ai_living_fraction cliff_wave) .3)
				  (volume_test_objects cliff_right_fort_second_floor (players))
				  (volume_test_objects cliff_left_fort_second_floor (players))) 5)
	(if (or (volume_test_objects cliff_right_fort_second_floor (players))
		   (volume_test_objects cliff_left_fort_second_floor (players)))
		(ai_place cliff_wave/inside_bottom_jackal))
	(ai_place cliff_marine)
	(objects_predict (ai_actors cliff_marine))
	(objects_predict (ai_actors cliff_wave))

	(sleep_until (or (< (ai_living_fraction cliff_wave) .3)
				  (volume_test_objects cliff_inside_left_bottom (players))) 5)
	(sleep_until (< (ai_living_count cliff_wave/inside_bottom_jackal) 3) 1 delay_late)

	(if (< (ai_living_fraction cliff_wave) .3) (set global_cliff_welcome true))
	(sleep_until (game_safe_to_speak) 1)
	(wake save_cliff_welcome)
	(ai_conversation cliff_welcome)
	
	(sleep_until (< 4 (ai_conversation_status cliff_welcome)) 1)
	(set global_cliff_welcome true)
	)

(script dormant mission_cliff
	(wake obj_cliff_arrival)
	
	(sleep_until (or (volume_test_objects cliff_1 (players))
				  (volume_test_objects cliff_2 (players))) 15)
	(set global_cliff_start true)
	(if (or global_river_end global_rubble_end) (set cont_banshee_kill true))
	(ai_place cliff_wave/right_fort_elite)
	(ai_place cliff_wave/right_fort_grunt)
	(ai_place cliff_wave/right_fort_far_jackal)
	(ai_place cliff_wave/right_fort_inside_grunt)
	(ai_place cliff_wave/left_fort_elite)
	(ai_place cliff_wave/left_fort_grunt)
	(ai_place cliff_wave/left_fort_far_jackal)
	(ai_place cliff_wave/left_fort_farther_jackal)
	(ai_place cliff_wave/left_fort_inside_grunt)
	(ai_place cliff_wave/main_top_elite)
	(ai_place cliff_wave/main_near_grunt)
	(ai_place cliff_wave/main_far_grunt)
	(objects_predict (ai_actors cliff_wave))

	(sleep 90)
	(sleep_until (volume_test_objects cliff_all (players)) 1)
	(wake obj_cliff_abandon)
	(wake mission_cliff_marine)

	(sleep_until global_cliff_welcome 1)
	(wake obj_cliff_all_killed)
	(ai_maneuver_enable cliff_marine 0)
	(ai_follow_target_players cliff_marine)
	(if (and global_river_end global_rubble_end) (set play_music_a30_07 true))

	(sleep_until (> 7 (ai_living_count cliff_wave)) 15)
	(ai_migrate cliff_wave cliff_wave/main_near)
;	(if mark_final_banshee (final_banshee_cliff))
	(ai_maneuver_enable cliff_wave 0)
	(ai_follow_target_players cliff_wave)
	(ai_magically_see_players cliff_wave)

	(sleep_until (= 0 (ai_living_count cliff_wave)) 15 delay_late)
	(if (not (or global_cliff_all_killed (= 0 (ai_living_count cliff_wave)))) (ai_conversation cliff_cleanup))
	(sleep_until (= 0 (ai_living_count cliff_wave)) 15 delay_lost)
;	(if mark_final_banshee (sleep_until (=  0 (ai_living_count final_banshee)) 1 delay_lost))
;	(ai_kill final_banshee)
	(set test_cliff_kill true)
	(ai_conversation_stop cliff_welcome)
	(sleep delay_calm)
	(ai_follow_target_disable cliff_marine)
	(ai_maneuver_enable cliff_marine 1)
	(set global_cliff_end true)
	(set global_cliff_dead true)
	(sleep 10)
	(set play_music_a30_07 false)
	(if (and global_river_end global_rubble_end) (wake mission_extraction_cliff))
	(if (and global_river_end global_rubble_end) (set global_extraction true))
	(if (and global_river_end global_rubble_end) (sleep -1))
	(if global_cliff_all_killed (ai_conversation cliff_abandon_killed))
	(if global_cliff_all_killed (sleep -1))
	(object_create foehammer_cliff)
	(unit_set_enterable_by_player foehammer_cliff 0)
	(cond ((or (volume_test_objects cliff_all jeep)
			 (volume_test_objects cliff_all jeep2)
			 (volume_test_objects cliff_all jeep3)
			 ) (sleep 1))
		 (mark_jeep3 (sleep 1))
	    	 (mark_jeep2 (begin (object_create jeep3) (unit_enter_vehicle jeep3 foehammer_cliff "cargo") (set mark_jeep3 true)))
	    	 (true (begin (object_create jeep2) (unit_enter_vehicle jeep2 foehammer_cliff "cargo") (set mark_jeep2 true)))
		)
	(object_teleport foehammer_cliff foehammer_cliff_flag)
	(recording_play_and_hover foehammer_cliff foehammer_cliff_in)

	(sleep 210)
	(ai_migrate cliff_marine cliff_marine/waiting_marine)

	(sleep (recording_time foehammer_cliff))
	(unit_exit_vehicle jeep)
	(unit_exit_vehicle jeep2)
	(unit_exit_vehicle jeep3)
	(set global_cliff_marine_rescued true)
	(wake save_cliff_rescued)
	(cond ((game_is_cooperative) (sleep 1))
		 ((volume_test_objects cliff_all jeep) (ai_go_to_vehicle cliff_marine jeep "gunner"))
		 ((volume_test_objects cliff_all jeep2) (ai_go_to_vehicle cliff_marine jeep2 "gunner"))
		 ((volume_test_objects cliff_all jeep3) (ai_go_to_vehicle cliff_marine jeep3 "gunner")))
	(cond ((game_is_cooperative) (sleep 1))
		 ((volume_test_objects cliff_all jeep) (ai_go_to_vehicle cliff_marine jeep "passenger"))
		 ((volume_test_objects cliff_all jeep2) (ai_go_to_vehicle cliff_marine jeep2 "passenger"))
		 ((volume_test_objects cliff_all jeep3) (ai_go_to_vehicle cliff_marine jeep3 "passenger")))

	(ai_go_to_vehicle cliff_marine foehammer_cliff "riderLB")
	(ai_go_to_vehicle cliff_marine foehammer_cliff "riderRB")
	(ai_go_to_vehicle cliff_marine foehammer_cliff "riderLM")
	(ai_go_to_vehicle cliff_marine foehammer_cliff "riderRM")

	(sleep_until (= 0 (ai_going_to_vehicle foehammer_cliff)) 15)
	(sleep 60)
	(vehicle_hover foehammer_cliff 0)
	(recording_play_and_delete foehammer_cliff foehammer_cliff_out)
	)

;========== Rubble Scripts ==========

(script dormant obj_rubble_abandon
	(deactivate_team_nav_point_flag player cliff_nav_flag)
	(deactivate_team_nav_point_flag player rubble_nav_flag)
	(deactivate_team_nav_point_flag player river_nav_flag)

	(sleep_until (not (volume_test_objects_all rubble_all (players))) 15)
	(cond (global_two_marine_rescued (ai_conversation rubble_abandon_final))
		 (global_rubble_dead (sleep -1))
		 (global_rubble_all_killed (ai_conversation rubble_abandon_killed))
		 (global_rubble_welcome (ai_conversation rubble_abandon_welcome))
		 (true (ai_conversation rubble_abandon)))
;coop If it starts to be a problem that two players can run all over, fix it here
	)

(script dormant obj_rubble_all_killed
	(sleep_until (or global_rubble_end
				  (= 0 (ai_living_count rubble_marine))) 15)
	(sleep 60)
	(if (not global_rubble_end) (set global_rubble_all_killed true))
	(if (and (volume_test_objects rubble_all (players)) (not global_rubble_end)) (ai_conversation rubble_all_killed))
	(if (not (and global_river_end global_cliff_end)) (set global_rubble_end true))
	)

(script dormant mission_rubble_defend
	(sleep_until global_rubble_wave_2 5)
	(sleep_until (volume_test_objects_all rubble_defend (players)) 15)
	(ai_retreat rubble_wave/wave_2_attack_toon)
	(set global_rubble_wave_2_defend true)

	(sleep_until global_rubble_wave_3 5)
	(sleep_until (volume_test_objects_all rubble_defend (players)) 15)
	(ai_retreat rubble_wave/wave_3_attack_toon)
	(set global_rubble_wave_3_defend true)

	(sleep_until global_rubble_wave_4 5)
	(sleep_until (volume_test_objects_all rubble_defend (players)) 15)
	(ai_retreat rubble_wave/wave_4_attack_toon)
	(set global_rubble_wave_4_defend true)

	(sleep_until global_rubble_wave_5 5)
	(sleep_until (volume_test_objects_all rubble_defend (players)) 15)
	(ai_retreat rubble_wave/wave_5_attack_toon)
	(set global_rubble_wave_5_defend true)
	)

(script dormant mission_rubble_retreat
	(sleep_until global_rubble_wave_2_defend 5)
	(sleep_until (volume_test_objects_all rubble_retreat (players)) 15)
	(ai_retreat rubble_wave/wave_2_defend_toon)

	(sleep_until global_rubble_wave_3_defend 5)
	(sleep_until (volume_test_objects_all rubble_retreat (players)) 15)
	(ai_retreat rubble_wave/wave_3_defend_toon)

	(sleep_until global_rubble_wave_4_defend 5)
	(sleep_until (volume_test_objects_all rubble_retreat (players)) 15)
	(ai_retreat rubble_wave/wave_4_defend_toon)

	(sleep_until global_rubble_wave_5_defend 5)
	(sleep_until (volume_test_objects_all rubble_retreat (players)) 15)
	(ai_retreat rubble_wave/wave_5_defend_toon)
	)

(script dormant mission_rubble_marine
	(ai_place rubble_marine)
	(objects_predict (ai_actors rubble_marine))

	(sleep_until global_rubble_wave_2 1)
	(sleep 90)
	(sleep_until (or global_rubble_wave_3
				  (!= (game_difficulty_get) normal)
				  (> .5 (ai_living_fraction rubble_marine))) 15)
	(ai_migrate rubble_marine rubble_marine/fight_marine)
	
	(sleep 90)
	(wake mission_rubble_defend)

	(sleep 90)
	(sleep_until (or (= (game_difficulty_get) impossible)
				  global_rubble_wave_4
				  (> .25 (ai_living_fraction rubble_marine))) 15)

	(sleep 90)
	(ai_migrate rubble_marine rubble_marine/iron_marine)
	(ai_conversation rubble_retreat)
	
	(sleep 45)
	(wake mission_rubble_retreat)

	(sleep_until (or global_rubble_wave_5
				  (= 0 (ai_living_fraction rubble_marine))) 15)
	(ai_maneuver_enable rubble_wave 0)
	(ai_follow_target_players rubble_wave)
	)

(script dormant mission_rubble_wave_2
	(object_create rubble_rock_cship)
	(unit_close rubble_rock_cship)
	(ai_place rubble_wave/wave_2_lz_toon)
	(ai_disregard (ai_actors rubble_wave/wave_2_lz_toon) 1)
	(ai_braindead rubble_wave/wave_2_lz_toon 1)
	(vehicle_load_magic rubble_rock_cship "passenger" (ai_actors rubble_wave/wave_2_lz_toon))
	(object_teleport rubble_rock_cship rubble_rock_cship_flag)
	(recording_play_and_hover rubble_rock_cship rubble_rock_cship_enter)
	(objects_predict rubble_rock_cship)

	(sleep (recording_time rubble_rock_cship))
	(ai_conversation rubble_wave_2_alert)
	(sleep_until (< 4 (ai_conversation_status rubble_wave_2_alert)) 1 delay_dawdle)

	(ai_disregard (ai_actors rubble_wave/wave_2_lz_toon) 0)
	(ai_migrate rubble_marine rubble_marine/fight_marine)
	(ai_magically_see_encounter rubble_marine rubble_wave)

	(sleep_until (not (volume_test_objects rubble_rock_lz (players))) 15 delay_dawdle)
	(vehicle_hover rubble_rock_cship 0)
	(recording_play_And_hover rubble_rock_cship rubble_rock_cship_drop)

	(sleep (max 0 (- (recording_time rubble_rock_cship) 60)))
	(unit_open rubble_rock_cship)

	(ai_braindead rubble_wave/wave_2_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload rubble_rock_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerr04") (sleep 5))
		)
	(set global_rubble_wave_2 true)

	(sleep 120)
	(vehicle_hover rubble_rock_cship 0)
	(recording_play_and_delete rubble_rock_cship rubble_rock_cship_exit)
	(sleep 30)
	(unit_close rubble_rock_cship)
	(object_set_collideable rubble_rock_cship 0)

	(sleep_until (or (vehicle_test_seat_list jeep W-driver (players))
				  (vehicle_test_seat_list jeep2 W-driver (players))
				  (vehicle_test_seat_list jeep3 W-driver (players))
				  (volume_test_objects_all rubble_attack (players))) 15)
	(ai_migrate rubble_wave/wave_2_jackal rubble_wave/wave_2_attack_toon)
	(sleep 90)
	(ai_migrate rubble_wave/wave_2_lz_toon rubble_wave/wave_2_attack_toon)
	(if (or (vehicle_test_seat_list jeep W-driver (players))
		   (vehicle_test_seat_list jeep2 W-driver (players))
		   (vehicle_test_seat_list jeep3 W-driver (players)))
		(ai_migrate rubble_wave/wave_2_attack_toon rubble_wave/wave_2_defend_toon))
	(ai_magically_see_players rubble_wave)
	(ai_magically_see_encounter rubble_wave rubble_marine)
	)

(script dormant mission_rubble_wave_3
	(object_create rubble_middle_cship)
	(unit_close rubble_middle_cship)
	(ai_place rubble_wave/wave_3_lz_toon)
	(ai_disregard (ai_actors rubble_wave/wave_3_lz_toon) 1)
	(ai_braindead rubble_wave/wave_3_lz_toon 1)
	(vehicle_load_magic rubble_middle_cship "passenger" (ai_actors rubble_wave/wave_3_lz_toon))
	(object_teleport rubble_middle_cship rubble_middle_cship_flag)
	(recording_play_and_hover rubble_middle_cship rubble_middle_cship_enter)
	(objects_predict rubble_middle_cship)

	(sleep (recording_time rubble_middle_cship))
	(ai_conversation rubble_wave_3_alert)
	
	(sleep_until (< 4 (ai_conversation_status rubble_wave_3_alert)) 1 delay_dawdle)
	(ai_disregard (ai_actors rubble_wave/wave_3_lz_toon) 0)
	(ai_magically_see_encounter rubble_marine rubble_wave)

	(sleep_until (not (volume_test_objects rubble_middle_lz (players))) 15 delay_dawdle)
	(vehicle_hover rubble_middle_cship 0)
	(recording_play_and_hover rubble_middle_cship rubble_middle_cship_drop)

	(sleep (max 0 (- (recording_time rubble_middle_cship) 60)))
	(unit_open rubble_middle_cship)
	(ai_braindead rubble_wave/wave_3_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload rubble_middle_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload rubble_middle_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload rubble_middle_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload rubble_middle_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload rubble_middle_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload rubble_middle_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload rubble_middle_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload rubble_middle_cship "cd-passengerr04") (sleep 5))
		)
	(set global_rubble_wave_3 true)

	(sleep 120)
	(vehicle_hover rubble_middle_cship 0)
	(recording_play_and_delete rubble_middle_cship rubble_middle_cship_exit)
	(sleep 30)
	(unit_close rubble_middle_cship)
	(object_set_collideable rubble_middle_cship 0)

	(sleep_until (or (vehicle_test_seat_list jeep W-driver (players))
				  (vehicle_test_seat_list jeep2 W-driver (players))
				  (vehicle_test_seat_list jeep3 W-driver (players))
				  (volume_test_objects_all rubble_attack (players))) 15)
	(ai_migrate rubble_wave/wave_3_grunt rubble_wave/wave_3_attack_toon)
	(sleep 90)
	(ai_migrate rubble_wave/wave_3_lz_toon rubble_wave/wave_3_attack_toon)
	(if (or (vehicle_test_seat_list jeep W-driver (players))
		   (vehicle_test_seat_list jeep2 W-driver (players))
		   (vehicle_test_seat_list jeep3 W-driver (players)))
		(ai_migrate rubble_wave/wave_3_attack_toon rubble_wave/wave_3_defend_toon))
	(ai_magically_see_players rubble_wave)
	(ai_magically_see_encounter rubble_wave rubble_marine)
	)

(script dormant mission_rubble_wave_4
	(object_create rubble_rock_cship)
	(unit_close rubble_rock_cship)
	(ai_place rubble_wave/wave_4_lz_toon)
	(ai_disregard (ai_actors rubble_wave/wave_4_lz_toon) 1)
	(ai_braindead rubble_wave/wave_4_lz_toon 1)
	(vehicle_load_magic rubble_rock_cship "passenger" (ai_actors rubble_wave/wave_4_lz_toon))
	(object_teleport rubble_rock_cship rubble_rock_cship_flag)
	(recording_play_and_hover rubble_rock_cship rubble_rock_cship_enter)
	(objects_predict rubble_rock_cship)

	(sleep (recording_time rubble_rock_cship))
	(ai_conversation rubble_wave_4_alert)
	(sleep_until (< 4 (ai_conversation_status rubble_wave_2_alert)) 1 delay_dawdle)

	(ai_disregard (ai_actors rubble_wave/wave_4_lz_toon) 0)
	(ai_magically_see_encounter rubble_marine rubble_wave)

	(sleep_until (not (volume_test_objects rubble_rock_lz (players))) 15 delay_dawdle)
	(vehicle_hover rubble_rock_cship 0)
	(recording_play_and_hover rubble_rock_cship rubble_rock_cship_drop)

	(sleep (max 0 (- (recording_time rubble_rock_cship) 60)))
	(unit_open rubble_rock_cship)

	(ai_braindead rubble_wave/wave_4_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload rubble_rock_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload rubble_rock_cship "cd-passengerr04") (sleep 5))
		)
	(set global_rubble_wave_4 true)

	(sleep 120)
	(vehicle_hover rubble_rock_cship 0)
	(recording_play_and_delete rubble_rock_cship rubble_rock_cship_exit)
	(sleep 30)
	(unit_close rubble_rock_cship)
	(object_set_collideable rubble_rock_cship 0)

	(sleep_until (volume_test_objects_all rubble_attack (players)) 15)
	(sleep_until (or (vehicle_test_seat_list jeep W-driver (players))
				  (vehicle_test_seat_list jeep2 W-driver (players))
				  (vehicle_test_seat_list jeep3 W-driver (players))
				  (volume_test_objects_all rubble_attack (players))) 15)
	(ai_migrate rubble_wave/wave_4_grunt rubble_wave/wave_4_attack_toon)
	(sleep 90)
	(ai_migrate rubble_wave/wave_4_lz_toon rubble_wave/wave_4_attack_toon)
	(if (or (vehicle_test_seat_list jeep W-driver (players))
		   (vehicle_test_seat_list jeep2 W-driver (players))
		   (vehicle_test_seat_list jeep3 W-driver (players)))
		(ai_migrate rubble_wave/wave_4_attack_toon rubble_wave/wave_4_defend_toon))
	(ai_magically_see_players rubble_wave)
	(ai_magically_see_encounter rubble_wave rubble_marine)
	)

(script dormant mission_rubble_wave_5
	(object_create rubble_boat_cship)
	(unit_close rubble_boat_cship)
	(ai_place rubble_wave/wave_5_lz_toon)
	(ai_disregard (ai_actors rubble_wave/wave_5_lz_toon) 1)
	(ai_braindead rubble_wave/wave_5_lz_toon 1)
	(vehicle_load_magic rubble_boat_cship "passenger" (ai_actors rubble_wave/wave_5_lz_toon))
	(object_teleport rubble_boat_cship rubble_boat_cship_flag)
	(recording_play_and_hover rubble_boat_cship rubble_boat_cship_enter)
	(objects_predict rubble_boat_cship)

	(sleep (recording_time rubble_boat_cship))
	(ai_disregard (ai_actors rubble_wave/wave_5_lz_toon) 0)
	(ai_magically_see_encounter rubble_marine rubble_wave)

	(sleep_until (not (volume_test_objects rubble_rock_lz (players))) 15 delay_dawdle)
	(vehicle_hover rubble_boat_cship 0)
	(recording_play_and_hover rubble_boat_cship rubble_boat_cship_drop)

	(sleep (max 0 (- (recording_time rubble_boat_cship) 60)))
	(unit_open rubble_boat_cship)

	(ai_braindead rubble_wave/wave_5_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload rubble_boat_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload rubble_boat_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload rubble_boat_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload rubble_boat_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload rubble_boat_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload rubble_boat_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload rubble_boat_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload rubble_boat_cship "cd-passengerr04") (sleep 5))
		)
	(set global_rubble_wave_5 true)

	(sleep 120)
	(vehicle_hover rubble_boat_cship 0)
	(recording_play_and_delete rubble_boat_cship rubble_boat_cship_exit)
	(sleep 30)
	(unit_close rubble_boat_cship)
	(object_set_collideable rubble_boat_cship 0)

	(sleep_until (volume_test_objects_all rubble_attack (players)) 15)
	(sleep_until (or (vehicle_test_seat_list jeep W-driver (players))
				  (vehicle_test_seat_list jeep2 W-driver (players))
				  (vehicle_test_seat_list jeep3 W-driver (players))
				  (volume_test_objects_all rubble_attack (players))) 15)
	(ai_migrate rubble_wave/wave_5_jackal rubble_wave/wave_5_attack_toon)
	(sleep 90)
	(ai_retreat rubble_wave/wave_5_lz_toon)
	(if (or (vehicle_test_seat_list jeep W-driver (players))
		   (vehicle_test_seat_list jeep2 W-driver (players))
		   (vehicle_test_seat_list jeep3 W-driver (players)))
		(ai_migrate rubble_wave/wave_5_attack_toon rubble_wave/wave_5_defend_toon))
	(ai_magically_see_players rubble_wave)
	(ai_magically_see_encounter rubble_wave rubble_marine)
	)

(script continuous cont_rubble_kill
	(sleep_until test_rubble_kill 10)
	(sleep_until (not (objects_can_see_object (players) (list_get (ai_actors rubble_wave) 0) 40)) 10)
	(sleep 75)
	(if (not (objects_can_see_object (players) (list_get (ai_actors rubble_wave) 0) 40)) (object_destroy (list_get (ai_actors rubble_wave) 0)))
	)

(script dormant mission_rubble
	(sleep_until (or (volume_test_objects rubble_1 (players))
				  (volume_test_objects rubble_2 (players))) 15)
	(set global_rubble_start true)
	(if (or global_cliff_end global_river_end) (set cont_banshee_kill true))
	(ai_place rubble_wave/wave_1_toon)
	(objects_predict (ai_actors rubble_wave))
	(ai_playfight rubble_wave 1)
	(ai_playfight rubble_marine 1)
	(ai_try_to_fight rubble_wave rubble_marine)
	(wake mission_rubble_marine)

	(sleep_until (volume_test_objects rubble_arrival (players)) 15)
	(ai_conversation rubble_arrival)
	(deactivate_team_nav_point_flag player cliff_nav_flag)
	(deactivate_team_nav_point_flag player rubble_nav_flag)
	(deactivate_team_nav_point_flag player river_nav_flag)
	(wake save_rubble_welcome)

	(sleep_until (or (< .5 (ai_living_fraction rubble_wave)) 
				   (volume_test_objects rubble_attack (players))) 15)
	(ai_playfight rubble_wave 0)
	(ai_playfight rubble_marine 0)
	(sleep_until (or (< (ai_living_count rubble_wave) 3) 
				  (volume_test_objects rubble_attack (players))) 15)
	(sleep_until (and (< (ai_living_count rubble_wave) 3) 
				  (volume_test_objects rubble_attack (players))) 15 delay_late)
	(ai_conversation rubble_welcome)

	(sleep_until (< 4 (ai_conversation_status rubble_welcome)) 1 delay_late)
	(set global_rubble_welcome true)
	(wake obj_rubble_abandon)
	(wake obj_rubble_all_killed)

	(ai_try_to_fight_nothing rubble_wave)
	(wake mission_rubble_wave_2)

	(sleep_until global_rubble_wave_2 5)
	(set global_rubble_count (ai_living_count rubble_wave))
	(sleep_until (> (- global_rubble_count 1) (ai_living_count rubble_wave)) 15 delay_late)
	(sleep_until (> 4 (ai_living_count rubble_wave)) 15 delay_late)
	(wake mission_rubble_wave_3)

	(if (< 2 (ai_living_count rubble_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
	(wake save_rubble_wave_2)

	(sleep_until global_rubble_wave_3 5)
	(set global_rubble_count (ai_living_count rubble_wave))
	(sleep_until (> (- global_rubble_count 1) (ai_living_count rubble_wave)) 15 delay_late)
	(sleep_until (> 4 (ai_living_count rubble_wave)) 15 delay_dawdle)
	(wake mission_rubble_wave_4)

	(if (< 2 (ai_living_count rubble_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
	(wake save_rubble_wave_3)

	(sleep_until global_rubble_wave_4 5)
	(if (and global_river_end global_cliff_end) (set play_music_a30_07 true))
	(set global_rubble_count (ai_living_count rubble_wave))
	(sleep_until (> (- global_rubble_count 1) (ai_living_count rubble_wave)) 15 delay_dawdle)
;	(sleep_until (> 4 (ai_living_count rubble_wave)) 15 delay_late)
	(wake mission_rubble_wave_5)

	(if (< 0 (ai_living_count rubble_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
	(wake save_rubble_wave_4)

	(sleep_until global_rubble_wave_5 5)

	(sleep_until (> 5 (ai_living_count rubble_wave)) 15)
;	(if mark_final_banshee (final_banshee_rubble))
	(ai_maneuver_enable rubble_wave 0)
	(ai_follow_target_players rubble_wave)
	(ai_magically_see_players rubble_wave)

	(sleep_until (= 0 (ai_living_count rubble_wave)) 15 delay_lost)
	(if (not (or global_rubble_all_killed (= 0 (ai_living_count rubble_wave)))) (ai_conversation rubble_cleanup))

	(sleep_until (= 0 (ai_living_count rubble_wave)) 15 delay_lost)
	(if (< 0 (ai_living_count rubble_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
;	(if mark_final_banshee (sleep_until (=  0 (ai_living_count final_banshee)) 1 delay_lost))
;	(ai_kill final_banshee)
	(set test_rubble_kill true)
	(ai_conversation_stop rubble_welcome)
	(sleep delay_calm)
	(set global_rubble_end true)
	(set global_rubble_dead true)
	(sleep 10)
	(set play_music_a30_07 false)
	(if (and global_river_end global_cliff_end) (wake mission_extraction_rubble))
	(if (and global_river_end global_cliff_end) (set global_extraction true))
	(if (and global_river_end global_cliff_end) (sleep -1))
	(if global_rubble_all_killed (ai_conversation rubble_abandon_killed))
	(if global_rubble_all_killed (sleep -1))
	(sleep 10)
	(object_create foehammer_rubble)
	(unit_set_enterable_by_player foehammer_rubble 0)
	(cond ((or (volume_test_objects rubble_all jeep)
			 (volume_test_objects rubble_all jeep2)
			 (volume_test_objects rubble_all jeep3)
			 ) (sleep 1))
		 (mark_jeep3 (sleep 1))
	    	 (mark_jeep2 (begin (object_create jeep3) (unit_enter_vehicle jeep3 foehammer_rubble "cargo") (set mark_jeep3 true)))
	    	 (true (begin (object_create jeep2) (unit_enter_vehicle jeep2 foehammer_rubble "cargo") (set mark_jeep2 true)))
		)
	(object_teleport foehammer_rubble foehammer_rubble_flag)
	(recording_play_and_hover foehammer_rubble foehammer_rubble_in)
	
	(sleep 210)
	(ai_migrate rubble_marine rubble_marine/waiting_marine)

	(sleep (recording_time foehammer_rubble))
	(unit_exit_vehicle jeep)
	(unit_exit_vehicle jeep2)
	(unit_exit_vehicle jeep3)
	(set global_rubble_marine_rescued true)
	(wake save_rubble_rescued)
	(cond ((game_is_cooperative) (sleep 1))
		 ((volume_test_objects rubble_all jeep) (ai_go_to_vehicle rubble_marine jeep "gunner"))
		 ((volume_test_objects rubble_all jeep2) (ai_go_to_vehicle rubble_marine jeep2 "gunner"))
		 ((volume_test_objects rubble_all jeep3) (ai_go_to_vehicle rubble_marine jeep3 "gunner")))
	(cond ((game_is_cooperative) (sleep 1))
		 ((volume_test_objects rubble_all jeep) (ai_go_to_vehicle rubble_marine jeep "passenger"))
		 ((volume_test_objects rubble_all jeep2) (ai_go_to_vehicle rubble_marine jeep2 "passenger"))
		 ((volume_test_objects rubble_all jeep3) (ai_go_to_vehicle rubble_marine jeep3 "passenger")))

	(ai_go_to_vehicle rubble_marine foehammer_rubble "riderLB")
	(ai_go_to_vehicle rubble_marine foehammer_rubble "riderRB")
	(ai_go_to_vehicle rubble_marine foehammer_rubble "riderLM")
	(ai_go_to_vehicle rubble_marine foehammer_rubble "riderRM")

	(sleep_until (= 0 (ai_going_to_vehicle foehammer_rubble)) 15)
	(sleep 60)
	(vehicle_hover foehammer_rubble 0)
	(recording_play_and_delete foehammer_rubble foehammer_rubble_out)
	)

;========== River Scripts ==========

(script dormant mission_river_defend
	(sleep_until global_river_wave_2 5)
	(sleep_until (volume_test_objects_all river_attack (players)) 15)
	(ai_retreat river_wave/wave_2_attack_toon)
	(set global_river_wave_2_defend true)

	(sleep_until global_river_wave_3 5)
	(sleep_until (volume_test_objects_all river_attack (players)) 15)
	(ai_retreat river_wave/wave_3_attack_toon)
	(set global_river_wave_3_defend true)
	)

(script dormant mission_river_retreat
	(sleep_until global_river_wave_2_defend 5)
	(sleep_until (volume_test_objects_all river_retreat (players)) 15)
	(ai_retreat river_wave/wave_2_defend_toon)

	(sleep_until global_river_wave_3_defend 5)
	(sleep_until (volume_test_objects_all river_retreat (players)) 15)
	(ai_retreat river_wave/wave_3_defend_toon)
	)

(script dormant mission_river_marine
	(ai_place river_marine)
	(objects_predict (ai_actors river_marine))
	(ai_disregard (ai_actors river_wave) 1)

	(sleep_until (volume_test_objects river_retreat (players)) 15)
	(ai_defend river_marine)

	(sleep 90)
	(wake mission_river_defend)

	(sleep 90)
	(sleep_until (or global_river_wave_3
				  (> .3 (ai_living_fraction river_marine))) 15)

	(sleep 90)
	(ai_retreat river_marine)
	
	(sleep 45)
	(wake mission_river_retreat)

	(sleep_until (= 0 (ai_living_fraction river_marine)) 15)
	(ai_migrate river_wave river_wave/wave_2_retreat)
	(ai_follow_target_players river_wave)
	)

(script dormant obj_river_abandon
	(deactivate_team_nav_point_flag player cliff_nav_flag)
	(deactivate_team_nav_point_flag player rubble_nav_flag)
	(deactivate_team_nav_point_flag player river_nav_flag)

	(sleep_until (not (volume_test_objects_all river_all (players))) 15)
	(cond (global_two_marine_rescued (ai_conversation river_abandon_final))
		 (global_river_dead (sleep -1))
		 (global_river_all_killed (ai_conversation river_abandon_killed))
		 (global_river_welcome (ai_conversation river_abandon_welcome))
		 (true (ai_conversation river_abandon)))
;coop If it starts to be a problem that two players can run all over, fix it here
	)

(script dormant obj_river_all_killed
	(sleep_until (or global_river_end
				  (= 0 (ai_living_count river_marine))) 15)
	(sleep 60)
	(if (not global_river_end) (set global_river_all_killed true))
	(if (and (volume_test_objects river_all (players)) (not global_river_end)) (ai_conversation river_all_killed))
	(if (not (and global_rubble_end global_cliff_end)) (set global_river_end true))
	)

(script dormant mission_river_wave_1
	(ai_place river_wave/wave_1_toon)
	(objects_predict (ai_actors river_wave))
	(ai_disregard (ai_actors river_marine) 1)
	)

(script dormant mission_river_wave_2
;	(object_create river_pipe_cship)
;	(unit_close river_pipe_cship)
	(ai_place river_wave/wave_3_lz_toon)
	(objects_predict (ai_actors river_wave))
	(set global_river_wave_2 true)

	(sleep_until (volume_test_objects_all river_attack (players)) 15)
	(ai_retreat river_wave/wave_3_jackal)
	(sleep 300)
	(ai_retreat river_wave/wave_3_lz_toon)
	(ai_magically_see_players river_wave)
	(ai_magically_see_encounter river_wave river_marine)
	
	(sleep delay_late)
	(sleep_until (volume_test_objects_all river_retreat (players)) 15)
	(ai_retreat river_wave/wave_3_attack_toon)
	
	(sleep delay_late)
	(sleep_until (volume_test_objects_all river_retreat (players)) 15)
	(ai_retreat river_wave/wave_3_defend_toon)
	)

(script dormant mission_river_wave_3
	(object_create river_boat_cship)
	(unit_close river_boat_cship)
	(ai_place river_wave/wave_2_lz_toon)
	(ai_disregard (ai_actors river_wave/wave_2_lz_toon) 1)
	(ai_braindead river_wave/wave_2_lz_toon 1)
	(vehicle_load_magic river_boat_cship "passenger" (ai_actors river_wave/wave_2_lz_toon))
	(object_teleport river_boat_cship river_boat_cship_flag)
	(recording_play_and_hover river_boat_cship river_boat_cship_enter)
	(objects_predict river_boat_cship)

	(sleep (recording_time river_boat_cship))
	(ai_disregard (ai_actors river_wave/wave_2_lz_toon) 0)
	(ai_disregard (ai_actors river_marine) 0)
	(ai_magically_see_encounter river_marine river_wave)

	(sleep_until (not (volume_test_objects river_boat_lz (players))) 15)
	(vehicle_hover river_boat_cship 0)
	(recording_play_and_hover river_boat_cship river_boat_cship_drop)

	(sleep (max 0 (- (recording_time river_boat_cship) 60)))
	(unit_open river_boat_cship)
	(ai_braindead river_wave/wave_2_lz_toon 0)
	(sleep 60)
	(begin_random
		(begin (vehicle_unload river_boat_cship "cd-passengerl01") (sleep 5))
		(begin (vehicle_unload river_boat_cship "cd-passengerl02") (sleep 5))
		(begin (vehicle_unload river_boat_cship "cd-passengerl03") (sleep 5))
		(begin (vehicle_unload river_boat_cship "cd-passengerl04") (sleep 5))
		(begin (vehicle_unload river_boat_cship "cd-passengerr01") (sleep 5))
		(begin (vehicle_unload river_boat_cship "cd-passengerr02") (sleep 5))
		(begin (vehicle_unload river_boat_cship "cd-passengerr03") (sleep 5))
		(begin (vehicle_unload river_boat_cship "cd-passengerr04") (sleep 5))
		)
	(set global_river_wave_3 true)

	(sleep 120)
	(vehicle_hover river_boat_cship 0)
	(recording_play_and_delete river_boat_cship river_boat_cship_exit)
	(sleep 30)
	(unit_close river_boat_cship)

	(sleep_until (volume_test_objects_all river_attack (players)) 15)
	(ai_retreat river_wave/wave_2_grunt)
	(sleep 300)
	(ai_retreat river_wave/wave_2_lz_toon)
	(ai_magically_see_players river_wave)
	(ai_magically_see_encounter river_wave river_marine)
	
	(sleep delay_late)
	(sleep_until (volume_test_objects_all river_retreat (players)) 15)
	(ai_retreat river_wave/wave_2_attack_toon)
	
	(sleep delay_late)
	(sleep_until (volume_test_objects_all river_retreat (players)) 15)
	(ai_retreat river_wave/wave_2_defend_toon)
	)

(script continuous cont_river_kill
	(sleep_until test_river_kill 10)
	(sleep_until (not (objects_can_see_object (players) (list_get (ai_actors river_wave) 0) 40)) 10)
	(sleep 75)
	(if (not (objects_can_see_object (players) (list_get (ai_actors river_wave) 0) 40)) (object_destroy (list_get (ai_actors river_wave) 0)))
	)
;*
(script dormant flavor_river_sniper
	(ai_conversation river_sniper)

	(sleep_until (< 4 (ai_conversation_status river_sniper)) 1)
	(sleep 30)
	(ai_kill river_marine/wounded_marine)
	)
*;

(script dormant mission_river
	(sleep_until (or (volume_test_objects river_1 (players))
				  (volume_test_objects river_2 (players))) 15)
	(set global_river_start true)
	(if (or global_cliff_end global_rubble_end) (set cont_banshee_kill true))
	(wake save_river_arrival)
	(wake mission_river_marine)
	(wake mission_river_wave_1)

	(sleep_until (volume_test_objects river_attack (players)) 15)
	(sleep_until (game_safe_to_speak) 1)
	(ai_conversation river_arrival)
	(deactivate_team_nav_point_flag player cliff_nav_flag)
	(deactivate_team_nav_point_flag player rubble_nav_flag)
	(deactivate_team_nav_point_flag player river_nav_flag)
	
	(sleep_until (< 4 (ai_conversation_status river_arrival)) 1 delay_dawdle)
	(wake save_river_welcome)
	(ai_conversation river_welcome)

	(sleep_until (volume_test_objects river_retreat (players)) 1 delay_late)
	(sleep_until (< 4 (ai_conversation_status river_welcome)) 1 delay_dawdle)
	(set global_river_welcome true)
	(wake obj_river_abandon)
	(wake obj_river_all_killed)
	(wake mission_river_wave_2)
	(ai_disregard (ai_actors river_wave) 0)
	(ai_disregard (ai_actors river_marine) 0)

	(sleep_until global_river_wave_2 5)
	(sleep_until (> .5 (ai_living_fraction river_wave)) 15)
	(ai_migrate river_wave river_wave/wave_2_retreat)
	(ai_maneuver_enable river_wave 0)
	(ai_follow_target_players river_wave)
	(sleep_until (> 9 (ai_living_count river_wave)) 15 delay_late)
	(if (< 6 (ai_living_count river_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
	(ai_follow_target_disable river_wave)
	(ai_maneuver_enable river_wave 1)
	(wake save_river_wave_2)

	(wake mission_river_wave_3)

	(sleep_until global_river_wave_3 5)
	(if (and global_rubble_end global_cliff_end) (set play_music_a30_07 true))

	(sleep_until (> 6 (ai_living_count river_wave)) 15)
	(ai_migrate river_wave river_wave/wave_2_retreat)
;	(if mark_final_banshee (final_banshee_river))
	(ai_maneuver_enable river_wave 0)
	(ai_follow_target_players river_wave)
	(ai_magically_see_players river_wave)

	(sleep_until (= 0 (ai_living_count river_wave)) 15 delay_late)
	(if (not (or global_river_all_killed (= 0 (ai_living_count river_wave)))) (ai_conversation river_cleanup))

	(sleep_until (= 0 (ai_living_count river_wave)) 15 delay_lost)
	(if (< 0 (ai_living_count river_wave)) (sleep_until (game_all_quiet) 1 delay_dawdle))
;	(if mark_final_banshee (sleep_until (=  0 (ai_living_count final_banshee)) 1 delay_lost))
;	(ai_kill final_banshee)
	(set test_river_kill true)
	(ai_conversation_stop river_welcome)
	(sleep delay_calm)
	(set global_river_end true)
	(set global_river_dead true)
	(sleep 10)
	(set play_music_a30_07 false)
	(if (and global_rubble_end global_cliff_end) (wake mission_extraction_river))
	(if (and global_rubble_end global_cliff_end) (set global_extraction true))
	(if (and global_rubble_end global_cliff_end) (sleep -1))
	(if global_river_all_killed (ai_conversation river_abandon_killed))
	(if global_river_all_killed (sleep -1))
	(sleep 10)
	(object_create foehammer_river)
	(unit_set_enterable_by_player foehammer_river 0)
	(cond ((or (volume_test_objects river_all jeep)
			 (volume_test_objects river_all jeep2)
			 (volume_test_objects river_all jeep3)
			 ) (sleep 1))
		 (mark_jeep3 (sleep 1))
	    	 (mark_jeep2 (begin (object_create jeep3) (unit_enter_vehicle jeep3 foehammer_river "cargo") (set mark_jeep3 true)))
	    	 (true (begin (object_create jeep2) (unit_enter_vehicle jeep2 foehammer_river "cargo") (set mark_jeep2 true)))
		)
	(object_teleport foehammer_river foehammer_river_flag)
	(recording_play_and_hover foehammer_river foehammer_river_in)
	
	(sleep 210)
	(ai_migrate river_marine river_marine/waiting_marine)

	(sleep (recording_time foehammer_river))
	(unit_exit_vehicle jeep)
	(unit_exit_vehicle jeep2)
	(unit_exit_vehicle jeep3)
	(set global_river_marine_rescued true)
	(wake save_river_rescued)
	(cond ((game_is_cooperative) (sleep 1))
		 ((volume_test_objects river_all jeep) (ai_go_to_vehicle river_marine jeep "gunner"))
		 ((volume_test_objects river_all jeep2) (ai_go_to_vehicle river_marine jeep2 "gunner"))
		 ((volume_test_objects river_all jeep3) (ai_go_to_vehicle river_marine jeep3 "gunner")))
	(cond ((game_is_cooperative) (sleep 1))
		 ((volume_test_objects river_all jeep) (ai_go_to_vehicle river_marine jeep "passenger"))
		 ((volume_test_objects river_all jeep2) (ai_go_to_vehicle river_marine jeep2 "passenger"))
		 ((volume_test_objects river_all jeep3) (ai_go_to_vehicle river_marine jeep3 "passenger")))

	(ai_go_to_vehicle river_marine foehammer_river "riderLB")
	(ai_go_to_vehicle river_marine foehammer_river "riderRB")
	(ai_go_to_vehicle river_marine foehammer_river "riderLM")
	(ai_go_to_vehicle river_marine foehammer_river "riderRM")

	(sleep_until (= 0 (ai_going_to_vehicle foehammer_river)) 15)
	(sleep 60)
	(vehicle_hover foehammer_river 0)
	(recording_play_and_delete foehammer_river foehammer_river_out)
	)

;========== Mission Scripts ==========
;scripts that control the mission flow

(script continuous cont_banshee_kill
	(sleep_until cont_banshee_kill 10)
	(sleep_until (not (objects_can_see_object (players) mid_banshee_1 40)) 10)
	(sleep 75)
	(if (not (objects_can_see_object (players) mid_banshee_1 40)) (begin (object_destroy mid_banshee_1) (ai_erase mid_banshee/pilot_1)))
	(sleep_until (not (objects_can_see_object (players) mid_banshee_2 40)) 10)
	(sleep 75)
	(if (not (objects_can_see_object (players) mid_banshee_2 40)) (begin (object_destroy mid_banshee_2) (ai_erase mid_banshee/pilot_2)))
	)

(script dormant mission_mid_banshee
	(object_create mid_banshee_1)
	(unit_set_enterable_by_player mid_banshee_1 0)
	(object_create mid_banshee_2)
	(unit_set_enterable_by_player mid_banshee_2 0)
	(ai_place mid_banshee)
	(vehicle_load_magic mid_banshee_1 "driver" (ai_actors mid_banshee/pilot_1))
	(object_teleport mid_banshee_1 mid_banshee_flag_1)

	(vehicle_load_magic mid_banshee_2 "driver" (ai_actors mid_banshee/pilot_2))
	(object_teleport mid_banshee_2 mid_banshee_flag_2)
	(objects_predict mid_banshee_1)
	)

(script dormant mission_mid_cliff_1
	(ai_place mid_cliff_1)
	(object_create midcliff_cship_1)
	(object_teleport midcliff_cship_1 midcliff_1_flag)
	(vehicle_hover midcliff_cship_1 1)
	(objects_predict (ai_actors mid_cliff_1))
	(objects_predict midcliff_cship_1)

	(sleep_until (or (volume_test_objects midcliff_1_trigger (players))
				  (< (ai_strength mid_cliff_1) .9)
				  (objects_can_see_object (players) midcliff_cship_1 5)) 1)
	(vehicle_hover midcliff_cship_1 0)
	(recording_play_and_delete midcliff_cship_1 midcliff_1_cship_exit)
	)

(script dormant mission_mid_cliff_2
	(ai_place mid_cliff_2)
	(object_create midcliff_cship_2)
	(object_teleport midcliff_cship_2 midcliff_2_flag)
	(vehicle_hover midcliff_cship_2 1)
	(objects_predict (ai_actors mid_cliff_2))
	(objects_predict midcliff_cship_2)
	
	(sleep_until (or (volume_test_objects midcliff_2_trigger (players))
				  (< (ai_strength mid_cliff_2) .9)
				  (objects_can_see_object (players) midcliff_cship_2 5)) 1)
	(vehicle_hover midcliff_cship_2 0)
	(recording_play_and_delete midcliff_cship_2 midcliff_2_cship_exit)
	)

(script dormant mission_mid_rubble_1
	(ai_place mid_rubble_1)
	(object_create midrubble_cship_1)
	(object_teleport midrubble_cship_1 midrubble_1_flag)
	(vehicle_hover midrubble_cship_1 1)
	(objects_predict (ai_actors mid_rubble_1))
	(objects_predict midrubble_cship_1)
	
	(sleep_until (or (volume_test_objects midrubble_1_trigger (players))
				  (< (ai_strength mid_rubble_1) .9)
				  (objects_can_see_object (players) midrubble_cship_1 5)) 1)
	(vehicle_hover midrubble_cship_1 0)
	(recording_play_and_delete midrubble_cship_1 midrubble_1_cship_exit)
	)

(script dormant mission_mid_river_1
	(ai_place mid_river_1)
	(object_create midriver_cship_1)
	(object_teleport midriver_cship_1 midriver_1_flag)
	(vehicle_hover midriver_cship_1 1)
	(objects_predict (ai_actors mid_river_1))
	(objects_predict midriver_cship_1)
	
	(sleep_until (or (volume_test_objects midriver_1_trigger (players))
				  (< (ai_strength mid_river_1) .9)
				  (objects_can_see_object (players) midriver_cship_1 5)) 1)
	(vehicle_hover midriver_cship_1 0)
	(recording_play_and_delete midriver_cship_1 midriver_1_cship_exit)
	)

(script dormant mission_obj
	(sleep_until (or global_cliff_end
				  global_rubble_end
				  global_river_end) 15)
	(set mark_search2 true)
	(cond ((volume_test_objects_all cliff_all (players)) (begin (wake mission_mid_rubble_1)))
		 ((volume_test_objects_all rubble_all (players)) (begin (wake mission_mid_cliff_1) (wake mission_mid_river_1)))
		 ((volume_test_objects_all river_all (players)) (begin (wake mission_mid_cliff_2) (ai_place mid_rubble_2)))
	)
	(wake mission_mid_banshee)
	(cond ((and global_cliff_end (not global_cliff_dead)) (sleep 1))
		 ((and global_river_end (not global_river_dead)) (sleep 1))
		 ((and global_rubble_end (not global_rubble_dead)) (sleep 1))
		 ((and global_cliff_end (not global_cliff_all_killed)) (wake cutscene_one_rescued_cliff))
		 ((and global_rubble_end (not global_rubble_all_killed)) (wake cutscene_one_rescued_rubble))
		 ((and global_river_end (not global_river_all_killed)) (wake cutscene_one_rescued_river))
		 (true (wake dialog_one_rescued_killed))
		 )
	(sleep_until (not (or (volume_test_objects_all cliff_all (players))
					  (volume_test_objects_all rubble_all (players))
					  (volume_test_objects_all river_all (players)))) 1)
	(sleep_until (or (and global_cliff_end
				  	  global_rubble_end)
				  (and global_cliff_end
				  	  global_river_end)
			  	  (and global_rubble_end
				  	  global_river_end)) 15 delay_lost)
	(if (not (or (and global_cliff_start
			  	   global_rubble_start
			  	   (or (volume_test_objects cliff_all (players))
			  	   	  (volume_test_objects rubble_all (players))))
			   (and global_cliff_start
			  	   global_river_start
			  	   (or (volume_test_objects cliff_all (players))
			  	   	  (volume_test_objects river_all (players))))
		  	   (and global_rubble_start
			  	   global_river_start
			  	   (or (volume_test_objects rubble_all (players))
			  	   	  (volume_test_objects river_all (players))))))
		(begin (wake dialog_one_rescued_prompt)
			  (cond ((and global_cliff_end global_rubble_end) (sleep 1))
				   ((and global_cliff_end global_river_end) (sleep 1))
			  	   ((and global_rubble_end global_river_end) (sleep 1))
			  	   ((not global_river_end) (activate_team_nav_point_flag "default_red" player river_nav_flag 0))
				   ((not global_rubble_end) (activate_team_nav_point_flag "default_red" player rubble_nav_flag 0))
				   ((not global_cliff_end) (activate_team_nav_point_flag "default_red" player cliff_nav_flag 0))
			  	)))
	
	(sleep_until (or (and global_cliff_end
				  	  global_rubble_end)
				  (and global_cliff_end
				  	  global_river_end)
			  	  (and global_rubble_end
				  	  global_river_end)) 15)

	(set mark_search3 true)
	(cond ((volume_test_objects_all cliff_all (players)) (begin (wake mission_mid_rubble_1)))
		 ((volume_test_objects_all rubble_all (players)) (begin (wake mission_mid_cliff_1) (wake mission_mid_river_1)))
		 ((volume_test_objects_all river_all (players)) (begin (wake mission_mid_cliff_2) (ai_place mid_rubble_2)))
	)
	(cond ((and (volume_test_objects_all cliff_all (players)) global_cliff_end (not global_cliff_dead)) (sleep 1))
		 ((and (volume_test_objects_all rubble_all (players)) global_rubble_end (not global_rubble_dead)) (sleep 1))
		 ((and (volume_test_objects_all river_all (players)) global_river_end (not global_river_dead)) (sleep 1))
		 ((and (volume_test_objects_all cliff_all (players)) global_cliff_end (not global_cliff_all_killed)) (wake dialog_two_rescued))
		 ((and (volume_test_objects_all rubble_all (players)) global_rubble_end (not global_rubble_all_killed)) (wake dialog_two_rescued))
		 ((and (volume_test_objects_all river_all (players)) global_river_end (not global_river_all_killed)) (wake dialog_two_rescued))
		 ((and (not (volume_test_objects_all cliff_all (players)))
		 	  (not (volume_test_objects_all rubble_all (players)))
		 	  (not (volume_test_objects_all river_all (players)))) (sleep 1))
		 (true (wake dialog_two_rescued_killed))
		 )
;	(set mark_final_banshee true)
	(sleep_until (not (or (volume_test_objects_all cliff_all (players))
					  (volume_test_objects_all rubble_all (players))
					  (volume_test_objects_all river_all (players)))) 1)
	(sleep_until (and global_cliff_end
				   global_rubble_end
			  	   global_river_end) 15 delay_dawdle)
	(ai_conversation third_driving)

	(sleep_until (and global_cliff_end
				   global_rubble_end
			  	   global_river_end) 15 delay_lost)
	(if (not (and global_cliff_start
			    global_rubble_start
			    global_river_start))
		(wake dialog_two_rescued_prompt))
	(if (not (and global_cliff_start
			    global_rubble_start
			    global_river_start
			    (or (volume_test_objects_all cliff_all (players))
				   (volume_test_objects_all rubble_all (players))
				   (volume_test_objects_all river_all (players)))))
		(cond ((and global_rubble_end global_river_end) (activate_team_nav_point_flag "default_red" player cliff_nav_flag 0))
			 ((and global_cliff_end global_river_end) (activate_team_nav_point_flag "default_red" player rubble_nav_flag 0))
			 ((and global_rubble_end global_cliff_end) (activate_team_nav_point_flag "default_red" player river_nav_flag 0))
		 ))

;	(sleep_until (and global_cliff_start
;				   global_rubble_start
;			  	   global_river_start) 15)
;	(set mark_final true)
;	(sleep_until (and global_cliff_end
;				   global_rubble_end
;			  	   global_river_end) 15)
;	(cond ((volume_test_objects cliff_all (players)) (mission_extraction_cliff))
;		 ((volume_test_objects rubble_all (players)) (mission_extraction_rubble))
;		 ((volume_test_objects river_all (players)) (mission_extraction_river))
;		 ((not mark_final_cliff_waiting) (mission_extraction_cliff))
;		 ((not mark_final_rubble_waiting) (mission_extraction_rubble))
;		 ((not mark_final_river_waiting) (mission_extraction_river))
;		 )
	)

;========== Main Mission Script ==========

(script static void cutscene_intro

	(objects_predict intro_pod)
	(object_beautify intro_pod true)

;	(show_hud 0)
	(cinematic_start)
	(camera_control on)
;	(player_camera_control 0)
	(fade_out 0 0 0 0)
	(camera_set intro_1 0)

	(camera_set intro_2 210)
	(fade_in 0 0 0 30)
	
	(sound_looping_start sound\sinomatixx\a30_insertion_foley none 1)
	(sound_looping_start sound\sinomatixx\a30_insertion_music none 1)
	
	(sleep 90) 
	(cinematic_set_title arrival)
	(sleep 30)
	(camera_set intro_3 150)
	
	(object_destroy intro_pod)
	(object_destroy pilot_intro)
	
	(object_create pilot_intro)
	(object_create intro_pod)
	
	(objects_attach intro_pod "driver" pilot_intro "") 	
	(custom_animation pilot_intro cinematics\animations\pilot\x30\x30 idle false)
	
	(game_skip_ticks 5)
	
	(object_teleport intro_pod intro_pod_flag)
	(recording_play intro_pod intro_pod_fly)
	
	(sleep 60)
	
	(sound_impulse_start sound\dialog\a30\a30_insert_010_cortana none 1)
	
	(sleep 30)
	
	(sleep (camera_time))
	
	(fade_out 1 1 1 10)
;	(camera_shake)
	
	(sleep 10)
	(camera_set_relative intro_pod_follow 0 intro_pod)
	
	(sound_impulse_start sound\dialog\a30\a30_insert_020_lifeboatpilot none 1)
	(print "pilot: damn! airbrake failure! we're losing them!")
	
	(player_effect_set_max_vibrate .3 .3)
	(player_effect_start 1 1 )
	
	(fade_in 1 1 1 10)
	
	(sleep 30)
	
	(custom_animation intro_pod vehicles\lifepod_entry\lifepod_entry "vehicle airbrakes-off" true)
	
	(print "<airbrakes pop off>")
	
	(sleep 90)
	
	(fade_out 1 1 1 10)
	
	(sleep 10)
	
	(objects_detach intro_pod pilot_intro)
	
	(object_destroy intro_pod)
	(object_destroy pilot_intro)
	
	(object_create_anew intro_pod_2)
	(object_create_anew chief)
	(object_create_anew pilot_intro)
	
	(objects_attach intro_pod_2 "driver" pilot_intro "") 	
	(custom_animation pilot_intro cinematics\animations\pilot\x30\x30 heads_up false)
	
	(game_skip_ticks 5)
	
	(unit_enter_vehicle chief intro_pod_2 "stand")
	
	(object_teleport intro_pod_2 intro_pod_2_base) 
	
	(cinematic_set_near_clip_distance .01)
	
	(camera_set_first_person chief)
	(recording_play chief chief_intro_cam)
	(recording_play intro_pod_2 intro_pod_fly_2)
	
	(player_effect_set_max_rotation 0 .5 .5)
	(player_effect_set_max_vibrate .5 .5)
	
	(fade_in 1 1 1 10)
	
	(sound_impulse_start sound\dialog\a30\a30_insert_030_lifeboatpilot none 1)
	
	(sleep 165)
	
	(sound_impulse_start sound\sfx\vehicles\lifeboat_crash none 1)
	
	(fade_out 1 1 1 0)	
	(camera_control off)
	
	(sleep 30)
	
	(player_effect_set_max_vibrate 1 1)
	(player_effect_stop 4)
	
	(object_destroy intro_tree)
	(object_destroy chief)
	(object_destroy pilot_intro)
	(object_destroy intro_pod_2)

	(sleep 90)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_convolution 1 1 3 0 7)
	)

; Jaime, do not delete this script! I love it! I need it!
(script static void intro_build

	(object_teleport intro_pod_2 intro_pod_2_base)
;	(recording_play intro_pod_2 intro_pod_fly_2)
)

(script dormant setup_dead
	(object_create pilot_intro)
	(object_create dead_marine_1)
	(object_create dead_marine_2)
	(object_create dead_marine_3)
	(objects_attach pod_of_death "rider left b" dead_marine_1 "")
	(objects_attach pod_of_death "rider right c" dead_marine_2 "")
	(objects_attach pod_of_death "rider right a" dead_marine_3 "")
	(objects_attach pod_of_death "driver" pilot_intro "")
	(custom_animation dead_marine_1 cinematics\animations\marines\x30\x30 death_pose_1 false)
	(custom_animation dead_marine_2 cinematics\animations\marines\x30\x30 death_pose_2 false)
	(custom_animation dead_marine_3 cinematics\animations\marines\x30\x30 death_pose_1 false)
	(custom_animation pilot_intro cinematics\animations\pilot\x30\x30 death_pose false)
	(ai_disregard pilot_intro 1)
	(ai_disregard dead_marine_1 1)
	(ai_disregard dead_marine_2 1)
	(ai_disregard dead_marine_3 1)
	)

(script static void death_pod_load
	(object_destroy pilot_intro)
	(object_destroy dead_marine_1)
	(object_destroy dead_marine_2)
	(object_destroy dead_marine_3)
	)

(script startup mission_a30
   (if (mcc_mission_segment "cine1_intro") (sleep 1))              
   
	(hud_show_motion_sensor 0)
	(fade_out 0 0 0 0)
	(print "mission script is running")
	(ai_allegiance player human)
	(if (cinematic_skip_start) (cutscene_intro))
	(cinematic_skip_stop)
	(wake setup_dead)
	(fade_out 1 1 1 0)
	(cinematic_show_letterbox 1)
	(player_camera_control 0)
	(player_enable_input 0)
	(show_hud 0)
	(sleep 30)
	(fade_in 1 1 1 120)
	(sleep 30)
	(ai_conversation intro_1)
	(sleep 120)
	(cinematic_show_letterbox 0)
	(player_camera_control 1)
	(player_enable_input 1)
	(hud_show_motion_sensor 1)
	(show_hud 1)
	(cinematic_stop)

   (mcc_mission_segment "01_start")
   
	(wake objectives_a30)
	(wake music_a30)

	(sleep_until (not (volume_test_objects_all lz_lifeboat (players))) 1)
	(wake save_mission_start)
	(ai_conversation intro_1b)
	(wake mission_lz)
	(wake mission_first)
	(wake mission_cave)
	
	(sleep_until (volume_test_objects cave_exit (players)) 1)
	(wake mission_cliff)
	(wake mission_rubble)
	(wake mission_river)
	(wake mission_obj)

	(set play_music_a30_06 true)
	(sleep 30)
	(show_hud 0)
	(cinematic_show_letterbox 1)
	(sleep 30)
	(cinematic_set_title reunion)
	(sleep 150)
	(cinematic_show_letterbox 0)
	(show_hud 1)
	(game_save_no_timeout)

	(sleep_until (or global_cliff_start global_rubble_start global_river_start) 1)
	(set play_music_a30_06 false)
	)

(script startup mission_killer
	(sleep_until global_extraction 1)
	(sleep -1 mission_cliff)
	(sleep -1 mission_rubble)
	(sleep -1 mission_river)
	)
