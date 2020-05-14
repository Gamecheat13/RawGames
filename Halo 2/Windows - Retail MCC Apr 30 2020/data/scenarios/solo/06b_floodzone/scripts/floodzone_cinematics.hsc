; CINEMATICS FOR 06B, "FLOOD ZONE" ====================================
;======================================================================

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)

	(script stub void 06_intra1_01_predict_stub (print "predict 01"))

	(script stub void 06_intra2_01_predict_stub (print "predict 01"))
	(script stub void 06_intra2_02_predict_stub (print "predict 02"))
	(script stub void 06_intra2_03_predict_stub (print "predict 03"))

	(script stub void x07_01_predict_stub (print "predict 01"))
	(script stub void x07_02_predict_stub (print "predict 02"))
	(script stub void x07_03_predict_stub (print "predict 03"))
	(script stub void x07_04_predict_stub (print "predict 04"))
	(script stub void x07_05_predict_stub (print "predict 05"))
	(script stub void x07_06_predict_stub (print "predict 06"))

; C06_INTRA_1 SCENE 01 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c06_intra1_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\c06_intra1\music\c06_intra1_01_mus none 1)
	(print "c06_intra1 score 01 start")
	)
	
(script dormant c06_intra1_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\c06_intra1\foley\c06_intra1_01_fol none 1)
	(print "c06_intra1 foley 01 start")
	)

(script dormant c06_2070_der
	(sleep 69)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_2070_der dervish_intra1 1)
	(cinematic_subtitle c06_2070_der 7)
	)

(script dormant c06_2090_soc
	(sleep 303)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_2090_soc commander_intra1 1)
	(cinematic_subtitle c06_2090_soc 8)
	)
	
(script dormant c06_2101_elc
	(sleep 533)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_2101_elc none 1)
	(cinematic_subtitle c06_2101_elc 3)
	)
	
(script dormant c06_2110_soc
	(sleep 610)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_2110_soc commander_intra1 1)
	(cinematic_subtitle c06_2110_soc 3)
	)
	
(script dormant c06_2120_soc
	(sleep 693)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_2120_soc commander_intra1 1)
	(cinematic_subtitle c06_2120_soc 2)
	)
	
; LIGHTING & EFFECTS --------------------------------------------------

(script dormant c06_intra1_dof_01
	
	(sleep 0)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 5 1 1 0 0 0 0)
	(print "rack focus")
	
	(sleep 165)
	
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)

(script dormant c06_intra1_dof_02

	(time_code_reset)
	
	(sleep 587)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 3 0 0 0 .5 .5 0)
	(print "rack focus")
	
	(object_destroy_containing elite)
	
	(sleep 190)
	(cinematic_screen_effect_set_depth_of_field 3 0 .5 1 .5 0 1)
	(print "rack focus")
	
	)

