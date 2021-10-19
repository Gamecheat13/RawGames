; CINEMATICS FOR LEVEL 05, SENTINEL WALL ---------------------------------------------------------------------------------------------
; X06 SCENE 01A ----------------------------------------------------------------------------------------------------------------------

;(script dormant x06_score_1a
;	(sleep 0)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)
	
;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x06_01a_setup

	(object_create_anew dervish)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew brute_03)
	(object_create_anew brute_04)
	(object_create_anew elite_hg_01)
	(object_create_anew elite_hg_02)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod brute_03 true)
	(object_cinematic_lod brute_04 true)
	(object_cinematic_lod elite_hg_01 true)
	(object_cinematic_lod elite_hg_02 true)
	
;	(wake x04_score_1)
;	(wake x04_0010_bgr)
;	(wake x04_0020_bgl)
;	(wake x04_0040_jcr)
;	(wake x04_0030_bgl)
;	(wake x04_0050_bgr)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x06_01a_cleanup
	
	(object_destroy dervish)
	(object_destroy_containing brute)
	(object_destroy_containing elite_hg)
	)

(script static void x06_scene_01a

	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_01a" none "anchor_flag_x06")
	
	(x06_01a_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_01a" false anchor_x06)

	(custom_animation_relative brute_01 objects\characters\brute\x06\x06 "brute01_01a" false anchor_x06)
	(custom_animation_relative brute_02 objects\characters\brute\x06\x06 "brute02_01a" false anchor_x06)
	(custom_animation_relative brute_03 objects\characters\brute\x06\x06 "brute03_01a" false anchor_x06)
	(custom_animation_relative brute_04 objects\characters\brute\x06\x06 "brute04_01a" false anchor_x06)
	
	(custom_animation_relative elite_hg_01 objects\characters\elite\x06\x06 "elite_guard1_01a" false anchor_x06)
	(custom_animation_relative elite_hg_02 objects\characters\elite\x06\x06 "elite_guard2_01a" false anchor_x06)
	
	(fade_in 0 0 0 30)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x06_01a_cleanup)
	)
	
; X06 SCENE 01B -------------------------------------------------------
	
;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x06_01b_setup

	(object_create_anew dervish)
	(object_create_anew brute_hg_01)
	(object_create_anew brute_hg_02)
	(object_create_anew brute_hg_03)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod brute_hg_01 true)
	(object_cinematic_lod brute_hg_02 true)
	(object_cinematic_lod brute_hg_03 true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x06_01b_cleanup
	
	(object_destroy dervish)
	(object_destroy_containing brute_hg)
	(object_destroy_containing brute)
	)

(script static void x06_scene_01b
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_01b" none "anchor_flag_x06")
	
	(x06_01b_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_01b" false anchor_x06)

	(custom_animation_relative brute_hg_01 objects\characters\brute\x06\x06 "brute01_01b" false anchor_x06)
	(custom_animation_relative brute_hg_02 objects\characters\brute\x06\x06 "brute02_01b" false anchor_x06)
	(custom_animation_relative brute_hg_03 objects\characters\brute\x06\x06 "brute03_01b" false anchor_x06)
	(custom_animation_relative brute_01 objects\characters\brute\x06\x06 "brute04_01b" false anchor_x06)
	(custom_animation_relative brute_02 objects\characters\brute\x06\x06 "brute05_01b" false anchor_x06)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x06_01b_cleanup)
	)
	
; X06 SCENE 02 --------------------------------------------------------

(script dormant x06_0010_soc
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0010_soc none 1)
	)

(script dormant x06_0020_pot
	(sleep 92)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0020_pot none 1)
	)
	
(script dormant x06_0030_soc
	(sleep 168)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0030_soc commander 1)
	)
	
(script dormant x06_0040_pot
	(sleep 306)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0040_pot truth 1)
	)
	
(script dormant x06_0050_soc
	(sleep 371)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0050_soc commander 1)
	)
	
(script dormant x06_0060_pot
	(sleep 520)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0060_pot truth 1)
	)
	
