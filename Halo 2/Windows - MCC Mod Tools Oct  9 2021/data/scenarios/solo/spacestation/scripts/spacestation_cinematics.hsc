; Cinematics for level 01, "SPACE-STATION" ----------------------------
; ---------------------------------------------------------------------

; X02 SCENE 01 --------------------------------------------------------
(script static void x01_scene_01
	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 55)
	
	(sleep 60)
	(print "so full of hate were our eyes...")
	(sleep 30)
	(print "that none of us could see")
	(sleep 60)
	(print "our war would yield countless dead...")
	(sleep 30)
	(print "but never victory")
	(sleep 60)
	(print "excerpt, covenant writ of union")
	(sleep 120)
	
	(object_create_anew x01_01_obj)
	(objects_attach anchor "" x01_01_obj "")
	(scenery_animation_start x01_01_obj objects\cinematics\matte_elements\x01\x01_01\x01_01 "idle")
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_01" none "anchor_flag")
	
	(fade_in 0 0 0 15)
	
	(sleep 110)
	
	(print "covenant holy city, high charity")
	(print "ninth age of reclamation")
	
	(camera_predict c_x01_02_predict)
	
	(sleep 109)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_crossfade 1)
	
	(sleep 1)
;	(sleep 220)
	
	)

; X02 SCENE 02 --------------------------------------------------------
(script static void x01_02_setup

	(object_destroy x01_01_obj)

 	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew truth)
	(object_create_anew regret)
	(object_create_anew mercy)
	(object_create_anew_containing throne)
	(object_create_anew prophet_c_01)
	(object_create_anew prophet_c_02)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod regret true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_regret true)
	(object_cinematic_lod throne_mercy true)
	(object_cinematic_lod prophet_c_02 true)
	(object_cinematic_lod prophet_c_02 true)
	
	(objects_attach anchor "" dervish "")
	(objects_attach anchor "" tartarus "")
	(objects_attach throne_truth "driver" truth "")
	(objects_attach anchor "" throne_truth "")
	(objects_attach throne_regret "driver" regret "")
	(objects_attach anchor "" throne_regret "")
	(objects_attach throne_mercy "driver" mercy "")
	(objects_attach anchor "" throne_mercy "")
	(objects_attach anchor "" prophet_c_01 "")
	(objects_attach anchor "" prophet_c_02 "")
	)

(script static void x01_scene_02
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(x01_02_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_02" none "anchor_flag")
	
	(custom_animation dervish objects\characters\elite\x01\x01 "dervish_02" true)
	(custom_animation tartarus objects\characters\brute\x01\x01 "tartarus_02" true)
	
	(custom_animation truth objects\characters\prophet\x01\x01 "truth_02" true)
	(custom_animation throne_truth objects\vehicles\gravity_throne\animations\x01\x01 "throne_truth_02" true)
	(custom_animation regret objects\characters\prophet\x01\x01 "regret_02" true)
	(custom_animation throne_regret objects\vehicles\gravity_throne\animations\x01\x01 "throne_regret_02" true)
	(custom_animation mercy objects\characters\prophet\x01\x01 "mercy_02" true)
	(custom_animation throne_mercy objects\vehicles\gravity_throne\animations\x01\x01 "throne_mercy_02" true)
	
	(custom_animation prophet_c_01 objects\characters\prophet\x01\x01 "prophetminor1_02" true)
	(custom_animation prophet_c_02 objects\characters\prophet\x01\x01 "prophetminor2_02" true)
	
	
	(sleep (- (unit_get_custom_animation_time dervish) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	)
	
; X02 SCENE 03 --------------------------------------------------------
(script static void x01_scene_03
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 55)
	
	(fade_in 1 1 1 15)
	
	(object_create_anew x01_03_obj)
	(objects_attach anchor "" x01_03_obj "")
	(scenery_animation_start x01_03_obj objects\cinematics\matte_elements\x01\x01_03\x01_03 "idle")
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_03" none "anchor_flag")
	
	(sleep 169)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_crossfade 1)
	
	(sleep 1)
;	(sleep 170)
	)
	
; X02 SCENE 04 --------------------------------------------------------
(script static void x01_scene_04
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 55)
	
	(object_create_anew x01_04_obj)
	(objects_attach anchor "" x01_04_obj "")
	(scenery_animation_start x01_04_obj objects\cinematics\matte_elements\x01\x01_04\x01_04 "idle")
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_04" none "anchor_flag")
	
	(sleep 235)
	
	(fade_out 1 1 1 15)
	(sleep 15)
;	(sleep 250)

	)
	
; X02 SCENE 05 --------------------------------------------------------

