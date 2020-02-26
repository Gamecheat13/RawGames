;04a_GASGIANT!
;-------------------------------------------------------------------------------

(script stub void c04_intro
	(print "hi, joe")
)
(script stub void X04
	(print "hi, joe")
)


;-------------------------------------------------------------------------------
;temp

;Used to make AI aware of each other when active camo supposed to drop
(script continuous active_camo_drop
	(sleep_until 
		(OR
			(> (ai_combat_status rec_center_heretics) ai_combat_status_uninspected)
			(> (ai_combat_status hangar_heretics) ai_combat_status_uninspected)
			(> (ai_combat_status first_hall_heretics) ai_combat_status_uninspected)
			(> (ai_combat_status underhangar_heretics) ai_combat_status_uninspected)
			(> (ai_combat_status second_hall_heretics) ai_combat_status_uninspected)
			(> (ai_combat_status bottling_heretics) ai_combat_status_uninspected)
		)
	)
	(ai_set_active_camo arm01_allies FALSE)
	(ai_set_blind all_enemies FALSE)
)


;-------------------------------------------------------------------------------
;Global Scripts

;Used to abort an AI out of a command script manually
(script command_script abort
	(cs_pause .1)
)

;Used to make an AI stand around and do nothing until alerted
(script command_script long_pause
	(cs_abort_on_alert TRUE)
	(sleep_forever)
)
(script command_script forever_pause
	(cs_pause -1)
)

;Used to make an AI become alert without forcing combat status in order
(script command_script snap_alert
	(cs_force_combat_status 4)
	(sleep 5)
;	(cs_shoot TRUE)
;	(cs_enable_targeting TRUE)
;	(cs_enable_moving TRUE)
;	(sleep_forever)
)

;Faked combat dialogue for stealth on allies
(global boolean stealth_talk_gone FALSE)
(script command_script stealth_comment_01
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'Quietly now!'")
	(cs_play_line 1020)
)
(script command_script stealth_comment_02
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'With stealth!'")
	(cs_play_line 1030)
)
(script command_script stealth_comment_03
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'Camouflage engaged!'")
	(cs_play_line 1040)
)
(script command_script stealth_comment_04
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'An honorable ruse!'")
	(cs_play_line 1050)
)
(script command_script stealth_comment_05
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'They shall not see me coming!'")
	(cs_play_line 1060)
)
(script command_script stealth_comment_06
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'I'm invisible!'")
	(cs_play_line 1070)
)
(script command_script stealth_comment_07
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'No one see me now!'")
	(cs_play_line 1080)
)
(script command_script stealth_comment_08
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'Tricky-tricky!'")
	(cs_play_line 1090)
)
(script command_script stealth_comment_09
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'Where me gun go? Oh, right! (laughs)'")
	(cs_play_line 1100)
)
(script command_script stealth_comment_10
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: '(a la Elmer Fudd) Shhhh! Me hunting He-wa-tics!'")
	(cs_play_line 1110)
)
(script static void stealth_comment
	(sleep (random_range 10 60))
	(begin_random
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_01_scene stealth_comment_01 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_02_scene stealth_comment_02 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_03_scene stealth_comment_03 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_04_scene stealth_comment_04 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_05_scene stealth_comment_05 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_06_scene stealth_comment_06 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_07_scene stealth_comment_07 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_08_scene stealth_comment_08 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_09_scene stealth_comment_09 all_allies)
			)
		)
		(if (= stealth_talk_gone TRUE)
			(begin
				(set stealth_talk_gone FALSE)
				(ai_scene stealth_comment_10_scene stealth_comment_10 all_allies)
			)
		)
	)
)

;-------------------------------------------------------------------------------
;Chapter Titles

;"A Whisper in the Storm"
(script dormant 04a_title0
	(cinematic_fade_from_white_bars)
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)

;"To the Hunt"
(script dormant 04a_title1
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)


;-------------------------------------------------------------------------------
;Objectives

(script dormant objective_hl_set
            (sleep 30)
            (print "new objective set:")
            (print "Locate the Heretic Leader.")
            (objectives_show_up_to 0)
)
(script dormant objective_hl_clear
            (print "objective complete:")
            (print "Locate the Heretic Leader.")
            (objectives_finish_up_to 0)
)

(script dormant objective_dogfight_set
            (sleep 30)
            (print "new objective set:")
            (print "Pursue the Heretic Leader. Neutralize enemy air units.")
            (objectives_show_up_to 1)
)
(script dormant objective_dogfight_clear
            (print "objective complete:")
            (print "Pursue the Heretic Leader. Neutralize enemy air units.")
            (objectives_finish_up_to 1)
)


;-------------------------------------------------------------------------------
;Music

(script dormant music_04a_01_start
	;push evelvator button to hangar
	(print "music 04a_01 start")
	(sound_looping_start "scenarios\solo\04a_gasgiant\04a_music\04a_01" none 1.0)
)

(script dormant music_04a_01_stop
	;when reinforcement phantom leaves
	(print "music 04a_01 stop")
	(sound_looping_stop "scenarios\solo\04a_gasgiant\04a_music\04a_01")
)

(script dormant music_04a_02_start
	;at first big room under the hangar
	(print "music 04a_02 start")
	(sound_looping_start "scenarios\solo\04a_gasgiant\04a_music\04a_02" none 1.0)
)

(script dormant music_04a_02_stop
	;stop at checkpoint after that encounter or get thru back door
	(print "music 04a_02 stop")
	(sound_looping_stop "scenarios\solo\04a_gasgiant\04a_music\04a_02")
)

(script dormant music_04a_03_start
	;when heretic leader flies away
	(print "music 04a_03 start")
	(sound_looping_start "scenarios\solo\04a_gasgiant\04a_music\04a_03" none 1.0)
)

(script dormant music_04a_04_start
	;when you get in banshee
	(print "music 04a_04 start")
	(sound_looping_start "scenarios\solo\04a_gasgiant\04a_music\04a_04" none 1.0)
)

(script dormant music_04a_04_stop
	;at end of first big massive dogfight (or something)
	(sleep_until
		(OR
			(= (volume_test_objects vol_dog_obj_04 (players)) TRUE)
			(= (volume_test_objects vol_dog_obj_07 (players)) TRUE)
		)
	30 8000)
	(print "music 04a_04 stop")
	(sound_looping_stop "scenarios\solo\04a_gasgiant\04a_music\04a_04")
)


;-------------------------------------------------------------------------------
;Kill Volumes

;so much simpler
(script dormant kill_volumes
	(kill_volume_disable kill_banshee_ledge)
	(kill_volume_disable kill_recycling_pit)
	(kill_volume_disable kill_recycling_left)
	(kill_volume_disable kill_recycling_right)						
	(kill_volume_disable kill_hangar_pit_01)
	(kill_volume_disable kill_hangar_pit_02)
	(kill_volume_disable kill_hangar_pit_03)
	(kill_volume_disable kill_hangar_pit_04)
	(kill_volume_disable kill_underhangar_pit_01)
	(kill_volume_disable kill_underhangar_pit_02)
	(kill_volume_disable kill_bottling_pit_01)
	(kill_volume_disable kill_bottling_pit_02)

	(sleep_until (= (structure_bsp_index) 3))
	(kill_volume_disable kill_lz_pit)

	(sleep_until
		(begin			
			(sleep_until (= (structure_bsp_index) 3))
			(kill_volume_enable kill_recycling_pit)
			(kill_volume_enable kill_recycling_left)
			(kill_volume_enable kill_recycling_right)						
			(kill_volume_enable kill_hangar_pit_01)
			(kill_volume_enable kill_hangar_pit_02)
			(kill_volume_enable kill_hangar_pit_03)
			(kill_volume_enable kill_hangar_pit_04)
			(kill_volume_enable kill_underhangar_pit_01)
			(kill_volume_enable kill_underhangar_pit_02)
			
			(kill_volume_disable kill_bottling_pit_01)
			(kill_volume_disable kill_bottling_pit_02)

			(sleep_until (= (structure_bsp_index) 0))
			(kill_volume_enable kill_banshee_ledge)
			(kill_volume_enable kill_bottling_pit_01)
			(kill_volume_enable kill_bottling_pit_02)

			(kill_volume_disable kill_recycling_pit)
			(kill_volume_disable kill_recycling_left)
			(kill_volume_disable kill_recycling_right)						
			(kill_volume_disable kill_hangar_pit_01)
			(kill_volume_disable kill_hangar_pit_02)
			(kill_volume_disable kill_hangar_pit_03)
			(kill_volume_disable kill_hangar_pit_04)
			(kill_volume_disable kill_underhangar_pit_01)
			(kill_volume_disable kill_underhangar_pit_02)
			
			FALSE
		)
	)
)


;-------------------------------------------------------------------------------
;Initializing start of mission

;Sets up everything to match with the end of the intro
(script static void prep_return_from_intro
	(ai_place intro_phantom)

	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)

	(ai_place intro_elites)
	(ai_place allies_elites_01)
	(ai_place hacker)
	(ai_place allies_grunts_01)
)


;-------------------------------------------------------------------------------
;Rooftop

(script dormant wind
	(sleep_until
		(begin
			(sound_impulse_start sound\ambience\sound_scenery\gusty_wind\details\gusty_wind NONE 1)
			(sleep 30)
			(player_effect_set_max_rotation (real_random_range .1 1) (real_random_range .1 1) 0)
			(player_effect_start (real_random_range .05 .2) (real_random_range .5 2))
			(player_effect_stop (real_random_range 3 5))
			(sleep (random_range 300 600))
			(= (structure_bsp_index) 3)
		)
	)
)
(script static void windtoo
	(sleep_until
		(begin
			(sound_impulse_start sound\ambience\sound_scenery\gusty_wind\details\gusty_wind NONE 1)
			(sleep 30)
			(player_effect_set_max_rotation (real_random_range .1 1) (real_random_range .1 1) 0)
			(player_effect_start (real_random_range .05 .2) (real_random_range .5 2))
			(player_effect_stop (real_random_range 3 5))
			(sleep (random_range 300 600))
			(= (structure_bsp_index) 3)
		)
	)
)

;Phantoms boost away
(script command_script lz_phantom_01_away
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_to airspace_lz/exit01 20)
	(ai_erase ai_current_actor)
)
(script command_script lz_phantom_02_away
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_to airspace_lz/exit02 20)
	(ai_erase ai_current_actor)
)
(script command_script lz_phantom_03_away
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)
	(cs_fly_to airspace_lz/exit03 20)
	(ai_erase ai_current_actor)
)

;Reminder to get your ass inside
(script dormant commander_entry_reminder
	(sleep_until (= (volume_test_objects vol_entering_facility (players)) TRUE) 30 900)
	(if 
		(AND
			(= (volume_test_objects vol_entering_facility (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "SPEC-OPS COMMANDER: 'My warriors are in position, Arbiter. They wait for you to lead them!'")
				(sleep (ai_play_line_on_object NONE 0970))
				;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_0970_soc))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

(global boolean stealth_hint_done FALSE)
(global boolean first_airlock_go FALSE)

;Commander says to use your stealth armor
(script dormant commander_comment_03
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'You may wish to do the same, Arbiter.'")
	(sleep (ai_play_line_on_object NONE 1000))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_1000_soc))
	(sleep 30)
	;(hud_set_training_text training_stealth)
	;(hud_show_training_text 1)
	(print "'But, take heed. Your armor's system is not as…new as ours. Your camouflage will not last forever.'")
	(sleep (ai_play_line_on_object NONE 1010))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_1010_soc))
	;(hud_show_training_text 0)
	(set stealth_hint_done TRUE)
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Ally calls for active camo
(script command_script lz_active_camo_call
	(set first_airlock_go TRUE)
	(cs_switch ally)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	;(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'Engage active camouflage! Reveal yourselves only after the Arbiter has joined battle with the enemy!'")
	(cs_play_line 0980)
	(sleep 30)
	(ai_set_orders all_allies allies_rec_hide)
	(sleep 60)
	(wake commander_comment_03)
	(object_can_take_damage (ai_get_object ai_current_actor))
)

;Positions allies inside entrance
(script command_script inner_aim_elites
	(cs_abort_on_damage TRUE)
	(cs_enable_moving TRUE)
	(cs_crouch TRUE)
	
	(sleep_until (= (volume_test_object vol_entering_facility (ai_get_object ai_current_actor)) TRUE)) 
	(cs_aim TRUE recycling_center/rec_center_inner)
	(cs_crouch FALSE)
	
	(sleep_until (= (structure_bsp_index) 3))
	(cs_enable_moving FALSE)

	(sleep_until (> (device_get_position rec_center_entry_int) 0))
	(cs_aim FALSE recycling_center/rec_center_inner)
)
(script command_script inner_aim_hacker
	(cs_abort_on_damage TRUE)
	(cs_enable_moving TRUE)
	
	(sleep_until (= (volume_test_object vol_entering_facility (ai_get_object ai_current_actor)) TRUE)) 
	(cs_aim TRUE recycling_center/rec_center_inner)
	
	(sleep_until (= (structure_bsp_index) 3))
	(cs_enable_moving FALSE)

	(sleep_until (> (device_get_position rec_center_entry_int) 0))
	(cs_aim FALSE recycling_center/rec_center_inner)
)
(script command_script inner_aim_grunts
	(cs_abort_on_damage TRUE)
	
	(sleep 60)
	(cs_enable_moving TRUE)
	
	(sleep_until (= (volume_test_object vol_entering_facility (ai_get_object ai_current_actor)) TRUE)) 
	(cs_aim TRUE recycling_center/rec_center_inner)

	(sleep_until (= (structure_bsp_index) 3))
	(cs_enable_moving FALSE)

	(sleep_until (> (device_get_position rec_center_entry_int) 0))
	(cs_aim FALSE recycling_center/rec_center_inner)
)

;Airlock BSP swap
(script dormant production_arm_bsp_swap
	(device_operates_automatically_set rec_center_entry_ext TRUE)
	(cs_run_command_script allies_elites_01 inner_aim_elites)
	(cs_run_command_script allies_grunts_01 inner_aim_grunts)
	(ai_set_orders allies_elites_01 allies_enter)
	(ai_set_orders allies_grunts_01 allies_enter)
	(ai_set_orders intro_elites lz_linger)
	(wake commander_entry_reminder)
		
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_entering_facility (players)) TRUE)
			(> (player_count) 0)
		)
	)
	(cs_run_command_script hacker inner_aim_hacker)
	(ai_set_orders hacker allies_enter)
	(sleep_forever wind)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_entering_facility (players)) TRUE)
			(> (player_count) 0)
			(= (device_get_position rec_center_entry_ext) 0)
;			(OR
;				(= (volume_test_objects_all vol_entering_facility (ai_actors arm01_allies)) TRUE)
;				(< (ai_living_count arm01_allies) 1)
;			)
		)
	)
	(device_operates_automatically_set rec_center_entry_ext FALSE)
	(sleep 30)
	
	(sound_class_set_gain ambient_machinery 0 2)
	(begin_random
		(begin
			(object_create_anew gas01)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas02)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas03)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas04)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas05)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas06)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas07)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas08)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas09)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create_anew gas10)
			(sleep (random_range 5 15))
		)
	)
	(switch_bsp 3)
	(sleep_until (= (structure_bsp_index) 3))
	
	(object_destroy filthy_audio1)
	(object_destroy filthy_audio2)
	(sound_class_set_gain ambient_machinery 1 2)
	
	(sleep_until 
		(OR
			(ai_scene lz_active_camo_scene lz_active_camo_call all_allies)
			(AND
				(< (ai_living_count hacker) 0)
				(< (ai_living_count allies_elites_01) 1)
			)
		)
	30 150)
	(begin_random
		(begin
			(object_destroy gas01)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas02)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas03)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas04)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas05)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas06)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas07)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas08)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas09)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas10)
			(sleep (random_range 5 15))
		)
	)
	(player_training_activate_stealth)
	
	(if (= first_airlock_go TRUE)	
		(sleep_until (= stealth_hint_done TRUE) 30 900)
	)
	(device_operates_automatically_set rec_center_entry_int TRUE)
)

;Used to determine when scripted guy has hacked into the door and unlocked it 
(global boolean open_rec_center FALSE)

;To tell when the commander is done talking, so the elites can move
(global boolean commander_done_yapping FALSE)

;Spec-ops commander radios you as he takes off
(script dormant commander_comment_01
	(sleep 60)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'We are the arm of the Prophets, Dervish, and you are the blade!'")
	(sleep (ai_play_line_on_object NONE 0210))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_0210_soc))
	(sleep 30)
	(print "'Be silent and swift, and we will quell this heresy without incident!'")
	(sleep (ai_play_line_on_object NONE 0220))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_0220_soc))
	(sleep 15)
	(set commander_done_yapping TRUE)
	(sleep 30)
;	(ai_dialogue_enable TRUE)
)
(script dormant commander_comment_02
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'The storm has masked our approach.'")
	(sleep (ai_play_line_on_object NONE 0240))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_0240_soc))
	(sleep 30)
	(print "SPEC-OPS COMMANDER: 'And it should have their local battle-net in disarray.'")
	(sleep (ai_play_line_on_object NONE 0250))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_0250_soc))
	(sleep 30)
	(print "SPEC-OPS COMMANDER: 'We have the element of surprise.  For now.'")
	(sleep (ai_play_line_on_object NONE 0260))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_0260_soc))
	(unit_stop_custom_animation (unit (list_get (ai_actors hacker) 0)))
	(set open_rec_center TRUE) 
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Takes phantom on path away from LZ, into hiding, and then deletes it
(script command_script lz_phantom_leaves
;	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_vehicle_speed .5)
	(cs_fly_by airspace_lz/p0 10)
	(cs_fly_by airspace_lz/p1 10)
	(cs_fly_by airspace_lz/p2 10)
	(cs_fly_by airspace_lz/p3 10)
	(cs_fly_by airspace_lz/p4 10)
	(cs_fly_by airspace_lz/p5 10)
	(cs_fly_to airspace_lz/p6 10)
	(ai_erase intro_phantom)
)

;LZ scene!
(script command_script landing_zone_follow_01
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to landing_zone/ramp01)
	(cs_face_player TRUE)
	(sleep_until (= (volume_test_objects vol_leaving_lz (players)) TRUE))	
	(cs_face_player FALSE)
)
(script command_script landing_zone_follow_02
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to landing_zone/ramp02)
	(cs_face_player TRUE)

	(sleep_until (= (volume_test_objects vol_leaving_lz (players)) TRUE))	
	(cs_face_player FALSE)
	(cs_suppress_dialogue_global TRUE)
	(if (= commander_done_yapping TRUE)
		(begin
			(print "SPEC-OPS ELITE: 'First lance in position!'")
			(cs_play_line 0230)
		)
	)
)

