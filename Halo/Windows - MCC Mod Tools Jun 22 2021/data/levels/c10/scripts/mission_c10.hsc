;          C10 Mission Script

;========== Mission Outline ==========

;	== Intro Cutscene ==

;	Exterior 1
;		Human dropship crash site
;		Covenant dropship crash site (Covenant encampment)
;		Covenant fleeing past player as he approaches the elevator door
;		Flood milling around outside but not attacking player

;	Level 1
;		fleeing covenant...
;		marine finds helmit cinematic
;		flood everywhere

;	Level 2
;		flood everywhere
;		player must find proper lift to exit
;		

;	Exterior 2
;		dropship pilot tells player to go to the tower
;		monitor rescues player from the neverending waves of flood

;	== Outro Cutscene ==


;========== Stub Scripts ==========

(script stub void all_kill
	(print "merging cinema script failed")
	)
	
(script stub void all_create
	(print "merging cinema script failed")
	)
	
(script stub void emotions
	(print "merging cinema script failed")
	)
	
(script stub void setup
	(print "merging cinema script failed")
	)
	
(script stub void intro
	(print "merging cinema script failed")
	)
	
(script stub void pelican
	(print "merging cinema script failed")
	)
	
(script stub void door_setup
	(print "merging cinema script failed")
	)
	
(script stub void door
	(print "merging cinema script failed")
	)
	
(script stub void check_setup
	(print "merging cinema script failed")
	)
	
(script stub void check
	(print "merging cinema script failed")
	)
	
(script stub void lab_setup_1
	(print "merging cinema script failed")
	)
	
(script stub void lab_setup_2
	(print "merging cinema script failed")
	)
	
(script stub void lab_setup_3
	(print "merging cinema script failed")
	)
	
(script stub void lab
	(print "merging cinema script failed")
	)
	
(script stub void flood
	(print "merging cinema script failed")
	)
	
(script stub void mendoza_unlock
	(print "merging cinema script failed")
	)

(script stub void mendoza_flee
	(print "merging cinema script failed")
	)

(script stub void final
	(print "merging cinema script failed")
	)
	
(script stub void x50
	(print "merging cinema script failed")
	)
	
(script stub void destroy_door_a
	(print "merging cinema script failed")
	)
	
(script stub void cutscene_extraction
	(print "merging cinema script failed")
	)

;========== Global Variables ==========

(global boolean debug false)

(global boolean player_view_helmet false)

(global long crazy_marine_delay (* 30 2))
(global short continuous_save_counter 0)

(global short swamp_a_limiter 10)
(global short swamp_a_counter 0)

(global short int_a_limiter 10)
(global short int_a_counter 0)

(global boolean control_door_a_wave true)
(global boolean control_door_b_wave true)
(global boolean control_door_c_wave true)
(global boolean control_door_d_wave true)
(global boolean control_door_e_wave true)
(global boolean control_door_f_wave true)
(global boolean control_door_g_wave true)
(global boolean control_door_h_wave true)

(global long control_delay 60)
(global short control_limit 4)

(global short int_b_limiter 10)
(global short int_b_counter 0)

(global short swamp_b_player_locator 0)
(global long swamp_b_emitter_delay (* 30 25))
(global long sentinel_migration_delay (* 30 10))

;if the total # of active flood is less than this # then more will spawn
(global short swamp_b_limiter 0)
(global short swamp_b_counter 0)

(global short swamp_b_infection_limiter 0)

;allows the swamp b ledge emitters to continue
(global boolean swamp_b_ledge_a true)
(global boolean swamp_b_ledge_b true)
(global boolean swamp_b_ledge_c true)
(global boolean swamp_b_ledge_d true)
(global boolean swamp_b_ledge_e true)
(global boolean swamp_b_ledge_f true)

(global boolean swamp_b_flood_wave true)

;counts the # of squads spawned per ledge encounter
(global short swamp_b_ledge_a_counter 0)
(global short swamp_b_ledge_b_counter 0)
(global short swamp_b_ledge_c_counter 0)
(global short swamp_b_ledge_d_counter 0)
(global short swamp_b_ledge_e_counter 0)
(global short swamp_b_ledge_f_counter 0)

(global short swamp_b_flood_counter 0)

;limits the # of squads spawned per wave
;range 1-5
(global short swamp_b_ledge_a_limit 2)
(global short swamp_b_ledge_b_limit 2)
(global short swamp_b_ledge_c_limit 2)
(global short swamp_b_ledge_d_limit 2)
(global short swamp_b_ledge_e_limit 2)
(global short swamp_b_ledge_f_limit 2)

(global short swamp_b_flood_limiter 3)

(global boolean test_flee_halln false)


;========== Effect Scripts ==========

;(effect_new effects\explosions\large flag)
; some effect have direction and it'll use the direction of the flag
; will also cause damage

(script continuous flicker_bridge
	(sleep_until (= (structure_bsp_index) 3) 1)
	(device_set_position bridge_c 0)
	(sleep (random_range 15 75))
	(device_set_position bridge_c (real_random_range .5 1))
	(sleep (random_range 15 75))
	)

;*
(script continuous lift_a_control
	(sleep_until (= (device_get_position lift_a) 0) 1)
	(device_one_sided_set lift_a_cont_a 1)

	(sleep_until (!= (device_get_position lift_a) 0) 1)
	(device_one_sided_set lift_a_cont_a 0)
	)

(script continuous lift_a_control
	(sleep_until (= (device_get_position lift_a) 0) 1)
	(device_one_sided_set lift_b_cont_a 1)

	(sleep_until (!= (device_get_position lift_a) 0) 1)
	(device_one_sided_set lift_b_cont_a 0)
	)
*;

(global short tracker_bsp_index 0)
(global boolean tracker_x50 false)
(script continuous bsp_biped_recycler
	(sleep_until (!= (structure_bsp_index) tracker_bsp_index) 1)
	(cond (tracker_x50 (sleep 1))
		 ((= (structure_bsp_index) 0) (begin (if (!= tracker_bsp_index 1) (ai_erase_all)) (garbage_collect_now) (object_destroy_containing biped) (object_create_anew_containing bsp0_biped) (object_destroy_containing device) (object_create_anew_containing bsp0_device) (set tracker_bsp_index 0)))
		 ((= (structure_bsp_index) 1) (begin (garbage_collect_now) (object_destroy_containing biped) (object_create_anew_containing bsp1_biped) (object_destroy_containing device) (object_create_anew_containing bsp1_device) (set tracker_bsp_index 1)))
		 ((= (structure_bsp_index) 2) (begin (if (!= tracker_bsp_index 1) (ai_erase_all)) (garbage_collect_now) (object_destroy_containing biped) (object_create_anew_containing bsp2_biped) (object_destroy_containing device) (object_create_anew_containing bsp2_device) (set tracker_bsp_index 2)))
		 ((= (structure_bsp_index) 3) (begin (if (!= tracker_bsp_index 4) (ai_erase_all)) (garbage_collect_now) (object_destroy_containing biped) (object_create_anew_containing bsp3_biped) (object_destroy_containing device) (object_create_anew_containing bsp3_device) (set tracker_bsp_index 3)))
		 ((= (structure_bsp_index) 4) (begin (if (!= tracker_bsp_index 3) (ai_erase_all)) (garbage_collect_now) (object_destroy_containing biped) (object_create_anew_containing bsp4_biped) (object_destroy_containing device) (object_create_anew_containing bsp4_device) (set tracker_bsp_index 4)))
		 ((= (structure_bsp_index) 5) (begin (ai_erase_all) (garbage_collect_now) (object_destroy_containing biped) (object_create_anew_containing bsp5_biped) (object_destroy_containing device) (object_create_anew_containing bsp5_device) (set tracker_bsp_index 5)))
		 (true (object_destroy_containing biped))
		 )
	(sleep 15)
	)

;========== Music Scripts ==========

(global boolean play_music_c10_01 false)
(global boolean play_music_c10_01_alt false)
(global boolean play_music_c10_02 false)
(global boolean play_music_c10_02_alt false)
(global boolean play_music_c10_03 false)
(global boolean play_music_c10_03_alt false)
(global boolean play_music_c10_04 false)
(global boolean play_music_c10_04_alt false)
(global boolean play_music_c10_05 false)
(global boolean play_music_c10_05_alt false)
(global boolean play_music_c10_06 false)
(global boolean play_music_c10_06_alt false)
(global boolean play_music_c10_07 false)
(global boolean play_music_c10_07_alt false)

(script startup music_c10_01
	(sleep_until play_music_c10_01)
	(print "levels\c10\music\c10_01")
	(sound_looping_start "levels\c10\music\c10_01" none 1)
	(sleep_until (or (not play_music_c10_01) play_music_c10_01_alt) 1 (/ global_delay_music 2))
	(if play_music_c10_01_alt (sound_looping_set_alternate "levels\c10\music\c10_01" 1))
	(sleep_until (not play_music_c10_01) 1 (/ global_delay_music 2))
	(sound_looping_stop "levels\c10\music\c10_01")
	)

(script startup music_c10_02
	(sleep_until play_music_c10_02)
	(print "levels\c10\music\c10_02")
	(sound_looping_start "levels\c10\music\c10_02" none 1)
	(sleep_until (or (not play_music_c10_02) play_music_c10_02_alt) 1 (/ global_delay_music 2))
	(if play_music_c10_02_alt (sound_looping_set_alternate "levels\c10\music\c10_02" 1))
	(sleep_until (not play_music_c10_02) 1 (/ global_delay_music 2))
	(sound_looping_stop "levels\c10\music\c10_02")
	)

(script startup music_c10_03
	(sleep_until play_music_c10_03)
	(print "levels\c10\music\c10_03")
	(sound_looping_start "levels\c10\music\c10_03" none 1)
	(sleep_until (or (not play_music_c10_03) play_music_c10_03_alt) 1 (/ global_delay_music 2))
	(if play_music_c10_03_alt (sound_looping_set_alternate "levels\c10\music\c10_03" 1))
	(sleep_until (not play_music_c10_03) 1 (/ global_delay_music 2))
	(sound_looping_stop "levels\c10\music\c10_03")
	)

(script startup music_c10_04
	(sleep_until play_music_c10_04)
	(print "levels\c10\music\c10_04")
	(sound_looping_start "levels\c10\music\c10_04" none 1)
	(sleep_until (or (not play_music_c10_04) play_music_c10_04_alt) 1 (/ global_delay_music 2))
	(if play_music_c10_04_alt (sound_looping_set_alternate "levels\c10\music\c10_04" 1))
	(sleep_until (not play_music_c10_04) 1 (/ global_delay_music 2))
	(sound_looping_stop "levels\c10\music\c10_04")
	)

(script startup music_c10_05
	(sleep_until play_music_c10_05)
	(print "levels\c10\music\c10_05")
	(sound_looping_start "levels\c10\music\c10_05" none 1)
	(sleep_until (or (not play_music_c10_05) play_music_c10_05_alt) 1 (/ global_delay_music 2))
	(if play_music_c10_05_alt (sound_looping_set_alternate "levels\c10\music\c10_05" 1))
	(sleep_until (not play_music_c10_05) 1 (/ global_delay_music 2))
	(sound_looping_stop "levels\c10\music\c10_05")
	)

