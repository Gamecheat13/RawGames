; CINEMATICS FOR LEVEL 05B, "DELTA TOWERS" ============================
; =====================================================================

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 60)
	
	(script stub void 05_intra1_01_predict_stub (print "predict 01"))
	(script stub void 05_intra1_02_predict_stub (print "predict 02"))
	(script stub void 05_intra1_03_predict_stub (print "predict 03"))

	(script stub void 05_intra2_01_predict_stub (print "predict 01"))
	
	(script stub void 05_outro_01_predict_stub (print "predict 01"))
	(script stub void 05_outro_02_predict_stub (print "predict 02"))
	(script stub void 05_outro_03_predict_stub (print "predict 03"))
	(script stub void 05_outro_04_predict_stub (print "predict 04"))
	(script stub void 05_outro_05_predict_stub (print "predict 05"))

; C05_INTRA_1 SCENE 01 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c05_intra1_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_intra1\music\c05_intra1_02_mus none 1)
	(print "c05_intra1 score 01 start")
	)
	
(script dormant c05_intra1_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_intra1\foley\c05_intra1_01_fol none 1)
	(print "c05_intra1 foley 01 start")
	)

(script dormant c05_2010_cor
	(sleep 17)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2010_cor none 1)
	(cinematic_subtitle c05_2010_cor 1)
	)

(script dormant c05_2020_cor
	(sleep 135)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2020_cor cortana 1)
	(cinematic_subtitle c05_2020_cor 1)
	
	(unit_set_emotional_state cortana angry .5 60)
	(print "cortana - angry .5 60")
	
	)
	
(script dormant c05_2030_cor
	(sleep 200)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2030_cor cortana 1)
	(cinematic_subtitle c05_2030_cor 3)
	)
	
(script dormant c05_2040_mas
	(sleep 299)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2040_mas chief 1)
	(cinematic_subtitle c05_2040_mas 1)
	)
	
(script dormant c05_2050_por
	(sleep 357)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2050_por regret 1)
	(cinematic_subtitle c05_2050_por 8)
	)
	
(script dormant c05_2060_cor
	(sleep 553)
	
	(unit_set_emotional_state cortana annoyed .25 60)
	(print "cortana - annoyed .25 60")
	
	(sleep 30)
	
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2060_cor cortana 1)
	(cinematic_subtitle c05_2060_cor 1)
	)

(script dormant c05_2070_mas
	(sleep 622)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2070_mas chief 1)
	(cinematic_subtitle c05_2070_mas 2)
	)
	
(script dormant c05_2080_mir
	(sleep 678)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\c05_2080_mir none 1 radio_default_in)
	(cinematic_subtitle c05_2080_mir 1)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant cortana_appear
	(sleep 98)
	(print "cortana appears") 
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off cortana_base "marker")
	)
	
(script dormant c05_intra1_cinematic_light_01
	
	(cinematic_lighting_set_primary_light -38 310 0.180392 0.160784 0.113725)
	(cinematic_lighting_set_secondary_light -46 162 0.458824 0.466667 0.74902)
	(cinematic_lighting_set_ambient_light 0.0823529 0.0470588 0.00784314)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting cortana 1)
	(object_uses_cinematic_lighting regret 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void c05_intra1_02_problem_actors

	(print "problem actors")
	
	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_create_anew pilot)
	(object_create_anew pelican_01)
	(object_create_anew holo_index)
	(object_create_anew iac_bridge)
	(object_create_anew matte_horizon)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod pilot true)
	(object_cinematic_lod pelican_01 true)
	(object_cinematic_lod holo_index true)
	(object_cinematic_lod iac_bridge true)
	
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting iac_bridge 1)
	
	(object_hide johnson true)
	(object_hide pilot true)
	(object_hide pelican_01 true)
	(object_hide matte_horizon true)

	)
	
; ---------------------------------------------------------------------


