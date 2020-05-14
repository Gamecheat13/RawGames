; CINEMATICS FOR LEVEL 04A, "GAS-GIANT" ===============================
; =====================================================================

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 75)

	(script stub void x04_01_predict_stub (print "predict 01"))
	(script stub void x04_02a_predict_stub (print "predict 02a"))
	(script stub void x04_02b_predict_stub (print "predict 02b"))
	(script stub void x04_03b_predict_stub (print "predict 03b"))
	(script stub void x04_04_predict_stub (print "predict 04"))
	(script stub void x04_05_predict_stub (print "predict 05"))
	(script stub void x04_06_predict_stub (print "predict 06"))
	(script stub void x04_07_predict_stub (print "predict 07"))
	(script stub void x04_08_predict_stub (print "predict 08"))
	(script stub void x04_09_predict_stub (print "predict 09"))
	(script stub void x04_10_predict_stub (print "predict 10"))
	
	(script stub void 04_intro_01_predict_stub (print "predict 01"))
	(script stub void 04_intro_02a_predict_stub (print "predict 02a"))
	(script stub void 04_intro_02b_predict_stub (print "predict 02b"))
	(script stub void 04_intro_02c_predict_stub (print "predict 02c"))
	(script stub void 04_intro_02d_predict_stub (print "predict 02d"))
	(script stub void 04_intro_03_predict_stub (print "predict 03"))
	(script stub void 04_intro_05_predict_stub (print "predict 05"))
	(script stub void 04_intro_06b_predict_stub (print "predict 06b"))

; X04 SCENE 01 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\music\01_mus none 1)
	(print "x04 score 01 start")
	)
	
(script dormant x04_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_01_fol none 1)
	(print "x04 foley 01 start")
	)

(script dormant x04_0010_bgr
	(sleep 483)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0010_bgr brute_01 1)
	(cinematic_subtitle x04_0010_bgr 5)
	)
	
(script dormant x04_0020_bgl
	(sleep 633)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0020_bgl brute_01 1)
	(cinematic_subtitle x04_0020_bgl 2)
	) 
	
(script dormant x04_0040_jcr
	(sleep 693)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0040_jcr jackal_01 1)
	(cinematic_subtitle x04_0040_jcr 4)
	) 
	
(script dormant x04_0030_bgl
	(sleep 816)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0030_bgl brute_01 1)
	(cinematic_subtitle x04_0030_bgl 1.5)
	) 
	
(script dormant x04_0050_bgr
	(sleep 863)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0050_bgr brute_02 1)
	(cinematic_subtitle x04_0050_bgr 7.5)
	) 

; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant x04_cinematic_lighting_scene_01
	
	(cinematic_lighting_set_primary_light 46 276 0.11 0.10 0.14)
	(cinematic_lighting_set_secondary_light 73 0 0.11 0.11 0.13)
	(cinematic_lighting_set_ambient_light 0.04 0.04 0.04)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3)
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting jackal_01 1)
	(object_uses_cinematic_lighting jackal_02 1)
	(object_uses_cinematic_lighting jackal_03 1)
	(object_uses_cinematic_lighting hammer 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void x04_01_setup

	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew jackal_01)
	(object_create_anew jackal_02)
	(object_create_anew jackal_03)
	(object_create_anew hammer)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod jackal_01 true)
	(object_cinematic_lod jackal_02 true)
	(object_cinematic_lod jackal_03 true)
	(object_cinematic_lod hammer true)
	
	(wake x04_0010_bgr)
	(wake x04_0020_bgl)
	(wake x04_0040_jcr)
	(wake x04_0030_bgl)
	(wake x04_0050_bgr)
	
	(wake x04_score_01)
	(wake x04_foley_01)
	
	(wake x04_cinematic_lighting_scene_01)
	
	)

(script static void x04_scene_01

	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start_movie "gasgiant_1")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x04_01_predict_stub)
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\music\01_mus)
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_01_fol)
	(sleep prediction_offset)
	
	(x04_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_01" none "anchor_flag_x04a")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_01" false anchor_x04a)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_01" false anchor_x04a)

	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_01" false anchor_x04a)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_01" false anchor_x04a)
	
	(custom_animation_relative jackal_01 objects\characters\jackal\x04\x04 "jackal01_01" false anchor_x04a)
	(custom_animation_relative jackal_02 objects\characters\jackal\x04\x04 "jackal02_01" false anchor_x04a)
	(custom_animation_relative jackal_03 objects\characters\jackal\x04\x04 "jackal03_01" false anchor_x04a)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x04\x04 "hammer_01" anchor_x04a)
	
	(interpolator_start blurry_vision 1 .001)
	
	(sleep 30)
	(fade_in 0 0 0 30)
	(sleep 45)
	(fade_out 0 0 0 30)
	(sleep 45)
	(fade_in 0 0 0 20)
	
	(interpolator_start blurry_vision 0 2)
	
	(sleep 30)
	(fade_out 0 0 0 20)
	
	(sleep 20)
	(interpolator_start blurry_vision 1 .001)
	(sleep 25)
	
	(fade_in 0 0 0 10)
	(interpolator_start blurry_vision 0 2)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_02a_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_02a_fol)
	
	(sleep (camera_time))
	
	)

; X04 SCENE 02a -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_foley_02a
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_02a_fol none 1)
	(print "x04 foley 02a start")
	)

(script dormant x04_0060_tar
	(sleep 173)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0060_tar tartarus 1)
	(cinematic_subtitle x04_0060_tar 4)
	) 
	
(script dormant x04_0070_tar
	(sleep 300)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0070_tar tartarus 1)
	(cinematic_subtitle x04_0070_tar 2)
	)
	
(script dormant x04_0080_tar
	(sleep 370)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0080_tar tartarus 1)
	(cinematic_subtitle x04_0080_tar 3.5)
	
	(sleep 15)
	(unit_set_emotional_state tartarus inquisitive .75 90)
	
	) 

; ---------------------------------------------------------------------

(script dormant x04_button_delete
	(sleep 361)
	(print "button_delete")
	(object_destroy x04_button)
	)
	
(script dormant x04_door_open
	(sleep 455)
	(print "door open")
	(device_set_position x04_door_01 1)
	)

(script static void x04_02a_setup

	(object_create_anew x04_button)

	(wake x04_foley_02a)
	
	(wake x04_0060_tar)
	(wake x04_0070_tar)
	(wake x04_0080_tar)
	
	(wake x04_door_open)
	(wake x04_button_delete)
	
	)

(script static void x04_scene_02a

	(x04_02a_setup)
	
	(camera_set_field_of_view 70 0)
	(print "fov change: 60 -> 70 over 0 ticks")
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_02a" none "anchor_flag_x04a")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_02a" false anchor_x04a)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_02a" false anchor_x04a)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_02a" false anchor_x04a)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_02a" false anchor_x04a)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x04\x04 "hammer_02a" anchor_x04a)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_02b_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_02b_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(object_destroy x04_door_01)
	
	)
	
; X04 SCENE 02b -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_foley_2b
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_02b_fol none 1)
	(print "x04 foley 02b start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x04_02b_fov
	(sleep 140)
	(camera_set_field_of_view 80 0)
	(print "fov change: 70 -> 80 over 0 ticks")
	)

(script dormant x04_cinematic_lighting_02b
	
	(cinematic_lighting_set_primary_light 68 336 0.25 0.24 0.36)
	(cinematic_lighting_set_secondary_light 0 24 0.18 0.13 0.20)
	(cinematic_lighting_set_ambient_light 0.03 0.03 0.03)

	)

; ---------------------------------------------------------------------

(script static void x04_02b_setup

	(object_create_anew jail_ledge)
	(object_uses_cinematic_lighting jail_ledge 1)

	(wake x04_foley_2b)
	(wake x04_02b_fov)

	(wake x04_cinematic_lighting_02b)

	)

(script static void x04_02b_cleanup

	(object_destroy jail_ledge)
	(object_destroy_containing jackal)

	)

