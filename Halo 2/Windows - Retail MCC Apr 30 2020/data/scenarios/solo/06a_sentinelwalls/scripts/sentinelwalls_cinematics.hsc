; CINEMATICS FOR 06A, "SENTINEL WALL" =================================
; =====================================================================

;*
	COVENANT WRIT OF UNION, CANTO I

	So full of hate were our eyes
		That none of us could see
	Our war would yield countless dead
		But never victory

	So let us cast arms aside
		And like discard our wrath
	Thou, in faith, will keep us safe
		Whilst we find the path

	- High Council of Concordance,	
	  First Age of Reconciliation
*;

; GLOBALS & STUBS =====================================================

	(global short sound_offset 15)
	(global short prediction_offset 45)

	(script stub void x06_01a_predict_stub (print "predict 01a"))
	(script stub void x06_01b_predict_stub (print "predict 01ab"))
	(script stub void x06_02_predict_stub (print "predict 02"))
	(script stub void x06_03_predict_stub (print "predict 03"))
	(script stub void x06_04_predict_stub (print "predict 04"))
	(script stub void x06_05_predict_stub (print "predict 05"))
	
	(script stub void 06_intro_01_predict_stub (print "predict 01"))
	(script stub void 06_intro_02_predict_stub (print "predict 02"))

; SCENE 01A -----------------------------------------------------------
; AI ------------------------------------------------------------------

(script command_script cs_brute_walk_01
	(cs_movement_mode ai_movement_patrol)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_go_to brute_targets/p0)
	)
	
(script command_script cs_brute_walk_02
	(cs_movement_mode ai_movement_patrol)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_go_to brute_targets/p1)
	)

(script command_script cs_elite_walk_01
	(cs_movement_mode ai_movement_patrol)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_go_to elite_targets/p0)
	)
	
(script command_script cs_elite_walk_02
	(cs_movement_mode ai_movement_patrol)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_go_to elite_targets/p1)
	)
	
(script dormant exchange_of_hats

	(ai_allegiance covenant prophet)

	(sleep 210)
	(print "exchange of hats")
	
	(ai_place brutes_01)
	(ai_place brutes_02)
	(ai_place elites_01)
	(ai_place elites_02)
		
	(cs_run_command_script brutes_01 cs_brute_walk_01)
	(cs_run_command_script brutes_02 cs_brute_walk_02)
	(cs_run_command_script elites_01 cs_elite_walk_01)
	(cs_run_command_script elites_02 cs_elite_walk_02)
	
	(time_code_reset)
	
	(sleep 188)
	
	(ai_erase brutes_01)
	(ai_erase brutes_02)
	(ai_erase elites_01)
	(ai_erase elites_02)
	
	(object_destroy_containing elite_hg_prop)
	
	)

; SOUND ---------------------------------------------------------------

(script dormant x06_score_01a
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x06\music\x06_01_mus none 1)
	(print "x06 score 01a start")
	)
	
(script dormant x06_foley_01a
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x06\foley\x06_01a_fol none 1)
	(print "x06 foley 01a start")
	)
	
; LIGHTING & EFFECTS --------------------------------------------------

(script dormant x06_supratitle_01
	(sleep 60)
	(cinematic_set_title cinematic_title0)
	)

(script dormant cinematic_lighting_scene_01a
	
	(cinematic_lighting_set_primary_light 3 234 0.28 0.28 0.39)
	(cinematic_lighting_set_secondary_light 21 96 0.38 0.33 0.27)
	(cinematic_lighting_set_ambient_light 0.05 0.05 0.05)
	
	(rasterizer_bloom_override 1)
	(rasterizer_bloom_override_threshold .3) 
	(rasterizer_bloom_override_brightness .5)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting brute_03 1)
	(object_uses_cinematic_lighting elite_hg_01 1)
	(object_uses_cinematic_lighting elite_hg_02 1)
	
	(object_uses_cinematic_lighting elite_hg_prop_01 1)
	(object_uses_cinematic_lighting elite_hg_prop_02 1)
	(object_uses_cinematic_lighting elite_hg_prop_03 1)
	(object_uses_cinematic_lighting elite_hg_prop_04 1)
	(object_uses_cinematic_lighting elite_hg_prop_05 1)
	(object_uses_cinematic_lighting elite_hg_prop_06 1)
	(object_uses_cinematic_lighting elite_hg_prop_07 1)
	(object_uses_cinematic_lighting elite_hg_prop_08 1)
	
	(object_uses_cinematic_lighting x06_helmet 1)
	(object_uses_cinematic_lighting x06_pike_01 1)
	(object_uses_cinematic_lighting x06_pike_02 1)
	(object_uses_cinematic_lighting x06_pike_03 1)
	
	(object_uses_cinematic_lighting (ai_get_object brutes_01) 1)
	(object_uses_cinematic_lighting (ai_get_object brutes_02) 1)
	(object_uses_cinematic_lighting (ai_get_object elites_01) 1)
	(object_uses_cinematic_lighting (ai_get_object elites_02) 1)
	
	)
	
; PROBLEM ACTORS ------------------------------------------------------

(script static void x06_01b_problem_actors

	(print "create problem actors")
	
	(object_create_anew brute_01)
	(object_create_anew brute_hg_01)
	(object_create_anew brute_hg_02)
	(object_create_anew brute_hg_03)
	
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_hg_01 true)
	(object_cinematic_lod brute_hg_02 true)
	(object_cinematic_lod brute_hg_03 true)
	
	)
	
