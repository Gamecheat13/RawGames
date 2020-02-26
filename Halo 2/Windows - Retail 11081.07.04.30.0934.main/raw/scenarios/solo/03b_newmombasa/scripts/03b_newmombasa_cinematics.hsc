; CINEMATICS FOR LEVEL 03B, "NEW MOMBASA" =============================
; =====================================================================

;*
	To One Who Has Been Long In City Pent

		To one who has been long in city pent,
    		'Tis very sweet to look into the fair
    		And open face of heaven,--to breathe a prayer
		Full in the smile of the blue firmament.
		Who is more happy, when, with heart's content,
    		Fatigued he sinks into some pleasant lair
    		Of wavy grass, and reads a debonair
		And gentle tale of love and languishment?
		Returning home at evening, with an ear
    		Catching the notes of Philomel,--an eye
		Watching the sailing cloudlet's bright career,
    		He mourns that day so soon has glided by:
		E'en like the passage of an angel's tear
    		That falls through the clear ether silently.

			- John Keats
*;

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)

	(script stub void 03_intra1_01_predict_stub (print "predict 01"))
	(script stub void 03_intra1_02a_predict_stub (print "predict 02a"))
	(script stub void 03_intra1_02b_predict_stub (print "predict 02b"))
	(script stub void 03_intra1_02c_predict_stub (print "predict 02c"))
	(script stub void 03_intra1_03_predict_stub (print "predict 03"))

	(script stub void x03_01_predict_stub (print "predict 01"))
	(script stub void x03_02_predict_stub (print "predict 02"))
	(script stub void x03_03_predict_stub (print "predict 03"))
	(script stub void x03_04_predict_stub (print "predict 04"))
	(script stub void x03_05_predict_stub (print "predict 05"))
	(script stub void x03_06_predict_stub (print "predict 06"))
	(script stub void x03_07_predict_stub (print "predict 07"))
	(script stub void x03_08_predict_stub (print "predict 08"))

; C03_INTRA_1 SCENE 01 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c03_intra1_sound_scene1_01
	(sound_class_set_gain vehicle_engine 0 0)	
	(sleep 390)
	(sound_class_set_gain vehicle_engine .5 60)
	)

(script dormant c03_intra1_score_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intra1\music\c03_intra1_01_mus none 1)
	(print "c03_intro score 01 start")
	)
	
(script dormant c03_intra1_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intra1\foley\c03_intra1_01_fol none 1)
	(print "c03_intro foley 01 start")
	)

(script dormant c03_2010_mr3
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2010_mr3 marine_01 1)
	(cinematic_subtitle c03_2010_mr3 4)
	
	(unit_set_emotional_state marine_01 scared 1 0)
	(print "marine_01 - scared 1 0")
	
	)

(script dormant c03_2020_mr4

	(unit_set_emotional_state marine_02 shocked .25 0)
	(print "marine_02 - shocked .25 0")

	(sleep 200)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2020_mr4 marine_02 1)
	(cinematic_subtitle c03_2020_mr4 2)
	
	(sleep 15)
	
	(unit_set_emotional_state marine_02 angry .5 30)
	(print "marine_02 - angry .5 30")
	
	)
	
(script dormant c03_2030_mr4
	(sleep 278)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2030_mr4 marine_02 1)
	(cinematic_subtitle c03_2030_mr4 3)
	)
	
; EFFECTS -------------------------------------------------------------
	
(script dormant c03_intra1_fov_01

	(time_code_reset)

	(sleep 263)
	(camera_set_field_of_view 14 0)
	(sleep 1)
	(camera_set_field_of_view 10 144)
	
	(time_code_reset)
	
	(sleep 144)
	(camera_set_field_of_view 60 0)
	)

(script dormant drop_tank
	(sleep 598)
	(objects_detach pelican_01a scorpion_01)
	(print "special delivery")
	)

(script dormant destroy_scarab
	(sleep 410)
	(object_destroy scarab_01)
	(print "destroy scarab")
	)

(script dormant c03_intra1_cinematic_light_01
	
	(cinematic_lighting_set_primary_light 27 228 0.360784 0.317647 0.203922)
	(cinematic_lighting_set_secondary_light -35 100 0.0901961 0.109804 0.14902)
	(cinematic_lighting_set_ambient_light 0.101961 0.101961 0.0666667)

	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .6)
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting johnson 1)
	(object_uses_cinematic_lighting marine_01 1)
	(object_uses_cinematic_lighting marine_02 1)
	(object_uses_cinematic_lighting rifle_01 1)
	(object_uses_cinematic_lighting rifle_02 1)
	(object_uses_cinematic_lighting rifle_03 1)
	(object_uses_cinematic_lighting pelican_01a 1)
	(object_uses_cinematic_lighting scarab_02 1)
	(object_uses_cinematic_lighting scorpion_01 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script dormant c03_intra1_problem_actors
	
	(print "problem actors")
	(object_create_anew marine_01)
	(object_create_anew marine_02)
	(object_create_anew rifle_02)
	(object_create_anew rifle_03)
	
	(object_cinematic_lod marine_01 true)
	(object_cinematic_lod marine_02 true)

	(objects_attach marine_01 "right hand" rifle_02 "")
	(objects_attach marine_02 "right hand" rifle_03 "")
	(object_set_permutation marine_02 "head" "michelle")

	)

; ---------------------------------------------------------------------

(script static void c03_intra1_01_setup

	(object_create_anew chief)
	(object_create_anew johnson)
	
	(object_create_anew pelican_01a)
	(object_create_anew scorpion_01)
	(object_create_anew scarab_01)

	(object_create_anew rifle_01)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod johnson true)
	
	(object_cinematic_lod pelican_01a true)
	(object_cinematic_lod scorpion_01 true)
	(object_cinematic_lod scarab_01 true)
	
	(objects_attach chief "right hand" rifle_01 "")
	(objects_attach pelican_01a "pelican_sc_01" scorpion_01 "scorpion_b_t")
	(object_set_function_variable pelican_01a "hover" 1 0)
	
	(wake c03_intra1_sound_scene1_01)
	(wake c03_intra1_score_01)
	(wake c03_intra1_foley_01)
	
	(wake c03_2010_mr3)
	(wake c03_2020_mr4)
	(wake c03_2030_mr4)
	
	(wake c03_intra1_fov_01)
	(wake c03_intra1_cinematic_light_01)

	(wake drop_tank)
	(wake destroy_scarab)
	
	)

