;==== GLOBALS ====
(global boolean global_demo_start false)
(global boolean global_core_save_mode false)


;==== STUB SCRIPTS ====

(script stub void intro
	(sleep 1)
)



;==== JOHNSON INTRO ====

(script static void demo_start
	(set global_demo_start true)
	(sleep 30)
	(intro)
)
	
(script static void johnson_start
	(set global_demo_start true)
;	(cinematic_screen_effect_set_bloom_transition 1 0 0 1 1 3)
;	(cinematic_screen_effect_start 0)

;PREDICT johnson and room
	(camera_predict briefing_1)
	(object_type_predict_high objects\characters\marine\marine_johnson\marine_johnson)
	(bitmap_predict scenarios\solo\earthcity\earthcity_e3\cinematics\projector\bitmaps\map_new_mombasa)
;END PREDICT

	(sleep 15)
	(cinematic_start)
	(camera_control on)
	(object_create_anew briefing_johnson)
;	(object_teleport briefing_johnson johnson_start)
	(object_create_anew briefing_light)

;	(camera_set briefing_1 0)

	(sleep 30)
	(sound_impulse_predict sound\temp\sgtjohnson\johnson_speech)
	(custom_animation briefing_johnson objects\characters\marine\marine_johnson\marine_johnson "johnson_intro" false)
	(camera_set_animation scenarios\solo\earthcity\earthcity_e3\cinematics\camera\camera "camera_johnson_intro")
	(sleep 15)
	(fade_in 0 0 0 30)

;	(camera_set briefing_2 200)
	(sound_impulse_start sound\temp\sgtjohnson\johnson_speech none 1)	
	(sound_looping_start sound\e3\foley\johnson_foley\johnson_foley none 1)	

	(sleep 158)
;	(cinematic_screen_effect_start true)	
;	(cinematic_screen_effect_set_depth_of_field 1 0 0.25 .25 0 0 0)
;	sets dof: <seperation dist>, <near blur lower bound> <upper bound> <time> <far blur lower bound> <upper bound> <time>
	(sleep 20)
;	(cinematic_screen_effect_set_depth_of_field 1 0 0 0.5 0 0 0)
	(sleep 20)
;	(cinematic_screen_effect_stop)

	(sleep 52)
	
	(object_create_anew projector)
	(device_set_position projector .9)
	
	(sleep 100)
	(object_create_anew projector_map_light)

	(sleep 70)
	(object_create_anew swagger_stick)
	(object_set_scale swagger_stick .7	0)
	(objects_attach briefing_johnson right_hand swagger_stick "right_hand")

	(sleep 400)
	
	(bitmap_predict scenarios\solo\earthcity\earthcity_e3\cinematics\projector\bitmaps\map_new_mombasa2)
	(bitmap_predict scenarios\solo\earthcity\earthcity_e3\cinematics\projector\bitmaps\map_new_mombasa3)
	(sleep 40)

	(object_destroy projector_map_light)
	(object_create_anew projector_grunt1_light)
	(sleep 20)
	
	(object_destroy projector_grunt1_light)
	(object_create_anew projector_grunt2_light)
	(sleep 20)

	(object_destroy projector_grunt2_light)
	(object_create_anew projector_grunt1_light)
	(sleep 20)
	
	(object_destroy projector_grunt1_light)
	(object_create_anew projector_grunt2_light)
	(sleep 20)

	(object_destroy projector_grunt2_light)
	(object_create_anew projector_grunt1_light)
	(sleep 20)
	
	(object_destroy projector_grunt1_light)
	(object_create_anew projector_grunt2_light)
	(sleep 20)

	(object_destroy projector_grunt2_light)
	(object_create_anew projector_grunt1_light)
	(sleep 20)
	
	(object_destroy projector_grunt1_light)
	(object_create_anew projector_grunt2_light)
	(sleep 20)

	(object_destroy projector_grunt2_light)
	(object_create_anew projector_grunt1_light)

	(sleep (- (sound_impulse_time sound\temp\sgtjohnson\johnson_speech) 60))

	(fade_out 0 0 0 10)

	(sleep 60)

	(object_destroy swagger_stick)
	(object_destroy briefing_johnson)
	(object_destroy projector)
	(object_destroy briefing_light)
	(object_destroy projector_map_light)
	(camera_control off)
	(cinematic_stop)
;	(cinematic_screen_effect_stop)
	(sleep 90)
	(intro)
)



