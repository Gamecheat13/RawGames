;========== GLOBALS =========================================================================================
(global boolean debug 1)
(global boolean dialogue 1)
(global boolean g_play_cinematics 1)

(global short sleep_lower_bound 120)
(global short sleep_upper_bound 180)

(global boolean g_cheiftan 0)
(global boolean g_dervish_ledge_orders 0)
(global boolean g_room_a_door 0)
(global boolean g_sc_ioc_finished 0)

(global boolean g_jail_a_free 0)
(global boolean g_jail_b_free 0)
(global boolean g_jail_a_finished 0)
(global boolean g_jail_b_finished 0)

(global boolean g_marine_mig_garden_a 0)
(global boolean g_marine_mig_midtower 0)
(global boolean g_marine_mig_garden_b 0)
(global boolean g_marine_mig_ext_b 0)
(global boolean g_marine_mig_maus 0)
(global boolean g_marine_mig_maus_room 0)
(global boolean g_marine_mig_maus_int 0)

; cinematic stub scripts  
(script stub void x08 (print "x08"))
(script stub void C07_intro (print "C07_intro"))
(script stub void c07_intra1 (print "c07_intra1"))

(script command_script cs_jump
	(cs_jump_to_point 0 5)
)

(script command_script cs_abort
	(sleep 1)
)

(script command_script cs_alert
	(cs_abort_on_alert true)
	(sleep_forever)
)

(script command_script cs_alert_combat
	(cs_abort_on_alert true)
	(cs_movement_mode ai_movement_combat)
	(sleep_forever)
)

(script static void test_rumble
	(damage_object objects\cinematics\human\inamberclad_to_scale\damage_effects\ioc_flyby (player0))
)

(script static void test_ioc
	(object_create ioc_effect)
	(sound_impulse_start sound\visual_effects\inamberclad_flyby\slipspace rupture 1)
	(sound_impulse_start sound\visual_effects\inamberclad_flyby\inamberclad_flyby none 1)
	(sleep 3)
	(object_create ioc)
	(device_set_position_track ioc high_charity_flyby 0)
	(device_animate_position ioc 1 15 0 0 false)
	(sleep 30)
	(object_destroy ioc_effect)

	(sleep 30)
	(damage_object objects\cinematics\human\inamberclad_to_scale\damage_effects\ioc_flyby (player0))

	(sleep_until (>= (device_get_position ioc) 1))
	(object_destroy ioc)
)

;*
(script command_script cs_c07_infection
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_nearest c07_infection_a)
	(cs_go_to_nearest c07_infection_b)
)

(script static void c07_infection_place
	(ai_place c07_infection)
)
(script static void c07_infection_erase
	(ai_erase c07_infection)
)
*;

(script dormant bullshit
	(sleep_until (= (structure_bsp_index) 3)) ; first exterior (high_3) 
	(object_destroy_containing bsp0_crate)
	(object_destroy_containing bsp1_crate)
	(object_destroy_containing bsp2_crate)
	(object_destroy_containing bsp2_body)
	(sleep 1)
	(object_create_anew_containing bsp3_body)
	(object_create_anew_containing bsp3_crate)
	
	(sleep_until (= (structure_bsp_index) 4)) ; second exterior (high_3b) 
	(object_destroy_containing bsp3_body)
	(object_destroy_containing bsp3_crate)
	(sleep 1)
	(object_create_anew_containing bsp3b_body)
	(object_create_anew_containing bsp3b_crate)
	
	(sleep_until (= (structure_bsp_index) 5)) ; mausoleum interior (high_4) 
	(object_destroy_containing bsp3b_body)
	(object_destroy_containing bsp3b_crate)
	(sleep 1)
	(object_create_anew_containing bsp4_body)
	(object_create_anew_containing bsp4_crate)
)
	


; =====  CORTANA SCRIPTS ===========================================================================

(script command_script cs_expand_cortana
	(object_set_scale (ai_get_object ai_current_actor) 0.01 0)
	(object_cannot_take_damage (ai_get_object ai_current_actor))
	(ai_disregard (ai_get_object ai_current_actor) true)
	(sleep 5)
	(object_dynamic_simulation_disable (ai_get_object ai_current_actor) true)
	(unit_set_emotional_state (ai_get_unit ai_current_actor) "pensive" 0.5 0)
;	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 (ai_get_object ai_current_actor) "effect")
	(sleep 1)
	(object_hide (ai_get_object ai_current_actor) false)
	(object_set_scale (ai_get_object ai_current_actor) 0.65 20)
	(cs_face_player true)
	(sleep_forever)
)

(script command_script cs_shrink_cortana
	(cs_enable_dialogue false)
	(sleep 60)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 (ai_get_object ai_current_actor) "effect")
	(sleep 3)
	(object_set_scale (ai_get_object ai_current_actor) 0.01 10)
	(sleep 30)
	(ai_erase ai_current_actor)
)

(script dormant ice_cream_angry
	(sleep_until (volume_test_objects tv_ice_cream (players)))
	(object_create ice_cream_effect)
	(object_create ice_cream_head)
	(ai_place ice_cream_grunt)
	
	(sleep 1)
	(device_set_position ice_cream_effect 1)
	(ai_set_active_camo ice_cream_grunt TRUE)

	(sleep_until 
		(or
                (unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head.weapon")
                (unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head.weapon")
		)
	)
	
	(if debug (print "you're going to get fat!!!!! or dead..."))
	(if debug (print "because now everyone is angry!!!!"))
	(ice_cream_flavor_stock 13)
)

; =====  !!!! MUSIC !!!! ===========================================================================
(global boolean g_music_07a_01 0)
(global boolean g_music_07a_02 0)
(global boolean g_music_07a_03 0)
(global boolean g_music_07a_03_alt 0)
(global boolean g_music_07a_04 0)
(global boolean g_music_07a_04_alt 0)
(global boolean g_music_07a_05 0)
(global boolean g_music_07a_06 0)
(global boolean g_music_07a_07 0)
(global boolean g_music_07a_07_alt 0)
(global boolean g_music_07a_08 0)


(script dormant music_07a_01
	(sleep_until g_music_07a_01)
	(if debug (print "start music 07a_01"))
	(sound_looping_start scenarios\solo\07a_highcharity\07a_music\07a_01 none 1)

	(sleep_until (not g_music_07a_01))
	(if debug (print "stop music 07a_01"))
	(sound_looping_stop scenarios\solo\07a_highcharity\07a_music\07a_01)
)

(script dormant music_07a_02
	(sleep_until g_music_07a_02)
	(if debug (print "start music 07a_02"))
	(sound_looping_start scenarios\solo\07a_highcharity\07a_music\07a_02 none 1)

	(sleep_until (not g_music_07a_02))
	(if debug (print "stop music 07a_02"))
	(sound_looping_stop scenarios\solo\07a_highcharity\07a_music\07a_02)
)

(script dormant music_07a_03
	(sleep_until g_music_07a_03)
	(if debug (print "start music 07a_03"))
	(sound_looping_start scenarios\solo\07a_highcharity\07a_music\07a_03 none 1)

	(sleep_until g_music_07a_03_alt)
	(if debug (print "set music 07a_03 alternate"))
	(sound_looping_set_alternate scenarios\solo\07a_highcharity\07a_music\07a_03 true)

	(sleep_until (not g_music_07a_03))
	(if debug (print "stop music 07a_03"))
	(sound_looping_stop scenarios\solo\07a_highcharity\07a_music\07a_03)
)

(script dormant music_07a_04
	(sleep_until g_music_07a_04)
	(if debug (print "start music 07a_04"))
	(sound_looping_start scenarios\solo\07a_highcharity\07a_music\07a_04 none 1)

	(sleep_until g_music_07a_04_alt)
	(if debug (print "set music 07a_04 alternate"))
	(sound_looping_set_alternate scenarios\solo\07a_highcharity\07a_music\07a_04 true)

	(sleep_until (not g_music_07a_04))
	(if debug (print "stop music 07a_04"))
	(sound_looping_stop scenarios\solo\07a_highcharity\07a_music\07a_04)
)

(script dormant music_07a_05
	(sleep_until g_music_07a_05)
	(if debug (print "start music 07a_05"))
	(sound_looping_start scenarios\solo\07a_highcharity\07a_music\07a_05 none 1)

	(sleep_until (not g_music_07a_05))
	(if debug (print "stop music 07a_05"))
	(sound_looping_stop scenarios\solo\07a_highcharity\07a_music\07a_05)
)

(script dormant music_07a_06
;	(sleep_until (> (device_get_position midtower_exit) .5) 5)
	(sleep_until g_music_07a_06)
	(if debug (print "start music 07a_06"))
	(sound_looping_start scenarios\solo\07a_highcharity\07a_music\07a_06 none 1)
)

(script dormant music_07a_07
	(sleep_until g_music_07a_07)
	(if debug (print "start music 07a_07"))
	(sound_looping_start scenarios\solo\07a_highcharity\07a_music\07a_07 none 1)

	(sleep_until g_music_07a_07_alt)
	(if debug (print "set music 07a_07 alternate"))
	(sound_looping_set_alternate scenarios\solo\07a_highcharity\07a_music\07a_07 true)

	(sleep_until (not g_music_07a_07))
	(if debug (print "stop music 07a_07"))
	(sound_looping_stop scenarios\solo\07a_highcharity\07a_music\07a_07)
)

(script dormant music_07a_08
	(sleep_until g_music_07a_08)
	(if debug (print "start music 07a_08"))
	(sound_looping_start scenarios\solo\07a_highcharity\07a_music\07a_08 none 1)

	(sleep_until (not g_music_07a_08))
	(if debug (print "stop music 07a_08"))
	(sound_looping_stop scenarios\solo\07a_highcharity\07a_music\07a_08)
)






;= CHAPTER TITLES ========================================================================
(script dormant chapter_job
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)
(script dormant chapter_thanks
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)
(script dormant chapter_grudge
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_3)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)
(script dormant chapter_graves
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox true)
	(sleep 30)
	(cinematic_set_title title_4)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

;= OBJECTIVES ============================================================================
(script dormant objective_locate_set
	(sleep 30)
	(print "new objective set:")
	(print "Locate the Prophet of Truth and the Index.")
	(objectives_show_up_to 0)
)
(script dormant objective_locate_clear
	(print "objective complete:")
	(print "Locate the Prophet of Truth and the Index.")
	(objectives_finish_up_to 0)
)
(script dormant objective_rescue_set
	(sleep 30)
	(print "new objective set:")
	(print "Rescue the Marines being held in the detention-block.")
	(objectives_show_up_to 1)
)
(script dormant objective_rescue_clear
	(print "objective complete:")
	(print "Rescue the Marines being held in the detention-block.")
	(objectives_finish_up_to 1)
)
(script dormant objective_truth_set
	(sleep 30)
	(print "new objective set:")
	(print "Follow the Prophet of Truth to the far tower.")
	(objectives_show_up_to 2)
)
(script dormant objective_truth_clear
	(print "objective complete:")
	(print "Follow the Prophet of Truth to the far tower.")
	(objectives_finish_up_to 2)
)
(script dormant objective_phantom_set
	(sleep 30)
	(print "new objective set:")
	(print "Stop the Prophet of Truth from boarding his Phantom.")
	(objectives_show_up_to 3)
)
(script dormant objective_phantom_clear
	(print "objective complete:")
	(print "Stop the Prophet of Truth from boarding his Phantom.")
	(objectives_finish_up_to 3)
)

; =====  DIALOGUE SCENES ===========================================================================
(global boolean g_council_initial 0)
(global boolean g_council_exit_reminder 0)
(global boolean g_council_reminder_played 0)
(global boolean g_ledge_reminder 0)
(global short dialogue_pause 7)

(script static void erase_cortana
	(if debug (print "erasing cortana..."))
	(cs_run_command_script cortana cs_shrink_cortana)
	(sleep 1)
	
;	(sleep_until (not (cs_command_script_running cortana cs_shrink_cortana)))
)

(script static void sc_this_way_a
	(if dialogue (print "CORTANA: This way, Chief!"))
	(sleep (ai_play_line_on_object none 2000))
	(sleep dialogue_pause)
)
(script static void sc_this_way_b
	(if dialogue (print "CORTANA: Over here, Chief!"))
	(sleep (ai_play_line_on_object none 2010))
	(sleep dialogue_pause)
)
(script static void sc_this_way_c
	(if dialogue (print "CORTANA: Chief! Let's go"))
	(sleep (ai_play_line_on_object none 2020))
	(sleep dialogue_pause)
)
(script static void sc_this_way_d
	(if dialogue (print "CORTANA: Come on, Chief!"))
	(sleep (ai_play_line_on_object none 2030))
	(sleep dialogue_pause)
)
(script static void sc_this_way_e
	(if dialogue (print "CORTANA: Through here!"))
	(sleep (ai_play_line_on_object none 2040))
	(sleep dialogue_pause)
)
(script static void sc_this_way_f
	(if dialogue (print "CORTANA: Go on through!"))
	(sleep (ai_play_line_on_object none 2050))
	(sleep dialogue_pause)
)

(script dormant sc_council_ini
	(if dialogue (print "CORTANA: Brutes!"))
	(sleep (ai_play_line_on_object none 2070))
	(sleep (* dialogue_pause 3))

	(if dialogue (print "CORTANA: The faster you kill those Brutes the better"))
	(sleep (ai_play_line_on_object none 2100))
	
	(set g_council_initial 1)

)

(script dormant sc_brutes_berserk
	(if (> (ai_living_count council_brute_ini) 0)
		(begin
			(if dialogue (print "CORTANA: They don't have shield generators, but take them out before..."))
			(sleep (ai_play_line_on_object none 2080))
			(sleep dialogue_pause)
		)
	)
		
	(if (> (ai_living_count council_brute_ini) 0)
		(begin
			(if dialogue (print "CORTANA: It's berserking!"))
			(sleep (ai_play_line_on_object none 2090))
		)
	)
)

(script dormant sc_council_exit_reminder
	(sleep (* 30 20))
	(sleep_until
		(begin
			(if	(or
					(volume_test_objects tv_council_bk (players))
					(volume_test_objects tv_council_lt_bk (players))
					(volume_test_objects tv_council_rt_bk (players))
				)
					(begin
						(if g_council_exit_reminder (sleep_forever))
						(if dialogue (print "CORTANA: They've locked it from below"))
						(sleep (ai_play_line_on_object none 2130))
						(sleep (* dialogue_pause 2))
						
						(if g_council_exit_reminder (sleep_forever))
						(if dialogue (print "CORTANA: There's a door at the other end of the chamber"))
						(sleep (ai_play_line_on_object none 2120))
						(set g_council_reminder_played 1)
					)
			)
			(if g_council_reminder_played (begin (set g_council_reminder_played 0) (sleep (* 30 30))))
		g_council_exit_reminder)
	60)
)

(script static void sc_council_mid
	(sleep (random_range 15 45))

	(if dialogue (print "BRUTE: The Demon has infiltrated the Council Chamber?!"))
	(sound_impulse_start "sound\dialog\levels\07_highcharity\mission\l07_1000_bth" council_sound_a 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_1000_bth" council_sound_b 1 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_1000_bth" council_sound_c 1 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_1000_bth" council_sound_d 1 1)
	(sleep 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_1000_bth))
;	(sleep (ai_play_line_on_object council_sound_d 1000))
	(sleep dialogue_pause)


	(if dialogue (print "BRUTE: Protect the Hierarchs! Seal the exits!"))
	(sound_impulse_start "sound\dialog\levels\07_highcharity\mission\l07_1010_bth" council_sound_a 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_1010_bth" council_sound_b 1 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_1010_bth" council_sound_c 1 1)
	(sound_impulse_trigger "sound\dialog\levels\07_highcharity\mission\l07_1010_bth" council_sound_d 1 1)
	(sleep 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_1010_bth))
;	(sleep (ai_play_line_on_object council_sound_d 1010))
	(sleep (* dialogue_pause 2))
	
	(if dialogue (print "CORTANA: Oh, I don't think so"))
	(sleep (ai_play_line_on_object none 2190))
	(sleep (* dialogue_pause 4))
)

(script dormant sc_council_exit_leave
	(sleep 150)

	(if	(volume_test_objects tv_council_ext (players))
			(begin
				(if dialogue (print "CORTANA: Don't worry. You can pick me up later"))
				(sleep (ai_play_line_at_player cortana_0 2180))
			)
	)
	(erase_cortana)
)


(script dormant sc_council_exit
	(sleep (random_range 15 45))

	(if dialogue (print "CORTANA: Put me down on one of the pedestals near the door."))
	(sleep (ai_play_line_on_object none 2110))
;	(activate_team_nav_point_object default_red player bsp_0_holo_a .5)
	(wake sc_council_exit_reminder)

	(sleep_until
		(begin
			(cond
				((and 
					(> (objects_distance_to_object (players) bsp_0_holo_a) 0)
					(< (objects_distance_to_object (players) bsp_0_holo_a) 2.5)
				)
					(begin
						(ai_place cortana_0/a)
						(set g_council_exit_reminder 1)
						(sleep 5)
						(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 bsp_0_holo_a "effect")
					)
				)

				((and 
					(> (objects_distance_to_object (players) bsp_0_holo_b) 0)
					(< (objects_distance_to_object (players) bsp_0_holo_b) 2.5)
				)
					(begin
						(ai_place cortana_0/b)
						(set g_council_exit_reminder 1)
						(sleep 5)
						(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 bsp_0_holo_b "effect")
					)
				)
			)
		g_council_exit_reminder)
		
	5)

;	(deactivate_team_nav_point_object player bsp_0_holo_a)
	(sleep 90)
	
	(if dialogue (print "CORTANA: That Prophet - Truth - He has the Index!"))
	(if dialogue (print "CORTANA: You've got to take it back from him!"))
	(sleep (ai_play_line_at_player cortana_0 2150))
	(sleep (* dialogue_pause 3))
	
	(if dialogue (print "CORTANA: Let me get these doors..."))
	(sleep (ai_play_line_at_player cortana_0 2140))
	(sleep dialogue_pause)
	
	(device_closes_automatically_set council_exit 0)
	(device_operates_automatically_set council_exit 1)
	(sleep 1)
	(device_set_position council_exit 1)
	(sleep 15)
	(game_save)

	(if dialogue (print "CORTANA: Go. It'll be easier to track Truth if I stay in the network"))
	(sleep (ai_play_line_at_player cortana_0 2170))
	(sleep dialogue_pause)

	(set g_music_07a_01 1)

	(wake sc_council_exit_leave)
	
	(sleep_until (volume_test_objects tv_council_hall (players)) 5)
	(sleep 30)
	(erase_cortana)
	(device_closes_automatically_set council_exit 1)
)