(script dormant x06_0070_soc
	(sleep 794)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0070_soc commander 1)
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x06_02_setup

	(object_create_anew dervish)
	(object_create_anew truth)
	(object_create_anew mercy)
	(object_create_anew commander)
	
	(object_create_anew brute_hg_01)
	(object_create_anew brute_hg_02)
	(object_create_anew so_elite_01)
	(object_create_anew so_elite_02)
	
	(object_create_anew throne_truth)
	(object_create_anew throne_mercy)
	
	(objects_attach throne_truth "driver" truth "")
	(objects_attach throne_mercy "driver" mercy "")
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod brute_hg_01 true)
	(object_cinematic_lod brute_hg_02 true)
	(object_cinematic_lod so_elite_01 true)
	(object_cinematic_lod so_elite_02 true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_mercy true)
	
	(wake x06_0010_soc)
	(wake x06_0020_pot)
	(wake x06_0030_soc)
	(wake x06_0040_pot)
	(wake x06_0050_soc)
	(wake x06_0060_pot)
	(wake x06_0070_soc)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x06_02_cleanup
	
	(object_destroy dervish)
	(object_destroy_containing truth)
	(object_destroy_containing mercy)
	(object_destroy commander)
	(object_destroy_containing brute_hg)
	(object_destroy_containing so_elite)
	)

(script static void x06_scene_02
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_02" none "anchor_flag_x06")
	
	(x06_02_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_02" false anchor_x06)
	
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x06\x06 "throne_truth_02" false anchor_x06)
	(custom_animation truth objects\characters\prophet\x06\x06 "truth_02" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x06\x06 "throne_mercy_02" false anchor_x06)
	(custom_animation mercy objects\characters\prophet\x06\x06 "mercy_02" false)

	(custom_animation_relative commander objects\characters\elite\x06\x06 "commander_02" false anchor_x06)
	(custom_animation_relative so_elite_01 objects\characters\elite\x06\x06 "elite1_02" false anchor_x06)
	(custom_animation_relative so_elite_02 objects\characters\elite\x06\x06 "elite2_02" false anchor_x06)

	(custom_animation_relative brute_hg_01 objects\characters\brute\x06\x06 "brute01_02" false anchor_x06)
	(custom_animation_relative brute_hg_02 objects\characters\brute\x06\x06 "brute02_02" false anchor_x06)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x06_02_cleanup)
	)

; X06 SCENE 03 --------------------------------------------------------

(script dormant x06_0080_pot
	(sleep 208)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0080_pot none 1)
	)
	
(script dormant x06_0090_pot
	(sleep 325)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0090_pot truth 1)
	)
	
(script dormant x06_0100_pot
	(sleep 478)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0100_pot truth 1)
	)
	
(script dormant x06_0110_der
	(sleep 645)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0110_der dervish 1)
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x06_03_setup

	(object_create_anew dervish)
	(object_create_anew truth)
	(object_create_anew mercy)
	(object_create_anew commander)
	
	(object_create_anew brute_hg_01)
	(object_create_anew brute_hg_02)
	(object_create_anew so_elite_01)
	(object_create_anew so_elite_02)
	
	(object_create_anew throne_truth)
	(object_create_anew throne_mercy)
	
	(objects_attach throne_truth "driver" truth "")
	(objects_attach throne_mercy "driver" mercy "")
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod brute_hg_01 true)
	(object_cinematic_lod brute_hg_02 true)
	(object_cinematic_lod so_elite_01 true)
	(object_cinematic_lod so_elite_02 true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_mercy true)
	
	(wake x06_0080_pot)
	(wake x06_0090_pot)
	(wake x06_0100_pot)
	(wake x06_0110_der)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x06_03_cleanup
	
	(object_destroy dervish)
	(object_destroy_containing truth)
	(object_destroy_containing mercy)
	(object_destroy commander)
	(object_destroy_containing brute_hg)
	(object_destroy_containing so_elite)
	)

