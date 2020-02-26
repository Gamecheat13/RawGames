; CINEMATICS FOR LEVEL 07B, FORERUNNER SHIP ===========================
; =====================================================================

;*
	O, Damage
	
	Pointy and acrid
	yet so shiny and beckoning in the dark
	Should I touch thee
	and live a lifetime in that instant of doom?
	Or pass you by diminished
	ignoring the grinding of your jilted teeth?
	
	- Jones on the cutting of "Earth Ark"
*;

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)
	
	(script stub void 07_intra1_05_predict_stub (print "predict 05"))
	(script stub void 07_intra1_06_predict_stub (print "predict 06"))
	(script stub void 07_intra1_07_predict_stub (print "predict 07"))
	(script stub void 07_intra1_08_predict_stub (print "predict 08"))

	(script stub void 07_outro_01_predict_stub (print "predict 01"))
	(script stub void 07_outro_02_predict_stub (print "predict 02"))
	(script stub void 07_outro_03_predict_stub (print "predict 03"))
	
	(script stub void cinematic_pelican_unload (print "flood unload"))
	(script stub void cinematic_pelican_runby (print "flood runby"))

; C07_INTRA_1 SCENE 05 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_intra1_score_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\music\c07_intra1_05_mus none 1)
	(print "c07_intra1 score 05")
	)
	
(script dormant c07_intra1_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_05_fol none 1)
	(print "c07_intra1 foley 05 start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c07_intra1_05_dof_01
	(time_code_reset)
	
	(sleep 127)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 1 0 0 0 .75 .75 0)
	(print "rack focus")
	
	(time_code_reset)
	
	(sleep 60)
	(cinematic_screen_effect_set_depth_of_field 1 0 .75 .5 .75 0 .5)
	(print "rack focus")

	(time_code_reset)

	(sleep 68)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)

(script dormant c07_intra1_cinematic_light_01
	
     (cinematic_lighting_set_primary_light 23 74 0.258824 0.270588 0.368627)
     (cinematic_lighting_set_secondary_light -40 276 0.407843 0.345098 0.317647)
     (cinematic_lighting_set_ambient_light 0.0431373 0.0470588 0.0666667)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting mercy 1)
	(object_uses_cinematic_lighting infection_01 1)
	(object_uses_cinematic_lighting throne_mercy 1)
	(object_uses_cinematic_lighting phantom_01 1)
	(object_uses_cinematic_lighting phantom_02 1)
	(object_uses_cinematic_lighting phantom_03 1)
	
	)

; ---------------------------------------------------------------------

(script static void c07_intra1_05_setup

	(wake c07_intra1_score_05)
	(wake c07_intra1_foley_05)

	(object_create_anew chief)
	(object_create_anew mercy)
	(object_create_anew infection_01)
	(object_create_anew throne_mercy)
	(object_create_anew phantom_01)
	(object_create_anew phantom_02)
	(object_create_anew phantom_03)

	(cinematic_clone_players_weapon chief "right_hand" "")
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod infection_01 true)
	(object_cinematic_lod throne_mercy true)
	(object_cinematic_lod phantom_01 true)
	(object_cinematic_lod phantom_02 true)
	(object_cinematic_lod phantom_03 true)
	
	(wake c07_intra1_05_dof_01)
	(wake c07_intra1_cinematic_light_01)
	
	(object_destroy ledge_1)
	
	)

(script static void c07_intra1_05_cleanup

	(object_destroy_containing phantom)
	
	)

(script static void c07_intra1_scene_05

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(07_intra1_05_predict_stub)
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\music\c07_intra1_05_mus)
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_05_fol)
	(sleep prediction_offset)
	
	(c07_intra1_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intra1\07_intra1 "07_intra1_05" none "anchor_flag_intra1")

	(custom_animation_relative chief objects\characters\masterchief\07_intra1\07_intra1 "chief_05" false anchor_intra1)
	(custom_animation_relative mercy objects\characters\prophet\07_intra1\07_intra1 "mercy_05" false anchor_intra1)
	(custom_animation_relative infection_01 objects\characters\flood_infection\07_intra1\07_intra1 "infection01_05" false anchor_intra1)
	
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\07_intra1\07_intra1 "throne_mercy_05" false anchor_intra1)
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom1_05" false anchor_intra1)
	(custom_animation_relative phantom_02 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom2_05" false anchor_intra1)
	(custom_animation_relative phantom_03 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom3_05" false anchor_intra1)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intra1_06_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_06_fol)
	
	(sleep (camera_time))
	
	(c07_intra1_05_cleanup)

	)
	
; C07_INTRA_1 SCENE 06 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_intra1_foley_06
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_06_fol none 1)
	(print "c07_intra1 foley 06 start")
	)

