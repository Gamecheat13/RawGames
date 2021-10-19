; CINEMATICS FOR LEVEL 08B, "DELTA CONTROL" ===========================
; =====================================================================

;*
	Between the desire
	And the spasm
	Between the potency
	And the existence
	Between the essence
	And the descent
	Falls the Shadow...

	...This is the way the world ends
	Not with a bang but a whimper. 
*; 

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)
	
	(script stub void 08_intra1_04_predict_stub (print "predict 04"))
	
	(script stub void 08_intra2_01_predict_stub (print "predict 01"))
	(script stub void 08_intra2_02_predict_stub (print "predict 02"))
	
	(script stub void 08_intra3_01_predict_stub (print "predict 01"))
	(script stub void 08_intra3_02_predict_stub (print "predict 02"))
	(script stub void 08_intra3_03_predict_stub (print "predict 03"))
	(script stub void 08_intra3_04_predict_stub (print "predict 04"))
	(script stub void 08_intra3_05_predict_stub (print "predict 05"))
	(script stub void 08_intra3_06_predict_stub (print "predict 06"))
	
	(script stub void x09_01_predict_stub (print "predict 01"))
	(script stub void x09_02_predict_stub (print "predict 02"))
	(script stub void x09_03_predict_stub (print "predict 03"))
	(script stub void x09_04_predict_stub (print "predict 04"))
	(script stub void x09_05_predict_stub (print "predict 05"))
	(script stub void x09_06_predict_stub (print "predict 06"))
	(script stub void x09_07_predict_stub (print "predict 07"))
	(script stub void x09_08_predict_stub (print "predict 08"))
	
	(script stub void x10_01_predict_stub (print "predict 01"))
	(script stub void x10_02_predict_stub (print "predict 02"))

; C08_INTRA1 SCENE 04 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c08_intra1_score_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra1\music\c08_intra1_04_mus none 1)
	(print "c08_intra1 score 04 start")
	)
	
(script dormant c08_intra1_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra1\foley\c08_intra1_04_fol none 1)
	(print "c08_intra1 foley 04 start")
	)

(script dormant c08_2050_der
	(sleep 60)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_2050_der dervish_02 1)
	(cinematic_subtitle c08_2050_der 1)
	)
	
(script dormant c08_2060_soc
	(sleep 92)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_2060_soc commander 1)
	(cinematic_subtitle c08_2060_soc 6)
	)
	
(script dormant c08_2070_grv
	(sleep 273)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_2070_grv none 1)
	(cinematic_subtitle c08_2070_grv 5)
	
	(cinematic_lightmap_shadow_disable)
	
	)
	
(script dormant c08_2080_der
	(sleep 425)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_2080_der dervish_02 1)
	(cinematic_subtitle c08_2080_der 2)
	)
	
(script dormant c08_2090_soc
	(sleep 473)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_2090_soc commander 1)
	(cinematic_subtitle c08_2090_soc 1)
	)
	
(script dormant c08_2100_soc
	(sleep 512)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_2100_soc commander 1)
	(cinematic_subtitle c08_2100_soc 2)
	)

; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c04_intra1_fov_04

	(sleep 511)
	(print "fov change: 80 -> 60 over 0 ticks")
	(camera_set_field_of_view 60 0)

	)
	
(script dormant c04_intra1_dof_04

	(sleep 427)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 1.17 .5 .5 0 0 0 0)
	(print "rack focus")

	(sleep 84)
	(cinematic_screen_effect_set_depth_of_field .5 .5 .5 0 0 0 0)
	(print "rack focus")
	
	(sleep 100)
	(cinematic_screen_effect_set_depth_of_field .5 .5 0 0 0 .5 .5)
	(print "rack focus")
	
	)
	
(script dormant cinematic_lighting_intra1_04
	
	(cinematic_lighting_set_primary_light 40 134 0.321569 0.321569 0.290196)
	(cinematic_lighting_set_secondary_light 8 274 0.301961 0.290196 0.45098)
	(cinematic_lighting_set_ambient_light 0.121569 0.121569 0.0705882)
	
	(object_uses_cinematic_lighting dervish_02 1)
	(object_uses_cinematic_lighting commander 1)
	(object_uses_cinematic_lighting wraith_01 1)
	
	)
	
; PREDICTION ----------------------------------------------------------

(script static void c08_intra1_04_problem_actors
	(print "problem actors")
	
	(object_create_anew dervish_02)
	(object_create_anew commander)
	(object_create_anew wraith_01)
	
	(cinematic_clone_players_weapon dervish_02 "right_hand_elite" "")
	
	(object_cinematic_lod dervish_02 true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod wraith_01 true)
	
	)

; ---------------------------------------------------------------------

(script static void c08_intra1_04_setup

	(wake c08_intra1_score_04)
	(wake c08_intra1_foley_04)
	
	(wake c08_2050_der)
	(wake c08_2060_soc)
	(wake c08_2070_grv)
	(wake c08_2080_der)
	(wake c08_2090_soc)
	(wake c08_2100_soc)
	
	(wake c04_intra1_fov_04)
	(wake c04_intra1_dof_04)
	(wake cinematic_lighting_intra1_04)
	
	)
	
(script static void c08_intra1_04_cleanup

	(object_destroy dervish_02)
	(object_destroy commander)
	(object_destroy wraith_01)
	
	)

(script static void c08_intra1

	(texture_cache_flush)
	(geometry_cache_flush)

	(sound_class_set_gain vehicle 0 0)

	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start_movie "deltacontrol_intra1")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
	(c08_intra1_04_problem_actors)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(08_intra1_04_predict_stub)
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra1\music\c08_intra1_04_mus)
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra1\foley\c08_intra1_04_fol)
	(sleep prediction_offset)
	
	(c08_intra1_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\08_intra1\08_intra1 "08_intra1_04" none "anchor_flag_intra1")

	(custom_animation_relative dervish_02 objects\characters\dervish\08_intra1\08_intra1 "dervish_04" false anchor_intra1)
	(custom_animation_relative commander objects\characters\elite\08_intra1\08_intra1 "commander_04" false anchor_intra1)
	
	(custom_animation_relative wraith_01 objects\vehicles\wraith\08_intra1\08_intra1 "wraith_04" false anchor_intra1)

	(print "cache block")
	(sleep 1)
	(cache_block_for_one_frame)

	(fade_in 0 0 0 30)

	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c08_intra1_04_cleanup)
	(cinematic_screen_effect_stop)
	
	(sleep 30)
	
	(sound_class_set_gain vehicle 1 1)
	
	)

; C08_INTRA2 SCENE 01 -------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant c08_intra2_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra2\foley\c08_intra2_01_fol none 1)
	(print "c08_intra2 foley 01 start")
	)

(script dormant c08_3010_jon
	(sleep 100)
	(sound_impulse_start_effect sound\dialog\levels\08_controlroom\cinematic\c08_3010_jon johnson_02 1 radio_covy_in)
	(cinematic_subtitle c08_3010_jon 3)
	)
	
(script dormant c08_3020_jon
	(sleep 203)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_3020_jon johnson_02 1)
	(cinematic_subtitle c08_3020_jon 3)
	)
	
(script dormant c08_3030_jon
	(sleep 316)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_3030_jon johnson_02 1)
	(cinematic_subtitle c08_3030_jon 2)
	)

(script dormant c08_3040_der
	(sleep 359)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_3040_der dervish_02 1)
	(cinematic_subtitle c08_3040_der 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant intra2_texture_cam_01
	(object_create_anew texture_camera)
	(texture_camera_set_object_marker texture_camera marker 35)
	(scenery_animation_start_relative texture_camera objects\cinematics\texture_camera\08_intra2\08_intra2 "texture_camera_01" anchor_intra2)
	)

(script dormant cinematic_lighting_intra2
	
	(cinematic_lighting_set_primary_light 33 0 0.258824 0.278431 0.34902)
	(cinematic_lighting_set_secondary_light -37 228 0.109804 0.419608 0.611765)
	(cinematic_lighting_set_ambient_light 0.121569 0.121569 0.0705882)
	
	(object_uses_cinematic_lighting dervish_02 1)
	(object_uses_cinematic_lighting johnson_02 1)
	(object_uses_cinematic_lighting scarab_01 1)
	
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void c08_intra2_problem_actors
	(print "problem actors")
	(object_create_anew dervish_02)
	(object_cinematic_lod dervish_02 true)
	(cinematic_clone_players_weapon dervish_02 "right_hand_elite" "")
	)

; ---------------------------------------------------------------------

