;          A50 Mission Script

;========== Mission Outline ==========

;	== Intro Cutscene ==

;	Area 1
;	- Landing Zone Cinematic
;	- 2nd Dropship Cinematic

;	Area 2 Encounter
;	Area 3 Encounter
;	Area 4 Encounter
;	Area 5 Encounter

;	== Enter the ship Cinematic ==

;	Secure grav Pad Room
;	Proceed to Muster Bay
;	Proceed to Hangar
;	Find the Control Room
;	Locate the Captain
;	Save the Captain
;	Control room revisited
;	Proceed to second floor of the hangar
;	Steal a Covenant dropship and escape

;	== Outro Cutscene ==

;========== Global Variables ==========

(global boolean mission_begin 0)

;used for printing of debug text
;(global boolean debug false)
;(global boolean objective true)

(global boolean area2_marine_migrate false)
(global boolean area2_marine_migrate_2 false)

(global long default_encounter_delay 150)
(global long default_gravity_delay 150)
(global long default_muster_delay 150)
(global long default_sleep_expire 450)

;-------------- exterior variables --------------
(global short area4_location_index 0)
(global long default_turret_gunner_delay (* 30 30))
(global boolean area4_covenant_reins true)
(global boolean area4_pelican_a true)

(global boolean area4_cov_dropship true)
(global boolean area4_marine_reins true)
(global boolean area5_pelican true)



;-------------- Area 5 Variables --------------
; turns a1 spawner off
(global boolean area5_e_spawn true)
; counts the # of squads spawned
; DO NOT CHANGE
(global short area5_e_spawn_counter 0)
; limits the # of squads spawned
; range 0-2
(global short area5_e_squad_index 2)

(global boolean area5_g_spawn true)
(global short area5_g_spawn_counter 0)
(global short area5_g_squad_index 2)


(global boolean area5_o_spawn true)
(global short area5_o_spawn_counter 0)
(global short area5_o_squad_index 2)


(global boolean area5_q_spawn true)
(global short area5_q_spawn_counter 0)
(global short area5_q_squad_index 2)

;-------------- interior variables --------------
;(global boolean gravity_pad_initialization false)
(global boolean muster_bay_door_unlocked false)


;-------------- gravity room encounter spawn variables --------------
;turns continuous encounter spawn scripts on/off
(global boolean grav_frontleft true)
(global boolean grav_rearleft true)
(global boolean grav_frontright true)
(global boolean grav_rearright true)
;counts the # of characters spawned
;DO NOT CHANGE
;use enc_***_index or ini_***_index to change the # of encounters that get spawned.
(global short gravity_enc_index 0)
;used to set the # of characters spawned in the encounter
;range (1-4) usually set in the script
(global short enc_grav_frontleft_index 2)
(global short enc_grav_frontright_index 2)
(global short enc_grav_rearleft_index 2)
(global short enc_grav_rearright_index 2)

;-------------- gravity wave initialization script variables --------------
;turns gravity wave continuous scripts on/off
(global boolean gravity_wave false)
;used to control the # of encounters that get spawned
;range (0-4) usually set in the script
(global short ini_grav_wave_index 0)
;counts the # of encounters spawned.
;DO NOT CHANGE
;use enc_***_index or ini_***_index to change the # of encounters that get spawned.
(global short gravity_wave_index 0)
(global short grav_cov_limit 1)

;delay variables
(global long grav_frontleft_delay 60)
(global long grav_frontright_delay 60)
(global long grav_rearleft_delay 60)
(global long grav_rearright_delay 60)
(global long grav_mar_return_delay 270)


;-------------- gravity room - muster bay hallway variables --------------
(global boolean grav_mus_hall true)
;counts the # of encounters spawned
(global short grav_mus_hall_index 0)
;limit for how many encounters get spawned
(global short enc_grav_mus_hall_index 1)

;-------------- muster ledge wave encounter spawn variables --------------
;turns muster wave continuous scripts on/off
(global boolean muster_ledge false)
;used to control the # of encounters that get spawned
;range (0-3) usually set in the script
(global short ini_muster_ledge_index 2)
;counts the # of encounters spawned.
;DO NOT CHANGE
;use enc_***_index or ini_***_index to change the # of encounters that get spawned.
(global short muster_ledge_index 0)

