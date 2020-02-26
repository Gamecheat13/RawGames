; CINEMATICS FOR LEVEL 07A, "HIGH CHARITY" ============================
; =====================================================================

;*
	O, Tank
	
	Ill-defined
	silent monkey on our backs
	No white-board 
	will 'ere display your design
	Were you raft, or Forerunner submarine
	or monument to our sins?
	
	- Joseph on the cutting of "Forerunner Tank"
*; 

; Hi Joe! 
(script command_script cs_c07_infection
	(cs_enable_pathfinding_failsafe true)
	(cs_go_to_nearest c07_infection_a)
	(cs_go_to_nearest c07_infection_b)
)


; GLOBALS & STUBS =====================================================

;	(script stub void c07_infection_place (print "place infection"))
;	(script stub void c07_infection_erase (print "erase infection"))

	(global short sound_offset 15)
	(global short prediction_offset 45)
	
	(script stub void x08_01_predict_stub (print "predict 01"))
	(script stub void x08_02_predict_stub (print "predict 02"))
	(script stub void x08_03_predict_stub (print "predict 03"))
	(script stub void x08_04_predict_stub (print "predict 04"))
	(script stub void x08_05_predict_stub (print "predict 05"))
	(script stub void x08_06a_predict_stub (print "predict 06a"))
	(script stub void x08_06b_predict_stub (print "predict 06b"))
	(script stub void x08_06c_predict_stub (print "predict 06c"))
	(script stub void x08_07_predict_stub (print "predict 07"))
	(script stub void x08_08_predict_stub (print "predict 08"))
	(script stub void x08_09_predict_stub (print "predict 09"))
	(script stub void x08_10_predict_stub (print "predict 10"))
	(script stub void x08_11_predict_stub (print "predict 11"))

	(script stub void 07_intro_01_predict_stub (print "predict 01"))
	(script stub void 07_intro_02_predict_stub (print "predict 02"))
	(script stub void 07_intro_03_predict_stub (print "predict 03"))
	(script stub void 07_intro_04_predict_stub (print "predict 04"))
	
	(script stub void 07_intra1_01_predict_stub (print "predict 04"))
	(script stub void 07_intra1_02_predict_stub (print "predict 04"))
	(script stub void 07_intra1_03_predict_stub (print "predict 04"))
	(script stub void 07_intra1_04_predict_stub (print "predict 04"))

; X08 SCENE 01 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\music\x08_01_mus none 1)
	(print "x08 score 01 start")
	)
	
(script dormant x08_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_01_fol none 1)
	(print "x08 foley 01 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant blurry_vision

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

	)

(script dormant x08_cinematic_light_01
	
	(cinematic_lighting_set_primary_light -90 0 0.0352941 0.278431 0.301961)
	(cinematic_lighting_set_secondary_light -4 316 0.156863 0.109804 0)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .25) 
	(rasterizer_bloom_override_brightness .4)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting gravemind 1)
	(object_uses_cinematic_lighting tentacle_chief 1)
	(object_uses_cinematic_lighting tentacle_capture_01 1)
	
	(render_lights_enable_cinematic_shadow 1 chief head .1)
	
	)

; ---------------------------------------------------------------------

(script static void x08_01_setup

	(object_create_anew chief)
	(object_create_anew gravemind)
	(object_create_anew tentacle_chief)
	(object_create_anew tentacle_capture_01)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod gravemind true)
	(object_cinematic_lod tentacle_chief true)
	(object_cinematic_lod tentacle_capture_01 true)

	(wake x08_score_01)
	(wake x08_foley_01)

	(wake blurry_vision)
	(wake x08_cinematic_light_01)
	
	)

(script static void x08_scene_01

	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x08_01_predict_stub)
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\music\x08_01_mus)	
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_01_fol)	
	(sleep prediction_offset)
	
	(x08_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_01" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_01" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_01" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_01" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_01" anchor_x08)		

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_02_fol)	

	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	)
	
; X08 SCENE 02 --------------------------------------------------------

(script dormant x08_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_02_fol none 1)
	(print "x08 foley 02 start")
	)

(script dormant x08_0020_cor
	(sleep 40)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0020_cor none 1)
	(cinematic_subtitle x08_0020_cor 2)
	)
	
(script dormant x08_0030_grv
	(sleep 134)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0030_grv gravemind 1)
	(cinematic_subtitle x08_0030_grv 9)
	)

; ---------------------------------------------------------------------

(script static void x08_02_setup

	(wake x08_foley_02)

	(wake x08_0020_cor)
	(wake x08_0030_grv)
	
	)

(script static void x08_scene_02
	
	(x08_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_02" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_02" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_02" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_02" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_02" anchor_x08)
	
	(fade_in 1 1 1 15)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_03_fol)
	
	(sleep (camera_time))
	
	)
	
; X08 SCENE 03 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_03_fol none 1)
	(print "x08 foley 03 start")
	)

(script dormant x08_0060_mas
	(sleep 259)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0060_mas chief 1)
	(cinematic_subtitle x08_0060_mas 3)
	)

; ---------------------------------------------------------------------

(script static void x08_03_setup

	(object_create_anew dervish)
	(object_create_anew tentacle_capture_02)
	(object_create_anew tentacle_capture_03)
	(object_create_anew tentacle_capture_04)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tentacle_capture_02 true)
	(object_cinematic_lod tentacle_capture_03 true)
	(object_cinematic_lod tentacle_capture_04 true)
	
	(object_uses_cinematic_lighting dervish 1)
	(render_lights_enable_cinematic_shadow 1 dervish head .2)	

	(object_uses_cinematic_lighting tentacle_capture_02 1)
	(object_uses_cinematic_lighting tentacle_capture_03 1)
	(object_uses_cinematic_lighting tentacle_capture_04 1)
	
	(wake x08_foley_03)
	(wake x08_0060_mas)
	
	)

(script static void x08_scene_03
	
	(x08_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_03" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_03" false anchor_x08)
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_03" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_03" false anchor_x08)

	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_03" anchor_x08)
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_03" anchor_x08)
	
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_03" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_03" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_03" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_03" anchor_x08)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_04_fol)
	
	(sleep (camera_time))
	
	)
	
; X08 SCENE 04 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_04_fol none 1)
	(print "x08 foley 04 start")
	)

(script dormant x08_0070_der
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0070_der dervish 1)
	(cinematic_subtitle x08_0070_der 2)
	)
	
(script dormant x08_0080_grv
	(sleep 20)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0080_grv gravemind 1)
	(cinematic_subtitle x08_0080_grv 13)
	)
	
(script dormant x08_0090_grv
	(sleep 402)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0090_grv gravemind 1)
	(cinematic_subtitle x08_0090_grv 10)
	)
	
(script dormant x08_0100_der
	(sleep 683)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0100_der dervish 1)
	(cinematic_subtitle x08_0100_der 6)
	)

; ---------------------------------------------------------------------

(script static void x08_04_setup
	
	(wake x08_foley_04)
	(wake x08_0070_der)
	(wake x08_0080_grv)
	(wake x08_0090_grv)
	(wake x08_0100_der)
	
	)

(script static void x08_scene_04
	
	(x08_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_04" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_04" false anchor_x08)
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_04" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_04" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_04" anchor_x08)
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_04" anchor_x08)
	
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_04" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_04" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_04" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_04" anchor_x08)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_05_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_05_fol)

	(sleep (camera_time))
	
	)

; X08 SCENE 05 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_05_fol none 1)
	(print "x08 foley 05 start")
	)

(script dormant x08_0110_grv
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0110_grv gravemind 1)
	(cinematic_subtitle x08_0110_grv 3)
	)
	
(script dormant x08_0120_grv
	(sleep 86)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0120_grv gravemind 1)
	(cinematic_subtitle x08_0120_grv 7)
	)
	
(script dormant x08_0130_grv
	(sleep 324)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0130_grv gravemind 1)
	(cinematic_subtitle x08_0130_grv 6)	
	)
	
; ---------------------------------------------------------------------

