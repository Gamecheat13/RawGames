; CINEMATICS FOR 00A_INTRODUCTION, "THE HERETIC" =======================
; =====================================================================

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)

	(script stub void x01_01_predict_stub (print "predict 01"))
	(script stub void x01_01b_predict_stub (print "predict 01"))
	(script stub void x01_02_predict_stub (print "predict 02"))
	(script stub void x01_03_predict_stub (print "predict 03"))
	(script stub void x01_04_predict_stub (print "predict 04"))
	(script stub void x01_05_predict_stub (print "predict 05"))
	(script stub void x01_06_predict_stub (print "predict 06"))
	(script stub void x01_07_predict_stub (print "predict 07"))
	(script stub void x01_08_predict_stub (print "predict 08"))
	(script stub void x01_09_predict_stub (print "predict 09"))
	(script stub void x01_10_predict_stub (print "predict 10"))

	(script stub void 01_intro_01_predict_stub (print "predict 01"))
	(script stub void 01_intro_02_predict_stub (print "predict 02"))

; X01 SCENE 01A -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x01_score_01a
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\music\x01_01_mus none 1)
	(print "x01 score 01 start")
	)
	
(script dormant x01_foley_01a
	(sleep 60)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\foley\x01_01a_fol none 1)
	(print "x01 foley 01 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x01_supratitle_01
	(sleep 420)
	(cinematic_set_title cinematic_title0)
	)
	
(script dormant cinematic_lighting_scene_01a
	
	(cinematic_lighting_set_primary_light -23 152 0.576471 0.513726 0.4)
	(cinematic_lighting_set_secondary_light 38 222 0.141176 0.141176 0.290196)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .6) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting carrier_01 1)
	(object_uses_cinematic_lighting cruiser_01 1)
	(object_uses_cinematic_lighting cruiser_02 1)
	(object_uses_cinematic_lighting cruiser_03 1)
	(object_uses_cinematic_lighting cruiser_04 1)
	(object_uses_cinematic_lighting cruiser_05 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x01_01b_problem_actors

	(print "problem actors")

	(object_create_anew_containing banshee)
	
	(object_cinematic_lod banshee_01 true)
	(object_cinematic_lod banshee_02 true)
	(object_cinematic_lod banshee_03 true)
	(object_cinematic_lod banshee_04 true)
	(object_cinematic_lod banshee_05 true)
	(object_cinematic_lod banshee_06 true)
	(object_cinematic_lod banshee_07 true)
	(object_cinematic_lod banshee_08 true)
	(object_cinematic_lod banshee_09 true)
	(object_cinematic_lod banshee_10 true)
	
	)
	
; ---------------------------------------------------------------------

(script static void x01_01a_setup

	(object_create_anew x01_fleet)

	(object_create_anew carrier_01)
	(object_create_anew_containing cruiser)

	(object_create_anew matte_high_charity)
	(object_create_anew matte_threshold)
	(object_create_anew	matte_halo_01)
	(object_create_anew	matte_halo_02)
	(object_create_anew	matte_stardust_01)
	(object_create_anew	matte_stardust_02)
	
	(object_cinematic_lod carrier_01 true)
	(object_cinematic_lod cruiser_01 true)
	(object_cinematic_lod cruiser_02 true)
	(object_cinematic_lod cruiser_03 true)
	(object_cinematic_lod cruiser_04 true)
	(object_cinematic_lod cruiser_05 true)

	(wake x01_score_01a)
	(wake x01_foley_01a)

	(wake x01_supratitle_01)
	
	(wake cinematic_lighting_scene_01a)
	
	)
	
(script static void x01_scene_01a

	(sound_class_set_gain amb 0 0)
	
	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start_movie "introduction")
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x01_01_predict_stub)
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\foley\x01_01a_fol)
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\music\x01_01_mus)
	(sleep prediction_offset)
	
	(sleep 45)
	
	(x01_01a_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_01" none "anchor_flag_x01a")
	
	(fade_in 0 0 0 90)
	
	(scenery_animation_start_relative carrier_01 scenarios\objects\covenant\military\capital_ship\x01\x01 "01_capital_ship_01" anchor_x01a)
	
	(scenery_animation_start_relative cruiser_01 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "01_ship01" anchor_x01a)
	(scenery_animation_start_relative cruiser_02 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "01_ship02" anchor_x01a)
	(scenery_animation_start_relative cruiser_03 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "01_ship03" anchor_x01a)
	(scenery_animation_start_relative cruiser_04 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "01_ship04" anchor_x01a)
	(scenery_animation_start_relative cruiser_05 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "01_ship05" anchor_x01a)
	
	(scenery_animation_start_relative matte_high_charity objects\cinematics\matte_paintings\high_charity_exterior\x01\x01 "high_charity_01" anchor_x01a)
	(scenery_animation_start_relative matte_threshold objects\cinematics\matte_paintings\threshold_space\x01\x01 "threshold_space_01" anchor_x01a)
	(scenery_animation_start_relative matte_halo_01 objects\cinematics\matte_paintings\halo_destroyed_01\x01\x01 "halo_destroyed01_01" anchor_x01a)
	(scenery_animation_start_relative matte_halo_02 objects\cinematics\matte_paintings\halo_destroyed_02\x01\x01 "halo_destroyed02_01" anchor_x01a)
	(scenery_animation_start_relative matte_stardust_01 objects\cinematics\matte_paintings\high_charity_stardust\x01\x01 "stardust01_01" anchor_x01a)
	(scenery_animation_start_relative matte_stardust_02 objects\cinematics\matte_paintings\high_charity_stardust\x01\x01 "stardust02_01" anchor_x01a)
	
	(cinematic_screen_effect_start true)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_01b_predict_stub)
	(x01_01b_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\foley\x01_01b_fol)
	
	(sleep (- (camera_time) 1))
	
	(cinematic_screen_effect_set_crossfade 2)
	(sleep 1)
	
	)
	
; X01 SCENE 01B -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x01_foley_01b
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\foley\x01_01b_fol none 1)
	(print "x01 foley 01b start")
	)

(script dormant x01_0010_der
	(sleep 203)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0010_der none 1)
	(cinematic_subtitle x01_0010_der 1)
	)
	
(script dormant banshee_audio
	(sound_class_set_gain vehicle_engine 0 0)
	(sound_class_set_gain vehicle_engine 1 120)
	)
	
(script dormant banshee_hotness

	(object_set_function_variable banshee_01 "engine_audio" 1 1)
	(object_set_function_variable banshee_02 "engine_audio" 1 1)
	(object_set_function_variable banshee_03 "engine_audio" 1 1)
	(object_set_function_variable banshee_04 "engine_audio" 1 1)
	(object_set_function_variable banshee_05 "engine_audio" 1 1)
	(object_set_function_variable banshee_06 "engine_audio" 1 1)
	(object_set_function_variable banshee_07 "engine_audio" 1 1)
	(object_set_function_variable banshee_08 "engine_audio" 1 1)
	(object_set_function_variable banshee_09 "engine_audio" 1 1)
	(object_set_function_variable banshee_10 "engine_audio" 1 1)
	
	(sleep 30)
	
	(object_set_function_variable banshee_06 "wingtips" 1 1)
	(object_set_function_variable banshee_07 "wingtips" 1 1)
	(print "contrails start")
	
	(sleep 150)
	
	(object_clear_function_variable banshee_06 "wingtips")
	(object_clear_function_variable banshee_07 "wingtips")
	(print "contrails stop")
	
	)

; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant cinematic_lighting_scene_01b
	
	(cinematic_lighting_set_primary_light -59 308 0.466667 0.517647 0.643137)
	(cinematic_lighting_set_secondary_light -5 360 0.270588 0.313726 0.380392)
	(cinematic_lighting_set_ambient_light 0.00784314 0.00784314 0.00784314)
	
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting banshee_01 1)
	(object_uses_cinematic_lighting banshee_02 1)
	(object_uses_cinematic_lighting banshee_03 1)
	(object_uses_cinematic_lighting banshee_04 1)
	(object_uses_cinematic_lighting banshee_05 1)
	(object_uses_cinematic_lighting banshee_06 1)
	(object_uses_cinematic_lighting banshee_07 1)
	(object_uses_cinematic_lighting banshee_08 1)
	(object_uses_cinematic_lighting banshee_09 1)
	(object_uses_cinematic_lighting banshee_10 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void x01_01b_setup

	(object_destroy x01_fleet)

	(object_create_anew mercy)
	(object_create_anew regret)
	(object_create_anew throne_mercy)
	(object_create_anew throne_regret)
	(objects_attach mercy "" throne_mercy "driver_cinematic")
	(objects_attach regret "" throne_regret "driver_cinematic")

	(object_create_anew_containing matte)
	(object_destroy_containing carrier)
	(object_destroy x01_fleet)
	
	(wake x01_foley_01b)
	
	(wake x01_0010_der)
	(wake banshee_audio)
	
	(wake banshee_hotness)
	
	(wake cinematic_lighting_scene_01b)
	
	)

(script static void x01_scene_01b

	(sound_class_set_gain amb 1 1)

	(print "x01 scene 01b start")
	
	(x01_01b_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_01b" none "anchor_flag_x01b")

	(custom_animation_relative banshee_01 objects\vehicles\banshee\x01\x01 "banshee01_01b" false anchor_x01b)
	(custom_animation_relative banshee_02 objects\vehicles\banshee\x01\x01 "banshee02_01b" false anchor_x01b)
	(custom_animation_relative banshee_03 objects\vehicles\banshee\x01\x01 "banshee03_01b" false anchor_x01b)
	(custom_animation_relative banshee_04 objects\vehicles\banshee\x01\x01 "banshee04_01b" false anchor_x01b)
	(custom_animation_relative banshee_05 objects\vehicles\banshee\x01\x01 "banshee05_01b" false anchor_x01b)
	(custom_animation_relative banshee_06 objects\vehicles\banshee\x01\x01 "banshee06_01b" false anchor_x01b)
	(custom_animation_relative banshee_07 objects\vehicles\banshee\x01\x01 "banshee07_01b" false anchor_x01b)
	(custom_animation_relative banshee_08 objects\vehicles\banshee\x01\x01 "banshee08_01b" false anchor_x01b)
	(custom_animation_relative banshee_09 objects\vehicles\banshee\x01\x01 "banshee09_01b" false anchor_x01b)
	(custom_animation_relative banshee_10 objects\vehicles\banshee\x01\x01 "banshee10_01b" false anchor_x01b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\foley\x01_02_fol)
	
	(sleep (- (camera_time) 1))
	
	(cinematic_screen_effect_set_crossfade 1)
	(sleep 1)
	
	)
	
; X01 SCENE 02 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x01_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\foley\x01_02_fol none 1)
	(print "x01 foley 02 start")
	)

(script dormant x01_0020_pot
	(sleep 19)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0020_pot truth 1)
	(cinematic_subtitle x01_0020_pot 3)
	)

(script dormant x01_0030_der
	(sleep 100)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0030_der dervish 1)
	(cinematic_subtitle x01_0030_der 3)
	)

(script dormant x01_0040_pcc
	(sleep 170)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0040_pcc none 1)
	(cinematic_subtitle x01_0040_pcc 7)
	)
	
(script dormant x01_0050_pom
	(sleep 289)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0050_pom mercy 1)
	(cinematic_subtitle x01_0050_pom 2.5)
	)
	
(script dormant x01_0060_der
	(sleep 391)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0060_der dervish 1)
	(cinematic_subtitle x01_0060_der 2)
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x01_02_fov

	(sleep 196)
	(camera_set_field_of_view 80 0)
	(print "fov change: 60 -> 80 over 0 ticks")

	(sleep 90)
	(camera_set_field_of_view 47 0)
	(print "fov change: 80 -> 47 over 0 ticks")
	
	)

(script dormant cinematic_lighting_scene_02
	
	(cinematic_lighting_set_primary_light -90 116 0.4 0.4 0.4)
	(cinematic_lighting_set_secondary_light -26 148 0.3 0.25 0.3)
	(cinematic_lighting_set_ambient_light 0.00784314 0.00784314 0.00784314)

	(render_lights_enable_cinematic_shadow 1 dervish head .4)

	(rasterizer_bloom_override_threshold .25) 
	(rasterizer_bloom_override_brightness .7)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting mercy 1)
	(object_uses_cinematic_lighting regret 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting prophet_counc_01 1)
	(object_uses_cinematic_lighting prophet_counc_02 1)
	(object_uses_cinematic_lighting prophet_counc_03 1)
	(object_uses_cinematic_lighting prophet_counc_04 1)
	
	(object_uses_cinematic_lighting ehg_01 1)
	(object_uses_cinematic_lighting ehg_02 1)
	(object_uses_cinematic_lighting ehg_03 1)
	(object_uses_cinematic_lighting ehg_04 1)
	(object_uses_cinematic_lighting ehg_05 1)
	(object_uses_cinematic_lighting ehg_06 1)
	(object_uses_cinematic_lighting ehg_07 1)
	(object_uses_cinematic_lighting ehg_08 1)
	(object_uses_cinematic_lighting ehg_09 1)
	(object_uses_cinematic_lighting ehg_10 1)
	(object_uses_cinematic_lighting ehg_11 1)
	(object_uses_cinematic_lighting ehg_12 1)
	
	(object_uses_cinematic_lighting throne_mercy 1)
	(object_uses_cinematic_lighting throne_regret 1)
	(object_uses_cinematic_lighting hammer 1)
	
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void x01_03_problem_actors
	
	(print "problem actors")
	
	(object_create_anew poa_01)
	(object_create_anew_containing cruiser)
	(object_create_anew matte_reach)
	
	(object_cinematic_lod poa_01 true)
	(object_cinematic_lod cruiser_01 true)
	(object_cinematic_lod cruiser_02 true)
	(object_cinematic_lod cruiser_03 true)
	(object_cinematic_lod cruiser_04 true)
	(object_cinematic_lod cruiser_05 true)
	(object_cinematic_lod cruiser_06 true)
	(object_cinematic_lod cruiser_07 true)
	(object_cinematic_lod cruiser_08 true)
	(object_cinematic_lod cruiser_09 true)
	
	)

; ---------------------------------------------------------------------