(script dormant scarab_shake
	(sleep 45)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 2)
	(sleep 240)
	(player_effect_stop 2)
	)
			
(script static void c08_intra2_01_setup

	(object_destroy scarab)

	(object_create_anew johnson_02)
	(object_create_anew scarab_01)
	(object_create_anew scarab_screen)
	
	(objects_attach scarab_01 "holo_scarab_full" scarab_screen "")
	
	(object_cinematic_lod johnson_02 true)
	(object_cinematic_lod scarab_01 true)
	
	(unit_set_emotional_state johnson_02 angry .25 0)

	(wake c08_intra2_foley_01)
	
	(wake c08_3010_jon)
	(wake c08_3020_jon)
	(wake c08_3030_jon)
	(wake c08_3040_der)
	
;	(wake x04_01_dof_1)

	(wake scarab_shake)

	(wake intra2_texture_cam_01)
	(wake cinematic_lighting_intra2)
	
	)

(script static void c08_intra2_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start_movie "deltacontrol_intra2")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
	(c08_intra2_problem_actors)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(08_intra2_01_predict_stub)
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra2\foley\c08_intra2_01_fol)
	(sleep prediction_offset)
	
;	safety white
	(sleep 45)
	
	(c08_intra2_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\08_intra2\08_intra2 "08_intra2_01" none "anchor_flag_intra2")

	(custom_animation_relative dervish_02 objects\characters\dervish\08_intra2\08_intra2 "dervish_01" false anchor_intra2)
	(custom_animation_relative johnson_02 objects\characters\marine\08_intra2\08_intra2 "johnson_01" false anchor_intra2)
	
	(scenery_animation_start_relative scarab_01 scenarios\objects\covenant\military\scarab\08_intra2\08_intra2 "scarab_01" anchor_intra2)

	(fade_in 1 1 1 15)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(08_intra2_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra2\foley\c08_intra2_02_fol)

	(sleep (camera_time))
	
	)
	
; C08_INTRA2 SCENE 02 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c08_intra2_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra2\foley\c08_intra2_02_fol none 1)
	(print "c08_intra1 foley 04 start")
	)

(script dormant c08_3050_jon
	(sleep 70)
	(sound_impulse_start_effect sound\dialog\levels\08_controlroom\cinematic\c08_3050_jon johnson_02 1 radio_covy_loop)
	(cinematic_subtitle c08_3050_jon 2)
	)
	
(script dormant c08_3061_jon
	(sleep 156)
	(sound_impulse_start_effect sound\dialog\levels\08_controlroom\cinematic\c08_3061_jon johnson_02 1 radio_covy_loop)
	(cinematic_subtitle c08_3061_jon 2)
	)
	
(script dormant c08_3070_jon
	(sleep 231)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_3070_jon johnson_02 1)
	(cinematic_subtitle c08_3070_jon 1)
	
	(unit_set_emotional_state johnson_02 angry .75 45)
	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant intra2_dof

	(sleep 68)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
	(print "rack focus")

	(sleep 151)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	)
	
; ---------------------------------------------------------------------

(script dormant scarab_shake2
	(sleep 137)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .75 .15)
	(sleep 5)
	(player_effect_stop .5)
	)

(script static void c08_intra2_02_setup
	
	(wake c08_intra2_foley_02)
	
	(wake c08_3050_jon)
	(wake c08_3061_jon)
	(wake c08_3070_jon)
	
	(wake intra2_dof)
	
	(wake scarab_shake2)
	
	)

(script static void c08_intra2_02_cleanup

	(object_destroy dervish_02)
	(object_destroy johnson_02)
	(object_destroy scarab_01)
	(object_destroy scarab_screen)
	
	(object_create_anew scarab)
	
	)

(script static void c08_intra2_scene_02

	(c08_intra2_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\08_intra2\08_intra2 "08_intra2_02" none "anchor_flag_intra2")

	(custom_animation_relative dervish_02 objects\characters\dervish\08_intra2\08_intra2 "dervish_02" false anchor_intra2)
	(custom_animation_relative johnson_02 objects\characters\marine\08_intra2\08_intra2 "johnson_02" false anchor_intra2)
	
	(scenery_animation_start_relative scarab_01 scenarios\objects\covenant\military\scarab\08_intra2\08_intra2 "scarab_02" anchor_intra2)

	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c08_intra2_02_cleanup)
	
	(sound_class_set_gain amb 0 15)
	(sleep 15)

	)

; C08_INTRA2 MASTER SCRIPT ============================================
; =====================================================================

(script static void c08_intra2

	(texture_cache_flush)
	(geometry_cache_flush)

	(switch_bsp_by_name deltacontrolroom_bsp0)
	(sleep 1)
	
	(c08_intra2_scene_01)
	(c08_intra2_scene_02)
	)

; C08_INTRA3 SCENE 01 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c08_intra3_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_01_fol none 1)
	(print "c08_intra3 foley 01 start")
	)

(script dormant c08_4010_tar
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4010_tar tartarus 1)
	(cinematic_subtitle c08_4010_tar 4)
	)
	
(script dormant c08_4020_tar
	(sleep 167)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4020_tar tartarus 1)
	(cinematic_subtitle c08_4020_tar 3)
	)
	
(script dormant c08_4030_gsp
	(sleep 251)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4030_gsp monitor 1)
	(cinematic_subtitle c08_4030_gsp 3)
	)
	
(script dormant c08_4040_tar
	(sleep 344)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4040_tar tartarus 1)
	(cinematic_subtitle c08_4040_tar 4)
	)

(script dormant c08_4050_mir
	(sleep 486)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4050_mir miranda 1)
	(cinematic_subtitle c08_4050_mir 1)
	)
	
(script dormant c08_4060_tar
	(sleep 510)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4060_tar tartarus 1)
	(cinematic_subtitle c08_4060_tar 3)
	)
	
; LIGHTING & EFFECTS --------------------------------------------------
	
(script dormant c08_intra3_fov_01
	
	(sleep 246)
	(camera_set_field_of_view 30 0)
	(print "fov change: 60 -> 30 over 0 ticks")
	
	(sleep 105)
	(camera_set_field_of_view 60 13)
	(print "fov change: 30 -> 60 over 13 ticks")
	
	)

(script dormant cinematic_lighting_intra3_01
	
	(cinematic_lighting_set_primary_light 63 80 0.180392 0.168627 0.129412)
	(cinematic_lighting_set_secondary_light -51 188 0.101961 0.2 0.301961)
	(cinematic_lighting_set_ambient_light 0.121569 0.121569 0.0705882)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting brute_03 1)
	(object_uses_cinematic_lighting brute_04 1)
	(object_uses_cinematic_lighting monitor 1)
	(object_uses_cinematic_lighting index 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void c08_intra3_problem_actors_01
	(print "problem actors")
	
	(object_create_anew miranda)
	(object_create_anew tartarus)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew brute_03)
	(object_create_anew brute_04)
	(object_create_anew monitor)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod brute_03 true)
	(object_cinematic_lod brute_04 true)
	(object_cinematic_lod monitor true)
	
	)

; ---------------------------------------------------------------------

(script dormant c08_intra2_miranda_emotion_01
	(unit_set_emotional_state miranda angry .25 0)
	(sleep 180)
	(unit_set_emotional_state miranda angry .75 30)
	)
	
(script dormant c08_intra2_miranda_emotion_02
	(sleep 488)
	(unit_set_emotional_state miranda pain .75 30)
	(sleep 81)
	(unit_set_emotional_state miranda angry .25 60)
	)

(script static void c08_intra3_01_setup

;	(object_create_anew hammer)
	(object_create_anew index)
	(object_create_anew repository)
	
;	(object_cinematic_lod hammer true)
	(object_cinematic_lod index true)
	(object_cinematic_lod repository true)

	(wake c08_intra3_foley_01)
	
	(wake c08_4010_tar)
	(wake c08_4020_tar)
	(wake c08_4030_gsp)
	(wake c08_4040_tar)
	(wake c08_4050_mir)
	(wake c08_4060_tar)
	
	(wake c08_intra2_miranda_emotion_01)
	(wake c08_intra2_miranda_emotion_02)
	
;	(wake x04_01_dof_1)
	(wake c08_intra3_fov_01)

	(wake cinematic_lighting_intra3_01)
	
	)

