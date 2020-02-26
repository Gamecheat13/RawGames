; CINEMATICS FOR LEVEL 04b, "FLOOD LAB" ===============================
; =====================================================================

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)
	
	(script stub void 04_intra0_predict_stub (print "predict 01"))
	
	(script stub void 04_intra1_01_predict_stub (print "predict 01"))
	(script stub void 04_intra1_02_predict_stub (print "predict 02"))
	
	(script stub void 04_outro1_01_predict_stub (print "predict 01"))
	(script stub void 04_outro1_02_predict_stub (print "predict 02"))
	(script stub void 04_outro1_03_predict_stub (print "predict 03"))
	
	(script stub void 04_outro2_01_predict_stub (print "predict 01"))
	(script stub void 04_outro2_02_predict_stub (print "predict 02"))

; C04_INTRA0 ----------------------------------------------------------

(script dormant c04_intra0_score_01
	(sleep 369)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intra0\music\c04_intra0_01_mus none 1)
	(print "c04_intra0 score 01 start")
	)
	
(script dormant c04_intra0_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intra0\foley\c04_intra0_01_fol none 1)
	(print "c04_intra1 foley 01 start")
	)

(script dormant c04_1230_der
	(sleep 467)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1230_der dervish_intra0 1)
	(cinematic_subtitle c04_1230_der 1)
	)

(script dormant c04_1240_soc
	(sleep 493)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1240_soc commander_intra0 1)
	(cinematic_subtitle c04_1240_soc 3)
	)
	
(script dormant c04_intra0_cinematic_light_01
	
	(cinematic_lighting_set_primary_light 55 138 0.26 0.24 0.15)
	(cinematic_lighting_set_secondary_light -28 358 0.08 0.08 0.11)
	(cinematic_lighting_set_ambient_light 0.03 0.03 0.03)

;	(rasterizer_bloom_override 1)
;	(rasterizer_bloom_override_threshold .15)
;	(rasterizer_bloom_override_brightness .25)
	
	(object_uses_cinematic_lighting dervish_intra0 1)
	(object_uses_cinematic_lighting commander_intra0 1)
	(object_uses_cinematic_lighting elite_intra0_01 1)
	(object_uses_cinematic_lighting elite_intra0_02 1)
	(object_uses_cinematic_lighting grunt_intra0_01 1)
	(object_uses_cinematic_lighting grunt_intra0_02 1)
	
	(object_uses_cinematic_lighting pr_intra0_der 1)
	(object_uses_cinematic_lighting eb_intra0_soc 1)
	(object_uses_cinematic_lighting pr_intra0_soe_01 1)
	(object_uses_cinematic_lighting pr_intra0_soe_02 1)
	(object_uses_cinematic_lighting pr_intra0_soe_03 1)
	(object_uses_cinematic_lighting pp_intra0_sog_01 1)
	(object_uses_cinematic_lighting pp_intra0_sog_02 1)
	
	)

(script dormant soc_blade_activate
	(sleep 5)
	(object_set_permutation eb_intra0_soc "blade" "default")
	(print "blade activate")
	)

(script static void c04_intra0_setup
	
	(object_create_anew dervish_intra0)
	(object_create_anew commander_intra0)
	(object_create_anew_containing elite_intra0)
	(object_create_anew_containing grunt_intra0)
	
;	(object_create_anew pr_intra0_der)
	(object_create_anew eb_intra0_soc)
	(object_create_anew pr_intra0_soe_01)
	(object_create_anew pr_intra0_soe_02)
	(object_create_anew pr_intra0_soe_03)
	(object_create_anew pp_intra0_sog_01)
	(object_create_anew pp_intra0_sog_02)
	
	(object_cinematic_lod dervish_intra0 true)
	(object_cinematic_lod commander_intra0 true)
	(object_cinematic_lod elite_intra0_01 true)
	(object_cinematic_lod elite_intra0_02 true)
	(object_cinematic_lod grunt_intra0_01 true)
	(object_cinematic_lod grunt_intra0_02 true)
	
;	(object_cinematic_lod pr_intra0_der true)
	(object_cinematic_lod eb_intra0_soc true)
	(object_cinematic_lod pr_intra0_soe_01 true)
	(object_cinematic_lod pr_intra0_soe_02 true)
	(object_cinematic_lod pr_intra0_soe_03 true)
	(object_cinematic_lod pp_intra0_sog_01 true)
	(object_cinematic_lod pp_intra0_sog_02 true)

	(cinematic_clone_players_weapon dervish_intra0 "right_hand_elite" "")
;	(objects_attach dervish_intra0 "right_hand_elite" pr_intra0_der "")
	(objects_attach commander_intra0 "right_hand_elite" eb_intra0_soc "")
	(objects_attach elite_intra0_01 "right_hand_elite" pr_intra0_soe_01 "")
	(objects_attach elite_intra0_01 "left_hand_elite" pr_intra0_soe_02 "")
	(objects_attach elite_intra0_02 "right_hand_elite" pr_intra0_soe_03 "")
	(objects_attach grunt_intra0_01 "right_hand" pp_intra0_sog_01 "")
	(objects_attach grunt_intra0_02 "right_hand" pp_intra0_sog_02 "")

	(wake c04_intra0_score_01)
	(wake c04_intra0_foley_01)

	(wake c04_1230_der)
	(wake c04_1240_soc)
	
	(wake soc_blade_activate)
	
	(wake c04_intra0_cinematic_light_01)

	 )
	 
