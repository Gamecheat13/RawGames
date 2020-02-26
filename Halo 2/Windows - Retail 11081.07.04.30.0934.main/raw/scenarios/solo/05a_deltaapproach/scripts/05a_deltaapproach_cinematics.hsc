; CINEMATICS FOR LEVEL 05A, "DELTA APPROACH" ==========================
; =====================================================================

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)
	
	(script stub void x05_01_predict_stub (print "predict 01"))
	(script stub void x05_02_predict_stub (print "predict 02"))
	(script stub void x05_03_predict_stub (print "predict 03"))
	(script stub void x05_04_predict_stub (print "predict 04"))
	(script stub void x05_05_predict_stub (print "predict 05"))
	(script stub void x05_06a_predict_stub (print "predict 06a"))
	(script stub void x05_06b_predict_stub (print "predict 06b"))
	(script stub void x05_07_predict_stub (print "predict 07"))
	(script stub void x05_08_predict_stub (print "predict 08"))
	
	(script stub void 05_intro_01_predict_stub (print "predict 01"))
	(script stub void 05_intro_02_predict_stub (print "predict 02"))
	(script stub void 05_intro_03_predict_stub (print "predict 03"))

; X05 SCENE 01 --------------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant x05_score_01
	(sleep 40)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\music\x05_01_mus none 1)
	(print "x05 score 01 start")
	)	

(script dormant x05_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\foley\x05_01_fol none 1)
	(print "x05 foley 01 start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant x05_slipspace_open
	(sleep 10)
	(print "effect - slipspace open")
	(object_create_anew x05_slipspace)
	(sleep 300)
	(object_destroy x05_slipspace)
	)

(script dormant x05_cinematic_lighting_scene_01
	
	(cinematic_lighting_set_primary_light 34 146 0.51 0.79 0.99)
	(cinematic_lighting_set_secondary_light 6 118 0.18 0.22 0.41)
	(cinematic_lighting_set_ambient_light 0.00 0.00 0.00)

	(object_uses_cinematic_lighting carrier 1)
	(object_uses_cinematic_lighting iac 1)
	(object_uses_cinematic_lighting x05_debris 1)
	
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void x05_02_problem_actors
	(print "problem actors")
	
	(object_create_anew miranda)
	(object_create_anew iac_bridge)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod iac_bridge true)

	)

; ---------------------------------------------------------------------

(script static void x05_01_setup

	(object_create_anew carrier)
	(object_create_anew iac)
	(object_create_anew x05_debris)
	
	(object_cinematic_lod carrier true)
	(object_cinematic_lod iac true)
	(object_cinematic_lod x05_debris true)
	
	(wake x05_score_01)
	(wake x05_foley_01)

	(wake x05_slipspace_open)
	(wake x05_cinematic_lighting_scene_01)
	
	)
	
(script static void x05_01_cleanup

	(object_destroy carrier)
	
	)

(script static void x05_scene_01
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x05_01_predict_stub)
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\music\x05_01_mus)
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\foley\x05_01_fol)
	(sleep prediction_offset)
	
	(x05_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_01" none "anchor_flag_x05")
	
	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\x05\x05 "iac_01" anchor_x05)
	(scenery_animation_start_relative carrier scenarios\objects\covenant\military\capital_ship\x05\x05 "capital_ship_01" anchor_x05)
	(scenery_animation_start_relative x05_debris objects\cinematics\effects\x05_building_debris\x05\x05 "debris_01" anchor_x05)
	
	(fade_in 0 0 0 30)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x05_02_predict_stub)
	(x05_02_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\foley\x05_02_fol)
	
	(sleep (camera_time))
	
	(x05_01_cleanup)
	
	)


; X05 SCENE 02 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x05_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\foley\x05_02_fol none 1)
	(print "x05 foley 02 start")
	)

(script dormant x05_0010_mir
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0010_mir miranda 1)
	(cinematic_subtitle x05_0010_mir 1)
	
	(unit_set_emotional_state miranda shocked .5 15)
	(print "miranda - shocked .5 15")
	
	(unit_set_emotional_state nav_officer annoyed .25 0)
	(print "nav_officer - pain .5 0")
	
	(unit_set_emotional_state weap_officer annoyed .5 0)
	(print "nav_officer - annoyed .5 0")
	
	(sleep 153)
	
	(unit_set_emotional_state miranda pensive .5 30)
	(print "miranda - pensive .25 30")
	
	)

(script dormant x05_0020_mir
	(sleep 25)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0020_mir miranda 1)
	(cinematic_subtitle x05_0020_mir 1)
	)
	
(script dormant x05_0030_no1
	(sleep 51)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0030_no1 nav_officer 1)
	(cinematic_subtitle x05_0030_no1 2)
	)
	
(script dormant x05_0040_wo1
	(sleep 127)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0040_wo1 weap_officer 1)
	(cinematic_subtitle x05_0040_wo1 2)
	)
	
(script dormant x05_0050_mir
	(sleep 204)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0050_mir miranda 1)
	(cinematic_subtitle x05_0050_mir 2)
	)
	
(script dormant x05_0060_mir
	(sleep 272)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0060_mir none 1 radio_default_in)
	(cinematic_subtitle x05_0060_mir 2)
	)
	
(script dormant x05_0070_mir
	(sleep 327)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0070_mir none 1 radio_default_out)
	(cinematic_subtitle x05_0070_mir 1)
	
	(sleep 27)
	
	(unit_set_emotional_state johnson inquisitive .5 10)
	(print "johnson - inquisitive .5 10")
	
	)
	
(script dormant x05_0080_jon
	(sleep 367)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0080_jon johnson 1)
	(cinematic_subtitle x05_0080_jon 2)
	)
	
(script dormant x05_0090_cor
	(sleep 437)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0090_cor none 1 radio_default_loop)
	(cinematic_subtitle x05_0090_cor 1)
	)
	
(script dormant x05_0100_no1
	(sleep 481)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0100_no1 nav_officer 1)
	(cinematic_subtitle x05_0100_no1 3)
	
	(unit_set_emotional_state miranda pensive .5 0) 
	(print "miranda - pensive .5 0")
	
	(unit_set_emotional_state nav_officer shocked .5 30)
	(print "nav_officer - shocked .5 30")
	
	(sleep 90)
	
	(unit_set_emotional_state miranda shocked .5 120)
	(print "miranda - shocked .5 120")
	
	(sleep 60)
	
	(unit_set_emotional_state miranda shocked .25 90)
	(print "miranda - shocked .25 90")
	
	(sleep 75)
	
	(unit_set_emotional_state miranda shocked .05 60)
	(print "miranda - shocked .05 60")
	
	)
	
(script dormant x05_0110_mir
	(sleep 594)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0110_mir miranda 1)
	(cinematic_subtitle x05_0110_mir 3)
	
	)
	
; EFFECTS -------------------------------------------------------------
	
(script dormant x05_fov_02
	(sleep 49)
	(camera_set_field_of_view 36 0)
	(print "fov change: 60 -> 36 over 0 ticks")
	(sleep 154)
	(camera_set_field_of_view 60 0)
	(print "fov change: 36 -> 60 over 0 ticks")
	)
	