(script static void c08_intra3_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start_movie "deltacontrol_intra3")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(c08_intra3_problem_actors_01)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(08_intra3_01_predict_stub)	
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_01_fol)
	(sleep prediction_offset)
	
	(c08_intra3_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\08_intra3\08_intra3 "08_intra3_01" none "anchor_flag_intra3")

	(custom_animation_relative miranda objects\characters\miranda\08_intra3\08_intra3 "miranda_01" false anchor_intra3)
	(custom_animation_relative monitor objects\characters\monitor\08_intra3\08_intra3 "monitor_01" false anchor_intra3)
	
	(custom_animation_relative tartarus objects\characters\brute\08_intra3\08_intra3 "tartarus_01" false anchor_intra3)
	(custom_animation_relative brute_01 objects\characters\brute\08_intra3\08_intra3 "brute01_01" false anchor_intra3)
	(custom_animation_relative brute_02 objects\characters\brute\08_intra3\08_intra3 "brute02_01" false anchor_intra3)
	(custom_animation_relative brute_03 objects\characters\brute\08_intra3\08_intra3 "brute03_01" false anchor_intra3)
	(custom_animation_relative brute_04 objects\characters\brute\08_intra3\08_intra3 "brute04_01" false anchor_intra3)
	
;	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\08_intra3\08_intra3 "hammer_01" anchor_intra3)
	(scenery_animation_start_relative index scenarios\objects\forerunner\industrial\index\index_full\08_intra3\08_intra3 "index_01" anchor_intra3)

	(fade_in 1 1 1 15)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(08_intra3_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra3\music\c08_intra3_02_mus)
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_02_fol)
	
	(sleep (camera_time))
	
	)
	
; C08_INTRA3 SCENE 02 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c08_intra3_score_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra3\music\c08_intra3_02_mus none 1)
	(print "c08_intra3 score 02 start")
	)

(script dormant c08_intra3_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_02_fol none 1)
	(print "c08_intra3 foley 02 start")
	)

(script dormant c08_4070_der
	(sleep 36)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4070_der dervish 1)
	(cinematic_subtitle c08_4070_der 1)
	)
	
(script dormant c08_4080_tar
	(sleep 77)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4080_tar tartarus 1)
	(cinematic_subtitle c08_4080_tar 3)
	)
	
(script dormant c08_4100_der
	(sleep 157)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4100_der dervish 1)
	(cinematic_subtitle c08_4100_der 2)
	)
	
(script dormant c08_4110_tar
	(sleep 212)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4110_tar tartarus 1)
	(cinematic_subtitle c08_4110_tar 3)
	)

(script dormant c08_4120_der
	(sleep 312)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4120_der dervish 1)
	(cinematic_subtitle c08_4120_der 5)
	)
	
(script dormant c08_4140_tar
	(sleep 516)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4140_tar tartarus 1)
	(cinematic_subtitle c08_4140_tar 4)
	)
	
(script dormant c08_4150_der
	(sleep 628)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4150_der dervish 1)
	(cinematic_subtitle c08_4150_der 1)
	)

(script dormant c08_4160_der
	(sleep 681)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4160_der dervish 1)
	(cinematic_subtitle c08_4160_der 3)
	)

; ---------------------------------------------------------------------

(script dormant unhide_dervish
	(time_code_reset)
	(sleep 10)
	(print "unhide dervish")
	(object_hide dervish false)
	)

(script static void c08_intra3_02_setup

	(object_create_anew dervish)
	(object_cinematic_lod dervish true)
	
	(object_hide dervish true)
	
	(cinematic_clone_players_weapon dervish "right_hand_elite" "")
	
	(wake c08_intra3_score_02)
	(wake c08_intra3_foley_02)
	
	(wake c08_4070_der)
	(wake c08_4080_tar)
	(wake c08_4100_der)
	(wake c08_4110_tar)
	(wake c08_4120_der)
	(wake c08_4140_tar)
	(wake c08_4150_der)
	(wake c08_4160_der)
	
	(wake unhide_dervish)
	
;	(wake x04_01_dof_1)
	
	)

(script static void c08_intra3_scene_02
	
	(c08_intra3_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\08_intra3\08_intra3 "08_intra3_02" none "anchor_flag_intra3")

	(custom_animation_relative miranda objects\characters\miranda\08_intra3\08_intra3 "miranda_02" false anchor_intra3)
	(custom_animation_relative monitor objects\characters\monitor\08_intra3\08_intra3 "monitor_02" false anchor_intra3)
	
	(custom_animation_relative dervish objects\characters\dervish\08_intra3\08_intra3 "dervish_02" false anchor_intra3)	
	(custom_animation_relative tartarus objects\characters\brute\08_intra3\08_intra3 "tartarus_02" false anchor_intra3)
	(custom_animation_relative brute_01 objects\characters\brute\08_intra3\08_intra3 "brute01_02" false anchor_intra3)
	(custom_animation_relative brute_02 objects\characters\brute\08_intra3\08_intra3 "brute02_02" false anchor_intra3)
	(custom_animation_relative brute_03 objects\characters\brute\08_intra3\08_intra3 "brute03_02" false anchor_intra3)
	(custom_animation_relative brute_04 objects\characters\brute\08_intra3\08_intra3 "brute04_02" false anchor_intra3)
	
	(scenery_animation_start_relative index scenarios\objects\forerunner\industrial\index\index_full\08_intra3\08_intra3 "index_02" anchor_intra3)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(08_intra3_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_03_fol)

	(sleep (camera_time))
	
	)
	
; C08_INTRA3 SCENE 03 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c08_intra3_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_03_fol none 1)
	(print "c08_intra3 foley 03 start")
	)

(script dormant c08_4170_gsp
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4170_gsp monitor 1)
	(cinematic_subtitle c08_4170_gsp 2)
	)

(script dormant c08_4180_tar
	(sleep 41)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4180_tar tartarus 1)
	(cinematic_subtitle c08_4180_tar 2)
	)

(script dormant c08_4190_tar
	(sleep 84)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4190_tar tartarus 1)
	(cinematic_subtitle c08_4190_tar 2)
	)

(script dormant c08_4200_jon
	(sleep 137)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4200_jon johnson 1)
	(cinematic_subtitle c08_4200_jon 1)
	
	(unit_set_emotional_state johnson angry .5 0)	
	(print "johnson - angry .5 0")
	
	)

(script dormant c08_4201_jon
	(sleep 202)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4201_jon johnson 1)
	(cinematic_subtitle c08_4201_jon 2)
	)
	
(script dormant c08_4220_jon
	(sleep 308)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4220_jon johnson 1)
	(cinematic_subtitle c08_4220_jon 3)
	
	(unit_set_emotional_state johnson angry  1 15)	
	(print "johnson - angry 1 15")	
	
	)

(script dormant c08_4230_tar
	(sleep 430)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4230_tar tartarus 1)
	(cinematic_subtitle c08_4230_tar 1)
	)
	
(script dormant c08_4240_jon
	(sleep 474)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4240_jon johnson 1)
	(cinematic_subtitle c08_4240_jon 2)
	)
	
(script dormant c08_4250_der
	(sleep 548)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4250_der dervish 1)
	(cinematic_subtitle c08_4250_der 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c08_intra3_fov_03
	
	(sleep 184)
	(camera_set_field_of_view 5 21)
	(print "fov change: 60 -> 5 over 21 ticks")
	
	(sleep 69)
	(camera_set_field_of_view 60 0)
	(print "fov change: 5 -> 60 over 0 ticks")
	
	)

(script dormant cinematic_lighting_intra3_03
	
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting cov_sniper 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c08_intra3_03_setup

	(object_create_anew johnson)
	(object_create_anew cov_sniper)
	
	(object_cinematic_lod johnson true)
	(object_cinematic_lod cov_sniper true)
	
	(objects_attach johnson "right_hand" cov_sniper "")
	
	(wake c08_intra3_foley_03)
	
	(wake c08_4170_gsp)
	(wake c08_4180_tar)
	(wake c08_4190_tar)
	(wake c08_4200_jon)
	(wake c08_4201_jon)
	(wake c08_4220_jon)
	(wake c08_4230_tar)
	(wake c08_4240_jon)
	(wake c08_4250_der)
	
;	(wake x04_01_dof_1)
	(wake c08_intra3_fov_03)
	(wake cinematic_lighting_intra3_03)
	
	)

