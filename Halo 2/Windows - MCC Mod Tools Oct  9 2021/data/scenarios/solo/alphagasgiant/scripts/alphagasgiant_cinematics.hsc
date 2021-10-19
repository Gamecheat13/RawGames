; CINEMATICS FOR LEVEL 04, ALPHA GAS-GIANT ----------------------------
; X04 SCENE 01 --------------------------------------------------------

(script dormant x04_score_1
	(sleep 0)
	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
	)

(script dormant x04_0010_bgr
	(sleep 483)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0010_bgr brute_01 1)
	)
	
(script dormant x04_0020_bgl
	(sleep 632)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0020_bgl brute_02 1)
	) 
	
(script dormant x04_0040_jcr
	(sleep 712)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0040_jcr jackal_01 1)
	) 
	
(script dormant x04_0030_bgl
	(sleep 804)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0030_bgl brute_02 1)
	) 
	
(script dormant x04_0050_bgr
	(sleep 845)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0050_bgr brute_01 1)
	) 
	
(script dormant x04_01_dof_1
	(sleep 567)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
	(print "rack focus")
	(sleep 64)
	(cinematic_screen_effect_stop)
	(print "rack focus")
	)

(script static void x04_01_setup

	(object_create_anew dervish)
	(object_create_anew tartarus)
	(object_create_anew brute_01)
	(object_create_anew brute_02)
	(object_create_anew jackal_01)
	(object_create_anew jackal_02)
	(object_create_anew jackal_03)
	
	(object_cinematic_lod dervish true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_01 true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod jackal_01 true)
	(object_cinematic_lod jackal_02 true)
	(object_cinematic_lod jackal_03 true)
	
;	(wake x04_score_1)
	(wake x04_0010_bgr)
	(wake x04_0020_bgl)
	(wake x04_0040_jcr)
	(wake x04_0030_bgl)
	(wake x04_0050_bgr)
	
	(wake x04_01_dof_1)
	
	)
	
(script static void x04_01_cleanup
	
	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy brute_01)
	(object_destroy brute_02)
	(object_destroy_containing jackal)
	)

(script static void x04_scene_01

	(fade_out 0 0 0 0)
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_01" none "cinematic_anchor")
	
	(x04_01_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_01" false anchor)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_01" false anchor)

	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_01" false anchor)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_01" false anchor)
	
	(custom_animation_relative jackal_01 objects\characters\jackal\x04\x04 "jackal01_01" false anchor)
	(custom_animation_relative jackal_02 objects\characters\jackal\x04\x04 "jackal02_01" false anchor)
	(custom_animation_relative jackal_03 objects\characters\jackal\x04\x04 "jackal03_01" false anchor)
	
	(sleep 30)
	(fade_in 0 0 0 30)
	(sleep 45)
	(fade_out 0 0 0 30)
	(sleep 45)
	(fade_in 0 0 0 20)
	(sleep 30)
	(fade_out 0 0 0 20)
	(sleep 45)
	(fade_in 0 0 0 10)
	
	(sleep (unit_get_custom_animation_time dervish))
	
;	(x04_01_cleanup)
	)

; X04 SCENE 02a --------------------------------------------------------

(script dormant x04_0060_tar
	(sleep 173)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0060_tar tartarus 1)
	) 
	
(script dormant x04_0070_tar
	(sleep 300)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0070_tar tartarus 1)
	)
	
(script dormant x04_0080_tar
	(sleep 370)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0080_tar tartarus 1)
	) 

(script static void x04_02a_setup

;	(object_create_anew dervish)
;	(object_create_anew tartarus)
;	(object_create_anew brute_01)
;	(object_create_anew brute_02)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod tartarus true)
;	(object_cinematic_lod brute_01 true)
;	(object_cinematic_lod brute_02 true)
	
	(wake x04_0060_tar)
	(wake x04_0070_tar)
	(wake x04_0080_tar)
	
	)
	
(script static void x04_02a_cleanup
	
	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy brute_01)
	(object_destroy brute_02)
	)

(script static void x04_scene_02a
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_02a" none "cinematic_anchor")
	
	(x04_02a_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_02a" false anchor)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_02a" false anchor)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_02a" false anchor)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_02a" false anchor)
	
	(sleep (- (unit_get_custom_animation_time dervish) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
;	(x04_02a_cleanup)
	)
	
; X04 SCENE 02b --------------------------------------------------------

(script static void x04_02b_setup

;	(object_create_anew dervish)
;	(object_create_anew tartarus)
;	(object_create_anew brute_01)
;	(object_create_anew brute_02)
	
	(object_cinematic_lod dervish true)
;	(object_cinematic_lod tartarus true)
;	(object_cinematic_lod brute_01 true)
;	(object_cinematic_lod brute_02 true)

	)
	
(script static void x04_02b_cleanup
	
	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy brute_01)
	(object_destroy brute_02)
	(object_destroy_containing jackal)
	)

(script static void x04_scene_02b
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_02b" none "cinematic_anchor")
	
	(x04_02b_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_02b" false anchor)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_02b" false anchor)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_02b" false anchor)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_02b" false anchor)
	
	(fade_in 1 1 1 15)
	
	(sleep (unit_get_custom_animation_time dervish))
	
;	(x04_02b_cleanup)
	)

; X04 SCENE 03a --------------------------------------------------------

(script static void x04_03a_setup

;	(object_create_anew dervish)
;	(object_create_anew tartarus)
;	(object_create_anew brute_01)
;	(object_create_anew brute_02)
	
	(object_cinematic_lod dervish true)
;	(object_cinematic_lod tartarus true)
;	(object_cinematic_lod brute_01 true)
;	(object_cinematic_lod brute_02 true)

	)
	
(script static void x04_03a_cleanup
	
	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy brute_01)
	(object_destroy brute_02)
	(object_destroy_containing jackal)
	)

(script static void x04_scene_03a
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_03a" none "cinematic_anchor")
	
	(x04_03a_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_03a" false anchor)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_03a" false anchor)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_03a" false anchor)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_03a" false anchor)
	
	(sleep (unit_get_custom_animation_time dervish))
	
;	(x04_03a_cleanup)
	)

; X04 SCENE 03b --------------------------------------------------------

;(script dormant 03b_04_crossfade
;	(sleep 448)
;	(cinematic_screen_effect_start true)
;	(cinematic_screen_effect_set_crossfade 2)
;	)

(script dormant x04_03b_dof_1
	(sleep 91)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_depth_of_field 1 .5 .5 0.001 0 0 0.001)
	(print "rack focus")
	(sleep 140)
	(cinematic_screen_effect_set_depth_of_field 5 .5 .5 0.001 0 0 0.001)
	(print "rack focus")
	
