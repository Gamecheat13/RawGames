; CINEMATICS FOR LEVEL 01B, "SPACE STATION" ===========================
; =====================================================================

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)

	(script stub void x02_01_predict_stub (print "predict 01"))
	(script stub void x02_02_predict_stub (print "predict 02"))
	(script stub void x02_03_predict_stub (print "predict 03"))
	(script stub void x02_04a_predict_stub (print "predict 04a"))
	(script stub void x02_04b_predict_stub (print "predict 04b"))
	(script stub void x02_05_predict_stub (print "predict 05"))
	(script stub void x02_06_predict_stub (print "predict 06"))
	(script stub void x02_07_predict_stub (print "predict 07"))
	(script stub void x02_08_predict_stub (print "predict 08"))
	(script stub void x02_09_predict_stub (print "predict 09"))
	(script stub void x02_10_predict_stub (print "predict 10"))
	
	(script stub void 01_outro_01_predict_stub (print "predict 01"))
	(script stub void 01_outro_02_predict_stub (print "predict 02"))
	(script stub void 01_outro_03_predict_stub (print "predict 03"))
	(script stub void 01_outro_04_predict_stub (print "predict 04"))
	(script stub void 01_outro_05_predict_stub (print "predict 05"))
	(script stub void 01_outro_06_predict_stub (print "predict 06"))
	(script stub void 01_outro_07_predict_stub (print "predict 07"))
	(script stub void 01_outro_08_predict_stub (print "predict 08"))
	(script stub void 01_outro_09_predict_stub (print "predict 09"))
	(script stub void 01_outro_10_predict_stub (print "predict 10"))

; X02 SCENE 01 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\music\x02_01_mus none 1)
	(print "x02 score 01 start")
	)
	
(script dormant x02_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_01_fol none 1)
	(print "x02 foley 01 start")
	)

(script dormant x02_0010_mas
	(sleep 20)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0010_mas chief_x02_01 1)
	(cinematic_subtitle x02_0010_mas 2)
	)
	
(script dormant x02_0020_jon
	(sleep 80)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0020_jon johnson_x02_01 1)
	(cinematic_subtitle x02_0020_jon 2.5)
	
	(unit_set_emotional_state johnson_x02_01 annoyed .75 10)
	(print "johnson - annoyed .75 15")
	
	)
	
(script dormant x02_0030_jon
	(sleep 181)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0030_jon johnson_x02_01 1)
	(cinematic_subtitle x02_0030_jon 2.5)
	)

(script dormant x02_0040_jon
	(sleep 270)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0040_jon johnson_x02_01 1)
	(cinematic_subtitle x02_0040_jon 2)
	
	(unit_set_emotional_state johnson_x02_01 happy .75 30)
	(print "johnson - happy .75 30")
	
	)

(script dormant x02_0050_jon
	(sleep 333)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0050_jon johnson_x02_01 1)
	(cinematic_subtitle x02_0050_jon 2)
	
	(sleep 10)
	
	(unit_set_emotional_state johnson_x02_01 pensive 1 60)
	(print "johnson - pensive 1 60")
	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x02_01_dof
	
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field .85 0 0 0 .5 .5 0)
	(print "rack focus")
	
	(sleep 164)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	(sleep 104)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 0 0 0 .5 .5 0)
	(print "rack focus")
	
	(sleep 147)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)

(script dormant cinematic_lighting_x02_01
	
	(cinematic_lighting_set_primary_light 67 208 0.458824 0.407843 0.34902)
	(cinematic_lighting_set_secondary_light 45 120 0.215686 0.207843 0.25098)
	(cinematic_lighting_set_ambient_light 0.0823529 0.0823529 0.0823529)
	
	(object_uses_cinematic_lighting chief_x02_01 1)
	(object_uses_cinematic_lighting johnson_x02_01 1)
	(object_uses_cinematic_lighting marine_x02_01 1)
	(object_uses_cinematic_lighting marine_x02_02 1)
	(object_uses_cinematic_lighting marine_x02_03 1)
	(object_uses_cinematic_lighting marine_x02_04 1)
	(object_uses_cinematic_lighting marine_x02_05 1)
	(object_uses_cinematic_lighting marine_x02_06 1)
	(object_uses_cinematic_lighting marine_x02_07 1)
	(object_uses_cinematic_lighting marine_x02_08 1)
	(object_uses_cinematic_lighting marine_door_01 1)
	(object_uses_cinematic_lighting marine_door_02 1)
	(object_uses_cinematic_lighting johnson_hat 1)
	(object_uses_cinematic_lighting x02_drone_01 1)
	(object_uses_cinematic_lighting x02_drone_02 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)
	
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void x02_02_problem_actors
	
	(print "problem actors")
	
	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew brute_01)
	(object_create_anew brute_02)

	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)

	)

; CROWDS --------------------------------------------------------------

(script dormant x02_hum_crowd_01a

	(print "first marine crowd")

	(custom_animation_loop marine_x02_05 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(custom_animation_loop marine_x02_04 objects\characters\marine\x02\x02 "marine_fist_loop" false)
	
	(custom_animation_loop marine_x02_01 objects\characters\marine\x02\x02 "marine_clapping_loop" false)
	(sleep 5)
	(custom_animation_loop marine_x02_02 objects\characters\marine\x02\x02 "marine_clapping_loop" false)
	(sleep 10)
	(custom_animation_loop marine_x02_03 objects\characters\marine\x02\x02 "marine_clapping_loop" false)
	(sleep 10)
	(custom_animation_loop marine_x02_06 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(sleep 10)
	(custom_animation_loop marine_x02_07 objects\characters\marine\x02\x02 "marine_clapping_loop" false)
	(sleep 10)
	(custom_animation_loop marine_x02_08 objects\characters\marine\x02\x02 "marine_clapping_loop" false)

	)
	
(script dormant x02_hum_crowd_01b

	(sleep 268)

	(print "second marine crowd")
	
	(object_destroy marine_x02_01)
	(object_destroy marine_x02_02)
	(object_destroy marine_x02_03)
	(object_destroy marine_x02_04)
	(object_destroy marine_x02_05)

	(object_create_anew marine_x02_09)
	(object_create_anew marine_x02_10)
	(object_create_anew marine_x02_11)
	(object_create_anew marine_x02_12)
	
	(object_uses_cinematic_lighting marine_x02_09 1)
	(object_uses_cinematic_lighting marine_x02_10 1)
	(object_uses_cinematic_lighting marine_x02_11 1)
	(object_uses_cinematic_lighting marine_x02_12 1)

	(custom_animation_loop marine_x02_09 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(custom_animation_loop marine_x02_10 objects\characters\marine\x02\x02 "marine_fist_loop" false)
	
	(custom_animation_loop marine_x02_11 objects\characters\marine\x02\x02 "marine_clapping_loop" false)
	(sleep 10)
	(custom_animation_loop marine_x02_12 objects\characters\marine\x02\x02 "marine_clapping_loop" false)

	)

; ---------------------------------------------------------------------

(script dormant open_bridge_door
	(sleep 417)
	(print "open bridge door")
	(device_set_position x02_bridge_door 1)
	)

(script static void x02_01_setup

	(object_destroy_type_mask 2052)
	(object_destroy offending_light)

	(object_create_anew chief_x02_01)
	(object_create_anew johnson_x02_01)
	(object_create_anew johnson_hat)
	
	(object_set_permutation johnson_x02_01 "helmet" "")
	
	(object_create_anew marine_door_01)
	(object_create_anew marine_door_02)
	
	(object_set_permutation marine_door_01 "head" "smith")
	(object_set_permutation marine_door_02 "head" "perez")
	
	(object_create_anew marine_x02_01)
	(object_create_anew marine_x02_02)
	(object_create_anew marine_x02_03)
	(object_create_anew marine_x02_04)
	(object_create_anew marine_x02_05)
	(object_create_anew marine_x02_06)
	(object_create_anew marine_x02_07)
	(object_create_anew marine_x02_08)
	
	(object_create_anew x02_drone_01)
	(object_create_anew x02_drone_02)
	
	(object_cinematic_lod chief_x02_01 true)
	(object_cinematic_lod johnson_x02_01 true)
	(object_cinematic_lod marine_x02_01 true)
	(object_cinematic_lod marine_x02_02 true)
	(object_cinematic_lod marine_x02_03 true)
	(object_cinematic_lod marine_x02_04 true)
	(object_cinematic_lod marine_x02_05 true)
	(object_cinematic_lod marine_x02_06 true)
	(object_cinematic_lod marine_x02_07 true)
	(object_cinematic_lod marine_x02_08 true)
	
	(wake x02_score_01)
	(wake x02_foley_01)

	(wake x02_0010_mas)
	(wake x02_0020_jon)
	(wake x02_0030_jon)
	(wake x02_0040_jon)
	(wake x02_0050_jon)
	
	(wake x02_hum_crowd_01a)
	(wake x02_hum_crowd_01b)

	(wake x02_01_dof)
	(wake cinematic_lighting_x02_01)
	
	(wake open_bridge_door)
	
	)

(script static void x02_01_cleanup
	(object_destroy chief_x02_01)
	(object_destroy johnson_x02_01)
	(object_destroy_containing marine_x02)
	(object_destroy_containing marine_door)
	(object_destroy_containing drone)
	(cinematic_screen_effect_stop)
	)

(script static void x02_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x02_01_predict_stub)
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\music\x02_01_mus)
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_01b_fol)
	(sleep prediction_offset)
	
	(x02_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_01" none "anchor_flag_x02_01")
	
	(custom_animation_relative chief_x02_01 objects\characters\masterchief\x02\x02 "chief_01" false anchor_x02_01)
	(custom_animation_relative johnson_x02_01 objects\characters\marine\x02\x02 "johnson_01" false anchor_x02_01)
	
	(custom_animation_relative marine_door_01 objects\characters\marine\x02\x02 "marine02_01" false anchor_x02_01)
	(custom_animation_relative marine_door_02 objects\characters\marine\x02\x02 "marine04_01" false anchor_x02_01)
	
	(scenery_animation_start_relative johnson_hat objects\characters\marine\dress_cap\x02\x02 "dress_cap_01" anchor_x02_01)
	(scenery_animation_start_relative x02_drone_01 objects\cinematics\news_drone\x02\x02 "news_drone01_01" anchor_x02_01)
	(scenery_animation_start_relative x02_drone_02 objects\cinematics\news_drone\x02\x02 "news_drone02_01" anchor_x02_01)

; 	safety white
	(sleep 20)

	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_01b_fol)
	
	(sleep (- (camera_time) 15))
	(x02_02_problem_actors)
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(x02_01_cleanup)
	
	)
	
; X02 SCENE 02 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_01b_fol none 1)
	(print "x02 foley 02 start")
	)

(script dormant x02_0070_gch
	(sleep 386)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0070_gch none 1)
	(cinematic_subtitle x02_0070_gch 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x02_fov_02
	
	(sleep 384)
	(camera_set_field_of_view 30 0)
	(print "fov change: 60 -> 30 over 0 ticks")
	
	(sleep 71)
	(camera_set_field_of_view 60 0)
	(print "fov change: 30 -> 60 over 0 ticks")

	)
	
(script dormant cinematic_lighting_x02_02
	
	(cinematic_lighting_set_primary_light 90 248 0.345098 0.286275 0.270588)
	(cinematic_lighting_set_secondary_light 90 36 0.0784314 0.0745098 0.0901961)
	(cinematic_lighting_set_ambient_light 0.0509804 0.0509804 0.0509804)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting grunt_01 1)
	(object_uses_cinematic_lighting grunt_02 1)
	(object_uses_cinematic_lighting grunt_03 1)
	(object_uses_cinematic_lighting jackal_01 1)
	(object_uses_cinematic_lighting hammer 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	)

; CROWDS --------------------------------------------------------------

(script dormant place_cov_crowd_01a
	(sleep 60)
	(print "place crowd 01a")
	(object_create_anew_containing cov_crowd_01a)
	(object_create_anew problem_guard)
	
	(object_uses_cinematic_lighting cov_crowd_01a_01 1)
	(object_uses_cinematic_lighting cov_crowd_01a_02 1)
	(object_uses_cinematic_lighting cov_crowd_01a_03 1)
	(object_uses_cinematic_lighting cov_crowd_01a_04 1)
	(object_uses_cinematic_lighting cov_crowd_01a_05 1)
	(object_uses_cinematic_lighting cov_crowd_01a_06 1)
	(object_uses_cinematic_lighting cov_crowd_01a_07 1)
	(object_uses_cinematic_lighting cov_crowd_01a_08 1)
	(object_uses_cinematic_lighting cov_crowd_01a_09 1)
	(object_uses_cinematic_lighting cov_crowd_01a_10 1)
	(object_uses_cinematic_lighting cov_crowd_01a_11 1)
	(object_uses_cinematic_lighting cov_crowd_01a_12 1)
	(object_uses_cinematic_lighting cov_crowd_01a_13 1)
	(object_uses_cinematic_lighting cov_crowd_01a_14 1)
	(object_uses_cinematic_lighting cov_crowd_01a_15 1)
	(object_uses_cinematic_lighting cov_crowd_01a_16 1)
	(object_uses_cinematic_lighting cov_crowd_01a_17 1)
	(object_uses_cinematic_lighting cov_crowd_01a_18 1)
	(object_uses_cinematic_lighting cov_crowd_01a_19 1)
	(object_uses_cinematic_lighting cov_crowd_01a_20 1)
	(object_uses_cinematic_lighting cov_crowd_01a_21 1)
	(object_uses_cinematic_lighting cov_crowd_01a_22 1)
	(object_uses_cinematic_lighting cov_crowd_01a_23 1)
	(object_uses_cinematic_lighting cov_crowd_01a_24 1)
	(object_uses_cinematic_lighting cov_crowd_01a_25 1)
	(object_uses_cinematic_lighting cov_crowd_01a_26 1)
	(object_uses_cinematic_lighting cov_crowd_01a_27 1)
	(object_uses_cinematic_lighting cov_crowd_01a_28 1)
	(object_uses_cinematic_lighting cov_crowd_01a_29 1)
	(object_uses_cinematic_lighting cov_crowd_01a_30 1)
	(object_uses_cinematic_lighting cov_crowd_01a_31 1)
	(object_uses_cinematic_lighting cov_crowd_01a_32 1)
	(object_uses_cinematic_lighting cov_crowd_01a_33 1)
	(object_uses_cinematic_lighting problem_guard 1)
	)
	