;Tells elite to hack the door until the player arrives
(script command_script SWAT_hack
	(cs_abort_on_damage TRUE)
	(cs_aim TRUE landing_zone/control)
	(sleep_until 
		(OR
			(= (device_get_position rec_center_entry_ext) 1)
			(= (volume_test_objects vol_entering_facility (players)) TRUE)
		)
	)
	(cs_aim FALSE landing_zone/control)
)

;Positions allies outside entrance
(script command_script SWAT_aim
	(cs_abort_on_damage TRUE)
	(cs_aim TRUE landing_zone/entry)
	(sleep_until 
		(OR
			(= (device_get_position rec_center_entry_ext) 1)
			(= (volume_test_objects vol_entering_facility (players)) TRUE)
		)
	)
	(cs_aim FALSE landing_zone/entry)
)

;Overall script for deployment
(script dormant SWAT_deploy
	(data_mine_set_mission_segment "04a_1_landing_zone")
	(wake wind)
	(wake commander_comment_01)
	;(ai_scene lz_scene landing_zone_follow intro_elites) 
	(cs_run_command_script intro_elites/01 landing_zone_follow_01)	
	(cs_run_command_script intro_elites/02 landing_zone_follow_02)	
	(custom_animation_loop (unit (list_get (ai_actors hacker) 0)) objects\characters\elite\elite "uplink_station" TRUE)
	(cs_run_command_script hacker SWAT_hack)
	(cs_run_command_script intro_phantom/01 lz_phantom_01_away)	
	(cs_run_command_script intro_phantom/02 lz_phantom_02_away)	
	(cs_run_command_script intro_phantom/03 lz_phantom_03_away)	
	(cs_run_command_script allies_grunts_01 SWAT_aim)
	(cs_run_command_script allies_elites_01 SWAT_aim)

	(sleep_until (= (volume_test_objects vol_entry_landing (players)) TRUE))
	(sleep_until (= commander_done_yapping TRUE))	
	(wake commander_comment_02)

	(sleep_until 
		(OR 
			(= open_rec_center TRUE) 
			(<= (object_get_health (list_get (ai_actors hacker) 0)) 0)
		)
	30 360)
	(wake production_arm_bsp_swap)

	(sleep_until 
		(OR
			(= (volume_test_objects_all vol_phantom_kill (ai_actors intro_phantom)) TRUE)
			(AND
				(= (volume_test_objects_all vol_recycling_all (players)) TRUE)
				(> (player_count) 0)
			)
		)
	)
	(ai_erase intro_phantom)
	
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_recycling_all (players)) TRUE)
			(> (player_count) 0)
		)
	)	
	(ai_erase intro_elites)
)


;-------------------------------------------------------------------------------
;Recycling Plant

;Temp variables for controlling conveyors
(global short recycling_time 300)
(global boolean recycling_power_on FALSE)

;Spawns cans randomly on lines A, B, and C
(script dormant recycling_can_spawner
	(object_set_deleted_when_deactivated rec_can_a_01)
	(object_set_deleted_when_deactivated rec_can_a_02)
	(object_set_deleted_when_deactivated rec_can_a_03)
	(object_set_deleted_when_deactivated rec_can_a_04)
;	(object_set_deleted_when_deactivated rec_can_a_05)
	(object_set_deleted_when_deactivated rec_can_a_06)
	(object_set_deleted_when_deactivated rec_can_a_07)
	(object_set_deleted_when_deactivated rec_can_b_01)
	(object_set_deleted_when_deactivated rec_can_b_02)
	(object_set_deleted_when_deactivated rec_can_c_01)
	(object_set_deleted_when_deactivated rec_can_c_02)
	(object_set_deleted_when_deactivated rec_can_c_03)
	(object_set_deleted_when_deactivated rec_can_c_04)
;	(object_set_deleted_when_deactivated rec_can_c_05)
	(object_set_deleted_when_deactivated rec_can_c_06)
	
	(sleep_until (= recycling_power_on TRUE))
	(sleep_until
		(begin
			(begin_random
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_recycling_can_all 2048)) 20)
						(begin
							(object_create_clone recycling_can_A)
							(object_set_deleted_when_deactivated recycling_can_A)
						)
					)
					(sleep recycling_time)
				)
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_recycling_can_all 2048)) 20)
						(begin
							(object_create_clone recycling_can_B)
							(object_set_deleted_when_deactivated recycling_can_B)
						)
					)
					(sleep recycling_time)
				)
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_recycling_can_all 2048)) 20)
						(begin
							(object_create_clone recycling_can_C)
							(object_set_deleted_when_deactivated recycling_can_C)
						)
					)
					(sleep recycling_time)
				)
			)
			(= recycling_power_on FALSE)
		)
	)
)

;Kills crates and characters dropped into pits
(script dormant recycling_killer_new
	(sleep_until (= recycling_power_on TRUE))
	(sleep_until
		(begin
			(object_destroy (list_get (volume_return_objects kill_recycling_pit) 0))
			(sleep 30)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_recycling_pit 1) 0)))
			(sleep 30)
			(= recycling_power_on FALSE)
		)
	)
)

;Heretic conversation scene!
(global object chatter_her_01 none)
(global object chatter_her_02 none)
(script command_script heretic_chat
	(cs_switch chat_her_02)
	(cs_abort_on_alert TRUE)
	(set chatter_her_02 (ai_get_object ai_current_actor))
	(cs_enable_moving TRUE)

	(cs_switch chat_her_01)
	(cs_abort_on_alert TRUE)
	(set chatter_her_01 (ai_get_object ai_current_actor))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_and_face recycling_center/p0 recycling_center/p1)
	(cs_custom_animation objects\characters\elite\elite "uplink_station" 0 TRUE)
	(custom_animation_loop (unit (ai_get_object ai_current_actor)) objects\characters\elite\elite "uplink_station" TRUE)

	(cs_switch chat_her_02)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_approach chatter_her_01 2 20 20)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC_01: 'Any word on our missing brothers?'")
	(cs_play_line 0270)

	(cs_switch chat_her_01)
	(unit_stop_custom_animation (unit (ai_get_object ai_current_actor)))
	(cs_face FALSE recycling_center/p1)
	(cs_approach chatter_her_02 1.5 20 20)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC_02: 'Still nothing.'")
	(cs_play_line 0280)
	(sleep 30)
	(print "HERETIC_02: 'And given what sleeps here, I fear they are lost.'")
	(cs_play_line 0290)
	(sleep 15)

	(cs_switch chat_her_02)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC_01: 'Surely the Oracle will protect us?'")
	(cs_play_line 0300)
	(sleep 15)
	
	(cs_switch chat_her_01)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC_02: 'Perhaps. But I fear its Sentinels are too few.'")
	(cs_play_line 0310)
	(sleep 15)
	(print "HERETIC_02: 'Better we protect ourselves.'")
	(cs_play_line 0320)
	(sleep 30)
	(cs_run_command_script rec_center_heretic_02 abort)
	(cs_approach_stop)
	(sleep 60)
	(cs_enable_moving TRUE)
	
;	(cs_switch chat_her_02)
;	(cs_approach_stop)
;	(sleep 30)
)

;Makes this heretic play uplink animation until alerted
(script dormant heretic_uplink_01
	(custom_animation_loop (unit (list_get (ai_actors rec_center_heretic_03) 0)) objects\characters\elite\elite "uplink_station" TRUE)
	(sleep_until (> (ai_combat_status rec_center_heretic_03) ai_combat_status_idle))
	(unit_stop_custom_animation (unit (list_get (ai_actors rec_center_heretic_03) 0)))
)

;Reminder to go down below
(script dormant rec_center_reminder
	(sleep_until (= (volume_test_objects vol_leaving_rec_center (players)) TRUE) 30 3600)
	(if 
		(AND
			(= (volume_test_objects vol_leaving_rec_center (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "SPEC-OPS COMMANDER: 'There should be a hangar directly below you. Find a way down!'")
				(sleep (ai_play_line_on_object NONE 1130))
				;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_1130_soc))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;gets guys on elevator
(script command_script get_on_e1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to recycling_center/e1)
)
(script command_script get_on_e2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to recycling_center/e2)
)
(script command_script get_on_g1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to recycling_center/g1)
)
(script command_script get_on_g2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to recycling_center/g2)
)

;tells grunt to deploy his turret
(script command_script rec_center_turret
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to rec_cen_turret/go_here)
	(cs_deploy_turret rec_cen_turret/p1)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)

;Overall script for recycling center
(script dormant recycling_center_start
	(sleep_until (= (structure_bsp_index) 3))
	(data_mine_set_mission_segment "04a_2_recycling_center")
	(object_create_containing "rec_can_")
	(wake recycling_can_spawner)
	(wake recycling_killer_new)
	(set recycling_power_on TRUE)
	(ai_place rec_center_heretic_01 1)
	(ai_place rec_center_heretic_02 1)
	(cs_run_command_script rec_center_heretic_02 long_pause)
	(ai_place rec_center_grunts_01 2)

	(sleep_until (= stealth_hint_done TRUE))
	(game_save)

	(sleep_until (> (device_get_position rec_center_entry_int) 0))
	(sleep_until (= (device_get_position rec_center_entry_int) 1))
	(ai_scene heretic_chat_scene heretic_chat rec_center_h_entry)
	(ai_set_orders arm01_allies allies_rec_center_all)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_rec_slope_top (players)) TRUE)
			(< (ai_living_count rec_center_heretics) 2)
		)
	)
	(game_save)
	(ai_place rec_center_grunts_02R 2)
	(ai_place rec_center_grunts_02L 2)
	(if (> (ai_combat_status rec_center_heretics) ai_combat_status_idle)
		(begin
			(if (objects_can_see_object (players) rec_cen_rein_01r 45)
				(begin
					(if (< (ai_living_count rec_center_heretics) 8)
						(ai_place rec_cen_rein_her_01R 1)
					)
					(cs_run_command_script rec_cen_rein_her_01R snap_alert)
					(if (< (ai_living_count rec_center_heretics) 8)
						(ai_place rec_cen_rein_grt_01R (random_range 1 3))
					)
					(cs_run_command_script rec_cen_rein_grt_01R snap_alert)
				)
			)
			(if (objects_can_see_object (players) rec_cen_rein_01l 45)
				(begin
					(if (< (ai_living_count rec_center_heretics) 8)
						(ai_place rec_cen_rein_her_01L (- 1 (ai_living_count rec_cen_rein_her_01R)))
					)
					(cs_run_command_script rec_cen_rein_her_01L snap_alert)
					(if (< (ai_living_count rec_center_heretics) 8)
						(ai_place rec_cen_rein_grt_01L (- (random_range 1 3) (ai_living_count rec_cen_rein_grt_01R)))
					)
					(cs_run_command_script rec_cen_rein_grt_01L snap_alert)
				)
			)
		)
	)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_recycling_mid_01 (players)) TRUE)
			(< (ai_living_count rec_center_heretics) 3)
		)
	)
	(game_save)
	(cs_run_command_script allies_grunts_01/grunt02 rec_center_turret)
	(if (< (ai_living_count rec_center_heretics) 8)
		(ai_place rec_center_grunts_03 3)
	)
	(if (< (ai_living_count rec_center_heretics) 8)
		(ai_place rec_center_heretic_03 2)
	)
	(wake heretic_uplink_01)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_recycling_mid_02 (players)) TRUE)
			(< (ai_living_count rec_center_heretics) 3)
		)
	)	
	(game_save)
;	(ai_place rec_center_heretic_05)
;	(cs_run_command_script rec_center_heretic_05 long_pause)
;	(ai_place rec_center_grunts_05)
	(if (< (ai_living_count rec_center_heretics) 8)
		(ai_place rec_center_heretic_04 (- 1 (ai_living_count rec_center_heretic_03)))
	)
	(if (< (ai_living_count rec_center_heretics) 8)
		(ai_place rec_center_grunts_04 (- 3 (ai_living_count rec_center_grunts_03)))
	)
	(wake rec_center_reminder)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_leaving_rec_center (players)) TRUE)
			(= (ai_living_count rec_center_heretics) 0)
		)
	)
	(device_set_position_immediate elev_hangar .25)
	(cs_run_command_script allies_grunts_01/grunt02 abort)
	(ai_vehicle_exit allies_grunts_01) 

	(sleep_until (= (volume_test_objects vol_leaving_rec_center (players)) TRUE))
	(sleep_until (< (ai_combat_status all_enemies) ai_combat_status_uninspected) 30 150)
	(set stealth_talk_gone TRUE)
	(ai_set_orders arm01_allies allies_rec_center_under)
	(game_save)
	(if (< (ai_living_count rec_center_heretics) 8)
		(ai_place rec_center_grunts_06 4)
	)
			
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_hangar_lift_top (players)) TRUE)
			(< (ai_living_count rec_center_heretics) 3)
;			FALSE
		)
	)		
	(game_save)
;	(object_create elev_crate_01)
;	(object_create elev_crate_02)
	(if (< (ai_living_count rec_center_heretics) 8)
		(ai_place rec_center_heretic_06 1)
	)
	(if (< (ai_living_count rec_center_heretics) 8)
		(ai_place rec_center_grunts_07 3)
	)
	(device_set_position elev_hangar 0)
	
	(sleep_until (< (ai_living_count rec_center_heretics) 1) 30 1800)
	(sleep_until (= (game_safe_to_save) TRUE))
	(game_save)

;	(sleep_until (= (volume_test_objects vol_on_hangar_lift_top (players)) TRUE))
;	(sleep_until (< (ai_combat_status all_enemies) ai_combat_status_uninspected) 30 150)
	(ai_set_orders arm01_allies get_on_hangar_elev)
	(cs_run_command_script hacker get_on_e1)
	(cs_run_command_script allies_elites_01 get_on_e2)
	(cs_run_command_script allies_grunts_01/grunt01 get_on_g1)
	(cs_run_command_script allies_grunts_01/grunt02 get_on_g2)

;*	(sleep_until 
		(AND
			(= (volume_test_objects vol_on_hangar_lift_top (players)) TRUE)
			(OR 
				(= (volume_test_objects vol_on_hangar_lift_top (ai_actors allies_elites)) TRUE)
				(< (ai_living_count allies_elites) 1)
			)
		)
	)
	(ai_scene hangar_elevator_scene hangar_elevator arm01_allies)
*;
)


;-------------------------------------------------------------------------------
;Hangar

(script dormant hangar_extra_save
	(sleep_until (= (device_get_position elev_hangar) 1))
	(sleep_until (game_safe_to_save))
	(game_save)
)

;Temp variables for controlling conveyors
(global boolean hangar_power_on FALSE)

;Spawns cans randomly on lines A, B, and C
(script dormant hangar_can_spawner
	(sleep_until (= hangar_power_on TRUE))
	(sleep_until
		(begin
			(begin_random
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_hangar_can_all 2048)) 15)
						(begin
							(object_create_clone hangar_can_A)
						)
					)
					(sleep recycling_time)
				)
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_hangar_can_all 2048)) 15)
						(begin
							(object_create_clone hangar_can_B)
						)
					)
					(sleep recycling_time)
				)
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_hangar_can_all 2048)) 15)
						(begin
							(object_create_clone hangar_can_C)
						)
					)
					(sleep recycling_time)
				)
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_hangar_can_all 2048)) 15)
						(begin
							(object_create_clone hangar_can_D)
						)
					)
					(sleep recycling_time)
				)
			)
			(= hangar_power_on FALSE)
		)
	)
)

;Kills crates and characters dropped into pits
(script dormant hangar_killer_new
	(sleep_until (= hangar_power_on TRUE))
	(sleep_until
		(begin
			(object_destroy (list_get (volume_return_objects kill_hangar_pit_01) 0))
			(sleep 30)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_hangar_pit_01 1) 0)))
			(sleep 30)
			(object_destroy (list_get (volume_return_objects kill_hangar_pit_02) 0))
			(sleep 30)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_hangar_pit_02 1) 0)))
			(sleep 30)
			(object_destroy (list_get (volume_return_objects kill_hangar_pit_03) 0))
			(sleep 30)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_hangar_pit_03 1) 0)))
			(sleep 30)
			(object_destroy (list_get (volume_return_objects kill_hangar_pit_04) 0))
			(sleep 30)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_hangar_pit_04 1) 0)))
			(sleep 30)
			(= hangar_power_on FALSE)
		)
	)
)

;Command scripts for helper sentinels
(script command_script hangar_help_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(sleep 120)
	(objects_attach (list_get (ai_actors hangar_helper_01) 0) primary_trigger help_can_01 top)
	(cs_fly_by hangar/p0)
	(cs_fly_by hangar/p9)
	(cs_fly_to hangar/p8)
	(objects_detach (list_get (ai_actors hangar_helper_01) 0) help_can_01)
	(object_destroy help_can_01)
	(ai_erase hangar_helper_01)
)
(script command_script hangar_help_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by hangar/p7)
	(cs_fly_to hangar/p10)
	(objects_attach (list_get (ai_actors hangar_helper_02) 0) primary_trigger help_can_02 top)
	(cs_fly_by hangar/p0)
;	(cs_fly_by hangar/p9)
;	(cs_fly_to hangar/p8)
	(cs_fly_to hangar/p11)
	(objects_detach (list_get (ai_actors hangar_helper_02) 0) help_can_02)
