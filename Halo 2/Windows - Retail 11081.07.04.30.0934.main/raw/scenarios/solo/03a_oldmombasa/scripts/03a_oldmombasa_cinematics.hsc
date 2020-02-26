; CINEMATICS FOR LEVEL 03A, "OLD MOMBASA" =============================
; =====================================================================

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 75)

	(script stub void 03_intro_01_predict_stub (print "predict 01"))
	(script stub void 03_intro_02_predict_stub (print "predict 02"))
	(script stub void 03_intro_03_predict_stub (print "predict 03"))
	(script stub void 03_intro_04_predict_stub (print "predict 04"))

; C03_INTRO SCENE 01 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c03_intro_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intro\music\c03_intro_01_mus none 1)
	(print "c03_intro score 01 start")
	)

(script dormant c03_intro_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_01_fol none 1)
	(print "c03_intro foley 01 start")
	)

(script dormant c03_intro_sound_scene1_01
	
	(object_set_function_variable pelican_01 "engine_hack" 1 0)
	(object_set_function_variable pelican_02 "engine_hack" 1 0)
	(object_set_function_variable pelican_03 "engine_hack" 1 0)
	(object_set_function_variable pelican_04 "engine_hack" 1 0)

	(object_set_function_variable pelican_01 "engine_audio" 1 0)
	(object_set_function_variable pelican_02 "engine_audio" 1 0)
	(object_set_function_variable pelican_03 "engine_audio" 1 0)
	(object_set_function_variable pelican_04 "engine_audio" 1 0)
	
	(object_set_function_variable pelican_01 "hover_audio" 1 0)
	(object_set_function_variable pelican_02 "hover_audio" 1 0)
	(object_set_function_variable pelican_03 "hover_audio" 1 0)
	(object_set_function_variable pelican_04 "hover_audio" 1 0)
	
	(sound_class_set_gain vehicle 0 0)
	(sound_class_set_gain vehicle 1 115)
	
	(object_set_velocity pelican_01 8)
	(object_set_velocity pelican_02 8)
	(object_set_velocity pelican_03 8)
	
	(sleep 130)
	
	(sound_class_set_gain vehicle 0 120)
	
	)
	
(script dormant c03_intro_sound_scene1_02
	(sleep 260)
	(sound_class_set_gain vehicle .5 10)
	)
	
(script dormant c03_intro_sound_scene1_03
	(sleep 350)
	(sound_class_set_gain vehicle 0 10)
	)
	
(script dormant c03_intro_sound_scene1_04
	(sleep 435)
	(sound_class_set_gain vehicle .5 10)
	)
	
(script dormant c03_1010_cor
	(sleep 212)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1010_cor none 1)
	(cinematic_subtitle c03_1010_cor 1)
	)

(script dormant c03_1011_cor
	(sleep 265)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1011_cor none 1)
	(cinematic_subtitle c03_1011_cor 2)
	)
	
(script dormant c03_1020_mir
	(sleep 333)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1020_mir none 1 radio_default_loop)
	(cinematic_subtitle c03_1020_mir 1)
	)

(script dormant c03_1021_mir
	(sleep 357)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1021_mir miranda 1)
	(cinematic_subtitle c03_1021_mir 1)
	)
	
(script dormant c03_1030_jon
	(sleep 396)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1030_jon none 1 radio_default_loop)
	(cinematic_subtitle c03_1030_jon 5)
	)
	
(script dormant c03_1040_jon
	(sleep 560)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1040_jon johnson 1)
	(cinematic_subtitle c03_1040_jon 4)
	)
	
(script dormant c03_1050_och_1
	(sleep 684)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1050_och pilot 1)
	(cinematic_subtitle c03_1050_och 1)
	)
	
(script dormant c03_1050_och_2
	(sleep 684)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1050_och copilot 1)
	(cinematic_subtitle c03_1050_och 2)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c03_intro_shake_01_1
	(sleep 113)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(player_effect_stop 1.5)
	)

(script dormant c03_intro_shake_01_2
	(sleep 259)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(sleep 91)
	(player_effect_stop 0)
	(print "shake stop")
	)	
	
(script dormant c03_intro_shake_01_3
	(sleep 560)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	)	
	
(script dormant c03_intro_01_dof_1
	(sleep 436)
	(print "dof values: 12 5 5 0 0 0 0")
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 12 5 5 0 0 0 0)
	(sleep 123)
	(print "dof stop")
	(cinematic_screen_effect_stop)
	)

(script dormant cinematic_light_01_city_01

;	(print "light city")
	
	(cinematic_lighting_set_primary_light 43 122 0.54902 0.478431 0.34902)
	(cinematic_lighting_set_secondary_light -25 98 0.317647 0.313726 0.396078)
	(cinematic_lighting_set_ambient_light 0.101961 0.101961 0.101961)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting pilot 1)
	(object_uses_cinematic_lighting copilot 1)
	(object_uses_cinematic_lighting pelican_01 1)
	(object_uses_cinematic_lighting pelican_02 1)
	(object_uses_cinematic_lighting pelican_03 1)
	(object_uses_cinematic_lighting pelican_04 1)
	(object_uses_cinematic_lighting iac 1)
	(object_uses_cinematic_lighting iac_bridge 1)
	(object_uses_cinematic_lighting carrier 1)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .6) 
	(rasterizer_bloom_override_brightness .5)
	
	)
	
