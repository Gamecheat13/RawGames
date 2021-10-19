;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)
(global boolean debug TRUE)
(global boolean g_play_cinematics 1)
(global short marine_pos 0)
(global boolean g_null 0)
(global boolean random_bool 0)
; insertion point index 
(global short g_insertion_index 0)
(global short base_obj_control 0)
;====================================================================================================================================================================================================
;================================================================================================================================================================================== BASE MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script static void start
	; fade out 
	(fade_out 0 0 0 0)
	
	; select insertion point 
	(cond
		((= (game_insertion_point_get) 0) (ins_command_center_start))
		((= (game_insertion_point_get) 1) (ins_loop02_begin))
		((= (game_insertion_point_get) 2) (ins_cortana_highway))
	)
)

(script startup mission_base
	; fade to black 
	(fade_out 0 0 0 0)
	
	(print_difficulty)
	(campaign_metagame_time_pause TRUE)
	(if debug (print "startup 020_base_mission"))
	(chud_show_fire_grenades FALSE)
	(chud_show_spike_grenades FALSE)
	; set allegiances 
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	(ai_allegiance human covenant)
	; temp sleeping rumble scripts
	(sleep_forever rumble_motor_pool)	
	(sleep_forever rumble_cave_a)
	(sleep_forever rumble_command_center)
	(sleep_forever rumble_hangar_a)
	(sleep_forever rumble_cortana_highway)
	(sleep_forever rumble_evac_hangar)
	(sleep_forever rumble_barracks)
	(sleep_forever rumble_sewer)
	(sleep_forever rumble_hallway_a)
	(sleep_forever rumble_highway_a)
	(sleep_forever rumble_hallway_b)
	; the game can use flashlights 
	(game_can_use_flashlights TRUE)
	(objectives_clear)
	(object_destroy elevator_evac_02)
	; startup Ai disposal
	(wake gs_award_primary_skull)	
	(wake gs_award_secondary_skull)
	(wake base_disposable_ai)
	(wake base_cleanup)
	(wake object_management)
	
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
	; Begin Command_Center Scripting
	(sleep_until (>= g_insertion_index 1))
	(if (= g_insertion_index 1) (wake 020_command_center_start))

;====

	;====
	; begin Cave_A Scripting (insertion 1) 
	(sleep_until	(or
					(volume_test_players cave_a_start_trig)
					(>= g_insertion_index 2)
				)
	1)
		; wake encounter script 
		(if (<= g_insertion_index 2) (wake 020_01_Cave_A))


;====
	; begin Highway_A Scripting (insertion 2) 

	(sleep_until	(or
					(volume_test_players highway_a_start_trig)
					(>= g_insertion_index 3)
				)
	1)
		; wake encounter script 
		(if (<= g_insertion_index 3) (wake 020_02_highway_a))

;====
	; begin hangar_a encounters (insertion 4) 
	(sleep_until	(or
					(volume_test_players hangar_a_start_trig)
					(>= g_insertion_index 4)
				)
	1)
		; wake encounter script 
		(if (<= g_insertion_index 4) (wake 020_04_hangar_a))

;====
	; begin loop01_return encounters (insertion 5) 
	(sleep_until	(or
					(and (volume_test_players loop01_return_start_trig) (= hangar_a_done true))
					(>= g_insertion_index 5)
				)
	1)
		; wake encounter script 
		(if (<= g_insertion_index 5) (wake 020_05_loop01_return))

;====
	; begin Loop02_begin vignette (insertion 6) 
	(sleep_until	(or
					(and
						(>= (device_get_position cave_a_door_command) 1)
						(volume_test_players command_exit_trig)
					)
					(volume_test_players cave_a_start_trig)					
					(>= g_insertion_index 6)
				)
	1)
		; wake encounter script 
		(if (<= g_insertion_index 6) (wake 020_05_loop02_begin))
				
;====
	; begin motor_pool encounters (insertion 7) 
	
	(sleep_until	(or
					(volume_test_players motor_pool_start_trig)
					(>= g_insertion_index 7)
				)
	1)
		; wake encounter script 
	(if (<= g_insertion_index 7) (wake 020_06_motor_pool))			

;====
	; begin sewers (insertion 8) 
	(sleep_until	(or
					(volume_test_players sewer01_trig)
					(>= g_insertion_index 8)
				)
	1)
	; wake sewer scripts
	(if (<= g_insertion_index 8) (wake 020_06_sewer))

	(sleep_until	(or
					(volume_test_players barracks_start_trig)
					(>= g_insertion_index 9)
				)
	1)
	; wake barracks
	(if (<= g_insertion_index 9) (wake 020_07_barracks))				

	(sleep_until	(or
					(volume_test_players evac_hangar_start_trig)
					(>= g_insertion_index 10)
				)
	1)
	; wake encounter script 
	(if (<= g_insertion_index 10) (wake 020_08_evac_hangar))

	(sleep_until	(or
					(volume_test_players cortana_highway_start_trig)
					(>= g_insertion_index 11)
				)
	1)
	; wake encounter script 
	(if (<= g_insertion_index 11) (wake 020_09_cortana_highway))
	
	(sleep_until	(or
					(volume_test_players self_destruct_start_trig)
					(>= g_insertion_index 13)
				)
	1)
	; wake encounter script 
	(if (<= g_insertion_index 13) (wake 020_10_self_destruct))

	(sleep_until	(or
					(> (device_get_position self_destruct_switch) 0)
					(>= g_insertion_index 14)
				)
	1)
	; wake encounter script 
	(if (<= g_insertion_index 14) (wake 020_11_exit_run))

	(sleep_until (= (current_zone_set_fully_active) 10)1)
	; wake encounter script 
	(sleep 1)
	(wake 020_12_hangar_a_return)
				
)

;========================020_COMMAND/CAVE_A STUFF===================================

;adding script to switch texture camera around on big screen
(script dormant ops_center_big_screen
	(object_create_anew cin_main_screen)
	(object_create_anew big_screen_tv)		
	(object_destroy default_monitor)	
	(texture_camera_on)
;	(object_set_always_active int_cam_03 1)
;	(sleep 1)
;	(texture_camera_set_object_marker int_cam_03 "cam" 70)
;	(sleep_until (>= base_obj_control 30))
;	(sleep_until
;		(begin
;			(texture_camera_set_object_marker int_cam_01 "cam" 70)
;			(sleep 150)
;			(texture_camera_set_object_marker int_cam_02 "cam" 70)
;			(sleep 150)
;			(texture_camera_set_object_marker int_cam_03 "cam" 70)
;			(sleep 150)
;			(texture_camera_set_object_marker int_cam_04 "cam" 70)
;			(sleep 150)
;			(>= base_obj_control 30))
;		)
;	)
;	(object_set_always_active int_cam_03 0)
;	(sleep 1)
	(texture_camera_off)
	(object_destroy cin_main_screen)
	(object_destroy big_screen_tv)		
	(object_create_anew default_monitor)	
)

;adding script to control what the monitors are showing - rstokes 5/4/07
(script dormant ops_center_monitors
	(object_set_function_variable cc_monitor01 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor02 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor03 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor04 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor05 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor06 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor07 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor08 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor09 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor10 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor11 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor12 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor_new12 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor_new14 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor_mir_01 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor_mir_02 "screen_control" (real_random_range 0 1) 0)
	(object_set_function_variable cc_monitor_mir_03 "screen_control" (real_random_range 0 1) 0)
	(sleep_until
		(begin
			(begin_random
				(begin
					(object_set_function_variable cc_monitor01 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor02 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor03 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor04 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor05 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor06 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor07 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor08 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor09 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor10 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor11 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor12 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor_new12 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor_new14 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor_mir_01 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor_mir_02 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
				(begin
					(object_set_function_variable cc_monitor_mir_03 "screen_control" (real_random_range 0 1) 0)
					(sleep (random_range 30 90))
				)
			)
			(>= base_obj_control 30)
		)
	)
)

(script dormant 020_command_center_start
; starting command center intro gameplay
	(data_mine_set_mission_segment "020_01_command_center")
	(device_set_position_immediate command_center_cin_door 0)
	(set base_obj_control 10)
	(game_save)
	(texture_camera_off)
	(object_destroy cin_main_screen)
	(object_destroy big_screen_tv)		
	(object_create_anew default_monitor)
	(ai_dialogue_enable false) ;50336									
	(wake 020_music_01)
;	(ai_place command_center_marines01)
;	(ai_place command_center_marines02/05)
;	(ai_place command_center_marines02/10)
;	(ai_place command_center_marines02/jon)
;	(ai_place command_center_marines02/actor_miranda)
;	(if (= (game_coop_player_count) 1)
;		(ai_place command_center_marines02/arby)
;	)
;	(ai_place command_center_marines03)
;	(ai_place command_center_marines04)
;	(ai_place command_center_marines05)
;	(ai_place command_center_marines06)
	(wake miranda_movement)
	(wake md_01_command_objectives_01)
	(wake md_01_command_objectives_02)
	(wake md_01_command_objectives_03)
;	(wake md_01_command_objectives_04)
	(wake md_01_command_objectives_05)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_encounter true)
	(zone_set_trigger_volume_enable zone_set:020_00_01_encounter true)	
	(wake md_01_command_followers02)
;	(cs_run_command_script command_center_marines04 cs_run)
	(wake command_navpoint_active)
	(wake command_navpoint_deactive)
;	(wake ops_center_big_screen)
	(wake ops_center_monitors)

	(sleep 1)
)

(script command_script cs_run
	(cs_movement_mode ai_movement_combat)
	(cs_enable_moving true)
)

(script command_script cc_m01_anim
	(cs_look TRUE command_center_intro/p13)
)

(script command_script cc_m02_anim
	(cs_look TRUE command_center_intro/p15)
)
;*
(script command_script cc_m03_anim
	(cs_look command_center_intro/p)
	(sleep_forever)	
)

(script command_script cc_m04_anim
	(cs_look command_center_intro/p)
	(sleep_forever)	
)
*;
(script dormant miranda_retreat
	(sleep_until (volume_test_players command_center_intro_trig) 1)
	(cs_run_command_script command_center_marines02/actor_miranda cs_miranda_retreat)
)

(script command_script cs_miranda_retreat
	(cs_go_to command_center_intro/p7)
)

(global short random_rats 0)
(script dormant cave_a_rats
	(begin_random
		(if (< random_rats 3)
			(begin
				(flock_create cave_a_rats_01)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 3)
			(begin
				(flock_create cave_a_rats_02)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 3)
			(begin
				(flock_create cave_a_rats_03)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 3)
			(begin
				(flock_create cave_a_rats_04)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 3)
			(begin
				(flock_create cave_a_rats_05)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 3)
			(begin
				(flock_create cave_a_rats_06)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 3)
			(begin
				(flock_create cave_a_rats_07)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 3)
			(begin
				(flock_create cave_a_rats_08)
				(set random_rats (+ random_rats 1))
			)
		)
	
	)
	(set random_rats 0)
	(sleep 60)
	(flock_stop cave_a_rats_01)
	(flock_stop cave_a_rats_02)
	(flock_stop cave_a_rats_03)
	(flock_stop cave_a_rats_04)
	(flock_stop cave_a_rats_05)
	(flock_stop cave_a_rats_06)
	(flock_stop cave_a_rats_07)
	(flock_stop cave_a_rats_08)
	
	(sleep_until (>= (current_zone_set_fully_active) 1))
	(flock_create hall_a_rats_01)
	(sleep 60)
	(flock_stop hall_a_rats_01)
)

(script dormant 020_01_Cave_A
; starting cave a gameplay
	(data_mine_set_mission_segment "020_01_cave_a")
	(game_save)
	(set base_obj_control 20)
	(ai_place cave_a_marines01)
	(ai_place cave_a_marines02)
	(ai_place cave_a_marines03)
	(ai_place cave_a_marines04)
	(ai_place cave_a_marines05)
;	(cs_run_command_script cave_a_marines05/01 01_cave_a_runner01)
;	(cs_run_command_script cave_a_marines05/02 01_cave_a_runner02)	
;	(ai_place cave_a_marines07)	
	(ai_place players_marines)
	(wake cave_a_rats)
	(chud_show_arbiter_ai_navpoint FALSE)
	(wake md_01_cave_marines)
	(wake md_01_hw_followers)
	(if debug (print "setting marine_pos 1"))
	(set marine_pos 1)	
	(wake cave_a_navpoint_active)
	(wake cave_a_navpoint_deactive)	

	(sleep_until (volume_test_players cave_a_marine_1) 1)
	(ai_set_objective players_marines cave_a_obj)

	; marine followers for the hallway
	(sleep_until (volume_test_players cave_a_hwy_marines00_trig) 1)
	(ai_set_objective players_marines highway_a_hum_obj)	
	(if debug (print "setting marine_pos 1"))
	(set marine_pos 1)
	(ai_dialogue_enable true) ;50336									

	(sleep_until (volume_test_players cave_a_hwy_marines01_trig) 1)
	(wake br_bb_hangar_a)
	(if debug (print "setting marine_pos 2"))
	(set marine_pos 2)
	(wake 02_rumble_event_weak)
	(sleep_forever md_01_command_objectives_01)
	(sleep_forever md_01_command_objectives_02)
	(sleep_forever md_01_command_objectives_03)
	(sleep_forever md_01_command_objectives_04)
	(sleep_forever md_01_command_objectives_05)
	(ai_dialogue_enable true)												
	(object_destroy_containing arb_sphere)
	
	(sleep_until (volume_test_players cave_a_hwy_marines02_trig) 1)
	(if debug (print "setting marine_pos 3"))
	(set marine_pos 3)
	(wake 020_02_highway_directors_cut)	
	(sleep_until (volume_test_players cave_a_hwy_marines03_trig) 1)
	(if debug (print "setting marine_pos 4"))
	(set marine_pos 4)	
	(sleep_until (AND (volume_test_players highway_a_start_trig)(> (device_get_position highway_a_door) 0)) 1)

	(if debug (print "setting marine_pos 5"))
	(set marine_pos 5)
	
	(sleep 60)
	
;	(wake md_01_hw_encounter)
;	(if debug (print "setting marine_pos 6"))
;	(set marine_pos 6)
)

;========================020_02_HIGHWAY_A ENCOUNTER=============================

(script dormant 020_02_highway_directors_cut
	(wake 020_music_02)
	(ai_place highway_a_warthog01)
	(ai_vehicle_reserve_seat highway_a_warthog01 "warthog_d" TRUE)	
	(ai_force_active highway_a_warthog01 TRUE)

	(cs_run_command_script highway_a_warthog01/gunner 020_02_warthog_01_attack )
	(cs_run_command_script highway_a_warthog01/passenger 020_02_warthog_02_attack)
	(cs_run_command_script highway_a_warthog01/driver 020_02_warthog_00_attack)		
	
	(sleep_until (> (device_get_position highway_a_door) 0)1 (* 30 15))	
	(ai_place highway_a_cov00)	
	(wake blow_warthog)	
	
	(cs_run_command_script highway_a_cov00/01 020_02_warthog_grenade)
	(cs_run_command_script highway_a_cov00/02 020_02_warthog_grenade)
)

(script dormant 020_02_highway_a
	(data_mine_set_mission_segment "020_02_highway_a")
	(game_save)
	(set base_obj_control 30)
	(wake 020VG_RVB_EASTER_EGG)
	
	(flock_create hall_a_rats_02)

	(sleep_until (> (device_get_position highway_a_door) 0)1)
	(set g_music_020_01 false)
	(set g_music_020_02 true)		
	(ai_place highway_a_cov01)
	(ai_place highway_a_cov02)
	(ai_place highway_a_cov03)
	(ai_place highway_a_cov07_legend)
	(ai_place highway_a_cov08_legend)
	(sleep 30)
	(flock_stop hall_a_rats_02)
	
	(sleep_until (OR (< (ai_living_count highway_a_cov02) 1) (volume_test_players highway_a_mid_trig)) 5)
	(wake highway_a_navpoint_active)
	(wake highway_a_navpoint_deactive)
	(device_set_position highway_a_door_switch 1)
	
;	(cs_run_command_script highway_a_cov01/01 020_02_warthog_grenade)
;	(cs_run_command_script highway_a_cov01/02 020_02_warthog_grenade)

	
	(sleep_until (OR (< (ai_living_count highway_a_cov03) 1) (volume_test_players highway_second_part_trig)) 5)
	
	(ai_place highway_a_cov04)
	(ai_place highway_a_cov05)
	(sleep_until (volume_test_players highway_a_rumble_trig))
	(wake 03_rumble_event_weak)
	(object_destroy hangar_a_remove01)
	
	(sleep_until
		(OR
			(= (volume_test_players vol_hangar_a_rats) TRUE)
			(AND
				(< (ai_living_count highway_a_cov04) 1)
				(< (ai_living_count highway_a_cov05) 1)
			)
		)
	)
	(if (= (volume_test_players vol_hangar_a_rats) FALSE)
		(begin
			(flock_create hall_a_rats_03)
			(sleep 60)
			(flock_stop hall_a_rats_03)
		)
	)
)

(script command_script 020_02_warthog_00_attack
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to highway_a_warthog/p4 1)
	(sleep_forever)
)