(script dormant place_cov_crowd_01b
	(sleep 249)
	(print "place crowd 01b")
	(object_destroy_containing cov_crowd_01a)
	(object_destroy problem_guard)
	(object_create_anew_containing cov_crowd_01b)
	
	(object_uses_cinematic_lighting cov_crowd_01b_01 1)
	(object_uses_cinematic_lighting cov_crowd_01b_03 1)
	(object_uses_cinematic_lighting cov_crowd_01b_04 1)
	(object_uses_cinematic_lighting cov_crowd_01b_05 1)
	(object_uses_cinematic_lighting cov_crowd_01b_06 1)
	(object_uses_cinematic_lighting cov_crowd_01b_07 1)
	(object_uses_cinematic_lighting cov_crowd_01b_08 1)
	(object_uses_cinematic_lighting cov_crowd_01b_09 1)
	(object_uses_cinematic_lighting cov_crowd_01b_10 1)
	(object_uses_cinematic_lighting cov_crowd_01b_11 1)
	(object_uses_cinematic_lighting cov_crowd_01b_12 1)
	(object_uses_cinematic_lighting cov_crowd_01b_13 1)
	(object_uses_cinematic_lighting cov_crowd_01b_14 1)
	(object_uses_cinematic_lighting cov_crowd_01b_15 1)
	(object_uses_cinematic_lighting cov_crowd_01b_16 1)
	
	) 
	
(script dormant place_cov_crowd_01c
	(sleep 384)
	(print "place crowd 01c")
	(object_destroy_containing cov_crowd_01b)
	(object_create_anew_containing cov_crowd_01c)
	
	(object_uses_cinematic_lighting cov_crowd_01c_01 1)
	(object_uses_cinematic_lighting cov_crowd_01c_02 1)
	(object_uses_cinematic_lighting cov_crowd_01c_03 1)
	(object_uses_cinematic_lighting cov_crowd_01c_04 1)
	(object_uses_cinematic_lighting cov_crowd_01c_05 1)
	
	)
	
(script dormant place_cov_crowd_01d
	(time_code_reset)

	(sleep 610)
	(print "place crowd 01d")
	(object_destroy_containing cov_crowd_01c)
	(object_create_anew_containing cov_crowd_01d)
	
	(object_uses_cinematic_lighting cov_crowd_01d_01 1)
	(object_uses_cinematic_lighting cov_crowd_01d_02 1)
	(object_uses_cinematic_lighting cov_crowd_01d_03 1)
	(object_uses_cinematic_lighting cov_crowd_01d_04 1)
	(object_uses_cinematic_lighting cov_crowd_01d_05 1)
	(object_uses_cinematic_lighting cov_crowd_01d_06 1)
	(object_uses_cinematic_lighting cov_crowd_01d_07 1)
	(object_uses_cinematic_lighting cov_crowd_01d_08 1)
	(object_uses_cinematic_lighting cov_crowd_01d_09 1)
	(object_uses_cinematic_lighting cov_crowd_01d_10 1)
	(object_uses_cinematic_lighting cov_crowd_01d_11 1)
	(object_uses_cinematic_lighting cov_crowd_01d_12 1)
	(object_uses_cinematic_lighting cov_crowd_01d_13 1)
	(object_uses_cinematic_lighting cov_crowd_01d_14 1)
	(object_uses_cinematic_lighting cov_crowd_01d_15 1)
	(object_uses_cinematic_lighting cov_crowd_01d_16 1)
	(object_uses_cinematic_lighting cov_crowd_01d_17 1)
	(object_uses_cinematic_lighting cov_crowd_01d_18 1)
	(object_uses_cinematic_lighting cov_crowd_01d_19 1)
	(object_uses_cinematic_lighting cov_crowd_01d_20 1)
	(object_uses_cinematic_lighting cov_crowd_01d_21 1)
	
	) 
	
(script dormant place_cov_crowd_distant
	(sleep 456)
	(print "place crowd distant")
	(object_create_anew_containing x02_crowd_distant)
	)
	
; ---------------------------------------------------------------------
	
(script dormant activate_manacles
	(sleep 666)
	(print "activate manacle")
	(object_set_function_variable x02_manacle_01 "manacle_on" 0 1)
	(sleep 20)
	(object_set_function_variable x02_manacle_02 "manacle_on" 0 1)
	)

(script dormant create_columns
	(object_create_anew x02_column_01)
	(object_create_anew x02_column_06)
	(sleep 30)
	(object_create_anew x02_column_02)
	(object_create_anew x02_column_05)
	(sleep 30)
	(object_create_anew x02_column_03)
	(object_create_anew x02_column_04)
	)

(script static void x02_02_setup

	(object_create_anew grunt_01)
	(object_create_anew grunt_02)
	(object_create_anew grunt_03)
	(object_create_anew jackal_01)
	(object_create_anew hammer)
	(object_create_anew_containing x02_manacle)

	(object_cinematic_lod grunt_01 true)
	(object_cinematic_lod grunt_02 true)
	(object_cinematic_lod grunt_03 true)
	(object_cinematic_lod jackal_01 true)
	(object_cinematic_lod hammer true)
	
	(wake x02_foley_02)
	
	(wake x02_0070_gch)

	(wake x02_fov_02)
;	(wake x04_01_dof_1)

	(wake place_cov_crowd_01a)
	(wake place_cov_crowd_01b)
	(wake place_cov_crowd_01c)
	(wake place_cov_crowd_01d)
	(wake place_cov_crowd_distant)
	
	(wake create_columns)
	(wake activate_manacles)
	(wake cinematic_lighting_x02_02)
	
	(device_set_position x02_door_02 1)
	
	)

(script static void x02_02_cleanup
	(object_destroy brute_01)
	(object_destroy brute_02)
	(object_destroy grunt_01)
	(object_destroy grunt_02)
	(object_destroy grunt_03)
	(object_destroy jackal_01)
	(object_destroy hammer)
	(object_destroy_containing cov_crowd_01)
	(object_destroy_containing crowd_distant)
	)

(script static void x02_scene_02

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x02_02_predict_stub)
	
	(x02_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_02" none "anchor_flag_x02_02")
	
	(custom_animation_relative dervish objects\characters\dervish\x02\x02 "dervish_02" false anchor_x02_02)
	(custom_animation_relative tartarus objects\characters\brute\x02\x02 "tartarus_02" false anchor_x02_02)
	
	(custom_animation_relative brute_01 objects\characters\brute\x02\x02 "brute01_02" false anchor_x02_02)
	(custom_animation_relative brute_02 objects\characters\brute\x02\x02 "brute02_02" false anchor_x02_02)

	(custom_animation_relative grunt_01 objects\characters\grunt\x02\x02 "grunt01_02" false anchor_x02_02)
	(custom_animation_relative grunt_02 objects\characters\grunt\x02\x02 "grunt02_02" false anchor_x02_02)
	(custom_animation_relative grunt_03 objects\characters\grunt\x02\x02 "grunt03_02" false anchor_x02_02)
	(custom_animation_relative jackal_01 objects\characters\jackal\x02\x02 "jackal01_02" false anchor_x02_02)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x02\x02 "hammer_02" anchor_x02_02)
	
	(scenery_animation_start_relative x02_manacle_01 objects\cinematics\covenant\manacles\x02\x02 "manacle1_02" anchor_x02_02)
	(scenery_animation_start_relative x02_manacle_02 objects\cinematics\covenant\manacles\x02\x02 "manacle2_02" anchor_x02_02)

; 	safety white
	(sleep 30)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x02_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_02_fol)
	
	(sleep (camera_time))
	
	(x02_02_cleanup)
	
	)
	
; X02 SCENE 03 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_02_fol none 1)
	(print "x02 foley 03 start")
	)

(script dormant x02_0090_tar
	(sleep 40)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0090_tar tartarus 1)
	(cinematic_subtitle x02_0090_tar 2)
	)

(script dormant x02_0100_der
	(sleep 106)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0100_der dervish 1)
	(cinematic_subtitle x02_0100_der 3.5)
	)
	
(script dormant x02_0110_tar
	(sleep 213)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0110_tar tartarus 1)
	(cinematic_subtitle x02_0110_tar 1.5)
	
	(unit_set_emotional_state tartarus inquisitive 1 60)
	(print "tartarus - inquisitive 1 60")
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_beam_01_start
	(sleep 297)
	(print "effect - beam 01 start")
	(object_create beam_start_01)
	)

(script dormant effect_beams
	(sleep 378)
	(print "effect - beam 01")
	(object_create beam_01)
	(sleep 69)
	(print "effect - beam 02")
	(object_create beam_02)
	)

(script dormant place_cov_crowd_02
	(sleep 480)
	(print "place crowd 02")
	(object_create_anew_containing cov_crowd_02)
	(object_uses_cinematic_lighting cov_crowd_02_01 1)
	(object_uses_cinematic_lighting cov_crowd_02_02 1)
	(object_uses_cinematic_lighting cov_crowd_02_03 1)
	(object_uses_cinematic_lighting cov_crowd_02_04 1)
	(object_uses_cinematic_lighting cov_crowd_02_05 1)
	(object_uses_cinematic_lighting cov_crowd_02_06 1)
	(object_uses_cinematic_lighting cov_crowd_02_07 1)
	(object_uses_cinematic_lighting cov_crowd_02_08 1)
	(object_uses_cinematic_lighting cov_crowd_02_09 1)
	(object_uses_cinematic_lighting cov_crowd_02_10 1)
	(object_uses_cinematic_lighting cov_crowd_02_11 1)
	(object_uses_cinematic_lighting cov_crowd_02_12 1)
	(object_uses_cinematic_lighting cov_crowd_02_13 1)
	(object_uses_cinematic_lighting cov_crowd_02_14 1)
	(object_uses_cinematic_lighting cov_crowd_02_15 1)
	(object_uses_cinematic_lighting cov_crowd_02_16 1)
	(object_uses_cinematic_lighting cov_crowd_02_17 1)
	(object_uses_cinematic_lighting cov_crowd_02_18 1)
	(object_uses_cinematic_lighting cov_crowd_02_19 1)
	) 
	
; ---------------------------------------------------------------------
	
(script static void x02_03_setup
	
	(wake x02_foley_03)
	
	(wake x02_0090_tar)
	(wake x02_0100_der)
	(wake x02_0110_tar)

	(wake effect_beam_01_start)
	(wake effect_beams)

	(wake place_cov_crowd_02)
	
	)
	
(script static void x02_scene_03_cleanup
	(object_destroy_containing beam)
	(object_destroy_containing cov_crowd_02)
	)

(script static void x02_scene_03
	
	(x02_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_03" none "anchor_flag_x02_02")
	
	(custom_animation_relative dervish objects\characters\dervish\x02\x02 "dervish_03" false anchor_x02_02)
	(custom_animation_relative tartarus objects\characters\brute\x02\x02 "tartarus_03" false anchor_x02_02)
	
	(scenery_animation_start_relative x02_manacle_01 objects\cinematics\covenant\manacles\x02\x02 "manacle1_03" anchor_x02_02)
	(scenery_animation_start_relative x02_manacle_02 objects\cinematics\covenant\manacles\x02\x02 "manacle2_03" anchor_x02_02)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_03_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(x02_scene_03_cleanup)
	
	)
	
; X02 SCENE 04A -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_foley_04a
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_03_fol none 1)
	(print "x02 foley 04a start")
	)

(script dormant x02_0140_lhd
	(sleep 300)
	
	(unit_set_emotional_state hood_x02 happy .25 30)
	(print "hood - happy .25 30")
	
	(sleep 41)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0140_lhd hood_x02 1)
	(cinematic_subtitle x02_0140_lhd 2)
	)
	
(script dormant marine_whisper
	(sleep 413)
	(print "marine whisper")
	(sound_impulse_start sound\ambience\earthcity\whisper marine_01 1)
	)
	
(script dormant x02_0150_lhd
	(sleep 430)
	
	(unit_set_emotional_state hood_x02 angry .25 60)
	(print "hood - angry .25 60")
	
	(sleep 50)
	
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0150_lhd hood_x02 1)
	(cinematic_subtitle x02_0150_lhd 1.5)
	)
	
(script dormant x02_0160_cor

	(unit_set_emotional_state cortana_x02 angry .15 0)
	(print "cortana - angry .15 0")
	
	(sleep 524)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0160_cor cortana_x02 1)
	(cinematic_subtitle x02_0160_cor 3)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_cortana_on 
	(sleep 521)
	(print "cortana_on")
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off x02_cortana_stand "holo_effect")
;	(custom_animation_relative cortana_x02 objects\characters\cortana\x02\x02 "cortana_04a" false anchor_x02_01)
	)

(script dormant cinematic_lighting_x02_04a
	
	(cinematic_lighting_set_primary_light 61 116 0.356863 0.317647 0.301961)
	(cinematic_lighting_set_secondary_light -28 54 0.207843 0.219608 0.258824)
	(cinematic_lighting_set_ambient_light 0.105882 0.101961 0.14902)
	
	(object_uses_cinematic_lighting chief_x02 1)
	(object_uses_cinematic_lighting johnson_x02 1)
	(object_uses_cinematic_lighting hood_x02 1)
	(object_uses_cinematic_lighting miranda_x02 1)
	(object_uses_cinematic_lighting cortana_x02 1)
	
	(object_uses_cinematic_lighting marine_01 1)
	(object_uses_cinematic_lighting marine_02 1)
	(object_uses_cinematic_lighting marine_03 1)
	(object_uses_cinematic_lighting marine_04 1)
	
	(object_uses_cinematic_lighting marine_plant_01 1)
	(object_uses_cinematic_lighting marine_plant_02 1)
	(object_uses_cinematic_lighting marine_plant_03 1)
	(object_uses_cinematic_lighting marine_plant_04 1)
	(object_uses_cinematic_lighting marine_plant_05 1)
	(object_uses_cinematic_lighting marine_plant_06 1)
	(object_uses_cinematic_lighting marine_plant_07 1)
	
	(object_uses_cinematic_lighting x02_cortana_stand 1)
	(object_uses_cinematic_lighting x02_medal_tray 1)

	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)

	)
	
; CROWDS --------------------------------------------------------------

(script dormant x02_marine_crowd_01
	(sleep 0)
	(print "create marine crowd 02")
	
	(object_create_anew_containing x02_marine_prop_01a)
	(sleep 10)
	(object_create_anew_containing x02_marine_prop_01b)
	
	(object_uses_cinematic_lighting x02_marine_prop_01a_01 1)
	(object_uses_cinematic_lighting x02_marine_prop_01b_02 1)
	(object_uses_cinematic_lighting x02_marine_prop_01a_03 1)
	(object_uses_cinematic_lighting x02_marine_prop_01b_04 1)
	(object_uses_cinematic_lighting x02_marine_prop_01a_05 1)
	(object_uses_cinematic_lighting x02_marine_prop_01a_06 1)
	(object_uses_cinematic_lighting x02_marine_prop_01a_07 1)
	(object_uses_cinematic_lighting x02_marine_prop_01b_08 1)
	(object_uses_cinematic_lighting x02_marine_prop_01a_09 1)
	(object_uses_cinematic_lighting x02_marine_prop_01b_10 1)
	(object_uses_cinematic_lighting x02_marine_prop_01a_11 1)
	(object_uses_cinematic_lighting x02_marine_prop_01b_12 1)
	(object_uses_cinematic_lighting x02_marine_prop_01a_13 1)
	(object_uses_cinematic_lighting x02_marine_prop_01b_14 1)
	(object_uses_cinematic_lighting x02_marine_prop_01a_15 1)
	(object_uses_cinematic_lighting x02_marine_prop_01b_16 1)
	
	)