;==== CORE SAVE MODE ====


(script dormant core_save_mode
	(print "Entering Core Save Mode")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")

	(sleep_until global_core_intro 1) ;post-intro cinematic
	(print "saving core_intro")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
	(core_save_name core_intro)

;	(player_action_test_reset)
;	(sleep_until (player_action_test_rotate_grenades)	1)
;	(sleep 15)
;	(if (not (player_action_test_back)) (sleep_forever))
;	(print "Resetting Core Save Mode")

	(sleep_until global_core_perez 1) ;post-perez shouting 'covering fire'
	(print "saving core_perez")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
	(core_save_name core_perez)

;	(player_action_test_reset)
;	(sleep_until (player_action_test_rotate_grenades)	1)
;	(sleep 15)
;	(if (not (player_action_test_back)) (sleep_forever))
;	(print "Resetting Core Save Mode")

	(sleep_until global_core_sarge 1) ;post-turret, pre-odst charge
	(print "saving core_sarge")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
	(core_save_name core_sarge)

;	(player_action_test_reset)
;	(sleep_until (player_action_test_rotate_grenades)	1)
;	(sleep 15)
;	(if (not (player_action_test_back)) (sleep_forever))
;	(print "Resetting Core Save Mode")

	(sleep_until global_core_creeps 1) ;post-third creep
	(print "saving core_creeps")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
;	(print "Press Back and Black to Save the Next Core")
	(core_save_name core_creeps)

;	(player_action_test_reset)
;	(sleep_until (player_action_test_rotate_grenades)	1)
;	(sleep 15)
;	(if (not (player_action_test_back)) (sleep_forever))
;	(print "Resetting Core Save Mode")

	(sleep_until global_core_phantom 1) ;post-first phantom, pre-brute attack
	(print "saving core_phantom")
	(print "Core Saves Complete")
	(core_save_name core_phantom)
)



;==== CORE LOAD MODE ====

(script continuous core_load_mode
;	(sleep_until global_demo_start 1)
;	(sleep 90)
;
	(player_action_test_reset)
	(sleep_until (player_action_test_start)	1)
	(sleep 15)
	(cond
		((not (player_action_test_back)) (sleep 1))
		(global_core_phantom (core_load_name core_phantom))
		(global_core_creeps (core_load_name core_creeps))
		(global_core_sarge (core_load_name core_sarge))
		(global_core_perez (core_load_name core_perez))
		(global_core_intro (core_load_name core_intro))
		(1 (game_revert))
	)
)




;==== STARTUP SCRIPTS ====

(script dormant e3_start
	(fade_out 0 0 0 0)
	(sound_class_set_gain "" 0 0)
	(ui_debug_screen_tag ui\screens\e3\bungie_logo)
	(object_teleport (player0) johnson_player)

	(ai_allegiance human player)	
	(ai_allegiance human player)
	(ai_allegiance human flood)	
	(ai_allegiance covenant flood)
	(ai_allegiance flood player)
	(ai_allegiance flood human)
	(ai_allegiance flood covenant)	
	
	(hud_show_health off)
	(hud_show_motion_sensor off)
	(hud_show_shield off)
	(hud_show_ammo off)
	(show_hud_help_text false)
	(show_hud_messages false)

	(player_action_test_reset)
	(sleep_until
		(or
			(player_action_test_accept)
			(and
				(player_action_test_primary_trigger)
				(player_action_test_grenade_trigger)
			)
		)
	1 60)
	(if
		(and
			(player_action_test_primary_trigger)
			(player_action_test_grenade_trigger)
		)
		(wake core_save_mode)
	)
	
	(sleep 120)
	(sleep_until (player_action_test_accept) 1)

	(ui_transition_out_console_window)
	(sleep 15)
	(sound_class_set_gain "" 1 0)
	(if
		(player_action_test_back)
		(demo_start)
		(johnson_start)
	)
)


	