(script static void x08_05_setup

	(object_create_anew regret)
	(object_create_anew 2401)
	(object_create_anew tentacle_capture_05)
	
	(object_cinematic_lod regret true)
	(object_cinematic_lod 2401 true)
	(object_cinematic_lod tentacle_capture_05 true)
	
	(object_uses_cinematic_lighting regret 1)
	(render_lights_enable_cinematic_shadow 1 regret head .1)
	(object_uses_cinematic_lighting 2401 1)
	(object_uses_cinematic_lighting tentacle_capture_05 1)
	
	(wake x08_foley_05)
	(wake x08_0110_grv)
	(wake x08_0120_grv)
	(wake x08_0130_grv)
	
	)

(script static void x08_scene_05
	
	(x08_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_05" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_05" false anchor_x08)
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_05" false anchor_x08)
	(custom_animation_relative regret objects\characters\gravemind\floodregret\x08\x08 "regret_05" false anchor_x08)
	(custom_animation_relative 2401 objects\characters\gravemind\monitor_flood_infected\x08\x08 "tangent_05" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_05" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_05" anchor_x08)
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_05" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_05" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_05" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_05" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_05" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_05 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven05_05" anchor_x08)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_06a_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_06a_fol)
	
	(sleep (camera_time))
	
	)
	
; X08 SCENE 06A -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_06a
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_06a_fol none 1)
	(print "x08 foley 06a start")
	)
	
(script dormant x08_0140_pnt
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0140_pnt 2401 1)
	(cinematic_subtitle x08_0140_pnt 7)
	)	
	
(script dormant x08_0150_por
	(sleep 198)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0150_por regret 1)
	(cinematic_subtitle x08_0150_por 7)
	)
	
; ---------------------------------------------------------------------

(script static void x08_06a_setup

	(object_destroy gravemind)

	(wake x08_foley_06a)
	(wake x08_0140_pnt)
	(wake x08_0150_por)
	
	)

(script static void x08_scene_06a
	
	(x08_06a_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_06a" none "anchor_flag_x08")
	
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_06a" false anchor_x08)
	(custom_animation_relative regret objects\characters\gravemind\floodregret\x08\x08 "regret_06a" false anchor_x08)
	(custom_animation_relative 2401 objects\characters\gravemind\monitor_flood_infected\x08\x08 "tangent_06a" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_06a" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_06a" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_06a" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_06a" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_05 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven05_06a" anchor_x08)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_06b_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_06b_fol)
	
	(sleep (camera_time))
	
	)
	
; X08 SCENE 06B -------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_06b
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_06b_fol none 1)
	(print "x08 foley 06b start")
	)

(script dormant x08_0180_pnt
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0180_pnt 2401 1)
	(cinematic_subtitle x08_0180_pnt 3.5)
	)
	
(script dormant x08_0190_pnt
	(sleep 105)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0190_pnt 2401 1)
	(cinematic_subtitle x08_0190_pnt 5)
	)		
	
(script dormant x08_0200_por
	(sleep 268)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0200_por regret 1)
	(cinematic_subtitle x08_0200_por 2)
	)
	
(script dormant x08_0210_por
	(sleep 343)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0210_por regret 1)
	(cinematic_subtitle x08_0210_por 4)
	)
	
(script dormant x08_0220_pnt
	(sleep 453)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0220_pnt 2401 1)
	(cinematic_subtitle x08_0220_pnt 8.5)
	)
	
(script dormant x08_0230_por
	(sleep 714)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0230_por regret 1)
	(cinematic_subtitle x08_0230_por 12.5)
	)

; ---------------------------------------------------------------------

(script static void x08_06b_setup

	(wake x08_foley_06b)
	(wake x08_0180_pnt)
	(wake x08_0190_pnt)
	(wake x08_0200_por)
	(wake x08_0210_por)
	(wake x08_0220_pnt)
	(wake x08_0230_por)

;	(wake x04_01_dof_1)
	
	)

(script static void x08_scene_06b
	
	(x08_06b_setup)

	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_06b" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_06b" false anchor_x08)
	(custom_animation_relative regret objects\characters\gravemind\floodregret\x08\x08 "regret_06b" false anchor_x08)
	(custom_animation_relative 2401 objects\characters\gravemind\monitor_flood_infected\x08\x08 "tangent_06b" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_06b" anchor_x08)	
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_06b" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_05 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven05_06b" anchor_x08)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_06c_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_06c_fol)

	(sleep (camera_time))
	
	)
	
; X08 SCENE 06C -------------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant x08_foley_06c
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_06c_fol none 1)
	(print "x08 foley 06c start")
	)

(script dormant x08_0240_pnt
	(sleep 351)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0240_pnt 2401 1)
	(cinematic_subtitle x08_0240_pnt 5.5)
	)
	
; ---------------------------------------------------------------------

(script static void x08_06c_setup

	(wake x08_foley_06c)
	(wake x08_0240_pnt)
	
	)

(script static void x08_scene_06c
	
	(x08_06c_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_06c" none "anchor_flag_x08")
	
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_06c" false anchor_x08)
	(custom_animation_relative regret objects\characters\gravemind\floodregret\x08\x08 "regret_06c" false anchor_x08)
	(custom_animation_relative 2401 objects\characters\gravemind\monitor_flood_infected\x08\x08 "tangent_06c" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_06c" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_06c" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_06c" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_06c" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_05 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven05_06c" anchor_x08)
	
	(sleep (- (camera_time) 10))
	
	(object_create_anew gravemind)
	(object_uses_cinematic_lighting gravemind 1)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_07_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_07_fol)
	
	(sleep (camera_time))
	
	)
	
; X08 SCENE 07 --------------------------------------------------------
	
(script dormant x08_foley_07
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_07_fol none 1)
	(print "x08 foley 07 start")
	)

(script dormant x08_0250_grv
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0250_grv gravemind 1)
	(cinematic_subtitle x08_0250_grv 5)
	)
	
(script dormant x08_0260_grv
	(sleep 152)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0260_grv gravemind 1)
	(cinematic_subtitle x08_0260_grv 6)
	)	
	
(script dormant x08_0251_por
	(sleep 270)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0251_por regret 1)
	)
	
; ---------------------------------------------------------------------

(script static void x08_07_setup

	(wake x08_foley_07)
	(wake x08_0250_grv)
	(wake x08_0260_grv)
	(wake x08_0251_por)
	
	)

(script static void x08_scene_07
	
	(x08_07_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_07" none "anchor_flag_x08")
	
	(custom_animation_relative regret objects\characters\gravemind\floodregret\x08\x08 "regret_07" false anchor_x08)
	(custom_animation_relative 2401 objects\characters\gravemind\monitor_flood_infected\x08\x08 "tangent_07" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_07" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_capture_05 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven05_07" anchor_x08)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_08_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_08_fol)
	
	(sleep (camera_time))
	
	)
	
; X08 SCENE 08 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_08
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_08_fol none 1)
	(print "x08 foley 08 start")
	)

(script dormant x08_0270_grv
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0270_grv gravemind 1)
	(cinematic_subtitle x08_0270_grv 12)
	)
	
(script dormant x08_0280_grv
	(sleep 351)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0280_grv gravemind 1)
	(cinematic_subtitle x08_0280_grv 15)
	)
	
; ---------------------------------------------------------------------

(script static void x08_08_setup

	(object_destroy tentacle_capture_05)

	(wake x08_foley_08)
	(wake x08_0270_grv)
	(wake x08_0280_grv)
	
	)

(script static void x08_scene_08
	
	(x08_08_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_08" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_08" false anchor_x08)
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_08" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_08" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_08" anchor_x08)
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_08" anchor_x08)
	
;	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_08" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_08" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_08" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_08" anchor_x08)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_09_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_09_fol)
	
	(sleep (camera_time))
	
	)
	
; X08 SCENE 09 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_09
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_09_fol none 1)
	(print "x08 foley 09 start")
	)

; ---------------------------------------------------------------------

(script static void x08_scene_09

	(wake x08_foley_09)

	(object_destroy regret)
	(object_destroy 2401)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_09" none "anchor_flag_x08")
	
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_09" false anchor_x08)
	
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_09" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_09" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_09" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_09" anchor_x08)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_10_predict_stub)

	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_10_fol)
	
	(sleep (camera_time))
	
	)
	