(script dormant x02_marine_crowd_02
	(sleep 0)
	(print "create marine crowd 02")
	
	(object_create_anew_containing x02_marine_prop_02a)
	(sleep 5)
	(object_create_anew_containing x02_marine_prop_02b)
	(sleep 10)
	(object_create_anew_containing x02_marine_prop_02c)
	
	(object_uses_cinematic_lighting x02_marine_prop_02a_01 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_02 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_03 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_05 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_06 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_07 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_08 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_09 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_10 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_11 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_12 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_13 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_14 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_16 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_17 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_18 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_19 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_20 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_21 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_22 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_23 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_24 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_25 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_26 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_27 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_28 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_29 1)
	(object_uses_cinematic_lighting x02_marine_prop_02a_30 1)
	(object_uses_cinematic_lighting x02_marine_prop_02b_31 1)
	(object_uses_cinematic_lighting x02_marine_prop_02c_32 1)
	
	)

; ---------------------------------------------------------------------

(script static void x02_04a_setup

	(object_create_anew chief_x02)
	(object_create_anew hood_x02)
	(object_create_anew cortana_x02)
	(object_create_anew miranda_x02)
	(object_create_anew johnson_x02)
	(object_create_anew marine_01)
	(object_create_anew marine_02)
	(object_create_anew marine_03)
	(object_create_anew marine_04)
	
	(object_create_anew marine_plant_01)
	(object_create_anew marine_plant_02)
	(object_create_anew marine_plant_03)
	(object_create_anew marine_plant_04)
	(object_create_anew marine_plant_05)
	(object_create_anew marine_plant_06)
	(object_create_anew marine_plant_07)
	
	(object_set_permutation marine_01 "head" "perez")
	(object_set_permutation marine_02 "head" "smith")
	(object_set_permutation marine_03 "head" "walter")
	(object_set_permutation marine_04 "head" "dion")
	
	(object_create_anew x02_cortana_stand)
	(object_create_anew x02_medal_tray)
	(object_create_anew x02_unsc_logo)
	
	(object_cinematic_lod chief_x02 true)
	(object_cinematic_lod hood_x02 true)
	(object_cinematic_lod cortana_x02 true)
	(object_cinematic_lod miranda_x02 true)
	(object_cinematic_lod johnson_x02 true)
	(object_cinematic_lod marine_01 true)
	(object_cinematic_lod marine_02 true)
	(object_cinematic_lod marine_03 true)
	(object_cinematic_lod marine_04 true)
	
	(object_cinematic_lod marine_plant_01 true)
	(object_cinematic_lod marine_plant_02 true)
	(object_cinematic_lod marine_plant_03 true)
	(object_cinematic_lod marine_plant_04 true)
	(object_cinematic_lod marine_plant_05 true)
	(object_cinematic_lod marine_plant_06 true)
	(object_cinematic_lod marine_plant_07 true)
	
	(wake x02_foley_04a)
	
	(wake x02_0140_lhd)
	(wake marine_whisper)
	(wake x02_0150_lhd)
	(wake x02_0160_cor)

	(wake x02_marine_crowd_01)
	(wake x02_marine_crowd_02)

	(wake effect_cortana_on)
	(wake cinematic_lighting_x02_04a)
	
	)
	
(script static void x02_scene_04a_cleanup
	
	(object_destroy marine_05)
	(object_destroy marine_06)
	(object_destroy marine_07)
	(object_destroy marine_08)
	(object_destroy_containing x02_marine_prop_01)
	(object_destroy_containing x02_marine_prop_02)
	(object_destroy_containing marine_plant)

	)

(script static void x02_scene_04a

	(cinematic_lightmap_shadow_enable)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x02_04a_predict_stub)
	
	(x02_04a_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_04a" none "anchor_flag_x02_01")
	
	(custom_animation_relative chief_x02 objects\characters\masterchief\x02\x02 "chief_04a" false anchor_x02_01)
	(custom_animation_relative johnson_x02 objects\characters\marine\x02\x02 "johnson_04a" false anchor_x02_01)

	(custom_animation_relative hood_x02 objects\characters\lord_hood\x02\x02 "hood_04a" false anchor_x02_01)
	(custom_animation_relative miranda_x02 objects\characters\miranda\x02\x02 "miranda_04a" false anchor_x02_01)
	
	(custom_animation_relative cortana_x02 objects\characters\cortana\x02\x02 "cortana_04a" false anchor_x02_01)

	(custom_animation_relative marine_01 objects\characters\marine\x02\x02 "marine01_04a" false anchor_x02_01)
	(custom_animation_relative marine_02 objects\characters\marine\x02\x02 "marine02_04a" false anchor_x02_01)
	(custom_animation_relative marine_03 objects\characters\marine\x02\x02 "marine03_04a" false anchor_x02_01)
	(custom_animation_relative marine_04 objects\characters\marine\x02\x02 "marine04_04a" false anchor_x02_01)
	
	(custom_animation_loop marine_plant_01 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(custom_animation_loop marine_plant_02 objects\characters\marine\x02\x02 "marine_fist_loop" false)
	(custom_animation_loop marine_plant_03 objects\characters\marine\x02\x02 "marine_clapping_loop" false)
	(custom_animation_loop marine_plant_04 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(custom_animation_loop marine_plant_05 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(custom_animation_loop marine_plant_06 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(custom_animation_loop marine_plant_07 objects\characters\marine\x02\x02 "marine_fist_loop" false)
	
	(scenery_animation_start_relative x02_cortana_stand scenarios\objects\solo\spacestation\ss_stand_cortana\x02\x02 "cortana_stand_04a" anchor_x02_01)
	(scenery_animation_start_relative x02_medal_tray objects\cinematics\human\medals\medal_tray\x02\x02 "medal_tray_04a" anchor_x02_01)
	(scenery_animation_start_relative x02_unsc_logo objects\cinematics\human\cairo_bridge_holoscreens\holo_display_unsc_logo\x02\x02 "unsc_logo_04a" anchor_x02_01)
	
;	safety white
	(sleep 30)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x02_04b_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_04_fol)
	
	(sleep (camera_time))
	
	(x02_scene_04a_cleanup)
	
	)
	
; X02 SCENE 04B -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_foley_04b
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_04_fol none 1)
	(print "x02 foley 04b start")
	)

(script dormant x02_0170_lhd
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0170_lhd hood_x02 1)
	(cinematic_subtitle x02_0170_lhd 3)
	)
	
(script dormant x02_0180_cor

	(sleep 10)
	
	(unit_set_emotional_state cortana_x02 angry .25 0)

	(sleep 117)
	
	(unit_set_emotional_state cortana_x02 happy .25 60)
	(print "cortana - happy .15 60")

	(sleep 30)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0180_cor cortana_x02 1)
	(cinematic_subtitle x02_0180_cor 1)
	)
	
(script dormant x02_0190_mas
	(sleep 194)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0190_mas chief_x02 1)
	(cinematic_subtitle x02_0190_mas 1)
	)
	
(script dormant x02_0200_jon
	(sleep 189)
	
	(unit_set_emotional_state johnson_x02 arrogant 1 0)
	(print "johnson - amorous 1 0")
	
	(sleep 5)
	
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0200_jon johnson_x02 1)
	(cinematic_subtitle x02_0200_jon 1)
	
	(sleep 30)
	
	(unit_set_emotional_state johnson_x02 annoyed .5 30)
	(print "johnson - annoyed .5 30")
	
	(sleep 40)
	
	(unit_set_emotional_state johnson_x02 pensive 1 5)
	(print "johnson - pensive 1 5")
	
	)
	
(script dormant x02_0210_lhd
	(sleep 255)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0210_lhd hood_x02 1)
	(cinematic_subtitle x02_0210_lhd 1)
	)

(script dormant x02_0220_lhd
	(sleep 293)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0220_lhd hood_x02 1)
	(cinematic_subtitle x02_0220_lhd 5)
	)
	
(script dormant x02_0230_lhd
	(sleep 435)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0230_lhd hood_x02 1)
	(cinematic_subtitle x02_0230_lhd 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x02_04b
	
	(cinematic_lighting_set_primary_light 61 116 0.356863 0.317647 0.301961)
	(cinematic_lighting_set_secondary_light -28 54 0.207843 0.219608 0.258824)
	(cinematic_lighting_set_ambient_light 0.105882 0.101961 0.14902)
	
	(object_uses_cinematic_lighting medal_01 1)
	(object_uses_cinematic_lighting medal_02 1)
	(object_uses_cinematic_lighting medal_03 1)

	)

; ---------------------------------------------------------------------

(script static void x02_04b_setup
	
	(object_create_anew_containing medal)

	(cinematic_set_near_clip_distance .043)
	(print "setting near clip distance to .043")

	(wake x02_foley_04b)
	
	(wake x02_0170_lhd)
	(wake x02_0180_cor)
	(wake x02_0190_mas)
	(wake x02_0200_jon)
	(wake x02_0210_lhd)
	(wake x02_0220_lhd)
	(wake x02_0230_lhd)
	
	)

(script static void x02_scene_04b
	
	(x02_04b_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_04b" none "anchor_flag_x02_01")

	(custom_animation_relative chief_x02 objects\characters\masterchief\x02\x02 "chief_04b" false anchor_x02_01)
	(custom_animation_relative johnson_x02 objects\characters\marine\x02\x02 "johnson_04b" false anchor_x02_01)
	(custom_animation_relative hood_x02 objects\characters\lord_hood\x02\x02 "hood_04b" false anchor_x02_01)
	(custom_animation_relative cortana_x02 objects\characters\cortana\x02\x02 "cortana_04b" false anchor_x02_01)
	(custom_animation_relative marine_01 objects\characters\marine\x02\x02 "marine01_04b" false anchor_x02_01)

	(scenery_animation_start_relative x02_cortana_stand scenarios\objects\solo\spacestation\ss_stand_cortana\x02\x02 "cortana_stand_04b" anchor_x02_01)
	(scenery_animation_start_relative x02_medal_tray objects\cinematics\human\medals\medal_tray\x02\x02 "medal_tray_04b" anchor_x02_01)

	(scenery_animation_start_relative medal_01 objects\cinematics\Human\medals\colonial_cross\x02\x02 "cross1_04b" anchor_x02_01)
	(scenery_animation_start_relative medal_02 objects\cinematics\Human\medals\colonial_cross\x02\x02 "cross2_04b" anchor_x02_01)
	(scenery_animation_start_relative medal_03 objects\cinematics\Human\medals\colonial_cross\x02\x02 "cross3_04b" anchor_x02_01)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\music\x02_05_mus)
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_05_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	)
	
; X02 SCENE 05 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_score_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\music\x02_05_mus none 1)
	(print "x02 score 05 start")
	)

(script dormant x02_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_05_fol none 1)
	(print "x02 foley 05 start")
	)

(script dormant x02_0240_tar
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0240_tar tartarus 1)
	(cinematic_subtitle x02_0240_tar 3)
	)
	
(script dormant x02_0250_tar
	(sleep 88)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0250_tar tartarus 1)
	(cinematic_subtitle x02_0250_tar 3)
	)
	
(script dormant x02_0270_tar
	(sleep 245)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0270_tar tartarus 1)
	(cinematic_subtitle x02_0270_tar 2)
	(effect_new_on_object_marker effects\cinematics\02\charred_smoke_medium dervish "head")
	)

; LIGHTING & EFFECTS --------------------------------------------------

(script dormant effect_body_smoke
	(sleep 0)
	(print "effect - body smoke")
	(effect_new_on_object_marker effects\cinematics\02\charred_smoke_medium dervish "head")
	)

(script dormant cinematic_lighting_x02_05
	
	(cinematic_lighting_set_primary_light 90 248 0.345098 0.286275 0.270588)
	(cinematic_lighting_set_secondary_light 90 36 0.0784314 0.0745098 0.0901961)
	(cinematic_lighting_set_ambient_light 0.0509804 0.0509804 0.0509804)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting grunt_01 1)
	(object_uses_cinematic_lighting grunt_02 1)
	(object_uses_cinematic_lighting grunt_03 1)
	(object_uses_cinematic_lighting jackal_01 1)
	(object_uses_cinematic_lighting jackal_02 1)
	(object_uses_cinematic_lighting hunter_01 1)
	(object_uses_cinematic_lighting hunter_02 1)
	(object_uses_cinematic_lighting hunter_03 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	)

; ---------------------------------------------------------------------

(script static void x02_05_setup

	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew grunt_01)
	(object_create_anew grunt_02)
	(object_create_anew grunt_03)
	(object_create_anew jackal_01)
	(object_create_anew jackal_02)
	(object_create_anew hunter_01)
	(object_create_anew hunter_02)
	(object_create_anew hunter_03)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod grunt_01 true)
	(object_cinematic_lod grunt_02 true)
	(object_cinematic_lod grunt_03 true)
	(object_cinematic_lod jackal_01 true)
	(object_cinematic_lod jackal_02 true)
	(object_cinematic_lod hunter_01 true)
	(object_cinematic_lod hunter_02 true)
	(object_cinematic_lod hunter_03 true)
	
	(object_set_function_variable dervish "elite_burnt" 0 0)

	(cinematic_set_near_clip_distance .06)
	(print "resetting near clip distance to .06")	

	(wake x02_score_05)
	(wake x02_foley_05)
	
	(wake x02_0240_tar)
	(wake x02_0250_tar)
	(wake x02_0270_tar)

;	(wake x05_fov_02)
;	(wake x04_01_dof_1)
	(wake effect_body_smoke)

	(wake cinematic_lighting_x02_05)
	
	)
	
(script static void x02_05_cleanup
	(object_destroy dervish)
	(object_destroy brute_01)
	(object_destroy brute_02)
	(object_destroy grunt_01)
	(object_destroy grunt_02)
	(object_destroy grunt_03)
	(object_destroy jackal_01)
	(object_destroy jackal_02)
	(object_destroy hunter_01)
	(object_destroy hunter_02)
	(object_destroy hunter_03)
	)