(script dormant cinematic_light_01_pelican_01
	
	(sleep 259)
	
	(object_destroy carrier)
	(print "destroy carrier")
	
;	(print "light chief")
	
	(cinematic_lighting_set_primary_light 4 278 0.54902 0.478431 0.34902)
	(cinematic_lighting_set_secondary_light -34 154 0.14902 0.141176 0.180392)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(sleep 86)
	(fade_out 1 1 1 5)

	)

(script dormant cinematic_light_01_iac_01
	
	(sleep 350)
	
	(object_hide chief true)
	(print "hide chief")
	
;	(print "light iac bridge")
	
	(cinematic_lighting_set_primary_light -52 282 0.156863 0.180392 0.333333)
	(cinematic_lighting_set_secondary_light -75 150 0.121569 0.121569 0.180392)
	(cinematic_lighting_set_ambient_light 0.0588235 0.0509804 0.0392157)
	
	(sleep 20)
	(fade_in 1 1 1 5)
	
	)
	
(script dormant cinematic_light_01_city_02
	
	(sleep 435)
	
	(object_destroy miranda)
	(object_destroy iac_bridge)
	(print "destroy miranda, iac bridge")

;	(print "light approach")
	
	(cinematic_lighting_set_primary_light 43 122 0.54902 0.478431 0.34902)
	(cinematic_lighting_set_secondary_light -25 98 0.317647 0.313726 0.396078)
	(cinematic_lighting_set_ambient_light 0.101961 0.101961 0.101961)

	)
	
(script dormant cinematic_light_01_pelican_02
	
	(sleep 558)
	
	(print "light pelican")
	
	(cinematic_lighting_set_primary_light 29 116 0.478431 0.415686 0.329412)
	(cinematic_lighting_set_secondary_light 20 272 0.235294 0.235294 0.384314)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	)

; PROBLEM ACTORS ------------------------------------------------------

(script static void c03_intro_01_problem_actors
	(print "problem actors")

	(object_create_anew iac)
	(object_create_anew pelican_01)
	(object_create_anew pelican_02)
	(object_create_anew pelican_03)
	(object_create_anew pelican_04)

	(object_cinematic_lod iac true)
	(object_cinematic_lod pelican_01 true)
	(object_cinematic_lod pelican_02 true)
	(object_cinematic_lod pelican_03 true)
	(object_cinematic_lod pelican_04 true)
	
	(object_cinematic_visibility iac true)

	)

; ---------------------------------------------------------------------
	
(script static void c03_intro_01_setup

	(object_create_anew chief)
	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_create_anew pilot)
	(object_create_anew copilot)
	(object_create_anew iac_bridge)
	(object_create_anew carrier)
	
	(unit_set_emotional_state miranda inquisitive .25 0)
	
	(object_set_scale carrier .4 0)
	(object_set_function_variable carrier "grav_lift_control" 1 0)
	
	(object_create_anew intro_flak_01)
	(object_create_anew intro_flak_02)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod miranda true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod pilot true)
	(object_cinematic_lod copilot true)
	(object_cinematic_lod carrier true)
	
	(object_set_permutation copilot "head" "smith")
	
	(unit_set_emotional_state johnson happy .25 0)
	(unit_set_emotional_state pilot angry .25 0)
	(unit_set_emotional_state copilot angry .25 0)

	(wake c03_intro_score_01)
	(wake c03_intro_foley_01)
	
	(wake c03_intro_sound_scene1_01)
	(wake c03_intro_sound_scene1_02)
	(wake c03_intro_sound_scene1_03)
	(wake c03_intro_sound_scene1_04)

	(wake c03_1010_cor)
	(wake c03_1011_cor)
	(wake c03_1020_mir)
	(wake c03_1021_mir)
	(wake c03_1030_jon)
	(wake c03_1040_jon)
	(wake c03_1050_och_1)
	(wake c03_1050_och_2)
	
	(wake c03_intro_shake_01_1)
	(wake c03_intro_shake_01_2)
	(wake c03_intro_shake_01_3)

	(wake cinematic_light_01_city_01)
	(wake cinematic_light_01_pelican_01)
	(wake cinematic_light_01_iac_01)
	(wake cinematic_light_01_city_02)
	(wake cinematic_light_01_pelican_02)
	
	)
	
(script static void c03_intro_01_cleanup

	(object_destroy pelican_04)
	(player_effect_stop 0)
	
	)

(script static void c03_intro_scene_01

	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
	(c03_intro_01_problem_actors)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(03_intro_01_predict_stub)
	
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intro\music\c03_intro_01_mus)
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_01_fol)
	
	(sleep prediction_offset)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\03_intro\03_intro "03_intro_01" none "anchor_flag_intro")
	
	(c03_intro_01_setup)
	
	(custom_animation_relative chief objects\characters\masterchief\03_intro\03_intro "mc_01" false anchor_intro)
	(custom_animation_relative johnson objects\characters\marine\03_intro\03_intro "johnson_01" false anchor_intro)
	(custom_animation_relative miranda objects\characters\miranda\03_intro\03_intro "miranda_01" false anchor_intro)
	(custom_animation_relative pilot objects\characters\marine\03_intro\03_intro "marine1_01" false anchor_intro)
	(custom_animation_relative copilot objects\characters\marine\03_intro\03_intro "marine2_01" false anchor_intro)
	
	(custom_animation_relative pelican_01 objects\vehicles\pelican\03_intro\03_intro "pel1_01" false anchor_intro)
	(custom_animation_relative pelican_02 objects\vehicles\pelican\03_intro\03_intro "pel2_01" false anchor_intro)
	(custom_animation_relative pelican_03 objects\vehicles\pelican\03_intro\03_intro "pel3_01" false anchor_intro)
	(custom_animation_relative pelican_04 objects\vehicles\pelican\03_intro\03_intro "pel4_01" false anchor_intro)

	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\03_intro\03_intro "iac_01" anchor_intro)
	(scenery_animation_start_relative iac_bridge objects\cinematics\human\inamberclad_bridge\03_intro\03_intro "iac_bridge_01" anchor_intro)
	
	(sleep 10)
	
	(fade_in 0 0 0 60)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(03_intro_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_02_fol)

	(sleep (camera_time))
	
	(c03_intro_01_cleanup)
	
	)