(script command_script 020_02_warthog_01_attack
	(sleep_until
		(begin
			(cs_shoot_point TRUE highway_a_warthog/p1)
			(sleep 60)
			(cs_shoot_point TRUE highway_a_warthog/p2)
			(sleep 60)
			(cs_shoot_point TRUE highway_a_warthog/p3)
		(< (ai_living_count highway_a_warthog01)1))
	)
)

(script command_script 020_02_warthog_02_attack
	(sleep_until
		(begin
			(cs_shoot_point TRUE highway_a_warthog/p3)
			(sleep 60)
			(cs_shoot_point TRUE highway_a_warthog/p1)
			(sleep 30)
			(cs_shoot_point TRUE highway_a_warthog/p2)
			(sleep 30)
		(< (ai_living_count highway_a_warthog01)1))
	)
)

(script command_script 020_02_warthog_grenade
	(cs_grenade highway_a_warthog/p0 1)
)

(script dormant blow_warthog
	(sleep_until (< (ai_strength highway_a_warthog01) 0.95)1 90)
	(unit_kill (ai_vehicle_get_from_starting_location highway_a_warthog01/driver))	
;	(ai_vehicle_reserve highway_a_warthog01 true)
	(if (= (unit_in_vehicle (unit (ai_get_object highway_a_warthog01/driver))) TRUE)
	(unit_kill highway_a_warthog01/driver))
	(if (= (unit_in_vehicle (unit (ai_get_object highway_a_warthog01/gunner))) TRUE)
	(unit_kill highway_a_warthog01/gunner))
	(if (= (unit_in_vehicle (unit (ai_get_object highway_a_warthog01/passenger))) TRUE)	
	(unit_kill highway_a_warthog01/passenger))
	(print "KILL THE HOG!!")
)

(script command_script 020_02_transition

	(ai_set_objective ai_current_squad hangar_a_hum_obj)
	;need to do this here as it overlaps into another bsp
)

;========================020_04_HANGAR_A ENCOUNTER==============================

(script dormant hangar_a_rats
	(begin_random
		(if (< random_rats 2)
			(begin
				(flock_create hangar_a_rats_01)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 2)
			(begin
				(flock_create hangar_a_rats_02)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 2)
			(begin
				(flock_create hangar_a_rats_03)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 2)
			(begin
				(flock_create hangar_a_rats_04)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 2)
			(begin
				(flock_create hangar_a_rats_05)
				(set random_rats (+ random_rats 1))
			)
		)
	)
	(set random_rats 0)
	(sleep 60)
	(flock_stop hangar_a_rats_01)
	(flock_stop hangar_a_rats_02)
	(flock_stop hangar_a_rats_03)
	(flock_stop hangar_a_rats_04)
	(flock_stop hangar_a_rats_05)
)

(global short var_hangar_a_pos 0)

(script dormant 020_04_hangar_a
	(data_mine_set_mission_segment "020_04_hangar_a")
	(wake 020_music_03)
	(wake 020_music_04)
	(wake 020_music_05)
	(wake 020_music_06)	
	(sleep_until (= (current_zone_set_fully_active) 2) 5)
	(ai_dialogue_enable true)													
	(sleep_forever 020VG_RVB_EASTER_EGG)	
	(wake md_04_hangar_a_combat)
	(set base_obj_control 40)
	(object_create_anew cov_capital_ship01)	
	(flock_create banshees)
	(flock_create hornets)
	(sleep 1)
	(flock_start banshees)
	(flock_start hornets)
	(wake hangar_a_rats)
;	(wake turret_guys)
	(ai_place hangar_a_cov_init_top01)
	(ai_place hangar_a_cov_init_left)
	(ai_place hangar_a_cov_init_right)
	(ai_place hangar_a_hum_turret01) ;50390
	(ai_place hangar_a_hum_turret02) ;50390
	(ai_place hangar_a_hum_init01)
	(ai_place hangar_a_hum_init02)
	(ai_place hangar_a_cov_init_bottom_right)
	(ai_place hangar_a_cov_init_bottom_left)	
	(ai_set_objective players_marines hangar_a_hum_obj)
	(wake 020_04_Covenant_Phantom_Attack)
	
	(wake 020_04_Top_Attack)
	(ai_disregard (ai_actors hangar_a_hum_init01) TRUE)
	(ai_disregard (ai_actors hangar_a_hum_init02) TRUE)
	(sleep_until (volume_test_players hangar_a_entrance_trig) 5)
	(game_save)
	(volume_teleport_players_not_inside hangar_a_entrance_trig hangar_a_coop_flag)
	(add_recycling_volume g_highway_trig_a 10 30)
	(add_recycling_volume g_hallway_b_trig_a 5 30)
	
	(device_set_position_immediate 020_03_d2 0)
	(ai_disposable highway_a_all TRUE)	
	(if (= (ai_living_count rvb_marine) 1)
		(ai_erase rvb_marine)
	)
	(sleep_until (volume_test_players hangar_a_door_entrance_trig) 5)
	(ai_disregard (ai_actors hangar_a_hum_init01) FALSE)
	(ai_disregard (ai_actors hangar_a_hum_init02) FALSE)
	(set g_music_020_03	TRUE)
	
	(set var_hangar_a_pos 1)
	
	(sleep_until (volume_test_players hangar_a_var02) 5)
	(set var_hangar_a_pos 2)	
	(sleep_until (volume_test_players hangar_a_var03) 5)
	(set var_hangar_a_pos 3)
	
)

(script command_script peaceful_flyer
	(sleep_forever)
)

(script command_script hangar_a_pelican_load
	(ai_vehicle_exit ai_current_actor)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location hangar_a_pelican/pilot))
	(sleep_until
		(begin
			(sleep 90)
			(cs_go_to_vehicle (ai_vehicle_get_from_starting_location hangar_a_pelican/pilot))
			;(unit_in_vehicle (unit (ai_get_object ai_current_actor)))
			(vehicle_test_seat hangar_a_pelican "" ai_current_actor)
		)
	)
)

(global boolean Phantom_Ready FALSE)
(global boolean Covenant_Losing FALSE)

(script dormant 020_04_Top_Attack
	(sleep_until (or (> var_hangar_a_pos 1) (= Covenant_Losing TRUE)))
	(ai_migrate hangar_a_hum_init01 players_marines)
	(ai_migrate hangar_a_hum_init02 players_marines)
;	(ai_migrate hangar_a_hum_turret03 players_marines)
;	(ai_migrate hangar_a_hum_turret04 players_marines)	
)
(global boolean hangar_a_done FALSE)

(script dormant 020_04_Covenant_Phantom_Attack
	; Start up Hangar_A Phantoms
	(ai_place hangar_a_cov_init_phantom)
;	(object_cannot_die (ai_vehicle_get_from_starting_location hangar_a_cov_init_phantom/pilot) TRUE)		
;	(ai_cannot_die hangar_a_cov_init_phantom/pilot TRUE)
;	(object_cannot_take_damage (ai_vehicle_get_from_starting_location hangar_a_cov_init_phantom/pilot))	
	(object_set_shadowless hangar_a_cov_init_phantom/pilot TRUE)
	(ai_place hangar_a_cov_phantom01)	
;	(object_cannot_die (ai_vehicle_get_from_starting_location hangar_a_cov_phantom01/pilot) TRUE)	
;	(ai_cannot_die hangar_a_cov_phantom01/pilot TRUE)	
;	(object_cannot_take_damage (ai_vehicle_get_from_starting_location hangar_a_cov_phantom01/pilot))
	(object_set_shadowless hangar_a_cov_phantom01/pilot TRUE)

	(device_set_position_immediate hangar_a_crane01 0.5)
	(ai_place hangar_a_pelican)	
	(ai_disregard (ai_actors hangar_a_pelican) true)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location hangar_a_pelican/pilot))			
	
	(object_set_shadowless hangar_a_pelican/pilot TRUE)
	(ai_vehicle_reserve_seat hangar_a_pelican "pelican_g" TRUE)		
	(cs_run_command_script hangar_a_pelican/pilot peaceful_flyer)
	
	(sleep 1)
	(objects_attach hangar_a_crane01 "pelicanattach" (ai_vehicle_get_from_starting_location hangar_a_pelican/pilot) "crane")
	; Script them to sit there	
	(cs_run_command_script hangar_a_cov_init_phantom/pilot peaceful_flyer)
	(cs_run_command_script hangar_a_cov_phantom01/pilot peaceful_flyer)
	; Drop first set of reinforcements
	; wait until player can see phantom leave	
	(sleep_until (volume_test_players hangar_a_door_entrance_trig) 5)
	; get the first Phantom out
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_init_phantom/pilot) TRUE)
	(cs_run_command_script hangar_a_cov_init_phantom 020_04_PhantomInitPath)
	(sleep 15)
	; sleep until the first phantom gets out of the hangar door
	(sleep_until Phantom_Ready)
	; return phantom ready so that it drops off all of the covenant reinforcments
	(set Phantom_Ready FALSE)		
	(game_save)
	(sleep_until (or (< (ai_living_count hangar_a_cov_assaulting) 1) (> var_hangar_a_pos 1))5)
	; start bringing in the other phantom
	(cs_run_command_script hangar_a_cov_phantom01/pilot 020_04_Phantom01Path)
	(add_recycling_volume g_hangar_a_trig_a 15 60)
	
	(ai_place hangar_a_cov_phantom01_5)
;	(object_cannot_die (ai_vehicle_get_from_starting_location hangar_a_cov_phantom01_5/pilot) TRUE)		
;	(ai_cannot_die hangar_a_cov_phantom01_5/pilot TRUE)
;	(object_cannot_take_damage (ai_vehicle_get_from_starting_location hangar_a_cov_phantom01_5/pilot))		
	(object_set_shadowless hangar_a_cov_phantom01_5/pilot TRUE)	
	(cs_run_command_script hangar_a_cov_phantom01_5/pilot 020_04_Phantom01_5Path)
	(add_recycling_volume g_hangar_a_trig_a 15 60)
	
	(sleep_until Phantom_Ready)
	(ai_place hangar_a_cov_phantom02)
;	(object_cannot_die (ai_vehicle_get_from_starting_location hangar_a_cov_phantom02/pilot) TRUE)			
;	(ai_cannot_die hangar_a_cov_phantom02/pilot TRUE)
;	(object_cannot_take_damage (ai_vehicle_get_from_starting_location hangar_a_cov_phantom02/pilot))		
	(object_set_shadowless hangar_a_cov_phantom02/pilot TRUE)		
	(game_save)
	(set Phantom_Ready FALSE)		
	(sleep_until (< (ai_living_count hangar_a_cov_reinforcements) 6)5)
	(cs_run_command_script hangar_a_cov_phantom02/pilot 020_04_Phantom02Path)
	(add_recycling_volume g_hangar_a_trig_a 15 60)	
	; sleep until most of the covenant are dead
	(sleep_until (and (< (ai_living_count hangar_a_cov) 4) Covenant_Losing))
	(game_save)
	(set var_hangar_a_pos 4)
	; move the Covenant to the middle
	(if (>= (game_difficulty_get_real) heroic)
		(begin
			(set Phantom_Ready FALSE)									
			(ai_place hangar_a_cov_phantom03)
			;(object_cannot_die (ai_vehicle_get_from_starting_location hangar_a_cov_phantom03/pilot) TRUE)				
			;(ai_cannot_die hangar_a_cov_phantom03/pilot TRUE)
			;(object_cannot_take_damage (ai_vehicle_get_from_starting_location hangar_a_cov_phantom03/pilot))		
			(object_set_shadowless hangar_a_cov_phantom03/pilot TRUE)
			(cs_run_command_script hangar_a_cov_phantom03/pilot 020_04_Phantom03Path)
			(add_recycling_volume g_hangar_a_trig_a 15 60)	
			(sleep_until Phantom_Ready)
		)
	)
	(sleep_until (< (ai_living_count hangar_a_cov) 1))
	; end of the encounter
	(wake kill_straggler_marines)	
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_return true)
	(zone_set_trigger_volume_enable zone_set:020_00_01_return true)
	(set hangar_a_done TRUE)			
	(device_set_position 020_03_d2 1)
	; spawning marines based on how many are currently alive
	(cond
		((<= (ai_living_count players_marines) 2)
		(begin
			(print "PLACING 5 MARINES")
			(ai_place hangar_a_hum_reinf01 5)
			
		))
		((and (>= (ai_living_count players_marines) 3) (<= (ai_living_count players_marines) 4))
		(begin
			(print "PLACING 3 MARINES")
			(ai_place hangar_a_hum_reinf01 3)		
		))
		((and (>= (ai_living_count players_marines) 5) (<= (ai_living_count players_marines) 7))
		(begin
			(print "PLACING 2 MARINES")
			(ai_place hangar_a_hum_reinf01 2)
		))
	)
	(ai_force_active hangar_a_hum_reinf01 TRUE)
	(ai_migrate hangar_a_hum_reinf01 players_marines)
	(sleep 30)
	(pvs_set_object (ai_get_object players_marines))
	(sleep_until (< (ai_living_count hangar_a_cov) 1))
;	(flock_create bugger_fakes01)
;	(flock_create bugger_fakes02)
;	(flock_create bugger_fakes03)
;	(flock_create bugger_fakes04)
;	(flock_create bugger_fakes05)
	(object_create_containing bugger_sound)
	
	(ai_place loop01_return_hw01) 
	(cs_run_command_script loop01_return_hw01/03 020_03_bugger_in_the_vents03)
	(cs_run_command_script loop01_return_hw01/04 020_03_bugger_in_the_vents04)

	
	(sleep_forever md_04_hangar_a_combat)
	(ai_dialogue_enable true)													
	(device_set_position hangar_a_crane01 1)
	(set g_music_020_02	FALSE)
	(set g_music_020_03	FALSE)
	(set g_music_020_04	FALSE)
	(set g_music_020_05	FALSE)
	
	(sleep_until (= (device_get_position hangar_a_crane01) 1))
	(sleep 30)

	(wake hangar_a_navpoint_active)
	(wake hangar_a_navpoint_deactive)			
	(objects_detach hangar_a_crane01 (ai_vehicle_get_from_starting_location hangar_a_pelican/pilot))	
	(cs_run_command_script hangar_a_pelican 020_04_Pelican_Path)
			
)

(script dormant 020_04_script_zone_set
; UNUSED SCRIPT
	(sleep_until (volume_test_players hangar_a_door_entrance_trig) 5)			
	(device_set_position hangar_a_left_door 0)
	(device_set_position hangar_a_right_door 0)
	(sleep_until (and 
				(= (device_get_position hangar_a_left_door) 0) 
				(= (device_get_position hangar_a_right_door) 0)
			)
	)

;	(prepare_to_switch_to_zone_set 020_00_03_encounter)
)

(global short straggler_no 0)

(script dormant kill_straggler_marines
	(if 
		(or
	          (volume_test_objects g_highway_trig_a (ai_actors players_marines))
	          (volume_test_objects g_highway_trig_b (ai_actors players_marines))			          
	          (volume_test_objects g_hallway_a_trig_a (ai_actors players_marines))
	          (volume_test_objects g_hallway_a_trig_b (ai_actors players_marines))	          
	          (volume_test_objects g_hallway_a_trig_c (ai_actors players_marines))
	          (volume_test_objects g_hallway_a_trig_d (ai_actors players_marines))
	          (volume_test_objects g_hallway_a_trig_e (ai_actors players_marines))			          
		)
			(ai_erase_inactive players_marines 10)
	)			
)

(script command_script 020_04_deploy_turret01
	(cs_enable_pathfinding_failsafe true)
	(cs_deploy_turret hangar_a_patrol/p14)
)
(script command_script 020_04_deploy_turret02
	(cs_enable_pathfinding_failsafe true)
	(cs_deploy_turret hangar_a_patrol/p15)
)

