;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)
(global boolean debug 0)
(global boolean g_play_cinematics 1)
(global boolean g_null 0)

; insertion point index 
(global short g_insertion_index 0)
(global short halo_obj_control 0)
;====================================================================================================================================================================================================
;================================================================================================================================================================================== HALO MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script static void start
	; fade out 
	(fade_out 0 0 0 0)
	
	; select insertion point 
	(cond
		((= (game_insertion_point_get) 0) (ins_crash_site))
		((= (game_insertion_point_get) 1) (ins_exit_run))
	)
)

(script startup mission_halo
	(if debug (print "startup 120_halo_mission"))
	(print_difficulty)
	(wake object_management)
	(sleep_forever arbiter_in_vehicle)
	; fade to black 
	(fade_out 0 0 0 0)
	
	; set allegiances 
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	(ai_allegiance human covenant)
	(ai_allegiance player sentinel)
	(ai_allegiance sentinel player)
	(ai_allegiance covenant sentinel)
	(ai_allegiance sentinel covenant)
	(ai_allegiance human sentinel)
	(ai_allegiance sentinel human)		
	(wake disable_kill_vols)

	(wake gs_award_primary_skull)

	(object_create fp_terminal)
	(objects_attach fp_terminal_base "forerunner_terminal" fp_terminal "")

	
	; pre-killing continuous scripts
	(sleep_forever kill_stragglers)
	(sleep_forever kill_stragglers_left)
	(sleep_forever kill_stragglers_right)
	(sleep_forever kill_stragglers_center)
	(sleep_forever kill_pure_forms)
	(sleep_forever kill_all_end)
	(sleep_forever kill_pureform_finale_right)
	(sleep_forever kill_pureform_finale_left)
	(sleep_forever kill_pureform_finale_center)
	; the game can use flashlights 
	(game_can_use_flashlights TRUE)

	; Begin the mission if the player exists in the world 
	; otherwise fade in
	; === INSERTION POINT TEST =====================================================
	(if	(and
			(not editor)
			(> (player_count) 0)
		)
		; if game is allowed to start 
		(start)
		
		; if game is NOT allowed to start
		(fade_in 0 0 0 0)
	)
	; === INSERTION POINT TEST =====================================================

		;====
			(sleep_until (>= g_insertion_index 1))
			(if (= g_insertion_index 1) (wake 120_01_crash_site))
		
		;====
	
			;====
			(sleep_until	(or
							(volume_test_players 120_02_drop_down_start)
							(>= g_insertion_index 2)
						)
			1)
				(if (<= g_insertion_index 2) (wake 120_02_drop_down))

		;====

			(sleep_until	(or
							(volume_test_players 120_03_valley_floor_start)
							(>= g_insertion_index 3)
						)
			1)
				(if (<= g_insertion_index 3) (wake 120_03_valley_floor))

		;====
			(sleep_until	(or
							(volume_test_players 120_04_ziggurat_start)
							(volume_test_players 120_04_ziggurat_start02)							
							(>= g_insertion_index 4)
						)
			1)
				(if (<= g_insertion_index 4) (wake 120_04_ziggurat))

		;====
			(sleep_until	(or
							(volume_test_players 120_05_ziggurat_top_trig)
							(>= g_insertion_index 5)
						)
			1)
				(if (<= g_insertion_index 5) (wake 120_05_ziggurat_top))

		;====
			(sleep_until	(or
							(volume_test_players control_room_trig)
							(>= g_insertion_index 6)
						)
			1)
				(if (<= g_insertion_index 6) (wake 120_06_control_room))

		;====
			(sleep_until	(or
							(and (= cin_johnson_dead TRUE)
								(< (ai_living_count 343_spark_combat) 1))
							(>= g_insertion_index 7)
						)
			1)
			(if (<= g_insertion_index 7) (wake 120_07_path_to_exit))			
		;====
			(sleep_until	(or
							(volume_test_players 120_08_trench_run_start)
							(>= g_insertion_index 8)
						)
			1)
			(if (<= g_insertion_index 8) (wake 120_08_trench_run))
			
;*			(cond 
				((= (game_difficulty_get_real) easy)
					(sleep_until (volume_test_players end_trilogy03) 1))				
				((= (game_difficulty_get_real) normal)
					(sleep_until
						(or (volume_test_players end_trilogy02) 
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg/mongoose))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg/mongoose02))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg02/01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg03/01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg04/01))							
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost02))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost03))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost04))											
					)1))
				((= (game_difficulty_get_real) heroic)
					(sleep_until
					(or (volume_test_players end_trilogy01) 
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg/mongoose))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg/mongoose02))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg02/01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg03/01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg04/01))				
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost02))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost03))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost04))											
					)1))
				((= (game_difficulty_get_real) legendary)
*;					(sleep_until
					(or (volume_test_players end_trilogy01) 
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg/mongoose))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg/mongoose02))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg02/01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg03/01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location secret_egg04/01))						
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost01))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost02))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost03))
						(volume_test_object end_trilogy03 (ai_vehicle_get_from_starting_location sassy_egg/ghost04))											
					)1)
				;)
			;)
			(object_cannot_die (player0) true)
			(object_cannot_die (player1) true)
			(object_cannot_die (player2) true)
			(object_cannot_die (player3) true)		
			(sleep_forever 120_07_ambient_background)
			(if (game_is_cooperative)(game_safe_to_respawn TRUE))
			(player_effect_stop 0)
			(print "YOU BEAT THE GAME!!")
			(wake obj_exit_clear)
			
			(wake cin_halo_outro)			
			

)

(script dormant 120_01_crash_site
	(data_mine_set_mission_segment "120_01_crash_site")
	; TEST FOR FX GUYS
	(sleep_until (script_finished cin_halo_intro)5)
	(wake 120_music_01)
	(set g_music_120_01 true)	
	(wake md_01_crash_site_cortana)
	(wake md_02_terminal_cortana)
	(set halo_obj_control 10)
	(game_save)
	(sleep_until (volume_test_players cor_dialog_trig01)5)
	(set halo_obj_control 11)	
	(sleep_until (volume_test_players cor_dialog_trig01a)5)
	(set halo_obj_control 14)
	(sleep_until (volume_test_players cor_dialog_trig01b)5)
	(set halo_obj_control 16)
	(sleep_until (volume_test_players cor_dialog_trig01c)5)
	(set halo_obj_control 18)
	
)

(script dormant 120_02_drop_down
	(data_mine_set_mission_segment "120_02_drop_down")
	(wake 120_music_02)
	(ai_set_objective arbiter drop_down_obj)
	(set halo_obj_control 20)

	(sleep_until (volume_test_players cor_dialog_trig02)5)
	(set halo_obj_control 21)	

	(sleep_until (volume_test_players cor_dialog_trig02a)5)
	(set halo_obj_control 23)	

	(sleep_until (volume_test_players cor_dialog_trig02b)5)
	(set halo_obj_control 25)
	(set g_music_120_02 true)
	(sleep_until (volume_test_players cor_dialog_trig03)5)
	(sleep_forever md_01_crash_site_cortana)
;	(wake md_02_drop_path_cortana)
)


(script dormant 120_03_valley_floor
	(data_mine_set_mission_segment "120_03_valley_floor")
	(wake 120_music_03)
	(ai_disregard (ai_actors ziggurat_pureforms) TRUE)
	(ai_set_objective arbiter ziggurat_obj)			
	(set halo_obj_control 30)
	(sleep_until (volume_test_players 120_03_flood_attack)1)
;	(120_PA_Johnson_FlyBy)
	(game_save)	
	(sleep 30)
	(wake md_03_valley_floor); first crash located in this dialog
	(wake crash01)
	(wake crash02)
	(wake kill_stragglers)
	(wake flood_timer)
;	(ai_bring_forward obj_arbiter 5)	
	(sleep 30)
;	(wake ambient_meteors)
	(wake pure_form_attacks)
	(sleep_forever md_02_terminal_cortana)
)

(script dormant 120_04_ziggurat
	(data_mine_set_mission_segment "120_04_ziggurat")
	(wake 120_music_04)
	(wake 120_music_045)
	(wake 120_music_05)
	(wake 120_music_06)
	(game_save)
	(set halo_obj_control 40)
	(sleep_forever md_03_valley_floor)
	(wake sentinel_encounter)
	(wake combat_encounter)
	(set combat_total (+ 40 (ai_spawn_count exterior_meteorites)))
;	(set pure_total (+ 18 (ai_spawn_count ziggurat_pureforms)))
	(set valley_bool FALSE)
	(wake 120_04_ziggurat_encounters)
	(sleep_until 
			(or 
				(volume_test_players third_right_trig) 
				(volume_test_players third_center_trig) 
				(volume_test_players third_left_trig) 
				(volume_test_players johnson_intro_trig) 
			)
	5)
	(set g_music_120_03 false)
	(set g_music_120_045 true)	
	(ai_disregard (ai_actors ziggurat_pureforms) FALSE)	
	(ai_bring_forward obj_arbiter 20)
	(wake 120PA_JOHNSON_INTRO)
	(wake ziggurat_navpoint_active)
	(wake ziggurat_navpoint_deactive)
	(if (< (game_difficulty_get_real) legendary)
	(object_create_anew invincibility))
)

(script dormant 120_05_ziggurat_top
	(data_mine_set_mission_segment "120_05_ziggurat_top")											
	(set halo_obj_control 50)
	(wake 120_music_07)	
	(wake 120_music_08)	
	(wake 120_music_09)
	(set g_music_120_06 false)

	(sleep_forever 120_04_ziggurat_encounters)
	(sleep_forever crash00)	
	(sleep_forever crash01)
	(sleep_forever crash02)
	(md_06_spark_door)
	(ai_bring_forward obj_arbiter 10)
	(wake ziggurat_top_encounter)
	(sleep_forever combat_encounter)
	(sleep_forever pure_form_attacks)
	(sleep_forever flood_timer)
	(kill_volume_enable kill_pure_forms_trig)
	(sleep_until (= wave_num 7))
	(sleep_forever sentinel_right_spawner)
	(sleep_forever sentinel_left_spawner)
	(switch_zone_set 120_01_02_03)
	(sleep_until (>= (current_zone_set_fully_active) 1) 1) ;120_01_02_03
	(wake 120VB_DOOR_OPENS); this opens the door
	(game_save)
	(wake tjm01_navpoint_active)		
	(wake tjm01_navpoint_deactive)
	(wake 120VB_Johnson_movement)	
	
)


(global boolean cin_johnson_dead FALSE)