(script static void x01_05_setup

	(object_destroy x01_03_obj)
	(object_destroy x01_04_obj)

	(object_create_anew truth)
	(object_create_anew regret)
	(object_create_anew mercy)
	(object_create_anew_containing throne)

	(object_cinematic_lod truth true)
	(object_cinematic_lod regret true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod throne_regret true)
	(object_cinematic_lod throne_regret true)
	(object_cinematic_lod throne_regret true)
	
	(objects_attach throne_truth "driver" truth "")
	(objects_attach anchor "" throne_truth "")
	(objects_attach throne_regret "driver" regret "")
	(objects_attach anchor "" throne_regret "")
	(objects_attach throne_mercy "driver" mercy "")
	(objects_attach anchor "" throne_mercy "")
	)

(script static void x01_scene_05
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(fade_in 1 1 1 15)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_05" none "anchor_flag")
	
	(custom_animation truth objects\characters\prophet\x01\x01 "truth_05" true)
	(custom_animation throne_truth objects\vehicles\gravity_throne\animations\x01\x01 "throne_truth_05" true)
	(custom_animation regret objects\characters\prophet\x01\x01 "regret_05" true)
	(custom_animation throne_regret objects\vehicles\gravity_throne\animations\x01\x01 "throne_regret_05" true)
	(custom_animation mercy objects\characters\prophet\x01\x01 "mercy_05" true)
	(custom_animation throne_mercy objects\vehicles\gravity_throne\animations\x01\x01 "throne_mercy_05" true)
	
	(sleep 209)
	)

; X02 SCENE 06 --------------------------------------------------------

(script static void x01_06_setup

	(object_create_anew dervish)
	(object_create_anew truth)
	(object_create_anew regret)
	(object_create_anew mercy)
	(object_create_anew_containing throne)

	(object_cinematic_lod dervish true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod regret true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod throne_regret true)
	(object_cinematic_lod throne_regret true)
	(object_cinematic_lod throne_regret true)
	
	(objects_attach anchor "" dervish "")
	(objects_attach throne_truth "driver" truth "")
	(objects_attach anchor "" throne_truth "")
	(objects_attach throne_regret "driver" regret "")
	(objects_attach anchor "" throne_regret "")
	(objects_attach throne_mercy "driver" mercy "")
	(objects_attach anchor "" throne_mercy "")
	)

(script static void x01_scene_06
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(x01_06_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_06" none "anchor_flag")
	(custom_animation dervish objects\characters\elite\x01\x01 "dervish_06" true)
	
	(custom_animation truth objects\characters\prophet\x01\x01 "truth_06" true)
	(custom_animation throne_truth objects\vehicles\gravity_throne\animations\x01\x01 "throne_truth_06" true)
	(custom_animation regret objects\characters\prophet\x01\x01 "regret_06" true)
	(custom_animation throne_regret objects\vehicles\gravity_throne\animations\x01\x01 "throne_regret_06" true)
	(custom_animation mercy objects\characters\prophet\x01\x01 "mercy_06" true)
	(custom_animation throne_mercy objects\vehicles\gravity_throne\animations\x01\x01 "throne_mercy_06" true)
	
	(sleep (- (unit_get_custom_animation_time dervish) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	)
	
; X02 SCENE 07 --------------------------------------------------------
(script static void x01_scene_07
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 55)
	
	(fade_in 1 1 1 15)
	
	(object_create_anew x01_07_obj)
	(objects_attach anchor "" x01_07_obj "")
	(scenery_animation_start x01_07_obj objects\cinematics\matte_elements\x01\x01_07\x01_07 "idle")
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_07" none "anchor_flag")
	
	(sleep 105)
	
	(fade_out 1 1 1 15)
	(sleep 15)
;	(sleep 120)
	)
	
; X02 SCENE 08 --------------------------------------------------------

(script static void x01_08_setup

	(object_destroy x01_07_obj)

	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew truth)
	(object_create_anew regret)
	(object_create_anew mercy)
	(object_create_anew_containing throne)
	(object_create_anew elite_c_01)
	(object_create_anew elite_c_02)
	(object_create_anew prophet_c_01)
	(object_create_anew prophet_c_02)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod regret true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_regret true)
	(object_cinematic_lod throne_mercy true)
	(object_cinematic_lod elite_c_02 true)
	(object_cinematic_lod elite_c_02 true)
	(object_cinematic_lod prophet_c_02 true)
	(object_cinematic_lod prophet_c_02 true)
	
	(objects_attach anchor "" dervish "")
	(objects_attach anchor "" tartarus "")
	(objects_attach throne_truth "driver" truth "")
	(objects_attach anchor "" throne_truth "")
	(objects_attach throne_regret "driver" regret "")
	(objects_attach anchor "" throne_regret "")
	(objects_attach throne_mercy "driver" mercy "")
	(objects_attach anchor "" throne_mercy "")
	(objects_attach anchor "" elite_c_01 "")
	(objects_attach anchor "" elite_c_02 "")
	(objects_attach anchor "" prophet_c_01 "")
	(objects_attach anchor "" prophet_c_02 "")
	)
	