(script dormant c06_intra1_cinematic_light
	
	(cinematic_lighting_set_primary_light -20 282 0.21 0.29 0.37)
	(cinematic_lighting_set_secondary_light -59 306 0.34 0.58 0.65)
	(cinematic_lighting_set_ambient_light 0.07 0.05 0.08)
	
	(object_uses_cinematic_lighting dervish_intra1 1)
	(object_uses_cinematic_lighting commander_intra1 1)
	(object_uses_cinematic_lighting elite_01 1)
	(object_uses_cinematic_lighting elite_02 1)
	(object_uses_cinematic_lighting elite_03 1)
	(object_uses_cinematic_lighting elite_04 1)
	(object_uses_cinematic_lighting phantom_intra1 1)
	(object_uses_cinematic_lighting spectre_intra1 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c06_intra1_setup

	(object_create_anew dervish_intra1)
	(object_create_anew commander_intra1)
	(object_create_anew elite_01)
	(object_create_anew elite_02)
	(object_create_anew elite_03)
	(object_create_anew elite_04)
	(object_create_anew phantom_intra1)
	(object_create_anew spectre_intra1)
	
	(cinematic_clone_players_weapon dervish_intra1 "left_hand_elite" "")
	
	(object_cinematic_lod dervish_intra1 true)
	(object_cinematic_lod commander_intra1 true)
	(object_cinematic_lod elite_01 true)
	(object_cinematic_lod elite_02 true)
	(object_cinematic_lod elite_03 true)
	(object_cinematic_lod elite_04 true)
	(object_cinematic_lod phantom_intra1 true)
	(object_cinematic_lod spectre_intra1 true)
	
	(wake c06_intra1_score_01)
	(wake c06_intra1_foley_01)

	(wake c06_2070_der)
	(wake c06_2090_soc)
	(wake c06_2101_elc)
	(wake c06_2110_soc)
	(wake c06_2120_soc)
	
	(wake c06_intra1_dof_01)
	(wake c06_intra1_dof_02)
	(wake c06_intra1_cinematic_light)
	
	)
	
(script static void c06_intra1_cleanup
	
	(object_destroy_containing intra1)
	(cinematic_screen_effect_stop)
	
	)

(script static void c06_intra1

	(texture_cache_flush)
	(geometry_cache_flush)

	(sound_class_set_gain vehicle .25 1)
	(sound_class_set_gain amb .5 1)

	(switch_bsp_by_name sentinelhq_2)
	(sleep 1)

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start_movie "floodzone_intra1")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(06_intra1_01_predict_stub)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\c06_intra1\music\c06_intra1_01_mus)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\c06_intra1\foley\c06_intra1_01_fol)	
	(sleep prediction_offset)
	
	(c06_intra1_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\06_intra1\06_intra1 "06_intra1_01" none "anchor_flag_intra1")	

	(custom_animation_relative dervish_intra1 objects\characters\dervish\06_intra1\06_intra1 "dervish_01" false anchor_intra1)
	(custom_animation_relative commander_intra1 objects\characters\elite\06_intra1\06_intra1 "soc_01" false anchor_intra1)

	(custom_animation_relative elite_01 objects\characters\elite\06_intra1\06_intra1 "elite01_01" false anchor_intra1)
	(custom_animation_relative elite_02 objects\characters\elite\06_intra1\06_intra1 "elite02_01" false anchor_intra1)
	(custom_animation_relative elite_03 objects\characters\elite\06_intra1\06_intra1 "elite03_01" false anchor_intra1)
	(custom_animation_relative elite_04 objects\characters\elite\06_intra1\06_intra1 "elite04_01" false anchor_intra1)

	(custom_animation_relative phantom_intra1 objects\vehicles\phantom\animations\06_intra1\06_intra1 "phantom_01" false anchor_intra1)
	(custom_animation_relative spectre_intra1 objects\vehicles\spectre\06_intra1\06_intra1 "spectre_01" false anchor_intra1)
	
;	safety white
	(sleep 15)
	
	(fade_in 1 1 1 15)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c06_intra1_cleanup)
	
	(sleep 30)
	
	(sound_class_set_gain vehicle 1 1)
	(sound_class_set_gain amb 1 1)
	
	)

; C06_INTRA_2 SCENE 01 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c06_intra2_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\c06_intra2\music\c06_intra_2_01_mus none 1)
	(print "c06_intra2 score 01 start")
	)
	
(script dormant c06_intra2_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\c06_intra2\foley\c06_intra2_01_fol none 1)
	(print "c06_intra2 foley 01 start")
	)

(script dormant c06_3010_soc
	(sleep 550)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_3010_soc none 1)
	(cinematic_subtitle c06_3010_soc 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c06_intra2_cinematic_light
	
	(cinematic_lighting_set_primary_light 40 40 0.24 0.25 0.27)
	(cinematic_lighting_set_secondary_light -72 134 0.23 0.27 0.29)
	(cinematic_lighting_set_ambient_light 0.05 0.05 0.05)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting commander 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c06_intra2_01_setup

	(object_destroy key)

	(object_create_anew dervish)
	(object_create_anew commander)
	(object_create_anew energy_blade)
	(object_create_anew key_intra2_01)
	(object_create_anew key_intra2_02)
	
;	(cinematic_clone_players_weapon dervish "right_hand_elite" "")
	
	(objects_attach commander "left_hand_elite" energy_blade "")
	(object_set_permutation energy_blade "blade" "noblade")
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod index_container true)
	(object_cinematic_lod key_intra2_01 true)
	(object_cinematic_lod key_intra2_02 true)
	
	(wake c06_intra2_score_01)
 	(wake c06_intra2_foley_01)
	
	(wake c06_3010_soc)
	
	(wake c06_intra2_cinematic_light)
	
	)