;	(object_destroy help_can_02)
;	(cs_fly_to hangar/p9 2)
)
(script command_script hangar_help_03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_fly_to hangar/p3)
					(cs_shoot_point TRUE hangar/weld1)
					(sleep 90)
					(cs_shoot_point FALSE hangar/weld1)
				)
				(begin
					(cs_fly_to hangar/p4)
					(cs_shoot_point TRUE hangar/weld2)
					(sleep 90)
					(cs_shoot_point FALSE hangar/weld2)
				)
				(begin
					(cs_fly_to hangar/p5)
					(cs_shoot_point TRUE hangar/weld3)
					(sleep 90)
					(cs_shoot_point FALSE hangar/weld3)
				)
				(begin
					(cs_fly_to hangar/p6)
					(cs_shoot_point TRUE hangar/weld4)
					(sleep 90)
					(cs_shoot_point FALSE hangar/weld4)
				)
			)
			FALSE
		)
	)
)
(script command_script hangar_fly_out_l1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/l1_1)
	(cs_fly_to hangar_too/l1_0)
)
(script command_script hangar_fly_out_l2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/l2_1)
	(cs_fly_to hangar_too/l2_0)
)
(script command_script hangar_fly_out_r1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/r1_1)
	(cs_fly_to hangar_too/r1_0)
)
(script command_script hangar_fly_out_r2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/r2_1)
	(cs_fly_to hangar_too/r2_0)
)
(script command_script hangar_fly_out_c1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/c1_1)
	(cs_fly_to hangar_too/c1_0)
)
(script command_script hangar_fly_out_c2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/c2_1)
	(cs_fly_to hangar_too/c2_0)
)
(script command_script hangar_fly_l1
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (= (volume_test_objects vol_hangar_center ai_current_actor) TRUE))
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/l1_0)
	(cs_fly_by hangar_too/l1_1)
	(cs_fly_to hangar_too/l1_2)
	(ai_erase ai_current_actor)
)
(script command_script hangar_fly_l2
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (= (volume_test_objects vol_hangar_center ai_current_actor) TRUE))
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/l2_0)
	(cs_fly_by hangar_too/l2_1)
	(cs_fly_to hangar_too/l2_2)
	(ai_erase ai_current_actor)
)
(script command_script hangar_fly_r1
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (= (volume_test_objects vol_hangar_center ai_current_actor) TRUE))
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/r1_0)
	(cs_fly_by hangar_too/r1_1)
	(cs_fly_to hangar_too/r1_2)
	(ai_erase ai_current_actor)
)
(script command_script hangar_fly_r2
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (= (volume_test_objects vol_hangar_center ai_current_actor) TRUE))
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/r2_0)
	(cs_fly_by hangar_too/r2_1)
	(cs_fly_to hangar_too/r2_2)
	(ai_erase ai_current_actor)
)
(script command_script hangar_fly_c1
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (= (volume_test_objects vol_hangar_center ai_current_actor) TRUE))
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/c1_0)
	(cs_fly_by hangar_too/c1_1)
	(cs_fly_to hangar_too/c1_2)
	(ai_erase ai_current_actor)
)
(script command_script hangar_fly_c2
	(cs_enable_pathfinding_failsafe TRUE)
	(sleep_until (= (volume_test_objects vol_hangar_center ai_current_actor) TRUE))
	(cs_vehicle_speed .5)
	(cs_fly_by hangar_too/c2_0)
	(cs_fly_by hangar_too/c2_1)
	(cs_fly_to hangar_too/c2_2)
	(ai_erase ai_current_actor)
)
(global boolean hangar_sentinel_var TRUE)
(script dormant hangar_sentinels_flitting
	(sleep_until 
		(begin
			(begin_random
				(if (< (ai_living_count hangar_sentinels_flit) 1)
					(begin
						(ai_place hangar_sentinels_flit/l1)
						(cs_run_command_script hangar_sentinels_flit/l1 hangar_fly_out_l1)
						(set hangar_sentinel_var TRUE)
						(begin_random
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/l1 hangar_fly_l2)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/l1 hangar_fly_r1)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/l1 hangar_fly_r2)
									(set hangar_sentinel_var FALSE)
								)
							)
							;(if (= hangar_sentinel_var TRUE)
							;	(begin
							;		(cs_queue_command_script hangar_sentinels_flit/l1 hangar_fly_c1)
							;		(set hangar_sentinel_var FALSE)
							;	)
							;)
						)
					)
				)
				(if (< (ai_living_count hangar_sentinels_flit) 1)
					(begin
						(ai_place hangar_sentinels_flit/l2)
						(cs_run_command_script hangar_sentinels_flit/l2 hangar_fly_out_l2)
						(set hangar_sentinel_var TRUE)
						(begin_random
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/l2 hangar_fly_l1)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/l2 hangar_fly_r1)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/l2 hangar_fly_r2)
									(set hangar_sentinel_var FALSE)
								)
							)
							;(if (= hangar_sentinel_var TRUE)
							;	(begin
							;		(cs_queue_command_script hangar_sentinels_flit/l2 hangar_fly_c2)
							;		(set hangar_sentinel_var FALSE)
							;	)
							;)
						)
					)
				)
				(if (< (ai_living_count hangar_sentinels_flit) 1)
					(begin
						(ai_place hangar_sentinels_flit/r1)
						(cs_run_command_script hangar_sentinels_flit/r1 hangar_fly_out_r1)
						(set hangar_sentinel_var TRUE)
						(begin_random
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/r1 hangar_fly_l1)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/r1 hangar_fly_l2)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/r1 hangar_fly_r2)
									(set hangar_sentinel_var FALSE)
								)
							)
							;(if (= hangar_sentinel_var TRUE)
							;	(begin
							;		(cs_queue_command_script hangar_sentinels_flit/r1 hangar_fly_c1)
							;		(set hangar_sentinel_var FALSE)
							;	)
							;)
						)
					)
				)
				(if (< (ai_living_count hangar_sentinels_flit) 1)
					(begin
						(ai_place hangar_sentinels_flit/r2)
						(cs_run_command_script hangar_sentinels_flit/r2 hangar_fly_out_r2)
						(set hangar_sentinel_var TRUE)
						(begin_random
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/r2 hangar_fly_l1)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/r2 hangar_fly_l2)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/r2 hangar_fly_r1)
									(set hangar_sentinel_var FALSE)
								)
							)
							;(if (= hangar_sentinel_var TRUE)
							;	(begin
							;		(cs_queue_command_script hangar_sentinels_flit/r2 hangar_fly_c2)
							;		(set hangar_sentinel_var FALSE)
							;	)
							;)
						)
					)
				)
				(if (< (ai_living_count hangar_sentinels_flit) 1)
					(begin
						(ai_place hangar_sentinels_flit/c1)
						(cs_run_command_script hangar_sentinels_flit/c1 hangar_fly_out_c1)
						(set hangar_sentinel_var TRUE)
						(begin_random
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/c1 hangar_fly_l1)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/c1 hangar_fly_r1)
									(set hangar_sentinel_var FALSE)
								)
							)
							;(if (= hangar_sentinel_var TRUE)
							;	(begin
							;		(cs_queue_command_script hangar_sentinels_flit/c1 hangar_fly_c2)
							;		(set hangar_sentinel_var FALSE)
							;	)
							;)
						)
					)
				)
;*				(if (< (ai_living_count hangar_sentinels_flit) 1)
					(begin
						(ai_place hangar_sentinels_flit/c2)
						(cs_run_command_script hangar_sentinels_flit/c2 hangar_fly_out_c2)
						(set hangar_sentinel_var TRUE)
						(begin_random
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/c2 hangar_fly_l2)
									(set hangar_sentinel_var FALSE)
								)
							)
							(if (= hangar_sentinel_var TRUE)
								(begin
									(cs_queue_command_script hangar_sentinels_flit/c2 hangar_fly_r2)
									(set hangar_sentinel_var FALSE)
								)
							)
							;(if (= hangar_sentinel_var TRUE)
							;	(begin
							;		(cs_queue_command_script hangar_sentinels_flit/c2 hangar_fly_c1)
							;		(set hangar_sentinel_var FALSE)
							;	)
							;)
						)
					)
				)
*;
			)
			(>= (ai_combat_status hangar_heretics) ai_combat_status_uninspected)
		)
	)
)

;Ally commenting on sentinel presence scene!
(script command_script hangar_sentinel_comment
	(cs_switch elev_elite)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'Sentinels! The holy warriors of the sacred rings!'")
	(cs_aim TRUE hangar_too/p0)
;	(cs_custom_animation objects\characters\elite\elite "combat:rifle:warn" 1 TRUE)
	(cs_play_line 0360)
	(sleep 30)
	(print "'Why have they sided with these heretics?'")
	(cs_play_line 0370)
	(cs_aim FALSE hangar_too/p0)
)

;Puts sentinels to work for heretics and breaks them out when alerted
(script dormant hangar_helpers
	(ai_place hangar_helper_01)
	(cs_run_command_script hangar_helper_01 forever_pause)
	(ai_place hangar_helper_03)
	(cs_run_command_script hangar_helper_03 forever_pause)

	(sleep_until (= (volume_test_objects vol_trigger_helpers (players)) TRUE))
	(cs_run_command_script hangar_helper_03 hangar_help_03)
	(cs_run_command_script hangar_helper_01 hangar_help_01)
	(ai_place hangar_helper_02)
	
	(cs_run_command_script hangar_helper_02 hangar_help_02)
	(cs_queue_command_script hangar_helper_02 hangar_help_03)
	
	(sleep 90)
	(ai_scene sentinel_react_scene hangar_sentinel_comment arm01_allies)

	(sleep_until (> (ai_combat_status hangar_heretics) ai_combat_status_uninspected))
	(unit_add_equipment (unit (list_get (ai_actors hangar_helper_01) 0)) swap TRUE TRUE)
	(unit_add_equipment (unit (list_get (ai_actors hangar_helper_02) 0)) swap TRUE TRUE)
	(unit_add_equipment (unit (list_get (ai_actors hangar_helper_03) 0)) swap TRUE TRUE)
	(objects_detach (list_get (ai_actors hangar_helper_01) 0) help_can_01)
	(objects_detach (list_get (ai_actors hangar_helper_02) 0) help_can_02)
	(cs_run_command_script hangar_helper_01 abort)
	(cs_run_command_script hangar_helper_02 abort)
	(cs_run_command_script hangar_helper_03 abort)
	(cs_queue_command_script hangar_sentinels_flit abort)
)

;Tells when your allies have finally entered
(global boolean hangar_phantom_cue FALSE)
(global boolean hangar_sentinels_come FALSE)
(global short heavies_spawned 0)
(script command_script hangar_phantom_arrives
	;(sleep_until (> (ai_living_count hangar_phantom) 1))
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_by airspace_hangar/hangar_ph0 3)
	(cs_fly_by airspace_hangar/hangar_ph1 3)
	(cs_vehicle_speed .25)
	(cs_fly_to airspace_hangar/hangar_ph2 1)
	
	(ai_place reinforce_elites_01 (max 1 (- 2 (ai_living_count allies_elites))))
	(ai_place reinforce_grunts_01 (- 2 (ai_living_count allies_grunts)))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p" (ai_actors reinforce_elites_01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p" (ai_actors reinforce_grunts_01))
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_a01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_a02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_a03")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_b01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_b02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_b03")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_c01")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_c02")
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p_c03")

	(sleep_until (< (ai_living_count hangar_phantom) 2) 30 900)
	(set hangar_phantom_cue TRUE)

;	(sleep_until (= hangar_sentinels_come TRUE))
;	(sleep 120)
;	(cs_shoot TRUE)
	;(cs_enable_targeting TRUE)
	
	(sleep_until (> heavies_spawned 0))
	(sleep_until 
		(OR
			(>= (ai_combat_status hangar_heretic_heavies_L) ai_combat_status_clear_los)
			(>= (ai_combat_status hangar_heretic_heavies_R) ai_combat_status_clear_los)
		)
	30 300)
	;(sleep 60)
	(wake music_04a_01_stop)
	
	(cs_fly_to_and_face airspace_hangar/hangar_ph1 airspace_hangar/hangar_ph2 2)
	
	(cs_vehicle_speed 1)
	(cs_fly_by airspace_hangar/hangar_ph0 5)
	(cs_fly_to airspace_hangar/hangar_phx 5)
	(ai_erase hangar_phantom)
)

;Phantom flies reinforcements in, once you reach the end of the room or kill enough guys
(script dormant hangar_allies_reinforce
	(sleep_until
		(begin
			(if 
				(AND
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 3)) 50)
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 3) 45) FALSE)
				)
					(object_destroy (list_get (ai_actors all_allies) 3))
			)
			(if 
				(AND
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 50)
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 2) 45) FALSE)
				)
					(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(if 
				(AND
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 50)
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 1) 45) FALSE)
				)
					(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(if 
				(AND
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 50)
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 0) 45) FALSE)
				)
					(object_destroy (list_get (ai_actors all_allies) 0))
			)
			FALSE
		)
	30 150)
	(ai_place hangar_phantom)
	(cs_run_command_script hangar_phantom hangar_phantom_arrives)
	(sleep 60)

	(sleep_until (> (ai_living_count hangar_phantom) 1))
	(sleep_until (< (ai_living_count hangar_phantom) 2))
	(ai_set_orders reinforce_elites_01 allies_hangar_bottom)
	(ai_set_orders reinforce_grunts_01 allies_hangar_bottom)
)
(script static void short_hangar_allies
	(sleep_until
		(begin
			(if 
				(AND
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 2)) 50)
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 2) 45) FALSE)
				)
					(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(if 
				(AND
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 1)) 50)
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 1) 45) FALSE)
				)
					(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(if 
				(AND
					(> (objects_distance_to_object (players) (list_get (ai_actors all_allies) 0)) 50)
					(= (objects_can_see_object (players) (list_get (ai_actors all_allies) 0) 45) FALSE)
				)
					(object_destroy (list_get (ai_actors all_allies) 0))
			)
			FALSE
		)
	30 150)
	(ai_place hangar_phantom)
	(cs_run_command_script hangar_phantom hangar_phantom_arrives)
	(sleep 60)
	(ai_place reinforce_elites_01 (- 2 (ai_living_count allies_elites)))
	(ai_place reinforce_grunts_01 (- 2 (ai_living_count allies_grunts)))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p" (ai_actors reinforce_elites_01))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location hangar_phantom/pilot) "phantom_p" (ai_actors reinforce_grunts_01))

	(sleep_until (< (ai_living_count hangar_phantom) 2))
	(ai_set_orders reinforce_elites_01 allies_hangar_bottom)
	(ai_set_orders reinforce_grunts_01 allies_hangar_bottom)
)

;Waits till you open the hangar doors
(script dormant hangar_door_monitor
	(sleep_until (> (device_get_position hangar_door_cinematic) 0))
	(wake hangar_allies_reinforce)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "PHANTOM PILOT: 'Hold position! I am making my approach!'")
	(sleep (ai_play_line_on_object NONE 2030))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_2030_scl))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Dialogue related to new objective
(script dormant hangar_objective
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "PHANTOM PILOT: 'Arbiter! Clear the hangar, and open its door so I may drop the second lance!'")
	(sleep (ai_play_line_on_object NONE 2000))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_2000_scl))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Hangar door reminder
(script dormant hangar_door_reminder
	(sleep_until (> (device_get_position hangar_door_cinematic) 0) 30 4000)
	(if (<= (device_get_position hangar_door_cinematic) 0)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'Find the controls to the hangar-doors, Arbiter!'")
			(sleep (ai_play_line_on_object NONE 2010))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_2010_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)

	(sleep_until (> (device_get_position hangar_door_cinematic) 0) 30 2000)
	(if (<= (device_get_position hangar_door_cinematic) 0)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'The hangar-doors, Arbiter! Open them, and I will land your reinforcements!'")
			(sleep (ai_play_line_on_object NONE 2020))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_2020_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
			(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
				(begin 
					(activate_team_nav_point_object default player hangar_door_switch_L 0)
					(sleep_until (> (device_get_position hangar_door_cinematic) 0))
					(deactivate_team_nav_point_object player hangar_door_switch_L)
				)
				(begin 
					(activate_team_nav_point_object default player hangar_door_switch_R 0)
					(sleep_until (> (device_get_position hangar_door_cinematic) 0))
					(deactivate_team_nav_point_object player hangar_door_switch_R)
				)
			)
		)
	)	
)

;Heretic yelling for sentinels scene!
(script command_script hangar_sentinel_call
	(cs_switch heretic)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC: 'Sentinels! Defend us!'")
	(cs_play_line 0380)
)
(script dormant hangar_alerted_call
	(sleep_until (> (ai_combat_status hangar_heretics) ai_combat_status_uninspected))
	(ai_scene hangar_s_call_scene hangar_sentinel_call hangar_heretics)
)

;Spawns sentinel swarm to pester phantom
(script static void sentinel_swarm_spawning
	(set hangar_sentinels_come TRUE)
	(sleep_until
		(begin
			(if (< (ai_living_count hangar_sentinels) 3)
				(ai_place hangar_sentinel_swarm 1)
			)
			(sleep (random_range 10 30))
			(> (ai_spawn_count hangar_sentinel_swarm) 4)
		)
	)
)

;Spawns flak grunts to drive away phantom
(script static void heretic_heavy_spawning
	(begin_random
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02r) 0)
				(< heavies_spawned 3)
			)
				(begin
					(print "heavy_02r_a")
					(ai_place hangar_heretic_heavies_R/02a)
					(cs_run_command_script hangar_heretic_heavies_R snap_alert)
					(set heavies_spawned (+ heavies_spawned 1))
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02r) 0)
				(< heavies_spawned 3)
			)
				(begin
					(print "heavy_02r_b")
					(ai_place hangar_heretic_heavies_R/02b)
					(cs_run_command_script hangar_heretic_heavies_R snap_alert)
					(set heavies_spawned (+ heavies_spawned 1))
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_03R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_03r) 0)
				(< heavies_spawned 3)
			)
				(begin
					(print "heavy_03r_a")
					(ai_place hangar_heretic_heavies_R/03a)
					(cs_run_command_script hangar_heretic_heavies_R snap_alert)
					(set heavies_spawned (+ heavies_spawned 1))
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_03R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_03r) 0)
				(< heavies_spawned 3)
			)
				(begin
					(print "heavy_03r_b")
					(ai_place hangar_heretic_heavies_R/03b)
					(cs_run_command_script hangar_heretic_heavies_R snap_alert)
					(set heavies_spawned (+ heavies_spawned 1))
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02l) 0)
				(< heavies_spawned 3)
			)
				(begin
					(print "heavy_02l_a")
					(ai_place hangar_heretic_heavies_L/02a)
					(cs_run_command_script hangar_heretic_heavies_L snap_alert)
					(set heavies_spawned (+ heavies_spawned 1))
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02l) 0)
				(< heavies_spawned 3)
			)
				(begin
					(print "heavy_02l_b")
					(ai_place hangar_heretic_heavies_L/02b)
					(cs_run_command_script hangar_heretic_heavies_L snap_alert)
					(set heavies_spawned (+ heavies_spawned 1))
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_03L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_03l) 0)
				(< heavies_spawned 3)
			)
				(begin
					(print "heavy_03l_a")
					(ai_place hangar_heretic_heavies_L/03a)
					(cs_run_command_script hangar_heretic_heavies_L snap_alert)
					(set heavies_spawned (+ heavies_spawned 1))
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_03L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_03l) 0)
				(< heavies_spawned 3)
			)
				(begin
					(print "heavy_03l_b")
					(ai_place hangar_heretic_heavies_L/03b)
					(cs_run_command_script hangar_heretic_heavies_L snap_alert)
					(set heavies_spawned (+ heavies_spawned 1))
				)
		)
	)
)

;Bertone time!

;Tracks number of spawns made per group
(global short a50_spawn_go 0)