(script startup music_c10_06
	(sleep_until play_music_c10_06)
	(print "levels\c10\music\c10_06")
	(sound_looping_start "levels\c10\music\c10_06" none 1)
	(sleep_until (or (not play_music_c10_06) play_music_c10_06_alt) 1 (/ global_delay_music 2))
	(if play_music_c10_06_alt (sound_looping_set_alternate "levels\c10\music\c10_06" 1))
	(sleep_until (not play_music_c10_06) 1 (/ global_delay_music 2))
	(sound_looping_stop "levels\c10\music\c10_06")
	)

(script startup music_c10_07
	(sleep_until play_music_c10_07)
	(print "levels\c10\music\c10_07")
	(sound_looping_start "levels\c10\music\c10_07" none 1)
	(sleep_until (or (not play_music_c10_07) play_music_c10_07_alt) 1 (/ global_delay_music 2))
	(if play_music_c10_07_alt (sound_looping_set_alternate "levels\c10\music\c10_07" 1))
	(sleep_until (not play_music_c10_07) 1 (/ global_delay_music 2))
	(sound_looping_stop "levels\c10\music\c10_07")
	)
;========== Objective,Help and Title Screen Scripts ==========

(script dormant obj_find
	(show_hud_help_text 1)
	(hud_set_help_text obj_find)
	(hud_set_objective_text obj_find)
	(sleep 150)
	(show_hud_help_text 0)
	(game_save_no_timeout)
	)

(script dormant obj_escape
	(show_hud_help_text 1)
	(hud_set_help_text obj_escape)
	(hud_set_objective_text obj_escape)
	(sleep 150)
	(show_hud_help_text 0)
	(game_save_no_timeout)
	)

(script dormant obj_tower
	(show_hud_help_text 1)
	(hud_set_help_text obj_tower)
	(hud_set_objective_text obj_tower)
	(sleep 150)
	(show_hud_help_text 0)
	(game_save_no_timeout)
	)

(script dormant chapter_lost
	(sleep_until (game_safe_to_save))
	(show_hud false)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title chapter_lost)
	(sleep 150)
	(cinematic_show_letterbox false)
	(show_hud true)
	(game_save_no_timeout)
	)

(script dormant chapter_flood
	(show_hud false)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title chapter_flood)
	(sleep 150)
	(cinematic_stop)
	(show_hud true)
	(game_save_no_timeout)
	)

(script dormant chapter_friends
	(show_hud false)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title chapter_friends)
;	(sleep 150)
;	(cinematic_show_letterbox false)
;	(show_hud true)
	)

;========== Recording Scripts ==========

(script static void clean
	(ai_erase_all)
	(ai_reconnect)
	(garbage_collect_now)
	)
;*
(script static void killguns
	(object_destroy insertion_ar_1)
	(object_destroy insertion_ar_2)
	(object_destroy insertion_ar_3)
	(object_destroy ledge_ar_1)
	(object_destroy ledge_ar_2)
	(object_destroy ledge_ar_3)
	(object_destroy entrance_ar_1)
	(object_destroy entrance_ar_2)
	(object_destroy entrance_ar_3)
	(object_destroy entrance_ar_4)
	(object_destroy entrance_ar_5)
	(object_destroy int_a_bay_a_ar_1)
	(object_destroy int_a_bay_a_ar_2)
	)
	
(script static void guns
	(object_create insertion_ar_1)
	(object_create insertion_ar_2)
	(object_create insertion_ar_3)
	(object_create ledge_ar_1)
	(object_create ledge_ar_2)
	(object_create ledge_ar_3)
	(object_create entrance_ar_1)
	(object_create entrance_ar_2)
	(object_create entrance_ar_3)
	(object_create entrance_ar_4)
	(object_create entrance_ar_5)
	(object_create int_a_bay_a_ar_1)
	(object_create int_a_bay_a_ar_2)
	)
*;
(script dormant insertion

;	marty

	(fade_out 0 0 0 0)
	(cinematic_start)
	(show_hud 0)
	(camera_control on)
	
	(object_destroy insertion_pelican)
	(object_create insertion_pelican)
	(object_teleport insertion_pelican insertion_flag)
	(sleep 1)

	(unit_enter_vehicle (player0) insertion_pelican "P-riderLF")
	(unit_enter_vehicle (player1) insertion_pelican "P-riderRF")
	(unit_set_enterable_by_player insertion_pelican false)

;	(object_set_facing (player0) initial_facing)
;	(object_set_facing (player1) initial_facing)
	
	(objects_predict insertion_pelican)
;	(objects_predict (ai_actors swamp_a_marines))

	(ai_place swamp_a_covenant/grunts_insertion)
	(ai_place swamp_a_covenant/jackals_insertion)
	(objects_predict (ai_actors swamp_a_covenant))
	
;	(ai_place swamp_a_marines/insertion)
;	(ai_disregard (ai_actors swamp_a_marines/insertion) true)
	(ai_disregard (players) true)

	(camera_set insertion_1 0)

	(sleep 5)

	(recording_play_and_hover insertion_pelican insertion_pelican_in)
	
	(sound_looping_start sound\sinomatixx_music\c10_insertion_music none 1)
	
	(fade_in 0 0 0 60)
	(camera_set insertion_2 400)
	(sleep 200)
;	(ai_follow_target_ai swamp_a_marines/insertion swamp_a_covenant/grunts_insertion)
	(camera_set insertion_3 400)
	(sleep 200)
	
	(cinematic_set_title chapter_lost)
;	(object_create insertion_ar_1)
;	(object_create insertion_ar_2)
;	(object_create insertion_ar_3)
	(sleep 60)
	(ai_conversation insertion)
	(sleep 150)
	(fade_out 1 1 1 15)
	(sleep 15)
	(camera_control off)
	(ai_erase swamp_a_marines)
	(ai_erase swamp_a_covenant)
	(sleep 15)
;	(object_destroy insertion_ar_1)
;	(object_destroy insertion_ar_2)
;	(object_destroy insertion_ar_3)
	(fade_in 1 1 1 15)
	(sleep 15)
	(cinematic_stop)
	(show_hud 1)

	(sleep (recording_time insertion_pelican))
;	(vehicle_hover insertion_pelican 1)
	(unit_exit_vehicle (player0))
	(unit_exit_vehicle (player1))
	(ai_disregard (players) false)
	(game_save_totally_unsafe)
   (mcc_mission_segment "01_start")
	(sleep_until (> (ai_conversation_status insertion) 4) 12 (* 30 12))
	(sleep 30)
	(object_create pelican_radio)
	(vehicle_hover insertion_pelican 0)
	(recording_play_and_delete insertion_pelican insertion_pelican_out)
	)

;========== save Game Scripts ==========

;(script continuous general_save
;	(sleep -1)
;	(game_save_no_timeout)
;	)

(script continuous swamp_b_save
	(sleep_until (volume_test_objects swamp_b_trigger_b (players)))
	(game_save))
	
;- tyson's shiznat -------------------------------------------------------------

; Incidents (bigfoot sightings!)
(script dormant inc_log
	(sleep_until (volume_test_objects inc_log (players)))
	(ai_place inc_swamp/log_incident)
	(unit_impervious (ai_actors inc_swamp/log_incident) true)
	(object_cannot_take_damage (ai_actors inc_swamp/log_incident))
)

(script dormant inc7
	(sleep_until (volume_test_objects inc5 (players)))
	(ai_place inc_swamp/inc7)
	(unit_impervious (ai_actors inc_swamp/inc7) true)
	(object_cannot_take_damage (ai_actors inc_swamp/inc7))
)

(script dormant inc6
	(sleep_until (volume_test_objects inc6 (players)))
	(ai_place inc_swamp/inc6)
	(unit_impervious (ai_actors inc_swamp/inc6) true)
	(object_cannot_take_damage (ai_actors inc_swamp/inc6))
)

(script dormant inc5
	(sleep_until (or (volume_test_objects inc5 (players)) (volume_test_objects inc5b (players))))
	(ai_place inc_swamp/inc5)
	(unit_impervious (ai_actors inc_swamp/inc5) true)
	(object_cannot_take_damage (ai_actors inc_swamp/inc5))
)

(script dormant inc4
	(sleep_until (volume_test_objects inc4 (players)))
	(ai_place inc_swamp/inc4)
	(unit_impervious (ai_actors inc_swamp/inc4) true)
	(object_cannot_take_damage (ai_actors inc_swamp/inc4))
)

(script dormant inc3
	(sleep_until (volume_test_objects inc3 (players)))
	(ai_place inc_swamp/inc3)
	(unit_impervious (ai_actors inc_swamp/inc3) true)
	(object_cannot_take_damage (ai_actors inc_swamp/inc3))
)

; Swamp Encounter 2, occurs near the entrance
(script dormant enc_swamp2
	(sleep_until (volume_test_objects enc_swamp2 (players)))
	(game_save_no_timeout)
	(set play_music_c10_01 false)
	; Place the ai
	(ai_place enc_swamp2/squadA)
	
	; Wait a moment, then place the rifles
	(sleep 15)
	(object_create entrance_asr_2) (sleep 15)
	(object_create entrance_asr_4) (sleep 20)
	(object_create entrance_asr_5)
	
	; Wait another moment, blow up the turret
	(sleep 45)
	(effect_new "weapons\frag grenade\effects\explosion" enc_swamp2_turret)
	(effect_new "effects\explosions\large explosion no objects" enc_swamp2_turret)
	
	; Place the second group of AI
	(ai_place enc_swamp2/squadC)
	(ai_place enc_swamp2/lift_jackal)

	; Destroy rifles
	(sleep 45)
	(object_destroy entrance_asr_2) (sleep 15)
	(object_destroy entrance_asr_4) (sleep 10)
	(object_destroy entrance_asr_5)
	)


; Swamp Encounter 1, occurs near the dropship
(script dormant enc_swamp1
	(sleep_until (or (volume_test_objects pelican_radio (players))
				  (volume_test_objects enc_swamp1 (players))) 1)
	(game_save_no_timeout)
	(set play_music_c10_01 true)
	(ai_place enc_swamp1/squadA)
	(objects_predict (ai_actors enc_swamp1))
	(ai_magically_see_players enc_swamp1)

;	(sleep_until 
;		(or
;			(< (ai_strength enc_swamp1) 0.97)
;			(volume_test_objects enc_swamp1b (players))
;		) 1)
	
	; Override their command list
;	(ai_command_list enc_swamp1 general_null)
	
	; Blow up the hapless rocketeers
	(effect_new "weapons\frag grenade\effects\explosion" enc_swamp1_rocket_booster) (sleep 15)
	(ai_place enc_swamp1/rocketeers)
	(effect_new "weapons\frag grenade\effects\explosion" enc_swamp1_rocket_booster)
;	(effect_new "effects\explosions\medium explosion no objects" enc_swamp1_rocket_booster) (sleep 15)
	(effect_new "effects\explosions\medium explosion no objects" enc_swamp1_rocket_booster2)
	(effect_new "effects\explosions\medium explosion no objects" enc_swamp1_rocket_booster3)

	; Wait a second... then run!
	(sleep_until (volume_test_objects enc_swamp1 (players)) 1)
	(game_save_no_timeout)
	(ai_maneuver enc_swamp1/squadA)
	(ai_place enc_swamp1/tree_jackal)
	; Create the guns, staggering them a bit... sleep a bit, then start removing
;	(object_create enc_swamp1_ar1) (sleep 35)
;	(object_create enc_swamp1_ar2) (sleep 20)
;	(object_create enc_swamp1_ar3)
;	(sleep 110)
	
	; Remove rifles
;	(object_destroy enc_swamp1_ar2) (sleep 35)
;	(object_destroy enc_swamp1_ar1) (sleep 20)
;	(object_destroy enc_swamp1_ar3) (sleep 35)
;	(sleep 30)
;	(object_create enc_swamp1_ar2) (sleep 65)
;	(object_destroy enc_swamp1_ar2)
	)