(script dormant sc_grand_a_exit
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_0/f)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 bsp_0_holo_f "effect")

	(sleep_until
		(and 
			(> (objects_distance_to_object (players) bsp_0_holo_f) 0)
			(< (objects_distance_to_object (players) bsp_0_holo_f) 4)
		)
	)
	
	(set g_music_07a_02 1)
	(if dialogue (print "CORTANA: Right this way chief!"))
	(sleep (ai_play_line_at_player cortana_0 2060))
	(device_one_sided_set grand_a_exit false)
	
	(sleep_until (volume_test_objects tv_dervish_ledge_fr (players)))
	(sleep 30)
	(erase_cortana)
)

(script dormant sc_ledge_chieftan
	(if g_cheiftan (sleep_forever))
	(sleep 30)
	(if dialogue (print "CORTANA: Watch out for the Captain!"))
	(if dialogue (print "CORTANA: It's got a Brute Shot"))
	(sleep (ai_play_line_on_object none 2200))
	(set g_cheiftan 1)
)

(script dormant sc_ledge_down_reminder
	(sleep 300)
	(sleep_until (volume_test_objects tv_dervish_ledge_lift (players)))
	(if g_ledge_reminder (sleep_forever))
	(if dialogue (print "CORTANA: After that stunt on the Cairo,"))
	(if dialogue (print "CORTANA: I know you're not afraid of heights."))
	(sleep (ai_play_line_at_player cortana_0 2240))
	(sleep (* dialogue_pause 3))
	
	(sleep 300)
	(sleep_until (volume_test_objects tv_dervish_ledge_lift (players)))
	(if g_ledge_reminder (sleep_forever))
	(if dialogue (print "CORTANA: Fine, I won't watch"))
	(if dialogue (print "CORTANA: Meet you at the bottom, OK?"))
	(sleep (ai_play_line_at_player cortana_0 2250))
	(sleep dialogue_pause)
)

(script dormant sc_ledge_down
	(sleep_until
		(and
			g_cheiftan
			(<= (ai_living_count dervish_ledge_prophets) 3)
		)
	)
			
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_0/i)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 bsp_0_holo_i "effect")
	(sleep 90)

	(sleep_until
		(and
			(not (volume_test_objects tv_dervish_ledge_fr (ai_actors prophets)))
			(not (volume_test_objects tv_dervish_ledge_bk (ai_actors prophets)))
		)
	)
	(set g_dervish_ledge_orders 1)
	(sleep 30)
	
	(sleep_until	(and
					(> (objects_distance_to_object (players) bsp_0_holo_i) 0)
					(< (objects_distance_to_object (players) bsp_0_holo_i) 2)
				)
	)

	(if dialogue (print "CORTANA: Truth is moving through the lower-levels of the tower."))
	(sleep (ai_play_line_at_player cortana_0 2210))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: I'll reverse this grav-lift. Drop down, try to cut him off."))
	(sleep (ai_play_line_at_player cortana_0 2220))
	(sleep dialogue_pause)
	
	(game_save)

	(device_closes_automatically_set dervish_lift_up false)
	(device_set_position dervish_lift_up 1)
	(sleep 30)
	(object_destroy dervish_lift_up)
	(object_create dervish_lift_down)
	(sleep 5)

	(if dialogue (print "CORTANA: It's safe really. Just step in"))
	(sleep (ai_play_line_at_player cortana_0 2230))
	(sleep dialogue_pause)

	(wake sc_ledge_down_reminder)

	(sleep_until (volume_test_objects tv_dervish_ledge_lower (players)))
	(set g_ledge_reminder 1)
	(erase_cortana)
)

(script dormant sc_corridor_a_amb
	(sleep (random_range 15 45))
	(if dialogue (print "BRUTE: Reinforce all approaches to the holding-pens!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_1020_bth corr_a_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1020_bth corr_a_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1020_bth corr_a_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1020_bth corr_a_sound_d 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_1020_bth))
;	(sleep (ai_play_line_on_object corr_a_sound_a 1020))
	(sleep dialogue_pause)


	(if dialogue (print "BRUTE: Slay the Demon on sight!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_1030_bth corr_a_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1030_bth corr_a_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1030_bth corr_a_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1030_bth corr_a_sound_d 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_1030_bth))
;	(sleep (ai_play_line_on_object corr_a_sound_a 1030))
	(sleep (* dialogue_pause 5))

	
	(sleep_until	(and
					(> (objects_distance_to_object (players) grand_b_holo_b) 0)
					(< (objects_distance_to_object (players) grand_b_holo_b) 5)
				)
	5)

	(erase_cortana)
	(sleep 1)
	(ai_place cortana_grand_b/b)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 grand_b_holo_b "effect")
	(sleep 30)
	
	(if dialogue (print "CORTANA: They're beefing-up their patrols. Stay Sharp."))
	(sleep (ai_play_line_at_player cortana_grand_b 2260))
	
	(game_save_no_timeout)
	(sleep 30)
	(device_set_position grand_b_exit 1)
	
	(sleep 90)
	(erase_cortana)
	(device_closes_automatically_set grand_b_exit true)
)

(script dormant sc_jail_info
	(if dialogue (print "CORTANA: Wait a minute... I'm reading Marine IFF transponders!"))
	(sleep (ai_play_line_on_object none 2270))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: The signals are originating somewhere below your position."))
	(sleep (ai_play_line_on_object none 2280))

	(game_save_no_timeout)
	(ai_place hall_b_jackals)

	(wake objective_locate_clear)
	(wake objective_rescue_set)
)

(script dormant sc_room_a_lift
	(sleep_until (<= (ai_living_count hall_b_prophets) 3))
	(ai_place cortana_corridor_a/o)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 hall_a_holo_o "effect")

	(sleep_until	(and
					(> (objects_distance_to_object (players) hall_a_holo_o) 0)
					(< (objects_distance_to_object (players) hall_a_holo_o) 4.5)
				)
	)

	(if dialogue (print "CORTANA: There's another lift in the next room"))
	(sleep (ai_play_line_at_player cortana_corridor_a 2290))
	(sleep dialogue_pause)

	(sleep_until	(and
					g_room_a_door
					(volume_test_objects tv_room_a (players))
				)
	)
	(erase_cortana)
)

(script dormant sc_room_a_down
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_room_a/m)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 room_a_holo_m "effect")

	(sleep_until	(and
					(> (objects_distance_to_object (players) jail_down) 0)
					(< (objects_distance_to_object (players) jail_down) 3.5)
				)
	5) ; 9/18 

	(sleep 15)
	(if dialogue (print "CORTANA: Here, Chief! Jump in!"))
	(sleep (ai_play_line_at_player cortana_room_a 2300))
	(ai_place room_a_tube_fodder)
	(device_set_power room_a_lift 0)
	(device_set_position room_a_lift_effect 1)
	(sleep 30)
	(device_set_position jail_down 1)
)

(script dormant sc_jail_down

	(if dialogue (print "CORTANA: There are two groups of Marines in this detention-block."))
	(sleep (ai_play_line_on_object none 2310))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: I'll zero their locations - you neutralize the guards... quietly"))
	(sleep (ai_play_line_on_object none 2320))
	
	(sleep 30)
	(set g_music_07a_03 1)

	(game_save_immediate) ; 9/18 
)

(script dormant sc_cell_a_ent
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_jail/h)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 jail_ped_h "effect")
	(sleep 60)

	(if dialogue (print "CORTANA: Come to middle-level, Chief!"))
	(sleep (ai_play_line_on_object none 2350))
	(sleep (* dialogue_pause 3))

	(if (or g_jail_a_finished g_jail_b_finished)
		(begin
			(if dialogue (print "CORTANA: More guards! Get ready!"))
			(sleep (ai_play_line_on_object none 2380))
		)
		(begin
			(if dialogue (print "CORTANA: The Marines are just inside. Careful of the guards."))
			(sleep (ai_play_line_on_object none 2360))
		)
	)
	(sleep_until	(and
					(> (objects_distance_to_object (players) jail_ped_h) 0)
					(< (objects_distance_to_object (players) jail_ped_h) 3)
				)
	5)
	
	(game_save)
)

(script dormant sc_cell_b_ent
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_jail/n)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 jail_ped_n "effect")
	(sleep 60)

	(if dialogue (print "CORTANA: Chief! Come to the lower level!"))
	(sleep (ai_play_line_on_object none 2370))
	(sleep (* dialogue_pause 3))

	(if (or g_jail_a_finished g_jail_b_finished)
		(begin
			(if dialogue (print "CORTANA: More guards! Get ready!"))
			(sleep (ai_play_line_on_object none 2380))
		)
		(begin
			(if dialogue (print "CORTANA: The Marines are just inside. Careful of the guards."))
			(sleep (ai_play_line_on_object none 2360))
		)
	)
	(sleep_until	(and
					(> (objects_distance_to_object (players) jail_ped_n) 0)
					(< (objects_distance_to_object (players) jail_ped_n) 3)
				)
	5)
	
	(game_save)
)

(script dormant sc_first_cell
;	(if g_jail_a_free
;			(sleep_until (<= (ai_living_count cell_a_prophets) 0))
;			(sleep_until (<= (ai_living_count cell_b_prophets) 0))
;	)
	(ai_dialogue_enable false)
	(sleep 90)
	
	(if dialogue (print "CORTANA: Listen-up Marines. The Chief's hunting a Prophet,"))
	(if dialogue (print "CORTANA: and you're gonna help him kill it."))
	(sleep (ai_play_line_at_player cortana_jail 2390))
	(sleep dialogue_pause)

	(set g_music_07a_03_alt 1)
	
	(if dialogue (print "MARINE: No sense sticking around here!"))
	(sleep (ai_play_line_at_player jail_marines 4000))
	(sleep dialogue_pause)

	(if dialogue (print "MARINE: Affirmative!"))
	(sleep (ai_play_line_at_player jail_marines 4010))
	(sleep (* dialogue_pause 5))

	(if dialogue (print "CORTANA: One more group of Marines to go"))
	(sleep (ai_play_line_at_player cortana_jail 2400))
	(sleep dialogue_pause)
	
	(game_save_no_timeout)
	(sleep 90)
	(ai_dialogue_enable true)
	(erase_cortana)
)

(script dormant sc_second_cell
;	(if g_jail_a_finished
;			(sleep_until (<= (ai_living_count cell_a_prophets) 0))
;			(sleep_until (<= (ai_living_count cell_b_prophets) 0))
;	)
	(sleep 90)
	
	(if dialogue (print "MARINE: Good on ya"))
	(sleep (ai_play_line_at_player jail_marines 4020))
	(sleep dialogue_pause)

	(if dialogue (print "MARINE: Thanks"))
	(sleep (ai_play_line_at_player jail_marines 4030))
	(sleep dialogue_pause)

;	(if g_jail_a_finished
;		(begin
	(if dialogue (print "CORTANA: That's all the Marines, Chief. Good work."))
	(sleep (ai_play_line_at_player cortana_jail 2410))
;		)
;	)
	(sleep dialogue_pause)
	
	(game_save_no_timeout)
	(sleep 90)
	(wake objective_rescue_clear)
	(erase_cortana)
)

(script dormant sc_jail_exit
	(if dialogue (print "CORTANA: We'll get out of here the same way we came in:"))
	(if dialogue (print "CORTANA: the central grav-lift"))
	(sleep (ai_play_line_on_object none 2420))
)

(script dormant sc_lift_reins
	(if dialogue (print "CORTANA: Hostile reinforcements! Coming down the lift!"))
	(sleep (ai_play_line_on_object none 2430))
)

(global boolean g_jail_exit_reminder 0)
(global boolean g_jail_exit_reminder_played 0)

(script dormant sc_jail_clear_reminder
	(sleep (* 30 20))
	(sleep_until
		(begin
			(if	(or
					(volume_test_objects tv_jail_top (players))
					(volume_test_objects tv_jail_mid (players))
					(volume_test_objects tv_jail_bot (players))
				)
					(begin
						(if g_jail_exit_reminder (sleep_forever))
						(if dialogue (print "CORTANA: We've got to get after Truth, Chief! Step into the lift!"))
						(sleep (ai_play_line_on_object none 2450))
						(set g_jail_exit_reminder_played 1)
					)
			)
			(if g_jail_exit_reminder_played (begin (set g_jail_exit_reminder_played 0) (sleep (* 30 20))))
		g_jail_exit_reminder)
	60)
)

(script command_script cs_marines_exit
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_targeting true)
	(cs_shoot true)
	(cs_go_to jails/exit)
)

(script dormant sc_jail_clear
	(if (= (random_range 0 2) 0)
		(begin
			(ai_place cortana_jail/a)
			(sleep 5)
			(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 jail_ped_a "effect")

		)
			
		(begin
			(ai_place cortana_jail/b)
			(sleep 5)
			(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 jail_ped_b "effect")
		)
	)
	
;	(sleep_until (<= (ai_living_count jail_prophets) 0))
	(sleep 90)
	(object_destroy jail_down)
	(device_set_position jail_up_effect 1)
	(sleep 30)
	(object_create jail_up)
	(object_create room_b_lift)
	(device_set_position room_b_lift_effect 1)

;	(sleep 120)
	
	(pvs_set_object jail_ped_a)
	
	(sleep_until	
				(or
					(and
						(> (objects_distance_to_object (players) jail_ped_a) 0)
						(< (objects_distance_to_object (players) jail_ped_a) 3)
					)
					(and
						(> (objects_distance_to_object (players) jail_ped_b) 0)
						(< (objects_distance_to_object (players) jail_ped_b) 3)
					)
				)
	5)

	(if dialogue (print "CORTANA: The lift is clear. Step on in!"))
	(sleep (ai_play_line_at_player cortana_jail 2440))
	(sleep dialogue_pause)

	(cs_run_command_script marines cs_marines_exit)
	
	(wake sc_jail_clear_reminder)
)

(global boolean g_sc_room_b_done 0)