(script static void c05_intra1_01_setup

	(object_create_anew chief)
	(object_create_anew cortana)
	(object_create_anew regret)
	(object_create_anew throne_regret)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod cortana true)
	(object_cinematic_lod regret true)
	(object_cinematic_lod throne_regret true)
	
	(cinematic_clone_players_weapon chief "right_hand" "")
	
	(objects_attach regret "driver" throne_regret "driver_cinematic")
	
	(wake c05_2010_cor)
	(wake c05_2020_cor)
	(wake c05_2030_cor)
	(wake c05_2040_mas)
	(wake c05_2050_por)
	(wake c05_2060_cor)
	(wake c05_2070_mas)
	(wake c05_2080_mir)

	(wake c05_intra1_score_01)
	(wake c05_intra1_foley_01)
	
	(wake cortana_appear)
	(wake c05_intra1_cinematic_light_01)
	
	)

(script static void c05_intra1_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(05_intra1_01_predict_stub)
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_intra1\music\c05_intra1_02_mus)
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_intra1\foley\c05_intra1_01_fol)
	(sleep prediction_offset)
	
	(c05_intra1_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_intra1\05_intra1 "05_intra1_01" none "anchor_flag_intra1a")
	
	(custom_animation_relative chief objects\characters\masterchief\05_intra1\05_intra1 "chief_01" false anchor_intra1a)
	(custom_animation_relative regret objects\characters\prophet\05_intra1\05_intra1 "regret_01" false anchor_intra1a)
	
; 	safety white
	(sleep 5)
	
	(fade_in 1 1 1 15)
	
	(sleep 94)
	
	(custom_animation_relative cortana objects\characters\cortana\05_intra1\05_intra1 "cortana_01" false anchor_intra1a)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(05_intra1_02_predict_stub)
	(c05_intra1_02_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_intra1\foley\c05_intra1_02_fol)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 1 1 1 5)
	(sleep 5)
	
	)
	
; C05_INTRA_1 SCENE 02 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c05_intra1_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_intra1\foley\c05_intra1_02_fol none 1)
	(print "c05_intra1 foley 02 start")
	)

(script dormant c05_2090_mir

	(unit_set_emotional_state miranda pensive .5 0)
	(print "miranda - pensive .5 0")

	(sleep 7)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2090_mir miranda 1)
	(cinematic_subtitle c05_2090_mir 5)
	)

(script dormant c05_2100_mir
	(sleep 162)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2100_mir miranda 1)
	(cinematic_subtitle c05_2100_mir 7)
	)
	
(script dormant c05_2110_jon
	(sleep 373)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\c05_2110_jon johnson 1 radio_default_loop)
	(cinematic_subtitle c05_2110_jon 3)
	)
	
(script dormant c05_2120_mir
	(sleep 455)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2120_mir miranda 1)
	(cinematic_subtitle c05_2120_mir 2)
	)
	
(script dormant c05_2130_mir
	(sleep 509)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_2130_mir miranda 1)
	(cinematic_subtitle c05_2130_mir 2)
	
	(texture_camera_off)
	
	(sleep 45)
	
	(unit_set_emotional_state miranda angry .25 60)
	(print "miranda - angry .25 60")
	
	)
	
(script dormant c05_2140_jon
	(sleep 574)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\c05_2140_jon johnson 1 radio_default_loop)
	(cinematic_subtitle c05_2140_jon 1)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant intra1_texture_camera_on

	(object_create_anew texture_camera)
	(scenery_animation_start_relative texture_camera objects\cinematics\texture_camera\05_intra1\05_intra1 "texture_camera_02" anchor_intra1b)
	
	(sleep 150)
	(print "texture camera on")
	
	(texture_camera_set_object_marker texture_camera marker 50)
	
	(object_hide johnson false)
	(object_hide pilot false)
	(object_hide pelican_01 false)
	(object_hide matte_horizon false)
	
	)

(script dormant c05_intra1_cinematic_light_02
	
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -14 150 0.09 0.09 0.22)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting iac_bridge 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting pilot 1)
	(object_uses_cinematic_lighting index 1)
	(object_uses_cinematic_lighting pelican_01 1)
	
;	(render_lights_enable_cinematic_shadow 1 miranda head .1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c05_intra1_02_setup

	(object_create_anew holo_library)
	(object_create_anew matte_horizon)
	
	(object_cinematic_lod holo_library true)
	
	(wake c05_2090_mir)
	(wake c05_2100_mir)
	(wake c05_2110_jon)
	(wake c05_2120_mir)
	(wake c05_2130_mir)
	(wake c05_2140_jon)
	
	(wake c05_intra1_foley_02)
	
	(wake intra1_texture_camera_on)
	(wake c05_intra1_cinematic_light_02)
	
	)
	