(script static void c03_intra1_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(03_intra1_01_predict_stub)
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intra1\music\c03_intra1_01_mus)
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intra1\foley\c03_intra1_01_fol)
	(wake c03_intra1_problem_actors)
	
	(sleep prediction_offset)
	
	(c03_intra1_01_setup)

	(camera_set_animation_relative objects\characters\cinematic_camera\03_intra1\03_intra1 "03_intra1_01" none "anchor_flag_intra1")	

	(custom_animation_relative chief objects\characters\masterchief\03_intra1\03_intra1 "chief_01" false anchor_intra1)
	(custom_animation_relative johnson objects\characters\marine\03_intra1\03_intra1 "johnson_01" false anchor_intra1)
	(custom_animation_relative marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_01" false anchor_intra1)
	(custom_animation_relative marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_01" false anchor_intra1)
	(custom_animation_relative pelican_01a objects\vehicles\pelican\03_intra1\03_intra1 "pelican_01" false anchor_intra1)
	
	(scenery_animation_start_relative scarab_01 scenarios\objects\covenant\military\scarab\03_intra1\03_intra1 "scarab_01" anchor_intra1)
	
;	(print "cache block")
;	(sleep 1)
;	(cache_block_for_one_frame)	

;	safety white
	(sleep 45)
	
	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(03_intra1_02a_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intra1\foley\c03_intra1_02a_fol)
	
	(sleep (camera_time))
	
	)
	
; C03_INTRA_1 SCENE 02A -----------------------------------------------

(script dormant c03_intra1_foley_02a
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intra1\foley\c03_intra1_02a_fol none 1)
	(print "c03_intro foley 02a start")
	)

(script dormant c03_2040_jon
	(sleep 115)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2040_jon johnson 1)
	(cinematic_subtitle c03_2040_jon 1)
	)
	
(script dormant c03_2050_mr4
	(sleep 161)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2050_mr4 marine_02 1)
	(cinematic_subtitle c03_2050_mr4 1)
	)
	
(script dormant c03_2060_mr3
	(sleep 200)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2060_mr3 marine_01 1)
	(cinematic_subtitle c03_2060_mr3 3)
	(unit_set_emotional_state marine_01 scared .5 30)
	(print "marine_01 - angry .5 30")
	)
	
(script dormant c03_2070_jon
	(sleep 288)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2070_jon johnson 1)
	(cinematic_subtitle c03_2070_jon 1)
	(unit_set_emotional_state johnson angry .5 30)
	(print "johnson - angry .5 30")
	)
	
(script dormant c03_2080_mr3
	(sleep 328)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2080_mr3 marine_01 1)
	(cinematic_subtitle c03_2080_mr3 1)
	)

(script dormant c03_2090_jon
	(sleep 370)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2090_jon johnson 1)
	(cinematic_subtitle c03_2090_jon 1)
	)

(script dormant swap_tanks

	(sleep 200)
	(object_destroy scorpion_01)
	(object_create_anew scorpion_02)
	(object_cinematic_lod scorpion_02 true)
	(object_uses_cinematic_lighting scorpion_02 1)
	(print "swap tanks")
	
	)	

(script static void c03_intra1_02a_setup

	(wake c03_2040_jon)
	(wake c03_2050_mr4)
	(wake c03_2060_mr3)
	(wake c03_2070_jon)
	(wake c03_2080_mr3)
	(wake c03_2090_jon)
	
	(wake c03_intra1_foley_02a)

	(wake swap_tanks)
	
	)