(script command_script 020_04_Pelican_Path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 0.5)
	(cs_fly_to hangar_a_pelican02_path/p0 1)
	(if (volume_test_players hangar_a_pelican_volume)
		(wake md_04_hangar_a_pelican)
	)	
	(sleep 30)
	(cs_vehicle_speed 0.35)	
	(cs_fly_to hangar_a_pelican02_path/p1 1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(cs_run_command_script players_marines hangar_a_pelican_load)		
	(sleep 120)	
	(wake 04_rumble_event_medium)
	(wake md_hangar_a_radio_johnson)
	(sleep_until (and (= (ai_living_count hangar_a_pelican) (ai_in_vehicle_count hangar_a_pelican))
			(= (ai_living_count players_marines) 0)))
	(sleep 60)
	(cs_vehicle_speed 0.5)
	(cs_fly_by hangar_a_pelican01_path/p1)
	(object_set_physics hangar_a_pelican/pilot false)
	(unit_close hangar_a_pelican/pilot)
	(cs_vehicle_speed 0.75)
	(cs_fly_by hangar_a_pelican01_path/p2)
	(cs_vehicle_speed 1.0)
	(cs_vehicle_boost TRUE)		
	(cs_fly_to hangar_a_pelican01_path/p3)
	(ai_erase hangar_a_pelican)
)

(script command_script 020_04_PhantomInitPath
	(cs_enable_pathfinding_failsafe TRUE)
		(cs_vehicle_speed 0.9)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p4 hangar_a_phantom_path_b/p3)
	(object_set_physics hangar_a_cov_init_phantom/pilot false)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p0 hangar_a_phantom_path_b/p3)
	(set Phantom_Ready TRUE)
	(cs_vehicle_speed 1.0)
	(cs_fly_by hangar_a_phantom_path_b/p1)
;	(cs_vehicle_boost TRUE)		
	(cs_fly_to hangar_a_phantom_path_b/p2 0)
	(ai_erase hangar_a_cov_init_phantom)
)

(script command_script 020_04_Phantom01Path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	(cs_fly_to hangar_a_phantom_path_a/p2 10)

	(cs_vehicle_speed 0.8)	
	(cs_fly_by hangar_a_phantom_path_a/p1 10)
	(set g_music_020_04	TRUE)

	(cs_vehicle_speed 0.6)	
	(cs_fly_to hangar_a_phantom_path_a/p4 2)	
;	(cs_enable_targeting true)
	
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_phantom01/pilot) TRUE)
	(sleep_until (= hangar_a_perf_hack TRUE)); makes it so that this phantom drops and takes off while the other Phantom stays for a bit longer and then drops

	(ai_trickle_via_phantom hangar_a_cov_phantom01/pilot hangar_a_cov_init_phantom_drop)
	
;	(sleep 90)
	
;	(ai_trickle_via_phantom hangar_a_cov_phantom01/pilot hangar_a_cov_phantom01_drop_b)

	(if debug (print "PHANTOM 01 UNLOAD"))
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_phantom01/pilot) FALSE)
	(sleep 30)
	(cs_vehicle_speed 0.8)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p4 hangar_a_phantom_path_b/p3)
	(object_set_physics hangar_a_cov_phantom01/pilot false)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p0 hangar_a_phantom_path_b/p3)
;	(cs_enable_targeting false)
	
	(set Phantom_Ready TRUE)
	(cs_vehicle_speed 1.0)
	(cs_fly_by hangar_a_phantom_path_b/p1)
	(cs_fly_to hangar_a_phantom_path_b/p2)
	(ai_erase hangar_a_cov_phantom01)
	
)

(global boolean hangar_a_perf_hack FALSE)

(script command_script 020_04_Phantom01_5Path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	(cs_fly_to hangar_a_phantom_path_a/p2 10)

	(cs_vehicle_speed 0.8)	
	(cs_fly_by hangar_a_phantom_path_a/p1 10)

	(cs_vehicle_speed 0.6)	
	(cs_fly_to hangar_a_phantom_path_a/p3 2)	
;	(cs_enable_targeting true)
	
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_phantom01_5/pilot) TRUE)
		
	(ai_dump_via_phantom hangar_a_cov_phantom01_5/pilot hangar_a_cov_phantom01_drop_a)
	
	(sleep 90)
	
	(ai_dump_via_phantom hangar_a_cov_phantom01_5/pilot hangar_a_cov_phantom01_drop_b)

	(sleep 90)

	(if debug (print "PHANTOM 01 UNLOAD"))
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_phantom01_5/pilot) FALSE)
	(cs_vehicle_speed 0.8)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p4 hangar_a_phantom_path_b/p3)
	(object_set_physics hangar_a_cov_phantom01/pilot false)
	(set hangar_a_perf_hack TRUE); makes it so that this phantom drops and takes off while the other Phantom stays for a bit longer and then drops
	
	(cs_fly_to_and_face hangar_a_phantom_path_b/p0 hangar_a_phantom_path_b/p3)
;	(cs_enable_targeting false)	
	(cs_vehicle_speed 1.0)
	(cs_fly_by hangar_a_phantom_path_b/p1)
	(cs_fly_to hangar_a_phantom_path_b/p2)
	(ai_erase hangar_a_cov_phantom01_5)
	
)
(script command_script 020_04_Phantom02Path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	(cs_fly_to hangar_a_phantom_path_a/p2 10)

	(cs_vehicle_speed 0.8)	
	(cs_fly_by hangar_a_phantom_path_a/p1 10)
	(if (<= (game_difficulty_get_real) normal)
		(begin
			(sound_looping_set_alternate levels\solo\020_base\music\020_music_04 TRUE)
			(set g_music_020_05	TRUE)
		)
	)
	(cs_vehicle_speed 0.6)	
	(cs_fly_to hangar_a_phantom_path_a/p0 2)	
;	(cs_enable_targeting true)
	
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_phantom02/pilot) TRUE)
	; difficulty check on the last batch of reinforcements			
	(if (<= (game_difficulty_get_real) normal)
		(begin
		
			(ai_trickle_via_phantom hangar_a_cov_phantom02/pilot hangar_a_cov_phantom02_drop_a)
			
			(sleep 90)
			
			(ai_trickle_via_phantom hangar_a_cov_phantom02/pilot hangar_a_cov_phantom02_drop_b)
			(sleep 90)
			; Tell the Phantom that he can leave if he meets the other conditions in his script 020_04_Phantom01Path				
		)
		(if (>= (game_difficulty_get_real) heroic)
			(begin
				(game_save)
				(ai_trickle_via_phantom hangar_a_cov_phantom02/pilot hangar_a_cov_phantom03_drop_a)
				
				(sleep 90)
				
				(ai_trickle_via_phantom hangar_a_cov_phantom02/pilot hangar_a_cov_phantom03_drop_b)
				(sleep 90)
				; Tell the Phantom that he can leave if he meets the other conditions in his script 020_04_Phantom01Path
			)
		)
	)

	(if debug (print "PHANTOM 02 UNLOAD"))
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_phantom02/pilot) FALSE)
	(sleep 30)
	
	(cs_vehicle_speed 0.8)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p4 hangar_a_phantom_path_b/p3)
	(object_set_physics hangar_a_cov_phantom02/pilot false)
;	(cs_enable_targeting false)
	
	(cs_fly_to_and_face hangar_a_phantom_path_b/p0 hangar_a_phantom_path_b/p3)
	(set Phantom_Ready TRUE)	
	(set Covenant_Losing true)	

	(cs_vehicle_speed 1.0)
	(cs_fly_by hangar_a_phantom_path_b/p1)
;	(cs_vehicle_boost TRUE)		
	(cs_fly_to hangar_a_phantom_path_b/p2)
	(ai_erase hangar_a_cov_phantom02)
	
)
(script command_script 020_04_Phantom03Path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	(cs_fly_to hangar_a_phantom_path_a/p2 10)

	(cs_vehicle_speed 0.8)	
	(cs_fly_by hangar_a_phantom_path_a/p1 10)
	(sound_looping_set_alternate levels\solo\020_base\music\020_music_04 TRUE)
	(set g_music_020_05	TRUE)
	(cs_vehicle_speed 0.6)	
	(cs_fly_to hangar_a_phantom_path_a/p0 2)	
;	(cs_enable_targeting true)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_phantom03/pilot) TRUE)

	(ai_trickle_via_phantom hangar_a_cov_phantom03/pilot hangar_a_phantom04_legend_a)
	(sleep 90)
	(ai_trickle_via_phantom hangar_a_cov_phantom03/pilot hangar_a_phantom04_legend_c)
	(sleep 90)	
	(ai_trickle_via_phantom hangar_a_cov_phantom03/pilot hangar_a_phantom04_legend_b)
	
	(if debug (print "PHANTOM 03 UNLOAD"))
	(object_set_phantom_power (ai_vehicle_get_from_starting_location hangar_a_cov_phantom03/pilot) FALSE)
	(sleep 30)
	(cs_vehicle_speed 0.8)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p4 hangar_a_phantom_path_b/p3)
	(object_set_physics hangar_a_cov_phantom01/pilot false)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p0 hangar_a_phantom_path_b/p3)
;	(cs_enable_targeting false)	
	(set Phantom_Ready TRUE)
	(cs_vehicle_speed 1.0)
	(cs_fly_by hangar_a_phantom_path_b/p1)
	(cs_fly_to hangar_a_phantom_path_b/p2)
	(ai_erase hangar_a_cov_phantom03)
)


;========================020_05_LOOP01_RETURN ENCOUNTER==============================
(script static void bugger_vents
	(ai_place loop01_return_hw01)

	(cs_run_command_script loop01_return_hw01/03 020_03_bugger_in_the_vents03)
	(cs_run_command_script loop01_return_hw01/04 020_03_bugger_in_the_vents04)

)

(script static void test_bugger_vignette

	(ai_place bugger_intro_hum01)
	(wake 020VB_BUGGER_V_MARINE)
	
)

(script dormant 020_05_loop01_return
	(data_mine_set_mission_segment "020_05_loop01_return")
	(set base_obj_control 50)
	(wake 05_rumble_event_medium)
	(wake 020_05_PA_talking)		
	(wake md_06_bugger_marine02)
	(sleep_until (volume_test_players cortana_exit_run_trig)5)
	(cs_run_command_script loop01_return_hw01/03 cs_abort)
	(cs_run_command_script loop01_return_hw01/04 cs_abort)
	(sleep 1)
	(ai_set_objective loop01_return_hw01 loop01_return_highway)
	(sleep_until (volume_test_players cave_a_hwy_marines00_trig)5)
	(game_save)	
     (render_patchy_fog 0); for barry!!
     (ai_migrate loop01_return_hw01 players_marines)
	(ai_set_objective players_marines loop01_return_obj)
	(object_destroy_containing bugger_intro_remove)
	(object_create_anew_containing bugger_intro_crate)
	
	(ai_place bugger_intro_hum01)

	(cs_run_command_script bugger_intro_hum01/actor03 020_03_bugger_in_the_vents)
	(cs_run_command_script bugger_intro_hum01/actor01 020_03_bugger_in_the_vents02)
	(sleep 15)
	(wake 020_05_bugger_machine)
	(wake 020VB_BUGGER_V_MARINE)
	(object_destroy_containing bugger_sound)
	
;	(sleep_until (< (ai_living_count bugger_intro_hum01/actor02) 1))
	
	(wake md_05_bugger_marine)

	(sleep_until (and (script_finished 020_05_bugger_machine) (<= (ai_living_count bugger_intro_cov)3)) 5) ; this was big-time broken
	(sleep_until (< (ai_living_count bugger_intro_cov)1)5 300)
	(wake md_05_bugger_marine01)
	
	(cs_run_command_script bugger_intro_hum01/actor03 01_cave_a_runner01)
	(cs_run_command_script bugger_intro_hum01/actor01 01_cave_a_runner02)

;	(cs_run_command_script bugger_intro_hum01/actor03 cave_a_bunker_01)
;	(cs_run_command_script bugger_intro_hum01/actor01 cave_a_bunker_02)
;	(cs_run_command_script bugger_intro_hum01/actor02 cave_a_pos_08)

	(wake loop01_navpoint_active)
	(wake loop01_navpoint_deactive)		
	(ai_place loop01_return_hum02)
	(ai_place Loop02_Begin_Vig03)
	(ai_place Loop02_Begin_Vig04)
	(device_set_position cave_a_door_command 1)

)

(global short bugger_no 1)
(global short bugger_difficulty 20)

(script dormant 020_05_bugger_machine
	(sleep_until (= bugger_attack TRUE)1)
	(object_damage_damage_section bugger_vent "all" 1) 	
	(cond
		((= (game_difficulty_get_real) easy)(set bugger_difficulty 20))
		((= (game_difficulty_get_real) normal)(set bugger_difficulty 25))
		((= (game_difficulty_get_real) heroic)(set bugger_difficulty 30))
		((= (game_difficulty_get_real) legendary)(set bugger_difficulty 35))
	)
	(sleep_until
		(begin
			(if (< (ai_living_count bugger_intro_cov) 19)
				(begin
					(cond 
						((= bugger_no 1)
							(ai_place bugger_squad01 1))
						((= bugger_no 2)
							(ai_place bugger_squad02 1))
						((= bugger_no 3)
							(ai_place bugger_squad03 1))
						((= bugger_no 4)
							(ai_place bugger_squad04 1))
						((= bugger_no 5)
							(ai_place bugger_squad05 1))
					)
				)
			)		
		(>= (ai_body_count bugger_intro_obj/overall_task) bugger_difficulty))
			
	15)														
)

(script dormant 020_05_loop02_begin
	(data_mine_set_mission_segment "020_05_loop02_begin")
	(game_save)
	(game_insertion_point_unlock 1)
	(wake obj_return_command_center_clear)
	(set base_obj_control 60)
	(device_set_power loop02_begin_switch 1)
	(device_set_power loop02_begin_switch_b 1)	
	(wake 020VC_GIFT_WITH_PURCHASE)
	(wake 020_title2)
	(wake loop02_navpoint_active)	
	(sleep_until	(or
					(>= (device_get_position loop02_begin_door) 1)
					(= (game_insertion_point_get) 1)
				)
	1)
	(wake loop02_navpoint_deactive)
	(ai_dialogue_enable true)
	(wake obj_barracks_set)
	
)

;========================020_06_MOTOR_POOL ENCOUNTER==============================

(script dormant motorpool_rats
	(begin_random
		(if (< random_rats 1)
			(begin
				(flock_create motorpool_rats_01)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 1)
			(begin
				(flock_create motorpool_rats_02)
				(set random_rats (+ random_rats 1))
			)
		)
	)
	(set random_rats 0)
	(sleep 60)
	(flock_stop motorpool_rats_01)
	(flock_stop motorpool_rats_02)
)

(global short var_motor_pool_pos 0)

(script dormant 020_06_motor_pool
	(wake 020_music_07)	
	(wake 020_music_08)
	(wake 020_music_02b)
	(ai_dialogue_enable TRUE)	
	(data_mine_set_mission_segment "020_06_motor_pool")
	(game_save)
	(set base_obj_control 70)				
	(wake 020_06_player_position)
	(wake 020_06_save)
	(wake motorpool_chieftain_attack)
	(if debug (print "Starting The Motor Pool"))
	(wake md_06_motorpool_brutes)
	(ai_place motor_pool_brute01)		
	(ai_place motor_pool_brute02)		
	(ai_place motor_pool_brute03)
	(ai_place motor_pool_armor_chieftain)
	(ai_place motor_pool_turret) ;50390
	(wake motorpool_rats)
;	(set g_music_020_08 TRUE)
				
	(sleep_until (OR (<= (+ (ai_living_count motor_pool_brute03)
					   (ai_living_count motor_pool_brute02)
					   ) 1)
				  (< (ai_living_count motor_pool_armor_chieftain) 1)))
				  
	(if debug	(print "REINFORCEMENTS"))
;	(zone_set_trigger_volume_enable zone_set:020_04_05_06_encounter true)
	
;	(sleep_until (= (current_zone_set_fully_active) 5) 1)
	(ai_place motor_pool_brute04)
	(ai_place motor_pool_brute05_legend)
	(device_set_position motor_pool_exit_door 1)
	(wake motor_pool_navpoint_active)
	(wake motor_pool_navpoint_deactive)	

)

(script dormant motorpool_chieftain_attack
	(sleep_until (and 
				(<= (ai_living_count motor_pool_brute02) 0) 
				(<= (ai_living_count motor_pool_brute03) 0)
				(<= (ai_living_count motor_pool_brute04) 0)))
	(set var_motor_pool_pos 4)
)