(script static void x04_scene_02b

	(cinematic_lightmap_shadow_disable)

	(x04_02b_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_02b" none "anchor_flag_x04a")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_02b" false anchor_x04a)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_02b" false anchor_x04a)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_02b" false anchor_x04a)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_02b" false anchor_x04a)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x04\x04 "hammer_02b" anchor_x04a)
	(scenery_animation_start_relative jail_ledge scenarios\objects\solo\highcharity\high_jail_ledge\x04\x04 "ledge_02b" anchor_x04a)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_03b_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_03b_fol)
	
	(sleep (camera_time))
	
	)

; X04 SCENE 03b -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_foley_03b
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_03b_fol none 1)
	(print "x04 foley 03b start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x04_03b_dof_1

	(sleep 91)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
	(print "rack focus")
	
	(sleep 138)
	
	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	)
	
(script dormant x04_cinematic_lighting_03b
	
	(cinematic_lighting_set_primary_light 65 0 0.24 0.24 0.31)
	(cinematic_lighting_set_secondary_light 0 26 0.21 0.18 0.15)
	(cinematic_lighting_set_ambient_light 0.05 0.05 0.05)
	
;	(object_uses_cinematic_lighting honor_guard_01 1)
	(object_uses_cinematic_lighting honor_guard_02 1)
;	(object_uses_cinematic_lighting honor_guard_03 1)
	(object_uses_cinematic_lighting honor_guard_04 1)
	(object_uses_cinematic_lighting honor_guard_05 1)
	(object_uses_cinematic_lighting honor_guard_06 1)
;	(object_uses_cinematic_lighting honor_guard_07 1)
;	(object_uses_cinematic_lighting honor_guard_08 1)
;	(object_uses_cinematic_lighting honor_guard_09 1)
;	(object_uses_cinematic_lighting honor_guard_10 1)
;	(object_uses_cinematic_lighting honor_guard_11 1)
;	(object_uses_cinematic_lighting honor_guard_12 1)
;	(object_uses_cinematic_lighting honor_guard_13 1)
	(object_uses_cinematic_lighting honor_guard_14 1)
	(object_uses_cinematic_lighting honor_guard_15 1)
	(object_uses_cinematic_lighting honor_guard_16 1)
	(object_uses_cinematic_lighting honor_guard_17 1)
	(object_uses_cinematic_lighting honor_guard_18 1)
	(object_uses_cinematic_lighting honor_guard_19 1)
	(object_uses_cinematic_lighting honor_guard_20 1)
;	(object_uses_cinematic_lighting honor_guard_21 1)
;	(object_uses_cinematic_lighting honor_guard_22 1)
;	(object_uses_cinematic_lighting honor_guard_23 1)
;	(object_uses_cinematic_lighting honor_guard_24 1)
;	(object_uses_cinematic_lighting honor_guard_25 1)
;	(object_uses_cinematic_lighting honor_guard_26 1)
;	(object_uses_cinematic_lighting honor_guard_27 1)
	(object_uses_cinematic_lighting honor_guard_28 1)
	(object_uses_cinematic_lighting honor_guard_29 1)
	(object_uses_cinematic_lighting honor_guard_30 1)

	)
	
; ---------------------------------------------------------------------

(script static void x04_03b_setup

	(object_create_anew_containing honor_guard)
	
	(wake x04_foley_03b)
	
;	(wake x04_03b_dof_1)
	(wake x04_cinematic_lighting_03b)

	)

(script static void x04_scene_03b
	
	(x04_03b_setup)
	
	(camera_set_field_of_view 60 0)
	(print "fov change: 80 -> 60 over 0 ticks")
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_03b" none "anchor_flag_x04a")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_03b" false anchor_x04a)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_03b" false anchor_x04a)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_03b" false anchor_x04a)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_03b" false anchor_x04a)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x04\x04 "hammer_03b" anchor_x04a)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_04_fol)
	
	(sleep (- (camera_time) 30))
	(cinematic_screen_effect_start true)
	
	(sleep (- (camera_time) 5))	
	
	(cinematic_screen_effect_set_crossfade 2)
	(print "crossfade")
	
	(sleep 5)
	
	(object_destroy_containing honor_guard)

	)

; X04 SCENE 04 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_04_fol none 1)
	(print "x04 foley 04 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant x04_cinematic_lighting_scene_04
	
	(cinematic_lighting_set_primary_light 65 0 0.34 0.34 0.41)
	(cinematic_lighting_set_secondary_light 0 26 0.21 0.18 0.15)
	(cinematic_lighting_set_ambient_light 0.05 0.05 0.05)
	
	(object_uses_cinematic_lighting truth 1)
	(object_uses_cinematic_lighting mercy 1)
	(object_uses_cinematic_lighting throne_truth 1)
	(object_uses_cinematic_lighting throne_mercy 1)
	(object_uses_cinematic_lighting sarcophagus 1)
	
	)

; ---------------------------------------------------------------------

(script static void x04_04_setup

	(object_create_anew truth)
	(object_create_anew mercy)
	(object_create_anew_containing throne)
	(object_create_anew sarcophagus)

	(object_cinematic_lod truth true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_mercy true)

	(objects_attach truth "driver" throne_truth "driver_cinematic")
	(objects_attach mercy "driver" throne_mercy "driver_cinematic")
	
	(wake x04_foley_04)
	
	(wake x04_cinematic_lighting_scene_04)
	
	)

(script static void x04_scene_04
	
	(x04_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_04" none "anchor_flag_x04b")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_04" false anchor_x04b)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_04" false anchor_x04b)
	(custom_animation_relative truth objects\characters\prophet\x04\x04 "truth_04" false anchor_x04b)
	(custom_animation_relative mercy objects\characters\prophet\x04\x04 "mercy_04" false anchor_x04b)
	
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_04" false anchor_x04b)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_04" false anchor_x04b)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x04\x04 "hammer_04" anchor_x04b)
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_04" anchor_x04b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_05_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_05_fol)
	
	(sleep (camera_time))
	
	)
	
; X04 SCENE 05 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_05_fol none 1)
	(print "x04 foley 05 start")
	)

(script dormant x04_0090_tar
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0090_tar tartarus 1)
	(cinematic_subtitle x04_0090_tar 5.5)
	)

(script dormant x04_0100_pot
	(sleep 157)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0100_pot truth 1)
	(cinematic_subtitle x04_0100_pot 2)
	)
	
(script dormant x04_0110_tar
	(sleep 205)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0110_tar tartarus 1)
	(cinematic_subtitle x04_0110_tar 2)
	)
	
(script dormant x04_0120_pot
	(sleep 242)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0120_pot truth 1)
	(cinematic_subtitle x04_0120_pot 2)
	)
	
(script dormant x04_0130_tar
	(sleep 385)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0130_tar tartarus 1)
	(cinematic_subtitle x04_0130_tar 1.5)
	)
	
(script dormant x04_0140_pot
	(sleep 554)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0140_pot truth 1)
	(cinematic_subtitle x04_0140_pot 5)
	)

(script dormant x04_0150_pot
	(sleep 731)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0150_pot truth 1)
	(cinematic_subtitle x04_0150_pot 4)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x04_05_dof_1
	(sleep 708)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 2 0 0 .001 .5 .5 .001)
	(print "rack focus")
	)
	
(script dormant x04_cinematic_lighting_scene_05
	
	(cinematic_lighting_set_primary_light -41 270 0.25 0.32 0.52)
	(cinematic_lighting_set_secondary_light 58 78 0.21 0.11 0.22)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)
	
	(rasterizer_bloom_override_threshold .25) 
	(rasterizer_bloom_override_brightness .8)
	(print "new bloom .25 .8")
	
	(render_lights_enable_cinematic_shadow 1 dervish head .2)
	(render_lights_enable_cinematic_shadow 1 truth head .2)
	(render_lights_enable_cinematic_shadow 1 mercy head .2)
	(render_lights_enable_cinematic_shadow 1 tartarus head .2)

	)
	