;	(player_effect_set_max_rotation 0 1 1)
;	(player_effect_set_max_translation 0 0 .005)
;	(player_effect_start .25 0)
	)

(script static void x04_03b_setup

;	(object_create_anew dervish)
;	(object_create_anew tartarus)
;	(object_create_anew brute_01)
;	(object_create_anew brute_02)
	(object_create_anew_containing honor_guard)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod tartarus true)
;	(object_cinematic_lod brute_01 true)
;	(object_cinematic_lod brute_02 true)

;	(wake 03b_04_crossfade)
	(wake x04_03b_dof_1)
	
	)
	
(script static void x04_03b_cleanup
	
;	(object_destroy dervish)
;	(object_destroy tartarus)
;	(object_destroy brute_01)
;	(object_destroy brute_02)
	(object_destroy_containing honor_guard)
	
	)

(script static void x04_scene_03b
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_03b" none "cinematic_anchor")
	
	(x04_03b_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_03b" false anchor)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_03b" false anchor)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_03b" false anchor)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_03b" false anchor)
	
	(sleep (- (unit_get_custom_animation_time dervish) 30))	
	
	(cinematic_screen_effect_stop)
	(cinematic_screen_effect_start true)
	(cinematic_screen_effect_set_crossfade 1)
	
;	(sleep 30)
	
	(x04_03b_cleanup)
	)

; X04 SCENE 04 --------------------------------------------------------

(script static void x04_04_setup

;	(object_create_anew dervish)
;	(object_create_anew tartarus)
	(object_create_anew truth)
	(object_create_anew mercy)
	(object_create_anew_containing throne)
;	(object_create_anew brute_01)
;	(object_create_anew brute_02)
	(object_create_anew sarcophagus)

	(object_destroy_containing jackal)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod tartarus true)
	(object_cinematic_lod truth true)
	(object_cinematic_lod mercy true)
	(object_cinematic_lod throne_truth true)
	(object_cinematic_lod throne_mercy true)
;	(object_cinematic_lod brute_01 true)
;	(object_cinematic_lod brute_02 true)

	(objects_attach throne_truth "driver" truth "")
	(objects_attach throne_mercy "driver" mercy "")
	
	)
	
(script static void x04_04_cleanup
	
	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy truth)
	(object_destroy mercy)
	(object_destroy_containing throne)
	(object_destroy brute_01)
	(object_destroy brute_02)
	)

(script static void x04_scene_04
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_04" none "cinematic_anchor")
	
	(x04_04_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_04" false anchor)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_04" false anchor)
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x04\x04 "throne_truth_04" false anchor)
	(custom_animation truth objects\characters\prophet\x04\x04 "truth_04" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x04\x04 "throne_mercy_04" false anchor)
	(custom_animation mercy objects\characters\prophet\x04\x04 "mercy_04" false)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_04" false anchor)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_04" false anchor)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_04" anchor)
	
	(sleep (unit_get_custom_animation_time dervish))
	
;	(x04_04_cleanup)
	)
	
; X04 SCENE 05 --------------------------------------------------------

(script dormant x04_0090_tar
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0090_tar tartarus 1)
	)

(script dormant x04_0100_pot
	(sleep 157)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0100_pot truth 1)
	)
	
(script dormant x04_0110_tar
	(sleep 205)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0110_tar tartarus 1)
	)
	
(script dormant x04_0120_pot
	(sleep 242)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0120_pot truth 1)
	)
	
(script dormant x04_0130_tar
	(sleep 385)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0130_tar tartarus 1)
	)
	
(script dormant x04_0140_pot
	(sleep 554)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0140_pot truth 1)
	)

(script dormant x04_0150_pot
	(sleep 731)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0150_pot truth 1)
	)

(script dormant x04_05_dof_1
	(sleep 708)
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_depth_of_field 2 0 0 .001 .5 .5 .001)
	(print "rack focus")
	)

(script static void x04_05_setup

;	(object_create_anew dervish)
;	(object_create_anew tartarus)
;	(object_create_anew truth)
;	(object_create_anew_containing throne)
;	(object_create_anew brute_01)
;	(object_create_anew brute_02)
	
;	(object_destroy_containing mercy)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod tartarus true)
;	(object_cinematic_lod truth true)
;	(object_cinematic_lod throne_truth true)
;	(object_cinematic_lod brute_01 true)
;	(object_cinematic_lod brute_02 true)
	
	(wake x04_0090_tar)
	(wake x04_0100_pot)
	(wake x04_0110_tar)
	(wake x04_0120_pot)
	(wake x04_0130_tar)
	(wake x04_0140_pot)
	(wake x04_0150_pot)
	
	(wake x04_05_dof_1)

	)
	
(script static void x04_05_cleanup
	
	(object_destroy dervish)
	(object_destroy tartarus)
	(object_destroy truth)
	(object_destroy_containing throne)
	(object_destroy brute_01)
	(object_destroy brute_02)
	)

(script static void x04_scene_05
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_05" none "cinematic_anchor")
	
	(x04_05_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_05" false anchor)
	(custom_animation_relative tartarus objects\characters\brute\x04\x04 "tartarus_05" false anchor)
	(custom_animation_relative brute_01 objects\characters\brute\x04\x04 "brute01_05" false anchor)
	(custom_animation_relative brute_02 objects\characters\brute\x04\x04 "brute02_05" false anchor)
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x04\x04 "throne_truth_05" false anchor)
	(custom_animation truth objects\characters\prophet\x04\x04 "truth_05" false)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_05" anchor)
	
	(sleep (unit_get_custom_animation_time dervish))
	
;	(x04_05_cleanup)
	)
	
; X04 SCENE 06 --------------------------------------------------------

(script dormant x04_0160_der
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0160_der dervish 1)
	)
	
(script dormant x04_0170_pot
	(sleep 46)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0170_pot truth 1)
	)
	
(script dormant x04_0180_pot
	(sleep 104)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0180_pot truth 1)
	)
	
(script dormant x04_0190_der
	(sleep 152)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0190_der dervish 1)
	)
	
(script dormant x04_0200_pot
	(sleep 237)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0200_pot truth 1)
	)
	
(script dormant x04_0210_pot
	(sleep 301)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0210_pot none 1)
	)
	
(script dormant x04_0220_pom
	(sleep 624)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0220_pom none 1)
	)
	
(script dormant x04_0230_der
	(sleep 851)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0230_der dervish 1)
	)
	
(script dormant x04_0240_pot
	(sleep 955)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0240_pot truth 1)
	)
	
(script dormant x04_06_dof_1
	(sleep 398)
	(cinematic_screen_effect_set_depth_of_field 2 .5 .5 1 0 0 1)
	(print "rack focus")
	(sleep 88)
	(cinematic_screen_effect_set_depth_of_field 2 0 0 .001 0 0 .001)
	(print "rack focus")
	(sleep 229)
	(cinematic_screen_effect_set_depth_of_field 2 0 0 .001 .5 .5 .001)
	(print "rack focus")
	)