; X08 SCENE 10 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_10
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_10_fol none 1)
	(print "x08 foley 10 start")
	)
	
(script dormant x08_0340_mas
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0340_mas chief 1)
	(cinematic_subtitle x08_0340_mas 5)
	)
	
(script dormant x08_0350_der
	(sleep 147)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0350_der dervish 1)
	(cinematic_subtitle x08_0350_der 6)
	)
	
(script dormant x08_0360_grv
	(sleep 323)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0360_grv gravemind 1)
	(cinematic_subtitle x08_0360_grv 8)
	)
	
(script dormant x08_0370_grv
	(sleep 561)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0370_grv gravemind 1)
	(cinematic_subtitle x08_0370_grv 9)
	)	

; ---------------------------------------------------------------------

(script static void x08_10_setup

	(wake x08_foley_10)
	(wake x08_0340_mas)
	(wake x08_0350_der)
	(wake x08_0360_grv)
	(wake x08_0370_grv)
	
	)

(script static void x08_scene_10
	
	(x08_10_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_10" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_10" false anchor_x08)
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_10" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_10" false anchor_x08)

	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_10" anchor_x08)
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_10" anchor_x08)
	
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_10" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_10" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_10" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_10" anchor_x08)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x08_11_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\music\x08_11_mus)
	(sound_impulse_predict sound\cinematics\07_highcharity\x08\foley\x08_11_fol)
	
	(sleep (camera_time))
	
	)

; X08 SCENE 11 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x08_foley_11
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\foley\x08_11_fol none 1)
	(print "x08 foley 11 start")
	)

(script dormant x08_score_11
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\x08\music\x08_11_mus none 1)
	(print "x08 score 11 start")
	)

(script dormant x08_0380_grv
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0380_grv gravemind 1)
	(cinematic_subtitle x08_0380_grv 7)
	)
	
(script dormant x08_0390_grv
	(sleep 207)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\x08_0390_grv gravemind 1)
	(cinematic_subtitle x08_0390_grv 8.5)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x08_teleport_build

	(sleep 470)
	(print "effect - teleport build")
	
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_01 "teleport06")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_02 "teleport06")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_03 "teleport06")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_04 "teleport06")
	
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_01 "teleport05")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_02 "teleport05")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_03 "teleport05")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_04 "teleport05")
	
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_01 "teleport04")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_02 "teleport04")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_03 "teleport04")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_04 "teleport04")
	
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_01 "teleport03")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_02 "teleport03")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_03 "teleport03")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_04 "teleport03")
	
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_01 "teleport02")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_02 "teleport02")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_03 "teleport02")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_04 "teleport02")
	
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_01 "teleport01")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_02 "teleport01")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_03 "teleport01")
	(effect_new_on_object_marker effects\objects\characters\gravemind\tentacle_teleport tentacle_capture_04 "teleport01")

	)

(script dormant x08_teleport_characters

	(sleep 470)
	(print "effect - teleport dervish")
	(effect_new_on_object_marker effects\gameplay\regret_teleport dervish "body")
	
	(sleep 5)
	(print "effect - teleport chief")
	(effect_new_on_object_marker effects\gameplay\regret_teleport chief "body")
	
	)
	
; ---------------------------------------------------------------------

(script static void x08_11_setup
	
	(wake x08_score_11)
	
	(wake x08_foley_11)
	(wake x08_0380_grv)
	(wake x08_0390_grv)
	
	(wake x08_teleport_build)
	(wake x08_teleport_characters)
	
	)
	
(script dormant x08_11_cleanup	
	(object_destroy chief)
	(object_destroy dervish)
	(object_destroy gravemind)
	(object_destroy tentacle_chief)
	(object_destroy tentacle_arbiter)
	(object_destroy_containing tentacle_capture)
	)

(script static void x08_scene_11
	
	(x08_11_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x08\x08 "x08_11" none "anchor_flag_x08")
	
	(custom_animation_relative chief objects\characters\masterchief\x08\x08 "chief_11" false anchor_x08)
	(custom_animation_relative dervish objects\characters\dervish\x08\x08 "dervish_11" false anchor_x08)
	(custom_animation_relative gravemind objects\characters\gravemind\x08\x08 "gm_mouth_11" false anchor_x08)

	(scenery_animation_start_relative tentacle_chief objects\characters\gravemind\tentacle_capture_masterchief\x08\x08 "tc_mc_11" anchor_x08)
	(scenery_animation_start_relative tentacle_arbiter objects\characters\gravemind\tentacle_capture_arbiter\x08\x08 "tc_arb_11" anchor_x08)
	
	(scenery_animation_start_relative tentacle_capture_01 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven01_11" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_02 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven02_11" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_03 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven03_11" anchor_x08)
	(scenery_animation_start_relative tentacle_capture_04 objects\characters\gravemind\tentacle_capture_driven\x08\x08 "tc_driven04_11" anchor_x08)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(wake x08_11_cleanup)
	
	(sleep 30)
	
	)

	
; X08 MASTER SCRIPT ===================================================
; =====================================================================


(script static void x08

	(texture_cache_flush)
	(geometry_cache_flush)

	(switch_bsp_by_name gravemind)
	(sleep 1)

	(x08_scene_01)
	(x08_scene_02)
	(x08_scene_03)
	(x08_scene_04)
	(x08_scene_05)
	(x08_scene_06a)
	(x08_scene_06b)
	(x08_scene_06c)
	(x08_scene_07)
	(x08_scene_08)
	(x08_scene_09)
	(x08_scene_10)
	(x08_scene_11)
	
	(rasterizer_bloom_override 0)
	
	)
	
; C07_INTRO SCENE 01 --------------------------------------------------
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c07_intro_cinematic_light_01
	
	(cinematic_lighting_set_primary_light 18 56 0.227451 0.129412 0.223529)
	(cinematic_lighting_set_secondary_light -26 134 0.196078 0.188235 0.286275) 
	(cinematic_lighting_set_ambient_light 0.180392 0.176471 0.207843)
	
	(object_uses_cinematic_lighting delta_halo 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script dormant c07_intro_01_problem_actors
	(print "problem actors")
	(object_create_anew delta_halo)
	(object_create_anew matte_substance)
	(object_create_anew matte_high_charity)
	(object_create_anew_containing intro_fleet)	
	(object_create_anew_containing stardust)	
	)

(script static void c07_intro_02_problem_actors
	
	(print "problem actors")
	
	(object_create_anew brute_intro_01)
	(object_create_anew brute_intro_02)
	(object_create_anew brute_intro_03)
	(object_create_anew brute_intro_04)
	(object_create_anew brute_05)
	(object_create_anew brute_06)
	(object_create_anew grunt_01)
	(object_create_anew grunt_02)
	(object_create_anew grunt_03)
	(object_create_anew grunt_04)
	(object_create_anew grunt_05)
	(object_create_anew jackal_01)
	(object_create_anew jackal_02)
	
	(object_create_anew_containing intro_pike)
	(object_create_anew_containing intro_crowd)
	
	(object_cinematic_lod brute_intro_01 true)
	(object_cinematic_lod brute_intro_02 true)
	(object_cinematic_lod brute_intro_03 true)
	(object_cinematic_lod brute_intro_04 true)
	(object_cinematic_lod brute_05 true)
	(object_cinematic_lod brute_06 true)
	(object_cinematic_lod grunt_01 true)
	(object_cinematic_lod grunt_02 true)
	(object_cinematic_lod grunt_03 true)
	(object_cinematic_lod grunt_04 true)
	(object_cinematic_lod grunt_05 true)
	(object_cinematic_lod jackal_01 true)
	(object_cinematic_lod jackal_02 true)
	
	)
	
; ---------------------------------------------------------------------
	
(script static void c07_intro_01_cleanup

	(object_destroy delta_halo)
	(object_destroy matte_substance)
	(object_destroy matte_high_charity)	
	(object_destroy_containing fleet)
	(object_destroy_containing stardust)
	
	)

(script static void c07_intro_scene_01

	(fade_out 0 0 0 0)
	
	(wake c07_intro_cinematic_light_01)

	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(07_intro_01_predict_stub)
	(wake c07_intro_01_problem_actors)	
	(sleep prediction_offset)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intro\07_intro "07_intro_01" none "anchor_flag_intro_a")
	
	(scenery_animation_start_relative delta_halo scenarios\objects\forerunner\industrial\halo\07_intro\07_intro "halo_01" anchor_intro_a)	
	(scenery_animation_start_relative matte_high_charity objects\cinematics\matte_paintings\high_charity_exterior\07_intro\07_intro "high_charity_exterior_01" anchor_intro_a)
	(scenery_animation_start_relative matte_substance objects\cinematics\matte_paintings\substance_space\07_intro\07_intro "substance_01" anchor_intro_a)
	(scenery_animation_start_relative stardust_01 objects\cinematics\matte_paintings\high_charity_stardust\07_intro\07_intro "stardust01_01" anchor_intro_a)
	(scenery_animation_start_relative stardust_02 objects\cinematics\matte_paintings\high_charity_stardust\07_intro\07_intro "stardust02_01" anchor_intro_a)
	
	(sleep 15)
	
	(fade_in 0 0 0 60)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intro_02_predict_stub)
	(c07_intro_02_problem_actors)
	(cinematic_screen_effect_start 1)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intro\foley\c07_intro_02_fol)
	
	(sleep (- (camera_time) 15))	
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c07_intro_01_cleanup)
	
	)
	
