;========== Stub Scripts ==========

(script stub void cutscene_insertion_a
	(print "merging cinema script failed")
	)

(script stub void cutscene_insertion_b
	(print "merging cinema script failed")
	)

(script stub void cutscene_extraction
	(print "merging cinema script failed")
	)
	
;========== MIssion Outline ==========

;	== Intro Cutscene ==


;	== Outro Cutscene ==

(global boolean debug true)
(global long default_turret_delay (* 30 10))
(global long control_turret_delay (* 30 10))

(global short exterior_player_location 0)
(global boolean mission_start 0)

;1 - ext_a_a
;2 - ext_a_b
;3 - ext_a_c
;4 - crev
;5 - ext_b_a
;6 - ext_b_b

;----------------------------------------------------------
; turns a1 spawner off
(global boolean a1_spawn true)
; counts the # of squads spawned
; DO NOT CHANGE
(global short a1_spawn_counter 0)
; limits the # of squads spawned
; range 0-2
(global short a1_squad_index 1)
;----------------------------------------------------------
(global boolean a_bridge_rein true)
(global short a_bridge_rein_counter 0)
; range 0-2
(global short a_bridge_rein_index 1)
;----------------------------------------------------------
(global boolean ext_a_spawn true)
(global short ext_a_spawn_counter 0)
; range 0-2
(global short ext_a_squad_index 1)
;----------------------------------------------------------
(global boolean crev_ent_turrets true)
(global short crev_ent_turret_counter 0)
;range 0-5
(global short crev_ent_turret_limit 3)
;----------------------------------------------------------
(global boolean b3_top_spawn true)
(global short b3_top_spawn_counter 0)
; range 0-3
(global short b3_top_squad_index 2)
;----------------------------------------------------------
(global boolean b4_bridge_spawn true)
(global short b4_bridge_spawn_counter 0)
; range 0-3
(global short b4_bridge_squad_index 1)
;----------------------------------------------------------
(global boolean c_bridge_spawn true)
(global short c_bridge_spawn_counter 0)
; range 0-3
(global short c_bridge_squad_index 2)
;----------------------------------------------------------
(global boolean play_music_b40_01 true)
(global boolean play_music_b40_011 true)
(global boolean play_music_b40_02 true)
(global boolean play_music_b40_03 true)
(global boolean play_music_b40_04 true)
(global boolean play_music_b40_041 true)
(global boolean play_music_b40_042 true)
(global boolean play_music_b40_05 true)
(global boolean play_music_b40_06 true)
(global boolean play_music_b40_061 true)
(global boolean play_music_b40_07 true)
(global boolean play_music_b40_071 true)
(global boolean play_music_b40_08 true)

;========== save Game Scripts ==========

(script static void save
	(sleep_until (game_safe_to_save))
	(game_save))
	
(script continuous general_save
;	(save)
	(if (= mission_start 0) (sleep -1))
	(game_save_no_timeout)
	(sleep -1)
	)
	
;(script dormant a2_top_save
;	(sleep_until (or (= (ai_living_count a2_top_cov) 0)
;				  (volume_test_objects a2_top_save (players))))
;	(wake general_save))

;(script dormant a2_bottom_save
;	(sleep_until (= (ai_living_count a2_bottom_cov) 0))
;	(wake general_save))

(script continuous cont_crev_save
	(sleep_until (volume_test_objects crevasse_trigger (players)))
	(wake general_save)
	(sleep (* 30 60))
	)

(script dormant save_script
	(sleep_until (volume_test_objects a_bridge_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects a2_top_a_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects a2_top_b_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects a2_bottom_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects ext_a_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects crev_a_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects crev_b_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects b3_bottom_a_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects b3_bottom_b_save (players)))
	(wake general_save)
;	(sleep_until (volume_test_objects b3_top_save (players)))
;	(wake general_save)
	(sleep_until (volume_test_objects b3_bridge_save (players)))
	(wake general_save)
;	(sleep_until (volume_test_objects b4_a_save (players)))
;	(wake general_save)
;	(sleep_until (volume_test_objects b4_bridge_save (players)))
;	(wake general_save)
	(sleep_until (volume_test_objects b5_a_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects c_bridge_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects c1_top_a_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects c1_top_b_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects c1_bottom_save (players)))
	(wake general_save)
	(sleep_until (volume_test_objects ext_c_save (players)))
	(wake general_save)
	)


;========== Music Scripts ==========

(script dormant music_b40_01
;	(sleep_until play_music_b40_01)
	(sleep_until (> (ai_conversation_status a_bridge_marines) 3))
	(sound_looping_start "levels\b40\music\b40_01" none 1)
;	(sleep_until (or (= (ai_living_count a_bridge/elites_reins) 0)
;				  (not play_music_b40_01)))
;	(sound_looping_stop "levels\b40\music\b40_01")
	)

(script dormant music_b40_011
	(sleep_until (> (device_get_position a2_top_ent_door) 0))
	(sound_looping_start "levels\b40\music\b40_011" none 1)
	(sleep_until (or (volume_test_objects a2_top_b_save (players))
				  (= (ai_living_count a2_top_cov) 0)))
	(sound_looping_stop "levels\b40\music\b40_011")
	)