(script dormant x05_05_dof_scene_02

	(sleep 49)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 0 0 0 1 1 0)
	(print "rack focus")
	
	(sleep 76)
	(cinematic_screen_effect_set_depth_of_field 1 0 1 .5 1 0 .5)
	(print "rack focus")
	
	(sleep 78)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)
	
(script dormant x05_light_scene_02_bridge_1

	(print "light bridge")
	
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -73 160 0.117647 0.117647 0.176471)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)

	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting nav_officer 1)
	(object_uses_cinematic_lighting weap_officer 1)
	(object_uses_cinematic_lighting cigar 1)
	
;	(render_lights_enable_cinematic_shadow 1 miranda head .1)
;	(render_lights_enable_cinematic_shadow 1 chief head .1)
;	(render_lights_enable_cinematic_shadow 1 johnson head .1)
;	(render_lights_enable_cinematic_shadow 1 nav_officer head .1)
;	(render_lights_enable_cinematic_shadow 1 weap_officer head .1)
	
	(object_uses_cinematic_lighting iac_bridge 1)
	(object_uses_cinematic_lighting hev_bay 1)
	(object_uses_cinematic_lighting hev_01 1)
	(object_uses_cinematic_lighting hev_02 1)
	(object_uses_cinematic_lighting hev_03 1)
	(object_uses_cinematic_lighting hev_04 1)
	(object_uses_cinematic_lighting hev_05 1)
	(object_uses_cinematic_lighting hev_06 1)
	(object_uses_cinematic_lighting hev_07 1)
	(object_uses_cinematic_lighting hev_08 1)
	(object_uses_cinematic_lighting hev_09 1)
	(object_uses_cinematic_lighting hev_10 1)
	(object_uses_cinematic_lighting hev_11 1)
	(object_uses_cinematic_lighting hev_12 1)
	(object_uses_cinematic_lighting hev_13 1)
	(object_uses_cinematic_lighting hev_14 1)
	(object_uses_cinematic_lighting hev_15 1)
	(object_uses_cinematic_lighting hev_16 1)
	(object_uses_cinematic_lighting hev_17 1)
	
	)
	
(script dormant x05_light_scene_02_hev_1

	(sleep 264)
	(print "light hev")
	
	(cinematic_lighting_set_primary_light 8 172 0.55 0.39 0.26)
	(cinematic_lighting_set_secondary_light -46 246 0.19 0.18 0.26)
	(cinematic_lighting_set_ambient_light 0.04 0.04 0.05)
	
	)
	
(script dormant x05_light_scene_02_bridge_2

	(sleep 479)
	(print "light bridge")
	
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -73 160 0.117647 0.117647 0.176471)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	
	)
	
; ---------------------------------------------------------------------

(script static void x05_02_setup

	(object_create_anew chief)
	(object_create_anew johnson)
	(object_create_anew nav_officer)
	(object_create_anew weap_officer)
	(object_create_anew cigar)
	(object_create_anew_containing hev)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod nav_officer true)
	(object_cinematic_lod weap_officer true)
	(object_cinematic_lod cigar true)
	
	(object_cinematic_lod hev_bay true)
	(object_cinematic_lod hev_01 true)
	(object_cinematic_lod hev_02 true)
	(object_cinematic_lod hev_03 true)
	(object_cinematic_lod hev_04 true)
	(object_cinematic_lod hev_05 true)
	(object_cinematic_lod hev_06 true)
	(object_cinematic_lod hev_07 true)
	(object_cinematic_lod hev_08 true)
	(object_cinematic_lod hev_09 true)
	(object_cinematic_lod hev_10 true)
	(object_cinematic_lod hev_11 true)
	(object_cinematic_lod hev_12 true)
	(object_cinematic_lod hev_13 true)
	(object_cinematic_lod hev_14 true)
	(object_cinematic_lod hev_15 true)
	(object_cinematic_lod hev_16 true)
	(object_cinematic_lod hev_17 true)
	
	(wake x05_0010_mir)
	(wake x05_0020_mir)
	(wake x05_0030_no1)
	(wake x05_0040_wo1)
	(wake x05_0050_mir)
	(wake x05_0060_mir)
	(wake x05_0070_mir)
	(wake x05_0080_jon)
	(wake x05_0090_cor)
	(wake x05_0100_no1)
	(wake x05_0110_mir)
	
	(wake x05_foley_02)
	
	(wake x05_fov_02)
	(wake x05_05_dof_scene_02)
	(wake x05_light_scene_02_bridge_1)
	(wake x05_light_scene_02_hev_1)
	(wake x05_light_scene_02_bridge_2)
	
	)

(script static void x05_scene_02
	
	(x05_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_02" none "anchor_flag_x05")
	
	(custom_animation_relative miranda objects\characters\miranda\x05\x05 "miranda_02" false anchor_x05)
	(custom_animation_relative chief objects\characters\masterchief\x05\x05 "chief_02" false anchor_x05)
	(custom_animation_relative johnson objects\characters\marine\x05\x05 "johnson_02" false anchor_x05)
	(custom_animation_relative nav_officer objects\characters\marine\x05\x05 "nav_02" false anchor_x05)
	(custom_animation_relative weap_officer objects\characters\marine\x05\x05 "weap_02" false anchor_x05)
	
	(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_bent\x05\x05 "cigar_bent_02" anchor_x05)
	
	(scenery_animation_start_relative hev_01 objects\cinematics\human\hev\x05\x05 "hev01_02" anchor_x05)
	(scenery_animation_start_relative hev_02 objects\cinematics\human\hev\x05\x05 "hev02_02" anchor_x05)
	(scenery_animation_start_relative hev_03 objects\cinematics\human\hev\x05\x05 "hev03_02" anchor_x05)
	(scenery_animation_start_relative hev_04 objects\cinematics\human\hev\x05\x05 "hev04_02" anchor_x05)
	
	(scenery_animation_start_relative iac_bridge objects\cinematics\human\inamberclad_bridge\x05\x05 "bridge_02" anchor_x05)
	(scenery_animation_start_relative hev_bay objects\cinematics\human\inamberclad_hevbay\x05\x05 "hevbay_02" anchor_x05)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x05_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\music\x05_03_mus)
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\foley\x05_03_fol)
	
	(sleep (camera_time))
	
	)
	
; X05 SCENE 03 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x05_score_03
	(sleep 113)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\music\x05_03_mus none 1)
	(print "x05 score 03 start")
	)

(script dormant x05_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\foley\x05_03_fol none 1)
	(print "x05 foley 03 start")
	)
	
(script dormant x05_0120_cor
	(sleep 60)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0120_cor none 1 radio_default_loop)
	(cinematic_subtitle x05_0120_cor 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x05_cinematic_lighting_scene_03
	
	(cinematic_lighting_set_primary_light 34 146 0.51 0.79 0.99)
	(cinematic_lighting_set_secondary_light 6 118 0.18 0.22 0.41)
	(cinematic_lighting_set_ambient_light 0.00 0.00 0.00)
	
	)

; ---------------------------------------------------------------------

(script static void x05_03_setup

	(object_create_anew delta_halo)
	(object_create_anew matte_substance)
	(object_uses_cinematic_lighting delta_halo 1)
	
	(wake x05_score_03)
	(wake x05_foley_03)
	
	(wake x05_0120_cor)

	)