;Spawns randomly from the six rooms, depending on where you are
(script static void hangar_a50_clone
	(begin_random
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02r) 0)
			)
				(begin
					(ai_place hangar_a50_02r_high (- (random_range 0 3) (ai_living_count a50_high)))
					(cs_run_command_script hangar_a50_02r_high snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02r) 0)
			)
				(begin
					(ai_place hangar_a50_02r_low (- (random_range 0 3) (ai_living_count a50_low)))
					(cs_run_command_script hangar_a50_02r_low snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_03R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_03r) 0)
			)
				(begin
					(ai_place hangar_a50_03r_high (- (random_range 0 3) (ai_living_count a50_high)))
					(cs_run_command_script hangar_a50_03r_high snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_03R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_03r) 0)
			)
				(begin
					(ai_place hangar_a50_03r_low (- (random_range 0 3) (ai_living_count a50_low)))
					(cs_run_command_script hangar_a50_03r_low snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02l) 0)
			)
				(begin
					(ai_place hangar_a50_02l_high (- (random_range 0 3) (ai_living_count a50_high)))
					(cs_run_command_script hangar_a50_02l_high snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02l) 0)
			)
				(begin
					(ai_place hangar_a50_02l_low (- (random_range 0 3) (ai_living_count a50_low)))
					(cs_run_command_script hangar_a50_02l_low snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_03L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_03l) 0)
			)
				(begin
					(ai_place hangar_a50_03l_high (- (random_range 0 3) (ai_living_count a50_high)))
					(cs_run_command_script hangar_a50_03l_high snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_03L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_03l) 0)
			)
				(begin
					(ai_place hangar_a50_03l_low (- (random_range 0 3) (ai_living_count a50_low)))
					(cs_run_command_script hangar_a50_03l_low snap_alert)
				)
		)
	)
	
	(sleep_until (< (ai_living_count hangar_heretics) 3) 30 8000)
	(sleep_until (< (ai_living_count hangar_heretics) 1) 30 1800)
	(sleep 150)
	(game_save)
	
	(begin_random
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02r) 0)
			)
				(begin
					(ai_place hangar_a50_02r_high (- (random_range 0 2) (ai_living_count a50_high)))
					(cs_run_command_script hangar_a50_02r_high snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02r) 0)
			)
				(begin
					(ai_place hangar_a50_02r_low (- (random_range 0 4) (ai_living_count a50_low)))
					(cs_run_command_script hangar_a50_02r_low snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_01R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_01r) 0)
			)
				(begin
					(ai_place hangar_a50_01r_high (- (random_range 0 2) (ai_living_count a50_high)))
					(cs_run_command_script hangar_a50_01r_high snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_01R (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_01r) 0)
			)
				(begin
					(ai_place hangar_a50_01r_low (- (random_range 0 4) (ai_living_count a50_low)))
					(cs_run_command_script hangar_a50_01r_low snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02l) 0)
			)
				(begin
					(ai_place hangar_a50_02l_high (- (random_range 0 2) (ai_living_count a50_high)))
					(cs_run_command_script hangar_a50_02l_high snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_02L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_02l) 0)
			)
				(begin
					(ai_place hangar_a50_02l_low (- (random_range 0 4) (ai_living_count a50_low)))
					(cs_run_command_script hangar_a50_02l_low snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_01L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_01l) 0)
			)
				(begin
					(ai_place hangar_a50_01l_high (- (random_range 0 2) (ai_living_count a50_high)))
					(cs_run_command_script hangar_a50_01l_high snap_alert)
				)
		)
		(if 
			(AND
				(= (volume_test_objects vol_hangar_spawn_01L (players)) FALSE)
				(> (player_count) 0)
				(= (device_get_position hang_01l) 0)
			)
				(begin
					(ai_place hangar_a50_01l_low (- (random_range 0 4) (ai_living_count a50_low)))
					(cs_run_command_script hangar_a50_01l_low snap_alert)
				)
		)
	)
)

;Reminder about where to go at end of encounter
(script command_script hangar_exit_comment
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'More heretics!  In the passage below us!'")
	(cs_play_line 1140)
)
(script dormant hangar_exit_warn
	(sleep_until (= (volume_test_objects vol_hangar_center_exit (players)) TRUE) 30 300)
	(if 
		(AND
			(= (volume_test_objects vol_hangar_center_exit (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_scene hangar_exit_scene hangar_exit_comment all_allies)
			)
	)
)

;Reminder to go down
(script dormant hangar_reminder
	(sleep_until (= (volume_test_objects vol_leaving_hangar (players)) TRUE) 30 3600)
	(if 
		(AND
			(= (volume_test_objects vol_leaving_hangar (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "SPEC-OPS COMMANDER: 'Keep heading down. Find the leader of these heretics!'")
				(sleep (ai_play_line_on_object NONE 1150))
				;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_1150_soc))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
	(sleep_until (= (volume_test_objects vol_leaving_hangar (players)) TRUE) 30 1800)
	(if 
		(AND
			(= (volume_test_objects vol_leaving_hangar (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(activate_team_nav_point_object default player hangar_exit 0)
				(sleep_until (= (volume_test_objects vol_leaving_hangar (players)) TRUE))
				(deactivate_team_nav_point_object player hangar_exit)
			)
	)
)

;exterior sound toggle
(script dormant hangar_exterior_toggle
	(object_create alpha_gas_exterior)
	(sleep_until 
		(begin
			(sleep_until (= (volume_test_objects vol_first_hall_01 (players)) TRUE))
			(object_destroy alpha_gas_exterior)
			(sleep_until (= (volume_test_objects vol_leaving_hangar (players)) TRUE))
			(object_create alpha_gas_exterior)
			FALSE
		)
	)
)

(script command_script deploy_hangar_right
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to hangar_turrets/deploy_r)
	(cs_deploy_turret hangar_turrets/right)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script deploy_hangar_left
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to hangar_turrets/deploy_l)
	(cs_deploy_turret hangar_turrets/left)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)

(script static void test_ass
	(device_operates_automatically_set hangar_exit TRUE)
	(ai_place hangar_heretic_06R (random_range 0 2))
	(ai_place hangar_heretic_06L (- 1 (ai_living_count hangar_heretic_06R)))
	(ai_place hangar_grunts_04R 1)
	(ai_place hangar_grunts_04L 1)
	(cs_run_command_script hangar_heretics snap_alert)
	(cs_queue_command_script hangar_grunts_04R deploy_hangar_right)
	(cs_queue_command_script hangar_grunts_04L deploy_hangar_left)
)

;Overall script for hangar
(script dormant hangar_firsttime_start
	(data_mine_set_mission_segment "04a_3_hangar")
	(object_create_containing "hang_can_")
	(wake hangar_helpers)
	(wake hangar_can_spawner)
	(wake hangar_killer_new)
	(wake hangar_sentinels_flitting)
	(wake hangar_door_monitor)
	(set hangar_power_on TRUE)
	(ai_renew all_allies)
	
	(ai_place hangar_heretic_01R (random_range 0 2))
	(ai_place hangar_heretic_01L (- 1 (ai_living_count hangar_heretic_01R)))
	(ai_place hangar_heretic_02L (random_range 0 2))
	(ai_place hangar_heretic_02R (- 1 (ai_living_count hangar_heretic_02L)))
	(ai_place hangar_grunts_01R (random_range 1 3))
	(ai_place hangar_grunts_01L (- 2 (ai_living_count hangar_grunts_01R)))
	
	(sleep_until (> (device_get_position elev_hangar) .1))	
	(wake music_04a_01_start)
	(cs_run_command_script all_allies abort)
	(wake hangar_extra_save)

	(sleep_until (> (device_get_position elev_hangar) .6))	
;	(game_save)
	(set stealth_talk_gone TRUE)
	(ai_set_orders arm01_allies ride_hangar_elev)		
	(wake hangar_alerted_call)
		
;	(sleep_until 
;		(OR 
;			(= (volume_test_objects vol_hangar_mid_left (players)) TRUE)
;			(= (volume_test_objects vol_hangar_mid_right (players)) TRUE)
;			(= (volume_test_objects vol_hangar_elev_left (players)) TRUE)
;			(= (volume_test_objects vol_hangar_elev_right (players)) TRUE)
;;			(< (ai_living_count hangar_heretics) 5)
;		)
;	)
;	(game_save)
;	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
;			(begin
;				(ai_place hangar_rein_her_01L (- 2 (+ (ai_living_count hangar_heretic_01R) (ai_living_count hangar_heretic_01L))))
;			)
;	)
;	(if (= (volume_test_objects vol_hangar_right (players)) TRUE)
;			(begin
;				(ai_place hangar_rein_her_01R (- 2 (+ (ai_living_count hangar_heretic_01R) (ai_living_count hangar_heretic_01L))))
;			)
;	)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_hangar_mid_left (players)) TRUE)
			(= (volume_test_objects vol_hangar_mid_right (players)) TRUE)		
			(= (volume_test_objects vol_hangar_end_left (players)) TRUE)
			(= (volume_test_objects vol_hangar_end_right (players)) TRUE)		
			(< (ai_living_count hangar_heretics) 3)
		)
	)
	(game_save)
	(wake hangar_objective)
	(wake hangar_door_reminder)
	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
			(begin
				(ai_place hangar_rein_her_02L (- 3 (ai_living_count hangar_grunts_01L)))
			)
	)
	(if (= (volume_test_objects vol_hangar_right (players)) TRUE)
			(begin
				(ai_place hangar_rein_her_02R (- 3 (ai_living_count hangar_grunts_01R)))
			)
	)

	(sleep_until 
		(OR 
			(= (volume_test_objects vol_hangar_end_left (players)) TRUE)
			(= (volume_test_objects vol_hangar_end_right (players)) TRUE)		
			(< (ai_living_count hangar_heretics) 3)
		)
	)
	(game_save)
	(if (= (volume_test_objects vol_hangar_left (players)) TRUE)
			(begin
				(ai_place hangar_rein_her_03L (- 2 (+ (ai_living_count hangar_heretic_01L) (ai_living_count hangar_heretic_01R) (ai_living_count hangar_heretic_02R) (ai_living_count hangar_heretic_02L))))
				;(ai_place hangar_sentinels_flit/l1)
				;(ai_place hangar_sentinels_flit/l2)
				;(ai_place hangar_sentinels_flit/c1)
				;(ai_place hangar_sentinels_flit/c2)
			)
	)
	(if (= (volume_test_objects vol_hangar_right (players)) TRUE)
			(begin
				(ai_place hangar_rein_her_03R (- 2 (+ (ai_living_count hangar_heretic_01L) (ai_living_count hangar_heretic_01R) (ai_living_count hangar_heretic_02R) (ai_living_count hangar_heretic_02L))))
				;(ai_place hangar_sentinels_flit/r1)
				;(ai_place hangar_sentinels_flit/r2)
				;(ai_place hangar_sentinels_flit/c1)
				;(ai_place hangar_sentinels_flit/c2)
			)
	)
	(ai_set_orders hangar_heretics_init defend_switch)
	
;	(ai_place hangar_heretic_05)
;	(ai_place hangar_grunts_03)
	
;	(sleep_until 
;		(OR
;			(< (ai_living_count hangar_heretics) 1)
;			(> (ai_combat_status hangar_heretics) ai_combat_status_idle)
;		)
;	)
;	(game_save)
;	(if (< (ai_living_count arm01_allies) 4)
;		(begin
;			(wake hangar_allies_reinforce)
;		)
;	)
;	
;	(sleep_until 
;		(OR
;			(= (volume_test_objects vol_hangar_by_door (ai_actors reinforce_elites_01)) TRUE) 
;			(= (volume_test_objects vol_hangar_by_door (ai_actors reinforce_grunts_01)) TRUE) 
;		)
;	30 900)
;	(game_save)

	(sleep_until (> (device_get_position hangar_door_cinematic) 0))
	(wake hangar_exterior_toggle)
	
	;(sleep_until (= hangar_phantom_cue TRUE) 30 1800)
	(game_save)
	(sentinel_swarm_spawning)
	
	(sleep_until (< (ai_living_count hangar_sentinel_swarm) 3) 30 8000)
	(sleep_until (< (ai_living_count hangar_sentinel_swarm) 1) 30 900)
	(sleep 150)
	(game_save)
	(heretic_heavy_spawning)

	(sleep_until (< (ai_living_count hangar_heretics) 3) 30 8000)
	(sleep_until (< (ai_living_count hangar_heretics) 1) 30 900)
	(sleep 150)
	(game_save)
	
	(ai_place hangar_a50_02r_high (- (random_range 0 3) (ai_living_count a50_high)))
	(cs_run_command_script hangar_a50_02r_high snap_alert)

	(ai_place hangar_a50_02l_high (- 2 (ai_living_count a50_high)))
	(cs_run_command_script hangar_a50_02l_high snap_alert)
	
	(ai_place hangar_a50_02r_low (- (random_range 0 3) (ai_living_count a50_low)))
	(cs_run_command_script hangar_a50_02r_low snap_alert)

	(ai_place hangar_a50_02l_low (- 2 (ai_living_count a50_low)))
	(cs_run_command_script hangar_a50_02l_low snap_alert)

	(sleep_until 
		(OR
			(< (ai_living_count hangar_heretics) 3)
			(= (volume_test_objects vol_hangar_center_exit (players)) TRUE)
		)
	30 3600)
	
	(game_save)
	(if 
		(AND
			(= (volume_test_objects vol_hangar_center_exit (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_place hangar_a50_01r_high (- (random_range 0 3) (ai_living_count a50_high)))
				(cs_run_command_script hangar_a50_01r_high snap_alert)
			
				(ai_place hangar_a50_01l_high (- 2 (ai_living_count a50_high)))
				(cs_run_command_script hangar_a50_01l_high snap_alert)
				
				(ai_place hangar_a50_01r_low (- (random_range 0 3) (ai_living_count a50_low)))
				(cs_run_command_script hangar_a50_01r_low snap_alert)
			
				(ai_place hangar_a50_01l_low (- 2 (ai_living_count a50_low)))
				(cs_run_command_script hangar_a50_01l_low snap_alert)
			)
	)

	(sleep_until 
		(OR
			(< (ai_living_count hangar_heretics) 3)
			(= (volume_test_objects vol_hangar_center_exit (players)) TRUE)
		)
	30 3600)	

	;(hangar_a50_clone)
;	(sleep_until (< (ai_living_count hangar_heretics) 3) 30 8000)
;	(sleep_until (< (ai_living_count hangar_heretics) 1) 30 1800)
;	(sleep 150)
	
	;(sleep_until (= (volume_test_objects vol_hangar_center_exit (players)) TRUE))
;	(sleep_until 
;		(OR
;			(= (objects_can_see_object (players) hangar_exit 60) TRUE)
;			(= (volume_test_objects vol_leaving_hangar (players)) TRUE)
;		)
;	30 1800)
;	(game_save)

	(game_save)
	(device_operates_automatically_set hangar_exit TRUE)
	(ai_place hangar_heretic_06R (random_range 0 2))
	(ai_place hangar_heretic_06L (- 1 (ai_living_count hangar_heretic_06R)))
	(ai_place hangar_grunts_04R 1)
	(ai_place hangar_grunts_04L 1)
	(cs_run_command_script hangar_heretics snap_alert)
	(cs_queue_command_script hangar_grunts_04R deploy_hangar_right)
	(cs_queue_command_script hangar_grunts_04L deploy_hangar_left)
	(wake hangar_exit_warn)
	(wake hangar_reminder)
	
	(sleep_until (= (volume_test_objects vol_leaving_hangar (players)) TRUE) 30 300)
	(ai_place hangar_heretic_06C 1)
	(cs_run_command_script hangar_heretic_06C snap_alert)
	
	(sleep_until (< (ai_living_count hangar_heretics) 1))
	(game_save)
;*	
	(if 
		(AND
			(= (volume_test_objects vol_underhangar_reinforce (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count hangar_grunts_end) 1)
		)	
			(ai_place hangar_grunts_end 2)
	)
	(sleep 210)
	(if 
		(AND
			(= (volume_test_objects vol_underhangar_reinforce (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count hangar_grunts_end) 1)
		)	
			(ai_place hangar_grunts_end (random_range 1 3))
	)
	(if (= (volume_test_objects vol_underhangar_reinforce (players)) TRUE)
		(sleep_forever)
	)
	(sleep_until 
		(begin
			(if 
				(AND
					(= (volume_test_objects vol_underhangar_reinforce (players)) FALSE)
					(> (player_count) 0)
					(< (ai_living_count hangar_grunts_end) 1)
				)	
					(ai_place hangar_grunts_end 1)
			)
			(sleep 210)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_underhangar_reinforce (players)) TRUE) 
					(< (ai_living_count hangar_grunts_end) 1)
					(> (ai_spawn_count hangar_grunts_end) 6)
				)
			)	
			(OR
				(= (volume_test_objects vol_underhangar_reinforce (players)) TRUE)
				(> (ai_spawn_count hangar_grunts_end) 6)
			)
		)
	)
*;
)


;-------------------------------------------------------------------------------
;Corridors to Under Hangar

;Reinforces heretics if they're alerted
(script dormant first_hall_reinforce
	(sleep_until 
		(AND
			(> (ai_combat_status first_hall_heretics) ai_combat_status_idle)
			(OR 
				(< (ai_living_count first_hall_heretic_01) 1)
				(< (ai_living_count first_hall_heretic_02) 1)
			)
		)
	)
	(ai_place first_hall_heretic_03 2)
	(cs_run_command_script first_hall_heretic_03 snap_alert)
)

;Overall script for halls leading to under hangar
(script dormant to_underhangar_firsttime
	(sleep_until (= (volume_test_objects vol_hangar_reenter (players)) TRUE))
	(data_mine_set_mission_segment "04a_4_first_halls")
	(game_save)
	(ai_renew all_allies)

	(ai_migrate hangar_heretics chasers)
	(ai_set_orders chasers chase01)
			
	(ai_place first_hall_heretic_01 1)
	(ai_place first_hall_grunts_01 2)
	(ai_place first_hall_heretic_02 1)
	
	(sleep_until (= (volume_test_objects vol_hangar_reenter (players)) TRUE))
	(wake first_hall_reinforce)
	(set stealth_talk_gone TRUE)
	(ai_set_orders arm01_allies allies_first_hall)
	
	(sleep_until (< (ai_living_count first_hall_heretics) 1))
	(game_save)
)


;-------------------------------------------------------------------------------
;Under Hangar

;Temp variables for controlling conveyors
(global boolean underhangar_power_on FALSE)

;Spawns cans randomly on lines A, B, and C
(script dormant underhangar_can_spawner
	(sleep_until (= underhangar_power_on TRUE))
	(sleep_until
		(begin
			(begin_random
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_underhangar_can_all 2048)) 15)
						(begin
							(object_create_clone underhangar_can_A)
;							(sleep recycling_time)
						)
					)
					(sleep recycling_time)
				)
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_underhangar_can_all 2048)) 15)
						(begin
							(object_create_clone underhangar_can_B)
;							(sleep recycling_time)
						)
					)
					(sleep recycling_time)
				)
			)
			(= underhangar_power_on FALSE)
		)
	)
)