(script static void x02_scene_05

	(cinematic_lightmap_shadow_disable)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x02_05_predict_stub)
	
	(x02_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_05" none "anchor_flag_x02_02")
	
	(custom_animation_relative dervish objects\characters\dervish\x02\x02 "dervish_05" false anchor_x02_02)
	(custom_animation_relative tartarus objects\characters\brute\x02\x02 "tartarus_05" false anchor_x02_02)
	
	(custom_animation_relative brute_01 objects\characters\brute\x02\x02 "brute01_05" false anchor_x02_02)
	(custom_animation_relative brute_02 objects\characters\brute\x02\x02 "brute02_05" false anchor_x02_02)
	(custom_animation_relative grunt_01 objects\characters\grunt\x02\x02 "grunt01_05" false anchor_x02_02)
	(custom_animation_relative grunt_02 objects\characters\grunt\x02\x02 "grunt02_05" false anchor_x02_02)
	(custom_animation_relative grunt_03 objects\characters\grunt\x02\x02 "grunt03_05" false anchor_x02_02)
	(custom_animation_relative jackal_01 objects\characters\jackal\x02\x02 "jackal01_05" false anchor_x02_02)
	(custom_animation_relative jackal_02 objects\characters\jackal\x02\x02 "jackal02_05" false anchor_x02_02)
	(custom_animation_relative hunter_01 objects\characters\hunter\x02\x02 "hunter01_05" false anchor_x02_02)
	(custom_animation_relative hunter_02 objects\characters\hunter\x02\x02 "hunter02_05" false anchor_x02_02)
	(custom_animation_relative hunter_03 objects\characters\hunter\x02\x02 "hunter03_05" false anchor_x02_02)
	
	(scenery_animation_start_relative x02_manacle_01 objects\cinematics\covenant\manacles\x02\x02 "manacle1_05" anchor_x02_02)
	(scenery_animation_start_relative x02_manacle_02 objects\cinematics\covenant\manacles\x02\x02 "manacle2_05" anchor_x02_02)
	
; 	safety white
	(sleep 30)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_06_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(x02_05_cleanup)
	
	)
	
; X02 SCENE 06 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_foley_06
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_06_fol none 1)
	(print "x02 foley 06 start")
	)

(script dormant x02_0280_lhd
	(sleep 165)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0280_lhd hood_x02 1)
	(cinematic_subtitle x02_0280_lhd 2)
	
	(unit_set_emotional_state miranda_x02 pensive .25 0)
	(print "miranda - pensive .25 0")
	
	)

(script dormant x02_0290_lhd
	(sleep 217)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0290_lhd hood_x02 1)
	(cinematic_subtitle x02_0290_lhd 4.5)
	)
	
(script dormant x02_0300_lhd
	(sleep 356)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0300_lhd hood_x02 1)
	(cinematic_subtitle x02_0300_lhd 6.5)
	)

(script dormant x02_0310_lhd
	(sleep 556)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0310_lhd hood_x02 1)
	(cinematic_subtitle x02_0310_lhd 2.5)
	
	(unit_set_emotional_state miranda_x02 shocked .25 60)
	(print "miranda - shocked .25 60")
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x02_06
	
	(cinematic_lighting_set_primary_light 61 116 0.356863 0.317647 0.301961)
	(cinematic_lighting_set_secondary_light -28 54 0.207843 0.219608 0.258824)
	(cinematic_lighting_set_ambient_light 0.105882 0.101961 0.14902)
	
	(object_uses_cinematic_lighting chief_x02 1)
	(object_uses_cinematic_lighting johnson_x02 1)
	(object_uses_cinematic_lighting hood_x02 1)
	(object_uses_cinematic_lighting miranda_x02 1)
	(object_uses_cinematic_lighting cortana_x02 1)
	(object_uses_cinematic_lighting marine_01 1)
	(object_uses_cinematic_lighting marine_02 1)
	(object_uses_cinematic_lighting marine_03 1)
	(object_uses_cinematic_lighting marine_04 1)
	(object_uses_cinematic_lighting medal_01 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)
	
	)

; CROWDS --------------------------------------------------------------

(script dormant x02_marine_crowd_03
	(sleep 0)
	(print "create marine crowd 02")
	(object_create_anew_containing x02_marine_prop_03)
	
	(object_uses_cinematic_lighting x02_marine_prop_03_01 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_02 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_03 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_04 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_05 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_06 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_07 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_08 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_09 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_10 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_11 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_12 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_13 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_14 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_16 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_17 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_18 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_19 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_20 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_21 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_22 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_23 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_24 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_25 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_26 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_27 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_28 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_29 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_30 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_31 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_32 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_33 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_34 1)
	(object_uses_cinematic_lighting x02_marine_prop_03_35 1)
	
	)

; ---------------------------------------------------------------------

(script static void x02_06_setup

	(object_create_anew chief_x02)
	(object_create_anew hood_x02)
	(object_create_anew cortana_x02)
	(object_create_anew miranda_x02)
	(object_create_anew johnson_x02)
	(object_create_anew marine_01)
	(object_create_anew marine_02)
	(object_create_anew marine_03)
	(object_create_anew marine_04)
	(object_create_anew medal_01)
	
	(object_cinematic_lod chief_x02 true)
	(object_cinematic_lod hood_x02 true)
	(object_cinematic_lod cortana_x02 true)
	(object_cinematic_lod miranda_x02 true)
	(object_cinematic_lod johnson_x02 true)
	(object_cinematic_lod marine_01 true)
	(object_cinematic_lod marine_02 true)
	(object_cinematic_lod marine_03 true)
	(object_cinematic_lod marine_04 true)
	(object_cinematic_lod medal_01 true)
	
	(object_set_permutation marine_01 "head" "perez")
	(object_set_permutation marine_02 "head" "smith")
	(object_set_permutation marine_03 "head" "walter")
	(object_set_permutation marine_04 "head" "dion")

	(wake x02_marine_crowd_03)

	(wake x02_foley_06)

	(wake x02_0280_lhd)
	(wake x02_0290_lhd)
	(wake x02_0300_lhd)
	(wake x02_0310_lhd)

;	(wake x05_fov_02)
;	(wake x04_01_dof_1)

	(wake cinematic_lighting_x02_06)
	
	)
	
(script static void x02_06_cleanup 

	(object_hide marine_01 true)
	(object_destroy_containing medal)
	(object_destroy_containing x02_marine_prop_03)
	
	)

(script static void x02_scene_06

	(cinematic_lightmap_shadow_enable)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x02_06_predict_stub)
	
	(x02_06_setup)
	(disable_render_light_suppressor)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_06" none "anchor_flag_x02_01")
	
	(custom_animation_relative chief_x02 objects\characters\masterchief\x02\x02 "chief_06" false anchor_x02_01)
	(custom_animation_relative johnson_x02 objects\characters\marine\x02\x02 "johnson_06" false anchor_x02_01)

	(custom_animation_relative hood_x02 objects\characters\lord_hood\x02\x02 "hood_06" false anchor_x02_01)
	(custom_animation_relative miranda_x02 objects\characters\miranda\x02\x02 "miranda_06" false anchor_x02_01)
	(custom_animation_relative cortana_x02 objects\characters\cortana\x02\x02 "cortana_06" false anchor_x02_01)

	(custom_animation_relative marine_01 objects\characters\marine\x02\x02 "marine01_06" false anchor_x02_01)
	(custom_animation_relative marine_02 objects\characters\marine\x02\x02 "marine02_06" false anchor_x02_01)
	(custom_animation_relative marine_03 objects\characters\marine\x02\x02 "marine03_06" false anchor_x02_01)
	(custom_animation_relative marine_04 objects\characters\marine\x02\x02 "marine04_06" false anchor_x02_01)
	
	(scenery_animation_start_relative x02_cortana_stand scenarios\objects\solo\spacestation\ss_stand_cortana\x02\x02 "cortana_stand_06" anchor_x02_01)	
	(scenery_animation_start_relative x02_medal_tray objects\cinematics\human\medals\medal_tray\x02\x02 "medal_tray_06" anchor_x02_01)
	(scenery_animation_start_relative medal_01 objects\cinematics\human\medals\colonial_cross\x02\x02 "cross1_06" anchor_x02_01)	
	(scenery_animation_start_relative x02_unsc_logo objects\cinematics\human\cairo_bridge_holoscreens\holo_display_unsc_logo\x02\x02 "unsc_logo_06" anchor_x02_01)

;	safety white
	(sleep 30)

	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\music\x02_08_mus)
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_07_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(enable_render_light_suppressor)
	(x02_06_cleanup)
	
	)
	
; X02 SCENE 07 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_score_08
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\music\x02_08_mus none 1)
	(print "x02 score 08 start")
	)

(script dormant x02_foley_07
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_07_fol none 1)
	(print "x02 foley 07 start")
	)

(script dormant x02_0320_der
	(sleep 540)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0320_der none 1)
	(cinematic_subtitle x02_0320_der 4)
	)
	
; EFFECTS -------------------------------------------------------------

(script dormant x02_07_dof_01
	
	(sleep 80)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 1.5 1 1 0 0 0 0)
	(print "rack focus")
	
	(sleep 70)
	(cinematic_screen_effect_set_depth_of_field 1.5 1 0 .5 0 1 .5)
	(print "rack focus")
	
	(sleep 80)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)
	
(script dormant effect_helmet_smoke
	(sleep 0)
	(print "effect - helmet smoke")
	(effect_new_on_object_marker effects\cinematics\02\charred_smoke_small x02_elite_helmet "head")
	)

(script dormant effect_brand
	(sleep 425)
	(effect_new_on_object_marker effects\objects\cinematics\branding_iron\branding_iron_burn branding_iron_02 "smoke")
	(print "ouch")
	)

(script dormant cinematic_lighting_x02_07
	
	(cinematic_lighting_set_primary_light 90 248 0.345098 0.286275 0.270588)
	(cinematic_lighting_set_secondary_light 90 36 0.0784314 0.0745098 0.0901961)
	(cinematic_lighting_set_ambient_light 0.0509804 0.0509804 0.0509804)
	
	(object_uses_cinematic_lighting dervish_nude 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting x02_elite_helmet 1)
	(object_uses_cinematic_lighting branding_iron_01 1)
	(object_uses_cinematic_lighting branding_iron_02 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	)

; ---------------------------------------------------------------------

(script dormant backup_brand
	(sleep 231)
	(scenery_animation_start_relative branding_iron_02 objects\cinematics\covenant\branding_iron\x02\x02 "branding_iron01_07" anchor_x02_02)
	)

(script dormant bring_back_brand
	(sleep 90)
	(object_hide branding_iron_02 false)
	)

(script dormant delete_brand
	(sleep 363)
	(print "destroy branding-iron")
	(object_destroy branding_iron_01)
	)
	
(script dormant emotion_tartarus_07
	(sleep 180)
	(unit_set_emotional_state tartarus pensive 1 0)
	(print "tartarus - pensive 1 0")
	
	(sleep 63)
	(unit_set_emotional_state tartarus amorous 1 30)
	(print "tartaurs - amorous 1 30")
	
	)

(script static void x02_07_setup

	(object_create_anew dervish_nude)
	(object_create_anew tartarus)
	(object_create_anew x02_elite_helmet)
	(object_create_anew branding_iron_01)
	(object_create_anew branding_iron_02)
	
	(object_create_anew_containing cov_crowd_02)
	(wake delete_brand)
	
	(object_cinematic_lod dervish_nude true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod branding_iron_01 true)
	(object_cinematic_lod branding_iron_02 true)

	(wake x02_foley_07)

	(wake x02_0320_der)
	
;	(wake x02_07_dof_01)
	(wake effect_helmet_smoke)
	(wake backup_brand)
	(wake effect_brand)
	(wake cinematic_lighting_x02_07)
	
	(wake emotion_tartarus_07)
	
	)
	
(script static void x02_07_cleanup
	
	(object_destroy dervish_nude)
	(object_destroy tartarus)
	(object_destroy_containing cov_crowd_02)
	
	(object_destroy x02_elite_helmet)
	(object_destroy_containing branding)
	(object_destroy_containing x02_column)
	(object_destroy_containing x02_manacle)
	(object_destroy_containing x02_dervish_lift)
	
	)

(script static void x02_scene_07

	(cinematic_lightmap_shadow_disable)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x02_07_predict_stub)
	
	(x02_07_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_07" none "anchor_flag_x02_02")
	
	(custom_animation_relative dervish_nude objects\characters\dervish\x02_alt\x02_alt "dervish_07" false anchor_x02_02)
	(custom_animation_relative tartarus objects\characters\brute\x02\x02 "tartarus_07" false anchor_x02_02)
	
	(scenery_animation_start_relative x02_elite_helmet objects\cinematics\covenant\elite_helmet_charred\elite_helmet_charred "helmet_charred_07" anchor_x02_02)
	(scenery_animation_start_relative branding_iron_01 objects\cinematics\covenant\branding_iron\x02\x02 "branding_iron02_07" anchor_x02_02)
	(scenery_animation_start_relative x02_manacle_01 objects\cinematics\covenant\manacles\x02\x02 "manacle1_07" anchor_x02_02)
	(scenery_animation_start_relative x02_manacle_02 objects\cinematics\covenant\manacles\x02\x02 "manacle2_07" anchor_x02_02)
	(object_hide branding_iron_02 true)
	(wake bring_back_brand)	

;	safe white
	(sleep 5)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_08_fol)
	
	(wake x02_score_08)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(x02_07_cleanup)
	
	)
	
; X02 SCENE 08 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x02_foley_08
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_08_fol none 1)
	(print "x02 foley 08 start")
	)

(script dormant x02_0330_cor

	(sleep 1)
	
	(unit_set_emotional_state hood_x02 shocked .25 0)
	(unit_set_emotional_state cortana_x02 angry .5 0)

	(sleep 71)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0330_cor cortana_x02 1)
	(cinematic_subtitle x02_0330_cor 3)
	
	)

(script dormant x02_0340_lhd

	(unit_set_emotional_state hood_x02 angry .5 15)
	(print "hood - angry .5 15")

	(sleep 150)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0340_lhd hood_x02 1)
	(cinematic_subtitle x02_0340_lhd 1)
	)
	
(script dormant x02_0350_cor
	(sleep 180)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0350_cor cortana_x02 1)
	(cinematic_subtitle x02_0350_cor 4)
	)
	
(script dormant x02_0360_ahp
	(sleep 311)
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\cinematic\x02_0360_ahp none 1 radio_default)
	(cinematic_subtitle x02_0360_ahp 3)
	)
	
(script dormant x02_0370_lhd

	(unit_set_emotional_state hood_x02 pensive .5 15)
	(print "hood - pensive .5 15")
	
	(unit_set_emotional_state miranda_x02 shocked .15 0)

	(sleep 415)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0370_lhd hood_x02 1)
	(cinematic_subtitle x02_0370_lhd 4)	
	)
	
(script dormant x02_0380_lhd
	(sleep 548)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0380_lhd hood_x02 1)
	(cinematic_subtitle x02_0380_lhd 2.5)
	
	(sleep 75)
	
	(unit_set_emotional_state miranda_x02 angry .5 15)
	(print "miranda - angry .5 15")
	
	)

(script dormant x02_0390_mir
	(sleep 632)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0390_mir miranda_x02 1)
	(cinematic_subtitle x02_0390_mir 1)
	)

(script dormant x02_0400_lhd
	(sleep 676)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0400_lhd hood_x02 1)
	(cinematic_subtitle x02_0400_lhd 4)
	)
	
(script dormant x02_0405_cor
	(sleep 793)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0405_cor cortana_x02 1)
	(cinematic_subtitle x02_0405_cor 1)
	)
	