(script static void x05_scene_03
	
	(x05_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_03" none "anchor_flag_x05")

	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\x05\x05 "iac_03" anchor_x05)
	(scenery_animation_start_relative x05_debris objects\cinematics\effects\x05_building_debris\x05\x05 "debris_03" anchor_x05)

	(scenery_animation_start_relative delta_halo scenarios\objects\forerunner\industrial\halo\x05\x05 "halo_03" anchor_x05)
	(scenery_animation_start_relative matte_substance objects\cinematics\matte_paintings\substance_space\x05\x05 "substance_space_03" anchor_x05)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x05_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\foley\x05_04_fol)
	
	(sleep (camera_time))
	
	(object_destroy x05_debris)
	
	)
	
; X05 SCENE 04 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x05_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\foley\x05_04_fol none 1)
	(print "x05 foley 04 start")
	)

(script dormant x05_0130_jon
	(sleep 12)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0130_jon johnson 1)
	(cinematic_subtitle x05_0130_jon 1)
	
	(unit_set_emotional_state johnson shocked .75 10)
	(print "johnson - shocked .75 10")
	
	)	
	
(script dormant x05_0140_mir

	(unit_set_emotional_state miranda shocked .25 0)
	(print "miranda - shocked .25 0")

	(sleep 63)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0140_mir miranda 1)
	(cinematic_subtitle x05_0140_mir 2)
	
	(unit_set_emotional_state miranda pain .25 60)
	(print "miranda - pain .25 60")
	
	)
	
(script dormant x05_0150_mir
	(sleep 132)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0150_mir miranda 1)
	(cinematic_subtitle x05_0150_mir 2)
	)
	
(script dormant x05_0160_cor
	(sleep 202)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0160_cor none 1 radio_default_loop)
	(cinematic_subtitle x05_0160_cor 4)
	)
	
(script dormant x05_0170_mir
	(sleep 340)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0170_mir none 1 radio_default_loop)
	(cinematic_subtitle x05_0170_mir 3)
	)	
	
(script dormant x05_0180_mir
	(sleep 418)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0180_mir none 1 radio_default_loop)
	(cinematic_subtitle x05_0180_mir 2)
	
	(unit_set_emotional_state miranda angry .25 0)
	(print "miranda - angry .25 0")
	
	)
	
(script dormant x05_0181_mir
	(sleep 483)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0181_mir miranda 1)
	(cinematic_subtitle x05_0181_mir 2)
	
	(texture_camera_off)
	
	)
	
(script dormant x05_0190_cor
	(sleep 550)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0190_cor none 1 radio_default_loop)
	(cinematic_subtitle x05_0190_cor 1)
	)
	
(script dormant x05_0200_mir
	(sleep 573)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0200_mir miranda 1)
	(cinematic_subtitle x05_0200_mir 1)
	)
	
(script dormant x05_0210_wo1
	(sleep 602)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0210_wo1 weap_officer 1)
	(cinematic_subtitle x05_0210_wo1 3)
	
	(unit_set_emotional_state weap_officer pensive .5 60)
	(print "weap_officer - pensive .5 60")
	
	)
	
(script dormant x05_0220_mir
	(sleep 704)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0220_mir miranda 1)
	(cinematic_subtitle x05_0220_mir 1)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant x05_texture_camera_scene_04
	(object_create_anew texture_camera)
	(texture_camera_set_object_marker texture_camera marker 50)
	(scenery_animation_start_relative texture_camera objects\cinematics\texture_camera\x05\x05 "texture_camera_04" anchor_x05)
	)
	
(script dormant x05_fov_04

	(time_code_reset)

	(sleep 588)
	(camera_set_field_of_view 34 0)
	(print "fov change: 60 -> 34 over 0 ticks")
	)
	
(script dormant x05_05_dof_scene_04
	(sleep 589)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field .5 0 0 0 1 1 0)
	(print "rack focus")
	(sleep 112)
	(cinematic_screen_effect_set_depth_of_field .5 0 1 .25 1 0 .25)
	(print "rack focus")
	)
	
(script dormant x05_cinematic_lighting_scene_04
	(cinematic_lighting_set_primary_light 8 172 0.55 0.39 0.26)
	(cinematic_lighting_set_secondary_light -46 246 0.19 0.18 0.26)
	(cinematic_lighting_set_ambient_light 0.04 0.04 0.05)
	)
	
(script dormant x05_light_scene_04_bridge_1
	(sleep 49)
	(print "light bridge")
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -73 160 0.117647 0.117647 0.176471)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	)
	
(script dormant x05_light_scene_04_hev_1
	(sleep 326)
	(print "light hev")
	(cinematic_lighting_set_primary_light 8 172 0.55 0.39 0.26)
	(cinematic_lighting_set_secondary_light -46 246 0.19 0.18 0.26)
	(cinematic_lighting_set_ambient_light 0.04 0.04 0.05)
	)
	
(script dormant x05_light_scene_04_bridge_2
	(sleep 467)
	(print "light bridge")
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -73 160 0.117647 0.117647 0.176471)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	)
	
; ---------------------------------------------------------------------

(script static void x05_04_setup
	
	(wake x05_0130_jon)
	(wake x05_0140_mir)
	(wake x05_0150_mir)
	(wake x05_0160_cor)
	(wake x05_0170_mir)
	(wake x05_0180_mir)
	(wake x05_0181_mir)
	(wake x05_0190_cor)
	(wake x05_0200_mir)
	(wake x05_0210_wo1)
	(wake x05_0220_mir)
	
	(wake x05_texture_camera_scene_04)
	(wake x05_fov_04)
	(wake x05_05_dof_scene_04)
	
	(wake x05_cinematic_lighting_scene_04)
	(wake x05_light_scene_04_bridge_1)
	(wake x05_light_scene_04_hev_1)
	(wake x05_light_scene_04_bridge_2)
	
	(wake x05_foley_04)
	
	)
	
(script static void x05_04_cleanup
	
	(object_destroy cigar)
	(object_destroy texture_camera)
	(cinematic_screen_effect_stop)

	)

(script static void x05_scene_04
	
	(x05_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_04" none "anchor_flag_x05")
	
	(custom_animation_relative miranda objects\characters\miranda\x05\x05 "miranda_04" false anchor_x05)
	(custom_animation_relative chief objects\characters\masterchief\x05\x05 "chief_04" false anchor_x05)
	(custom_animation_relative johnson objects\characters\marine\x05\x05 "johnson_04" false anchor_x05)
	(custom_animation_relative nav_officer objects\characters\marine\x05\x05 "nav_04" false anchor_x05)
	(custom_animation_relative weap_officer objects\characters\marine\x05\x05 "weap_04" false anchor_x05)
	
	(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_bent\x05\x05 "cigar_bent_04" anchor_x05)
	
	(scenery_animation_start_relative hev_01 objects\cinematics\human\hev\x05\x05 "hev01_04" anchor_x05)
	(scenery_animation_start_relative hev_02 objects\cinematics\human\hev\x05\x05 "hev02_04" anchor_x05)
	
	(scenery_animation_start_relative iac_bridge objects\cinematics\human\inamberclad_bridge\x05\x05 "bridge_04" anchor_x05)
	(scenery_animation_start_relative hev_bay objects\cinematics\human\inamberclad_hevbay\x05\x05 "hevbay_04" anchor_x05)
	
	(scenery_animation_start_relative delta_halo scenarios\objects\forerunner\industrial\halo\x05\x05 "halo_04" anchor_x05)
	(scenery_animation_start_relative matte_substance objects\cinematics\matte_paintings\substance_space\x05\x05 "substance_space_04" anchor_x05)
		
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x05_05_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\foley\x05_05_fol)
	
	(sleep (camera_time))
	
	(x05_04_cleanup)
	
	)
	