(script dormant 020_06_save

	(sleep_until (= (ai_task_status motor_pool_obj/brutes02) 1) 5)
	(if debug (print "First Motor_Pool save seeking"))
	(sleep_until (OR (volume_test_players motor_pool_save00)
				  (volume_test_players motor_pool_save01)
				  (volume_test_players motor_pool_save02)
			   )5 300)
	(game_save)
	(sleep_until (= (ai_task_status motor_pool_obj/brutes_reinforcement) 1) 5)
	(if debug (print "Second Motor_Pool save seeking"))
	(sleep_until (OR (volume_test_players motor_pool_save00)
				  (volume_test_players motor_pool_save01)
				  (volume_test_players motor_pool_save02)
				  (volume_test_players motor_pool_player_vol02)
			   )5)
	(game_save)
	
)
(script dormant 020_06_player_position
	(set var_motor_pool_pos 1)
	(sleep_until (OR (volume_test_players motor_pool_player_vol02)
				  (volume_test_players motor_pool_player_vol02a)
				  (volume_test_players motor_pool_player_vol02b))5)
	(set var_motor_pool_pos 2)
	(sleep_until (volume_test_players motor_pool_player_vol03)5)
	(set var_motor_pool_pos 3)
	(wake 07_rumble_event_strong)
;	(wake md_06_hw_joh)
					
)
;========================020_06_SEWER ENCOUNTER==============================
(script dormant 020_06_sewer
	(set base_obj_control 80)
	(data_mine_set_mission_segment "020_06_sewer")
	(game_save)
	(wake 020_music_09)
	(wake 020_music_10)	
	(chud_show_arbiter_ai_navpoint TRUE)	
	(wake cortana_moment_a)			
	(wake 08_rumble_event_weak)
;	(device_group_change_only_once_more_set 020_01_g3 FALSE)
	(device_set_power motor_pool_switch_a 0)
	(sleep_until (volume_test_players bugger_scary_trig)5)
	(set random_bool (random_range 0 2))
		(if (= random_bool 1)
			(begin
				(ai_place sewer_bugger_pop_out)
				(set g_music_020_02b FALSE)
				(set g_music_020_09 TRUE)
				(set g_music_020_10 TRUE)				
			)
		)
	(sleep_until (volume_test_players sewer_start_trig)5)
	(set g_music_020_02b FALSE)
	(set g_music_020_09 TRUE)
	(set g_music_020_10 TRUE)
;	(sleep_forever md_06_hw_joh)

;	(wake br_06_sewer_rescue)

	(wake bugger_machine01)
	(wake bugger_machine02)
	(wake bugger_machine03)
	(wake bugger_swarm01)
	(wake bugger_swarm02)
	(wake bugger_swarm03)
	(sleep (random_range 90 120))
;	(wake md_06_motorpool_johnson_pa)	

	(sleep_until (volume_test_players sewer02_trig)1)

	(if (not (game_is_cooperative))
		(begin
			(ai_place 020_arbiter)
			(set obj_arbiter (ai_get_object 020_arbiter/actor01))
			(ai_set_objective 020_arbiter evac_hangar_hum_obj)
			(ai_place arbiter_buggers01)
			
		)
	)
	(wake md_07_evac_arbiter)

)

(script command_script bugger_vent_scare
	(cs_enable_pathfinding_failsafe TRUE)
;	(object_destroy sewer_grate)			
;	(cs_fly_to sewer_buggers/p21 0.25)
	(cs_fly_to sewer_buggers/p22 0.25)	

)

(global short bugger01_num 1)
(global short bugger02_num 1)
(global short bugger03_num 1)

(script dormant bugger_machine01
	(sleep_until
		(begin
		 		(sleep (random_range 5 90))
		 		(set bugger01_num (random_range 0 2))
				(if (= bugger01_num 0)
					(begin
						(bugger_init01)
						(ai_erase sewer_bugger01)
					)
					(begin
						(bugger_init02)
						(ai_erase sewer_bugger02)

					)
				)				
	
			(OR (>= (ai_combat_status sewer_bugger01) 7)
			    (>= (ai_combat_status sewer_bugger02) 7)
			)
		)
	)
)

(script dormant bugger_machine02
	(sleep_until
		(begin
		 		(sleep (random_range 5 60))
		 		(set bugger02_num (random_range 0 2))
				(if (= bugger02_num 0)
					(begin
						(bugger_init03)				
						(ai_erase sewer_bugger03)
					)
					(begin
						(bugger_init04)
						(ai_erase sewer_bugger04)
					)
				)				
	
			(OR (>= (ai_combat_status sewer_bugger03) 7)
			    (>= (ai_combat_status sewer_bugger04) 7)
			)
		)
	)
)

(script dormant bugger_machine03
	(sleep_until
		(begin
		 		(sleep (random_range 5 30))
		 		(set bugger03_num (random_range 0 2))
				(if (= bugger03_num 0)
					(begin
						(bugger_init05)				
						(ai_erase sewer_bugger05)
					)
					(begin
						(bugger_init06)
						(ai_erase sewer_bugger06)
					)
				)				
	
			(OR (>= (ai_combat_status sewer_bugger05) 7)
			    (>= (ai_combat_status sewer_bugger06) 7)
			)
		)
	)
)
			
(script dormant bugger_swarm01
	(sleep_until 
			(OR 
				(>= (ai_combat_status sewer_bugger01) 7)
				(>= (ai_combat_status sewer_bugger02) 7)

			)		
	5)
	(ai_set_objective sewer_bugger01 sewer_obj)
	(ai_set_objective sewer_bugger02 sewer_obj)	
	(sleep_forever bugger_machine01)
	(ai_place sewer_bugger_swarm01 1)
	(ai_place sewer_bugger_swarm02 1)			
	(cs_run_command_script sewer_bugger_swarm01 flyfree01)
	(cs_run_command_script sewer_bugger_swarm02 flyfree02)		
)

(script dormant bugger_swarm02
	(sleep_until 
			(OR 
				(>= (ai_combat_status sewer_bugger03) 7)
				(>= (ai_combat_status sewer_bugger04) 7)

			)		
	5)
	(ai_set_objective sewer_bugger03 sewer_obj)
	(ai_set_objective sewer_bugger04 sewer_obj)	
	(sleep_forever bugger_machine02)
	(ai_place sewer_bugger_swarm03 1)
	(ai_place sewer_bugger_swarm04 1)			
	(cs_run_command_script sewer_bugger_swarm03 flyfree03)
	(cs_run_command_script sewer_bugger_swarm04 flyfree04)		
)

(script dormant bugger_swarm03
	(sleep_until 
			(OR 
				(>= (ai_combat_status sewer_bugger05) 7)
				(>= (ai_combat_status sewer_bugger06) 7)
			)		
	5)
	(ai_set_objective sewer_bugger05 sewer_obj)
	(ai_set_objective sewer_bugger06 sewer_obj)		
	(sleep_forever bugger_machine03)
	(ai_place sewer_bugger_swarm06 1)				
	(ai_place sewer_bugger_swarm05 1)
	(cs_run_command_script sewer_bugger_swarm05 flyfree05)
	(cs_run_command_script sewer_bugger_swarm06 flyfree06)		
)


(script command_script flyfree01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p2 0.25)		
	(cs_fly_to sewer_buggers/p19 1)
	(cs_abort_on_alert TRUE)		
	(ai_set_objective sewer_bugger_swarm01 sewer_obj)
)

(script command_script flyfree02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p1 0.25)		
	(cs_fly_to sewer_buggers/p19 1)
	(cs_abort_on_alert TRUE)			
	(ai_set_objective sewer_bugger_swarm02 sewer_obj)	
)

(script command_script flyfree03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p4 0.25)		
	(cs_fly_to sewer_buggers/p18 1)
	(cs_abort_on_alert TRUE)			
	(ai_set_objective sewer_bugger_swarm03 sewer_obj)
)

(script command_script flyfree04
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p10 0.25)			
	(cs_fly_to sewer_buggers/p3 0.25)		
	(cs_fly_to sewer_buggers/p18 1)
	(cs_abort_on_alert TRUE)			
	(ai_set_objective sewer_bugger_swarm04 sewer_obj)	
)

(script command_script flyfree05
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p6 0.25)		
	(cs_fly_to sewer_buggers/p20 1)
	(cs_abort_on_alert TRUE)			
	(ai_set_objective sewer_bugger_swarm05 sewer_obj)
)

(script command_script flyfree06
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p5 0.25)		
	(cs_fly_to sewer_buggers/p20 1)
	(cs_abort_on_alert TRUE)			
	(ai_set_objective sewer_bugger_swarm06 sewer_obj)	
)


(script static void bugger_init01
	(ai_place sewer_bugger01)
	(cs_run_command_script sewer_bugger01 Fly01)
	(sleep_until (volume_test_objects sewer_bugger01_trig (ai_actors sewer_bugger01))1)
	
)

(script static void bugger_init02
	(ai_place sewer_bugger02)
	(cs_run_command_script sewer_bugger02 Fly02)
	(sleep_until (volume_test_objects sewer_bugger02_trig (ai_actors sewer_bugger02))1)

)

(script static void bugger_init03
	(ai_place sewer_bugger03)
	(cs_run_command_script sewer_bugger03 Fly03)
	(sleep_until (volume_test_objects sewer_bugger03_trig (ai_actors sewer_bugger03))1)
	
)

(script static void bugger_init04
	(ai_place sewer_bugger04)
	(cs_run_command_script sewer_bugger04 Fly04)
	(sleep_until (volume_test_objects sewer_bugger04_trig (ai_actors sewer_bugger04))1)
	
)

(script static void bugger_init05
	(ai_place sewer_bugger05)
	(cs_run_command_script sewer_bugger05 Fly05)
	(sleep_until (volume_test_objects sewer_bugger05_trig (ai_actors sewer_bugger05))1)
	
)

(script static void bugger_init06
	(ai_place sewer_bugger06)
	(cs_run_command_script sewer_bugger06 Fly06)
	(sleep_until (volume_test_objects sewer_bugger06_trig (ai_actors sewer_bugger06))1)
	
)

(script command_script Fly01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p2 0.25)	
	(cs_abort_on_combat_status 7)			
	(cs_fly_to sewer_buggers/p1 0.5)
	(cs_abort_on_combat_status 9)			
	(cs_fly_to sewer_buggers/p8 0.5)
	(cs_fly_to sewer_buggers/p9 0.5)	
)

(script command_script Fly02
	(cs_enable_pathfinding_failsafe TRUE)	
	(cs_fly_to sewer_buggers/p1 0.25)	
	(cs_abort_on_combat_status 7)			
	(cs_fly_to sewer_buggers/p2 0.5)
	(cs_abort_on_combat_status 9)			
	(cs_fly_to sewer_buggers/p0 0.5)
	(cs_fly_to sewer_buggers/p7 0.5)
	
)

(script command_script Fly03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p4 0.25)		
	(cs_abort_on_combat_status 7)			
	(cs_fly_to sewer_buggers/p3 0.5)
	(cs_abort_on_combat_status 9)			
	(cs_fly_to sewer_buggers/p10 0.5)
	(cs_fly_to sewer_buggers/p11 0.5)
	
)

(script command_script Fly04
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to sewer_buggers/p3 0.25)			
	(cs_abort_on_combat_status 7)			
	(cs_fly_to sewer_buggers/p4 0.5)
	(cs_abort_on_combat_status 9)			
	(cs_fly_to sewer_buggers/p12 0.5)
	(cs_fly_to sewer_buggers/p13 0.5)	
)

(script command_script Fly05
	(cs_enable_pathfinding_failsafe TRUE)	
	(cs_fly_to sewer_buggers/p6 0.25)	
	(cs_abort_on_combat_status 7)			
	(cs_fly_to sewer_buggers/p5 0.5)
	(cs_abort_on_combat_status 9)			
	(cs_fly_to sewer_buggers/p16 0.5)
	(cs_fly_to sewer_buggers/p17 0.5)	
)

(script command_script Fly06
	(cs_enable_pathfinding_failsafe TRUE)	
	(cs_fly_to sewer_buggers/p5 0.25)
	(cs_abort_on_combat_status 7)				
	(cs_fly_to sewer_buggers/p6 0.5)
	(cs_abort_on_combat_status 9)				
	(cs_fly_to sewer_buggers/p14 0.5)
	(cs_fly_to sewer_buggers/p15 0.5)				
	
)

;========================020_07_BARRACKS ENCOUNTER==============================


(script dormant barracks_rats
	(begin_random
		(if (< random_rats 1)
			(begin
				(flock_create barracks_rats_01)
				(set random_rats (+ random_rats 1))
			)
		)
	)
	(set random_rats 0)
	(sleep 60)
	(flock_stop barracks_rats_01)
)

(global short var_barracks_pos 0)

(script dormant 020_07_barracks
	(data_mine_set_mission_segment "020_07_barracks_pt1")
	(game_save)
	(set base_obj_control 90)
	(wake 020_music_105)
	(wake 020_music_106)	
	(wake 020_music_11)
	(wake Evac02_Elevator_Activate)		
	(wake 09_rumble_event_weak)
	(sleep_until (> (device_get_position 020_06_d1) 0))
	(ai_dialogue_enable true)													
	(ai_set_objective 020_arbiter barracks_marine_obj)
	(ai_set_objective barracks_sgt barracks_marine_obj)

	(wake 020VE_BRUTE_THROW_MARINE)		

	(ai_place barracks_jack01)
	(ai_place barracks_pack2_01)
	(ai_place barracks_pack3_01)
	(ai_place barracks_pack3_01_legendary)
	
	(wake barracks_rats)

	(sleep 10)

	(wake 020VE_MARINE_DIES)
	(wake vt_07_barracks_02)
	(wake vt_07_barracks_03)
	(wake 020_07_player_position)
	(wake obj_barracks_clear)
	(wake obj_evacuate_set)	
	
	(wake md_07_barracks_exit)
			
	(sleep_until (= (device_get_position barracks_door_end) 1) 5)
	(wake md_07_barracks_marines)

	(ai_dialogue_enable true)													
	(vs_release arbiter)
	(wake md_08_joh_cc_retreat)
	(sleep_until (= (device_get_position barracks_evac_hangar_door) 1) 5)
	(set g_music_020_11 TRUE)
	(set g_music_020_106 FALSE)
)

(script dormant 020_07_player_position
	(sleep_until (volume_test_players barracks_player_vol01)5)
	(data_mine_set_mission_segment "020_07_barracks_pt2")
	(set g_music_020_105 TRUE)
	(set g_music_020_106 TRUE)
	(set var_barracks_pos 1)
	(game_save)
	(ai_place barracks_pack4_01)
	(ai_place barracks_pack5_01)
	(ai_place barracks_chieftain)
	(ai_place barracks_bodyguards)
	(ai_place barracks_jack02)	
	(ai_place barracks_marine05)
	(ai_place barracks_marine06)
	(ai_place barracks_marine07)
	
	(wake Barracks_Marine05_Anim)
	(wake Barracks_Marine06_Anim)
	(wake Barracks_Marine07_Anim)
			
	(sleep_until (volume_test_players barracks_player_vol02)5)
	(set var_barracks_pos 2)
	(game_save)	
	(sleep_until (volume_test_players barracks_player_vol03)5)
	(data_mine_set_mission_segment "020_07_barracks_pt3")				
	(set var_barracks_pos 3)
	(game_save)	
	(sleep_until (volume_test_players barracks_player_vol04)5)
	(set var_barracks_pos 4)
	(sleep_until (volume_test_players barracks_marine_end_trig) 5)
	(set var_barracks_pos 5)
	(game_save)	
	(sleep_until (= (device_get_position barracks_door_end) 1) 5)
	(ai_migrate 020_arbiter evac_arbiter)	

)

(script dormant 020_07_Disregard_Marines
	(ai_disregard (ai_actors barracks_marine01) true)
	(ai_disregard (ai_actors barracks_marine02) true)
	(ai_disregard (ai_actors barracks_marine03) true)
	(ai_disregard (ai_actors barracks_marine04) true)
	(ai_disregard (ai_actors barracks_marine05) true)
	(ai_disregard (ai_actors barracks_marine06) true)
	(ai_disregard (ai_actors barracks_marine07) true)
)

;========================020_08_EVAC_HANGAR ENCOUNTER==============================

(script dormant evac_rats
	(begin_random
		(if (< random_rats 1)
			(begin
				(flock_create evac_rats_01)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 1)
			(begin
				(flock_create evac_rats_02)
				(set random_rats (+ random_rats 1))
			)
		)
		(if (< random_rats 1)
			(begin
				(flock_create evac_rats_03)
				(set random_rats (+ random_rats 1))
			)
		)
	)
	(set random_rats 0)
	(sleep 60)
	(flock_stop evac_rats_01)
	(flock_stop evac_rats_02)
	(flock_stop evac_rats_03)
)

(global short var_evac_hangar_pos 0)
(global boolean landing_pad_start FALSE)