(script dormant x02_0410_lhd
	(sleep 825)
	
	(unit_set_emotional_state hood_x02 annoyed .75 60)
	(print "hood - annoyed .75 60")
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0410_lhd hood_x02 1)
	(cinematic_subtitle x02_0410_lhd 5)
	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_cortana_off
	(sleep 809)
	(print "cortana off")
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off x02_cortana_stand "holo_effect")
	)

(script dormant cinematic_lighting_x02_08
	
	(cinematic_lighting_set_primary_light 61 116 0.356863 0.317647 0.301961)
	(cinematic_lighting_set_secondary_light -28 54 0.207843 0.219608 0.258824)
	(cinematic_lighting_set_ambient_light 0.105882 0.101961 0.14902)
	
	(object_uses_cinematic_lighting chief_x02 1)
	(object_uses_cinematic_lighting johnson_x02 1)
	(object_uses_cinematic_lighting hood_x02 1)
	(object_uses_cinematic_lighting miranda_x02 1)
	(object_uses_cinematic_lighting cortana_x02 1)
	(object_uses_cinematic_lighting marine_02 1)
	(object_uses_cinematic_lighting marine_03 1)
	(object_uses_cinematic_lighting marine_04 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)
	
	)
	
; ---------------------------------------------------------------------

(script static void x02_08_setup

	(object_create chief_x02)
	(object_create_anew hood_x02)
	(object_create_anew cortana_x02)
	(object_create_anew miranda_x02)
	(object_create_anew johnson_x02)
	(object_create_anew marine_02)
	(object_create_anew marine_03)
	(object_create_anew marine_04)
	
	(object_create_anew x02_tactical_display)
	
	(object_cinematic_lod chief_x02 true)
	(object_cinematic_lod hood_x02 true)
	(object_cinematic_lod cortana_x02 true)
	(object_cinematic_lod miranda_x02 true)
	(object_cinematic_lod johnson_x02 true)
	(object_cinematic_lod marine_02 true)
	(object_cinematic_lod marine_03 true)
	(object_cinematic_lod marine_04 true)
	
	(object_set_permutation marine_02 "head" "smith")
	(object_set_permutation marine_03 "head" "walter")
	(object_set_permutation marine_04 "head" "dion")
	
	(wake x02_foley_08)
	
	(wake x02_0330_cor)
	(wake x02_0340_lhd)
	(wake x02_0350_cor)
	(wake x02_0360_ahp)
	(wake x02_0370_lhd)
	(wake x02_0380_lhd)
	(wake x02_0390_mir)
	(wake x02_0400_lhd)
	(wake x02_0405_cor)
	(wake x02_0410_lhd)
	
	(wake effect_cortana_off)

;	(wake x05_fov_02)
;	(wake x04_01_dof_1)

	(wake cinematic_lighting_x02_08)
	
	)
	
(script static void x02_scene_08_cleanup

	(object_destroy miranda_x02)
	(object_destroy cortana_x02)
	(object_destroy marine_02)
	(object_destroy marine_03)
	(object_destroy marine_04)
	
	)

(script static void x02_scene_08

	(cinematic_lightmap_shadow_enable)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x02_08_predict_stub)
	
	(x02_08_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_08" none "anchor_flag_x02_01")
	
	(custom_animation_relative chief_x02 objects\characters\masterchief\x02\x02 "chief_08" false anchor_x02_01)
	(custom_animation_relative johnson_x02 objects\characters\marine\x02\x02 "johnson_08" false anchor_x02_01)

	(custom_animation_relative hood_x02 objects\characters\lord_hood\x02\x02 "hood_08" false anchor_x02_01)
	(custom_animation_relative miranda_x02 objects\characters\miranda\x02\x02 "miranda_08" false anchor_x02_01)
	(custom_animation_relative cortana_x02 objects\characters\cortana\x02\x02 "cortana_08" false anchor_x02_01)

	(custom_animation_relative marine_02 objects\characters\marine\x02\x02 "marine02_08" false anchor_x02_01)
	(custom_animation_relative marine_03 objects\characters\marine\x02\x02 "marine03_08" false anchor_x02_01)
	(custom_animation_relative marine_04 objects\characters\marine\x02\x02 "marine04_08" false anchor_x02_01)
	
	(scenery_animation_start_relative x02_cortana_stand scenarios\objects\solo\spacestation\ss_stand_cortana\x02\x02 "cortana_stand_08" anchor_x02_01)
	(scenery_animation_start_relative x02_unsc_logo objects\cinematics\human\cairo_bridge_holoscreens\holo_display_unsc_logo\x02\x02 "unsc_logo_08" anchor_x02_01)
	(scenery_animation_start_relative x02_tactical_display objects\cinematics\human\cairo_bridge_holoscreens\holo_display_large\x02\x02 "display_large_08" anchor_x02_01)

;	safety white
	(sleep 30)

	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x02_09_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_09_fol)
	
	(sleep (camera_time))
	
	(x02_scene_08_cleanup)
	
	)
	
; X02 SCENE 09 --------------------------------------------------------
; AI ------------------------------------------------------------------

(script command_script cs_x02_panic_01
	
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(sleep_until
		(begin
			(cs_go_to x02_run/p0)
			(cs_look true x02_look/p0)
			(sleep 60)
			(cs_go_to x02_run/p1)
			(cs_look true x02_look/p1)
		false)
	)
)

(script command_script cs_x02_panic_02
	
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(sleep_until
		(begin
			(cs_go_to x02_run/p2)
			(cs_look true x02_look/p2)
			(sleep 60)
			(cs_go_to x02_run/p3)
			(cs_look true x02_look/p3)
		false)
	)
)

(script command_script cs_x02_panic_03
	
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(sleep_until
		(begin
			(cs_go_to x02_run/p0)
			(cs_look true x02_look/p0)
			(sleep 60)
			(cs_go_to x02_run/p2)
			(cs_look true x02_look/p2)
		false)
	)
)

(script command_script cs_x02_panic_04
	
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(sleep_until
		(begin
			(cs_go_to x02_run/p3)
			(cs_look true x02_look/p3)
			(sleep 60)
			(cs_go_to x02_run/p1)
			(cs_look true x02_look/p1)
		false)
	)
)

; SOUND ---------------------------------------------------------------

(script dormant x02_foley_09
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_09_fol none 1)
	(print "x02 foley 09 start")
	)

(script dormant x02_0420_to1
	(sleep 107)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0420_to1 none 1)
	(cinematic_subtitle x02_0420_to1 1.5)
	
	(unit_set_emotional_state marine_01 annoyed .5 0)
	(unit_set_emotional_state marine_01 pensive .5 0)
	
	(sleep 45)
	
	(unit_set_emotional_state marine_01 annoyed 1 10)
	
	)
	
(script dormant x02_0430_to1
	(sleep 159)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0430_to1 marine_01 1)
	(cinematic_subtitle x02_0430_to1 1.5)
	
	(sleep 10)
	
	(unit_set_emotional_state marine_01 shocked .25 0)
	(print "marine_01 - shocked .5 0")
	
	)

(script dormant x02_0440_lhd
	(sleep 208)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0440_lhd hood_x02 1)
	(cinematic_subtitle x02_0440_lhd 5)
	)

(script dormant x02_0450_lhd
	(sleep 367)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0450_lhd hood_x02 1)
	(cinematic_subtitle x02_0450_lhd 3)
	)

(script dormant x02_0460_mas
	(sleep 462)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0460_mas chief_x02 1)
	(cinematic_subtitle x02_0460_mas 1)
	)

(script dormant x02_0480_mas
	(sleep 497)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0480_mas chief_x02 1)
	(cinematic_subtitle x02_0480_mas 1)
	)

(script dormant x02_0490_jon
	(sleep 529)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x02_0490_jon johnson_x02 1)
	(cinematic_subtitle x02_0490_jon 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x02_09

	(cinematic_lighting_set_primary_light 61 116 0.356863 0.317647 0.301961)
	(cinematic_lighting_set_secondary_light -28 54 0.207843 0.219608 0.258824)
	(cinematic_lighting_set_ambient_light 0.105882 0.101961 0.14902)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)

	)

(script dormant x02_fov_09_01
	(sleep 166)
	(camera_set_field_of_view 23 10)
	(print "fov change: 60 -> 23 over 10 ticks")
	)
	
(script dormant x02_fov_09_02
	(sleep 206)
	(camera_set_field_of_view 60 0)
	(print "fov change: 23 -> 60 over 0 ticks")
	)

; ---------------------------------------------------------------------

(script static void place_x02_ai
	(ai_place x02_panic_01)
	(ai_place x02_panic_02)
	(ai_place x02_panic_03)
	(ai_place x02_panic_04)
	)

(script dormant x02_09_setup

	(object_hide marine_01 false)
;	(object_cinematic_lod marine_01 true)
;	(object_uses_cinematic_lighting marine_01 1)
;	(object_set_permutation marine_01 "head" "dion")

	(wake x02_foley_09)

	(wake x02_0420_to1)
	(wake x02_0430_to1)
	(wake x02_0440_lhd)
	(wake x02_0450_lhd)
	(wake x02_0460_mas)
	(wake x02_0480_mas)
	(wake x02_0490_jon)
	
	(place_x02_ai)
	
	(wake x02_fov_09_01)
	(wake x02_fov_09_02)
	(wake cinematic_lighting_x02_09)
	
	)

(script static void x02_scene_09

	(wake x02_09_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_09" none "anchor_flag_x02_01")
	
	(custom_animation_relative chief_x02 objects\characters\masterchief\x02\x02 "chief_09" false anchor_x02_01)
	(custom_animation_relative johnson_x02 objects\characters\marine\x02\x02 "johnson_09" false anchor_x02_01)
	(custom_animation_relative hood_x02 objects\characters\lord_hood\x02\x02 "hood_09" false anchor_x02_01)
	(custom_animation_relative marine_01 objects\characters\marine\x02\x02 "marine01_09" false anchor_x02_01)
	
	(scenery_animation_start_relative x02_tactical_display objects\cinematics\human\cairo_bridge_holoscreens\holo_display_large\x02\x02 "display_large_09" anchor_x02_01)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x02_10_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x02\foley\x02_10_fol)
	
	(sleep (camera_time))
	
	(object_destroy marine_01)
	
	)
	
; X02 SCENE 10 --------------------------------------------------------

(script dormant x02_foley_10
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x02\foley\x02_10_fol none 1)
	(print "x02 foley 10 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x02_10
	
	(cinematic_lighting_set_primary_light 61 116 0.356863 0.317647 0.301961)
	(cinematic_lighting_set_secondary_light -28 54 0.207843 0.219608 0.258824)
	(cinematic_lighting_set_ambient_light 0.105882 0.101961 0.14902)
	
	(object_uses_cinematic_lighting poa_x02 1)
	(object_uses_cinematic_lighting fighter_x02_01 1)
	(object_uses_cinematic_lighting fighter_x02_02 1)
	(object_uses_cinematic_lighting fighter_x02_03 1)
	(object_uses_cinematic_lighting fighter_x02_04 1)
	(object_uses_cinematic_lighting fighter_x02_05 1)
	(object_uses_cinematic_lighting fighter_x02_06 1)
	(object_uses_cinematic_lighting fighter_x02_07 1)
	(object_uses_cinematic_lighting fighter_x02_08 1)
	
	)
	
; ---------------------------------------------------------------------

(script dormant fighters_unhide
	(sleep 5)
	(print "fighters unhide")
	(object_hide fighter_x02_01 false)
	(object_hide fighter_x02_02 false)
	(object_hide fighter_x02_03 false)
	(object_hide fighter_x02_04 false)
	(object_hide fighter_x02_05 false)
	(object_hide fighter_x02_06 false)
	(object_hide fighter_x02_07 false)
	(object_hide fighter_x02_08 false)
	)

(script static void x02_10_setup

	(object_create poa_x02)
	(object_create fighter_x02_01)
	(object_create fighter_x02_02)
	(object_create fighter_x02_03)
	(object_create fighter_x02_04)
	(object_create fighter_x02_05)
	(object_create fighter_x02_06)
	(object_create fighter_x02_07)
	(object_create fighter_x02_08)

	(object_cinematic_lod poa_x02 true)
	(object_cinematic_lod fighter_x02_01 true)
	(object_cinematic_lod fighter_x02_02 true)
	(object_cinematic_lod fighter_x02_03 true)
	(object_cinematic_lod fighter_x02_04 true)
	(object_cinematic_lod fighter_x02_05 true)
	(object_cinematic_lod fighter_x02_06 true)
	(object_cinematic_lod fighter_x02_07 true)
	(object_cinematic_lod fighter_x02_08 true)
	
	(object_hide fighter_x02_01 true)
	(object_hide fighter_x02_02 true)
	(object_hide fighter_x02_03 true)
	(object_hide fighter_x02_04 true)
	(object_hide fighter_x02_05 true)
	(object_hide fighter_x02_06 true)
	(object_hide fighter_x02_07 true)
	(object_hide fighter_x02_08 true)

	(wake x02_foley_10)

;	(wake x05_fov_02)
;	(wake x04_01_dof_1)

	(wake fighters_unhide)
	
	(wake cinematic_lighting_x02_10)
	
	)
	
(script static void x02_scene_10_cleanup

	(object_destroy chief_x02)
	(object_destroy johnson_x02)
	(object_destroy hood_x02)
	(object_destroy x02_cortana_stand)
	(object_destroy x02_tactical_display)
	(object_destroy poa_x02)
	(object_destroy_containing fighter_x02)
	
	)

(script static void x02_scene_10
	
	(x02_10_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x02\x02 "x02_10" none "anchor_flag_x02_01")
	
	(custom_animation_relative chief_x02 objects\characters\masterchief\x02\x02 "chief_10" false anchor_x02_01)
	(custom_animation_relative johnson_x02 objects\characters\marine\x02\x02 "johnson_10" false anchor_x02_01)
	(custom_animation_relative hood_x02 objects\characters\lord_hood\x02\x02 "hood_10" false anchor_x02_01)
	
	(scenery_animation_start_relative x02_cortana_stand scenarios\objects\solo\spacestation\ss_stand_cortana\x02\x02 "cortana_stand_10" anchor_x02_01)
	(scenery_animation_start_relative x02_tactical_display objects\cinematics\human\cairo_bridge_holoscreens\holo_display_large\x02\x02 "display_large_10" anchor_x02_01)
	
	(scenery_animation_start_relative poa_x02 objects\cinematics\human\pillarofautumn\x02\x02 "poa_10" anchor_x02_01)
	(scenery_animation_start_relative fighter_x02_01 objects\vehicles\longsword\x02\x02 "longsword01_10" anchor_x02_01)
	(scenery_animation_start_relative fighter_x02_02 objects\vehicles\longsword\x02\x02 "longsword02_10" anchor_x02_01)
	(scenery_animation_start_relative fighter_x02_03 objects\vehicles\longsword\x02\x02 "longsword03_10" anchor_x02_01)
	(scenery_animation_start_relative fighter_x02_04 objects\vehicles\longsword\x02\x02 "longsword04_10" anchor_x02_01)
	(scenery_animation_start_relative fighter_x02_05 objects\vehicles\longsword\x02\x02 "longsword05_10" anchor_x02_01)
	(scenery_animation_start_relative fighter_x02_06 objects\vehicles\longsword\x02\x02 "longsword06_10" anchor_x02_01)
	(scenery_animation_start_relative fighter_x02_07 objects\vehicles\longsword\x02\x02 "longsword07_10" anchor_x02_01)
	(scenery_animation_start_relative fighter_x02_08 objects\vehicles\longsword\x02\x02 "longsword08_10" anchor_x02_01)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(x02_scene_10_cleanup)
	
	(sleep 30)
	
	)