; ---------------------------------------------------------------------

(script static void x04_05_setup
	
	(wake x04_foley_05)
	
	(wake x04_0090_tar)
	(wake x04_0100_pot)
	(wake x04_0110_tar)
	(wake x04_0120_pot)
	(wake x04_0130_tar)
	(wake x04_0140_pot)
	(wake x04_0150_pot)
	
;	(wake x04_05_dof_1)
	
	(wake x04_cinematic_lighting_scene_05)

	)
	
(script static void x04_05_cleanup
	
	(object_destroy tartarus)
	(object_destroy brute_01)
	(object_destroy brute_02)
	(object_destroy hammer)
	
	)

(script static void x04_scene_05
	
	(x04_05_setup)
	
	(cinematic_set_near_clip_distance .05)
	(print "setting near distance to .05")	
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_05" none "anchor_flag_x04b")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_05" false anchor_x04b)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_05" false anchor_x04b)
	(custom_animation_relative truth objects\characters\prophet\x04\x04 "truth_05" false anchor_x04b)
	
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_05" false anchor_x04b)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_05" false anchor_x04b)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\x04\x04 "hammer_05" anchor_x04b)
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_05" anchor_x04b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_06_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\music\06_mus)
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_06_fol)
	
	(sleep (camera_time))
	
	(x04_05_cleanup)

	)
	
; X04 SCENE 06 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_score_06
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\music\06_mus none 1)
	(print "x04 score 06 start")
	)
	
(script dormant x04_foley_06
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_06_fol none 1)
	(print "x04 foley 06 start")
	)

(script dormant x04_0160_der
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0160_der dervish 1)
	(cinematic_subtitle x04_0160_der 2)
	)
	
(script dormant x04_0170_pot
	(sleep 46)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0170_pot truth 1)
	(cinematic_subtitle x04_0170_pot 1.25)
	)
	
(script dormant x04_0180_pot
	(sleep 104)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0180_pot truth 1)
	(cinematic_subtitle x04_0180_pot 2)
	)
	
(script dormant x04_0190_der
	(sleep 152)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0190_der dervish 1)
	(cinematic_subtitle x04_0190_der 3)
	)
	
(script dormant x04_0200_pot
	(sleep 237)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0200_pot truth 1)
	(cinematic_subtitle x04_0200_pot 1.25)
	)
	
(script dormant x04_0210_pot
	(sleep 301)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0210_pot truth 1)
	(cinematic_subtitle x04_0210_pot 11)
	)
	
(script dormant x04_0220_pom
	(sleep 624)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0220_pom mercy 1)
	(cinematic_subtitle x04_0220_pom 8.25)
	)
	
(script dormant x04_0230_der
	(sleep 851)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0230_der dervish 1)
	(cinematic_subtitle x04_0230_der 3.5)
	)
	
(script dormant x04_0240_pot
	(sleep 955)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0240_pot truth 1)
	(cinematic_subtitle x04_0240_pot 10)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant x04_06_dof_1

	(sleep 0)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	(sleep 280)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 2 0 0 0 .5 .5 0)
	(print "rack focus")

	(sleep 118)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 2 .5 .5 1 0 0 1)
	(print "rack focus")
	
	(sleep 87)
	(cinematic_screen_effect_set_depth_of_field 2 0 0 .001 0 0 .001)
	(print "rack focus")
	
	(sleep 230)
	(cinematic_screen_effect_set_depth_of_field 2 0 0 .001 .5 .5 .001)
	(print "rack focus")
	
	(sleep 179)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)
	
; ---------------------------------------------------------------------

(script static void x04_06_setup

	(object_destroy_containing brute)
	
	(wake x04_score_06)
	(wake x04_foley_06)
	
	(wake x04_0160_der)
	(wake x04_0170_pot)
	(wake x04_0180_pot)
	(wake x04_0190_der)
	(wake x04_0200_pot)
	(wake x04_0210_pot)
	(wake x04_0220_pom)
	(wake x04_0230_der)
	(wake x04_0240_pot)

;	(wake x04_06_dof_1)

	)

(script static void x04_scene_06
	
	(x04_06_setup)
	
	(cinematic_set_near_clip_distance .06)
	(print "resetting near distance to .06")
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_06" none "anchor_flag_x04b")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_06" false anchor_x04b)
	(custom_animation_relative truth objects\characters\prophet\x04\x04 "truth_06" false anchor_x04b)
	(custom_animation_relative mercy objects\characters\prophet\x04\x04 "mercy_06" false anchor_x04b)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_06" anchor_x04b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_07_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_07_fol)
	
	(sleep (camera_time))
	
	)

; X04 SCENE 07 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_foley_07
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_07_fol none 1)
	(print "x04 foley 07 start")
	)

(script dormant x04_0250_pot
	(sleep 172)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0250_pot truth 1)
	(cinematic_subtitle x04_0250_pot 8)
	)
	
(script dormant x04_0260_hld
	(sleep 400)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0260_her heretic_leader_holo_01 1)
	(cinematic_subtitle x04_0260_her 10.5)
	)

(script dormant x04_0270_pot
	(sleep 719)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0270_pot truth 1)
	(cinematic_subtitle x04_0270_pot 5)
	)

(script dormant x04_0280_pom
	(sleep 872)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0280_pom mercy 1)
	(cinematic_subtitle x04_0280_pom 3.5)
	)

; ---------------------------------------------------------------------

(script static void x04_07_setup

	(object_create_anew heretic_leader_holo_01)
	(object_cinematic_lod heretic_leader_holo_01 true)
	
	(wake x04_foley_07)
	
	(wake x04_0250_pot)
	(wake x04_0260_hld)
	(wake x04_0270_pot)
	(wake x04_0280_pom)

	)
	
(script static void x04_scene_07
	
	(x04_07_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_07" none "anchor_flag_x04b")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_07" false anchor_x04b)
	(custom_animation_relative truth objects\characters\prophet\x04\x04 "truth_07" false anchor_x04b)
	(custom_animation_relative mercy objects\characters\prophet\x04\x04 "mercy_07" false anchor_x04b)
	(custom_animation_relative heretic_leader_holo_01 objects\characters\heretic\x04\x04 "heretic_07" false anchor_x04b)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_07" anchor_x04b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_08_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\music\08_mus)
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_08_fol)
	
	(sleep (camera_time))
	
	(object_destroy heretic_leader_holo_01)
	
	)

; X04 SCENE 08 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_score_08
	(sleep 419)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\music\08_mus none 1)
	(print "x04 score 08 start")
	)

(script dormant x04_foley_08
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_08_fol none 1)
	(print "x04 foley 08 start")
	)

(script dormant x04_0290_der
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0290_der dervish 1)
	(cinematic_subtitle x04_0290_der 5)
	)
	
(script dormant x04_0300_pot
	(sleep 157)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0300_pot truth 1)
	(cinematic_subtitle x04_0300_pot 5)
	)
	
(script dormant x04_0310_pot
	(sleep 312)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0310_pot truth 1)
	(cinematic_subtitle x04_0310_pot 6)
	
	(unit_set_emotional_state truth happy .75 60)
	
	)

; ---------------------------------------------------------------------

(script static void x04_08_setup
	
	(wake x04_score_08)
	(wake x04_foley_08)
	
	(wake x04_0290_der)
	(wake x04_0300_pot)
	(wake x04_0310_pot)

	)

(script static void x04_scene_08

	(cinematic_screen_effect_stop)
	
	(x04_08_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_08" none "anchor_flag_x04b")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_08" false anchor_x04b)
	(custom_animation_relative truth objects\characters\prophet\x04\x04 "truth_08" false anchor_x04b)
	(custom_animation_relative mercy objects\characters\prophet\x04\x04 "mercy_08" false anchor_x04b)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_08" anchor_x04b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_09_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_09_fol)
	
	(sleep (camera_time))
	
	)
	