(script static void c04_intra0

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(cinematic_enable_ambience_details off)
	(sound_class_set_gain device .2 0)

	(switch_bsp_by_name alphagasgiant)

	(fade_out 1 1 1 0)

	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(04_intra0_predict_stub)
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_intra0\music\c04_intra0_01_mus)
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_intra0\foley\c04_intra0_01_fol)
	(sleep prediction_offset)
	
	(c04_intra0_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intra0\04_intra0 "04_intra0" none "anchor_flag_intra0")
	
	(custom_animation_relative dervish_intra0 objects\characters\dervish\04_intra0\04_intra0 "dervish" false anchor_intra0)
	(custom_animation_relative commander_intra0 objects\characters\elite\04_intra0\04_intra0 "commander" false anchor_intra0)
	(custom_animation_relative elite_intra0_01 objects\characters\elite\04_intra0\04_intra0 "elite01" false anchor_intra0)
	(custom_animation_relative elite_intra0_02 objects\characters\elite\04_intra0\04_intra0 "elite02" false anchor_intra0)
	(custom_animation_relative grunt_intra0_01 objects\characters\grunt\04_intra0\04_intra0 "grunt01" false anchor_intra0)
	(custom_animation_relative grunt_intra0_02 objects\characters\grunt\04_intra0\04_intra0 "grunt02" false anchor_intra0)
	
	(fade_in 1 1 1 15)
	
	(device_set_power arm_02_entry_ext 0)
	(sleep 30)
	(device_set_power arm_02_entry_ext 1)
	(device_set_position arm_02_entry_ext 1)
	(sleep 563)
	(device_group_change_only_once_more_set 04_intra0 false)
	(device_set_position arm_02_entry_ext 0)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	
	(object_destroy_containing intra0)
	
	(sound_class_set_gain device 0 30)
	(sound_class_set_gain amb 0 30)
	
	(sleep 30)
	
	)

; C04_INTRA1 SCENE 01 -------------------------------------------------
	
(script dormant c04_intra1_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intra1\foley\c04_intra1_01_fol none 1)
	(print "c04_intra1 foley 01 start")
	)

(script dormant c04_2010_her
	(sleep 45)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2010_her heretic_leader 1)
	(cinematic_subtitle c04_2010_her 2.5)
	)
	
(script dormant c04_2020_her
	(sleep 121)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2020_her heretic_leader 1)
	(cinematic_subtitle c04_2020_her 2)
	)
	
(script dormant c04_2030_soc
	(sleep 249)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2030_soc none 1)
	(cinematic_subtitle c04_2030_soc 1)
	)
	
(script dormant scale_hologram

	(sleep 615)
	(object_set_scale gasmine_hologram .525 0)
	(print "scale hologram")
	
	)
	
(script dormant effect_shield_impact
	(sleep 185)
	(print "effect - shield impact")
	(effect_new effects\impact\impact_bullet_medium\energy_shield_thin_cov flag_shield_impact)	
	)