(script dormant music_b40_02
	(sleep_until (= (device_get_position lift_a) 1))
	(sound_looping_start "levels\b40\music\b40_02" none 1)
	(sleep_until (> (device_get_position ext_a_door) 0))
;	(sleep_until (= (device_get_position lift_a) 1))
	(sound_looping_stop "levels\b40\music\b40_02")
	)

(script dormant music_b40_03
	(sleep_until (or (volume_test_objects ext_a_area_c_trigger_a (players))
				  (volume_test_objects ext_a_area_c_trigger_b (players))
				  (vehicle_test_seat_list ext_a_tank "scorpion-driver" (players))))
	(sound_looping_start "levels\b40\music\b40_03" none 1)
	(sleep_until (or (<= (unit_get_health crev_ent_wraith_a) 0)
				  (<= (unit_get_health crev_ent_wraith_b) 0)
				  (volume_test_objects ext_a_c_door (players))))
;				  (not play_music_b40_03)))
	(sound_looping_stop "levels\b40\music\b40_03")
	)

(script dormant music_b40_04
	(sleep_until (> (device_get_position garagedoor_a) 0))
	(sound_looping_start "levels\b40\music\b40_04" none 1)
	(sleep_until (not play_music_b40_04))
	(sound_looping_stop "levels\b40\music\b40_04")
	)

(script dormant music_b40_041
;	(sleep_until (> (device_get_position garagedoor_a) 0))
	(sound_looping_start "levels\b40\music\b40_041" none 1)
	(sleep_until (not play_music_b40_041))
	(sound_looping_stop "levels\b40\music\b40_041")
	)

(script dormant music_b40_042
	(sleep_until (> (device_get_position b3_bot_ent_door) 0))
	(sound_looping_start "levels\b40\music\b40_042" none 1)
	(sleep_until (> (device_get_position lift_c) 0))
	(sound_looping_stop "levels\b40\music\b40_042")
	)

(script dormant music_b40_05
	(sleep_until (= (ai_status b3_top_cov/elite_commander) 6))
	(sound_looping_start "levels\b40\music\b40_05" none 1)
	(sleep_until (not play_music_b40_05))
	(sound_looping_stop "levels\b40\music\b40_05")
	)

(script dormant music_b40_06
;	(sleep_until play_music_b40_06)
	(sleep_until (> (device_get_position b4_bridge_door) 0))
	(sound_looping_start "levels\b40\music\b40_06" none 1)
	(sleep_until (volume_test_objects b4_bridge_reins_trigger_b (players)))
	(sleep 30)
	(sleep_until (or (= (ai_living_count b4_bridge/stealth_elites) 0)
				  (not play_music_b40_06)))
	(sound_looping_stop "levels\b40\music\b40_06")
	)

(script dormant music_b40_061
;	(sleep_until play_music_b40_061)
	(sleep_until (or (volume_test_objects b5_hall_trigger (players))
				  (= (ai_living_count b5_a_cov) 0)))
	(sound_looping_start "levels\b40\music\b40_061" none 1)
	(sleep_until (volume_test_objects b5_b_trigger (players)))
	(sleep 30)
	(sleep_until (or (not play_music_b40_061) 
				  (= (ai_living_count b5_b_cov/hunters) 0)))
	(sound_looping_stop "levels\b40\music\b40_061")
	)

(script dormant music_b40_07
	(sleep_until (= (device_get_position c_bridge_near_door) 1))
	(ai_conversation view_zig)
	(sleep_until (> (ai_conversation_status view_zig) 4))
	(sound_looping_start "levels\b40\music\b40_07" none 1)
	(sleep_until (not play_music_b40_07) 30 (* 30 89))
	(sound_looping_stop "levels\b40\music\b40_07")
	)

(script dormant music_b40_071
	(sleep_until (> (device_get_position c1_top_ent_door) 0))
	(sound_looping_start "levels\b40\music\b40_071" none 1)
	(sleep_until (or (> (device_get_position ext_c_ent_door) 0)
				  (not play_music_b40_071)))
	(sound_looping_stop "levels\b40\music\b40_071")
	)

(script dormant music_b40_08
;	(sleep_until play_music_b40_08)
	(sleep_until (> (device_get_position control_door_a) 0))
	(sound_looping_start "levels\b40\music\b40_08" none 1)
	(sleep_until (not play_music_b40_08))
	(sound_looping_stop "levels\b40\music\b40_08")
	)

;========== Dialog Scripts ==========

(script dormant dialog_a1_clear
	(sleep_until (= (ai_living_count a1_cov) 0))
	(sleep 60)
	(ai_conversation a1_clear)
	)

(script dormant dialog_a_bridge_ini
	(sleep_until (= (ai_status a_bridge) 6)30 300)
	(ai_conversation a_bridge_marines)
	)

(script dormant dialog_ext_a_a_clear
	(sleep_until (= (ai_living_count ext_a_area_a_cov) 0))
	(if (= (volume_test_objects ext_a_area_b_trigger (players)) 0) (ai_conversation ext_a_a_clear))
	)

(script dormant dialog_ext_a_b	
	(sleep_until (= (ai_living_count ext_a_area_b_cov) 0))
	(ai_conversation ext_a_b_clear)
	)