(script static void c03_intra1_scene_02a
	
	(c03_intra1_02a_setup)

	(camera_set_animation_relative objects\characters\cinematic_camera\03_intra1\03_intra1 "03_intra1_02a" none "anchor_flag_intra1")
	
	(custom_animation_relative_loop chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02a" false anchor_intra1)
	(custom_animation_relative johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02a" false anchor_intra1)
	(custom_animation_relative_loop marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02a" false anchor_intra1)
	(custom_animation_relative_loop marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02a" false anchor_intra1)
	
	(custom_animation_relative pelican_01a objects\vehicles\pelican\03_intra1\03_intra1 "pelican_02a" false anchor_intra1)
	(custom_animation_relative_loop scorpion_01 objects\vehicles\scorpion\03_intra1\03_intra1 "scorpion_02a" false anchor_intra1)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(03_intra1_02b_predict_stub)

	(sleep (camera_time))
	
	(object_destroy pelican_01a)
	
	)

; C03_INTRA_1 SCENE 02B -----------------------------------------------

(script dormant c03_intra1_speech_easy

	(custom_animation_relative_loop johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02b_easy" false anchor_intra1)
	(custom_animation_relative_loop chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02b" false anchor_intra1)
	(custom_animation_relative_loop marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02b" false anchor_intra1)
	(custom_animation_relative_loop marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02b" false anchor_intra1)
	(sleep 5)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2097_jon none 1)
	(cinematic_subtitle c03_2097_jon 8)
	)
	
(script dormant c03_intra1_speech_normal

	(custom_animation_relative_loop johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02b_easy" false anchor_intra1)
	(custom_animation_relative_loop chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02b" false anchor_intra1)
	(custom_animation_relative_loop marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02b" false anchor_intra1)
	(custom_animation_relative_loop marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02b" false anchor_intra1)
	(sleep 5)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2091_jon none 1)
	(cinematic_subtitle c03_2091_jon 8)
	)
	
(script dormant c03_intra1_speech_heroic

	(custom_animation_relative_loop johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02b_easy" false anchor_intra1)
	(custom_animation_relative_loop chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02b" false anchor_intra1)
	(custom_animation_relative_loop marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02b" false anchor_intra1)
	(custom_animation_relative_loop marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02b" false anchor_intra1)
	(sleep 5)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2093_jon none 1)
	(cinematic_subtitle c03_2093_jon 8)
	)
	
(script dormant c03_intra1_speech_legendary

	(custom_animation_relative_loop johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02b_easy" false anchor_intra1)
	(custom_animation_relative_loop chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02b" false anchor_intra1)
	(custom_animation_relative_loop marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02b" false anchor_intra1)
	(custom_animation_relative_loop marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02b" false anchor_intra1)
	(sleep 5)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2095_jon none 1)
	(cinematic_subtitle c03_2095_jon 8)
	)

(script static void c03_intra1_scene_02b

(if (= "easy" (game_difficulty_get_real))
	(begin
		
		(print "easy speech")
		(wake c03_intra1_speech_easy)
		(camera_set c03_intra1_01 0)
		(camera_set c03_intra1_02 261)
		(sleep 261)
		(sleep 15)
	)
	)
	
	(if (= "normal" (game_difficulty_get_real))
	(begin
	
		(print "normal speech")
		(wake c03_intra1_speech_normal)
		(camera_set c03_intra1_01 0)
		(camera_set c03_intra1_02 246)
		(sleep 246)
		(sleep 15)
	)
	)
	
	(if (= "heroic" (game_difficulty_get_real))
	(begin
		
		(print "heroic speech")
		(wake c03_intra1_speech_heroic)
		(camera_set c03_intra1_01 0)
		(camera_set c03_intra1_02 290)
		(sleep 290)
		(sleep 15)
	)
	)
	
	(if (= "legendary" (game_difficulty_get_real))
	(begin
				
		(print "legendary speech")
		(wake c03_intra1_speech_legendary)
		(camera_set c03_intra1_01 0)
		(camera_set c03_intra1_02 320)
		(sleep 320)
		(sleep 15)
	)
	)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(03_intra1_02c_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intra1\foley\c03_intra1_02c_fol)
	
	)
	
; C03_INTRA_1 SCENE 02C -----------------------------------------------

(script dormant c03_intra1_foley_02c
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intra1\foley\c03_intra1_02c_fol none 1)
	(print "c03_intra1 foley 02c start")
	)

(script dormant c03_2092_jon
	(sleep 4)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2092_jon johnson 1)
	(cinematic_subtitle c03_2092_jon 2)
	
	(sleep 65)
	(unit_set_emotional_state marine_01 shocked .5 30)
	(print "marine_01 - shocked .5 30")
	
	)
	
(script dormant c03_2094_jon
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2094_jon johnson 1)
	(cinematic_subtitle c03_2094_jon 2)
	
	(sleep 65)
	(unit_set_emotional_state marine_01 shocked .5 30)
	(print "marine_01 - shocked .5 30")
	)
	
(script dormant c03_2096_jon
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2096_jon johnson 1)
	(cinematic_subtitle c03_2096_jon 2)
	
	(sleep 65)
	(unit_set_emotional_state marine_01 shocked .5 30)
	(print "marine_01 - shocked .5 30")
	)
	
(script dormant c03_2098_jon
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2098_jon johnson 1)
	(cinematic_subtitle c03_2098_jon 2)
	
	(sleep 65)
	(unit_set_emotional_state marine_01 shocked .5 30)
	(print "marine_01 - shocked .5 30")
	)

(script dormant c03_2100_mr4
	(sleep 81)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2100_mr4 marine_02 1)
	(cinematic_subtitle c03_2100_mr4 1)
	)
	
(script dormant c03_2100_mr4_hard
	(sleep 86)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2100_mr4 marine_02 1)
	(cinematic_subtitle c03_2100_mr4 1)
	)

(script dormant c03_2100_mr4_leg
	(sleep 102)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2100_mr4 marine_02 1)
	(cinematic_subtitle c03_2100_mr4 1)
	)
	
(script dormant c03_2110_jon
	(sleep 119)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2110_jon johnson 1)
	(cinematic_subtitle c03_2110_jon 3)
	
	(sleep 90)
	(unit_set_emotional_state marine_01 repulsed .25 60)
	(print "marine_01 - repulsed .25 60")
	
	)
	
(script dormant c03_2110_jon_leg
	(sleep 133)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2110_jon johnson 1)
	(cinematic_subtitle c03_2110_jon 3)
	)
	
(script dormant c03_2120_jon
	(sleep 235)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2120_jon johnson 1)
	(cinematic_subtitle c03_2120_jon 3)
	)
	
(script dormant c03_2120_jon_leg
	(sleep 249)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2120_jon johnson 1)
	(cinematic_subtitle c03_2120_jon 2)
	)
	
(script dormant c03_2130_mr4
	(sleep 301)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2130_mr4 marine_02 1)
	(cinematic_subtitle c03_2130_mr4 1)
	)
	
(script dormant c03_2130_mr4_leg
	(sleep 315)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2130_mr4 marine_02 1)
	(cinematic_subtitle c03_2130_mr4 1)
	)
	
(script dormant c03_2140_cor
	(sleep 352)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_2140_cor none 1 radio_default_in)
	(cinematic_subtitle c03_2140_cor 3)
	)

(script dormant c03_2140_cor_leg
	(sleep 366)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\c03_2140_cor none 1 radio_default_loop)
	(cinematic_subtitle c03_2140_cor 3)
	)