(global boolean muster_door_nav true)
;-------------- muster wave encounter spawn variables --------------
;turns continuous encounter spawn scripts on/off
(global boolean muster_l1 true)
(global boolean muster_l2 true)
(global boolean muster_l3 true)
(global boolean muster_r1 true)
(global boolean muster_r2 true)
(global boolean muster_r3 true)
;counts the # of characters spawned
;DO NOT CHANGE
;use enc_***_index or ini_***_index to change the # of encounters that get spawned.
(global short muster_enc_index 0)
;used to set the # of characters spawned in the encounter
;range (1-3) 
(global short enc_mus_bot_l1_index 2)
(global short enc_mus_bot_l2_index 2)
(global short enc_mus_bot_l3_index 2)
(global short enc_mus_bot_r1_index 2)
(global short enc_mus_bot_r2_index 2)
(global short enc_mus_bot_r3_index 2)

;-------------- muster wave initialization script variables --------------
;turns muster wave continuous scripts on/off
(global boolean muster_wave false)
;used to control the # of encounters that get spawned
;range (0-6) usually set in the script
(global short ini_muster_wave_index 0)
;counts the # of encounters spawned.
;DO NOT CHANGE
;use enc_***_index or ini_***_index to change the # of encounters that get spawned.
(global short muster_wave_index 0)
(global short muster_cov_limit 1)

;----------------- hangar migration variables -------------------
(global short hangar_location_index 0)
(global boolean pelican_hangar_a_trigger true)
;(global boolean hangar_manager false)
;(global long hangar_manage_delay_in 30)
;(global long hangar_manage_delay_out 0)
;(global long hangar_first_migrate_delay (* 30 60))

;----------------- prison migration variables -------------------

(global boolean captain_rescued false)
;initial captain location index
;1 - cellblock a
;2 - cellblock b
;3 - cellblock c
;4 - cellblock d
;(global short ini_captain_location 0)
;see escaped convict migration scripts: hallway migration scripts for variable definitions
;1 - prison area a
;2 - prison area b... so on and so forth
;(global short captain_location_index 0)
(global short player_location_index 0)

;(global boolean prison_manager false)

;(global long prison_manage_delay_in 0)
;(global long prison_manage_delay_out 0)

;(script static void clean
;	(ai_erase_all)
;	(ai_reconnect)
;	(garbage_collect_now)
;	(cls)
;	)
;========== Save Point Scripts ==========

;(script static void save
;	(sleep_until (game_safe_to_save))
;	(game_save))
	
(script continuous general_save
;	(save)
	(if (= mission_begin 0) (sleep -1))
	(game_save_no_timeout)
	(sleep -1)
	)


;========== Stub Scripts ==========

(script stub void cutscene_rescue
	(print "merging cinema script failed")
	)

;(script stub void run_setup
;	(print "merging cinema script failed")
;	)

(script stub void cutscene_extraction
	(print "merging cinema script failed")
	)

;(script stub void flight_check
;	(print "merging cinema script failed")
;	)

;========== Music Scripts ==========

(global boolean play_music_a50_01 true)
(global boolean play_music_a50_02 true)
(global boolean play_music_a50_03 true)
(global boolean play_music_a50_04 true)
(global boolean play_music_a50_05 true)
(global boolean play_music_a50_06 true)
(global boolean play_music_a50_07 true)
(global boolean play_music_a50_071 true)
(global boolean play_music_a50_072 true)
(global boolean play_music_a50_08 true)
(global boolean play_music_a50_09 true)
(global boolean play_music_a50_10 true)
(global boolean play_music_a50_11 true)

(script dormant music_a50_01
;	(sleep_until play_music_a50_01)
;	(sound_looping_set_alternate <looping_sound> <boolean>)
	(sound_looping_start "levels\a50\music\a50_01" none 1)
	(sleep_until (not play_music_a50_01))
;	(sound_looping_set_alternate "levels\a50\music\a50_01" false)
;	(sleep 1)
	(sound_looping_stop "levels\a50\music\a50_01")
	)

(script dormant music_a50_02
;	(sleep_until play_music_a50_02)
	(sound_looping_start "levels\a50\music\a50_02" none 1)
	(sleep_until (not play_music_a50_02))
	(sound_looping_stop "levels\a50\music\a50_02")
	)

(script dormant music_a50_03
;	(sleep_until play_music_a50_03)
	(sound_looping_start "levels\a50\music\a50_03" none 1)
	(sleep_until (not play_music_a50_03))
	(sound_looping_stop "levels\a50\music\a50_03")
	)

(script dormant music_a50_04
;	(sleep_until play_music_a50_04)
	(sound_looping_start "levels\a50\music\a50_04" none 1)
	(sleep_until (not play_music_a50_04))
	(sound_looping_stop "levels\a50\music\a50_04")
	)