; X05 SCENE 05 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x05_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\foley\x05_05_fol none 1)
	(print "x05 foley 05 start")
	)

(script dormant x05_0230_mir
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0230_mir none 1)
	(cinematic_subtitle x05_0230_mir 6)
	)	
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x05_cinematic_lighting_scene_05
	(cinematic_lighting_set_primary_light 34 146 0.51 0.79 0.99)
	(cinematic_lighting_set_secondary_light 6 118 0.18 0.22 0.41)
	(cinematic_lighting_set_ambient_light 0.00 0.00 0.00)
	)

; ---------------------------------------------------------------------

(script static void x05_05_setup

	(wake x05_0230_mir)
	(wake x05_foley_05)
	
	(wake x05_cinematic_lighting_scene_05)
	
	)

(script static void x05_scene_05
	
	(x05_05_setup)
	
	(camera_set_field_of_view 60 0)
	(print "fov change: 34 -> 60 over 0 ticks")
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_05" none "anchor_flag_x05")

	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\x05\x05 "iac_05" anchor_x05)

	(scenery_animation_start_relative delta_halo scenarios\objects\forerunner\industrial\halo\x05\x05 "halo_05" anchor_x05)
	(scenery_animation_start_relative matte_substance objects\cinematics\matte_paintings\substance_space\x05\x05 "substance_space_05" anchor_x05)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x05_06a_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\music\x05_06a_mus)
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\foley\x05_06a_fol)

	(sleep (camera_time))
	
;	(object_destroy delta_halo)
	
	)

; X05 SCENE 06A -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x05_score_06a
	(sleep 113)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\music\x05_06a_mus none 1)
	(print "x05 score 06a start")
	)

(script dormant x05_foley_06a
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\foley\x05_06a_fol none 1)
	(print "x05 foley 06a start")
	)

(script dormant x05_0240_mir
	(sleep 0)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0240_mir none 1 radio_default_in)
	(cinematic_subtitle x05_0240_mir 4)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x05_cinematic_light_scene_06a
	(cinematic_lighting_set_primary_light 8 172 0.55 0.39 0.26)
	(cinematic_lighting_set_secondary_light -46 246 0.19 0.18 0.26)
	(cinematic_lighting_set_ambient_light 0.04 0.04 0.05)
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x05_06b_problem_actors
	(object_create_anew johnson)
	(object_cinematic_lod johnson true)
	(object_uses_cinematic_lighting johnson 1)
	)

; ---------------------------------------------------------------------

(script static void x05_06a_setup
	
	(object_destroy johnson)
	
	(wake x05_score_06a)
	(wake x05_foley_06a)

	(wake x05_0240_mir)
	
	(wake x05_cinematic_light_scene_06a)
	
	)

(script static void x05_scene_06a
	
	(x05_06a_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_06a" none "anchor_flag_x05")
	
	(custom_animation_relative chief objects\characters\masterchief\x05\x05 "chief_06a" false anchor_x05)
	
	(scenery_animation_start_relative hev_01 objects\cinematics\human\hev\x05\x05 "hev01_06a" anchor_x05)
	(scenery_animation_start_relative hev_bay objects\cinematics\human\inamberclad_hevbay\x05\x05 "hevbay_06a" anchor_x05)
	
	(cinematic_screen_effect_start true)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x05_06b_predict_stub)
	(x05_06b_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\foley\x05_06b_fol)
	
	(sleep (- (camera_time) 5))
	
	(cinematic_screen_effect_set_crossfade 1)
	(sleep 5)
	
	)
	
; X05 SCENE 06B -------------------------------------------------------
; SOUND----------------------------------------------------------------

(script dormant x05_foley_06b
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\foley\x05_06b_fol none 1)
	(print "x05 foley 06b start")
	)

(script dormant x05_0250_mir
	(sleep 9)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0250_mir none 1 radio_default_loop)
	(cinematic_subtitle x05_0250_mir 3)
	)
	
(script dormant x05_0260_jon
	(sleep 89)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0260_jon johnson 1)
	(cinematic_subtitle x05_0260_jon 1)
	)
	
(script dormant x05_0270_mir
	(sleep 125)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0270_mir none 1 radio_default_loop)
	(cinematic_subtitle x05_0270_mir 3)
	)	
	
(script dormant x05_0280_mir
	(sleep 225)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\x05_0280_mir none 1 radio_default_out)
	(cinematic_subtitle x05_0280_mir 2)
	)
	
(script dormant x05_0290_mas
	(sleep 320)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0290_mas chief 1)
	(cinematic_subtitle x05_0290_mas 1)
	)
	
(script dormant x05_0300_wo1
	(sleep 356)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0300_wo1 weap_officer 1)
	(cinematic_subtitle x05_0300_wo1 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x05_fov_06b
	(sleep 358)
	(camera_set_field_of_view 35 0)
	(print "fov change: 60 -> 35 over 0 ticks")
	)
	
(script dormant x05_light_scene_06b_bridge_1
	(time_code_reset)
	(sleep 358)
	(print "light bridge")
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -73 160 0.117647 0.117647 0.176471)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x05_07_problem_actors
	(print "problem actors")
	(object_create_anew matte_delta_halo_close)
	)

; ---------------------------------------------------------------------

(script static void x05_06B_setup

	(wake x05_0250_mir)
	(wake x05_0260_jon)
	(wake x05_0270_mir)
	(wake x05_0280_mir)
	(wake x05_0290_mas)
	(wake x05_0300_wo1)
	
	(wake x05_foley_06b)

	(wake x05_fov_06b)
	(wake x05_light_scene_06b_bridge_1)
	
	)
	
(script static void x05_06B_cleanup
	
	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy nav_officer)
	(object_destroy weap_officer)

	)

(script static void x05_scene_06B
	
	(x05_06B_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_06b" none "anchor_flag_x05")
	
	(custom_animation_relative miranda objects\characters\miranda\x05\x05 "miranda_06b" false anchor_x05)
	(custom_animation_relative chief objects\characters\masterchief\x05\x05 "chief_06b" false anchor_x05)
	(custom_animation_relative johnson objects\characters\marine\x05\x05 "johnson_06b" false anchor_x05)
	(custom_animation_relative nav_officer objects\characters\marine\x05\x05 "nav_06b" false anchor_x05)
	(custom_animation_relative weap_officer objects\characters\marine\x05\x05 "weap_06b" false anchor_x05)
	
	(scenery_animation_start_relative hev_01 objects\cinematics\human\hev\x05\x05 "hev01_06b" anchor_x05)
	(scenery_animation_start_relative hev_02 objects\cinematics\human\hev\x05\x05 "hev02_06b" anchor_x05)
	(scenery_animation_start_relative hev_03 objects\cinematics\human\hev\x05\x05 "hev03_06b" anchor_x05)
	(scenery_animation_start_relative hev_04 objects\cinematics\human\hev\x05\x05 "hev04_06b" anchor_x05)
	
	(scenery_animation_start_relative iac_bridge objects\cinematics\human\inamberclad_bridge\x05\x05 "bridge_06b" anchor_x05)
	(scenery_animation_start_relative hev_bay objects\cinematics\human\inamberclad_hevbay\x05\x05 "hevbay_06b" anchor_x05)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x05_07_predict_stub)
	
	(sleep (- (camera_time) 15))
	(x05_07_problem_actors)
	
	(sleep (camera_time))
	
	(x05_06B_cleanup)
	
	)
	