; X04 SCENE 09 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_foley_09
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_09_fol none 1)
	(print "x04 foley 09 start")
	)

(script dormant x04_0320_der
	(sleep 63)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0320_der dervish 1)
	(cinematic_subtitle x04_0320_der 1.25)
	)
	
(script dormant x04_0330_pom
	(sleep 100)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0330_pom mercy 1)
	(cinematic_subtitle x04_0330_pom 12)
	)

; ---------------------------------------------------------------------

(script static void x04_09_setup

	(wake x04_foley_09)
	
	(wake x04_0320_der)
	(wake x04_0330_pom)
	
	)

(script static void x04_scene_09
	
	(x04_09_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_09" none "anchor_flag_x04b")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_09" false anchor_x04b)
	(custom_animation_relative truth objects\characters\prophet\x04\x04 "truth_09" false anchor_x04b)
	(custom_animation_relative mercy objects\characters\prophet\x04\x04 "mercy_09" false anchor_x04b)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_09" anchor_x04b)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x04_10_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\music\10_mus)
	(sound_impulse_predict sound\cinematics\04_alphagas\x04\foley\x04_10_fol)
	
	(sleep (camera_time))
	
	)
	
; X04 SCENE 10 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x04_score_10
	(sleep 538)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\music\10_mus none 1)
	(print "x04 score 10 start")
	)
	
(script dormant x04_foley_10
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\x04\foley\x04_10_fol none 1)
	(print "x04 foley 10 start")
	)

(script dormant x04_0370_der
	(sleep 566)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0340_der dervish 1)
	(cinematic_subtitle x04_0340_der 3)
	)

; ---------------------------------------------------------------------

(script static void x04_10_setup

	(wake x04_score_10)
	(wake x04_foley_10)
	
	(wake x04_0370_der)
	
	)
	
(script static void x04_10_cleanup
	
	(object_destroy dervish)
	(object_destroy truth)
	(object_destroy mercy)
	(object_destroy_containing throne)
	(object_destroy sarcophagus)
	)

(script static void x04_scene_10
	
	(x04_10_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_10" none "anchor_flag_x04b")
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_10" false anchor_x04b)
	(custom_animation_relative truth objects\characters\prophet\x04\x04 "truth_10" false anchor_x04b)
	(custom_animation_relative mercy objects\characters\prophet\x04\x04 "mercy_10" false anchor_x04b)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_10" anchor_x04b)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(x04_10_cleanup)
	
	)

; X04 MASTER SCRIPT ===================================================
; =====================================================================

(script static void x04
	
	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name high_4_cinematic)
	(sleep 1)
	
	(x04_scene_01)
	(x04_scene_02a)
	(x04_scene_02b)
	(x04_scene_03b)
	(x04_scene_04)
	(x04_scene_05)
	(x04_scene_06)
	(x04_scene_07)
	(x04_scene_08)
	(x04_scene_09)
	(x04_scene_10)
	
	(sleep 30)
	
	)

; C04_INTRO SCENE 01 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_intro_sound_scene1_01
	
	(object_set_function_variable phantom01 "engine_hack" 1 0)
	(object_set_function_variable phantom02 "engine_hack" 1 0)
	(object_set_function_variable phantom03 "engine_hack" 1 0)

	(object_set_function_variable phantom01 "engine_audio" 1 0)
	(object_set_function_variable phantom02 "engine_audio" 1 0)
	(object_set_function_variable phantom03 "engine_audio" 1 0)
	
	(object_set_function_variable phantom01 "hover_audio" 1 0)
	(object_set_function_variable phantom02 "hover_audio" 1 0)
	(object_set_function_variable phantom03 "hover_audio" 1 0)
	
	(sound_class_set_gain vehicle 0 0)
	(sound_class_set_gain vehicle 1 90)
	
	(object_set_velocity phantom01 30)
	(object_set_velocity phantom02 30)
	(object_set_velocity phantom03 30)
	
	(sleep 105)
	
	(sound_class_set_gain vehicle 0 150)
	
	)
	
(script dormant c04_intro_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intro\foley\c04_intro_01_fol none 1)
	(print "c04_intro foley 01 start")
	)

(script dormant c04_1010_soc
	(sleep 95)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1010_soc none 1)
	(cinematic_subtitle c04_1010_soc 2)
	)
	
(script dormant c04_1020_sec
	(sleep 167)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1020_sec none 1)
	(cinematic_subtitle c04_1020_sec 4)
	)
	
(script dormant c04_1030_soc
	(sleep 279)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1030_soc none 1)
	(cinematic_subtitle c04_1030_soc 6)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c04_intro_cinematic_lighting_01
	
	(cinematic_lighting_set_primary_light -64 276 0.427451 0.337255 0.337255)
	(cinematic_lighting_set_secondary_light -73 160 0.117647 0.117647 0.176471)
	(cinematic_lighting_set_ambient_light 0.0156863 0.0156863 0.0156863)
	
	(rasterizer_bloom_override_threshold .6)
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting phantom01 1)
	(object_uses_cinematic_lighting phantom02 1)
	(object_uses_cinematic_lighting phantom03 1)
	
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void c04_intro_01_problem_actors
	(print "problem actors")
		
	(object_create_anew phantom01)
	(object_create_anew phantom02)
	(object_create_anew phantom03)
	
	(object_create_anew matte_high_charity)
	(object_create_anew matte_threshold)
	(object_create_anew matte_halo_01)
	(object_create_anew stardust_01)
	(object_create_anew stardust_02)
	
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	(object_cinematic_lod phantom03 true)

	)

(script static void c04_intro_02a_problem_actors
	(print "problem actors")

	(object_create_anew dervish02)
	(object_create_anew commander)
	(object_create_anew elite01)
	(object_create_anew elite02)
	(object_create_anew elite03)
	(object_create_anew elite04)
	(object_create_anew elite05)
	(object_create_anew elite06)
	(object_create_anew elite07)
	(object_create_anew grunt01)
	(object_create_anew grunt02)
	(object_create_anew grunt03)
	(object_create_anew grunt04)
	(object_create_anew phantom_int)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod elite02 true)
	(object_cinematic_lod elite03 true)
	(object_cinematic_lod elite04 true)
	(object_cinematic_lod elite05 true)
	(object_cinematic_lod elite06 true)
	(object_cinematic_lod elite07 true)
	(object_cinematic_lod grunt01 true)
	(object_cinematic_lod grunt02 true)
	(object_cinematic_lod grunt03 true)
	(object_cinematic_lod grunt04 true)
	(object_cinematic_lod phantom_int true)

	)

; ---------------------------------------------------------------------
	
(script static void c04_intro_01_setup
	
;	(wake c04_intro_score_01)
	(wake c04_intro_foley_01)

	(wake c04_1010_soc)
	(wake c04_1020_sec)
	(wake c04_1030_soc)
	
	(wake c04_intro_sound_scene1_01)
	
	(wake c04_intro_cinematic_lighting_01)	

	)
	
(script static void c04_intro_01_cleanup
	(object_destroy intro_fleet)
	(object_destroy_containing stardust)
	(object_destroy_containing matte)
	)

(script static void c04_intro_01

	(fade_out 0 0 0 0)
	
	(object_create_anew intro_fleet)
	
	(camera_control on)
	(cinematic_start_movie "gasgiant_intro")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(04_intro_01_predict_stub)
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_03_fol)
	(c04_intro_01_problem_actors)
	(sleep prediction_offset)
	
	(c04_intro_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_01" none "cinematic_anchor03")
	
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_01" false anchor03)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_01" false anchor03)
	(custom_animation_relative phantom03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_01" false anchor03)

	(scenery_animation_start_relative matte_high_charity objects\cinematics\matte_paintings\high_charity_exterior\04_intro\04_intro "high_charity_exterior_01" anchor03)	
	(scenery_animation_start_relative matte_threshold objects\cinematics\matte_paintings\threshold_space\04_intro\04_intro "threshold_01" anchor03)
	(scenery_animation_start_relative matte_halo_01 objects\cinematics\matte_paintings\halo_destroyed_03\04_intro\04_intro "halo_destroyed03_01" anchor03)
	
	(scenery_animation_start_relative stardust_01 objects\cinematics\matte_paintings\high_charity_stardust\04_intro\04_intro "stardust01_01" anchor03)
	(scenery_animation_start_relative stardust_02 objects\cinematics\matte_paintings\high_charity_stardust\04_intro\04_intro "stardust01_02" anchor03)
	
	(fade_in 0 0 0 30)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_intro_02a_predict_stub)