(script dormant c07_2080_mas
	(sleep 45)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2080_mas chief 1)
	(cinematic_subtitle c07_2080_mas 2.5)
	)
	
(script dormant c07_2090_pom
	(sleep 180)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2090_pom mercy 1)
	(cinematic_subtitle c07_2090_pom 3)
	)
	
(script dormant c07_2100_pom
	(sleep 283)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2100_pom mercy 1)
	(cinematic_subtitle c07_2100_pom 4)
	)

(script dormant c07_2101_pom
	(sleep 451)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2101_pom mercy 1)
	)

(script dormant c07_2110_cor
	(sleep 566)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2110_cor cortana 1)
	(cinematic_subtitle c07_2110_cor 2)	
	
	(unit_set_emotional_state cortana shocked .25 0)
	(print "cortana - shocked .25 0")
	
	)

(script dormant c07_2120_cor
	(sleep 621)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2120_cor cortana 1)
	(cinematic_subtitle c07_2120_cor 4)	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c07_intra1_06_dof_01
	(time_code_reset)
	
	(sleep 121)
	(print "rack focus")
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field .4 .5 .5 0 0 0 0)
	
	(time_code_reset)
	
	(sleep 153)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	)
	
(script dormant c07_intra1_06_fov_01
	(sleep 396)
	(print "fov change: 60 -> 70 over 0 ticks")
	(camera_set_field_of_view 70 0)
	(sleep 53)
	(print "fov change: 70 -> 60 over 0 ticks")
	(camera_set_field_of_view 60 0)
	)
	
; ---------------------------------------------------------------------

(script dormant infection_pop
	(sleep 510)
	(print "infection pop")
	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_02 "")
	(sleep 1)
	(object_destroy infection_02)
	)

(script static void c07_intra1_06_setup

	(object_create_anew cortana)
	(object_cinematic_lod cortana true)

	(object_create_anew infection_02)
	(object_cinematic_lod infection_02 true)
	(object_uses_cinematic_lighting infection_02 1)
	
	(object_create_anew cortana_base)
	
	(wake c07_intra1_foley_06)
	
	(wake c07_2080_mas)
	(wake c07_2090_pom)
	(wake c07_2100_pom)
	(wake c07_2101_pom)
	(wake c07_2110_cor)
	(wake c07_2120_cor)
	
	(wake infection_pop)
	
	(wake c07_intra1_06_dof_01)
	(wake c07_intra1_06_fov_01)
	
	)
	
(script static void c07_intra1_06_cleanup

	(object_destroy_containing infection)
	(object_destroy cortana_base)
	
	)

(script static void c07_intra1_scene_06
	
	(c07_intra1_06_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intra1\07_intra1 "07_intra1_06" none "anchor_flag_intra1")

	(custom_animation_relative chief objects\characters\masterchief\07_intra1\07_intra1 "chief_06" false anchor_intra1)
	(custom_animation_relative mercy objects\characters\prophet\07_intra1\07_intra1 "mercy_06" false anchor_intra1)
	(custom_animation_relative infection_01 objects\characters\flood_infection\07_intra1\07_intra1 "infection01_06" false anchor_intra1)
	(custom_animation_relative infection_02 objects\characters\flood_infection\07_intra1\07_intra1 "infection02_06" false anchor_intra1)
	
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\07_intra1\07_intra1 "throne_mercy_06" false anchor_intra1)
	
	(sleep 556)

	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off_25 cortana_base "marker")
	(custom_animation_relative cortana objects\characters\cortana\07_intra1\07_intra1 "cortana_06" false anchor_intra1)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intra1_07_predict_stub)
	
	(sleep (camera_time))
	
	(c07_intra1_06_cleanup)

	)
	
; C07_INTRA_1 SCENE 07 ------------------------------------------------