(script dormant dialog_ext_a_c_wraith
	(sleep_until (or (= (ai_status ext_a_area_c_cov/wraith_a_pilot) 6)
				  (= (ai_status ext_a_area_c_cov/wraith_a_pilot) 6)))
	(sleep 30)
	(ai_conversation ext_a_c_wraith_eng)
	)

(script dormant dialog_ext_a_c
	(sleep_until (volume_test_objects ext_a_c_dialog (players)))
	(ai_conversation ext_a_c)
	
	(sleep 300)
	(sleep_until (or (<= (unit_get_health crev_ent_wraith_a) 0)
				  (<= (unit_get_health crev_ent_wraith_b) 0)))
	(sleep 60)
	(ai_conversation ext_a_c_wraith_des)
	)

(script dormant dialog_ext_a_c_door
	(sleep_until (volume_test_objects ext_a_c_door (players)))
	(ai_conversation crev_door)
	
	(sleep_until (> (device_get_position garagedoor_a) 0))
	(ai_conversation crev_door_open)
	)

(script dormant dialog_scorpion_dead
	(sleep_until (<= (unit_get_health ext_a_tank) 0))
	(ai_conversation scorpion_destroyed)
	)

(script dormant dialog_ext_b_c_clear
	(sleep 30)
	(sleep_until (= (ai_living_count ext_b_area_c_cov) 0))
	(if (> (ai_living_count ext_b_marines) 0) (ai_conversation ext_b_c_clear))
	)

(script dormant dialog_ext_b_c
	(sleep 60)
	(ai_conversation ext_b_c)
	)
	
(script dormant dialog_b5_clear
	(sleep_until (= (ai_living_count b5_b_cov) 0))
	(sleep 60)
	(ai_conversation b5_clear)
	)

(script dormant dialog_ext_c_ini
	(sleep_until (> (device_get_position ext_c_ent_door) 0))
	(sleep 30)
	(ai_conversation ext_c_ini)
	)

(script dormant dialog_ext_c_banshee
	(sleep_until (objects_can_see_object (players) ext_c_banshee_a 30))
	(sleep 30)
	(ai_conversation c_bridge_banshee)
	
	(sleep_until (and (vehicle_test_seat_list ext_c_banshee_a "b-driver" (ai_actors ext_c_banshee/banshee))
				   (vehicle_test_seat_list ext_c_banshee_b "b-driver" (ai_actors ext_c_banshee/banshee))))
	(sleep 30)
	(ai_conversation c_bridge_banshee_takeoff)
	)

(script dormant dialog_control_clear
	(sleep_until (= (ai_living_count control_cov) 0))
	(sleep 60)
	(ai_conversation control_clear)
	)			  

;========== End Game Script ==========

(script dormant game_win_script
	(sleep_until (> (device_get_position control_door_d) 0))
	(sleep -1 dialog_control_clear)
	(ai_conversation_stop control_clear)
	(sleep_until (> (device_get_position control_door_d) .3))
	(set play_music_b40_08 false)
;<JLG>
   (if (mcc_mission_segment "cine2_final") (sleep 1))
   
	(fade_out 1 1 1 15)
	(sleep 15)
	(ai_kill_silent control_cov)
	(sleep 5)
	(if (cinematic_skip_start) (cutscene_extraction))
	(cinematic_skip_stop)
;</JLG>
	(game_won)
	)

;========== Objective,Help and Title Screen Scripts ==========

(script dormant obj_chasm1
	(show_hud_help_text 1)
	(hud_set_help_text obj_chasm1)
	(hud_set_objective_text obj_chasm1)
	(sleep (* 30 10))
	(show_hud_help_text 0)
	)

(script dormant obj_chasm2
	(show_hud_help_text 1)
	(hud_set_help_text obj_chasm2)
	(hud_set_objective_text obj_chasm2)
	(sleep (* 30 10))
	(show_hud_help_text 0)
	)

(script dormant obj_control
	(show_hud_help_text 1)
	(hud_set_help_text obj_control)
	(hud_set_objective_text obj_control)
	(sleep (* 30 10))
	(show_hud_help_text 0)
	)

;<JLG>
(script dormant help_tank
	(sleep_until (vehicle_test_seat_list ext_a_tank "scorpion-driver" (players)) 10)
	(if (player0_joystick_set_is_normal) (display_scenario_help 3) (display_scenario_help 4))
	)

(script dormant help_banshee
	(sleep_until (or (vehicle_test_seat_list insertion_banshee_a "b-driver" (players))
				  (vehicle_test_seat_list ext_c_banshee_a "b-driver" (players))
				  (vehicle_test_seat_list ext_c_banshee_b "b-driver" (players))) 10)
	(if (player0_joystick_set_is_normal) (display_scenario_help 5) (display_scenario_help 6))
	)

(script dormant title_intro
	(sleep 90)
	(cinematic_set_title intro)
	)

(script dormant title_thunder
	(sleep_until (volume_test_objects ext_b_trigger (players)) 5)
	(cinematic_show_letterbox 1)
	(show_hud 0)
	(sleep 30)
	(cinematic_set_title thunder)
	(sleep 150)
	(cinematic_show_letterbox 0)
	(show_hud 1)
	)

(script dormant title_control
	(sleep_until (volume_test_objects ext_c_trigger_a (players)))
	(cinematic_show_letterbox 1)
	(show_hud 0)
	(sleep 30)
	(cinematic_set_title control)
	(sleep 150)
	(cinematic_show_letterbox 0)
	(show_hud 1)
	)