; C03_INTRO_1 SCENE 02 ------------------------------------------------
; AI ------------------------------------------------------------------

(script command_script cs_hog_01
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 1)
	(cs_vehicle_speed .9)
	(ai_vehicle_enter_immediate intro_hog_01/driver (ai_vehicle_get_from_starting_location intro_hog_01/hog) warthog_d)
	(sleep 1)
	(object_hide (ai_get_object ai_current_actor) true)

	(cs_go_to intro_hog_targets/p0)
	(ai_erase ai_current_actor)
	)
	
(script command_script cs_hog_02
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 1)
	(cs_vehicle_speed .9)
	(ai_vehicle_enter_immediate intro_hog_02/driver (ai_vehicle_get_from_starting_location intro_hog_02/hog) warthog_d)
	(sleep 1)
	(object_hide (ai_get_object ai_current_actor) true)

	(cs_go_to intro_hog_targets/p0)
	)
	
(script command_script cs_hog_03
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 1)
	(ai_vehicle_enter_immediate intro_hog_03/driver (ai_vehicle_get_from_starting_location intro_hog_03/hog) warthog_d)
	(cs_vehicle_speed .9)
	(sleep 1)
	(object_hide (ai_get_object ai_current_actor) true)

	(cs_go_to intro_hog_targets/p1)
	)
	
(script command_script cs_hog_04
	(cs_force_combat_status 3)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 1)
	(cs_vehicle_speed .9)
	(ai_vehicle_enter_immediate intro_hog_04/driver (ai_vehicle_get_from_starting_location intro_hog_04/hog) warthog_d)
	(sleep 1)
	(object_hide (ai_get_object ai_current_actor) true)

	(cs_go_to intro_hog_targets/p1)
	)
	
(script dormant intro_hogs

	(sleep 146)
;	(sleep 146)
	
	(ai_place intro_hog_01)
	(ai_place intro_hog_02)
	(ai_place intro_hog_03)
	(ai_place intro_hog_04)
		
	(cs_run_command_script intro_hog_01/driver cs_hog_01)
	(cs_run_command_script intro_hog_02/driver cs_hog_02)
	(cs_run_command_script intro_hog_03/driver cs_hog_03)
	(cs_run_command_script intro_hog_04/driver cs_hog_04)
	
	)
	
; SOUND ---------------------------------------------------------------

(script dormant c03_intro_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_02_fol none 1)
	(print "c03_intro foley 02 start")
	)

(script dormant c03_intro_sound_scene2_01
	(sound_class_set_gain vehicle 0 0)
	(sleep 144)
	(sound_class_set_gain vehicle .25 0)
	)
	
;(script dormant c03_intro_sound_scene2_02
;	(sleep 90)
;	(sound_class_set_gain vehicle 0 120)
;	)
	
(script dormant c03_intro_sound_scene2_03
	(sleep 145)
	(sound_class_set_gain vehicle .25 15)
	(sound_class_set_gain vehicle .5 120)
	)
	
(script dormant c03_intro_sound_scene2_04
	(sleep 280)
	(sound_class_set_gain vehicle .25 10)
	(sound_class_set_gain vehicle .5 75)
	)
	
(script dormant c03_intro_sound_scene2_05
	(sleep 480)
	(sound_class_set_gain vehicle .5 50)
	)

(script dormant c03_1060_cor
	(sleep 0)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1060_cor none 1 radio_default_loop)
	(cinematic_subtitle c03_1060_cor 5)
	)

(script dormant c03_1070_cor
	(sleep 150)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1070_cor none 1 radio_default_loop)
	(cinematic_subtitle c03_1070_cor 3)
	)
	
(script dormant c03_1080_mrs
	(sleep 290)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1080_mrs spotter 1 radio_default_in)
	(cinematic_subtitle c03_1080_mrs 4)
	)

(script dormant c03_1090_dp1
	(sleep 407)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1090_dp1 none 1 radio_default_out)
	(cinematic_subtitle c03_1090_dp1 1)
	)
	
; EFFECTS -------------------------------------------------------------
	
(script dormant c03_intro_shake_02
	(sleep 350)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(player_effect_stop 1.5)
	)
	
(script dormant c03_intro_fov_01
	
;	(sleep 322)
	(sleep 232)
	(camera_set_field_of_view 36 0)
	(print "fov change: 50 -> 16 over 0 ticks")
	
	(sleep 13)
	(camera_set_field_of_view 60 14)
	(print "fov change: 16 -> 50 over 14 ticks")
	
	)