; C07_INTRO SCENE 02 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_intro_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intro\foley\c07_intro_02_fol none 1)
	(print "c07_intro foley 02 start")
	)

(script dormant c07_1010_pot
	(sleep 200)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_1010_pot none 1)
	(cinematic_subtitle c07_1010_pot 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c07_intro_dof_02
	(time_code_reset)

	(cinematic_screen_effect_set_depth_of_field 2 0 0 0 1 1 0)
	(print "rack focus")
	
	(sleep 83)
	(cinematic_screen_effect_set_depth_of_field 2 0 1 .5 1 0 .5)
	(print "rack focus")
	
	(sleep 56)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	)
	
(script dormant lightmap_shadows_on
	(sleep 141)
	(print "enable lightmap shadows")
	(cinematic_lightmap_shadow_enable)
	)

(script dormant c07_intro_cinematic_light_02
	
	(cinematic_lighting_set_primary_light 25 190 0.470588 0.368627 0.541176)
	(cinematic_lighting_set_secondary_light -36 0 0.160784 0.176471 0.345098)
	(cinematic_lighting_set_ambient_light 0.105882 0.0941177 0.0784314)
	
	(object_uses_cinematic_lighting brute_intro_01 1)
	(object_uses_cinematic_lighting brute_intro_02 1)
	(object_uses_cinematic_lighting brute_intro_03 1)
	(object_uses_cinematic_lighting brute_intro_04 1)
	(object_uses_cinematic_lighting brute_05 1)
	(object_uses_cinematic_lighting brute_06 1)
	(object_uses_cinematic_lighting grunt_01 1)
	(object_uses_cinematic_lighting grunt_02 1)
	(object_uses_cinematic_lighting grunt_03 1)
	(object_uses_cinematic_lighting grunt_04 1)
	(object_uses_cinematic_lighting grunt_05 1)
	(object_uses_cinematic_lighting jackal_01 1)
	(object_uses_cinematic_lighting jackal_02 1)
	
	(object_uses_cinematic_lighting intro_pike_01 1)
	(object_uses_cinematic_lighting intro_pike_02 1)
	(object_uses_cinematic_lighting intro_pike_03 1)
	(object_uses_cinematic_lighting intro_pike_04 1)
	(object_uses_cinematic_lighting intro_pike_05 1)
	(object_uses_cinematic_lighting intro_pike_06 1)
	
	(object_uses_cinematic_lighting intro_crowd_01 1)
	(object_uses_cinematic_lighting intro_crowd_02 1)
	(object_uses_cinematic_lighting intro_crowd_03 1)
	(object_uses_cinematic_lighting intro_crowd_04 1)
	(object_uses_cinematic_lighting intro_crowd_05 1)
	(object_uses_cinematic_lighting intro_crowd_06 1)
	(object_uses_cinematic_lighting intro_crowd_07 1)
	(object_uses_cinematic_lighting intro_crowd_08 1)
	(object_uses_cinematic_lighting intro_crowd_09 1)
	(object_uses_cinematic_lighting intro_crowd_10 1)
	(object_uses_cinematic_lighting intro_crowd_11 1)
	(object_uses_cinematic_lighting intro_crowd_12 1)
	(object_uses_cinematic_lighting intro_crowd_13 1)
	(object_uses_cinematic_lighting intro_crowd_14 1)

	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void c07_intro_03_problem_actors

	(print "problem actors")
	
	(object_create_anew truth_intro)
	(object_create_anew mercy_intro)
	(object_create_anew throne_truth_intro)
	(object_create_anew throne_mercy_intro)
	(object_create_anew index_intro)
	
	(object_cinematic_lod truth_intro true)
	(object_cinematic_lod mercy_intro true)
	(object_cinematic_lod throne_truth_intro true)
	(object_cinematic_lod throne_mercy_intro true)
	(object_cinematic_lod index_intro true)
	
	(objects_attach truth_intro "driver" throne_truth_intro "driver_cinematic")
	(objects_attach mercy_intro "driver" throne_mercy_intro "driver_cinematic")
	
	)
	
; ---------------------------------------------------------------------

(script static void c07_intro_02_setup
	
	(wake c07_intro_foley_02)
	(wake c07_1010_pot)
	
	(wake lightmap_shadows_on)
	(wake c07_intro_dof_02)
	
	(wake c07_intro_cinematic_light_02)
	
		(if (= "legendary" (game_difficulty_get_real))
		(begin
			(object_create_anew grunt_card)
		))
	
	)
	
(script static void c07_intro_02_cleanup

	(object_destroy grunt_03)
	(object_destroy grunt_04)
	(object_destroy grunt_05)
	(object_destroy jackal_01)
	(object_destroy jackal_02)
	(object_destroy grunt_card)
	(object_destroy_containing intro_crowd)
	
	)

(script static void c07_intro_scene_02
	
	(c07_intro_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intro\07_intro "07_intro_02" none "anchor_flag_intro_c")

	(custom_animation_relative brute_intro_01 objects\characters\brute\07_intro\07_intro "brute01_02" false anchor_intro_c)
	(custom_animation_relative brute_intro_02 objects\characters\brute\07_intro\07_intro "brute02_02" false anchor_intro_c)
	(custom_animation_relative brute_intro_03 objects\characters\brute\07_intro\07_intro "brute03_02" false anchor_intro_c)
	(custom_animation_relative brute_intro_04 objects\characters\brute\07_intro\07_intro "brute04_02" false anchor_intro_c)
	(custom_animation_relative brute_05 objects\characters\brute\07_intro\07_intro "brute05_02" false anchor_intro_c)
	(custom_animation_relative brute_06 objects\characters\brute\07_intro\07_intro "brute06_02" false anchor_intro_c)
	
	(custom_animation_relative grunt_01 objects\characters\grunt\07_intro\07_intro "grunt01_02" false anchor_intro_c)
	(custom_animation_relative grunt_02 objects\characters\grunt\07_intro\07_intro "grunt02_02" false anchor_intro_c)
	(custom_animation_relative grunt_03 objects\characters\grunt\07_intro\07_intro "grunt03_02" false anchor_intro_c)
	(custom_animation_relative grunt_04 objects\characters\grunt\07_intro\07_intro "grunt04_02" false anchor_intro_c)
	(custom_animation_relative grunt_05 objects\characters\grunt\07_intro\07_intro "grunt05_02" false anchor_intro_c)
	
	(custom_animation_relative jackal_01 objects\characters\jackal\07_intro\07_intro "jackal01_02" false anchor_intro_c)
	(custom_animation_relative jackal_02 objects\characters\jackal\07_intro\07_intro "jackal02_02" false anchor_intro_c)
	
	(scenery_animation_start_relative intro_pike_01 objects\weapons\melee\pike\07_intro\07_intro "pike01_02" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_02 objects\weapons\melee\pike\07_intro\07_intro "pike02_02" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_03 objects\weapons\melee\pike\07_intro\07_intro "pike03_02" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_04 objects\weapons\melee\pike\07_intro\07_intro "pike04_02" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_05 objects\weapons\melee\pike\07_intro\07_intro "pike05_02" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_06 objects\weapons\melee\pike\07_intro\07_intro "pike06_02" anchor_intro_c)

;	safety white
	(sleep 5)
	
	(fade_in 1 1 1 15)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intro_03_predict_stub)
	(c07_intro_03_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intro\foley\c07_intro_03_fol)
	
	(sleep (camera_time))
	
	(c07_intro_02_cleanup)
	
	)
	