(script dormant 120_06_control_room
	
	(game_save)

	(set halo_obj_control 60)

	(wake 120_music_10)	
	(wake 120_music_11)
			
	(device_set_position control_room_door 1)

	(sleep 30)
	(set g_music_120_08 false)
	(set g_music_120_09 false)		
	(wake cin_halo_johnson)
	(sleep_until (script_finished cin_halo_johnson)1)

	(data_mine_set_mission_segment "120_06_control_room")

	(wake obj_ziggurat_clear)
	(wake obj_halo_set)
	
	(sleep_forever kill_stragglers)
	(sleep_forever kill_stragglers_left)
	(sleep_forever kill_stragglers_right)
	(sleep_forever kill_stragglers_center)
	(sleep_forever kill_pure_forms)
	(sleep_forever kill_all_end)
	(sleep_forever kill_pureform_finale_right)
	(sleep_forever kill_pureform_finale_left)
	(sleep_forever kill_pureform_finale_center)

;	(if dialogue (print "GUILTY: But this ring is mine"))
;	(ai_play_line 343_spark_combat 120LB_240)
	(set g_music_120_10 true)
	(set g_music_120_11 true)
	
	(boss);Is this where this goes?
	(set g_music_120_10 false)
	(set g_music_120_11 false)
	(wake cin_halo_activation)
)

(script dormant 120_halo_large_door03_lock
	(sleep_until (= (device_get_position 120_halo_large_door03) 1)1)
	(device_set_power 120_halo_large_door03 0)
)

(script dormant 120_07_path_to_exit
	(data_mine_set_mission_segment "120_07_path_to_exit")
	(game_save)
	(wake 120_music_13)
	(wake 120_music_14)		
	(wake exit_run_navpoint_active)
	(wake exit_run_navpoint_deactive)
	(set halo_obj_control 70)
	(game_insertion_point_unlock 1)
	(wake 120_07_destruction01)
	(wake 120_07_destruction02)
	(wake 120_07_destruction03)
	(wake 120_07_destruction04)
	(wake 120_07_destruction05)
	(wake 120_07_destruction06)
	(wake 120_07_destruction07)
	(object_create earthquake)
	(wake 120_07_ambient_background)
	(wake 120_07_c_hallway_explosions)	
	(wake md_08_cortana_hints)
	(wake outside_events)

	(sleep_until (= (device_get_position control_room_door) 0)1)
		(zone_set_trigger_volume_enable begin_zone_set:120_07_06_04_03 true)	
		(zone_set_trigger_volume_enable zone_set:120_07_06_04_03 true)		
		(device_set_position_immediate 120_halo_large_door01 1)
		(device_set_power 120_halo_large_door01 0)
		(device_set_position_immediate 120_halo_large_door02 1)
		(device_set_power 120_halo_large_door02 0)
		(wake obj_halo_clear)
		(wake obj_exit_set)
		(wake 120_halo_large_door03_lock)	
		(device_set_position 120_halo_large_door03 1)
		(sleep 30)
		(ai_place 120_07_infection01)
		(ai_place 120_07_combat01)

	(sleep_until (volume_test_players 120_07_hall_explosion04)1)
		(ai_place 120_07_infection02)

	(sleep_until (volume_test_players 120_07_hall_explosion12) 1)
		(ai_place 120_07_cliff_sentinel00)

	(sleep_until (volume_test_players 120_07_outside_trig) 5)
		(wake md_07_3_cortana_hints)
		(if (and 	
				(game_is_cooperative)
				(= (game_difficulty_get_real) legendary)
				(= (game_insertion_point_get) 0)
			)
			(begin
				(ai_place sassy_egg/ghost01)
				(ai_place sassy_egg/ghost02)
				(ai_place sassy_egg/ghost03)
				(ai_place sassy_egg/ghost04)		
			)
		)	
		(wake c_shape01_navpoint_active)
		(set halo_obj_control 71)
		(ai_place 120_07_cliff01)
		(ai_place 120_07_cliff01_infection)
		(ai_place 120_07_cliff_sentinel01)	
		(ai_place 120_07_cliff02)
		(ai_place 120_07_cliff02_infection)
		(ai_place 120_07_cliff_sentinel02)	
		(ai_place 120_07_cliff03)
		(ai_place 120_07_cliff_sentinel03)
		(ai_place 120_07_cliff04)

	(sleep_until (volume_test_players 120_07_cliff_section_start) 5)
	(ai_cannot_die arbiter_trench/actor FALSE)
	(set halo_obj_control 72)

	
	(sleep_until (volume_test_players 120_07_cliff_section01) 5)
	(set halo_obj_control 73)
;	(wake md_gravemind04)		

	(sleep_until (volume_test_players 120_07_cliff_section02) 5)
	(set halo_obj_control 74)
	(sleep_until (volume_test_players 120_07_cliff_section03) 5)
	(set halo_obj_control 75)
	
	(sleep_until (volume_test_players 120_07_c_hw_section_start)5)
	
	; wake gravemind dialogue 
	(wake md_gravemind03)
	
	(sleep_forever md_07_3_cortana_hints)
	(game_save)
	(ai_set_objective arbiter_trench c_hallway_obj_ext)		
	(ai_place 120_07_c_hwy_sentinels 6)
	(ai_place 120_07_c_hwy_combat 6)

	(sleep_until (volume_test_players 120_07_c_hw_section_02)5)
	(set halo_obj_control 76)
	
	(ai_place 120_07_c_hwy_carrier 5)
	
	(sleep_until (volume_test_players 120_07_c_hw_section_04)5)
	(ai_bring_forward obj_arbiter 20)	
	(ai_place 120_07_c_hwy_infection 6)
	(set halo_obj_control 77)
	
	(set g_music_120_14 true)

	(sleep_until (volume_test_players 120_07_c_hw_section_05)5)
	(ai_magically_see_players 120_07_c_hwy_infection)
	(sleep_until (volume_test_players 120_07_c_hall_end)5)
	
	(cs_run_command_script arbiter_trench arbiter_enter_hog)
	
	(sleep_until (or (= (unit_in_vehicle (player0)) TRUE)
				(= (unit_in_vehicle (player1)) TRUE)	
				(= (unit_in_vehicle (player2)) TRUE)
				(= (unit_in_vehicle (player3)) TRUE))5)
	(set g_music_120_13 false)

	(set good_guys_talking TRUE)
	(sleep 15)
	(if dialogue (print "CORTANA: Come on, Spartan! Go, go, go!"))
	(sleep (ai_play_line_on_object NONE 120MF_120))
	(set good_guys_talking FALSE)	
				
)
(script command_script arbiter_enter_hog
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location warthog01/driver))
	(ai_vehicle_enter arbiter_trench warthog01/driver "warthog_g")
)
(script dormant 120_08_trench_run
	(data_mine_set_mission_segment "120_08_trench_run")			
	(game_save)
	(wake 120_music_15)
	
	; wake grunt love story 
	(wake md_grunty_love)
	
	(ai_bring_forward obj_arbiter 20)		
	(wake arbiter_in_vehicle)
	(wake trench_killer)
	(set halo_obj_control 80)
	(wake md_09_cortana_hints)
	(wake md_cortana_countdown)
	(sleep_forever md_08_cortana_hints)
	(sleep_forever ambient_meteors)
	(sleep_forever kill_pure_forms)		
	(sleep_forever garbage_060)		
	(sleep_forever garbage_061)
	(sleep_forever garbage_062)
;	(sleep_forever rock_fall01)
;	(sleep_forever rock_fall02)			
;	(sleep_forever rock_fall03)
	(add_recycling_volume garbage_060_trig 1 0)
	(add_recycling_volume garbage_060_trig01 1 0)
	(add_recycling_volume garbage_060_trig02 1 0)			
	(print "Trench Run! Party time!")
	(wake trench_run_events)
	(sleep_forever kill_player01)
	(sleep_forever kill_player02)
	(chud_show_arbiter_ai_navpoint FALSE)	
	(sleep_until (volume_test_players 120_08_trench_encounter_100)1)
	(game_save)
	(set g_music_120_15 true)

			
)
(script continuous kill_player01
	(sleep_until (volume_test_players ziggurat_kill_player01)5)
	(cond
		((volume_test_object ziggurat_kill_player01 (player0))
		(unit_kill (unit (player0))))
		((volume_test_objects ziggurat_kill_player01 (player1))
		(unit_kill (unit (player1))))
		((volume_test_objects ziggurat_kill_player01 (player2))
		(unit_kill (unit (player2))))
		((volume_test_objects ziggurat_kill_player01 (player3))
		(unit_kill (unit (player3))))
	)
)
(script continuous kill_player02
	(sleep_until (volume_test_players ziggurat_kill_player02)5)
	(cond
		((volume_test_objects ziggurat_kill_player02 (player0))
		(unit_kill (unit (player0))))
		((volume_test_objects ziggurat_kill_player02 (player1))
		(unit_kill (unit (player1))))
		((volume_test_objects ziggurat_kill_player02 (player2))
		(unit_kill (unit (player2))))
		((volume_test_objects ziggurat_kill_player02 (player3))
		(unit_kill (unit (player3))))
	)
)
(global short meteor_var 0)
(script static void (meteor_test (point_reference location))
	(set meteor_var (+ meteor_var 1))				
	(cond 
		((= meteor_var 1) 
		(begin
			(object_create_anew meteorite_a)
			(object_teleport_to_ai_point meteorite_a location)
			(scenery_animation_start meteorite_a objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_a))
			(object_damage_damage_section meteorite_a "main" 1)
			(sleep 1)
			(object_destroy meteorite_a)
			(print "1")
		))
		((= meteor_var 2) 
		(begin
			(object_create_anew meteorite_b)
			(object_teleport_to_ai_point meteorite_b location)
			(scenery_animation_start meteorite_b objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_b))
			(object_damage_damage_section meteorite_b "main" 1)
			(sleep 1)
			(object_destroy meteorite_b)			
			(print "2")			
		))
		((= meteor_var 3) 		
		(begin
			(object_create_anew meteorite_c)
			(object_teleport_to_ai_point meteorite_c location)
			(scenery_animation_start meteorite_c objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_c))
			(object_damage_damage_section meteorite_c "main" 1)
			(sleep 1)
			(object_destroy meteorite_c)			
			(print "3")			
		))
		((= meteor_var 4) 			
		(begin
			(object_create_anew meteorite_d)
			(object_teleport_to_ai_point meteorite_d location)
			(scenery_animation_start meteorite_d objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_d))
			(object_damage_damage_section meteorite_d "main" 1)
			(sleep 1)
			(object_destroy meteorite_d)			
			(print "4")						
		))
		((= meteor_var 5) 		
		(begin
			(object_create_anew meteorite_e)
			(object_teleport_to_ai_point meteorite_e location)
			(scenery_animation_start meteorite_e objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_e))
			(object_damage_damage_section meteorite_e "main" 1)
			(sleep 1)
			(object_destroy meteorite_e)			
			(print "5")						
		))
		((= meteor_var 6) 		
		(begin
			(object_create_anew meteorite_f)
			(object_teleport_to_ai_point meteorite_f location)
			(scenery_animation_start meteorite_f objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_f))
			(object_damage_damage_section meteorite_f "main" 1)
			(sleep 1)
			(object_destroy meteorite_f)			
			(print "6")						
		))
		((= meteor_var 7) 		
		(begin
			(object_create_anew meteorite_g)
			(object_teleport_to_ai_point meteorite_g location)
			(scenery_animation_start meteorite_g objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_g))
			(object_damage_damage_section meteorite_g "main" 1)
			(sleep 1)
			(object_destroy meteorite_g)			
			(print "7")						
		))
		((= meteor_var 8) 		
		(begin
			(object_create_anew meteorite_h)
			(object_teleport_to_ai_point meteorite_h location)
			(scenery_animation_start meteorite_h objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_h))
			(object_damage_damage_section meteorite_h "main" 1)
			(sleep 1)
			(object_destroy meteorite_h)			
			(print "8")						
		))
		((= meteor_var 9) 		
		(begin
			(object_create_anew meteorite_i)
			(object_teleport_to_ai_point meteorite_i location)
			(scenery_animation_start meteorite_i objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_i))
			(object_damage_damage_section meteorite_i "main" 1)
			(sleep 1)
			(object_destroy meteorite_i)			
			(print "9")						
		))
		((= meteor_var 10) 		
		(begin
			(object_create_anew meteorite_j)
			(object_teleport_to_ai_point meteorite_j location)
			(scenery_animation_start meteorite_j objects\scenery\flood\flood_meteor\flood_meteor "flood_meteor_rock_my_world")
			(sleep (scenery_get_animation_time meteorite_j))
			(object_damage_damage_section meteorite_j "main" 1)
			(sleep 1)
			(object_destroy meteorite_j)			
			(print "10")			
		))
	)
	(if (>= meteor_var 10) (set meteor_var 0))			
)