(script dormant cinematic_lighting_scene_02
	
	(cinematic_lighting_set_primary_light 43 122 0.54902 0.478431 0.34902)
	(cinematic_lighting_set_secondary_light -25 98 0.317647 0.313726 0.396078)
	(cinematic_lighting_set_ambient_light 0.101961 0.101961 0.101961)
	
	(object_uses_cinematic_lighting sniper 1)
	(object_uses_cinematic_lighting spotter 1)
	(object_uses_cinematic_lighting sniper_rifle 1)
	(object_uses_cinematic_lighting scope 1)
	
	)

; ---------------------------------------------------------------------

(script dormant white_flash
	(sleep 130)
	(fade_out 1 1 1 15)
	(sleep 30)
	(fade_in 1 1 1 15)
	)
	
(script dormant erase_hogs
	(time_code_reset)
	(sleep 279)
	(print "erase hogs")
	(ai_erase intro_hog_01)
	(ai_erase intro_hog_02)
	(ai_erase intro_hog_03)
	(ai_erase intro_hog_04)
	)

(script static void c03_intro_02_setup

	(object_create_anew sniper)
	(object_create_anew spotter)
	(object_create_anew sniper_rifle)
	(object_create_anew scope)
	
	(object_cinematic_lod sniper true)
	(object_cinematic_lod spotter true)
	(object_cinematic_lod sniper_rifle true)
	(object_cinematic_lod scope true)
	
	(wake c03_intro_sound_scene2_01)
;	(wake c03_intro_sound_scene2_02)
	(wake c03_intro_sound_scene2_03)
	(wake c03_intro_sound_scene2_04)
	(wake c03_intro_sound_scene2_05)
	
	(unit_set_emotional_state sniper pensive .5 0)
	(unit_set_emotional_state spotter pain .5 0)

	(wake c03_intro_foley_02)

	(wake c03_1060_cor)
	(wake c03_1070_cor)
	(wake c03_1080_mrs)
	(wake c03_1090_dp1)
	
	(wake intro_hogs)
	(wake erase_hogs)
	
	(wake c03_intro_shake_02)
	(wake c03_intro_fov_01)
	(wake cinematic_lighting_scene_02)
	
	(wake white_flash)
	
	)
	
(script static void c03_intro_02_cleanup

	(object_destroy sniper)
	(object_destroy spotter)
	(object_destroy scope)
	
	)

(script static void c03_intro_scene_02
	
	(camera_set_animation_relative objects\characters\cinematic_camera\03_intro\03_intro "03_intro_02" none "anchor_flag_intro")
	
	(c03_intro_02_setup)
	
	(pvs_set_object pelican_01)

	(custom_animation_relative sniper objects\characters\marine\03_intro\03_intro "sniper_02" false anchor_intro)
	(custom_animation_relative spotter objects\characters\marine\03_intro\03_intro "spotter_02" false anchor_intro)
	
	(custom_animation_relative pelican_01 objects\vehicles\pelican\03_intro\03_intro "pel1_02" false anchor_intro)
	(custom_animation_relative pelican_02 objects\vehicles\pelican\03_intro\03_intro "pel2_02" false anchor_intro)
	(custom_animation_relative pelican_03 objects\vehicles\pelican\03_intro\03_intro "pel3_02" false anchor_intro)

	(scenery_animation_start_relative sniper_rifle objects\weapons\rifle\sniper_rifle\03_intro\03_intro "sniper_rifle_02" anchor_intro)
	(scenery_animation_start_relative scope scenarios\objects\human\military\spotting_scope\03_intro\03_intro "scope_02" anchor_intro)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(03_intro_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_03_fol)
	
	(sleep (camera_time))
	
	(c03_intro_02_cleanup)
	
	)
	
; C03_INTRA_1 SCENE 03 ------------------------------------------------

(script dormant c03_intro_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_03_fol none 1)
	(print "c03_intro foley 03 start")
	)

(script dormant c03_intro_sound_scene3_01
	(sleep 635)
	(sound_class_set_gain vehicle 0 5)
	)
	
(script dormant c03_intro_sound_scene3_02
	(sleep 640)
	(sound_class_set_gain vehicle .5 135)
	)
	
(script dormant c03_intro_sound_scene3_03
	(sleep 805)
	
	(object_set_function_variable pelican_01 "turn_absolute" 1 75)
	(object_set_function_variable pelican_02 "turn_absolute" 1 75)
	(object_set_function_variable pelican_03 "turn_absolute" 1 75)

	(object_set_function_variable pelican_01 "banking_audio" 1 75)
	(object_set_function_variable pelican_02 "banking_audio" 1 75)
	(object_set_function_variable pelican_03 "banking_audio" 1 75)

	)
	
(script dormant c03_1100_dp1
	(sleep 5)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1100_dp1 pilot 1)
	(cinematic_subtitle c03_1100_dp1 1)
	)

(script dormant c03_1110_jon
	(sleep 63)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1110_jon johnson 1)
	(cinematic_subtitle c03_1110_jon 1)
	)
	
(script dormant c03_1120_jon
	(sleep 135)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1120_jon johnson 1)
	(cinematic_subtitle c03_1120_jon 2)
	)
	
(script dormant c03_1130_lhd
	(sleep 190)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1130_lhd none 1 radio_default_in)
	(cinematic_subtitle c03_1130_lhd 4)
	)
	
(script dormant c03_1140_lhd
	(sleep 314)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1140_lhd none 1 radio_default_out)
	(cinematic_subtitle c03_1140_lhd 5)
	)