(script static void c06_intra2_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start_movie "floodzone_intra2")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(06_intra2_01_predict_stub)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\c06_intra2\music\c06_intra_2_01_mus)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\c06_intra2\foley\c06_intra2_01_fol)
	(sleep prediction_offset)
	
	(c06_intra2_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\06_intra2\06_intra2 "06_intra2_01" none "anchor_flag_intra2")
	
	(custom_animation_relative dervish objects\characters\dervish\06_intra2\06_intra2 "dervish_01" false anchor_intra2)
	(custom_animation_relative commander objects\characters\elite\06_intra2\06_intra2 "commander_01" false anchor_intra2)
	
	(scenery_animation_start_relative key_intra2_01 scenarios\objects\solo\sentinelhq\key_cine\06_intra2\06_intra2 "intra2_dervishkey_01" anchor_intra2)
	(scenery_animation_start_relative key_intra2_02 scenarios\objects\solo\sentinelhq\key_cine\06_intra2\06_intra2 "intra2_humankey_01" anchor_intra2)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(06_intra2_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\c06_intra2\foley\c06_intra2_02_fol)	
	
	(sleep (camera_time))
	
	)
	
; C06_INTRA_2 SCENE 02 ------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant c06_intra2_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\c06_intra2\foley\c06_intra2_02_fol none 1)
	(print "c06_intra2 foley 02 start")
	)

(script dormant c06_3030_soc
	(sleep 73)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_3030_soc commander 1)
	(cinematic_subtitle c06_3030_soc 3)
	)

; ---------------------------------------------------------------------

(script dormant blade_activate
	(time_code_reset)
	(sleep 87)
	(object_set_permutation energy_blade "blade" "default")
	(object_set_function_variable energy_blade turned_on 1 0)
	(effect_new_on_object_marker effects\objects\weapons\melee\energy_blade\blade_activate_replace commander "left_hand_elite")
	(print "blade activate")
	)
	
(script dormant kill_switch
	(sleep 307)
	(print "delete switch")
	(object_destroy key_switch)
	)

(script static void c06_intra2_02_setup

	(cinematic_set_far_clip_distance 2048)
	(print "set far clip")

;	(cinematic_clone_players_weapon dervish "left_hand_elite" "")

	(wake c06_intra2_foley_02)
	(wake c06_3030_soc)
	
	(wake blade_activate)
	(wake kill_switch)
	
	)
	
(script static void c06_intra2_02_cleanup
	
	(object_destroy commander)
	(object_destroy_containing key_intra2_02)
	
	)

(script static void c06_intra2_scene_02
	
	(c06_intra2_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\06_intra2\06_intra2 "06_intra2_02" none "anchor_flag_intra2")
	
	(custom_animation_relative dervish objects\characters\dervish\06_intra2\06_intra2 "dervish_02" false anchor_intra2)
	(custom_animation_relative commander objects\characters\elite\06_intra2\06_intra2 "commander_02" false anchor_intra2)
	
	(scenery_animation_start_relative key_intra2_01 scenarios\objects\solo\sentinelhq\key_cine\06_intra2\06_intra2 "intra2_dervishkey_02" anchor_intra2)
	(scenery_animation_start_relative key_intra2_02 scenarios\objects\solo\sentinelhq\key_cine\06_intra2\06_intra2 "intra2_humankey_02" anchor_intra2)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(06_intra2_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\c06_intra2\foley\c06_intra2_03_fol)
	
	(sleep (camera_time))
	
	(c06_intra2_02_cleanup)
	
	)
	
; C06_INTRA_2 SCENE 03 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c06_intra2_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\c06_intra2\foley\c06_intra2_03_fol none 1)
	(print "c06_intra2 foley 03 start")
	)

(script dormant l06_0300_tar
	(sleep 74)
	(sound_impulse_start_effect sound\dialog\levels\06_sentinelwall\mission\l06_0300_tar none 1 radio_covy)
	(cinematic_subtitle l06_0300_tar 2)
	)

(script dormant l06_0310_tar
	(sleep 164)
	(sound_impulse_start_effect sound\dialog\levels\06_sentinelwall\mission\l06_0310_tar none 1 radio_covy)
	(cinematic_subtitle l06_0310_tar 2.5)
	)
	
; ---------------------------------------------------------------------

(script dormant key_door_open
	(sleep 210)
	(print "key door open")
	(device_set_position key_ride_door0 1)
	)

(script static void c06_intra2_03_setup

	(object_create_anew phantom_01)
	(object_cinematic_lod phantom_01 true)
	(object_uses_cinematic_lighting phantom_01 1)
	
	(wake c06_intra2_foley_03)
	(wake l06_0300_tar)
	(wake l06_0310_tar)
	
;	(wake x04_01_dof_1)
	(wake key_door_open)
	
	)
	
(script static void c06_intra2_03_cleanup
	
	(object_destroy dervish)
	(object_destroy phantom_01)
	(object_destroy key_intra2_01)
	
	)