;	(c04_intro_02a_problem_actors)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c04_intro_01_cleanup)

	)

; C04_INTRO SCENE 02a -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_intro_sound_scene2a_01

	(object_set_function_variable phantom_int "engine_hack" 1 0)
	(object_set_function_variable phantom_int "engine_audio" 1 0)
	(object_set_function_variable phantom_int "hover_audio" 1 0)

	(sound_class_set_gain vehicle .5 15)
	)
	
(script dormant c04_intro_sound_scene2a_02
	(sleep 720)
	(sound_class_set_gain vehicle 0 15)
	)

(script dormant c04_1040_sec
	(sleep 169)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1040_sec none 1)
	(cinematic_subtitle c04_1040_sec 2)
	)
	
(script dormant c04_1050_soc
	(sleep 239)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1050_soc commander 1)
	(cinematic_subtitle c04_1050_soc 6)
	)
	
(script dormant c04_1060_soc
	(sleep 400)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1060_soc commander 1)
	(cinematic_subtitle c04_1060_soc 5)
	)
	
(script dormant c04_1070_sog
	(sleep 552)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1070_sog none 1)
	(cinematic_subtitle c04_1070_sog 1)
	(print "which grunt is this?")
	)

; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c04_intro_02a_fov
	(sleep 237)
	(camera_set_field_of_view 60 0)
	(print "fov change: 80 -> 60 over 0 ticks")
	)
	
(script dormant c04_intro_cinematic_light_02a

	(cinematic_lighting_set_primary_light -90 0 0.23 0.29 0.53)
	(cinematic_lighting_set_secondary_light -90 192 0.16 0.10 0.19)
	(cinematic_lighting_set_ambient_light 0.07 0.05 0.08)

	(rasterizer_bloom_override_threshold .3)
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting dervish02 1)
	(object_uses_cinematic_lighting commander 1)
	(object_uses_cinematic_lighting elite01 1)
	(object_uses_cinematic_lighting elite02 1)
	(object_uses_cinematic_lighting elite03 1)
	(object_uses_cinematic_lighting elite04 1)
	(object_uses_cinematic_lighting elite05 1)
	(object_uses_cinematic_lighting elite06 1)
	(object_uses_cinematic_lighting elite07 1)
	(object_uses_cinematic_lighting grunt01 1)
	(object_uses_cinematic_lighting grunt02 1)
	(object_uses_cinematic_lighting grunt03 1)
	(object_uses_cinematic_lighting grunt04 1)
	(object_uses_cinematic_lighting phantom_int 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c04_intro_02a_setup
	
	(object_create_anew dervish02)
	(object_create_anew commander)
	(object_create_anew elite01)
	(object_create_anew elite02)
	(object_create_anew elite03)
	(object_create_anew elite04)
	(object_create_anew elite05)
	(object_create_anew elite06)
	(object_create_anew elite07)
	(object_create_anew grunt01)
	(object_create_anew grunt02)
	(object_create_anew grunt03)
	(object_create_anew grunt04)
	(object_create_anew phantom_int)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod elite02 true)
	(object_cinematic_lod elite03 true)
	(object_cinematic_lod elite04 true)
	(object_cinematic_lod elite05 true)
	(object_cinematic_lod elite06 true)
	(object_cinematic_lod elite07 true)
	(object_cinematic_lod grunt01 true)
	(object_cinematic_lod grunt02 true)
	(object_cinematic_lod grunt03 true)
	(object_cinematic_lod grunt04 true)
	(object_cinematic_lod phantom_int true)
	
	(object_create_anew beam_rifle01)
	(object_create_anew plasma_rifle01)
	(object_create_anew plasma_rifle02)
	(object_create_anew plasma_rifle03)
	(object_create_anew plasma_rifle04)
	(object_create_anew plasma_rifle05)
	(object_create_anew plasma_rifle06)
	(object_create_anew plasma_pistol01)
	(object_create_anew plasma_pistol02)
	(object_create_anew plasma_pistol03)
	(object_create_anew plasma_pistol04)
	
	(objects_attach elite05 "right_hand_elite" beam_rifle01 "")
	(objects_attach elite01 "right_hand_elite" plasma_rifle01 "")
	(objects_attach elite02 "right_hand_elite" plasma_rifle02 "")
	(objects_attach elite03 "right_hand_elite" plasma_rifle03 "")
	(objects_attach elite04 "right_hand_elite" plasma_rifle04 "")
	(objects_attach elite06 "right_hand_elite" plasma_rifle05 "")
	(objects_attach elite07 "right_hand_elite" plasma_rifle06 "")
	(objects_attach grunt01 "right_hand" plasma_pistol01 "")
	(objects_attach grunt01 "right_hand" plasma_pistol02 "")
	(objects_attach grunt01 "right_hand" plasma_pistol03 "")
	(objects_attach grunt01 "right_hand" plasma_pistol04 "")

	(wake c04_intro_sound_scene2a_01)
	(wake c04_intro_sound_scene2a_02)

;	(wake c04_intro_foley_02a)

	(wake c04_1040_sec)
	(wake c04_1050_soc)
	(wake c04_1060_soc)
	(wake c04_1070_sog)
	
	(wake c04_intro_02a_fov)
	(wake c04_intro_cinematic_light_02a)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	)
	
(script static void c04_intro_02a_cleanup
	
	(object_destroy elite03)
	(object_destroy elite06)
	(object_destroy elite07)
	
	)

(script static void c04_intro_02a

	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(04_intro_02a_predict_stub)
	
	(c04_intro_02a_setup)
	
	(camera_set_field_of_view 80 0)
	(print "fov change: 60 -> 80 over 0 ticks")
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_02a" none "cinematic_anchor03")
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intro\04_intro "dervish_02a" false anchor03)
	(custom_animation_relative commander objects\characters\elite\04_intro\04_intro "commander_02a" false anchor03)
	(custom_animation_relative elite01 objects\characters\elite\04_intro\04_intro "elite01_02a" false anchor03)
	(custom_animation_relative elite02 objects\characters\elite\04_intro\04_intro "elite02_02a" false anchor03)
	(custom_animation_relative elite03 objects\characters\elite\04_intro\04_intro "elite03_02a" false anchor03)
	(custom_animation_relative elite04 objects\characters\elite\04_intro\04_intro "elite04_02a" false anchor03)
	(custom_animation_relative elite05 objects\characters\elite\04_intro\04_intro "elite05_02a" false anchor03)
	(custom_animation_relative elite06 objects\characters\elite\04_intro\04_intro "elite06_02a" false anchor03)
	(custom_animation_relative elite07 objects\characters\elite\04_intro\04_intro "elite07_02a" false anchor03)
	(custom_animation_relative grunt01 objects\characters\grunt\04_intro\04_intro "grunt01_02a" false anchor03)
	(custom_animation_relative grunt02 objects\characters\grunt\04_intro\04_intro "grunt02_02a" false anchor03)
	(custom_animation_relative grunt03 objects\characters\grunt\04_intro\04_intro "grunt03_02a" false anchor03)
	(custom_animation_relative grunt04 objects\characters\grunt\04_intro\04_intro "grunt04_02a" false anchor03)
	
	(scenery_animation_start_relative phantom_int objects\vehicles\phantom\cinematics\04_intro\04_intro "phantom_int_02a" anchor03)
	
	(sleep 5)
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_intro_02b_predict_stub)
	
	(sleep (camera_time))
	
	(c04_intro_02a_cleanup)
	)