(script dormant sc_room_b
;	(sleep_until (volume_test_objects tv_jails (players)))
	(sleep 150)

	(if dialogue (print "TRUTH: Fear not my brothers! The Sacred Icon is secure!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0140_pot corr_b_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0140_pot corr_b_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0140_pot corr_b_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0140_pot corr_b_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0140_pot corr_b_sound_i 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0140_pot))
;	(sleep (ai_play_line_on_object corr_b_sound_d 0140))
	(sleep dialogue_pause)


	(if dialogue (print "TRUTH: It was Tartarus and his Brutes who took the Icon from the Flood!"))
	(if dialogue (print "TRUTH: For that, they have our thanks!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0150_pot corr_b_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0150_pot corr_b_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0150_pot corr_b_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0150_pot corr_b_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0150_pot corr_b_sound_i 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0150_pot))
;	(sleep (ai_play_line_on_object corr_b_sound_d 0150))
	(sleep (* dialogue_pause 4))


	(if dialogue (print "CORTANA: Excellent! Truth is broadcasting on the move."))
	(if dialogue (print "CORTANA: It'll make him much easier to track"))
	(sleep (ai_play_line_on_object none 2460))
	(set g_sc_room_b_done 1)
)

(global boolean g_corr_b_exit_finished 0)

(script dormant sc_corridor_b_exit
	(sleep_until (game_safe_to_save))
	

	(if dialogue (print "TRUTH: The Elites have failed to protect the Prophets,"))
	(if dialogue (print "TRUTH: and in doing so, put all our lives at risk!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_e 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_f 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_g 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_h 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0220_pot corr_b_sound_i 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0220_pot))
;	(sleep (ai_play_line_on_object corr_b_sound_h 0220))
	(sleep dialogue_pause)


	(if dialogue (print "TRUTH: Let no warrior forget his oath: thou, in faith,"))
	(if dialogue (print "TRUTH: will keep us safe whilst we find the Path!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_e 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_f 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_g 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_h 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0240_pot corr_b_sound_i 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0240_pot))
;	(sleep (ai_play_line_on_object corr_b_sound_h 0240))
	(sleep (* dialogue_pause 4))

	(if dialogue (print "CORTANA: I've got a fix on Truth just outside this tower, Chief"))
	(sleep (ai_play_line_on_object none 2470))
	(sleep dialogue_pause)

	(set g_music_07a_04 1)
	
	(if dialogue (print "CORTANA: There's an exit nearby - hurry!"))
	(sleep (ai_play_line_on_object none 2480))
	(sleep (* dialogue_pause 5))

	(set g_corr_b_exit_finished 1)
	
	(game_save_no_timeout)
)

(script dormant sc_network
	(sleep_until
		(or
			(<= (ai_living_count grand_b_hunters) 0)
			(volume_test_objects tv_tower_a_ext (players))
		)
	)
	(sleep 30)
	
	(sleep_until g_corr_b_exit_finished)
	
	(if dialogue (print "TRUTH: With my blessing, the Brutes now lead our fleets."))
	(if dialogue (print "TRUTH: They ask for your allegiance, and you shall give it!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0230_pot ext_a_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0230_pot ext_a_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0230_pot ext_a_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0230_pot ext_a_sound_e 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0230_pot ext_a_sound_f 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0230_pot ext_a_sound_g 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0230_pot))
;	(sleep (ai_play_line_on_object ioc_sound_c 0230))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: You wouldn't believe the number of kill systems the"))
	(if dialogue (print "CORTANA: Covenant are throwing-down around me."))
	(sleep (ai_play_line_on_object none 2490))
	(sleep (* dialogue_pause 3))

	(if dialogue (print "CORTANA: Not to worry - it's pretty sloppy stuff."))
	(if dialogue (print "CORTANA: I guess they never expected a hostile intelligence"))
	(if dialogue (print "CORTANA: to penetrate their network from the inside!"))
	(sleep (ai_play_line_on_object none 2500))
	
	(game_save_no_timeout)
)

(script dormant in_amber_clad
	(object_create ioc_effect)
	(sound_impulse_start sound\visual_effects\inamberclad_flyby\slipspace rupture 1)
	(sound_impulse_start sound\visual_effects\inamberclad_flyby\inamberclad_flyby none 1)
	(sleep 3)
	(object_create ioc)
	(device_set_position_track ioc high_charity_flyby 0)
	(device_animate_position ioc 1 15 0 0 false)
	(sleep 30)
	(object_destroy ioc_effect)

	(sleep 30)
	(damage_object objects\cinematics\human\inamberclad_to_scale\damage_effects\ioc_flyby (player0))

	(sleep_until (>= (device_get_position ioc) 1))
	(object_destroy ioc)
)

(global boolean g_ioc_reminder 0)
(global boolean g_ioc_reminder_played 0)

(script dormant sc_ioc_reminder
	(sleep (* 30 10))
	(sleep_until
		(begin
			(if	(volume_test_objects tv_garden_a_tram (players))
				(begin
					(if g_council_exit_reminder (sleep_forever))
					(if dialogue (print "CORTANA: Just step into the pad. It'll move you forward automatically."))
					(sleep (ai_play_line_at_player cortana_3a 2570))
					(set g_ioc_reminder_played 1)
					(sleep 30)
;					(erase_cortana)
				)
			)
			(if g_ioc_reminder_played (begin (set g_ioc_reminder_played 0) (sleep (* 30 20))))
		g_ioc_reminder)
	60)
)

(global boolean g_truth_speaking 0)

(script dormant sc_truth_a
	(set g_truth_speaking 1)
;*
	(object_destroy garden_tram_a_bk)
	(object_create garden_tram_a)
	(device_set_position tram_a_effect 1)
	(device_set_position tram_a_bk_effect 1)
*;

	(if dialogue (print "CORTANA: They Covenant just destroyed two of their own ships,"))
	(if dialogue (print "CORTANA: and I'm hearing reports of small arms fire throughout their fleet."))
	(sleep (ai_play_line_on_object none 2520))
	(sleep dialogue_pause)

	(if dialogue (print "TRUTH: Creatures of the Covenant: the Path is broad,"))
	(if dialogue (print "TRUTH: and we shall walk it side-by-side!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0180_pot ioc_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0180_pot ioc_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0180_pot ioc_sound_c 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0180_pot))
;	(sleep (ai_play_line_on_object ioc_sound_c 0180))
	(sleep dialogue_pause)
	
	(set g_truth_speaking 0)
)

(script dormant sc_in_amber_clad
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_3a/tram_a)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 garden_a_holo_a "effect")
	(sleep 120)

	
	(sleep_until
				(and
						(> (objects_distance_to_object (players) garden_a_holo_a) 0)
						(< (objects_distance_to_object (players) garden_a_holo_a) 4)
				)
	5)

;	(if dialogue (print "CORTANA: They've cut the power to the pedway - hang tight while I bring it back online."))
;	(sleep (ai_play_line_at_player cortana_3a 2510))
;	(sleep (* dialogue_pause 3))

	(if dialogue (print "CORTANA: Slip-space rupture!"))
	(sleep (ai_play_line_at_player cortana_3a 2530))
	(sleep dialogue_pause)

	(set g_music_07a_05 1)

	(wake in_amber_clad)
	(if dialogue (print "CORTANA: It's In Amber Clad!"))
	(sleep (ai_play_line_at_player cortana_3a 2531))
	(sleep dialogue_pause)


	(set g_sc_ioc_finished 1)

	(sleep_until (not g_truth_speaking))
	(if dialogue (print "TRUTH: Be glad! The reward for all your toil, all your sacrifice,"))
	(if dialogue (print "TRUTH: is near at hand!"))

	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0320_pot ioc_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0320_pot ioc_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0320_pot ioc_sound_c 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0320_pot))
;	(sleep (ai_play_line_on_object ioc_sound_c 0320))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: Hailing... no response!"))
	(sleep (ai_play_line_at_player cortana_3a 2540))
	(sleep dialogue_pause)
	(game_save)
	
	(sleep_until (>= (device_get_position ioc) .9))
	(sleep 30)
	(if dialogue (print "CORTANA: She's crashed into another tower ahead of our position."))
	(if dialogue (print "CORTANA: I'll keep trying to make contact,"))
	(if dialogue (print "CORTANA: but I'm not registering any human vital-signs..."))
	(sleep (ai_play_line_at_player cortana_3a 2550))
	(sleep (* dialogue_pause 10))

	(set g_music_07a_04 0)
;*	
	(if dialogue (print "CORTANA: Power restored. Go ahead, Chief."))
	(sleep (ai_play_line_at_player cortana_3a 2560))
	(sleep dialogue_pause)
*;
	(wake sc_ioc_reminder)
	(game_save)	
;	(erase_cortana)
)

(script dormant sc_garden_a_tram_reminder
	(if dialogue (print "CORTANA: Truth has a big enough lead as it is, Chief. Get going!"))
	(sleep (ai_play_line_on_object none 2580))
)

(script dormant sc_drive_elites
	(sleep (random_range 30 90))

	(if dialogue (print "TRUTH: At this moment, the councilors gather on Halo to see the Icon safely placed!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0160_pot midtower_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0160_pot midtower_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0160_pot midtower_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0160_pot midtower_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0160_pot midtower_sound_e 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0160_pot))
;	(sleep (ai_play_line_on_object midtower_sound_e 0160))
	(sleep dialogue_pause)


	(if dialogue (print "BRUTE: Rise, pack-brothers! Death to the Elites!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_1040_bth midtower_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1040_bth midtower_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1040_bth midtower_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1040_bth midtower_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1040_bth midtower_sound_e 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_1040_bth))
;	(sleep (ai_play_line_on_object midtower_sound_e 1040))
	(sleep dialogue_pause)


	(if dialogue (print "TRUTH: There are those who said this day would never come."))
	(if dialogue (print "TRUTH: What have they to say now?"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0310_pot midtower_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0310_pot midtower_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0310_pot midtower_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0310_pot midtower_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0310_pot midtower_sound_e 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0310_pot))
;	(sleep (ai_play_line_on_object midtower_sound_e 0310))
	(sleep dialogue_pause)


	(if dialogue (print "BRUTE: Once the towers are cleared, we'll drive them from the lower districts!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_1050_bth midtower_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1050_bth midtower_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1050_bth midtower_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1050_bth midtower_sound_d 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1050_bth midtower_sound_e 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_1050_bth))
;	(sleep (ai_play_line_on_object midtower_sound_e 1050))
)

(script dormant sc_gardens_b
	(sleep_until (volume_test_objects tv_sc_gardens_b (players)))

	(if dialogue (print "TRUTH: I have listened to the Oracle, and it confirmed our dearest hope:"))
	(if dialogue (print "TRUTH: the Great Journey begins with Halo!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0290_pot garden_b_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0290_pot garden_b_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0290_pot garden_b_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0290_pot garden_b_sound_e 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0290_pot garden_b_sound_f 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0290_pot garden_b_sound_g 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0290_pot garden_b_sound_h 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0290_pot garden_b_sound_d 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0290_pot))
;	(sleep (ai_play_line_on_object garden_b_sound_d 0290))
	(sleep dialogue_pause)


	(if dialogue (print "BRUTE: The Elites are falling back to the mausoleum!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_1060_bth garden_b_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1060_bth garden_b_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1060_bth garden_b_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1060_bth garden_b_sound_e 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1060_bth garden_b_sound_f 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1060_bth garden_b_sound_g 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1060_bth garden_b_sound_h 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1060_bth garden_b_sound_d 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_1060_bth))
;	(sleep (ai_play_line_on_object garden_b_sound_d 1060))
	(sleep dialogue_pause)

	(if dialogue (print "BRUTE: Fools! Their Arbiter can do nothing for them now!"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_1070_bth garden_b_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1070_bth garden_b_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1070_bth garden_b_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1070_bth garden_b_sound_e 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1070_bth garden_b_sound_f 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1070_bth garden_b_sound_g 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1070_bth garden_b_sound_h 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_1070_bth garden_b_sound_d 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_1070_bth))
;	(sleep (ai_play_line_on_object garden_b_sound_d 1070))
	(sleep dialogue_pause)

	(if dialogue (print "TRUTH: Who would doubt the Prophets?"))
	(if dialogue (print "TRUTH: What have we foretold that has not come to pass?"))
	(sound_impulse_start sound\dialog\levels\07_highcharity\mission\l07_0300_pot garden_b_sound_a 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0300_pot garden_b_sound_b 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0300_pot garden_b_sound_c 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0300_pot garden_b_sound_e 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0300_pot garden_b_sound_f 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0300_pot garden_b_sound_g 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0300_pot garden_b_sound_h 1 1)
	(sound_impulse_trigger sound\dialog\levels\07_highcharity\mission\l07_0300_pot garden_b_sound_d 1 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\07_highcharity\mission\l07_0300_pot))
;	(sleep (ai_play_line_on_object garden_b_sound_d 0300))
)
;*
(script static void sc_flood
	(if dialogue (print "CORTANA: This isn't good. I'm getting confirmed reports of Flood"))
	(if dialogue (print "CORTANA: leaving In Amber Clad's wreckage"))
	(sleep (ai_play_line_on_object none 2590))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: Let's get the index, and find a way out of here -"))
	(if dialogue (print "CORTANA: before things get really ugly!"))
	(sleep (ai_play_line_on_object none 2600))
)
*;
(script dormant sc_catch_truth
	(if dialogue (print "CORTANA: If we're going to catch Truth, we'll need to take a short-cut -"))
	(if dialogue (print "CORTANA: straight through this mausoleum"))
	(sleep (ai_play_line_on_object none 2610))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: Look on the bright side. For now,"))
	(if dialogue (print "CORTANA: they seem much more interested in killing each other"))
	(sleep (ai_play_line_on_object none 2620))
)

(script dormant sc_maus_interior
	(sleep_until	(or
					(volume_test_objects tv_maus_ent (players))
					(>= (device_get_position maus_inner_ent) 0)
				)
	)
	(sleep 30)
	(ai_place cortana_maus/a)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 maus_inner_holo_a "effect")
	(sleep 45)
	(if dialogue (print "CORTANA: You might consider sitting this one out"))
	(sleep (ai_play_line_at_player cortana_maus 2630))
	
	(sleep 30)
	(set g_music_07a_07 1)
	(sleep 60)
	(erase_cortana)
)

(script static void sc_maus_breather
	(ai_place cortana_maus/j)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 maus_inner_holo_j "effect")
	(sleep_until	(and
					(> (objects_distance_to_object (players) maus_inner_holo_j) 0)
					(< (objects_distance_to_object (players) maus_inner_holo_j) 6)
				)
	30 (* 30 60 1.5))

	(if dialogue (print "CORTANA: Hang on... I'm picking-up two more transponders..."))
	(sleep (ai_play_line_at_player cortana_maus 2640))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: It's the Commander and Johnsom!"))
	(sleep (ai_play_line_at_player cortana_maus 2650))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: They're closing on Truth's position, Chief!"))
	(sleep (ai_play_line_at_player cortana_maus 2660))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: They'll need your help!"))
	(sleep (ai_play_line_at_player cortana_maus 2670))
	
	(set g_music_07a_07_alt 1)
)

(script dormant sc_maus_exit
;	(set g_maus_inner_cor_tele 1)
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_maus/f)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 maus_inner_holo_f "effect")

	(device_one_sided_set maus_inner_exit 0)
;	(device_group_change_only_once_more_set maus_door_ent 1)
;	(device_group_change_only_once_more_set maus_door_exit 1)
;	(device_group_change_only_once_more_set maus_door_end 1)
;	(device_operates_automatically_set maus_door_end 1)
	(sleep 1)

	(sleep_until	(and
					(> (objects_distance_to_object (players) maus_inner_holo_f) 0)
					(< (objects_distance_to_object (players) maus_inner_holo_f) 7)
				)
	5)

	(erase_cortana)

	
	(if dialogue (print "CORTANA: This way, Chief!"))
	(sleep (ai_play_line_at_player cortana_maus 2000))
	(sleep dialogue_pause)
;	(sc_this_way_a)

;	(sleep_until (> (device_get_position maus_door_end) .5))
	(sleep_until (volume_test_objects tv_game_won (players)) 1) ; 9/25 
	(set g_music_07a_08 0)
	(sleep 75)

	(if dialogue (print "CORTANA: This isn't good. I'm getting confirmed reports of Flood"))
	(if dialogue (print "CORTANA: leaving In Amber Clad's wreckage"))
	(sleep (ai_play_line_on_object none 2590))
	(sleep dialogue_pause)

	(if dialogue (print "CORTANA: Let's get the index, and find a way out of here -"))
	(if dialogue (print "CORTANA: before things get really ugly!"))
	(sleep (ai_play_line_on_object none 2600))
	(sleep 30)
	
;	(sleep_until (volume_test_objects tv_game_won (players)) 1) ; 9/18 
	(cinematic_fade_to_white)
	(ai_erase_all)

	(if (= g_play_cinematics 1)
		(begin
	
			(if (cinematic_skip_start)
				(begin
					(if debug (print "c07_intra_1"))
					(c07_intra1)
				)
			)
			(cinematic_skip_stop)
		)
	)
	(if debug (print "you win"))
	(playtest_mission)
	
	(game_won)

)

; =====  MARINE MIGRATION SCRIPTS ===========================================================================
(script dormant marine_migration
	(sleep_until ; sets orders based on bsp index 
		(begin
			(cond
				((= (structure_bsp_index) 2)	(begin
											(if debug (print "migrate into corridor b"))
											(ai_set_orders marines marines_corr_b)
										)
				)
				((= (structure_bsp_index) 3)	(begin
											(if debug (print "migrate into exterior a"))
											(ai_set_orders marines marines_ext_a)
										)
				)
			)
		g_marine_mig_garden_a) ; triggers when the gardens a script is woken (after IOC fly-by)
	)
	
	(sleep 30)
	(if debug (print "migrate into gardens a"))
	(ai_set_orders marines marines_gardens_a)
	
	(sleep_until g_marine_mig_midtower) ; triggers when the mid-tower script is woken 
	(sleep_until ; sets orders based on bsp index 
		(begin
			(cond
				((= (structure_bsp_index) 3)	(begin
											(if debug (print "migrate into mid-tower"))
											(ai_set_orders marines marines_midtower)
										)
				)
				((= (structure_bsp_index) 4)	(begin
											(if debug (print "migrate into gardens b"))
											(ai_set_orders marines marines_gardens_b)
										)
				)
			)
		g_marine_mig_ext_b) ; triggers when exterior b is initiated (player walking up steep incline 
	)
	
	(sleep 30)
	(if debug (print "migrate into exterior b"))
	(ai_set_orders marines marines_ext_b)
	
	(sleep_until g_marine_mig_maus) ; triggers when maus halls scripts initialize 
	(sleep_until ; sets orders based on bsp index 
		(begin
			(cond
				((= (structure_bsp_index) 4)	(begin
											(if debug (print "migrate into mausoleum halls"))
											(ai_set_orders marines marines_maus_halls)
										)
				)
				((= (structure_bsp_index) 5)
										(begin
											(if debug (print "migrate into mausoleum room bridge"))
											(ai_set_orders marines marines_maus_room_bridge)
										)
				)
			)
		g_marine_mig_maus_int) ; triggers when the maus interior scripts initialize 
	)
	
	(sleep 30)
	(if debug (print "migrate into mausoleum interior"))
	(ai_set_orders marines marines_maus_int)
)

(script dormant grand_b_door
	(sleep_until
		(begin
			(cond
				((= (structure_bsp_index) 2) (device_operates_automatically_set grand_b_door true))
				((= (structure_bsp_index) 3) (device_operates_automatically_set grand_b_door false))
			)
		false)
	1)
)

; =====  COUNCIL CHAMBER SCRIPTS ===========================================================================

(global boolean g_council_over 0)
(global boolean g_council_wave 0)
(global short g_council_count 0)
(global short g_council_limit 0)

(script command_script cs_council_grunt_a
	(cs_movement_mode 3)
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to council/p0)
	(sleep_until	(or
					(volume_test_objects tv_council_door_right_a (players))
					(<= (ai_living_count council_brute_ini) 0)
				)
	)
)
(script command_script cs_council_grunt_b
	(cs_movement_mode 3)
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to council/p1)
	(sleep_until	(or
					(volume_test_objects tv_council_door_right_b (players))
					(<= (ai_living_count council_brute_ini) 0)
				)
	)
)
(script command_script cs_council_grunt_c
	(cs_movement_mode 3)
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to council/p2)
	(sleep_until	(or
					(volume_test_objects tv_council_door_left_a (players))
					(<= (ai_living_count council_brute_ini) 0)
				)
	)
)
(script command_script cs_council_grunt_d
	(cs_movement_mode 3)
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to council/p3)
	(sleep_until	(or
					(volume_test_objects tv_council_door_left_b (players))
					(<= (ai_living_count council_brute_ini) 0)
				)
	)
)

(script dormant ai_council_brutes_berserk
	(sleep_until (<= (ai_living_count council_brute_ini) 1) 1)
	(if (> (ai_living_count council_brute_ini) 0)
		(begin
			(ai_set_orders council_brute_ini council_floor_all)
			(ai_berserk council_brute_ini 1)
			(sleep_until g_council_initial)
			(wake sc_brutes_berserk)
		)
	)
)

(script static void ai_council_left_a
	(if (and
			(not (volume_test_objects tv_council_door_left_a (players)))
			(= (device_get_position council_door_left_a) 0))
		(begin
			(if debug (print "left a"))
			(ai_place council_lt_brute_a)
			(ai_place council_lt_grunt_a)
			(set g_council_count (+ g_council_count 1))
			(if (= g_council_count g_council_limit) (set g_council_wave 0))
		)
	)
)

(script static void ai_council_left_b
	(if (and
			(not (volume_test_objects tv_council_door_left_b (players)))
			(= (device_get_position council_door_left_b) 0))
		(begin
			(if debug (print "left b"))
			(ai_place council_lt_brute_b)
			(ai_place council_lt_grunt_b)
			(set g_council_count (+ g_council_count 1))
			(if (= g_council_count g_council_limit) (set g_council_wave 0))
		)
	)
)

(script static void ai_council_left_c
	(if (and
			(not (volume_test_objects tv_council_door_left_c (players)))
			(= (device_get_position council_door_left_c) 0))
		(begin
			(if debug (print "left c"))
			(ai_place council_lt_brute_c)
			(ai_place council_lt_grunt_c)
			(set g_council_count (+ g_council_count 1))
			(if (= g_council_count g_council_limit) (set g_council_wave 0))
		)
	)
)

(script static void ai_council_right_a
	(if (and
			(not (volume_test_objects tv_council_door_right_a (players)))
			(= (device_get_position council_door_right_a) 0))
		(begin
			(if debug (print "right a"))
			(ai_place council_rt_brute_a)
			(ai_place council_rt_grunt_a)
			(set g_council_count (+ g_council_count 1))
			(if (= g_council_count g_council_limit) (set g_council_wave 0))
		)
	)
)

(script static void ai_council_right_b
	(if (and
			(not (volume_test_objects tv_council_door_right_b (players)))
			(= (device_get_position council_door_right_b) 0))
		(begin
			(if debug (print "right b"))
			(ai_place council_rt_brute_b)
			(ai_place council_rt_grunt_b)
			(set g_council_count (+ g_council_count 1))
			(if (= g_council_count g_council_limit) (set g_council_wave 0))
		)
	)
)

(script static void ai_council_right_c
	(if (and
			(not (volume_test_objects tv_council_door_right_c (players)))
			(= (device_get_position council_door_right_c) 0))
		(begin
			(if debug (print "right c"))
			(ai_place council_rt_brute_c)
			(ai_place council_rt_grunt_c)
			(set g_council_count (+ g_council_count 1))
			(if (= g_council_count g_council_limit) (set g_council_wave 0))
		)
	)
)

(script static void ai_council_rt_fr
	(if debug (print "right front"))
	
	(begin_random
		(if g_council_wave (ai_council_left_a))
		(if g_council_wave (ai_council_left_b))
		(if g_council_wave (ai_council_right_c))
	)
)

(script static void ai_council_rt_bk
	(if debug (print "right back"))
	
	(begin_random
		(if g_council_wave (ai_council_left_b))
		(if g_council_wave (ai_council_left_c))
		(if g_council_wave (ai_council_right_a))
	)
)

(script static void ai_council_lt_fr
	(if debug (print "left front"))
	
	(begin_random
		(if g_council_wave (ai_council_left_c))
		(if g_council_wave (ai_council_right_a))
		(if g_council_wave (ai_council_right_b))
	)
)

(script static void ai_council_lt_bk
	(if debug (print "left back"))
	
	(begin_random
		(if g_council_wave (ai_council_left_a))
		(if g_council_wave (ai_council_right_b))
		(if g_council_wave (ai_council_right_c))
	)
)

(script static void ai_council_fr
	(if debug (print "front"))
	
	(begin_random
		(if g_council_wave (ai_council_left_a))
		(if g_council_wave (ai_council_right_a))
	)
)

(script static void ai_council_bk
	(if debug (print "back"))
	
	(begin_random
		(if g_council_wave (ai_council_left_c))
		(if g_council_wave (ai_council_right_c))
	)
)

(global boolean g_council_orders 0)
(global boolean g_council_floor_wave 0)
(global short g_council_floor_wave_count 0)
(global short g_council_floor_wave_limit 0)

(script dormant ai_council_orders
	(sleep_until
		(begin
			(cond
;				((volume_test_objects tv_council_fr (players)) (ai_set_orders council_prophets_floor council_fr))
				((volume_test_objects tv_council_rt_fr (players)) (ai_set_orders council_prophets_floor council_rt_fr))
				((volume_test_objects tv_council_rt_bk (players)) (ai_set_orders council_prophets_floor council_rt_bk))
				((volume_test_objects tv_council_lt_fr (players)) (ai_set_orders council_prophets_floor council_lt_fr))
				((volume_test_objects tv_council_lt_bk (players)) (ai_set_orders council_prophets_floor council_lt_bk))
;				((volume_test_objects tv_council_bk (players)) (ai_set_orders council_prophets_floor council_bk))
			)
		g_council_orders)
	)
)

(script dormant ai_council_upper_migrate
	(sleep_until	(or
					(<= (ai_living_count council_prophets_floor) 0)
					(<= (ai_strength council_prophets_upper) .4)
				)
	30 (* 30 40))

;	(ai_berserk council_prophets_upper 1)
	(sleep 30)
	(ai_migrate council_prophets_upper council_rt_brute_a)
)

(global boolean g_council_upper 1)
(global short g_council_upper_limit 0)
(global short g_council_upper_count 0)

(script dormant ai_council_upper
	(sleep_until (<= (ai_living_count council_prophets) 2))
	(sleep 120)

	(begin_random
		(if g_council_upper
			(begin
				(ai_place council_rt_upper_brute_a)
				(set g_council_upper_count (+ g_council_upper_count 1))
				(if (= g_council_upper_count g_council_upper_limit) (set g_council_upper 0))
			)
		)
		(if g_council_upper
			(begin
				(ai_place council_rt_upper_brute_b)
				(set g_council_upper_count (+ g_council_upper_count 1))
				(if (= g_council_upper_count g_council_upper_limit) (set g_council_upper 0))
			)
		)
		(if g_council_upper
			(begin
				(ai_place council_rt_upper_brute_c)
				(set g_council_upper_count (+ g_council_upper_count 1))
				(if (= g_council_upper_count g_council_upper_limit) (set g_council_upper 0))
			)
		)
		(if g_council_upper
			(begin
				(ai_place council_lt_upper_brute_a)
				(set g_council_upper_count (+ g_council_upper_count 1))
				(if (= g_council_upper_count g_council_upper_limit) (set g_council_upper 0))
			)
		)
		(if g_council_upper
			(begin
				(ai_place council_lt_upper_brute_b)
				(set g_council_upper_count (+ g_council_upper_count 1))
				(if (= g_council_upper_count g_council_upper_limit) (set g_council_upper 0))
			)
		)
		(if g_council_upper
			(begin
				(ai_place council_lt_upper_brute_c)
				(set g_council_upper_count (+ g_council_upper_count 1))
				(if (= g_council_upper_count g_council_upper_limit) (set g_council_upper 0))
			)
		)
	)

	(wake ai_council_upper_migrate)
)

(script dormant ai_council_floor_spawn
	(set g_council_wave 1)
	
	(cond
		((difficulty_normal) (begin (set g_council_floor_wave_limit 1) (set g_council_limit 1)))
		((difficulty_heroic) (begin (set g_council_floor_wave_limit 1) (set g_council_limit 2)))
		((difficulty_legendary) (begin (set g_council_floor_wave_limit 2) (set g_council_limit 2)))
	)

	(cond
		((difficulty_normal) (set g_council_upper_limit 1))
		((difficulty_heroic) (set g_council_upper_limit 2))
		((difficulty_legendary) (set g_council_upper_limit 2))
	)

	(data_mine_set_mission_segment enc_council_wave_1)

	(sc_council_mid)
	(game_save)
	(sleep 120)
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count council_prophets_floor) 0))
			(game_save)
			
			(sleep (random_range sleep_lower_bound sleep_upper_bound))
			(if debug (print "begin wave 1"))
			(set g_council_wave 1)
			(set g_council_count 0)
			(cond
				((volume_test_objects tv_council_fr (players)) (ai_council_fr))
				((volume_test_objects tv_council_rt_fr (players)) (ai_council_rt_fr))
				((volume_test_objects tv_council_rt_bk (players)) (ai_council_rt_bk))
				((volume_test_objects tv_council_lt_fr (players)) (ai_council_lt_fr))
				((volume_test_objects tv_council_lt_bk (players)) (ai_council_lt_bk))
				((volume_test_objects tv_council_bk (players)) (ai_council_bk))
			)
			(set g_council_floor_wave_count (+ g_council_floor_wave_count 1))
			(if (= g_council_floor_wave_count g_council_floor_wave_limit) (set g_council_floor_wave 1))
		g_council_floor_wave)
	)
	
	(if debug (print "wave 1 over"))
	(set g_council_floor_wave 0)
	(set g_council_floor_wave_count 0)
	
	(sleep_until (<= (ai_living_count council_prophets_floor) 0))
	(sleep 150)
	(data_mine_set_mission_segment enc_council_pedestal)
	
	(game_save)
	
	(sleep 15)
	(if debug (print "pedestal, sides and upper"))
	(ai_place council_brute_ped/a)
	(ai_place council_brute_ped/b)
	(if (difficulty_legendary)
		(begin
			(ai_place council_brute_ped/chief)
			(wake sc_ledge_chieftan)
		)
;		(ai_place council_brute_ped/c)
	)
	(if
		(or
			(difficulty_heroic)
			(difficulty_legendary)
		)
			(begin
				(ai_place council_rt_grunt_c 1)
				(ai_place council_lt_grunt_c 1)
			)
	)
	(if (difficulty_legendary)
		(begin
			(ai_place council_rt_grunt_b 1)
			(ai_place council_lt_grunt_b 1)
		)
	)

	(sleep 30)
	(wake ai_council_upper)
	(sleep 30)
	(device_set_position council_ped 0)
	
	(sleep 5)
	(if
		(or
			(difficulty_heroic)
			(difficulty_legendary)
		)
		(sleep_until
			(begin
				(sleep_until (<= (ai_living_count council_prophets) 0))
				(game_save)
				(data_mine_set_mission_segment enc_council_wave_2)
				
				(sleep (random_range sleep_lower_bound sleep_upper_bound))
				(if debug (print "begin wave 2"))
				(set g_council_wave 1)
				(set g_council_count 0)
				(cond
					((volume_test_objects tv_council_fr (players)) (ai_council_fr))
					((volume_test_objects tv_council_rt_fr (players)) (ai_council_rt_fr))
					((volume_test_objects tv_council_rt_bk (players)) (ai_council_rt_bk))
					((volume_test_objects tv_council_lt_fr (players)) (ai_council_lt_fr))
					((volume_test_objects tv_council_lt_bk (players)) (ai_council_lt_bk))
					((volume_test_objects tv_council_bk (players)) (ai_council_bk))
				)
				(set g_council_floor_wave_count (+ g_council_floor_wave_count 1))
				(if (= g_council_floor_wave_count g_council_floor_wave_limit) (set g_council_floor_wave 1))
			g_council_floor_wave)
		)
	)
	
	(print "wave 2 over")
	(set g_council_floor_wave 0)
	(set g_council_over 1)

	
)

;========== GRAND A SCRIPTS ==============================================================================
(script command_script cs_grand_a_grunt_a
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_pathfinding_failsafe true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to grand_a/p0 2)
					(sleep (random_range 0 15))
				)
				(begin
					(cs_go_to grand_a/p1 2)
					(sleep (random_range 0 15))
				)
				(begin
					(cs_go_to grand_a/p2 2)
					(sleep (random_range 0 15))
				)
				(begin
					(cs_go_to grand_a/p3 2)
					(sleep (random_range 0 15))
				)
			)
		false)
	)
)
(script command_script cs_grand_a_grunt_b
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_pathfinding_failsafe true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to grand_a/p4 2)
					(sleep (random_range 0 15))
				)
				(begin
					(cs_go_to grand_a/p5 2)
					(sleep (random_range 0 15))
				)
				(begin
					(cs_go_to grand_a/p6 2)
					(sleep (random_range 0 15))
				)
				(begin
					(cs_go_to grand_a/p7 2)
					(sleep (random_range 0 15))
				)
			)
		false)
	)
)