(script static void x04_06_setup

;	(object_create_anew dervish)
;	(object_create_anew truth)
;	(object_create_anew mercy)
;	(object_create_anew_containing throne)

	(object_destroy_containing brute)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod truth true)
;	(object_cinematic_lod throne_truth true)
;	(object_cinematic_lod mercy true)
;	(object_cinematic_lod throne_mercy true)
	
	(wake x04_0160_der)
	(wake x04_0170_pot)
	(wake x04_0180_pot)
	(wake x04_0190_der)
	(wake x04_0200_pot)
	(wake x04_0210_pot)
	(wake x04_0220_pom)
	(wake x04_0230_der)
	(wake x04_0240_pot)
	
	(wake x04_06_dof_1)

	)
	
(script static void x04_06_cleanup
	
	(object_destroy dervish)
	(object_destroy truth)
	(object_destroy mercy)
	(object_destroy_containing throne)
	)

(script static void x04_scene_06
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_06" none "cinematic_anchor")
	
	(x04_06_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_06" false anchor)
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x04\x04 "throne_truth_06" false anchor)
	(custom_animation truth objects\characters\prophet\x04\x04 "truth_06" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x04\x04 "throne_mercy_06" false anchor)
	(custom_animation mercy objects\characters\prophet\x04\x04 "mercy_06" false)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_06" anchor)
	
	(sleep (unit_get_custom_animation_time dervish))
	
;	(x04_06_cleanup)
	)

; X04 SCENE 07 --------------------------------------------------------

(script dormant x04_score_2
	(sleep 693)
	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_2 none 1)
	)

(script dormant x04_0250_pot
	(sleep 172)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0250_pot truth 1)
	)
	
(script dormant x04_0260_hld
	(sleep 400)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0260_her heretic_leader_holo_01 1)
	)

(script dormant x04_0270_pot
	(sleep 719)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0270_pot truth 1)
	)

(script dormant x04_0280_pom
	(sleep 872)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0280_pom mercy 1)
	)
	
(script dormant x04_heretic_holo
	(sleep 192)
	(custom_animation_relative heretic_leader_holo_01 objects\characters\heretic\x04\x04 "heretic_07" false anchor)
	)

(script static void x04_07_setup

;	(object_create_anew dervish)
;	(object_create_anew truth)
;	(object_create_anew mercy)
;	(object_create_anew_containing throne)
	(object_create_anew heretic_leader_holo_01)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod truth true)
;	(object_cinematic_lod throne_truth true)
;	(object_cinematic_lod mercy true)
;	(object_cinematic_lod throne_mercy true)
	(object_cinematic_lod heretic_leader_holo_01 true)
	
;	(wake x04_score_2)
	(wake x04_0250_pot)
	(wake x04_0260_hld)
	(wake x04_0270_pot)
	(wake x04_0280_pom)
	(wake x04_heretic_holo)

	)
	
(script static void x04_07_cleanup
	
;	(object_destroy dervish)
;	(object_destroy truth)
;	(object_destroy mercy)
;	(object_destroy_containing throne)
	(object_destroy heretic_leader_holo_01)
	)

(script static void x04_scene_07
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_07" none "cinematic_anchor")
	
	(x04_07_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_07" false anchor)
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x04\x04 "throne_truth_07" false anchor)	
	(custom_animation truth objects\characters\prophet\x04\x04 "truth_07" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x04\x04 "throne_mercy_07" false anchor)	
	(custom_animation mercy objects\characters\prophet\x04\x04 "mercy_07" false)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_07" anchor)
	
	(sleep (unit_get_custom_animation_time dervish))
	
	(x04_07_cleanup)
	)

; X04 SCENE 08 --------------------------------------------------------

(script dormant x04_0290_der
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0290_der dervish 1)
	)
	
(script dormant x04_0300_pot
	(sleep 157)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0300_pot truth 1)
	)
	
(script dormant x04_0310_pot
	(sleep 312)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0310_pot truth 1)
	)
	
(script dormant x04_08_dof_1
	(cinematic_screen_effect_stop)
	)

(script static void x04_08_setup

;	(object_create_anew dervish)
;	(object_create_anew truth)
;	(object_create_anew mercy)
;	(object_create_anew_containing throne)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod truth true)
;	(object_cinematic_lod throne_truth true)
;	(object_cinematic_lod mercy true)
;	(object_cinematic_lod throne_mercy true)
	
	(wake x04_0290_der)
	(wake x04_0300_pot)
	(wake x04_0310_pot)

	(wake x04_08_dof_1)

	)
	
(script static void x04_08_cleanup
	
	(object_destroy dervish)
	(object_destroy truth)
	(object_destroy mercy)
	(object_destroy_containing throne)
	)

(script static void x04_scene_08
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_08" none "cinematic_anchor")
	
	(x04_08_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_08" false anchor)
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x04\x04 "throne_truth_08" false anchor)	
	(custom_animation truth objects\characters\prophet\x04\x04 "truth_08" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x04\x04 "throne_mercy_08" false anchor)	
	(custom_animation mercy objects\characters\prophet\x04\x04 "mercy_08" false)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_08" anchor)
	
	(sleep (unit_get_custom_animation_time dervish))
	
;	(x04_08_cleanup)
	)
	
; X04 SCENE 09 --------------------------------------------------------

(script dormant x04_0320_der
	(sleep 63)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0320_der dervish 1)
	)
	
(script dormant x04_0330_pom
	(sleep 100)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0330_pom mercy 1)
	)

(script static void x04_09_setup

;	(object_create_anew dervish)
;	(object_create_anew truth)
;	(object_create_anew mercy)
;	(object_create_anew_containing throne)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod truth true)
;	(object_cinematic_lod throne_truth true)
;	(object_cinematic_lod mercy true)
;	(object_cinematic_lod throne_mercy true)
	
	(wake x04_0320_der)
	(wake x04_0330_pom)
	
	)
	
(script static void x04_09_cleanup
	
	(object_destroy dervish)
	(object_destroy truth)
	(object_destroy mercy)
	(object_destroy_containing throne)
	)

(script static void x04_scene_09
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_09" none "cinematic_anchor")
	
	(x04_09_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_09" false anchor)
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x04\x04 "throne_truth_09" false anchor)	
	(custom_animation truth objects\characters\prophet\x04\x04 "truth_09" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x04\x04 "throne_mercy_09" false anchor)	
	(custom_animation mercy objects\characters\prophet\x04\x04 "mercy_09" false)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_09" anchor)
	
	(sleep (unit_get_custom_animation_time dervish))
	
;	(x04_09_cleanup)
	)
	