(script dormant create_councillors_01
	(sleep 196)
	(print "create councillors")
		
	(object_create_anew_containing elc)
	(object_create_anew_containing pcc)

	(object_uses_cinematic_lighting elc_01 1)
	(object_uses_cinematic_lighting elc_02 1)
	(object_uses_cinematic_lighting elc_03 1)
	(object_uses_cinematic_lighting elc_04 1)
	(object_uses_cinematic_lighting elc_05 1)
	(object_uses_cinematic_lighting elc_06 1)
	(object_uses_cinematic_lighting elc_07 1)
	(object_uses_cinematic_lighting elc_08 1)
	(object_uses_cinematic_lighting elc_09 1)
	(object_uses_cinematic_lighting elc_10 1)
	(object_uses_cinematic_lighting elc_11 1)
	(object_uses_cinematic_lighting elc_12 1)
	(object_uses_cinematic_lighting elc_13 1)
	(object_uses_cinematic_lighting elc_14 1)
	(object_uses_cinematic_lighting elc_15 1)
	(object_uses_cinematic_lighting elc_16 1)
	(object_uses_cinematic_lighting elc_17 1)
	(object_uses_cinematic_lighting elc_18 1)
	(object_uses_cinematic_lighting elc_19 1)
	(object_uses_cinematic_lighting elc_20 1)
	(object_uses_cinematic_lighting elc_21 1)
	(object_uses_cinematic_lighting elc_22 1)
	(object_uses_cinematic_lighting elc_23 1)
	(object_uses_cinematic_lighting elc_24 1)
	(object_uses_cinematic_lighting elc_25 1)
	(object_uses_cinematic_lighting elc_26 1)
	(object_uses_cinematic_lighting elc_27 1)
	(object_uses_cinematic_lighting elc_28 1)
	(object_uses_cinematic_lighting elc_29 1)
	(object_uses_cinematic_lighting elc_30 1)
	
	(object_uses_cinematic_lighting pcc_01 1)
	(object_uses_cinematic_lighting pcc_02 1)
	(object_uses_cinematic_lighting pcc_03 1)
	(object_uses_cinematic_lighting pcc_04 1)
	(object_uses_cinematic_lighting pcc_05 1)
	(object_uses_cinematic_lighting pcc_06 1)
	(object_uses_cinematic_lighting pcc_07 1)
	(object_uses_cinematic_lighting pcc_08 1)
	(object_uses_cinematic_lighting pcc_09 1)
	(object_uses_cinematic_lighting pcc_10 1)
	(object_uses_cinematic_lighting pcc_11 1)
	(object_uses_cinematic_lighting pcc_12 1)
	(object_uses_cinematic_lighting pcc_13 1)
	(object_uses_cinematic_lighting pcc_14 1)
	(object_uses_cinematic_lighting pcc_15 1)
	(object_uses_cinematic_lighting pcc_16 1)
	(object_uses_cinematic_lighting pcc_17 1)
	(object_uses_cinematic_lighting pcc_18 1)
	(object_uses_cinematic_lighting pcc_19 1)
	(object_uses_cinematic_lighting pcc_20 1)
	(object_uses_cinematic_lighting pcc_21 1)
	(object_uses_cinematic_lighting pcc_22 1)
	(object_uses_cinematic_lighting pcc_23 1)
	(object_uses_cinematic_lighting pcc_24 1)
	(object_uses_cinematic_lighting pcc_25 1)
	(object_uses_cinematic_lighting pcc_26 1)
	(object_uses_cinematic_lighting pcc_27 1)
	(object_uses_cinematic_lighting pcc_28 1)
	(object_uses_cinematic_lighting pcc_29 1)
	(object_uses_cinematic_lighting pcc_30 1)
	(object_uses_cinematic_lighting pcc_31 1)
	(object_uses_cinematic_lighting pcc_32 1)

	)

(script static void x01_02_setup

	(object_create_anew dervish)
	(object_create_anew tartarus)
	
	(object_create_anew_containing ehg)
	
	(object_create_anew hammer)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod regret true)
	(object_cinematic_lod tartarus true)

	(object_cinematic_lod throne_mercy true)
	(object_cinematic_lod throne_regret true)
	(object_cinematic_lod hammer true)
	
	(object_set_function_variable tartarus "invincibility" 0 0)
	
	(wake x01_foley_02)
	
	(wake x01_0020_pot)
	(wake x01_0030_der)
	(wake x01_0040_pcc)
	(wake x01_0050_pom)
	(wake x01_0060_der)
	
	(wake create_councillors_01)
	
	(wake x01_02_fov)
	
	(wake cinematic_lighting_scene_02)
	
	)
	
(script static void x01_02_cleanup

	(object_destroy prophet_counc_03)
	(object_destroy prophet_counc_04)
	
	)

(script static void x01_scene_02

	(print "x01 scene 02 start")
	
	(x01_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_02" none "anchor_flag_x01b")
	
	(custom_animation_relative dervish objects\characters\dervish\x01\x01 "dervish_02" false anchor_x01b)
	(custom_animation_relative mercy objects\characters\prophet\x01\x01 "mercy_02" false anchor_x01b)
	(custom_animation_relative regret objects\characters\prophet\x01\x01 "regret_02" false anchor_x01b)
	(custom_animation_relative tartarus objects\characters\brute\x01\x01 "tartarus_02" false anchor_x01b)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x01\x01 "hammer_02" anchor_x01b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_03_predict_stub)
	(x01_03_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\foley\x01_03_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(x01_02_cleanup)
	
	)
	
; X01 SCENE 03 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x01_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\foley\x01_03_fol none 1)
	(print "x01 foley 03 start")
	)