(script dormant c04_intra1_cinematic_light_01
	
	(cinematic_lighting_set_primary_light 55 138 0.26 0.24 0.15)
	(cinematic_lighting_set_secondary_light -28 358 0.08 0.08 0.11)
	(cinematic_lighting_set_ambient_light 0.03 0.03 0.03)

;	(rasterizer_bloom_override 1)
;	(rasterizer_bloom_override_threshold .15)
;	(rasterizer_bloom_override_brightness .25)
	
	(object_uses_cinematic_lighting dervish02 1)
	(object_uses_cinematic_lighting heretic_leader 1)
	
	)
	
(script static void c04_intra1_02_problem_actors
	(print "problem actors")
	
	(object_create_anew dervish02b)
	(object_create_anew commander)
	(object_create_anew elite01)
	(object_create_anew elite02)
	(object_create_anew intra1_blade)
	(object_create_anew intra1_rifle_01)
	(object_create_anew intra1_rifle_02)

	(object_cinematic_lod dervish02b true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod elite02 true)
	(object_cinematic_lod intra1_blade true)
	(object_cinematic_lod intra1_rifle_01 true)
	(object_cinematic_lod intra1_rifle_02 true)
	
	(cinematic_clone_players_weapon dervish02b "right_hand_elite" "")
	(objects_attach commander "right_hand_elite" intra1_blade "")
	(objects_attach elite01 "right_hand_elite" intra1_rifle_01 "")
	(objects_attach elite02 "right_hand_elite" intra1_rifle_02 "")
	
	)

(script static void c04_intra1_01_setup

	(object_create_anew dervish02)
	(object_create_anew heretic_leader)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod heretic_leader true)
	
	(cinematic_clone_players_weapon dervish02 "left_hand_elite" "")
	
	(wake c04_intra1_foley_01)
	
	(wake c04_2010_her)
	(wake c04_2020_her)
	(wake c04_2030_soc)
	
	(wake scale_hologram)
	
	(wake effect_shield_impact)
	(wake c04_intra1_cinematic_light_01)
	
	 )

(script static void c04_intra1_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 70 0)
	
	(cinematic_lightmap_shadow_enable)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(04_intra1_01_predict_stub)
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_intra1\foley\c04_intra1_01_fol)
	(sleep prediction_offset)
	
	(c04_intra1_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intra1\04_intra1 "04_intra1_01" none "cinematic_anchor02")
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intra1\04_intra1 "dervish_01" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_intra1\04_intra1 "heretic_01" false anchor02)
	
	(fade_in 1 1 1 15)
	
	(sleep 165)
	(device_set_position control_shield_door 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_intra1_02_predict_stub)
	(c04_intra1_02_problem_actors)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_intra1\foley\c04_intra1_02_fol)
	
	(sleep (camera_time))
	
	(object_destroy dervish02)
	(object_set_scale gasmine_hologram 1 0)
	(print "scale hologram")
	
	)
	
; C04_INTRA1 SCENE 02 -------------------------------------------------

(script dormant c04_intra1_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_intra1\foley\c04_intra1_02_fol none 1)
	(print "c04_intra1 foley 02 start")
	)

(script dormant c04_2031_soc
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2031_soc commander 1)
	(cinematic_subtitle c04_2031_soc 1)
	)
	
(script dormant c04_2040_soc
	(sleep 96)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2040_soc commander 1)
	(cinematic_subtitle c04_2040_soc 3)
	)
		
(script dormant c04_2050_soc
	(sleep 178)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2050_soc commander 1)
	(cinematic_subtitle c04_2050_soc 1.5)
	)
	
(script dormant c04_2060_der
	(sleep 229)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2060_der dervish02b 1)
	(cinematic_subtitle c04_2060_der 2)
	)
	
(script dormant c04_2070_soc
	(sleep 292)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2070_soc commander 1)
	(cinematic_subtitle c04_2070_soc 1)
	)

(script dormant c04_2080_der
	(sleep 335)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2080_der dervish02b 1)
	(cinematic_subtitle c04_2080_der 3.5)
	)
	
(script dormant c04_2090_der
	(sleep 482)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2090_der dervish02b 1)
	(cinematic_subtitle c04_2090_der 2)
	)

(script dormant c04_intra1_cinematic_light_02
	
	(cinematic_lighting_set_primary_light 55 138 0.26 0.24 0.15)
	(cinematic_lighting_set_secondary_light -28 358 0.08 0.08 0.11)
	(cinematic_lighting_set_ambient_light 0.03 0.03 0.03)
	
	(object_uses_cinematic_lighting dervish02b 1)
	(object_uses_cinematic_lighting commander 1)
	(object_uses_cinematic_lighting elite01 1)
	(object_uses_cinematic_lighting elite02 1)
	
	)
		