; X04 SCENE 10 --------------------------------------------------------

(script dormant x04_0370_der
	(sleep 566)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\x04_0340_der dervish 1)
	)

(script static void x04_10_setup

;	(object_create_anew dervish)
;	(object_create_anew truth)
;	(object_create_anew mercy)
;	(object_create_anew_containing throne)
	
;	(object_cinematic_lod dervish true)
;	(object_cinematic_lod truth true)
;	(object_cinematic_lod throne_truth true)
;	(object_cinematic_lod mercy true)
;	(object_cinematic_lod throne_mercy true)
	
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
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\x04\x04 "x04_10" none "cinematic_anchor")
	
	(x04_10_setup)
	
	(pvs_set_object dervish)
	
	(custom_animation_relative dervish objects\characters\dervish\x04\x04 "dervish_10" false anchor)
	(custom_animation_relative throne_truth objects\vehicles\gravity_throne\animations\x04\x04 "throne_truth_10" false anchor)	
	(custom_animation truth objects\characters\prophet\x04\x04 "truth_10" false)
	(custom_animation_relative throne_mercy objects\vehicles\gravity_throne\animations\x04\x04 "throne_mercy_10" false anchor)	
	(custom_animation mercy objects\characters\prophet\x04\x04 "mercy_10" false)
	
	(scenery_animation_start_relative sarcophagus scenarios\objects\solo\alphagasgiant\sarcophagus\sarcophagus "x04_10" anchor)
	
	(sleep (- (unit_get_custom_animation_time dervish) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(x04_10_cleanup)
	)

; X04 MASTER SCRIPT ---------------------------------------------------

(script static void x04
	
	(switch_bsp 1)
	
	(x04_scene_01)
	(x04_scene_02a)
	(x04_scene_02b)
;	(x04_scene_03a)
	(x04_scene_03b)
	(x04_scene_04)
	(x04_scene_05)
	(x04_scene_06)
	(x04_scene_07)
	(x04_scene_08)
	(x04_scene_09)
	(x04_scene_10)
	
;	(fade_out 0 0 0 0)
	
;	(cinematic_stop)
;	(camera_control off)
	)

; ------------------------------------------------------------------------------------------------------------------------------------
; C04_INTRO SCENE 01 --------------------------------------------------

;(script dormant x04_score_1
;	(sleep 0)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

(script dormant c04_1010_soc
	(sleep 95)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1010_soc none 1)
	)
	
(script dormant c04_1020_sec
	(sleep 167)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1020_sec none 1)
	)
	
(script dormant c04_1030_soc
	(sleep 279)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1030_soc none 1)
	)

(script static void c04_intro_01_setup

	(object_create_anew phantom01)
	(object_create_anew phantom02)
	(object_create_anew phantom03)
	
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	(object_cinematic_lod phantom03 true)
	
;	(wake x04_score_1)
	(wake c04_1010_soc)
	(wake c04_1020_sec)
	(wake c04_1030_soc)
	
	)
	
(script static void c04_intro_01_cleanup
	
	(object_destroy phantom01)
	(object_destroy phantom02)
	(object_destroy phantom03)
	
	)

(script static void c04_intro_01
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_01" none "cinematic_anchor03")
	
	(c04_intro_01_setup)
	
	(pvs_set_object phantom01)
	
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_01" false anchor03)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_01" false anchor03)
	(custom_animation_relative phantom03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_01" false anchor03)
	
	(fade_in 0 0 0 5)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_01_cleanup)
	)

; C04_INTRO SCENE 02a -------------------------------------------------
	
(script dormant c04_1040_sec
	(sleep 169)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1040_sec none 1)
	)
	
(script dormant c04_1050_soc
	(sleep 239)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1050_soc commander 1)
	)
	
(script dormant c04_1060_soc
	(sleep 400)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1060_soc commander 1)
	)
	
(script dormant c04_1070_sog
	(sleep 552)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1070_sog none 1)
	(print "which grunt is this?")
	)

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
	(object_create_anew phantom01)
	
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
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	
	(wake c04_1040_sec)
	(wake c04_1050_soc)
	(wake c04_1060_soc)
	(wake c04_1070_sog)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	)
	
(script static void c04_intro_02a_cleanup
	
;	(object_destroy dervish02)
;	(object_destroy commander)
;	(object_destroy elite01)
;	(object_destroy elite02)
	(object_destroy elite03)
;	(object_destroy elite04)
;	(object_destroy elite05)
	(object_destroy elite06)
	(object_destroy elite07)
;	(object_destroy grunt01)
;	(object_destroy grunt02)
;	(object_destroy grunt03)
;	(object_destroy grunt04)
;	(object_destroy phantom01)
	
	)

(script static void c04_intro_02a

;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_02a" none "cinematic_anchor03")
	
	(c04_intro_02a_setup)
	
	(pvs_set_object dervish02)
	
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
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_2a" false anchor03)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_02a_cleanup)
	)

; C04_INTRO SCENE 02b -------------------------------------------------

(script dormant c04_1080_sec
	(sleep 5)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1080_sec none 1)
	)
	
(script dormant c04_1090_soc
	(sleep 83)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1090_soc commander 1)
	)

(script static void c04_intro_02b_setup

	(object_create_anew dervish02)
	(object_create_anew commander)
	(object_create_anew elite01)
	(object_create_anew elite02)
	(object_create_anew elite04)
	(object_create_anew elite05)
	(object_create_anew grunt01)
	(object_create_anew grunt02)
	(object_create_anew grunt03)
	(object_create_anew grunt04)
	(object_create_anew phantom01)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod elite02 true)
	(object_cinematic_lod elite04 true)
	(object_cinematic_lod elite05 true)
	(object_cinematic_lod grunt01 true)
	(object_cinematic_lod grunt02 true)
	(object_cinematic_lod grunt03 true)
	(object_cinematic_lod grunt04 true)
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	
	(wake c04_1080_sec)
	(wake c04_1090_soc)
	
	)
	
(script static void c04_intro_02b_cleanup
	
	(object_destroy dervish02)
	(object_destroy commander)
	(object_destroy elite01)
	(object_destroy elite02)
	(object_destroy elite04)
	(object_destroy elite05)
	(object_destroy grunt01)
	(object_destroy grunt02)
	(object_destroy grunt03)
	(object_destroy grunt04)
	(object_destroy phantom01)
	
	)

(script static void c04_intro_02b
	
;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_02b" none "cinematic_anchor03")
	
	(c04_intro_02b_setup)
	
	(pvs_set_object dervish02)
	
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
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_2b" false anchor03)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_02b_cleanup)
	)
	
; C04_INTRO SCENE 02c -------------------------------------------------