; Cleap up my scripts
(script static void kill_tysons_crap
	(sleep -1 enc_swamp1)
	(sleep -1 enc_swamp2)
	(sleep -1 inc_log)
	(sleep -1 inc3)
	(sleep -1 inc4)
	(sleep -1 inc5)
	(sleep -1 inc6)
	(sleep -1 inc7)
)


;- end of tyson's stuff --------------------------------------------------------

;========== Swamp A Encounter Scripts ==========

;(script static void enc_fleeing_grunts_a
;	(ai_place swamp_a_covenant/fleeing_front_a))
	
;========== Swamp A Initialization Scripts ==========

;(script dormant ini_dropship_check
;	(sleep_until (volume_test_objects crashed_dropship_trigger (players)))
;	(deactivate_team_nav_point_object player crashed_dropship)
;	)
;(script dormant ini_pelican_radio
;	(sleep_until (volume_test_objects pelican_radio (players)))
;	(object_create pelican_radio)
;	)

(script dormant ini_see_flood_a
	(sleep_until (objects_can_see_flag (players) swamp_a_flood_a 30))
	(ai_place swamp_a_flood/flood_a)
	(object_cannot_take_damage (ai_actors swamp_a_flood))
	(unit_impervious (ai_actors swamp_a_flood) true))

(script dormant ini_see_flood_b
	(sleep_until (and (volume_test_objects_all swamp_a_flood_trigger_a (players))
				   (objects_can_see_flag (players) swamp_a_flood_b 20)))
	(ai_place swamp_a_flood/flood_b)
	(object_cannot_take_damage (ai_actors swamp_a_flood))
	(unit_impervious (ai_actors swamp_a_flood) true))

(script dormant ini_see_flood_c
	(sleep_until (and (volume_test_objects_all swamp_a_flood_trigger_a (players))
				   (objects_can_see_flag (players) swamp_a_flood_c 20)))
	(ai_place swamp_a_flood/flood_c)
	(object_cannot_take_damage (ai_actors swamp_a_flood))
	(unit_impervious (ai_actors swamp_a_flood) true))

(script dormant ini_see_flood_d
	(sleep_until (objects_can_see_flag (players) swamp_a_flood_d 30))
	(ai_place swamp_a_flood/flood_d)
	(object_cannot_take_damage (ai_actors swamp_a_flood))
	(unit_impervious (ai_actors swamp_a_flood) true))

;========== Interior A Encounter Scripts ==========

	
(script dormant enc_int_a_lift_a_cov
	(ai_place int_a_covenant/grunts_lift_left)
	(ai_place int_a_covenant/grunts_lift_right)
	)

(script dormant enc_int_a_bay_a_cov
	(ai_place int_a_covenant/grunts_bay_a_floor)
	(ai_place int_a_covenant/jackals_bay_a_floor)
	(ai_place int_a_covenant/grunts_bay_a_top)
	(ai_place int_a_covenant/jackals_bay_a_top)
	)

(script dormant enc_int_a_lab_a_cov
	(ai_place int_a_covenant/grunts_lab_a)
	(ai_place int_a_covenant/jackals_lab_a)
	(ai_place int_a_covenant/grunts_lab_a_bot)
	(ai_place int_a_covenant/jackals_lab_a_bot)
	)

(script dormant enc_int_a_ante_a_cov
	(ai_place int_a_covenant/ante_a)
	)

(script dormant enc_int_a_bay_a_flood
;	(ai_place int_a_flood/bay_a_top_1)
;	(ai_place int_a_flood/bay_a_top_2)
	(ai_place int_a_flood/bay_a_bottom_1)
	(ai_place int_a_flood/bay_a_bottom_2)
	(ai_place int_a_infection/bay_a))
	
(script dormant enc_int_a_lab_a_flood
;	(ai_place int_a_flood/lab_a_top)
	(ai_place int_a_flood/lab_a_bottom)
	(ai_place int_a_infection/lab_a))

(script dormant enc_int_a_ante_a_flood
	(ai_place int_a_flood/ante_a)
	(ai_place int_a_infection/ante_a))

(script dormant enc_int_a_lift_a_flood
	(ai_place int_a_flood/lift_a)
	(ai_place int_a_infection/lift_a))
	
(script dormant enc_int_a_tinylab_c_flood
	(ai_place int_a_flood/tinylab_c)
	(ai_place int_a_infection/tinylab_c))

(script dormant enc_int_a_tinylab_d_flood
	(ai_place int_a_flood/tinylab_d)
	(ai_place int_a_infection/tinylab_d))

(script dormant enc_int_a_lift_b_flood
	(ai_place int_a_flood/lift_b)
	(ai_place int_a_infection/lift_b))

;========== Interior A Initialization Scripts ==========

(script dormant ini_int_a_lift_a_cov
	(wake enc_int_a_lift_a_cov)
;	(object_create lift_a_ar_1)
;	(object_create lift_a_ar_2)
;	(object_create lift_a_ar_3)
;	(object_create lift_a_ar_4)
;	(sleep (* 30 2))
;	(object_destroy lift_a_ar_1)
;	(object_destroy lift_a_ar_2)
;	(object_destroy lift_a_ar_3)
;	(object_destroy lift_a_ar_4)
	)

(script dormant ini_int_a_bay_a_cov
	(wake enc_int_a_bay_a_cov)
;	(object_create int_a_bay_a_ar_1)
;	(object_create int_a_bay_a_ar_2)
	(sleep (* 30 4))
;	(object_destroy int_a_bay_a_ar_1)
;	(object_destroy int_a_bay_a_ar_2)
	)

(script dormant ini_int_a_lift_a_destroy
	(object_destroy lift_a)
;	(object_destroy lift_a_door)
	(object_destroy lift_a_cont_b)
;	(object_create lift_a_door_bashed)
	(object_create lift_a_falling)
	(object_create lift_a_falling_control)

	(sleep_until (!= (device_get_position lift_a_falling) 0))
	(set play_music_c10_04 true)

	(sleep_until (= (device_get_position lift_a_falling) 1))
	(sleep (* 15 30))
	(set play_music_c10_04 false)
	)

(script dormant ini_int_a_hall_b
	(sleep_until (volume_test_objects hall_b_bottom_trigger (players)))
	(wake enc_int_a_tinylab_c_flood)
	(wake enc_int_a_tinylab_d_flood))

(script dormant ini_int_a_lift_a
	(sleep_until (volume_test_objects lift_a_flood_trigger (players)))
	(wake enc_int_a_lift_a_flood)
	(sleep_until (= (ai_living_count int_a_flood/lift_a) 0))
	(game_save_no_timeout)
	)

;========== Interior B Encounter Scripts ==========

(script dormant enc_infection_ini
	(ai_place int_b_infection/control_ini))

(script dormant enc_control_a
	(device_set_position control_door_bashed_a 1)
	)
	
(script dormant enc_int_b_bay_b_flood
;	(ai_place int_b_flood/bay_b_top_1)
;	(ai_place int_b_flood/bay_b_top_2)
	(ai_place int_b_cov)
;	(ai_place int_b_inf)
	(ai_place int_b_flood/bay_b_bottom_1)
	(ai_place int_b_flood/bay_b_bottom_2)
;	(ai_place int_b_infection_2/bay_b)
	)

(script dormant enc_int_b_lab_b_flood
;	(ai_place int_b_flood/lab_b_top)
	(ai_place int_b_flood/lab_b_bottom)
	(ai_place int_b_infection_2/lab_b))

(script dormant enc_int_b_ante_b_flood
	(ai_place int_b_flood/ante_b)
	(ai_place int_b_infection_2/ante_b))

(script dormant enc_int_b_tinylab_g_flood
	(ai_place int_b_flood/tinylab_g)
	(ai_place int_b_infection_2/tinylab_g))

(script dormant enc_int_b_tinylab_h_flood
	(ai_place int_b_flood/tinylab_h)
	(ai_place int_b_infection_2/tinylab_h))

(script dormant ini_int_a_lift_b
	(sleep_until (volume_test_objects lift_b_flood_trigger (players)))
	(wake enc_int_a_lift_b_flood)
	(sleep_until (= (ai_living_count int_a_flood/lift_b) 0))
	(game_save_no_timeout)
	)

;========== Interior B Initialization Scripts ==========

(script static void ini_x50_preclean
	(ai_erase int_b_covenant/grunts_lab_b_bot)
	(ai_erase int_b_covenant/grunts_lab_b_top)
	(ai_erase int_b_covenant/jackals_lab_b_bot)
	(ai_erase int_b_covenant/jackals_lab_b_top)
	(object_destroy crashed_dropship)
	(object_destroy pelican_radio)
	(object_destroy x50_rock)
;*
	(object_destroy turret_1)
	(object_destroy turret_2)
;	(object_destroy marine_3)
	(object_destroy marine_4)
	(object_destroy marine_5)
	(object_destroy marine_6)
	(object_destroy marine_7)
	(object_destroy marine_8)
	(object_destroy marine_9)
	(object_destroy marine_10)
	(object_destroy marine_15)
	(object_destroy jackal_1)
	(object_destroy jackal_2)
	(object_destroy jackal_3)
	(object_destroy jackal_4)
	(object_destroy jackal_5)
	(object_destroy jackal_6)
	(object_destroy grunt_1)
	(object_destroy grunt_2)
	(object_destroy grunt_3)
	(object_destroy grunt_4)
	(object_destroy grunt_5)
	(object_destroy grunt_6)
	(object_destroy grunt_7)
	(object_destroy grunt_8)
	(object_destroy grunt_9)
;	(killguns)
*;
	)

(script dormant ini_lifta_replacement
	(object_destroy post_lifta_door_1)
	(object_create post_lifta_bashed_1)
	(device_set_position_immediate post_lifta_bashed_1 .4)

	(object_destroy post_lifta_door_2)
	(object_create post_lifta_bashed_2)
	(device_set_position_immediate post_lifta_bashed_2 .6)

;	(object_destroy post_lifta_door_3)
;	(object_create post_lifta_bashed_3)
;	(device_set_position_immediate post_lifta_bashed_3 .6)
	)

;*
(script dormant ini_door_replacement
;	(object_destroy control_door_a)
	(object_create control_door_bashed_a)
;	(object_destroy control_door_b)
	(object_create control_door_bashed_b)
;	(object_destroy control_door_c)
	(object_create control_door_bashed_c)				  
;	(object_destroy control_door_d)
	(object_create control_door_bashed_d)
;	(object_destroy control_door_d1)
;	(object_create control_door_bashed_d1)
;	(object_destroy control_door_d2)
;	(object_create control_door_bashed_d2)
;	(object_destroy control_door_d3)
;	(object_create control_door_bashed_d3)
;	(object_destroy control_door_e)
	(object_create control_door_bashed_e)
;	(object_destroy control_door_f)
;	(object_create control_door_bashed_f)
;	(object_destroy control_door_g)
	(object_create control_door_bashed_g)
;	(object_destroy control_door_h)
	(object_create control_door_bashed_h))