(script dormant 020_08_Evac_Hangar
	(game_save)
	(data_mine_set_mission_segment "020_08_evac_hangar_pt1")
	(wake evac_hangar_kill_player)
	(flock_create hornet_evac)
	(flock_create banshees_evac)
	(sleep 1)
	(flock_start hornet_evac)
	(flock_start banshees_evac)
;	(flock_start pelican_evac)
	(ai_place evac_hangar_hum_pelican)
	(cs_run_command_script evac_hangar_hum_pelican/pilot 020_08_Pelican_Init)	
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican/pilot))						
	(ai_cannot_die evac_hangar_hum_pelican/pilot TRUE)
;	(object_create_anew_containing evac_crate)


	(sleep_until (volume_test_players evac_hangar_elevator01_trig) 5)
;	(wake 020_08_Arbiter_arrives)
	(set base_obj_control 100)	
	(add_recycling_volume g_barracks_trig_a 0 10)
	(add_recycling_volume g_barracks_trig_b 2 30)	
	(add_recycling_volume g_barracks_trig_c 5 30)
	(sleep_until (volume_test_players evac_hangar_joh_event_trig)5)
	(object_create_folder crates_evac_hangar_folder)
			
	(sleep_until (volume_test_players evac_hangar_begin_encounter) 5)
	(set landing_pad_start TRUE) ;needed for marine objectives		
	(ai_bring_forward obj_arbiter 5)

	(020_08_Jetpack_Wave01)
	
	(wake md_08_evac_pelican_01)
	
	(sleep_until (or (> (device_get_position evac02_elev_top) 0)
				(volume_test_players evac_hangar_encounter06_trig)
				(volume_test_players evac_hangar_encounter06_1_trig))
	)
	
	(game_save)
	; badness
	(wake 020_08_Pelican_Landing_Pad)
	
	(set var_evac_hangar_pos 1)
	
	(sleep_until (OR (<= (ai_living_count evac_hangar_cov_wave01) 3) (volume_test_players evac_hangar_encounter08_trig)))

	(wake 020_08_Pelican_Returns)

	(sleep_until (<= (ai_living_count evac_hangar_cov_wave01) 2))
		
	(020_08_Jetpack_Wave02)

	(sleep_until (<= (ai_living_count evac_hangar_jetpack) 2)5)
	
	(020_08_Jetpack_Wave03)
	
	(game_save)

)

(script continuous evac_hangar_kill_player
	(sleep_until (volume_test_players evac_hangar_kill_trig)5)
	(cond
		((volume_test_object evac_hangar_kill_trig (player0))
		(unit_kill (unit (player0))))
		((volume_test_objects evac_hangar_kill_trig (player1))
		(unit_kill (unit (player1))))
		((volume_test_objects evac_hangar_kill_trig (player2))
		(unit_kill (unit (player2))))
		((volume_test_objects evac_hangar_kill_trig (player3))
		(unit_kill (unit (player3))))
	)
)

(script dormant 020_08_Pelican_Returns
	(sleep 60)
	(sleep_until (< (ai_living_count evac_hangar_cov_wave02) 2))
	(set var_evac_hangar_pos 2)

	(sleep_until (< (ai_living_count evac_hangar_jetpack) 1))
	(set g_music_020_11 FALSE)
	
	(set var_evac_hangar_pos 3)
	(zone_set_trigger_volume_enable zone_set:020_06_08_04_encounter TRUE)				
	(ai_place evac_hangar_hum_pelican02)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican02/pilot))						
	
	(ai_vehicle_reserve_seat evac_hangar_hum_pelican02 "pelican_p_l01" TRUE)	
	(ai_vehicle_reserve_seat evac_hangar_hum_pelican02 "pelican_e" TRUE)	

	(data_mine_set_mission_segment "020_08_evac_hangar_pt2")

	(cs_run_command_script evac_hangar_hum_pelican02/pilot 020_08_Pelican_Land)
)

(global short jetpack_no 0)

(script dormant kill_straggler_jetpacks
	(sleep_until
		(begin
			(if 
				(AND
			          (= (objects_can_see_object (players) (list_get (ai_actors evac_hangar_jetpack) jetpack_no) 45) FALSE)
			          (> (objects_distance_to_object (players) (list_get (ai_actors evac_hangar_jetpack) jetpack_no)) 21)
				)	
					(begin
				     	(object_destroy (list_get (ai_actors evac_hangar_jetpack) jetpack_no))
				     	(print "Jetpack Brute out of view, auto-destroyed")
				     )
			)			
			(set jetpack_no (+ jetpack_no 1))
			(if (> jetpack_no 15)
				(set jetpack_no 0)
			)
		(< (ai_living_count evac_hangar_jetpack) 1))
	)
)

; FIRST_PLAYTEST 
(script dormant 020_08_Arbiter_arrives
; This script is a temp script and will check if the player hits the top of the elevator in evac hangar and then for the arbiter. 
; If the arbiter is not there, it will teleport the arbiter to the point after 30 seconds. 
; The final script will be far more complex, (move the elevator down, script the arbiter to get into it and then bring the elevator up).
	(sleep_until (volume_test_players top_elevator_trigger)15)
; Lock the control switch so the playtest players can't activate it again.
	
;	(if (not (volume_test_objects top_elevator_trigger (ai_actors arbiter)))
;		(begin
;			(sleep 300)
;			(object_teleport (list_get (ai_actors evac_arbiter) 0) arbiter_teleport)
;		)
;	)
	
;	(sleep_until (not (volume_test_objects top_elevator_trigger (ai_actors evac_arbiter))) 1)
;	(sleep 900)
;	(object_teleport (list_get (ai_actors evac_arbiter) 0) arbiter_teleport)
)


(global boolean covenant_clear FALSE)

(script dormant 020_08_Pelican_Landing_Pad
	(sleep_until (= (device_get_position elevator_evac_02) 0))
	(sleep 30)
	(sleep_until (OR 	(< (ai_strength evac_hangar_jetpack010) 1)
					(< (ai_strength evac_hangar_jetpack011) 1)
					(< (ai_strength evac_hangar_jetpack012) 1)
					(< (ai_strength evac_hangar_jetpack013) 1)
					)15 90)
	(ai_disregard (ai_actors evac_hangar_hum_pelican) true)					
	(cs_run_command_script evac_hangar_hum_pelican/pilot 020_08_Pelican_Intro)	

)

(script static void 020_08_Jetpack_Wave01

	(ai_place	evac_hangar_jetpack010)
	(ai_place	evac_hangar_jetpack011)
	(ai_place	evac_hangar_jetpack012)
	(ai_place	evac_hangar_jetpack013)

	(cs_run_command_script evac_hangar_jetpack010 020_08_Jetpack010)
	(cs_run_command_script evac_hangar_jetpack011 020_08_Jetpack011)
	(cs_run_command_script evac_hangar_jetpack012 020_08_Jetpack012)
	(cs_run_command_script evac_hangar_jetpack013 020_08_Jetpack013)

)

(script static void 020_08_Jetpack_Wave02
	(ai_place	evac_hangar_jetpack05)
;	(cs_run_command_script evac_hangar_jetpack05 020_08_Jetpack05)
	(ai_place	evac_hangar_jetpack06)	
;	(cs_run_command_script evac_hangar_jetpack06 020_08_Jetpack06)
	(ai_place	evac_hangar_jetpack08)	
;	(cs_run_command_script evac_hangar_jetpack08 020_08_Jetpack08)
	(ai_place	evac_hangar_jetpack09)	
;	(cs_run_command_script evac_hangar_jetpack09 020_08_Jetpack09)
	(ai_place	evac_hangar_jetpack07_legend)	
	
	(sleep_until (> (ai_living_count evac_hangar_cov_wave02) 3) 5) ; checks to make sure wave02 actually spawns before moving to the next wave
)

(script static void 020_08_Jetpack_Wave03

	(device_set_position evac_door_surprise 1)
	(device_set_position barracks_evac_hangar_door 1)
	(device_set_position 020_06_d1 1)
	(ai_place	evac_hangar_jetpack01)
	(ai_place	evac_hangar_jetpack04)
	(ai_place	evac_hangar_jetpack02)
	(ai_place	evac_hangar_jetpack03)
	(device_set_power 020_06_c4a 1)
	(device_set_power evac_hangar_control_door 1)
	(device_set_position evac_hangar_control_door 1)
	(cs_run_command_script evac_hangar_jetpack01 020_08_Jetpack01)
	(cs_run_command_script evac_hangar_jetpack02 020_08_Jetpack02)
	(cs_run_command_script evac_hangar_jetpack03 020_08_Jetpack03)
	(cs_run_command_script evac_hangar_jetpack04 020_08_Jetpack04)
	
	(sleep_until (and 	(not (volume_test_objects jet_pack_door_close_trig (ai_actors evac_hangar_jetpack01)))
					(not (volume_test_objects jet_pack_door_close_trig (ai_actors evac_hangar_jetpack02)))
					(not (volume_test_objects jet_pack_door_close_trig (ai_actors evac_hangar_jetpack03)))
					(not (volume_test_objects jet_pack_door_close_trig (ai_actors evac_hangar_jetpack04)))) 5)
	(device_set_position evac_hangar_control_door 0)
	(sleep 300)	
	(wake kill_straggler_jetpacks)
	
)

(script command_script 020_08_Jetpack01
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
)
(script command_script 020_08_Jetpack02
	(cs_movement_mode ai_movement_combat)	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
)
(script command_script 020_08_Jetpack03
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
)
(script command_script 020_08_Jetpack04
	(cs_movement_mode ai_movement_combat)	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
)
(script command_script 020_08_Jetpack05
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
)
(script command_script 020_08_Jetpack06
	(cs_movement_mode ai_movement_combat)	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
)
(script command_script 020_08_Jetpack08
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
)
(script command_script 020_08_Jetpack09
	(cs_movement_mode ai_movement_combat)	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
)

(script command_script 020_08_Jetpack010
	(cs_movement_mode ai_movement_combat)	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
	(cs_abort_on_alert TRUE)		
)

(script command_script 020_08_Jetpack011
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
	(cs_abort_on_alert TRUE)		
)

(script command_script 020_08_Jetpack012
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
	(cs_abort_on_alert TRUE)	
)

(script command_script 020_08_Jetpack013
	(cs_movement_mode ai_movement_combat)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_nearest evac_hangar_jetpack)
	(sleep 1)
	(cs_abort_on_alert TRUE)		
)


(script dormant 020_08_Evac_Marines
	(sleep 30)
;	(sleep_until (= briefing_play FALSE))
	(ai_place evac_hangar_cov_buggers)
	(cond
		((>= (ai_living_count evac_safe_marines) 7) 
			(begin
				(ai_place evac_hangar_johnson)
				(ai_place evac_reinf_marines 1)
				(if debug (print "Good work Chief, you saved all of the marines!"))
			)
		)
		((= (ai_living_count evac_safe_marines) 6)
		
			(begin
				(ai_place evac_hangar_johnson)			
				(ai_place evac_reinf_marines 2)
				(if debug (print "Seems we lost a marine!"))
			)
		)
		((= (ai_living_count evac_safe_marines) 5)
		
			(begin
				(ai_place evac_hangar_johnson)			
				(ai_place evac_reinf_marines 3)
				(if debug (print "Looks like two didn't make it."))
			)
		)
		((< (ai_living_count evac_safe_marines) 5)
			(begin
				(ai_place evac_hangar_johnson)			
				(ai_place evac_reinf_marines 4)
				(if debug (print "Looks like we lost a fair amount in the barracks."))				
			)
		)
	)
	(cs_run_command_script evac_safe_marines evac_pelican_load)

	(device_set_position evac_hangar_highway_door 1)	
	(wake evac_hangar_navpoint_active)
	(wake evac_hangar_navpoint_deactive)	
	(sleep_until (= (device_get_position evac_hangar_highway_door) 1))

	(ai_migrate evac_reinf_marines evac_safe_marines)
	
	(wake md_08_joh_evac_arrives)

	(sleep_until 
		(and
			(= (ai_living_count evac_hangar_hum_pelican02) (ai_in_vehicle_count evac_hangar_hum_pelican02))
			(= (ai_living_count evac_safe_marines) 0)
		)
	)
	(sleep_until (= (unit_in_vehicle (unit (ai_get_object johnson))) TRUE))			
	(if (not (game_is_cooperative))
		(begin
			(cs_run_command_script evac_arbiter evac_pelican_load_arbiter)
			(sleep_until (= (unit_in_vehicle (unit obj_arbiter)) TRUE)30 600)
			(unit_set_active_camo evac_arbiter true 0)			
			(sleep 1)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location evac_hangar_hum_pelican02/pilot) "pelican_p_l01" obj_arbiter)
			(sleep 1)
			(unit_set_active_camo evac_arbiter false 3)
			(sleep_until (= (unit_in_vehicle (unit obj_arbiter)) TRUE))	
		)
	)

	(sleep 90)
	(cs_run_command_script evac_hangar_hum_pelican02/pilot 020_08_Pelican_take_off)
	
)

(script dormant 020_08_Landing_pad_filter
	; this checks to see if the marines have made it with the chief to the evac landing pad. If so, they are 'safe' and will be picked up by the pelican.
	(sleep_until
		(begin
			(if  
				(volume_test_objects g_evac_top_trig_a (ai_actors evac_hangar_marine01) )
				(ai_migrate evac_hangar_marine01 evac_safe_marines)
			)
			(if 
				(volume_test_objects g_evac_top_trig_a (ai_actors evac_hangar_marine02) )
				(ai_migrate evac_hangar_marine02 evac_safe_marines)
			)
			(if 
				(volume_test_objects g_evac_top_trig_a (ai_actors evac_hangar_marine03) )
				(ai_migrate evac_hangar_marine03 evac_safe_marines)
			)
			(if  
				(volume_test_objects g_evac_top_trig_a (ai_actors evac_hangar_marine04))
				(ai_migrate evac_hangar_marine04 evac_safe_marines)
			)
			(if 
				(volume_test_objects g_evac_top_trig_a (ai_actors evac_hangar_marine04) )
				(ai_migrate evac_hangar_marine05 evac_safe_marines)
			)									
			(if 
				(volume_test_objects g_evac_top_trig_a (ai_actors evac_hangar_marine05) )
				(ai_migrate evac_hangar_marine05 evac_safe_marines)
			)
			(if 
				(volume_test_objects g_evac_top_trig_a (ai_actors evac_hangar_marine06) )
				(ai_migrate evac_hangar_marine06 evac_safe_marines)
			)
			(if 
				(volume_test_objects g_evac_top_trig_a (ai_actors evac_hangar_marine07) )
				(ai_migrate evac_hangar_marine07 evac_safe_marines)
			)
		(= briefing_play FALSE))
	)
	(ai_disposable evac_hangar_marines TRUE)
)

(script command_script 020_08_Pelican_Init

	(sleep_forever)
)

(global boolean evac_encounter_begin FALSE)

(script command_script 020_08_Pelican_Intro
	(cs_vehicle_speed 0.7)
	(cs_face TRUE evac_hangar_pelican01/p4)
	(set evac_encounter_begin TRUE)
	(cs_fly_to evac_hangar_pelican01/p18 0.7)	
	(object_set_physics evac_hangar_hum_pelican/pilot false)	
	(cs_fly_to evac_hangar_pelican01/p2 0.7)
	(cs_face FALSE evac_hangar_pelican01/p4)
	(cs_vehicle_speed 1)
	(sleep_until
		(begin
			(if (<= var_evac_hangar_pos 2)
			(cs_fly_to evac_hangar_pelican01/p12 10))
			(if (<= var_evac_hangar_pos 2)			
			(cs_fly_to evac_hangar_pelican01/p15 10))
			(if (<= var_evac_hangar_pos 2)			
			(cs_fly_to evac_hangar_pelican01/p13 10))
			(if (<= var_evac_hangar_pos 2)			
			(cs_fly_to evac_hangar_pelican01/p16 10))
			(if (<= var_evac_hangar_pos 2)			
			(cs_fly_to evac_hangar_pelican01/p14 10))
		(> var_evac_hangar_pos 2))
	)
	(cs_fly_to evac_hangar_pelican01/p14 1)
	(ai_erase evac_hangar_hum_pelican)
)


(script command_script 020_08_Pelican_Land
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (= (current_zone_set_fully_active) 7) 5)	
;	(wake br_08_evac_destroy_base)
	(sleep 30)
	(wake 020_08_Landing_pad_filter)
	(wake obj_evacuate_clear)						
	(cs_vehicle_speed 0.7)
	(cs_fly_to evac_hangar_pelican01/p11 1)
	(wake 020_08_Evac_Marines)		
	(cs_face TRUE evac_hangar_pelican01/p9)
	(unit_open (ai_vehicle_get ai_current_actor))
	(cs_fly_to evac_hangar_pelican01/p10 0.1)

	(sleep_forever)
	
)