(script static void c04_intro_02c_setup

	(object_create_anew phantom01)
	(object_create_anew phantom02)
	(object_create_anew phantom03)
	
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	(object_cinematic_lod phantom03 true)
	
	(player_effect_stop 0)
	
	)
	
(script static void c04_intro_02c_cleanup
	
	(object_destroy phantom01)
	(object_destroy phantom02)
	(object_destroy phantom03)
	
	)

(script static void c04_intro_02c

;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_02c" none "cinematic_anchor03")
	
	(c04_intro_02c_setup)
	
	(pvs_set_object phantom01)
	
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_02c" false anchor03)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_02c" false anchor03)
	(custom_animation_relative phantom03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_02c" false anchor03)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_02c_cleanup)
	)

; C04_INTRO SCENE 02d -------------------------------------------------

(script dormant c04_1100_soc
	(sleep 29)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1100_soc commander 1)
	)

(script dormant c04_1110_soc
	(sleep 76)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1110_soc commander 1)
	)

(script dormant c04_1120_der
	(sleep 127)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1120_der dervish02 1)
	)
	
(script dormant c04_1130_soc
	(sleep 174)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1130_soc commander 1)
	)
	
(script dormant c04_1140_der
	(sleep 430)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1140_der dervish02 1)
	)

(script dormant c04_1150_soc
	(sleep 494)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1150_soc commander 1)
	)

(script static void c04_intro_02d_setup

	(object_create_anew dervish02)
	(object_create_anew commander)
	(object_create_anew phantom01)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod phantom01 true)
	
	(wake c04_1100_soc)
	(wake c04_1110_soc)
	(wake c04_1120_der)
	(wake c04_1130_soc)
	(wake c04_1140_der)
	(wake c04_1150_soc)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)

	)
	
(script static void c04_intro_02d_cleanup
	
	(object_destroy dervish02)
	(object_destroy commander)
	(object_destroy phantom01)
	
	)

(script static void c04_intro_02d
	
;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_02d" none "cinematic_anchor03")
	
	(c04_intro_02d_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intro\04_intro "dervish_02d" false anchor03)
	(custom_animation_relative commander objects\characters\elite\04_intro\04_intro "commander_02d" false anchor03)
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_2d" false anchor03)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_02d_cleanup)
	)

; C04_INTRO SCENE 03 --------------------------------------------------

(script static void c04_intro_03_setup

	(object_create_anew phantom01)
	(object_create_anew phantom02)
	(object_create_anew phantom03)
	
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	(object_cinematic_lod phantom03 true)
	
	(player_effect_stop 0)

	)
	
(script static void c04_intro_03_cleanup
	
	(object_destroy phantom01)
	(object_destroy phantom02)
	(object_destroy phantom03)
	
	)

(script static void c04_intro_03

;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_03" none "cinematic_anchor03")
	
	(c04_intro_03_setup)
	
	(pvs_set_object phantom01)
	
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_3" false anchor03)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_3" false anchor03)
	(custom_animation_relative phantom03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_3" false anchor03)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_03_cleanup)
	)
	
; C04_INTRO SCENE 04 --------------------------------------------------

(script dormant c04_1160_ecp
	(sleep 76)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1160_ecp none 1)
	(print "which elite is this?")
	)

(script dormant c04_1170_elp
	(sleep 133)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1170_elp none 1)
	(print "which elite is this?")
	)

(script dormant c04_1180_ecp
	(sleep 161)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1180_elp none 1)
	(print "which elite is this?")
	)
	
(script dormant c04_1190_soc
	(sleep 255)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1190_soc commander 1)
	)

(script static void c04_intro_04_setup

	(object_create_anew dervish02)
	(object_create_anew commander)
	(object_create_anew elite01)
	(object_create_anew elite02)
	(object_create_anew elite05)
	(object_create_anew elite06)
	(object_create_anew elite07)
	(object_create_anew grunt01)
	(object_create_anew phantom01)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod elite02 true)
	(object_cinematic_lod elite05 true)
	(object_cinematic_lod elite06 true)
	(object_cinematic_lod elite07 true)
	(object_cinematic_lod grunt01 true)
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	
	(wake c04_1160_ecp)
	(wake c04_1170_elp)
	(wake c04_1180_ecp)
	(wake c04_1190_soc)
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 0)
	
	)
	
(script static void c04_intro_04_cleanup
	
	(object_destroy dervish02)
	(object_destroy commander)
	(object_destroy elite01)
	(object_destroy elite02)
	(object_destroy elite05)
	(object_destroy elite06)
	(object_destroy elite07)
	(object_destroy grunt01)
	(object_destroy phantom01)
	
	)

(script static void c04_intro_04
	
;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_04" none "cinematic_anchor03")
	
	(c04_intro_04_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intro\04_intro "dervish_04" false anchor03)
	(custom_animation_relative commander objects\characters\elite\04_intro\04_intro "commander_04" false anchor03)
	(custom_animation_relative elite01 objects\characters\elite\04_intro\04_intro "elite01_04" false anchor03)
	(custom_animation_relative elite02 objects\characters\elite\04_intro\04_intro "elite02_04" false anchor03)
	(custom_animation_relative elite05 objects\characters\elite\04_intro\04_intro "elite05_04" false anchor03)
	(custom_animation_relative elite06 objects\characters\elite\04_intro\04_intro "elite06_04" false anchor03)
	(custom_animation_relative elite07 objects\characters\elite\04_intro\04_intro "elite07_04" false anchor03)
	(custom_animation_relative grunt01 objects\characters\grunt\04_intro\04_intro "grunt01_04" false anchor03)
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_4" false anchor03)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_04_cleanup)
	)


; C04_INTRO SCENE 05 --------------------------------------------------

;(script dormant x04_score_1
;	(sleep 0)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

;(script dormant x04_0010_bgr
;	(sleep 570)
;	(sound_impulse_start sound\dialog\alphagasmine\cinematic\x04_0010_bgr brute_01 1)
;	)

(script dormant c04_intro_05_shake_1
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .15 0)
	(sleep 401)
	(player_effect_stop 0)
	)

(script static void c04_intro_05_setup

	(object_create_anew elite01)
	(object_create_anew phantom01)
	(object_create_anew phantom02)
	(object_create_anew phantom03)
	
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	(object_cinematic_lod phantom03 true)
	
;	(wake x04_score_1)
;	(wake x04_0010_bgr)

	(wake c04_intro_05_shake_1)
	
	)
	
(script static void c04_intro_05_cleanup
	
	(object_destroy elite01)
	(object_destroy phantom01)
	(object_destroy phantom02)
	(object_destroy phantom03)
	
	)

(script static void c04_intro_05
	
;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_05" none "cinematic_anchor02")
	
	(c04_intro_05_setup)
	
	(pvs_set_object phantom01)
	
	(custom_animation_relative elite01 objects\characters\elite\04_intro\04_intro "elite01_05" false anchor02)
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_05" false anchor02)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_05" false anchor02)
	(custom_animation_relative phantom03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_05" false anchor02)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_05_cleanup)
	)