(script static void c04_intra1_02_setup
	
	(wake c04_intra1_foley_02)
	
	(wake c04_2031_soc)
	(wake c04_2040_soc)       
	(wake c04_2050_soc)       
	(wake c04_2060_der)       
	(wake c04_2070_soc)       
	(wake c04_2080_der)      
	(wake c04_2090_der)
	
	(wake c04_intra1_cinematic_light_02)
	
	)
	
(script static void c04_intra1_02_cleanup
	
	(object_destroy dervish02b)
	(object_destroy commander)
	(object_destroy elite01)
	(object_destroy elite02)
	(object_destroy_containing intra1)
	
	)

(script static void c04_intra1_02
	
	(c04_intra1_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intra1\04_intra1 "04_intra1_02" none "cinematic_anchor02")
	
	(custom_animation_relative dervish02b objects\characters\dervish\04_intra1\04_intra1 "dervish_02" false anchor02)
	(custom_animation_relative commander objects\characters\elite\04_intra1\04_intra1 "soc_02" false anchor02)
	(custom_animation_relative elite01 objects\characters\elite\04_intra1\04_intra1 "elite01_02" false anchor02)
	(custom_animation_relative elite02 objects\characters\elite\04_intra1\04_intra1 "elite02_02" false anchor02)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(sound_class_set_gain amb 0 15)
	(sleep 15)
	
	(c04_intra1_02_cleanup)
	
	)
	
; C04_INTRA1 MASTER SCRIPT ============================================
;* ====================================================================
*;

(script static void c04_intra1

	(fade_out 1 1 1 0)

	(geometry_cache_flush)
	(texture_cache_flush)
	
	(switch_bsp_by_name alphagasgiant)
	(sleep 1)
	
	(c04_intra1_01)
	(c04_intra1_02)

	(sleep 30)
	
	)


; C04_OUTRO1 SCENE 01 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_outro1_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_outro1\music\c04_outro1_01_mus none 1)
	(print "c04_outro1 score 01 start")
	)
	
(script dormant c04_outro1_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_outro1\foley\c04_outro1_01_fol none 1)
	(print "c04_outro1 foley 01 start")
	)
	
(script dormant c04_3010_der
	(sleep 118)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3010_der dervish_03 1)
	(cinematic_subtitle c04_3010_der 1.5)
	)

(script dormant c04_3020_her
	(sleep 197)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3020_her heretic_leader 1)
	(cinematic_subtitle c04_3020_her 1)
	)
	
(script dormant c04_3030_her
	(sleep 243)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3030_her heretic_leader 1)
	(cinematic_subtitle c04_3030_her 4.5)
	)

(script dormant c04_3040_der
	(sleep 385)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3040_der dervish_03 1)
	(cinematic_subtitle c04_3040_der 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c04_outro1_01_dof
	(time_code_reset)
	(sleep 382)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 1 1.5 1.5 0 0 0 0)
	(print "rack focus")
	)

(script dormant c04_outro1_cinematic_light_01
	
	(cinematic_lighting_set_primary_light 55 138 0.26 0.24 0.15)
	(cinematic_lighting_set_secondary_light -28 358 0.08 0.08 0.11)
	(cinematic_lighting_set_ambient_light 0.03 0.03 0.03)
	
	(object_uses_cinematic_lighting dervish_03 1)
	(object_uses_cinematic_lighting heretic_leader 1)
	(object_uses_cinematic_lighting outro_seraph 1)
	
	)
	
; ---------------------------------------------------------------------

(script static void c04_outro1_01_setup

	(object_destroy seraph)
	(object_create outro_seraph)

	(object_create_anew dervish_03)
	(object_create_anew heretic_leader)
	
	(object_cinematic_lod dervish_03 true)
	(object_cinematic_lod heretic_leader true)
	
	(cinematic_clone_players_weapon dervish_03 "right_hand_elite" "")
	
	(wake c04_outro1_score_01)
	(wake c04_outro1_foley_01)
	
	(wake c04_3010_der)        
	(wake c04_3020_her)        
	(wake c04_3030_her)        
	(wake c04_3040_der)
	
	(wake c04_outro1_01_dof)
	(wake c04_outro1_cinematic_light_01)
	      
	)