(script static void c03_intra1_scene_02c

	(unit_set_emotional_state johnson angry .5 0)
	(print "johnson - angry .5 0")
	
	(unit_set_emotional_state marine_01 scared .5 0)
	(print "marine_01 - scared .5 0")
	
(if (= "easy" (game_difficulty_get_real))
	(begin
		
		(print "easy speech")
		
		(object_create_anew cigar)
		
		(wake c03_2098_jon)
		(wake c03_2100_mr4)
		(wake c03_2110_jon)
		(wake c03_2120_jon)
		(wake c03_2130_mr4)
		(wake c03_2140_cor)
		
		(wake c03_intra1_foley_02c)
		
		(camera_set_animation_relative objects\characters\cinematic_camera\03_intra1\03_intra1 "03_intra1_02ce" none "anchor_flag_intra1")
		
		(custom_animation_relative chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02ce" false anchor_intra1)
		(custom_animation_relative johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02ce" false anchor_intra1)
		(custom_animation_relative marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02ce" false anchor_intra1)
		(custom_animation_relative marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02ce" false anchor_intra1)
		(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\03_intra1\03_intra1 "cigar_02e" anchor_intra1)
	)
	)
	
	(if (= "normal" (game_difficulty_get_real))
	(begin
	
		(print "normal speech")
		
		(object_create_anew cigar)
		
		(wake c03_2092_jon)
		(wake c03_2100_mr4)
		(wake c03_2110_jon)
		(wake c03_2120_jon)
		(wake c03_2130_mr4)
		(wake c03_2140_cor)
		
		(wake c03_intra1_foley_02c)
		
		(camera_set_animation_relative objects\characters\cinematic_camera\03_intra1\03_intra1 "03_intra1_02cn" none "anchor_flag_intra1")
		
		(custom_animation_relative chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02cn" false anchor_intra1)
		(custom_animation_relative johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02cn" false anchor_intra1)
		(custom_animation_relative marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02cn" false anchor_intra1)
		(custom_animation_relative marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02cn" false anchor_intra1)
		(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\03_intra1\03_intra1 "cigar_02n" anchor_intra1)
	)
	)
	
	(if (= "heroic" (game_difficulty_get_real))
	(begin
		
		(print "heroic speech")
		
		(object_create_anew cigar)
		
		(wake c03_2094_jon)
		(wake c03_2100_mr4_hard)
		(wake c03_2110_jon)
		(wake c03_2120_jon)
		(wake c03_2130_mr4)
		(wake c03_2140_cor)
		
		(wake c03_intra1_foley_02c)
		
		(camera_set_animation_relative objects\characters\cinematic_camera\03_intra1\03_intra1 "03_intra1_02ch" none "anchor_flag_intra1")
		
		(custom_animation_relative chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02ch" false anchor_intra1)
		(custom_animation_relative johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02ch" false anchor_intra1)
		(custom_animation_relative marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02ch" false anchor_intra1)
		(custom_animation_relative marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02ch" false anchor_intra1)
		(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\03_intra1\03_intra1 "cigar_02h" anchor_intra1)
	)
	)
	
	(if (= "legendary" (game_difficulty_get_real))
	(begin
				
		(print "legendary speech")
		
		(object_create_anew cigar)
		
		(wake c03_2096_jon)
		(wake c03_2100_mr4_leg)
		(wake c03_2110_jon_leg)
		(wake c03_2120_jon_leg)
		(wake c03_2130_mr4_leg)
		(wake c03_2140_cor_leg)
	
		(wake c03_intra1_foley_02c)
		
		(camera_set_animation_relative objects\characters\cinematic_camera\03_intra1\03_intra1 "03_intra1_02cl" none "anchor_flag_intra1")
		
		(custom_animation_relative chief objects\characters\masterchief\03_intra1\03_intra1 "chief_02cl" false anchor_intra1)
		(custom_animation_relative johnson objects\characters\marine\03_intra1\03_intra1 "johnson_02cl" false anchor_intra1)
		(custom_animation_relative marine_01 objects\characters\marine\03_intra1\03_intra1 "marine01_02cl" false anchor_intra1)
		(custom_animation_relative marine_02 objects\characters\marine\03_intra1\03_intra1 "marine02_02cl" false anchor_intra1)
		(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\03_intra1\03_intra1 "cigar_02l" anchor_intra1)
	)
	)

	(sleep (- (camera_time) 15))
	
	(object_destroy pelican_01a)
	(object_destroy cigar)
	
	(print "problem actors")
	(object_create_anew pelican_01b)
	(object_create_anew rear_gun)
	
	(object_cinematic_lod pelican_01b true)
	(object_cinematic_lod rear_gun true)
	
	(object_uses_cinematic_lighting pelican_01b 1)
	(object_uses_cinematic_lighting rear_gun 1)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(03_intra1_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\c03_intra1\foley\c03_intra1_03_fol)

	(sleep (camera_time))

	)
	
; C03_INTRA_1 SCENE 03 ------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c03_intra1_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\c03_intra1\foley\c03_intra1_03_fol none 1)
	(print "c03_intra1 foley 03 start")
	)

(script dormant c03_2150_jon
	(sleep 59)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\c03_2150_jon johnson 1)
	(cinematic_subtitle c03_2150_jon 2)
	(sleep 15)
	(unit_set_emotional_state johnson amorous 1 15)
	(print "johnson - amorous 1 15")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant c03_intra1_cinematic_light_03

	(cinematic_lighting_set_primary_light 31 72 0.105882 0.0941177 0.0705882)
	(cinematic_lighting_set_secondary_light 17 56 0.0784314 0.0784314 0.129412)
	(cinematic_lighting_set_ambient_light 0.0392157 0.0392157 0.0392157)	
	
	)
	
; ---------------------------------------------------------------------
	
(script static void c03_intra1_03_setup

	(wake c03_2150_jon)
	(wake c03_intra1_foley_03)
	
	(wake c03_intra1_cinematic_light_03)
	
	)
	
(script static void c03_intra1_03_cleanup
	
	(object_destroy chief)
	(object_destroy johnson)
	(object_destroy marine_01)
	(object_destroy marine_02)
	(object_destroy rear_gun)
	
	(object_destroy pelican_01b)
	(object_destroy scorpion_02)
	
	(object_destroy rifle_01)
	(object_destroy rifle_02)
	(object_destroy rifle_03)
	
	)

(script static void c03_intra1_scene_03
	
	(c03_intra1_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\03_intra1\03_intra1 "03_intra1_03" none "anchor_flag_intra1")
	
	(custom_animation_relative johnson objects\characters\marine\03_intra1\03_intra1 "johnson_03" false anchor_intra1)
	(custom_animation_relative pelican_01b objects\vehicles\pelican\03_intra1\03_intra1 "pelican_03" false anchor_intra1)
	(scenery_animation_start_relative rear_gun objects\vehicles\pelican\pelican_rear_gun\03_intra1\03_intra1 "rear_gun_03" anchor_intra1)

	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c03_intra1_03_cleanup)
	
	(sleep 30)
	
	)

; C03_INTRA_1 MASTER SCRIPT ===========================================
; =====================================================================

(script static void c03_intra1

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(sound_class_set_gain vehicle_collision 0 0)
	(sound_class_set_gain amb .25 1)
	
	(switch_bsp_by_name earthcity_3b)
	(sleep 1)
	
	(c03_intra1_scene_01)
	(c03_intra1_scene_02a)
	(c03_intra1_scene_02b)
	(c03_intra1_scene_02c)
	(c03_intra1_scene_03)
	
	(sound_class_set_gain vehicle_collision 1 1)
	(sound_class_set_gain amb 1 1)
	(rasterizer_bloom_override 0)
	
	)

; X03 =================================================================
; =====================================================================

; X03 SCENE 01 --------------------------------------------------------
; SOUND ---------------------------------------------------------------
	
(script dormant x03_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\x03\foley\x03_01_fol none 1)
	(print "x03 foley 01 start")
	)

(script dormant x03_0010_jon
	(sleep 484)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\x03_0010_jon johnson 1 radio_default)
	(cinematic_subtitle x03_0010_jon 2)
	)
	
(script dormant x03_0020_mir
	(sleep 552)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\x03_0020_mir none 1 radio_default)
	(cinematic_subtitle x03_0020_mir 1.5)
	)
	
; EFFECTS -------------------------------------------------------------
	
(script dormant x03_fov_01

	(sleep 88)
	(print "fov change: 65 -> 45 over 90 ticks")
	(camera_set_field_of_view 55 90)
	
	(sleep 91)
	(print "fov change: 45 -> 50 over 0 ticks")
	(camera_set_field_of_view 60 0)
	
	(sleep 299)
	(print "fov change: 50 -> 20 over 0 ticks")
	(camera_set_field_of_view 20 0)
	
	(object_destroy scarab_02)
	
	)
	
(script dormant x03_01_dof_1

	(sleep 479)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 1 1 0 0 0 0)
	(print "rack focus")

	)
	
(script dormant scarab_shake_1
	(sleep 135)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	)
	
(script dormant scarab_shake_2
	(sleep 179)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .4 0)
	(sleep 25)
	(player_effect_stop 3)
	)
	
(script dormant effect_scarab_death

	(sleep 27)
	(print "blow main-gun")
	
	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_death_explosion_mouth scarab_02 "primary_trigger")

	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_death_explosion scarab_02 "head_destroyed_cine")	
	(sleep 2)
	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_death_explosion scarab_02 "neck_destroyed_cine")	
	(sleep 3)
	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_death_explosion scarab_02 "neck_destroyed2_cine")		
	(sleep 5)
	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_death_explosion scarab_02 "knee_destroyed_cine")		
	(sleep 2)
	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_death_explosion scarab_02 "belly_destroyed_cine")		
	(sleep 3)
	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_death_explosion scarab_02 "calf_destroyed_cine")		
	(sleep 5)
	(effect_new_on_object_marker effects\scenarios\objects\covenant\military\scarab\scarab_death_explosion scarab_02 "knee_destroyed02_cine")		
	)
	