; C04_INTRO SCENE 02b -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_1080_sec
	(sleep 5)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1080_sec none 1)
	(cinematic_subtitle c04_1080_sec 3)
	)
	
(script dormant c04_1090_soc
	(sleep 83)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1090_soc commander 1)
	(cinematic_subtitle c04_1090_soc 3)
	)

; ---------------------------------------------------------------------

(script static void c04_intro_02b_setup
	
	(wake c04_1080_sec)
	(wake c04_1090_soc)
	
	)
	
(script static void c04_intro_02b_cleanup
	
	(object_hide phantom_int true)
	
	(object_destroy elite01)
	(object_destroy elite02)
	(object_destroy elite04)
	(object_destroy elite05)
	(object_destroy grunt01)
	(object_destroy grunt02)
	(object_destroy grunt03)
	(object_destroy grunt04)
	
	)

(script static void c04_intro_02b
	
	(c04_intro_02b_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_02b" none "cinematic_anchor03")
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intro\04_intro "dervish_02b" false anchor03)
	(custom_animation_relative commander objects\characters\elite\04_intro\04_intro "commander_02b" false anchor03)
	(custom_animation_relative elite01 objects\characters\elite\04_intro\04_intro "elite01_02b" false anchor03)
	(custom_animation_relative elite02 objects\characters\elite\04_intro\04_intro "elite02_02b" false anchor03)
	(custom_animation_relative elite04 objects\characters\elite\04_intro\04_intro "elite04_02b" false anchor03)
	(custom_animation_relative elite05 objects\characters\elite\04_intro\04_intro "elite05_02b" false anchor03)
	(custom_animation_relative grunt01 objects\characters\grunt\04_intro\04_intro "grunt01_02b" false anchor03)
	(custom_animation_relative grunt02 objects\characters\grunt\04_intro\04_intro "grunt02_02b" false anchor03)
	(custom_animation_relative grunt03 objects\characters\grunt\04_intro\04_intro "grunt03_02b" false anchor03)
	(custom_animation_relative grunt04 objects\characters\grunt\04_intro\04_intro "grunt04_02b" false anchor03)

	(scenery_animation_start_relative phantom_int objects\vehicles\phantom\cinematics\04_intro\04_intro "phantom_int_02b" anchor03)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_intro_02c_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_intro\music\c04_02c_mus)	
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_intro\foley\c04_intro_02c_fol)	
	
	(sleep (camera_time))
	
	(c04_intro_02b_cleanup)
	
	)
	
; C04_INTRO SCENE 02c -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_intro_sound_scene2c_01
	(sound_class_set_gain vehicle 1 80)
	)
	
(script dormant c04_intro_sound_scene2c_02
	(sleep 90)
	(sound_class_set_gain vehicle 0 10)
	)
	
(script dormant c04_intro_score_02c
	(sleep 101)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intro\music\c04_02c_mus none 1)
	(print "c04_intro score 02c start")
	)

(script dormant c04_intro_foley_02c
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intro\foley\c04_intro_02c_fol none 1)
	(print "c04_intro foley 02c start")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c04_intro_cinematic_light_02c
	
	(cinematic_lighting_set_primary_light 24 294 0.35 0.39 0.24)
	(cinematic_lighting_set_secondary_light 19 22 0.00 0.00 0.00)
	(cinematic_lighting_set_ambient_light 0.18 0.14 0.14)
	
	(rasterizer_bloom_override_threshold .4)
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting phantom01 1)
	(object_uses_cinematic_lighting phantom02 1)
	(object_uses_cinematic_lighting phantom03 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c04_intro_02c_setup
	
	(player_effect_stop 0)
	
	(object_create_anew matte_structure_top)
	
	(wake c04_intro_sound_scene2c_01)
	(wake c04_intro_sound_scene2c_02)
	
	(wake c04_intro_score_02c)
	(wake c04_intro_foley_02c)

	(wake c04_intro_cinematic_light_02c)
	
	)

(script static void c04_intro_02c
	
	(c04_intro_02c_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_02c" none "cinematic_anchor03")
	
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_02c" false anchor03)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_02c" false anchor03)
	(custom_animation_relative phantom03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_02c" false anchor03)
	
	(scenery_animation_start_relative matte_structure_top objects\cinematics\matte_paintings\gas_giant_structure_top\04_intro\04_intro "gas_giant_structure_top_02c" anchor03)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_intro_02d_predict_stub)
	
	(cinematic_screen_effect_start 1)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_intro\foley\c04_intro_02d_fol)

	(sleep (- (camera_time) 5))
	(cinematic_screen_effect_set_crossfade 2)

	(sleep 5)
	
	(object_destroy matte_structure_top)

	)

; C04_INTRO SCENE 02d -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_intro_sound_scene2d_01
	(sound_class_set_gain vehicle .5 15)
	)

(script dormant c04_intro_foley_02d
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intro\foley\c04_intro_02d_fol none 1)
	(print "c04_intro foley 02d start")
	)

(script dormant c04_1100_soc
	(sleep 29)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1100_soc commander 1)
	(cinematic_subtitle c04_1100_soc 1)
	)

(script dormant c04_1110_soc
	(sleep 76)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1110_soc commander 1)
	(cinematic_subtitle c04_1110_soc 2)
	)

(script dormant c04_1120_der
	(sleep 127)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1120_der dervish02 1)
	(cinematic_subtitle c04_1120_der 1)
	)
	
(script dormant c04_1130_soc
	(sleep 174)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1130_soc commander 1)
	(cinematic_subtitle c04_1130_soc 9)
	)
	
(script dormant c04_1140_der
	(sleep 430)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1140_der dervish02 1)
	(cinematic_subtitle c04_1140_der 2)
	)

(script dormant c04_1150_soc
	(sleep 494)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1150_soc commander 1)
	(cinematic_subtitle c04_1150_soc 1)
	)
	
; ---------------------------------------------------------------------

(script dormant c04_intro_cinematic_light_02d
	
	(cinematic_lighting_set_primary_light -90 0 0.23 0.29 0.53)
	(cinematic_lighting_set_secondary_light -90 192 0.16 0.10 0.19)
	(cinematic_lighting_set_ambient_light 0.07 0.05 0.08)
	
	(rasterizer_bloom_override_threshold .3)
	(rasterizer_bloom_override_brightness .5)

	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void c04_intro_03_problem_actors
	(print "problem actors")
	(object_create_anew matte_structure)
	)	
	
; ---------------------------------------------------------------------

(script static void c04_intro_02d_setup

	(object_hide phantom_int false)
	
	(wake c04_intro_sound_scene2d_01)
	
	(wake c04_intro_foley_02d)
	
	(wake c04_1100_soc)
	(wake c04_1110_soc)
	(wake c04_1120_der)
	(wake c04_1130_soc)
	(wake c04_1140_der)
	(wake c04_1150_soc)
	
	(wake c04_intro_cinematic_light_02d)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)

	)

(script static void c04_intro_02d
	
	(c04_intro_02d_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_02d" none "cinematic_anchor03")
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intro\04_intro "dervish_02d" false anchor03)
	(custom_animation_relative commander objects\characters\elite\04_intro\04_intro "commander_02d" false anchor03)

	(scenery_animation_start_relative phantom_int objects\vehicles\phantom\cinematics\04_intro\04_intro "phantom_int_02d" anchor03)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_intro_03_predict_stub)
	
	(cinematic_screen_effect_stop)

	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_intro\foley\c04_intro_03_fol)
	(c04_intro_03_problem_actors)
	
	(sleep (camera_time))
	
	(object_destroy dervish02)
	(object_destroy commander)
	(object_destroy phantom_int)
	
	)

; C04_INTRO SCENE 03 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_intro_sound_scene3_01
	(sound_class_set_gain vehicle 0 15)
	)
	