(script static void x06_scene_03
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_03" none "anchor_flag_x06")
	
	(x06_03_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_03" false anchor_x06)
	
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x06\x06 "throne_truth_03" false anchor_x06)
	(custom_animation truth objects\characters\prophet\x06\x06 "truth_03" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x06\x06 "throne_mercy_03" false anchor_x06)
	(custom_animation mercy objects\characters\prophet\x06\x06 "mercy_03" false)

	(custom_animation_relative commander objects\characters\elite\x06\x06 "commander_03" false anchor_x06)
	(custom_animation_relative so_elite_01 objects\characters\elite\x06\x06 "elite1_03" false anchor_x06)
	(custom_animation_relative so_elite_02 objects\characters\elite\x06\x06 "elite2_03" false anchor_x06)

	(custom_animation_relative brute_hg_01 objects\characters\brute\x06\x06 "brute01_03" false anchor_x06)
	(custom_animation_relative brute_hg_02 objects\characters\brute\x06\x06 "brute02_03" false anchor_x06)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x06_03_cleanup)
	)
	
; X06 SCENE 04 --------------------------------------------------------

(script dormant x06_0120_pot
	(sleep 15)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0120_pot none 1)
	)
	
(script dormant x06_0130_pom
	(sleep 109)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0130_pom mercy 1)
	)
	
(script dormant x06_0140_pot
	(sleep 346)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0140_pot truth 1)
	)
	
(script dormant x06_0150_pot
	(sleep 581)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0150_pot truth 1)
	)
	
(script dormant x06_0160_pom
	(sleep 715)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0160_pom mercy 1)
	)
	
(script dormant x06_fov_1
	(sleep 577)
	(camera_set_field_of_view 50)
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x06_04_setup

	(object_create_anew dervish)
	(object_create_anew truth)
	(object_create_anew mercy)
	
	(object_create_anew throne_truth)
	(object_create_anew throne_mercy)
	
	(objects_attach throne_truth "driver" truth "")
	(objects_attach throne_mercy "driver" mercy "")
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_mercy true)
	
	(wake x06_0120_pot)
	(wake x06_0130_pom)
	(wake x06_0140_pot)
	(wake x06_0150_pot)
	(wake x06_0160_pom)
	
	(wake x06_fov_1)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x06_04_cleanup
	
	(object_destroy dervish)
	(object_destroy_containing truth)
	(object_destroy_containing mercy)
	)

(script static void x06_scene_04
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 20)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_04" none "anchor_flag_x06")
	
	(x06_04_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_04" false anchor_x06)
	
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x06\x06 "throne_truth_04" false anchor_x06)
	(custom_animation truth objects\characters\prophet\x06\x06 "truth_04" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x06\x06 "throne_mercy_04" false anchor_x06)
	(custom_animation mercy objects\characters\prophet\x06\x06 "mercy_04" false)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x06_04_cleanup)
	)
	
; X06 SCENE 05 --------------------------------------------------------

(script dormant x06_0170_pot
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0170_pot none 1)
	)
	
(script dormant x06_0180_pot
	(sleep 276)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0180_pot truth 1)
	)
	
(script dormant x06_0190_pom
	(sleep 366)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0190_pom mercy 1)
	)
	
(script dormant x06_0200_pot
	(sleep 635)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0200_pot truth 1)
	)
	
(script dormant x06_0210_pot
	(sleep 780)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0210_pot truth 1)
	)
	
(script dormant x06_0220_pom
	(sleep 889)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0220_pom mercy 1)
	)

(script dormant x06_0230_pot
	(sleep 956)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x06_0230_pot truth 1)
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x06_05_setup

	(object_create_anew dervish)
	(object_create_anew truth)
	(object_create_anew mercy)
	(object_create_anew monitor)
	
	(object_create_anew throne_truth)
	(object_create_anew throne_mercy)
	
	(objects_attach throne_truth "driver" truth "")
	(objects_attach throne_mercy "driver" mercy "")
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod monitor true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_mercy true)
	
	(wake x06_0170_pot)
	(wake x06_0180_pot)
	(wake x06_0190_pom)
	(wake x06_0200_pot)
	(wake x06_0210_pot)
	(wake x06_0220_pom)
	(wake x06_0230_pot)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x06_05_cleanup
	
	(object_destroy dervish)
	(object_destroy_containing truth)
	(object_destroy_containing mercy)
	(object_destroy monitor)
	)