(script command_script 020_08_Pelican_take_off
	(cs_vehicle_speed 0.7)
	(cs_face TRUE evac_hangar_pelican01/p4)
	(cs_fly_to evac_hangar_pelican01/p18 0.7)
	(object_set_physics evac_hangar_hum_pelican02/pilot false)	
	(cs_fly_to evac_hangar_pelican01/p0 0.8)
	(cs_face FALSE evac_hangar_pelican01/p4)	
	(cs_fly_to evac_hangar_pelican01/p16 0.8)
	(ai_erase evac_hangar_hum_pelican02)
		
)
;========================020_09_CORTANA_HIGHWAY ENCOUNTER==============================
(global short var_cortana_highway_pos 0)

(script dormant 020_09_cortana_highway
	(data_mine_set_mission_segment "020_09_cortana_highway_pt1")			
	(game_save)
	(sleep_forever obj_self_destruct_set)
	(game_insertion_point_unlock 2)
	(if (= (game_insertion_point_get) 2)
	(zone_set_trigger_volume_enable zone_set:020_06_08_04_encounter TRUE))	
	(wake 020_title3)
	(wake cortana_moment_b) ;new cortana moment
	(wake 11_rumble_event_weak)
	(set base_obj_control 110)	
	(wake md_08_joh_reminder)	
	(wake cortana_navpoint_active)	
	(wake cortana_navpoint_deactive)

	(ai_place cortana_highway_cov02)
	(ai_place cortana_highway_cov06)
	(ai_place cortana_highway_cov07)
	(ai_place cortana_highway_grunt_turret01)
	(ai_place cortana_highway_grunt_turret02)
	(ai_place cortana_highway_grunt_turret03)
	(ai_place cortana_highway_grunt_turret04)
	(ai_place cortana_highway_turret05_legend)	
	(ai_place cortana_highway_grunt_reinf01)
	(ai_place cortana_highway_grunt_reinf02)	
	(sleep_until (> (device_get_position cortana_encounter_door) 0)5)
	(game_save)
	(data_mine_set_mission_segment "020_09_cortana_highway_pt2")
	(set base_obj_control 120)

	(device_set_position motor_pool_start_door 1)
	(device_set_power loop02_begin_switch_b 1)
	(device_set_power loop02_begin_switch 1)
		
;	(cs_run_command_script cortana_highway_grunt_turret02 grunt_having_fun)
	
	(device_set_position_immediate motor_pool_highway_door 1)
	(wake 020_09_player_position)
	(device_set_power motor_pool_switch_a 1)
		
	(object_destroy_containing motor_pool_crate)

	(wake cortana02_navpoint_active)
	(wake cortana02_navpoint_deactive)	
)

(script command_script grunt_having_fun
	(cs_shoot_point TRUE cortana_highway_script/p0)
	(sleep 60)
	(cs_shoot_point FALSE cortana_highway_script/p0)	
	(sleep 30)
	(cs_shoot_point TRUE cortana_highway_script/p1)
	(sleep 60)
	(cs_shoot_point FALSE cortana_highway_script/p1)	
	(sleep 30)
	(cs_shoot_point TRUE cortana_highway_script/p2)
	(sleep 60)
	(cs_shoot_point FALSE cortana_highway_script/p2)	
)

(script dormant 020_09_player_position
	(sleep_until (volume_test_players cortana_highway_var_trig01) 5)
	(set var_cortana_highway_pos 1)
	(sleep_until (volume_test_players cortana_highway_var_trig02) 5)
	(set var_cortana_highway_pos 2)
	(game_save)	
	(sleep_until (volume_test_players cortana_highway_var_trig03) 5)
;	(set var_cortana_highway_pos 30)
	(game_save)
)

(script command_script 020_09_transition

	(ai_set_objective ai_current_squad cortana_highway_ext_obj)
	;need to do this here as it overlaps into another bsp
)

;*(script dormant 020_09_Brute_04_fallback

	(sleep_until (>= (ai_body_count cortana_highway_obj/cov04_brute) 1))
	(ai_set_objective cortana_highway_cov04 cortana_highway_ext_obj)
	;need to do this here as it overlaps into another bsp

)
*;
;========================020_10_SELF_DESTRUCT ENCOUNTER==============================
	
(script dormant 020_10_self_destruct
	(data_mine_set_mission_segment "020_10_self_destruct")
	(wake 020_music_12)
	(wake 020_music_13)
	(wake 020_music_135)
	(device_group_change_only_once_more_set 020_01_g3 TRUE)
	(game_save)
	(device_set_position_immediate command_center_cin_door 0)
	(wake 13_rumble_event_medium)	
	(wake 14_rumble_event_medium)
	(flock_create hangar_a_return_banshees_from)
	(flock_create hangar_a_return_banshees_to)
	(sleep 1)
	(flock_start hangar_a_return_banshees_from)
	(flock_start hangar_a_return_banshees_to)
	(object_create_anew cov_capital_ship01)		
	(object_create_anew ark_closed)
;	(objects_attach main_sky "ark" ark_closed "")
	
	(set base_obj_control 130)
	(wake 02_10_bomb)
	(sleep 1)
	(object_create_anew_containing cc_blood)
	(object_create_anew loop01_return_crate_bomb)
	(wake destruct_bomb_navpoint_active)						
	(ai_place self_destruct_cov01)
	(ai_place self_destruct_cov02)
	(ai_place self_destruct_cov03)
	(ai_place self_destruct_cov05_legend)
	(ai_place self_destruct_cov06_legend)	
	(device_set_power 020_01_c1a 0)
	(object_create_folder cc_dmg_fx)
	(object_destroy loop01_return_crate_shotgun)
	(object_create_anew self_destruct_crate_empty)
	(object_create_anew self_destruct_switch)
	(object_create_anew pda_01)
	(object_destroy_containing cc_monitor)
	(object_create_anew_containing cc_monitor_destroy)
	(object_destroy_containing cc_computer)
	(object_destroy_containing cc2_computer)
	(object_destroy cc_med_console)
	(object_create_anew_containing cc_crashed)
	(sleep 1)
	(object_damage_damage_section cc_crashed01 "main" 1)
	(object_damage_damage_section cc_crashed02 "main" 1)
	(object_damage_damage_section cc_crashed03 "main" 1)
	(object_damage_damage_section cc_crashed04 "main" 1)
	(object_damage_damage_section cc_crashed05 "main" 1)
	(object_damage_damage_section cc_crashed06 "main" 1)
	(object_damage_damage_section cc_crashed07 "main" 1)
	(object_damage_damage_section cc_crashed08 "main" 1)
	(object_damage_damage_section cc_crashed09 "main" 1)
	(object_damage_damage_section cc_crashed10 "main" 1)
	(object_damage_damage_section cc_crashed11 "main" 1)
	(object_damage_damage_section cc_crashed12 "main" 1)
	(object_damage_damage_section cc_crashed13 "main" 1)
	(object_damage_damage_section cc_crashed14 "main" 1)
	(object_damage_damage_section cc_crashed15 "main" 1)
	(object_damage_damage_section cc_crashed16 "main" 1)
	(object_damage_damage_section cc_crashed17 "main" 1)
	(object_damage_damage_section cc_crashed18 "main" 1)
	(object_damage_damage_section cc_crashed19 "main" 1)
	(object_damage_damage_section cc_crashed20 "main" 1)
	(object_damage_damage_section cc_crashed21 "main" 1)
	(object_damage_damage_section cc_crashed22 "main" 1)
	(object_damage_damage_section cc_crashed23 "main" 1)
	(object_damage_damage_section cc_crashed29 "main" 1)
	(object_destroy cc_tacboard)
	(object_create_anew cc_tacboard_damaged)
	(device_set_position cave_a_door_command 0)

	(object_create_anew_containing command_)
	(device_set_power self_destruct_switch 1)

	(sleep_forever md_08_joh_reminder)	
	(sleep_forever md_08_joh_reminder_a)	
	(sleep_forever md_08_joh_reminder_b)	
	(sleep_forever md_08_joh_reminder_c)	
	(ai_dialogue_enable true)												

	(sleep_until (> (device_get_position loop02_begin_door) 0))
	(wake 020VF_TRUTH_REPRIMAND)
	(sleep 30)

	(sleep_until 
		(OR
			(script_finished 020VF_TRUTH_REPRIMAND)
			(< (ai_living_count self_destruct_all) 1)
			(= (volume_test_players cave_a_dia03_trig) TRUE)
		)
	)
	(texture_camera_off)
	(sleep 1)
;	(object_set_always_active (ai_get_object fake_truth/truth) 0)
	(ai_erase fake_truth)
	(object_destroy grav_throne)
	(device_set_position cortana_encounter_door 0)
	(wake md_10_self_destruct_joh)
	(sleep_until (< (ai_living_count self_destruct_all) 1)5)
	(set g_music_020_12 TRUE)
	
)

(script dormant 02_10_bomb
	(sleep_until (> (device_get_position self_destruct_switch) 0)5)
	(volume_teleport_players_not_inside self_destruct_coop_teleport command_center_coop_flag)
	(wake destruct_bomb_navpoint_deactive)
	(wake rumble_event_strong_loop)
	(sleep_forever md_10_self_destruct_joh)
	(ai_dialogue_enable true)													
	(device_set_power sec_light01 1)
	(device_group_change_only_once_more_set 020_01_g3 TRUE)
	(device_set_power loop02_begin_switch 0)
	(device_set_power loop02_begin_switch_b 0)									
	(device_set_position loop02_begin_door 0)
	(sleep_until (= (device_get_position loop02_begin_door) 0)5)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_exit_encounter true)
	(zone_set_trigger_volume_enable zone_set:020_00_01_exit_encounter true)		
	(game_save)
	(wake br_10_command_objective)
	(wake obj_self_destruct_clear)
	(wake obj_exit_set)	
	(sleep_until (or (volume_test_players cave_a_start_trig)(= briefing_play FALSE))5)
	(ai_place self_destruct_cov04)
	(ai_force_active self_destruct_cov04 TRUE)
	(device_set_position cave_a_door_command 1)
	(wake self_destruct_navpoint_active)
	(wake self_destruct_navpoint_deactive)	

)

;========================020_11_CAVE_A_HIGHWAY ENCOUNTER==============================


(script dormant 020_11_exit_run
	(data_mine_set_mission_segment "020_11_Exit_run")
	(wake 020_music_14)	
	(wake cortana_moment_c)
	(object_destroy hangar_a_pipes)
	(object_create_anew hangar_a_pipes_broke)
	(device_set_power sec_light02 1)
	(device_set_power sec_light05 1)	
;	(wake 15_rumble_event_strong)
	(set base_obj_control 140)					
	(device_set_position cave_a_door_hallway02 1)
	(device_set_position cave_a_door_hallway01 0)
	(object_create_anew_containing exit_run_rock)
	(ai_place exit_run_cov03)
	(ai_place exit_run_cov04)
	(ai_place exit_run_cov05)
;	(ai_place exit_run_cov06)
;	(cs_run_command_script exit_run_cov03 cs_flee)
;	(cs_run_command_script exit_run_cov05 cs_flee)
;	(cs_run_command_script exit_run_cov06 cs_flee)
	(sleep_until (volume_test_players command_exit_trig) 1)

	(sleep_until (volume_test_players cave_a_marine_1)5)
	(sleep_forever md_11_cave_hangar_joh02)	
	(ai_dialogue_enable true)													
	(sleep_until (volume_test_players cave_a_hwy_marines03_trig)5)
	(device_set_power sec_light04 1)
	(device_set_power sec_light06 1)
	(ai_place exit_run_cov01)
;	(cs_run_command_script exit_run_cov01 cs_flee)
	
	(ai_place exit_run_cov02)
;	(cs_run_command_script exit_run_cov02 cs_flee)
	
	(sleep_until (volume_test_players highway_a_start_trig)1)
	(ai_place exit_run_buggers)
	(cs_run_command_script exit_run_buggers cs_bugger_flee)	
	(wake kill_bugger)
	
)

(script dormant kill_bugger
	(set straggler_no 0)
	(sleep_until
		(begin
			(if (volume_test_objects bugger_kill (list_get (ai_actors exit_run_buggers) straggler_no))
  					(begin
				     	(ai_erase (object_get_ai (list_get (ai_actors exit_run_buggers) straggler_no)))
				     )
			)		
			(set straggler_no (+ straggler_no 1))
			(if (> straggler_no 20)
				(set straggler_no 0)
			)
		(< (ai_living_count exit_run_buggers) 1))
	1)
)

(script static void test_buggers
	
	(ai_place exit_run_buggers)
	(cs_run_command_script exit_run_buggers cs_bugger_flee)
	(wake kill_bugger)
)

(script command_script cs_flee
	(cs_suppress_activity_termination 1)
	(cs_abort_on_damage TRUE)
	(cs_enable_moving TRUE)
	(cs_movement_mode ai_movement_flee)
	(sleep_forever)
)
(script command_script cs_flee_interrupt
	(cs_suppress_activity_termination 1)
	(cs_abort_on_damage TRUE)
	(cs_abort_on_alert TRUE)
	(cs_enable_moving TRUE)
	(cs_movement_mode ai_movement_flee)
	(sleep_forever)
)
(script command_script cs_bugger_flee
	(cs_movement_mode ai_movement_flee)
	(cs_shoot FALSE)
	(cs_enable_moving TRUE)
	(sleep_forever)
)
;========================020_12_HANGAR_A_RETURN ENCOUNTER==============================

(script dormant 020_12_hangar_a_return
;	(wake Exit01_Elevator_Activate)
	(wake cortana_moment_e)
	(wake cortana_moment_f) ; base blows up here
	(device_set_power sec_light03 1)			
	(object_destroy_containing hangar_a_return_object)
	(device_set_position door_highway_hangar01 1)	
	(sleep 60)
	(ai_place Hangar_A_Return_cov01)
	(print "SPAWN ENEMIES")
	(ai_place Hangar_A_Return_cov02)
	(ai_place Hangar_A_Return_cov03)
	(ai_place Hangar_A_Return_cov04)
	(ai_place Hangar_A_Return_cov06)
	(ai_place Hangar_A_Return_cov05)		
	(ai_place Hangar_A_Return_phantom01)
	(object_set_shadowless Hangar_A_Return_phantom01/pilot TRUE)
;	(object_cannot_die (ai_vehicle_get_from_starting_location Hangar_A_Return_phantom01/pilot) TRUE)	
;	(ai_cannot_die Hangar_A_Return_phantom01/pilot TRUE)
;	(object_cannot_take_damage (ai_vehicle_get_from_starting_location Hangar_A_Return_phantom01/pilot))
	(sleep_until (volume_test_players hangar_a_entrance_trig) 5)
	(game_save)	
	(device_set_position cave_a_door_command 0)
	(data_mine_set_mission_segment "020_12_hangar_a_return")
	(set base_obj_control 150)						
	(add_recycling_volume g_cortana_highway_trig_c 15 10)

;	(cs_run_command_script Hangar_A_Return_cov06 cs_flee)
;	(cs_run_command_script Hangar_A_Return_cov03 cs_flee)
;	(cs_run_command_script Hangar_A_Return_cov02 cs_flee)
	
	(sleep_until (volume_test_players hangar_a_door_entrance_trig) 5)
	(cs_run_command_script Hangar_A_Return_phantom01/pilot 020_12_PhantomInitPath)
	(cs_run_command_script Hangar_A_Return_cov05/01 020_12_Grunt_Init01)
	(cs_run_command_script Hangar_A_Return_cov05/02 020_12_Grunt_Init02)
	(cs_run_command_script Hangar_A_Return_cov05/03 020_12_Grunt_Init03)
	(cs_run_command_script Hangar_A_Return_cov05/04 020_12_Grunt_Init04)
	(set g_music_020_14 TRUE)

)

(script static void grunt_test
	(ai_place Hangar_A_Return_phantom01)
	(cs_run_command_script Hangar_A_Return_phantom01/pilot 020_12_PhantomInitPath)

	(ai_place Hangar_A_Return_cov05)		
	(cs_run_command_script Hangar_A_Return_cov05/01 020_12_Grunt_Init01)
	(cs_run_command_script Hangar_A_Return_cov05/02 020_12_Grunt_Init02)
	(cs_run_command_script Hangar_A_Return_cov05/03 020_12_Grunt_Init03)
	(cs_run_command_script Hangar_A_Return_cov05/04 020_12_Grunt_Init04)
	
)