;========== DERVISH LEDGE SCRIPTS ==============================================================================
(script dormant create_ledge_columns
	(begin_random
		(begin
			(object_create ledge_col_a)
			(sleep (random_range 45 90))
		)
		(begin
			(object_create ledge_col_b)
			(sleep (random_range 45 90))
		)
		(begin
			(object_create ledge_col_c)
			(sleep (random_range 45 90))
		)
		(begin
			(object_create ledge_col_d)
			(sleep (random_range 45 90))
		)
		(begin
			(object_create ledge_col_e)
			(sleep (random_range 45 90))
		)
		(begin
			(object_create ledge_col_f)
			(sleep (random_range 45 90))
		)
	)
)

(script command_script cs_ledge_jackals_lt
	(cs_abort_on_alert 1)
	
	(sleep_until
		(begin
			(cs_go_to dervish_ledge/lt_0)
			(cs_go_to dervish_ledge/lt_1)
		false)
	)
)
(script command_script cs_ledge_jackals_rt
	(cs_abort_on_alert 1)
	
	(sleep_until
		(begin
			(cs_go_to dervish_ledge/rt_0)
			(cs_go_to dervish_ledge/rt_1)
		false)
	)
)
(script command_script cs_ledge_brute_a
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	
;	(sleep_until
;		(begin
;			(begin_random
;				(begin
;					(cs_go_to dervish_ledge/b1_1)
;					(sleep (random_range 0 15))
;				)
;				(begin
					(cs_go_to dervish_ledge/b1_2)
;					(sleep (random_range 0 15))
;				)
;			)
;		false)
;	)
)
(script command_script cs_ledge_brute_b
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	
;	(sleep_until
;		(begin
;			(begin_random
;				(begin
;					(cs_go_to dervish_ledge/b2_1)
;					(sleep (random_range 0 15))
;				)
;				(begin
					(cs_go_to dervish_ledge/b2_2)
;					(sleep (random_range 0 15))
;				)
;			)
;		false)
;	)
)

(script command_script cs_lift_jump
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to dervish_ledge/p0)
	(cs_jump_to_point 0 5)
)

(script static void ledge_fr_orders
	(ai_set_orders ledge_lift_brute_rt ledge_rt_fr)
	(ai_set_orders ledge_lift_brute_lt ledge_lt_fr)
	(ai_set_orders ledge_lift_grunt_rt ledge_minor_rt_fr)
	(ai_set_orders ledge_lift_grunt_lt ledge_minor_lt_fr)
	(ai_set_orders ledge_jackal_right ledge_minor_rt_fr)
	(ai_set_orders ledge_jackal_left ledge_minor_lt_fr)
	(ai_set_orders ledge_lift_chieftan ledge_chieftan)
)

(script static void ledge_bk_orders
	(ai_set_orders ledge_lift_brute_rt ledge_rt_bk)
	(ai_set_orders ledge_lift_brute_lt ledge_lt_bk)
	(ai_set_orders ledge_lift_grunt_rt ledge_minor_rt_bk)
	(ai_set_orders ledge_lift_grunt_lt ledge_minor_lt_bk)
	(ai_set_orders ledge_jackal_right ledge_minor_rt_bk)
	(ai_set_orders ledge_jackal_left ledge_minor_lt_bk)
	(ai_set_orders ledge_lift_chieftan ledge_chieftan_lift)
)

(script dormant ai_dervish_ledge_orders
	(sleep_until (>= (ai_combat_status dervish_ledge_prophets) ai_combat_status_active))
	(sleep_until
		(begin
			(cond
				((volume_test_objects tv_dervish_ledge_fr (players)) (begin (sleep (random_range 5 30)) (ledge_fr_orders)))
				((volume_test_objects tv_dervish_ledge_bk (players)) (begin (sleep (random_range 5 30)) (ledge_bk_orders)))
				((volume_test_objects tv_dervish_ledge_lift (players)) (begin (sleep (random_range 5 30)) (ledge_bk_orders)))
			)
		g_dervish_ledge_orders)
	)
)

(global boolean g_ledge_turret_left 0)
(global boolean g_ledge_turret_right 0)

(script command_script cs_ledge_turrets_left
	(cs_enable_pathfinding_failsafe true)
	
	(if (not g_ledge_turret_left)
		(begin
			(set g_ledge_turret_left 1)
			(cs_go_to dervish_ledge_turret/deploy_p2)
			(cs_deploy_turret dervish_ledge_turret/deploy_p2)
		)
		(begin
			(cs_go_to dervish_ledge_turret/deploy_p3)
			(cs_deploy_turret dervish_ledge_turret/deploy_p3)
		)
	)
)

(script command_script cs_ledge_turrets_right
	(cs_enable_pathfinding_failsafe true)
	
	(if (not g_ledge_turret_right)
		(begin
			(set g_ledge_turret_right 1)
			(cs_go_to dervish_ledge_turret/deploy_p0)
			(cs_deploy_turret dervish_ledge_turret/deploy_p0)
		)
		
		(begin
			(cs_go_to dervish_ledge_turret/deploy_p1)
			(cs_deploy_turret dervish_ledge_turret/deploy_p1)
		)
	)
)



(script dormant ai_ledge_lift
	(ai_place ledge_lift_grunt_lt 2)
	(ai_place ledge_lift_grunt_rt)
	(sleep 120)
	(if	(and
			(<= (ai_living_count dervish_ledge_prophets) 5)
			(or
				(difficulty_heroic)
				(difficulty_legendary)
			)
			(not (volume_test_objects tv_dervish_ledge_lift (players)))
		)
		(begin
			(ai_place ledge_lift_grunt_lt)
			(ai_place ledge_lift_grunt_rt 2)
		)
	)
	(sleep 150)
	
	(sleep_until (<= (ai_living_count dervish_ledge_prophets) 6))

	(if	(or
			(difficulty_heroic)
			(difficulty_legendary)
		)
		(begin
			(ai_place ledge_lift_brute_lt)
			(ai_place ledge_lift_brute_rt)
		)
	)
	(ai_place ledge_lift_chieftan)

	(sleep_until	(and
					(objects_can_see_object (players) (ai_get_object ledge_lift_chieftan) 45)
					(volume_test_objects tv_dervish_ledge_lift (ai_get_object ledge_lift_chieftan))
				)
	30 (* 30 20))
	(wake sc_ledge_chieftan)
	(set g_music_07a_01 0)
)

(script dormant ai_ledge_lower
	(ai_place ledge_bot_grunts)
	(ai_place ledge_bot_jackals)
)
;========== CORRIDOR A SCRIPTS ==============================================================================
(global boolean g_corridor_a_active 0)