(script static void c08_intra3_scene_03
	
	(c08_intra3_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\08_intra3\08_intra3 "08_intra3_03" none "anchor_flag_intra3")

	(custom_animation_relative miranda objects\characters\miranda\08_intra3\08_intra3 "miranda_03" false anchor_intra3)
	(custom_animation_relative johnson objects\characters\marine\08_intra3\08_intra3 "johnson_03" false anchor_intra3)	
	(custom_animation_relative monitor objects\characters\monitor\08_intra3\08_intra3 "monitor_03" false anchor_intra3)
	
	(custom_animation_relative dervish objects\characters\dervish\08_intra3\08_intra3 "dervish_03" false anchor_intra3)	
	(custom_animation_relative tartarus objects\characters\brute\08_intra3\08_intra3 "tartarus_03" false anchor_intra3)
	(custom_animation_relative brute_01 objects\characters\brute\08_intra3\08_intra3 "brute01_03" false anchor_intra3)
	(custom_animation_relative brute_02 objects\characters\brute\08_intra3\08_intra3 "brute02_03" false anchor_intra3)
	(custom_animation_relative brute_03 objects\characters\brute\08_intra3\08_intra3 "brute03_03" false anchor_intra3)
	(custom_animation_relative brute_04 objects\characters\brute\08_intra3\08_intra3 "brute04_03" false anchor_intra3)
	
	(scenery_animation_start_relative index scenarios\objects\forerunner\industrial\index\index_full\08_intra3\08_intra3 "index_03" anchor_intra3)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(08_intra3_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_04_fol)
	
	(sleep (camera_time))
	
	)
	
; C08_INTRA3 SCENE 04 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c08_intra3_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_04_fol none 1)
	(print "c08_intra3 foley 04 start")
	)

(script dormant c08_4260_gsp
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4260_gsp monitor 1)
	(cinematic_subtitle c08_4260_gsp 6)
	
	(unit_set_emotional_state miranda shocked .25 0)
	(print "miranda - shocked .25 0")
	
	)

(script dormant c08_4270_der
	(sleep 189)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4270_der dervish 1)
	(cinematic_subtitle c08_4270_der 4)
	)
	
(script dormant c08_4280_gsp
	(sleep 297)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4280_gsp monitor 1)
	(cinematic_subtitle c08_4280_gsp 11)
	)

(script dormant c08_4290_gsp
	(sleep 640)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4290_gsp monitor 1)
	(cinematic_subtitle c08_4290_gsp 2)
	)
	
(script dormant c08_4300_der
	(sleep 746)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4300_der dervish 1)
	(cinematic_subtitle c08_4300_der 4)
	)

; ---------------------------------------------------------------------

(script static void c08_intra3_04_setup
	
	(wake c08_intra3_foley_04)

	(wake c08_4260_gsp)
	(wake c08_4270_der)
	(wake c08_4280_gsp)
	(wake c08_4290_gsp)
	(wake c08_4300_der)
	
;	(wake x04_01_dof_1)
	
	)

(script static void c08_intra3_scene_04
	
	(c08_intra3_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\08_intra3\08_intra3 "08_intra3_04" none "anchor_flag_intra3")

	(custom_animation_relative miranda objects\characters\miranda\08_intra3\08_intra3 "miranda_04" false anchor_intra3)
	(custom_animation_relative johnson objects\characters\marine\08_intra3\08_intra3 "johnson_04" false anchor_intra3)	
	(custom_animation_relative monitor objects\characters\monitor\08_intra3\08_intra3 "monitor_04" false anchor_intra3)
	
	(custom_animation_relative dervish objects\characters\dervish\08_intra3\08_intra3 "dervish_04" false anchor_intra3)	
	(custom_animation_relative tartarus objects\characters\brute\08_intra3\08_intra3 "tartarus_04" false anchor_intra3)
	
	(scenery_animation_start_relative index scenarios\objects\forerunner\industrial\index\index_full\08_intra3\08_intra3 "index_04" anchor_intra3)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(08_intra3_05_predict_stub)

	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_05_fol)
	
	(sleep (camera_time))
	
	)
	
; C08_INTRA3 SCENE 05 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c08_intra3_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_05_fol none 1)
	(print "c08_intra3 foley 05 start")
	)

(script dormant c08_4310_jon
	(sleep 74)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4310_jon johnson 1)
	(cinematic_subtitle c08_4310_jon 1)
	)
	
(script dormant c08_4320_tar
	(sleep 106)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4320_tar tartarus 1)
	(cinematic_subtitle c08_4320_tar 1)
	
	(unit_set_emotional_state miranda pain .5 0)	
	(print "miranda - pain .5 0")
	
	(sleep 45)
	
	(unit_set_emotional_state miranda scared .5 15)	
	(print "miranda - scared .5 15")
	
	)

(script dormant c08_4330_tar
	(sleep 144)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4330_tar tartarus 1)
	(cinematic_subtitle c08_4330_tar 2)
	)
	
(script dormant c08_4340_tar
	(sleep 220)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\c08_4340_tar tartarus 1)
	(cinematic_subtitle c08_4340_tar 4)
	
	(object_set_function_variable tartarus "invincibility" 1 60)
	(print "tartarus activates shield")
	
	)

; LIGHTING & EFFECTS --------------------------------------------------
	
(script dormant cinematic_lighting_intra3_05
	
	(object_uses_cinematic_lighting hammer 1)
	
	)

; ---------------------------------------------------------------------

(script dormant index_insertion
	(sleep 165)
	(print "slot the icon")
	(device_set_position repository 1)
	(effect_new_on_object_marker effects\objects\cinematics\index\index_insertion index "")
	(sleep 15)
	(object_destroy index)
	)

(script static void c08_intra3_05_setup

	(object_create_anew hammer)
	(object_cinematic_lod hammer true)

	(wake c08_intra3_foley_05)

	(wake c08_4310_jon)
	(wake c08_4320_tar)
	(wake c08_4330_tar)
	(wake c08_4340_tar)
	
	(wake index_insertion)
	
;	(wake x04_01_dof_1)

	(wake cinematic_lighting_intra3_05)
	
	)
	
(script dormant c08_intra3_05_cleanup

	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy monitor)
	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy brute_01)
	(object_destroy brute_02)
	(object_destroy brute_03)
	(object_destroy brute_04)
	(object_destroy repository)
	(object_destroy index)
	(object_destroy hammer)
	(object_destroy cov_sniper)
	
	)

(script static void c08_intra3_scene_05
	
	(c08_intra3_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\08_intra3\08_intra3 "08_intra3_05" none "anchor_flag_intra3")

	(custom_animation_relative miranda objects\characters\miranda\08_intra3\08_intra3 "miranda_05" false anchor_intra3)
	(custom_animation_relative johnson objects\characters\marine\08_intra3\08_intra3 "johnson_05" false anchor_intra3)	
	(custom_animation_relative monitor objects\characters\monitor\08_intra3\08_intra3 "monitor_05" false anchor_intra3)
	
	(custom_animation_relative dervish objects\characters\dervish\08_intra3\08_intra3 "dervish_05" false anchor_intra3)	
	(custom_animation_relative tartarus objects\characters\brute\08_intra3\08_intra3 "tartarus_05" false anchor_intra3)
	(custom_animation_relative brute_01 objects\characters\brute\08_intra3\08_intra3 "brute01_05" false anchor_intra3)
	(custom_animation_relative brute_02 objects\characters\brute\08_intra3\08_intra3 "brute02_05" false anchor_intra3)
	(custom_animation_relative brute_03 objects\characters\brute\08_intra3\08_intra3 "brute03_05" false anchor_intra3)
	(custom_animation_relative brute_04 objects\characters\brute\08_intra3\08_intra3 "brute04_05" false anchor_intra3)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\08_intra3\08_intra3 "hammer_05" anchor_intra3)
	(scenery_animation_start_relative index scenarios\objects\forerunner\industrial\index\index_full\08_intra3\08_intra3 "index_05" anchor_intra3)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(08_intra3_06_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra3\music\c08_intra3_06_mus)	
	(sound_impulse_predict sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_06_fol)
	
	(sleep (camera_time))
	
	(wake c08_intra3_05_cleanup)
	
	)
	
; C08_INTRA3 SCENE 06 -------------------------------------------------

(script dormant create_lift

	(print "create lift")
	(object_create_anew c08_intra3_lift)
	(object_set_function_variable c08_intra3_lift "effect" 0 0)
	(sleep 10)
	(object_set_function_variable c08_intra3_lift "effect" 1 60)
	
	)

(script static void c08_intra3_scene_06

	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra3\music\c08_intra3_06_mus none 1)
	(sound_impulse_start sound\cinematics\08_deltacliffs\c08_intra3\foley\c08_intra3_06_fol none 1)

	(device_set_position e13_boss_platform 1)
	
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 3)

	(camera_set platform_01a 0)
	(camera_set platform_01b 420)
	(sleep 300)
	
	(wake create_lift)
	(sleep 30)
	
	(camera_set platform_02 0)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 5 0 0 0 2 2 0)
	(sleep 30)
	(cinematic_screen_effect_set_depth_of_field 5 0 2 .5 2 0 .5)
	(sleep 45)
	
	(player_effect_stop 1.5)
	
	(sleep 15)
	
	(print "fade to white")
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(cinematic_screen_effect_stop)
	(object_destroy c08_intra3_lift)
	(sound_class_set_gain amb 0 15)
	
	(sleep 30)
	
	)
	