(script dormant 120_04_ziggurat_encounters
	(sleep_until (or (volume_test_players third_right_trig) (volume_test_players ziggurat_start_trig)) 1)
	(ai_place ziggurat_reinforcements01)
	(ai_place ziggurat_reinforcements02)	
	(ai_place ziggurat_reinforcements03)
	
	(sleep_until (volume_test_players third_right_pure_trig)1)
	(game_save)
	(ai_place 120_04_flood_pure_b01 2)
	(sleep_until (volume_test_players third_center_trig)1)
	(if (< (ai_living_count ziggurat_reinforcements01) 3) (ai_place ziggurat_reinforcements01))
	(if (< (ai_living_count ziggurat_reinforcements02) 3) (ai_place ziggurat_reinforcements02))
	(if (< (ai_living_count ziggurat_reinforcements03) 3) (ai_place ziggurat_reinforcements03))
	(sleep_until (volume_test_players third_corner_trig)1)
	(set g_music_120_06 true)
	(set g_music_120_04 false)
	(set g_music_120_045 false)	
	(if (< (ai_living_count ziggurat_reinforcements01) 3) (ai_place ziggurat_reinforcements01))
	(if (< (ai_living_count ziggurat_reinforcements02) 3) (ai_place ziggurat_reinforcements02))
	(if (< (ai_living_count ziggurat_reinforcements03) 3) (ai_place ziggurat_reinforcements03))
	
	(sleep_until (volume_test_players second_left_pure_trig)1)
	(game_save)	
	(ai_place 120_04_flood_pure_b02 2)


	(sleep_until (volume_test_players second_center_trig)1)
	(if (< (ai_living_count ziggurat_reinforcements01) 2) (ai_place ziggurat_reinforcements01))
	(if (< (ai_living_count ziggurat_reinforcements02) 2) (ai_place ziggurat_reinforcements02))
	(if (< (ai_living_count ziggurat_reinforcements03) 2) (ai_place ziggurat_reinforcements03))	
	
)



(global point_reference temp_point ziggurat00/p0)

(script static void (spawnme (ai enemy) (string side))
		(cond ((= side "left")
			(begin
				(print "SPAWNING FROM LEFT")
				(sleep_until
					(begin
						(set zg_point00 (ai_random_smart_point ziggurat_finale_left 0.25 30 60))		
					(not (= zg_point00 temp_point)))
				1)
				(set temp_point zg_point00)
				(if (< (ai_nonswarm_count enemy) 1)
					(begin
						(meteor_test zg_point00)
						(ai_place enemy)
						(ai_teleport enemy zg_point00)
					)
				)
			))
			((= side "center")
			(begin
				(print "SPAWNING FROM CENTER")		
				(sleep_until
					(begin
						(set zg_point01 (ai_random_smart_point ziggurat_finale_center 0.25 30 60))		
					(not (= zg_point01 temp_point)))
				1)
				(set temp_point zg_point01)
				(if (< (ai_nonswarm_count enemy) 1)
					(begin
						(meteor_test zg_point01)												
						(ai_place enemy)
						(ai_teleport enemy zg_point01)
					)
				)
			))
			((= side "right")
			(begin
				(print "SPAWNING FROM RIGHT")		
				(sleep_until
					(begin
						(set zg_point02 (ai_random_smart_point ziggurat_finale_right 0.25 30 60))		
					(not (= zg_point02 temp_point)))
				1)
				(set temp_point zg_point02)				

				(if (< (ai_nonswarm_count enemy) 1)
					(begin
						(meteor_test zg_point02)												
						(ai_place enemy)
						(ai_teleport enemy zg_point02)
					)
				)
			))		
		)			
)

;NOTE: spawns 01-05 are elite, 06-10 are human, 11-15 are brute
; plasma_rifle
; needler
; carbine
; sword
; assault
; battle
; smg
; shotgun
; spike
; bruteshot
; excavator


(script dormant ziggurat_top_encounter
	(set wave_num 1)
	(add_recycling_volume garbage_060_trig01 5 30)		
	;================= WAVE 1 ====================
	(spawnme ziggurat_finale_left01/plasma_rifle "left")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_left02/sword "left")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_center01 1)
	(spawnme ziggurat_finale_left03/sword "left")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_center02 1)	
	(spawnme ziggurat_finale_left04/plasma_rifle "left")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_center03 1)		
	(spawnme ziggurat_finale_left08/smg "left")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_center04 1)	
	(spawnme ziggurat_finale_left010/shotgun "left")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_center05 1)		
	(spawnme ziggurat_finale_left011/spike "left")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_left012/spike "left")
	(sleep (random_range 15 45))	
	(spawnme ziggurat_finale_left06/battle "left")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_left07/battle "left")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_left013/bruteshot "left")
	(sleep (random_range 15 45))	
	(spawnme ziggurat_finale_left05/needler "left")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_left_boss "left")	
	(sleep_until (< (ai_nonswarm_count all) 5)30 300)
	(wake kill_stragglers_left)
	(wake kill_pureform_finale_left)	
	(sleep_until (< (ai_nonswarm_count all) 5)30 300)
	(sleep_forever kill_stragglers_left)
	(wake kill_pureform_finale_left)	
	(add_recycling_volume garbage_060_trig02 15 30)
	(add_recycling_volume garbage_060_trig01 5 30)						
						
	(game_save)
	;================= WAVE 2 START ===============
	
	; if normal then wake mission dialogue 
	(if (<= (game_difficulty_get) normal) (wake md_gravemind02))
	
	(set wave_num 2)
	(ai_place 120_04_pure_finale_right01 1)	
	(spawnme ziggurat_finale_right01/needler "right")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_right02 1)	
	(spawnme ziggurat_finale_right02/needler "right")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_right03 1)	
	(spawnme ziggurat_finale_right05/plasma_rifle "right")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_right04 1)	
	(spawnme ziggurat_finale_right012/spike "right")
	(sleep (random_range 15 45))
	(ai_place 120_04_pure_finale_right05 1)						
	(spawnme ziggurat_finale_right013/spike "right")
	(sleep (random_range 15 45))	
	(spawnme ziggurat_finale_right09/assault "right")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_right010/assault "right")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_right011/bruteshot "right")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_right06/shotgun "right")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_right07/shotgun "right")
	(sleep (random_range 15 45))	
	(spawnme ziggurat_finale_right014/excavator "right")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_right015/excavator "right")
	(sleep (random_range 15 45))
	(spawnme ziggurat_finale_right_boss "right")	
	(add_recycling_volume garbage_060_trig02 15 30)
	(add_recycling_volume garbage_060_trig01 5 30)
	(sleep_until (< (ai_nonswarm_count all) 5)30 300)
	(wake kill_pureform_finale_right)
	(wake kill_stragglers_right)
	(sleep_until (< (ai_nonswarm_count all) 5)30 300)
	(sleep_forever kill_stragglers_right)
	(sleep_forever kill_pureform_finale_right)	
	(game_save)
	(if (> (game_difficulty_get_real) normal)
		(begin
			(sleep_until (< (ai_nonswarm_count all) 10)30 300)
			
			; wake gravemind dialogue 
			(wake md_gravemind02)
								
			(ai_place 120_04_pure_finale_center01 1)			
			(spawnme ziggurat_finale_center01/plasma_rifle "center")
			(sleep (random_range 15 45))
			(ai_place 120_04_pure_finale_center02 1)						
			(spawnme ziggurat_finale_center011/excavator "center")
			(sleep (random_range 15 45))
			(ai_place 120_04_pure_finale_center03 1)						
			(spawnme ziggurat_finale_center08/shotgun "center")
			(sleep (random_range 15 45))
			(ai_place 120_04_pure_finale_center04 1)						
			(spawnme ziggurat_finale_center09/smg "center")
			(sleep (random_range 15 45))
			(ai_place 120_04_pure_finale_center05 1)									
			(spawnme ziggurat_finale_center06/battle "center")
			(sleep (random_range 15 45))
			(spawnme ziggurat_finale_center014/spike "center")
			(sleep (random_range 15 45))
			(spawnme ziggurat_finale_center013/bruteshot "center")
			(sleep (random_range 15 45))
			(spawnme ziggurat_finale_center07/battle "center")
			(sleep (random_range 15 45))			
			(spawnme ziggurat_finale_center_boss "center")
			(add_recycling_volume garbage_060_trig02 15 30)
			(add_recycling_volume garbage_060_trig01 5 30)					
		)
		(begin
			(ai_place 120_04_pure_finale_center01 1)
			(ai_place 120_04_pure_finale_center02 1)			
			(ai_place 120_04_pure_finale_center03 1)			
			(ai_place 120_04_pure_finale_center04 1)			
			(ai_place 120_04_pure_finale_center05 1)
		)
	)
	
	(sleep_until (AND (< (ai_nonswarm_count ziggurat_finale_left)1)
				   (< (ai_nonswarm_count ziggurat_finale_center)1)
				   (< (ai_nonswarm_count ziggurat_finale_right)1)
			)30 900)
	(kill_volume_enable kill_final_pure_forms_trig)		
	(wake kill_all_end)
	(sleep_until (AND (< (ai_nonswarm_count ziggurat_finale_left)1)
				   (< (ai_nonswarm_count ziggurat_finale_center)1)
				   (< (ai_nonswarm_count ziggurat_finale_right)1)
				   (< (ai_living_count ziggurat_pureforms)1)
			)
	30 1800)
	(ai_kill_silent all)
	(set wave_num 7)	

)
(global short wave_num 0)