; C07_INTRO SCENE 03 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_intro_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intro\foley\c07_intro_03_fol none 1)
	(print "c07_intro foley 03 start")
	)

(script dormant c07_1020_pot
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_1020_pot none 1)
	(cinematic_subtitle c07_1020_pot 6)
	
	(unit_set_emotional_state truth_intro pensive .25 0)
	(print "truth - pensive .25 0")
	
	)
	
(script dormant c07_1030_pot
	(sleep 181)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_1030_pot truth_intro 1)
	(cinematic_subtitle c07_1030_pot 9)
	
	(sleep 180)
	(unit_set_emotional_state truth_intro happy .25 90)
	(print "truth - happy .25 90")
	
	)
	
(script dormant c07_1040_pot
	(sleep 451)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_1040_pot truth_intro 1)
	(cinematic_subtitle c07_1040_pot 6)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c07_intro_03_fov
	(time_code_reset)
	
	(sleep 178)
	(print "change fov")
	(camera_set_field_of_view 40 0)
	
	(time_code_reset)
	
	(sleep 166)
	(print "change fov")
	(camera_set_field_of_view 50 0)
	
	)

(script dormant c07_intro_cinematic_light_03
	
	(cinematic_lighting_set_primary_light 44 166 0.317647 0.282353 0.376471)
	(cinematic_lighting_set_secondary_light -69 348 0.290196 0.227451 0.537255)
	(cinematic_lighting_set_ambient_light 0.054902 0.0470588 0.0392157)
	
	(object_uses_cinematic_lighting truth_intro 1)
	(object_uses_cinematic_lighting mercy_intro 1)
	(object_uses_cinematic_lighting throne_truth_intro 1)
	(object_uses_cinematic_lighting throne_mercy_intro 1)
	(object_uses_cinematic_lighting index_intro 1)
	
;	(render_lights_enable_cinematic_shadow 1 truth_intro head .4)
;	(render_lights_enable_cinematic_shadow 1 mercy_intro head .4)

	)

; ---------------------------------------------------------------------

(script dormant texture_camera_start
	(time_code_reset)
	(sleep 178)
	(print "texture camera start")
	(texture_camera_set_object_marker texture_camera marker 50)
	
	(object_hide mercy true)
	(object_hide throne_mercy true)
	(object_hide brute_intro_01 true)
	(object_hide brute_intro_02 true)
	(object_hide brute_intro_03 true)
	(object_hide brute_intro_04 true)
	(object_hide brute_05 true)
	(object_hide brute_06 true)
	
	)
	
(script dormant texture_camera_stop
	(sleep 344)
	(print "texture camera stop")
	(texture_camera_off)
	
	(object_hide mercy false)
	(object_hide throne_mercy false)
	(object_hide brute_intro_01 false)
	(object_hide brute_intro_02 false)
	(object_hide brute_intro_03 false)
	(object_hide brute_intro_04 false)
	(object_hide brute_05 false)
	(object_hide brute_06 false)
	
	)

(script static void c07_intro_03_setup

	(cinematic_lightmap_shadow_disable)

	(object_create_anew chief_needler)
	(object_create_anew texture_camera)
	(object_create_anew holo_cam)
	
	(object_cinematic_lod chief_needler true)
	(object_cinematic_lod holo_cam true)
	
	(objects_attach grunt_02 "right_hand" chief_needler "")
	
	(wake c07_intro_foley_03)
	
	(wake c07_1020_pot)
	(wake c07_1030_pot)
	(wake c07_1040_pot)
	
	(wake c07_intro_03_fov)
	(wake texture_camera_start)
	(wake texture_camera_stop)
	
	(wake c07_intro_cinematic_light_03)
	
	)
	
(script static void c07_intro_03_cleanup

	(object_destroy brute_intro_03)
	(object_destroy brute_intro_04)
	(object_destroy brute_05)
	(object_destroy brute_06)

	)

(script static void c07_intro_scene_03
	
	(c07_intro_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intro\07_intro "07_intro_03" none "anchor_flag_intro_c")

	(custom_animation_relative truth_intro objects\characters\prophet\07_intro\07_intro "truth_03" false anchor_intro_c)
	(custom_animation_relative mercy_intro objects\characters\prophet\07_intro\07_intro "mercy_03" false anchor_intro_c)

	(custom_animation_relative brute_intro_01 objects\characters\brute\07_intro\07_intro "brute01_03" false anchor_intro_c)
	(custom_animation_relative brute_intro_02 objects\characters\brute\07_intro\07_intro "brute02_03" false anchor_intro_c)
	(custom_animation_relative brute_intro_03 objects\characters\brute\07_intro\07_intro "brute03_03" false anchor_intro_c)
	(custom_animation_relative brute_intro_04 objects\characters\brute\07_intro\07_intro "brute04_03" false anchor_intro_c)
	(custom_animation_relative brute_05 objects\characters\brute\07_intro\07_intro "brute05_03" false anchor_intro_c)
	(custom_animation_relative brute_06 objects\characters\brute\07_intro\07_intro "brute06_03" false anchor_intro_c)
	
	(custom_animation_relative grunt_01 objects\characters\grunt\07_intro\07_intro "grunt01_03" false anchor_intro_c)
	(custom_animation_relative grunt_02 objects\characters\grunt\07_intro\07_intro "grunt02_03" false anchor_intro_c)
	
	(scenery_animation_start_relative texture_camera objects\cinematics\texture_camera\07_intro\07_intro "tex_camera_03" anchor_intro_c)	
	(scenery_animation_start_relative holo_cam objects\cinematics\covenant\holo_cam\07_intro\07_intro "holo_cam_03" anchor_intro_c)
	(scenery_animation_start_relative index_intro scenarios\objects\forerunner\industrial\index\index_full\07_intro\07_intro "index_03" anchor_intro_c)
	
	(scenery_animation_start_relative intro_pike_01 objects\weapons\melee\pike\07_intro\07_intro "pike01_03" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_02 objects\weapons\melee\pike\07_intro\07_intro "pike02_03" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_03 objects\weapons\melee\pike\07_intro\07_intro "pike03_03" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_04 objects\weapons\melee\pike\07_intro\07_intro "pike04_03" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_05 objects\weapons\melee\pike\07_intro\07_intro "pike05_03" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_06 objects\weapons\melee\pike\07_intro\07_intro "pike06_03" anchor_intro_c)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intro_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intro\foley\c07_intro_04_fol)

	(sleep (camera_time))
	
	(c07_intro_03_cleanup)
	
	)
	
; C07_INTRO SCENE 04 --------------------------------------------------

(script dormant c07_intro_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intro\foley\c07_intro_04_fol none 1)
	(print "c07_intro foley 04 start")
	)

(script dormant c07_1050_pot
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_1050_pot truth_intro 1)
	(cinematic_subtitle c07_1050_pot 5)
	
	(unit_set_emotional_state truth_intro happy .25 0)
	(unit_set_emotional_state truth_intro happy .5 60)
	(print "truth - happy .5 60")
	
	)

(script dormant c07_1060_mas
	(sleep 217)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_1060_mas chief 1)
	(cinematic_subtitle c07_1060_mas 1)
	)
	