(script command_script cs_hall_a_jackal_ini_a
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_looking true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to hall_a/jackal_patrol_p0 1)
	(cs_look true hall_a/look_p0)
	(sleep_until (and (not (volume_test_objects tv_hall_a_jackal_patrol (players))) (<= (device_get_position hall_a_jackal_door) 0)) 5)
	(if (not g_corridor_a_active) (ai_erase ai_current_actor))
)
(script command_script cs_hall_a_jackal_ini_b
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_looking true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to hall_a/jackal_patrol_p1 1)
	(cs_look true hall_a/look_p0)
	(sleep_until (and (not (volume_test_objects tv_hall_a_jackal_patrol (players))) (<= (device_get_position hall_a_jackal_door) 0)) 5)
	(if (not g_corridor_a_active) (ai_erase ai_current_actor))
)
(script command_script cs_hall_a_jackal_ini_c
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_looking true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to hall_a/jackal_patrol_p2 1)
	(cs_look true hall_a/look_p0)
	(sleep_until (and (not (volume_test_objects tv_hall_a_jackal_patrol (players))) (<= (device_get_position hall_a_jackal_door) 0)) 5)
	(if (not g_corridor_a_active) (ai_erase ai_current_actor))
)
(script command_script cs_hall_a_brute_ini
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to hall_a/b_p0 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to hall_a/b_p1 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to hall_a/b_p2 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to hall_a/b_p3 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to hall_a/b_p4 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_look true hall_a/look_p0)
					(sleep (random_range 45 90))
					(cs_look false hall_a/look_p0)
				)
				(begin
					(cs_look true hall_a/look_p1)
					(sleep (random_range 45 90))
					(cs_look false hall_a/look_p1)
				)
				(begin
					(cs_look true hall_a/look_p2)
					(sleep (random_range 45 90))
					(cs_look false hall_a/look_p2)
				)
				(begin
					(cs_look true hall_a/look_p3)
					(sleep (random_range 45 90))
					(cs_look false hall_a/look_p3)
				)
			)
		false)
	)
)

(script command_script cs_hall_a_jackal_ini
	(cs_abort_on_combat_status ai_combat_status_certain)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to hall_a/j_p0 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to hall_a/j_p1 1)
					(begin_random
						(begin
							(cs_look true hall_a/look_p0)
							(sleep (random_range 60 90))
						)
						(begin
							(cs_look true hall_a/look_p2)
							(sleep (random_range 60 90))
						)
					)
				)				(begin
					(cs_go_to hall_a/j_p2 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to hall_a/j_p3 1)
					(begin_random
						(begin
							(cs_look true hall_a/look_p1)
							(sleep (random_range 60 90))
						)
						(begin
							(cs_look true hall_a/look_p3)
							(sleep (random_range 60 90))
						)
					)
				)
				(begin
					(cs_go_to hall_a/j_p4 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to hall_a/j_p5 1)
					(begin_random
						(begin
							(cs_look true hall_a/look_p0)
							(sleep (random_range 60 90))
						)
						(begin
							(cs_look true hall_a/look_p3)
							(sleep (random_range 60 90))
						)
					)
				)
				(begin
					(cs_go_to hall_a/j_p6 1)
					(sleep (random_range 0 45))
				)
			)
		false)
	)
)
(script command_script cs_hall_b_jackal_a
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_looking true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to hall_b/jackal_p0 1)
	(cs_look true hall_a/look_p0)
	(sleep_until (and (not (volume_test_objects tv_hall_b_jackal (players))) (<= (device_get_position hall_b_jackal_door) 0)) 5)
	(device_one_sided_set hall_b_jackal_door true)
)
(script command_script cs_hall_b_jackal_b
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_looking true)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to hall_b/jackal_p1 1)
	(cs_look true hall_a/look_p0)
	(sleep_until (and (not (volume_test_objects tv_hall_b_jackal (players))) (<= (device_get_position hall_b_jackal_door) 0)) 5)
	(device_one_sided_set hall_b_jackal_door true)
)
(script command_script cs_hall_b_brutes
	(cs_abort_on_combat_status ai_combat_status_clear_los)
	(cs_enable_pathfinding_failsafe true)
;	(if (not g_corridor_a_active)
		(sleep_until
			(begin
				(begin_random
					(begin
						(cs_go_to hall_b/p0 1)
						(sleep (random_range 0 45))
					)
					(begin
						(cs_go_to hall_b/p1 1)
						(sleep (random_range 0 45))
					)
					(begin
						(cs_go_to hall_b/p2 1)
						(sleep (random_range 0 45))
					)
					(begin
						(cs_go_to hall_b/p3 1)
						(sleep (random_range 0 45))
					)
					(begin
						(cs_go_to hall_b/p4 1)
						(sleep (random_range 0 45))
					)
				)
			false)
		)
;	)
)
(script command_script cs_hall_b_wake_grunts
	(if g_corridor_a_active (cs_force_combat_status ai_combat_status_alert))
)




;========== ROOM A SCRIPTS ==============================================================================
(script command_script cs_room_a_brute_ini
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to room_a/p0 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to room_a/p1 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_look true room_a/look_p0)
					(sleep (random_range 45 90))
					(cs_look false room_a/look_p0)
				)
				(begin
					(cs_look true room_a/look_p1)
					(sleep (random_range 45 90))
					(cs_look false hall_a/look_p1)
				)
			)
		false)
	)
)
(script command_script cs_room_a_jackal_ini
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_go_to room_a/p4 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_go_to room_a/p5 1)
					(sleep (random_range 0 45))
				)
				(begin
					(cs_look true room_a/look_p0)
					(sleep (random_range 45 90))
;					(cs_look false room_a/look_p0)
				)
				(begin
					(cs_look true room_a/look_p1)
					(sleep (random_range 45 90))
;					(cs_look rffalse hall_a/look_p1)
				)
			)
		false)
	)
)
(script command_script cs_room_a_brutes_bk
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_look true room_a/look_p0)
					(sleep (random_range 90 150))
;					(cs_look false room_a/look_p0)
				)
				(begin
					(cs_look true room_a/look_p2)
					(sleep (random_range 90 150))
;					(cs_look false room_a/look_p2)
				)
				(begin
					(cs_look true room_a/look_p3)
					(sleep (random_range 90 150))
;					(cs_look false hall_a/look_p3)
				)
			)
		false)
	)
)

(script command_script cs_room_a_to_jail
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to room_a/stand_p0)
	(cs_move_in_direction 0 1 180)
)

(script dormant room_a_door
	(sleep_until (> (device_get_position room_a_door) 0) 5)
	(set g_room_a_door 1)
	(if debug (print "room a door opened"))
)

(script dormant corridor_a_activate
	(sleep_until (>= (ai_combat_status hall_a_prophets) ai_combat_status_active))
	(set g_corridor_a_active 1)
	(if debug (print "corridor a prophets active"))
)

(script dormant ai_hall_a_prophets ; 9/18 
	(if debug (print "hall a initial prophets"))
	(ai_place hall_a_jackal_patrol_ini)
	(ai_place hall_a_brute_ini)
	(ai_place hall_a_jackal_ini)
	
;	(sleep_until g_corridor_a_active)

	(sleep_until	(or
					(<= (ai_living_count hall_a_prophets) 1)
					(volume_test_objects tv_hall_a_bk (players))
				)
	)
	(game_save)

	(if g_corridor_a_active
		(begin
			(if debug (print "hall a reinforcements"))
			(ai_place hall_a_brute_rein)
			(ai_place hall_a_grunt_rein (pin (- 6 (ai_living_count hall_a_prophets)) 0 2))
			(sleep 1)
			(ai_place hall_a_brute_rein_bk)
			(ai_place hall_a_grunt_rein_bk (pin (- 6 (ai_living_count hall_a_prophets)) 0 2))
		)
	)
)

(script dormant ai_room_a ; 9/18 
	(ai_place room_a_brutes_ini)
	(ai_place room_a_jackals_ini)
	(ai_place room_a_brutes_bk)
	
	(sleep_until	(or
					(volume_test_objects tv_room_a_mid (players))
					(and
						(<= (ai_living_count room_a_prophets) 2)
						(>= (ai_combat_status room_a_prophets) ai_combat_status_active)
					)
				)
	)
	
	(if	(and
			(>= (ai_combat_status room_a_prophets) ai_combat_status_active)
			(<= (ai_living_count room_a_prophets) 2)
		)
		(begin
			(ai_place room_a_brutes_a)
			(ai_place room_a_brutes_c)
			(sleep 1)
			(ai_place room_a_grunts_a (pin (- 4 (ai_living_count room_a_prophets)) 0 2))
			(ai_place room_a_grunts_c (pin (- 4 (ai_living_count room_a_prophets)) 0 2))
		)
	)
	
	(sleep_until (volume_test_objects tv_room_a_bk (players)))
	(if	(and
			(>= (ai_combat_status room_a_prophets) ai_combat_status_active)
			(<= (ai_living_count room_a_prophets) 4)
		)
		(begin
			(ai_place room_a_brutes_b)
			(ai_place room_a_grunts_b (pin (- 4 (ai_living_count room_a_prophets)) 0 2))
		)
	)
)
(script static void test_room_a_to_jail
	(wake sc_room_a_down)
	(ai_place room_a_brutes_ini)
	(ai_place room_a_jackals_ini)
	(ai_place room_a_brutes_bk)
	(sleep 150)
	(cs_run_command_script room_a_prophets cs_room_a_to_jail)
)
;========== JAIL SCRIPTS ==============================================================================
(global boolean g_jail_prophets_ini_active 0)

(script command_script cs_ignore_jail_a_marines
	(cs_abort_on_damage false)
	(ai_disregard (ai_actors jail_a_marines) true)
	(cs_look_player true)
	(sleep_until g_jail_a_free)
)
(script command_script cs_ignore_jail_b_marines
	(cs_abort_on_damage false)
	(ai_disregard (ai_actors jail_b_marines) true)
	(cs_look_player true)
	(sleep_until g_jail_b_free)
)

(script command_script cs_jail_jackal_ini_a
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jail_jackal_patrol/p0 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p1 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p2 1)
			(sleep (random_range 0 15))
		false)
	)
)
(script command_script cs_jail_jackal_ini_b
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jail_jackal_patrol/p3 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p4 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p5 1)
			(sleep (random_range 0 15))
		false)
	)
)
(script command_script cs_jail_jackal_ini_c
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jail_jackal_patrol/p6 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p7 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p8 1)
			(sleep (random_range 0 15))
		false)
	)
)
(script command_script cs_jail_jackal_ini_d
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jail_jackal_patrol/p9 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p10 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p11 1)
			(sleep (random_range 0 15))
		false)
	)
)
(script command_script cs_jail_jackal_ini_e
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jail_jackal_patrol/p12 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p13 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p14 1)
			(sleep (random_range 0 15))
		false)
	)
)
(script command_script cs_jail_jackal_ini_f
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jail_jackal_patrol/p15 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p16 1)
			(sleep (random_range 0 15))
			(cs_go_to jail_jackal_patrol/p17 1)
			(sleep (random_range 0 15))
		false)
	)
)

(script command_script cs_cell_a_jackal_a
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jails/jail_a_p0 1)
			(sleep (random_range 5 45))
			(cs_go_to jails/jail_a_p1 1)
			(sleep (random_range 5 45))
		false)
	)
)
(script command_script cs_cell_a_jackal_b
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jails/jail_a_p2 1)
			(sleep (random_range 5 45))
			(cs_go_to jails/jail_a_p3 1)
			(sleep (random_range 5 45))
		false)
	)
)
(script command_script cs_cell_a_brute
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jails/jail_a_p4 1)
			(sleep (random_range 5 10))
			(cs_go_to jails/jail_a_p5 1)
			(sleep (random_range 5 10))
		false)
	)
)
(script command_script cs_cell_b_brute
	(cs_abort_on_combat_status ai_combat_status_active)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to jails/jail_b_p0 1)
			(sleep (random_range 5 10))
			(cs_go_to jails/jail_b_p1 1)
			(sleep (random_range 5 10))
		false)
	)
)

(script command_script cs_jail_a_marine_a
	(cs_enable_pathfinding_failsafe true)
	(cs_force_combat_status 4)
	(cs_go_to jails/jail_a_plasma_rifle)
	(sleep 5)
	(cs_custom_animation objects\characters\marine\marine "combat:rifle:idle:2:crouch:idle" 0 1)
	(sleep 15)
	(unit_add_equipment (ai_get_unit ai_current_actor) jail_a_a 1 1)
	(object_destroy jail_a_plasma_rifle)
	(sleep 15)
	(cs_stop_custom_animation)
)

(script command_script cs_jail_a_marine_b
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to jails/jail_a_needler)
	(sleep 5)
	(cs_custom_animation objects\characters\marine\marine "combat:rifle:idle:2:crouch:idle" 0 1)
	(sleep 15)
	(unit_add_equipment (ai_get_unit ai_current_actor) jail_a_b 1 1)
	(object_destroy jail_a_needler)
	(sleep 15)
	(cs_stop_custom_animation)
)

(script command_script cs_jail_b_marine_a
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to jails/jail_b_carbine)
	(sleep 5)
	(cs_custom_animation objects\characters\marine\marine "combat:rifle:idle:2:crouch:idle" 0 1)
	(sleep 15)
	(unit_add_equipment (ai_get_unit ai_current_actor) jail_b_a 1 1)
	(object_destroy jail_b_carbine)
	(sleep 15)
	(cs_stop_custom_animation)
)

(script command_script cs_jail_b_marine_b
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to jails/jail_b_plasma_rifle)
	(sleep 5)
	(cs_custom_animation objects\characters\marine\marine "combat:rifle:idle:2:crouch:idle" 0 1)
	(sleep 15)
	(unit_add_equipment (ai_get_unit ai_current_actor) jail_b_b 1 1)
	(object_destroy jail_b_plasma_rifle)
	(sleep 15)
	(cs_stop_custom_animation)
)
(script command_script cs_jail_b_marine_c
	(cs_force_combat_status 4)
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to jails/jail_b_plasma_pistol)
	(sleep 5)
	(cs_custom_animation objects\characters\marine\marine "combat:rifle:idle:2:crouch:idle" 0 1)
	(sleep 15)
	(unit_add_equipment (ai_get_unit ai_current_actor) jail_b_c 1 1)
	(object_destroy jail_b_plasma_pistol)
	(sleep 15)
	(cs_stop_custom_animation)
)

(script dormant ai_cell_a_guards
	(if debug (print "cell a guards"))
	
	(ai_place jail_guard_brute_cell_a)
	(ai_place jail_guard_jackal_cell_a)
	(sleep 1)
	(if g_jail_prophets_ini_active (ai_set_orders jail_cell_outer_guards_a jail_guard_alert_cell_a))
)

(script dormant ai_cell_b_guards
	(if debug (print "cell b guards"))
	
	(ai_place jail_guard_brute_cell_b)
	(ai_place jail_guard_jackal_cell_b)
	(sleep 1)
	(if g_jail_prophets_ini_active (ai_set_orders jail_cell_outer_guards_b jail_guard_alert_cell_b))
)

(script command_script cs_lift_grunt_a
	(cs_enable_pathfinding_failsafe true)
;	(sleep_until (volume_test_objects_all tv_jail_top (ai_actors jail_grunts_down)))
	(cs_go_to jail_turret/p0)
	(cs_deploy_turret jail_turret/p0)
)

(script command_script cs_lift_grunt_b
	(cs_enable_pathfinding_failsafe true)
;	(sleep_until (volume_test_objects_all tv_jail_top (ai_actors jail_grunts_down)))
	(cs_go_to jail_turret/p1)
	(cs_deploy_turret jail_turret/p1)
)

(global boolean jail_a_doors_open 0)
(global boolean jail_b_doors_open 0)

(script dormant jail_a_doors
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_jail/p)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 jail_ped_p "effect")

	(sleep_until jail_a_doors_open)
	(ai_disregard (ai_actors jail_a_marines) false)
	(ai_set_orders jail_a_marines jail_marines_mid)
	(set g_jail_a_free 1)
	(sleep 15)
	(cs_run_command_script jail_a_marines/a cs_jail_a_marine_a)
	(cs_run_command_script jail_a_marines/b cs_jail_a_marine_b)
	
	(if (or g_jail_a_finished g_jail_b_finished) (wake sc_second_cell) (wake sc_first_cell))
	
	(sleep_until (not (volume_test_objects_all tv_cell_a (players))))
	(sleep 90)
	(set g_jail_a_finished 1)
)

(script dormant jail_b_doors
	(erase_cortana)
	(sleep 1)
	(ai_place cortana_jail/q)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 jail_ped_q "effect")

	(sleep_until jail_b_doors_open)
	(ai_disregard (ai_actors jail_b_marines) false)
	(ai_set_orders jail_b_marines jail_marines_bot)
	(set g_jail_b_free 1)
	(sleep 15)
	(cs_run_command_script jail_b_marines/a cs_jail_b_marine_a)
	(cs_run_command_script jail_b_marines/b cs_jail_b_marine_b)
	(cs_run_command_script jail_b_marines/c cs_jail_b_marine_c)

	(if (or g_jail_a_finished g_jail_b_finished) (wake sc_second_cell) (wake sc_first_cell))

	(sleep_until (not (volume_test_objects_all tv_cell_b (players))))
	(sleep 60)
	(set g_jail_b_finished 1)
)

(script dormant cor_open_a
	(sleep_until (<= (ai_living_count cell_a_prophets) 0))
	(sleep 60)
		(begin_random
			(begin
				(device_group_set jail_a_door_b jail_a_group_a 1)
				(sleep (random_range 5 15))
			)
			(begin
				(device_group_set jail_a_door_a jail_a_group_b 1)
				(sleep (random_range 5 15))
			)
			(begin
				(device_group_set jail_a_door_c jail_a_group_c 1)
				(sleep (random_range 5 15))
			)
		)
;	(sleep 5)
	(set jail_a_doors_open 1)
)

(script dormant cor_open_b
	(sleep_until (<= (ai_living_count cell_b_prophets) 0))
	(sleep 60)
		(begin_random
			(begin
				(device_group_set jail_b_door_c jail_b_group_a 1)
				(sleep (random_range 5 15))
			)
			(begin
				(device_group_set jail_b_door_b jail_b_group_b 1)
				(sleep (random_range 5 15))
			)
			(begin
				(device_group_set jail_b_door_a jail_b_group_c 1)
				(sleep (random_range 5 15))
			)
		)
;	(sleep 5)
	(set jail_b_doors_open 1)
)