(script dormant music_a50_05
	(sound_looping_start "levels\a50\music\a50_05" none 1)

;change this based on difficulty
	(if (= (game_difficulty_get) normal) (sleep_until (> gravity_wave_index 2)))
	(if (= (game_difficulty_get) hard) (sleep_until (> gravity_wave_index 4)))
	(if (= (game_difficulty_get) impossible) (sleep_until (> gravity_wave_index 6)))
;	(sleep_until play_music_a50_05)
	(sound_looping_set_alternate "levels\a50\music\a50_05" 1)

	(sleep_until (not play_music_a50_05))
	(sound_looping_stop "levels\a50\music\a50_05")
	)

(script dormant music_a50_06
;	(sleep_until play_music_a50_06)
	(sound_looping_start "levels\a50\music\a50_06" none 1)
	(sleep_until (not play_music_a50_06))
	(sound_looping_stop "levels\a50\music\a50_06")
	)

(script dormant music_a50_07
;	(sleep_until play_music_a50_07)
	(sound_looping_start "levels\a50\music\a50_07" none 1)
	(sleep_until (not play_music_a50_07))
	(sound_looping_stop "levels\a50\music\a50_07")
	)

(script dormant music_a50_071
;	(sleep_until play_music_a50_071)
	(sound_looping_start "levels\a50\music\a50_071" none 1)
	(sleep_until (not play_music_a50_071))
	(sound_looping_stop "levels\a50\music\a50_071")
	)

(script dormant music_a50_072
;	(sleep_until play_music_a50_072)
	(sound_looping_start "levels\a50\music\a50_072" none 1)
	(sleep_until (not play_music_a50_072))
	(sound_looping_stop "levels\a50\music\a50_072")
	)

(script dormant music_a50_08
;	(sleep_until play_music_a50_08)
	(sleep_until (or (> (device_get_position control_door_a) 0)
				  (> (device_get_position control_door_b) 0)
				  (> (device_get_position control_door_c) 0)))
	(sound_looping_start "levels\a50\music\a50_08" none 1)
	(sleep_until (not play_music_a50_08))
	(sound_looping_stop "levels\a50\music\a50_08")
	)

(script dormant music_a50_09
;	(sleep_until play_music_a50_09)
	(sound_looping_start "levels\a50\music\a50_09" none 1)
	(sleep_until (not play_music_a50_09))
	(sound_looping_stop "levels\a50\music\a50_09")
	)

(script dormant music_a50_10
;	(sleep_until play_music_a50_10)
	(sound_looping_start "levels\a50\music\a50_10" none 1)
	(sleep_until (not play_music_a50_10))
	(sound_looping_stop "levels\a50\music\a50_10")
	)

(script dormant music_a50_11
;	(sleep_until play_music_a50_11)
	(sound_looping_start "levels\a50\music\a50_11" none 1)
	(sleep_until (not play_music_a50_11))
	(sound_looping_stop "levels\a50\music\a50_11")
	)

;========== Game Win/Lost Scripts ==========

(script static void extraction_cleanup
	(fade_out 1 1 1 15)
	(sleep 15)
;	(ai_erase_all)
	(object_destroy hangar_dropship_a)
	(object_destroy_containing box)
	(ai_kill_silent hangar_cov_third_floor)
	)

(script dormant game_lost_script
	(sleep_until (<= (unit_get_health captain_keyes) 0) 1)
	(game_save_cancel)
	(sleep -1 general_save)
	(wake music_a50_10)
	(ai_conversation captain_dead)
	(cinematic_show_letterbox true)
	(player_enable_input false)
	(camera_control on)
	(camera_set_dead captain_keyes)
	(sleep 120)
	(game_lost)
	)

(script dormant game_win_script
	(ai_conversation shuttle_revisited)
	(device_set_power hangar_door_b 1)
	(device_set_position hangar_door_b 0)
	(device_group_change_only_once_more_set hangar_door_b_position 1)
	(sleep_until (> (ai_conversation_status shuttle_revisited) 4))
	(activate_team_nav_point_flag "default_red" player extraction_switch_flag 0)

	(sleep_until (= (device_get_position hangar_door_b) 1))
	(device_set_power hangar_door_b 0)
	(deactivate_team_nav_point_flag player extraction_switch_flag)
	
	(sleep_until (and (= (ai_living_count hangar_cov_third_floor/grunts_return) 0)
				   (= (ai_living_count hangar_cov_third_floor/elites_return) 0)) 30 300)
	(ai_follow_target_disable hangar_marines_halls)
	(ai_follow_target_disable hangar_captain_halls)
	(sleep -1 game_lost_script)
	(sleep 1)
	(set play_music_a50_11 false)
	(extraction_cleanup)
  
   (if (mcc_mission_segment "cine4_final") (sleep 1))

	(if (cinematic_skip_start) (cutscene_extraction))
	(cinematic_skip_stop)
	
	(game_won)
	)