; X02 MASTER SCRIPT ===================================================
; =====================================================================


(script static void x02
	
	(texture_cache_flush)
	(geometry_cache_flush)
	
	(cinematic_enable_ambience_details false)
	(sound_class_set_gain device_machinery 0 15)
	
	(switch_bsp_by_name 01_bsp_0)
	(sleep 1)
	
	(x02_scene_01)
	
	(switch_bsp_by_name high_0)
	(sleep 5)
	(x02_scene_02)
	(x02_scene_03)
	
	(switch_bsp_by_name 01_bsp_1)
	(sleep 5)
	(x02_scene_04a)
	(x02_scene_04b)
	
	(switch_bsp_by_name high_0)
	(sleep 5)
	(x02_scene_05)
	
	(switch_bsp_by_name 01_bsp_1)
	(sleep 5)
	(x02_scene_06)
	
	(switch_bsp_by_name high_0)
	(sleep 5)
	(x02_scene_07)
	
	(switch_bsp_by_name 01_bsp_1)
	(sleep 5)
	(x02_scene_08)
	(x02_scene_09)
	(x02_scene_10)
	
	(sound_class_set_gain device_machinery 1 15)	
	
	(rasterizer_bloom_override 0)

	)

; C01_OUTRO SCENE 01 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_score_01
	(sleep 259)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\music\c01_outro_01_mus none 1)
	(print "c01_outro score 01 start")
	)
	
(script dormant c01_outro_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_01_fol none 1)
	(print "c01_outro foley 01 start")
	)

(script dormant c01_9010_cor
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9010_cor cortana 1)
	(cinematic_subtitle c01_9010_cor 2)
	)
	
(script dormant c01_9050_mas
	(sleep 311)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9050_mas chief 1)
	(cinematic_subtitle c01_9050_mas 2)
	)
	
(script dormant c01_9060_cor
	(sleep 349)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9060_cor none 1)
	(cinematic_subtitle c01_9060_cor 2)
	)
	
(script dormant c01_9070_mir
	(sleep 393)
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\cinematic\c01_9070_mir none 1 radio_default)
	(cinematic_subtitle c01_9070_mir 2)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_outro_01
	
	(cinematic_lighting_set_primary_light 33 188 0.388235 0.380392 0.372549)
	(cinematic_lighting_set_secondary_light -28 54 0.207843 0.219608 0.258824)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting cortana 1)
	(object_uses_cinematic_lighting pickle 1)
	(object_uses_cinematic_lighting outro_cortana_stand 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)
	
	)
	
(script dormant effects_cortana_transfer
	(sleep 125)
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off outro_cortana_base "marker")
	(sleep 20)
	(effect_new_on_object_marker effects\objects\characters\masterchief\data_transfer chief "right_hand")
	)
	
(script static void test
		(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off outro_cortana_base "marker")
	)
	
(script dormant bomb_deactivate
	(sleep 284)
	(print "bomb deactivate")
	(object_set_function_variable pickle "flare" 0 1)
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void c01_outro_02_problem_actors

	(print "problem actors")
	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_create_anew iac_bridge_outro_01)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod iac_bridge_outro_01 true)

	)

; ---------------------------------------------------------------------

(script dormant upload_cortana
	(time_code_reset)
	(sleep 135)
	(print "upload cortana")
	(object_destroy cortana)
	)

(script static void c01_outro_01_setup

	(object_create_anew chief)
	(object_create_anew cortana)
	(object_create_anew pickle)
	(object_create_anew outro_cortana_stand)
	(object_create_anew outro_cortana_base)
	
	(object_destroy_containing outro_crate)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod cortana true)
	(object_cinematic_lod pickle true)
	(object_cinematic_lod outro_cortana_stand true)

	(wake c01_outro_score_01)
	(wake c01_outro_foley_01)

	(wake c01_9010_cor)
	(wake c01_9050_mas)
	(wake c01_9060_cor)
	(wake c01_9070_mir)
	
	(wake effects_cortana_transfer)
	(wake upload_cortana)
	(wake bomb_deactivate)
	
;	(wake x05_fov_02)
;	(wake x04_01_dof_1)

	(wake cinematic_lighting_outro_01)
	
	)
	
(script static void c01_outro_01_cleanup
	
	(object_destroy outro_cortana_stand)
	(object_destroy outro_cortana_base)
	
	)

(script static void c01_outro_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x02_01_predict_stub)
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\music\c01_outro_01_mus)
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_01_fol)
	(sleep prediction_offset)

	(c01_outro_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_01" none "anchor_flag_outro1")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_01" false anchor_outro1)
	(custom_animation_relative cortana objects\characters\cortana\01_outro\01_outro "cortana_01" false anchor_outro1)
	
	(scenery_animation_start_relative pickle scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_01" anchor_outro1)
	(scenery_animation_start_relative outro_cortana_stand scenarios\objects\solo\spacestation\ss_stand_cortana\01_outro\01_outro "cortana_stand_01" anchor_outro1)

	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off outro_cortana_base "marker")

	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_outro_02_predict_stub)
	(c01_outro_02_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_02_fol)	
	
	(sleep (camera_time))
	
	(c01_outro_01_cleanup)
	
	)
	
; C01_OUTRO SCENE 02 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_02_fol none 1)
	(print "c01_outro foley 02 start")
	)

(script dormant c01_9080_mir
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9080_mir miranda 1)
	(cinematic_subtitle c01_9080_mir 3)
	
	(sleep 1)
	(unit_set_emotional_state miranda pain .25 0)
	(unit_set_emotional_state hood annoyed .5 0)
	
	)
	
(script dormant c01_9090_lhd
	(sleep 113)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9090_lhd hood 1)
	(cinematic_subtitle c01_9090_lhd 4)
	)
	
(script dormant c01_9100_mas
	(sleep 227)
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\cinematic\c01_9100_mas none 1 radio_default)
	(cinematic_subtitle c01_9100_mas 1)
	)
	
(script dormant c01_9110_mas
	(sleep 250)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9110_mas chief 1)
	(cinematic_subtitle c01_9110_mas 1)
	)
	
(script dormant c01_9120_lhd
	(sleep 290)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9120_lhd hood 1)
	(cinematic_subtitle c01_9120_lhd 2)
	)
	
(script dormant c01_9130_mas
	(sleep 343)
	(sound_impulse_start_effect sound\dialog\levels\01_spacestation\cinematic\c01_9130_mas none 1 radio_default)
	(cinematic_subtitle c01_9130_mas 2)
	
	(sleep 77)
	
	(unit_set_emotional_state hood happy .25 90)
	(print "hood - happy .25 90")
	
	)
	
(script dormant c01_9140_lhd
	(sleep 436)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9140_lhd hood 1)
	(cinematic_subtitle c01_9140_lhd 1)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_bridges_01a
	(time_code_reset)

	(print "light miranda")

	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -73 160 0.117647 0.117647 0.176471)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)

	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting iac_bridge_outro_01 1)
	
	)
	
(script dormant cinematic_lighting_bridges_01b

	(sleep 111)
	(print "light hood")

     (cinematic_lighting_set_primary_light -21 102 0.368627 0.333333 0.258824)
     (cinematic_lighting_set_secondary_light 13 294 0.192157 0.2 0.243137)
     (cinematic_lighting_set_ambient_light 0.00784314 0.00784314 0.00784314)

	(object_uses_cinematic_lighting hood 1)
	(object_uses_cinematic_lighting cairo_bridge 1)
	
	)
	
(script dormant cinematic_lighting_chief_01

	(sleep 240)
	(print "light chief")
	
     (cinematic_lighting_set_primary_light -12 294 0.47451 0.419608 0.392157)
     (cinematic_lighting_set_secondary_light -39 296 0.156863 0.137255 0.262745)
     (cinematic_lighting_set_ambient_light 0 0 0)
 
     (object_uses_cinematic_lighting pickle 1)

	)
	
(script dormant cinematic_lighting_bridges_02
	
	(sleep 288)
	(print "light hood")
	
     (cinematic_lighting_set_primary_light -21 102 0.368627 0.333333 0.258824)
     (cinematic_lighting_set_secondary_light 13 294 0.192157 0.2 0.243137)
     (cinematic_lighting_set_ambient_light 0.00784314 0.00784314 0.00784314)

	)

; ---------------------------------------------------------------------

(script static void c01_outro_02_setup

	(object_create_anew hood)
	(object_create_anew cairo_bridge)
	
	(object_cinematic_lod hood true)
	(object_cinematic_lod cairo_bridge true)
	
	(wake c01_outro_foley_02)

	(wake c01_9080_mir)
	(wake c01_9090_lhd)
	(wake c01_9100_mas)
	(wake c01_9110_mas)
	(wake c01_9120_lhd)
	(wake c01_9130_mas)
	(wake c01_9140_lhd)
	
	(wake cinematic_lighting_bridges_01a)
	(wake cinematic_lighting_bridges_01b)
	(wake cinematic_lighting_chief_01)
	(wake cinematic_lighting_bridges_02)
	
	)
	
(script static void c01_outro_02_cleanup
	
	(object_destroy hood)
	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy iac_bridge_outro_01)
	(object_destroy cairo_bridge)

	)

(script static void c01_outro_scene_02

	(pvs_set_object anchor_outro1)
	
	(c01_outro_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_02" none "anchor_flag_outro1")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_02" false anchor_outro1)
	(custom_animation_relative miranda objects\characters\miranda\01_outro\01_outro "miranda_02" false anchor_outro1)
	(custom_animation_relative johnson objects\characters\marine\01_outro\01_outro "johnson_02" false anchor_outro1)
	(custom_animation_relative hood objects\characters\lord_hood\01_outro\01_outro "hood_02" false anchor_outro1)
	
	(scenery_animation_start_relative pickle scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_02" anchor_outro1)
	(scenery_animation_start_relative iac_bridge_outro_01 objects\cinematics\human\inamberclad_bridge\01_outro\01_outro "iac_bridge_02" anchor_outro1)
	(scenery_animation_start_relative cairo_bridge objects\cinematics\Human\cairo_bridge\01_outro\01_outro "cairo_bridge_02" anchor_outro1)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_outro_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_03_fol)
	
	(sleep (camera_time))
	
	(c01_outro_02_cleanup)
	
	)
	
; C01_OUTRO SCENE 03 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_03_fol none 1)
	(print "c01_outro foley 03 start")
	)
	
(script dormant doors_outro_03

	(device_set_position outro_door_01 1)
	(sleep 360)
	(device_group_change_only_once_more_set outro_door_01 false)
	(device_set_position outro_door_01 0)	
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant outro_sparks_03

	(sleep 101)
	
	(object_create_anew_containing sparks_backward)
	
	(objects_attach pickle "sparks01" sparks_backward_01 "marker")
	(objects_attach pickle "sparks03" sparks_backward_02 "marker")
	(objects_attach pickle "sparks04" sparks_backward_03 "marker")
	(objects_attach pickle "sparks07" sparks_backward_04 "marker")
	(objects_attach pickle "sparks08" sparks_backward_05 "marker")

	(sleep 36)
	
	(object_destroy_containing sparks_backward)
	
	(sleep 25)
	
	(object_create_anew_containing sparks_backward)
	
	(objects_attach pickle "sparks01" sparks_backward_01 "marker")
	(objects_attach pickle "sparks03" sparks_backward_02 "marker")
	(objects_attach pickle "sparks04" sparks_backward_03 "marker")
	(objects_attach pickle "sparks07" sparks_backward_04 "marker")
	(objects_attach pickle "sparks08" sparks_backward_05 "marker")
	
	)
	
(script dormant cinematic_lighting_chief_02
	
	(print "light chief")
	(cinematic_lighting_set_primary_light 33 188 0.388235 0.380392 0.372549)
	(cinematic_lighting_set_secondary_light -28 54 0.207843 0.219608 0.258824)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(object_uses_cinematic_lighting outro_elevator 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c01_outro_03_setup

	(wake c01_outro_foley_03)

	(object_create_anew outro_elevator)
	(object_cinematic_lod outro_elevator true)
	
	(wake doors_outro_03)
	(wake outro_sparks_03)
	
	(wake cinematic_lighting_chief_02)
	
	)

(script static void c01_outro_03_cleanup

	(object_destroy_containing sparks_backward)
	
	)

(script static void c01_outro_scene_03
	
	(c01_outro_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_03" none "anchor_flag_outro1")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_03" false anchor_outro1)
	(scenery_animation_start_relative pickle scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_03" anchor_outro1)
	(scenery_animation_start_relative outro_elevator objects\cinematics\human\ss_elevator\01_outro\01_outro "elevator_03" anchor_outro1)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_outro_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_04_fol)
	
	(sleep (camera_time))
	
	(c01_outro_03_cleanup)
	
	)

; C01_OUTRO SCENE 04 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_04_fol none 1)
	(print "c01_outro foley 04 start")
	)

(script dormant c01_9150_cor
	(sleep 30)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9150_cor none 1)
	(cinematic_subtitle c01_9150_cor 2)
	)
	
(script dormant c01_9160_mas
	(sleep 108)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9160_mas chief 1)
	(cinematic_subtitle c01_9160_mas 2)
	)
	
(script dormant c01_9170_cor
	(sleep 154)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9170_cor none 1)
	(cinematic_subtitle c01_9170_cor 2)
	)

(script dormant c01_9180_cor
	(sleep 217)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9180_cor none 1)
	(cinematic_subtitle c01_9180_cor 1)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c01_outro_shake_04_01
	(time_code_reset)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(player_effect_stop 1)
	)
	
(script dormant c01_outro_shake_04_02
	(sleep 105)
	(print "shake")
	(player_effect_set_max_rotation 0 .35 .35)
	(player_effect_start .25 0)
	(sleep 93)
	(player_effect_stop 0)
	(print "shake stop")
	)
	
(script dormant c01_outro_shake_04_03
	(sleep 227)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 2)
	(sleep 45)
	(player_effect_stop 0)
	(print "shake stop")
	)
	
(script dormant outro_sparks_03_04
	
	(object_create_anew_containing sparks_forward)
	
	(objects_attach pickle "sparks01" sparks_forward_01 "marker")
	(objects_attach pickle "sparks02" sparks_forward_02 "marker")
	(objects_attach pickle "sparks03" sparks_forward_03 "marker")
	(objects_attach pickle "sparks04" sparks_forward_04 "marker")
	(objects_attach pickle "sparks05" sparks_forward_05 "marker")
	(objects_attach pickle "sparks06" sparks_forward_06 "marker")
	(objects_attach pickle "sparks07" sparks_forward_07 "marker")
	(objects_attach pickle "sparks08" sparks_forward_08 "marker")

	(sleep 490)
	
	(object_destroy_containing sparks_forward)
	
	)
	