(script static void c04_outro1_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(cinematic_lightmap_shadow_enable)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(04_outro1_01_predict_stub)
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_outro1\music\c04_outro1_01_mus)
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_outro1\foley\c04_outro1_01_fol)
	(sleep prediction_offset)
	
	(c04_outro1_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro1\04_outro1 "04_outro1_01" none "anchor_flag_seraph")
	
	(custom_animation_relative dervish_03 objects\characters\dervish\04_outro1\04_outro1 "dervish_01" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro1\04_outro1 "heretic_01" false anchor02)
	
	(scenery_animation_start_relative outro_seraph scenarios\objects\vehicles\c_seraph\c_seraph "04_outro1_01" anchor_seraph)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_outro1_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_outro1\foley\c04_outro1_02_fol)
		
	(sleep (camera_time))
	
	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	)

; C04_OUTRO1 SCENE 02 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_outro1_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_outro1\foley\c04_outro1_02_fol none 1)
	(print "c04_outro1 foley 02 start")
	)

(script dormant c04_3050_der
	(sleep 132)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3050_der dervish_03 1)
	(cinematic_subtitle c04_3050_der 1.5)
	)

(script dormant c04_3060_gsp
	(sleep 190)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3060_gsp monitor 1)
	(cinematic_subtitle c04_3060_gsp 6)
	)
	
(script dormant c04_3070_her
	(sleep 363)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3070_her heretic_leader 1)
	(cinematic_subtitle c04_3070_her 5)
	)

(script dormant c04_3080_gsp
	(sleep 516)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3080_gsp monitor 1)
	(cinematic_subtitle c04_3080_gsp 3.5)
	)

; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant c04_outro1_cinematic_light_02
	
	(cinematic_lighting_set_primary_light 55 138 0.26 0.24 0.15)
	(cinematic_lighting_set_secondary_light -28 358 0.08 0.08 0.11)
	(cinematic_lighting_set_ambient_light 0.03 0.03 0.03)
	
	(object_uses_cinematic_lighting monitor 1)
	
	)
	
; ---------------------------------------------------------------------

(script dormant heretic_leader_fire_rifles

	(object_create_anew hl_rifle_01)
	(object_create_anew hl_rifle_02)

	(sleep 623)
	(objects_attach heretic_leader "right_hand_elite" hl_rifle_01 "")
	(objects_attach heretic_leader "left_hand_elite" hl_rifle_02 "")
	(sleep 1)
	(weapon_hold_trigger hl_rifle_01 0 true)
	(weapon_hold_trigger hl_rifle_02 0 true)
	(print "heretic rifles fire")

	(sleep 85)
	(weapon_hold_trigger hl_rifle_01 0 false)
	(weapon_hold_trigger hl_rifle_02 0 false)
	(print "heretic rifles stop")
	
	)
	
(script dormant effect_jetpack
	(sleep 735)
	(print "jetpack on")
	(object_set_function_variable heretic_leader "vertical_thrust" 1 0)
	(sleep 154)
	(object_set_function_variable heretic_leader "vertical_thrust" 0 0)
	)
	
(script static void c04_outro1_02_setup

	(object_create_anew monitor)
	(object_cinematic_lod monitor true)
	
	(wake c04_outro1_foley_02)
	
	(wake c04_3050_der)
	(wake c04_3060_gsp)
	(wake c04_3070_her)
	(wake c04_3080_gsp)
	
	(wake heretic_leader_fire_rifles)
	(wake effect_jetpack)
	
	)

(script static void c04_outro1_02
	
	(c04_outro1_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro1\04_outro1 "04_outro1_02" none "anchor_flag_seraph")
	
	(custom_animation_relative dervish_03 objects\characters\dervish\04_outro1\04_outro1 "dervish_02" false anchor02)
	(custom_animation_relative monitor objects\characters\monitor\04_outro1\04_outro1 "monitor_02" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro1\04_outro1 "heretic_02" false anchor02)
	
	(scenery_animation_start_relative outro_seraph scenarios\objects\vehicles\c_seraph\c_seraph "04_outro1_02" anchor_seraph)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_outro1_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_outro1\foley\c04_outro1_03_fol)
	
	(sleep (camera_time))

	)
	