(script static void c05_intra1_02_cleanup
	
	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy pilot)
	(object_destroy holo_index)
	(object_destroy holo_library)
	(object_destroy pelican_01)
	(object_destroy iac_bridge)
	(object_destroy texture_camera)
	(object_destroy matte_horizon)

	)

(script static void c05_intra1_scene_02
	
	(c05_intra1_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_intra1\05_intra1 "05_intra1_02" none "anchor_flag_intra1b")
	
	(custom_animation_relative miranda objects\characters\miranda\05_intra1\05_intra1 "miranda_02" false anchor_intra1b)
	(custom_animation_relative johnson objects\characters\marine\05_intra1\05_intra1 "johnson_02" false anchor_intra1b)
	(custom_animation_relative pilot objects\characters\marine\05_intra1\05_intra1 "marine01_02" false anchor_intra1b)
	
	(scenery_animation_start_relative iac_bridge objects\cinematics\human\inamberclad_bridge\05_intra1\05_intra1 "bridge_02" anchor_intra1b)
	
	(scenery_animation_start_relative holo_index objects\cinematics\forerunner\index_holo_human\05_intra1\05_intra1 "index_holo_human_02" anchor_intra1b)
	(scenery_animation_start_relative holo_library objects\cinematics\forerunner\mount_doom_holo\05_intra1\05_intra1 "mount_doom_holo_02" anchor_intra1b)
	(scenery_animation_start_relative matte_horizon objects\cinematics\matte_paintings\delta_horizon\05_intra1\05_intra1 "delta_horizon_02" anchor_intra1b)

	(custom_animation_relative pelican_01 objects\vehicles\pelican\05_intra1\05_intra1 "pelican_02" false anchor_intra1b)
	
	(sleep 30)
	(fade_in 1 1 1 5)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(05_intra1_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_intra1\foley\c05_intra1_03_fol)
	
	(sleep (camera_time))
	
	(c05_intra1_02_cleanup)
	
	)
	
; C05_INTRA_1 SCENE 03 ------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant c05_intra1_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_intra1\foley\c05_intra1_03_fol none 1)
	(print "c05_intra1 foley 03 start")
	)

(script dormant c05_2150_mir

	(unit_set_emotional_state cortana angry .5 0)
	(print "cortana - angry .5 0")

	(sleep 0)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\c05_2150_mir none 1 radio_default_loop)
	(cinematic_subtitle c05_2150_mir 3)
	)
	
(script dormant c05_2160_mir
	(sleep 99)
	(sound_impulse_start_effect sound\dialog\levels\05_deltatemple\cinematics\c05_2160_mir none 1 radio_default_out)
	(cinematic_subtitle c05_2160_mir 2)
	)

(script dormant cortana_disappear
	(sleep 35)
	(print "cortana disappears") 
	(effect_new_on_object_marker effects\objects\characters\cortana\cortana_on_off cortana_base "marker")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c05_intra1_cinematic_light_03

	(cinematic_lighting_set_primary_light -38 310 0.180392 0.160784 0.113725)
	(cinematic_lighting_set_secondary_light -46 162 0.458824 0.466667 0.74902)
	(cinematic_lighting_set_ambient_light 0.0823529 0.0470588 0.00784314)
	
	)
	
; ---------------------------------------------------------------------

(script static void c05_intra1_03_setup
	
	(wake c05_2150_mir)
	(wake c05_2160_mir)
	
	(wake c05_intra1_foley_03)

	(wake c05_intra1_cinematic_light_03)

	(wake cortana_disappear)
	
	)
	
(script static void c05_intra1_03_cleanup
	
	(object_destroy chief)
	(object_destroy regret)
	(object_destroy throne_regret)
	(object_destroy cortana_base)

	)