*;

(script dormant ini_post_helmet_replace
	(object_create post_helmet_ar1)
	(object_create post_helmet_ar2)
	(object_create post_helmet_ar3)
	(object_create post_helmet_ar4)
	(object_create post_helmet_pl1)

	(object_destroy post_helmet_door_1)
	(object_create post_helmet_bashed_1)
	(device_set_position_immediate post_helmet_bashed_1 .5)

	(object_destroy post_helmet_door_2)
	(object_create post_helmet_bashed_2)
	(device_set_position_immediate post_helmet_bashed_2 .6)

	(object_destroy post_helmet_door_3)
	(object_create post_helmet_bashed_3)
	(if (or (game_is_cooperative) (= (game_difficulty_get) impossible)) (device_set_position_immediate post_helmet_bashed_3 .4) (device_set_position_immediate post_helmet_bashed_3 1))

	(device_set_power post_lifta_door_1 1)
	(object_destroy post_lifta_light_1a)
	(object_destroy post_lifta_light_1b)
	(object_create post_lifta_light_1c)
	(object_create post_lifta_light_1d)

	(device_set_power post_lifta_door_2 1)
	(object_destroy post_lifta_light_2a)
	(object_destroy post_lifta_light_2b)
	(object_create post_lifta_light_2c)
	(object_create post_lifta_light_2d)

	(device_set_power post_helmet_door_4 1)
	(object_destroy post_helmet_light_4a)
	(object_destroy post_helmet_light_4b)
	(object_create post_helmet_light_4c)
	(object_create post_helmet_light_4d)

	(device_set_power post_helmet_door_5 1)
	(object_destroy post_helmet_light_5a)
	(object_destroy post_helmet_light_5b)
	(object_create post_helmet_light_5c)
	(object_create post_helmet_light_5d)
	)

;*
(script continuous ini_control_flood_wave
	(sleep 30)
	(if (and control_door_b_wave
;		    (objects_can_see_object (players) control_door_bashed_b 25)
		    (< (ai_living_count int_b_flood) control_limit))
	    (begin (ai_place int_b_flood/control_b)
			 (ai_place int_b_infection/control_b)
			 (sleep control_delay)
			 (set control_door_b_wave false)))
	(if (and control_door_c_wave
;		    (objects_can_see_object (players) control_door_bashed_c 25)
		    (< (ai_living_count int_b_flood) control_limit))
	    (begin (ai_place int_b_flood/control_c)
			 (ai_place int_b_infection/control_c)
			 (sleep control_delay)
			 (set control_door_c_wave false)))
	(if (and control_door_d_wave
;		    (objects_can_see_object (players) control_door_bashed_d 25)
		    (< (ai_living_count int_b_flood) control_limit))
	    (begin (ai_place int_b_flood/control_d)
			 (ai_place int_b_infection/control_d)
			 (sleep control_delay)
			 (set control_door_d_wave false)))
	(if (and control_door_e_wave
;		    (objects_can_see_object (players) control_door_bashed_e 25)
		    (< (ai_living_count int_b_flood) control_limit))
	    (begin (ai_place int_b_flood/control_e)
			 (ai_place int_b_infection/control_e)
			 (sleep control_delay)
			 (set control_door_e_wave false)))
;	(if (and control_door_f_wave
;		    (objects_can_see_object (players) control_door_bashed_f 25)
;		    (< (ai_living_count int_b_flood) control_limit))
;			(begin (ai_place int_a_flood/control_f)
;			 (ai_place int_a_infection/control_f)
;			 (sleep control_delay)
;			 (set control_door_f_wave false)))
	(if (and control_door_g_wave
;		    (objects_can_see_object (players) control_door_bashed_g 25)
		    (< (ai_living_count int_b_flood) control_limit))
	    (begin (ai_place int_b_flood/control_g)
			 (ai_place int_b_infection/control_g)
			 (sleep control_delay)
			 (set control_door_g_wave false)))
	(if (and control_door_h_wave
;		    (objects_can_see_object (players) control_door_bashed_h 25)
		    (< (ai_living_count int_b_flood) control_limit))
	    (begin (ai_place int_b_flood/control_h)
			 (ai_place int_b_infection/control_h)
			 (sleep control_delay)
			 (set control_door_h_wave false)))
	(ai_magically_see_players int_b_flood)
	)
*;

(script dormant ini_int_b_bay_b_breakin
	(sleep_until (volume_test_objects hall_d_bash_trigger (players)))
	(ai_place int_b_flood/hall_d)
	)
	
(script dormant ini_int_b_lab_b
	(sleep_until (or (volume_test_objects hall_d_top_trigger (players))
				  (volume_test_objects hall_d_bottom_trigger (players))))
	(wake enc_int_b_lab_b_flood)
	(sleep_until (= (ai_living_count int_c_flood/lab_b) 0))
	(game_save_no_timeout)
	)

(script dormant ini_int_b_lab_b_cov
	(sleep_until (or (volume_test_objects hall_d_top_trigger (players))
				  (volume_test_objects hall_d_bottom_trigger (players))))
	(ai_place int_b_covenant/grunts_lab_b_bot)
	(ai_place int_b_covenant/jackals_lab_b_bot)
	)

(script dormant ini_int_b_hall_d
	(sleep_until (volume_test_objects hall_d_bottom_trigger (players)))
	(wake enc_int_b_tinylab_g_flood)
	(wake enc_int_b_tinylab_h_flood))


(script dormant ini_crazy_marine
	(object_create marine_suicidal)
	(ai_attach marine_suicidal int_b_crazy_marine/crazy_marine)
	(unit_set_maximum_vitality marine_suicidal 1 0)
	(unit_set_current_vitality marine_suicidal 1 0)

	(sleep_until (volume_test_objects hall_d_bottom_trigger (players)))
	(game_save_no_timeout)
;	(wake music_c10_03)
	(sleep_until (or (volume_test_objects suicidal_trigger (players)) (objects_can_see_object (players) marine_suicidal 15)) 1)
   (mcc_mission_segment "07_crazy_marine")

	(sleep_until (volume_test_objects suicidal_trigger (players)) 1 90)
	(sleep 60)
	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_050_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_050_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_050_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_060_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_060_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_060_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_070_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_070_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_070_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_080_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_080_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_080_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_090_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_090_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_090_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_100_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_100_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_100_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_110_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_110_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_110_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_120_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_120_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_120_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_130_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_130_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_130_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_140_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_140_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_140_crazymarine")

	(if (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) (sleep -1))
	(sound_impulse_start "sound\dialog\c10\c10_150_crazymarine" marine_suicidal 1)
	(sleep_until (= (ai_living_count int_b_crazy_marine/crazy_marine) 0) 1
		(sound_impulse_time "sound\dialog\c10\c10_150_crazymarine"))
	(sound_impulse_stop "sound\dialog\c10\c10_150_crazymarine")
;	(custom_animation marine_suicidal cinematics\animations\marine_suicidal\level_specific\level_specific "c10crazy suicide" true)
;	(ai_kill_silent int_b_crazy_marine)
	)

;========== Interior C Encounter Scripts ==========

(script dormant enc_int_c_bay_a_flood
	(ai_place int_c_flood/bay_a)
	(ai_place int_c_infection/bay_a))

(script dormant enc_int_c_bay_a_jumpers
	(ai_place int_c_flood/bay_a_jumpers))

(script dormant enc_int_c_lift_b_flood
	(ai_place int_c_flood/lift_b)
	(ai_place int_c_infection/lift_b))

(script dormant enc_int_c_lab_a_flood
	(ai_place int_c_flood/lab_a)
	(ai_place int_c_infection/lab_a))

(script dormant enc_int_c_lab_b_flood
	(ai_place int_c_flood/lab_b)
	(ai_place int_c_infection/lab_b))

(script dormant enc_int_c_tinylab_a_flood
	(ai_place int_c_flood/tinylab_a)
	(ai_place int_c_infection/tinylab_a))

(script dormant enc_int_c_tinylab_b_flood
	(ai_place int_c_flood/tinylab_b)
	(ai_place int_c_infection/tinylab_b))

(script dormant enc_int_c_tinylab_c_flood
	(ai_place int_c_flood/tinylab_c)
	(ai_place int_c_infection/tinylab_c))

(script dormant enc_int_c_tinylab_d_flood
	(ai_place int_c_flood/tinylab_d)
	(ai_place int_c_infection/tinylab_d))

(script dormant enc_int_c_hall_a_flood
	(ai_place int_c_infection/hall_a))

(script dormant enc_int_c_hall_b_flood
	(ai_place int_c_infection/hall_b))

;========== Interior C Initialization Scripts ==========

;*
(script static void temp
	(ai_reconnect)
;	(device_set_position_immediate int_c_bay_a_bashed 0)
;	(object_destroy int_c_bay_a_door)
;	(object_destroy int_c_bay_a_bashed)
;	(object_create int_c_bay_a_door)
	(ai_erase_all)
	(sleep 1)
	(garbage_collect_now)
	)
*;

(script dormant ini_int_c_marines_1
;	(device_set_position int_c_bay_a_door 1)
	(ai_place int_c_marines/bay_a)
	(sleep 90)
	(units_set_current_vitality (ai_actors int_c_marines/bay_a) .5 0)
;	(device_operates_automatically_set int_c_bay_a_door 0)
;	(device_set_position int_c_bay_a_door 0)
	(sleep 60)
;	(object_destroy int_c_bay_a_door)
;	(object_create int_c_bay_a_bashed)
;	(device_set_position int_c_bay_a_bashed 1)
	(sleep 85)
	(ai_place int_c_flood/bay_a_chasers)
	(sleep 30)
	(ai_place int_c_infection/bay_a_chasers)
	)

(script dormant ini_int_c_lab_a
	(sleep_until (or (volume_test_objects int_b_hall_a_trigger (players))
				  (volume_test_objects int_b_hall_a_trigger_b (players))))
	(game_save_no_timeout)
	(wake enc_int_c_lab_a_flood))
	
(script dormant ini_int_c_hall_a_labs
	(sleep_until (volume_test_objects int_b_hall_a_trigger (players)) 10)
	(game_save_no_timeout)
	(wake enc_int_c_tinylab_a_flood)
	(wake enc_int_c_tinylab_b_flood)
	(ai_magically_see_players int_c_infection/tinylab_a)
	(ai_magically_see_players int_c_infection/tinylab_b)
	(ai_magically_see_players int_c_flood/tinylab_a)
	(ai_magically_see_players int_c_flood/tinylab_b))

	
(script dormant ini_int_c_hall_b_labs
	(sleep_until (volume_test_objects int_b_hall_b_trigger (players)) 10)
	(game_save_no_timeout)
	(wake enc_int_c_tinylab_c_flood)
	(wake enc_int_c_tinylab_d_flood)
	(ai_magically_see_players int_c_infection/tinylab_c)
	(ai_magically_see_players int_c_infection/tinylab_d)
	(ai_magically_see_players int_c_flood/tinylab_c)
	(ai_magically_see_players int_c_flood/tinylab_d))