;========== Objective,Help and Title Screen Scripts ==========

(script dormant obj_board
	(show_hud_help_text 1)
	(hud_set_help_text obj_board)
	(hud_set_objective_text obj_board)
	(sleep (* 30 5))
	(show_hud_help_text 0)
	)

(script dormant obj_rescue
	(show_hud_help_text 1)
	(hud_set_help_text obj_rescue)
	(hud_set_objective_text obj_rescue)
	(sleep (* 30 5))
	(show_hud_help_text 0)
	)

(script dormant obj_escape
	(show_hud_help_text 1)
	(hud_set_help_text obj_escape)
	(hud_set_objective_text obj_escape)
	(sleep (* 30 5))
	(show_hud_help_text 0)
	)
	
(script dormant obj_sniper
	(show_hud_help_text 1)
	(hud_set_help_text obj_sniper)
	(sleep 450)
	(show_hud_help_text 0)
	)

;(script dormant chapter_start
;	(show_hud false)
;	(cinematic_show_letterbox true)
;	(sleep 30)
;	(cinematic_set_title mission_start)
;	(sleep 150)
;	(cinematic_show_letterbox false)
;	(show_hud true)
;	)

;(script dormant chapter_belly
;	(show_hud false)
;	(cinematic_show_letterbox true)
;	(sleep 30)
;	(cinematic_set_title gravity_lift)
;	(sleep 150)
;	(cinematic_show_letterbox false)
;	(show_hud true)
;	)

;(script dormant chapter_captain
;	(show_hud false)
;	(cinematic_show_letterbox true)
;	(sleep 30)
;	(cinematic_set_title captain)
;	(sleep 180)
;	(cinematic_set_title sir)
;	(sleep 150)
;	(cinematic_show_letterbox false)
;	(show_hud true)
;	)

(script static void ini_scenery_predictions
	(object_type_predict "scenery\shrubs\shrub_large\shrub_large")
	(object_type_predict "scenery\shrubs\shrub_small\shrubsmall")
	(object_type_predict "scenery\rocks\boulder_redrock_small\boulder_redrock_small")
	(object_type_predict "scenery\rocks\boulder_redrock_medium\boulder_redrock_medium")
	(object_type_predict "scenery\rocks\a50_rock_large\a50_rock_large")
	(object_type_predict "scenery\trees\tree_desert_whitebark\tree_desert_whitebark")
	(object_type_predict "scenery\trees\tree_wall1\tree_wall")
	(object_type_predict "scenery\trees\tree_wallbig\tree_wallbig")
	(object_type_predict "scenery\rocks\rock_sharpwedge\rock_sharpwedge")
	(object_type_predict "scenery\trees\tree_desert_dead\tree_desert_dead")
	(object_type_predict "scenery\c_storage\c_storage")
	(object_type_predict "scenery\rocks\rock_sharphole\rock_sharphole")
	(object_type_predict "scenery\rocks\rock_sharpsmall\rock_sharpsmall")
	)

;========== Recording Scripts ==========

; GOOD
(script static void pelican_area4_a
	(set area4_covenant_reins false)
	(ai_conversation ext_marine_reins)
	(sleep 150)
;	(object_destroy insertion_pelican)
	(object_create_anew insertion_pelican)
	(unit_set_enterable_by_player insertion_pelican false)
	(ai_place	marines_area4/marines_m)
	(objects_predict (ai_actors marines_area4))
	(vehicle_load_magic insertion_pelican "rider" (ai_actors marines_area4/marines_m))
	(object_teleport insertion_pelican area4_pelican_flag)
	(recording_play_and_hover insertion_pelican area4_pelican_a_in)
	
	(sleep 1)
	(ai_braindead marines_area4/marines_m 1)
	(objects_predict insertion_pelican)
	(objects_predict (ai_actors marines_area4))

	(sleep (recording_time insertion_pelican))
	(ai_braindead marines_area4 0)
	(sleep 15)
;	(vehicle_hover insertion_pelican 1)
	(vehicle_unload insertion_pelican "rider")
;	(ai_command_list marines_area4/marines_m forward_4s)
	(sleep (* 30 3.5))

	(units_set_desired_flashlight_state (ai_actors marines_area4/marines_m) 1)

	(sleep 1)
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican area4_pelican_a_out)
	(set area4_covenant_reins true)
	
	(ai_migrate marines_area4/marines_m marines_area4/squad_m)
	(sleep 1)
	(ai_follow_target_players marines_area4/squad_m)