(script static void x01_08_cleanup

	(object_destroy elite_c_01)
	(object_destroy elite_c_02)
	)

(script static void x01_scene_08
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(x01_08_setup)
	
	(fade_in 1 1 1 15)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_08" none "anchor_flag")
	
	(custom_animation dervish objects\characters\elite\x01\x01 "dervish_08" true)
	(custom_animation tartarus objects\characters\brute\x01\x01 "tartarus_08" true)
	
	(custom_animation truth objects\characters\prophet\x01\x01 "truth_08" true)
	(custom_animation throne_truth objects\vehicles\gravity_throne\animations\x01\x01 "throne_truth_08" true)
	(custom_animation regret objects\characters\prophet\x01\x01 "regret_08" true)
	(custom_animation throne_regret objects\vehicles\gravity_throne\animations\x01\x01 "throne_regret_08" true)
	(custom_animation mercy objects\characters\prophet\x01\x01 "mercy_08" true)
	(custom_animation throne_mercy objects\vehicles\gravity_throne\animations\x01\x01 "throne_mercy_08" true)
	
	(custom_animation elite_c_01 objects\characters\elite\x01\x01 "councilor1_08" true)
	(custom_animation elite_c_02 objects\characters\elite\x01\x01 "councilor2_08" true)
	(custom_animation prophet_c_01 objects\characters\prophet\x01\x01 "prophetminor1_08" true)
	(custom_animation prophet_c_02 objects\characters\prophet\x01\x01 "prophetminor2_08" true)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x01_08_cleanup)
	)

; X02 SCENE 09 --------------------------------------------------------

(script static void x01_09_setup

	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew truth)
	(object_create_anew regret)
	(object_create_anew mercy)
	(object_create_anew_containing throne)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod regret true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_regret true)
	(object_cinematic_lod throne_mercy true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	
	(objects_attach anchor "" dervish "")
	(objects_attach anchor "" tartarus "")
	(objects_attach throne_truth "driver" truth "")
	(objects_attach anchor "" throne_truth "")
	(objects_attach throne_regret "driver" regret "")
	(objects_attach anchor "" throne_regret "")
	(objects_attach throne_mercy "driver" mercy "")
	(objects_attach anchor "" throne_mercy "")
	(objects_attach anchor "" dervish "")
	(objects_attach anchor "" dervish "")
	(objects_attach anchor "" brute_01 "")
	(objects_attach anchor "" brute_02 "")
	)
	
(script static void x01_09_cleanup
	
	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy truth)
	(object_destroy regret)
	(object_destroy mercy)
	(object_destroy_containing throne)
	(object_destroy brute_01)
	(object_destroy brute_02)
	)

(script static void x01_scene_09
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(x01_09_setup)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\cinematic_camera "x01_09" none "anchor_flag")
	
	(custom_animation dervish objects\characters\elite\x01\x01 "dervish_09" true)
	(custom_animation tartarus objects\characters\brute\x01\x01 "tartarus_09" true)
	
	(custom_animation truth objects\characters\prophet\x01\x01 "truth_09" true)
	(custom_animation throne_truth objects\vehicles\gravity_throne\animations\x01\x01 "throne_truth_09" true)
	(custom_animation regret objects\characters\prophet\x01\x01 "regret_09" true)
	(custom_animation throne_regret objects\vehicles\gravity_throne\animations\x01\x01 "throne_regret_09" true)
	(custom_animation mercy objects\characters\prophet\x01\x01 "mercy_09" true)
	(custom_animation throne_mercy objects\vehicles\gravity_throne\animations\x01\x01 "throne_mercy_09" true)
	
	(custom_animation brute_01 objects\characters\brute\x01\x01 "brute01_09" true)
	(custom_animation brute_02 objects\characters\brute\x01\x01 "brute02_09" true)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x01_09_cleanup)
	)
	
; X01 MASTER SCRIPT ---------------------------------------------------

(script static void x01
	(x01_scene_01)
	(x01_scene_02)
	(x01_scene_03)
	(x01_scene_04)
	(x01_scene_05)
	(x01_scene_06)
	(x01_scene_07)
	(x01_scene_08)
	(x01_scene_09)
	
	(fade_out 0 0 0 0)
	
	(cinematic_stop)
	(camera_control off)
	)