(script dormant x01_0070_der
	(sleep 65)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0070_der none 1)
	(cinematic_subtitle x01_0070_der 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant cinematic_lighting_scene_03
	
	(cinematic_lighting_set_primary_light 69 232 0.290196 0.32549 0.243137)
	(cinematic_lighting_set_secondary_light -2 76 0.129412 0.141176 0.270588)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(rasterizer_bloom_override_threshold .6) 
	(rasterizer_bloom_override_brightness .5)

	(object_uses_cinematic_lighting poa_01 1)	
	(object_uses_cinematic_lighting cruiser_01 1)
	(object_uses_cinematic_lighting cruiser_02 1)
	(object_uses_cinematic_lighting cruiser_03 1)
	(object_uses_cinematic_lighting cruiser_04 1)
	(object_uses_cinematic_lighting cruiser_05 1)
	(object_uses_cinematic_lighting cruiser_06 1)
	(object_uses_cinematic_lighting cruiser_07 1)
	(object_uses_cinematic_lighting cruiser_08 1)
	(object_uses_cinematic_lighting cruiser_09 1)
	(object_uses_cinematic_lighting cruiser_10 1)
	(object_uses_cinematic_lighting cruiser_11 1)
	(object_uses_cinematic_lighting cruiser_12 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void x01_03_setup

	(object_create halo_whole)
	(object_create_anew matte_reach)
	(object_create_anew	matte_stardust_01)
	
	(wake x01_foley_03)
	
	(wake x01_0070_der)
	
	(wake cinematic_lighting_scene_03)
	
	)

(script static void x01_scene_03

	(sound_class_set_gain amb 0 1)
	
	(x01_03_setup)
	
	(camera_set_field_of_view 60 0)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_03" none "anchor_flag_x01a")
	
	(fade_in 1 1 1 15)
	
	(scenery_animation_start_relative poa_01 objects\cinematics\human\pillarofautumn\x01\x01 "poa_03" anchor_x01a)
	
	(scenery_animation_start_relative cruiser_01 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship01" anchor_x01a)
	(scenery_animation_start_relative cruiser_02 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship02" anchor_x01a)
	(scenery_animation_start_relative cruiser_03 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship03" anchor_x01a)
	(scenery_animation_start_relative cruiser_04 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship04" anchor_x01a)
	(scenery_animation_start_relative cruiser_05 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship05" anchor_x01a)
	(scenery_animation_start_relative cruiser_06 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship06" anchor_x01a)
	(scenery_animation_start_relative cruiser_07 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship07" anchor_x01a)
	(scenery_animation_start_relative cruiser_08 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship08" anchor_x01a)
	(scenery_animation_start_relative cruiser_09 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "03_ship09" anchor_x01a)
	
	(scenery_animation_start_relative matte_reach objects\cinematics\matte_paintings\reach_space\x01\x01 "reach_space_03" anchor_x01a)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_04_predict_stub)
	
	(sleep (- (camera_time) 1))
	
	(cinematic_screen_effect_set_crossfade 2)
	(sleep 1)
	
	)
	
; X01 SCENE 04 --------------------------------------------------------

(script dormant x01_0080_por
	(sleep 12)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0080_por none 1)
	(cinematic_subtitle x01_0080_por 5)
	)
	
(script dormant x01_0090_der
	(sleep 152)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0090_der none 1)
	(cinematic_subtitle x01_0090_der 1)
	)
	
(script dormant x01_0100_por
	(sleep 180)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0100_por none 1)
	(cinematic_subtitle x01_0100_por 2)
	)
	
(script dormant x01_0110_der
	(sleep 238)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0110_der none 1)
	(cinematic_subtitle x01_0110_der 1)
	)
	
(script dormant cinematic_lighting_scene_04
	
	(cinematic_lighting_set_primary_light -42 60 0.4 0.380392 0.270588)
	(cinematic_lighting_set_secondary_light 38 222 0.141176 0.141176 0.290196)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(object_uses_cinematic_lighting halo_whole 1)
	(object_uses_cinematic_lighting cruiser_10 1)
	(object_uses_cinematic_lighting cruiser_11 1)
	(object_uses_cinematic_lighting cruiser_12 1)
	
	)

(script static void x01_04_setup
	
	(wake x01_0080_por)
	(wake x01_0090_der)
	(wake x01_0100_por)
	(wake x01_0110_der)
	
	(wake cinematic_lighting_scene_04)
	
	)
	
(script dormant x01_04_cleanup
	
	(object_destroy poa_01)
	(object_destroy halo_whole)
	(object_destroy_containing cruiser)
	(object_destroy_containing matte)

	)

(script static void x01_scene_04
	
	(print "x01 scene 04 start")	
	
	(x01_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_04" none "anchor_flag_x01a")
	
	(scenery_animation_start_relative cruiser_01 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship01" anchor_x01a)
	(scenery_animation_start_relative cruiser_02 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship02" anchor_x01a)
	(scenery_animation_start_relative cruiser_03 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship03" anchor_x01a)
	(scenery_animation_start_relative cruiser_04 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship04" anchor_x01a)
	(scenery_animation_start_relative cruiser_05 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship05" anchor_x01a)
	(scenery_animation_start_relative cruiser_06 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship06" anchor_x01a)
	(scenery_animation_start_relative cruiser_07 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship07" anchor_x01a)
	(scenery_animation_start_relative cruiser_08 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship08" anchor_x01a)
	(scenery_animation_start_relative cruiser_09 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship09" anchor_x01a)
	(scenery_animation_start_relative cruiser_10 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship10" anchor_x01a)
	(scenery_animation_start_relative cruiser_11 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship11" anchor_x01a)
	(scenery_animation_start_relative cruiser_12 scenarios\objects\covenant\military\battle_cruiser\x01\x01 "04_ship12" anchor_x01a)
	
	(scenery_animation_start_relative matte_threshold objects\cinematics\matte_paintings\threshold_space\x01\x01 "threshold_space_04" anchor_x01a)
	(scenery_animation_start_relative halo_whole scenarios\objects\forerunner\industrial\halo\x01\x01 "halo_04" anchor_x01a)	
	(scenery_animation_start_relative matte_stardust_01 objects\cinematics\matte_paintings\high_charity_stardust\x01\x01 "stardust01_04" anchor_x01a)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_05_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\foley\x01_05_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(wake x01_04_cleanup)
	
	)

; X01 SCENE 05 --------------------------------------------------------

(script dormant x01_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\foley\x01_05_fol none 1)
	(print "x01 foley 05 start")
	)

(script dormant x01_0120_por
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0120_por regret 1)
	(cinematic_subtitle x01_0120_por 4)
	
	(unit_set_emotional_state regret arrogant .5 90)
	
	)
	
(script dormant x01_0130_por
	(sleep 141)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0130_por regret 1)
	(cinematic_subtitle x01_0130_por 3)
	
	(unit_set_emotional_state regret angry 1 30)
	
	)
	
(script dormant cinematic_lighting_scene_05
	
	(cinematic_lighting_set_primary_light -90 116 0.4 0.4 0.4)
	(cinematic_lighting_set_secondary_light -26 148 0.254902 0.203922 0.270588)
	(cinematic_lighting_set_ambient_light 0.00784314 0.00784314 0.00784314)
	
	(rasterizer_bloom_override_threshold .25) 
	(rasterizer_bloom_override_brightness .7)
	
	(object_uses_cinematic_lighting mercy 1)
	(object_uses_cinematic_lighting regret 1)
	
	)

(script static void x01_05_setup

	(wake x01_foley_05)
	
	(wake x01_0120_por)
	(wake x01_0130_por)
	
	(wake cinematic_lighting_scene_05)
	
	)
	
(script static void x01_scene_05

	(sound_class_set_gain amb 1 1)
	
	(x01_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_05" none "anchor_flag_x01b")
	
	(fade_in 1 1 1 15)
	
	(custom_animation_relative mercy objects\characters\prophet\x01\x01 "mercy_05" false anchor_x01b)
	(custom_animation_relative regret objects\characters\prophet\x01\x01 "regret_05" false anchor_x01b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_06_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\foley\x01_06_fol)

	(sleep (camera_time))

	)
	
; X01 SCENE 06 --------------------------------------------------------

(script dormant x01_foley_06
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\foley\x01_06_fol none 1)
	(print "x01 foley 06 start")
	)

(script dormant x01_0140_der
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0140_der dervish 1)
	(cinematic_subtitle x01_0140_der 4)
	)

(script dormant x01_0150_cch
	(sleep 112)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0150_cch none 1)
	(cinematic_subtitle x01_0150_cch 3)
	)
	
(script dormant x01_0160_pom
	(sleep 199)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0160_pom mercy 1)
	(cinematic_subtitle x01_0160_pom 2)
	)
	
(script dormant x01_0170_pot
	(sleep 330)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0170_pot truth 1)
	(cinematic_subtitle x01_0170_pot 6)
	)

(script dormant x01_0180_der
	(sleep 524)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0180_der none 1)
	(cinematic_subtitle x01_0180_der 8)
	)

(script dormant cinematic_lighting_scene_06
	
	(cinematic_lighting_set_primary_light -90 116 0.258824 0.258824 0.317647)
	(cinematic_lighting_set_secondary_light -26 148 0.254902 0.203922 0.270588)
	(cinematic_lighting_set_ambient_light 0.00784314 0.00784314 0.00784314)
	
	(rasterizer_bloom_override_threshold .25) 
	(rasterizer_bloom_override_brightness .7)
	(print "new bloom .25 .7")
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting truth 1)
	(object_uses_cinematic_lighting mercy 1)
	(object_uses_cinematic_lighting regret 1)
	
	)

(script static void x01_06_setup

	(object_create_anew truth)
	(object_create_anew throne_truth)
	
	(object_cinematic_lod truth true)
	(object_cinematic_lod throne_truth true)
	
	(objects_attach truth "" throne_truth "driver_cinematic")
	
	(wake x01_foley_06)
	
	(wake x01_0140_der)
	(wake x01_0150_cch)
	(wake x01_0160_pom)
	(wake x01_0170_pot)
	(wake x01_0180_der)
	
	(wake cinematic_lighting_scene_06)
	
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void x01_07_problem_actors

	(print "problem actors")

	(object_create_anew halo_exploding)
	(object_cinematic_lod halo_exploding true)
	
	)

; ---------------------------------------------------------------------

(script static void x01_scene_06
	
	(print "x01 scene 06 start")	
	
	(x01_06_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_06" none "anchor_flag_x01b")
	
	(custom_animation_relative dervish objects\characters\dervish\x01\x01 "dervish_06" false anchor_x01b)
	(custom_animation_relative truth objects\characters\prophet\x01\x01 "truth_06" false anchor_x01b)
	(custom_animation_relative mercy objects\characters\prophet\x01\x01 "mercy_06" false anchor_x01b)
	(custom_animation_relative regret objects\characters\prophet\x01\x01 "regret_06" false anchor_x01b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_07_predict_stub)
	(x01_07_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\foley\x01_07_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	)

; X01 SCENE 07 --------------------------------------------------------

(script dormant x01_foley_07
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\foley\x01_07_fol none 1)
	(print "x01 foley 07 start")
	)

(script dormant x01_0190_der
	(sleep 93)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0190_der none 1)
	(cinematic_subtitle x01_0190_der 1)
	)
	
; LIGHTING & EFFECTS --------------------------------------------------

(script dormant cinematic_lighting_scene_07
	
	(cinematic_lighting_set_primary_light 56 18 0.4 0.380392 0.270588)
	(cinematic_lighting_set_secondary_light -77 40 0.172549 0.172549 0.372549)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(rasterizer_bloom_override_threshold .6) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting halo_exploding 1)
	
	)
	
(script dormant halo_explosion
	(sleep 60)
	(print "effect - halo explosion")
	(effect_new_on_object_marker effects\cinematics\01\halo_destruction halo_exploding "explosion_poa_front")
	)	
	
; ---------------------------------------------------------------------

(script static void x01_07_setup

	(wake x01_foley_07)
	(wake x01_0190_der)
	
	(wake halo_explosion)
	(wake cinematic_lighting_scene_07)
	
	(effect_new_on_object_marker effects\cinematics\01_outro\alpha_halo_explosion halo_exploding "explosion_poa_front")
	
	)

(script static void x01_scene_07
	
	(sound_class_set_gain amb 0 1)
	
	(x01_07_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_07" none "anchor_flag_x01a")
	
	(fade_in 1 1 1 15)
	
	(scenery_animation_start_relative halo_exploding scenarios\objects\forerunner\industrial\halo_exploding\x01\x01 "halo_07" anchor_x01a)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_08_predict_stub)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_destroy halo_exploding)

	)
	
; X01 SCENE 08 --------------------------------------------------------

(script dormant x01_0200_pcc
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0200_pcc none 1)
	(cinematic_subtitle x01_0200_pcc 7)
	)

(script dormant x01_0210_tar
	(sleep 244)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0210_tar tartarus 1)
	(cinematic_subtitle x01_0210_tar 1)
	)

(script dormant x01_0220_por
	(sleep 279)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0220_por regret 1)
	(cinematic_subtitle x01_0220_por 7)
	
	(unit_set_emotional_state regret angry .5 60)
	
	)
	
(script dormant x01_0230_pot
	(sleep 470)
	
	(unit_set_emotional_state truth angry .25 60)
	
	(sleep 20)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0230_pot truth 1)
	(cinematic_subtitle x01_0230_pot 7)
	
	(unit_set_emotional_state regret shocked .5 30)
	(sleep 60)
	(unit_set_emotional_state regret arrogant .5 60)
	
	)
	
(script dormant x01_0240_pot
	(sleep 705)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0240_pot truth 1)
	(cinematic_subtitle x01_0240_pot 6)	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x01_08_fov

	(sleep 689)
	(camera_set_field_of_view 38 0)
	(print "fov change: 60 -> 38 over 0 ticks")
	
	(sleep 111)
	(camera_set_field_of_view 60 0)
	(print "fov change: 38 -> 60 over 0 ticks")
	
	)