; C08_INTRA3 MASTER SCRIPT ============================================
; =====================================================================

(script static void c08_intra3

	(texture_cache_flush)
	(geometry_cache_flush)

	(switch_bsp_by_name deltacontrolroom_bsp3)
	(sleep 1)
	
	(c08_intra3_scene_01)
	(c08_intra3_scene_02)
	(c08_intra3_scene_03)
	(c08_intra3_scene_04)
	(c08_intra3_scene_05)
	(c08_intra3_scene_06)
	
	(rasterizer_bloom_override 0)
	
	)

; X09 SCENE 01 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x09_foley_1
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\foley\x09_01_fol none 1)
	(print "x09 foley 01 start")
	)

(script dormant x09_01_stop_sounds
	(sleep 383)
	(print "sound looping stop")
	(sound_looping_stop scenarios\solo\08b_deltacontrol\08b_music\08b_11)
	(sound_looping_stop scenarios\solo\08b_deltacontrol\08b_music\08b_12)
	(sound_looping_stop scenarios\solo\08b_deltacontrol\08b_music\08b_13)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x09_01
	
	(cinematic_lighting_set_primary_light -4 206 0.454902 0.435294 0.352941)
	(cinematic_lighting_set_secondary_light -69 234 0.152941 0.152941 0.227451)
	(cinematic_lighting_set_ambient_light 0.0862745 0.0862745 0.0862745)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .4) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting rotors_x09 1)
	
	)
	
(script dormant x09_fov_01

	(time_code_reset)
	
	(sleep 289)
	(camera_set_field_of_view 35 0)
	(print "fov change: 60 -> 35 over 0 ticks")

	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x09_problem_actors_01
	(print "problem actors")
	
	(object_create_anew miranda)
	(object_create_anew rotors_x09)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod rotors_x09 true)
	
	)
	
(script static void x09_problem_actors_02
	(print "problem actors")
	(object_create_anew index_x09)
	(object_cinematic_lod index_x09 true)
	)

; ---------------------------------------------------------------------

(script dormant x09_miranda_emotion_01
	(unit_set_emotional_state miranda angry .25 0)
	(sleep 186)
	(unit_set_emotional_state miranda shocked .5 30)
	(sleep 71)
	(unit_set_emotional_state miranda pain .5 30)
	)

(script static void x09_01_setup

	(object_destroy e13_rotors)
	
	(wake x09_miranda_emotion_01)

	(wake x09_01_stop_sounds)

	(wake x09_foley_1)
	(wake  x09_fov_01)
	
	(wake cinematic_lighting_x09_01)
	
	)

; ---------------------------------------------------------------------

(script static void x09_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start_movie "deltacontrol_1")
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
	(x09_problem_actors_01)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x09_01_predict_stub)
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\foley\x09_01_fol)
	(sleep prediction_offset)
	
	(sleep 30)
	
	(x09_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x09\x09 "x09_01" none "anchor_flag_x09_01")

	(custom_animation_relative miranda objects\characters\miranda\x09\x09 "miranda_01" false anchor_x09_01)
	(scenery_animation_start_relative rotors_x09 scenarios\objects\solo\deltacontrolroom\control_rotors\x09\x09 "control_rotors_01" anchor_x09_01)

	(fade_in 1 1 1 15)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x09_02_predict_stub)
	(x09_problem_actors_02)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\music\x09_02_mus)	
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\foley\x09_02_fol)
	
	(sleep (camera_time))
	
	(object_destroy rotors_x09)
	
	)
	
; X09 SCENE 02 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x09_score_2
	(sleep 92)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\music\x09_02_mus none 1)
	(print "x09 score 01 start")
	)

(script dormant x09_foley_2
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\foley\x09_02_fol none 1)
	(print "x09 foley 02 start")
	)

(script dormant cinematic_lighting_x09_02
	
	(cinematic_lighting_set_primary_light -18 166 0.454902 0.435294 0.352941)
	(cinematic_lighting_set_secondary_light -10 78 0.152941 0.152941 0.227451)
	(cinematic_lighting_set_ambient_light 0.0862745 0.0862745 0.0862745)
	
	(object_uses_cinematic_lighting index_x09 1)
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x09_dof_01
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field .5 1 1 0 0 0 0)
	(print "rack focus")
	(sleep 45)
	(cinematic_screen_effect_set_depth_of_field .5 1 0 .25 0 1 .25)
	(print "rack focus")
	)
	
; ---------------------------------------------------------------------

(script dormant lift_deactivate
	(sleep 93)
	(print "lift deactivate")
	(object_set_function_variable x09_lift effect 0 90)
	(sound_class_set_gain device 0 30)
	)

(script dormant x09_miranda_emotion_02
	(unit_set_emotional_state miranda angry .25 0)
	(sleep 137)
	(unit_set_emotional_state miranda scared .5 90)
	)

(script static void x09_02_setup

	(wake x09_score_2)
	(wake x09_foley_2)

	(wake lift_deactivate)
	(wake x09_miranda_emotion_02)

;	(wake x09_dof_01)
	(wake cinematic_lighting_x09_02)
	
	)

(script static void x09_scene_02

	(camera_set_field_of_view 60 0)
	
	(x09_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x09\x09 "x09_02" none "anchor_flag_x09_01")

	(custom_animation_relative miranda objects\characters\miranda\x09\x09 "miranda_02" false anchor_x09_01)
	(scenery_animation_start_relative index_x09 scenarios\objects\forerunner\industrial\index\index_full\x09\x09 "index_02" anchor_x09_01)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x09_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\foley\x09_03_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(cinematic_screen_effect_stop)
	
	)

; X09 SCENE 03 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x09_foley_3
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\foley\x09_03_fol none 1)
	(print "x09 foley 03 start")
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x09_problem_actors_04
	(print "predict: problem actors")
	
	(object_create_anew halo)
	(object_create_anew matte_halo)
	
	(object_cinematic_lod halo true)
	(object_cinematic_lod matte_halo true)

	)

; ---------------------------------------------------------------------

(script static void x09_03_setup

	(object_create_anew x09_halo_bang)

	(wake x09_foley_3)

	)

(script static void x09_scene_03

	(sleep 15)
	
	(x09_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x09\x09 "x09_03" none "anchor_flag_x09_03")

	(sleep 10)
	
	(fade_in 1 1 1 15)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x09_04_predict_stub)
	(x09_problem_actors_04)
	
	(cinematic_screen_effect_start true)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\foley\x09_04_fol)

	(sleep (- (camera_time) 5))	
	
	(fade_out 1 1 1 5)
	(sleep 5)
	
	)	

; X09 SCENE 04 --------------------------------------------------------

(script dormant x09_foley_4
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\foley\x09_04_fol none 1)
	(print "x09 foley 04 start")
	)

(script dormant cinematic_lighting_x09_04
	
	(cinematic_lighting_set_primary_light 34 146 0.51 0.79 0.99)
	(cinematic_lighting_set_secondary_light 6 118 0.18 0.22 0.41)
	(cinematic_lighting_set_ambient_light 0.05 0.05 0.05)
	
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting halo 1)
	
	)

; ---------------------------------------------------------------------

(script static void x09_04_setup

;	(object_create_anew halo)
	(object_create_anew matte_substance)
	(object_create_anew matte_high_charity)
	
;	(object_cinematic_lod halo true)
	(object_cinematic_lod matte_substance true)
	(object_cinematic_lod matte_high_charity true)
	
	(object_create_anew x09_halo_whimper)

	(wake x09_foley_4)

	(wake cinematic_lighting_x09_04)
	
	)
	
(script static void x09_scene_04_cleanup

	(object_destroy halo)
	(object_destroy_containing matte)

	)