(script static void x06_scene_05
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x06\x06 "x06_05" none "anchor_flag_x06")
	
	(x06_05_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x06\x06 "dervish_05" false anchor_x06)
	
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x06\x06 "throne_truth_05" false anchor_x06)
	(custom_animation truth objects\characters\prophet\x06\x06 "truth_05" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x06\x06 "throne_mercy_05" false anchor_x06)
	(custom_animation mercy objects\characters\prophet\x06\x06 "mercy_05" false)
	
	(custom_animation_relative monitor objects\characters\monitor\x06\x06 "monitor_05" false anchor_x06)

	(sleep (- (unit_get_custom_animation_time dervish) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(x06_05_cleanup)
	)

; X06 MASTER SCRIPT ---------------------------------------------------

(script static void x06
	
	(switch_bsp 6)
	
	(x06_scene_01a)
	(x06_scene_01b)
	(x06_scene_02)
	(x06_scene_03)
	(x06_scene_04)
	(x06_scene_05)
	
	)

; ------------------------------------------------------------------------------------------------------------------------------------
; C06_INTRO SCENE 01 -----------------------------------------------------------------------------------------------------------------

(script dormant c06_1010_tar
	(sleep 144)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1010_tar none 1)
	)
	
(script dormant c06_1020_tar
	(sleep 191)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1020_tar tartarus 1)
	)
	
(script dormant c06_1030_tar
	(sleep 264)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1030_tar tartarus 1)
	)
	
(script dormant c06_1040_der
	(sleep 337)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1040_der dervish 1)
	)
	
(script dormant c06_1050_tar
	(sleep 463)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1050_tar none 1)
	)
	
(script dormant c06_1060_der
	(sleep 507)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1060_der dervish 1)
	)

(script dormant c06_1070_tar
	(sleep 550)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1070_tar tartarus 1)
	)

(script dormant c06_1080_tar
	(sleep 593)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1080_tar tartarus 1)
	)

(script dormant c06_1090_tar
	(sleep 623)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1090_tar none 1)
	)
	
(script dormant c06_1100_der
	(sleep 670)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1100_der dervish 1)
	)

(script dormant c06_1110_tar
	(sleep 745)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1110_tar none 1)
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void c06_intro_01_setup

	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew brute_03)
	(object_create_anew brute_04)
	(object_create_anew phantom_01)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod brute_03 true)
	(object_cinematic_lod brute_04 true)
	(object_cinematic_lod phantom_01 true)
	
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
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void c06_intro_01_cleanup

	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy_containing brute)
	(object_destroy phantom_01)
	
	)

(script static void c06_intro_scene_01
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\06_intro\06_intro "06_intro_01" none "anchor_flag_intro")
	
	(c06_intro_01_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\06_intro\06_intro "dervish_01" false anchor_intro)
	(custom_animation_relative tartarus objects\characters\brute\06_intro\06_intro "tartarus_01" false anchor_intro)
	
	(custom_animation_relative brute_01 objects\characters\brute\06_intro\06_intro "brute01_01" false anchor_intro)
	(custom_animation_relative brute_02 objects\characters\brute\06_intro\06_intro "brute02_01" false anchor_intro)
	(custom_animation_relative brute_03 objects\characters\brute\06_intro\06_intro "brute03_01" false anchor_intro)
	(custom_animation_relative brute_04 objects\characters\brute\06_intro\06_intro "brute04_01" false anchor_intro)
	
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\06_intro\06_intro "phantom_01" false anchor_intro)
	
	(fade_in 0 0 0 5)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(c06_intro_01_cleanup)
	
	)
	
; C06_INTRO SCENE 02 --------------------------------------------------

(script dormant c06_1120_tar
	(sleep 973)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1120_tar none 1)
	)
	
(script dormant c06_1130_tar
	(sleep 1052)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\c06_1130_tar tartarus 1)
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void c06_intro_02_setup

	(object_create_anew dervish)
	(object_create_anew phantom_01)
	(object_create_anew intro_sen_maj)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod intro_sen_maj true)
	(object_cinematic_lod phantom_01 true)
	
	(wake c06_1120_tar)
	(wake c06_1130_tar)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void c06_intro_02_cleanup
	
	(object_destroy dervish)
	(object_destroy intro_sen_maj)
	(object_destroy phantom_01)
	
	)