(script dormant c04_intro_sound_scene3_02
	(sound_class_set_gain vehicle 1 170)
	)

(script dormant c04_intro_sound_scene3_03
	(sleep 180)
	(sound_class_set_gain vehicle 0 120)
	)

(script dormant c04_intro_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intro\foley\c04_intro_03_fol none 1)
	(print "c04_intro foley 03 start")
	)

(script dormant c04_1170_elp
	(sleep 189)
	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\cinematic\c04_1170_elp none 1 radio_covy_in)
	(cinematic_subtitle c04_1170_elp 1)
	)

(script dormant c04_1180_ecp
	(sleep 212)
	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\cinematic\c04_1180_elp none 1 radio_covy_loop)
	(cinematic_subtitle c04_1180_elp 3)
	)
	
(script dormant c04_1190_soc
	(sleep 295)
	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\cinematic\c04_1190_soc none 1 radio_covy_out)
	(cinematic_subtitle c04_1190_soc 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c04_intro_cinematic_light_03

	(cinematic_lighting_set_primary_light -32 140 0.35 0.39 0.24)
	(cinematic_lighting_set_secondary_light 19 22 0.00 0.00 0.00)
	(cinematic_lighting_set_ambient_light 0.18 0.14 0.14)
	
	(rasterizer_bloom_override_threshold .4)
	(rasterizer_bloom_override_brightness .5)
	
	)
	
; ---------------------------------------------------------------------

(script dormant c04_intro_shake_03
	(sleep 173)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(player_effect_stop 1.5)
	)

(script static void c04_intro_03_setup

	(object_create_anew matte_mine)
	
	(wake c04_intro_sound_scene3_01)
	(wake c04_intro_sound_scene3_02)
	(wake c04_intro_sound_scene3_03)
	
	(wake c04_intro_foley_03)
	
	(wake c04_1170_elp)
	(wake c04_1180_ecp)
	(wake c04_1190_soc)
	
	(wake c04_intro_shake_03)
	(wake c04_intro_cinematic_light_03)
	(player_effect_stop 0)

	)
	
(script static void c04_intro_03_cleanup

	(object_destroy phantom01)
	(object_destroy phantom02)
	(object_destroy phantom03)
	
	(object_destroy_containing matte)
	
	)

(script static void c04_intro_03
	
	(c04_intro_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_03" none "cinematic_anchor03")
	
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_3" false anchor03)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_3" false anchor03)
	(custom_animation_relative phantom03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_3" false anchor03)
	
	(scenery_animation_start_relative matte_mine objects\cinematics\matte_paintings\gas_giant_exterior\04_intro\04_intro "gas_giant_exterior_03" anchor03)
	(scenery_animation_start_relative matte_structure objects\cinematics\matte_paintings\gas_giant_structure\04_intro\04_intro "gas_giant_structure_03" anchor03)
	
	(sleep (- (camera_time) 15))
	(fade_out 1 1 1 15)
	
	(sleep (camera_time))
	
	(c04_intro_03_cleanup)
	
	)

; C04_INTRO SCENE 05 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_intro_sound_scene5_01
	
	(object_set_function_variable phantom_01 "engine_hack" 1 0)
	(object_set_function_variable phantom_02 "engine_hack" 1 0)
	(object_set_function_variable phantom_03 "engine_hack" 1 0)

	(object_set_function_variable phantom_01 "engine_audio" 1 0)
	(object_set_function_variable phantom_02 "engine_audio" 1 0)
	(object_set_function_variable phantom_03 "engine_audio" 1 0)
	
	(object_set_function_variable phantom_01 "hover_audio" 1 0)
	(object_set_function_variable phantom_02 "hover_audio" 1 0)
	(object_set_function_variable phantom_03 "hover_audio" 1 0)
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c04_intro_05_shake_1
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .15 0)
	(sleep 401)
	(player_effect_stop 0)
	)

; ---------------------------------------------------------------------

(script static void c04_intro_05_setup
	
	(object_create_anew phantom_01)
	(object_create_anew phantom_02)
	(object_create_anew phantom_03)
	
	(wake c04_intro_sound_scene5_01)

	(wake c04_intro_05_shake_1)
	
	)

(script static void c04_intro_05

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(04_intro_05_predict_stub)
	
	(c04_intro_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_05" none "cinematic_anchor02")
	
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_05" false anchor02)
	(custom_animation_relative phantom_02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_05" false anchor02)
	(custom_animation_relative phantom_03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_05" false anchor02)
	
;	safety white
	(sleep 15)
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_intro_06b_predict_stub)
	
	(sleep (camera_time))
	
	)
	
; C04_INTRO SCENE 06b -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_intro_sound_scene6b_01
	(sound_class_set_gain vehicle 1 30)
	)
	
(script dormant c04_intro_sound_scene6b_02
	(object_set_function_variable phantom_01 "engine_hack" 0 120)
	(object_set_function_variable phantom_02 "engine_hack" 0 120)
	(object_set_function_variable phantom_03 "engine_hack" 0 120)

	(object_set_function_variable phantom_01 "engine_audio" 0 120)
	(object_set_function_variable phantom_02 "engine_audio" 0 120)
	(object_set_function_variable phantom_03 "engine_audio" 0 120)
	
	(object_set_function_variable phantom_01 "hover_audio" 0 120)
	(object_set_function_variable phantom_02 "hover_audio" 0 120)
	(object_set_function_variable phantom_03 "hover_audio" 0 120)
	)

(script dormant c04_intro_sound_scene6b_03
	(sleep 30)
	(object_set_function_variable phantom_01 "turn_absolute" 1 30)
	(object_set_function_variable phantom_02 "turn_absolute" 1 30)
	(object_set_function_variable phantom_03 "turn_absolute" 1 30)

	(object_set_function_variable phantom_01 "banking_audio" 1 30)
	(object_set_function_variable phantom_02 "banking_audio" 1 30)
	(object_set_function_variable phantom_03 "banking_audio" 1 30)

	(object_set_function_variable phantom_01 "engine_ducker" 1 60)
	(object_set_function_variable phantom_02 "engine_ducker" 1 60)
	(object_set_function_variable phantom_03 "engine_ducker" 1 60)
	)

(script dormant c04_intro_sound_scene6b_04
	(sleep 60)
	(object_set_function_variable phantom_01 "turn_absolute" 0 30)
	(object_set_function_variable phantom_02 "turn_absolute" 0 30)
	(object_set_function_variable phantom_03 "turn_absolute" 0 30)

	(object_set_function_variable phantom_01 "banking_audio" 0 30)
	(object_set_function_variable phantom_02 "banking_audio" 0 30)
	(object_set_function_variable phantom_03 "banking_audio" 0 30)
	)


(script dormant c04_intro_sound_scene6b_05	
	(sleep 210)
	
	(object_set_function_variable phantom_01 "engine_hack" 1 60)
	(object_set_function_variable phantom_03 "engine_hack" 1 60)

	(object_set_function_variable phantom_01 "engine_audio" 1 60)
	(object_set_function_variable phantom_03 "engine_audio" 1 60)
	
	(object_set_function_variable phantom_01 "hover_audio" 1 60)
	(object_set_function_variable phantom_03 "hover_audio" 1 60)

	(object_set_function_variable phantom_01 "engine_ducker" 0 60)
	(object_set_function_variable phantom_03 "engine_ducker" 0 60)
	)

(script dormant c04_intro_sound_scene6b_06
	(sleep 315)
	
	(object_set_function_variable phantom_02 "engine_hack" 1 60)
	(object_set_function_variable phantom_02 "engine_audio" 1 60)
	(object_set_function_variable phantom_02 "hover_audio" 1 60)
	(object_set_function_variable phantom_02 "engine_ducker" 0 60)
	)

(script dormant c04_intro_sound_scene6b_07	
	(sleep 375)
	(sound_class_set_gain vehicle 0 30)
	)

(script dormant c04_1200_soc
	(sleep 330)
	(sound_impulse_start_effect sound\dialog\levels\04_gasgiant\cinematic\c04_1200_soc none 1 radio_covy)
	(cinematic_subtitle c04_1200_soc 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c04_intro_06b_fov
	(sleep 117)
	(camera_set_field_of_view 60 32)
	)	

(script dormant c04_06b_shake_1
	(player_effect_stop 0)
	(sleep 30)
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 2)
	(sleep 60)
	(player_effect_stop 2)
	)
	
(script dormant c04_intro_cinematic_light_06b
	
	(cinematic_lighting_set_primary_light 3 234 0.40 0.44 0.27)
	(cinematic_lighting_set_secondary_light 19 118 0.25 0.23 0.15)
	(cinematic_lighting_set_ambient_light 0.07 0.06 0.06)
	
	(rasterizer_bloom_override_threshold .4)
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting phantom_01 1)
	(object_uses_cinematic_lighting phantom_02 1)
	(object_uses_cinematic_lighting phantom_03 1)
	
	)
	