;	(sleep_until (and (< (ai_living_count covenant_area4/grunts_q) 2)
;				   (< (ai_strength covenant_area4/elites_q) .8)))
;	(ai_migrate marines_area4/squad_m marines_area4/squad_q)
	
;	(sleep_until (and (= (ai_living_count covenant_area4/elites_q) 0)
;				   (= (ai_living_count covenant_area4/grunts_q) 0)))
;	(ai_migrate marines_area4/squad_q marines_area4/squad_o)

;	(sleep_until (and (= (ai_living_count covenant_area4/elites_q) 0)
;				   (= (ai_living_count covenant_area4/grunts_q) 0)))
;	(ai_migrate marines_area4/squad_o marines_area4/squad_x)

;	(ai_follow_target_players marines_area4/squad_x)
	)

; GOOD
(script static void pelican_area4_b
	(set area4_covenant_reins false)
	(ai_conversation ext_marine_reins)
	(sleep 150)
;	(object_destroy insertion_pelican)
	(object_create_anew insertion_pelican)
	(objects_predict insertion_pelican)
	(unit_set_enterable_by_player insertion_pelican false)
	(ai_place	marines_area4/marines_b)
	(objects_predict (ai_actors marines_area4))
	(vehicle_load_magic insertion_pelican "rider" (ai_actors marines_area4/marines_b))
	(object_teleport insertion_pelican area4_pelican_b_flag)
	(recording_play_and_hover insertion_pelican area4_pelican_b_in)
	
	(sleep 1)
	(ai_braindead marines_area4/marines_b 1)
	(objects_predict insertion_pelican)
	(objects_predict (ai_actors marines_area4))

	(sleep (- (recording_time insertion_pelican) 60))
	(ai_braindead marines_area4 0)
	(sleep 60)
;	(vehicle_hover insertion_pelican 1)
	(vehicle_unload insertion_pelican "rider")
;	(ai_command_list marines_area4/marines_b forward_4s)
	(sleep (* 30 3.5))

	(units_set_desired_flashlight_state (ai_actors marines_area4/marines_b) 1)

	(sleep 1)
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican area4_pelican_b_out)
	(set area4_covenant_reins true)

	(ai_migrate marines_area4/marines_b marines_area4/squad_b)
	(sleep 1)
	(ai_follow_target_players marines_area4/squad_b)

;	(sleep_until (and (< (ai_living_count covenant_area4/grunts_b) 3)
;				   (< (ai_living_count covenant_area4/jackals_g) 2)))
;	(ai_migrate marines_area4/squad_b marines_area4/squad_u)
	
;	(sleep_until (and (< (ai_living_count covenant_area4/grunts_s) 2)
;				   (< (ai_living_count covenant_area4/jackals_u) 2)))
;	(ai_migrate marines_area4/squad_u marines_area4/squad_s)
	
;	(sleep_until (and (= (ai_living_count covenant_area4/grunts_s) 0)
;				   (= (ai_living_count covenant_area4/jackals_u) 0)))
;	(ai_migrate marines_area4/squad_s marines_area4/squad_o)
	
;	(sleep_until (and (= (ai_living_count covenant_area4/elites_q) 0)
;				   (= (ai_living_count covenant_area4/grunts_q) 0)))
;	(ai_migrate marines_area4/squad_o marines_area4/squad_x)

;	(sleep 90)
;	(sleep_until (and (= (ai_living_count covenant_area4/elites_reins) 0)
;				   (= (ai_living_count covenant_area4/grunts_reins) 0)))
;	(ai_migrate marines_area4/squad_x marines_area4/squad_y)

;	(ai_follow_target_players marines_area4/squad_y)
	)