(script dormant c07_2130_cor
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2130_cor cortana 1)
	(cinematic_subtitle c07_2130_cor 3)
	)

(script dormant c07_2140_cor
	(sleep 110)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2140_cor cortana 1)
	(cinematic_subtitle c07_2140_cor 1)
	)
	
(script dormant c07_2150_mas
	(sleep 150)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2150_mas chief 1)
	(cinematic_subtitle c07_2150_mas 5)	
	)

(script dormant c07_2160_cor
	(sleep 297)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2160_cor cortana 1)
	(cinematic_subtitle c07_2160_cor 6)
	
	(unit_set_emotional_state cortana annoyed .5 0)
	(print "cortana - annoyed .5 0")
	
	)
	
(script dormant c07_2170_cor
	(sleep 490)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2170_cor cortana 1)
	(cinematic_subtitle c07_2170_cor 3)	
	)
	
(script dormant c07_2180_cor
	(sleep 622)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2180_cor cortana 1)
	(cinematic_subtitle c07_2180_cor 3)
	)
	
(script dormant c07_2190_cor
	(sleep 710)
	
	(unit_set_emotional_state cortana disappointed .5 60)
	(print "cortana - disappointed .5 60")
	
	(sleep 13)
	
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2190_cor cortana 1)
	(cinematic_subtitle c07_2190_cor 1)	
	)
	
(script dormant c07_intra1_07_fov_01
	(sleep 414)
	(print "fov change: 60 -> 26 over 0 ticks")
	(camera_set_field_of_view 26 0)
	(sleep 70)
	(print "fov change: 26 -> 60 over 0 ticks")
	(camera_set_field_of_view 60 0)
	)

(script static void c07_intra1_07_setup

;	(object_create_anew cortana)
;	(object_cinematic_lod cortana true)
	
	(wake c07_2130_cor)
	(wake c07_2140_cor)
	(wake c07_2150_mas)
	(wake c07_2160_cor)
	(wake c07_2170_cor)
	(wake c07_2180_cor)
	(wake c07_2190_cor)
	
	(wake c07_intra1_07_fov_01)
	
	)
	
(script static void c07_intra1_07_cleanup

	(object_destroy_containing mercy)
	
	)

(script static void c07_intra1_scene_07
	
	(c07_intra1_07_setup)
	
	(cinematic_set_near_clip_distance .05)
	(print "setting near clip distance to .05")
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intra1\07_intra1 "07_intra1_07" none "anchor_flag_intra1")

	(custom_animation_relative chief objects\characters\masterchief\07_intra1\07_intra1 "chief_07" false anchor_intra1)
	(custom_animation_relative cortana objects\characters\cortana\07_intra1\07_intra1 "cortana_07" false anchor_intra1)
	(custom_animation_relative mercy objects\characters\prophet\07_intra1\07_intra1 "mercy_07" false anchor_intra1)
	
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\07_intra1\07_intra1 "throne_mercy_07" false anchor_intra1)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intra1_08_predict_stub)	
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_08_fol)

	(sleep (camera_time))
	
	(c07_intra1_07_cleanup)

	)
	
; C07_INTRA_1 SCENE 08 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_intra1_foley_08
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_08_fol none 1)
	(print "c07_intra1 foley 08 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant pelican_crash_01
	(sleep 38)
	(print "crash 1")
	(effect_new_on_object_marker effects\generic\explosions_air\human_vehicle_air_hit_small pelican_01 "hardpoint_right")
	)
	
(script dormant pelican_crash_02
	(sleep 49)
	(print "crash 2")
	(effect_new_on_object_marker effects\generic\explosions_air\human_vehicle_air_hit pelican_01 "johnson")
	)
	
(script dormant pelican_crash_03
	(sleep 101)
	(print "crash 3")
	(effect_new_on_object_marker effects\generic\explosions_air\human_vehicle_air_hit pelican_01 "pelican_p_l05")
	)
	
(script dormant c07_intra1_08_fov_01
	(sleep 99)
	(print "fov change: 36 -> 60 over 0 ticks")
	(camera_set_field_of_view 60 0)
	)
	
; ---------------------------------------------------------------------