; ---------------------------------------------------------------------

(script dormant grunt_insertion
	(sleep 173)
	
	(object_create_anew grunt01)
	(object_create_anew grunt02)
	(object_create_anew grunt03)
	(object_create_anew grunt04)
	
	(object_cinematic_lod grunt01 true)
	(object_cinematic_lod grunt02 true)
	(object_cinematic_lod grunt03 true)
	(object_cinematic_lod grunt04 true)
	
	(object_create_anew plasma_pistol01)
	(object_create_anew plasma_pistol02)
	(object_create_anew plasma_pistol03)
	(object_create_anew plasma_pistol04)
	
	(objects_attach grunt01 "right_hand" plasma_pistol01 "")
	(objects_attach grunt01 "right_hand" plasma_pistol02 "")
	(objects_attach grunt01 "right_hand" plasma_pistol03 "")
	(objects_attach grunt01 "right_hand" plasma_pistol04 "")
	
	(object_uses_cinematic_lighting grunt01 1)
	(object_uses_cinematic_lighting grunt02 1)
	(object_uses_cinematic_lighting grunt03 1)
	(object_uses_cinematic_lighting grunt04 1)
	
	(custom_animation_relative grunt01 objects\characters\grunt\04_intro\04_intro "grunt01_06b" false anchor02)
	(custom_animation_relative grunt02 objects\characters\grunt\04_intro\04_intro "grunt02_06b" false anchor02)
	(custom_animation_relative grunt03 objects\characters\grunt\04_intro\04_intro "grunt03_06b" false anchor02)
	(custom_animation_relative grunt04 objects\characters\grunt\04_intro\04_intro "grunt04_06b" false anchor02)
	)
	
(script dormant elite_insertion
	(sleep 179)
	
	(object_create_anew elite03)
	(object_create_anew elite04)
	
	(object_cinematic_lod elite03 true)
	(object_cinematic_lod elite04 true)
	
	(object_create_anew plasma_rifle03)
	(object_create_anew plasma_rifle04)
	
	(objects_attach elite03 "right_hand_elite" plasma_rifle03 "")
	(objects_attach elite04 "right_hand_elite" plasma_rifle04 "")
	
	(object_uses_cinematic_lighting elite03 1)
	(object_uses_cinematic_lighting elite04 1)
	
	(custom_animation_relative elite03 objects\characters\elite\04_intro\04_intro "elite03_06b" false anchor02)
	(custom_animation_relative elite04 objects\characters\elite\04_intro\04_intro "elite04_06b" false anchor02)
	)
	
(script dormant dervish_insertion
	(sleep 312)
	
	(object_create_anew dervish02)
	(object_create_anew energy_blade01)
	(object_cinematic_lod dervish02 true)
	
	(objects_attach dervish02 "right_hand_elite" energy_blade01 "")
	(object_set_permutation energy_blade01 "blade" "noblade")
	
	(object_uses_cinematic_lighting dervish02 1)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intro\04_intro "dervish_06b" false anchor02)
	
	(sleep 72)
	(object_set_permutation energy_blade01 "blade" "default")
	(object_set_function_variable energy_blade01 turned_on 1 0)
	(effect_new_on_object_marker effects\objects\weapons\melee\energy_blade\blade_activate_elite dervish02 "right_hand_elite")
	(print "blade activate")
	
	)
	
(script static void test
	(print "no blade")
	(object_set_permutation energy_blade01 "blade" "noblade")
	(sleep 60)
	
	(object_set_permutation energy_blade01 "blade" "default")
	(effect_new_on_object_marker effects\objects\weapons\melee\energy_blade\blade_activate energy_blade01 "ground_point")
	(print "blade")
	
	)
	
(script dormant elite_01_insertion
	(sleep 281)
	
	(object_create_anew elite01)
	(object_create_anew plasma_rifle01)
	(object_cinematic_lod elite01 true)
	(objects_attach elite01 "right_hand_elite" plasma_rifle01 "")
	(object_uses_cinematic_lighting elite01 1)

	(custom_animation_relative elite01 objects\characters\elite\04_intro\04_intro "elite01_06b" false anchor02)
	)
	
(script dormant elite_02_insertion
	(sleep 272)
	
	(object_create_anew elite02)
	(object_create_anew plasma_rifle02)
	(object_cinematic_lod elite02 true)
	(objects_attach elite02 "right_hand_elite" plasma_rifle02 "")
	(object_uses_cinematic_lighting elite02 1)
	
	(custom_animation_relative elite02 objects\characters\elite\04_intro\04_intro "elite02_06b" false anchor02)
	)

(script static void c04_intro_06b_setup
	
	(wake c04_intro_sound_scene6b_01)
	(wake c04_intro_sound_scene6b_02)
	(wake c04_intro_sound_scene6b_03)
	(wake c04_intro_sound_scene6b_04)
	(wake c04_intro_sound_scene6b_05)
	(wake c04_intro_sound_scene6b_06)
	(wake c04_intro_sound_scene6b_07)
	
	(wake c04_1200_soc)
	
	(wake grunt_insertion)
	(wake elite_insertion)
	(wake dervish_insertion)
	(wake elite_01_insertion)
	(wake elite_02_insertion)
	
	(wake c04_intro_06b_fov)
	(wake c04_06b_shake_1)
	(wake c04_intro_cinematic_light_06b)

	)
	
(script static void c04_intro_06b_cleanup
	
	(object_destroy dervish02)
	(object_destroy commander)
	(object_destroy elite01)
	(object_destroy elite02)
	(object_destroy elite03)
	(object_destroy elite04)
	(object_destroy grunt01)
	(object_destroy grunt02)
	(object_destroy grunt03)
	(object_destroy grunt04)
	(object_destroy phantom_01)
	(object_destroy phantom_02)
	(object_destroy phantom_03)
	
	)

(script static void c04_intro_06b
	
	(c04_intro_06b_setup)
	
	(camera_set_field_of_view 27.5 0)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_06b" none "cinematic_anchor02")
	
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_06b" false anchor02)
	(custom_animation_relative phantom_02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_06b" false anchor02)
	(custom_animation_relative phantom_03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_06b" false anchor02)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c04_intro_06b_cleanup)
	
	(sleep 30)
	
	(cinematic_lightmap_shadow_disable)
	
	)

; C04_INTRO MASTER SCRIPT ---------------------------------------------------

(script static void c04_intro

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name ag_cinematic_bsp1)
	(sleep 1)
	
	(c04_intro_01)
	
	(switch_bsp_by_name ag_cinematic_bsp2)
	
	(c04_intro_02a)
	(c04_intro_02b)
	(c04_intro_02c)
	(c04_intro_02d)
	(c04_intro_03)
	
	(switch_bsp_by_name alphagasgiant)
	
	(c04_intro_05)
	(c04_intro_06b)
	
	(rasterizer_bloom_override 0)
	
	)