;*
(script continuous ini_interior_c_cleanup
	(sleep (* 30 5))
	(if (<= (ai_status int_c_flood/lift_b) 2) (ai_kill int_c_flood/lift_b))
	(if (<= (ai_status int_c_flood/bay_a) 2) (ai_kill int_c_flood/bay_a))
	(if (<= (ai_status int_c_flood/lab_a) 2) (ai_kill int_c_flood/lab_a))
	(if (<= (ai_status int_c_flood/tinylab_a) 2) (ai_kill int_c_flood/tinylab_a))
	(if (<= (ai_status int_c_flood/tinylab_b) 2) (ai_kill int_c_flood/tinylab_a))
	(if (<= (ai_status int_c_infection/lift_b) 2) (ai_kill int_c_infection/lift_b))
	(if (<= (ai_status int_c_infection/bay_a) 2) (ai_kill int_c_infection/bay_a))
	(if (<= (ai_status int_c_infection/tinylab_a) 2) (ai_kill int_c_infection/tinylab_a))
	(if (<= (ai_status int_c_infection/tinylab_b) 2) (ai_kill int_c_infection/tinylab_b))
	(if (<= (ai_status int_c_infection/lab_a) 2) (ai_kill int_c_infection/lab_a))
	(sleep (* 30 5))
	)
*;

;========== Interior D Encounter Scripts ==========

(script dormant enc_int_d_bay_b_flood
	(ai_place int_d_flood/bay_b)
	(ai_place int_d_infection/bay_b))

(script dormant enc_int_d_bay_c_flood
	(ai_place int_d_flood/bay_c)
	(ai_place int_d_infection/bay_c))

(script dormant enc_int_d_lift_c_flood
	(ai_place int_d_flood/lift_c)
	(ai_place int_d_infection/lift_c))

(script dormant enc_int_d_lift_d_flood
	(ai_place int_d_flood/lift_d)
	(ai_place int_d_infection/lift_d))

;(script dormant enc_int_d_lab_c_flood
;	(ai_place int_d_flood/lab_c)
;	(ai_place int_d_infection/lab_c))

(script dormant enc_int_d_lab_d_flood
	(ai_place int_d_flood/lab_d)
	(ai_place int_d_infection/lab_d))

(script dormant enc_int_d_tinylab_g_flood
	(ai_place int_d_flood/tinylab_g)
	(ai_place int_d_infection/tinylab_g))

(script dormant enc_int_d_tinylab_h_flood
	(ai_place int_d_flood/tinylab_h)
	(ai_place int_d_infection/tinylab_h))

(script dormant enc_int_d_tinylab_i_flood
	(ai_place int_d_flood/tinylab_i)
	(ai_place int_d_infection/tinylab_i))

(script dormant enc_int_d_tinylab_j_flood
	(ai_place int_d_flood/tinylab_j)
	(ai_place int_d_infection/tinylab_j))

(script dormant enc_int_d_tinylab_k_flood
	(ai_place int_d_flood/tinylab_k)
	(ai_place int_d_infection/tinylab_k))

(script dormant enc_int_d_tinylab_l_flood
	(ai_place int_d_flood/tinylab_l)
	(ai_place int_d_infection/tinylab_l))

(script dormant enc_int_d_tinylab_m_flood
	(ai_place int_d_flood/tinylab_m)
	(ai_place int_d_infection/tinylab_m))

(script dormant enc_int_d_tinylab_n_flood
	(ai_place int_d_flood/tinylab_n)
	(ai_place int_d_infection/tinylab_n))

(script dormant enc_int_d_tinylab_o_flood
	(ai_place int_d_flood/tinylab_o)
	(ai_place int_d_infection/tinylab_o))

(script dormant enc_int_d_hall_d_flood
	(ai_place int_d_infection/hall_d))

(script dormant enc_int_d_hall_e_flood
	(ai_place int_d_infection/hall_e))

(script dormant enc_int_d_hall_f_flood
	(ai_place int_d_infection/hall_f))

(script dormant enc_int_d_hall_g_flood
	(ai_place int_d_infection/hall_g))
	
(script dormant enc_int_d_lift_d_rush
	(ai_place int_d_flood/lift_d_rush))

;========== Interior D Initialization Scripts ==========

;(script dormant ini_int_d_lab_c
;	(sleep_until (or (volume_test_objects int_b_hall_d_trigger (players))
;				  (volume_test_objects int_b_hall_d_trigger_b (players))))
;	(wake enc_int_d_lab_c_flood))
	
(script dormant ini_int_d_hall_d_labs
	(sleep_until (volume_test_objects int_b_hall_d_trigger (players)) 10)
	(game_save_no_timeout)
	(wake enc_int_d_tinylab_g_flood)
	(wake enc_int_d_tinylab_h_flood)
	(ai_magically_see_players int_d_infection/tinylab_g)
	(ai_magically_see_players int_d_infection/tinylab_h)
	(ai_magically_see_players int_d_flood/tinylab_g)
	(ai_magically_see_players int_d_flood/tinylab_h))


(script dormant ini_int_d_lift_c
	(sleep_until (or (volume_test_objects int_b_hall_e_trigger (players))
				  (volume_test_objects int_b_hall_e_trigger_b (players))))
	(game_save_no_timeout)
	(wake enc_int_d_lift_c_flood))

(script dormant ini_int_d_hall_e_labs
	(sleep_until (volume_test_objects int_b_hall_e_trigger (players)) 10)
	(game_save_no_timeout)
	(wake enc_int_d_tinylab_i_flood)
	(wake enc_int_d_tinylab_j_flood)
	(wake enc_int_d_tinylab_k_flood)
	(ai_magically_see_players int_d_infection/tinylab_i)
	(ai_magically_see_players int_d_infection/tinylab_j)
	(ai_magically_see_players int_d_infection/tinylab_k)
	(ai_magically_see_players int_d_flood/tinylab_i)
	(ai_magically_see_players int_d_flood/tinylab_j)
	(ai_magically_see_players int_d_flood/tinylab_k))

(script dormant ini_int_d_hall_f_labs
	(sleep_until (volume_test_objects int_b_hall_f_trigger (players)) 10)
	(game_save_no_timeout)
	(wake enc_int_d_tinylab_l_flood)
	(wake enc_int_d_tinylab_m_flood)
	(ai_magically_see_players int_d_infection/tinylab_l)
	(ai_magically_see_players int_d_infection/tinylab_m)
	(ai_magically_see_players int_d_flood/tinylab_l)
	(ai_magically_see_players int_d_flood/tinylab_m))

(script dormant ini_int_d_hall_g_labs
	(sleep_until (volume_test_objects int_b_hall_g_trigger (players)) 10)
	(game_save_no_timeout)
	(wake enc_int_d_tinylab_n_flood)
	(wake enc_int_d_tinylab_o_flood)
	(ai_magically_see_players int_d_infection/tinylab_n)
	(ai_magically_see_players int_d_infection/tinylab_o)
	(ai_magically_see_players int_d_flood/tinylab_n)
	(ai_magically_see_players int_d_flood/tinylab_o))

;*
(script continuous ini_interior_d_cleanup
	(sleep (* 30 5))
	(if (<= (ai_status int_d_flood/lift_c) 2) (ai_kill int_d_flood/lift_c))
	(if (<= (ai_status int_d_flood/bay_b) 2) (ai_kill int_d_flood/bay_b))
	(if (<= (ai_status int_c_flood/lab_b) 2) (ai_kill int_c_flood/lab_b))
	(if (<= (ai_status int_d_flood/lab_c) 2) (ai_kill int_d_flood/lab_c))
	(if (<= (ai_status int_c_flood/tinylab_c) 2) (ai_kill int_c_flood/tinylab_c))
	(if (<= (ai_status int_c_flood/tinylab_d) 2) (ai_kill int_c_flood/tinylab_d))
	(if (<= (ai_status int_d_flood/tinylab_g) 2) (ai_kill int_d_flood/tinylab_g))
	(if (<= (ai_status int_d_flood/tinylab_h) 2) (ai_kill int_d_flood/tinylab_h))
	(if (<= (ai_status int_d_flood/tinylab_i) 2) (ai_kill int_d_flood/tinylab_i))
	(if (<= (ai_status int_d_flood/tinylab_j) 2) (ai_kill int_d_flood/tinylab_j))
	(if (<= (ai_status int_d_flood/tinylab_k) 2) (ai_kill int_d_flood/tinylab_k))
	(sleep (* 30 5))
	(if (<= (ai_status int_c_infection/lift_b) 2) (ai_kill int_c_infection/lift_b))
	(if (<= (ai_status int_d_infection/bay_b) 2) (ai_kill int_d_infection/bay_b))
	(if (<= (ai_status int_c_infection/lab_b) 2) (ai_kill int_c_infection/lab_b))
;	(if (<= (ai_status int_d_infection/lab_c) 2) (ai_kill int_d_infection/lab_c))
	(if (<= (ai_status int_c_infection/tinylab_c) 2) (ai_kill int_c_infection/tinylab_c))
	(if (<= (ai_status int_c_infection/tinylab_d) 2) (ai_kill int_c_infection/tinylab_d))
	(if (<= (ai_status int_d_infection/tinylab_g) 2) (ai_kill int_d_infection/tinylab_g))
	(if (<= (ai_status int_d_infection/tinylab_h) 2) (ai_kill int_d_infection/tinylab_h))
	(if (<= (ai_status int_d_infection/tinylab_i) 2) (ai_kill int_d_infection/tinylab_i))
	(if (<= (ai_status int_d_infection/tinylab_j) 2) (ai_kill int_d_infection/tinylab_j))
	(if (<= (ai_status int_d_infection/tinylab_k) 2) (ai_kill int_d_infection/tinylab_k))
	(sleep (* 30 5))
	)
*;		   	   
;========== Swamp b Encounter Scripts ==========

(script dormant enc_swamp_b_flood_gauntlet
	(ai_place swamp_b_flood_2/gauntlet_floor)
	(ai_place swamp_b_flood_2/gauntlet_left)
	(ai_place swamp_b_flood_2/gauntlet_right)
	(ai_place swamp_b_flood_2/gauntlet_infection)
	)

(script dormant enc_swamp_b_flood_tower
	(ai_place swamp_b_flood_2/tower_floor)
	)

(script dormant enc_swamp_b_flood_ini
	(ai_place swamp_b_flood/flood_initial)
	(ai_place swamp_b_infection/infection_initial)
	)

(script dormant enc_swamp_b_sentinels
	(ai_place swamp_b_sentinels/sentinels_ini)
	(ai_place swamp_b_monitor/monitor_ini)
	(sleep (* 30 3))
	(ai_migrate swamp_b_sentinels swamp_b_sentinels/sentinels_a)
	(ai_migrate swamp_b_monitor swamp_b_monitor/monitor_a)
	(ai_try_to_fight swamp_b_sentinels swamp_b_flood)
	(ai_try_to_fight swamp_b_monitor swamp_b_flood)
	(sleep 1)
	(ai_follow_target_players swamp_b_sentinels/sentinels_a)
	(ai_follow_target_players swamp_b_monitor/monitor_a)
	)

(script static void enc_swamp_b_volume_a1
	(if (<= (ai_living_count swamp_b_flood) swamp_b_limiter)
		  (begin (ai_place swamp_b_flood/flood_a)
			    (if debug (print "placing flood a"))
;			    (ai_place swamp_b_flood/flood_b)
;			    (if debug (print "placing flood b"))
			    (ai_place swamp_b_flood/flood_m)
			    (if debug (print "placing flood m"))
			    (ai_place swamp_b_flood/flood_n)
			    (if debug (print "placing flood n"))))
	(if (<= (ai_living_count swamp_b_infection) swamp_b_infection_limiter)
		  (begin (ai_place swamp_b_infection/infection_a1)
		  	    (if debug (print "placing a1 infection"))))
	(set swamp_b_player_locator 1))
	