; ---------------------------------------------------------------------

(script static void x06_01a_setup

	(object_create_anew dervish)
	(object_create_anew brute_02)
	(object_create_anew brute_03)
	(object_create_anew elite_hg_01)
	(object_create_anew elite_hg_02)
	(object_create_anew_containing elite_hg_prop)
	
	(object_create_anew x06_helmet)
	(object_create_anew x06_pike_01)
	(object_create_anew x06_pike_02)
	(object_create_anew x06_pike_03)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod brute_03 true)
	(object_cinematic_lod elite_hg_01 true)
	(object_cinematic_lod elite_hg_02 true)
	
	(object_cinematic_lod x06_helmet true)
	(object_cinematic_lod x06_pike_01 true)
	(object_cinematic_lod x06_pike_02 true)
	(object_cinematic_lod x06_pike_03 true)
	
	(wake x06_score_01a)
	(wake x06_foley_01a)

	(wake cinematic_lighting_scene_01a)
	(wake x06_supratitle_01)
	
	(wake exchange_of_hats)

	)
	
(script static void x06_01a_cleanup
	
	(object_destroy elite_hg_01)
	(object_destroy elite_hg_02)
	(object_destroy brute_03)
	(object_destroy brute_04)
	
	)

(script static void x06_scene_01a

	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start_movie "sentinelwalls_1")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(x06_01a_predict_stub)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x06\music\x06_01_mus)	
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x06\foley\x06_01a_fol)	
	(sleep prediction_offset)
	
	(x06_01a_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_01a" none "anchor_flag_x06")
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_01a" false anchor_x06)
	(custom_animation_relative brute_02 objects\characters\brute\x06\x06 "brute02_01a" false anchor_x06)
	(custom_animation_relative brute_03 objects\characters\brute\x06\x06 "brute03_01a" false anchor_x06)
	(custom_animation_relative elite_hg_01 objects\characters\elite\x06\x06 "elite_guard1_01a" false anchor_x06)
	(custom_animation_relative elite_hg_02 objects\characters\elite\x06\x06 "elite_guard2_01a" false anchor_x06)
	
	(scenery_animation_start_relative x06_helmet objects\characters\brute\brute_honor_guard\brute_honor_helmet_scenery\x06\x06 "helmet01_01a" anchor_x06)
	(scenery_animation_start_relative x06_pike_01 objects\weapons\melee\pike\x06\x06 "pike01_01a" anchor_x06)
	
	(print "cache block")
	(sleep 1)
	(cache_block_for_one_frame)

	(fade_in 0 0 0 30)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x06_01b_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x06\foley\x06_01b_fol)	
	(x06_01b_problem_actors)
	
	(sleep (camera_time))
	
	(x06_01a_cleanup)

	)
	
; X06 SCENE 01B -------------------------------------------------------
; AI ------------------------------------------------------------------

(script command_script cs_elite_walk_03
	(cs_movement_mode ai_movement_patrol)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_go_to elite_targets/p2)
	)
	
(script dormant final_hg_walk

	(ai_allegiance covenant prophet)

	(sleep 120)
	(print "final honor-guards")
	
	(ai_place elites_03)
	(cs_run_command_script elites_03 cs_elite_walk_03)
	(object_uses_cinematic_lighting (ai_get_object ai_current_actor) 1)
	
	)	
	
; SOUND ---------------------------------------------------------------
	
(script dormant x06_foley_01b
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x06\foley\x06_01b_fol none 1)
	(print "x06 foley 01b start")
	)
	
; LIGHTING & EFFECTS --------------------------------------------------

(script dormant x06_01b_dof_1

	(time_code_reset)

	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0 0 0 0)
	(print "rack focus")
	
	(sleep 45)
	(cinematic_screen_effect_set_depth_of_field 1 .5 0 1 0 .5 1)
	(print "rack focus")
	
	(time_code_reset)
	
	(sleep 98)
	(cinematic_screen_effect_stop)
	(print "rack focus stop")
	)
	
(script dormant cinematic_lighting_scene_01b
	
	(cinematic_lighting_set_primary_light 3 234 0.28 0.28 0.39)
	(cinematic_lighting_set_secondary_light 21 96 0.38 0.33 0.27)
	(cinematic_lighting_set_ambient_light 0.05 0.05 0.05)
	
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_hg_01 1)
	(object_uses_cinematic_lighting brute_hg_02 1)
	(object_uses_cinematic_lighting brute_hg_03 1)
	
	)

; ---------------------------------------------------------------------

(script dormant x06_texture_camera_01b_01

	(time_code_reset)

	(sleep 143)
	(print "start texture camera")

	(object_create_anew texture_camera)
	(object_create_anew texture_space)
	(object_create_anew texture_halo)
	
	(object_cinematic_lod texture_halo true)
	(object_uses_cinematic_lighting texture_halo 1)
	
	(texture_camera_set_object_marker texture_camera primary_trigger 40)
	
	(sleep 156)
	
	(texture_camera_off)
	(print "stop texture camera")
	
	)

(script dormant open_sanctum_door
	(sleep 176)
	(print "open sanctum door")
	(device_set_position sanctum_door 1)
	
	(object_destroy_containing offending_column)
	(print "destroy columns")
	
	)

(script static void x06_01b_setup
	
	(wake x06_foley_01b)
	
	(wake final_hg_walk)
	(wake x06_texture_camera_01b_01)
	(wake open_sanctum_door)
	
	(wake cinematic_lighting_scene_01b)
	(wake x06_01b_dof_1)
	
	)
	