(script command_script 020_12_Grunt_Init01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(cs_go_to hangar_a_vignette/p0)
	(sleep 150)	
)
(script command_script 020_12_Grunt_Init02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(cs_go_to hangar_a_vignette/p1)
	(sleep 150)	
)
(script command_script 020_12_Grunt_Init03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(cs_go_to hangar_a_vignette/p2)
	(sleep 150)	
)
(script command_script 020_12_Grunt_Init04
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_movement_mode ai_movement_flee)
	(cs_go_to hangar_a_vignette/p3)
	(sleep 150)		
)
(script command_script 020_12_PhantomInitPath

;	(ai_trickle_via_phantom Hangar_A_Return_phantom01/pilot Hangar_A_Return_cov05)	
	(cs_vehicle_speed 0.8)
	(cs_fly_to_and_face hangar_a_phantom_path_b/p4 hangar_a_phantom_path_b/p3)
	(object_set_physics Hangar_A_Return_phantom01/pilot false)	
	(cs_fly_to_and_face hangar_a_phantom_path_b/p0 hangar_a_phantom_path_b/p3)
;	(ai_place Hangar_A_Return_cov07)
	
	(cs_vehicle_speed 1.0)
	(cs_fly_by hangar_a_phantom_path_b/p1)
	(cs_fly_to hangar_a_phantom_path_b/p2)
	(ai_erase Hangar_A_Return_phantom01)
)

(script dormant Evac02_Elevator_Activate
	(sleep_until 
		(begin
			(cond
			((= (device_get_position elevator_evac_02) 0)
				(begin
					(device_set_position evac02_elev_top 1)
					(device_set_position evac02_elev_back 1)
;					(device_set_power evac2_elev_switch02 1)
					(device_set_power evac2_elev_switch01 1)
					(motion_blur TRUE) ;50289						
				FALSE)
			)
			((= (device_get_position elevator_evac_02) 1)
				(begin 
					(device_set_position evac02_elev_bottom 1)
					(device_set_position evac02_elev_front 1)
					(device_set_power evac2_elev_switch03 1)
					(device_set_power evac2_elev_switch02 1)
					(motion_blur TRUE) ;50289					
				
				FALSE)
			)
			(( AND (< (device_get_position elevator_evac_02) 1)
				  (> (device_get_position elevator_evac_02) 0))			
				(begin
					(motion_blur FALSE) ;50289
					(device_set_position evac02_elev_bottom 0)
					(device_set_position evac02_elev_top 0)
					(device_set_position evac02_elev_front 0)
					(device_set_position evac02_elev_back 0)
					(device_set_power evac2_elev_switch01 0)
					(device_set_power evac2_elev_switch02 0)
					(device_set_power evac2_elev_switch03 0)
				FALSE)
			))			
		)
	1)
)

(script dormant Exit01_Elevator_Activate
	(sleep_until (> (device_get_position exit_elev_switch02) 0)1)
		(device_set_position exit_elev_top 0)
		(device_set_position exit_elev_front 0)
	(sleep_until (> (device_get_position exit_elev_front) 0)1)		
		(device_set_position elevator_exit 1)


)

(script dormant base_disposable_ai
	(sleep_until (>= base_obj_control 30))
		(ai_disposable command_center_hum TRUE)
		(ai_disposable cave_a_hum TRUE)	
		(flock_delete cave_a_rats_01)
		(flock_delete cave_a_rats_02)
		(flock_delete cave_a_rats_03)
		(flock_delete cave_a_rats_04)
		(flock_delete cave_a_rats_05)
		(flock_delete cave_a_rats_06)
		(flock_delete cave_a_rats_07)
		(flock_delete cave_a_rats_08)
	(sleep_until (>= base_obj_control 50))
		(ai_disposable highway_a_all TRUE)
		(flock_delete hall_a_rats_01)
	(sleep_until (>= base_obj_control 60))		
		(ai_disposable hangar_a_all TRUE)
		(ai_disposable players_marines TRUE)
		(flock_delete hangar_a_rats_01)
		(flock_delete hangar_a_rats_02)
		(flock_delete hangar_a_rats_03)
		(flock_delete hangar_a_rats_04)
		(flock_delete hangar_a_rats_05)
	(sleep_until (>= base_obj_control 70))
		(ai_disposable loop01_return_cov_all TRUE)
		(ai_disposable loop01_return_hum_all TRUE)
		(ai_disposable loop01_return_hw01 TRUE)
		(ai_disposable bugger_intro_all TRUE)
	(sleep_until (>= base_obj_control 90))
		(ai_disposable loop02_begin_hum TRUE)
		(ai_disposable motor_pool_all TRUE)
		(ai_disposable sewer_all TRUE)
		(flock_delete motorpool_rats_01)
		(flock_delete motorpool_rats_02)
	(sleep_until (>= base_obj_control 100))
		(ai_disposable barracks_cov_all TRUE)
		(flock_delete barracks_rats_01)
	(sleep_until (>= base_obj_control 110))				
		(flock_delete evac_rats_01)
		(flock_delete evac_rats_02)
		(flock_delete evac_rats_03)
	(sleep_until (>= base_obj_control 120))		
	(sleep_until (>= base_obj_control 130))
	(sleep_until (>= base_obj_control 140))	
		(ai_disposable cortana_highway_all TRUE)
	(sleep_until (>= base_obj_control 150))
		(ai_disposable self_destruct_all TRUE)
)

(script dormant base_cleanup

	(sleep_until (>= base_obj_control 10)) ;beginning of Command_Center
	
	(sleep_until (>= base_obj_control 20)) ;beginning of Cave_A
	(sleep_until (>= base_obj_control 30)) ;beginning of Highway_A
		(device_set_position cave_a_door_command 0)
;		(pvs_set_object cave_a_door_hallway01)
		(device_set_position cave_a_door_hallway01 0)
		;kill ambient scripts			
		(sleep_forever ops_center_big_screen)
		(sleep_forever ops_center_monitors)
		(sleep_forever md_01_hw_followers)
		(sleep_forever 01_cave_entry)
		(sleep_forever 01_take_positions)
		(sleep_forever 01_sergeant_dialog)
		(sleep_forever 01_follower_dialog)
		(sleep_forever md_01_command_followers)		
		(sleep_forever md_01_command_followers02)
		(sleep_forever 01_cave_a_runner01)
		(sleep_forever 01_cave_a_runner02)	
		(sleep_forever 01_johnson_reminder)
		(ai_dialogue_enable true)												

	(sleep_until (>= base_obj_control 40)) ;beginning of Hangar_A
		(sleep_forever 01_door_repair)
	(sleep_until (>= base_obj_control 50)) ;beginning of Bugger_intro/Loop01_Return
	(sleep_forever md_04_hangar_miranda_pa)
	(ai_dialogue_enable true)													
	(sleep_until (>= base_obj_control 60)) ;beginning of Loop02_Begin
	(sleep_forever md_hangar_a_radio_johnson)
	(ai_dialogue_enable true)													
	(sleep_until (>= base_obj_control 70)) ;beginning of Motor_Pool
	(sleep_until (>= base_obj_control 80)) ;beginning of Sewers	
	(sleep_until (>= base_obj_control 90)) ;beginning of Barracks
		(sleep_forever 020VC_GIFT_WITH_PURCHASE)
		(sleep_forever 020VC_01)
		(sleep_forever 020VC_setup)
;		(sleep_forever medic_02_mon)
	(sleep_until (>= base_obj_control 100)) ;beginning of Evac_Hangar
		(sleep_forever bugger_machine01)
		(sleep_forever bugger_machine02)
		(sleep_forever bugger_machine03)
		(sleep_forever bugger_swarm01)
		(sleep_forever bugger_swarm02)
		(sleep_forever bugger_swarm03)
	(sleep_until (>= base_obj_control 110))	;beginning of Cortana_Highway
	(sleep_until (>= base_obj_control 120)) 
	(sleep_until (>= base_obj_control 130)) ;beginning of Self_Destruct
		(device_set_position command_miranda_door 1)
		(device_set_position command_center_cin_door 0)
	(sleep_until (>= base_obj_control 140)) ;beginning of Exit_Run
	(sleep_until (>= base_obj_control 150)) ;beginning of Hangar_A_Return

)
		
(global real g_nav_offset 0.55); stole this from bertone
;==============================================================

(script dormant command_navpoint_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player command_navpoint01 g_nav_offset)
)
(script dormant command_navpoint_deactive
	(sleep_until (or (> base_obj_control 10)(<= (objects_distance_to_flag (players) command_navpoint01) 1))1)
	(sleep_forever command_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player command_navpoint01)
)
;==============================================================
(script dormant cave_a_navpoint_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player cave_a_navpoint g_nav_offset)
)
(script dormant cave_a_navpoint_deactive
	(sleep_until (or (> base_obj_control 20)(<= (objects_distance_to_flag (players) cave_a_navpoint) 2))1)
	(sleep_forever cave_a_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player cave_a_navpoint)
)
;==============================================================

(script dormant highway_a_navpoint_active
	(sleep_until (and (< (ai_living_count highway_a_cov01) 1)
					(< (ai_living_count highway_a_cov02) 1)
					(< (ai_living_count highway_a_cov03) 1)
					(< (ai_living_count highway_a_cov07_legend) 1)
					(< (ai_living_count highway_a_cov08_legend) 1)
					)5)
	(sleep (* 30 60))
	(hud_activate_team_nav_point_flag player highway_a_navpoint g_nav_offset)
)
(script dormant highway_a_navpoint_deactive
	(sleep_until (or (> base_obj_control 30)(<= (objects_distance_to_flag (players) highway_a_navpoint) 2))1)
	(sleep_forever highway_a_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player highway_a_navpoint)
)
;==============================================================		
	
(script dormant hangar_a_navpoint_active
	(sleep (* 30 30))
	(hud_activate_team_nav_point_flag player hangar_a_navpoint01 g_nav_offset)
)
(script dormant hangar_a_navpoint_deactive
	(sleep_until (<= (objects_distance_to_flag (players) hangar_a_navpoint01) 2)1)
	(sleep_forever hangar_a_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player hangar_a_navpoint01)
	(wake hangar_a_navpoint02_active)
	(wake hangar_a_navpoint02_deactive)
)

(script dormant hangar_a_navpoint02_active
	(sleep (* 30 30))
	(hud_activate_team_nav_point_flag player highway_a_navpoint01 g_nav_offset)
)
(script dormant hangar_a_navpoint02_deactive
	(sleep_until (<= (objects_distance_to_flag (players) highway_a_navpoint01) 2)1)
	(sleep_forever hangar_a_navpoint02_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player highway_a_navpoint01)
	(wake hangar_a_navpoint03_active)
	(wake hangar_a_navpoint03_deactive)	
)
(script dormant hangar_a_navpoint03_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player cave_a_navpoint g_nav_offset)
)
(script dormant hangar_a_navpoint03_deactive
	(sleep_until (<= (objects_distance_to_flag (players) cave_a_navpoint) 2)1)
	(sleep_forever hangar_a_navpoint03_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player cave_a_navpoint)
)

;==============================================================
	
(script dormant loop01_navpoint_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player command_navpoint01 g_nav_offset)
)
(script dormant loop01_navpoint_deactive
	(sleep_until (or (> base_obj_control 50)(<= (objects_distance_to_flag (players) command_navpoint01) 2))1)
	(sleep_forever loop01_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player command_navpoint01)
)
;==============================================================
(global boolean loop02_navpoint_bool FALSE)
(script dormant loop02_navpoint_active
	(sleep_until (= loop02_navpoint_bool true )5)
	(hud_activate_team_nav_point_flag player command_navpoint02 g_nav_offset)
)
(script dormant loop02_navpoint_deactive
;	(sleep_until (script_finished loop02_navpoint_active))
	(sleep_forever loop02_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player command_navpoint02)
)
;==============================================================
(script dormant motor_pool_navpoint_active
	(sleep_until (< (ai_living_count motor_pool_all) 1))
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player sewer_navpoint01 g_nav_offset)
)
(script dormant motor_pool_navpoint_deactive
	(sleep_until (or (> base_obj_control 70)(<= (objects_distance_to_flag (players) sewer_navpoint01) 2))1)
	(sleep_forever motor_pool_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player sewer_navpoint01)
)
;==============================================================
(script dormant evac_hangar_navpoint_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player evac_hangar_navpoint02 g_nav_offset)
)
(script dormant evac_hangar_navpoint_deactive
	(sleep_until (or (> base_obj_control 100)(<= (objects_distance_to_flag (players) evac_hangar_navpoint02) 3))1)
	(sleep_forever evac_hangar_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player evac_hangar_navpoint02)
)
;==============================================================

(script dormant cortana_navpoint_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player cortana_highway_navpoint01 g_nav_offset)
)
(script dormant cortana_navpoint_deactive
	(sleep_until (or (> base_obj_control 110)(<= (objects_distance_to_flag (players) cortana_highway_navpoint01) 3))1)
	(sleep_forever cortana_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player cortana_highway_navpoint01)
)
;==============================================================
(script dormant cortana02_navpoint_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player command_navpoint02 g_nav_offset)
)
(script dormant cortana02_navpoint_deactive
	(sleep_until (or (> base_obj_control 120)(<= (objects_distance_to_flag (players) command_navpoint02) 2))1)
	(sleep_forever cortana02_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player command_navpoint02)
)
;==============================================================

(script dormant destruct_bomb_navpoint_active
	(hud_activate_team_nav_point_flag player bomb_navpoint g_nav_offset)
)
(script dormant destruct_bomb_navpoint_deactive
	(sleep_forever destruct_bomb_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player bomb_navpoint)
)
;==============================================================

(script dormant self_destruct_navpoint_active
	(sleep (* 30 30))
	(hud_activate_team_nav_point_flag player command_navpoint01 g_nav_offset)
)
(script dormant self_destruct_navpoint_deactive
	(sleep_until (or (> base_obj_control 140)(<= (objects_distance_to_flag (players) command_navpoint01) 2))1)
	(sleep_forever self_destruct_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player command_navpoint01)
	(wake exit_run_navpoint_active)
	(wake exit_run_navpoint_deactive)		
)
;==============================================================

(script dormant exit_run_navpoint_active
	(sleep (* 30 60))
	(hud_activate_team_nav_point_flag player cave_a_navpoint g_nav_offset)
)
(script dormant exit_run_navpoint_deactive
	(sleep_until (or (> base_obj_control 140)(<= (objects_distance_to_flag (players) cave_a_navpoint) 2))1)
	(sleep_forever exit_run_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player cave_a_navpoint)
	(wake hangar_a_ret_navpoint_active)
	(wake hangar_a_ret_navpoint_deactive)		
)
;==============================================================


(script dormant hangar_a_ret_navpoint_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player highway_a_navpoint01 g_nav_offset)
)
(script dormant hangar_a_ret_navpoint_deactive
	(sleep_until (or (> base_obj_control 150)(<= (objects_distance_to_flag (players) highway_a_navpoint01) 2))1)
	(sleep_forever hangar_a_ret_navpoint_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player highway_a_navpoint01)
	(wake hangar_a_ret02_nav_active)
	(wake hangar_a_ret02_nav_deactive)	
)

(script dormant hangar_a_ret02_nav_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player highway_a_navpoint g_nav_offset)
)
(script dormant hangar_a_ret02_nav_deactive
	(sleep_until (or (> base_obj_control 150)(<= (objects_distance_to_flag (players) highway_a_navpoint) 2))1)
	(sleep_forever hangar_a_ret02_nav_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player highway_a_navpoint)
	(wake hangar_a_ret03_nav_active)
	(wake hangar_a_ret03_nav_deactive)		
)
	
(script dormant hangar_a_ret03_nav_active
	(sleep (* 30 90))
	(hud_activate_team_nav_point_flag player hangar_a_navpoint01 g_nav_offset)
)
(script dormant hangar_a_ret03_nav_deactive
	(sleep_until (or (> base_obj_control 150)(<= (objects_distance_to_flag (players) hangar_a_navpoint01) 2))1)
	(sleep_forever hangar_a_ret03_nav_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player hangar_a_navpoint01)
	(wake hangar_a_ret04_nav_active)
	(wake hangar_a_ret04_nav_deactive)			
)

(script dormant hangar_a_ret04_nav_active
	(sleep (* 30 30))
	(hud_activate_team_nav_point_flag player exit_navpoint01 g_nav_offset)
)
(script dormant hangar_a_ret04_nav_deactive
	(sleep_until (or (> base_obj_control 150)(<= (objects_distance_to_flag (players) exit_navpoint01) 2))1)
	(sleep_forever hangar_a_ret03_nav_active)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player exit_navpoint01)
)