(script static void c05_intra1_scene_03
	
	(c05_intra1_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_intra1\05_intra1 "05_intra1_03" none "anchor_flag_intra1a")
	
	(custom_animation_relative chief objects\characters\masterchief\05_intra1\05_intra1 "chief_03" false anchor_intra1a)
	(custom_animation_relative cortana objects\characters\cortana\05_intra1\05_intra1 "cortana_03" false anchor_intra1a)
	
	(sleep 50)
	
	(object_destroy cortana)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c05_intra1_03_cleanup)
	
	)
	
; C05_INTRA1 MASTER SCRIPT ============================================
; =====================================================================

(script static void c05_intra1

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name bsp_01)
	(sleep 1)
	
	(sound_class_set_gain amb 0 0)
	(sound_class_set_gain vehicle 0 0)
	
	(c05_intra1_scene_01)
	(c05_intra1_scene_02)
	(c05_intra1_scene_03)
	
	(sound_class_set_gain amb 0 15)
	
	)

; C05_INTRA2 ----------------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant c05_intra2_foley
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_intra2\foley\c05_intra2_01_fol none 1)
	(print "c05_intra2 foley start")
	)

(script dormant c05_3010_cor
	(sleep 275)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_3010_cor none 1)
	(cinematic_subtitle c05_3010_cor 2)
	)
	
(script dormant c05_3020_cor
	(sleep 359)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_3020_cor none 1)
	(cinematic_subtitle c05_3020_cor 2)
	)
	
(script dormant c05_3030_cor
	(sleep 513)
	(sound_impulse_start sound\dialog\levels\05_deltatemple\cinematics\c05_3030_cor none 1)
	(cinematic_subtitle c05_3030_cor 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c05_intra2_dof

	(sleep 250)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0 0 0 0)
	(print "rack focus")	
	
	(sleep 250)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	)
	
(script dormant c05_intra2_cinematic_light
	
	(cinematic_lighting_set_primary_light 24 272 0.639216 0.54902 0.388235)
	(cinematic_lighting_set_secondary_light -27 140 0.329412 0.180392 0.0509804)
	(cinematic_lighting_set_ambient_light 0.0784314 0.0784314 0.101961)
	
	(object_uses_cinematic_lighting chief 1)
	
	)
	
; ---------------------------------------------------------------------
	
(script dormant fleet_arrival
	(sleep 251)
	(print "fleet arrival")
	(object_create_anew intra2_fleet)
	)

(script static void c05_intra2_setup

	(object_create chief)
	(object_cinematic_lod chief true)
	
	(cinematic_clone_players_weapon chief "right_hand" "")
	
	(wake c05_3010_cor)
	(wake c05_3020_cor)
	(wake c05_3030_cor)
	
	(wake c05_intra2_foley)	

	(wake fleet_arrival)
	
	(wake c05_intra2_dof)
	(wake c05_intra2_cinematic_light)
	
	) 

(script static void c05_intra2

	(texture_cache_flush)
	(geometry_cache_flush)

	(switch_bsp_by_name bsp_03)
	(sleep 1)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(05_intra1_01_predict_stub)
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_intra2\foley\c05_intra2_01_fol)	
	(sleep prediction_offset)

	(c05_intra2_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_intra2\05_intra2 "05_intra2_01" none "anchor_flag_outro")
	
	(custom_animation_relative chief objects\characters\masterchief\05_intra2\05_intra2 "chief_01" false anchor_outro)
	
	(fade_in 1 1 1 15)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_destroy chief)
	(object_destroy intra2_fleet)
	
	)

; C05_OUTRO SCENE 01 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c05_outro_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_outro\music\c05_outro_01_mus none 1)
	(print "c05_outro score 01 start")
	)
	
(script dormant c05_outro_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_outro\foley\c05_outro_01_fol none 1)
	(print "c05_outro foley 01 start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_dust_scrape
	(time_code_reset)
	(sleep 240)
	(print "effect - dust scrape")
	(object_create_anew outro_dust_scrape)
	)
	
(script dormant c05_outro_01_dof

	(sleep 55)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0 0 0 0)
	(print "rack focus")	
	
	(sleep 130)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	)