(script dormant cinematic_lighting_scene_08
	
	(cinematic_lighting_set_primary_light -90 116 0.4 0.4 0.4)
	(cinematic_lighting_set_secondary_light -26 148 0.254902 0.203922 0.270588)
	(cinematic_lighting_set_ambient_light 0.00784314 0.00784314 0.00784314)
	
	(rasterizer_bloom_override_threshold .25) 
	(rasterizer_bloom_override_brightness .7)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting truth 1)
	(object_uses_cinematic_lighting mercy 1)
	(object_uses_cinematic_lighting regret 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting prophet_counc_01 1)
	(object_uses_cinematic_lighting prophet_counc_02 1)
	(object_uses_cinematic_lighting elite_counc_01 1)
	(object_uses_cinematic_lighting elite_counc_02 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void x01_08_setup
	
	(object_destroy elc_26)
	(object_destroy elc_27)
	
	(object_destroy pcc_33)
	(object_destroy pcc_34)
	
	(object_create_anew prophet_counc_01)
	(object_create_anew prophet_counc_02)
	(object_create_anew elite_counc_01)
	(object_create_anew elite_counc_02)
	
	(object_cinematic_lod prophet_counc_01 true)
	(object_cinematic_lod prophet_counc_02 true)
	(object_cinematic_lod elite_counc_01 true)
	(object_cinematic_lod elite_counc_02 true)
	
	(wake x01_0200_pcc)
	(wake x01_0210_tar)
	(wake x01_0220_por)
	(wake x01_0230_pot)
	(wake x01_0240_pot)
	
	(wake x01_08_fov)
	
	(wake cinematic_lighting_scene_08)
	
	)
	
(script static void x01_08_cleanup

	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	(object_destroy elite_counc_01)
	(object_destroy elite_counc_02)

	)