; X05 SCENE 07 --------------------------------------------------------
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x05_cinematic_lighting_scene_07
	
	(cinematic_lighting_set_primary_light 34 146 0.51 0.79 0.99)
	(cinematic_lighting_set_secondary_light 6 118 0.18 0.22 0.41)
	(cinematic_lighting_set_ambient_light 0.00 0.00 0.00)
	
	)

; ---------------------------------------------------------------------

(script static void x05_scene_07
	
	(wake x05_cinematic_lighting_scene_07)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_07" none "anchor_flag_x05")
	(camera_set_field_of_view 60 0)

	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\x05\x05 "iac_07" anchor_x05)

	(scenery_animation_start_relative matte_substance objects\cinematics\matte_paintings\substance_space\x05\x05 "substance_space_07" anchor_x05)
	(scenery_animation_start_relative matte_delta_halo_close objects\cinematics\matte_paintings\delta_halo_close\x05\x05 "delta_halo_close_07" anchor_x05)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x05_08_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\x05\foley\x05_08_fol)

	(sleep (camera_time))
	
	)
	
; X05 SCENE 08 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x05_foley_08
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\x05\foley\x05_08_fol none 1)
	(print "x05 foley 08 start")
	)

(script dormant x05_0310_cor
	(sleep 9)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\x05_0310_cor none 1)
	(cinematic_subtitle x05_0310_cor 1)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_hev_release
	
	(sleep 40)
	(effect_new_on_object_marker effects\cinematics\05\hev_explosive_bolt hev_bay "explosive_bolt06")
	(effect_new_on_object_marker effects\cinematics\05\hev_launch_steam hev_bay "steam_vent06")
	(print "effects - first hev")
	
	(sleep 56)
	(effect_new_on_object_marker effects\cinematics\05\hev_explosive_bolt hev_bay "explosive_bolt05")
	(effect_new_on_object_marker effects\cinematics\05\hev_launch_steam hev_bay "steam_vent05")
	(print "effects - second hev")
	
	(sleep 37)
	(effect_new_on_object_marker effects\cinematics\05\hev_explosive_bolt hev_bay "explosive_bolt04")
	(effect_new_on_object_marker effects\cinematics\05\hev_launch_steam hev_bay "steam_vent04")
	(print "effects - second hev")
	
	(sleep 29)
	(effect_new_on_object_marker effects\cinematics\05\hev_explosive_bolt hev_bay "explosive_bolt03")
	(effect_new_on_object_marker effects\cinematics\05\hev_launch_steam hev_bay "steam_vent03")
	(print "effects - second hev")
	
	)
	
(script dormant effect_corona
	(sleep 320)
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_start hev_10 "")
	(print "effect - re-entry corona")
	)
	
(script dormant x05_effect_shake_01
	(sleep 300)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .5 3)
	)
	
(script dormant x05_cinematic_lighting_scene_08
	(cinematic_lighting_set_primary_light 8 172 0.55 0.39 0.26)
	(cinematic_lighting_set_secondary_light -46 246 0.19 0.18 0.26)
	(cinematic_lighting_set_ambient_light 0.04 0.04 0.05)
	)
	
(script dormant x05_light_scene_08_space
	(sleep 172)
	(print "light space")
	(cinematic_lighting_set_primary_light -21 32 0.48 0.53 0.69)
	(cinematic_lighting_set_secondary_light -17 214 0.18 0.22 0.41)
	(cinematic_lighting_set_ambient_light 0.11 0.11 0.14)
	
	)

; ---------------------------------------------------------------------

(script dormant destroy_chief
	(sleep 52) 
	(object_destroy chief)
	(print "destroy chief")
	)

(script static void x05_08_setup

	(wake x05_0310_cor)
	
	(wake x05_foley_08)

	(wake destroy_chief)
	
	(wake effect_hev_release)
	(wake effect_corona)
	(wake x05_effect_shake_01)
	
	(wake x05_cinematic_lighting_scene_08)
	(wake x05_light_scene_08_space)
	
	)
	
(script static void x05_08_cleanup
	
	(object_destroy delta_halo)
	(object_destroy_containing iac)
	(object_destroy_containing hev)
	(object_destroy_containing matte)
	(player_effect_stop 0)

	)

(script static void x05_scene_08
	
	(x05_08_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x05\x05 "x05_08" none "anchor_flag_x05")

	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\x05\x05 "iac_08" anchor_x05)
	(custom_animation_relative chief objects\characters\masterchief\x05\x05 "chief_08" false anchor_x05)
	
	(scenery_animation_start_relative hev_01 objects\cinematics\human\hev\x05\x05 "hev01_08" anchor_x05)
	(scenery_animation_start_relative hev_02 objects\cinematics\human\hev\x05\x05 "hev02_08" anchor_x05)
	(scenery_animation_start_relative hev_03 objects\cinematics\human\hev\x05\x05 "hev03_08" anchor_x05)
	(scenery_animation_start_relative hev_04 objects\cinematics\human\hev\x05\x05 "hev04_08" anchor_x05)
	(scenery_animation_start_relative hev_05 objects\cinematics\human\hev\x05\x05 "hev05_08" anchor_x05)
	(scenery_animation_start_relative hev_06 objects\cinematics\human\hev\x05\x05 "hev06_08" anchor_x05)
	
	(scenery_animation_start_relative delta_halo scenarios\objects\forerunner\industrial\halo\x05\x05 "halo_08" anchor_x05)
	(scenery_animation_start_relative hev_bay objects\cinematics\human\inamberclad_hevbay\x05\x05 "hevbay_08" anchor_x05)
	(scenery_animation_start_relative matte_delta_halo_close objects\cinematics\matte_paintings\delta_halo_close\x05\x05 "delta_halo_close_08" anchor_x05)
	
	(scenery_animation_start_relative hev_07 objects\cinematics\human\hev\x05\x05 "hev07_08" anchor_x05)
	(scenery_animation_start_relative hev_08 objects\cinematics\human\hev\x05\x05 "hev08_08" anchor_x05)
	(scenery_animation_start_relative hev_09 objects\cinematics\human\hev\x05\x05 "hev09_08" anchor_x05)
	(scenery_animation_start_relative hev_10 objects\cinematics\human\hev\x05\x05 "hev10_08" anchor_x05)
	(scenery_animation_start_relative hev_11 objects\cinematics\human\hev\x05\x05 "hev11_08" anchor_x05)
	(scenery_animation_start_relative hev_12 objects\cinematics\human\hev\x05\x05 "hev12_08" anchor_x05)
	(scenery_animation_start_relative hev_13 objects\cinematics\human\hev\x05\x05 "hev13_08" anchor_x05)
	(scenery_animation_start_relative hev_14 objects\cinematics\human\hev\x05\x05 "hev14_08" anchor_x05)
	(scenery_animation_start_relative hev_15 objects\cinematics\human\hev\x05\x05 "hev15_08" anchor_x05)
	(scenery_animation_start_relative hev_16 objects\cinematics\human\hev\x05\x05 "hev16_08" anchor_x05)
	(scenery_animation_start_relative hev_17 objects\cinematics\human\hev\x05\x05 "hev17_08" anchor_x05)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 1 1 1 5)
	(sleep 5)
	
	(x05_08_cleanup)
	
	)