;</JLG>

(script static void predict_ext_scenery
	(object_type_predict "scenery\shrubs\shrub_large\shrub_large")
	(object_type_predict "levels\b40\scenery\b40_snowbush\b40_snowbush")
	(object_type_predict "levels\b40\scenery\b40_snowbushsmall\b40_snowbushsmall")
	(object_type_predict "scenery\trees\tree_pine_snow\tree_pine_snow")
	(object_type_predict "scenery\trees\tree_pine_snowsmall\tree_pine_snowsmall")
	(object_type_predict "scenery\rocks\boulder_snow_small\boulder_snow_small")
	(object_type_predict "scenery\rocks\boulder_granite_large\boulder_granite_large")
	(object_type_predict "scenery\rocks\boulder_snow_gigantic\boulder_snow_gigantic")
	(object_type_predict "levels\b40\scenery\b40_ctorch\ctorch")
	(object_type_predict "levels\b40\devices\b40_outerdoor\b40_outerdoor")
	(object_type_predict "scenery\c_storage\c_storage")
	(object_type_predict "levels\b40\scenery\bridge lightning markers\bridge lightning")
	)

;========== Recording Scripts ==========
;	(object_create ext_a_dropship_turret)
;	(object_create ext_a_dropship_ghost_a)
;	(object_create ext_a_dropship_ghost_b)
;	(unit_enter_vehicle ext_a_dropship_ghost_a ext_a_dropship_a "cargo_ghost01")
;	(unit_enter_vehicle ext_a_dropship_ghost_b ext_a_dropship_a "cargo_ghost03")

(script static void clean
	(ai_erase_all)
	(ai_reconnect)
	(garbage_collect_now)
	(cls)
	)

;(script static void record
;	(object_destroy pelican_a)
;	(object_create pelican_a)
;	(objects_predict pelican_a)
;	(object_teleport pelican_a ext_b_pelican)
;	(recording_play_and_hover pelican_a EXT_B_PELICAN_IN)
;	)

(script static void ext_b_b_dropship_b
	(object_destroy c_dropship_b)
	(object_create c_dropship_b)
;	(unit_close c_dropship_b)
	(objects_predict c_dropship_b)
	(object_teleport c_dropship_b ext_b_b_dropship_b)
;	(vehicle_hover c_dropship_b 1)
	(recording_play_and_delete c_dropship_b ext_b_b_dropship_b_out)
	)

(script static void ext_b_b_dropship_a
	(object_destroy c_dropship_b)
	(object_create c_dropship_b)
	(object_teleport c_dropship_b ext_b_b_dropship_a)
	(recording_play_and_hover c_dropship_b ext_b_b_dropship_a_in)
	(unit_close c_dropship_b)

	(ai_place ext_b_area_b_cov/elites_p)
	(ai_place ext_b_area_b_cov/grunts_p)
	(ai_place ext_b_area_b_cov/jackals_p)

	(vehicle_load_magic c_dropship_b "passenger" (ai_actors ext_b_area_b_cov/elites_p))
	(vehicle_load_magic c_dropship_b "passenger" (ai_actors ext_b_area_b_cov/grunts_p))
	(vehicle_load_magic c_dropship_b "passenger" (ai_actors ext_b_area_b_cov/jackals_p))
	(sleep 1)
	(objects_predict c_dropship_b)
	(objects_predict (ai_actors ext_b_area_a_cov))

; tweak this value if conversation starts too soon
	(sleep 150)
	(ai_conversation ext_b_b_reins)
	
	(sleep (recording_time c_dropship_b))
	(unit_open c_dropship_b)
	(sleep 30)
	
	(begin_random 
		(begin (vehicle_unload c_dropship_b cd-passengerl01) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerl02) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerl03) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerl04) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerr01) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerr02) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerr03) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerr04) (sleep 5)))
		
	(sleep 90)
	(vehicle_hover c_dropship_b 0)
	(recording_play_and_delete c_dropship_b ext_b_b_dropship_a_out)
	)