(script static void c06_intra2_scene_03
	
	(c06_intra2_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\06_intra2\06_intra2 "06_intra2_03" none "anchor_flag_intra2")
	
	(custom_animation_relative dervish objects\characters\dervish\06_intra2\06_intra2 "dervish_03" false anchor_intra2)
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\06_intra2\06_intra2 "phantom_03" false anchor_intra2)

	(scenery_animation_start_relative key_intra2_01 scenarios\objects\solo\sentinelhq\key_cine\06_intra2\06_intra2 "intra2_dervishkey_03" anchor_intra2)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c06_intra2_03_cleanup)
	
	(sleep 30)
	
	)

; C06_INTRA_2 MASTER SCRIPT ===========================================
; =====================================================================


(script static void c06_intra2
	
	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name sen_hq_bsp_5)
	(sleep 1)
	
	(c06_intra2_scene_01)
	(c06_intra2_scene_02)
	(c06_intra2_scene_03)
	
	)

; X07 SCENE 01 --------------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant x07_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x07\foley\x07_01_fol none 1)
	(print "x07 foley 01 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x07_cinematic_light_01
	
	(cinematic_lighting_set_primary_light -46 220 0.26 0.23 0.20)
	(cinematic_lighting_set_secondary_light 63 262 0.23 0.27 0.29)
	(cinematic_lighting_set_ambient_light 0.02 0.02 0.02)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
;	(render_lights_enable_cinematic_shadow 1 miranda head .2)
	
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting x07_tentacle 1)
	(print "tentacle cinematic lighting")
	(object_uses_cinematic_lighting index_container 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void x07_01_setup

	(object_create_anew miranda)
	(object_create_anew x07_tentacle)
	(object_create_anew index_container)
	(print "tentacle created")
	
	(object_cinematic_lod miranda true)
;	(object_cinematic_lod x07_tentacle true)
	(object_cinematic_lod index_container true)
;	(print "tentacle cinematic lod")
	
	(unit_set_emotional_state miranda pain .25 0)
	(print "miranda - pain .25 0")
	
	(wake x07_foley_01)
	
	(wake x07_cinematic_light_01)
	
	)
	
(script static void x07_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start_movie "floodzone_1")
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x07_01_predict_stub)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x07\music\x07_02_mus)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x07\foley\x07_01_fol)
	(sleep prediction_offset)
	
	(x07_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_01" none "anchor_flag_x07")
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_01" false anchor_x07)
	(scenery_animation_start_relative x07_tentacle objects\characters\gravemind\tentacle_capture\x07\x07 "tentacle_02" anchor_x07)
	(print "tentacle 02 animation relative started")
	(scenery_animation_start_relative x07_tentacle objects\characters\gravemind\tentacle_capture\x07\x07 "tentacle_01" anchor_x07)
	(print "tentacle 01 animation relative started")
	(scenery_animation_start_relative index_container scenarios\objects\forerunner\industrial\index\index_full\index_full "x07_01" anchor_x07)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x07_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x07\foley\x07_02_fol)
	
	(sleep (camera_time))
	
	)
	
; X07 SCENE 02 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x07_score_02
	(sleep 279)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x07\music\x07_02_mus none 1)
	(print "x07 score 02 start")
	)

(script dormant x07_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x07\foley\x07_02_fol none 1)
	(print "x07 foley 02 start")
	)

(script dormant x07_0010_mir
	(sleep 249)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0010_mir miranda 1)
	(cinematic_subtitle x07_0010_mir 1)
	)
	
(script dormant x07_0020_jon
	(sleep 399)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0020_jon johnson 1)
	(cinematic_subtitle x07_0020_jon 4)
	)
	
(script dormant x07_0030_mir
	(sleep 540)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0030_mir miranda 1)
	(cinematic_subtitle x07_0030_mir 1.5)
	
	(unit_set_emotional_state miranda pain .25 15)
	(print "miranda - pain .25 15")
	
	)

; ---------------------------------------------------------------------

(script dormant x07_emotion_miranda_01
	(sleep 330)
	(unit_set_emotional_state miranda shocked .5 0)
	(print "miranda - shocked .5 0")
	)
	
(script dormant x07_emotion_miranda_02
	(sleep 520)
	(unit_set_emotional_state miranda shocked .25 0)
	(print "miranda - shocked .25 0")
	)

(script static void x07_02_setup

	(object_create_anew johnson)
	(object_cinematic_lod johnson true)
	(object_uses_cinematic_lighting johnson 1)
;	(render_lights_enable_cinematic_shadow 1 johnson head .2)
	
	(wake x07_score_02)
	(wake x07_foley_02)
	
	(wake x07_0010_mir)
	(wake x07_0020_jon)
	(wake x07_0030_mir)
	
	(wake x07_emotion_miranda_01)
	(wake x07_emotion_miranda_02)
	
	)