(script static void x09_scene_04
	
	(x09_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x09\x09 "x09_04" none "anchor_flag_x09_02")

	(scenery_animation_start_relative halo scenarios\objects\forerunner\industrial\halo\x09\x09 "halo_04" anchor_x09_02)
	(scenery_animation_start_relative matte_halo objects\cinematics\matte_paintings\delta_halo_quarter\x09\x09 "delta_halo_quarter_04" anchor_x09_02)
	(scenery_animation_start_relative matte_substance objects\cinematics\matte_paintings\substance_space\x09\x09 "substance_space_04" anchor_x09_02)
	(scenery_animation_start_relative matte_high_charity objects\cinematics\matte_paintings\high_charity_exterior\x09\x09 "high_charity_exterior_04" anchor_x09_02)
	
	(sleep 10)
	(fade_in 1 1 1 5)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x09_05_predict_stub)
	(cinematic_screen_effect_start true)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\foley\x09_05_fol)
	
	(sleep (- (camera_time) 90))	

	(fade_out 0 0 0 90)
	(sleep 90)
	
	(x09_scene_04_cleanup)
	
	)	
	
; X09 SCENE 05 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x09_foley_5
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\foley\x09_05_fol none 1)
	(print "x09 foley 05 start")
	)

(script dormant x09_0010_mir
	(sleep 188)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0010_mir miranda 1)
	(cinematic_subtitle x09_0010_mir 1)
	)

(script dormant x09_0020_gsp
	(sleep 214)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0020_gsp monitor 1)
	(cinematic_subtitle x09_0020_gsp 1)
	)

(script dormant x09_0030_mir
	(sleep 251)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0030_mir miranda 1)
	(cinematic_subtitle x09_0030_mir 1)
	)

(script dormant x09_0040_gsp
	(sleep 280)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0040_gsp monitor 1)
	(cinematic_subtitle x09_0040_gsp 3)
	)
	
(script dormant x09_0050_mir
	(sleep 370)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0050_mir miranda 1)
	(cinematic_subtitle x09_0050_mir 2)
	)
	
(script dormant x09_0060_gsp
	(sleep 419)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0060_gsp monitor 1)
	(cinematic_subtitle x09_0060_gsp 2)
	)

(script dormant x09_0070_mir
	(sleep 469)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0070_mir miranda 1)
	(cinematic_subtitle x09_0070_mir 1)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x09_05
	
	(cinematic_lighting_set_primary_light -18 220 0.286275 0.270588 0.219608)
	(cinematic_lighting_set_secondary_light 13 176 0.152941 0.152941 0.227451)
	(cinematic_lighting_set_ambient_light 0.0862745 0.0862745 0.0862745)
	
	(rasterizer_bloom_override_threshold .4) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting monitor 1)
	(object_uses_cinematic_lighting index_x09 1)
	
	)
	
; ---------------------------------------------------------------------

(script dormant beacon_shuffle
	
	(sleep 140)
	(print "beacon 01 -> beacon 02")
	(object_destroy beacon_01)
	(object_create_anew beacon_02)

	)

(script dormant x09_miranda_emotion_05
	(sleep 467)
	(unit_set_emotional_state miranda angry .5 30)
	)

(script static void x09_05_setup

	(object_destroy e13_rotors)
	(object_destroy x09_lift)

	(object_create_anew johnson)
	(object_create_anew monitor)
	(object_create_anew beacon_01)
	
	(object_cinematic_lod johnson true)
	(object_cinematic_lod monitor true)
	
	(unit_set_emotional_state miranda inquisitive 1 0)
	(wake x09_miranda_emotion_05)

	(wake x09_foley_5)

	(wake x09_0010_mir)
	(wake x09_0020_gsp)
	(wake x09_0030_mir)
	(wake x09_0040_gsp)
	(wake x09_0050_mir)
	(wake x09_0060_gsp)
	(wake x09_0070_mir)
	
	(wake beacon_shuffle)

	(wake cinematic_lighting_x09_05)
	(interpolator_start x09_fog 1 1)
	
	)

(script static void x09_scene_05
	
	(x09_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x09\x09 "x09_05" none "anchor_flag_x09_01")

	(custom_animation_relative miranda objects\characters\miranda\x09\x09 "miranda_05" false anchor_x09_01)
	(custom_animation_relative johnson objects\characters\marine\x09\x09 "johnson_05" false anchor_x09_01)
	(custom_animation_relative monitor objects\characters\monitor\x09\x09 "monitor_05" false anchor_x09_01)

	(scenery_animation_start_relative index_x09 scenarios\objects\forerunner\industrial\index\index_full\x09\x09 "index_05" anchor_x09_01)

	(sleep 15)

	(fade_in 0 0 0 90)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x09_06_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\foley\x09_06_fol)
	
	(sleep (camera_time))
	
	)
	
; X09 SCENE 06 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x09_foley_6
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\foley\x09_06_fol none 1)
	(print "x09 foley 06 start")
	)

(script dormant x09_0080_gsp
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0080_gsp monitor 1)
	(cinematic_subtitle x09_0080_gsp 10)
	)

(script dormant x09_0090_mir
	(sleep 310)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0090_mir miranda 1)
	(cinematic_subtitle x09_0090_mir 2)
	
;	(unit_set_emotional_state miranda repulsed .25 0)
;	(print "miranda - repulsed .25 0")
	
	)

(script dormant x09_0100_gsp
	(sleep 386)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0100_gsp monitor 1)
	(cinematic_subtitle x09_0100_gsp 1)
	)
	
(script dormant x09_0110_jon
	(sleep 430)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0110_jon johnson 1)
	(cinematic_subtitle x09_0110_jon 2)
	)
	
(script dormant x09_0120_mir
	(sleep 494)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0120_mir miranda 1)
	(cinematic_subtitle x09_0120_mir 4)
	
	(sleep 30)
;	(unit_set_emotional_state miranda pain .25 15)
;	(print "miranda - pain .25 15")
	
	)
	
(script dormant x09_0130_gsp
	(sleep 675)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0130_gsp monitor 1)
	(cinematic_subtitle x09_0130_gsp 2)
	)

(script dormant x09_0140_der
	(sleep 742)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0140_der dervish 1)
	(cinematic_subtitle x09_0140_der 3)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x09_06
	
	(cinematic_lighting_set_primary_light -18 220 0.286275 0.270588 0.219608)
	(cinematic_lighting_set_secondary_light 13 176 0.152941 0.152941 0.227451)
	(cinematic_lighting_set_ambient_light 0.0862745 0.0862745 0.0862745)
	
	(object_uses_cinematic_lighting dervish 1)
	
	)
	
; ---------------------------------------------------------------------

(script dormant x09_miranda_emotion_06a
	(sleep 310)
	(unit_set_emotional_state miranda scared .5 60)
	)
	
(script dormant x09_miranda_emotion_06b
	(sleep 525)
	(unit_set_emotional_state miranda pain .25 90)
	)
	
(script dormant x09_miranda_emotion_06c
	(sleep 776)
	(unit_set_emotional_state miranda shocked .25 30)
	)

(script dormant x09_johnson_emotion_06a
	(sleep 440)
	(unit_set_emotional_state johnson angry .75 60)
	(sleep 54)
	(unit_set_emotional_state johnson shocked .25 30)
	)
	
(script dormant x09_johnson_emotion_06b
	(sleep 784)
	(unit_set_emotional_state johnson shocked .25 30)
	)

(script static void x09_06_setup

	(object_destroy beacon_02)
	(object_create_anew beacon_03)

	(device_set_position beacon_03 1)

	(object_create_anew dervish)
	(object_cinematic_lod dervish true)
	
	(unit_set_emotional_state miranda angry .25 0)
	(unit_set_emotional_state johnson angry .25 0)
	
	(wake x09_miranda_emotion_06a)
	(wake x09_miranda_emotion_06b)
	(wake x09_miranda_emotion_06c)
	(wake x09_johnson_emotion_06a)
	(wake x09_johnson_emotion_06b)

	(wake x09_foley_6)

	(wake x09_0080_gsp)
	(wake x09_0090_mir)
	(wake x09_0100_gsp)
	(wake x09_0110_jon)
	(wake x09_0120_mir)
	(wake x09_0130_gsp)
	(wake x09_0140_der)
	
	)

(script static void x09_scene_06_cleanup

	(object_destroy dervish)
	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy monitor)
	(object_destroy index_x09)

	)

(script static void x09_scene_06
	
	(x09_06_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x09\x09 "x09_06" none "anchor_flag_x09_01")

	(custom_animation_relative dervish objects\characters\dervish\x09\x09 "dervish_06" false anchor_x09_01)
	(custom_animation_relative miranda objects\characters\miranda\x09\x09 "miranda_06" false anchor_x09_01)
	(custom_animation_relative johnson objects\characters\marine\x09\x09 "johnson_06" false anchor_x09_01)
	(custom_animation_relative monitor objects\characters\monitor\x09\x09 "monitor_06" false anchor_x09_01)

	(scenery_animation_start_relative index_x09 scenarios\objects\forerunner\industrial\index\index_full\x09\x09 "index_06" anchor_x09_01)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x09_07_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\foley\x09_07_fol)

	(sleep (- (camera_time) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(x09_scene_06_cleanup)
	
	)
	
; X09 SCENE 07 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x09_foley_7
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\foley\x09_07_fol none 1)
	(print "x09 foley 07 start")
	)