(script dormant garbage_060
	(sleep_until
		(begin
	(add_recycling_volume garbage_060_trig 1 1)
		FALSE)
	)
)
(script dormant garbage_061
	(sleep_until
		(begin
	(add_recycling_volume garbage_060_trig01 1 10)
		FALSE)
	300)
)
(script dormant garbage_062
	(sleep_until
		(begin
	(add_recycling_volume garbage_060_trig02 1 35)
		FALSE)
	300)
)

(script dormant outside_events
	(sleep_until (volume_test_players 120_07_outside_trig)5)
	(wake garbage_060)		
	(wake garbage_061)
	(wake garbage_062)
;	(wake rock_fall01)
;	(wake rock_fall02)
;	(wake rock_fall03)
	(device_set_power c_hallway_door 1)
	(device_set_position c_hallway_door 1)
	(sleep_until (= (device_get_position c_hallway_door) 1)1)
	(device_set_power c_hallway_door 0)	
)

(global short clock_var 0)

(script static void clock
	(sleep_until
		(begin
			(if (volume_test_players ziggurat_final_trig)
				(set clock_var (+ clock_var 1))
			)
			
			(or (>= clock_var 60) ; change this number to increase/decrease the top battle time
				(and (>= (ai_spawn_count exterior_meteorites) combat_total) 
					(< (ai_nonswarm_count exterior_meteorites) 1)
					(>= (ai_spawn_count ziggurat_pureforms) pure_total)
					(< (ai_living_count ziggurat_pureforms) 1)					
				)
			))
	30)
	(print "ENCOUNTER DONE")
)

(script dormant sentinel_encounter
	(ai_place sentinel_right00 2)
	(ai_place sentinel_left00 2)
;	(ai_prefer_target_team sentinels flood)
;	(wake md_04_ziggurat_exterior)
	(set g_music_120_04 true)	; the dialog was cut here, so we're calling the music here anyways
	(sound_looping_set_alternate levels\solo\120_halo\music\120_music_03 TRUE)
	
	(sleep_until (OR (volume_test_players third_right_trig) (volume_test_players third_left_trig) (volume_test_players third_center_trig)) 5)
	(wake sentinel_right_spawner)
	(wake sentinel_left_spawner)
)
(global point_reference zg_point00 ziggurat00/p0)
(global point_reference zg_point01 ziggurat01/p0)
(global point_reference zg_point02 ziggurat02/p0)
(global point_reference zg_point03 ziggurat03/p0)
(global point_reference zg_point04 ziggurat04/p0)
(global point_reference zg_point05 ziggurat05/p0)
(global point_reference zg_point06 ziggurat06/p0)
(global point_reference zg_point07 ziggurat07/p0)
(global point_reference zg_point08 ziggurat08/p0)


(script dormant test_meteor_test
	(sleep_until
		(begin
			(set zg_point01 (ai_random_smart_point ziggurat01 0.25 30 60))
			(meteor_test zg_point01)
			(set zg_point02 (ai_random_smart_point ziggurat02 0.25 30 60))
			(meteor_test zg_point02)
			(set zg_point03 (ai_random_smart_point ziggurat02 0.25 30 60))
			(meteor_test zg_point03)
			(set zg_point04 (ai_random_smart_point ziggurat02 0.25 30 60))
			(meteor_test zg_point04)
			(set zg_point05 (ai_random_smart_point ziggurat02 0.25 30 60))
			(meteor_test zg_point05)
			(set zg_point06 (ai_random_smart_point ziggurat02 0.25 30 60))
			(meteor_test zg_point06)
			(set zg_point07 (ai_random_smart_point ziggurat02 0.25 30 60))
			(meteor_test zg_point07)
			(set zg_point08 (ai_random_smart_point ziggurat02 0.25 30 60))
			(meteor_test zg_point08)																				
			(print "NEXT ONE")
		false)
	90)
)

(script dormant combat_encounter
	(sleep_until (volume_test_players third_right_trig) 5)

	(set zg_point01 (ai_random_smart_point ziggurat01 0.25 30 60))
	(meteor_test zg_point01)		
	(ai_place ziggurat_combat_01 1)
	(ai_teleport ziggurat_combat_01 zg_point01)
	
	(sleep (random_range 30 90))
	
	(set zg_point02 (ai_random_smart_point ziggurat02 0.25 30 60))
	(meteor_test zg_point02)			
	(ai_place ziggurat_combat_02 1)
	(ai_teleport ziggurat_combat_02 zg_point02)
	
	(sleep_until (volume_test_players third_center_trig) 5)

	(set zg_point03 (ai_random_smart_point ziggurat03 0.25 30 60))
	(meteor_test zg_point03)			
	(ai_place ziggurat_combat_03 1)
	(ai_teleport ziggurat_combat_03 zg_point03)

	(sleep_until (volume_test_players third_left_trig) 5)

	(set zg_point04 (ai_random_smart_point ziggurat04 0.25 30 60))
	(meteor_test zg_point04)			
	(ai_place ziggurat_combat_04 1)
	(ai_teleport ziggurat_combat_04 zg_point04)

	
	(sleep (random_range 30 90))

	(set zg_point05 (ai_random_smart_point ziggurat05 0.25 30 60))
	(meteor_test zg_point05)			
	(ai_place ziggurat_combat_05 1)
	(ai_teleport ziggurat_combat_05 zg_point05)

	
	(sleep_until (volume_test_players second_left_trig) 5)
	
	(set zg_point06 (ai_random_smart_point ziggurat06 0.25 30 60))
	(meteor_test zg_point06)			
	(ai_place ziggurat_combat_06 1)
	(ai_teleport ziggurat_combat_06 zg_point06)

	(sleep (random_range 30 90))

	(set zg_point07 (ai_random_smart_point ziggurat07 0.25 30 60))
	(meteor_test zg_point07)			
	(ai_place ziggurat_combat_07 1)
	(ai_teleport ziggurat_combat_07 zg_point07)
		
	(sleep_until (volume_test_players second_right_trig) 5)

	(set zg_point08 (ai_random_smart_point ziggurat08 0.25 30 60))
	(meteor_test zg_point08)				
	(ai_place ziggurat_combat_08 1)
	(ai_teleport ziggurat_combat_08 zg_point08)
	
)

(script dormant sentinel_right_spawner
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count sentinel_right00) 2))
			(ai_place sentinel_right00)
			(sleep 60)			
			(unit_close sentinel_emitter_right00)
			(unit_close sentinel_emitter_right01)
			(unit_close sentinel_emitter_right02)
			(unit_close sentinel_emitter_right03)
			
		;	(ai_prefer_target_team sentinels flood)					
			(sleep 300)										
		(> (ai_spawn_count sentinel_right) 10))
	)
)

(script dormant sentinel_left_spawner
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count sentinel_left00) 2))
			(ai_place sentinel_left00)
			(sleep 60)
			(unit_close sentinel_emitter_left00)
			(unit_close sentinel_emitter_left01)
			(unit_close sentinel_emitter_left02)
			(unit_close sentinel_emitter_left03)			
;			(ai_prefer_target_team sentinels flood)										
			(sleep 300)								
		(> (ai_spawn_count sentinel_left) 10))
	)
)
(global short pure_total 18)

(script dormant pure_form_attacks
	(sleep_until
		(begin
			(sleep_until (< (ai_spawn_count ziggurat_pureforms) pure_total))
			(cond
				((and (< (ai_living_count 120_04_flood_pure_a01) 1)
					 (< (ai_living_count top_pure_forms) 8))
					(sleep (random_range 120 240))			
					(ai_place 120_04_flood_pure_a01 1))
				((and (< (ai_living_count 120_04_flood_pure_a02) 1)
					 (< (ai_living_count top_pure_forms) 8))		
					(sleep (random_range 120 240))			
					(ai_place 120_04_flood_pure_a02 1))
				((and (< (ai_living_count 120_04_flood_pure_a03) 1)
					 (< (ai_living_count top_pure_forms) 8))			
					(sleep (random_range 240 480))			
					(ai_place 120_04_flood_pure_a03 1))
				((and (< (ai_living_count 120_04_flood_pure_a04) 1)
					 (< (ai_living_count top_pure_forms) 8))
					(sleep (random_range 240 480))			
					(ai_place 120_04_flood_pure_a04 1))
				((and (< (ai_living_count 120_04_flood_pure_a05) 1)
					 (< (ai_living_count top_pure_forms) 8))
					(sleep (random_range 480 960))				
					(ai_place 120_04_flood_pure_a05 1))
				((and (< (ai_living_count 120_04_flood_pure_a06) 1)
					(< (ai_living_count top_pure_forms) 8))
					(sleep (random_range 480 960))				
					(ai_place 120_04_flood_pure_a06 1))											
			)
		FALSE)
	)					
)
(global short random_num 0)
(script command_script kill_pure
	(cs_enable_moving TRUE)
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)
	(cs_force_combat_status 1)	
	(sleep 120)
	(sleep_until
		(OR	
			(volume_test_objects pureform_teleport_trig (ai_get_object ai_current_actor ))
			(AND
				(= (objects_can_see_object (players) (list_get (ai_actors ai_current_actor) 1) 15) FALSE)
				(> (objects_distance_to_object (players) (list_get (ai_actors ai_current_actor) 1)) 10)
			)
		)5)
		(set random_num (random_range 0 2))
		(if (= random_num 0)
		(ai_teleport ai_current_actor pureform_teleport/p0)
		(ai_teleport ai_current_actor pureform_teleport/p1)
		)		
		(cs_queue_command_script ai_current_actor kill_pure)
		(print "PUREFORM TELEPORTED FROM NEGLECT!")
					
)

(script command_script top_pure
;	(cs_enable_moving TRUE)
;	(cs_enable_looking FALSE)
;	(cs_enable_targeting FALSE)
;	(cs_force_combat_status 1)	
;	(sleep_until (volume_test_objects ziggurat_top_trig (ai_get_object ai_current_actor ))1)
	(ai_migrate ai_current_actor top_pure_forms)			
)


(script command_script save_pure
	(sleep 1)
)
(script dormant teleport_players
; teleporting the players from a temp area (bsp 000) to the final starting points
	(sleep_until (volume_test_players teleport_players_trig)1)
	
	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)
	(object_teleport (player2) player2_start)
	(object_teleport (player3) player3_start)
	(camera_control off)
	(cinematic_stop)
	(fade_in 0 0 0 15)
)

(global point_reference point01 exterior02/p0)
(global point_reference lastpoint01 exterior02/p2)
(global point_reference point02 exterior02/p1)
(global short infection_number 1)
(global short combat_number 1)
(global short combat_timer 0)
(global short number_var 1) ; the amount of time it waits to throw another random meteorite
(global boolean timer_paused FALSE)
(global short combat_total 40)