(script static void x01_scene_08

	(sound_class_set_gain amb 1 1)
	
	(print "x01 scene 08 start")
	
	(x01_08_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_08" none "anchor_flag_x01b")
	
	(fade_in 1 1 1 15)
	
	(custom_animation_relative dervish objects\characters\dervish\x01\x01 "dervish_08" false anchor_x01b)
	(custom_animation_relative truth objects\characters\prophet\x01\x01 "truth_08" false anchor_x01b)
	(custom_animation_relative mercy objects\characters\prophet\x01\x01 "mercy_08" false anchor_x01b)
	(custom_animation_relative regret objects\characters\prophet\x01\x01 "regret_08" false anchor_x01b)
	(custom_animation_relative tartarus objects\characters\brute\x01\x01 "tartarus_08" false anchor_x01b)
	
	(custom_animation_relative prophet_counc_01 objects\characters\prophet\x01\x01 "prophet01_08" false anchor_x01b)
	(custom_animation_relative prophet_counc_02 objects\characters\prophet\x01\x01 "prophet02_08" false anchor_x01b)
	(custom_animation_relative elite_counc_01 objects\characters\elite\x01\x01 "elite01_08" false anchor_x01b)
	(custom_animation_relative elite_counc_02 objects\characters\elite\x01\x01 "elite02_08" false anchor_x01b)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x01\x01 "hammer_08" anchor_x01b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_09_predict_stub)	

	(sleep (camera_time))

	(x01_08_cleanup)
	
	)
	
; X01 SCENE 09 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x01_0250_pc1
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0250_pc1 none 1)
	(cinematic_subtitle x01_0250_pc1 3)
	)

(script dormant x01_0260_pcc
	(sleep 60)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0260_pcc none 1)
	(cinematic_subtitle x01_0260_pcc 9)
	)

(script dormant x01_0270_der
	(sleep 252)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0270_der dervish 1)
	(cinematic_subtitle x01_0270_der 4)
	)
	
(script dormant x01_0280_pot
	(sleep 376)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0280_pot truth 1)
	(cinematic_subtitle x01_0280_pot 3)
	
	(sleep 30)
	(unit_set_emotional_state truth arrogant .5 60)
	
	)
	
(script dormant x01_0290_tar
	(sleep 494)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0290_tar tartarus 1)
	(cinematic_subtitle x01_0290_tar 1)
	)

; EFFECTS & LIGHITNG --------------------------------------------------
	
(script dormant x01_09_fov

	(sleep 441)
	(camera_set_field_of_view 38 0)
	(print "fov change: 60 -> 38 over 0 ticks")

	)
	
(script dormant cinematic_lighting_scene_09
	
	(cinematic_lighting_set_primary_light -90 116 0.258824 0.258824 0.317647)
	(cinematic_lighting_set_secondary_light -26 148 0.254902 0.203922 0.270588)
	(cinematic_lighting_set_ambient_light 0.00784314 0.00784314 0.00784314)
	
	(object_uses_cinematic_lighting hammer 1)
	(object_uses_cinematic_lighting elc_26 1)
	(object_uses_cinematic_lighting elc_27 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x01_10_problem_actors

	(print "problem actors")

	(object_create_anew brute_01)
	(object_create_anew brute_02)
	
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	
	)

; ---------------------------------------------------------------------

(script static void x01_09_setup

	(object_create_anew elc_26)
	(object_create_anew elc_27)
	
	(wake x01_0250_pc1)
	(wake x01_0260_pcc)
	(wake x01_0270_der)
	(wake x01_0280_pot)
	(wake x01_0290_tar)

	(wake x01_09_fov)
	
	(wake cinematic_lighting_scene_09)
	
	)
	
(script static void x01_09_cleanup

	(object_destroy prophet_counc_01)
	(object_destroy prophet_counc_02)

	)

(script static void x01_scene_09
	
;	(time_code_reset)
	(print "x01 scene 09 start")
	
	(x01_09_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_09" none "anchor_flag_x01b")
	
	(custom_animation_relative dervish objects\characters\dervish\x01\x01 "dervish_09" false anchor_x01b)
	(custom_animation_relative truth objects\characters\prophet\x01\x01 "truth_09" false anchor_x01b)
	(custom_animation_relative mercy objects\characters\prophet\x01\x01 "mercy_09" false anchor_x01b)
	(custom_animation_relative regret objects\characters\prophet\x01\x01 "regret_09" false anchor_x01b)
	(custom_animation_relative tartarus objects\characters\brute\x01\x01 "tartarus_09" false anchor_x01b)
	
	(custom_animation_relative prophet_counc_01 objects\characters\prophet\x01\x01 "prophet01_09" false anchor_x01b)
	(custom_animation_relative prophet_counc_02 objects\characters\prophet\x01\x01 "prophet02_09" false anchor_x01b)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x01\x01 "hammer_09" anchor_x01b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x01_10_predict_stub)
	(x01_10_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\x01\music\x01_c01_intro_trans_mus)

	(sleep (camera_time))
	
	(x01_09_cleanup)
	
	(cinematic_screen_effect_stop)
	
	)
	
; X01 SCENE 10 --------------------------------------------------------

(script dormant x01_score_10
	(sleep 79)
	(sound_impulse_start sound\cinematics\01_spacestation\x01\music\x01_c01_intro_trans_mus none 1)
	(print "x01 score 10 start")
	)

(script dormant x01_0300_pot
	(sleep 20)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0300_pot truth 1)
	(cinematic_subtitle x01_0300_pot 2)
	)

(script dormant x01_0310_cch
	(sleep 98)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0310_cch none 1)
	(cinematic_subtitle x01_0310_cch 3)
	)

(script dormant x01_0320_pot
	(sleep 180)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0320_pot none 1)
	(cinematic_subtitle x01_0320_pot 4)
	)
	
(script dormant x01_0330_pot
	(sleep 329)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\x01_0330_pot truth 1)
	(cinematic_subtitle x01_0330_pot 2)
	)
	
(script dormant cinematic_lighting_scene_10
	
   	(cinematic_lighting_set_primary_light 19 298 0.266667 0.266667 0.317647)
	(cinematic_lighting_set_secondary_light -53 106 0.168627 0.168627 0.223529)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting pcc_19 1)
	(object_uses_cinematic_lighting pcc_20 1)
	(object_uses_cinematic_lighting pcc_23 1)
	(object_uses_cinematic_lighting pcc_24 1)
	(object_uses_cinematic_lighting pcc_25 1)
	
	)

(script dormant improve_framerate
	(time_code_reset)
	(sleep 223)
	(print "improve framerate")
	(object_destroy_containing pcc)
	(object_destroy_containing elc)
	)

(script static void x01_10_setup
	
	(object_create_anew pcc_19)
	(object_create_anew pcc_20)
	(object_create_anew pcc_23)
	(object_create_anew pcc_24)
	(object_create_anew pcc_25)
	
	(wake x01_score_10)
	
	(wake improve_framerate)
	
	(wake x01_0300_pot)
	(wake x01_0310_cch)
	(wake x01_0320_pot)
	(wake x01_0330_pot)
	
	(wake cinematic_lighting_scene_10)
	
	)
	
(script static void x01_10_cleanup

	(object_destroy dervish)
	(object_destroy truth)
	(object_destroy mercy)
	(object_destroy regret)
	(object_destroy tartarus)
	
	(object_destroy_containing throne)
	(object_destroy_containing brute)
;	(object_destroy_containing elc)
;	(object_destroy_containing pcc)
	(object_destroy_containing ehg)
	
	(object_destroy hammer)
	
	)