(script dormant c07_1070_crz
	(sleep 236)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_1070_crz grunt_01 1)
	(cinematic_subtitle c07_1070_crz 2)
	
	(unit_set_emotional_state truth_intro shocked .75 0)
	(print "truth - shocked .75 0")
	
	)
	
(script dormant c07_1080_pot
	(sleep 412)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_1080_pot truth_intro 1)
	(cinematic_subtitle c07_1080_pot 2)
	
	(sleep 30)
	
	(unit_set_emotional_state truth_intro arrogant .5 30)
	(print "truth - arrogant .5 30")
	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_chief_teleport
	(print "effect - teleport")
	(effect_new_on_object_marker effects\gameplay\cinematic_teleport teleport "marker")
	)

; ---------------------------------------------------------------------

(script dormant intro_chief_arrival
	(sleep 142)
	(print "chief arrival")
	(custom_animation_relative chief_intro objects\characters\masterchief\07_intro\07_intro "chief_04" false anchor_intro_c)
	)
	
(script dormant needler_attach
	(time_code_reset)
	(sleep 230)
	(objects_detach grunt_02 chief_needler)
	(print "needler detach")
	(sleep 80)
	(objects_attach chief_intro "right_hand" chief_needler "")
	(print "needler attach")
	)

(script static void c07_intro_04_setup

	(object_create_anew teleport)
	(object_create_anew chief_intro)
	
	(object_cinematic_lod chief_intro true)
	
	(object_uses_cinematic_lighting chief_intro 1)
	(render_lights_enable_cinematic_shadow 1 chief_intro head .4)
	
	(wake c07_intro_foley_04)

	(wake c07_1050_pot)
	(wake c07_1060_mas)
	(wake c07_1070_crz)
	(wake c07_1080_pot)
	
	(wake intro_chief_arrival)
	(wake needler_attach)
	
	(wake effect_chief_teleport)
	
	)
	
(script static void c07_intro_04_cleanup

	(object_destroy chief_intro)
	(object_destroy_containing truth)
	(object_destroy_containing mercy)
	(object_destroy brute_intro_01)
	(object_destroy brute_intro_02)
	(object_destroy grunt_01)
	(object_destroy grunt_02)
	(object_destroy index_intro)
	(object_destroy holo_cam)
	(object_destroy teleport)
	(object_destroy_containing intro_pike)
	(object_destroy chief_needler)

	)

(script static void c07_intro_scene_04
	
	(c07_intro_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intro\07_intro "07_intro_04" none "anchor_flag_intro_c")
	
	(custom_animation_relative truth_intro objects\characters\prophet\07_intro\07_intro "truth_04" false anchor_intro_c)
	(custom_animation_relative mercy_intro objects\characters\prophet\07_intro\07_intro "mercy_04" false anchor_intro_c)

	(custom_animation_relative brute_intro_01 objects\characters\brute\07_intro\07_intro "brute01_04" false anchor_intro_c)
	(custom_animation_relative brute_intro_02 objects\characters\brute\07_intro\07_intro "brute02_04" false anchor_intro_c)
	
	(custom_animation_relative grunt_01 objects\characters\grunt\07_intro\07_intro "grunt01_04" false anchor_intro_c)
	(custom_animation_relative grunt_02 objects\characters\grunt\07_intro\07_intro "grunt02_04" false anchor_intro_c)
	
	(scenery_animation_start_relative index_intro scenarios\objects\forerunner\industrial\index\index_full\07_intro\07_intro "index_04" anchor_intro_c)
	(scenery_animation_start_relative texture_camera objects\cinematics\texture_camera\07_intro\07_intro "tex_camera_04" anchor_intro_c)	
	(scenery_animation_start_relative holo_cam objects\cinematics\covenant\holo_cam\07_intro\07_intro "holo_cam_04" anchor_intro_c)
	
	(scenery_animation_start_relative intro_pike_01 objects\weapons\melee\pike\07_intro\07_intro "pike01_04" anchor_intro_c)
	(scenery_animation_start_relative intro_pike_02 objects\weapons\melee\pike\07_intro\07_intro "pike02_04" anchor_intro_c)

	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c07_intro_04_cleanup)
	
	)

; C07_INTRO MASTER SCRIPT =============================================
; =====================================================================

(script static void c07_intro

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(sound_class_set_gain amb 0 15)

	(switch_bsp_by_name high_0)
	(sleep 1)
	
	(c07_intro_scene_01)
	
	(sound_class_set_gain amb 1 15)
	
	(c07_intro_scene_02)
	(c07_intro_scene_03)
	(c07_intro_scene_04)
		
	)


; C07_INTRA1 SCENE 01 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c07_intra1_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\music\c07_intra1_01_mus none 1)
	(print "c07_intra1 score 01 start")
	)

(script dormant c07_intra1_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_01_fol none 1)
	(print "c07_intra1 foley 01 start")
	)

(script dormant c07_2010_tar
	(sleep 128)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2010_tar tartarus 1)
	(cinematic_subtitle c07_2010_tar 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c07_intra1_cinematic_light_01
	
     (cinematic_lighting_set_primary_light 23 74 0.258824 0.270588 0.368627)
     (cinematic_lighting_set_secondary_light -40 276 0.407843 0.345098 0.317647)
     (cinematic_lighting_set_ambient_light 0.0431373 0.0470588 0.0666667)

	(object_uses_cinematic_lighting truth 1)
	(object_uses_cinematic_lighting mercy 1)
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting monitor 1)
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting brute_03 1)
	(object_uses_cinematic_lighting brute_04 1)
	(object_uses_cinematic_lighting throne_truth 1)
	(object_uses_cinematic_lighting throne_mercy 1)
	(object_uses_cinematic_lighting phantom_01 1)
	(object_uses_cinematic_lighting phantom_02 1)
	(object_uses_cinematic_lighting phantom_03 1)
	(object_uses_cinematic_lighting hammer 1)
	(object_uses_cinematic_lighting intra_pike_01 1)
	(object_uses_cinematic_lighting intra_pike_02 1)
	
	)

; ---------------------------------------------------------------------

(script dormant hide_pikes 
	(time_code_reset)
	(sleep 300)
	(print "hide pikes")
	(object_hide intra_pike_01 true)
	(object_hide intra_pike_02 true)
	)
	
(script dormant show_pikes 
	(sleep 400)
	(print "show pikes")
	(object_hide intra_pike_01 false)
	(object_hide intra_pike_02 false)
	)
	
(script dormant johnson_emotion
	(unit_set_emotional_state johnson angry .25 0)
	(sleep 277)
	(unit_set_emotional_state johnson pain .5 30)
	(print "johnson - pain .5 30")
	)
	
(script dormant miranda_emotion
	(unit_set_emotional_state miranda shocked .1 0)
	(sleep 375)
	(unit_set_emotional_state miranda shocked .4 60)
	(print "miranda - shocked .25 60")
	)

(script static void c07_intra1_01_setup

	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_create_anew truth)
	(object_create_anew mercy)
	(object_create_anew tartarus)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew brute_03)
	(object_create_anew brute_04)
	(object_create_anew monitor)
	(object_create_anew hammer)
	(object_create_anew throne_truth)
	(object_create_anew throne_mercy)
	(object_create_anew phantom_01)
	(object_create_anew phantom_02)
	(object_create_anew phantom_03)
	(object_create_anew_containing intra_pike)
	
	(object_set_function_variable monitor talking 0 0)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod brute_03 true)
	(object_cinematic_lod brute_04 true)
	(object_cinematic_lod monitor true)
	(object_cinematic_lod hammer true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_mercy true)
	(object_cinematic_lod phantom_01 true)
	(object_cinematic_lod phantom_02 true)
	(object_cinematic_lod phantom_03 true)
	
	(objects_attach truth "driver" throne_truth "driver_cinematic")
	(objects_attach mercy "driver" throne_mercy "driver_cinematic")
	
	(wake c07_intra1_score_01)
	(wake c07_intra1_foley_01)
	
	(wake c07_2010_tar)
	
	(wake johnson_emotion)
	(wake miranda_emotion)
	
	(wake hide_pikes)
	(wake show_pikes)

	(wake c07_intra1_cinematic_light_01)
	
	)
	