(script static void ext_b_a_dropship_a
	(object_destroy c_dropship_b)
	(object_create c_dropship_b)
	(object_teleport c_dropship_b ext_b_dropship_a)
	(unit_enter_vehicle ext_b_a_ghost_a c_dropship_b "cargo_ghost01")
	(unit_enter_vehicle ext_b_a_ghost_b c_dropship_b "cargo_ghost03")
	(unit_close c_dropship_b)
	(recording_play_and_hover c_dropship_b ext_b_dropship_a_in)

	(ai_place ext_b_area_a_cov/elites_e)
	(ai_place ext_b_area_a_cov/grunts_e)
	(ai_place ext_b_area_a_cov/jackals_e)
	(ai_place ext_b_area_a_cov/elites_f)
	(ai_place ext_b_area_a_cov/grunts_f)
	(ai_place ext_b_area_a_cov/jackals_f)

	(vehicle_load_magic c_dropship_b "passengerl" (ai_actors ext_b_area_a_cov/elites_e))
	(vehicle_load_magic c_dropship_b "passengerl" (ai_actors ext_b_area_a_cov/grunts_e))
	(vehicle_load_magic c_dropship_b "passengerl" (ai_actors ext_b_area_a_cov/jackals_e))
	(vehicle_load_magic c_dropship_b "passengerr" (ai_actors ext_b_area_a_cov/elites_f))
	(vehicle_load_magic c_dropship_b "passengerr" (ai_actors ext_b_area_a_cov/grunts_f))
	(vehicle_load_magic c_dropship_b "passengerr" (ai_actors ext_b_area_a_cov/jackals_f))
	
	(sleep 1)
	(objects_predict c_dropship_b)
	(objects_predict ext_b_a_ghost_a)
	(objects_predict ext_b_a_ghost_b)
	(objects_predict (ai_actors ext_b_area_a_cov))

	(sleep (- (recording_time c_dropship_b) 60))
	(begin_random
		(begin (unit_exit_vehicle ext_b_a_ghost_a) (sleep 15))
		(begin (unit_exit_vehicle ext_b_a_ghost_b) (sleep 15)))
	(sleep 15)
	(unit_open c_dropship_b)
	(sleep 30)
	
	(begin_random 
		(begin (vehicle_unload c_dropship_b cd-passengerl01) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerl02) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerl03) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerl04) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerr01) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerr02) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerr03) (sleep 5))
		(begin (vehicle_unload c_dropship_b cd-passengerr04) (sleep 5)))
		
	(sleep 30)
	(vehicle_hover c_dropship_b 0)
	(recording_play_and_delete c_dropship_b ext_b_dropship_a_out)
	
	(ai_vehicle_enterable_distance ext_b_a_ghost_a 20)
	(ai_vehicle_enterable_distance ext_b_a_ghost_b 20)
	
	(ai_go_to_vehicle ext_b_area_a_cov/elites_e ext_b_a_ghost_a "driver")
	(ai_go_to_vehicle ext_b_area_a_cov/elites_f ext_b_a_ghost_b "driver")
	
	(ai_vehicle_encounter ext_b_a_ghost_a ext_b_a_ghost_a/squad_a)
	(ai_vehicle_encounter ext_b_a_ghost_b ext_b_a_ghost_b/squad_a)
	
	(ai_follow_target_players ext_b_a_ghost_a)
	(ai_follow_target_players ext_b_a_ghost_b)
	
	(ai_magically_see_players ext_b_a_ghost_a)
	(ai_magically_see_players ext_b_a_ghost_b)
	)

(script static void cinematic_ext_a_pelican
	(object_destroy pelican_a)
	(object_create pelican_a)
	(object_create ext_a_pelican_jeep)
	(ai_place ext_a_area_a_marines)
	(unit_enter_vehicle ext_a_pelican_jeep pelican_a "cargo")
	(vehicle_load_magic pelican_a "rider" (ai_actors ext_a_area_a_marines/marines_pelican))
	
	(sleep 1)
	(ai_braindead ext_a_area_a_marines/marines_pelican true)
	(objects_predict pelican_a)
	(objects_predict ext_a_pelican_jeep)
	(objects_predict (ai_actors ext_a_area_a_marines))

	(object_teleport pelican_a ext_a_pelican_flag)
	(recording_play pelican_a ext_a_pelican_in)
	(sleep (recording_time pelican_a))
	(ai_braindead ext_a_area_a_marines false)

	(sleep 1)
	(unit_exit_vehicle ext_a_pelican_jeep)
	(vehicle_unload pelican_a "rider")
	(sleep 60)
	(ai_disregard	(ai_actors ext_a_area_a_marines/marines_pelican) true)
	(ai_command_list ext_a_area_a_marines ext_a_pelican_marines)
	(recording_play_and_delete pelican_a ext_a_pelican_out)
	
	(sleep_until (= (ai_command_list_status (ai_actors ext_a_area_a_marines)) 1))
	(ai_braindead ext_a_area_a_marines/marines_pelican true)
	)

(script static void cinematic_ext_a_dropship_a
;	(object_destroy c_dropship_a)
;	(object_create c_dropship_a)
	(object_create ext_a_dropship_wraith_a)
;	(unit_close c_dropship_a)
;	(unit_enter_vehicle ext_a_dropship_wraith_a c_dropship_a "cargo_ghost02")

;	(ai_place ext_a_area_a_cov/jackals_i)
;	(ai_place ext_a_area_a_cov/elites_i)
;	(ai_place ext_a_area_a_cov/jackals_o)
;	(ai_place ext_a_area_a_cov/elites_o)
;	(ai_place ext_a_area_a_cov/jackals_q)
	(ai_place ext_a_area_a_cov/wraith_pilot)
	(sleep 1)
;	(objects_predict c_dropship_a)
	(objects_predict ext_a_dropship_wraith_a)
	(objects_predict (ai_actors ext_a_area_a_cov))

;	(vehicle_load_magic c_dropship_a "passengerl" (ai_actors ext_a_area_a_cov/jackals_i))
;	(vehicle_load_magic c_dropship_a "passengerl" (ai_actors ext_a_area_a_cov/elites_i))
;	(vehicle_load_magic c_dropship_a "passengerr" (ai_actors ext_a_area_a_cov/jackals_o))
;	(vehicle_load_magic c_dropship_a "passengerr" (ai_actors ext_a_area_a_cov/elites_o))
	(sleep 1)
;	(vehicle_load_magic c_dropship_a "passenger" (ai_actors ext_a_area_a_cov/jackals_q))
	(vehicle_load_magic ext_a_dropship_wraith_a "driver" (ai_actors ext_a_area_a_cov/wraith_pilot))

;	(object_teleport c_dropship_a ext_a_dropship_a_flag)
;	(recording_play c_dropship_a ext_a_dropship_a_in)
;	(sleep (- (recording_time c_dropship_a) 90))
;	(unit_open c_dropship_a)
;	(sleep 15)

;	(begin_random 
;		(begin (vehicle_unload c_dropship_b cd-passengerl01) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerl02) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerl03) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerl04) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerr01) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerr02) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerr03) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerr04) (sleep 5)))