(script dormant flood_timer
	(cond 
		((= (game_difficulty_get_real) easy) (set number_var 120))	
		((= (game_difficulty_get_real) normal) (set number_var 120))
		((= (game_difficulty_get_real) heroic) (set number_var 60))
		((= (game_difficulty_get_real) legendary) (set number_var 60))		
	)			
	(sleep_until
		(begin
			(if (= timer_paused FALSE)
				(begin
					(print "timer activated")
					(set combat_timer (+ combat_timer 1))
				)
				(begin
					(print "timer reset")
					(set combat_timer 0)
				)
			)
			(if (= combat_timer number_var)
				(begin
				(game_save)
					(if (not valley_bool)
						(exterior_encounter02)					
					)
					(set combat_timer 0)					
				)
			)
		FALSE)
	30)
)

(script static void exterior_encounter
	(if (< (+ (ai_nonswarm_count all) (/ (ai_swarm_count all) 2)) 35)		
		(begin
				(sleep_until
					(begin
						(set point01 (ai_random_smart_point 
						infection_flood_points01 1 30 60))
					(!= point01 lastpoint01)
					)
				)
				(sleep (random_range 0 60))		
			(cond
				((= infection_number 1)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior02)								
						(ai_teleport infection_exterior02 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 2)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior02)								
						(ai_teleport infection_exterior02 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 3)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior03)								
						(ai_teleport infection_exterior03 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 4)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior04)								
						(ai_teleport infection_exterior04 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 5)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior05)								
						(ai_teleport infection_exterior05 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 6)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior06)								
						(ai_teleport infection_exterior06 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 7)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior07)								
						(ai_teleport infection_exterior07 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 8)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior08)								
						(ai_teleport infection_exterior08 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 9)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior09)								
						(ai_teleport infection_exterior09 point01)
						(set infection_number (+ infection_number 1))
					)
				)
				((= infection_number 10)
					(begin
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point01)
						(ai_place infection_exterior10)								
						(ai_teleport infection_exterior10 point01)
						(set infection_number (+ infection_number 1))
					)
				)																		
				((= infection_number 11)
					(set infection_number 1)
				)
				(TRUE (print "THIS SHOULDN'T DO THIS"))
			)
			(print "BOOM01")
			(set lastpoint01 point01)
		)
	)		
)

(global short rand_zigg_number 1)
(global boolean valley_bool TRUE)
(script static void exterior_encounter02
	(sleep_until (< (ai_spawn_count exterior_meteorites) combat_total)1)
	(if (< (+ (ai_nonswarm_count all) (/ (ai_swarm_count all) 2)) 35)
		(begin
				(set rand_zigg_number (random_range 0 9))							
				(if (= valley_bool FALSE)		
					(begin
						(cond
							((= rand_zigg_number 0)
								(set point02 (ai_random_smart_point 
								ziggurat00 1 15 30))
							)												
							((= rand_zigg_number 1)
								(set point02 (ai_random_smart_point 
								ziggurat01 1 15 30))
							)
							((= rand_zigg_number 2)
								(set point02 (ai_random_smart_point 
								ziggurat02 1 15 30))							
							)
							((= rand_zigg_number 3)
								(set point02 (ai_random_smart_point 
								ziggurat03 1 15 30))
							)
							((= rand_zigg_number 4)
								(set point02 (ai_random_smart_point 
								ziggurat04 1 15 30))
							)
							((= rand_zigg_number 5)
								(set point02 (ai_random_smart_point 
								ziggurat05 1 15 30))
							)
							((= rand_zigg_number 6)
								(set point02 (ai_random_smart_point 
								ziggurat06 1 15 30))
							)
							((= rand_zigg_number 7)
							(set point02 (ai_random_smart_point 
								ziggurat07 1 15 30))
							)
							((= rand_zigg_number 8)
								(set point02 (ai_random_smart_point 
								ziggurat08 1 15 30))
							)
							(TRUE
								(print "HOLYCRAP THIS iS THE WRONG NUMBER")							
							)
						)	
					)
				)
				(sleep (random_range 0 30))							
				(cond		
					((= combat_number 1)
						(if valley_bool
							(ai_place flood_exterior01 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_01 (random_range 1 3))								
								(ai_teleport ziggurat_combat_01 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 2)
						(if valley_bool
							(ai_place flood_exterior02 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_02 (random_range 1 3))								
								(ai_teleport ziggurat_combat_02 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 3)
						(if valley_bool

								(ai_place flood_exterior03 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_03 (random_range 1 3))								
								(ai_teleport ziggurat_combat_03 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 4)
						(if valley_bool
							(ai_place flood_exterior04 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_04 (random_range 1 3))								
								(ai_teleport ziggurat_combat_04 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 5)
						(if valley_bool
							(ai_place flood_exterior05 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_05 (random_range 1 3))								
								(ai_teleport ziggurat_combat_05 point02)
		
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 6)
						(if valley_bool
							(ai_place flood_exterior06 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_06 (random_range 1 3))								
								(ai_teleport ziggurat_combat_06 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 7)
						(if valley_bool
							(ai_place flood_exterior07 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_07 (random_range 1 3))
								(ai_teleport ziggurat_combat_07 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 8)
						(if valley_bool
							(ai_place flood_exterior08 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_08 (random_range 1 3))								
								(ai_teleport ziggurat_combat_08 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 9)
						(if valley_bool
							(ai_place flood_exterior09 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_09 (random_range 1 3))								
								(ai_teleport ziggurat_combat_09 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 10)
						(if valley_bool
							(ai_place flood_exterior10 (random_range 1 3))								
							(begin
								(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" point02)
								(ai_place ziggurat_combat_10 (random_range 1 3))								
								(ai_teleport ziggurat_combat_10 point02)
							)
						)							
						(set combat_number (+ combat_number 1))
							
					)
					((= combat_number 11)
						(set combat_number 1)
		
					)
					(TRUE (print "THIS SHOULDN'T DO THIS"))
				)						
			(print "BOOM02")
		)
	)
)

(script dormant ambient_meteors
	(sleep_until
		(begin
			(cond 
				((volume_test_players valley_volume01)
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points02)
				(sleep (random_range 30 90))						
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points03)
				(sleep (random_range 30 90))
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points04)
				(sleep (random_range 30 90))									
				)
				((volume_test_players valley_volume02)
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points04)
				(sleep (random_range 30 90))						
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points01)
				(sleep (random_range 30 90))
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points03)
				(sleep (random_range 30 90))									
				)
				((volume_test_players valley_volume03)
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points02)
				(sleep (random_range 30 90))						
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points01)
				(sleep (random_range 30 90))
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points04)
				(sleep (random_range 30 90))										
				)
				((volume_test_players valley_volume04)
				(effect_new_random 
				"fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points01)
				(sleep (random_range 30 90))						
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points02)
				(sleep (random_range 30 90))
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points03)
				(sleep (random_range 30 90))														
				)
				(TRUE (effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points01)
				(sleep (random_range 30 90))						
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points02)
				(sleep (random_range 30 90))
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points03)
				(sleep (random_range 30 90))
				(effect_new_random "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" combat_flood_points04)
				(sleep (random_range 30 90))			
				)
			)
		FALSE)
	)
)

(global point_reference ex_point01 exterior02/p0)
(global point_reference ex_point02 exterior02/p0)
(global point_reference ex_point03 exterior03/p0)
(global point_reference ex_point04 exterior04/p0)
(global point_reference ex_point05 exterior05/p0)
(global point_reference ex_point06 exterior06/p0)
(global point_reference ex_point07 exterior07/p0)
(global point_reference ex_point08 exterior08/p0)

(global short rand_valley_number 0)

(global boolean spawn_bool01 FALSE)
(global boolean spawn_bool02 FALSE)
(global boolean spawn_bool03 FALSE)
(global boolean spawn_bool04 FALSE)
(global boolean spawn_bool05 FALSE)
(global boolean spawn_bool06 FALSE)
(global boolean spawn_bool07 FALSE)
(global boolean spawn_bool08 FALSE)

(script static void (meteor_crash00 (point_reference location)(short amount))
	(set ex_point01 location)
	(meteor_test ex_point01)
	(ai_place combat_00 amount)
	(ai_teleport combat_00 ex_point01)
)