(script static void x07_scene_02
	
	(x07_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_02" none "anchor_flag_x07")
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_02" false anchor_x07)
	(custom_animation_relative johnson objects\characters\marine\x07\x07 "johnson_02" false anchor_x07)
	(scenery_animation_start_relative x07_tentacle objects\characters\gravemind\tentacle_capture\x07\x07 "tentacle_02" anchor_x07)
	(print "tentacle 02 animation started")
	(scenery_animation_start_relative index_container scenarios\objects\forerunner\industrial\index\index_full\index_full "x07_02" anchor_x07)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x07_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x07\music\x07_03_mus)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x07\foley\x07_03_fol)
	
	(sleep (camera_time))
	(object_destroy x07_tentacle)
	(print "tentacle destroyed")
	)

; X07 SCENE 03 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x07_score_03
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x07\music\x07_03_mus none 1)
	(print "x07 score 03 start")
	)

(script dormant x07_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x07\foley\x07_03_fol none 1)
	(print "x07 foley 03 start")
	)

(script dormant x07_0040_jon
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0040_jon johnson 1)
	(cinematic_subtitle x07_0040_jon 2)
	)
	
(script dormant x07_0050_jon

	(sleep 77)
	(unit_set_emotional_state johnson pain .25 0)
	(print "johnson - pain .25 0")

	(sleep 10)
;	(sleep 87)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0050_jon johnson 1)
	(cinematic_subtitle x07_0050_jon 1.5)
	)
	
(script dormant x07_0060_jon
	(sleep 150)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0060_jon johnson 1)
	(cinematic_subtitle x07_0060_jon 1)
	
	(sleep 25)
	(unit_set_emotional_state miranda shocked .25 15)
	(print "miranda - shocked .25 15")
	
	)
	
(script dormant x07_0070_jon

	(sleep 540)
	(unit_set_emotional_state johnson shocked .25 10)
	(print "johnson - shocked .25 10")

	(sleep 10)
;	(sleep 550)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0070_jon johnson 1)
	(cinematic_subtitle x07_0070_jon 1)
	)
	
(script dormant x07_0080_jon

	(sleep 678)
	(unit_set_emotional_state johnson annoyed .75 60)
	(print "johnson - annoyed .75 60")

	(sleep 10)
;	(sleep 688)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0080_jon johnson 1)
	(cinematic_subtitle x07_0080_jon 1)
	
	(sleep 45)
	(unit_set_emotional_state johnson shocked .5 30)
	(print "johnson - shocked .5 30")
	
	)
	
(script dormant x07_0090_mir
	(sleep 776)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0090_mir none 1)
	(cinematic_subtitle x07_0090_mir 1)
	)
	
(script dormant x07_0100_mir
	(sleep 800)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0100_mir miranda 1)
	(cinematic_subtitle x07_0100_mir 1)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant miranda_smgs_fire_1
	(sleep 834)

	(object_create_anew smg_real_01)
	(object_create_anew smg_real_02)
	
	(object_set_scale smg_real_01 1 0)
	(object_set_scale smg_real_02 1 0)
	
	(objects_attach miranda "right_hand" smg_real_01 "")
	(objects_attach miranda "left_hand" smg_real_02 "")
	
	(sleep 5)
	
	(weapon_hold_trigger smg_real_01 0 true)
	(weapon_hold_trigger smg_real_02 0 true)
	
	)

(script dormant johnson_rifle_fire
	(sleep 563)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 2)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 2)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	
	(sleep 10)
	
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 2)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 2)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	
	(sleep 21)
	
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 2)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 2)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	
	)
	
(script dormant dervish_cammo
	(sleep 627)
	(print "effect - cammo off")
	(unit_set_active_camo dervish false 1)
	)

(script dormant x07_cinematic_light_03

	(cinematic_lighting_set_primary_light 16 82 0.25 0.32 0.32)
	(cinematic_lighting_set_secondary_light 24 272 0.22 0.26 0.28)
	(cinematic_lighting_set_ambient_light 0.02 0.02 0.02)	
	
;	(render_lights_enable_cinematic_shadow 1 dervish head .2)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting miranda_smg_01 1)
	(object_uses_cinematic_lighting miranda_smg_02 1)
	(object_uses_cinematic_lighting johnson_rifle 1)
	
	)

; ---------------------------------------------------------------------