(script dormant ai_jail_a
	(data_mine_set_mission_segment enc_jail_cell_a)
	(game_save)
	(sleep 60)

	(wake sc_cell_a_ent)
	(wake ai_cell_a_guards)
	(sleep 15)

	(sleep_until (volume_test_objects tv_jail_a_ent (players)) 1)
;*	(if (> (ai_living_count jail_b_marines) 0)	(begin
											(ai_set_orders jail_b_marines marines_b_guard_a)
											(print "MARINES: we'll wait for you here chief")
										)
	)
*;
	(ai_place jail_a_marines)
	(ai_place jail_a_brute)
	(ai_place jail_a_jackals)
	(sleep 30)
	(wake cor_open_a)
	(wake jail_a_doors)
	
	(sleep_until g_jail_a_finished)
	(game_save)
)

(script dormant ai_jail_b
	(data_mine_set_mission_segment enc_jail_cell_b)
	(game_save)
	(sleep 60)

	(wake sc_cell_b_ent)
	(wake ai_cell_b_guards)
	(sleep 15)

	(sleep_until (volume_test_objects tv_jail_b_ent (players)) 1)
;*	(if (> (ai_living_count jail_a_marines) 0)	(begin
											(ai_set_orders jail_a_marines marines_a_guard_b)
											(print "MARINES: we'll cover your back chief")
										)
	)
*;
	(ai_place jail_b_marines)
	(ai_place jail_b_brutes)
	(ai_place jail_b_grunts)
	(sleep 30)
	(wake cor_open_b)
	(wake jail_b_doors)

	(sleep_until g_jail_b_finished)
	(game_save)
)

(global boolean g_jail_door 1)
(global short g_jail_door_limit 0)
(global short g_jail_door_count 0)

(script static void ai_jail_door_c
	(if debug (print "door c"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_c)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_c)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_c)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_d
	(if debug (print "door d"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_d)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_d)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_d)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_e
	(if debug (print "door e"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_e)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_e)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_e)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_f
	(if debug (print "door f"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_f)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_f)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_f)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_g
	(if debug (print "door g"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_g)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_g)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_g)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_i
	(if debug (print "door i"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_i)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_i)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_i)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_j
	(if debug (print "door j"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_j)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_j)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_j)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_k
	(if debug (print "door k"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_k)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_k)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_k)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_l
	(if debug (print "door l"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_l)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_l)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_l)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)
(script static void ai_jail_door_m
	(if debug (print "door m"))
	(begin_random
		(if g_jail_door
			(begin
				(ai_place jail_brute_m)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_grunt_m)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
		(if g_jail_door
			(begin
				(ai_place jail_jackal_m)
				(set g_jail_door_count (+ g_jail_door_count 1))
				(if (= g_jail_door_count g_jail_door_limit) (set g_jail_door 0))
			)
		)
	)
	
	(set g_jail_door 1)
	(set g_jail_door_count 0)
)

(global boolean g_jail_spawner 1)
(global short g_jail_spawn_limit 0)
(global short g_jail_spawn_count 0)

(script static void ai_jail_spawner
	(if debug (print "jail spawner!!!!"))
	(game_save_no_timeout) ; 9/18 

	(cond
		((difficulty_normal) (begin (set g_jail_spawn_limit 1) (set g_jail_door_limit 1)))
		((difficulty_heroic) (begin (set g_jail_spawn_limit 1) (set g_jail_door_limit 2)))
		((difficulty_legendary) (begin (set g_jail_spawn_limit 2) (set g_jail_door_limit 2)))
	)

	(begin_random
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_c) 0) (not (volume_test_objects tv_jail_door_c (players))))
				(begin
					(ai_jail_door_c)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_d) 0) (not (volume_test_objects tv_jail_door_d (players))))
				(begin
					(ai_jail_door_d)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_e) 0) (not (volume_test_objects tv_jail_door_e (players))))
				(begin
					(ai_jail_door_e)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_f) 0) (not (volume_test_objects tv_jail_door_f (players))))
				(begin
					(ai_jail_door_f)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_g) 0) (not (volume_test_objects tv_jail_door_g (players))))
				(begin
					(ai_jail_door_g)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_i) 0) (not (volume_test_objects tv_jail_door_i (players))))
				(begin
					(ai_jail_door_i)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_j) 0) (not (volume_test_objects tv_jail_door_j (players))))
				(begin
					(ai_jail_door_j)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_k) 0) (not (volume_test_objects tv_jail_door_k (players))))
				(begin
					(ai_jail_door_k)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_l) 0) (not (volume_test_objects tv_jail_door_l (players))))
				(begin
					(ai_jail_door_l)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
		(if g_jail_spawner
			(if	(and (<= (device_get_position jail_door_m) 0) (not (volume_test_objects tv_jail_door_m (players))))
				(begin
					(ai_jail_door_c)
					(set g_jail_spawn_count (+ g_jail_spawn_count 1))
					(if (= g_jail_spawn_count g_jail_spawn_limit) (set g_jail_spawner 0))
		)))
	)
	(set g_jail_spawner 1)
	(set g_jail_spawn_count 0)
)

(global boolean g_jail_round_lift_spawned 0)

(script dormant ai_jail_down_lift
	(sleep_until (and (volume_test_objects tv_jail_top (players)) (<= (ai_living_count jail_prophets) 2)) 30 (* 30 30))
	(data_mine_set_mission_segment enc_jail_down_lift)
	(sleep 60)
	
	(wake sc_lift_reins)
	
	(begin_random
		(begin
			(ai_place jail_jackals_down)
			(sleep_until (volume_test_objects_all tv_jail_top (ai_actors jail_jackals_down)) 30 450)
		)
		(begin
			(ai_place jail_grunts_down)
			(sleep_until (volume_test_objects_all tv_jail_top (ai_actors jail_grunts_down)) 30 450)
		)
	)
	(ai_place jail_brutes_down)
	(sleep_until (volume_test_objects_all tv_jail_top (ai_actors jail_brutes_down))30 450)
	(sleep 90)
	(set g_jail_round_lift_spawned 1)
	
	(wake sc_jail_clear)
)

(script dormant ai_prophets_ini_active
	(sleep_until (>= (ai_combat_status jail_prophets) ai_combat_status_active))
	(if debug (print "jail prophets active"))
	(set g_jail_prophets_ini_active 1)
	(ai_set_orders jail_grunts_ini jail_cov_top)
	(ai_set_orders jail_jackals_ini jail_cov_top)

	(sleep_until (<= (ai_living_count jail_prophets) 2))
	(ai_jail_spawner)
)

;========== CORRIDOR B SCRIPTS ==============================================================================

(script command_script cs_room_b_brute_ini_a
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to room_b/p0 1)
			(sleep (random_range 0 15))
			(cs_go_to room_b/p1 1)
			(sleep (random_range 0 15))
		false)
	)
)
(script command_script cs_room_b_brute_ini_b
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to room_b/p2 1)
			(sleep (random_range 0 15))
			(cs_go_to room_b/p3 1)
			(sleep (random_range 0 15))
		false)
	)
)
(script command_script cs_room_b_brute_ini_c
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to room_b/p4 1)
			(sleep (random_range 0 15))
			(cs_go_to room_b/p5 1)
			(sleep (random_range 0 15))
		false)
	)
)

(script dormant ai_room_b_buggers
	(ai_place room_b_buggers)
	
	(sleep_until (<= (ai_living_count room_b_buggers) 2))
	(if	(and (volume_test_objects_all tv_room_b (players)) (= (device_get_position room_b_exit) 0)) (ai_place room_b_buggers))
)

(script dormant ai_corridor_b
	(if (<= (+ (ai_living_count corridor_b_prophets) (ai_living_count corridor_b_covenant)) 8) (ai_place hall_c_elites))
;	(sleep 90)
	(ai_place hall_c_buggers)
	(sleep 1)
	
	(sleep_until (<= (ai_living_count corridor_b_prophets) 2))
	(ai_place hall_c_brute_reins)
)

;========== EXTERIOR A SCRIPTS ==============================================================================
;(script command_script cs_elites_up_tower
;	(cs_go_to ext_a/p0)
;	(cs_jump_to_point 1 1)
;)

(script dormant ai_ext_a_elite_ini
	(ai_place ext_a_elite_ini)

	(sleep_until (<= (ai_living_count ext_a_brute_ini) 0))
	(ai_migrate ext_a_elite_ini ext_a_watch_elites)
)

(script dormant ai_ext_a_brute_ini
	(ai_place ext_a_brute_ini)

	(sleep_until (<= (ai_living_count ext_a_elite_ini) 0))
	(ai_migrate ext_a_brute_ini ext_a_watch_brutes)
)

(script dormant ai_ext_a_hunters
	(ai_place ext_a_hunters)
	(sleep 150)
	
	(sleep_until	(or
					(<= (ai_living_count ext_a_prophets) 4)
					(volume_test_objects tv_ext_a_mid (players))
				)
	)
	(if (<= (+ (ai_living_count ext_a_prophets) (ai_living_count ext_a_covenant)) 6) (ai_place ext_a_brute_door))
)

(script dormant ai_ext_a_prophet_migrate
	(sleep_until
		(begin
			(if (<= (ai_living_count ext_a_covenant) 0)
				(begin
					(ai_set_orders ext_a_watch_brutes ext_a_prophets_follow)
					(ai_set_orders ext_a_brute_door ext_a_prophets_follow)
					(ai_set_orders ext_a_brute_ini ext_a_prophets_follow)
					(ai_set_orders ext_a_buggers ext_a_prophets_follow)
				)
			)
			(if (<= (ai_living_count ext_a_prophets) 0) (ai_set_orders ext_a_covenant ext_a_covenant_follow))
		false)
	90)
)

(global boolean g_ext_a_snipers 1)
(global short g_ext_a_snipers_count 0)
(global short g_ext_a_snipers_index 4)

(script dormant ai_ext_a_snipers
	(if g_ext_a_snipers
		(begin
			(ai_place ext_a_jackal_snipers_a)
			(set g_ext_a_snipers_count (+ g_ext_a_snipers_count 1))
			(if (= g_ext_a_snipers_count g_ext_a_snipers_index) (set g_ext_a_snipers 0))
		)
	)
	(if g_ext_a_snipers
		(begin
			(ai_place ext_a_jackal_snipers_b)
			(set g_ext_a_snipers_count (+ g_ext_a_snipers_count 1))
			(if (= g_ext_a_snipers_count g_ext_a_snipers_index) (set g_ext_a_snipers 0))
		)
	)
	(if g_ext_a_snipers
		(begin
			(ai_place ext_a_jackal_snipers_c)
			(set g_ext_a_snipers_count (+ g_ext_a_snipers_count 1))
			(if (= g_ext_a_snipers_count g_ext_a_snipers_index) (set g_ext_a_snipers 0))
		)
	)
	(if g_ext_a_snipers
		(begin
			(ai_place ext_a_jackal_snipers_d)
			(set g_ext_a_snipers_count (+ g_ext_a_snipers_count 1))
			(if (= g_ext_a_snipers_count g_ext_a_snipers_index) (set g_ext_a_snipers 0))
		)
	)
)

(global boolean g_ext_a_fliers 0)

(script dormant ai_ext_a_fliers
	(sleep_until (<= (+ (ai_living_count ext_a_prophets) (ai_living_count ext_a_covenant)) 3))
	
	(if (not g_ext_a_fliers)
		(begin
			(ai_place ext_a_rangers)
			(ai_place ext_a_buggers)
		)
	)
)

(script dormant tram_a_no_save
	(sleep_until
		(begin
			(if (volume_test_objects tv_tram_a_no_save (players)) (game_save_cancel))
		false)
	1)
)
(script dormant tram_b_no_save
	(sleep_until
		(begin
			(if (volume_test_objects tv_tram_b_no_save (players)) (game_save_cancel))
		false)
	1)
)
(script dormant tram_c_no_save
	(sleep_until
		(begin
			(if (volume_test_objects tv_tram_c_no_save (players)) (game_save_cancel))
		false)
	1)
)
(script dormant tram_d_no_save
	(sleep_until
		(begin
			(if (volume_test_objects tv_tram_d_no_save (players)) (game_save_cancel))
		false)
	1)
)

;========== GARDEN A SCRIPTS ==============================================================================
(script dormant ai_garden_a_ini
	(ai_place garden_a_elites)
	(ai_place garden_a_grunts)
	(ai_place garden_a_brute_lt)
	(ai_place garden_a_brute_rt)
	(ai_place garden_a_jackal_snipers)
)

(script dormant ai_garden_a_rangers
	(sleep_until (<= (+ (ai_living_count garden_a_prophet) (ai_living_count garden_a_covenant)) 5))
	(ai_place garden_a_rangers)
)

(script command_script cs_garden_a_turret_bk_a
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to garden_a_turrets/p0)
	(cs_deploy_turret garden_a_turrets/p0)
)
(script command_script cs_garden_a_turret_bk_b
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to garden_a_turrets/p1)
	(cs_deploy_turret garden_a_turrets/p1)
)

(script dormant garden_a_tram_b_on
	(sleep_until (volume_test_objects tv_garden_a_tram_b (players)) 5)
	(object_destroy garden_tram_b_bk)
	(sleep 30)
	(object_create garden_tram_b)
)
;========== MID-TOWER SCRIPTS ==============================================================================
(global boolean g_midtower_prophet_rein 0)

(script command_script cs_midtower_buggers_hall
	(cs_abort_on_damage false)
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to midtower/p0)
	(cs_fly_to midtower/p1)
	(cs_fly_to midtower/p2)
	(cs_fly_to midtower/p3)
	(cs_fly_to midtower/p4)
	(cs_fly_to midtower/p5)
	(cs_fly_to midtower/p6)
)

(script dormant ai_midtower_buggers_rein
	(sleep_until	(or
					(volume_test_objects tv_midtower_mid (players))
					(<= (ai_living_count midtower_prophets) 3)
				)
	)
	(if (<= (+ (ai_living_count midtower_prophets) (ai_living_count midtower_covenant)) 4) (ai_place midtower_bugger_rein))
	(if debug (print "bugger reinforcements"))
)

(script dormant ai_midtower_cov_rein
	(sleep_until	(or
					(volume_test_objects tv_midtower_mid (players))
					(<= (ai_living_count midtower_covenant) 1)
					g_midtower_prophet_rein
				)
	)
		(if (<= (+ (ai_living_count midtower_prophets) (ai_living_count midtower_covenant)) 4)
			(begin
				(ai_place midtower_elite_reins)
				(if debug (print "covenant reinforcements"))
				(sleep 5)
				(device_set_position midtower_exit 1)
			)
		)
)


(script dormant ai_midtower_prophets
	(sleep_until	(or
					(volume_test_objects tv_midtower_bk (players))
					(<= (ai_living_count midtower_prophets) 2)
				)
	)
	
	(if	(volume_test_objects tv_midtower_bk (players))
			(begin
				(ai_place midtower_brutes)
				(if (<= (ai_living_count midtower_prophets) 3) (ai_place midtower_jackals))
				(set g_midtower_prophet_rein 1)
				(if debug (print "exit prophets"))
			)
	)
	(sleep 1)
	(if	(not g_midtower_prophet_rein)
			(begin
				(sleep_until (volume_test_objects tv_midtower_bk (players)) 10 (* 30 15))
				(ai_place midtower_brutes)
				(if (<= (ai_living_count midtower_prophets) 3) (ai_place midtower_jackals))
				(set g_midtower_prophet_rein 1)
				(if debug (print "exit prophets"))
			)
	)

)

;========== GARDEN B SCRIPTS ==============================================================================
(script command_script cs_garden_b_grunts
	(cs_movement_mode 3)
	
	(sleep_until
		(begin
			(begin_random
				(cs_go_to garden_b/p0)
				(cs_go_to garden_b/p1)
				(cs_go_to garden_b/p2)
				(cs_go_to garden_b/p3)
				(cs_go_to garden_b/p4)
				(cs_go_to garden_b/p5)
				(cs_go_to garden_b/p6)
				(cs_go_to garden_b/p7)
				(cs_go_to garden_b/p8)
				(cs_go_to garden_b/p9)
				(cs_go_to garden_b/p10)
				(cs_go_to garden_b/p11)
				(cs_go_to garden_b/p12)
				(cs_go_to garden_b/p13)
				(cs_go_to garden_b/p14)
			)
		false)
	)
)

(script command_script garden_b_brute_berserk
	(ai_berserk garden_b_brute_ini 1)
	(ai_magically_see garden_b_prophet garden_b_covenant)
)

;========== TOWER EXTERIOR B SCRIPTS ==============================================================================
(global boolean g_ext_b_dump 0)

(script dormant ai_ext_b_dump
	(sleep_until g_ext_b_dump 30 (* 30 25))
	
	(sleep_until	(or
					(volume_test_objects tv_ext_b_low (players))
					(<= (ai_living_count ext_b_covenant) 0)
					(<= (ai_living_count ext_b_prophets) 0)
				)
	)
	(sleep 60)
	(if debug (print "--- migrating enemies --- migrating enemies ---"))
	(ai_migrate ext_b_covenant ext_b_cov_dump)
	(ai_migrate ext_b_prophets ext_b_prophet_dump)
)

(script dormant ai_ext_b_reins
	(sleep_until
		(or
			(volume_test_objects tv_ext_b_low (players))
			(<= (ai_living_count all_enemies) 4)
		)
	)
	(if debug (print "far door covenant"))
	(ai_place ext_b_grunt_bk_door)
	(ai_place ext_b_elites_bk_door (pin (- 8 (ai_living_count all_enemies)) 1 3))
	(sleep 1)
	
	(sleep_until
		(or
			(volume_test_objects tv_ext_b_low (players))
			(<= (ai_living_count all_enemies) 4)
		)
	)
	(if debug (print "lower door brutes"))
	(ai_place ext_b_brutes_low_door (pin (- 8 (ai_living_count all_enemies)) 1 4))
)

(script command_script cs_ext_b_grunts_low
	(cs_movement_mode 3)
	(cs_abort_on_damage true)
	
	(sleep_until
		(begin
			(begin_random
				(cs_go_to ext_b/p0)
				(cs_go_to ext_b/p1)
				(cs_go_to ext_b/p2)
				(cs_go_to ext_b/p3)
				(cs_go_to ext_b/p4)
				(cs_go_to ext_b/p5)
				(cs_go_to ext_b/p6)
				(cs_go_to ext_b/p7)
				(cs_go_to ext_b/p8)
			)
		false)
	)
)