; ---------------------------------------------------------------------

(script dormant doors_outro_04

	(sleep 300)
	(device_set_position outro_door_02 1)
	(sleep 150)
	(device_group_change_only_once_more_set outro_door_02 false)
	(device_set_position outro_door_02 0)
	
	)
	
(script dormant create_bloom_quad
	(time_code_reset)
	(sleep 273)
	(print "create bloom quad")
	(object_create_anew bloom_quad)
	) 
	
(script dormant top_light
	(sleep 105)
	(print "delete top light")
	(objects_detach outro_elevator elevator_light_top)
	(object_destroy elevator_light_top)
	)
	
(script dormant bottom_light
	(sleep 198)
	(print "create bottom light")
	(object_create_anew elevator_light_bottom)
	(objects_attach outro_elevator "light_red02" elevator_light_bottom "")
	)
	
(script static void c01_outro_04_setup

	(render_lights_enable_cinematic_shadow 1 chief head .4)
	
	(object_create_anew matte_earth)
	(object_create_anew elevator_light_top)
	(object_create_anew elevator_light_flash)
	
	(objects_attach outro_elevator "light_red01" elevator_light_top "")	
	
	(wake c01_outro_foley_04)

	(wake c01_9150_cor)
	(wake c01_9160_mas)
	(wake c01_9170_cor)
	(wake c01_9180_cor)
	
	(wake doors_outro_04)
	(wake outro_sparks_03_04)
	(wake create_bloom_quad)
	
	(wake top_light)
	(wake bottom_light)
	
	(wake c01_outro_shake_04_01)
	(wake c01_outro_shake_04_02)
	(wake c01_outro_shake_04_03)
	
	)
	
(script static void c01_outro_04_cleanup
	(objects_detach outro_elevator elevator_light_bottom)	
	(object_destroy_containing elevator)
	(object_destroy bloom_quad)
	
	)

(script static void c01_outro_scene_04
	
	(c01_outro_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_04" none "anchor_flag_outro1")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_04" false anchor_outro1)
	(scenery_animation_start_relative pickle scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_04" anchor_outro1)
	(scenery_animation_start_relative outro_elevator objects\cinematics\human\ss_elevator\01_outro\01_outro "elevator_04" anchor_outro1)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_outro_05_predict_stub)
	
	(object_create_anew outro_fleet)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_05_fol)

	(sleep (camera_time))
	
	(c01_outro_04_cleanup)
	
	)
	
; C01_OUTRO SCENE 05 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_05_fol none 1)
	(print "c01_outro foley 05 start")
	)

(script dormant c01_9190_cor
	(sleep 293)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9190_cor none 1)
	(cinematic_subtitle c01_9190_cor 2)
	)
	
(script dormant c01_9200_cor
	(sleep 355)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9200_cor none 1)
	(cinematic_subtitle c01_9200_cor 1)
	)
	
(script dormant c01_9210_mas
	(sleep 412)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9210_mas chief 1)
	(cinematic_subtitle c01_9210_mas 1)
	
	(object_create_anew outro_fleet)
	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c01_outro_shake_05_01
	(time_code_reset)
	(sleep 470)
	
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	)

(script dormant cinematic_lighting_bay_01
	
	(print "light bay")
	(cinematic_lighting_set_primary_light 81 88 0.360784 0.372549 0.462745)
	(cinematic_lighting_set_secondary_light 0 0 0.160784 0.152941 0.211765)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(object_uses_cinematic_lighting outro_fighter_01 1)
	(object_uses_cinematic_lighting outro_fighter_02 1)
	(object_uses_cinematic_lighting outro_seraph 1)
	
	)

; ---------------------------------------------------------------------

(script dormant lever
	(sleep 240)
	(device_set_position outro_lever 1)	
	)

(script dormant airlock
	(sleep 470)
	(device_set_position outro_door_03 1)	
	)

(script static void c01_outro_05_setup

	(object_create_anew outro_fighter_01)
	(object_create_anew outro_fighter_02)
	(object_create_anew outro_seraph)
	
	(object_cinematic_lod outro_fighter_01 true)
	(object_cinematic_lod outro_fighter_02 true)
	(object_cinematic_lod outro_seraph true)
	
	(object_cinematic_visibility outro_fighter_01 true)
	(object_cinematic_visibility outro_fighter_02 true)
	(object_cinematic_visibility outro_seraph true)
	
	(wake lever)
	(wake airlock)
	
	(wake c01_outro_foley_05)
	
	(wake c01_9190_cor)
	(wake c01_9200_cor)
	(wake c01_9210_mas)
	
	(wake c01_outro_shake_05_01)
	(wake cinematic_lighting_bay_01)
	
	)
	
(script static void c01_outro_05_cleanup

	(object_destroy outro_fighter_01)
	(object_destroy outro_fighter_02)
	(object_destroy outro_seraph)
	
	)

(script static void c01_outro_scene_05
	
	(c01_outro_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_05" none "anchor_flag_outro1")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_05" false anchor_outro1)
	(scenery_animation_start_relative pickle scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_05" anchor_outro1)
	(scenery_animation_start_relative matte_earth objects\cinematics\matte_paintings\earth_space\01_outro\01_outro "earth_matte_05" anchor_outro1)
	
	(scenery_animation_start_relative outro_fighter_01 objects\vehicles\longsword\01_outro\01_outro "longsword01_05" anchor_outro1)
	(scenery_animation_start_relative outro_fighter_02 objects\vehicles\longsword\01_outro\01_outro "longsword02_05" anchor_outro1)
	(scenery_animation_start_relative outro_seraph scenarios\objects\vehicles\c_seraph\c_seraph "01_outro_05" anchor_outro1)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_outro_06_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\music\c01_outro_06_mus)
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_06_fol)
	
	(sleep (camera_time))
	
	(c01_outro_05_cleanup)
	
	)
	
; C01_OUTRO SCENE 06 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_music_06
	(sleep 233)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\music\c01_outro_06_mus none 1)
	(print "c01_outro music 06 start")
	)
	
(script dormant c01_outro_foley_06
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_06_fol none 1)
	(print "c01_outro foley 06 start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c01_outro_shake_06_01
	(sleep 243)
	(player_effect_stop 2)
	(print "shake stop")
	)
	
(script dormant cinematic_lighting_bay_02
     
     (print "light bay 02")
     
     (cinematic_lighting_set_primary_light -12 294 0.47451 0.419608 0.392157)
     (cinematic_lighting_set_secondary_light -39 296 0.156863 0.137255 0.262745)
     (cinematic_lighting_set_ambient_light 0 0 0)

	)
	
(script dormant final_sparks
	
	(time_code_reset)
	
	(sleep 132)
	(print "sparks start")
	
	(object_create_anew_containing sparks_forward)
	
	(objects_attach pickle "sparks01" sparks_forward_01 "marker")
	(objects_attach pickle "sparks02" sparks_forward_02 "marker")
	(objects_attach pickle "sparks03" sparks_forward_03 "marker")
	(objects_attach pickle "sparks04" sparks_forward_04 "marker")
	(objects_attach pickle "sparks05" sparks_forward_05 "marker")
	(objects_attach pickle "sparks06" sparks_forward_06 "marker")
	(objects_attach pickle "sparks07" sparks_forward_07 "marker")
	(objects_attach pickle "sparks08" sparks_forward_08 "marker")
	
	(sleep 8)
	(object_destroy_containing sparks_forward)
	(print "sparks stop")
	
	(sleep 22)
	(object_create_anew_containing sparks_forward)
	(print "sparks start")
	(objects_attach pickle "sparks01" sparks_forward_01 "marker")
	(objects_attach pickle "sparks02" sparks_forward_02 "marker")
	(objects_attach pickle "sparks03" sparks_forward_03 "marker")
	(objects_attach pickle "sparks04" sparks_forward_04 "marker")
	(objects_attach pickle "sparks05" sparks_forward_05 "marker")
	(objects_attach pickle "sparks06" sparks_forward_06 "marker")
	(objects_attach pickle "sparks07" sparks_forward_07 "marker")
	(objects_attach pickle "sparks08" sparks_forward_08 "marker")
	
	(sleep 5)
	(object_destroy_containing sparks_forward)
	(print "sparks stop")
	
	(sleep 29)
	(object_create_anew_containing sparks_forward)
	(print "sparks start")
	(objects_attach pickle "sparks01" sparks_forward_01 "marker")
	(objects_attach pickle "sparks02" sparks_forward_02 "marker")
	(objects_attach pickle "sparks03" sparks_forward_03 "marker")
	(objects_attach pickle "sparks04" sparks_forward_04 "marker")
	(objects_attach pickle "sparks05" sparks_forward_05 "marker")
	(objects_attach pickle "sparks06" sparks_forward_06 "marker")
	(objects_attach pickle "sparks07" sparks_forward_07 "marker")
	(objects_attach pickle "sparks08" sparks_forward_08 "marker")
	
	(sleep 50)
	(object_destroy_containing sparks_forward)
	(print "sparks stop")
	
	)

(script dormant destroy_fleet
	(sleep 150)
	(print "destroy fleet")
	(object_destroy outro_fleet)
	)

; ---------------------------------------------------------------------

(script static void c01_outro_06_setup

	(object_create_anew airlock_debris_01)
	(object_create_anew airlock_debris_02)
	
	(wake c01_outro_music_06)
	(wake c01_outro_foley_06)
	
	(wake c01_outro_shake_06_01)
	(wake cinematic_lighting_bay_02)
	
	(wake final_sparks)
	(wake destroy_fleet)
	
	)
	
(script static void c01_outro_06_cleanup
	
	(object_destroy matte_earth)
	(object_destroy pickle)
	(object_destroy_containing airlock_debris)

	)

(script static void c01_outro_scene_06
	
	(c01_outro_06_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_06" none "anchor_flag_outro1")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_06" false anchor_outro1)
	(scenery_animation_start_relative pickle scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_06" anchor_outro1)
	(scenery_animation_start_relative matte_earth objects\cinematics\matte_paintings\earth_space\01_outro\01_outro "earth_matte_06" anchor_outro1)	
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_07_fol)
	
	(sleep (camera_time))
	
	(fade_out 0 0 0 0)
	
	(sleep 69)
	
	(c01_outro_06_cleanup)
	
	)	
	
; C01_OUTRO SCENE 07 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_foley_07
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_07_fol none 1)
	(print "c01_outro foley 07 start")
	)

; EFFECTS & LIGHTING -------------------------------------------------

(script dormant effect_covenant_beams
	(sleep 338)
	
	(object_destroy carrier_02)
	
	(print "effect - beam fire")
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_beam covenant_battery "")
	
	(sleep 40)
	(print "effect - beam fire")
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_beam covenant_battery "")
	
	(sleep 59)
	(print "effect - beam fire")
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_beam covenant_battery "")
	)
	
(script dormant effect_poa_explosions
	(sleep 444)
	(print "effect - poa explosion large")
	(effect_new_on_object_marker effects\cinematics\01_outro\poa_hit_small poa "explosion02")
	)

(script dormant cinematic_lighting_outro_07
	
	(cinematic_lighting_set_primary_light -5 314 0.32549 0.27451 0.243137)
	(cinematic_lighting_set_secondary_light 19 170 0.145098 0.14902 0.313726)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting pickle2 1)
	(object_uses_cinematic_lighting carrier_01 1)
	(object_uses_cinematic_lighting carrier_02 1)
	(object_uses_cinematic_lighting fighter_01 1)
	(object_uses_cinematic_lighting fighter_02 1)
	(object_uses_cinematic_lighting poa 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .6) 
	(rasterizer_bloom_override_brightness .5)
	
	)
	
(script dormant cinematic_lighting_poa_reverse

	(time_code_reset)
	(sleep 491)
	(print "light poa reverse")
	
     (cinematic_lighting_set_primary_light -68 122 0.47451 0.419608 0.392157)
     (cinematic_lighting_set_secondary_light -39 296 0.156863 0.137255 0.262745)
     (cinematic_lighting_set_ambient_light 0 0 0)

	)
	
; ---------------------------------------------------------------------

(script static void c01_outro_07_setup

	(render_lights_enable_cinematic_shadow 0 chief head .4)

	(object_create_anew pickle2)
	(object_create_anew carrier_01)
	(object_create_anew carrier_02)
	(object_create_anew fighter_01)
	(object_create_anew fighter_02)
	(object_create_anew poa)
	(object_create_anew covenant_battery)
	(object_create_anew matte_africa)
	
	(object_cinematic_lod pickle2 true)
	(object_cinematic_lod carrier_01 true)
	(object_cinematic_lod carrier_02 true)
	(object_cinematic_lod fighter_01 true)
	(object_cinematic_lod fighter_02 true)
	(object_cinematic_lod poa true)
	(object_cinematic_lod covenant_battery true)
	(object_cinematic_lod matte_africa true)
	
	(object_set_function_variable pickle2 "flare" 0 1)
	
	(wake c01_outro_foley_07)
	
	(wake effect_covenant_beams)
	(wake effect_poa_explosions)
	(wake cinematic_lighting_outro_07)
	(wake cinematic_lighting_poa_reverse)
	
	(effect_new_on_object_marker effects\cinematics\01_outro\poa_flaming_debris poa "flaming_debris")
	
	)
	
(script static void c01_outro_07_cleanup
	
	(object_destroy poa)

	)

(script static void c01_outro_scene_07

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(01_outro_07_predict_stub)
	
	(c01_outro_07_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_07" none "anchor_flag_outro2")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_07" false anchor_outro2)
	
	(scenery_animation_start_relative pickle2 scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_07" anchor_outro2)
	(scenery_animation_start_relative carrier_01 scenarios\objects\covenant\military\capital_ship\01_outro\01_outro "capship01_07" anchor_outro2)
	(scenery_animation_start_relative carrier_02 scenarios\objects\covenant\military\capital_ship\01_outro\01_outro "capship02_07" anchor_outro2)
	(scenery_animation_start_relative fighter_01 objects\vehicles\longsword\01_outro\01_outro "longsword01_07" anchor_outro2)
	(scenery_animation_start_relative fighter_02 objects\vehicles\longsword\01_outro\01_outro "longsword02_07" anchor_outro2)
	(scenery_animation_start_relative poa objects\cinematics\human\pillarofautumn\01_outro\01_outro "poa_07" anchor_outro2)
	(scenery_animation_start_relative covenant_battery objects\cinematics\texture_camera\01_outro\01_outro "texture_camera_07" anchor_outro2)
	
	(scenery_animation_start_relative matte_africa objects\cinematics\matte_paintings\africa_space\01_outro\01_outro "africa_space_07" anchor_outro2)
	
	(fade_in 0 0 0 30)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_outro_08_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_08_fol)
	
	(sleep (camera_time))
	
	(c01_outro_07_cleanup)
	
	)
	