;	(vehicle_hover c_dropship_a 1)
;	(sleep 120)
;	(unit_close c_dropship_a)
;	(unit_exit_vehicle ext_a_dropship_wraith_a)
;	(sleep 1)
	(ai_vehicle_encounter ext_a_dropship_wraith_a ext_a_area_a_wraith/squad_i)
	(ai_magically_see_encounter ext_a_area_a_wraith ext_a_area_a_marines)

		
;	(sleep 15)
;	(vehicle_hover c_dropship_a 0)
;	(recording_play_and_delete c_dropship_a ext_a_dropship_a_out)
	)

(script static void cinematic_ext_a_dropship_b
;	(object_destroy c_dropship_b)
;	(object_create c_dropship_b)
	(object_create ext_a_dropship_turret)
	(object_create ext_a_dropship_ghost_a)
	(object_create ext_a_dropship_ghost_b)
;	(unit_close c_dropship_b)

	(ai_place ext_a_area_a_cov/grunts_g)
	(ai_place ext_a_area_a_cov/jackals_g)
	(ai_place ext_a_area_a_cov/grunts_k)
	(ai_place ext_a_area_a_cov/jackals_k2)
	(ai_place ext_a_area_a_cov/ghost_pilot_a)
;	(if (= (game_difficulty_get) impossible) (ai_place ext_a_area_a_cov/ghost_pilot_b))
	(ai_place ext_a_area_a_cov/turret_grunts_b)
	
	(sleep 1)
;	(objects_predict c_dropship_b)
	(objects_predict ext_a_dropship_turret)
	(objects_predict ext_a_dropship_ghost_a)
;	(objects_predict ext_a_dropship_ghost_b)
	(objects_predict (ai_actors ext_a_area_a_cov))

;	(vehicle_load_magic c_dropship_b "passengerl" (ai_actors ext_a_area_a_cov/grunts_g))
;	(vehicle_load_magic c_dropship_b "passengerl" (ai_actors ext_a_area_a_cov/jackals_g))
;	(vehicle_load_magic c_dropship_b "passengerr" (ai_actors ext_a_area_a_cov/grunts_k))
;	(vehicle_load_magic c_dropship_b "passengerr" (ai_actors ext_a_area_a_cov/jackals_k2))
;	(vehicle_load_magic c_dropship_b "passengerl" (ai_actors ext_a_area_a_cov/ghost_pilot_a))
;	(vehicle_load_magic c_dropship_b "passengerr" (ai_actors ext_a_area_a_cov/ghost_pilot_b))
	(vehicle_load_magic ext_a_dropship_turret "gunner" (ai_actors ext_a_area_a_cov/turret_grunts_b))

;	(unit_enter_vehicle ext_a_dropship_ghost_a c_dropship_b "cargo_ghost01")
;	(unit_enter_vehicle ext_a_dropship_ghost_b c_dropship_b "cargo_ghost03")
;	(unit_enter_vehicle ext_a_dropship_turret c_dropship_b "cargo_ghost02")

;	(object_teleport c_dropship_b ext_a_dropship_b_flag)
;	(recording_play_and_hover c_dropship_b ext_a_dropship_b_in)
;	(sleep (recording_time c_dropship_b))
;	(unit_exit_vehicle ext_a_dropship_turret)
;	(sleep 30)
;	(vehicle_hover c_dropship_b 0)

;	(sleep 30)
;	(recording_play_and_hover c_dropship_b ext_a_dropship_b_exit)
;	(sleep (recording_time c_dropship_b))

;	(begin_random
;		(begin (unit_exit_vehicle ext_a_dropship_ghost_a) (sleep 15))
;		(begin (unit_exit_vehicle ext_a_dropship_ghost_b) (sleep 15)))
;	(sleep 30)
;	(unit_open c_dropship_b)
;	(sleep 30)
	
	(ai_vehicle_encounter ext_a_dropship_ghost_a ext_a_area_a_ghost_a/squad_j)
	(ai_vehicle_encounter ext_a_dropship_ghost_b ext_a_area_a_ghost_b/squad_j)

	(ai_follow_target_players ext_a_area_a_ghost_a/squad_j)
	(ai_follow_target_players ext_a_area_a_ghost_b/squad_j)


;	(begin_random 
;		(begin (vehicle_unload c_dropship_b cd-passengerl01) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerl02) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerl03) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerl04) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerr01) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerr02) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerr03) (sleep 5))
;		(begin (vehicle_unload c_dropship_b cd-passengerr04) (sleep 5)))
		
	(sleep (random_range 300 450))
	
	(ai_go_to_vehicle ext_a_area_a_cov/ghost_pilot_a ext_a_dropship_ghost_a "driver")
	(ai_go_to_vehicle ext_a_area_a_cov/ghost_pilot_b ext_a_dropship_ghost_b "driver")

	(ai_vehicle_enterable_distance ext_a_dropship_ghost_a 15)
	(ai_vehicle_enterable_distance ext_a_dropship_ghost_b 15)
	
	(ai_magically_see_players ext_a_area_a_ghost_a)
	(ai_magically_see_players ext_a_area_a_ghost_b)