(script static void enc_swamp_b_volume_a2
	(if (<= (ai_living_count swamp_b_flood) swamp_b_limiter)
		  (begin (ai_place swamp_b_flood/flood_b)
			    (if debug (print "placing flood b"))
;			    (ai_place swamp_b_flood/flood_a)
;			    (if debug (print "placing flood a"))
			    (ai_place swamp_b_flood/flood_m)
			    (if debug (print "placing flood m"))
			    (ai_place swamp_b_flood/flood_n)
			    (if debug (print "placing flood n"))))
	(if (<= (ai_living_count swamp_b_infection) swamp_b_infection_limiter)
		  (begin (ai_place swamp_b_infection/infection_a2)
		  	    (if debug (print "placing a2 infection"))))
	(set swamp_b_player_locator 2))

(script static void enc_swamp_b_volume_b
	(if (<= (ai_living_count swamp_b_flood) swamp_b_limiter)
		  (begin (ai_place swamp_b_flood/flood_c)
			    (if debug (print "placing flood c"))
			    (ai_place swamp_b_flood/flood_b)
			    (if debug (print "placing flood b"))
			    (ai_place swamp_b_flood/flood_l)
			    (if debug (print "placing flood l"))))
	(if (<= (ai_living_count swamp_b_infection) swamp_b_infection_limiter)
		  (begin (ai_place swamp_b_infection/infection_b)
		  	    (if debug (print "placing b infection"))))
	(set swamp_b_player_locator 3))

(script static void enc_swamp_b_volume_c
	(if (<= (ai_living_count swamp_b_flood) swamp_b_limiter)
		  (begin (ai_place swamp_b_flood/flood_d)
			    (if debug (print "placing flood d"))
			    (ai_place swamp_b_flood/flood_e)
			    (if debug (print "placing flood e"))
;			    (ai_place swamp_b_flood/flood_f)
;			    (if debug (print "placing flood f"))
;			    (ai_place swamp_b_flood/flood_k)
;			    (if debug (print "placing flood k"))
			  (cond ((= 0 (volume_test_objects swamp_b_trigger_d (players)))  
			    (ai_place swamp_b_flood/flood_p_c)
			    (if debug (print "placing flood p_c"))))			    
			  (cond ((= 0 (volume_test_objects swamp_b_trigger_f (players)))  
			    (ai_place swamp_b_flood/flood_r_c)
			    (if debug (print "placing flood r_c"))))))
	(if (<= (ai_living_count swamp_b_infection) swamp_b_infection_limiter)
		  (begin (ai_place swamp_b_infection/infection_c)
		  	    (if debug (print "placing c infection"))))
	(set swamp_b_player_locator 4))
	
(script static void enc_swamp_b_volume_d
	(if (<= (ai_living_count swamp_b_flood) swamp_b_limiter)
		  (begin (ai_place swamp_b_flood/flood_f)
			    (if debug (print "placing flood f"))
			    (ai_place swamp_b_flood/flood_g)
			    (if debug (print "placing flood g"))
;			    (ai_place swamp_b_flood/flood_e)
;			    (if debug (print "placing flood e"))
;			    (ai_place swamp_b_flood/flood_h)
;			    (if debug (print "placing flood h"))
			  (cond ((= 0 (volume_test_objects swamp_b_trigger_c (players)))  
			    (ai_place swamp_b_flood/flood_o_d)
			    (if debug (print "placing flood o_d"))))
			  (cond ((= 0 (volume_test_objects swamp_b_trigger_e (players)))  
			    (ai_place swamp_b_flood/flood_q_d)
			    (if debug (print "placing flood q_d"))))))
	(if (<= (ai_living_count swamp_b_infection) swamp_b_infection_limiter)
		  (begin (ai_place swamp_b_infection/infection_d)
		  	    (if debug (print "placing d infection"))))
	(set swamp_b_player_locator 5))

(script static void enc_swamp_b_volume_e
	(if (<= (ai_living_count swamp_b_flood) swamp_b_limiter)
		  (begin (ai_place swamp_b_flood/flood_h)
			    (if debug (print "placing flood h"))
			    (ai_place swamp_b_flood/flood_i)
			    (if debug (print "placing flood i"))
;			    (ai_place swamp_b_flood/flood_g)
;			    (if debug (print "placing flood g"))
;			    (ai_place swamp_b_flood/flood_j)
;			    (if debug (print "placing flood j"))
			  (cond ((= 0 (volume_test_objects swamp_b_trigger_d (players)))  
			    (ai_place swamp_b_flood/flood_p_e)
			    (if debug (print "placing flood p_e"))))
			  (cond ((= 0 (volume_test_objects swamp_b_trigger_f (players)))  
			    (ai_place swamp_b_flood/flood_r_e)
			    (if debug (print "placing flood r_e"))))))
	(if (<= (ai_living_count swamp_b_infection) swamp_b_infection_limiter)
		  (begin (ai_place swamp_b_infection/infection_e)
		  	    (if debug (print "placing e infection"))))
	(set swamp_b_player_locator 6))

(script static void enc_swamp_b_volume_f
	(if (<= (ai_living_count swamp_b_flood) swamp_b_limiter)
		  (begin (ai_place swamp_b_flood/flood_j)
			    (if debug (print "placing flood j"))
			    (ai_place swamp_b_flood/flood_k)
			    (if debug (print "placing flood k"))
;			    (ai_place swamp_b_flood/flood_d)
;			    (if debug (print "placing flood d"))
;			    (ai_place swamp_b_flood/flood_i)
;			    (if debug (print "placing flood i"))
			  (cond ((= 0 (volume_test_objects swamp_b_trigger_c (players)))  
			    (ai_place swamp_b_flood/flood_o_f)
			    (if debug (print "placing flood o_f"))))
			  (cond ((= 0 (volume_test_objects swamp_b_trigger_e (players)))  
			    (ai_place swamp_b_flood/flood_q_f)
			    (if debug (print "placing flood q_f"))))))
	(if (<= (ai_living_count swamp_b_infection) swamp_b_infection_limiter)
		  (begin (ai_place swamp_b_infection/infection_f)
		  	    (if debug (print "placing f infection"))))
	(set swamp_b_player_locator 7))

;========== Swamp b Initialization Scripts ==========

(script dormant ini_swamp_b_marines
	(ai_place swamp_b_marines/lift_meat)
;	(sleep 60)
	(ai_place swamp_b_infection/lift)

;	(sleep_until (or (volume_test_objects gogogo_trigger (players))
;				  (< (ai_living_count swamp_b_infection/lift) 2)) 1 (* 30 10))
;	(if (not (volume_test_objects_all gogogo_trigger (players))) (ai_conversation swamp_b))
	(ai_conversation swamp_b)
	(sleep_until (or (volume_test_objects gogogo_trigger (players))
				  (> (ai_conversation_status swamp_b) 4)) 1)
	(set play_music_c10_07 true)
	(ai_migrate swamp_b_marines swamp_b_marines/b)

	(sleep_until (volume_test_objects swamp_b_trigger_a1 (players)) 1 120)
	(ai_migrate swamp_b_marines swamp_b_marines/c)
	
	(sleep_until (volume_test_objects swamp_b_trigger_a1 (players)) 1)
	(ai_migrate swamp_b_marines swamp_b_marines/d)

	(sleep_until (volume_test_objects swamp_b_trigger_a2 (players)) 1 150)
	(ai_migrate swamp_b_marines swamp_b_marines/g)

	(sleep_until (volume_test_objects swamp_b_trigger_a2 (players)) 1 150)
	(ai_migrate swamp_b_marines swamp_b_marines/h)

	(sleep_until (volume_test_objects swamp_b_trigger_a2 (players)) 1 150)
	(ai_migrate swamp_b_marines swamp_b_marines/f)

	(sleep_until (volume_test_objects swamp_b_trigger_a2 (players)) 1 150)
	(ai_migrate swamp_b_marines swamp_b_marines/i)

	(sleep_until (volume_test_objects swamp_b_trigger_a2 (players)) 1 150)
	(ai_migrate swamp_b_marines swamp_b_marines/i)

	(sleep_until (volume_test_objects swamp_b_trigger_a2 (players)) 1)
	(ai_migrate swamp_b_marines swamp_b_marines/j)

	(sleep_until (volume_test_objects swamp_b_trigger_b (players)) 1 150)
	(ai_migrate swamp_b_marines swamp_b_marines/k)

	(sleep_until (volume_test_objects swamp_b_trigger_b (players)) 1)
	(ai_migrate swamp_b_marines swamp_b_marines/l)

	(sleep_until (volume_test_objects swamp_b_trigger_c (players)) 1)
	(ai_migrate swamp_b_marines swamp_b_marines/l)
	(ai_follow_target_players swamp_b_marines/l)
	)

(script static void ini_swamp_b_from_a1
	(cond ((volume_test_objects swamp_b_trigger_a2 (players)) (enc_swamp_b_volume_a2))
		 (true (enc_swamp_b_volume_a1))))

(script static void ini_swamp_b_from_a2
	(cond ((volume_test_objects swamp_b_trigger_a1 (players)) (enc_swamp_b_volume_a1))
		 ((volume_test_objects swamp_b_trigger_c (players)) (enc_swamp_b_volume_c))
		 (true (enc_swamp_b_volume_a2))))

(script static void ini_swamp_b_from_b
	(cond ((volume_test_objects swamp_b_trigger_a2 (players)) (enc_swamp_b_volume_a2))
		 ((volume_test_objects swamp_b_trigger_c (players)) (enc_swamp_b_volume_c))
		 (true (enc_swamp_b_volume_b))))

(script static void ini_swamp_b_from_c
	(cond ((volume_test_objects swamp_b_trigger_b (players)) (enc_swamp_b_volume_b))
		 ((volume_test_objects swamp_b_trigger_d (players)) (enc_swamp_b_volume_d))
		 ((volume_test_objects swamp_b_trigger_f (players)) (enc_swamp_b_volume_f))
		 (true (enc_swamp_b_volume_c))))

(script static void ini_swamp_b_from_d
	(cond ((volume_test_objects swamp_b_trigger_c (players)) (enc_swamp_b_volume_c))
		 ((volume_test_objects swamp_b_trigger_e (players)) (enc_swamp_b_volume_e))
		 (true (enc_swamp_b_volume_d))))

(script static void ini_swamp_b_from_e
	(cond ((volume_test_objects swamp_b_trigger_d (players)) (enc_swamp_b_volume_d))
		 ((volume_test_objects swamp_b_trigger_f (players)) (enc_swamp_b_volume_f))
		 (true (enc_swamp_b_volume_e))))

(script static void ini_swamp_b_from_f
	(cond ((volume_test_objects swamp_b_trigger_c (players)) (enc_swamp_b_volume_c))
		 ((volume_test_objects swamp_b_trigger_e (players)) (enc_swamp_b_volume_e))
		 (true (enc_swamp_b_volume_f))))