;Kills crates and characters dropped into pits
(script dormant underhangar_killer_new
	(sleep_until (= underhangar_power_on TRUE))
	(sleep_until
		(begin
			(object_destroy (list_get (volume_return_objects kill_underhangar_pit_01) 0))
			(sleep 45)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_underhangar_pit_01 1) 0)))
			(sleep 45)
			(object_destroy (list_get (volume_return_objects kill_underhangar_pit_02) 0))
			(sleep 45)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_underhangar_pit_02 1) 0)))
			(sleep 45)
			(= underhangar_power_on FALSE)
		)
	)
)

;Spawns new allies if you need them
(script dormant new_allies_02
	(if 
		(AND
			(= (volume_test_objects vol_hangar_can_all (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(sleep_until
					(begin
						(object_destroy (list_get (volume_return_objects_by_type vol_hangar_can_all 1) 0))
						(= (list_count (volume_return_objects_by_type vol_hangar_can_all 1)) 0)
					)
				10)
			)
	)
	(if 
		(AND
			(= (volume_test_objects vol_underhangar_reinforce (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count arm01_allies) 3)
		)
			(begin
				(ai_place reinforce_elites_02 (- 1 (ai_living_count allies_elites)))
				(ai_place reinforce_grunts_02 (- 1 (ai_living_count allies_grunts)))
			)
	)
)

(script dormant underhangar_reinforce
	(sleep_until (> (ai_combat_status underhangar_heretics) ai_combat_status_idle))
	(if 
		(AND
			(= (volume_test_objects vol_underhangar_halfway (players)) FALSE)
			(= (volume_test_objects vol_underhangar_end (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count underhangar_heretics) 8)
					(ai_place underhangar_rein_her_01 2)
				)
				(cs_run_command_script underhangar_rein_her_01 snap_alert)
			)
	)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_underhangar_halfway (players)) TRUE)
			(= (volume_test_objects vol_underhangar_end (players)) TRUE)
		)
	)
	(if 
		(AND
			(= (volume_test_objects vol_underhangar_end (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(if (< (ai_living_count underhangar_heretics) 8)
					(ai_place underhangar_rein_her_02 2)
				)
				(cs_run_command_script underhangar_rein_her_02 snap_alert)
			)
	)

	(sleep_until 
		;(OR 
			(= (volume_test_objects vol_underhangar_end (players)) TRUE)
		;	(< (ai_living_count underhangar_heretics) 3)
		;)
	)
	(if (< (ai_living_count underhangar_heretics) 8)
		(ai_place underhangar_grunts_03 4)
	)
	(cs_run_command_script underhangar_grunts_03 snap_alert)
)

;Reminder to keep moving
(script command_script underhangar_comment
	(cs_switch ally)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'Shall we keep moving, Arbiter? The Heretic-Leader cowers below!'")
	(cs_play_line 1160)
)
(script dormant underhangar_reminder
	(sleep_until (= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE) 30 900)
	(if 
		(AND
			(= (volume_test_objects vol_underhangar_from_bottom (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_scene underhangar_scene underhangar_comment all_allies)
			)
	)
)

;Overall script for under hangar
(script dormant underhangar_firsttime_start
	(data_mine_set_mission_segment "04a_5_underhangar")
	(game_save)
	(ai_renew all_allies)
	(object_create_containing "underhang_can_")

	;(device_set_position_immediate hangar_door_cinematic 0)
	(if
		(AND
			(= (volume_test_objects_all vol_hangar_left (players)) FALSE)
			(= (volume_test_objects_all vol_hangar_right (players)) FALSE)
			(> (device_get_position hangar_exit) 0)
			(> (player_count) 0)
		)
			(begin
				(pvs_set_object hangar_door_cinematic)
				(sleep 2)
				(device_set_position_immediate hangar_door_cinematic 0)
				(sleep 2)
				(pvs_clear)
			)
	)
	
	(wake underhangar_can_spawner)
	(wake underhangar_killer_new)
	(wake underhangar_reinforce)
	(set underhangar_power_on TRUE)

	(ai_migrate first_hall_heretics chasers)
	(ai_set_orders chasers chase01)
	
	(ai_place underhangar_heretic_01 1)
	(ai_place underhangar_grunts_01 3)
	(set stealth_talk_gone TRUE)
	(ai_set_orders arm01_allies allies_underhangar)

	(sleep 5)
	(wake music_04a_02_start)
	
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_underhangar_halfway (players)) TRUE)
			(< (ai_living_count underhangar_heretics) 1)
		)
	)
	(game_save)
	(wake new_allies_02)
	(if (< (ai_living_count underhangar_heretics) 8)
		(ai_place underhangar_heretic_02 1)
	)
	(if (< (ai_living_count underhangar_heretics) 8)
		(ai_place underhangar_grunts_02 2)
	)
	
	(sleep_until 
		(OR
			(< (ai_living_count underhangar_heretics) 1)
			(= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE)
		)
	)
	(game_save)	
	(wake underhangar_reminder)
	
	(wake music_04a_02_stop)	
)


;-------------------------------------------------------------------------------
;Corridors to Bottling Plant

;Enemy reinforcement scripts
(script dormant second_hall_reinforce_01
	(sleep_until 
		(OR 
			(> (ai_combat_status second_hall_grunts_01) ai_combat_status_idle)
			(> (ai_combat_status second_hall_heretic_01) ai_combat_status_idle)
		)
	)
	(ai_place second_hall_heretic_02 1)
	(cs_run_command_script second_hall_heretic_02 snap_alert)
)
(script dormant second_hall_reinforce_02
	(sleep_until (> (ai_combat_status second_hall_heretic_03) ai_combat_status_idle))
	(ai_place second_hall_grunts_02/1)
	(ai_place second_hall_grunts_02/2)

	(if 
		(AND
			(= (volume_test_objects vol_2nd_hall_02 (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_place second_hall_grunts_02/3)
				(ai_place second_hall_grunts_02/4)
			)
	)
	(cs_run_command_script second_hall_grunts_02 snap_alert)
)
(script dormant second_hall_reinforce_03
	(sleep_until (> (ai_combat_status second_hall_grunts_03) ai_combat_status_idle))
	(ai_place second_hall_heretic_04 1)
	
	(if 
		(AND
			(= (volume_test_objects vol_2nd_hall_02 (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_place second_hall_heretic_05 1)
			)
	)
	(cs_run_command_script second_hall_heretic_04 snap_alert)
	(cs_run_command_script second_hall_heretic_05 snap_alert)
)

;Overall script for halls to bottling plant
(script dormant to_bottling
	(sleep_until (= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE))
	(data_mine_set_mission_segment "04a_6_second_halls")
	(game_save)
	(ai_renew all_allies)
	(player_training_activate_stealth)

	(if (> (device_get_position hangar_door_cinematic) 0)
		(begin
			(pvs_set_object hangar_door_cinematic)
			(sleep 2)
			(device_set_position_immediate hangar_door_cinematic 0)
			(sleep 2)
			(pvs_clear)
		)
	)

	(wake second_hall_reinforce_01)
	(wake second_hall_reinforce_02)
	(wake second_hall_reinforce_03)

	(ai_migrate underhangar_heretics chasers)
	(ai_set_orders chasers chase02)

	(ai_place second_hall_heretic_01 1)
	(ai_place second_hall_grunts_01 2)
	(set stealth_talk_gone TRUE)
	(ai_set_orders arm01_allies allies_second_hall)

	(sleep_until (= (volume_test_objects vol_2nd_hall_01 (players)) TRUE))
	(game_save)
	(ai_place second_hall_heretic_03 1)
	(ai_place second_hall_grunts_03 4)
	(if (< (ai_combat_status second_hall_heretics) ai_combat_status_active)
		(begin
			(ai_set_active_camo arm01_allies TRUE)
			(ai_suppress_combat arm01_allies TRUE)
		)
	)
	
;*	(sleep_until 
		(OR 
			(= (volume_test_objects vol_2nd_hall_03 (players)) TRUE)
;			(< (ai_living_count second_hall_heretics) 3)
			FALSE
		)
	)
	(game_save)
	(ai_place second_hall_heretic_05)
	(ai_place second_hall_heretic_06)
	(cs_run_command_script second_hall_heretic_06 long_pause)
	(if (< (ai_combat_status second_hall_heretics) ai_combat_status_active)
		(begin
			(ai_set_active_camo arm01_allies TRUE)
			(ai_suppress_combat arm01_allies TRUE)
		)
	)

	(sleep_until (< (ai_living_count second_hall_heretics) 1))
	(game_save)
*;
)


;-------------------------------------------------------------------------------
;Bottling Plant Entry and Main Hall

;Temp variables for controlling conveyors
(global boolean bottling_power_on FALSE)

;Spawns cans randomly on lines A, B, and C
(script dormant bottling_can_spawner
	(sleep_until (= bottling_power_on TRUE))
	(sleep_until
		(begin
			(begin_random
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_bottling_can_all 2048)) 10)
						(begin
							(object_create_clone bottling_can_A)
							(sleep recycling_time)
						)
					)
					(sleep recycling_time)
				)
				(begin
					(if (< (list_count (volume_return_objects_by_type vol_bottling_can_all 2048)) 10)
						(begin
							(object_create_clone bottling_can_B)
							(sleep recycling_time)
						)
					)
					(sleep recycling_time)
				)
			)
			(= bottling_power_on FALSE)
		)
	)
)

;Kills crates and characters dropped into pits
(script dormant bottling_killer_new
	(sleep_until (= bottling_power_on TRUE))
	(sleep_until
		(begin
			(object_destroy (list_get (volume_return_objects kill_bottling_pit_01) 0))
			(sleep 45)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_bottling_pit_01 1) 0)))
			(sleep 45)
			(object_destroy (list_get (volume_return_objects kill_bottling_pit_02) 0))
			(sleep 45)
			(unit_kill_silent (unit (list_get (volume_return_objects_by_type kill_bottling_pit_02 1) 0)))
			(sleep 45)
			(= bottling_power_on FALSE)
		)
	)
)

;Command script for heretics calling for sentinels
(script command_script bottling_sentinel_call
	(cs_switch heretic)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC: 'We need Sentinels!'")
	(cs_play_line 0450)
)

;For when the player is out of the first section
(global boolean left_bottling_firsthalf FALSE)

;Tracks number of sentinels spawned overall
(global short bottling_sentinels_spawned 0)

;Spawns new allies if you need them
(script dormant new_allies_03
	(if 
		(AND
			(= (volume_test_objects vol_underhangar_can_all (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(sleep_until
					(begin
						(object_destroy (list_get (volume_return_objects_by_type vol_underhangar_can_all 1) 0))
						(= (list_count (volume_return_objects_by_type vol_underhangar_can_all 1)) 0)
					)
				10)
			)
	)
	(if 
		(AND
			(= (volume_test_objects vol_bottling_reinforce (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count arm01_allies) 3)
		)
			(begin
				(ai_place reinforce_elites_03 (- 1 (ai_living_count allies_elites)))
				(ai_place reinforce_grunts_03 (- 1 (ai_living_count allies_grunts)))
			)
	)
)

;Overall script for first half of bottling plant
(script dormant bottling_firsttime_start
	(data_mine_set_mission_segment "04a_7_bottling_plant")
	(game_save)
	(object_create_containing "bott_can_")
	(ai_renew all_allies)
	(set stealth_talk_gone TRUE)
	(ai_set_orders arm01_allies allies_bottling)

	(wake bottling_can_spawner)
	(wake bottling_killer_new)
	(set bottling_power_on TRUE)

	(ai_migrate second_hall_heretics chasers)
	(ai_set_orders chasers chase02)

	(ai_place bottling_heretics_01 2)
	(ai_place bottling_grunts_01 2)
	(ai_place bottling_sentinels_01 2)

	(sleep_until (= (volume_test_objects vol_bottling_really_inside (players)) TRUE))
	(wake new_allies_03)
	
	(sleep_until 
		(OR 
			(< (ai_living_count bottling_heretics) 2)
			(= (volume_test_objects vol_bottling_mid01 (players)) TRUE)
			FALSE
		)
	)
	(game_save)
	(ai_place bottling_heretics_02 (- 1 (ai_living_count bottling_heretics_01)))
	(ai_place bottling_grunts_02 (- 4 (ai_living_count bottling_grunts_01)))
	
	(sleep_until 
		(OR 
			(< (ai_living_count bottling_heretics) 2)
			(= (volume_test_objects vol_bottling_mid02 (players)) TRUE)
			FALSE
		)
	)
	(game_save)
	(ai_place bottling_heretics_03 (- 2 (+ (ai_living_count bottling_heretics_01) (ai_living_count bottling_heretics_02))))
	(ai_place bottling_grunts_03 (- 3 (+ (ai_living_count bottling_grunts_02) (ai_living_count bottling_grunts_01))))

	(sleep_until 
		(AND 
			(< (ai_living_count bottling_heretics) 1)
			(< (ai_living_count bottling_sentinels) 1)
		)
	)
	(game_save)
)


;-------------------------------------------------------------------------------
;Bottling Plant Back Passage and Overlook Room

;First heretic leader scene!
(script command_script hl_retreat_01
	(cs_switch heretic_01)
	(cs_force_combat_status 4)
	(cs_face_player TRUE)
;	(cs_play_line ???)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC LEADER: 'There! The assassin!'")
	(cs_custom_animation objects\characters\elite\elite "combat:rifle:warn" 1 TRUE)
	(cs_face_player FALSE)
)

;Just in case scene fails
(script command_script hl_retreat_backup
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to bottling_plant/p1)
	(ai_erase heretic_leader_02)
)

;Scripts two sentinels to fly off with the heretic leader
(script command_script sentinel_wingmen_a
	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_pause 1)
	(cs_fly_to airspace_hl/sen_a_0 5)
	(cs_fly_to airspace_hl/sen_a_1 20)
	(ai_erase bottling_sentinels_03/a)
)
(script command_script sentinel_wingmen_b
	(cs_enable_pathfinding_failsafe TRUE)
;	(cs_pause 1)
	(cs_fly_to airspace_hl/sen_b_0 5)
	(cs_fly_to airspace_hl/sen_b_1 20)
	(ai_erase bottling_sentinels_03/b)
)

;For when he's done yapping
(global boolean hl_done_yapping FALSE)

;Second heretic leader scene!
(script command_script hl_retreat_02
;	(cs_switch heretic_leader)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
;	(cs_go_to_and_face bottling_plant/p3 bottling_plant/p2)
;	(cs_custom_animation objects\characters\elite\elite "combat:rifle:warn" 1 TRUE)
;	(cs_approach (list_get (ai_actors bottling_heretics_05) 0) 5 20 20)
	(cs_approach approach_here 1 20 20)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC LEADER: 'Deal with him, my brothers!'")
	(cs_play_line 0470)
	(sleep 15)
	(print "'I will defend the Oracle!'")
	(cs_play_line 0480)
	(set hl_done_yapping TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_01/center) FALSE)
	(cs_approach_stop)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location ledge_banshees_01/center))
;	(cs_run_command_script bottling_sentinels_03/a sentinel_wingmen_a)
;	(cs_run_command_script bottling_sentinels_03/b sentinel_wingmen_b)
	
	(wake music_04a_03_start)
	
	(cs_fly_to airspace_hl/hl0 5)
	(cs_vehicle_boost TRUE)
	(cs_fly_to airspace_hl/hl1 20)
	(ai_erase heretic_leader_03)
)

(script command_script hl_retreat_react
	(cs_switch heretic)
	(cs_force_combat_status 4)
	(cs_enable_moving TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "HERETIC: 'Its truth must not be silenced!'")
	(cs_play_line 0490)
)	
	
;Staggers spawning of sentinels in bottling plant overlook
(script dormant bottling_overlook_reinforce
	(ai_place bottling_sentinels_02 1)
	(sleep 120)
	(ai_place bottling_sentinels_02 1)
	(sleep 120)
	(ai_place bottling_sentinels_02 1)
)

;Flies phantom to ledge and parks it
(script command_script phantom_to_ledge
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .75)
	(cs_fly_by airspace/ph0x 10)
	(cs_fly_to_and_face airspace/ph00 airspace/ph01 5)
	(sleep_forever)
)

;Any surviving allies tell you they'll hang back
(script command_script bottling_elites_secure
	(cs_switch elite)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS ELITE: 'Onward, Arbiter!  We will secure this section of the station!'")
	(cs_play_line 1170)
)	
(script command_script bottling_grunts_secure
	(cs_switch grunt)
	(cs_abort_on_damage TRUE)
	(cs_suppress_dialogue_global TRUE)
	(print "SPEC-OPS GRUNT: 'You go. We stay. Grunt not allowed to fly.'")
	(cs_play_line 1180)
)
(script dormant bottling_allies_secure
	(sleep_until 
		(OR 
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player1))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player1))) TRUE)
		)
	30 900)
	(if 
		(AND 
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player0))) FALSE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player0))) FALSE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player1))) FALSE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player1))) FALSE)
		)
			(begin
				(if (> (ai_living_count allies_elites) 0)
					(ai_scene bottling_elite_scene bottling_elites_secure allies_elites)
					(ai_scene bottling_grunt_scene bottling_grunts_secure allies_grunts)
				)
			)
	)
)

(script dormant big_filth_toggle
	(sleep_until (= (volume_test_objects vol_on_banshee_ledge (players)) TRUE))
	(sound_class_set_gain ambient_machinery 0 2)
	(object_create Big_filthy_audio1)
	(sound_class_set_gain ambient_machinery 1 2)
	(sleep_until 
		(begin
			(sleep_until 
				(OR
					(= (volume_test_objects vol_bottling_back_top (players)) TRUE)
					(= (volume_test_objects vol_bottling_back (players)) TRUE)
					(= (volume_test_objects vol_bottling_exit_r (players)) TRUE)
					(= (volume_test_objects vol_bottling_exit_l (players)) TRUE)
				)
			)
			(sound_class_set_gain ambient_machinery 0 2)
			(object_destroy Big_filthy_audio1)
			(sound_class_set_gain ambient_machinery 1 2)
			(sleep_until (= (volume_test_objects vol_on_banshee_ledge (players)) TRUE))
			(sound_class_set_gain ambient_machinery 0 2)
			(object_create Big_filthy_audio1)
			(sound_class_set_gain ambient_machinery 1 2)
			FALSE
		)
	)
)

;Brings the phantom in
(script dormant bring_in_da_phantom
	(sleep_until 
		(OR 
			(= (volume_test_objects vol_bottling_exit_l (players)) TRUE) 
			(= (volume_test_objects vol_bottling_exit_r (players)) TRUE)
			(= (volume_test_objects vol_on_banshee_ledge (players)) TRUE)
		)
	)
	(game_save)
	(wake 04a_title1)
	(wake big_filth_toggle)
	(ai_place allied_phantom_01)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location allied_phantom_01/driver))
	(cs_run_command_script allied_phantom_01/driver phantom_to_ledge)
	
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'The heretics are mobilizing their air-forces, Dervish!'")
	(sleep (ai_play_line_on_object NONE 0500))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0500_soc))
	(sleep 15)
	(print "'Get after their leader, but watch your back!'")
	(sleep (ai_play_line_on_object NONE 0510))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0510_soc))
	(sleep 15)
	(print "'I'm sending one of our Phantoms to support you!'")
	(sleep (ai_play_line_on_object NONE 0520))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0520_soc))		
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