(script static void c07_intra1_01_cleanup

	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy monitor)
	(object_destroy brute_01)
	(object_destroy brute_02)
	
	)

(script static void c07_intra1_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(07_intra1_01_predict_stub)
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_01_fol)
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\music\c07_intra1_01_mus)
	(sleep prediction_offset)
	
	(c07_intra1_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intra1\07_intra1 "07_intra1_01" none "anchor_flag_intra1")

	(custom_animation_relative miranda objects\characters\miranda\07_intra1\07_intra1 "miranda_01" false anchor_intra1)
	(custom_animation_relative johnson objects\characters\marine\07_intra1\07_intra1 "johnson_01" false anchor_intra1)
	(custom_animation_relative truth objects\characters\prophet\07_intra1\07_intra1 "truth_01" false anchor_intra1)
	(custom_animation_relative mercy objects\characters\prophet\07_intra1\07_intra1 "mercy_01" false anchor_intra1)
	(custom_animation_relative monitor objects\characters\monitor\07_intra1\07_intra1 "monitor_01" false anchor_intra1)
	
	(custom_animation_relative tartarus objects\characters\brute\07_intra1\07_intra1 "tartarus_01" false anchor_intra1)
	(custom_animation_relative brute_01 objects\characters\brute\07_intra1\07_intra1 "brute01_01" false anchor_intra1)
	(custom_animation_relative brute_02 objects\characters\brute\07_intra1\07_intra1 "brute02_01" false anchor_intra1)
	(custom_animation_relative brute_03 objects\characters\brute\07_intra1\07_intra1 "brute03_01" false anchor_intra1)
	(custom_animation_relative brute_04 objects\characters\brute\07_intra1\07_intra1 "brute04_01" false anchor_intra1)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\07_intra1\07_intra1 "hammer_01" anchor_intra1)
	(scenery_animation_start_relative intra_pike_01 objects\weapons\melee\pike\07_intra1\07_intra1 "pike01_01" anchor_intra1)
	(scenery_animation_start_relative intra_pike_02 objects\weapons\melee\pike\07_intra1\07_intra1 "pike02_01" anchor_intra1)
	
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom1_01" false anchor_intra1)
	(custom_animation_relative phantom_02 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom2_01" false anchor_intra1)
	(custom_animation_relative phantom_03 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom3_01" false anchor_intra1)
	
	(fade_in 1 1 1 15)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intra1_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_02_fol)

	(sleep (camera_time))
	
	(c07_intra1_01_cleanup)
	
	)
	
; C07_INTRA1 SCENE 02 -------------------------------------------------

(script dormant c07_intra1_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_02_fol none 1)
	(print "c07_intra1 foley 02 start")
	)

(script dormant c07_2020_pot
	(sleep 52)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2020_pot truth 1)
	(cinematic_subtitle c07_2020_pot 4)
	)

(script dormant c07_2030_tar
	(sleep 163)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2030_tar tartarus 1)
	(cinematic_subtitle c07_2030_tar 4)
	
	(sleep 90)
	(print "spawn infection-forms")
	(ai_place c07_infection)
	
	)
	
(script dormant c07_intra1_02_fov_01
	(sleep 347)
	(print "fov change: 60 -> 8 over 20 ticks")
	(camera_set_field_of_view 8 20)
	)

(script static void c07_intra1_02_setup

	(object_cannot_take_damage truth)
	(object_cannot_take_damage mercy)
	(object_cannot_take_damage tartarus)
	(object_cannot_take_damage brute_03)
	(object_cannot_take_damage brute_04)
	(object_cannot_take_damage infection_form_01)
	(object_cannot_take_damage infection_form_02)

	(object_create_anew infection_form_01)
	(object_create_anew index)
	
	(object_cinematic_lod infection_form_01 true)
	(object_cinematic_lod index true)

	(wake c07_intra1_foley_02)
	
	(wake c07_2020_pot)
	(wake c07_2030_tar)
	
;	(wake x04_01_dof_1)
	
	(wake c07_intra1_02_fov_01)
	
	)
	
(script static void c07_intra1_02_cleanup
	
	(objects_detach mercy throne_mercy)
	(object_destroy mercy)
	(object_hide index true)
	
	)

(script static void c07_intra1_scene_02
	
	(c07_intra1_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intra1\07_intra1 "07_intra1_02" none "anchor_flag_intra1")

	(custom_animation_relative truth objects\characters\prophet\07_intra1\07_intra1 "truth_02" false anchor_intra1)
	(custom_animation_relative mercy objects\characters\prophet\07_intra1\07_intra1 "mercy_02" false anchor_intra1)
	
	(custom_animation_relative tartarus objects\characters\brute\07_intra1\07_intra1 "tartarus_02" false anchor_intra1)
	(custom_animation_relative brute_03 objects\characters\brute\07_intra1\07_intra1 "brute03_02" false anchor_intra1)
	(custom_animation_relative brute_04 objects\characters\brute\07_intra1\07_intra1 "brute04_02" false anchor_intra1)
	
	(custom_animation_relative infection_form_01 objects\characters\flood_infection\07_intra1\07_intra1 "infection01_02" false anchor_intra1)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\07_intra1\07_intra1 "hammer_02" anchor_intra1)
	(scenery_animation_start_relative index scenarios\objects\forerunner\industrial\index\index_full\07_intra1\07_intra1 "index_02" anchor_intra1)
	(scenery_animation_start_relative intra_pike_01 objects\weapons\melee\pike\07_intra1\07_intra1 "pike01_02" anchor_intra1)

	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom1_02" false anchor_intra1)
	(custom_animation_relative phantom_02 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom2_02" false anchor_intra1)
	(custom_animation_relative phantom_03 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom3_02" false anchor_intra1)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intra1_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_03_fol)

	(sleep (camera_time))
	
	(c07_intra1_02_cleanup)

	)
	
; C07_INTRA1 SCENE 03 -------------------------------------------------

(script dormant c07_intra1_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_03_fol none 1)
	(print "c07_intra1 foley 03 start")
	)

(script dormant c07_2040_pom
	(sleep 295)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2040_pom mercy 1)
	(cinematic_subtitle c07_2040_pom 4)
	
	(unit_set_emotional_state mercy scared 1 30)
	(print "mercy - scared 1 30")
	
	)

; LIGHTING & EFFECTS --------------------------------------------------
	
(script dormant effect_infection_burrow
	(sleep 302)
	(print "effect - infection burrow")
	(effect_new_on_object_marker effects\cinematics\07\flood_burrowing infection_form_02 "mouth")
	)
	
(script dormant infection_pop_01
	(time_code_reset)
	(sleep 162)
	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_form_01 "")
	(object_hide infection_form_01 true)
	(sleep 51)
	(object_hide infection_form_01 false)
	(sleep 5)
	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_form_01 "")
	(object_hide infection_form_01 true)
	)	
	
(script dormant infection_pop_02
	(sleep 171)
	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_form_02 "")
	(object_hide infection_form_02 true)
	(sleep 2)
	(object_hide infection_form_02 false)
	(sleep 7)
	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_form_02 "")
	(object_hide infection_form_02 true)
	(sleep 9)
	(object_hide infection_form_02 false)
	(sleep 17)
	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_form_02 "")
	(object_hide infection_form_02 true)
	(sleep 10)
	(object_hide infection_form_02 false)
	)	
	
;(script dormant infection_pop_03
;	(sleep 178)
;	(print "pop 3")
;	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_form_02 "")
;	(sleep 1)
;	(object_hide infection_form_02 true)	
;	)	
	
;(script dormant infection_pop_04
;	(sleep 203)
;	(print "pop 4")
;	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_form_02 "")
;	)

;(script dormant infection_pop_05
;	(sleep 214)
;	(print "pop 5")
;	(effect_new_on_object_marker effects\objects\characters\flood_infection\body_depleted infection_form_01 "")
;	(sleep 1)
;	(object_hide infection_form_01 true)
;	)

;(script dormant hide_seek_if_02

;pops on frame 171
;reappears on frame 173
;pops on frame 180
;reappears on frame 189
;pops on frame 206
;
;	)
	