(script static void x06_01b_cleanup
	
	(ai_erase elites_03)
	
	(object_destroy x06_helmet)
	(object_destroy brute_01)
	(object_destroy brute_02)
	
	(cinematic_screen_effect_stop)
	
	)

(script static void x06_scene_01b
	
	(x06_01b_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_01b" none "anchor_flag_x06")
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_01b" false anchor_x06)
	(custom_animation_relative brute_hg_01 objects\characters\brute\x06\x06 "brute01_01b" false anchor_x06)
	(custom_animation_relative brute_hg_02 objects\characters\brute\x06\x06 "brute02_01b" false anchor_x06)
	(custom_animation_relative brute_hg_03 objects\characters\brute\x06\x06 "brute03_01b" false anchor_x06)
	(custom_animation_relative brute_01 objects\characters\brute\x06\x06 "brute04_01b" false anchor_x06)
	(custom_animation_relative brute_02 objects\characters\brute\x06\x06 "brute05_01b" false anchor_x06)
	
	(scenery_animation_start_relative x06_helmet objects\characters\brute\brute_honor_guard\brute_honor_helmet_scenery\x06\x06 "helmet01_01b" anchor_x06)
	(scenery_animation_start_relative x06_pike_01 objects\weapons\melee\pike\x06\x06 "pike01_01b" anchor_x06)
	(scenery_animation_start_relative x06_pike_02 objects\weapons\melee\pike\x06\x06 "pike02_01b" anchor_x06)
	(scenery_animation_start_relative x06_pike_03 objects\weapons\melee\pike\x06\x06 "pike03_01b" anchor_x06)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x06_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x06\foley\x06_02_fol)	
	
	(sleep (camera_time))
	
	(x06_01b_cleanup)
	
	)
	
; X06 SCENE 02 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x06_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x06\foley\x06_02_fol none 1)
	(print "x06 foley 02 start")
	)

(script dormant x06_0010_soc
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0010_soc none 1)
	(cinematic_subtitle x06_0010_soc 3)
	)

(script dormant x06_0020_pot
	(sleep 92)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0020_pot none 1)
	(cinematic_subtitle x06_0020_pot 2)
	)
	
(script dormant x06_0030_soc
	(sleep 168)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0030_soc commander 1)
	(cinematic_subtitle x06_0030_soc 5)
	)
	
(script dormant x06_0040_pot
	(sleep 306)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0040_pot truth 1)
	(cinematic_subtitle x06_0040_pot 2)
	)
	
(script dormant x06_0050_soc
	(sleep 371)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0050_soc commander 1)
	(cinematic_subtitle x06_0050_soc 5)
	)
	
(script dormant x06_0060_pot
	(sleep 520)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0060_pot truth 1)
	(cinematic_subtitle x06_0060_pot 8)
	
	(sleep 110)
	(unit_set_emotional_state truth arrogant .75 60)
	
	)
	
(script dormant x06_0070_soc
	(sleep 794)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0070_soc commander 1)
	(cinematic_subtitle x06_0070_soc 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant cinematic_lighting_scene_02
	
	(cinematic_lighting_set_primary_light 3 234 0.28 0.28 0.39)
	(cinematic_lighting_set_secondary_light 21 96 0.38 0.33 0.27)
	(cinematic_lighting_set_ambient_light 0.05 0.05 0.05)
	
	(object_uses_cinematic_lighting truth 1)
	(object_uses_cinematic_lighting mercy 1)
	(object_uses_cinematic_lighting commander 1)
	(object_uses_cinematic_lighting so_elite_01 1)
	(object_uses_cinematic_lighting so_elite_02 1)
	(object_uses_cinematic_lighting throne_truth 1)
	(object_uses_cinematic_lighting throne_mercy 1)
	
	)

; ---------------------------------------------------------------------

(script dormant x06_texture_camera_02_01

	(print "start texture camera")

	(object_create_anew texture_camera)
	(object_create_anew texture_space)
	(object_create_anew texture_halo)
	
	(object_cinematic_lod texture_halo true)
	(object_uses_cinematic_lighting texture_halo 1)
	
	(texture_camera_set_object_marker texture_camera primary_trigger 40)
	
	)

(script static void x06_02_setup

	(object_create_anew truth)
	(object_create_anew mercy)
	(object_create_anew commander)
	(object_create_anew so_elite_01)
	(object_create_anew so_elite_02)
	(object_create_anew throne_truth)
	(object_create_anew throne_mercy)
	
	(object_cinematic_lod truth true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod so_elite_01 true)
	(object_cinematic_lod so_elite_02 true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_mercy true)
	
	(objects_attach truth "driver" throne_truth "driver_cinematic")
	(objects_attach mercy "driver" throne_mercy "driver_cinematic")
	
	(wake x06_foley_02)
	
	(wake x06_0010_soc)
	(wake x06_0020_pot)
	(wake x06_0030_soc)
	(wake x06_0040_pot)
	(wake x06_0050_soc)
	(wake x06_0060_pot)
	(wake x06_0070_soc)
	
	(wake cinematic_lighting_scene_02)
	
	(wake x06_texture_camera_02_01)
	
	)