(script static void x01_scene_10
	
	(x01_10_setup)
	
	(camera_set_field_of_view 60 0)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x01\x01 "x01_10" none "anchor_flag_x01b")
	
	(custom_animation_relative dervish objects\characters\dervish\x01\x01 "dervish_10" false anchor_x01b)
	(custom_animation_relative truth objects\characters\prophet\x01\x01 "truth_10" false anchor_x01b)
	(custom_animation_relative mercy objects\characters\prophet\x01\x01 "mercy_10" false anchor_x01b)
	(custom_animation_relative regret objects\characters\prophet\x01\x01 "regret_10" false anchor_x01b)
	(custom_animation_relative tartarus objects\characters\brute\x01\x01 "tartarus_10" false anchor_x01b)
	
	(custom_animation_relative brute_01 objects\characters\brute\x01\x01 "brute01_10" false anchor_x01b)
	(custom_animation_relative brute_02 objects\characters\brute\x01\x01 "brute02_10" false anchor_x01b)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x01\x01 "hammer_10" anchor_x01b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_intro_01_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_intro\foley\c01_intro_01_fol)
	(cinematic_screen_effect_start 1)
	
	(sleep (- (camera_time) 16))
	
	(cinematic_screen_effect_set_crossfade 1)
	(sleep 1)

	(x01_10_cleanup)
	
	)

; C01_INTRO SCENE 01---------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c01_intro_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_intro\foley\c01_intro_01_fol none 1)
	(print "c01 intro foley 01 start")
	)

(script dormant c01_1010_qtm
	(sleep 390)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_1010_qtm none 1)
	(cinematic_subtitle c01_1010_qtm 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c01_intro_supratitle_01
	(sleep 285)
	(cinematic_set_title cinematic_title1)
	)
	
(script dormant lens_flares
	(object_create_anew_containing yellow_01)
	(sleep 15)
	(object_create_anew_containing yellow_02)
	(sleep 15)
	(object_create_anew_containing red)
	)
	
(script dormant c01_intro_dof_01
	(time_code_reset)
	(sleep 404)
	
	(object_destroy athens)
	(object_destroy malta)
	(object_destroy poa_01)
		
	(print "rack focus")
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 1.5 1 1 0 0 0 0)
	)
	
(script dormant cinematic_lighting_c01_scene_01
	
	(cinematic_lighting_set_primary_light -11 360 0.415686 0.415686 0.501961)
	(cinematic_lighting_set_secondary_light 41 230 0 0 0)
	(cinematic_lighting_set_ambient_light 0.0588235 0.0470588 0.0431373)
	
	(rasterizer_bloom_override_threshold .6) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting cairo 1)
	(object_uses_cinematic_lighting malta 1)
	(object_uses_cinematic_lighting athens 1)
	
	(object_uses_cinematic_lighting poa_01 1)
	(object_uses_cinematic_lighting poa_02 1)
	(object_uses_cinematic_lighting poa_03 1)
	
	(object_uses_cinematic_lighting iac_01 1)
	(object_uses_cinematic_lighting iac_02 1)
	(object_uses_cinematic_lighting iac_03 1)
	(object_uses_cinematic_lighting iac_04 1)
	(object_uses_cinematic_lighting iac_05 1)
	
	(object_uses_cinematic_lighting fighter_01 1)
	(object_uses_cinematic_lighting fighter_02 1)
	(object_uses_cinematic_lighting fighter_03 1)
	(object_uses_cinematic_lighting fighter_04 1)
	(object_uses_cinematic_lighting fighter_05 1)
	(object_uses_cinematic_lighting fighter_06 1)
	(object_uses_cinematic_lighting fighter_08 1)
	
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void c01_02_problem_actors

	(print "problem actors")
	
	(object_create_anew master_guns)
	(object_create_anew armory)
	(object_create_anew cart)
	(object_create_anew optics)
	(object_create_anew power_supply)
	
	(object_cinematic_lod master_guns true)
	(object_cinematic_lod armory true)
	(object_cinematic_lod cart true)
	(object_cinematic_lod optics true)
	(object_cinematic_lod power_supply true)
	
	(object_hide master_guns true)
	(object_hide armory true)
	(object_hide cart true)
	(object_hide optics true)
	(object_hide power_supply true)
	
	)

; ---------------------------------------------------------------------

(script dormant ships_unhide
	(sleep 150)
	(print "ships unhide")
	(object_hide poa_01 false)
	(object_hide poa_02 false)
	(object_hide poa_03 false)
	)

(script static void c01_intro_scene_01_setup

	(object_create_anew cairo)
	(object_create_anew malta)
	(object_create_anew athens)
	
	(object_create_anew_containing iac)
	(object_create_anew_containing poa)
	(object_create_anew_containing fighter)
	
	(object_hide poa_01 true)
	(object_hide poa_02 true)
	(object_hide poa_03 true)
	
	(object_create_anew matte_earth)
	(object_create_anew matte_moon)
	
	(object_cinematic_lod cairo true)
	(object_cinematic_lod malta true)
	(object_cinematic_lod athens true)
;	(object_cinematic_lod iac_01 true)
	
	(wake c01_intro_foley_01)

	(wake c01_1010_qtm)
	
	(wake ships_unhide)
	
	(wake c01_intro_supratitle_01)	
	(wake lens_flares)	
;	(wake c01_intro_dof_01)
	
	(wake cinematic_lighting_c01_scene_01)
	
	)
	
(script static void c01_intro_scene_01_cleanup

	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	(object_destroy cairo)
	(object_destroy athens)
	(object_destroy malta)
	(object_destroy_containing iac)
	(object_destroy_containing poa)
	(object_destroy_containing fighter)
	(object_destroy_containing matte)
	
	)