(global boolean overlook_choose_side FALSE)

;Overall script for second half of bottling plant
(script dormant bottling_plant_end
	(sleep_until (= (volume_test_objects vol_bottling_back (players)) TRUE))
	(data_mine_set_mission_segment "04a_8_bottling_back")
	(game_save)
;	(ai_place heretic_leader_02)
;	(cs_run_command_script heretic_leader_02 long_pause)
;	(object_cannot_take_damage (ai_actors heretic_leader_02))

	(ai_migrate bottling_heretics_start chasers)
	(ai_set_orders chasers chase03)

	(if (< (ai_living_count bottling_enemies) 8)
		(ai_place bottling_heretics_04 2)
	)

;	(sleep_until (= (volume_test_objects vol_bottling_back (players)) TRUE))
;	(game_save)
	;(ai_scene heretic_retreat_01_scene hl_retreat_01 bottling_heretics_04)
	(ai_place dog_turrets_01)
	(ai_place ledge_banshees_01)
;	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_01/center))
;	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_01/left))
;	(object_cannot_take_damage (ai_vehicle_get_from_starting_location ledge_banshees_01/right))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_01/center) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_01/left) TRUE)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location ledge_banshees_01/right) TRUE)

;	(ai_place bottling_sentinels_03 2)
;	(cs_run_command_script bottling_sentinels_03 long_pause)
	(ai_place bottling_heretics_05 2)
	(ai_place heretic_leader_03)
	(cs_run_command_script heretic_leader_03 long_pause)
	(object_cannot_take_damage (ai_actors heretic_leader_03))
	(set left_bottling_firsthalf TRUE)

	(sleep_until (= (volume_test_objects vol_hl_delete_02 (players)) TRUE) 30 90)
	(if 
		(AND
			(= (volume_test_objects vol_hl_delete_02 (players)) FALSE)
			(> (player_count) 0)
			(< (ai_living_count bottling_enemies) 8)
		)
			(ai_place bottling_grunts_04 3)
	)

	(sleep_until (= (volume_test_objects vol_hl_delete_02 (players)) TRUE))
	(cs_run_command_script heretic_leader_03 hl_retreat_02)
	
	(sleep_until (= hl_done_yapping TRUE) 30 450)
	(sleep_until (ai_scene heretic_retreat_02_scene hl_retreat_react bottling_heretics_05) 30 90)
	(game_save)
		
	(begin_random
		(if (= overlook_choose_side FALSE)
			(begin
				(set overlook_choose_side TRUE)
				(ai_place bottling_grunts_05/R1) 
				(ai_place bottling_grunts_05/R2) 
				(ai_place bottling_grunts_05/R3) 
				(device_operates_automatically_set viewroom_exit02 TRUE)
				(object_create blocker_L)
			)
		)
		(if (= overlook_choose_side FALSE)
			(begin
				(set overlook_choose_side TRUE)
				(ai_place bottling_grunts_05/L1) 
				(ai_place bottling_grunts_05/L2) 
				(ai_place bottling_grunts_05/L3) 
				(device_operates_automatically_set viewroom_exit01 TRUE)
				(object_create blocker_R)
			)
		)
	)
	(ai_set_orders bottling_heretics_05 bottling_h_wave_05_high)
	(wake bring_in_da_phantom)

	(sleep_until (< (ai_living_count bottling_heretics_05) 1))
	(game_save)
	(wake bottling_overlook_reinforce)

	(sleep_until 
		(AND 
			(< (ai_living_count bottling_heretics) 1)
			(< (ai_living_count bottling_sentinels) 1)
		)
	)
	(game_save)
	(wake bottling_allies_secure)
)


;-------------------------------------------------------------------------------
;Banshee Dogfight 1

(script command_script partytime
	(cs_face TRUE arm02_lz/cake)
	(sleep_forever)
)

(script dormant grunt_birthday_party
	(sleep_until (= (volume_test_objects vol_grunt_bday (players)) TRUE))
	(object_create bday_cake)
	(ai_place bday_party)
	(cs_run_command_script bday_party partytime)
	(custom_animation_loop (unit (list_get (ai_actors bday_party) 0)) objects\characters\grunt\grunt "combat:pistol:cheer" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors bday_party) 1)) objects\characters\grunt\grunt "combat:pistol:cheer" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors bday_party) 2)) objects\characters\grunt\grunt "combat:pistol:cheer" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors bday_party) 3)) objects\characters\grunt\grunt "combat:pistol:cheer" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors bday_party) 4)) objects\characters\grunt\grunt "combat:pistol:cheer" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors bday_party) 5)) objects\characters\grunt\grunt "combat:pistol:cheer" TRUE)

;9/13

	(sleep_until 
		(OR
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	)
	(ice_cream_flavor_stock 1)
)

;Ugly hack to give you a new banshee when your back is turned
(script dormant banshee_stuck_spawner_01
	(sleep_until (= (unit_in_vehicle (player0)) TRUE))
	(sleep_until 
		(begin
			(sleep_until
				(AND
					(= (unit_in_vehicle (player0)) FALSE)
					(= (volume_test_object vol_arm_02_lz (player0)) FALSE)
					(> (player_count) 0)
				)
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_01 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
									(= (objects_can_see_flag (players) 01a 45) FALSE)
									(> (objects_distance_to_flag (players) 01a) 2)
								)
									(object_create_clone extra01a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
									(= (objects_can_see_flag (players) 01b 45) FALSE)
									(> (objects_distance_to_flag (players) 01b) 2)
								)
									(object_create_clone extra01b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
									(= (objects_can_see_flag (players) 01c 45) FALSE)
									(> (objects_distance_to_flag (players) 01c) 2)
								)
									(object_create_clone extra01c)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
									(= (objects_can_see_flag (players) 01d 45) FALSE)
									(> (objects_distance_to_flag (players) 01d) 2)
								)
									(object_create_clone extra01d)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_02 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
									(= (objects_can_see_flag (players) 02a 45) FALSE)
									(> (objects_distance_to_flag (players) 02a) 2)
								)
									(object_create_clone extra02a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
									(= (objects_can_see_flag (players) 02b 45) FALSE)
									(> (objects_distance_to_flag (players) 02b) 2)
								)
									(object_create_clone extra02b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
									(= (objects_can_see_flag (players) 02c 45) FALSE)
									(> (objects_distance_to_flag (players) 02c) 2)
								)
									(object_create_clone extra02c)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
									(= (objects_can_see_flag (players) 02d 45) FALSE)
									(> (objects_distance_to_flag (players) 02d) 2)
								)
									(object_create_clone extra02d)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_03 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_03 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_03 2)) 0)
									(= (objects_can_see_flag (players) 03a 45) FALSE)
									(> (objects_distance_to_flag (players) 03a) 2)
								)
									(object_create_clone extra03a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_03 2)) 0)
									(= (objects_can_see_flag (players) 03b 45) FALSE)
									(> (objects_distance_to_flag (players) 03b) 2)
								)
									(object_create_clone extra03b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_03 2)) 0)
									(= (objects_can_see_flag (players) 03c 45) FALSE)
									(> (objects_distance_to_flag (players) 03c) 2)
								)
									(object_create_clone extra03c)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_04 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_04 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_04 2)) 0)
									(= (objects_can_see_flag (players) 04a 45) FALSE)
									(> (objects_distance_to_flag (players) 04a) 2)
								)
									(object_create_clone extra04a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_04 2)) 0)
									(= (objects_can_see_flag (players) 04b 45) FALSE)
									(> (objects_distance_to_flag (players) 04b) 2)
								)
									(object_create_clone extra04b)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_05 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_05 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_05 2)) 0)
									(= (objects_can_see_flag (players) 05a 45) FALSE)
									(> (objects_distance_to_flag (players) 05a) 2)
								)
									(object_create_clone extra05a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_05 2)) 0)
									(= (objects_can_see_flag (players) 05b 45) FALSE)
									(> (objects_distance_to_flag (players) 05b) 2)
								)
									(object_create_clone extra05b)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_06 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_06 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_06 2)) 0)
									(= (objects_can_see_flag (players) 06a 45) FALSE)
									(> (objects_distance_to_flag (players) 06a) 2)
								)
									(object_create_clone extra06a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_06 2)) 0)
									(= (objects_can_see_flag (players) 06b 45) FALSE)
									(> (objects_distance_to_flag (players) 06b) 2)
								)
									(object_create_clone extra06b)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_07 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_07 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_07 2)) 0)
									(= (objects_can_see_flag (players) 07a 45) FALSE)
									(> (objects_distance_to_flag (players) 07a) 2)
								)
									(object_create_clone extra07a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_07 2)) 0)
									(= (objects_can_see_flag (players) 07b 45) FALSE)
									(> (objects_distance_to_flag (players) 07b) 2)
								)
									(object_create_clone extra07b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_07 2)) 0)
									(= (objects_can_see_flag (players) 07c 45) FALSE)
									(> (objects_distance_to_flag (players) 07c) 2)
								)
									(object_create_clone extra07c)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_08 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_08 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_08 2)) 0)
									(= (objects_can_see_flag (players) 08a 45) FALSE)
									(> (objects_distance_to_flag (players) 08a) 2)
								)
									(object_create_clone extra08a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_08 2)) 0)
									(= (objects_can_see_flag (players) 08b 45) FALSE)
									(> (objects_distance_to_flag (players) 08b) 2)
								)
									(object_create_clone extra08b)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_09 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_09 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_09 2)) 0)
									(= (objects_can_see_flag (players) 09a 45) FALSE)
									(> (objects_distance_to_flag (players) 09a) 2)
								)
									(object_create_clone extra09a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_09 2)) 0)
									(= (objects_can_see_flag (players) 09b 45) FALSE)
									(> (objects_distance_to_flag (players) 09b) 2)
								)
									(object_create_clone extra09b)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_10 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_10 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_10 2)) 0)
									(= (objects_can_see_flag (players) 10a 45) FALSE)
									(> (objects_distance_to_flag (players) 10a) 2)
								)
									(object_create_clone extra10a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_10 2)) 0)
									(= (objects_can_see_flag (players) 10b 45) FALSE)
									(> (objects_distance_to_flag (players) 10b) 2)
								)
									(object_create_clone extra10b)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_11 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_11 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_11 2)) 0)
									(= (objects_can_see_flag (players) 11a 45) FALSE)
									(> (objects_distance_to_flag (players) 11a) 2)
								)
									(object_create_clone extra11a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_11 2)) 0)
									(= (objects_can_see_flag (players) 11b 45) FALSE)
									(> (objects_distance_to_flag (players) 11b) 2)
								)
									(object_create_clone extra11b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_11 2)) 0)
									(= (objects_can_see_flag (players) 11c 45) FALSE)
									(> (objects_distance_to_flag (players) 11c) 2)
								)
									(object_create_clone extra11c)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_12 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_12 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_12 2)) 0)
									(= (objects_can_see_flag (players) 12a 45) FALSE)
									(> (objects_distance_to_flag (players) 12a) 2)
								)
									(object_create_clone extra12a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_12 2)) 0)
									(= (objects_can_see_flag (players) 12b 45) FALSE)
									(> (objects_distance_to_flag (players) 12b) 2)
								)
									(object_create_clone extra12b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_12 2)) 0)
									(= (objects_can_see_flag (players) 12c 45) FALSE)
									(> (objects_distance_to_flag (players) 12c) 2)
								)
									(object_create_clone extra12c)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_13 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_13 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_13 2)) 0)
									(= (objects_can_see_flag (players) 13a 45) FALSE)
									(> (objects_distance_to_flag (players) 13a) 2)
								)
									(object_create_clone extra13a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_13 2)) 0)
									(= (objects_can_see_flag (players) 13b 45) FALSE)
									(> (objects_distance_to_flag (players) 13b) 2)
								)
									(object_create_clone extra13b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_13 2)) 0)
									(= (objects_can_see_flag (players) 13c 45) FALSE)
									(> (objects_distance_to_flag (players) 13c) 2)
								)
									(object_create_clone extra13c)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_14 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_14 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_14 2)) 0)
									(= (objects_can_see_flag (players) 14a 45) FALSE)
									(> (objects_distance_to_flag (players) 14a) 2)
								)
									(object_create_clone extra14a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_14 2)) 0)
									(= (objects_can_see_flag (players) 14b 45) FALSE)
									(> (objects_distance_to_flag (players) 14b) 2)
								)
									(object_create_clone extra14b)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_15 (player0)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_15 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_15 2)) 0)
									(= (objects_can_see_flag (players) 15a 45) FALSE)
									(> (objects_distance_to_flag (players) 15a) 2)
								)
									(object_create_clone extra15a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_15 2)) 0)
									(= (objects_can_see_flag (players) 15b 45) FALSE)
									(> (objects_distance_to_flag (players) 15b) 2)
								)
									(object_create_clone extra15b)
							)
							(= (unit_in_vehicle (player0)) TRUE)
						)
					)			
			)
			FALSE
		)
	)
)
(script dormant banshee_stuck_spawner_02
	(sleep_until (= (unit_in_vehicle (player1)) TRUE))
	(sleep_until 
		(begin
			(sleep_until
				(AND
					(= (unit_in_vehicle (player1)) FALSE)
					(= (volume_test_object vol_arm_02_lz (player1)) FALSE)
					(> (player_count) 0)
				)
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_01 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
									(= (objects_can_see_flag (players) 01a 45) FALSE)
									(> (objects_distance_to_flag (players) 01a) 2)
								)
									(object_create_clone extra01a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
									(= (objects_can_see_flag (players) 01b 45) FALSE)
									(> (objects_distance_to_flag (players) 01b) 2)
								)
									(object_create_clone extra01b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
									(= (objects_can_see_flag (players) 01c 45) FALSE)
									(> (objects_distance_to_flag (players) 01c) 2)
								)
									(object_create_clone extra01c)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
									(= (objects_can_see_flag (players) 01d 45) FALSE)
									(> (objects_distance_to_flag (players) 01d) 2)
								)
									(object_create_clone extra01d)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_02 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
									(= (objects_can_see_flag (players) 02a 45) FALSE)
									(> (objects_distance_to_flag (players) 02a) 2)
								)
									(object_create_clone extra02a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
									(= (objects_can_see_flag (players) 02b 45) FALSE)
									(> (objects_distance_to_flag (players) 02b) 2)
								)
									(object_create_clone extra02b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
									(= (objects_can_see_flag (players) 02c 45) FALSE)
									(> (objects_distance_to_flag (players) 02c) 2)
								)
									(object_create_clone extra02c)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_02 2)) 0)
									(= (objects_can_see_flag (players) 02d 45) FALSE)
									(> (objects_distance_to_flag (players) 02d) 2)
								)
									(object_create_clone extra02d)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_03 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_03 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_03 2)) 0)
									(= (objects_can_see_flag (players) 03a 45) FALSE)
									(> (objects_distance_to_flag (players) 03a) 2)
								)
									(object_create_clone extra03a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_03 2)) 0)
									(= (objects_can_see_flag (players) 03b 45) FALSE)
									(> (objects_distance_to_flag (players) 03b) 2)
								)
									(object_create_clone extra03b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_03 2)) 0)
									(= (objects_can_see_flag (players) 03c 45) FALSE)
									(> (objects_distance_to_flag (players) 03c) 2)
								)
									(object_create_clone extra03c)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_04 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_04 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_04 2)) 0)
									(= (objects_can_see_flag (players) 04a 45) FALSE)
									(> (objects_distance_to_flag (players) 04a) 2)
								)
									(object_create_clone extra04a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_04 2)) 0)
									(= (objects_can_see_flag (players) 04b 45) FALSE)
									(> (objects_distance_to_flag (players) 04b) 2)
								)
									(object_create_clone extra04b)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_05 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_05 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_05 2)) 0)
									(= (objects_can_see_flag (players) 05a 45) FALSE)
									(> (objects_distance_to_flag (players) 05a) 2)
								)
									(object_create_clone extra05a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_05 2)) 0)
									(= (objects_can_see_flag (players) 05b 45) FALSE)
									(> (objects_distance_to_flag (players) 05b) 2)
								)
									(object_create_clone extra05b)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_06 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_06 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_06 2)) 0)
									(= (objects_can_see_flag (players) 06a 45) FALSE)
									(> (objects_distance_to_flag (players) 06a) 2)
								)
									(object_create_clone extra06a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_06 2)) 0)
									(= (objects_can_see_flag (players) 06b 45) FALSE)
									(> (objects_distance_to_flag (players) 06b) 2)
								)
									(object_create_clone extra06b)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_07 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_07 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_07 2)) 0)
									(= (objects_can_see_flag (players) 07a 45) FALSE)
									(> (objects_distance_to_flag (players) 07a) 2)
								)
									(object_create_clone extra07a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_07 2)) 0)
									(= (objects_can_see_flag (players) 07b 45) FALSE)
									(> (objects_distance_to_flag (players) 07b) 2)
								)
									(object_create_clone extra07b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_07 2)) 0)
									(= (objects_can_see_flag (players) 07c 45) FALSE)
									(> (objects_distance_to_flag (players) 07c) 2)
								)
									(object_create_clone extra07c)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_08 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_08 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_08 2)) 0)
									(= (objects_can_see_flag (players) 08a 45) FALSE)
									(> (objects_distance_to_flag (players) 08a) 2)
								)
									(object_create_clone extra08a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_08 2)) 0)
									(= (objects_can_see_flag (players) 08b 45) FALSE)
									(> (objects_distance_to_flag (players) 08b) 2)
								)
									(object_create_clone extra08b)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_09 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_09 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_09 2)) 0)
									(= (objects_can_see_flag (players) 09a 45) FALSE)
									(> (objects_distance_to_flag (players) 09a) 2)
								)
									(object_create_clone extra09a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_09 2)) 0)
									(= (objects_can_see_flag (players) 09b 45) FALSE)
									(> (objects_distance_to_flag (players) 09b) 2)
								)
									(object_create_clone extra09b)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_10 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_10 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_10 2)) 0)
									(= (objects_can_see_flag (players) 10a 45) FALSE)
									(> (objects_distance_to_flag (players) 10a) 2)
								)
									(object_create_clone extra10a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_10 2)) 0)
									(= (objects_can_see_flag (players) 10b 45) FALSE)
									(> (objects_distance_to_flag (players) 10b) 2)
								)
									(object_create_clone extra10b)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_11 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_11 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_11 2)) 0)
									(= (objects_can_see_flag (players) 11a 45) FALSE)
									(> (objects_distance_to_flag (players) 11a) 2)
								)
									(object_create_clone extra11a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_11 2)) 0)
									(= (objects_can_see_flag (players) 11b 45) FALSE)
									(> (objects_distance_to_flag (players) 11b) 2)
								)
									(object_create_clone extra11b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_11 2)) 0)
									(= (objects_can_see_flag (players) 11c 45) FALSE)
									(> (objects_distance_to_flag (players) 11c) 2)
								)
									(object_create_clone extra11c)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_12 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_12 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_12 2)) 0)
									(= (objects_can_see_flag (players) 12a 45) FALSE)
									(> (objects_distance_to_flag (players) 12a) 2)
								)
									(object_create_clone extra12a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_12 2)) 0)
									(= (objects_can_see_flag (players) 12b 45) FALSE)
									(> (objects_distance_to_flag (players) 12b) 2)
								)
									(object_create_clone extra12b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_12 2)) 0)
									(= (objects_can_see_flag (players) 12c 45) FALSE)
									(> (objects_distance_to_flag (players) 12c) 2)
								)
									(object_create_clone extra12c)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_13 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_13 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_13 2)) 0)
									(= (objects_can_see_flag (players) 13a 45) FALSE)
									(> (objects_distance_to_flag (players) 13a) 2)
								)
									(object_create_clone extra13a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_13 2)) 0)
									(= (objects_can_see_flag (players) 13b 45) FALSE)
									(> (objects_distance_to_flag (players) 13b) 2)
								)
									(object_create_clone extra13b)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_13 2)) 0)
									(= (objects_can_see_flag (players) 13c 45) FALSE)
									(> (objects_distance_to_flag (players) 13c) 2)
								)
									(object_create_clone extra13c)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_14 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_14 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_14 2)) 0)
									(= (objects_can_see_flag (players) 14a 45) FALSE)
									(> (objects_distance_to_flag (players) 14a) 2)
								)
									(object_create_clone extra14a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_14 2)) 0)
									(= (objects_can_see_flag (players) 14b 45) FALSE)
									(> (objects_distance_to_flag (players) 14b) 2)
								)
									(object_create_clone extra14b)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			(if 
				(AND
					(= (volume_test_object vol_stuck_15 (player1)) TRUE)
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_15 2)) 0)
				)
					(sleep_until
						(begin
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_15 2)) 0)
									(= (objects_can_see_flag (players) 15a 45) FALSE)
									(> (objects_distance_to_flag (players) 15a) 2)
								)
									(object_create_clone extra15a)
							)
							(if 
								(AND
									(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_15 2)) 0)
									(= (objects_can_see_flag (players) 15b 45) FALSE)
									(> (objects_distance_to_flag (players) 15b) 2)
								)
									(object_create_clone extra15b)
							)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)			
			)
			FALSE
		)
	)
)