; C04_INTRO SCENE 06a -------------------------------------------------

;(script dormant x04_score_1
;	(sleep 0)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

;(script dormant x04_0010_bgr
;	(sleep 570)
;	(sound_impulse_start sound\dialog\alphagasmine\cinematic\x04_0010_bgr brute_01 1)
;	)

(script static void c04_intro_06a_setup

	(object_create_anew elite01)
	(object_create_anew phantom01)
	(object_create_anew phantom02)
	(object_create_anew phantom03)
	
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	(object_cinematic_lod phantom03 true)
	
;	(wake x04_score_1)
;	(wake x04_0010_bgr)

	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .15 0)
	
	)
	
(script static void c04_intro_06a_cleanup
	
	(object_destroy elite01)
	(object_destroy phantom01)
	(object_destroy phantom02)
	(object_destroy phantom03)
	
	)

(script static void c04_intro_06a
	
;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_06a" none "cinematic_anchor02")
	
	(c04_intro_06a_setup)
	
	(pvs_set_object phantom01)
	
	(custom_animation_relative elite01 objects\characters\elite\04_intro\04_intro "elite01_06a" false anchor02)
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_06a" false anchor02)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_06a" false anchor02)
	(custom_animation_relative phantom03 objects\vehicles\phantom\animations\04_intro\04_intro "phantom03_06a" false anchor02)
	
	(sleep (unit_get_custom_animation_time phantom01))
	
	(c04_intro_06a_cleanup)
	)
	
; C04_INTRO SCENE 06b -------------------------------------------------

;(script dormant x04_score_1
;	(sleep 0)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

(script dormant c04_1200_soc
	(sleep 328)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_1200_soc none 1)
	)
	
(script dormant c04_06b_shake_1
	(player_effect_stop 0)
	(sleep 30)
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start .25 2)
	(sleep 60)
	(player_effect_stop 2)
	)

(script static void c04_intro_06b_setup

	(object_create_anew dervish02)
	(object_create_anew commander)
	(object_create_anew elite01)
	(object_create_anew elite02)
	(object_create_anew elite03)
	(object_create_anew elite04)
	(object_create_anew grunt01)
	(object_create_anew phantom01)
	(object_create_anew phantom02)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod elite02 true)
	(object_cinematic_lod elite03 true)
	(object_cinematic_lod elite04 true)
	(object_cinematic_lod grunt01 true)
	(object_cinematic_lod phantom01 true)
	(object_cinematic_lod phantom02 true)
	(object_cinematic_lod phantom03 true)
	
;	(wake x04_score_1)
	(wake c04_1200_soc)
	
	(wake c04_06b_shake_1)
	
	)
	
(script static void c04_intro_06b_cleanup
	
	(object_destroy dervish02)
	(object_destroy commander)
	(object_destroy elite01)
	(object_destroy elite02)
	(object_destroy elite03)
	(object_destroy elite04)
	(object_destroy grunt01)
	(object_destroy phantom01)
	(object_destroy phantom02)
	(object_destroy phantom03)
	
	)

(script static void c04_intro_06b
	
;	(camera_control on)
;	(cinematic_start)
;	(set cinematic_letterbox_style 1)
;	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_06b" none "cinematic_anchor02")
	
	(c04_intro_06b_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intro\04_intro "dervish_06b" false anchor02)
	(custom_animation_relative commander objects\characters\elite\04_intro\04_intro "commander_06b" false anchor02)
	(custom_animation_relative elite01 objects\characters\elite\04_intro\04_intro "elite01_06b" false anchor02)
	(custom_animation_relative elite02 objects\characters\elite\04_intro\04_intro "elite02_06b" false anchor02)
	(custom_animation_relative elite03 objects\characters\elite\04_intro\04_intro "elite03_06b" false anchor02)
	(custom_animation_relative elite04 objects\characters\elite\04_intro\04_intro "elite04_06b" false anchor02)
	(custom_animation_relative grunt01 objects\characters\grunt\04_intro\04_intro "grunt01_06b" false anchor02)
	(custom_animation_relative phantom01 objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_06b" false anchor02)
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_intro\04_intro "phantom02_06b" false anchor02)
	
	(sleep (- (unit_get_custom_animation_time phantom01) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c04_intro_06b_cleanup)
	)

; C04_INTRO MASTER SCRIPT ---------------------------------------------------

(script static void c04_intro

	(sound_class_set_gain vehicle 0 0)
	
	(switch_bsp 2)
	
	(c04_intro_01)
	(c04_intro_02a)
	(c04_intro_02b)
	(c04_intro_02c)
	(c04_intro_02d)
	(c04_intro_03)
	(c04_intro_04)
	
	(switch_bsp 0)
	
	(c04_intro_05)
	(c04_intro_06a)
	(c04_intro_06b)
	
	(cinematic_stop)
	(camera_control off)
	
	(sound_class_set_gain vehicle 1 1)
	
	)

; ---------------------------------------------------------------------
; C04_INTRA1 SCENE 01 -------------------------------------------------

;(script dormant c04_score_1
;	(sleep 143)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

(script dormant c04_2010_her
	(sleep 45)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2010_her heretic_leader 1)
	)
	
(script dormant c04_2020_her
	(sleep 121)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2020_her heretic_leader 1)
	)
	
(script dormant c04_2030_soc
	(sleep 249)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2030_soc none 1)
	)

(script static void c04_intra1_01_setup

	(device_set_position control_shield_door 1)
	(object_create_anew dervish02)
	(object_create_anew heretic_leader)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod heretic_leader true)
	
	(wake c04_2010_her)
	(wake c04_2020_her)
	(wake c04_2030_soc)
	
	(sound_class_set_gain amb .25 2)
	
	 )
	
(script static void c04_intra1_01_cleanup
	
	(object_destroy dervish02)
	(object_destroy heretic_leader)
	
	)

(script static void c04_intra1_01
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intra1\04_intra1 "04_intra1_01" none "cinematic_anchor02")
	
	(c04_intra1_01_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intra1\04_intra1 "dervish_01" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_intra1\04_intra1 "heretic_01" false anchor02)
	
	(fade_in 1 1 1 15)
	
	(sleep 165)
	(device_set_position control_shield_door 0)
	
	(sleep (unit_get_custom_animation_time dervish02))
	
;	(c04_intra1_01_cleanup)
	)
	
; C04_INTRA1 SCENE 02 -------------------------------------------------

;(script dormant c04_score_1
;	(sleep 143)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

(script dormant c04_2031_soc
	(sleep 0)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2031_soc commander 1)
	)
	