; GOOD
;pelican_area5_a
(script static void pelican_area5_a
	(ai_conversation ext_marine_reins)
;	(sleep 150)
	(object_destroy insertion_pelican)
	(object_create_anew insertion_pelican)
	(unit_set_enterable_by_player insertion_pelican false)
	(sleep 1)
	(object_teleport insertion_pelican area5_pelican_a)

	(ai_place marines_area5/dropship_marines)
	(vehicle_load_magic insertion_pelican "rider" (ai_actors marines_area5/dropship_marines))

	(recording_play insertion_pelican area5_pelican_a_in)

	(sleep 1)
	(ai_braindead marines_area5/dropship_marines 1)
	(objects_predict insertion_pelican)
	(objects_predict (ai_actors marines_area5))

	(sleep (- (recording_time insertion_pelican) 60))
	(ai_braindead marines_area5 0)
	(sleep 60)
	(vehicle_hover insertion_pelican 1)
	(vehicle_unload insertion_pelican "rider")
	(sleep 120)

	(units_set_desired_flashlight_state (ai_actors marines_area5/dropship_marines) 1)

	(sleep 1)
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican v_rec_pel_2_out)
	(sleep_until (and (= (ai_living_count covenant_area5/grunts_drop) 0)
				   (= (ai_living_count covenant_area5/jackals_drop) 0)))
	(ai_migrate marines_area5/dropship_marines marines_area5/marines_i)
	(sleep 1)
	(ai_follow_target_players marines_area5)
	)

; GOOD
(script static void pelican_area5_b
	(ai_conversation lift_secured)
;	(object_destroy insertion_pelican)
	(object_create_anew insertion_pelican)
	(unit_set_enterable_by_player insertion_pelican false)
	
	(object_create ship_marine_1)
;	(object_create ship_marine_2)
	(object_create ship_marine_3)
	(object_create ship_marine_4)
	(object_create ship_marine_5)
;	(object_create ship_marine_6)
	(object_create ship_marine_7)
	
	(ai_attach ship_marine_1 marines_area5/gravity_pad_fodder)
	(ai_attach ship_marine_2 marines_area5/gravity_pad_fodder)
	(ai_attach ship_marine_3 marines_area5/gravity_pad_fodder)
	(ai_attach ship_marine_4 marines_area5/gravity_pad_fodder)
	(ai_attach ship_marine_5 marines_area5/gravity_pad_fodder)
	(ai_attach ship_marine_6 marines_area5/gravity_pad_fodder)
	(ai_attach ship_marine_7 marines_area5/gravity_pad_fodder)

	(vehicle_load_magic insertion_pelican P-riderRF ship_marine_6)
	(vehicle_load_magic insertion_pelican P-riderRM ship_marine_5)
	(vehicle_load_magic insertion_pelican P-riderRB ship_marine_4)
	(vehicle_load_magic insertion_pelican P-riderRB01 ship_marine_3)
	(vehicle_load_magic insertion_pelican P-riderLF ship_marine_7)
	(vehicle_load_magic insertion_pelican P-riderLM ship_marine_1)
	(vehicle_load_magic insertion_pelican P-riderLB ship_marine_2)

	(object_teleport insertion_pelican area5_gravity_fodder_flag)
	(recording_play insertion_pelican area5_pelican_b_in)

	(sleep 1)
	(objects_predict insertion_pelican)
	(objects_predict (ai_actors marines_area5))

	(sleep (recording_time insertion_pelican))
	(vehicle_hover insertion_pelican 1)

	(unit_exit_vehicle ship_marine_6)
	(ai_command_list_by_unit ship_marine_6 forward_4s)
	(sleep 10)
	(unit_exit_vehicle ship_marine_7)
	(ai_command_list_by_unit ship_marine_7 forward_4s)
	(sleep 10)
	(unit_exit_vehicle ship_marine_5)
	(ai_command_list_by_unit ship_marine_5 forward_4s)
	(sleep 10)
	(unit_exit_vehicle ship_marine_1)
	(ai_command_list_by_unit ship_marine_1 forward_4s)
	(sleep 10)
	(unit_exit_vehicle ship_marine_4)
	(ai_command_list_by_unit ship_marine_4 forward_4s)
	(sleep 10)
	(unit_exit_vehicle ship_marine_2)
	(ai_command_list_by_unit ship_marine_2 forward_4s)
	(sleep 10)
	(unit_exit_vehicle ship_marine_3)
	(ai_command_list_by_unit ship_marine_3 forward_4s)
	(sleep 60)
	
	(ai_command_list_by_unit ship_marine_6 marine_to_pad_6)
	(ai_command_list_by_unit ship_marine_7 marine_to_pad_7)
	(ai_command_list_by_unit ship_marine_5 marine_to_pad_5)
	(ai_command_list_by_unit ship_marine_1 marine_to_pad_1)
	(ai_command_list_by_unit ship_marine_2 marine_to_pad_2)
	(ai_command_list_by_unit ship_marine_3 marine_to_pad_3)
	(ai_command_list_by_unit ship_marine_4 marine_to_pad_4)

	(sleep 120)
	(ai_conversation_advance lift_secured)

	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican area5_pelican_b_out)
	)