(script dormant effect_smoke_start
	(sleep 165)
	(print "smoke start")
	(object_create x03_smoke)
	)
	
(script dormant effect_smoke_stop
	(sleep 475)
	(print "smoke stop")
	(object_destroy x03_smoke)
	)
	
(script dormant effect_grav_lift
	(sleep 330)
	(object_set_function_variable carrier "grav_lift_control" 0 75)
	(print "grav-lift deactivate")
	)
	
(script dormant x03_cinematic_lighting_01
	
	(cinematic_lighting_set_primary_light 31 72 0.529412 0.466667 0.396078)
	(cinematic_lighting_set_secondary_light -60 180 0.0627451 0.0588235 0.117647)
	(cinematic_lighting_set_ambient_light 0 0 0)
	
	(object_uses_cinematic_lighting chief 1)
	(object_uses_cinematic_lighting johnson_02 1)
	(object_uses_cinematic_lighting pilot 1)
	(object_uses_cinematic_lighting pelican_01a 1)
	(object_uses_cinematic_lighting scarab_02 1)
	(object_uses_cinematic_lighting carrier 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

; ---------------------------------------------------------------------

(script static void x03_01_setup

	(object_create_anew chief)
	(object_create_anew johnson_02)
	(object_create_anew pilot)
	(object_create_anew pelican_01a)
	(object_create_anew scarab_02)
	(object_create_anew carrier)
	
	(object_cinematic_lod chief true)
	(object_cinematic_lod johnson_02 true)
	(object_cinematic_lod pilot true)
	(object_cinematic_lod pelican_01a true)
	(object_cinematic_lod scarab_02 true)
	(object_cinematic_lod carrier true)
	
	(cinematic_clone_players_weapon chief "right_hand" "")
	(object_set_function_variable carrier "grav_lift_control" 1 0)
	
	(wake x03_0010_jon)
	(wake x03_0020_mir)

	(wake x03_foley_01)
	
	(wake x03_fov_01)
	(wake x03_01_dof_1)
	(wake scarab_shake_1)
	(wake scarab_shake_2)
	(wake effect_grav_lift)
	(wake effect_scarab_death)
	(wake effect_smoke_start)
	(wake effect_smoke_stop)
	(wake x03_cinematic_lighting_01)
	
	)
	
(script static void x03_01_cleanup
	(object_destroy chief)
	(object_destroy johnson_02)
	(object_destroy pilot)
	(object_destroy pelican_01a)
	(object_destroy carrier)
	(object_destroy x03_smoke)
	)

(script static void x03_scene_01

	(fade_out 1 1 1 0)
	
	(camera_control on)
	(cinematic_start)
	(cinematic_outro_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x03_01_predict_stub)
	(sound_impulse_predict sound\cinematics\03_earthcity\x03\foley\x03_01_fol)
	(sleep prediction_offset)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x03\x03 "x03_01" none "anchor_flag_x03_01")
	
	(x03_01_setup)
	
	(custom_animation_relative chief objects\characters\masterchief\x03\x03 "chief_01" false anchor_x03_01)
	(custom_animation_relative johnson_02 objects\characters\marine\x03\x03 "johnson_01" false anchor_x03_01)
	(custom_animation_relative pilot objects\characters\marine\x03\x03 "pilot_01" false anchor_x03_01)

	(custom_animation_relative pelican_01a objects\vehicles\pelican\x03\x03 "pelican_01" false anchor_x03_01)
	
	(scenery_animation_start_relative scarab_02 scenarios\objects\covenant\military\scarab\x03\x03 "scarab_01" anchor_x03_01)
	(scenery_animation_start_relative carrier scenarios\objects\covenant\military\capital_ship\x03\x03 "carrier_01" anchor_x03_01)
	
;	safety white
	(sleep 15)
	
	(fade_in 1 1 1 15)	
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\x03\foley\x03_02_fol)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(x03_01_cleanup)
	
	)
	
; X03 SCENE 02 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c03_intra1_sound_scene2_01
	(sleep 30)
	(sound_class_set_gain vehicle_engine .2 60)
	)

(script dormant x03_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\x03\foley\x03_02_fol none 1)
	(print "x03 foley 02 start")
	)
	
(script dormant x03_0030_mir
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\x03_0030_mir miranda 1)
	(cinematic_subtitle x03_0030_mir 2)
	)
	
(script dormant x03_0040_jon
	(sleep 73)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\x03_0040_jon johnson_03 1 radio_default)
	(cinematic_subtitle x03_0040_jon 1)
	)

(script dormant x03_0050_lhd
	(sleep 106)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\x03_0050_lhd hood 1 radio_default)
	(cinematic_subtitle x03_0050_lhd 1)
	)
	
(script dormant x03_0060_mir
	(sleep 133)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\x03_0060_mir miranda 1)
	(cinematic_subtitle x03_0060_mir 3)
	)
	
; EFFECTS -------------------------------------------------------------

(script dormant x03_texture_camera_scene_02
	(print "texture camera start")
	(object_create_anew texture_camera)
	(texture_camera_set_object_marker texture_camera marker 50)
	(scenery_animation_start_relative texture_camera objects\cinematics\texture_camera\x03\x03 "texture_camera_02" anchor_x03_02)
	
	)

(script dormant x03_cinematic_lighting_02
	
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -14 150 0.09 0.09 0.22)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)

;	(render_lights_enable_cinematic_shadow 1 miranda head .1)
;	(render_lights_enable_cinematic_shadow 1 nav_officer head .1)
	
	(object_uses_cinematic_lighting miranda 1)
	(object_uses_cinematic_lighting iac_bridge 1)
	(object_uses_cinematic_lighting hood 1)
	(object_uses_cinematic_lighting johnson_03 1)
	(object_uses_cinematic_lighting pilot_02 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------
	
(script static void x03_03_problem_actors
	(print "problem actors")
	(object_create_anew iac)
	(object_cinematic_lod iac true)
	)
	
; ---------------------------------------------------------------------

(script dormant delete_johnson
	
	(sleep 150)
	(print "delete johnson and pelican")
	
	(object_destroy johnson_03)
	(object_destroy pilot_02)
	
	)
	
(script dormant x03_emotion_02

	(unit_set_emotional_state miranda angry .25 0)
	(print "miranda - angry .25 0")
	
	(unit_set_emotional_state johnson angry .5 0)
	(print "johnson - angry .5 0")
	
	(unit_set_emotional_state hood angry .25 0)
	(print "hood - angry .25 0")
	
	)

(script static void x03_02_setup

	(object_create_anew miranda)
	(object_create_anew hood)
	(object_create johnson_03)
	(object_create pilot_02)
	(object_create_anew iac_bridge)
	(object_create_anew pelican_02)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod hood true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod pilot true)
	(object_cinematic_lod iac_bridge true)
	(object_cinematic_lod pelican_02 true)
	
	(wake c03_intra1_sound_scene2_01)
	
	(wake x03_foley_02)
	
	(wake x03_0030_mir)
	(wake x03_0040_jon)
	(wake x03_0050_lhd)
	(wake x03_0060_mir)
	
	(wake delete_johnson)
	(wake x03_emotion_02)

	(wake x03_texture_camera_scene_02)
	(wake x03_cinematic_lighting_02)
	
	)