(script dormant c03_1150_dp2
	(sleep 490)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_1150_dp2 none 1 radio_default_loop)
	(cinematic_subtitle c03_1150_dp2 1)
	)
	
; EFFECTS -------------------------------------------------------------
	
(script dormant c03_intro_shake_03
	(sleep 0)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	(sleep 405)
	(player_effect_stop 0)
	(print "shake stop")
	)	

(script dormant c03_intro_03_dof_1
	
	(sleep 96)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 1 0 0 0 1 1 0)
	(print "rack focus")
	
	(sleep 83)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	)
	
(script dormant c03_intro_03_dof_2
	(sleep 319)
	(print "dof values: 3 0 0 0 1 1 0")
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 3 0 0 0 1 1 0)
	(sleep 85)
	(print "dof values: 9 2.5 2.5 0 0 0 0")
	(cinematic_screen_effect_set_depth_of_field 9 2.5 2.5 0 0 0 0)
	(sleep 116)
	(print "dof stop")
	(cinematic_screen_effect_stop)
	)
	
(script dormant cinematic_lighting_scene_03
	
	(cinematic_lighting_set_primary_light 29 116 0.478431 0.415686 0.329412)
	(cinematic_lighting_set_secondary_light 20 272 0.235294 0.235294 0.384314)
	(cinematic_lighting_set_ambient_light 0 0 0)

	(object_uses_cinematic_lighting odst_01 1)
	(object_uses_cinematic_lighting odst_02 1)
	(object_uses_cinematic_lighting odst_03 1)
	(object_uses_cinematic_lighting odst_04 1)
	(object_uses_cinematic_lighting helmet 1)
	(object_uses_cinematic_lighting battle_rifle_01 1)
	(object_uses_cinematic_lighting battle_rifle_02 1)
	
	)
	
(script dormant cinematic_light_troopbay_03_01
	
	(sleep 178)
	(print "light bay")
	
	(object_hide odst_01 false)
	(object_hide odst_02 false)
	(object_hide odst_03 false)
	
	(cinematic_lighting_set_primary_light 4 278 0.54902 0.478431 0.34902)
	(cinematic_lighting_set_secondary_light -34 154 0.14902 0.141176 0.180392)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	)
	
(script dormant cinematic_light_chief_03_01
	
	(sleep 318)
	(print "light chief rev")
	
	(object_hide chief false)
	(object_hide odst_04 false)
	
	(cinematic_lighting_set_primary_light 4 240 0.54902 0.478431 0.34902)
	(cinematic_lighting_set_secondary_light -34 154 0.145098 0.141176 0.184314)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	)
	
(script dormant cinematic_light_street_03_01
	
	(sleep 403)
	(print "light street")
	
	(cinematic_lighting_set_primary_light 43 122 0.54902 0.478431 0.34902)
	(cinematic_lighting_set_secondary_light -25 98 0.317647 0.313726 0.396078)
	(cinematic_lighting_set_ambient_light 0.101961 0.101961 0.101961)
	
	)

; ---------------------------------------------------------------------

(script dormant save_dof_01

	(sleep 318)
	
	(print "delete marines, hide pelican")
	(object_destroy odst_01)
	(object_destroy odst_02)
	(object_destroy odst_03)
	(object_destroy battle_rifle_01)
	(object_destroy battle_rifle_02)
	(object_destroy sniper_rifle)
	
	(object_hide pelican_03 true)
	(object_hide offending_palm_01 true)
	(object_hide offending_palm_02 true)
	(object_hide offending_palm_03 true)
	(object_hide offending_palm_04 true)
	(object_hide offending_palm_05 true)
	(object_hide offending_palm_06 true)
	(object_hide offending_palm_07 true)
	(object_hide offending_palm_08 true)
	(object_hide offending_palm_09 true)
	(object_hide offending_palm_10 true)
	(object_hide offending_palm_11 true)
	(object_hide offending_palm_12 true)
	(object_hide offending_palm_13 true)
	(object_hide offending_palm_14 true)
	(object_hide offending_palm_15 true)
	(object_hide offending_palm_16 true)
	(object_hide offending_palm_17 true)
	(object_hide offending_palm_18 true)
	(object_hide offending_palm_19 true)
	(object_hide offending_palm_20 true)
	
	)

(script dormant show_trees_pelican

	(sleep 405)
	(print "show trees, pelican")

	(object_hide pelican_03 false)
	(object_hide offending_palm_01 false)
	(object_hide offending_palm_02 false)
	(object_hide offending_palm_03 false)
	(object_hide offending_palm_04 false)
	(object_hide offending_palm_05 false)
	(object_hide offending_palm_06 false)
	(object_hide offending_palm_07 false)
	(object_hide offending_palm_08 false)
	(object_hide offending_palm_09 false)
	(object_hide offending_palm_10 false)
	(object_hide offending_palm_11 false)
	(object_hide offending_palm_12 false)
	(object_hide offending_palm_13 false)
	(object_hide offending_palm_14 false)
	(object_hide offending_palm_15 false)
	(object_hide offending_palm_16 false)
	(object_hide offending_palm_17 false)
	(object_hide offending_palm_18 false)
	(object_hide offending_palm_19 false)
	(object_hide offending_palm_20 false)

	)
	