(script static void (meteor_crash01 (point_reference location)(short amount))
	(set ex_point01 (ai_random_smart_point location 1 30 90))
	(meteor_test ex_point01)
	(sleep_until
		(begin
			(set rand_valley_number (random_range 1 6))					
			(cond
				((and (= rand_valley_number 1) (< (ai_nonswarm_count combat_01) 1)) 
					(begin (ai_place combat_01 amount)
						(ai_teleport combat_01 ex_point01)
						(set spawn_bool01 TRUE)
					)
				)
				((and (= rand_valley_number 2) (< (ai_nonswarm_count combat_02) 1)) 
					(begin (ai_place combat_02 amount)
						(ai_teleport combat_02 ex_point01)
						(set spawn_bool01 TRUE)
					)
				)
				((and (= rand_valley_number 3) (< (ai_nonswarm_count combat_03) 1)) 
					(begin (ai_place combat_03 amount)
						(ai_teleport combat_03 ex_point01)
						(set spawn_bool01 TRUE)
					)
				)
				((and (= rand_valley_number 4) (< (ai_nonswarm_count combat_04) 1)) 
					(begin (ai_place combat_04 amount)
						(ai_teleport combat_04 ex_point01)
						(set spawn_bool01 TRUE)
					)
				)
				((and (= rand_valley_number 5) (< (ai_nonswarm_count combat_05) 1)) 
					(begin (ai_place combat_05 amount)
						(ai_teleport combat_05 ex_point01)
						(set spawn_bool01 TRUE)
					)
				)							
			)
		(= spawn_bool01 true))
	1)
		(set spawn_bool01 FALSE)
)
(script static void (meteor_crash02 (point_reference location)(short amount))
	(set ex_point02 (ai_random_smart_point location 2 30 90))
	(meteor_test ex_point02)	
	(sleep_until
		(begin
			(set rand_valley_number (random_range 1 6))					
			(cond
				((and (= rand_valley_number 1) (< (ai_nonswarm_count combat_06) 1)) 
					(begin (ai_place combat_06 amount)
						(ai_teleport combat_06 ex_point02)
						(set spawn_bool02 TRUE)
					)
				)
				((and (= rand_valley_number 2) (< (ai_nonswarm_count combat_07) 1)) 
					(begin (ai_place combat_07 amount)
						(ai_teleport combat_07 ex_point02)
						(set spawn_bool02 TRUE)
					)
				)
				((and (= rand_valley_number 3) (< (ai_nonswarm_count combat_08) 1)) 
					(begin (ai_place combat_08 amount)
						(ai_teleport combat_08 ex_point02)
						(set spawn_bool02 TRUE)
					)
				)
				((and (= rand_valley_number 4) (< (ai_nonswarm_count combat_09) 1)) 
					(begin (ai_place combat_09 amount)
						(ai_teleport combat_09 ex_point02)
						(set spawn_bool02 TRUE)
					)
				)
				((and (= rand_valley_number 5) (< (ai_nonswarm_count combat_10) 1)) 
					(begin (ai_place combat_10 amount)
						(ai_teleport combat_10 ex_point02)
						(set spawn_bool02 TRUE)
					)
				)							
			)
		(= spawn_bool02 true))
	1)
		(set spawn_bool02 FALSE)
)
(script static void (meteor_crash03 (point_reference location)(short amount))
	(set ex_point03 (ai_random_smart_point location 2 30 90))
	(meteor_test ex_point03)		
	(sleep_until
		(begin
			(set rand_valley_number (random_range 1 6))					
			(cond
				((and (= rand_valley_number 1) (< (ai_nonswarm_count combat_11) 1)) 
					(begin (ai_place combat_11 amount)
						(ai_teleport combat_11 ex_point03)
						(set spawn_bool03 TRUE)
					)
				)
				((and (= rand_valley_number 2) (< (ai_nonswarm_count combat_12) 1)) 
					(begin (ai_place combat_12 amount)
						(ai_teleport combat_12 ex_point03)
						(set spawn_bool03 TRUE)
					)
				)
				((and (= rand_valley_number 3) (< (ai_nonswarm_count combat_13) 1)) 
					(begin (ai_place combat_13 amount)
						(ai_teleport combat_13 ex_point03)
						(set spawn_bool03 TRUE)
					)
				)
				((and (= rand_valley_number 4) (< (ai_nonswarm_count combat_14) 1)) 
					(begin (ai_place combat_14 amount)
						(ai_teleport combat_14 ex_point03)
						(set spawn_bool03 TRUE)
					)
				)
				((and (= rand_valley_number 5) (< (ai_nonswarm_count combat_15) 1)) 
					(begin (ai_place combat_15 amount)
						(ai_teleport combat_15 ex_point03)
						(effect_new_at_ai_point "fx\scenery_fx\explosions\human_explosion_large\human_explosion_large" ex_point03)
						(set spawn_bool03 TRUE)
					)
				)							
			)
		(= spawn_bool03 true))
	1)
		(set spawn_bool03 FALSE)
)
(script static void (meteor_crash04 (point_reference location) (short amount))
	(set ex_point04 (ai_random_smart_point location 2 30 90))
	(meteor_test ex_point04)			
	(sleep_until
		(begin
			(set rand_valley_number (random_range 1 6))					
			(cond
				((and (= rand_valley_number 1) (< (ai_nonswarm_count combat_16) 1)) 
					(begin (ai_place combat_16 amount)
						(ai_teleport combat_16 ex_point04)
						(set spawn_bool04 TRUE)
					)
				)
				((and (= rand_valley_number 2) (< (ai_nonswarm_count combat_17) 1)) 
					(begin (ai_place combat_17 amount)
						(ai_teleport combat_17 ex_point04)
						(set spawn_bool04 TRUE)
					)
				)
				((and (= rand_valley_number 3) (< (ai_nonswarm_count combat_18) 1)) 
					(begin (ai_place combat_18 amount)
						(ai_teleport combat_18 ex_point04)
						(set spawn_bool04 TRUE)
					)
				)
				((and (= rand_valley_number 4) (< (ai_nonswarm_count combat_19) 1)) 
					(begin (ai_place combat_19 amount)
						(ai_teleport combat_19 ex_point04)
						(set spawn_bool04 TRUE)
					)
				)
				((and (= rand_valley_number 5) (< (ai_nonswarm_count combat_20) 1)) 
					(begin (ai_place combat_20 1)
						(ai_teleport combat_20 ex_point04)
						(set spawn_bool04 TRUE)
					)
				)							
			)
		(= spawn_bool04 true))
	1)
		(set spawn_bool04 FALSE)
)
(script static void (meteor_crash05 (point_reference location)(short amount))
	(set ex_point05 (ai_random_smart_point location 2 30 90))
	(meteor_test ex_point05)			
	(sleep_until
		(begin
			(set rand_valley_number (random_range 1 6))					
			(cond
				((and (= rand_valley_number 1) (< (ai_nonswarm_count combat_21) 1)) 
					(begin (ai_place combat_21 amount)
						(ai_teleport combat_21 ex_point05)
						(set spawn_bool05 TRUE)
					)
				)
				((and (= rand_valley_number 2) (< (ai_nonswarm_count combat_22) 1)) 
					(begin (ai_place combat_22 amount)
						(ai_teleport combat_22 ex_point05)
						(set spawn_bool05 TRUE)
					)
				)
				((and (= rand_valley_number 3) (< (ai_nonswarm_count combat_23) 1)) 
					(begin (ai_place combat_23 amount)
						(ai_teleport combat_23 ex_point05)
						(set spawn_bool05 TRUE)
					)
				)
				((and (= rand_valley_number 4) (< (ai_nonswarm_count combat_24) 1)) 
					(begin (ai_place combat_24 amount)
						(ai_teleport combat_24 ex_point05)
						(set spawn_bool05 TRUE)
					)
				)
				((and (= rand_valley_number 5) (< (ai_nonswarm_count combat_25) 1)) 
					(begin (ai_place combat_25 amount)
						(ai_teleport combat_25 ex_point05)
						(set spawn_bool05 TRUE)
					)
				)							
			)
		(= spawn_bool05 true))
	1)
		(set spawn_bool05 FALSE)
)
(script static void (meteor_crash06 (point_reference location)(short amount))
	(set ex_point06 (ai_random_smart_point location 2 30 90))
	(meteor_test ex_point06)			
	(sleep_until
		(begin
			(set rand_valley_number (random_range 1 6))					
			(cond
				((and (= rand_valley_number 1) (< (ai_nonswarm_count combat_26) 1)) 
					(begin (ai_place combat_26 amount)
						(ai_teleport combat_26 ex_point06)
						(set spawn_bool06 TRUE)
					)
				)
				((and (= rand_valley_number 2) (< (ai_nonswarm_count combat_27) 1)) 
					(begin (ai_place combat_27 amount)
						(ai_teleport combat_27 ex_point06)
						(set spawn_bool06 TRUE)
					)
				)
				((and (= rand_valley_number 3) (< (ai_nonswarm_count combat_28) 1)) 
					(begin (ai_place combat_28 amount)
						(ai_teleport combat_28 ex_point06)
						(set spawn_bool06 TRUE)
					)
				)
				((and (= rand_valley_number 4) (< (ai_nonswarm_count combat_29) 1)) 
					(begin (ai_place combat_29 amount)
						(ai_teleport combat_29 ex_point06)
						(set spawn_bool06 TRUE)
					)
				)
				((and (= rand_valley_number 5) (< (ai_nonswarm_count combat_30) 1)) 
					(begin (ai_place combat_30 amount)
						(ai_teleport combat_30 ex_point06)
						(set spawn_bool06 TRUE)
					)
				)							
			)
		(= spawn_bool06 true))
	1)
		(set spawn_bool06 FALSE)
)
(script static void (meteor_crash07 (point_reference location)(short amount))
	(set ex_point07 (ai_random_smart_point location 2 30 90))
	(meteor_test ex_point07)				
	(sleep_until
		(begin
			(set rand_valley_number (random_range 1 6))					
			(cond
				((and (= rand_valley_number 1) (< (ai_nonswarm_count combat_31) 1)) 
					(begin (ai_place combat_31 amount)
						(ai_teleport combat_31 ex_point07)
						(set spawn_bool07 TRUE)
					)
				)
				((and (= rand_valley_number 2) (< (ai_nonswarm_count combat_32) 1)) 
					(begin (ai_place combat_32 amount)
						(ai_teleport combat_32 ex_point07)
						(set spawn_bool07 TRUE)
					)
				)
				((and (= rand_valley_number 3) (< (ai_nonswarm_count combat_33) 1)) 
					(begin (ai_place combat_33 amount)
						(ai_teleport combat_33 ex_point07)
						(set spawn_bool07 TRUE)
					)
				)
				((and (= rand_valley_number 4) (< (ai_nonswarm_count combat_34) 1)) 
					(begin (ai_place combat_34 amount)
						(ai_teleport combat_34 ex_point07)
						(set spawn_bool07 TRUE)
					)
				)
				((and (= rand_valley_number 5) (< (ai_nonswarm_count combat_35) 1)) 
					(begin (ai_place combat_35 amount)
						(ai_teleport combat_35 ex_point07)
						(set spawn_bool07 TRUE)
					)
				)							
			)
		(= spawn_bool07 true))
	1)
		(set spawn_bool07 FALSE)
)
(script static void (meteor_crash08 (point_reference location)(short amount))
	(set ex_point08 (ai_random_smart_point location 2 30 90))
	(meteor_test ex_point08)			
	(sleep_until
		(begin
			(set rand_valley_number (random_range 1 6))					
			(cond
				((and (= rand_valley_number 1) (< (ai_nonswarm_count combat_36) 1)) 
					(begin (ai_place combat_36 amount)
						(ai_teleport combat_36 ex_point08)
						(set spawn_bool08 TRUE)
					)
				)
				((and (= rand_valley_number 2) (< (ai_nonswarm_count combat_37) 1)) 
					(begin (ai_place combat_37 amount)
						(ai_teleport combat_37 ex_point08)
						(set spawn_bool08 TRUE)
					)
				)
				((and (= rand_valley_number 3) (< (ai_nonswarm_count combat_38) 1)) 
					(begin (ai_place combat_38 amount)
						(ai_teleport combat_38 ex_point08)
						(set spawn_bool08 TRUE)
					)
				)
				((and (= rand_valley_number 4) (< (ai_nonswarm_count combat_39) 1)) 
					(begin (ai_place combat_39 amount)
						(ai_teleport combat_39 ex_point08)
						(set spawn_bool08 TRUE)
					)
				)
				((and (= rand_valley_number 5) (< (ai_nonswarm_count combat_40) 1)) 
					(begin (ai_place combat_40 amount)
						(ai_teleport combat_40 ex_point08)
						(set spawn_bool08 TRUE)
					)
				)							
			)
		(= spawn_bool08 true))
	1)
		(set spawn_bool08 FALSE)
)


(script dormant crash00
	(set timer_paused TRUE)
	(meteor_crash00 exterior00/p0 1)
	(sleep 30)
	(meteor_crash08 exterior02 2)
	(sleep (random_range 15 45))
	(meteor_crash01 exterior05 1)
	(sleep (random_range 15 45))	
	(meteor_crash02 exterior05 2)
	(sleep (random_range 15 45))	
	(meteor_crash03 exterior02 1)
	(sleep 120)
	(meteor_crash04 exterior08 2)
	(sleep (random_range 15 45))	
	(meteor_crash05 exterior12 2)
	(sleep (random_range 15 45))	
	(meteor_crash06 exterior04 1)
	
	(set timer_paused FALSE)
	(sleep 300)
	(sleep_until (volume_test_players valley_floor_trig01)5)
	(game_save)
	(set timer_paused TRUE)
	(meteor_crash07 exterior04 2)
	(sleep (random_range 15 45))
	(meteor_crash08 exterior08 1)
	(sleep (random_range 15 45))	
	(meteor_crash01 exterior12 2)		
	(sleep 120)
	(meteor_crash01 exterior03 2)
	(sleep (random_range 15 45))	
	(meteor_crash02 exterior14 1)
	(sleep (random_range 15 45))	
	(meteor_crash03 exterior09 2)
	(sleep (random_range 15 45))	
	(meteor_crash04 exterior15 1)
	(sleep 120)
	(meteor_crash05 exterior06 1)
	(sleep (random_range 15 45))	
	(meteor_crash06 exterior07 1)
	(set timer_paused FALSE)			
)