;========== MAUSOLEUM HALL SCRIPTS ==============================================================================
(script command_script cs_maus_hall_grunts
	(cs_movement_mode 3)
	(cs_abort_on_damage true)
	(cs_enable_pathfinding_failsafe true)
	
	(sleep_until
		(begin
			(begin_random
				(cs_go_to maus_hall/p0 2)
;				(cs_go_to maus_hall/p1 2)
				(cs_go_to maus_hall/p2 2)
;				(cs_go_to maus_hall/p3 2)
				(cs_go_to maus_hall/p4 2)
				(cs_go_to maus_hall/p5 2)
				(cs_go_to maus_hall/p6 2)
				(cs_go_to maus_hall/p7 2)
				(cs_go_to maus_hall/p8 2)
				(cs_go_to maus_hall/p9 2)
;				(cs_go_to maus_hall/p10 2)
;				(cs_go_to maus_hall/p11 2)

			)
		false)
	)
)


;========== MAUSOLEUM ROOM SCRIPTS ==============================================================================
(script dormant maus_door
	(sleep_until
		(begin
			(cond
				((= (structure_bsp_index) 4) (device_operates_automatically_set maus_bsp_4_door false))
				((= (structure_bsp_index) 5) (device_operates_automatically_set maus_bsp_4_door true))
			)
		false)
	5)
)

(script command_script cs_maus_room_elite_lt
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to maus_room/p0 1)
			(sleep (random_range 0 15))
			(cs_go_to maus_room/p1 1)
			(sleep (random_range 0 15))
			(cs_go_to maus_room/p2 1)
			(sleep (random_range 0 15))
			(cs_go_to maus_room/p3 1)
			(sleep (random_range 0 15))
		false)
	)
)

(script command_script cs_maus_room_elite_rt
	(cs_abort_on_alert true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until
		(begin
			(cs_go_to maus_room/p4 1)
			(sleep (random_range 0 15))
			(cs_go_to maus_room/p5 1)
			(sleep (random_range 0 15))
			(cs_go_to maus_room/p6 1)
			(sleep (random_range 0 15))
			(cs_go_to maus_room/p7 1)
			(sleep (random_range 0 15))
		false)
	)
)


(script dormant ai_maus_room_ini
	(ai_place maus_room_elite_lt)
	(ai_place maus_room_elite_rt)
	(if	(<= (ai_living_count all_enemies) 6)
			(begin
				(ai_place maus_room_grunt_lt (pin (- 6 (ai_living_count all_enemies)) 0 2))
				(ai_place maus_room_grunt_rt (pin (- 6 (ai_living_count all_enemies)) 0 2))
			)
	)

	(sleep_until	(or
					(volume_test_objects tv_maus_room_bk (players))
					(<= (ai_living_count maus_room_covenant) 2)
				)
	)

	(ai_place maus_room_lt_elite_reins (pin (- 8 (ai_living_count all_enemies)) 0 1))
	(ai_place maus_room_rt_elite_reins (pin (- 8 (ai_living_count all_enemies)) 0 1))
	(sleep 1)
	(ai_place maus_room_lt_grunt_reins (pin (- 6 (ai_living_count all_enemies)) 0 2))
	(ai_place maus_room_rt_grunt_reins (pin (- 6 (ai_living_count all_enemies)) 0 2))
)

;========== MAUSOLEUM BRIDGE SCRIPTS ==============================================================================

(global boolean g_maus_bridge_fr 0)

(script dormant ai_maus_bridge_ini
	(if debug (print "initial bridge"))
	(if (< (ai_living_count all_enemies) 4) (ai_place maus_bridge_elite_turret 2) (ai_place maus_bridge_elite_turret 1))
	(ai_place maus_bridge_elites_ini)
	(ai_place maus_bridge_brutes_ini (pin (- 10 (ai_living_count all_enemies)) 0 3))
	(ai_place maus_bridge_jackals_ini)
	
	(sleep_until	(or
					g_maus_bridge_fr
					(ai_trigger_test maus_bridge_elites_ini maus_bridge_elites_ini)
					(<= (ai_living_count maus_bridge_prophets) 1)
				)
	)

	(sleep 1)
	(if debug (print "bugger reinforcements"))
	(ai_place maus_bridge_buggers_ini (pin (- 11 (ai_living_count all_enemies)) 0 5))
)


;========== MAUSOLEUM INNER SCRIPTS ==============================================================================
(global boolean g_maus_inner_order_trans 0)

(script dormant ai_maus_inner_order_transitions
	(sleep_until
		(begin
			(if (<= (ai_living_count maus_inner_prophets) 0) ; brutes and buggers dead 
				(begin	
					(ai_vehicle_exit maus_inner_turrets)
					(ai_vehicle_reserve (ai_vehicle_get_from_starting_location maus_inner_turrets/a) true)
					(ai_vehicle_reserve (ai_vehicle_get_from_starting_location maus_inner_turrets/b) true)
					(sleep 60)
					(ai_set_orders maus_inner_elites_ini maus_inner_follow)
					(ai_set_orders maus_inner_turrets maus_inner_follow)
				)
			)

			(if 	(and
					(<= (ai_living_count maus_inner_elites_ini) 0) ; elites, brutes, buggers dead 
					(<= (ai_living_count maus_inner_prophets) 0)
				)
				(ai_set_orders maus_inner_hunters_ini maus_inner_follow)
			)
			
			(if (<= (ai_living_count maus_inner_covenant) 0) ; elites and hunters dead 
					(ai_set_orders maus_inner_prophets maus_inner_follow)
				)
													
		g_maus_inner_order_trans)
	60)
)

(script dormant ai_maus_inner_brute_reins
	(sleep_until (<= (ai_living_count maus_inner_brutes_ini) 0))
	(sleep 90)
	(ai_place maus_inner_brutes_rein)
	(sleep 1)
	(wake ai_maus_inner_order_transitions)
)

(global boolean g_maus_inner 0)
(global boolean g_maus_inner_wave_pause 1)
(global boolean g_maus_inner_wave_end 0)
(global short g_maus_inner_count 0)
(global short g_maus_inner_limit 0)
(global short g_maus_inner_wave_count 0)
(global short g_maus_inner_wave_limit 0)
				
(script static void ai_maus_inner_brute_a
	(if debug (print "door a"))
	
	(if (and
			(not (volume_test_objects tv_maus_inner_door_a (players)))
			(= (device_get_position maus_inner_door_a) 0))
		(begin
			(ai_place maus_inner_brutes_a)
			(set g_maus_inner_count (+ g_maus_inner_count 1))
			(if (= g_maus_inner_count g_maus_inner_limit) (set g_maus_inner 0))
		)
	)
)
(script static void ai_maus_inner_brute_b
	(if debug (print "door b"))
	
	(if (and
			(not (volume_test_objects tv_maus_inner_door_b (players)))
			(= (device_get_position maus_inner_door_b) 0))
		(begin
			(ai_place maus_inner_brutes_b)
			(set g_maus_inner_count (+ g_maus_inner_count 1))
			(if (= g_maus_inner_count g_maus_inner_limit) (set g_maus_inner 0))
		)
	)
)
(script static void ai_maus_inner_brute_c
	(if debug (print "door c"))
	
	(if (and
			(not (volume_test_objects tv_maus_inner_door_c (players)))
			(= (device_get_position maus_inner_door_c) 0))
		(begin
			(ai_place maus_inner_brutes_c)
			(set g_maus_inner_count (+ g_maus_inner_count 1))
			(if (= g_maus_inner_count g_maus_inner_limit) (set g_maus_inner 0))
		)
	)
)
(script static void ai_maus_inner_brute_d
	(if debug (print "door d"))
	
	(if (and
			(not (volume_test_objects tv_maus_inner_door_d (players)))
			(= (device_get_position maus_inner_door_d) 0))
		(begin
			(ai_place maus_inner_brutes_d)
			(set g_maus_inner_count (+ g_maus_inner_count 1))
			(if (= g_maus_inner_count g_maus_inner_limit) (set g_maus_inner 0))
		)
	)
)
(script static void ai_maus_inner_brute_e
	(if debug (print "door e"))
	
	(if (and
			(not (volume_test_objects tv_maus_inner_door_e (players)))
			(= (device_get_position maus_inner_door_e) 0))
		(begin
			(ai_place maus_inner_brutes_e)
			(set g_maus_inner_count (+ g_maus_inner_count 1))
			(if (= g_maus_inner_count g_maus_inner_limit) (set g_maus_inner 0))
		)
	)
)
(script static void ai_maus_inner_brute_f
	(if debug (print "door f"))
	
	(if (and
			(not (volume_test_objects tv_maus_inner_door_f (players)))
			(= (device_get_position maus_inner_door_f) 0))
		(begin
			(ai_place maus_inner_brutes_f)
			(set g_maus_inner_count (+ g_maus_inner_count 1))
			(if (= g_maus_inner_count g_maus_inner_limit) (set g_maus_inner 0))
		)
	)
)

(script dormant ai_maus_inner_spawn
	(cond
		((difficulty_normal) (begin (set g_maus_inner_wave_limit 1) (set g_maus_inner_limit 1)))
		((difficulty_heroic) (begin (set g_maus_inner_wave_limit 2) (set g_maus_inner_limit 1)))
		((difficulty_legendary) (begin (set g_maus_inner_wave_limit 3) (set g_maus_inner_limit 2)))
	)

	(sleep_until
		(begin
			(set g_maus_inner 1)
			(set g_maus_inner_count 0)
;			(set g_maus_inner_wave_count 0)
			
			(sleep_until (<= (ai_living_count maus_inner_prophets) 1))
			(sleep (random_range sleep_lower_bound sleep_upper_bound))
			
			(begin_random ; spawn brutes 
				(if g_maus_inner (ai_maus_inner_brute_a))
				(if g_maus_inner (ai_maus_inner_brute_b))
				(if g_maus_inner (ai_maus_inner_brute_c))
				(if g_maus_inner (ai_maus_inner_brute_d))
				(if g_maus_inner (ai_maus_inner_brute_e))
				(if g_maus_inner (ai_maus_inner_brute_f))
			)
			
			(sleep (random_range sleep_lower_bound sleep_upper_bound))
			(if (= (random_range 0 2) 0) (ai_place maus_inner_buggers_lt) (ai_place maus_inner_buggers_rt)) ; place buggers 
			(sleep 1)
			(ai_set_orders maus_inner_buggers maus_inner_follow)
			
;			(set g_maus_inner_cor_tele_pause 0)
			(set g_maus_inner_wave_count (+ g_maus_inner_wave_count 1))
			(if (= g_maus_inner_wave_count g_maus_inner_wave_limit) 
				(begin (set g_maus_inner_wave_pause 0) (sleep_until g_maus_inner_wave_pause))
			)
			(if (= g_maus_inner_wave_count (* g_maus_inner_wave_limit 2)) (set g_maus_inner_wave_end 1))
		g_maus_inner_wave_end)
	)
)

(script dormant ai_maus_inner_elites_final
	(sleep_until	(and
					(not (volume_test_objects tv_maus_ent_door_a (players)))
					(<= (device_get_position maus_ent_door_a) 0)
					(not (volume_test_objects tv_maus_ent_door_b (players)))
					(<= (device_get_position maus_ent_door_b) 0)
				)
	)
	(ai_place maus_inner_elites_ultra)
	(sleep 45)
	(sleep_until	(and
					(not (volume_test_objects tv_maus_ent_door_a (players)))
					(<= (device_get_position maus_ent_door_a) 0)
					(not (volume_test_objects tv_maus_ent_door_b (players)))
					(<= (device_get_position maus_ent_door_b) 0)
				)
	)
	(ai_place maus_inner_elites_spec)
	(sleep 45)
	(sleep_until	(and
					(not (volume_test_objects tv_maus_ent_door_a (players)))
					(<= (device_get_position maus_ent_door_a) 0)
					(not (volume_test_objects tv_maus_ent_door_b (players)))
					(<= (device_get_position maus_ent_door_b) 0)
				)
	)
	(ai_place maus_inner_elite_zealot)
)

;===========================================================================================================
;========== ENCOUNTER SCRIPTS ==============================================================================
;===========================================================================================================

(script dormant enc_council_chamber
		(data_mine_set_mission_segment enc_council_ini)
		(if debug (print "initialize council chamber encounters"))
		(game_save)
		
		(object_hide holo_generator false) ; yeah!!!!! 
		(device_set_position_immediate council_ped .75)
		(device_set_position council_ped 1)
		
		(ai_place council_grunt_ini)
		
	;	(sleep_until (not (volume_test_objects_all tv_start (players))) 1 150)
		(ai_place council_brute_ini)
		(wake ai_council_brutes_berserk)
		(sleep 90)
		(wake sc_council_ini)
	
		(sleep 90)
		(device_one_sided_set council_door_left_a 1)
		(device_one_sided_set council_door_left_b 1)
		(device_one_sided_set council_door_left_c 1)
		(device_one_sided_set council_door_right_a 1)
		(device_one_sided_set council_door_right_b 1)
		(device_one_sided_set council_door_right_c 1)
		
		(wake ai_council_orders)
	
	(sleep_until (<= (ai_living_count council_prophets_floor) 0))

		(wake ai_council_floor_spawn)
	
	(sleep_until (and (<= (ai_living_count prophets) 0) g_council_over))
		(sleep 75)
		
		(wake music_07a_01)
		(wake sc_council_exit)
	
	(sleep_until (>= (device_get_position council_exit) .8))
		(ai_place grand_a_grunts)

	(sleep_until (volume_test_objects tv_dervish_grand_hall (players)) 10)
		(data_mine_set_mission_segment enc_grand_a)
		(game_save)
		(ai_place grand_a_brutes)
		(ai_place grand_a_turret)
		(if (difficulty_normal) (ai_place ledge_brutes_ini 1) (ai_place ledge_brutes_ini))
		(if (difficulty_normal) (ai_place ledge_brutes_honor_ini 1) (ai_place ledge_brutes_honor_ini))

	(sleep_until (<= (ai_living_count grand_a_prophets) 2) 30 210)
		(wake music_07a_02)
		(wake sc_grand_a_exit)
)

(script dormant enc_dervish_ledge
		(data_mine_set_mission_segment enc_ledge_ini)
		(if debug (print "initialize dervish ledge encounters"))
		(game_save)
		
		(ai_disposable council_prophets true)
		
		(ai_place ledge_jackal_left)
		(ai_place ledge_jackal_right)
		
		(wake ai_dervish_ledge_orders)
	
	(sleep_until (volume_test_objects tv_dervish_ledge_fr (players)))
		(sleep (random_range 15 45))
	(sleep_until 	(or
					(volume_test_objects tv_dervish_ledge_bk (players))
					(<= (ai_living_count dervish_ledge_prophets) 2)
				)
	10)
		(data_mine_set_mission_segment enc_ledge_lift)
		(game_save)
		(wake ai_ledge_lift)
		(wake sc_ledge_down)

	(sleep_until (volume_test_objects tv_dervish_ledge_lower (players)))
		(game_save)
		(data_mine_set_mission_segment enc_ledge_lower)
		(wake ai_ledge_lower)
		
		(set g_music_07a_02 0)
)

(script dormant enc_corridors_a
		(data_mine_set_mission_segment enc_high_hall_a)
		(if debug (print "initialize corridor a encounters"))
;		(game_save)
		
		(ai_disposable grand_a_prophets true)
		(ai_disposable dervish_ledge_prophets true)
	
		(wake corridor_a_activate)
		(wake ai_hall_a_prophets)
		(wake sc_corridor_a_amb)
	
	(sleep_until (volume_test_objects tv_hall_b (players)) 5)
		(data_mine_set_mission_segment enc_high_hall_b)
;		(game_save) game_save_no_timeout after sc_jail_info is done playing 
		
		(wake sc_jail_info)
		
;		(if (not g_corridor_a_active) (ai_place hall_b_jackals))
		(ai_place hall_b_brutes)
		(ai_place hall_b_grunts)
		(ai_place hall_b_grunts_bk)
	
		(wake sc_room_a_lift)

	(sleep_until (volume_test_objects tv_room_a (players)) 1)
		(data_mine_set_mission_segment enc_room_a)
		(game_save)
		
		(device_operates_automatically_set room_a_door 1)
		(wake ai_room_a)
		(wake room_a_door)
	
	(sleep_until (volume_test_objects tv_room_a_bot (players)) 10)
		(wake sc_room_a_down)
	
		(sleep_until (volume_test_objects tv_room_a_tube (players)))
		(cs_run_command_script room_a_prophets cs_room_a_to_jail)
		(ai_migrate room_a_prophets jail_trash)
		(erase_cortana)
)

(script dormant enc_jails
		(data_mine_set_mission_segment enc_jail_ini)
		(if debug (print "initialize jails encounters"))
;		(game_save_immediate)
		
		(ai_disposable hall_a_prophets true)
		(ai_disposable hall_b_prophets true)
	
			(device_set_power room_a_lift 0)
			(device_set_position room_a_lift_effect 1)
			(device_set_position jail_down 1)
		
		(ai_erase room_a_tube_fodder)
		(ai_place jail_brutes_ini)
		(ai_place jail_grunts_ini)
		(ai_place jail_jackals_ini)
		(wake music_07a_03)
		(wake ai_prophets_ini_active)
		(wake sc_jail_down)
		
	(sleep_until	(and
					(<= (ai_living_count jail_brutes_ini) 0)
					(<= (ai_living_count jail_jackals_ini) 0)
				)
	)
		(game_save)
	
		(if g_jail_prophets_ini_active (sleep_until (<= (ai_living_count jail_prophets) 0)) (sleep_forever ai_prophets_ini_active))
		
		(if (= (random_range 0 2) 0) (wake ai_jail_a) (wake ai_jail_b))

	(sleep_until (or g_jail_a_finished g_jail_b_finished))
		(ai_jail_spawner)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(if g_jail_a_finished (wake ai_jail_b) (wake ai_jail_a))
		
	(sleep_until (and g_jail_a_finished g_jail_b_finished))
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(wake sc_jail_exit)

		(ai_jail_spawner)
		(sleep 1)
		(wake ai_jail_down_lift)
	
	(sleep_until g_jail_round_lift_spawned)
		(sleep 30)

	(sleep_until	(and
					(not (volume_test_objects_all tv_jail_top (players)))
					(not (volume_test_objects_all tv_jail_mid (players)))
					(not (volume_test_objects_all tv_jail_bot (players)))
				)
	)
		(erase_cortana)
		
		(set g_music_07a_03 0)
	
)