(script static void c03_intro_03_setup

	(object_create_anew odst_01)
	(object_create_anew odst_02)
	(object_create_anew odst_03)
	(object_create_anew odst_04)
	(object_create_anew helmet)
	(object_create_anew battle_rifle_01)
	(object_create_anew battle_rifle_02)
	
	(object_cinematic_lod odst_01 true)
	(object_cinematic_lod odst_02 true)
	(object_cinematic_lod odst_03 true)
	(object_cinematic_lod odst_04 true)
	(object_cinematic_lod helmet true)
	(object_cinematic_lod battle_rifle_01 true)
	(object_cinematic_lod battle_rifle_02 true)
	
	(object_hide odst_01 true)
	(object_hide odst_02 true)
	(object_hide odst_03 true)
	(object_hide odst_04 true)

	(object_set_permutation odst_01 "head" "morgan")
	(object_set_permutation odst_02 "head" "perez")
	(object_set_permutation odst_03 "head" "walter")
	(object_set_permutation odst_04 "head" "banks")
	
	(unit_set_emotional_state odst_01 angry .25 0)
	(unit_set_emotional_state odst_02 angry .25 0)
	(unit_set_emotional_state odst_03 angry .25 0)
	(unit_set_emotional_state odst_04 angry .25 0)

	(object_set_region_state odst_03 helmet destroyed)
	(object_set_region_state odst_04 helmet destroyed)

	(objects_attach odst_01 "right hand" battle_rifle_01 "")
	(objects_attach odst_02 "right hand" battle_rifle_02 "")

	(wake c03_intro_foley_03)

	(wake c03_intro_sound_scene3_01)
	(wake c03_intro_sound_scene3_02)
	(wake c03_intro_sound_scene3_03)

	(wake c03_1100_dp1)
	(wake c03_1110_jon)
	(wake c03_1120_jon)
	(wake c03_1130_lhd)
	(wake c03_1140_lhd)
	(wake c03_1150_dp2)

;	(wake c03_intro_03_dof_1)
;	(wake c03_intro_03_dof_2)
	
	(wake save_dof_01)
	(wake show_trees_pelican)
	
	(wake c03_intro_shake_03)
	(wake cinematic_lighting_scene_03)
	(wake cinematic_light_troopbay_03_01)
	(wake cinematic_light_chief_03_01)
	(wake cinematic_light_street_03_01)
	
	)
	
(script static void c03_intro_03_cleanup

	(object_destroy chief)
	(object_destroy johnson)
	(object_destroy_containing odst)
	(object_destroy helmet)
	(object_destroy battle_rifle_01)
	(object_destroy battle_rifle_02)
	(object_destroy sniper_rifle)
	(object_destroy magazine)
	
	)

(script static void c03_intro_scene_03
	
	(camera_set_animation_relative objects\characters\cinematic_camera\03_intro\03_intro "03_intro_03" none "anchor_flag_intro")
	
	(c03_intro_03_setup)
	
	(pvs_set_object pelican_01)
	
	(custom_animation_relative chief objects\characters\masterchief\03_intro\03_intro "mc_03" false anchor_intro)
	(custom_animation_relative johnson objects\characters\marine\03_intro\03_intro "johnson_03" false anchor_intro)
	
	(custom_animation_relative pilot objects\characters\marine\03_intro\03_intro "marine1_03" false anchor_intro)
	(custom_animation_relative copilot objects\characters\marine\03_intro\03_intro "marine2_03" false anchor_intro)
	
	(custom_animation_relative odst_01 objects\characters\marine\03_intro\03_intro "odst1_03" false anchor_intro)
	(custom_animation_relative odst_02 objects\characters\marine\03_intro\03_intro "odst2_03" false anchor_intro)
	(custom_animation_relative odst_03 objects\characters\marine\03_intro\03_intro "odst3_03" false anchor_intro)
	(custom_animation_relative odst_04 objects\characters\marine\03_intro\03_intro "odst4_03" false anchor_intro)
	
	(custom_animation_relative pelican_01 objects\vehicles\pelican\03_intro\03_intro "pel1_03" false anchor_intro)
	(custom_animation_relative pelican_02 objects\vehicles\pelican\03_intro\03_intro "pel2_03" false anchor_intro)
	(custom_animation_relative pelican_03 objects\vehicles\pelican\03_intro\03_intro "pel3_03" false anchor_intro)
	
	(scenery_animation_start_relative helmet objects\characters\marine\helmet_odst\03_intro\03_intro "helmet_03" anchor_intro)
	(scenery_animation_start_relative sniper_rifle objects\weapons\rifle\sniper_rifle\03_intro\03_intro "sniper_rifle_03" anchor_intro)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(03_intro_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_04_fol)
	
	(sleep (camera_time))
	
	(c03_intro_03_cleanup)
	
	)
	
; C03_INTRA_1 SCENE 04 ------------------------------------------------

(script dormant intro_scarab_gun_charge

	(sleep 200)
	(print "scarab gun charge")
	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_beam_charging scarab "primary_trigger")

	)

(script dormant intro_scarab_gun_fire

	(object_create intro_scarab_gun)
	(objects_attach scarab "primary_trigger" intro_scarab_gun "")

	(sleep 240)
	(print "scarab gun fire")
	(object_hide intro_scarab_gun true)
	(weapon_hold_trigger intro_scarab_gun 0 true)
	
	(sleep 120)

	(weapon_hold_trigger intro_scarab_gun 0 false)
	
	)
	
(script dormant intro_scarab_turret_fire

	(object_create intro_scarab_gun_turret)
	(objects_attach scarab_turret "primary_trigger" intro_scarab_gun_turret "")
	(object_hide intro_scarab_gun_turret true)

	(sleep 285)
	(print "scarab turret fire")
	(weapon_hold_trigger intro_scarab_gun_turret 0 true)
	
	)