(script static void x06_scene_02
	
	(x06_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_02" none "anchor_flag_x06")
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_02" false anchor_x06)
	(custom_animation_relative truth objects\characters\prophet\x06\x06 "truth_02" false anchor_x06)
	(custom_animation_relative mercy objects\characters\prophet\x06\x06 "mercy_02" false anchor_x06)
	(custom_animation_relative commander objects\characters\elite\x06\x06 "commander_02" false anchor_x06)
	(custom_animation_relative so_elite_01 objects\characters\elite\x06\x06 "elite1_02" false anchor_x06)
	(custom_animation_relative so_elite_02 objects\characters\elite\x06\x06 "elite2_02" false anchor_x06)
	(custom_animation_relative brute_hg_01 objects\characters\brute\x06\x06 "brute01_02" false anchor_x06)
	(custom_animation_relative brute_hg_02 objects\characters\brute\x06\x06 "brute02_02" false anchor_x06)
	
	(scenery_animation_start_relative x06_pike_01 objects\weapons\melee\pike\x06\x06 "pike01_02" anchor_x06)
	(scenery_animation_start_relative x06_pike_02 objects\weapons\melee\pike\x06\x06 "pike02_02" anchor_x06)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x06_03_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x06\foley\x06_03_fol)	
	
	(sleep (camera_time))
	
	(object_destroy_containing x06_pike)
	
	)

; X06 SCENE 03 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x06_foley_03
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x06\foley\x06_03_fol none 1)
	(print "x06 foley 03 start")
	)

(script dormant x06_0080_pot
	(sleep 148)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0080_pot none 1)
	(cinematic_subtitle x06_0080_pot 4)
	)
	
(script dormant x06_0090_pot
	(sleep 265)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0090_pot truth 1)
	(cinematic_subtitle x06_0090_pot 5)
	)
	
(script dormant x06_0100_pot
	(sleep 418)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0100_pot truth 1)
	(cinematic_subtitle x06_0100_pot 6)
	
	(sleep 78)
	(unit_set_emotional_state truth annoyed .75 60)
	
	)
	
(script dormant x06_0110_der
	(sleep 585)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0110_der dervish 1)
	(cinematic_subtitle x06_0110_der 2)
	)

; ---------------------------------------------------------------------

(script static void x06_03_setup
	
	(wake x06_foley_03)

	(wake x06_0080_pot)
	(wake x06_0090_pot)
	(wake x06_0100_pot)
	(wake x06_0110_der)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x06_03_cleanup
	
	(object_destroy commander)
	(object_destroy_containing brute_hg)
	(object_destroy_containing so_elite)
	)

(script static void x06_scene_03
	
	(x06_03_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_03" none "anchor_flag_x06")
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_03" false anchor_x06)
	(custom_animation_relative truth objects\characters\prophet\x06\x06 "truth_03" false anchor_x06)
	(custom_animation_relative mercy objects\characters\prophet\x06\x06 "mercy_03" false anchor_x06)
	(custom_animation_relative commander objects\characters\elite\x06\x06 "commander_03" false anchor_x06)
	(custom_animation_relative so_elite_01 objects\characters\elite\x06\x06 "elite1_03" false anchor_x06)
	(custom_animation_relative so_elite_02 objects\characters\elite\x06\x06 "elite2_03" false anchor_x06)
	(custom_animation_relative brute_hg_01 objects\characters\brute\x06\x06 "brute01_03" false anchor_x06)
	(custom_animation_relative brute_hg_02 objects\characters\brute\x06\x06 "brute02_03" false anchor_x06)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x06_04_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x06\music\x06_04_mus)	
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x06\foley\x06_03_fol)	
	
	(sleep (camera_time))
	
	(x06_03_cleanup)
	
	)
	
; X06 SCENE 04 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x06_score_04
	(sleep 274)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x06\music\x06_04_mus none 1)
	(print "x06 score 04 start")
	)

(script dormant x06_foley_04
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x06\foley\x06_04_fol none 1)
	(print "x06 foley 04 start")
	)

(script dormant x06_0120_pot
	(sleep 15)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0120_pot truth 1)
	(cinematic_subtitle x06_0120_pot 3)
	)
	
(script dormant x06_0130_pom
	(sleep 109)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0130_pom mercy 1)
	(cinematic_subtitle x06_0130_pom 8)
	)
	
(script dormant x06_0140_pot
	(sleep 346)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0140_pot truth 1)
	(cinematic_subtitle x06_0140_pot 8)
	)
	
(script dormant x06_0150_pot
	(sleep 581)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0150_pot truth 1)
	(cinematic_subtitle x06_0150_pot 5)
	)
	
(script dormant x06_0160_pom
	(sleep 715)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0160_pom mercy 1)
	(cinematic_subtitle x06_0160_pom 9)
	
	(sleep 150)
	(unit_set_emotional_state mercy asleep .75 60)
	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant x06_fov_01
	(sleep 576)
	(camera_set_field_of_view 60 0)
	(print "fov")
	(cinematic_screen_effect_stop)
	)

(script dormant x06_04_dof_1
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0 0 0 0)
	(print "dof")
	(sleep 103)
	(cinematic_screen_effect_set_depth_of_field .8 .5 0 1 0 .5 1)
	(print "dof")
	)
	
(script dormant x06_04_dof_2
	(sleep 343)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0 0 0 0)
	(print "dof")
	(sleep 82)
	(cinematic_screen_effect_set_depth_of_field 1 .5 0 1 0 .5 1)
	(print "dof")
	)

; ---------------------------------------------------------------------

(script dormant unhide_dervish
	(time_code_reset)
	(sleep 576)
	(print "unhide dervish")
	(object_hide dervish false)
	)