(script dormant x09_0150_to1
	(sleep 100)
	(sound_impulse_start_effect sound\dialog\levels\08_controlroom\cinematic\x09_0150_to1 none 1 radio_default_in)
	(cinematic_subtitle x09_0150_to1 3)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x09_07
	
	(cinematic_lighting_set_primary_light 16 -32 .8 .6 .4)
	(cinematic_lighting_set_secondary_light 20 180 .3 .3 .5)
	(cinematic_lighting_set_ambient_light .2 .2 .2)
	
	(object_uses_cinematic_lighting forerunner_ship 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x09_problem_actors_08
	(print "problem actors")
	(object_create_anew chief)
	(object_create_anew x09_alcove)
	(object_create_anew bloom_quad)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod x09_alcove true)
	)
	
; ---------------------------------------------------------------------

(script static void x09_07_setup
	
	(object_create_anew slipspace)
	(object_create_anew_containing earth_battle)
	(object_create_anew forerunner_ship)
	(object_create_anew matte_earth)
	(object_create_anew matte_moon)
	
	(object_cinematic_lod forerunner_ship true)
	(object_cinematic_lod matte_earth true)
	(object_cinematic_lod matte_moon true)

	(wake x09_foley_7)

	(wake x09_0150_to1)

	(wake cinematic_lighting_x09_07)
	
	)
	
(script static void x09_scene_07_cleanup

	(object_destroy slipspace)
	(object_destroy_containing earth_battle)
	(object_destroy forerunner_ship)
	(object_destroy_containing matte)
	
	)

(script static void x09_scene_07

	(sleep 60)
	
	(x09_07_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x09\x09 "x09_07" none "anchor_flag_x09_02")

	(scenery_animation_start_relative forerunner_ship objects\cinematics\forerunner\forerunner_ship\x09\x09 "forerunner_ship_07" anchor_x09_02)
	(scenery_animation_start_relative cairo scenarios\objects\solo\spacestation\ss_prop\x09\x09 "ss_prop_07" anchor_x09_02)	
	
	(scenery_animation_start_relative matte_earth objects\cinematics\matte_paintings\earth_space\x09\x09 "earth_space_07" anchor_x09_02)
	(scenery_animation_start_relative matte_moon objects\cinematics\matte_paintings\moon\x09\x09 "moon_07" anchor_x09_02)
	
	(fade_in 0 0 0 5)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x09_08_predict_stub)
	(x09_problem_actors_08)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\music\x09_08_mus)
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x09\foley\x09_03_fol)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 1 1 1 5)
	(sleep 5)
	
	(x09_scene_07_cleanup)
	
	)
	
; X09 SCENE 08 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x09_score_8
	(sleep 338)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\music\x09_08_mus none 1)
	(print "x09 score 08 start")
	)

(script dormant x09_foley_8
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x09\foley\x09_08_fol none 1)
	(print "x09 foley 08 start")
	)

(script dormant x09_0160_lhd
	(sleep 0)
	(sound_impulse_start_effect sound\dialog\levels\08_controlroom\cinematic\x09_0160_lhd none 1 radio_default_loop)
	(cinematic_subtitle x09_0160_lhd 2)
	)

(script dormant x09_0180_mas
	(sleep 69)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0180_mas chief 1)
	(cinematic_subtitle x09_0180_mas 2)
	)

(script dormant x09_0190_mas
	(sleep 132)
	(sound_impulse_start_effect sound\dialog\levels\08_controlroom\cinematic\x09_0190_mas none 1 radio_default_out)
	(cinematic_subtitle x09_0190_mas 2)
	)
	
(script dormant x09_0200_lhd
	(sleep 183)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0200_lhd hood 1)
	(cinematic_subtitle x09_0200_lhd 1)
	)
	
(script dormant x09_0210_lhd
	(sleep 232)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0210_lhd hood 1)
	(cinematic_subtitle x09_0210_lhd 3)
	)
	
(script dormant x09_0220_mas
	(sleep 342)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x09_0220_mas chief 1)
	(cinematic_subtitle x09_0220_mas 3)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_light_x09_chief_01

	(print "light chief 01")
	
	(cinematic_lighting_set_primary_light -20 278 0.388235 0.427451 0.494118)
	(cinematic_lighting_set_secondary_light 42 224 0.0431373 0.0431373 0.0666667)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting hood 1)
	(object_uses_cinematic_lighting cairo_bridge 1)
	(object_uses_cinematic_lighting x09_alcove 1)
	
	)
	
(script dormant cinematic_light_x09_hood_01
	
	(sleep 124)
	(print "light hood 01")
	
	(cinematic_lighting_set_primary_light 0 94 0.47451 0.443137 0.333333)
	(cinematic_lighting_set_secondary_light 0 320 0.184314 0.176471 0.266667)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)
	
	)
	
(script dormant final_explosion
	(time_code_reset)
	(sleep 135)	
	(object_create_anew_containing blast_base)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion blast_base "marker")
	(sleep 110)
	(effect_new_on_object_marker effects\cinematics\01_outro\covenant_tiny_explosion blast_base2 "marker")
	)

(script dormant cinematic_light_x09_chief_02
	
	(sleep 277)
	(print "light chief 02")
	
	(cinematic_lighting_set_primary_light -20 278 0.388235 0.427451 0.494118)
	(cinematic_lighting_set_secondary_light 42 224 0.0431373 0.0431373 0.0666667)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	)

; ---------------------------------------------------------------------

(script dormant x09_hood_emotion_08
	(sleep 43)
	(unit_set_emotional_state hood shocked .5 30)
	(sleep 45)
	(unit_set_emotional_state hood happy .25 90)
	)
	
(script dormant shake_chief
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .75 0)
	(sleep 15)
	(player_effect_stop 3)
	)
	
(script static void x09_08_setup

	(object_create_anew hood)
	(object_create_anew cairo_bridge)
	
	(object_cinematic_lod hood true)
	(object_cinematic_lod cairo_bridge true)
	
	(object_create_anew_containing cairo_effect)
	
	(unit_set_emotional_state hood angry .5 0)
	(wake x09_hood_emotion_08)

	(wake x09_score_8)
	(wake x09_foley_8)

	(wake x09_0160_lhd)
	(wake x09_0180_mas)
	(wake x09_0190_mas)
	(wake x09_0200_lhd)
	(wake x09_0210_lhd)
	(wake x09_0220_mas)
	
	(wake shake_chief)
	(wake final_explosion)
	
	(wake cinematic_light_x09_chief_01)
	(wake cinematic_light_x09_hood_01)
	(wake cinematic_light_x09_chief_02)
	
	)

(script static void x09_scene_08_cleanup

	(object_destroy chief)
	(object_destroy hood)
	(object_destroy cairo_bridge)
	(object_destroy x09_alcove)
	(object_destroy bloom_quad)
	(object_destroy_containing blast_base)
	
	)

(script static void x09_scene_08
	
	(x09_08_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x09\x09 "x09_08" none "anchor_flag_x09_02")

	(custom_animation_relative chief objects\characters\masterchief\x09\x09 "chief_08" false anchor_x09_02)
	(custom_animation_relative hood objects\characters\lord_hood\x09\x09 "hood_08" false anchor_x09_02)

	(scenery_animation_start_relative cairo_bridge objects\cinematics\human\cairo_bridge\x09\x09 "cairo_bridge_08" anchor_x09_02)
	(scenery_animation_start_relative x09_alcove objects\cinematics\forerunner\forerunner_ship_alcove\x09\x09 "alcove_08" anchor_x09_02)
	(scenery_animation_start_relative bloom_quad scenarios\objects\special\bloom_quad\x09\x09 "bloom_quad_08" anchor_x09_02)
	
; 	safety white
	
	(sleep 10)
	(fade_in 1 1 1 5)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(sleep 401)
	
	(x09_scene_08_cleanup)
	
	(rasterizer_bloom_override 0)
	
	)

; X10 SCENE 01 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x10_score_1
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x10\music\x10_01_mus none 1)
	(print "x10 score 01 start")
	)

(script dormant x10_foley_1
	(sleep 0)
	(sound_impulse_start sound\cinematics\08_deltacliffs\x10\foley\x10_01_fol none 1)
	(print "x10 foley 01 start")
	)