(script dormant enc_corridors_b
		(data_mine_set_mission_segment enc_corridors_b)
		(if debug (print "initialize corridor b encounters"))
		(game_save)
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(set g_jail_exit_reminder 1)
		(if	(and (not g_jail_a_finished) (not g_jail_b_finished))
				(begin
					(object_destroy jail_down)
					(object_create jail_up)
					(object_create room_b_lift)
					(device_set_position room_b_lift_effect 1)
					(sleep 1)
					(ai_place room_b_marines)
				)
		)
		
		(ai_disposable jail_prophets true)
;		(ai_disposable jail_marines true)
		
	 	(wake sc_room_b)
		(wake grand_b_door)
		(wake objective_truth_set)
;		(ai_place room_b_brutes_ini)
		
		(ai_set_orders marines marines_corr_b)
	
;*	(sleep_until	(or
					g_sc_room_b_done
					(and
						(not (volume_test_object tv_room_a_tube (player0)))
						(not (volume_test_object tv_room_a_tube (player1)))
					)
				)
	1)
*;
		(sleep_until (volume_test_objects tv_room_b_start (players)) 5)

		(pvs_clear)
		
		(ai_place room_b_elites)
		(wake ai_room_b_buggers)
	
	(sleep_until (volume_test_objects tv_hall_c (players)))
		(game_save)
		
		(cs_run_command_script marines cs_abort)
		(wake ai_corridor_b)
		(wake marine_migration)
		
	(sleep_until (volume_test_objects tv_hall_c_bk (players)) 1)
		(ai_disposable room_b_prophets true)
		(ai_disposable room_b_covenant true)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(if (<= (ai_living_count corridor_b_prophets) 4) (ai_place hall_c_bugger_reins))
	
	(sleep_until (volume_test_objects tv_hall_d (players)))
;		(game_save)
		(wake sc_corridor_b_exit)
	
		(ai_place hall_d_elites)
		(ai_place hall_d_brutes)
		(if (<= (+ (ai_living_count corridor_b_prophets) (ai_living_count corridor_b_covenant)) 8) (ai_place hall_d_jackals_bk))
	
		(sleep 1)
		(if (<= (+ (ai_living_count corridor_b_prophets) (ai_living_count corridor_b_covenant)) 8) (ai_place hall_d_jackals_fr))

	(sleep_until (volume_test_objects tv_grand_b (players)))
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(game_save)
		
		(wake music_07a_04)
		(ai_place grand_b_hunter_a)
		(ai_place grand_b_hunter_b)
		
		(ai_disposable corridor_b_prophets true)
		(ai_disposable corridor_b_covenant true)

		(objects_predict (ai_actors ext_a_prophets))
		(objects_predict (ai_actors ext_a_covenant))
		
		(wake sc_network)
)

(script dormant enc_tower_a_ext
		(data_mine_set_mission_segment enc_tower_a_exterior)
		(if debug (print "initialize tower a exterior encounters"))
		(game_save)
	
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(if (difficulty_legendary) (wake ice_cream_angry))
		
		(ai_disposable corridor_b_prophets true)
		(ai_disposable corridor_b_covenant true)
		
		(wake ai_ext_a_snipers)
		
		(ai_place ext_a_watch_brutes)
		(ai_place ext_a_watch_elites)
		
		(wake ai_ext_a_hunters)
		(wake ai_ext_a_elite_ini)
		(wake ai_ext_a_brute_ini)
		(wake ai_ext_a_prophet_migrate)
	
	(sleep_until	(or
					(volume_test_objects tv_ext_a_mid (players))
					(<= (+ (ai_living_count ext_a_prophets) (ai_living_count ext_a_covenant)) 6)
				)
	10)
		(ai_disposable grand_b_hunters true)
	
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
	
		(wake ai_ext_a_fliers)
	
	(sleep_until (volume_test_objects tv_ext_a_exit (players)))
		(set g_ext_a_fliers 1)
		(ai_place ext_a_brute_bk_door)
	
	(sleep_until (volume_test_objects tv_tower_a_ramp (players)) 10)
		(set g_music_07a_04_alt 1)
		
		(wake sc_truth_a)
	
;		(ai_place ext_a_buggers_bk)
;		(ai_place ext_a_brutes_bk)
	
	(sleep_until	(or
					(volume_test_objects tv_garden_a_tram (players))
					(and
						(<= (ai_living_count ext_a_brutes_bk) 0)
						(<= (ai_living_count ext_a_buggers_bk) 0)
					)
				)
	10)
		
		(sleep 30)
		(wake sc_in_amber_clad)
		(wake tram_a_no_save)
		(sleep 60)
		(if (not (volume_test_objects tv_tram_a_no_save (players))) (game_save))
		(wake music_07a_05)
	
	(sleep_until g_sc_ioc_finished)
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
;		(wake ai_garden_a_ini)
)

(script dormant enc_gardens_a
		(data_mine_set_mission_segment enc_gardens_a)
		(if debug (print "initialize hanging gardens a encounters"))
		(game_save)
	
		(erase_cortana)
		
		(ai_disposable ext_a_prophets true)
		(ai_disposable ext_a_covenant true)
		
		(set g_marine_mig_garden_a 1)
		(set g_ioc_reminder 1)

		(wake ai_garden_a_ini)

	(sleep_until
		(or
			(volume_test_objects tv_garden_a_fr_suck (players))
			(volume_test_objects tv_garden_a_fr (players))
		)
	5)
		(if debug (print "garden a fr"))
		(ai_place garden_a_brute_a)
		(ai_place garden_a_brute_b)
		(ai_place garden_a_brute_c)
		(ai_place garden_a_elite_a)
		(ai_place garden_a_elite_b)
		(ai_place garden_a_elite_c)

	(sleep_until (volume_test_objects tv_garden_a_mid (players)))
		(if debug (print "garden a mid"))
		(game_save)
		(set g_music_07a_05 0)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(wake ai_garden_a_rangers)

	(sleep_until (volume_test_objects tv_garden_a_bk (players)))
		(if debug (print "garden a bk"))
		(game_save)
		
		(wake garden_a_tram_b_on)
		
;		(ai_place garden_a_rangers)
		(ai_place garden_a_elites_bk)
		(ai_place garden_a_grunts_bk (pin (- 8 (ai_living_count all_enemies)) 0 2))
		(sleep 1)
		(ai_place garden_a_brutes_bk)
		(ai_place garden_a_jackals_bk (pin (- 8 (ai_living_count all_enemies)) 0 2))
		
)

(script dormant ai_midtower_ini
	(sleep_until (> (device_get_position midtower_ent_door) 0) 10)
		(ai_place midtower_buggers_hall)
)

(script dormant enc_mid_tower
		(data_mine_set_mission_segment enc_mid_tower)
		(if debug (print "initialize midspan tower encounters"))
		(game_save)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))

		(ai_disposable garden_a_prophet true)
		(ai_disposable garden_a_covenant true)
		
		(set g_marine_mig_midtower 1)
		
		(wake sc_drive_elites)
		(wake ai_midtower_ini)
	
	(sleep_until (volume_test_objects tv_mid_tower_room (players)))
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(game_save)
		(ai_place midtower_elites)
		(ai_place midtower_buggers_ini)
	
		(wake ai_midtower_buggers_rein)
		(wake ai_midtower_cov_rein)
		(wake ai_midtower_prophets)
		(wake music_07a_06)
)

(script dormant enc_gardens_b
		(data_mine_set_mission_segment enc_gardens_b)
		(if debug (print "initialize hanging gardens b encounters"))
		(game_save)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))

		(set g_music_07a_06 1)
		
		(ai_disposable midtower_prophets true)
		(ai_disposable midtower_covenant true)
		
		(wake sc_gardens_b)

	(sleep_until (volume_test_objects tv_garden_b_fr (players)))
		(if debug (print "garden b fr"))
		(game_save)
		
		(ai_place garden_b_grunt_a)
		(ai_place garden_b_grunt_b)
		(ai_place garden_b_grunt_c)
		(ai_place garden_b_brute_ini)

	(sleep_until (volume_test_objects tv_garden_b_mid (players)))
		(if debug (print "garden b mid"))
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(game_save)

	(sleep_until (volume_test_objects tv_garden_b_bk (players)))
		(if debug (print "garden b bk"))
		(game_save)
		
		(wake tram_d_no_save)
	
)

(script dormant enc_tower_b_ext
		(data_mine_set_mission_segment enc_tower_b_exterior)
		(if debug (print "initialize tower b exterior encounters"))
		(game_save)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))

		(ai_disposable garden_b_prophet true)
		(ai_disposable garden_b_covenant true)
		
		(set g_marine_mig_ext_b 1)
		
		(wake objective_truth_clear)
		(wake objective_phantom_set)
		(ai_place ext_b_brute_ramp)

	(sleep_until (volume_test_objects tv_ext_b (players)) 5)
		(if debug (print "initial enemies"))
		(game_save)
	
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(ai_place ext_b_elite_a)
		(ai_place ext_b_brute_a)
		(ai_place ext_b_grunts_b)
		(ai_place ext_b_brutes_b)
		(ai_place ext_b_grunts_low)
		(ai_place ext_b_brutes_low)
		(ai_place ext_b_jackal_a)
		(sleep 1)
		(wake ai_ext_b_reins)
		(wake ai_ext_b_dump)
	
	(sleep_until (volume_test_objects tv_ext_b_lt (players)))
		(set g_ext_b_dump 1)
		(if debug (print "placing left covenant"))
		(game_save)

		(if (<= (ai_living_count marines) 3) (ai_renew marines))

		(ai_place ext_b_grunts_lt)
		(ai_place ext_b_elites_stealth)
)


(script dormant enc_mausoleum_ext
		(data_mine_set_mission_segment enc_maus_grand)
		(if debug (print "initialize mausoleum exterior encounters"))
		(game_save)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))

		(ai_disposable ext_b_prophets true)
		(ai_disposable ext_b_covenant true)
		
		(set g_marine_mig_maus 1)
		
		(wake maus_door)
		(ai_place maus_hall_grunts)
		(ai_place maus_hall_elites_stealth)
	
	(sleep_until (volume_test_objects tv_maus_room (players)) 5)
		(data_mine_set_mission_segment enc_maus_room)
		(game_save)
		(cs_run_command_script covenant cs_abort)
		(ai_set_orders maus_hall_covenant maus_room_cov_follow)
		
		(set g_marine_mig_maus_room 1)
		
		(wake ai_maus_room_ini)
	
	(sleep_until (volume_test_objects tv_maus_room_bk (players)) 10)
		(if (<= (ai_living_count marines) 3) (ai_renew marines))
		(ai_place maus_room_brute_bk)
		(ai_place maus_room_jackal_bk_lt)
		(ai_place maus_room_jackal_bk_rt)
		
		(ai_set_orders maus_hall_covenant maus_room_cov_follow)
		(ai_set_orders maus_room_covenant maus_room_cov_follow)
	
	(sleep_until (volume_test_objects tv_maus_bridge (players)) 5)
		(data_mine_set_mission_segment enc_maus_bridge)
		(game_save)
		(erase_cortana)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))

		(ai_set_orders maus_hall_covenant maus_bridge_cov_screw)
		(ai_set_orders maus_room_prophet maus_bridge_prophet_screw)
		(ai_set_orders maus_room_covenant maus_bridge_cov_screw)
	
		(sleep_forever ai_maus_room_ini)
		
		(ai_disposable maus_hall_covenant true)
		
		(wake ai_maus_bridge_ini)
		(wake sc_catch_truth)
	
	(sleep_until (volume_test_objects tv_maus_bridge_fr (players)) 10)
		(set g_maus_bridge_fr 1)
	
		(sleep_until (volume_test_objects tv_maus_bridge_mid (players)) 10)
		(game_save)
		
		(if debug (print "bridge reinforcements wave 1"))
	
		(ai_place maus_bridge_elite_rein (pin (- 12 (ai_living_count all_enemies)) 1 2))
		(sleep 1)
		(ai_place maus_bridge_grunt_rein (pin (- 10 (ai_living_count all_enemies)) 0 4))
		(sleep 1)
		(ai_place maus_bridge_buggers_ini (pin (- 6 (ai_living_count all_enemies)) 2 5))
		
		(ai_set_orders maus_bridge_buggers_ini maus_bridge_buggers_rein)

	(sleep_until (volume_test_objects tv_maus_bridge_bk (players)) 10)
		(if debug (print "bridge reinforcements wave 2"))
		(game_save)

		(if (<= (ai_living_count marines) 3) (ai_renew marines))

		(ai_place maus_bridge_grunt_rein_b (pin (- 8 (ai_living_count all_enemies)) 0 4))
		(ai_place maus_bridge_hunters)
)

(script dormant enc_mausoleum
		(data_mine_set_mission_segment enc_mausoleum)
		(if debug (print "initialize mausoleum encounters"))
		(game_save)
		
		(kill_volume_disable kill_maus)
		
		(set g_marine_mig_maus_int 1)
		
		(if (<= (ai_living_count marines) 3) (ai_renew marines))

		(ai_disposable maus_room_prophet true)
		(ai_disposable maus_room_covenant true)
		(ai_disposable maus_bridge_prophets true)
		(ai_disposable maus_bridge_covenant true)
		
		(ai_set_orders maus_bridge_covenant maus_ent_collapse)
		(ai_set_orders maus_bridge_prophets maus_ent_collapse)
		
		(ai_place maus_inner_elites_ini)
;		(ai_place maus_inner_turrets)
		(ai_place maus_inner_brutes_ini)
		(ai_place maus_inner_buggers_lt)
		
		(wake music_07a_07)
		(wake sc_maus_interior)
		
		(sleep 120)
		(kill_volume_enable kill_maus)

	(sleep_until 	(or 
					(volume_test_objects tv_maus_inner_mid (players))
					(<= (ai_living_count maus_inner_covenant) 1)
				)
	)
		(game_save)
		(sleep 5)
		(ai_place maus_inner_hunters_ini)
		(sleep 1)
		
		(wake ai_maus_inner_brute_reins)
	
	(sleep_until	
				(and
					(<= (ai_living_count maus_inner_prophets) 0)
					(<= (ai_living_count maus_inner_covenant) 0)
				)
	30 (* 30 60 10)) ; 9/18 

		(game_save)
		(set g_maus_inner_order_trans 1)
		
	;	(set g_maus_inner_cor_tele_pause 1)
	;	(game_save) 9/18 
		(sc_maus_breather)
		
		(data_mine_set_mission_segment enc_maus_midpoint)
		(game_save)
	;	(wake ai_maus_inner_spawn)
	
		(wake music_07a_08)
	;	(sleep 150)
		(wake ai_maus_inner_elites_final)
;*
	(sleep_until (and (not g_maus_inner_wave_pause) (<= (ai_living_count maus_inner_prophets) 0)))
	
	(set g_maus_inner_wave_pause 1)
	(sleep 30)
	
	(sleep_until	(and
					g_maus_inner_wave_end
					(<= (ai_living_count maus_inner_covenant) 0)
					(<= (ai_living_count maus_inner_prophets) 0)
				)
	)
*;
		(set g_music_07a_07 0)
		(set g_music_07a_08 1)
		
		(sleep 60)
		(game_save)
		(wake sc_maus_exit)
)

(script static void cutscenes
	(x08)
	(sleep 30)
	(c07_intro)
	(sleep 30)
	(c07_intra1)
)
	

;===========================================================================================================
;============= STARTUP SCRIPT ==============================================================================
;===========================================================================================================

(script dormant mission_highcharity	
	(cinematic_snap_to_white)
	
	(object_hide holo_generator true) ; yeah!!!!! 
	
	(switch_bsp 0)
	
	(if (= g_play_cinematics 1)
		(begin
			(sound_suppress_ambience_update_on_revert)
			(if (cinematic_skip_start)
				(begin
					(if debug (print "x08"))
					(x08)
				)
			)
			(cinematic_skip_stop)

			(if (cinematic_skip_start)
				(begin
					(if debug (print "c07_intro"))
					(C07_intro)
				)
			)
			(cinematic_skip_stop)
		)
	)

	(sleep 2)
	
	(object_teleport (player0) player0_start)
	(object_teleport (player1) player1_start)

	(wake enc_council_chamber)
	(wake bullshit)

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white_bars)
	(wake chapter_job)
	(wake objective_locate_set)

	(sleep_until (volume_test_objects tv_dervish_ledge (players)) 5)
	(wake enc_dervish_ledge)
	
	(sleep_until (volume_test_objects tv_corridors_a (players)) 5)
	(wake enc_corridors_a)

	(sleep_until (volume_test_objects tv_jails (players)) 5)
	(wake enc_jails)

	(sleep_until (volume_test_objects tv_room_a_tube (players)) 5)
	(wake enc_corridors_b)

	(sleep_until (volume_test_objects tv_tower_a_ext (players)) 5)
	(wake enc_tower_a_ext)

	(sleep_until (volume_test_objects tv_gardens_a (players)) 5)
	(wake enc_gardens_a)

	(sleep_until (volume_test_objects tv_mid_tower (players)) 5)
	(wake enc_mid_tower)

	(sleep_until (volume_test_objects tv_gardens_b (players)) 5)
	(wake enc_gardens_b)

	(sleep_until (volume_test_objects tv_tower_b_ext (players)) 5)
	(wake enc_tower_b_ext)

	(sleep_until (volume_test_objects tv_mausoleum_ext (players)) 5)
	(wake enc_mausoleum_ext)

	(sleep_until (volume_test_objects tv_mausoleum (players)) 5)
	(wake enc_mausoleum)

)

(script static void start
	(wake mission_highcharity)
)

(script startup mission_main
;	(switch_bsp 0)

	; Necessary startup stuff
	(ai_allegiance player human)
	(ai_allegiance human player)
	
	; Begin the mission
	; Comment this out when you're testing individual encounters
	(if (> (player_count) 0 ) (start))
)