; X05 MASTER SCRIPT ===================================================
; =====================================================================

(script static void x05

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name bsp_x05)
	(sleep 1)
	
	(x05_scene_01)
	(x05_scene_02)
	(x05_scene_03)
	(x05_scene_04)
	(x05_scene_05)
	(x05_scene_06a)
	(x05_scene_06b)
	(x05_scene_07)
	(x05_scene_08)
	
	)	

; C05_INTRO SCENE 01 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c05_intro_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_intro\foley\c05_intro_01_fol none 1)
	(print "c05_intro foley 01 start")
	)

(script dormant c05_1010_cor
	(sleep 192)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_1010_cor none 1)
	(cinematic_subtitle c05_1010_cor 1)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant effect_burn_contrails

	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_burn corona_02 "")
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_contrail corona_02 "")
	
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_burn corona_03 "")
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_contrail corona_03 "")
	
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_burn corona_04 "")
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_contrail corona_04 "")
	
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_burn corona_05 "")
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_contrail corona_05 "")
	
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_burn corona_06 "")
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_contrail corona_06 "")
	
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_burn corona_07 "")
	(effect_new_on_object_marker effects\cinematics\05\hev_reentry_contrail corona_07 "")

	(print "effect - burn, contrail")
	
	)

(script dormant effect_chute_pins
	(sleep 259)
	(print "effect - chute pins")
	(effect_new_on_object_marker effects\cinematics\05\hev_explosive_bolt hev_02 "cable_release")
	)

(script dormant effect_retros_01
	(sleep 264)
	(print "effect - retro rockets")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_02 "retro_rocket")
	)
	
(script dormant c05_intro_dof_01
	(time_code_reset)
	(sleep 79)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 20 0 0 0 5 5 0)
	(print "rack focus")
	)

(script dormant c05_intro_cinematic_light_01
	
	(cinematic_lighting_set_primary_light -21 32 0.48 0.53 0.69)
	(cinematic_lighting_set_secondary_light -17 214 0.18 0.22 0.41)
	(cinematic_lighting_set_ambient_light 0.11 0.11 0.14)

	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting hev_01 1)
	(object_uses_cinematic_lighting hev_02 1)
	(object_uses_cinematic_lighting hev_03 1)
	(object_uses_cinematic_lighting hev_04 1)
	(object_uses_cinematic_lighting hev_05 1)
	(object_uses_cinematic_lighting hev_06 1)
	(object_uses_cinematic_lighting hev_07 1)
	(object_uses_cinematic_lighting hev_chute 1)
	
	)

; ---------------------------------------------------------------------

(script dormant hev_unhide
	(sleep 126)
	(print "hev unhide")
	(object_hide hev_06 false)
	)

(script dormant destroy_corona_02
	(sleep 210)
	(print "destroy corona 02")
	(object_destroy corona_02)
	)

(script static void c05_intro_01_setup

	(object_create_anew chief)
	
	(object_create_anew hev_01)
	(object_create_anew hev_02)
	(object_create_anew hev_03)
	(object_create_anew hev_04)
	(object_create_anew hev_05)
	(object_create_anew hev_06)
	(object_create_anew hev_07)
	
	(object_create_anew hev_chute)
	
	(object_create_anew corona_01)
	(object_create_anew corona_02)
	(object_create_anew corona_03)
	(object_create_anew corona_04)
	(object_create_anew corona_05)
	(object_create_anew corona_06)
	(object_create_anew corona_07)
	
	(object_create_anew matte_horizon)
	(object_create_anew matte_islands)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod hev_01 true)
	(object_cinematic_lod hev_02 true)
	(object_cinematic_lod hev_03 true)
	(object_cinematic_lod hev_04 true)
	(object_cinematic_lod hev_05 true)
	(object_cinematic_lod hev_06 true)
	(object_cinematic_lod hev_07 true)
	(object_cinematic_lod hev_chute true)
	
	(object_hide hev_06 true)
	
	(wake c05_1010_cor)
	(wake c05_intro_foley_01)

	(wake destroy_corona_02)
	
	(wake effect_burn_contrails)
	(wake hev_unhide)
	(wake effect_chute_pins)
	(wake effect_retros_01)
	(wake c05_intro_dof_01)
	(wake c05_intro_cinematic_light_01)
	
	)
	
(script static void c05_intro_01_cleanup
	
	(object_destroy chief_intro)
	(object_destroy_containing matte)
	
	(object_destroy hev_01)
	(object_destroy hev_02)
	(object_destroy hev_03)
	(object_destroy hev_04)
	(object_destroy hev_05)
	(object_destroy hev_06)
	(object_destroy hev_07)

	(object_destroy_containing corona)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	)

(script static void c05_intro_scene_01

	(fade_out 1 1 1 0)

	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(05_intro_01_predict_stub)
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_intro\foley\c05_intro_01_fol)
	(sleep prediction_offset)

	(c05_intro_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_intro\05_intro "05_intro_01" none "anchor_flag_x05")
	
	(custom_animation_relative chief objects\characters\masterchief\05_intro\05_intro "chief_01" false anchor_x05)
	
	(scenery_animation_start_relative hev_01 objects\cinematics\human\hev\05_intro\05_intro "hev01_01" anchor_x05)
	(scenery_animation_start_relative hev_02 objects\cinematics\human\hev\05_intro\05_intro "hev02_01" anchor_x05)
	(scenery_animation_start_relative hev_03 objects\cinematics\human\hev\05_intro\05_intro "hev03_01" anchor_x05)
	(scenery_animation_start_relative hev_04 objects\cinematics\human\hev\05_intro\05_intro "hev04_01" anchor_x05)
	(scenery_animation_start_relative hev_05 objects\cinematics\human\hev\05_intro\05_intro "hev05_01" anchor_x05)
	(scenery_animation_start_relative hev_06 objects\cinematics\human\hev\05_intro\05_intro "hev06_01" anchor_x05)
	(scenery_animation_start_relative hev_07 objects\cinematics\human\hev\05_intro\05_intro "hev07_01" anchor_x05)
	
	(scenery_animation_start_relative hev_chute objects\cinematics\human\hev\hev_chute\05_intro\05_intro "hev_chute_01" anchor_x05)