(script dormant c04_2040_soc
	(sleep 96)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2040_soc commander 1)
	)
		
(script dormant c04_2050_soc
	(sleep 178)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2050_soc commander 1)
	)
	
(script dormant c04_2060_der
	(sleep 229)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2060_der dervish02 1)
	)
	
(script dormant c04_2070_soc
	(sleep 292)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2070_soc commander 1)
	)

(script dormant c04_2080_der
	(sleep 335)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2080_der dervish02 1)
	)
	
(script dormant c04_2090_der
	(sleep 482)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_2090_der dervish02 1)
	)
		
(script static void c04_intra1_02_setup

	(object_create_anew dervish02)
	(object_create_anew commander)
	(object_create_anew elite01)
	(object_create_anew elite02)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod commander true)
	(object_cinematic_lod elite01 true)
	(object_cinematic_lod elite02 true)
	
	(wake c04_2031_soc)
	(wake c04_2040_soc)       
	(wake c04_2050_soc)       
	(wake c04_2060_der)       
	(wake c04_2070_soc)       
	(wake c04_2080_der)      
	(wake c04_2090_der)
	
	)
	
(script static void c04_intra1_02_cleanup
	
	(object_destroy dervish02)
	(object_destroy commander)
	(object_destroy elite01)
	(object_destroy elite02)
	
	(sound_class_set_gain amb 1 2)
	(sound_class_set_gain amb 1 2)
	
	)

(script static void c04_intra1_02
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_intra1\04_intra1 "04_intra1_02" none "cinematic_anchor02")
	
	(c04_intra1_02_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_intra1\04_intra1 "dervish_02" false anchor02)
	(custom_animation_relative commander objects\characters\elite\04_intra1\04_intra1 "soc_02" false anchor02)
	(custom_animation_relative elite01 objects\characters\elite\04_intra1\04_intra1 "elite01_02" false anchor02)
	(custom_animation_relative elite02 objects\characters\elite\04_intra1\04_intra1 "elite02_02" false anchor02)
	
	(sleep (- (unit_get_custom_animation_time dervish02) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c04_intra1_02_cleanup)
	)
	
; C04_INTRA1 MASTER SCRIPT ---------------------------------------------------

(script static void c04_intra1
	
	(c04_intra1_01)
	(c04_intra1_02)
	
	(cinematic_stop)
	(camera_control off)
	)

; ---------------------------------------------------------------------
; C04_OUTRO1 SCENE 01 ------------------------------------------------

;(script dormant c04_score_1
;	(sleep 143)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

(script dormant c04_outro_1_foley
	(sleep 446)
	(sound_impulse_start sound\music\joe's_temp_music\c04_outro_1_foley none 1)
	)

(script dormant c04_3010_der
	(sleep 118)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3010_der dervish02 1)
	)

(script dormant c04_3020_her
	(sleep 197)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3020_her heretic_leader 1)
	)
	
(script dormant c04_3030_her
	(sleep 243)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3030_her heretic_leader 1)
	)

(script dormant c04_3040_der
	(sleep 385)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3040_der dervish02 1)
	)

(script static void c04_outro1_01_setup

	(object_destroy seraph)
;	(object_destroy seraph_bsp0)

	(object_create_anew dervish02)
	(object_create_anew heretic_leader)
	
	(object_create outro_seraph)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod heretic_leader true)
	
	(wake c04_outro_1_foley)
	
	(wake c04_3010_der)        
	(wake c04_3020_her)        
	(wake c04_3030_her)        
	(wake c04_3040_der)
	
	(sound_class_set_gain amb .25 2) 
	      
	)
	
(script static void c04_outro1_01_cleanup
	
	(object_destroy dervish02)
	(object_destroy heretic_leader)
	
	)

(script static void c04_outro1_01
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro1\04_outro1 "04_outro1_01" none "cinematic_anchor02")
	
	(c04_outro1_01_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_outro1\04_outro1 "dervish_01" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro1\04_outro1 "heretic_01" false anchor02)
	
	(scenery_animation_start_relative outro_seraph scenarios\objects\vehicles\c_seraph\c_seraph "04_outro1_01" anchor02)
	
	(fade_in 1 1 1 15)
		
	(sleep (unit_get_custom_animation_time dervish02))
	
;	(c04_outro1_01_cleanup)
	)

; C04_OUTRO1 SCENE 02 ------------------------------------------------

;(script dormant c04_score_1
;	(sleep 0)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

(script dormant c04_3050_der
	(sleep 132)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3050_der dervish02 1)
	)

(script dormant c04_3060_gsp
	(sleep 190)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3060_gsp monitor 1)
	)
	
(script dormant c04_3070_her
	(sleep 363)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3070_her heretic_leader 1)
	)

(script dormant c04_3080_gsp
	(sleep 516)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3080_gsp monitor 1)
	)

(script static void c04_outro1_02_setup

	(object_create_anew dervish02)
	(object_create_anew heretic_leader)
	(object_create_anew monitor)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod heretic_leader true)
	(object_cinematic_lod monitor true)
	
	(wake c04_3050_der)
	(wake c04_3060_gsp)
	(wake c04_3070_her)
	(wake c04_3080_gsp)
	
	)
	
(script static void c04_outro1_02_cleanup
	
;	(object_destroy dervish02)
;	(object_destroy heretic_leader)
	(object_destroy monitor)
	
	)

(script static void c04_outro1_02
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro1\04_outro1 "04_outro1_02" none "cinematic_anchor02")
	
	(c04_outro1_02_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_outro1\04_outro1 "dervish_02" false anchor02)
	(custom_animation_relative monitor objects\characters\monitor\04_outro1\04_outro1 "monitor_02" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro1\04_outro1 "heretic_02" false anchor02)
	
	(scenery_animation_start_relative outro_seraph scenarios\objects\vehicles\c_seraph\c_seraph "04_outro1_02" anchor02)
	
	(sleep (unit_get_custom_animation_time dervish02))
	
	(c04_outro1_02_cleanup)
	)
	
; C04_OUTRO1 SCENE 03 -------------------------------------------------

(script dormant c04_3090_her
	(sleep 29)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3090_her none 1)
	)
	
(script dormant c04_3100_her
	(sleep 108)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_3100_her heretic_leader 1)
	)

(script static void c04_outro1_03_setup

	(object_create_anew dervish02)
	(object_create_anew heretic_leader)
	(object_create_anew monitor)
	
	(object_create_anew holo_drone_1)
	(object_create_anew holo_drone_2)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod heretic_leader true)
	(object_cinematic_lod monitor true)
	
	(wake c04_3090_her)
	(wake c04_3100_her)
	
	)
	