(script static void x03_scene_02
	
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x03_02_predict_stub)
	
	(x03_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x03\x03 "x03_02" none "anchor_flag_x03_02")
	
	(custom_animation_relative miranda objects\characters\miranda\x03\x03 "miranda_02" false anchor_x03_02)
	(custom_animation_relative johnson_03 objects\characters\marine\x03\x03 "johnson_02" false anchor_x03_02)
	(custom_animation_relative pilot_02 objects\characters\marine\x03\x03 "pilot_02" false anchor_x03_02)
	(custom_animation_relative hood objects\characters\lord_hood\x03\x03 "hood_02" false anchor_x03_02)
	(custom_animation_relative pelican_02 objects\vehicles\pelican\x03\x03 "pelican_02" false anchor_x03_02)

	(scenery_animation_start_relative iac_bridge objects\cinematics\human\inamberclad_bridge\x03\x03 "iacbridge_02" anchor_x03_02)

; safety white 10
	(sleep 20)

	(fade_in 1 1 1 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x03_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\x03\music\x03_03_mus)
	(sound_impulse_predict sound\cinematics\03_earthcity\x03\foley\x03_03_fol)
	
	(sleep (- (camera_time) 15))
	(x03_03_problem_actors)
	
	(sleep (camera_time))
	
;	(texture_camera_off)
	(print "texture camera stop")
	
	(object_hide hood true)
	(print "hide hood")
	
	)

; X03 SCENE 03 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x03_score_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\x03\music\x03_03_mus none 1)
	(print "x03 score 03 start")
	)

(script dormant x03_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\x03\foley\x03_03_fol none 1)
	(print "x03 foley 03 start")
	)

(script dormant x03_0070_lhd
	(sleep 0)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\x03_0070_lhd none 1 radio_default)
	(cinematic_subtitle x03_0070_lhd 1)
	)
	
(script dormant x03_0080_lhd
	(sleep 50)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\x03_0080_lhd none 1 radio_default)
	(cinematic_subtitle x03_0080_lhd 2)
	)
	
(script dormant x03_0090_nv1
	(sleep 195)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\x03_0090_nv1 none 1)
	(cinematic_subtitle x03_0090_nv1 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant x03_fov_03
	(sleep 27)
	(print "fov change: 5 -> 50 over 38 ticks")
	(camera_set_field_of_view 60 38)
	(sleep 191)
	(print "fov change: 50 -> 15 over 26 ticks")
	(camera_set_field_of_view 25 26)
	)

(script dormant effect_slipspace_open
	(sleep 161)
	(print "effect - slipspace open")
	(effect_new_on_object_marker effects\cinematics\03\slipspace_open carrier_02 "bow")
	)

(script dormant x03_cinematic_lighting_03
	
	(cinematic_lighting_set_primary_light 31 68 0.513726 0.415686 0.313726)
	(cinematic_lighting_set_secondary_light -63 42 0.0901961 0.0901961 0.117647)
	(cinematic_lighting_set_ambient_light 0.0823529 0.0823529 0.0823529)
	
	(object_uses_cinematic_lighting iac 1)
	(object_uses_cinematic_lighting carrier_02 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x03_04_problem_actors
	(print "problem actors")
	(object_create_anew nav_officer)
	(object_cinematic_lod nav_officer true)
	(object_uses_cinematic_lighting nav_officer 1)
	)

; ---------------------------------------------------------------------

(script dormant hide_iac_crew_03
	(print "hide iac bridge")
	(object_hide miranda true)
	(object_hide iac_bridge true)
	)

(script static void x03_03_setup

	(object_create_anew carrier_02)
	(object_cinematic_lod carrier_02 true)
	
	(wake x03_0070_lhd)
	(wake x03_0080_lhd)
	(wake x03_0090_nv1)
	
	(wake x03_score_03)
	(wake x03_foley_03)
	
	(wake x03_fov_03)
	(wake x03_cinematic_lighting_03)
	(wake effect_slipspace_open)
	
	(wake hide_iac_crew_03)
	
	)

(script static void x03_scene_03

	(print "fov change: 50 -> 5 over 0 ticks")
	(camera_set_field_of_view 15 0)
	
	(x03_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x03\x03 "x03_03" none "anchor_flag_x03_02")
	
	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\x03\x03 "iac_03" anchor_x03_02)
	(scenery_animation_start_relative carrier_02 scenarios\objects\covenant\military\capital_ship\x03\x03 "carrier_03" anchor_x03_02)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x03_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\x03\foley\x03_04_fol)
	(x03_04_problem_actors)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 1 1 1 5)
	(sleep 5)
	
	)
	
; X03 SCENE 04 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x03_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\x03\foley\x03_04_fol none 1)
	(print "x03 foley 04 start")
	)
	
(script dormant x03_0100_nv1
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\x03_0100_nv1 nav_officer 1)
	(cinematic_subtitle x03_0100_nv1 2)	
	)
	
(script dormant x03_0110_mir
	(sleep 121)
	
	(object_hide iac true)
	(object_hide carrier_02 true)
	(print "hide iac, carrier")
	
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\x03_0110_mir miranda 1)
	(cinematic_subtitle x03_0110_mir 1)
	
	(unit_set_emotional_state miranda shocked .25 30)
	(print "miranda - shocked .25 30")
	
	(sleep 30)
	(object_hide hood false)
	(print "unhide hoodr")
	
	)

(script dormant x03_0120_lhd
	(sleep 175)
	(sound_impulse_start_effect sound\dialog\levels\03_earthcity\cinematic\x03_0120_lhd hood 1 radio_default)
	(cinematic_subtitle x03_0120_lhd 2)

	(unit_set_emotional_state hood angry .5 30)
	(print "hood - angry .5 30")

	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x03_texture_camera_scene_04
	(print "texture camera start")
	(object_create_anew texture_camera)
	(texture_camera_set_object_marker texture_camera marker 50)
	(scenery_animation_start_relative texture_camera objects\cinematics\texture_camera\x03\x03 "texture_camera_04" anchor_x03_02)
	)
	
(script dormant x03_cinematic_lighting_04
	
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -14 150 0.09 0.09 0.22)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)