(script dormant effect_pelican_hit_01

	(sleep 265)
	(print "pelican hit")
	(effect_new_on_object_marker effects\generic\explosions_air\human_vehicle_air_hit pelican_01 "johnson")
	
	)
	
(script dormant effect_pelican_impact_01

	(sleep 410)
	(print "pelican impact 1")
	
	(effect_new_on_object_marker effects\generic\explosions_air\human_vehicle_air_hit_small pelican_03 "light_cockpit_back")
	(sleep 5)
	(effect_new_on_object_marker effects\generic\explosions_air\human_vehicle_air_hit_small pelican_03 "hardpoint_left")
	
	)
	
(script dormant effect_pelican_impact_02

	(sleep 434)
	(print "pelican impact 2")
	(effect_new_on_object_marker effects\generic\explosions_air\human_vehicle_air_hit pelican_03 "johnson")
	
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion intro_junction_flag_01)
	
	)

(script dormant effect_blow_railings
	
	(sleep 450)
	
	(print "blow railings far")
	
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion intro_railing_flag_01)
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion intro_railing_flag_02)
	(sleep 5)
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion intro_railing_flag_03)
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion intro_railing_flag_04)
	
	)

; SCENE 04 EFFECTS ----------------------------------------------------

(script dormant c03_intro_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intro\foley\c03_intro_04_fol none 1)
	(print "c03_intro foley 04 start")
	)

(script dormant c03_1160_dp2
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_1160_dp2 pilot 1)
	(cinematic_subtitle c03_1160_dp2 2)
	)
	
(script dormant c03_intro_fov_02

	(sleep 382)
	(camera_set_field_of_view 30 0)
	(print "fov change: 50 -> 20 over 0 ticks")

	
	(sleep 18)
	(camera_set_field_of_view 60 20)
	(print "fov change: 20 -> 50 over 20 ticks")

	)
	
(script dormant c03_intro_shake_04
	(sleep 137)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .5 0)
	(player_effect_stop 1)
	)
	
(script dormant c03_intro_04_dof_1
	
	(sleep 58)

	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 2 1 1 0 0 0 0)
	(print "rack focus")
	
	(sleep 59)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")

	)

(script dormant c03_intro_04_dof_3
	(sleep 382)
	(print "dof stop")
	(cinematic_screen_effect_stop)
	)
	
(script dormant cinematic_lighting_scene_04
	
	(cinematic_lighting_set_primary_light 29 116 0.478431 0.415686 0.329412)
	(cinematic_lighting_set_secondary_light 20 272 0.235294 0.235294 0.384314)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	)
	
(script dormant cinematic_light_street_04_01
	
	(sleep 117)
	(print "light street")

	(cinematic_lighting_set_primary_light 43 122 0.54902 0.478431 0.34902)
	(cinematic_lighting_set_secondary_light -25 98 0.317647 0.313726 0.396078)
	(cinematic_lighting_set_ambient_light 0.101961 0.101961 0.101961)
	
	)
	
(script dormant effect_big_foot
	(time_code_reset)
	(sleep 126)
	(print "big foot")
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion bus_flag_01)
	(damage_new objects\weapons\grenade\frag_grenade\damage_effects\frag_grenade_explosion bus_flag_02)
	)
	
; ---------------------------------------------------------------------

(script static void c03_intro_04_setup

	(object_create_anew scarab)
	(object_create_anew scarab_turret)
	(object_create_anew_containing intro_railing)
	(object_create_anew_containing intro_crash)
	(object_create_anew the_fiscal_year)
	
	(object_cinematic_lod scarab true)
	(object_cinematic_lod scarab_turret true)
	(object_cinematic_lod the_fiscal_year true)
	
	(object_uses_cinematic_lighting scarab 1)
	(object_uses_cinematic_lighting scarab_turret 1)

	(wake c03_intro_foley_04)

	(wake c03_1160_dp2)
	
	(wake c03_intro_fov_02)
;	(wake c03_intro_04_dof_1)
;	(wake c03_intro_04_dof_3)
	(wake c03_intro_shake_04)
	
	(wake intro_scarab_gun_charge)
	(wake intro_scarab_gun_fire)
	(wake intro_scarab_turret_fire)
	
	(wake effect_big_foot)
	(wake effect_pelican_hit_01)
	(wake effect_pelican_impact_01)
	(wake effect_pelican_impact_02)
	(wake effect_blow_railings)
	
	(wake cinematic_lighting_scene_04)
	(wake cinematic_light_street_04_01)
	
	)
	
(script static void c03_intro_04_cleanup

	(object_destroy pilot)
	(object_destroy copilot)
	(object_destroy_containing scarab)
	(object_destroy_containing pelican)
	(object_destroy the_fiscal_year)
	
	)