(script dormant crash01
	(sleep_until (volume_test_players valley_floor_trig02)5)
	(set timer_paused TRUE)
	(game_save)
	(meteor_crash07 exterior15 1)
	(sleep (random_range 15 45))	
	(meteor_crash08 exterior12 2)
	(sleep (random_range 15 45))	
	(meteor_crash01 exterior15 2)
	(sleep 120)
	(meteor_crash02 exterior12 1)
	(sleep (random_range 15 45))	
	(meteor_crash03 exterior03 1)
	(sleep (random_range 15 45))	
	(meteor_crash04 exterior03 2)
	(sleep (random_range 15 45))	
	(meteor_crash05 exterior16 2)
	(set timer_paused FALSE)	
	(sleep_until (volume_test_players valley_floor_trig03)5)
	(game_save)
	(set timer_paused TRUE)
	(meteor_crash06 exterior16 2)
	(sleep (random_range 15 45))	
	(meteor_crash07 exterior03 1)
	(sleep (random_range 15 45))	
	(meteor_crash08 exterior10 1)
	(sleep 120)									
	(meteor_crash01 exterior11 1)
	(sleep (random_range 15 45))	
	(meteor_crash02 exterior10 1)
	(sleep (random_range 15 45))	
	(meteor_crash03 exterior11 1)
	(set timer_paused FALSE)
)



(script dormant crash02
	(sleep_until (volume_test_players valley_floor_trig05)5)
	(set timer_paused TRUE)
	(game_save)		
	(meteor_crash04 exterior10 2)
	(sleep (random_range 15 45))	
	(meteor_crash05 exterior11 1)
	(sleep (random_range 15 45))	
	(meteor_crash06 exterior11 1)
	(sleep (random_range 15 45))	
	(meteor_crash07 exterior11 2)
	(sleep (random_range 15 45))	
	(meteor_crash08 exterior13 2)	
	(set timer_paused FALSE)
	(sleep_until (volume_test_players valley_floor_trig06)5)
	(set timer_paused TRUE)
	(game_save)	
	(meteor_crash01 exterior13 2)
	(sleep (random_range 15 45))		
	(meteor_crash02 exterior13 1)
	(sleep (random_range 15 45))	
	(meteor_crash03 exterior13 1)
	(sleep (random_range 15 45))	
	(meteor_crash04 exterior17 2)
	(sleep (random_range 15 45))	
	(meteor_crash05 exterior17 2)
	(set timer_paused FALSE)
)

(global short straggler_no 0)
(global short pureform_no 0)
(global short l_straggler_no 0)
(global short r_straggler_no 0)
(global short c_straggler_no 0)
(global short e_straggler_no 0)
(global short l_straggler_pure 0)
(global short r_straggler_pure 0)
(global short c_straggler_pure 0)

(script dormant kill_all
	(sleep_until
		(begin
			(if 
				(AND
			          (= (objects_can_see_object (players) (list_get (ai_actors all) straggler_no) 10) FALSE)
			          (> (objects_distance_to_object (players) (list_get (ai_actors all) straggler_no)) 10)
				)
					(begin
				   	  	(object_destroy (list_get (ai_actors all) straggler_no))
				     	(print "Combat Form Auto-Destroyed")
				     )			   	  
			)
			(set straggler_no (+ straggler_no 1))
			(if (> straggler_no 35)
				(set straggler_no 0)
			)
		(< (ai_nonswarm_count all) 1))
	 )
)

(script continuous kill_stragglers
	(sleep_until (or (> (ai_nonswarm_count all) 38)(> (ai_living_count all) 40))5)
	(if 
		(AND
	          (= (objects_can_see_object (players) (list_get (ai_actors exterior_meteorites) straggler_no) 15) FALSE)
	          (> (objects_distance_to_object (players) (list_get (ai_actors exterior_meteorites) straggler_no)) 10)
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors exterior_meteorites) straggler_no))
		     	(print "Combat Form Auto-Destroyed")
		     )				   	  
	)			
	(set straggler_no (+ straggler_no 1))
	(if (> straggler_no 35)
		(set straggler_no 0)
	)
)

(script continuous kill_pure_forms

	(if 
		(AND
	          (= (objects_can_see_object (players) (list_get (ai_actors ziggurat_pureforms) pureform_no) 10) FALSE)
	          (> (objects_distance_to_object (players) (list_get (ai_actors ziggurat_pureforms) pureform_no)) 5)
	          (not (volume_test_objects 120_05_ziggurat_top_trig (list_get (ai_actors ziggurat_pureforms) pureform_no)))	          
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors ziggurat_pureforms) pureform_no))
		     	(print "Combat Form Auto-Destroyed")
		     )				   	  
	)			
	(set pureform_no (+ pureform_no 1))
	(if (> pureform_no 30)
		(set pureform_no 0)
	)
)


(script continuous kill_stragglers_left
	(if 
		(AND
	          (= (objects_can_see_object (players) (list_get (ai_actors ziggurat_finale_left) l_straggler_no) 10) FALSE)
	          (> (objects_distance_to_object (players) (list_get (ai_actors ziggurat_finale_left) l_straggler_no)) 5)
	          (not (volume_test_objects 120_05_ziggurat_top_trig (list_get (ai_actors ziggurat_finale_left) l_straggler_no)))	           
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors ziggurat_finale_left) l_straggler_no))
		     	(print "Combat Form Auto-Destroyed")
		     )				   	  
	)			
	(set l_straggler_no (+ l_straggler_no 1))
	(if (> l_straggler_no 40)
		(set l_straggler_no 0)
	)
)

(script continuous kill_stragglers_right
	(if 
		(AND
	          (= (objects_can_see_object (players) (list_get (ai_actors ziggurat_finale_right) r_straggler_no) 10) FALSE)
	          (> (objects_distance_to_object (players) (list_get (ai_actors ziggurat_finale_right) r_straggler_no)) 5)
	          (not (volume_test_objects 120_05_ziggurat_top_trig (list_get (ai_actors ziggurat_finale_right) r_straggler_no)))           	          
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors ziggurat_finale_right) r_straggler_no))
		     	(print "Combat Form Auto-Destroyed")
		     )				   	  
	)			
	(set r_straggler_no (+ r_straggler_no 1))
	(if (> r_straggler_no 40)
		(set r_straggler_no 0)
	)
)
(script continuous kill_pureform_finale_right
	(if 
		(AND
	          (= (objects_can_see_object (players) (list_get (ai_actors pureform_finale_right) r_straggler_pure) 10) FALSE)
	          (> (objects_distance_to_object (players) (list_get (ai_actors pureform_finale_right) r_straggler_pure)) 5)
	          (not (volume_test_objects 120_05_ziggurat_top_trig (list_get (ai_actors pureform_finale_right) r_straggler_pure)))           	          
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors pureform_finale_right) r_straggler_pure))
		     	(print "PureForm Auto-Destroyed")
		     )				   	  
	)			
	(set r_straggler_pure (+ r_straggler_pure 1))
	(if (> r_straggler_pure 10)
		(set r_straggler_pure 0)
	)
)
(script continuous kill_pureform_finale_left
	(if 
		(AND
	          (= (objects_can_see_object (players) (list_get (ai_actors pureform_finale_left) l_straggler_pure) 10) FALSE)
	          (> (objects_distance_to_object (players) (list_get (ai_actors pureform_finale_left) l_straggler_pure)) 5)
	          (not (volume_test_objects 120_05_ziggurat_top_trig (list_get (ai_actors pureform_finale_left) l_straggler_pure)))           	          
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors pureform_finale_left) l_straggler_pure))
		     	(print "PureForm Auto-Destroyed")
		     )				   	  
	)			
	(set l_straggler_pure (+ l_straggler_pure 1))
	(if (> l_straggler_pure 10)
		(set l_straggler_pure 0)
	)
)
(script continuous kill_pureform_finale_center
	(if 
		(AND
	          (= (objects_can_see_object (players) (list_get (ai_actors pureform_finale_center) c_straggler_pure) 10) FALSE)
	          (> (objects_distance_to_object (players) (list_get (ai_actors pureform_finale_center) c_straggler_pure)) 5)
	          (not (volume_test_objects 120_05_ziggurat_top_trig (list_get (ai_actors pureform_finale_center) c_straggler_pure)))           	          
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors pureform_finale_center) c_straggler_pure))
		     	(print "PureForm Auto-Destroyed")
		     )				   	  
	)			
	(set c_straggler_pure (+ c_straggler_pure 1))
	(if (> c_straggler_pure 10)
		(set c_straggler_pure 0)
	)
)

(script continuous kill_stragglers_center
	(if 
		(AND
	          (= (objects_can_see_object (players) (list_get (ai_actors ziggurat_finale_center) c_straggler_no) 10) FALSE)
	          (> (objects_distance_to_object (players) (list_get (ai_actors ziggurat_finale_center) c_straggler_no)) 5)
	          (not ( volume_test_objects 120_05_ziggurat_top_trig (list_get (ai_actors ziggurat_finale_center) c_straggler_no)))
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors ziggurat_finale_center) c_straggler_no))
		     	(print "Combat Form Auto-Destroyed")
		     )				   	  
	)			
	(set c_straggler_no (+ c_straggler_no 1))
	(if (> c_straggler_no 40)
		(set c_straggler_no 0)
	)
)

(script continuous kill_all_end
	(if 
		(AND
	          (> (objects_distance_to_object (players) (list_get (ai_actors all) e_straggler_no)) 10)
	          (not ( volume_test_objects 120_05_ziggurat_top_trig (list_get (ai_actors all) e_straggler_no)))	          
		)
			(begin
		   	  	(object_destroy (list_get (ai_actors all) e_straggler_no))
		     	(print "Combat Form Auto-Destroyed")
		     )			   	  
	)			
	(set e_straggler_no (+ e_straggler_no 1))
	(if (> e_straggler_no 35)
		(set e_straggler_no 0)
	)
)

(script static void (ai_magically_see_players (ai spawned_squad))
	(ai_magically_see_object spawned_squad (player0))
	(ai_magically_see_object spawned_squad (player1))	
	(ai_magically_see_object spawned_squad (player2))	
	(ai_magically_see_object spawned_squad (player3))
)

(global real faulty_door_jitter_state 0)


(script dormant ziggurat_navpoint_active
	(sleep 3600)
	(hud_activate_team_nav_point_flag player ziggurat_nav g_nav_offset)
)
(script dormant ziggurat_navpoint_deactive
	(sleep_until (<= (objects_distance_to_flag (players) ziggurat_nav) 10))
	(sleep_forever ziggurat_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player ziggurat_nav)
)
(script dormant tjm01_navpoint_active
	(sleep 900)
	(hud_activate_team_nav_point_flag player hallway_tjm01_nav g_nav_offset)
)
(script dormant tjm01_navpoint_deactive
	(sleep_until (> (device_get_position 120_halo_large_door02)0))
	(sleep_forever tjm01_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player hallway_tjm01_nav)
	(wake tjm02_navpoint_active)
	(wake tjm02_navpoint_deactive)
)