(script dormant flood_pelican_unload
	(sleep 145)
	(print "ai flood unload")
	(cinematic_pelican_unload)
	(cinematic_pelican_runby)
	)
	
(script static void c07_intra1_08_setup

	(wake c07_intra1_foley_08)

	(object_destroy_containing offending_crate)

	(object_create_anew pelican_01)
	(object_cinematic_lod pelican_01 true)
	(object_uses_cinematic_lighting pelican_01 true)
	
	(wake c07_intra1_08_fov_01)
	
	(wake pelican_crash_01)
	(wake pelican_crash_02)
	(wake pelican_crash_03)
	
	(wake flood_pelican_unload)
	
	)
	
(script static void c07_intra1_08_cleanup

	(object_destroy chief)
	(object_destroy cortana)
	(object_destroy pelican_01)
	
	)

(script static void c07_intra1_scene_08
	
	(c07_intra1_08_setup)
	
	(cinematic_set_near_clip_distance .06)
	(print "resetting near clip distance to .06")
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intra1\07_intra1 "07_intra1_08" none "anchor_flag_intra1")

	(camera_set_field_of_view 26 0)

	(custom_animation_relative chief objects\characters\masterchief\07_intra1\07_intra1 "chief_08" false anchor_intra1)
	(custom_animation_relative cortana objects\characters\cortana\07_intra1\07_intra1 "cortana_08" false anchor_intra1)
	
	(custom_animation_relative pelican_01 objects\vehicles\pelican\07_intra1\07_intra1 "pelican_08" false anchor_intra1)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(sound_class_set_gain amb 0 15)
	(sleep 15)
	
	(c07_intra1_08_cleanup)

	)

; C07_INTRA1 MASTER SCRIPT ============================================
;* ====================================================================
*;

(script static void c07_intra1

	(texture_cache_flush)
	(geometry_cache_flush)

	(sound_class_set_gain vehicle 0 0)
	(sound_class_set_gain amb 0 0)

	(switch_bsp_by_name high_5)
	(sleep 1)
	
	(c07_intra1_scene_05)
	(c07_intra1_scene_06)
	(c07_intra1_scene_07)
	(c07_intra1_scene_08)

	(sound_class_set_gain vehicle 1 15)
	(sound_class_set_gain amb 1 15)
	(sleep 15)
	
	)
	
; C07_OUTRO SCENE 01 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_outro_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_outro\music\c07_outro_01_mus none 1)
	(print "c07_outro score 01 start")
	)

(script dormant c07_outro_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_outro\foley\c07_outro_01_fol none 1)
	(print "c07_outro foley 01 start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c07_outro_shake
	(sleep 89)
	(print "shake start")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	(sleep 70)
	(player_effect_stop 0)
	(print "shake stop")
	
	)
	
(script dormant c07_outro_shake2
	
	(time_code_reset)
	
	(sleep 290)
	(print "shake start")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	(sleep 60)
	(player_effect_stop 1)
	(print "shake stop")
	
	)

(script dormant c07_outro_dof_01

	(time_code_reset)

	(print "rack focus")
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 20 0 0 0 1 1 0)
	
	(sleep 89)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)

(script dormant c07_outro_dof_02

	(time_code_reset)

	(sleep 289)
	(print "rack focus")
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 20 2 2 0 0 0 0)
	
	(sleep 106)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)

(script dormant c07_outro_fov_01

	(sleep 357)
	(print "fov change: 60 -> 12 over 15 ticks")
	(camera_set_field_of_view 12 15)
	
	(sleep 46)
	(print "fov change: 12 -> 60 over 0 ticks")
	(camera_set_field_of_view 60 0)
	
	)

(script dormant c07_outro_cinematic_lighting_01
	
	(cinematic_lighting_set_primary_light -41 270 0.25 0.32 0.52)
	(cinematic_lighting_set_secondary_light 58 78 0.21 0.11 0.22)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting chief_outro 1)
	(object_uses_cinematic_lighting alcove 1)
	(object_uses_cinematic_lighting cap 1)
	(object_uses_cinematic_lighting ring_01 1)
	(object_uses_cinematic_lighting ring_02 1)
	(object_uses_cinematic_lighting ring_03 1)
	(object_uses_cinematic_lighting ring_04 1)
	(object_uses_cinematic_lighting ring_05 1)
	(object_uses_cinematic_lighting ring_06 1)
	(object_uses_cinematic_lighting ring_06 1)
	(object_uses_cinematic_lighting ring_08 1)
	
	)
	