(script static void c01_intro_scene_01

	(sound_class_set_gain amb 0 1)
	
	(c01_intro_scene_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_intro\01_intro "01_intro_01" none "anchor_flag_x01a")
	
	(scenery_animation_start_relative athens scenarios\objects\solo\spacestation\ss_prop\01_intro\01_intro "ss_prop01_01" anchor_x01a)
	(scenery_animation_start_relative cairo objects\cinematics\human\cairo\cairo "01_intro_01" anchor_x01a)
	(scenery_animation_start_relative malta scenarios\objects\solo\spacestation\ss_prop\01_intro\01_intro "ss_prop03_01" anchor_x01a)
	
	(scenery_animation_start_relative iac_01 objects\cinematics\human\inamberclad\01_intro\01_intro "iac_01" anchor_x01a)
	(scenery_animation_start_relative iac_02 objects\cinematics\human\inamberclad\01_intro\01_intro "iac_02" anchor_x01a)
	(scenery_animation_start_relative iac_03 objects\cinematics\human\inamberclad\01_intro\01_intro "iac_03" anchor_x01a)
	(scenery_animation_start_relative iac_04 objects\cinematics\human\inamberclad\01_intro\01_intro "iac_04" anchor_x01a)
	(scenery_animation_start_relative iac_05 objects\cinematics\human\inamberclad\01_intro\01_intro "iac_05" anchor_x01a)
	
	(scenery_animation_start_relative poa_01 objects\cinematics\human\pillarofautumn\01_intro\01_intro "poa_01" anchor_x01a)
	(scenery_animation_start_relative poa_02 objects\cinematics\human\pillarofautumn\01_intro\01_intro "poa_02" anchor_x01a)
	(scenery_animation_start_relative poa_03 objects\cinematics\human\pillarofautumn\01_intro\01_intro "poa_03" anchor_x01a)
	
	(scenery_animation_start_relative fighter_01 objects\vehicles\longsword\01_intro\01_intro "longsword_01" anchor_x01a)
	(scenery_animation_start_relative fighter_02 objects\vehicles\longsword\01_intro\01_intro "longsword_02" anchor_x01a)
	(scenery_animation_start_relative fighter_03 objects\vehicles\longsword\01_intro\01_intro "longsword_03" anchor_x01a)
	(scenery_animation_start_relative fighter_04 objects\vehicles\longsword\01_intro\01_intro "longsword_04" anchor_x01a)
	(scenery_animation_start_relative fighter_05 objects\vehicles\longsword\01_intro\01_intro "longsword_05" anchor_x01a)
	(scenery_animation_start_relative fighter_06 objects\vehicles\longsword\01_intro\01_intro "longsword_06" anchor_x01a)
	(scenery_animation_start_relative fighter_07 objects\vehicles\longsword\01_intro\01_intro "longsword_07" anchor_x01a)
	(scenery_animation_start_relative fighter_08 objects\vehicles\longsword\01_intro\01_intro "longsword_08" anchor_x01a)
	
	(scenery_animation_start_relative matte_earth objects\cinematics\matte_paintings\earth_space\01_intro\01_intro "earth_space_01" anchor_x01a)
	(scenery_animation_start_relative matte_moon objects\cinematics\matte_paintings\moon\01_intro\01_intro "moon_01" anchor_x01a)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(01_intro_02_predict_stub)
	(c01_02_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\01_spacestation\c01_intro\foley\c01_intro_02_fol)
	
	(sleep (camera_time))

	(c01_intro_scene_01_cleanup)
	
	)

; C01_INTRO SCENE 02---------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant c01_intro_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\01_spacestation\c01_intro\foley\c01_intro_02_fol none 1)
	(print "c01 intro foley 01 start")
	)	

(script dormant c01_1020_qtm
	(sleep 18)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_1020_qtm master_guns 1)
	(cinematic_subtitle c01_1020_qtm 2)
	
	(unit_set_emotional_state master_guns annoyed 1 0)
	(print "master guns - annoyed 1 0")

	)
	
(script dormant c01_1030_qtm
	(sleep 91)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_1030_qtm master_guns 1)
	(cinematic_subtitle c01_1030_qtm 2)
	)
	
(script dormant c01_1040_qtm
	(sleep 173)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_1040_qtm master_guns 1)
	(cinematic_subtitle c01_1040_qtm 2)
	
	(unit_set_emotional_state master_guns angry 1 15)
	(print "master guns - angry 1 15")
	
	)

(script dormant c01_1050_mas
	(sleep 396)
	(sound_impulse_start sound\dialog\levels\01_spacestation\cinematic\c01_1050_mas chief 1)
	(cinematic_subtitle c01_1050_mas 1)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant cinematic_lighting_c01_scene_02
	
	(cinematic_lighting_set_primary_light 12 184 0.117647 0.109804 0.0901961)
	(cinematic_lighting_set_secondary_light -48 106 0.113725 0.113725 0.0941177)
	(cinematic_lighting_set_ambient_light 0.0352941 0.0392157 0.0666667)
	
	(render_lights_enable_cinematic_shadow 1 chief head .25)

	(rasterizer_bloom_override_threshold .75) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting master_guns 1)
	(object_uses_cinematic_lighting armory 1)
	(object_uses_cinematic_lighting cart 1)
	(object_uses_cinematic_lighting optics 1)
	(object_uses_cinematic_lighting power_supply 1)
	(object_uses_cinematic_lighting helmet 1)
	
	)

; ---------------------------------------------------------------------

(script static void c01_intro_scene_02_setup

	(object_hide master_guns false)
	(object_hide armory false)
	(object_hide cart false)
	(object_hide optics false)
	(object_hide power_supply false)

	(object_create_anew chief)
	(object_create_anew helmet)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod helmet true)
	
	(wake c01_intro_foley_02)
	
	(wake c01_1020_qtm)
	(wake c01_1030_qtm)
	(wake c01_1040_qtm)
	(wake c01_1050_mas)
	
	(wake cinematic_lighting_c01_scene_02)
	
	)
	
(script static void c01_intro_scene_02_cleanup

	(object_destroy chief)
	(object_destroy master_guns)
	(object_destroy armory)
	(object_destroy cart)
	(object_destroy optics)
	(object_destroy power_supply)
	(object_destroy helmet)
	
	)

(script static void c01_intro_scene_02
	(disable_render_light_suppressor)
	(sound_class_set_gain amb 1 1)
	
	(c01_intro_scene_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\01_intro\01_intro "01_intro_02" none "anchor_flag_x01a")
	
	(custom_animation_relative chief objects\characters\masterchief\01_intro\01_intro "chief_02" false anchor_x01a)
	(custom_animation_relative master_guns objects\characters\marine\01_intro\01_intro "quartermaster_02" false anchor_x01a)

	(scenery_animation_start_relative armory objects\cinematics\human\cairo_armory\01_intro\01_intro "cairo_armory_02" anchor_x01a)
	(scenery_animation_start_relative cart objects\cinematics\human\equipment_cart\01_intro\01_intro "equipment_cart_02" anchor_x01a)
	(scenery_animation_start_relative optics objects\cinematics\human\optics\01_intro\01_intro "optics_02" anchor_x01a)
	(scenery_animation_start_relative power_supply objects\cinematics\human\power_core\01_intro\01_intro "power_supply_02" anchor_x01a)
	(scenery_animation_start_relative helmet objects\characters\masterchief\helmet\01_intro\01_intro "helmet_02" anchor_x01a)
	
	(sleep (- (camera_time) 15))
	
;	(fade_out 1 1 1 15)
;	(sleep 15)

	(sound_class_set_gain amb 0 15)
;	(sleep 15)

;	(c01_intro_scene_02_cleanup)
	
	(enable_render_light_suppressor)
        (loading_screen_fade_to_white)
	)

; X01 MASTER SCRIPT ---------------------------------------------------

(script static void intro

	(texture_cache_flush)
	(geometry_cache_flush)

	(sound_class_set_gain device_door 0 0)

	(cinematic_outro_start)
	
	(x01_scene_01a)
	(x01_scene_01b)
	(x01_scene_02)
	(x01_scene_03)
	(x01_scene_04)
	(x01_scene_05)
	(x01_scene_06)
	(x01_scene_07)
	(x01_scene_08)
	(x01_scene_09)
	(x01_scene_10)
	
	(c01_intro_scene_01)
	(c01_intro_scene_02)
	
	(rasterizer_bloom_override 0)
)

(script startup

	(fade_out 0 0 0 0)
	
	(switch_bsp_by_name high_0)
	
	(if (cinematic_skip_start)
		(begin
			(intro)
		)
	)
	(cinematic_skip_stop)
	
	(game_won)
	
	)
	