(script dormant tjm02_navpoint_active
	(sleep 900)
	(hud_activate_team_nav_point_flag player hallway_tjm02_nav g_nav_offset)
)
(script dormant tjm02_navpoint_deactive
	(sleep_until (> (device_get_position 120_halo_large_door03)0))
	(sleep_forever tjm02_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player hallway_tjm02_nav)
	(wake tjm03_navpoint_active)
	(wake tjm03_navpoint_deactive)	
)

(script dormant tjm03_navpoint_active
	(sleep 900)
	(hud_activate_team_nav_point_flag player hallway_tjm03_nav g_nav_offset)
)
(script dormant tjm03_navpoint_deactive
	(sleep_until (> (device_get_position control_room_door)0))
	(sleep_forever tjm03_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player hallway_tjm03_nav)
)

(script dormant exit_run_navpoint_active
	(sleep 1800)
	(hud_activate_team_nav_point_flag player arbiter_return_flag g_nav_offset)
)
(script dormant exit_run_navpoint_deactive
	(sleep_until (<= (objects_distance_to_flag (players) arbiter_return_flag) 10))
	(sleep_forever exit_run_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player arbiter_return_flag)
)

(script dormant c_shape01_navpoint_active
	(hud_activate_team_nav_point_flag player c_shape_nav g_nav_offset)
	(wake c_shape01_navpoint_deactive)
)
(script dormant c_shape01_navpoint_deactive
	(sleep_until (<= (objects_distance_to_flag (players) c_shape_nav) 10))
	(sleep_forever c_shape01_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player c_shape_nav)
	(wake c_shape02_navpoint_active)
	(wake c_shape02_navpoint_deactive)
)
(script dormant c_shape02_navpoint_active
	(hud_activate_team_nav_point_flag player trench_run_start_nav g_nav_offset)
	(wake c_shape02_navpoint_deactive)
)
(script dormant c_shape02_navpoint_deactive
	(sleep_until (<= (objects_distance_to_flag (players) trench_run_start_nav) 10))
	(sleep_forever c_shape02_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player trench_run_start_nav)
)
; =======================================================================================================================================================================
; =======================================================================================================================================================================
; PRIMARY OBJECTIVES  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(script dormant obj_ziggurat_set
	(sleep 270)
	(if debug (print "new objective set:"))
	(if debug (print "Get to control room!"))
	(objectives_show_up_to 0)
	(cinematic_set_chud_objective obj_0)	
	
)
(script dormant obj_ziggurat_clear
	(sleep 30)
	(if debug (print "objective complete:"))
	(if debug (print "Control room reached"))
	(objectives_finish_up_to 0)
)

; =======================================================================================================================================================================

(script dormant obj_halo_set
	(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Activate the Halo"))
	(objectives_show_up_to 1)
	(sleep 150)
	(cinematic_set_chud_objective obj_1)	
)
(script dormant obj_halo_clear
	(sleep 30)
	(if debug (print "objective complete:"))
	(if debug (print "Halo Activated"))
	(objectives_finish_up_to 1)
)

; =======================================================================================================================================================================

(script dormant obj_exit_set
	(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Get the Hell out of there!"))
	(objectives_show_up_to 2)
	(sleep 180)
	(cinematic_set_chud_objective obj_2)	
	
)
(script dormant obj_exit_clear
	(if debug (print "objective complete:"))
	(if debug (print "GAME FINISHED"))
	(objectives_finish_up_to 2)
)

;====================================================================================================================================================================================================
;============================== AWARD SKULLS ========================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_award_primary_skull
	(if	(award_skull)

		(begin
			(object_create skull_mythic)
			
			(sleep_until 
				(or
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
				)
			5)
			
			(if debug (print "award mythic skull"))
			(campaign_metagame_award_primary_skull (player0) 8)
			(campaign_metagame_award_primary_skull (player1) 8)
			(campaign_metagame_award_primary_skull (player2) 8)
			(campaign_metagame_award_primary_skull (player3) 8)
		)
	)
)


(script dormant object_management
	(sleep_until (> (player_count) 0) 1)
	(zone_set_trigger_volume_enable zone_set:120_07_06_04_03 false)
	(zone_set_trigger_volume_enable begin_zone_set:120_07_06_04_03 false)	

	(sleep_until (>= (current_zone_set) 1) 1) ;120_01_02_03
		(object_create_anew rock_slide)
		(object_destroy pelican_sparks)
	
	(sleep_until (>= (current_zone_set_fully_active) 1) 1) ;120_03_05
		(zone_set_trigger_volume_enable begin_zone_set:120_01_02_03 false)
	(sleep_until (>= (current_zone_set) 2) 1) ;120_03_05
		(device_set_position_immediate 120_halo_large_door01 0)					
		(ai_allegiance_remove player sentinel)
		(ai_allegiance_remove sentinel player)
		(ai_allegiance_remove covenant sentinel)
		(ai_allegiance_remove sentinel covenant)
		(ai_allegiance_remove human sentinel)
		(ai_allegiance_remove sentinel human)
	(sleep_until (>= (current_zone_set_fully_active) 2) 1) ;120_03_05
		(zone_set_trigger_volume_enable zone_set:120_03_05 false)
		(zone_set_trigger_volume_enable zone_set:120_01_02_03 false)		
		(zone_set_trigger_volume_enable begin_zone_set:120_03_05 false)			
	(sleep_until (>= (current_zone_set_fully_active) 3) 1) ;120_07_06_04_03
		(device_set_position_immediate control_room_door 0)
		(object_create_anew rock_slide)		
		(zone_set_trigger_volume_enable zone_set:120_00_01_02 false)
		(object_destroy flame_thrower)
		(object_destroy auto_turret01)
		(object_destroy auto_turret02)		
	(sleep_until (>= (current_zone_set) 4) 1) ;120_04_100_110
		(kill_volume_disable kill_100_01)
		(kill_volume_disable kill_100_02)
		(kill_volume_disable kill_100_02a)
		(kill_volume_disable kill_100_03)
		(kill_volume_disable kill_100_04)		
		(kill_volume_disable kill_110_01)
		(kill_volume_disable kill_110_01a)			
		(kill_volume_disable kill_110_02)
		(kill_volume_disable kill_110_03)
		(kill_volume_disable kill_110_04)
		(kill_volume_disable kill_120_04a)
		(kill_volume_disable kill_110_05)
		(kill_volume_disable kill_120_01)
		(kill_volume_disable kill_120_02)
		(kill_volume_disable kill_120_03)
		(kill_volume_disable kill_120_04)
		(kill_volume_disable kill_120_05)	
		
	(sleep_until (>= (current_zone_set_fully_active) 4) 1) ;120_04_100_110
		(wake lock_c_hallway_door)
		(object_destroy_folder trench_run_100)	
		(object_destroy_folder trench_run_100_hw)
		(object_destroy_folder trench_run_100_crates)		
		(object_destroy_folder trench_run_110_1)	
		(object_destroy_folder trench_run_110_2)			
		(object_destroy_folder trench_run_110_3)		
		(object_destroy_folder trench_run_110_4)
		(object_destroy_folder trench_run_110_hw)
		(object_destroy_folder trench_run_110_crates)
		(if (game_is_cooperative)(ai_place secret_egg02))
		(object_cannot_die (ai_vehicle_get_from_starting_location secret_egg02/01) true)
		(object_cannot_take_damage (ai_vehicle_get_from_starting_location secret_egg02/01))	
		(unit_falling_damage_disable (ai_vehicle_get_from_starting_location secret_egg02/01) true)					
			
	(sleep_until (>= (current_zone_set_fully_active) 5) 1) ;120_100_110
		(wake lock_trench_run_door)
		(if (game_is_cooperative)(ai_place secret_egg03))
		(object_cannot_die (ai_vehicle_get_from_starting_location secret_egg03/01) true)
		(object_cannot_take_damage (ai_vehicle_get_from_starting_location secret_egg03/01))
		(unit_falling_damage_disable (ai_vehicle_get_from_starting_location secret_egg03/01) true)					
					
		(if (game_is_cooperative)(ai_place secret_egg04))
		(object_cannot_die (ai_vehicle_get_from_starting_location secret_egg04/01) true)
		(object_cannot_take_damage (ai_vehicle_get_from_starting_location secret_egg04/01))
		(unit_falling_damage_disable (ai_vehicle_get_from_starting_location secret_egg04/01) true)					
	(sleep_until (>= (current_zone_set) 6) 1) ;120_110_120
		(object_destroy_folder trench_run_100_crates)
							
	(sleep_until (>= (current_zone_set_fully_active) 6) 1) ;120_110_120
		(object_destroy_folder trench_run_120_1)
		(object_destroy_folder trench_run_120_2)	
		(object_destroy_folder trench_run_120_3)
		(object_destroy_folder trench_run_120_4)
		(object_create trench_f_front)
		(object_create trench_f_mid)
		(object_create trench_f_back)
		;(sleep 1)
		(objects_attach trench_frigate marker_backelevator01 trench_f_front marker_backelevator)
		(objects_attach trench_frigate marker_backelevator02 trench_f_mid marker_backelevator)
		(objects_attach trench_frigate marker_backelevator trench_f_back marker_backelevator)
	(sleep_until (>= (current_zone_set) 7) 1) ;120_120_130
		(object_destroy_folder trench_run_110_crates)				
)           

(script dormant disable_kill_vols
		(kill_volume_disable kill_100_01)
		(kill_volume_disable kill_100_02)
		(kill_volume_disable kill_100_02a)
		(kill_volume_disable kill_100_03)
		(kill_volume_disable kill_100_04)		
		(kill_volume_disable kill_110_01)
		(kill_volume_disable kill_110_01a)	
		(kill_volume_disable kill_110_02)
		(kill_volume_disable kill_110_03)
		(kill_volume_disable kill_110_04)
		(kill_volume_disable kill_120_04a)		
		(kill_volume_disable kill_110_05)
		(kill_volume_disable kill_120_01)
		(kill_volume_disable kill_120_02)
		(kill_volume_disable kill_120_03)
		(kill_volume_disable kill_120_04)
		(kill_volume_disable kill_120_05)
		(kill_volume_disable kill_pure_forms_trig)
		(kill_volume_disable kill_final_pure_forms_trig)
)

(script dormant lock_c_hallway_door
		(device_set_power c_hallway_door 1)
		(device_set_position c_hallway_door 0)
		(sleep_until (= (device_get_position c_hallway_door) 0)1)
		(device_set_power c_hallway_door 0)
)
(script dormant lock_trench_run_door
	(device_set_position trench_run_door 0)
	(sleep_until (= (device_get_position trench_run_door) 0)1)
	(device_set_power trench_run_door 0)
)