(script dormant x10_0010_grv
	(sleep 496)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x10_0010_grv none 1)
	(cinematic_subtitle x10_0010_grv 6)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x10_01
	
	(cinematic_lighting_set_primary_light 51 28 0.380392 0.384314 0.341176)
	(cinematic_lighting_set_secondary_light -53 202 0.0588235 0.356863 0.356863)
	(cinematic_lighting_set_ambient_light 0.0901961 0.117647 0.0823529)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting tentacle_01 1)
	(object_uses_cinematic_lighting tentacle_02 1)
	(object_uses_cinematic_lighting tentacle_03 1)
	(object_uses_cinematic_lighting tentacle_04 1)
	
	)

; PREDICTION ----------------------------------------------------------

(script static void x10_problem_actors_01
	(print "problem actors")
	(object_create_anew spore_01)
	(object_create_anew spore_02)
	(object_create_anew spore_03)
	(object_cinematic_lod spore_01 true)
	(object_cinematic_lod spore_02 true)
	(object_cinematic_lod spore_03 true)
	)

; ---------------------------------------------------------------------

(script static void x10_scene_01_setup

	(object_create_anew x09_chamber_door)
	(object_create_anew tentacle_01)
	(object_create_anew tentacle_02)
	(object_create_anew tentacle_03)
	(object_create_anew tentacle_04)
	
	(object_cinematic_lod x09_chamber_door true)
	(object_cinematic_lod tentacle_01 true)
	(object_cinematic_lod tentacle_02 true)
	(object_cinematic_lod tentacle_03 true)
	(object_cinematic_lod tentacle_04 true)

	(object_cinematic_visibility tentacle_01 true)
	(object_cinematic_visibility tentacle_02 true)
	(object_cinematic_visibility tentacle_03 true)
	(object_cinematic_visibility tentacle_04 true)

	(wake x10_score_1)
	(wake x10_foley_1)

	(wake x10_0010_grv)
	
	(wake cinematic_lighting_x10_01)
	
	)

(script static void x10_scene_01_cleanup

	(object_destroy x09_chamber_door)
	(object_destroy_containing spore)
	
	)

(script static void x10_scene_01
	
	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start_movie "deltacontrol_2")
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(weather_start 0)
	(weather_change_intensity 0 1)
	
	(x10_problem_actors_01)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x10_01_predict_stub)
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x10\music\x10_01_mus)
	(sound_impulse_predict sound\cinematics\08_deltacliffs\x10\foley\x10_01_fol)
	(sleep prediction_offset)
	
	(x10_scene_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x10\x10 "x10_01" none "anchor_flag_x10")

	(scenery_animation_start_relative x09_chamber_door scenarios\objects\solo\highcharity\high_door_grand\x10\x10 "high_door_grand_01" anchor_x10)
	(scenery_animation_start_relative spore_01 objects\cinematics\flood\flood_spore\x10\x10 "spore01_01" anchor_x10)
	(scenery_animation_start_relative spore_02 objects\cinematics\flood\flood_spore\x10\x10 "spore02_01" anchor_x10)
	(scenery_animation_start_relative spore_03 objects\cinematics\flood\flood_spore\x10\x10 "spore03_01" anchor_x10)
	(scenery_animation_start_relative tentacle_01 objects\characters\gravemind\tentacle_capture\x10\x10 "tentacle01_01" anchor_x10)
	(scenery_animation_start_relative tentacle_02 objects\characters\gravemind\tentacle_capture\x10\x10 "tentacle02_01" anchor_x10)
	(scenery_animation_start_relative tentacle_03 objects\characters\gravemind\tentacle_capture\x10\x10 "tentacle03_01" anchor_x10)

	(fade_in 0 0 0 60)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x10_02_predict_stub)
	
	(cinematic_screen_effect_start true)

	(sleep (- (camera_time) 1))
	
	(cinematic_screen_effect_set_crossfade 2)
	(sleep 1)
	
	(x10_scene_01_cleanup)
	
	)
	
; X10 SCENE 02 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x10_score_2
	(sleep 553)
	(sound_looping_start sound\cinematics\08_deltacliffs\x10\music\x10_02_mus none 1)
	(print "x10 score 02 start")
	)

(script dormant x10_0020_grv
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x10_0020_grv none 1)
	(cinematic_subtitle x10_0020_grv 8)
	)
	
(script dormant x10_0030_grv
	(sleep 260)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x10_0030_grv none 1)
	(cinematic_subtitle x10_0030_grv 5)
	)
	
(script dormant x10_0040_cor
	(sleep 496)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x10_0040_cor cortana 1)
	(cinematic_subtitle x10_0040_cor 1)
	)
	
(script dormant x10_0041_cor
	(sleep 520)
	
	(unit_set_emotional_state cortana pain .25 60)
	(print "cortana - pain .25 60")
	
	(sleep 30)
	(sound_impulse_start sound\dialog\levels\08_controlroom\cinematic\x10_0041_cor cortana 1)
	(cinematic_subtitle x10_0041_cor 1)

	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_x10_02
	
	(cinematic_lighting_set_primary_light 51 28 0.380392 0.384314 0.341176)
	(cinematic_lighting_set_secondary_light -53 202 0.0588235 0.356863 0.356863)
	(cinematic_lighting_set_ambient_light 0.0901961 0.117647 0.0823529)
	
	(object_uses_cinematic_lighting cortana 1)
	
	)
	
; ---------------------------------------------------------------------

(script dormant effect_cortana_appear
	(sleep 410)
	(print "cortana appears")
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_65 cortana_stand "marker")
	)

(script static void x10_scene_02_setup

	(object_create_anew cortana)
	(object_cinematic_lod cortana true)
	
	(object_create_anew cortana_stand)
	
	(unit_set_emotional_state cortana repulsed .5 0)
	(print "cortana - repulsed .5 0")

	(wake x10_score_2)

	(wake x10_0020_grv)
	(wake x10_0030_grv)
	(wake x10_0040_cor)
	(wake x10_0041_cor)
	
	(wake effect_cortana_appear)
	(wake cinematic_lighting_x10_02)
	
	(cinematic_set_near_clip_distance .05)
	(print "setting near clip distance to .05")
	
	)

(script static void x10_scene_02_cleanup

	(object_destroy_containing cortana)
	(object_destroy_containing tentacle)
	
	)

(script static void x10_scene_02

	(time_code_reset)
	
	(x10_scene_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x10\x10 "x10_02" none "anchor_flag_x10")

	(custom_animation_relative cortana objects\characters\cortana\x10\x10 "cortana_02" false anchor_x10)

	(scenery_animation_start_relative tentacle_01 objects\characters\gravemind\tentacle_capture\x10\x10 "tentacle01_02" anchor_x10)
	(scenery_animation_start_relative tentacle_02 objects\characters\gravemind\tentacle_capture\x10\x10 "tentacle02_02" anchor_x10)
	(scenery_animation_start_relative tentacle_03 objects\characters\gravemind\tentacle_capture\x10\x10 "tentacle03_02" anchor_x10)
	(scenery_animation_start_relative tentacle_04 objects\characters\gravemind\tentacle_capture\x10\x10 "tentacle04_02" anchor_x10)

	(sleep (- (camera_time) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(cinematic_set_near_clip_distance .06)
	(print "setting near clip distance to .06")
	
	(sleep 328)
	
	)
	
(script static void x10

;	(texture_cache_flush)
;	(geometry_cache_flush)

	(switch_bsp_by_name high_0)
	(sleep 1)

	(x10_scene_01)
	(x10_scene_02)
	
	)

; X09 MASTER SCRIPT ===================================================
; =====================================================================

(script static void x09
	
	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name deltacontrolroom_bsp4)
	(sleep 1)
	
	(sound_class_set_gain amb 0 15)
	
	(x09_scene_01)
	(x09_scene_02)
	
	(switch_bsp_by_name deltacontrolroom_bsp0)
	(sleep 1)
	
	(x09_scene_03)
	(x09_scene_04)
	
	(switch_bsp_by_name deltacontrolroom_bsp4)
	(sleep 1)

	(x09_scene_05)
	(x09_scene_06)
	
	(switch_bsp_by_name deltacontrolroom_bsp0)
	(sleep 1)
	
	(x09_scene_07)
	(x09_scene_08)
	
	(sleep 90)
	(print "90 ticks of black instead of credits")
	
;	(cinematic_show_letterbox 0)
	
;	(play_credits)
;	(sleep (bink_time))
;	(sleep_until (bink_done) 1)
	
	(x10)
	
	(sleep 30)
	(print "30 ticks of black for marty2")
	
	(game_won)
	
	)
	