; C04_OUTRO1 SCENE 03 -------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c04_outro1_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_outro1\foley\c04_outro1_03_fol none 1)
	(print "c04_outro1 foley 01 start")
	)

(script dormant c04_3090_her
	(sleep 29)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3090_her heretic_leader 1)
	(cinematic_subtitle c04_3090_her 2)
	)
	
(script dormant c04_3100_her
	(sleep 108)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3100_her heretic_leader 1)
	(cinematic_subtitle c04_3100_her 2.5)
	)
	
; EFFECTS -------------------------------------------------------------

(script dormant effect_drone_activate
	(sleep 162)
	(effect_new_on_object_marker effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_activate holo_drone_1 "light")
	(print "effect - drone 1")
	(sleep 13)
	(effect_new_on_object_marker effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_activate holo_drone_2 "light")
	(print "effect - drone 2")
	)

(script dormant effect_holograms_appear
	(sleep 477)
	(effect_new_on_object_marker effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_holo_on_cinematic holo_base_1 "marker")
	(print "effect - hologram 1")
	(sleep 18)
	(effect_new_on_object_marker effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_holo_on_cinematic holo_base_2 "marker")
	(print "effect - hologram 2")
	)
	
(script dormant arm_holograms
	(time_code_reset)
	(sleep 546)
	(object_create_anew_containing holo_rifle)
	(objects_attach hologram01 "right_hand_elite" holo_rifle_01 "")
	(objects_attach hologram01 "left_hand_elite" holo_rifle_02 "")
	(objects_attach hologram02 "right_hand_elite" holo_rifle_03 "")
	(objects_attach hologram02 "left_hand_elite" holo_rifle_04 "")
	)

(script static void c04_outro1_03_setup

	(object_create_anew holo_base_1)
	(object_create_anew holo_base_2)
	(object_create_anew holo_drone_1)
	(object_create_anew holo_drone_2)
	
	(object_cinematic_lod holo_drone_1 true)
	(object_cinematic_lod holo_drone_2 true)
	
	(object_destroy hl_rifle_01)
	(object_destroy hl_rifle_02)
	
	(wake c04_outro1_foley_03)
	
	(wake c04_3090_her)
	(wake c04_3100_her)
	
	(wake arm_holograms)
	
	(wake effect_drone_activate)
	(wake effect_holograms_appear)
	
	)
	
(script static void c04_outro1_03_cleanup
	
	(object_destroy dervish_03)
	(object_destroy heretic_leader)
	(object_destroy monitor)
	(object_destroy hologram01)
	(object_destroy hologram02)
	(object_destroy holo_drone_1)
	(object_destroy holo_drone_2)
	(object_destroy_containing holo_rifle)
	
	)

(script dormant c04_outro1_03_holo1
	(sleep 478)
	(object_create_anew hologram01)
	(object_cinematic_lod hologram01 true)
	(custom_animation_relative hologram01 objects\characters\heretic\04_outro1\04_outro1 "holo1_03" false anchor02)
	)
	
(script dormant c04_outro1_03_holo2
	(sleep 490)
	(object_create_anew hologram02)
	(object_cinematic_lod hologram02 true)
	(custom_animation_relative hologram02 objects\characters\heretic\04_outro1\04_outro1 "holo2_03" false anchor02)
	)

(script static void c04_outro1_03
	
	(c04_outro1_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro1\04_outro1 "04_outro1_03" none "anchor_flag_seraph")
	
	(custom_animation_relative dervish_03 objects\characters\dervish\04_outro1\04_outro1 "dervish_03" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro1\04_outro1 "heretic_03" false anchor02)
	(custom_animation_relative monitor objects\characters\monitor\04_outro1\04_outro1 "monitor_03" false anchor02)
	
	(scenery_animation_start_relative outro_seraph scenarios\objects\vehicles\c_seraph\c_seraph "04_outro1_03" anchor_seraph)
	(scenery_animation_start_relative holo_drone_1 scenarios\objects\solo\alphagasgiant\holo_drone\holo_drone "outro1_01" anchor02)
	(scenery_animation_start_relative holo_drone_2 scenarios\objects\solo\alphagasgiant\holo_drone\holo_drone "outro1_02" anchor02)
	
	(wake c04_outro1_03_holo1)
	(wake c04_outro1_03_holo2)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c04_outro1_03_cleanup)
	
	(sound_class_set_gain amb 0 30)
	(sleep 30)
	
	)