(script static void c06_intro_scene_02
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\06_intro\06_intro "06_intro_02" none "anchor_flag_intro")
	
	(c06_intro_02_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\06_intro\06_intro "dervish_02" false anchor_intro)
	(custom_animation_relative intro_sen_maj objects\characters\sentinel_major\06_intro\06_intro "sentinel_major_02" false anchor_intro)
	(custom_animation_relative phantom_01 objects\vehicles\phantom\animations\06_intro\06_intro "phantom_02" false anchor_intro)
	
	(sleep (- (unit_get_custom_animation_time dervish) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c06_intro_02_cleanup)
	)
	
; C06_INTRO MASTER SCRIPT ---------------------------------------------

(script static void C06_intro

	(sound_class_set_gain vehicle 0 0)

	(switch_bsp 0)
	
	(c06_intro_scene_01)
	(c06_intro_scene_02)
	
	(sound_class_set_gain vehicle 1 1)
	
	)
	
; ------------------------------------------------------------------------------------------------------------------------------------
; X07 SCENE 01 -----------------------------------------------------------------------------------------------------------------------

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x07_01_setup

	(object_create_anew miranda)
	(object_cinematic_lod miranda true)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x07_01_cleanup
	
	(object_destroy miranda)
	
	)

(script static void x07_scene_01
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_01" none "anchor_flag_x07")
	
	(x07_01_setup)
	
	(pvs_set_object miranda)
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_01" false anchor_x07)
	
	(fade_in 1 1 1 15)
	
	(sleep (unit_get_custom_animation_time miranda))
	
	(x07_01_cleanup)
	
	)
	
; X07 SCENE 02 --------------------------------------------------------

(script dormant x07_0010_mir
	(sleep 265)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0010_mir miranda 1)
	)
	
(script dormant x07_0020_jon
	(sleep 374)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0020_jon johnson 1)
	)
	
(script dormant x07_0030_mir
	(sleep 495)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0030_mir miranda 1)
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x07_02_setup

	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_cinematic_lod miranda true)
	(object_cinematic_lod johnson true)
	
	(wake x07_0010_mir)
	(wake x07_0020_jon)
	(wake x07_0030_mir)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x07_02_cleanup
	
	(object_destroy miranda)
	(object_destroy johnson)
	
	)

(script static void x07_scene_02
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_02" none "anchor_flag_x07")
	
	(x07_02_setup)
	
	(pvs_set_object miranda)
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_02" false anchor_x07)
	(custom_animation_relative johnson objects\characters\marine\x07\x07 "johnson_02" false anchor_x07)
	
	(sleep (unit_get_custom_animation_time miranda))
	
	(x07_02_cleanup)
	
	)

; X07 SCENE 03 --------------------------------------------------------

(script dormant x07_0040_jon
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0040_jon johnson 1)
	)
	
(script dormant x07_0050_jon
	(sleep 84)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0050_jon johnson 1)
	)
	
(script dormant x07_0060_jon
	(sleep 139)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0060_jon johnson 1)
	)
	
(script dormant x07_0070_jon
	(sleep 612)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0070_jon johnson 1)
	)
	
(script dormant x07_0080_jon
	(sleep 771)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0080_jon johnson 1)
	)
	
(script dormant x07_0090_mir
	(sleep 838)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0090_mir none 1)
	)
	
(script dormant x07_0100_mir
	(sleep 862)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0100_mir miranda 1)
	)
	
(script dormant miranda_smgs_arm_1
	(sleep 240)
	(objects_attach miranda "right_hand" miranda_smg_01 "")
	(objects_attach miranda "left_hand" miranda_smg_02 "")
	)
	
(script dormant miranda_smgs_fire_1
	(sleep 897)
	(sleep_until 
		(begin
			
			(effect_new_on_object_marker effects\objects\weapons\rifle\smg\fire_bullet miranda_smg_01 "primary_trigger")
			(sleep 3)
			(effect_new_on_object_marker effects\objects\weapons\rifle\smg\fire_bullet miranda_smg_02 "primary_trigger")
			
			; Return false always
			false
		)
		2 	; Rate of repetition
		60 	; Timeout
	) 
	)