(script command_script cs_abort
	(sleep 1)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; PRIMARY OBJECTIVES  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(script dormant obj_init_set
	(if debug (print "new objective set:"))
	(if debug (print "Setup defenses"))
	(sleep_until (or (= miranda_done TRUE) (volume_test_players command_center_intro_marines))1)
	(if (volume_test_players command_center_intro_marines)
		(sleep 270))
		(objectives_show_up_to 0)
		(cinematic_set_chud_objective obj_0)
		(set g_music_020_01 true)
)
(script dormant obj_init_clear
	(if debug (print "objective complete:"))
	(if debug (print "Stop the Covenant from taking the Armory."))
	(objectives_finish_up_to 0)
)

; =======================================================================================================================================================================

(script dormant obj_hangar_a_set
	(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Seal off the South Hangar to limit Covenant reinforcements."))
	(objectives_show_up_to 1)
	(sleep 200)
	(cinematic_set_chud_objective obj_1)	
)
(script dormant obj_hangar_a_clear
	(if debug (print "objective complete:"))
	(if debug (print "Seal off the South Hangar to limit Covenant reinforcements."))
	(objectives_finish_up_to 1)
)

; =======================================================================================================================================================================

(script dormant obj_return_command_center_set
	(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Return to the Command Center."))
	(objectives_show_up_to 2)
	(sleep 90)
	(cinematic_set_chud_objective obj_2)	
)
(script dormant obj_return_command_center_clear
	(if debug (print "objective complete:"))
	(if debug (print "Return to the Command Center."))
	(objectives_finish_up_to 2)
)

; =======================================================================================================================================================================

(script dormant obj_barracks_set
	(if debug (print "new objective set:"))
	(if debug (print "Go to the barracks to help with the rescue effort."))
	(objectives_finish_up_to 2)	
	(objectives_show_up_to 3)
	(sleep 120)
	(cinematic_set_chud_objective obj_3)
)
(script dormant obj_barracks_clear
	(sleep_until (or (= (device_get_position barracks_door_end) 1)
				(<= (ai_living_count barracks_cov_all) 0)) 5)
	(if debug (print "objective complete:"))
	(if debug (print "Go to the barracks to help with the rescue effort."))
	(objectives_finish_up_to 3)	
)

; =======================================================================================================================================================================

(script dormant obj_evacuate_set
	(sleep_until (= (device_get_position barracks_door_end) 1) 5)
	(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Evacuate the base in the West Hangar."))
	(objectives_show_up_to 4)
	(sleep 120)
	(cinematic_set_chud_objective obj_4)	
)
(script dormant obj_evacuate_clear
	(if debug (print "objective complete:"))
	(if debug (print "Evacuate the base in the West Hangar."))
	(objectives_finish_up_to 4)
)

; =======================================================================================================================================================================

(script dormant obj_self_destruct_set
	(if debug (print "new objective set:"))
	(if debug (print "Return to the command Center to determine what is interfering with our remote detonation."))
	(objectives_finish_up_to 4)
	(objectives_show_up_to 5)
	(cinematic_set_chud_objective obj_5)
	(set self_destruct_objective TRUE)		
)

(script dormant obj_self_destruct_set_ins
	(sleep 180)
	(if (not self_destruct_objective)
		(begin
			(if debug (print "new objective set:"))
			(if debug (print "Return to the command Center to determine what is interfering with our remote detonation."))
			(objectives_finish_up_to 4)
			(objectives_show_up_to 5)
			(cinematic_set_chud_objective obj_5)
		)
	)
)

(script dormant obj_self_destruct_clear
	(if debug (print "objective complete:"))
	(if debug (print "Return to the command Center to determine what is interfering with our remote detonation."))
	(objectives_finish_up_to 5)
)

; ================================================================================================================================================

(script dormant obj_exit_set
	(sleep 30)
	(if debug (print "new objective set:"))
	(if debug (print "Exit the base via an elevator in the North hangar."))
	(objectives_show_up_to 6)
	(sleep 150)
	(cinematic_set_chud_objective obj_6)		
)
(script dormant obj_exit_clear
	(if debug (print "objective complete:"))
	(if debug (print "Exit the base via an elevator in the North hangar."))
	(objectives_finish_up_to 7)
)

;====================================================================================================================================================================================================
;============================== AWARD SKULLS ========================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_award_primary_skull
	(if	(award_skull)
		(begin
			(object_create skull_black_eye)
			
			(sleep_until 
				(or
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
				)
			5)
			
			(if debug (print "award black_eye skull"))
			(campaign_metagame_award_primary_skull (player0) 1)
			(campaign_metagame_award_primary_skull (player1) 1)
			(campaign_metagame_award_primary_skull (player2) 1)
			(campaign_metagame_award_primary_skull (player3) 1)
		)
	)
)

(script dormant gs_award_secondary_skull
	(if	(award_skull)

		(begin
			(object_create skull_grunt_bday)
			
			(sleep_until 
				(or
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
					(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
					(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
					(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
				)
			5)
			
			(if debug (print "award Grunt Birthday Party skull"))
			(campaign_metagame_award_secondary_skull (player0) 3)
			(campaign_metagame_award_secondary_skull (player1) 3)
			(campaign_metagame_award_secondary_skull (player2) 3)
			(campaign_metagame_award_secondary_skull (player3) 3)
		)
	)
)

(script static void disable_zone_volumes
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_00_01_encounter false)
;	(zone_set_trigger_volume_enable begin_zone_set:020_00_03_encounter false)
;	(zone_set_trigger_volume_enable zone_set:020_00_03_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_00_01_return false)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_return false)				
	(zone_set_trigger_volume_enable begin_zone_set:020_00_04_05_encounter false)
;	(zone_set_trigger_volume_enable zone_set:020_00_04_05_encounter false)
	(zone_set_trigger_volume_enable begin_zone_set:020_04_05_06_encounter false)
;	(zone_set_trigger_volume_enable zone_set:020_04_05_06_encounter false)
	(zone_set_trigger_volume_enable begin_zone_set:020_05_06_07_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_05_06_07_encounter false)
	(zone_set_trigger_volume_enable begin_zone_set:020_06_08_04_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_06_08_04_encounter false)				
	(zone_set_trigger_volume_enable zone_set:020_00_04_08_encounter false)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_04_08_encounter false)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_exit_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_00_01_exit_encounter false)
	(zone_set_trigger_volume_enable begin_zone_set:020_01_03_exit_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_01_03_exit_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_04_05_06_encounter false)		
	
)

(script dormant object_management
	(sleep_until (> (player_count) 0) 1)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_00_01_encounter false)		
	(zone_set_trigger_volume_enable begin_zone_set:020_00_04_05_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_00_04_05_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_00_04_08_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_00_01_return false)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_return false)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_exit_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_00_01_exit_encounter false)
	(zone_set_trigger_volume_enable begin_zone_set:020_01_03_exit_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_01_03_exit_encounter false)
	(zone_set_trigger_volume_enable zone_set:020_06_08_04_encounter false)				
	(if (= (current_zone_set) 0)
		(begin
			(vehicle_auto_turret cool_cam01 cool_cam_trig01 0 50 50)
			(vehicle_auto_turret cool_cam02 cool_cam_trig02 0 50 50)
			(vehicle_auto_turret cool_cam03 cool_cam_trig03 0 50 50)	
		)
	)
	(sleep_until (>= (current_zone_set) 1) 1) ;020_00_01
;		(device_set_position_immediate command_center_cin_door 0)
	(if (= (current_zone_set) 1)
		(begin
			(vehicle_auto_turret cool_cam04 cool_cam_trig04 0 50 50)
			(vehicle_auto_turret cool_cam05 cool_cam_trig05 0 50 50)
		)
	)
		
	(sleep_until (>= (current_zone_set) 2) 1) ;020_01_03
		(device_set_position_immediate cave_a_door_hallway01 0)
		(zone_set_trigger_volume_enable begin_zone_set:020_00_01_encounter false)
		(zone_set_trigger_volume_enable zone_set:020_00_01_encounter false)

	(if (= (current_zone_set) 2)
		(begin
			(object_create_folder bipeds_hangar_a_folder)
			(vehicle_auto_turret cool_cam06 cool_cam_trig06 0 50 50)
		)
	)
	(sleep_until (>= (current_zone_set) 3) 1) ;020_00_01_return
		(device_set_position cave_a_door_hallway01 1)
		(device_set_position_immediate 020_03_d2 1)		
		(device_set_position_immediate hangar_a_entrance_door 0)
		(zone_set_trigger_volume_enable begin_zone_set:020_01_03_encounter false)
		(zone_set_trigger_volume_enable zone_set:020_01_03_encounter false)		
		(zone_set_trigger_volume_enable begin_zone_set:020_00_04_05_encounter true)
		(zone_set_trigger_volume_enable zone_set:020_00_04_05_encounter true)			
		(device_set_position_immediate command_center_cin_door 0)
		(flock_delete banshees)
		(flock_delete hornets)

	(sleep_until (>= (current_zone_set) 4) 1) ;020_00_04_05
		(device_set_position_immediate cave_a_door_hallway01 0)
					
	(if (= (current_zone_set) 4)
		(begin
			(object_destroy_folder bipeds_hangar_a_folder)
			(object_create_folder bipeds_motorpool_folder)
		)
	)
	(sleep_until (>= (current_zone_set) 5) 1) ;020_04_05_06
		(device_set_position_immediate loop02_begin_door 0)					   		     	
		(zone_set_trigger_volume_enable zone_set:020_00_01_return false)
		(zone_set_trigger_volume_enable begin_zone_set:020_00_01_return false)
	     (zone_set_trigger_volume_enable begin_zone_set:020_00_04_05_encounter false)
		(zone_set_trigger_volume_enable zone_set:020_00_04_05_encounter false)
					
		(object_destroy bugger_vent)
	(if (= (current_zone_set) 5)
		(begin
			(vehicle_auto_turret cool_cam07 cool_cam_trig07 0 50 50)
			(vehicle_auto_turret cool_cam08 cool_cam_trig08 0 50 50)
			(vehicle_auto_turret cool_cam09 cool_cam_trig09 0 50 50)
		)
	)		

	(sleep_until (>= (current_zone_set_fully_active) 5) 1) ;020_04_05_06
		(sleep 30)
		(object_create_anew evac02_elev_back)
		(sleep 30)				
		(object_create_anew evac02_elev_front)
		(sleep 30)		
		(object_destroy evac02_elev_back)
		(sleep 30)				
		(object_destroy evac02_elev_front)
		(sleep 30)
		(object_create_anew evac02_elev_back)
		(object_create_anew evac02_elev_front)			
		(object_create_anew evac02_elev_top)
		(object_create_anew evac02_elev_bottom)
		(object_create_anew elevator_evac_02)
		(object_create_anew evac2_elev_switch01)
		(object_create_anew evac2_elev_switch02)
		(object_create_anew evac2_elev_switch03)
		(sleep 1)		
		(objects_attach elevator_evac_02 "panel" evac2_elev_switch02 "")
		(objects_attach elevator_evac_02 "back" evac02_elev_back "")
		(objects_attach elevator_evac_02 "front" evac02_elev_front "")
		(kill_volume_disable kill_evac_elevator)			
		
	(sleep_until (>= (current_zone_set) 6) 1) ;020_05_06_07
		(zone_set_trigger_volume_enable zone_set:020_04_05_06_encounter false)
	     (zone_set_trigger_volume_enable begin_zone_set:020_00_04_05_encounter false)
		(zone_set_trigger_volume_enable zone_set:020_00_04_05_encounter false)
		(device_set_position_immediate motor_pool_exit_door 0)
		(object_destroy_folder crates_evac_hangar_folder)
		(object_destroy_folder bipeds_motorpool_folder)
		(object_destroy_folder equipment_motorpool_folder)
		(object_destroy_folder weapons_motorpool_folder)
		(add_recycling_volume g_sewer_trig_a 0 1)
				
	(if (= (current_zone_set) 6)
		(begin
			(garbage_collect_now)
			(sleep 1)		
	   		(object_create_folder crates_barracks_folder)		

		)                                                                    
	)
	
	(sleep_until (>= (current_zone_set) 7) 1) ;020_06_08_04
		(zone_set_trigger_volume_enable begin_zone_set:020_04_05_06_encounter false)
;		(zone_set_trigger_volume_enable zone_set:020_04_05_06_encounter false)		
		(zone_set_trigger_volume_enable zone_set:020_00_04_08_encounter true)
		(zone_set_trigger_volume_enable zone_set:020_05_06_07_encounter false)
		(device_set_position_immediate barracks_evac_hangar_door 0)
		(kill_volume_enable kill_evac_elevator)			

	(if (= (current_zone_set) 7)
		(begin
			(object_destroy_folder crates_barracks_folder)
			(object_destroy_folder bipeds_barracks_folder)
			(object_destroy_folder weapons_barracks_folder)
			(object_destroy_folder equipment_barracks_folder)
			(vehicle_auto_turret cool_cam10 cool_cam_trig10 0 50 50)		
		)
	)
	(sleep_until (>= (current_zone_set) 8) 1) ;020_00_04_08
		(add_recycling_volume g_evac_bottom_trig_a 0 1)
		(add_recycling_volume g_evac_bottom_trig_b 0 1)	
		(add_recycling_volume g_evac_bottom_trig_c 0 1)
		(add_recycling_volume g_evac_top_trig_a 0 1)
		(sleep_forever evac_hangar_kill_player)
		(device_set_position_immediate cortana_zone_door 0)
		(device_set_power command_center_cin_door 1)
		(device_set_position_immediate command_center_cin_door 0)
		(device_set_position_immediate evac_hangar_highway_door 0)
;		(zone_set_trigger_volume_enable zone_set:020_06_08_04_encounter FALSE)
		(flock_delete banshees_evac)
		(flock_delete hornet_evac)
	(if (= (current_zone_set) 8)
		(object_destroy_folder crates_evac_hangar_folder)	
		(object_create_folder bipeds_cc_folder)
	)
	(sleep_until (>= (current_zone_set) 9) 1) ;020_00_01_exit
		(add_recycling_volume g_cortana_highway_trig_a 0 1)
		(add_recycling_volume g_cortana_highway_trig_b 0 1)	
		(add_recycling_volume g_cortana_highway_trig_c 0 1)
		(add_recycling_volume g_motor_pool_trig_a 0 1)
		(add_recycling_volume g_motor_pool_trig_b 0 1)
		(object_destroy_folder crates_cortana_highway_folder)
		(object_destroy_folder bipeds_cortana_highway_folder)
		(object_destroy_folder weapons_cortana_highway_folder)
		(object_destroy_folder equipment_cortana_highway_folder)
		(object_destroy_folder vehicles_cortana_highway_folder)						
								
	(sleep_until (>= (current_zone_set_fully_active) 9) 1) ;020_00_01_exit
		(zone_set_trigger_volume_enable begin_zone_set:020_01_03_exit_encounter true)
		(zone_set_trigger_volume_enable zone_set:020_01_03_exit_encounter true)
		(device_set_position_immediate cave_a_door_hallway01 1)
		(device_set_position_immediate highway_a_door 1)
		(device_set_position_immediate hangar_a_entrance_door 1)
		(device_set_position_immediate 020_03_d2 1)			
	(sleep_until (>= (current_zone_set) 10) 1) ;020_01_03_exit
		(add_recycling_volume g_command_center_trig_a 0 1)
		(add_recycling_volume g_command_center_trig_b 0 1)	
		(add_recycling_volume g_command_center_trig_c 0 1)
		(add_recycling_volume g_cave_a_trig_a 0 1)
		(add_recycling_volume g_cave_a_trig_b 0 1)
		(object_destroy_folder crates_command_center_folder)
		(object_destroy_folder crates_cave_a_folder)
		(object_destroy_folder bipeds_cc_folder)
		(device_set_power sec_light01 0)
		(device_set_power sec_light02 0)
		(zone_set_trigger_volume_enable zone_set:020_00_01_exit_encounter false)
		(zone_set_trigger_volume_enable begin_zone_set:020_00_01_exit_encounter false)		
		(device_set_position_immediate cave_a_door_hallway01 0)
	(sleep_until (>= (current_zone_set_fully_active) 10) 1) ;020_01_03_exit
		
		(object_create_anew exit_elev_front)
		(object_create_anew exit_elev_back)
		(object_create_anew exit_elev_top)
		(object_create_anew elevator_exit)	
		(sleep 1)
		(objects_attach elevator_exit "panel" exit_elev_switch02 "")
		(objects_attach elevator_exit "front" exit_elev_front "")
		(objects_attach elevator_exit "back" exit_elev_back "")
		(object_create_folder bipeds_hangar_a_folder)
	(sleep_until (>= (current_zone_set) 11) 1) ;020_03_exit
		(device_set_position_immediate hangar_a_left_door 1)
		(device_set_position_immediate hangar_a_right_door 1)
	
)           
;*
(global boolean save_bool FALSE)
(script continuous save_loop
	(sleep_until save_bool)
	(sleep_until (game_safe_to_save))
	(if save_bool (game_save))
	(set save_bool FALSE)
)
*;