(script static void x06_04_setup
	
	(wake x06_score_04)
	(wake x06_foley_04)
	
	(wake x06_0120_pot)
	(wake x06_0130_pom)
	(wake x06_0140_pot)
	(wake x06_0150_pot)
	(wake x06_0160_pom)
	
	(object_hide dervish true)
	(wake unhide_dervish)
	
	(wake x06_fov_01)
	(wake x06_04_dof_1)
	(wake x06_04_dof_2)
	
	)

(script static void x06_scene_04
	
	(x06_04_setup)
	
	(camera_set_field_of_view 30 0)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_04" none "anchor_flag_x06")
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_04" false anchor_x06)
	(custom_animation_relative truth objects\characters\prophet\x06\x06 "truth_04" false anchor_x06)
	(custom_animation_relative mercy objects\characters\prophet\x06\x06 "mercy_04" false anchor_x06)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(x06_05_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\x06\foley\x06_05_fol)

	(sleep (camera_time))
	
	(cinematic_screen_effect_stop)
	
	)
	
; X06 SCENE 05 --------------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant x06_foley_05
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\x06\foley\x06_05_fol none 1)
	(print "x06 foley 05 start")
	)

(script dormant x06_0170_pot
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0170_pot truth 1)
	(cinematic_subtitle x06_0170_pot 9)
	)
	
(script dormant x06_0180_pot
	(sleep 276)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0180_pot truth 1)
	(cinematic_subtitle x06_0180_pot 3)
	)
	
(script dormant x06_0190_pom
	(sleep 366)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0190_pom mercy 1)
	(cinematic_subtitle x06_0190_pom 9)
	)
	
(script dormant x06_0200_pot
	(sleep 635)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0200_pot truth 1)
	(cinematic_subtitle x06_0200_pot 5)
	)
	
(script dormant x06_0210_pot
	(sleep 780)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0210_pot truth 1)
	(cinematic_subtitle x06_0210_pot 4)
	)
	
(script dormant x06_0220_pom
	(sleep 889)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0220_pom mercy 1)
	(cinematic_subtitle x06_0220_pom 3)
	)

(script dormant x06_0230_pot
	(sleep 956)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0230_pot truth 1)
	(cinematic_subtitle x06_0230_pot 3)
	
	(unit_set_emotional_state truth happy .5 60)
	
	)
	
; EFFECTS & LIGHTING --------------------------------------------------

(script dormant x06_05_dof_1

	(sleep 488)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .75 .75 0 0 0 0)
	(print "rack focus")
	
	(sleep 160)
	(cinematic_screen_effect_set_depth_of_field 1 0 0 1 0 0 0)
	(print "rack focus")
	)
	
(script dormant x06_05_dof_2

	(sleep 777)
	(cinematic_screen_effect_set_depth_of_field 2 0 .75 1 .75 0 1)
	(print "rack focus")
	
	(sleep 173)
	(cinematic_screen_effect_stop)
	
	)

; ---------------------------------------------------------------------

(script dormant x06_texture_camera_05_01
	(time_code_reset)
	(sleep 279)
	(print "stop texture camera")
	(texture_camera_off)
	)	
	
(script dormant monitor_sound
	(sleep 281)
	(sound_class_set_gain device 1 60)
	(print "monitor sound up")
	)
	
(script static void x06_05_setup

	(sound_class_set_gain device 0 0)

	(object_create_anew monitor)
	(object_cinematic_lod monitor true)
	(object_set_function_variable monitor talking 0 0)
	(object_uses_cinematic_lighting monitor 1)
	
	(object_create_anew index_holo)
	
	(wake x06_foley_05)
	
	(wake x06_0170_pot)
	(wake x06_0180_pot)
	(wake x06_0190_pom)
	(wake x06_0200_pot)
	(wake x06_0210_pot)
	(wake x06_0220_pom)
	(wake x06_0230_pot)
	
	(wake monitor_sound)
	
	(wake x06_05_dof_1)
	(wake x06_05_dof_2)
	
	(wake x06_texture_camera_05_01)
	
	)
	
(script static void x06_05_cleanup
	
	(object_destroy dervish)
	(object_destroy_containing truth)
	(object_destroy_containing mercy)
	(object_destroy monitor)
	(object_destroy index_holo)
	(cinematic_screen_effect_stop)
	
	)

(script static void x06_scene_05

	(camera_set_field_of_view 60 0)
	
	(x06_05_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_05" none "anchor_flag_x06")
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_05" false anchor_x06)
	(custom_animation_relative truth objects\characters\prophet\x06\x06 "truth_05" false anchor_x06)
	(custom_animation_relative mercy objects\characters\prophet\x06\x06 "mercy_05" false anchor_x06)
	(custom_animation_relative monitor objects\characters\monitor\x06\x06 "monitor_05" false anchor_x06)
	
	(scenery_animation_start_relative index_holo scenarios\objects\forerunner\industrial\index\index_alone\x06\x06 "index_alone_05" anchor_x06)
	
	(sleep (- (camera_time) 15))
	
	(fade_out 0 0 0 15)
	(sleep 15)
	
	(x06_05_cleanup)
	
	)

; X06 MASTER SCRIPT ===================================================
; =====================================================================


(script static void x06
	
	(cinematic_enable_ambience_details false)
	
	(texture_cache_flush)
	(geometry_cache_flush)
	
	(switch_bsp_by_name high_8)
	(sleep 1)
	
	(x06_scene_01a)
	(x06_scene_01b)
	(x06_scene_02)
	(x06_scene_03)
	(x06_scene_04)
	(x06_scene_05)
	
	)


; C06_INTRO SCENE 01 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c06_intro_sound_scene1_01
	(object_set_function_variable phantom_01 "engine_hack" 1 0)
	(object_set_function_variable phantom_01 "engine_audio" 1 0)
	(object_set_function_variable phantom_01 "hover_audio" 1 0)
	
	(sound_class_set_gain vehicle 0 0)
	(sound_class_set_gain vehicle 1 90)

	(sleep 90)	

	(sound_class_set_gain vehicle 0 90)
	)
	