(script dormant ship_initial_blast
	(sleep 188)
	(print "effect - initial blast")
	(effect_new_on_object_marker effects\objects\cinematics\forerunner_ship\initial_take_off_scale5 forerunner_ship "thruster")
	)
	
; PREDICTION ----------------------------------------------------------

(script static void c07_outro_problem_actors

	(print "problem actors")
	
	(object_create_anew chief_outro)
	(object_cinematic_lod chief_outro true)

	(object_create_anew conduit)	
	(object_create_anew ring_01)
	(object_create_anew ring_02)
	(object_create_anew ring_03)
	(object_create_anew ring_04)
	(object_create_anew ring_05)
	(object_create_anew ring_06)
	(object_create_anew ring_07)
	(object_create_anew ring_08)

	(object_cinematic_lod conduit true)
	(object_cinematic_lod ring_01 true)
	(object_cinematic_lod ring_02 true)
	(object_cinematic_lod ring_03 true)
	(object_cinematic_lod ring_04 true)
	(object_cinematic_lod ring_05 true)
	(object_cinematic_lod ring_06 true)
	(object_cinematic_lod ring_07 true)
	(object_cinematic_lod ring_08 true)
	
	(object_cinematic_visibility conduit true)

	)

; ---------------------------------------------------------------------

(script static void c07_outro_01_setup

	(object_create_anew forerunner_ship)
	(object_create_anew cap)
	(object_create_anew alcove)
	
	(object_cinematic_visibility cap true)
	
	(object_cinematic_lod forerunner_ship true)
	(object_cinematic_lod alcove true)
	
	(wake c07_outro_score_01)
	(wake c07_outro_foley_01)
	
	(wake ship_initial_blast)
	
	(wake c07_outro_dof_01)
	(wake c07_outro_dof_02)
	(wake c07_outro_shake)
	(wake c07_outro_shake2)
	(wake c07_outro_fov_01)
	
	(wake c07_outro_cinematic_lighting_01)
	
	)
	
(script static void c07_outro_01_cleanup
	
	(object_destroy conduit)
	(object_destroy cap)
	(object_destroy ring_05)
	(object_destroy ring_06)
	(object_destroy ring_07)
	(object_destroy ring_08)
	
	)