;	(unit_close c_dropship_b)
;	(vehicle_hover c_dropship_b 0)
;	(recording_play_and_delete c_dropship_b ext_a_dropship_b_out)
	)

(script static void cinematic_crev_ent_a
;	(object_destroy c_dropship_a)
;	(object_create c_dropship_a)
	(object_create crev_ent_wraith_a)
;	(unit_close c_dropship_a)
	(ai_place ext_a_area_c_cov/wraith_a_pilot)
	
	(sleep 1)
;	(objects_predict c_dropship_a)
	(objects_predict crev_ent_wraith_a)
	(objects_predict (ai_actors ext_a_area_c_cov))
	
	(vehicle_load_magic crev_ent_wraith_a "driver" (ai_actors ext_a_area_c_cov/wraith_a_pilot))
;	(unit_enter_vehicle crev_ent_wraith_a c_dropship_a "cargo_ghost02")

;	(object_teleport c_dropship_a crev_ent_dropship_a_flag)
;	(recording_play c_dropship_a crev_ent_dropship_a_in)
;	(sleep (- (recording_time c_dropship_a) 30))
;	(unit_exit_vehicle crev_ent_wraith_a)
	(ai_vehicle_encounter crev_ent_wraith_a ext_a_area_c_wraith_a/squad_a)
	(ai_magically_see_players ext_a_area_c_wraith_a)
;	(sleep 30)
;	(recording_play_and_delete c_dropship_a crev_ent_dropship_a_out)
	)

(script static void cinematic_crev_ent_b
;	(object_destroy c_dropship_b)
;	(object_create c_dropship_b)
;	(unit_close c_dropship_b)
	(object_create crev_ent_wraith_b)	
	(ai_place ext_a_area_c_cov/wraith_b_pilot)
	
	(sleep 1)
;	(objects_predict c_dropship_b)
	(objects_predict crev_ent_wraith_b)
	(objects_predict (ai_actors ext_a_area_c_cov))

	(vehicle_load_magic crev_ent_wraith_b "driver" (ai_actors ext_a_area_c_cov/wraith_b_pilot))
;	(unit_enter_vehicle crev_ent_wraith_b c_dropship_b "cargo_ghost02")

;	(object_teleport c_dropship_b crev_ent_dropship_b_flag)
;	(recording_play c_dropship_b crev_ent_dropship_b_in)
;	(sleep (- (recording_time c_dropship_b) 30))
;	(unit_exit_vehicle c_dropship_b)
	(ai_vehicle_encounter crev_ent_wraith_b ext_a_area_c_wraith_b/squad_b)
	(ai_magically_see_players ext_a_area_c_wraith_b)
;	(sleep 30)
;	(recording_play_and_delete c_dropship_b crev_ent_dropship_b_out)
	)

(script static void cinematic_crev_ent_c
;	(object_destroy c_dropship_c)
;	(object_create c_dropship_c)
;	(unit_close c_dropship_c)
	(object_create crev_ent_ghost_a)
	(object_create crev_ent_ghost_b)
	(object_create crev_ent_ghost_c)
	
	(ai_place ext_a_area_c_cov/ghost_a_pilot)
	(ai_place ext_a_area_c_cov/ghost_b_pilot)
	(ai_place ext_a_area_c_cov/ghost_c_pilot)
	
	(sleep 1)
;	(objects_predict c_dropship_c)
	(objects_predict crev_ent_ghost_a)
	(objects_predict crev_ent_ghost_b)
	(objects_predict crev_ent_ghost_c)
	(objects_predict (ai_actors ext_a_area_c_cov))

	(vehicle_load_magic crev_ent_ghost_a "driver" (ai_actors ext_a_area_c_cov/ghost_a_pilot))
	(vehicle_load_magic crev_ent_ghost_b "driver" (ai_actors ext_a_area_c_cov/ghost_b_pilot))
	(vehicle_load_magic crev_ent_ghost_c "driver" (ai_actors ext_a_area_c_cov/ghost_c_pilot))

;	(unit_enter_vehicle crev_ent_ghost_a c_dropship_c "cargo_ghost01")
;	(unit_enter_vehicle crev_ent_ghost_b c_dropship_c "cargo_ghost02")
;	(unit_enter_vehicle crev_ent_ghost_c c_dropship_c "cargo_ghost03")
	
;	(object_teleport c_dropship_c crev_ent_dropship_c_flag)
;	(recording_play_and_delete c_dropship_c crev_ent_dropship_c_in)

;	(sleep 1005)
	
;	(unit_exit_vehicle crev_ent_ghost_a)
;	(sleep 40)
;	(unit_exit_vehicle crev_ent_ghost_b)
;	(sleep 40)
;	(unit_exit_vehicle crev_ent_ghost_c)

	(ai_vehicle_encounter crev_ent_ghost_a ext_a_area_c_ghost_a/squad_d)
	(ai_vehicle_encounter crev_ent_ghost_b ext_a_area_c_ghost_b/squad_c)
	(ai_vehicle_encounter crev_ent_ghost_c ext_a_area_c_ghost_c/squad_c)
	
	(ai_follow_target_players ext_a_area_c_ghost_a/squad_d)
	(ai_follow_target_players ext_a_area_c_ghost_b/squad_c)
	(ai_follow_target_players ext_a_area_c_ghost_c/squad_c)

	(ai_vehicle_enterable_distance crev_ent_ghost_a 10)
	(ai_vehicle_enterable_distance crev_ent_ghost_b 10)
	(ai_vehicle_enterable_distance crev_ent_ghost_c 10)
	
	(ai_magically_see_players ext_a_area_c_ghost_a)
	(ai_magically_see_players ext_a_area_c_ghost_b)
	(ai_magically_see_players ext_a_area_c_ghost_c)

	)