; GOOD
(script dormant pelican_hangar_a
;	(object_destroy insertion_pelican)
	(object_create_anew insertion_pelican)
	(unit_set_enterable_by_player insertion_pelican false)
	(ai_place	hangar_marines/drop_a)
	(objects_predict (ai_actors hangar_marines/drop_a))
	(vehicle_load_magic insertion_pelican "rider" (ai_actors hangar_marines/drop_a))
	(object_teleport insertion_pelican v_flag_hangar_pelican_a)

	(sleep 1)
	(ai_braindead hangar_marines/drop_a 1)
	(objects_predict insertion_pelican)
	(objects_predict (ai_actors hangar_marines))

	(recording_play insertion_pelican v_rec_hangar_pelican_a_in)
	(sleep (- (recording_time insertion_pelican) 60))
	(ai_braindead hangar_marines 0)
	(sleep 60)
	(vehicle_hover insertion_pelican 1)
	(vehicle_unload insertion_pelican "rider")
	(sleep (* 30 3))
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican v_rec_hangar_pelican_a_out)
	
	(cond ((= hangar_location_index 1) (ai_migrate hangar_marines hangar_marines/mig_marines_a))
		 ((= hangar_location_index 2) (ai_migrate hangar_marines hangar_marines/mig_marines_b))
		 ((= hangar_location_index 3) (ai_migrate hangar_marines hangar_marines/mig_marines_d))
		 ((= hangar_location_index 4) (ai_migrate hangar_marines hangar_marines/mig_marines_e))
		 ((= hangar_location_index 5) (ai_migrate hangar_marines hangar_marines/mig_marines_f)))
	(sleep 300)	 
	(device_group_set hangar_door_b_power 1)
	)

; GOOD
(script static void pelican_hangar_b
;	(object_destroy insertion_pelican)
	(object_create_anew insertion_pelican)
	(unit_set_enterable_by_player insertion_pelican false)
	(ai_place	hangar_marines_halls/marines_reins)
	(objects_predict (ai_actors hangar_marines_halls/marines_reins))
	(vehicle_load_magic insertion_pelican "rider" (ai_actors hangar_marines_halls/marines_reins))
	(object_teleport insertion_pelican hangar_pelican_b)
	(recording_play insertion_pelican hangar_pelican_b_in)

	(sleep 1)
	(ai_braindead hangar_marines_halls/marines_reins 1)
	(objects_predict insertion_pelican)
	(objects_predict (ai_actors hangar_marines_halls))

	(sleep (- (recording_time insertion_pelican) 60))
	(ai_braindead hangar_marines_halls 0)
	(sleep 60)
	(vehicle_hover insertion_pelican 1)
	(vehicle_unload insertion_pelican "rider")
	(sleep (* 30 3))
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican hangar_pelican_b_out)
	(ai_migrate hangar_marines_halls/marines_reins hangar_marines_halls/squad_exit)
	)

; GOOD
;(script static void c_dropship_area1_a
;	(object_destroy c_dropship_a)
;	(object_create c_dropship_a)
;	(object_teleport c_dropship_a v_flag_pel_4)
;	(recording_play c_dropship_a v_rec_pel_4_in)
;	(sleep (recording_time c_dropship_a))
;	(vehicle_hover c_dropship_a 1)
;	(print "covenant pile out...")
;	(sleep 120)
;	(vehicle_hover c_dropship_a 0)
;	(recording_play_and_delete c_dropship_a v_rec_pel_4_out)
;	)

; GOOD
;(script static void c_dropship_area1_b
;	(object_destroy c_dropship_b)
;	(object_create c_dropship_b)
;	(object_teleport c_dropship_b v_flag_c_dropship_2)
;	(recording_play c_dropship_b v_rec_c_dropship_2_in)
;	(sleep (recording_time c_dropship_b))
;	(vehicle_hover c_dropship_b 1)
;	(print "aliens pile out...")
;	(sleep 120)
;	(vehicle_hover c_dropship_b 0)
;	(recording_play_and_delete c_dropship_b v_rec_c_dropship_2_out)
;	)