;	(render_lights_enable_cinematic_shadow 1 miranda head .1)
;	(render_lights_enable_cinematic_shadow 1 nav_officer head .1)
	
	)

; ---------------------------------------------------------------------

(script dormant x03_emotion_04

	(unit_set_emotional_state miranda angry .25 0)
	(print "miranda - angry .25 0")
	
	(unit_set_emotional_state hood angry .25 0)
	(print "hood - angry .25 0")
	
	(unit_set_emotional_state nav_officer angry .25 0)
	(print "nav_officer - angry .25 0")
	
	(sleep 20)
	
	(unit_set_emotional_state nav_officer shocked .5 30)
	(print "nav_officer - shocked .5 30")
	
	)

(script static void x03_04_setup
	
	(object_hide miranda false)
	(object_hide iac_bridge false)
	
	(cinematic_set_near_clip_distance .05)
	(print "setting near clip distance to .05")
	
	(wake x03_0100_nv1)
	(wake x03_0110_mir)
	(wake x03_0120_lhd)
	
	(wake x03_foley_04)

	(wake x03_texture_camera_scene_04)
	(wake x03_cinematic_lighting_04)

	)

(script static void x03_scene_04

	(print "fov change: 15 -> 50 over 0 ticks")
	(camera_set_field_of_view 60 0)
	
	(x03_04_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x03\x03 "x03_04" none "anchor_flag_x03_02")
	
	(custom_animation_relative miranda objects\characters\miranda\x03\x03 "miranda_04" false anchor_x03_02)
	(custom_animation_relative hood objects\characters\lord_hood\x03\x03 "hood_04" false anchor_x03_02)
	(custom_animation_relative nav_officer objects\characters\marine\x03\x03 "nav_04" false anchor_x03_02)
	
	(scenery_animation_start_relative iac_bridge objects\cinematics\human\inamberclad_bridge\x03\x03 "iacbridge_04" anchor_x03_02)
	(scenery_animation_start_relative carrier_02 scenarios\objects\covenant\military\capital_ship\x03\x03 "carrier_04" anchor_x03_02)

	(sleep 10)
	(fade_in 1 1 1 5)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x03_05_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\x03\foley\x03_05_fol)
	
	(sleep (camera_time))
	
	(object_destroy hood)
	
	(texture_camera_off)
	(print "texture camera stop")
	
	)
	
; X03 SCENE 05 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x03_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\x03\foley\x03_05_fol none 1)
	(print "x03 foley 05 start")
	)

(script dormant x03_0130_mir
	(sleep 94)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\x03_0130_mir none 1)
	(cinematic_subtitle x03_0130_mir 1.5)
	)
	
(script dormant effect_iac_engines
	(sleep 112)
	(print "effect - engine")
	(effect_new_on_object_marker effects\cinematics\03\iac_engine_fire iac "")
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant effect_slipspace_widen
	(sleep 0)
	(effect_new_on_object_marker effects\cinematics\03\slipspace_widening carrier_02 "bow")
	(print "slipspace open")
	)
	
(script dormant x03_cinematic_lighting_05
	
	(cinematic_lighting_set_primary_light 31 42 0.662745 0.470588 0.278431)
	(cinematic_lighting_set_secondary_light -18 30 0.121569 0.113725 0.219608)
	(cinematic_lighting_set_ambient_light 0.0392157 0.0392157 0.0392157)
	
	)

; ---------------------------------------------------------------------

(script dormant delete_pelican
	(sleep 87)
	(object_destroy pelican_02)
	)
	
(script dormant hide_iac_crew_05
	(print "hide iac bridge")
	(object_hide miranda true)
	(object_hide nav_officer true)
	(object_hide iac_bridge true)
	)

(script static void x03_05_setup

	(object_hide iac false)
	(object_hide carrier_02 false)
	
	(cinematic_set_near_clip_distance .06)
	(print "resetting near clip distance to .06")
	
	(wake x03_foley_05)
	(wake x03_0130_mir)
	
	(wake x03_cinematic_lighting_05)
	
	(wake effect_iac_engines)
	(wake effect_slipspace_widen)

	(wake delete_pelican)
	(wake hide_iac_crew_05)
	
	)

(script static void x03_scene_05
	
	(x03_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x03\x03 "x03_05" none "anchor_flag_x03_02")
	
	(custom_animation_relative pelican_02 objects\vehicles\pelican\x03\x03 "pelican_05" false anchor_x03_02)
	
	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\x03\x03 "iac_05" anchor_x03_02)
	(scenery_animation_start_relative carrier_02 scenarios\objects\covenant\military\capital_ship\x03\x03 "carrier_05" anchor_x03_02)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x03_06_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\x03\foley\x03_06_fol)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 1 1 1 5)
	(sleep 5)
		
	)
	
; X03 SCENE 06 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x03_foley_06
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\x03\foley\x03_06_fol none 1)
	(print "x03 foley 06 start")
	)
	
(script dormant x03_0140_nv1
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\x03_0140_nv1 nav_officer 1)
	(cinematic_subtitle x03_0140_nv1 2)
	
	(unit_set_emotional_state miranda angry .15 0)
	(print "miranda - angry .15 0")
	
	)
	
(script dormant x03_0150_mir
	(sleep 55)
	(sound_impulse_start sound\dialog\levels\03_earthcity\cinematic\x03_0150_mir miranda 1)
	(cinematic_subtitle x03_0150_mir 1)
	
	(unit_set_emotional_state miranda angry .35 45)
	(print "miranda - angry .35 45")
	
	)

; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x03_fov_06
	(sleep 53)
	(print "fov change: 80 -> 60 over 0 ticks")
	(camera_set_field_of_view 60 0)
	)
	
(script dormant x03_texture_camera_scene_06
	(print "texture camera start")
	(object_create_anew texture_camera)
	(texture_camera_set_object_marker texture_camera marker 50)
	(scenery_animation_start_relative texture_camera objects\cinematics\texture_camera\x03\x03 "texture_camera_06" anchor_x03_02)
	)
	
(script dormant x03_cinematic_lighting_06
	
	(cinematic_lighting_set_primary_light -52 292 0.08 0.15 0.22)
	(cinematic_lighting_set_secondary_light -14 150 0.09 0.09 0.22)
	(cinematic_lighting_set_ambient_light 0.06 0.05 0.04)

;	(render_lights_enable_cinematic_shadow 1 miranda head .1)
;	(render_lights_enable_cinematic_shadow 1 nav_officer head .1)
	
	)

; ---------------------------------------------------------------------

(script static void x03_06_setup

	(object_hide miranda false)
	(object_hide nav_officer false)
	(object_hide iac_bridge false)
	
	(wake x03_0140_nv1)
	(wake x03_0150_mir)
	
	(wake x03_foley_06)
	
	(wake x03_texture_camera_scene_06)
	(wake x03_fov_06)
	(wake x03_cinematic_lighting_06)
	
	)
	