(script dormant c05_outro_cinematic_light_01
	
	(cinematic_lighting_set_primary_light 24 272 0.639216 0.54902 0.388235)
	(cinematic_lighting_set_secondary_light -27 140 0.329412 0.180392 0.0509804)
	(cinematic_lighting_set_ambient_light 0.0784314 0.0784314 0.101961)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting carrier 1)
	
	)

; ---------------------------------------------------------------------

(script dormant c05_outro_problem_actors		
	(print "problem actors") 
	(object_create_anew chief)
	(object_cinematic_lod chief true)
	)

(script static void c05_outro_01_setup

	(object_create_anew carrier)
	(object_cinematic_lod carrier true)

	(wake c05_outro_score_01)
	(wake c05_outro_foley_01)
	
	(wake effect_dust_scrape)
	(wake c05_outro_01_dof)
	(wake c05_outro_cinematic_light_01)
	
	(effect_new_on_object_marker effects\cinematics\05\covenant_beam carrier beam)
	
	)

(script static void c05_outro_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(05_outro_01_predict_stub)	
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_outro\music\c05_outro_01_mus)
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_outro\foley\c05_outro_01_fol)
	(wake c05_outro_problem_actors)
	(sleep prediction_offset)
	
	(c05_outro_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_outro\05_outro "05_outro_01" none "anchor_flag_outro")
	
	(custom_animation_relative chief objects\characters\masterchief\05_outro\05_outro "chief_01" false anchor_outro)
	(scenery_animation_start_relative carrier scenarios\objects\covenant\military\capital_ship\05_outro\05_outro "cruiser_01" anchor_outro)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>	
	(sleep (- (camera_time) prediction_offset))
	(05_outro_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_outro\foley\c05_outro_02_fol)
	
	(sleep (camera_time))
	
	)
	
; C05_OUTRO SCENE 02 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c05_outro_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_outro\foley\c05_outro_02_fol none 1)
	(print "c05_outro foley 02 start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_dust_land
	(sleep 59)
	(print "effect - dust land")
	(object_create_anew outro_dust_land)
	)

; ---------------------------------------------------------------------

(script static void c05_outro_scene_02
	
	(wake c05_outro_foley_02)
	(wake effect_dust_land)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_outro\05_outro "05_outro_02" none "anchor_flag_outro")
	
	(custom_animation_relative chief objects\characters\masterchief\05_outro\05_outro "chief_02" false anchor_outro)
	(scenery_animation_start_relative carrier scenarios\objects\covenant\military\capital_ship\05_outro\05_outro "cruiser_02" anchor_outro)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>	
	(sleep (- (camera_time) prediction_offset))
	(05_outro_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_outro\foley\c05_outro_03_fol)
	
	(sleep (camera_time))
	
	)
	
; C05_OUTRO SCENE 03 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c05_outro_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_outro\foley\c05_outro_03_fol none 1)
	(print "c05_outro foley 03 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c05_outro_fov_01
	
	(sleep 122)
	(camera_set_field_of_view 7 0)
	
	)
	
; ---------------------------------------------------------------------

(script static void c05_outro_03_setup

	(wake c05_outro_foley_03)
	
	(wake c05_outro_fov_01)
	
	)

(script static void c05_outro_scene_03
	
	(c05_outro_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_outro\05_outro "05_outro_03" none "anchor_flag_outro")
	(custom_animation_relative chief objects\characters\masterchief\05_outro\05_outro "chief_03" false anchor_outro)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>	
	(sleep (- (camera_time) prediction_offset))
	(05_outro_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\05_deltahalo\c05_outro\foley\c05_outro_04_fol)

	(sleep (camera_time))

	)

; C05_OUTRO SCENE 04 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c05_outro_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\05_deltahalo\c05_outro\foley\c05_outro_04_fol none 1)
	(print "c05_outro foley 04 start")
	)

; ---------------------------------------------------------------------

(script static void c05_outro_scene_04

	(wake c05_outro_foley_04)

	(object_create_anew outro_beam)
	(print "start beam")
	
	(camera_set_field_of_view 60 0)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_outro\05_outro "05_outro_04" none "anchor_flag_outro")
	
	(custom_animation_relative chief objects\characters\masterchief\05_outro\05_outro "chief_04" false anchor_outro)
	(scenery_animation_start_relative carrier scenarios\objects\covenant\military\capital_ship\05_outro\05_outro "cruiser_04" anchor_outro)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>	
	(sleep (- (camera_time) prediction_offset))
	(05_outro_05_predict_stub)
	
	(sleep (- (camera_time) 1))
	
	(fade_out 0 0 0 0)
	
	(sleep 60)
	
	(object_destroy outro_beam)
	
	)
	