(script dormant johnson_rifle_arm
	(sleep 105)
	(objects_attach johnson "right_hand" johnson_rifle "")
	)

(script static void x07_03_setup

	(sound_looping_stop scenarios\solo\06b_floodzone\06b_music\06b_07)
	
	(object_create_anew dervish)
	(object_cannot_die dervish true)
	(unit_set_active_camo dervish true 0)
	
	(object_create_anew miranda_smg_01)
	(object_create_anew miranda_smg_02)
	(object_create_anew johnson_rifle)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod miranda_smg_01 true)
	(object_cinematic_lod miranda_smg_02 true)
	(object_cinematic_lod johnson_rifle true)
	
	(unit_set_emotional_state miranda pain .25 0)
	(print "miranda - pain .25 0")
	
	(unit_set_emotional_state johnson pensive .25 0)
	(print "johnson - pensive .25 0")
	
	(wake x07_score_03)
	(wake x07_foley_03)

	(wake x07_0040_jon)
	(wake x07_0050_jon)
	(wake x07_0060_jon)
	(wake x07_0070_jon)
	(wake x07_0080_jon)
	(wake x07_0090_mir)
	(wake x07_0100_mir)
	
	(wake miranda_smgs_fire_1)
	(wake johnson_rifle_arm)
	(wake johnson_rifle_fire)
	
	(wake dervish_cammo)
	(wake x07_cinematic_light_03)
	
;	(wake x04_01_dof_1)
	
	)

(script static void x07_scene_03
	
	(x07_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_03" none "anchor_flag_x07")
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_03" false anchor_x07)
	(custom_animation_relative johnson objects\characters\marine\x07\x07 "johnson_03" false anchor_x07)
	(custom_animation_relative dervish objects\characters\dervish\x07\x07 "dervish_03" false anchor_x07)
	
	(scenery_animation_start_relative index_container scenarios\objects\forerunner\industrial\index\index_full\index_full "x07_03" anchor_x07)
	(scenery_animation_start_relative miranda_smg_01 objects\weapons\rifle\smg\x07\x07 "smg01_03" anchor_x07)
	(scenery_animation_start_relative miranda_smg_02 objects\weapons\rifle\smg\x07\x07 "smg02_03" anchor_x07)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x07_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x07\foley\x07_04_fol)
	
	(sleep (camera_time))
	
	)
	
; X07 SCENE 04 --------------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant x07_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x07\foley\x07_04_fol none 1)
	(print "x07 foley 04 start")
	)

(script dormant x07_0110_mir
	(sleep 117)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0110_mir miranda 1)
	(cinematic_subtitle x07_0110_mir 1.5)
	)
	
(script dormant x07_0120_mir
	(sleep 169)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0120_mir miranda 1)
	(cinematic_subtitle x07_0120_mir 1)
	)
	
(script dormant x07_0130_tar
	(sleep 483)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0130_tar tartarus 1)
	(cinematic_subtitle x07_0130_tar 4)
	)
	
(script dormant x07_0140_der
	(sleep 614)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0140_der dervish 1)
	(cinematic_subtitle x07_0140_der 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_miranda_hit
	(time_code_reset)
	(sleep 338)
	(print "effect - miranda hit")
	(effect_new_on_object_marker effects\objects\characters\brute\hammer_grappling miranda "body")
	)

(script dormant x07_cinematic_light_04

	(cinematic_lighting_set_primary_light 33 42 0.20 0.25 0.25)
	(cinematic_lighting_set_secondary_light -54 0 0.23 0.27 0.29)
	(cinematic_lighting_set_ambient_light 0.02 0.02 0.02)
	
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting hammer 1)
	
	)
	
; PREDICTION ----------------------------------------------------------

(script static void x07_scene_05_problem_actors

	(print "create problem actors")
	
	(object_create_anew_containing brute)
	
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod brute_03 true)
	(object_cinematic_lod brute_04 true)
	(object_cinematic_lod brute_shot_01 true)
	(object_cinematic_lod brute_shot_02 true)
	(object_cinematic_lod brute_rifle_01 true)
	(object_cinematic_lod brute_rifle_02 true)
	
	(objects_attach brute_03 "right_hand" brute_shot_01 "right_hand_brute")
	(objects_attach brute_04 "right_hand" brute_shot_02 "right_hand_brute")
	
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting brute_03 1)
	(object_uses_cinematic_lighting brute_04 1)
	(object_uses_cinematic_lighting brute_shot_01 1)
	(object_uses_cinematic_lighting brute_shot_02 1)
	(object_uses_cinematic_lighting brute_rifle_01 1)
	(object_uses_cinematic_lighting brute_rifle_02 1)
	
	)