;	(scenery_animation_start_relative corona_01 objects\cinematics\human\hev_reentry\05_intro\05_intro "hev_reentry01_01" anchor_x05)	
	(scenery_animation_start_relative corona_02 objects\cinematics\human\hev_reentry\05_intro\05_intro "hev_reentry02_01" anchor_x05)
	(scenery_animation_start_relative corona_03 objects\cinematics\human\hev_reentry\05_intro\05_intro "hev_reentry03_01" anchor_x05)
	(scenery_animation_start_relative corona_04 objects\cinematics\human\hev_reentry\05_intro\05_intro "hev_reentry04_01" anchor_x05)
	(scenery_animation_start_relative corona_05 objects\cinematics\human\hev_reentry\05_intro\05_intro "hev_reentry05_01" anchor_x05)
	(scenery_animation_start_relative corona_06 objects\cinematics\human\hev_reentry\05_intro\05_intro "hev_reentry06_01" anchor_x05)
	(scenery_animation_start_relative corona_07 objects\cinematics\human\hev_reentry\05_intro\05_intro "hev_reentry07_01" anchor_x05)	
	
	(scenery_animation_start_relative matte_horizon objects\cinematics\matte_paintings\delta_horizon\05_intro\05_intro "delta_horizon_01" anchor_x05)
	(scenery_animation_start_relative matte_islands objects\cinematics\matte_paintings\delta_islands\05_intro\05_intro "delta_islands_01" anchor_x05)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_intro\foley\c05_intro_02_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c05_intro_01_cleanup)
	
	)

; C05_INTRO SCENE 02 --------------------------------------------------
; FOR SILAS, MY LITTLE ALIEN ------------------------------------------

(script dormant little_alien
	
	(if (= "easy" (game_difficulty_get_real))
	(begin
	
		(object_create_anew tree_toy)
		(objects_attach grunt_01 "right_hand" tree_toy "")
		(sleep 150)
		(object_destroy tree_toy)

	)
	)
	
	(if (= "normal" (game_difficulty_get_real))
	(begin
		
		(object_create_anew grenade_toy_01)
		(object_create_anew grenade_toy_02)
		(objects_attach grunt_01 "right_hand" grenade_toy_01 "")
		(objects_attach grunt_01 "left_hand" grenade_toy_02 "")
		(sleep 150)
		(object_destroy grenade_toy_01)
		(object_destroy grenade_toy_02) 
	)
	)
	
	(if (= "heroic" (game_difficulty_get_real))
	(begin
	
		(object_create_anew intro_fire)
		(sleep 150)
		(object_destroy intro_fire)
	)
	)
	
	(if (= "legendary" (game_difficulty_get_real))
	(begin
				
		(object_create_anew chief_toy)
		(object_create_anew grunt_toy)
		(objects_attach grunt_01 "right_hand" grunt_toy "")
		(objects_attach grunt_01 "left_hand" chief_toy "")
		(sleep 150)
		(object_destroy chief_toy)
		(object_destroy grunt_toy) 
		
	)
	)
	
	)

; SOUND ---------------------------------------------------------------

(script dormant c05_intro_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_intro\foley\c05_intro_02_fol none 1)
	(print "c05_intro foley 02 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_retros_02
	(sleep 1)
	(print "effect - retro-rockets")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_01 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_02 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_03 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_04 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_05 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_06 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_07 "retro_rocket")	
	)
	
(script dormant effect_retros_03
	(sleep 310)
	(print "effect - retro-rockets")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_01 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_02 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_03 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_04 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_05 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_06 "retro_rocket")
	(effect_new_on_object_marker effects\cinematics\05\hev_retro_rocket hev_close_07 "retro_rocket")
	)
	
(script dormant c05_intro_dof_02
	(time_code_reset)
	(sleep 218)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 1 1 0 0 0 0)
	(print "rack focus")
	
	(time_code_reset)
	(sleep 88)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)

(script dormant c05_intro_cinematic_light_02
	
	(cinematic_lighting_set_primary_light 43 284 0.45 0.39 0.27)
	(cinematic_lighting_set_secondary_light 1 112 0.25 0.26 0.73)
	(cinematic_lighting_set_ambient_light 0.11 0.12 0.07)

	(object_uses_cinematic_lighting hev_close_01 1)
	(object_uses_cinematic_lighting hev_close_02 1)
	(object_uses_cinematic_lighting hev_close_03 1)
	(object_uses_cinematic_lighting hev_close_04 1)
	(object_uses_cinematic_lighting hev_close_05 1)
	(object_uses_cinematic_lighting hev_close_06 1)
	(object_uses_cinematic_lighting hev_close_07 1)
	(object_uses_cinematic_lighting hev_close_08 1)

	(object_uses_cinematic_lighting grunt_01 1)
	(object_uses_cinematic_lighting jackal_01 1)
	(object_uses_cinematic_lighting intro_turret 1)
	
	)
	
; ---------------------------------------------------------------------

(script dormant jackal_shield_activate
	(sleep 278)
	(print "jackal shield activate")
	(object_create_anew jackal_shield)
	(objects_attach jackal_01 "shield_light" jackal_shield "")
	(object_set_function_variable jackal_01 "shield" 1 1)
	)

(script static void c05_intro_02_setup

	(object_create_anew hev_close_01)
	(object_create_anew hev_close_02)
	(object_create_anew hev_close_03)
	(object_create_anew hev_close_04)
	(object_create_anew hev_close_05)
	(object_create_anew hev_close_06)
	(object_create_anew hev_close_07)
	(object_create_anew hev_close_08)

	(object_create_anew grunt_01)
	(object_create_anew jackal_01)
	(object_create_anew intro_turret)
	
	(object_cinematic_lod hev_close_01 true)
	(object_cinematic_lod hev_close_02 true)
	(object_cinematic_lod hev_close_03 true)
	(object_cinematic_lod hev_close_04 true)
	(object_cinematic_lod hev_close_05 true)
	(object_cinematic_lod hev_close_06 true)
	(object_cinematic_lod hev_close_07 true)
	(object_cinematic_lod hev_close_08 true)
	
	(object_cinematic_lod grunt_01 true)
	(object_cinematic_lod jackal_01 true)
	(object_cinematic_lod intro_turret true)
	
	(object_set_function_variable jackal_01 "shield" 0 0)
	
	(wake c05_intro_foley_02)
	
	(wake effect_retros_02)
	(wake effect_retros_03)
	(wake c05_intro_dof_02)
	(wake c05_intro_cinematic_light_02)
	
	(wake little_alien)
	(wake jackal_shield_activate)
	
	)

(script static void c05_intro_scene_02

	(cinematic_lightmap_shadow_enable)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(05_intro_02_predict_stub)
	(sleep prediction_offset)

	(c05_intro_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_intro\05_intro "05_intro_02" none "anchor_flag_intro")
	
	(custom_animation_relative grunt_01 objects\characters\grunt\05_intro\05_intro "grunt_02" false anchor_intro)
	(custom_animation_relative jackal_01 objects\characters\jackal\05_intro\05_intro "jackal_02" false anchor_intro)
	
	(custom_animation_relative intro_turret objects\vehicles\c_turret_ap\05_intro\05_intro "turret_02" false anchor_intro)
	
	(scenery_animation_start_relative hev_close_01 objects\cinematics\human\hev\05_intro\05_intro "hev01_02" anchor_intro)
	(scenery_animation_start_relative hev_close_02 objects\cinematics\human\hev\05_intro\05_intro "hev02_02" anchor_intro)
	(scenery_animation_start_relative hev_close_03 objects\cinematics\human\hev\05_intro\05_intro "hev03_02" anchor_intro)
	(scenery_animation_start_relative hev_close_04 objects\cinematics\human\hev\05_intro\05_intro "hev04_02" anchor_intro)
	(scenery_animation_start_relative hev_close_05 objects\cinematics\human\hev\05_intro\05_intro "hev05_02" anchor_intro)
	(scenery_animation_start_relative hev_close_06 objects\cinematics\human\hev\05_intro\05_intro "hev06_02" anchor_intro)
	(scenery_animation_start_relative hev_close_07 objects\cinematics\human\hev\05_intro\05_intro "hev07_02" anchor_intro)

; 	safety white
	(sleep 5)

	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(05_intro_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_intro\foley\c05_intro_03_fol)
	
	(sleep (camera_time))
	
	(cinematic_screen_effect_stop)
	
	)
	