(script static void x03_06_cleanup
	(object_destroy miranda)
	(object_destroy nav_officer)
	(object_destroy iac_bridge)
	)

(script static void x03_scene_06

	(camera_set_field_of_view 80 0)
	
	(x03_06_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x03\x03 "x03_06" none "anchor_flag_x03_02")
	
	(custom_animation_relative miranda objects\characters\miranda\x03\x03 "miranda_06" false anchor_x03_02)
	(custom_animation_relative nav_officer objects\characters\marine\x03\x03 "nav_06" false anchor_x03_02)
	
	(scenery_animation_start_relative iac_bridge objects\cinematics\human\inamberclad_bridge\x03\x03 "iacbridge_06" anchor_x03_02)
	(scenery_animation_start_relative carrier_02 scenarios\objects\covenant\military\capital_ship\x03\x03 "carrier_06" anchor_x03_02)

	(sleep 10)
	(fade_in 1 1 1 5)
		
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x03_07_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\03_earthcity\x03\foley\x03_07_fol)

	(sleep (camera_time))
	
	(x03_06_cleanup)
	
	(texture_camera_off)
	(print "texture camera stop")
	
	)
	
; X03 SCENE 07 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x03_foley_07
	(sleep 0)
	(sound_impulse_start sound\cinematics\03_earthcity\x03\foley\x03_07_fol none 1)
	(print "x03 foley 07 start")
	)

; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant effect_slipspace_collapse
	(sleep 150)
	(object_create_anew x03_slipspace_collapse)
	(print "effect - slipspace collapse")
	)

(script dormant effect_shockwave_start
	(sleep 218)
	(object_create_anew x03_shockwave_start)
	(print "effect - shockwave start")
	)
	
(script dormant shockwave_shake_01
	(time_code_reset)
	(sleep 234)
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .4 1)
	)
	
(script dormant x03_cinematic_lighting_07
	
	(cinematic_lighting_set_primary_light 31 42 0.662745 0.470588 0.278431)
	(cinematic_lighting_set_secondary_light -18 30 0.121569 0.113725 0.219608)
	(cinematic_lighting_set_ambient_light 0.0392157 0.0392157 0.0392157)
	
	)

; ---------------------------------------------------------------------

(script dormant delete_iac
	(sleep 152)
	(object_destroy iac)
	)

(script dormant delete_carrier
	(sleep 172)
	(object_destroy carrier_02)
	)

(script static void x03_07_setup
	
	(wake delete_iac)
	(wake delete_carrier)
	(wake effect_slipspace_collapse)
	(wake effect_shockwave_start)
	(wake shockwave_shake_01)
	
	(effect_new_on_object_marker effects\cinematics\03\slipspace_widening carrier_02 "bow")
	(wake x03_cinematic_lighting_07)
	
	(wake x03_foley_07)
	
	)

(script static void x03_scene_07
	
	(x03_07_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x03\x03 "x03_07" none "anchor_flag_x03_02")
	
	(scenery_animation_start_relative iac objects\cinematics\human\inamberclad\x03\x03 "iac_07" anchor_x03_02)
	(scenery_animation_start_relative carrier_02 scenarios\objects\covenant\military\capital_ship\x03\x03 "carrier_07" anchor_x03_02)

; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x03_08_predict_stub)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 1 1 1 5)
	(sleep 5)
	
	(player_effect_stop 0)
	
	)
	
; X03 SCENE 08 --------------------------------------------------------
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant effect_ease_on_down_the_road
	(sleep 0)
	(object_create_anew x03_shockwave_close)
	(print "effetc - tetsuo!!!")
	)

(script dormant effect_akira
	(sleep 130)
	(object_create_anew x03_shockwave_far)
	(print "effect - kaneda!!!")
	)
	
(script dormant shockwave_shake_02
	(time_code_reset)
	(sleep 40)
	(print "shake start")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .5 2)

	(time_code_reset)
	
	(sleep 89)
	(print "shake stop")
	(player_effect_stop 0)
	)
	
(script dormant shockwave_shake_03
	(time_code_reset)
	(sleep 270)
	(print "shake start")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 6)
	)
	
; ---------------------------------------------------------------------

(script dormant final_fade
	(sleep 125)
	(fade_out 1 1 1 5)
	(sleep 5)
	(sleep 10)
	(fade_in 1 1 1 5)
	)

(script static void x03_08_setup

	(object_create_anew x03_bus)
	(object_create_anew x03_truck)
	(object_create_anew x03_generator)
	(object_create_anew x03_dumpster)
	
	(object_destroy_containing x03_palm)
	(object_destroy x03_shockwave_start)
	(object_destroy x03_slipspace_collapse)

	(wake effect_ease_on_down_the_road)
	(wake final_fade)
	(wake effect_akira)
	(wake shockwave_shake_02)
	(wake shockwave_shake_03)
	
	)
	
(script static void x03_08_cleanup
	
	(object_destroy x03_shockwave_close)
	(object_destroy x03_shockwave_far)
	(object_destroy x03_bus)
	(object_destroy x03_truck)
	(object_destroy x03_generator)
	(object_destroy x03_dumpster)
	
	)

(script static void x03_scene_08
	
	(x03_08_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x03\x03 "x03_08" none "anchor_flag_x03_03")
	
	(scenery_animation_start_relative x03_bus objects\vehicles\civilian\bus\x03\x03 "bus_08" anchor_x03_03)
	(scenery_animation_start_relative x03_truck objects\vehicles\civilian\panel_truck\x03\x03 "panel_truck_08" anchor_x03_03) 
	(scenery_animation_start_relative x03_generator scenarios\objects\solo\earthcity\streetobjects\streetobj_big_generator\x03\x03 "big_generator_08" anchor_x03_03)
	(scenery_animation_start_relative x03_dumpster scenarios\objects\solo\earthcity\streetobjects\streetobj_dumpster\x03\x03 "dumpster_08" anchor_x03_03)
	
	(sleep 10)
	(fade_in 1 1 1 5)
	
	(sleep (- (camera_time) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(player_effect_stop 1)
	
	(x03_08_cleanup)
	
	(sleep 150)
	
	)

; X03 MASTER SCRIPT ===================================================
; =====================================================================

(script static void x03

	(texture_cache_flush)
	(geometry_cache_flush)
	
	(sound_class_set_gain vehicle .5 0)
	(sound_class_set_gain amb .5 0)
	
	(switch_bsp_by_name earthcity_4)
	(sleep 1)

	(x03_scene_01)
	
 	(switch_bsp_by_name earthcity_cine_intro_bsp)
 	(sleep 5)
	
	(x03_scene_02)
	(x03_scene_03)
	(x03_scene_04)
	(x03_scene_05)
	(x03_scene_06)
	(x03_scene_07)
	(x03_scene_08)
	
	)