;---

;To track the phantom's position on its course
(global short phantom_course_pos 0)

;A pointless attempt at flying the phantom by command script
(script command_script phantom_path
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .1)
	(cs_fly_by airspace/ph01 10)
	(set phantom_course_pos 1) 
	(cs_fly_by airspace/ph02 10) 
	(set phantom_course_pos 2) 
	(cs_fly_by airspace/ph03 10) 
	(set phantom_course_pos 3) 
	(cs_fly_by airspace/ph04 10) 
	(set phantom_course_pos 4) 
	(cs_fly_by airspace/ph05 10) 
	(set phantom_course_pos 5) 
	(cs_fly_by airspace/ph06 10) 
	(set phantom_course_pos 6) 
	(cs_fly_by airspace/ph07 10) 
	(set phantom_course_pos 7) 
	(cs_fly_by airspace/ph08 10) 
	(set phantom_course_pos 8) 
	(cs_fly_by airspace/ph09 10) 
	(set phantom_course_pos 9) 
	(cs_fly_by airspace/ph10 10) 
	(set phantom_course_pos 10) 
	(cs_fly_by airspace/ph11 10) 
	(set phantom_course_pos 11) 
	(cs_vehicle_speed .05)
	(cs_fly_by airspace/ph12 10) 
	(set phantom_course_pos 12) 
	(cs_fly_to airspace/ph13 5) 
	(set phantom_course_pos 13)
	(cs_pause -1) 
)

;Makes the guys entering the research arm with you act cool
(script command_script arm02_SWAT_aim_00
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to arm02_lz/p0)
	(cs_aim TRUE arm02_lz/door)
	(sleep_forever)
)
(script command_script arm02_SWAT_aim_01
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to arm02_lz/p1)
	(cs_aim TRUE arm02_lz/door)
	(sleep_forever)
)
(script command_script arm02_SWAT_aim_02
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to arm02_lz/p2)
	(cs_aim TRUE arm02_lz/door)
	(sleep_forever)
)
(script command_script arm02_SWAT_aim_03
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to arm02_lz/p3)
	(cs_aim TRUE arm02_lz/door)
	(sleep_forever)
)

(script command_script arm02_final_approach
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed .5)
	(cs_fly_to airspace/ph13 2)
	(sleep 60)
	
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_01/driver) "phantom_p_a01")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_01/driver) "phantom_p_a02")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_01/driver) "phantom_p_a03")
	(cs_run_command_script allies_elites_03/elite01 arm02_SWAT_aim_00)
	(cs_run_command_script allies_elites_03/elite02 arm02_SWAT_aim_01)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_01/driver) "phantom_p_b01")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_01/driver) "phantom_p_b02")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_01/driver) "phantom_p_b03")
 	(cs_run_command_script allies_grunts_03/grunt01 arm02_SWAT_aim_02)
	(cs_run_command_script allies_grunts_03/grunt02 arm02_SWAT_aim_03)

	(cs_pause -1) 
)

(global boolean dogfight_ph_pilot_go FALSE)

;Commander says the heretic leader ain't here and to keep looking
(script dormant dogfight_search_reminder
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'No sign of the Heretic-Leader or his Banshee. We must keep searching!'")
	(sleep (ai_play_line_on_object NONE 1210))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1210_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
;	(sleep 30)
;	(set dogfight_ph_pilot_go TRUE)	
)

;Phantom pilot dialogue
(script dormant dogfight_ph_pilot_talk
	(begin_random
		(begin
			(sleep_until (= dogfight_ph_pilot_go TRUE))
			(set dogfight_ph_pilot_go FALSE)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'Emplacement destroyed! Heading to the next target!'")
			(sleep (ai_play_line_on_object NONE 2050))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_2050_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
		(begin
			(sleep_until (= dogfight_ph_pilot_go TRUE))
			(set dogfight_ph_pilot_go FALSE)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'All Heretic forces have been eliminated! Moving on!'")
			(sleep (ai_play_line_on_object NONE 2060))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_2060_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
		(begin
			(sleep_until (= dogfight_ph_pilot_go TRUE))
			(set dogfight_ph_pilot_go FALSE)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'This area is clear! Let us continue!'")
			(sleep (ai_play_line_on_object NONE 2070))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_2070_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
		(begin
			(sleep_until (= dogfight_ph_pilot_go TRUE))
			(set dogfight_ph_pilot_go FALSE)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'That is the last of them! But there are more ahead!'")
			(sleep (ai_play_line_on_object NONE 2080))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_2080_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
		(begin
			(sleep_until (= dogfight_ph_pilot_go TRUE))
			(set dogfight_ph_pilot_go FALSE)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'These Heretics are dead. Onward!'")
			(sleep (ai_play_line_on_object NONE 2090))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_2090_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
		(begin
			(sleep_until (= dogfight_ph_pilot_go TRUE))
			(set dogfight_ph_pilot_go FALSE)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'Follow me, Arbiter! I have found another emplacement!'")
			(sleep (ai_play_line_on_object NONE 2100))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_2100_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
		(begin
			(sleep_until (= dogfight_ph_pilot_go TRUE))
			(set dogfight_ph_pilot_go FALSE)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'This way, Arbiter! I see another Heretic position!'")
			(sleep (ai_play_line_on_object NONE 2110))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_2110_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
		(begin
			(sleep_until (= dogfight_ph_pilot_go TRUE))
			(set dogfight_ph_pilot_go FALSE)
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "PHANTOM PILOT: 'Do you see, Arbiter? More Heretics have gathered there!'")
			(sleep (ai_play_line_on_object NONE 2120))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_2120_scl))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)

;Boost banshees into combat
(script command_script boost_test
	(cs_vehicle_boost TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_enable_moving TRUE)
	(sleep_until 
		(OR
			(< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 50)
			(< (objects_distance_to_object (ai_actors allied_phantom_01) (ai_get_object ai_current_actor)) 50)
		)
	)
)

;Saving in air
(global boolean try_to_save_now FALSE)
(global boolean dogfight_over FALSE)
(script dormant banshee_fight_saving
	(sleep_until
		(begin
			(sleep_until (= try_to_save_now TRUE))
			(sleep_until 
				(AND
					(unit_in_vehicle (unit (player0)))
					(OR
						(unit_in_vehicle (unit (player1)))
						(= (game_is_cooperative) FALSE)
					)
					(game_safe_to_save)
				)
			)
			(game_save_immediate)
			(set try_to_save_now FALSE)
			(= dogfight_over TRUE)
		)
	)
)

;Now trying it with orders
(global boolean emplace_01_done FALSE)
(global boolean emplace_02_done FALSE)
(global boolean emplace_03_done FALSE)
(global boolean emplace_04_done FALSE)
(global boolean emplace_05_done FALSE)
(global boolean emplace_06_done FALSE)
(global short dogfighters_spawned 0)

(script dormant phantom_path_w_orders
	(wake banshee_fight_saving)
	(cs_run_command_script allied_phantom_01/driver abort)
	(ai_set_orders allied_phantom_01 dog_ph_obj_01)
	(wake dogfight_ph_pilot_talk)

	(sleep 30)
	(sleep_until (= emplace_01_done TRUE) 30 4000)
	(sleep_until (= (ai_trigger_test "done_fighting" dog_obj_emplaced_01) TRUE) 30 2000)	
	(print "cleared")
	(sleep 150)
	(ai_set_orders allied_phantom_01 dog_ph_obj_02)
	(game_save_no_timeout)

	(set dogfighters_spawned 0)
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_03 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_03)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_02)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_03 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_01 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_01)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_02)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_01 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_02 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_02)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_02)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_02 boost_test)
					)
			)
			(sleep_until 
				(OR 
			;		(= (volume_test_objects vol_dog_obj_02 (players)) TRUE) 
					(= (volume_test_objects vol_dog_obj_02 (ai_actors allied_phantom_01)) TRUE) 
					(< (ai_living_count dogfighters_01) 2)
				)
			)
			(OR 
			;	(= (volume_test_objects vol_dog_obj_02 (players)) TRUE) 
				(= (volume_test_objects vol_dog_obj_02 (ai_actors allied_phantom_01)) TRUE)
				(> dogfighters_spawned 3)
			)
		)
	30 4000)
	(ai_set_orders allied_phantom_01 dog_ph_obj_03)
	(game_save_no_timeout)

	(set dogfighters_spawned 0)
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_05 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_05)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_03)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_05 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_03 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_03)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_03)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_03 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_04 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_04)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_03)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_04 boost_test)
					)
			)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_dog_obj_03 (players)) TRUE) 
					(= (volume_test_objects vol_dog_obj_03 (ai_actors allied_phantom_01)) TRUE) 
					(< (ai_living_count dogfighters_01) 2)
				)
			)
			(OR 
				(= (volume_test_objects vol_dog_obj_03 (players)) TRUE) 
				(= (volume_test_objects vol_dog_obj_03 (ai_actors allied_phantom_01)) TRUE)
				(> dogfighters_spawned 3)
			)
		)
	30 4000)
	
	(sleep 30)
	(sleep_until (= emplace_03_done TRUE) 30 1800)
	(sleep_until (= (ai_trigger_test "done_fighting" dog_obj_emplaced_03) TRUE) 30 1800)	
	(print "cleared")
	(sleep 30)
	(if (= (volume_test_objects vol_dog_obj_04 (players)) FALSE)
		(set dogfight_ph_pilot_go TRUE)
	)
	(ai_set_orders allied_phantom_01 dog_ph_obj_04)
	(game_save_no_timeout)

	(set dogfighters_spawned 0)
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_05 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_05)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_04)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_05 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_06 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_06)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_04)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_06 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_04 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_04)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_04)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_04 boost_test)
					)
			)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_dog_obj_04 (players)) TRUE) 
					(= (volume_test_objects vol_dog_obj_04 (ai_actors allied_phantom_01)) TRUE) 
					(< (ai_living_count dogfighters_01) 2)
				)
			)
			(OR 
				(= (volume_test_objects vol_dog_obj_04 (players)) TRUE) 
				(= (volume_test_objects vol_dog_obj_04 (ai_actors allied_phantom_01)) TRUE)
				(> dogfighters_spawned 3)
			)
		)
	30 4000)
	
	(sleep 30)
	(sleep_until (= emplace_04_done TRUE) 30 1800)
	(sleep_until (= (ai_trigger_test "done_fighting" dog_obj_emplaced_04) TRUE) 30 1800)	
	(sleep 60)
	(wake dogfight_search_reminder)
	(print "cleared")
	(sleep 30)

	(ai_set_orders allied_phantom_01 dog_ph_obj_06)
	(game_save_no_timeout)

	(set dogfighters_spawned 0)
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_01 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_01)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_06)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_01 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_06 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_06)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_06)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_06 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_07 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_07)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_06)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_07 boost_test)
					)
			)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_dog_obj_06 (players)) TRUE) 
					(= (volume_test_objects vol_dog_obj_06 (ai_actors allied_phantom_01)) TRUE) 
					(< (ai_living_count dogfighters_01) 2)
				)
			)
			(OR 
				(= (volume_test_objects vol_dog_obj_06 (players)) TRUE) 
				(= (volume_test_objects vol_dog_obj_06 (ai_actors allied_phantom_01)) TRUE)
				(> dogfighters_spawned 3)
			)
		)
	30 4000)
	
	(sleep 30)
	(sleep_until (= emplace_06_done TRUE) 30 1800)
	(sleep_until (= (ai_trigger_test "done_fighting" dog_obj_emplaced_06) TRUE) 30 1800)	
	(print "cleared")
	(sleep 30)
	(if (= (volume_test_objects vol_dog_obj_07 (players)) FALSE)
		(set dogfight_ph_pilot_go TRUE)
	)
	(ai_set_orders allied_phantom_01 dog_ph_obj_07)
	(game_save_no_timeout)
	
	(set dogfighters_spawned 0)
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_08 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_08)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_07)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_08 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_06 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_06)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_07)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_06 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_01 90) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_01)
						(set dogfighters_spawned (+ dogfighters_spawned 1))
						(ai_set_orders dogfight_enemies dogfight01_cell_07)
						(sleep 60)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_01 boost_test)
					)
			)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_dog_obj_07 (players)) TRUE) 
					(= (volume_test_objects vol_dog_obj_07 (ai_actors allied_phantom_01)) TRUE) 
					(< (ai_living_count dogfighters_01) 2)
				)
			)
			(OR 
				(= (volume_test_objects vol_dog_obj_07 (players)) TRUE) 
				(= (volume_test_objects vol_dog_obj_07 (ai_actors allied_phantom_01)) TRUE)
				(> dogfighters_spawned 3)
			)
		)
	30 4000)	
)

;Sends grunts to their turrets
(script command_script goto_dog_turret_01l
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_01/left))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_01/left) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_01r
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_01/right))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_01/right) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_02l
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_02/left))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_02/left) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_02r
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_02/right))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_02/right) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_03l
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_03/left))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_03/left) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_03r
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_03/right))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_03/right) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_04l
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_04/left))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_04/left) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_04r
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_04/right))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_04/right) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_06l
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_06/left))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_06/left) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script goto_dog_turret_06r
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_06/right))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_06/right) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script lz_turret_01
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_07/01))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_07/01) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script lz_turret_02
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_07/02))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_07/02) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script lz_turret_03
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_07/03))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_07/03) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)
(script command_script lz_turret_04
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location dog_turrets_07/04))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location dog_turrets_07/04) TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)

;Emplacements!
(script dormant near_dog_obj_01
	(ai_place dog_turret_men_01)
	(cs_run_command_script dog_turret_men_01/left goto_dog_turret_01l)
	(cs_run_command_script dog_turret_men_01/right goto_dog_turret_01r)
	
;	(sleep_until (= (ai_trigger_test "done_fighting" allied_phantom_01) FALSE))

	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_08 60) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_08)
						(ai_set_orders dogfight_enemies dogfight01_cell_01)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_08 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_02 60) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_02)
						(ai_set_orders dogfight_enemies dogfight01_cell_01)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_02 boost_test)
					)
			)
			(if 
				(AND
					(= (objects_can_see_flag (players) spawn_pt_01 60) FALSE)
					(< (ai_living_count dogfighters_01) 2)
				)
					(begin
						(ai_place dogfight_enemies/pt_01)
						(ai_set_orders dogfight_enemies dogfight01_cell_01)
						(ai_magically_see dogfight_enemies allied_phantom_01)
						(cs_run_command_script dogfight_enemies/pt_01 boost_test)
					)
			)
			(sleep_until 
				(OR 
					(> (objects_distance_to_flag (players) banshee_intro) 75) 
					(< (ai_living_count dogfighters_01) 2)
					(> (ai_spawn_count dogfighters_01) 2)
				)
			)
			(OR 
				(> (objects_distance_to_flag (players) banshee_intro) 75) 
				(> (ai_spawn_count dogfighters_01) 2)
			)
		)
	)	

	(sleep_until 
		(AND
			(< (ai_living_count dog_obj_emplaced_01) 1)
			(< (ai_living_count dogfighters_01) 1)
		;	(= (ai_trigger_test "done_fighting" allied_phantom_01) TRUE)
		)
	)
	(set emplace_01_done TRUE)
	(game_save_no_timeout)
;	(set try_to_save_now TRUE)
)

(script dormant near_dog_obj_02
	(sleep_until
		(OR
			(= (volume_test_objects vol_dog_obj_02 (players)) TRUE)
			(= (volume_test_objects vol_dog_obj_02 (ai_actors allied_phantom_01)) TRUE)
		)
	)
	(ai_place dog_turret_men_02)
	(cs_run_command_script dog_turret_men_02/left goto_dog_turret_02l)
	(cs_run_command_script dog_turret_men_02/right goto_dog_turret_02r)
	
	(sleep_until (< (ai_living_count dog_turret_men_02) 2))
	(ai_place dog_flak_02 2)
	
	(sleep_until (< (ai_living_count dog_flak_02) 2))
	(ai_place dog_flak_02 2)

	(sleep_until
		;(OR
			(< (ai_living_count dog_obj_emplaced_02) 1) 
		;	(= (ai_trigger_test "done_fighting" allied_phantom_01) TRUE)
		;)
	)
	(set emplace_02_done TRUE)
	(game_save_no_timeout)
;	(set try_to_save_now TRUE)
)