; C05_OUTRO SCENE 05 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x07_0220_grv
	(sleep 207)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0220_grv none 1)
	(cinematic_subtitle x07_0220_grv 7)
	)

(script dormant x07_0230_grv
	(sleep 426)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0230_grv none 1)
	(cinematic_subtitle x07_0230_grv 6)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c05_outro_bubbles
	(object_create_anew bubbles_01)
	(objects_attach chief "" bubbles_01 "")
	
	(effect_new_on_object_marker effects\cinematics\05\bubbles_debris rubble "bubbles01")
	(effect_new_on_object_marker effects\cinematics\05\bubbles_debris rubble "bubbles04")
	(effect_new_on_object_marker effects\cinematics\05\bubbles_debris rubble "bubbles06")
	(effect_new_on_object_marker effects\cinematics\05\bubbles_debris rubble "bubbles08")
	(effect_new_on_object_marker effects\cinematics\05\bubbles_debris rubble "bubbles09")
	(effect_new_on_object_marker effects\cinematics\05\bubbles_debris rubble "bubbles11")
	(effect_new_on_object_marker effects\cinematics\05\bubbles_debris rubble "bubbles12")
	(effect_new_on_object_marker effects\cinematics\05\bubbles_debris rubble "bubbles14")

	)
	
(script dormant c05_outro_caustic
	(time_code_reset)
	(sleep 127)
	(print "create caustic light")
	(object_create_anew_containing caustic_light)
	)
	
(script dormant c05_outro_cinematic_light_05
	
	(cinematic_lighting_set_primary_light 54 138 0.129412 0.121569 0.0705882)
	(cinematic_lighting_set_secondary_light -46 238 0.0705882 0.160784 0.329412)
	(cinematic_lighting_set_ambient_light 0.0901961 0.129412 0.219608)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting rubble 1)
	(object_uses_cinematic_lighting tentacle_capture_01 1)
	(object_uses_cinematic_lighting tentacle_capture_02 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c05_outro_05_setup
	
	(object_create_anew rubble)
	(object_create_anew tentacle_capture_01)
	(object_create_anew tentacle_capture_02)
	
	(wake x07_0220_grv)
	(wake x07_0230_grv)
	
	(wake c05_outro_cinematic_light_05)
	(wake c05_outro_bubbles)
	(wake c05_outro_caustic)
	
	)
	
(script static void c05_outro_05_cleanup
	(object_destroy chief)
	(object_destroy rubble)
	(object_destroy carrier)
	(object_destroy_containing caustic_light)
	(object_destroy_containing tentacle)
	(object_destroy_containing bubbles)
	)

(script static void c05_outro_scene_05

	(c05_outro_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\05_outro\05_outro "05_outro_05" none "anchor_flag_outro")

	(custom_animation_relative chief objects\characters\masterchief\05_outro\05_outro "chief_05" false anchor_outro)

	(scenery_animation_start_relative rubble objects\cinematics\effects\05_outro_rubble\05_outro_rubble "05_outro_05"	anchor_outro)
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture\05_outro\05_outro "tentacle1_05" anchor_outro)		
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture\05_outro\05_outro "tentacle2_05" anchor_outro)		
	
	(fade_in 0 0 0 60)
	
	(sleep (- (camera_time) 30))
	
	(fade_out 0 0 0 60)
	(sleep 60)
	
	(c05_outro_05_cleanup)
	
	(cinematic_lightmap_shadow_disable)
	
	)

; c05_OUTRO MASTER SCRIPT =============================================
; =====================================================================

(script static void c05_outro
	
	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name bsp_03)
	(sleep 1)
	
	(c05_outro_scene_01)
	(c05_outro_scene_02)
	(c05_outro_scene_03)
	(c05_outro_scene_04)
	(c05_outro_scene_05)
	
	)