; C01_OUTRO SCENE 08 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_foley_08
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_08_fol none 1)
	(print "c01_outro foley 08 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_cluster_bombs
	(sleep 120)
	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb carrier_01 "cluster01")
	(sleep 5)
;	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb carrier_01 "cluster02")
	(sleep 5)
	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb carrier_01 "cluster03")
	(sleep 5)
;	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb carrier_01 "cluster04")
	(sleep 4)
	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb carrier_01 "cluster05")
	(sleep 4)
	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb carrier_01 "cluster06")
	(sleep 3)
	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb carrier_01 "cluster07")
	(sleep 3)
;	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb carrier_01 "cluster08")
	)
	
(script dormant effect_interior_blast
	(sleep 195)
	(print "interior blast")
	(effect_new_on_object_marker effects\cinematics\01_outro\cluster_bomb blast_base "marker")
	)
	
(script dormant x02_08_dof
	(time_code_reset)
	
	(sleep 455)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 5 0 0 0 1 1 0)
	(print "rack focus")
	
	(time_code_reset)
	
	(sleep 116)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)
	
(script dormant bomb_reactivate
	(sleep 630)
	(print "bomb reactivate")
	(object_set_function_variable pickle2 "flare" 1 0)
	)
	
(script dormant cinematic_lighting_scene_08

	(print "light scene 08")
	
	(cinematic_lighting_set_primary_light -5 314 0.32549 0.27451 0.243137)
	(cinematic_lighting_set_secondary_light 19 170 0.145098 0.14902 0.313726)
	(cinematic_lighting_set_ambient_light 0 0 0)

	)
	
(script dormant cinematic_light_carrier_int

	(time_code_reset)
	
	(sleep 199)
	(print "light carrier interior")
	
	(cinematic_lighting_set_primary_light 63 356 0.305882 0.262745 0.380392)
	(cinematic_lighting_set_secondary_light 9 220 0.0784314 0.0784314 0.160784)
	(cinematic_lighting_set_ambient_light 0.0235294 0.027451 0.0588235)

	)
	
; ---------------------------------------------------------------------

(script dormant save_framerate_08
	(sleep 199)
	(print "hide carrier, africa matte")
	(object_hide carrier_01 true)
	(object_hide matte_africa true)
	)

(script static void c01_outro_08_setup

	(object_create matte_carrier_core)
	(object_create matte_carrier_side)
	(object_create matte_carrier_hull)
	(object_create_anew blast_base)
	(object_cinematic_visibility blast_base true)
	
	(object_cinematic_lod matte_carrier_core true)
	(object_cinematic_lod matte_carrier_side true)
	(object_cinematic_lod matte_carrier_hull true)
	
	(wake c01_outro_foley_08)
	
	(wake effect_cluster_bombs)
	(wake save_framerate_08)
	(wake effect_interior_blast)
	(wake bomb_reactivate)
	(wake x02_08_dof)
	
	(wake cinematic_lighting_scene_08)
	(wake cinematic_light_carrier_int)

	)
	
(script static void c01_outro_08_cleanup
	
	(object_destroy matte_carrier_core)
	(object_destroy matte_carrier_side)
	(object_destroy fighter_01)
	(object_destroy fighter_02)
	(object_destroy covenant_battery)
	(object_destroy blast_base)

	)

(script static void c01_outro_scene_08
	
	(c01_outro_08_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_08" none "anchor_flag_outro2")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_08" false anchor_outro2)
	
	(scenery_animation_start_relative pickle2 scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_08" anchor_outro2)
	
	(scenery_animation_start_relative carrier_01 scenarios\objects\covenant\military\capital_ship\01_outro\01_outro "capship01_08" anchor_outro2)
	(scenery_animation_start_relative fighter_01 objects\vehicles\longsword\01_outro\01_outro "longsword01_08" anchor_outro2)
	(scenery_animation_start_relative fighter_02 objects\vehicles\longsword\01_outro\01_outro "longsword02_08" anchor_outro2)
	(scenery_animation_start_relative covenant_battery objects\cinematics\texture_camera\01_outro\01_outro "texture_camera_08" anchor_outro2)
	
	(scenery_animation_start_relative matte_carrier_core objects\cinematics\matte_paintings\cruiser_interior_core\01_outro\01_outro "cruiser_core_08" anchor_outro2)
	(scenery_animation_start_relative matte_carrier_side objects\cinematics\matte_paintings\cruiser_interior_side\01_outro\01_outro "cruiser_side_08" anchor_outro2)
	(scenery_animation_start_relative matte_carrier_hull objects\cinematics\matte_paintings\cruiser_interior_up\01_outro\01_outro "cruiser_up_08" anchor_outro2)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_outro_09_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_09_fol)
	
	(sleep (camera_time))
	
	(c01_outro_08_cleanup)
	
	)
	
; C01_OUTRO SCENE 09 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_foley_09
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_09_fol none 1)
	(print "c01_outro foley 09 start")
	)

; LIGHTING & EFFECTS --------------------------------------------------

(script dormant cinematic_lighting_scene_09

	(print "light scene 09")
	
	(cinematic_lighting_set_primary_light -12 2 0.352941 0.109804 0.756863)
	(cinematic_lighting_set_secondary_light -39 296 0.156863 0.137255 0.262745)
	(cinematic_lighting_set_ambient_light 0 0 0)

	)

; ---------------------------------------------------------------------
	
(script static void c01_outro_09_setup

	(wake c01_outro_foley_09)

	(wake cinematic_lighting_scene_09)
	
	(object_hide matte_africa false)
	(print "unhide africa matte")
	
	)

(script static void c01_outro_09_cleanup
	
	(object_destroy pickle2)
	(object_destroy matte_carrier_hull)
	(object_destroy matte_africa)

	)

(script static void c01_outro_scene_09

	(c01_outro_09_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_09" none "anchor_flag_outro2")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_09" false anchor_outro2)
	(scenery_animation_start_relative pickle2 scenarios\objects\solo\spacestation\pickle\01_outro\01_outro "pickle_09" anchor_outro2)
	
	(scenery_animation_start_relative matte_carrier_hull objects\cinematics\matte_paintings\cruiser_interior_up\01_outro\01_outro "cruiser_up_09" anchor_outro2)
	(scenery_animation_start_relative matte_africa objects\cinematics\matte_paintings\africa_space\01_outro\01_outro "africa_space_09" anchor_outro2)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_outro_10_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_10_fol)
	
	(sleep (camera_time))
	
	(c01_outro_09_cleanup)
	
	)
	
; C01_OUTRO SCENE 10 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_outro_foley_10
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_outro\foley\c01_outro_10_fol none 1)
	(print "c01_outro foley 10 start")
	)

(script dormant c01_9220_jon
	(sleep 375)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9220_jon johnson 1)
	(cinematic_subtitle c01_9220_jon 1)
	)
	
(script dormant c01_9230_jon
	(sleep 415)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9230_jon johnson 1)
	(cinematic_subtitle c01_9230_jon 1)
	
	(unit_set_emotional_state johnson happy .75 90)
	(print "johnson - happy .75 90")
	
	(sleep 41)
	
	(unit_set_emotional_state miranda happy .25 60)
	(print "miranda - happy .25 60")
	
	)
	
(script dormant c01_9240_mir
	(sleep 461)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9240_mir miranda 1)
	(cinematic_subtitle c01_9240_mir 2)
	)
	
(script dormant c01_9250_mir
	(sleep 536)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_9250_mir none 1)
	(cinematic_subtitle c01_9250_mir 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant carrier_explosion_tiny
	(sleep 15)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion carrier_01 tiny_explosion01)
	(sleep 5)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion carrier_01 tiny_explosion02)
	(sleep 5)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion carrier_01 tiny_explosion03)
	(sleep 3)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion carrier_01 tiny_explosion04)
	(sleep 3)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion carrier_01 tiny_explosion05)
	(sleep 2)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion carrier_01 tiny_explosion06)
	(sleep 2)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion carrier_01 tiny_explosion07)
	)
	
(script dormant carrier_explosion_medium
	(sleep 20)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_minor_explosion carrier_01 tiny_explosion01)
	(sleep 5)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_minor_explosion carrier_01 tiny_explosion02)
	(sleep 10)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_minor_explosion carrier_01 tiny_explosion03)
	)
	
(script dormant carrier_explosion_large
	(sleep 50)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_major_explosion carrier_01 major_explosion)
	)
	
(script dormant white_flash

	(sleep 185)
	(print "white flash")
	
	(fade_out 1 1 1 15)
	(sleep 30)
	
	(object_hide miranda false)
	(object_hide johnson false)
	(object_hide iac false)
	(object_hide iac_bridge_outro_02 false)
	(object_hide matte_africa_coast false)
	(print "unhide miranda, johnson, iac")
	
	(fade_in 1 1 1 15)
	
	)
	
(script dormant effect_africa_explosions
	(sleep 522)
	(effect_new_on_object_marker effects\cinematics\01_outro\africa_explosion matte_africa_coast "explosion1")
	(sleep 20)
	(effect_new_on_object_marker effects\cinematics\01_outro\africa_explosion matte_africa_coast "explosion2")
	(sleep 15)
	(effect_new_on_object_marker effects\cinematics\01_outro\africa_explosion matte_africa_coast "explosion3")
	(sleep 25)
	(effect_new_on_object_marker effects\cinematics\01_outro\africa_explosion matte_africa_coast "explosion4")
	)

(script dormant cinematic_lighting_outro_10

     (cinematic_lighting_set_primary_light -68 122 0.47451 0.419608 0.392157)
     (cinematic_lighting_set_secondary_light -39 296 0.156863 0.137255 0.262745)
     (cinematic_lighting_set_ambient_light 0 0 0)
     
     )

(script dormant cinematic_lighting_iac_ext_01

	(time_code_reset)
	
	(sleep 198)
	(print "light iac exterior")
	
	(cinematic_lighting_set_primary_light 6 0 0.47451 0.423529 0.392157)
	(cinematic_lighting_set_secondary_light 45 116 0.0784314 0.0745098 0.101961)
	(cinematic_lighting_set_ambient_light 0.0392157 0.0392157 0.0470588)

	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting johnson 1)	
	(object_uses_cinematic_lighting iac 1)
	(object_uses_cinematic_lighting iac_bridge_outro_02 1)

	)
		
(script dormant cinematic_lighting_iac_interior
	
	(sleep 338)
	(print "light iac interior")
	
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -73 160 0.117647 0.117647 0.176471)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)

	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)

	)
	
(script dormant cinematic_lighting_iac_ext_02
	
	(sleep 502)
	(print "light iac exterior")
	
	(cinematic_lighting_set_primary_light 6 0 0.47451 0.423529 0.392157)
	(cinematic_lighting_set_secondary_light 45 116 0.0784314 0.0745098 0.101961)
	(cinematic_lighting_set_ambient_light 0.0392157 0.0392157 0.0470588)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .6) 
	(rasterizer_bloom_override_brightness .5)
	
	)
	
; ---------------------------------------------------------------------

(script dormant emotion_10
	(sleep 226)
	(unit_set_emotional_state miranda angry .25 0)
	(unit_set_emotional_state johnson pensive .5 0)
	)
	
(script dormant save_framerate_10
	
	(object_hide carrier_01 false)
	(print "unhide carrier")
	
	(object_hide miranda true)
	(object_hide johnson true)
	(object_hide iac true)
	(object_hide iac_bridge_outro_02 true)
	(object_hide matte_africa_coast true)
	(print "hide miranda, johnson, iac")
	
	)

(script static void c01_outro_10_setup

	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_create_anew iac)
	(object_create_anew iac_bridge_outro_02)
	(object_create_anew matte_africa_coast)
	
	(object_cinematic_lod iac true)
	(object_cinematic_lod iac_bridge_outro_02 true)

	(wake c01_outro_foley_10)

	(wake c01_9220_jon)
	(wake c01_9230_jon)
	(wake c01_9240_mir)
	(wake c01_9250_mir)

;	(wake x05_fov_02)
;	(wake x04_01_dof_1)

	(wake save_framerate_10)
	(wake carrier_explosion_tiny)
	(wake carrier_explosion_medium)
	(wake carrier_explosion_large)
	(wake white_flash)
	(wake effect_africa_explosions)
	
	(wake cinematic_lighting_outro_10)
	(wake cinematic_lighting_iac_ext_01)
	(wake cinematic_lighting_iac_interior)
	(wake cinematic_lighting_iac_ext_02)
	
	(wake emotion_10)
	
	)
	
(script static void c01_outro_10_cleanup

	(object_destroy chief)
	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy carrier_01)
	(object_destroy_containing iac)
	(object_destroy_containing matte)

	)

(script static void c01_outro_scene_10
	
	(c01_outro_10_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_outro\01_outro "01_outro_10" none "anchor_flag_outro2")
	
	(custom_animation_relative chief objects\characters\masterchief\01_outro\01_outro "chief_10" false anchor_outro2)
	(custom_animation_relative miranda objects\characters\miranda\01_outro\01_outro "miranda_10" false anchor_outro2)
	(custom_animation_relative johnson objects\characters\marine\01_outro\01_outro "johnson_10" false anchor_outro2)
	
	(scenery_animation_start_relative carrier_01 scenarios\objects\covenant\military\capital_ship\01_outro\01_outro "capship01_10" anchor_outro2)
	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\01_outro\01_outro "iac_10" anchor_outro2)
	(scenery_animation_start_relative iac_bridge_outro_02 objects\cinematics\human\inamberclad_bridge\01_outro\01_outro "iac_bridge_10" anchor_outro2)
	
	(scenery_animation_start_relative matte_africa_coast objects\cinematics\matte_paintings\africa_coast\01_outro\01_outro "africa_coast_10" anchor_outro2)
	
	(sleep (- (camera_time) 30))
	
	(fade_out 0 0 0 30)
	(sleep 30)
	
	(c01_outro_10_cleanup)
	
	(sleep 30)
	
	)

; C01_OUTRO MASTER SCRIPT =============================================
; =====================================================================

(script static void c01_outro
	
	(texture_cache_flush)
	(geometry_cache_flush)
	
	(cinematic_enable_ambience_details false)
	(sound_class_set_gain huge_ass 0 30)
	
	(switch_bsp_by_name 01_bsp_3)
	(sleep 1)

;	(sound_class_set_gain vehicle 0 0)
;	(sound_class_set_gain amb 0 0)
	
	(c01_outro_scene_01)
	(c01_outro_scene_02)
	(c01_outro_scene_03)
	(c01_outro_scene_04)
	(c01_outro_scene_05)
	(c01_outro_scene_06)
	
	(switch_bsp_by_name 01outro_bsp)
	(sleep 1)
	
	(c01_outro_scene_07)
	(c01_outro_scene_08)
	(c01_outro_scene_09)
	(c01_outro_scene_10)
	
	(rasterizer_bloom_override 0)
	
	)