; ---------------------------------------------------------------------

(script dormant kill_infection_forms
	(sleep 158)
	(print "erase infection forms")
	(ai_erase c07_infection)
	)

(script dormant delete_mercy_throne
	(sleep 308)
	(print "destroy mercy's throne")
	(object_destroy throne_mercy)
	)

(script static void c07_intra1_03_setup

	(object_create_anew mercy_no_crown)
	(object_create_anew infection_form_02)

	(object_cinematic_lod mercy_no_crown true)
	(object_cinematic_lod infection_form_02 true)
	
	(object_uses_cinematic_lighting mercy_no_crown 1)
	(object_uses_cinematic_lighting infection_form_02 1)
	
	(objects_attach mercy_no_crown "driver" throne_mercy "driver_cinematic")

	(wake c07_intra1_foley_03)
	
	(wake c07_2040_pom)
	
	(wake delete_mercy_throne)
	(wake kill_infection_forms)
	
	(wake infection_pop_01)
	(wake infection_pop_02)
;	(wake infection_pop_03)
;	(wake infection_pop_04)
;	(wake infection_pop_05)
	
	(wake effect_infection_burrow)
	
	)
	
(script static void c07_intra1_03_cleanup
	
	(object_destroy infection_form_02)
	(object_destroy hammer)
	(object_destroy_containing intra_pike)
	
	)

(script static void c07_intra1_scene_03
	
	(c07_intra1_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intra1\07_intra1 "07_intra1_03" none "anchor_flag_intra1")
	
	(camera_set_field_of_view 60 0)

	(custom_animation_relative truth objects\characters\prophet\07_intra1\07_intra1 "truth_03" false anchor_intra1)
	(custom_animation_relative mercy_no_crown objects\characters\prophet\07_intra1\07_intra1 "mercy_03" false anchor_intra1)
	
	(custom_animation_relative tartarus objects\characters\brute\07_intra1\07_intra1 "tartarus_03" false anchor_intra1)
	(custom_animation_relative brute_03 objects\characters\brute\07_intra1\07_intra1 "brute03_03" false anchor_intra1)
	(custom_animation_relative brute_04 objects\characters\brute\07_intra1\07_intra1 "brute04_03" false anchor_intra1)
	
	(custom_animation_relative infection_form_01 objects\characters\flood_infection\07_intra1\07_intra1 "infection01_03" false anchor_intra1)
	(custom_animation_relative infection_form_02 objects\characters\flood_infection\07_intra1\07_intra1 "infection02_03" false anchor_intra1)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\07_intra1\07_intra1 "hammer_03" anchor_intra1)
	(scenery_animation_start_relative intra_pike_01 objects\weapons\melee\pike\07_intra1\07_intra1 "pike01_03" anchor_intra1)
	(scenery_animation_start_relative intra_pike_02 objects\weapons\melee\pike\07_intra1\07_intra1 "pike02_03" anchor_intra1)
	
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom1_03" false anchor_intra1)
	(custom_animation_relative phantom_02 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom2_03" false anchor_intra1)
	(custom_animation_relative phantom_03 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom3_03" false anchor_intra1)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(07_intra1_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_04_fol)

	(sleep (camera_time))
	
	(c07_intra1_03_cleanup)

	)
	
; C07_INTRA1 SCENE 04 -------------------------------------------------

(script dormant c07_intra1_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\07_highcharity\c07_intra1\foley\c07_intra1_04_fol none 1)
	(print "c07_intra1 foley 04 start")
	)

(script dormant c07_2050_pot
	(sleep 64)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2050_pot truth 1)
	(cinematic_subtitle c07_2050_pot 1)
	
	)

(script dormant c07_2060_pot
	(sleep 132)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2060_pot truth 1)
	(cinematic_subtitle c07_2060_pot 3)
	
	(sleep 45)
	
	(unit_set_emotional_state tartarus pensive .5 60)
	(print "tartarus - shocked .5 60")
	
	(unit_set_emotional_state mercy shocked 1 0)
	(print "mercy - shocked 1 0")
	
	)
	
(script dormant c07_2070_pot
	(sleep 231)
	(sound_impulse_start sound\dialog\levels\07_highcharity\cinematic\c07_2070_pot truth 1)
	(cinematic_subtitle c07_2070_pot 2)
	
	(unit_set_emotional_state mercy pain 1 60)
	(print "mercy - pain 1 60")
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c07_intra1_dof_04
	(time_code_reset)
	(sleep 384)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field .5 .75 .75 0 0 0 0)
	(print "rack focus")
	
	(sleep 106)
	(cinematic_screen_effect_set_depth_of_field .5 .75 0 .5 0 .75 .5)
	(print "rack focus")
	
	)

; ---------------------------------------------------------------------

(script static void c07_intra1_04_setup

	(effect_new_on_object_marker effects\cinematics\07\flood_burrowing infection_form_01 "mouth")

	(object_hide index false)
	(object_hide infection_form_01 false)

	(wake c07_intra1_foley_04)
	
	(wake c07_2050_pot)
	(wake c07_2060_pot)
	(wake c07_2070_pot)
	
	(wake c07_intra1_dof_04)
	
	(unit_set_emotional_state tartarus shocked .5 0)
	(print "tartarus - shocked .5 0")
	
	)
	
(script static void c07_intra1_04_cleanup
	
	(object_destroy truth)
	(object_destroy mercy_no_crown)
	(object_destroy tartarus)
	(object_destroy brute_03)
	(object_destroy brute_04)
	(object_destroy infection_form_01)
	(object_destroy throne_mercy)
	(object_destroy phantom_01)
	(object_destroy phantom_02)
	(object_destroy phantom_03)
	(object_destroy index)
	
	)

(script static void c07_intra1_scene_04
	
	(c07_intra1_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\07_intra1\07_intra1 "07_intra1_04" none "anchor_flag_intra1")

	(custom_animation_relative truth objects\characters\prophet\07_intra1\07_intra1 "truth_04" false anchor_intra1)
	(custom_animation_relative mercy_no_crown objects\characters\prophet\07_intra1\07_intra1 "mercy_04" false anchor_intra1)
	
	(custom_animation_relative tartarus objects\characters\brute\07_intra1\07_intra1 "tartarus_04" false anchor_intra1)
	(custom_animation_relative brute_03 objects\characters\brute\07_intra1\07_intra1 "brute03_04" false anchor_intra1)
	(custom_animation_relative brute_04 objects\characters\brute\07_intra1\07_intra1 "brute04_04" false anchor_intra1)

	(scenery_animation_start_relative index scenarios\objects\forerunner\industrial\index\index_full\07_intra1\07_intra1 "index_04" anchor_intra1)

	(custom_animation_relative infection_form_01 objects\characters\flood_infection\07_intra1\07_intra1 "infection01_04" false anchor_intra1)
	
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom1_04" false anchor_intra1)
	(custom_animation_relative phantom_02 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom2_04" false anchor_intra1)
	(custom_animation_relative phantom_03 objects\vehicles\phantom\animations\07_intra1\07_intra1 "phantom3_04" false anchor_intra1)

	(sleep (- (camera_time) 60))
	
	(fade_out 0 0 0 60)
	(sleep 60)
	
	(c07_intra1_04_cleanup)
	(cinematic_lightmap_shadow_disable)

	)
	
; C07_INTRA1 MASTER SCRIPT ============================================
; =====================================================================

(script static void c07_intra1

	(sound_class_set_gain vehicle .25 1)

	(texture_cache_flush)
	(geometry_cache_flush)

	(switch_bsp_by_name high_5)
	(sleep 1)
	
	(c07_intra1_scene_01)
	(c07_intra1_scene_02)
	(c07_intra1_scene_03)
	(c07_intra1_scene_04)
	
	)
	
(script static void test
	(print "effect - infection burrow")
	(effect_new_on_object_marker effects\cinematics\07\flood_burrowing infection_form_02 "mouth")
	(effect_new_on_object_marker effects\cinematics\07\flood_burrowing infection_form_01 "mouth")
	)
	