(script static void c04_outro1_03_cleanup
	
	(object_destroy dervish02)
	(object_destroy heretic_leader)
	(object_destroy monitor)
	(object_destroy hologram01)
	(object_destroy hologram02)
	(object_destroy holo_drone_1)
	(object_destroy holo_drone_2)
	
	(sound_class_set_gain amb 1 2)
	
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
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro1\04_outro1 "04_outro1_03" none "cinematic_anchor02")
	
	(c04_outro1_03_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_outro1\04_outro1 "dervish_03" false anchor02)
;	(custom_animation_relative monitor objects\characters\monitor\04_outro1\04_outro1 "monitor_03" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro1\04_outro1 "heretic_03" false anchor02)
	
	(scenery_animation_start_relative outro_seraph scenarios\objects\vehicles\c_seraph\c_seraph "04_outro1_03" anchor02)
	(scenery_animation_start_relative holo_drone_1 scenarios\objects\solo\alphagasgiant\holo_drone\holo_drone "outro1_01" anchor02)
	(scenery_animation_start_relative holo_drone_2 scenarios\objects\solo\alphagasgiant\holo_drone\holo_drone "outro1_02" anchor02)
	
	(wake c04_outro1_03_holo1)
	(wake c04_outro1_03_holo2)
	
	(sleep (- (unit_get_custom_animation_time dervish02) 15))
	
	(fade_out 1 1 1 15)
	(sleep 15)
	
	(c04_outro1_03_cleanup)
	)

; C04_OUTRO1 MASTER SCRIPT --------------------------------------------

(script static void c04_outro1

	(sound_class_set_gain vehicle 0 0)
	
;	(switch_bsp 3)
	
	(c04_outro1_01)
	(c04_outro1_02)
	(c04_outro1_03)
	
	(cinematic_stop)
	(camera_control off)
	)

; ---------------------------------------------------------------------
; C04_OUTRO2 SCENE 01 -------------------------------------------------

;(script dormant c04_score_1
;	(sleep 0)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)

(script dormant c04_9110_gsp
	(sleep 32)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9110_gsp monitor 1)
	)
	
(script dormant c04_9120_der
	(sleep 133)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9120_der dervish02 1)
	)

(script dormant c04_9130_gsp
	(sleep 274)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9130_gsp monitor 1)
	)
	
(script dormant c04_9140_gsp
	(sleep 456)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9140_gsp monitor 1)
	)

(script static void c04_outro2_01_setup

	(object_create_anew dervish02)
	(object_create_anew heretic_leader)
	(object_create_anew monitor)
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod heretic_leader true)
	(object_cinematic_lod monitor true)
	
	(wake c04_9110_gsp)
	(wake c04_9120_der)
	(wake c04_9130_gsp)
	(wake c04_9140_gsp)
	
	(sound_class_set_gain amb .25 2)
	
	)
	
(script static void c04_outro2_01_cleanup
	
	(object_destroy phantom01)
	(object_destroy phantom02)
	(object_destroy phantom03)
	
	)

(script static void c04_outro2_01
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro2\04_outro2 "04_outro2_01" none "cinematic_anchor02")
	
	(c04_outro2_01_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_outro2\04_outro2 "dervish_01" false anchor02)
	(custom_animation_relative monitor objects\characters\monitor\04_outro2\04_outro2 "monitor_01" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro2\04_outro2 "heretic_01" false anchor02)
	
	(fade_in 1 1 1 15)
	
	(sleep (unit_get_custom_animation_time dervish02))
	
	(c04_outro2_01_cleanup)
	)

; C04_OUTRO2 SCENE 02 ------------------------------------------------

;(script dormant c04_score_1
;	(sleep 0)
;	(sound_impulse_start sound\music\joe's_temp_music\x04_temp_score_1 none 1)
;	)
	
(script dormant c04_9150_der
	(sleep 121)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9150_der dervish02 1)
	)
	
(script dormant c04_9160_tar
	(sleep 206)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9160_tar tartarus 1)
	)
	
(script dormant c04_9170_tar
	(sleep 264)
	(sound_impulse_start sound\dialog\levels\04_gasgiant\cinematic\c04_9170_tar tartarus 1)
	)

(script static void c04_outro2_02_setup

	(object_create_anew dervish02)
	(object_create_anew heretic_leader)
	(object_create_anew monitor)
	(object_create_anew tartarus)
	(object_create_anew brute_02)
	(object_create_anew phantom02)
	
	
	(object_cinematic_lod dervish02 true)
	(object_cinematic_lod heretic_leader true)
	(object_cinematic_lod monitor true)
	(object_cinematic_lod tartarus true)
	(object_cinematic_lod brute_02 true)
	(object_cinematic_lod phantom02 true)
	
	(wake c04_9150_der)
	(wake c04_9160_tar)
	(wake c04_9170_tar)
	
	)
	
(script static void c04_outro2_02_cleanup
	
	(object_destroy dervish02)
	(object_destroy heretic_leader)
	(object_destroy monitor)
	(object_destroy tartarus)
	(object_destroy brute_02)
	(object_destroy phantom02)
	
	(sound_class_set_gain amb 1 2)
	
	)

(script static void c04_outro2_02
	
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\04_outro2\04_outro2 "04_outro2_02" none "cinematic_anchor02")
	
	(c04_outro2_02_setup)
	
	(pvs_set_object dervish02)
	
	(custom_animation_relative dervish02 objects\characters\dervish\04_outro2\04_outro2 "dervish_02" false anchor02)
	(custom_animation_relative monitor objects\characters\monitor\04_outro2\04_outro2 "monitor_02" false anchor02)
	(custom_animation_relative heretic_leader objects\characters\heretic\04_outro2\04_outro2 "heretic_02" false anchor02)
	(custom_animation_relative tartarus objects\characters\brute\04_outro2\04_outro2 "tartarus_02" false anchor02)
	(custom_animation_relative brute_02 objects\characters\brute\04_outro2\04_outro2 "brute_02" false anchor02)
	
	(custom_animation_relative phantom02 objects\vehicles\phantom\animations\04_outro2\04_outro2 "phantom_02" false anchor02)
	
	(sleep (- (unit_get_custom_animation_time dervish02) 5))
	
	(fade_out 0 0 0 5)
	(sleep 5)
	
	(c04_outro2_02_cleanup)
	)

; C04_OUTRO2 MASTER SCRIPT ---------------------------------------------------

(script static void c04_outro2

	(sound_class_set_gain vehicle 0 0)
	
	(c04_outro2_01)
	(c04_outro2_02)
	
	(cinematic_stop)
	(camera_control off)
	)

;(script static void test
;	(camera_set_animation_relative objects\characters\cinematic_camera\04_intro\04_intro "04intro_01" none cinematic_anchor)
;	(custom_animation_relative test_phantom objects\vehicles\phantom\animations\04_intro\04_intro "phantom01_06a" false anchor)
;)