; C04_OUTRO1 MASTER SCRIPT ============================================
;* ====================================================================
*;

(script static void c04_outro1

	(fade_out 1 1 1 0)

	(geometry_cache_flush)
	(texture_cache_flush)

	(cinematic_enable_ambience_details off)
	(sound_class_set_gain amb .5 0)
	
	(switch_bsp_by_name production_arm2)
	(sleep 1)
	
	(c04_outro1_01)
	(c04_outro1_02)
	(c04_outro1_03)
	
	)
	
; ------------------------------------------------------------------------------------------------------------------------------------
; C04_OUTRO2 SCENE 01 -------------------------------------------------

(script dormant c04_outro2_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_outro2\music\c04_outro2_01_mus none 1)
	(print "c04_outro2 score 01 start")
	)

(script dormant c04_outro2_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_outro2\foley\c04_outro2_01_fol none 1)
	(print "c04_outro2 foley 01 start")
	)

(script dormant c04_9110_gsp
	(sleep 32)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9110_gsp monitor 1)
	(cinematic_subtitle c04_9110_gsp 3.5)
	)
	
(script dormant c04_9120_der
	(sleep 133)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9120_der dervish_03 1)
	(cinematic_subtitle c04_9120_der 5)
	)

(script dormant c04_9130_gsp
	(sleep 274)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9130_gsp monitor 1)
	(cinematic_subtitle c04_9130_gsp 5.5)
	
	(sleep 150)
	(unit_set_emotional_state dervish_03 shocked .75 30)
	
	)
	
(script dormant effect_monitor_scramble
	(sleep 423)
	(print "effect - monitor scramble")
	(effect_new_on_object_marker effects\objects\characters\brute\hammer_grappling monitor "body")
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(player_effect_stop 1.5)
	)
	
(script dormant c04_outro2_cinematic_light_01
	
	(cinematic_lighting_set_primary_light 55 138 0.26 0.24 0.15)
	(cinematic_lighting_set_secondary_light -28 358 0.08 0.08 0.11)
	(cinematic_lighting_set_ambient_light 0.03 0.03 0.03)

;	(rasterizer_bloom_override 1)
;	(rasterizer_bloom_override_threshold .15)
;	(rasterizer_bloom_override_brightness .25)
	
	(object_uses_cinematic_lighting dervish_03 1)
	(object_uses_cinematic_lighting heretic_leader 1)
	(object_uses_cinematic_lighting monitor 1)
	
	)

(script static void c04_outro2_01_setup

	(object_destroy hangar_door_ingame)
	(object_create_anew hangar_door_cinematic)
	
	(device_set_position hangar_door_cinematic 1)

	(object_create_anew dervish_03)
	(object_create_anew heretic_leader)
	(object_create_anew monitor)
	
	(object_cinematic_lod dervish_03 true)
	(object_cinematic_lod heretic_leader true)
	(object_cinematic_lod monitor true)
	
	(object_set_function_variable heretic_leader "alive" 0 0)
	
	(wake c04_outro2_score_01)
	(wake c04_outro2_foley_01)
	
	(wake c04_9110_gsp)
	(wake c04_9120_der)
	(wake c04_9130_gsp)
	
	(wake effect_monitor_scramble)
	(wake c04_outro2_cinematic_light_01)
	
	)

(script static void c04_outro2_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 70 0)
	
	(cinematic_lightmap_shadow_enable)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(04_outro2_01_predict_stub)
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_outro2\music\c04_outro2_01_mus)
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_outro2\foley\c04_outro2_01_fol)
	(sleep prediction_offset)
	
	(c04_outro2_01_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro2\04_outro2 "04_outro2_01" none "cinematic_anchor02")
	
	(custom_animation_relative dervish_03 objects\characters\dervish\04_outro2\04_outro2 "dervish_01" false anchor02)
	(custom_animation_relative monitor objects\characters\monitor\04_outro2\04_outro2 "monitor_01" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro2\04_outro2 "heretic_01" false anchor02)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(04_outro2_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\04_alphagas\c04_outro2\foley\c04_outro2_02_fol)
	
	(sleep (camera_time))
	
	)