(script dormant near_dog_obj_03
	(sleep_until
		(OR
			(= (volume_test_objects vol_dog_obj_03 (players)) TRUE)
			(= (volume_test_objects vol_dog_obj_03 (ai_actors allied_phantom_01)) TRUE)
		)
	)
	(ai_place dog_turret_men_03)
	;(cs_run_command_script dog_turret_men_03/left goto_dog_turret_03l)
	;(cs_run_command_script dog_turret_men_03/right goto_dog_turret_03r)

;	(sleep_until (< (ai_living_count dog_turret_men_03) 2))
;	(sleep_until
;		(begin
;			(ai_place dog_sen_03 1)
;			(sleep 15)
;			(sleep_until (< (ai_living_count dog_sen_03) 3))
;			(= (ai_spawn_count dog_sen_03) 6)
;		)
;	)

	(sleep_until
		(begin
			(ai_place dog_turret_men_03 1)
			(sleep 60)
			(sleep_until (< (ai_living_count dog_turret_men_03) 2))
			(> (ai_spawn_count dog_turret_men_03) 3)
		)
	)

	(sleep_until
		;(OR
			(< (ai_living_count dog_obj_emplaced_03) 1) 
		;	(= (ai_trigger_test "done_fighting" allied_phantom_01) TRUE)
		;)
	)
	(set emplace_03_done TRUE)
	(game_save_no_timeout)
;	(set try_to_save_now TRUE)
)

(script dormant near_dog_obj_04
	(sleep_until
		(OR
			(= (volume_test_objects vol_dog_obj_04 (players)) TRUE)
			(= (volume_test_objects vol_dog_obj_04 (ai_actors allied_phantom_01)) TRUE)
		)
	)
	(ai_place dog_flak_04)
	(ai_place dog_turret_men_04)
	(cs_run_command_script dog_turret_men_04/left goto_dog_turret_04l)
	(cs_run_command_script dog_turret_men_04/right goto_dog_turret_04r)

	(sleep_until
		;(OR
			(< (ai_living_count dog_obj_emplaced_04) 1) 
		;	(= (ai_trigger_test "done_fighting" allied_phantom_01) TRUE)
		;)
	)
	(set emplace_04_done TRUE)
	(game_save_no_timeout)
;	(set try_to_save_now TRUE)
)

(script dormant near_dog_obj_05
	(sleep_until
		(OR
			(= (volume_test_objects vol_dog_obj_05 (players)) TRUE)
			(= (volume_test_objects vol_dog_obj_05 (ai_actors allied_phantom_01)) TRUE)
		)
	)
	(sleep_until
		(begin
			(ai_place dog_sen_05 1)
			(sleep 15)
			(sleep_until (< (ai_living_count dog_sen_05) 4))
			(= (ai_spawn_count dog_sen_05) 8)
		)
	)

	(sleep_until
		;(OR
			(< (ai_living_count dog_obj_emplaced_05) 1) 
		;	(= (ai_trigger_test "done_fighting" allied_phantom_01) TRUE)
		;)
	)
	(set emplace_05_done TRUE)
	(game_save_no_timeout)
;	(set try_to_save_now TRUE)
)

(script dormant near_dog_obj_06
	(sleep_until
		(OR
			(= (volume_test_objects vol_dog_obj_06 (players)) TRUE)
			(= (volume_test_objects vol_dog_obj_06 (ai_actors allied_phantom_01)) TRUE)
		)
	)
	(ai_place dog_turret_men_06)
	;(cs_run_command_script dog_turret_men_06/left goto_dog_turret_06l)
	;(cs_run_command_script dog_turret_men_06/right goto_dog_turret_06r)

;	(sleep_until (< (ai_living_count dog_turret_men_06) 2))
;	(sleep_until
;		(begin
;			(ai_place dog_sen_06 1)
;			(sleep 15)
;			(sleep_until (< (ai_living_count dog_sen_06) 3))
;			(= (ai_spawn_count dog_sen_06) 6)
;		)
;	)

	(sleep_until
		(begin
			(ai_place dog_turret_men_06 1)
			(sleep 60)
			(sleep_until (< (ai_living_count dog_turret_men_06) 2))
			(> (ai_spawn_count dog_turret_men_06) 3)
		)
	)

	(sleep_until
		;(OR
			(< (ai_living_count dog_obj_emplaced_06) 1) 
		;	(= (ai_trigger_test "done_fighting" allied_phantom_01) TRUE)
		;)
	)
	(set emplace_06_done TRUE)
	(game_save_no_timeout)
;	(set try_to_save_now TRUE)
)

;Final reminder to finish the level
(script dormant final_dogfight_reminder
	(sleep_until (> (ai_living_count dog_turrets_07) 0))
	(sleep_until (< (ai_living_count dog_turrets_07) 1) 30 3600)
	(if (> (ai_living_count dog_turrets_07) 0)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "SPEC-OPS COMMANDER: 'Take out those turrets, and get after the Heretic-Leader!'")
			(sleep (ai_play_line_on_object NONE 1220))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1220_soc))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)

(script dormant ally_final_run
	(ai_set_orders allied_phantom_01 dog_ph_obj_park)
	(ai_place allies_elites_03 2)
	(ai_place allies_grunts_03 2)
	(sleep 60)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allied_phantom_01/driver) "phantom_p_a" (ai_actors allies_elites_03))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allied_phantom_01/driver) "phantom_p_b" (ai_actors allies_grunts_03))
	
	(sleep_until (= (volume_test_objects vol_arm02_air (ai_actors allied_phantom_01)) TRUE))
	(cs_run_command_script allied_phantom_01/driver arm02_final_approach)

;	(sleep_until 
;		(OR 
;			(= (volume_test_objects vol_arm_02_lz (ai_actors allies_elites_03)) TRUE)
;			(= (volume_test_objects vol_arm_02_lz (ai_actors allies_grunts_03)) TRUE)
;		)
;	)
)

(script dormant near_dog_obj_07
	(sleep_until 
		(OR
			(= (volume_test_objects vol_dog_obj_07 (players)) TRUE)
			(= (volume_test_objects vol_dog_obj_07 (ai_actors allied_phantom_01)) TRUE)
		)
	)
	(object_create hl_banshee)
	;(ai_place hl_escort_sentinels)
	(ai_place dog_turret_men_07)
	(sleep 2)
	(ai_enter_squad_vehicles dog_07_turrets)
	(sleep 2)
;	(cs_run_command_script dog_turret_men_07/01 lz_turret_01)
;	(cs_run_command_script dog_turret_men_07/02 lz_turret_02)
;	(cs_run_command_script dog_turret_men_07/03 lz_turret_03)
;	(cs_run_command_script dog_turret_men_07/04 lz_turret_04)
	(ai_place dog_flak_07)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'We've tracked the heretic leader to this part of the station.'")
	(sleep (ai_play_line_on_object NONE 0530))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0530_soc))
	(sleep 30)
	(print "SPEC-OPS COMMANDER: 'Clear that landing-zone, and get inside!'")
	(sleep (ai_play_line_on_object NONE 0540))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0540_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(wake final_dogfight_reminder)
	(game_save_no_timeout)
;	(set try_to_save_now TRUE)

	(sleep_until (< (ai_living_count dog_obj_emplaced_07) 3) 30 4000)
	(wake ally_final_run)
	
	(if 
		(AND
			(= (volume_test_objects vol_arm_02_lz (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_place arm02_final_heretics 2)
				(ai_place arm02_final_grunts 2)
			)
	)
	(sleep_until (< (+ (ai_living_count arm02_final_heretics) (ai_living_count arm02_final_heretics)) 1) 30 3600)
	(sleep_until (= (ai_trigger_test "done_fighting" dog_obj_emplaced_07) TRUE) 30 1800)	
	(set dogfight_over TRUE)
)

;Commander warns of flak
(script dormant dogfight_flak_warn
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'Look sharp, Arbiter! They're putting-up heavy flak!'")
	(sleep (ai_play_line_on_object NONE 1200))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1200_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Pilot warns of heavy weapons?
(script dormant dogfight_objectives
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "PHANTOM PILOT: 'The Heretics have weapon-emplacements all over the facility, Arbiter.'")
	(print "'We'll take them out, one-by-one, until we find the Heretic-Leader!'")
	(sleep (ai_play_line_on_object NONE 2040))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\L04_2040_scl))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;switches nav beacon if phantom dies
(script dormant dogfight_nav_swap
	(sleep_until 
		(OR
			(< (ai_living_count allied_phantom_01) 1) 
			(= (volume_test_objects vol_dog_obj_07 (players)) TRUE)
			(= (volume_test_objects vol_dog_obj_07 (ai_actors allied_phantom_01)) TRUE)
		)
	30 24000)
	(activate_team_nav_point_object default player arm_02_entry_ext 0)
)

(script dormant always_get_banshee_01
	(sleep_until
		(begin
			(sleep_until 
				(AND
					(AND
						(> (objects_distance_to_flag (players) 01a) 50) 
						(> (objects_distance_to_flag (players) 01b) 50)
						(= (objects_can_see_flag (players) 01a 45) FALSE) 
						(= (objects_can_see_flag (players) 01b 45) FALSE) 
					)
					(OR
						(= (volume_test_object vol_stuck_01 mid_banshee_01) FALSE)
						(= (volume_test_object vol_stuck_01 mid_banshee_02) FALSE)
					)
				)
			)
			(sleep_until
				(begin
					(object_destroy (list_get (volume_return_objects_by_type vol_stuck_01 2) 0))
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_01 2)) 0)
				)
			)
			(object_create_clone mid_banshee_01)				
			(object_create_clone mid_banshee_02)				
			FALSE
		)
	)
)
(script dormant always_get_banshee_02
	(sleep_until
		(begin
			(sleep_until 
				(AND
					(AND
						(> (objects_distance_to_flag (players) 10a) 50) 
						(> (objects_distance_to_flag (players) 10b) 50)
						(= (objects_can_see_flag (players) 10a 45) FALSE) 
						(= (objects_can_see_flag (players) 10b 45) FALSE) 
					)
					(OR
						(= (volume_test_object vol_stuck_10 (ai_vehicle_get_from_starting_location ledge_banshees_01/left)) FALSE)
						(= (volume_test_object vol_stuck_10 (ai_vehicle_get_from_starting_location ledge_banshees_01/right)) FALSE)
					)
				)
			)
			(sleep_until
				(begin
					(object_destroy (list_get (volume_return_objects_by_type vol_stuck_10 2) 0))
					(= (list_count_not_dead (volume_return_objects_by_type vol_stuck_10 2)) 0)
				)
			)
			(ai_place ledge_banshees_01/left)				
			(ai_place ledge_banshees_01/right)
			FALSE
		)
	)
)

;Overall script for the first banshee dogfight
(script dormant dogfight_firsttime_start
	(data_mine_set_mission_segment "04a_9_dogfight")
	(game_save)

;9/13	
	(if (difficulty_legendary)
		(wake grunt_birthday_party)
	)
	
	(kill_volume_disable kill_banshee_ledge)
	(wake banshee_stuck_spawner_01)
	(if (= (game_is_cooperative) TRUE)
		(wake banshee_stuck_spawner_02)
	)
	(activate_team_nav_point_object default player (list_get (ai_actors allied_phantom_01) 0) 3)
;	(cs_run_command_script allied_phantom_01/driver phantom_path)
	(ai_place dogfight_initial_enemies 2)
;	(ai_place dog_turrets_02)
	;(ai_place dog_turrets_03)
	(ai_place dog_turrets_04)
	;(ai_place dog_turrets_06)
	(ai_place dog_turrets_07)
;	(ai_prefer_target (ai_actors allied_phantom_01) TRUE)
	(wake near_dog_obj_01)
	;(wake near_dog_obj_02)
	(wake near_dog_obj_03)
	(wake near_dog_obj_04)
	;(wake near_dog_obj_05)
	(wake near_dog_obj_06)
	(wake near_dog_obj_07)
	;(wake dogfight_flak_warn)
	(wake phantom_path_w_orders)
	(wake dogfight_nav_swap)
	(object_create_containing "mid_banshee_0")
	(wake always_get_banshee_01)
	(wake always_get_banshee_02)

	(sleep 5)
	(wake music_04a_04_start)
	(wake music_04a_04_stop)

	(sleep_until 
		(AND
			(< (ai_living_count dogfight_initial_enemies) 1)
			(= emplace_01_done TRUE)
		)
	)
	(sleep 60)
	
;	(wake music_04a_04_stop)
	(sleep 30)
	
	(wake dogfight_objectives)
)


;-------------------------------------------------------------------------------
;Arm 2 Entry

;Game won for research arm entry
(script dormant arm_02_entry_win
	(sleep_until 
		(OR
			(= (volume_test_objects vol_04a_game_won (players)) TRUE)
			(AND
				(= dogfight_over TRUE)
				(= (volume_test_object vol_real_win (player0)) TRUE)
				(= (unit_in_vehicle (player0)) FALSE)
			)
			(AND
				(= dogfight_over TRUE)
				(= (volume_test_object vol_real_win (player1)) TRUE)
				(= (unit_in_vehicle (player1)) FALSE)
			)
		)
	)
;	(sleep 30)
	(playtest_mission)
	(sleep 30)
	(sound_class_set_gain "" 0 15)
	(cinematic_fade_to_white)
	(sleep 30)
	(game_won)
)


;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

;Sleeping old stuff once past

(script static void sleep_intro
	(sleep_forever SWAT_deploy)
	(sleep_forever commander_entry_reminder)
	(sleep_forever wind)
)

(script static void sleep_rec_center
	(sleep_forever production_arm_bsp_swap)
	(sleep_forever recycling_center_start)
	(sleep_forever recycling_can_spawner)
	(sleep_forever recycling_killer_new)
	(sleep_forever heretic_uplink_01)
	(sleep_forever rec_center_reminder)
	(ai_disposable rec_center_heretics TRUE)
)

(script static void sleep_hangar
	(sleep_forever hangar_firsttime_start)
	(sleep_forever hangar_can_spawner)
	(sleep_forever hangar_killer_new)
	(sleep_forever hangar_allies_reinforce)
	(sleep_forever hangar_helpers)
	(sleep_forever hangar_sentinels_flitting)
	(sleep_forever hangar_door_monitor)
	(sleep_forever hangar_door_reminder)
	(sleep_forever hangar_alerted_call)
	(sleep_forever hangar_exit_warn)
	(sleep_forever hangar_reminder)
	(sleep_forever hangar_exterior_toggle)
)

(script static void sleep_first_halls
	(sleep_forever to_underhangar_firsttime)
	(sleep_forever first_hall_reinforce)
)

(script static void sleep_underhangar
	(sleep_forever underhangar_firsttime_start)
	(sleep_forever underhangar_can_spawner)
	(sleep_forever underhangar_killer_new)
	(sleep_forever new_allies_02)
	(sleep_forever underhangar_reinforce)
	(sleep_forever underhangar_reminder)
)

(script static void sleep_second_halls
	(sleep_forever to_bottling)
	(sleep_forever second_hall_reinforce_01)
	(sleep_forever second_hall_reinforce_02)
	(sleep_forever second_hall_reinforce_03)
)

(script static void sleep_bottling
	(sleep_forever bottling_firsttime_start)
	(sleep_forever bottling_can_spawner)
	(sleep_forever bottling_killer_new)
	(sleep_forever bottling_overlook_reinforce)
	(sleep_forever active_camo_drop)
	(sleep_forever new_allies_03)
	(ai_disposable hangar_heretics TRUE)
	(ai_disposable hangar_sentinels TRUE)
	(ai_disposable first_hall_heretics TRUE)
	(ai_disposable underhangar_heretics TRUE)
	(ai_disposable second_hall_heretics TRUE)
	(ai_disposable bottling_enemies TRUE)
)


;Startup scripts
(script startup mission	

;Cutscene stuff

	(cinematic_snap_to_white)	
	(if (= (volume_test_objects vol_starting_locations (players)) TRUE)
		(begin
			(sound_suppress_ambience_update_on_revert)
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
	
	(sleep 2)
	(switch_bsp 0)	
	(sleep 2)
	
;Mission stuff

	(ai_allegiance player covenant)
	(ai_allegiance sentinel heretic)	
	(ai_allegiance heretic sentinel)
	(objectives_clear)
	
	(game_save_immediate)

	(prep_return_from_intro)		

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(wake 04a_title0)
	(wake objective_hl_set)
	
	(wake SWAT_deploy)
	(wake recycling_center_start)
	(wake kill_volumes)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_on_hangar_lift_top (players)) TRUE)
			(= (volume_test_objects vol_on_hangar_lift_top (ai_actors all_allies)) TRUE)
		)
	)
	(wake hangar_firsttime_start)
	(wake to_underhangar_firsttime)
	(sleep_intro)
	(device_one_sided_set rec_center_entry_ext TRUE)
	(device_one_sided_set rec_center_entry_int TRUE)

	(sleep_until (= (volume_test_objects vol_underhangar_from_top (players)) TRUE))
	(wake underhangar_firsttime_start)
	(wake to_bottling)
	(sleep_rec_center)
	(sleep_hangar)
	(set recycling_power_on FALSE)
	(set hangar_power_on FALSE)
	(device_one_sided_set hangar_exit TRUE)

	(sleep_until (= (structure_bsp_index) 0))
;	(sleep_until (= (volume_test_objects vol_bottling_enter (players)) TRUE))
	(wake bottling_firsttime_start)
	(wake bottling_plant_end)
	(sleep_first_halls)
	(sleep_underhangar)
	(set underhangar_power_on FALSE)
	(device_one_sided_set underhangar_entry TRUE)
	(device_one_sided_set underhangar_exit TRUE)

	(sleep_until 
		(OR 
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player0))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/left) "banshee_d" (unit (player1))) TRUE)
			(= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_01/right) "banshee_d" (unit (player1))) TRUE)
		)
	)
	(wake dogfight_firsttime_start)
	(wake arm_02_entry_win)
	(sleep_second_halls)
	(sleep_bottling)
	(set bottling_power_on FALSE)
	(device_operates_automatically_set rec_center_entry_ext FALSE)
	(device_one_sided_set bottling_entry TRUE)
	(device_one_sided_set bottling_midway TRUE)
	(device_one_sided_set viewroom_entry TRUE)
	(wake objective_hl_clear)
	(wake objective_dogfight_set)
	
	(sleep_until 
		(OR
			(AND
				(unit_in_vehicle (player0))
				(unit_in_vehicle (player1))
			)
			(AND
				(unit_in_vehicle (player0))
				(= (game_is_cooperative) FALSE)
			)
		)
	) 
)