; GOOD
(script static void c_dropship_area4
	(sound_looping_set_alternate "levels\a50\music\a50_03" 1)
	(set area4_pelican_a false)
	(ai_conversation area5_cov_reins)
;	(object_destroy c_dropship_a)
	(object_create_anew c_dropship_a)
	(unit_close c_dropship_a)
	(ai_place	covenant_area4/elites_dropship)
	(ai_place	covenant_area4/grunts_dropship)
	(ai_place	covenant_area4/jackals_dropship)
	(vehicle_load_magic c_dropship_a "passenger" (ai_actors covenant_area4/elites_dropship))
	(vehicle_load_magic c_dropship_a "passenger" (ai_actors covenant_area4/grunts_dropship))
	(vehicle_load_magic c_dropship_a "passenger" (ai_actors covenant_area4/jackals_dropship))
	(object_teleport c_dropship_a truth_left_flag)
	(recording_play_and_hover c_dropship_a area4_c_dropship_in)

	(sleep 1)
	(ai_braindead_by_unit c_dropship_a 1)
	(ai_braindead covenant_area4/elites_dropship 1)
	(ai_braindead covenant_area4/grunts_dropship 1)
	(ai_braindead covenant_area4/jackals_dropship 1)
	(objects_predict c_dropship_a)
	(objects_predict (ai_actors covenant_area4))

	(sleep (- (recording_time c_dropship_a) 150))
	(ai_braindead_by_unit c_dropship_a 0)
	(sleep 120)
	(ai_braindead covenant_area4 0)

	(unit_open c_dropship_a)
	(sleep 30)
;	(vehicle_hover c_dropship_a 1)

	(begin_random 
		(begin (vehicle_unload c_dropship_a cd-passengerl01) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerl02) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerl03) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerl04) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerr01) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerr02) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerr03) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerr04) (sleep 5)))
		
	(sleep 90)
	(vehicle_hover c_dropship_a 0)
	(unit_close c_dropship_a)
	(recording_play_and_delete c_dropship_a area4_c_dropship_out)
	(set area4_pelican_a true)
	(sleep 120)
	(ai_braindead_by_unit c_dropship_a 1)
	)

; GOOD
(script static void c_dropship_area5
;	(object_destroy c_dropship_a)
	(object_create_anew c_dropship_a)
	(object_teleport c_dropship_a truth_left_flag_b)
	(unit_close c_dropship_a)
	(ai_place covenant_area5/grunts_drop)
	(ai_place covenant_area5/jackals_drop)
	(vehicle_load_magic c_dropship_a "passenger" (ai_actors covenant_area5/grunts_drop))
	(vehicle_load_magic c_dropship_a "passenger" (ai_actors covenant_area5/jackals_drop))
	
	(recording_play_and_hover c_dropship_a c_dropship_area5_in)

	(sleep 1)
	(ai_braindead_by_unit c_dropship_a 1)
	(ai_braindead covenant_area5/grunts_drop 1)
	(ai_braindead covenant_area5/jackals_drop 1)
	(objects_predict c_dropship_a)
	(objects_predict (ai_actors covenant_area5))

	(sleep (- (recording_time c_dropship_a) 400))
	(ai_conversation area5_cov_reins)
	(sleep 250)
	
	(ai_braindead_by_unit c_dropship_a 0)
	(sleep 120)
	(ai_braindead covenant_area5 0)
;	(vehicle_hover c_dropship_a 1)
	(unit_open c_dropship_a)
	(sleep 30)

	(begin_random 
		(begin (vehicle_unload c_dropship_a cd-passengerl01) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerl02) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerl03) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerl04) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerr01) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerr02) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerr03) (sleep 5))
		(begin (vehicle_unload c_dropship_a cd-passengerr04) (sleep 5)))
		
	(sleep 90)
	(vehicle_hover c_dropship_a 0)
	(unit_close c_dropship_a)
	(recording_play_and_delete c_dropship_a c_dropship_area5_out)
	)

; GOOD
(script static void hangar_dropship_b
;	(object_destroy hangar_dropship_b)
	(object_create_anew hangar_dropship_b)
;	(object_create hangar_wraith)
;	(unit_enter_vehicle hangar_wraith hangar_dropship_b "cargo_ghost02")
;	(object_teleport hangar_dropship_b hangar_dropship_b)
	(vehicle_hover hangar_dropship_b 1)
	(sound_class_set_gain "vehicle_engine" .25 150)

	
	(sleep 1)
	(objects_predict hangar_dropship_b)
	(ai_braindead_by_unit hangar_dropship_b 1)

	(sleep_until (> (device_get_position hangar_first_floor_entr) 0))
	(sound_class_set_gain "vehicle_engine" .5 150)
	(wake music_a50_07)
	(unit_close hangar_dropship_b)
	(sleep 90)
	(vehicle_hover hangar_dropship_b 0)
	(recording_play_and_delete hangar_dropship_b hangar_dropship_b_exit)
	)