(script static void c03_intro_scene_04
	
	(camera_set_animation_relative objects\characters\cinematic_camera\03_intro\03_intro "03_intro_04" none "anchor_flag_intro")
	
	(c03_intro_04_setup)
	
	(pvs_set_object pelican_01)
	
	(custom_animation_relative pilot objects\characters\marine\03_intro\03_intro "marine1_04" false anchor_intro)
	(custom_animation_relative copilot objects\characters\marine\03_intro\03_intro "marine2_04" false anchor_intro)
	
	(custom_animation_relative pelican_01 objects\vehicles\pelican\03_intro\03_intro "pel1_04" false anchor_intro)
	(custom_animation_relative pelican_02 objects\vehicles\pelican\03_intro\03_intro "pel2_04" false anchor_intro)
	(custom_animation_relative pelican_03 objects\vehicles\pelican\03_intro\03_intro "pel3_04" false anchor_intro)
	
	(scenery_animation_start_relative scarab scenarios\objects\covenant\military\scarab\03_intro\03_intro "scarab_04" anchor_intro)
	(scenery_animation_start_relative scarab_turret scenarios\objects\covenant\military\scarab\scarab_upper_gun\03_intro\03_intro "scarab_upper_gun_04" anchor_intro)
	
	(sleep (- (camera_time) 60))
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .5 2)
	
	(sleep (- (camera_time) 5))
	
	(print "cut to black")
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(c03_intro_04_cleanup)
	
	(sleep 30)
	
	(player_effect_stop 0)
	
	)
	
; C03_INTRO MASTER SCRIPT =============================================
; =====================================================================

(script static void c03_intro

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name earthcity_cine_intro_bsp)
	(sleep 1)
	
	(c03_intro_scene_01)
	(c03_intro_scene_02)
	(c03_intro_scene_03)
	(c03_intro_scene_04)

	(rasterizer_bloom_override 0)
	
	)
	
; BLURRY BEGINNING ====================================================
; =====================================================================

(script static void chief_recovery_sequence

	(camera_control off)
	(player_camera_control true)

(if (= "easy" (game_difficulty_get_real))
	(begin
		
		(print "recovery - easy")

		(fade_out 0 0 0 0)
		(cinematic_start)
		(cinematic_show_letterbox_immediate 1)

		(interpolator_start blurry_vision 1 .001)
		(sleep 30)
	
		(fade_in 0 0 0 30)
		
		(sound_impulse_start sound\dialog\levels\03_earthcity\mission\l03_9000_cor none 1)
		
		(sleep 35)
		(fade_out 0 0 0 30)
		(sleep 45)
		(fade_in 0 0 0 20)
		(sleep 25)
		(fade_out 0 0 0 15)
		(sleep 20)
		(fade_in 0 0 0 15)
	
		(player_enable_input 0)

		(cinematic_stop)
		(cinematic_show_letterbox_immediate 1)
		(interpolator_start blurry_vision 0 3)
		
		(sleep 30)
		(player_enable_input 1)
	)
	)
	
	(if (= "normal" (game_difficulty_get_real))
	(begin
	
		(print "recovery - normal")

		(fade_out 0 0 0 0)
		(cinematic_start)
		(cinematic_show_letterbox_immediate 1)
	
		(interpolator_start blurry_vision 1 .001)
		(sleep 30)
	
		(fade_in 0 0 0 30)
		
		(sound_impulse_start sound\dialog\levels\03_earthcity\mission\l03_9030_cor none 1)
		
		(sleep 35)
		(fade_out 0 0 0 30)
		(sleep 45)
		(fade_in 0 0 0 20)
		(sleep 25)
		(fade_out 0 0 0 15)
		(sleep 20)
		(fade_in 0 0 0 15)
	
		(player_enable_input 0)
		
		(cinematic_stop)
		(cinematic_show_letterbox_immediate 1)
		(interpolator_start blurry_vision 0 3)
	
		(sleep 30)
		(player_enable_input 1)
	)
	)
	
	(if (= "heroic" (game_difficulty_get_real))
	(begin
		
		(print "recovery - heroic")

		(fade_out 0 0 0 0)
		(cinematic_start)
		(cinematic_show_letterbox_immediate 1)
		
		(interpolator_start blurry_vision 1 .001)
		(sleep 30)
	
		(fade_in 0 0 0 30)
		
		(sound_impulse_start sound\dialog\levels\03_earthcity\mission\l03_9020_cor none 1)
		
		(sleep 35)
		(fade_out 0 0 0 30)
		(sleep 45)
		(fade_in 0 0 0 20)
		(sleep 25)
		(fade_out 0 0 0 15)
		(sleep 20)
		(fade_in 0 0 0 15)
	
		(player_enable_input 0)
		
		(cinematic_stop)
		(cinematic_show_letterbox_immediate 1)
		(interpolator_start blurry_vision 0 3)
	
		(sleep 30)
		(player_enable_input 1)
	)
	)
	
	(if (= "legendary" (game_difficulty_get_real))
	(begin
				
		(print "recovery - legendary")

		(fade_out 0 0 0 0)
		(cinematic_start)
		(cinematic_show_letterbox_immediate 1)

		(interpolator_start blurry_vision 1 .001)
		(sleep 30)
	
		(fade_in 0 0 0 30)
		
		(sound_impulse_start sound\dialog\levels\03_earthcity\mission\l03_9010_cor none 1)
		
		(sleep 35)
		(fade_out 0 0 0 30)
		(sleep 45)
		(fade_in 0 0 0 20)
		(sleep 25)
		(fade_out 0 0 0 15)
		(sleep 20)
		(fade_in 0 0 0 15)
	
		(player_enable_input 0)
		
		(cinematic_stop)
		(cinematic_show_letterbox_immediate 1)
		(interpolator_start blurry_vision 0 3)
	
		(sleep 30)
		(player_enable_input 1)
	)
	)
	
;	(player_camera_control true)
	
	)