(script static void c07_outro_scene_01

	(sound_class_set_gain amb 0 30)

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(c07_outro_problem_actors)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(07_outro_01_predict_stub)
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_outro\music\c07_outro_01_mus)
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_outro\foley\c07_outro_01_fol)
	(sleep prediction_offset)
	
	(c07_outro_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_outro\07_outro "07_outro_01" none "anchor_flag_outro1")

	(custom_animation_relative chief_outro objects\characters\masterchief\07_outro\07_outro "chief_01" false anchor_outro1)
	
	(scenery_animation_start_relative forerunner_ship objects\cinematics\forerunner\forerunner_ship\07_outro\07_outro "forerunner_ship_01" anchor_outro1)
	(scenery_animation_start_relative alcove objects\cinematics\forerunner\forerunner_ship_alcove\07_outro\07_outro "alcove_01" anchor_outro1)
	(scenery_animation_start_relative cap objects\cinematics\covenant\conduit_cap\07_outro\07_outro "conduit_cap_01" anchor_outro1)
	
	(scenery_animation_start_relative conduit objects\cinematics\covenant\conduit\07_outro\07_outro "conduit_01" anchor_outro1)
	(scenery_animation_start_relative ring_01 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring01_01" anchor_outro1)
	(scenery_animation_start_relative ring_02 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring02_01" anchor_outro1)
	(scenery_animation_start_relative ring_03 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring03_01" anchor_outro1)
	(scenery_animation_start_relative ring_04 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring04_01" anchor_outro1)
	(scenery_animation_start_relative ring_05 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring05_01" anchor_outro1)
	(scenery_animation_start_relative ring_06 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring06_01" anchor_outro1)
	(scenery_animation_start_relative ring_07 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring07_01" anchor_outro1)
	(scenery_animation_start_relative ring_08 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring08_01" anchor_outro1)

	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_outro_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_outro\foley\c07_outro_02_fol)
	
	(sleep (camera_time))
	
	(c07_outro_01_cleanup)

	)
	
; C07_OUTRO SCENE 02 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_outro_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_outro\foley\c07_outro_02_fol none 1)
	(print "c07_outro foley 02 start")
	)
	
(script dormant c07_9010_cor
	(sleep 38)
	(sound_impulse_start_effect sound\dialog\levels\07_highcharity\cinematic\c07_9010_cor none 1 radio_default_loop)
	(cinematic_subtitle c07_9010_cor 2)	
	)

(script dormant c07_9020_mas
	(sleep 104)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_9020_mas chief_outro 1)
	(cinematic_subtitle c07_9020_mas 2)	
	)

(script dormant c07_9030_cor
	(sleep 147)
	(sound_impulse_start_effect sound\dialog\levels\07_highcharity\cinematic\c07_9030_cor none 1 radio_default_loop)
	(cinematic_subtitle c07_9030_cor 2)	
	
	(unit_set_emotional_state cortana_outro pensive .25 0)
	(print "cortana - pensive .25 0")
	
	)

(script dormant c07_9040_cor
	(sleep 211)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_9040_cor cortana_outro 1)
	(cinematic_subtitle c07_9040_cor 2)	
	
	(unit_set_emotional_state cortana_outro disappointed .75 60)
	(print "cortana - disappointed .75 60")
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant chief_sparks
	(sleep 17)
	(print "chief sparks")
	(effect_new_on_object_marker effects\cinematics\07\chief_sparks chief_outro "body")
	)

(script dormant c07_outro_fov_02
	(sleep 99)
	(print "fov change: 36 -> 60 over 0 ticks")
	(camera_set_field_of_view 60 0)
	)
	
(script dormant c07_outro_cinematic_lighting_02
	
	(cinematic_lighting_set_primary_light -41 270 0.25 0.32 0.52)
	(cinematic_lighting_set_secondary_light 58 78 0.21 0.11 0.22)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	
	)
	
(script dormant ship_take_off_01
	(sleep 271)
	(print "effect - take off 01")
	(effect_new_on_object_marker effects\objects\cinematics\forerunner_ship\initial_take_off_scale12 forerunner_ship "thruster")
	(object_create_anew takeoff_dust)
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void c07_outro_03_problem_actors
	(print "problem actors")
	(object_create_anew matte_high_charity)
	(object_create_anew matte_substance)
	(object_create_anew_containing outro_fleet)
	)

; ---------------------------------------------------------------------

(script static void c07_outro_02_setup

	(object_create_anew cortana_outro)
	(object_cinematic_lod cortana_outro true)
	
	(object_create_anew bloom_quad)
	
	(wake c07_outro_foley_02)
	
	(wake c07_9010_cor)
	(wake c07_9020_mas)
	(wake c07_9030_cor)
	(wake c07_9040_cor)
	
	(wake chief_sparks)
	(wake ship_take_off_01)
	(wake c07_outro_cinematic_lighting_02)
	
	)
	
(script static void c07_outro_02_cleanup

	(object_destroy takeoff_dust)
	(object_destroy ring_01)
	(object_destroy ring_02)
	(object_destroy ring_03)
	(object_destroy ring_04)
	(object_destroy bloom_quad)
	
	)

(script static void c07_outro_scene_02

	(c07_outro_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_outro\07_outro "07_outro_02" none "anchor_flag_outro1")

	(custom_animation_relative chief_outro objects\characters\masterchief\07_outro\07_outro "chief_02" false anchor_outro1)
	(custom_animation_relative cortana_outro objects\characters\cortana\07_outro\07_outro "cortana_02" false anchor_outro1)
	
	(scenery_animation_start_relative forerunner_ship objects\cinematics\forerunner\forerunner_ship\07_outro\07_outro "forerunner_ship_02" anchor_outro1)
	(scenery_animation_start_relative alcove objects\cinematics\forerunner\forerunner_ship_alcove\07_outro\07_outro "alcove_02" anchor_outro1)
	(scenery_animation_start_relative cap objects\cinematics\covenant\conduit_cap\07_outro\07_outro "conduit_cap_02" anchor_outro1)
	
	(scenery_animation_start_relative ring_01 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring01_02" anchor_outro1)
	(scenery_animation_start_relative ring_02 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring02_02" anchor_outro1)
	(scenery_animation_start_relative ring_03 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring03_02" anchor_outro1)
	(scenery_animation_start_relative ring_04 objects\cinematics\covenant\conduit_ring\07_outro\07_outro "ring04_02" anchor_outro1)
	
	(scenery_animation_start_relative bloom_quad scenarios\objects\special\bloom_quad\07_outro\07_outro "bloom_quad_02" anchor_outro1)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_outro_03_predict_stub)
	(c07_outro_03_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_outro\foley\c07_outro_03_fol)
		
	(cinematic_screen_effect_start true)
		
	(sleep (- (camera_time) 5))	
	
	(cinematic_screen_effect_set_crossfade 1.5)
	(print "crossfade")
	
	(sleep 5)
	
	(c07_outro_02_cleanup)

	)
	
; C07_OUTRO SCENE 03 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_outro_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_outro\foley\c07_outro_03_fol none 1)
	(print "c07_outro foley 03 start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c07_outro_cinematic_lighting_03
	
	(cinematic_lighting_set_primary_light -41 270 0.25 0.32 0.52)
	(cinematic_lighting_set_secondary_light 58 78 0.21 0.11 0.22)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	
	(object_uses_cinematic_lighting forerunner_ship 1)
	
	)
	
(script dormant ship_take_off_02
	(sleep 0)
	(print "effect - take off 02")
	(effect_new_on_object_marker effects\objects\cinematics\forerunner_ship\initial_take_off_scale01 forerunner_ship "thruster")
	)
	
(script dormant ship_take_off_03
	(time_code_reset)
	(sleep 111)
	(print "effect - take off 02")
	(effect_new_on_object_marker effects\objects\cinematics\forerunner_ship\initial_take_off_scale04 forerunner_ship "thruster")
	)
	
(script dormant effect_slipspace
	(sleep 159)
	(print "effect - slipspace")
	(object_create_anew slipspace)
	)

; ---------------------------------------------------------------------

(script static void c07_outro_03_setup
	
	(wake c07_outro_foley_03)
	
	(wake ship_take_off_02)
	(wake ship_take_off_03)
	(wake effect_slipspace)
;	(wake c07_outro_fov_01)

	(wake c07_outro_cinematic_lighting_02)
	
	)
	
(script static void c07_outro_03_cleanup

	(cinematic_screen_effect_stop)

	(object_destroy forerunner_ship)
	(object_destroy matte_high_charity)
	(object_destroy matte_substance)
	(object_destroy_containing outro_fleet)
	
	)

(script static void c07_outro_scene_03

	(c07_outro_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_outro\07_outro "07_outro_03" none "anchor_flag_outro2")

	(scenery_animation_start_relative forerunner_ship objects\cinematics\forerunner\forerunner_ship\07_outro\07_outro "forerunner_ship_03" anchor_outro2)
	(scenery_animation_start_relative matte_high_charity objects\cinematics\matte_paintings\high_charity_exterior\07_outro\07_outro "high_charity_03" anchor_outro2)
	(scenery_animation_start_relative matte_substance objects\cinematics\matte_paintings\substance_space\07_outro\07_outro "substance_03" anchor_outro2)
	
	(fade_in 1 1 1 15)
	
	(sleep (- (camera_time) 30))
	
	(fade_out 0 0 0 30)
	(sleep 30)
	
	(sleep 90)
	
	(c07_outro_03_cleanup)

	)

; C07_OUTRO MASTER SCRIPT =============================================
; =====================================================================

(script static void c07_outro

	(texture_cache_flush)
	(geometry_cache_flush)

	(sound_class_set_gain vehicle 0 0)
	(sound_class_set_gain amb 0 0)

	(switch_bsp_by_name high_9_cinematic)
	(sleep 1)
	
	(c07_outro_scene_01)
	(c07_outro_scene_02)
	(c07_outro_scene_03)

	(sound_class_set_gain vehicle 1 1)
	(sound_class_set_gain amb 1 1)
	
	(rasterizer_bloom_override 0)
	
	)