; C05_INTRO SCENE 03 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c05_intro_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_intro\foley\c05_intro_03_fol none 1)
	(print "c05_intro foley 03 start")
	)

(script dormant c05_1020_cor
	(sleep 439)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_1020_cor none 1)
	(cinematic_subtitle c05_1020_cor 2.5)
	)

(script dormant c05_1030_cor
	(sleep 552)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_1030_cor none 1)
	(cinematic_subtitle c05_1030_cor 1)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant effect_dust
	(time_code_reset)
	(sleep 286)
	(effect_new effects\cinematics\05\hev_land c05_intro_pod_01)
	(print "first pod")
	
	(sleep 42)
	(effect_new effects\cinematics\05\hev_land c05_intro_pod_03)
	(print "second pod")
	
	(sleep 29)
	(effect_new effects\cinematics\05\hev_land c05_intro_pod_02)
	(print "third pod")
	)

(script dormant effect_hev_door_release
	(sleep 390)
	(effect_new_on_object_marker effects\cinematics\05\hev_door_release hev_close_06 door_release)
	(print "effect - blow pins")
	)

(script dormant intro_turret_fire

	(object_create turret_handheld)
	(objects_attach intro_turret "primary_trigger" turret_handheld "")
	(object_hide turret_handheld true)
	
	(sleep 131)
	(print "turret fire")
	(weapon_hold_trigger turret_handheld 0 true)
	
	(sleep 150)
	(weapon_hold_trigger turret_handheld 0 false)
	
	)
	
(script dormant intro_turret_fire_02

	(object_create turret_handheld_02)
	(objects_attach intro_turret_02 "primary_trigger" turret_handheld_02 "")
	(object_hide turret_handheld_02 true)
	
	(sleep 193)
	(print "turret_02 fire")
	(weapon_hold_trigger turret_handheld_02 0 true)
	
	(sleep 160)
	(weapon_hold_trigger turret_handheld_02 0 false)
	
	)

(script dormant 05_intro_fov_03_1
	(sleep 161)
	(print "fov switch")
	(camera_set_field_of_view 70 0)
	(print "fov change: 60 -> 70 over 0 ticks")
	)
	
(script dormant 05_intro_fov_03_2
	(sleep 280)
	(print "fov switch")
	(camera_set_field_of_view 60 0)
	(print "fov change: 70 -> 60 over 0 ticks")
	)
	
(script dormant c05_intro_cinematic_light_03
	
	(object_uses_cinematic_lighting chief_intro 1)
	(object_uses_cinematic_lighting smg_01 1)
	(object_uses_cinematic_lighting rocket_01 1)
	
	)	

; ---------------------------------------------------------------------

(script dormant late_pods
	(sleep 280)
	(scenery_animation_start_relative hev_close_06 objects\cinematics\human\hev\05_intro\05_intro "hev06_03" anchor_intro)
	(scenery_animation_start_relative hev_close_07 objects\cinematics\human\hev\05_intro\05_intro "hev07_03" anchor_intro)
	(scenery_animation_start_relative hev_close_08 objects\cinematics\human\hev\05_intro\05_intro "hev08_03" anchor_intro)
	)

(script static void c05_intro_03_setup

	(object_create_anew chief_intro)
	(object_create_anew rocket_01)
	(object_create_anew smg_01)
	(object_create_anew intro_turret_02)
	
	(object_cinematic_lod chief_intro true)
	(object_cinematic_lod rocket_01 true)
	(object_cinematic_lod smg_01 true)
	(object_cinematic_lod intro_turret_02 true)
	
	(object_destroy intro_crate_01)
	(object_destroy intro_crate_02)
	
	(wake c05_1020_cor)
	(wake c05_1030_cor)
	
	(wake c05_intro_foley_03)
	
	(wake late_pods)
	
	(wake effect_dust)
	(wake effect_hev_door_release)
	(wake intro_turret_fire)
	(wake intro_turret_fire_02)
	
	(wake 05_intro_fov_03_1)
	(wake 05_intro_fov_03_2)

	(wake c05_intro_cinematic_light_03)
	
	)
	
(script static void c05_intro_03_cleanup
	
	(object_destroy chief_intro)
	(object_destroy grunt_01)
	(object_destroy jackal_01)
	(object_destroy_containing turret)
	(object_destroy rocket_01)
	(object_destroy smg_01)
	
	(object_destroy_containing hev_close)
	
	(object_create_anew intro_crate_01)
	(object_create_anew intro_crate_02)

	)

(script static void c05_intro_scene_03
	
	(c05_intro_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_intro\05_intro "05_intro_03" none "anchor_flag_intro")
	
	(custom_animation_relative grunt_01 objects\characters\grunt\05_intro\05_intro "grunt_03" false anchor_intro)
	(custom_animation_relative jackal_01 objects\characters\jackal\05_intro\05_intro "jackal_03" false anchor_intro)
	
	(custom_animation_relative intro_turret objects\vehicles\c_turret_ap\05_intro\05_intro "turret_03" false anchor_intro)
	(custom_animation_relative intro_turret_02 objects\vehicles\c_turret_ap\05_intro\05_intro "turret02_03" false anchor_intro)
	
	(scenery_animation_start_relative hev_close_01 objects\cinematics\human\hev\05_intro\05_intro "hev01_03" anchor_intro)
	(scenery_animation_start_relative hev_close_02 objects\cinematics\human\hev\05_intro\05_intro "hev02_03" anchor_intro)
	(scenery_animation_start_relative hev_close_03 objects\cinematics\human\hev\05_intro\05_intro "hev03_03" anchor_intro)
	(scenery_animation_start_relative hev_close_04 objects\cinematics\human\hev\05_intro\05_intro "hev04_03" anchor_intro)
	(scenery_animation_start_relative hev_close_05 objects\cinematics\human\hev\05_intro\05_intro "hev05_03" anchor_intro)
	(scenery_animation_start_relative smg_01 objects\weapons\rifle\smg\05_intro\05_intro "smg_03" anchor_intro)
	
	(sleep 400)
	
	(custom_animation_relative chief_intro objects\characters\masterchief\05_intro\05_intro "chief_03" false anchor_intro)
	(scenery_animation_start_relative rocket_01 objects\weapons\support_high\rocket_launcher\05_intro\05_intro "rocket_03" anchor_intro)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c05_intro_03_cleanup)
	
	(sleep 30)
	
	(cinematic_lightmap_shadow_disable)
	
	)

; C05_INTRO MASTER SCRIPT =============================================
; =====================================================================


(script static void c05_intro

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name bsp_x05)
	(sleep 1)
	
	(c05_intro_scene_01)
	
	(switch_bsp_by_name bsp_00)
	(sleep 1)
	
	(c05_intro_scene_02)
	(c05_intro_scene_03)
	
	)	