(script dormant c06_intro_foley_01
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\c06_intro\foley\c06_intro_01_fol none 1)
	(print "c06_intro foley 01 start")
	)

(script dormant c06_1010_tar
	(sleep 144)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1010_tar none 1)
	(cinematic_subtitle c06_1010_tar 1)
	)
	
(script dormant c06_1020_tar
	(sleep 191)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1020_tar tartarus 1)
	(cinematic_subtitle c06_1020_tar 2)
	)
	
(script dormant c06_1030_tar
	(sleep 264)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1030_tar tartarus 1)
	(cinematic_subtitle c06_1030_tar 3)
	)
	
(script dormant c06_1040_der
	(sleep 337)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1040_der dervish 1)
	(cinematic_subtitle c06_1040_der 4)
	)
	
(script dormant c06_1050_tar
	(sleep 463)
	(sound_impulse_start_effect sound\dialog\levels\06_sentinelwall\cinematic\c06_1050_tar none 1 radio_covy_loop)
	(cinematic_subtitle c06_1050_tar 1)
	)
	
(script dormant c06_1060_der
	(sleep 507)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1060_der dervish 1)
	(cinematic_subtitle c06_1060_der 1)
	)

(script dormant c06_1070_tar
	(sleep 550)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1070_tar tartarus 1)
	(cinematic_subtitle c06_1070_tar 1)
	
	(sleep 35)
	(unit_set_emotional_state tartarus inquisitive 1 30)
	
	)

(script dormant c06_1080_tar
	(sleep 593)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1080_tar tartarus 1)
	(cinematic_subtitle c06_1080_tar 1)
	)

(script dormant c06_1090_tar
	(sleep 623)
	(sound_impulse_start_effect sound\dialog\levels\06_sentinelwall\cinematic\c06_1090_tar none 1 radio_covy_loop)
	(cinematic_subtitle c06_1090_tar 1)
	)
	
(script dormant c06_1100_der
	(sleep 670)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1100_der dervish 1)
	(cinematic_subtitle c06_1100_der 3)
	)

(script dormant c06_1110_tar
	(sleep 745)
	(sound_impulse_start_effect sound\dialog\levels\06_sentinelwall\cinematic\c06_1110_tar none 1 radio_covy_out)
	(cinematic_subtitle c06_1110_tar 3)
	)
	
; EFFECTS & LIGHTING --------------------------------------------------
	
(script dormant camera_shake_01
	(sleep 188)
	(print "shake")
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	)

(script dormant cinematic_light_intro_scene_01
	
	(cinematic_lighting_set_primary_light -20 282 0.21 0.29 0.37)
	(cinematic_lighting_set_secondary_light -59 306 0.34 0.58 0.65)
	(cinematic_lighting_set_ambient_light 0.07 0.05 0.08)
	
	(rasterizer_bloom_override 0)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting tartarus 1)
	(object_uses_cinematic_lighting brute_01 1)
	(object_uses_cinematic_lighting brute_02 1)
	(object_uses_cinematic_lighting brute_03 1)
	(object_uses_cinematic_lighting brute_04 1)
	(object_uses_cinematic_lighting phantom_01 1)
	(object_uses_cinematic_lighting phantom_int 1)
	(object_uses_cinematic_lighting carbine 1)
	(object_uses_cinematic_lighting delta_halo 1)
	
	)
	
(script dormant cinematic_light_phantom_int

	(sleep 186)
	(print "light phantom")
	
	(cinematic_lighting_set_primary_light -90 0 0.23 0.29 0.53)
	(cinematic_lighting_set_secondary_light -90 192 0.16 0.10 0.19)
	(cinematic_lighting_set_ambient_light 0.07 0.05 0.08)
	
	)
	
; PREDICTION ----------------------------------------------------------

(script dormant c06_problem_actors_01
	(print "problem actors")
	(object_create_anew delta_halo)
	(object_create_anew matte_substance)
	(object_create_anew matte_stardust)
	
	(object_cinematic_lod delta_halo true)
	(object_cinematic_visibility delta_halo true)
	
	)

; ---------------------------------------------------------------------

(script static void c06_intro_01_setup

	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew brute_03)
	(object_create_anew brute_04)
	(object_create_anew phantom_01)
	(object_create_anew phantom_int)
	(object_create_anew carbine)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod brute_03 true)
	(object_cinematic_lod brute_04 true)
	(object_cinematic_lod phantom_01 true)
	(object_cinematic_lod phantom_int true)
	
	(objects_attach dervish "right_hand_elite" carbine "")
	
	(wake c06_intro_sound_scene1_01)
	
	(wake c06_intro_foley_01)
	
	(wake c06_1010_tar)
	(wake c06_1020_tar)
	(wake c06_1030_tar)
	(wake c06_1040_der)
	(wake c06_1050_tar)
	(wake c06_1060_der)
	(wake c06_1070_tar)
	(wake c06_1080_tar)
	(wake c06_1090_tar)
	(wake c06_1100_der)
	(wake c06_1110_tar)
	
	(wake camera_shake_01)
	(wake cinematic_light_intro_scene_01)
	(wake cinematic_light_phantom_int)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void c06_intro_01_cleanup

	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy_containing brute)
	(object_destroy phantom_int)
	(object_destroy delta_halo)
	(object_destroy matte_substance)
	(object_destroy matte_stardust)
	
	(player_effect_stop 0)
	
	)