(script continuous ini_swamp_b_flood_emitter
	(if (= 1 swamp_b_player_locator) (ini_swamp_b_from_a1))
	(if (= 2 swamp_b_player_locator) (ini_swamp_b_from_a2))
	(if (= 3 swamp_b_player_locator) (ini_swamp_b_from_b))
	(if (= 4 swamp_b_player_locator) (ini_swamp_b_from_c))
	(if (= 5 swamp_b_player_locator) (ini_swamp_b_from_d))
	(if (= 6 swamp_b_player_locator) (ini_swamp_b_from_e))
	(if (= 7 swamp_b_player_locator) (ini_swamp_b_from_f))
	(if debug (inspect swamp_b_player_locator))
;	(ai_magically_see_players swamp_b_flood)
;	(ai_magically_see_players swamp_b_infection)
	(sleep swamp_b_emitter_delay))
	
(script continuous ini_flood_prefer_sentinels
	(ai_try_to_fight swamp_b_flood swamp_b_sentinels)
	(ai_try_to_fight_player swamp_b_infection)
	)

;========== Cleanup Scripts ==========
;*
(script static void ini_swamp_a_cleanup
	(ai_erase_all)
	(garbage_collect_now)
	
	(sleep -1 ini_see_flood_a)
	(sleep -1 ini_see_flood_b)
	(sleep -1 ini_see_flood_c)
	(sleep -1 ini_see_flood_d)
	(deactivate_team_nav_point_object player crashed_dropship)
	(sleep 1)
	)

(script static void ini_interior_a_cleanup
	(ai_erase_all)
	(garbage_collect_now)

	(sleep -1 ini_int_b_lab_b)
	(sleep -1 ini_int_a_lift_a)
	(sleep -1 ini_int_b_bay_b_breakin)
	(sleep -1 ini_int_a_hall_b)
	(sleep -1 ini_int_b_hall_d)
	(sleep 1)
	)

(script static void ini_interior_b_cleanup
	(ai_erase_all)
	(objects_delete_by_definition "levels\c10\devices\door_small_bashed\door_small_bashed")
	(objects_delete_by_definition "levels\b30\devices\doors\door small\door small")
	(objects_delete_by_definition "levels\b30\devices\interior tech objects\holo display square\holo display square")
	(objects_delete_by_definition "levels\b30\devices\light fixtures\light fixture wall3\light fixture wall3")
	(objects_delete_by_definition "levels\b30\devices\interior tech objects\holo display wide\holo display wide")
	(objects_delete_by_definition "levels\b30\devices\interior tech objects\holo control\holo control")
	(objects_delete_by_definition "characters\captain_ingame\captain_ingame_cinematic")
	(objects_delete_by_definition "characters\marine_armored\marine_armored_unarmed")
	(objects_delete_by_definition "levels\b30\devices\interior tech objects\holo display tall\holo display tall")
	(objects_delete_by_definition "levels\c10\devices\bridge\bridge")
	(objects_delete_by_definition "levels\c10\devices\falling lift\falling lift")
	(objects_delete_by_definition "sound\sfx\ambience\c10\pelican")
	(objects_delete_by_definition "characters\cyborg\cyborg_unarmed")
	(objects_delete_by_definition "characters\jackal\jackal")
	(objects_delete_by_definition "characters\grunt\grunt")
	(objects_delete_by_definition "characters\flood_infection\flood_infection")
	(objects_delete_by_definition "characters\floodcombat_human\floodcombat_human")
	(objects_delete_by_definition "characters\floodcombat elite\floodcombat elite")
	(sleep -1 ini_int_c_lab_a)
;	(sleep -1 ini_int_d_lab_c)
	(sleep -1 ini_int_d_lift_c)
	(sleep -1 ini_int_c_hall_a_labs)
	(sleep -1 ini_int_c_hall_b_labs)
	(sleep -1 ini_int_d_hall_d_labs)
	(sleep -1 ini_int_d_hall_e_labs)
	(sleep -1 ini_int_d_hall_f_labs)
	(sleep -1 ini_int_d_hall_g_labs)
	(garbage_collect_now)
	(sleep 1)
	)
*;
;========== Mission Scripts ==========

(script dormant mission_swamp_a
	(wake obj_find)
;	(wake music_c10_01)
	(wake enc_swamp1)
	(wake enc_swamp2)
	(wake inc_log)
	(wake inc3)
	(wake inc4)
	(wake inc5)
	(wake inc6)
	(wake inc7)
;	(wake ini_pelican_radio)
;	(wake ini_see_flood_a)
;	(wake ini_see_flood_b)
;	(wake ini_see_flood_c)
;	(wake ini_see_flood_d)

	(sleep_until (volume_test_objects enc_swamp2 (players)) 1)
   (mcc_mission_segment "02_enc")
;	(set play_music_c10_01 false)

	(sleep_until (volume_test_objects int_a_trigger_3 (players)) 1)
	(device_set_position lift_a 0)
   (mcc_mission_segment "03_near_lift")

	(sleep_until (= (device_get_position lift_a) 0) 1)
	(game_save_no_timeout)
   (mcc_mission_segment "04_go_lift")

	(sleep_until (volume_test_objects int_a_trigger (players)) 1)
	(kill_tysons_crap)
;	(ini_swamp_a_cleanup)

	(sleep_until (volume_test_objects lift_a_flood_trigger (players)) 1)
	)

(script dormant mission_int_a
;	(wake music_c10_02)
;	(wake ini_int_a_lift_a_cov)
	(ai_place lifta_bottom)
	(game_save_no_timeout)
   (mcc_mission_segment "05_int_a")

	(sleep_until (volume_test_objects lift_a_flood_trigger (players)) 1)
;	(set play_music_c10_02 false)
	(ai_place halla_bottom)
	(ai_maneuver lifta_bottom)
;	(wake ini_int_a_bay_a_cov)
;	(ai_maneuver int_a_covenant/grunts_lift_left)
;	(ai_maneuver int_a_covenant/grunts_lift_right)
	
	(sleep_until (or (volume_test_objects hall_b_top_trigger (players))
				  (volume_test_objects hall_b_bottom_trigger (players))))
	(ai_place laba_bottom)
;	(wake enc_int_a_lab_a_cov)
;	(wake ini_int_b_lab_b_cov)
	(game_save_no_timeout)
   (mcc_mission_segment "06_hall_b")
	
	(sleep_until (or (volume_test_objects hall_d_top_trigger (players))
				  (volume_test_objects hall_d_bottom_trigger (players))))
	(ai_place laba_infection)
	(wake ini_crazy_marine)

;	(sleep_until (!= (device_get_position ante_b_door) 0))
	(game_save_no_timeout)
;	(wake enc_infection_ini)

	(sleep_until (volume_test_objects hall_d_top_trigger (players)) 10)
	(ai_place halln_flee)
   (mcc_mission_segment "08_hall_d_top")


	(sleep_until (volume_test_objects hall_d_bash_trigger (players)) 10)
	(game_save_no_timeout)
   (mcc_mission_segment "09_hall_d_bash")
	)

(script dormant mission_control
	(sleep_until (volume_test_objects bayb_trigger (players)) 1)
	(set play_music_c10_02 true)
;	(ai_place int_b_infection/control_ini)

	(sleep_until (volume_test_objects control_lab_trigger (players)) 1)
	(set play_music_c10_02 false)
	(player_enable_input false)
   
   (if (mcc_mission_segment "cine2_jenkins") (sleep 1))              

	(ini_x50_preclean)
	(ai_erase int_b_infection/control_ini)

	(cinematic_start)
	(set tracker_x50 true)
	(object_destroy_containing biped)
	(ai_erase_all)
	(garbage_collect_now)
	(if (cinematic_skip_start) (x50))
	(cinematic_skip_stop)
	(set tracker_x50 false)
;	(object_create_anew_containing bsp2_biped)
	(object_create_anew_containing blood)
	(object_create post_x50_marine)
	(object_teleport (player0) player0_playon_c10)
	(object_teleport (player1) player1_playon_c10)
	(cinematic_stop)
	(wake chapter_flood)
	(switch_bsp 2)
	(player_enable_input true)
;	(volume_teleport_players_not_inside null control_teleport_flag)
;	(wake ini_door_replacement)
	(game_save_no_timeout)

;	(sleep_until (or (volume_test_objects control_table_a_trigger (players))
;				  (volume_test_objects control_table_b_trigger (players))) 30 (* 30 20))
	(wake ini_int_a_lift_a_destroy)
;	(wake ini_control_flood_wave)

	(destroy_door_a)
	(object_create control_door_bashed_a)
;	(wake music_c10_04)
	(wake ini_post_helmet_replace)
	(sleep 15)
	(fade_in 1 1 1 15)
	(object_create control_rustle_1)
	(sleep 3)
	(object_create control_rustle_2)
	(sleep 3)
	(object_create control_rustle_3)
	(sleep 3)
	(object_create control_rustle_4)
	(sleep 450)
	(ai_place int_b_infection/control_d)
	(ai_place int_b_infection/control_d)
	(device_set_position control_door_bashed_d 1)
	(ai_magically_see_players int_b_infection)

	(sleep_until (< (ai_living_count int_b_infection) 20) 1)
	(sleep_until (< (ai_living_count int_b_infection) 10) 1 (* 15 30))
	(ai_place int_b_infection/control_b)
	(ai_place int_b_infection/control_b)
	(sleep 15)
	(device_set_position control_door_bashed_g 1)
	(ai_magically_see_players int_b_infection)

	(sleep_until (< (ai_living_count int_b_infection) 20) 1)
	(sleep_until (< (ai_living_count int_b_infection) 10) 1 (* 15 30))
	(set play_music_c10_03 true)
	(ai_place int_b_infection/control_e)
	(ai_place int_b_infection/control_e)
	(ai_place int_b_infection/control_e)
	(sleep 10)
	(device_set_position control_door_bashed_c 1)
	(ai_magically_see_players int_b_infection)

	(sleep_until (< (ai_living_count int_b_infection) 20) 1)
	(sleep_until (< (ai_living_count int_b_infection) 10) 1 (* 15 30))
	(set play_music_c10_03_alt true)
	(sleep 150)
	(ai_place int_b_infection/control_a)
	(ai_place int_b_infection/control_a)
	(ai_place int_b_flood/control_a)
	(sleep 10)
	(device_set_position control_door_bashed_a 1)
	(ai_magically_see_players int_b_infection)
	(ai_magically_see_players int_b_flood)

	(object_destroy control_rustle_1)
	(sleep 3)
	(object_destroy control_rustle_2)
	(sleep 3)
	(object_destroy control_rustle_3)
	(sleep 3)
	(object_destroy control_rustle_4)

	(sleep_until (not (volume_test_objects_all control_check_trigger (players))) 10)
	(game_save_no_timeout)
	(wake obj_escape)

;	(sleep_until (objects_can_see_object (players) control_door_bashed_a 20))
;	(wake enc_control_a)

	(wake enc_int_b_ante_b_flood)

	(sleep_until (volume_test_objects bayb_trigger (players)) 1)
	(set play_music_c10_03 false)
	(set play_music_c10_03_alt false)
	(game_save_no_timeout)
	(wake enc_int_b_bay_b_flood)
;	(wake ini_int_b_bay_b_breakin)
	(sleep 30)
	(wake ini_int_b_lab_b)
	(sleep 30)
	(wake ini_int_b_hall_d)

	(sleep_until (or (volume_test_objects hall_c_top_trigger (players))
				  (volume_test_objects hall_c_bottom_trigger (players))))
	(wake enc_int_a_lab_a_flood)
	(wake ini_int_a_hall_b)
				  
	(sleep_until (or (volume_test_objects hall_b_top_trigger (players))
				  (volume_test_objects hall_b_bottom_trigger (players))))
	(wake enc_int_a_bay_a_flood)
	(wake ini_int_a_lift_a)
	(ai_place halla_top)
	(ai_magically_see_encounter int_a_flood/bay_a_bottom_1 halla_top)
	(ai_magically_see_encounter halla_top int_a_flood/bay_a_bottom_1)

	(sleep_until (volume_test_objects int_a_ante_a_trigger (players)))
	(wake enc_int_a_ante_a_cov)
	
	(sleep_until (volume_test_objects lift_b_flood_trigger (players)))
	(game_save_no_timeout)
	(wake ini_int_a_lift_b)
	(sleep_until (!= (device_get_position lift_b) 0))
	(set play_music_c10_05 true)

	(sleep_until (volume_test_objects int_b_hall_a_trigger_b (players)) 1)
	(set play_music_c10_05 false)
	)
	