;========== Test Scripts ==========

(script static void jump_marines
	(object_create ext_a_pelican_jeep)
	(ai_vehicle_encounter ext_a_pelican_jeep test_hum/jump_jeep)
	(ai_place test_hum/jump_marines)
	(sleep 60)
	(ai_go_to_vehicle test_hum/jump_marines ext_a_pelican_jeep "driver")
	(ai_go_to_vehicle test_hum/jump_marines ext_a_pelican_jeep "passenger")
;	(ai_go_to_vehicle ext_a_area_a_cov jeep_a "gunner")
	(ai_vehicle_enterable_distance ext_a_pelican_jeep 20)
	)

(script static void drive_jeep
	(ai_command_list test_hum/jump_jeep jeep_jump)
	)
	
;(script static void wraith
;	(object_create test_wraith)
;	(ai_vehicle_encounter test_wraith test_cov/wraith)
;	(ai_place test_cov/elite)
;	(ai_vehicle_enterable_distance test_wraith 4)
;	)

;(script static void ghost
;	(object_create test_ghost)
;	(ai_vehicle_encounter test_ghost test_cov/ghost)
;	(ai_place test_cov/elite)
;	(ai_vehicle_enterable_distance test_ghost 4)
;	)

;(script static void turret
;	(object_create test_turret)
;	(ai_vehicle_encounter test_turret test_cov/turret)
;	(ai_place test_cov/elite)
;	(ai_vehicle_enterable_distance test_turret 4)
;	)

;(script static void jeep
;	(object_create test_jeep)
;	(ai_vehicle_encounter test_jeep test_hum/jeep)
;	(ai_place test_hum/marine)
;	(ai_vehicle_enterable_distance test_jeep 4)
;	)

;(script static void tank
;	(object_create test_tank)
;	(ai_vehicle_encounter test_tank test_hum/tank)
;	(ai_place test_hum/marine)
;	(ai_vehicle_enterable_distance test_tank 4)
;	)


;	(ai_command_list ext_a_area_a_cov/grunts_a ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/grunts_e ext_a_area_a_ledge_b)
;	(ai_command_list ext_a_area_a_cov/grunts_g ext_a_area_a_ledge_c)
;	(ai_command_list ext_a_area_a_cov/grunts_k ext_a_area_a_ledge_d)
;	(ai_command_list ext_a_area_a_cov/jackals_e ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/jackals_g ext_a_area_a_ledge_b)
;	(ai_command_list ext_a_area_a_cov/jackals_i ext_a_area_a_ledge_c)
;	(ai_command_list ext_a_area_a_cov/jackals_o ext_a_area_a_ledge_d)
;	(ai_command_list ext_a_area_a_cov/jackals_q ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/jackals_k1 ext_a_area_a_ledge_b)
;	(ai_command_list ext_a_area_a_cov/jackals_K2 ext_a_area_a_ledge_c)
;	(ai_command_list ext_a_area_a_cov/elites_a ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/elites_e ext_a_area_a_ledge_b)
;	(ai_command_list ext_a_area_a_cov/elites_i ext_a_area_a_ledge_c)
;	(ai_command_list ext_a_area_a_cov/elites_k ext_a_area_a_ledge_d)
;	(ai_command_list ext_a_area_a_cov/elites_o ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/ghost_pilot_a ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/ghost_pilot_b ext_a_area_a_ledge_d)
;	(ai_command_list ext_a_area_a_cov/wraith_pilot ext_a_area_a_ledge_a)
	
;	(ai_command_list ext_a_area_a_cov/squad_a ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/squad_c ext_a_area_a_ledge_b)
;	(ai_command_list ext_a_area_a_cov/squad_e ext_a_area_a_ledge_c)
;	(ai_command_list ext_a_area_a_cov/squad_g ext_a_area_a_ledge_d)
;	(ai_command_list ext_a_area_a_cov/squad_i ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/squad_k ext_a_area_a_ledge_b)
;	(ai_command_list ext_a_area_a_cov/squad_m ext_a_area_a_ledge_c)
;	(ai_command_list ext_a_area_a_cov/squad_o ext_a_area_a_ledge_d)
;	(ai_command_list ext_a_area_a_cov/squad_q ext_a_area_a_ledge_a)
;	(ai_command_list ext_a_area_a_cov/squad_s ext_a_area_a_ledge_b)