(script static void c06_intro_scene_01

	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start_movie "sentinelwalls_intro")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(06_intro_01_predict_stub)
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\c06_intro\foley\c06_intro_01_fol)
	(wake c06_problem_actors_01)
	(sleep prediction_offset)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\06_intro\06_intro "06_intro_01" none "anchor_flag_intro")
	
	(c06_intro_01_setup)
	
	(custom_animation_relative dervish objects\characters\dervish\06_intro\06_intro "dervish_01" false anchor_intro)
	(custom_animation_relative tartarus objects\characters\brute\06_intro\06_intro "tartarus_01" false anchor_intro)
	
	(custom_animation_relative brute_01 objects\characters\brute\06_intro\06_intro "brute01_01" false anchor_intro)
	(custom_animation_relative brute_02 objects\characters\brute\06_intro\06_intro "brute02_01" false anchor_intro)
	(custom_animation_relative brute_03 objects\characters\brute\06_intro\06_intro "brute03_01" false anchor_intro)
	(custom_animation_relative brute_04 objects\characters\brute\06_intro\06_intro "brute04_01" false anchor_intro)
	
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\06_intro\06_intro "phantom_01" false anchor_intro)
	(scenery_animation_start_relative phantom_int objects\vehicles\phantom\cinematics\06_intro\06_intro "phantom_int_01" anchor_intro)
	(scenery_animation_start_relative delta_halo scenarios\objects\forerunner\industrial\halo\06_intro\06_intro "halo_01" anchor_intro)
	
	(scenery_animation_start_relative matte_substance objects\cinematics\matte_paintings\substance_space\06_intro\06_intro "substance_01" anchor_intro)
	(scenery_animation_start_relative matte_stardust objects\cinematics\matte_paintings\high_charity_stardust\06_intro\06_intro "stardust_01" anchor_intro)

;	safety black
	(sleep 15)

	(fade_in 0 0 0 15)
	
; 	PREDICTION ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	(sleep (- (camera_time) prediction_offset))
	(06_intro_02_predict_stub)
	
	(sleep (- (camera_time) sound_offset))
	(sound_impulse_predict sound\cinematics\06_sentinelwalls\c06_intro\foley\c06_intro_02_fol)
	
	(cinematic_screen_effect_start true)
	
	(sleep (- (camera_time) 5))	
	
	(cinematic_screen_effect_set_crossfade 2)
	(print "crossfade")
	
	(sleep (camera_time))
	
	(c06_intro_01_cleanup)
	
	)
	
; C06_INTRO SCENE 02 --------------------------------------------------
; SOUND ---------------------------------------------------------------

(script dormant c06_intro_sound_scene2_01
	(sound_class_set_gain vehicle 0 0)

	(object_set_function_variable phantom_02 "engine_hack" 1 0)
	(object_set_function_variable phantom_02 "engine_audio" 1 0)
	(object_set_function_variable phantom_02 "hover_audio" 1 0)

	(sound_class_set_gain vehicle 1 50)

	(sleep 50)

	(sound_class_set_gain vehicle 0 90)
	)

(script dormant c06_intro_sound_scene2_02
	(sleep 160)

	(sound_class_set_gain vehicle 1 30)
	(sleep 30)	

	(object_set_function_variable phantom_02 "engine_hack" 0 120)
	(object_set_function_variable phantom_02 "engine_audio" 0 120)
	(object_set_function_variable phantom_02 "hover_audio" 0 120)
	(sleep 60)

	(object_set_function_variable phantom_02 "engine_hack" 1 90)
	(object_set_function_variable phantom_02 "engine_audio" 1 90)
	(object_set_function_variable phantom_02 "hover_audio" 1 90)

	(sound_class_set_gain vehicle 0 150)
	)

(script dormant c06_intro_sound_scene2_03
	(sleep 480) 

	(sound_class_set_gain vehicle 1 60)

	(object_set_function_variable intro_sen_maj "engine_hack" 0 0)
	(object_set_function_variable intro_sen_maj "engine_audio" 0 0)
	(object_set_function_variable intro_sen_maj "engine_hack" 1 60)
	(object_set_function_variable intro_sen_maj "engine_audio" 1 60)

	(sleep 110)


	(object_set_function_variable intro_sen_maj "engine_hack" 0 60)
	(object_set_function_variable intro_sen_maj "engine_audio" 0 60)

	(sleep 160)

	(object_set_function_variable intro_sen_maj "engine_hack" 1 60)
	(object_set_function_variable intro_sen_maj "engine_audio" 1 60)

	(sleep 60)

	(sound_class_set_gain vehicle 0 150)
	)

(script dormant c06_intro_foley_02
	(sleep 0)
	(sound_impulse_start sound\cinematics\06_sentinelwalls\c06_intro\foley\c06_intro_02_fol none 1)
	(print "c06_intro foley 02 start")
	)

(script dormant c06_1120_tar
	(sleep 782)
	(sound_impulse_start_effect sound\dialog\levels\06_sentinelwall\cinematic\c06_1120_tar none 1 radio_default_loop)
	(cinematic_subtitle c06_1120_tar 2)
	)
	