; ---------------------------------------------------------------------

(script dormant x07_emotion_miranda_03
	
	(sleep 300)
	(unit_set_emotional_state miranda shocked .5 0)
	(print "miranda - shocked .5 0")
	
	(sleep 38)
	(unit_set_emotional_state miranda pain .8 10)
	(print "miranda - shocked 1 10")
	
	)

(script dormant tartarus_hide_seek
	(sleep 5)
	(object_hide tartarus true)
	(object_hide hammer true)
	(sleep 400)
	(object_hide tartarus false)
	(object_hide hammer false)
	)
	
(script dormant miranda_smgs_destroy

	(time_code_reset)
	
	(sleep 98)
	(print "stop firing")

	(weapon_hold_trigger smg_real_01 0 false)
	(weapon_hold_trigger smg_real_02 0 false)

	(sleep 131)
	(print "destroy smgs")
	(objects_detach miranda smg_real_01)
	(objects_detach miranda smg_real_02)
	(object_destroy_containing smg_real)
	
	)

(script static void x07_04_setup

	(object_create_anew tartarus)
	(object_create hammer)

	(object_cinematic_lod tartarus true)
	(object_cinematic_lod hammer true)
	
 	(wake x07_foley_04)
	
	(wake x07_0110_mir)
	(wake x07_0120_mir)
	(wake x07_0130_tar)
	(wake x07_0140_der)
	
	(unit_set_emotional_state miranda shocked .25 0)
	(print "miranda - shocked .25 0")
	
	(wake x07_emotion_miranda_03)

	(wake miranda_smgs_destroy)
	(wake tartarus_hide_seek)
	
	(wake x07_cinematic_light_04)
	
	(wake effect_miranda_hit)
	
	)
	
(script static void x07_scene_04
	
	(x07_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_04" none "anchor_flag_x07")
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_04" false anchor_x07)
	(custom_animation_relative johnson objects\characters\marine\x07\x07 "johnson_04" false anchor_x07)
	(custom_animation_relative dervish objects\characters\dervish\x07\x07 "dervish_04" false anchor_x07)
	(custom_animation_relative tartarus objects\characters\brute\x07\x07 "tartarus_04" false anchor_x07)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x07\x07 "hammer_04" anchor_x07)
	(scenery_animation_start_relative miranda_smg_01 objects\weapons\rifle\smg\x07\x07 "smg01_04" anchor_x07)
	(scenery_animation_start_relative miranda_smg_02 objects\weapons\rifle\smg\x07\x07 "smg02_04" anchor_x07)
	(scenery_animation_start_relative index_container scenarios\objects\forerunner\industrial\index\index_full\index_full "x07_04" anchor_x07)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x07_05_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x07\foley\x07_05_fol)
	(x07_scene_05_problem_actors)
	
	(sleep (camera_time))
	
	(objects_detach johnson johnson_rifle)
	(object_destroy johnson_rifle)
	
	)
	
; X07 SCENE 05 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x07_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x07\foley\x07_05_fol none 1)
	(print "x07 foley 05 start")
	)

(script dormant x07_0150_tar
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0150_tar tartarus 1)
	(cinematic_subtitle x07_0150_tar 1.5)
	)
	
(script dormant x07_0160_tar
	(sleep 48)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0160_tar tartarus 1)
	(cinematic_subtitle x07_0160_tar 2)
	)	

(script dormant x07_0170_tar
	(sleep 302)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0170_tar tartarus 1)
	(cinematic_subtitle x07_0170_tar 4)
	)
	
(script dormant x07_0180_tar
	(sleep 428)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0180_tar tartarus 1)
	(cinematic_subtitle x07_0180_tar 5.5)
	)

(script dormant x07_0190_der
	(sleep 591)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0190_der dervish 1)
	(cinematic_subtitle x07_0190_der 2.5)
	)
	
; ---------------------------------------------------------------------

(script dormant destroy_miranda
	(sleep 428)
	(object_destroy miranda)
	(print "destroy miranda")
	)

(script static void x07_05_setup

	(wake x07_foley_05)
	
	(wake x07_0150_tar)
	(wake x07_0160_tar)
	(wake x07_0170_tar)
	(wake x07_0180_tar)
	(wake x07_0190_der)
	
;	(wake x04_01_dof_1)

	(unit_set_emotional_state miranda asleep 1 0)
	(print "miranda - asleep 1 0")
	
	(unit_set_emotional_state johnson asleep 1 0)
	(print "johnson - asleep 1 0")
	
	(wake destroy_miranda)
	
	)
	