; C04_OUTRO2 SCENE 02 -------------------------------------------------

(script dormant c04_outro2_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\04_alphagas\c04_outro2\foley\c04_outro2_02_fol none 1)
	(print "c04_outro2 foley 02 start")
	)
	
(script dormant c04_9140_gsp
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9140_gsp monitor 1)
	(cinematic_subtitle c04_9140_gsp 2)
	)
	
(script dormant c04_9150_der
	(sleep 146)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9150_der dervish_03 1)
	(cinematic_subtitle c04_9150_der 2)
	
	(sleep 127)
	(unit_set_emotional_state tartarus repulsed 1 60)
	
	)
	
(script dormant c04_9160_tar
	(sleep 236)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9160_tar tartarus 1)
	(cinematic_subtitle c04_9160_tar 1)
	
	)
	
(script dormant c04_9170_tar
	(sleep 300)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9170_tar tartarus 1)
	(cinematic_subtitle c04_9170_tar 2)
	
	(unit_set_emotional_state tartarus annoyed 1 60)
	
	)

(script dormant effect_monitor_yank
	(time_code_reset)
	(sleep 190)
	(print "effect - monitor yank")
	(object_set_function_variable monitor talking 0 0)
	(effect_new_on_object_marker effects\objects\characters\monitor\monitor_scrambled monitor "body")
	)
	
(script dormant c04_outro2_cinematic_light_02
	
	(cinematic_lighting_set_primary_light 55 138 0.26 0.24 0.15)
	(cinematic_lighting_set_secondary_light -28 358 0.08 0.08 0.11)
	(cinematic_lighting_set_ambient_light 0.03 0.03 0.03)

;	(rasterizer_bloom_override 1)
;	(rasterizer_bloom_override_threshold .15)
;	(rasterizer_bloom_override_brightness .25)
	
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting hammer 1)
	
	)

(script static void c04_outro2_02_setup

	(object_create_anew tartarus)
	(object_create_anew hammer)
	(object_create_anew phantom_outro2)
	
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod hammer true)
	(object_cinematic_lod phantom_outro2 true)
	
	(unit_set_emotional_state tartarus pensive 1 0)
	
	(wake c04_outro2_foley_02)
	
	(wake c04_9140_gsp)
	(wake c04_9150_der)
	(wake c04_9160_tar)
	(wake c04_9170_tar)
	
	(wake effect_monitor_yank)
	(wake c04_outro2_cinematic_light_02)
	
	)
	
(script static void c04_outro2_02_cleanup
	
	(object_destroy dervish_03)
	(object_destroy heretic_leader)
	(object_destroy monitor)
	(object_destroy tartarus)
	(object_destroy hammer)
	(object_destroy phantom_outro2)
	
	(sound_class_set_gain amb 1 2)
	
	)

(script static void c04_outro2_02
	
	(c04_outro2_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro2\04_outro2 "04_outro2_02" none "cinematic_anchor02")
	
	(custom_animation_relative dervish_03 objects\characters\dervish\04_outro2\04_outro2 "dervish_02" false anchor02)
	(custom_animation_relative monitor objects\characters\monitor\04_outro2\04_outro2 "monitor_02" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro2\04_outro2 "heretic_02" false anchor02)
	(custom_animation_relative tartarus objects\characters\brute\04_outro2\04_outro2 "tartarus_02" false anchor02)
	
	(scenery_animation_start_relative hammer objects\weapons\melee\gravity_hammer\04_outro2\04_outro2 "hammer_02" anchor02)
	
	(custom_animation_relative phantom_outro2 objects\vehicles\phantom\animations\04_outro2\04_outro2 "phantom_02" false anchor02)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 0 0 0 15)
	(sleep 15)
	
	(c04_outro2_02_cleanup)
	
	(sound_class_set_gain amb 0 30)
	(sleep 30)
	
	)

; C04_OUTRO2 MASTER SCRIPT ============================================
; =====================================================================


(script static void c04_outro2

	(fade_out 1 1 1 0)
	
	(geometry_cache_flush)
	(texture_cache_flush)
	
	(cinematic_enable_ambience_details off)
	(sound_class_set_gain amb .5 0)
	
	(switch_bsp_by_name production_arm2)
	(sleep 1)
	
	(c04_outro2_01)
	(c04_outro2_02)

	)