(script dormant c06_1130_tar
	(sleep 842)
	(sound_impulse_start_effect sound\dialog\levels\06_sentinelwall\cinematic\c06_1130_tar tartarus 1 radio_default_out)
	(cinematic_subtitle c06_1130_tar 2)
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

; LIGHTING & EFFECTS --------------------------------------------------

(script dormant arbiter_fires

;	(time_code_reset)
	
	(sleep 642)
	(print "carbine shot")
	(effect_new_on_object_marker effects\objects\weapons\rifle\covenant_carbine\firing carbine "primary_trigger")
	
;	(time_code_reset)
	
	(sleep 22)
	(print "carbine shot")
	(effect_new_on_object_marker effects\objects\weapons\rifle\covenant_carbine\firing carbine "primary_trigger")
	
	(sleep 24)
	(print "carbine shot")
	(effect_new_on_object_marker effects\objects\weapons\rifle\covenant_carbine\firing carbine "primary_trigger")
	
	)
	
(script dormant phantom_fires

	(time_code_reset)
	
	(sleep 690)
	(object_create_anew intro_turret_base)
	(object_create_anew intro_turret)
	(objects_attach intro_turret_base "primary_trigger" intro_turret "")

	(print "turret fires")
	(weapon_hold_trigger intro_turret 0 true)
	(sleep 30)
	(weapon_hold_trigger intro_turret 0 false)
	
	(objects_detach intro_turret_base intro_turret)
	(object_destroy intro_turret)
	(object_destroy intro_turret_base)
	
	)
	
; PREDICTION ----------------------------------------------------------

(script dormant c06_intro_predict_ledge_01
	(sleep 145)
	(print "predict: camera, dervish")
	(object_type_predict_high objects\characters\dervish\dervish)
	(camera_predict_resources_at_frame objects\characters\cinematic_camera\06_intro\06_intro "06_intro_02" none anchor_flag_intro 165)
	)
	
(script dormant c06_intro_predict_ledge_02
	(sleep 224)
	(print "predict: camera, dervish, sentinel major")
	(object_type_predict_high objects\characters\dervish\dervish)
	(object_type_predict_high objects\characters\sentinel_enforcer\sentinel_enforcer)
	(camera_predict_resources_at_frame objects\characters\cinematic_camera\06_intro\06_intro "06_intro_02" none anchor_flag_intro 244)
	)
	
; ---------------------------------------------------------------------

(script dormant create_dervish_again
	(sleep 305)
	(print "problem actor")
	(object_create_anew dervish)
	(object_create_anew carbine)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod carbine true)
	
	(object_uses_cinematic_lighting dervish 1)
	(object_uses_cinematic_lighting carbine 1)
	
	(objects_attach dervish "right_hand_elite" carbine "")
	
	(object_hide dervish true)
	
	)
	
(script dormant dervish_unhide
	
	(sleep 330)
	(object_hide dervish false)
	(print "dervish unhide")

	)

(script static void c06_intro_02_setup

	(object_create_anew phantom_02)
	(object_create_anew intro_sen_maj)
	(object_create_anew matte_mount_doom)
	
	(object_cinematic_lod phantom_02 true)
	(object_cinematic_lod intro_sen_maj true)
	
	(object_uses_cinematic_lighting phantom_02 1)
	(object_uses_cinematic_lighting intro_sen_maj 1)
	
	(wake c06_intro_sound_scene2_01)
	(wake c06_intro_sound_scene2_02)
	(wake c06_intro_sound_scene2_03)
	
	(wake c06_intro_foley_02)
	
	(wake c06_1120_tar)
	(wake c06_1130_tar)
	
	(wake dervish_unhide)
	(wake create_dervish_again)
	(wake arbiter_fires)
	(wake phantom_fires)
	
;	(wake x04_01_dof_1)

	(wake c06_intro_predict_ledge_01)
	(wake c06_intro_predict_ledge_02)
	
	)
	
(script static void c06_intro_02_cleanup
	
	(object_destroy dervish)
	(object_destroy intro_sen_maj)
	(object_destroy_containing phantom)
	(object_destroy matte_mount_doom)
	
	)

(script static void c06_intro_scene_02
	
	(c06_intro_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\06_intro\06_intro "06_intro_02" none "anchor_flag_intro")
	
	(custom_animation_relative dervish objects\characters\dervish\06_intro\06_intro "dervish_02" false anchor_intro)
	
	(custom_animation_relative intro_sen_maj objects\characters\sentinel_enforcer\06_intro\06_intro "sentinel_major_02" false anchor_intro)
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\06_intro\06_intro "phantom01_02" false anchor_intro)
	(custom_animation_relative phantom_02 objects\vehicles\phantom\animations\06_intro\06_intro "phantom02_02" false anchor_intro)
	
	(scenery_animation_start_relative matte_mount_doom objects\cinematics\matte_paintings\mount_doom\06_intro\06_intro "mount_doom_02" anchor_intro)

	(time_code_reset)

	(sleep 315)
	(custom_animation_relative dervish objects\characters\dervish\06_intro\06_intro "dervish_02" false anchor_intro)

	(sleep (- (camera_time) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c06_intro_02_cleanup)
	
	(sleep 30)
	
	)
	
; C06_INTRO MASTER SCRIPT =============================================
; =====================================================================

(script static void C06_intro

	(switch_bsp_by_name sentinelhq_1)
	(sleep 5)
	
	(c06_intro_scene_01)
	(c06_intro_scene_02)
	
	)