(script dormant johnson_rifle_fire
	(sleep 625)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 7)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 8)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 25)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	(sleep 7)
	(effect_new_on_object_marker effects\objects\weapons\rifle\battle_rifle\fire_bullet johnson_rifle "primary_trigger")
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x07_03_setup

	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_create_anew dervish)
	
	(object_create_anew miranda_smg_01)
	(object_create_anew miranda_smg_02)
	(object_create_anew johnson_rifle)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod dervish true)
	(object_cinematic_lod miranda_smg_01 true)
	(object_cinematic_lod miranda_smg_02 true)
	(object_cinematic_lod johnson_rifle true)
	
	(objects_attach johnson "right_hand" johnson_rifle "")
	
	(wake x07_0040_jon)
	(wake x07_0050_jon)
	(wake x07_0060_jon)
	
	(wake x07_0070_jon)
	(wake x07_0080_jon)
	(wake x07_0090_mir)
	(wake x07_0100_mir)
	
	(wake miranda_smgs_arm_1)
	(wake miranda_smgs_fire_1)
	(wake johnson_rifle_fire)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x07_03_cleanup
	
	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy dervish)
	(object_destroy_containing miranda_smg)
	(object_destroy johnson_rifle)
	
	
	)

(script static void x07_scene_03
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_03" none "anchor_flag_x07")
	
	(x07_03_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_03" false anchor_x07)
	(custom_animation_relative johnson objects\characters\marine\x07\x07 "johnson_03" false anchor_x07)
	(custom_animation_relative dervish objects\characters\dervish\x07\x07 "dervish_03" false anchor_x07)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x07_03_cleanup)
	
	)
	
; X07 SCENE 04 --------------------------------------------------------
	
(script dormant x07_0110_mir
	(sleep 171)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0110_mir miranda 1)
	)
	
(script dormant x07_0120_mir
	(sleep 244)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0120_mir miranda 1)
	)
	
(script dormant x07_0130_tar
	(sleep 623)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0130_tar tartarus 1)
	)
	
(script dormant x07_0140_der
	(sleep 765)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0140_der dervish 1)
	)

(script dormant miranda_smgs_arm_2
	(objects_attach miranda "right_hand" miranda_smg_01 "")
	(objects_attach miranda "left_hand" miranda_smg_02 "")
	
	(sleep 343)
	
	(objects_detach miranda miranda_smg_01)
	(objects_detach miranda miranda_smg_02)
	
	(object_destroy_containing miranda_smg)

	)
	
(script dormant miranda_smgs_fire_2
	(sleep 0)
	(sleep_until 
		(begin
			
			(effect_new_on_object_marker effects\objects\weapons\rifle\smg\fire_bullet miranda_smg_01 "primary_trigger")
			(sleep 3)
			(effect_new_on_object_marker effects\objects\weapons\rifle\smg\fire_bullet miranda_smg_02 "primary_trigger")
			
			; Return false always
			false
		)
		2 	; Rate of repetition
		158 	; Timeout
	) 
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x07_04_setup

	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_create_anew dervish)
	(object_create_anew tartarus)
	
	(object_create_anew miranda_smg_01)
	(object_create_anew miranda_smg_02)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod miranda_smg_01 true)
	(object_cinematic_lod miranda_smg_02 true)
	
	(wake x07_0110_mir)
	(wake x07_0120_mir)
	(wake x07_0130_tar)
	(wake x07_0140_der)
	
	(wake miranda_smgs_arm_2)
	(wake miranda_smgs_fire_2)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x07_04_cleanup
	
	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy dervish)
	(object_destroy_containing miranda_smg)
	
	)

(script static void x07_scene_04
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_04" none "anchor_flag_x07")
	
	(x07_04_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_04" false anchor_x07)
	(custom_animation_relative johnson objects\characters\marine\x07\x07 "johnson_04" false anchor_x07)
	(custom_animation_relative dervish objects\characters\dervish\x07\x07 "dervish_04" false anchor_x07)
	(custom_animation_relative tartarus objects\characters\brute\x07\x07 "tartarus_04" false anchor_x07)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x07_04_cleanup)
	
	)
	
; X07 SCENE 05 --------------------------------------------------------
	
(script dormant x07_0150_tar
	(sleep 43)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0150_tar tartarus 1)
	)
	
(script dormant x07_0160_tar
	(sleep 128)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0160_tar tartarus 1)
	)	