(script static void x07_05_cleanup
	
	(object_destroy johnson)
	(object_destroy_containing brute)
	
	)

(script static void x07_scene_05
	
	(x07_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_05" none "anchor_flag_x07")
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_05" false anchor_x07)
	(custom_animation_relative johnson objects\characters\marine\x07\x07 "johnson_05" false anchor_x07)
	(custom_animation_relative dervish objects\characters\dervish\x07\x07 "dervish_05" false anchor_x07)
	(custom_animation_relative tartarus objects\characters\brute\x07\x07 "tartarus_05" false anchor_x07)
	
	(custom_animation_relative brute_01 objects\characters\brute\x07\x07 "brute01_05" false anchor_x07)
	(custom_animation_relative brute_02 objects\characters\brute\x07\x07 "brute02_05" false anchor_x07)
	(custom_animation_relative brute_03 objects\characters\brute\x07\x07 "brute03_05" false anchor_x07)
	(custom_animation_relative brute_04 objects\characters\brute\x07\x07 "brute04_05" false anchor_x07)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x07\x07 "hammer_05" anchor_x07)
	(scenery_animation_start_relative index_container scenarios\objects\forerunner\industrial\index\index_full\index_full "x07_05" anchor_x07)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x07_06_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x07\foley\x07_06_fol)
	
	(sleep (camera_time))
	
	(x07_05_cleanup)
	
	)
	
; X07 SCENE 06 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x07_foley_06
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x07\foley\x07_06_fol none 1)
	(print "x07 foley 06 start")
	)	

(script dormant x07_0200_tar
	(sleep 86)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0200_tar tartarus 1)
	(cinematic_subtitle x07_0200_tar 6.5)
	
	(sleep 128)
	(unit_set_emotional_state tartarus inquisitive 1 60)
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant tartarus_bruteshot_fire
	(sleep 373)
	(print "effect - tartarus' hammer")
;	(effect_new_on_object_marker effects\objects\characters\brute\hammer_grappling tartarus "melee")
	(effect_new_on_object_marker effects\objects\characters\brute\tartarus_hammer_impact_cinematic tartarus "body")
	)
	
(script dormant tartarus_bruteshot_hit
	(sleep 380)
	(print "effect - hammer hit")
	(effect_new_on_object_marker effects\objects\characters\brute\hammer_grappling dervish "body")
	)

; PREDICTION ----------------------------------------------------------

(script dormant x07_predict_shaft_01
	(sleep 385)
	(print "predict: camera")
	(camera_predict_resources_at_frame objects\characters\cinematic_camera\x07\x07 "x07_06" none "anchor_flag_x07" 405)
	)
	
(script dormant x07_predict_shaft_02
	(sleep 532)
	(print "predict: camera")
	(camera_predict_resources_at_frame objects\characters\cinematic_camera\x07\x07 "x07_06" none "anchor_flag_x07" 552)
	)

; ---------------------------------------------------------------------

(script static void x07_06_setup
	
	(wake x07_foley_06)
	(wake x07_0200_tar)
	
	(wake tartarus_bruteshot_fire)
	(wake tartarus_bruteshot_hit)
	
	(wake x07_predict_shaft_01)
	(wake x07_predict_shaft_02)
	
	)
	
(script static void x07_06_cleanup

	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy hammer)
	(object_destroy index_container)
	
	)

(script static void x07_scene_06
	
	(x07_06_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_06" none "anchor_flag_x07")
	
	(custom_animation_relative dervish objects\characters\dervish\x07\x07 "dervish_06" false anchor_x07)
	(custom_animation_relative tartarus objects\characters\brute\x07\x07 "tartarus_06" false anchor_x07)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x07\x07 "hammer_06" anchor_x07)
	(scenery_animation_start_relative index_container scenarios\objects\forerunner\industrial\index\index_full\index_full "x07_06" anchor_x07)
	
	(sleep (- (camera_time) 1))
	
	(fade_out 0 0 0 0)
	(sleep 1)
	
	(x07_06_cleanup)
	
	(sound_class_set_gain amb 0 60)
	
	(sleep 90)
	
	)

; X07_INTRO MASTER SCRIPT =============================================
; =====================================================================

(script static void x07
	
	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name sen_hq_bsp_6)
	(sleep 1)
	
	(x07_scene_01)
	(x07_scene_02)
	(x07_scene_03)
	(x07_scene_04)
	(x07_scene_05)
	(x07_scene_06)
	
	(rasterizer_bloom_override 0)
	
	)
	