(script dormant mission_int_b
;	(ini_interior_a_cleanup)
	(game_save_no_timeout)
   (mcc_mission_segment "10_int_b")

	(objects_predict (ai_actors int_c_marines))
	(sleep 30)

	(wake enc_int_c_lift_b_flood)
	(wake enc_int_c_bay_a_flood)
	(wake enc_int_c_hall_a_flood)
;	(wake enc_int_c_hall_b_flood)

	(sleep_until (volume_test_objects int_b_bay_a_trigger (players)) 15)
   (mcc_mission_segment "11_b_bay_a")
	(game_save_no_timeout)
	(wake enc_int_c_bay_a_jumpers)
	(wake ini_int_c_marines_1)
	(sleep 30)
	(wake ini_int_c_lab_a)
	(wake ini_int_c_hall_a_labs)
	(wake ini_int_c_hall_b_labs)

	(sleep_until (or (volume_test_objects int_b_hall_b_trigger (players))
				  (volume_test_objects int_b_hall_b_trigger_b (players))))
	(game_save_no_timeout)
   (mcc_mission_segment "12_b_hall_b")
	(wake enc_int_c_lab_b_flood)

	(sleep_until (or (volume_test_objects int_b_hall_c_trigger (players))
				  (volume_test_objects int_b_hall_c_trigger_b (players))))
	(game_save_no_timeout)
   (mcc_mission_segment "13_b_hall_c")
	(wake enc_int_d_hall_d_flood)
	(wake enc_int_d_hall_e_flood)
;	(wake enc_int_d_hall_f_flood)
	(wake enc_int_d_bay_b_flood)
	(sleep 30)
;	(wake ini_int_d_lab_c)
	(wake ini_int_d_lift_c)
	(wake ini_int_d_hall_d_labs)
	(wake ini_int_d_hall_e_labs)
	(sleep 30)
	(wake ini_int_d_hall_f_labs)

;	(wake ini_interior_c_cleanup)

	(sleep_until (or (volume_test_objects int_b_hall_f_trigger (players))
				  (volume_test_objects int_b_hall_f_trigger_b (players))))
	(game_save_no_timeout)
   (mcc_mission_segment "14_b_hall_f")
	(wake enc_int_d_lab_d_flood)
	(sleep 30)
	(wake ini_int_d_hall_g_labs)

	(sleep_until (or (volume_test_objects int_b_hall_g_trigger (players))
				  (volume_test_objects int_b_hall_g_trigger_b (players))))
	(if (not (game_is_cooperative)) (begin (object_destroy last_door_a) (object_create last_bashed_a) (device_set_position_immediate last_bashed_a .4)))
	(game_save_no_timeout)
   (mcc_mission_segment "15_b_hall_g")
	(wake enc_int_d_bay_c_flood)
	(set play_music_c10_06 true)
	(sleep 30)
;	(wake ini_interior_d_cleanup)
	
	(sleep_until (= (device_get_position bridge_e) 1))
	(game_save_no_timeout)
   (mcc_mission_segment "16_bridge_e")
	(ai_place int_d_flood/lift_d_rush)
	(set play_music_c10_06_alt true)

	(sleep_until (volume_test_objects int_b_lift_d_trigger (players)) 1)
	(game_save_no_timeout)
   (mcc_mission_segment "17_lift_d")
	(ai_magically_see_players int_d_flood/lift_d_rush)
	(wake enc_int_d_lift_d_flood)

	(sleep_until (!= (device_get_position lift_d) 1) 1)
	(game_save_no_timeout)
   (mcc_mission_segment "17_lift_d_use")
	(set play_music_c10_06 false)
	)
	
	
(script dormant mission_swamp_b
;	(ini_interior_b_cleanup)
	(wake enc_swamp_b_flood_ini)
	(wake swamp_b_save)
	(wake ini_swamp_b_marines)
	(game_save_no_timeout)
   (mcc_mission_segment "18_swamp_b")

	(ai_conversation swamp_b_pilot)
	
	(sleep_until (volume_test_objects swamp_b_trigger_a1 (players)))
	(game_save_no_timeout)
	(wake ini_swamp_b_flood_emitter)
	(set swamp_b_player_locator 1)
	
	(cond
		((= (game_difficulty_get) normal) (set swamp_b_limiter 1) (set swamp_b_infection_limiter 6))
		((= (game_difficulty_get) hard) (set swamp_b_limiter 1) (set swamp_b_infection_limiter 3))
		((= (game_difficulty_get) impossible) (set swamp_b_limiter 2) (set swamp_b_infection_limiter 0)))
	
	(sleep_until (volume_test_objects swamp_b_trigger_a2 (players)))
	(ai_magically_see_players swamp_b_flood)
	(ai_magically_see_players swamp_b_infection)
				  
	(sleep_until (volume_test_objects swamp_b_trigger_b (players)))
	(wake enc_swamp_b_flood_gauntlet)
	(ai_attack swamp_b_flood/flood_initial)
	
	(sleep_until (volume_test_objects swamp_b_trigger_c (players)))
	(wake enc_swamp_b_flood_tower)
	
	(sleep_until (volume_test_objects monitor_trigger (players)))
	(wake enc_swamp_b_sentinels)
;	(set play_music_c10_07 false)
	(sleep (* 30 2))
	(ai_place swamp_b_flood/last_wave)
	(ai_magically_see_players swamp_b_flood)
	(ai_magically_see_encounter swamp_b_sentinels swamp_b_flood)
	(sleep 150)
	(set play_music_c10_07 false)

	(sleep_until (or (not (or (volume_test_objects swamp_b_trigger_f (players))
						 (volume_test_objects swamp_b_trigger_c (players))
						 (volume_test_objects swamp_b_trigger_d (players))
						 (volume_test_objects swamp_b_trigger_e (players))))
				  (= (ai_living_count swamp_b_sentinels) 0)
				  (< (ai_living_count swamp_b_flood/last_wave) 2)
				  (< (unit_get_health (player0)) .25)) 1 (* 90 30))
	(if (or (!= (game_difficulty_get) normal) (game_is_cooperative))
		(sleep_until (or (= (ai_living_count swamp_b_sentinels) 0)
					  (< (ai_living_count swamp_b_flood/last_wave) 2))))
	(sleep (* 8 30))
	(ai_disregard (players) true)
	(wake chapter_friends)
   
   (if (mcc_mission_segment "cine3_final") (sleep 1))              
   
	(if (cinematic_skip_start) (cutscene_extraction))
	(cinematic_skip_stop)
	(game_won)
	)
	
;========== Kill All Continuous Scripts ==========

(script dormant kill_all_continuous
	(sleep -1 ini_swamp_b_flood_emitter)
	(sleep -1 ini_flood_prefer_sentinels)
;	(sleep -1 ini_dropship_check)
;	(sleep -1 ini_control_flood_wave)
	(sleep -1 swamp_b_save)
;	(sleep -1 ini_interior_c_cleanup)
;	(sleep -1 ini_interior_d_cleanup)
	)

;*
(script static void int_a
	(fade_out 0 0 0 0)
	(sleep 1)
	
	(deactivate_team_nav_point_object player crashed_dropship)
	(ai_allegiance_remove player flood)
	(ai_allegiance_remove flood player)
	
	(player_enable_input false)
	(print "switching bsp...")
	(sleep 30)
	(switch_bsp 1)
	(print "teleporting players...")
	(volume_teleport_players_not_inside null interior_a_teleport)
	(fade_in 0 0 0 (* 30 5))
	(print "initializing area scripts...")
	(sleep 15)
	(wake mission_int_a)
	(sleep 15)
	(player_enable_input true)
	
	(sleep_until (volume_test_objects int_b_trigger (players)))
	(wake mission_int_b)

	(sleep_until (volume_test_objects swamp_b_trigger (players)))
	(wake mission_swamp_b))

(script static void int_b
	(fade_out 0 0 0 0)
	(sleep 1)
	
	(deactivate_team_nav_point_object player crashed_dropship)

	(ai_allegiance_remove player flood)
	(ai_allegiance_remove flood player)

	(player_enable_input false)
	(print "switching bsp...")
	(sleep 30)
	(switch_bsp 3)
	(print "teleporting players...")
	(volume_teleport_players_not_inside null interior_b_teleport)
	(fade_in 0 0 0 (* 30 5))
	(print "initializing area scripts...")
	(sleep 15)
	(wake mission_int_b)
	(sleep 15)
	(player_enable_input true)

	(sleep_until (volume_test_objects swamp_b_trigger (players)))
	(wake mission_swamp_b))

(script static void swamp_b
	(fade_out 0 0 0 0)
	(sleep 1)

	(deactivate_team_nav_point_object player crashed_dropship)
	
	(ai_allegiance_remove player flood)
	(ai_allegiance_remove flood player)
	
	(player_enable_input false)
	(print "switching bsp...")
	(sleep 30)
	(switch_bsp 5)
	(print "teleporting players...")
	(volume_teleport_players_not_inside null swamp_b_teleport)
	(fade_in 0 0 0 (* 30 5))
	(print "initializing area scripts...")
	(sleep 15)
	(wake mission_swamp_b)
	(sleep 15)
	(player_enable_input true))
*;

;========== Main Script ==========

(script startup mission_c10
	(wake kill_all_continuous)
	(fade_out 0 0 0 0)
	(ai_allegiance player sentinel)
	(ai_allegiance human sentinel)
	(ai_allegiance player human)
	(ai_allegiance player flood)
	(if (or (game_is_cooperative) (= (game_difficulty_get) impossible)) (begin (object_destroy_containing shotgun) (object_create_containing arc10)))
	(if (and (not (game_is_cooperative)) (= (game_difficulty_get_real) easy)) (object_create_containing easy))
   
   (if (mcc_mission_segment "cine1_intro") (sleep 1))              
   
	(wake insertion)
	(wake mission_swamp_a)
	
	(sleep_until (volume_test_objects int_a_trigger (players)) 5)
	(ai_allegiance_remove player flood)
	(wake mission_int_a)
	(wake mission_control)

	(sleep_until (volume_test_objects int_b_trigger (players)) 5)
	(wake mission_int_b)

	(sleep_until (volume_test_objects killitall (players)) 1)
	(ai_erase_all)

	(sleep_until (= (structure_bsp_index) 5) 1)
	(sleep 10)
	(wake mission_swamp_b)
	)