(script dormant x07_0170_tar
	(sleep 451)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0170_tar tartarus 1)
	)
	
(script dormant x07_0180_tar
	(sleep 685)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0180_tar tartarus 1)
	)
	
(script dormant tartarus_bruteshot_arm_1
	(sleep 584)
	(objects_attach tartarus "right_hand" brute_shot_01 "")
	)
	
;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x07_05_setup

	(object_create_anew miranda)
	(object_create_anew johnson)
	(object_create_anew dervish)
	(object_create_anew tartarus)
	
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew brute_03)
	(object_create_anew brute_04)
	
	(object_cinematic_lod miranda true)
	(object_cinematic_lod johnson true)
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod brute_03 true)
	(object_cinematic_lod brute_04 true)
	
	(wake x07_0150_tar)
	(wake x07_0160_tar)
	(wake x07_0170_tar)
	(wake x07_0180_tar)
	
	(wake tartarus_bruteshot_arm_1)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x07_05_cleanup
	
	(object_destroy miranda)
	(object_destroy johnson)
	(object_destroy dervish)
	(object_destroy_containing brute)
	
	)

(script static void x07_scene_05
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_05" none "anchor_flag_x07")
	
	(x07_05_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative miranda objects\characters\miranda\x07\x07 "miranda_05" false anchor_x07)
	(custom_animation_relative johnson objects\characters\marine\x07\x07 "johnson_05" false anchor_x07)
	(custom_animation_relative dervish objects\characters\dervish\x07\x07 "dervish_05" false anchor_x07)
	(custom_animation_relative tartarus objects\characters\brute\x07\x07 "tartarus_05" false anchor_x07)
	
	(custom_animation_relative brute_01 objects\characters\brute\x07\x07 "brute01_05" false anchor_x07)
	(custom_animation_relative brute_02 objects\characters\brute\x07\x07 "brute02_05" false anchor_x07)
	(custom_animation_relative brute_03 objects\characters\brute\x07\x07 "brute03_05" false anchor_x07)
	(custom_animation_relative brute_04 objects\characters\brute\x07\x07 "brute04_05" false anchor_x07)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x07_05_cleanup)
	
	)
	
; X07 SCENE 06 --------------------------------------------------------
	
(script dormant x07_0190_der
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0190_der dervish 1)
	)
	
(script dormant x07_0200_tar
	(sleep 95)
	(sound_impulse_start sound\dialog\levels\06_sentinelwall\cinematic\x07_0200_tar none 1)
	)
	
(script dormant tartarus_bruteshot_arm_2
	(objects_attach tartarus "right_hand" brute_shot_01 "")
	)

(script dormant tartarus_bruteshot_fire_1
	(sleep 394)
	(effect_new_on_object_marker effects\objects\weapons\support_low\brute_shot\brute_shot_fire brute_shot_01 "primary_trigger")
	)

;(script dormant x06_01_dof_1
;	(sleep 567)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
;	)

(script static void x07_06_setup

	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew brute_shot_01)

	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_shot_01 true)
	
	(wake x07_0190_der)
	(wake x07_0200_tar)
	
	(wake tartarus_bruteshot_arm_2)
	(wake tartarus_bruteshot_fire_1)
	
;	(wake x04_01_dof_1)
	
	)
	
(script static void x07_06_cleanup

	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy brute_shot_01)
	
	)

(script static void x07_scene_06
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 50)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x07\x07 "x07_06" none "anchor_flag_x07")
	
	(x07_06_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x07\x07 "dervish_06" false anchor_x07)
	(custom_animation_relative tartarus objects\characters\brute\x07\x07 "tartarus_06" false anchor_x07)
	
	(sleep (- (unit_get_custom_animation_time dervish) 1))
	
	(fade_out 0 0 0 0)
	(sleep 1)
	
	(x07_06_cleanup)
	
	)

; X07_INTRO MASTER SCRIPT ---------------------------------------------------

(script static void x07
	
	(switch_bsp 5)
	
	(x07_scene_01)
	(x07_scene_02)
	(x07_scene_03)
	(x07_scene_04)
	(x07_scene_05)
	(x07_scene_06)
	
	)