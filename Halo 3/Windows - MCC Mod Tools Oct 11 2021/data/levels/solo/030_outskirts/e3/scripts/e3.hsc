;;	E3 BRANCH

(global real e3_gamma 1.95)
(global real e3_exposure 0)

(script static void scene00

	(object_create_anew rocks)

;	(sound_looping_predict sound\e3_2006\e3_2006_1\e3_2006_1)
;	(print "SOUND: predict e32006_01")
	(sound_looping_predict sound\e3_2006\e3_2006_music\e3_2006_music)
;	(print "SOUND: predict e3_2006_music")
	
	(cinematic_start)
	(cinematic_skip_stop_internal)
	(set cinematic_letterbox_style 2)
	(fade_out 0 0 0 0)
	(camera_control on)

	(object_teleport (list_get (players) 0) "teleport_flag")
	(camera_set_field_of_view 110 0)
	
	(time_code_reset)
;	(time_code_show 1)
;	(time_code_start 1)
	
	(object_create_containing atmosphere)

	(sleep 15)
	(render_exposure (+ e3_exposure 6) 0)
	(sleep 120)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is where the script actually starts (goes to white)
; Remember when adjusting script to final version to build in the 
; above timing for creating Steve's atmosphere effects and Marty's music
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		
;	(sound_looping_start sound\e3_2006\e3_2006_1\e3_2006_1 none 1)
;	(print "SOUND: e32006_01")
	(sound_looping_start sound\e3_2006\e3_2006_music\e3_2006_music none 1)
;	(print "SOUND: e3_2006_music")

	(sleep 12)		;subtract 2
	(fade_in 1 1 1 300)

	(predict_bink_movie cortana_01)
	(render_exposure (+ e3_exposure 2) 10)
		
	(object_create_anew chief)
	(object_create_anew chiefs_gun)
	(objects_attach chief "right hand" chiefs_gun "")
	(object_cinematic_visibility chief 1)
	(object_set_permutation chief "visor" base)
		
	(texture_camera_off)

	(camera_set_animation_relative objects\characters\cinematic_camera\e3_2006\e3_2006 "start_camera00" none "e3_cutscene_anchor")
	(camera_set_field_of_view 90 1355)

	(render_depth_of_field 10 50000 20 0)
	(set render_dof_blur 5)
	
	(cinematic_lighting_initialize)
	(cinematic_light_object ark ark 0 .5)
	(cinematic_light_object storm storm 0 1)

	(sleep 248)	;add 2
	(render_exposure (+ e3_exposure .7) 10)
	(camera_set_animation_relative objects\characters\cinematic_camera\e3_2006\e3_2006 "camera00" none "e3_cutscene_anchor")
	(custom_animation_relative chief objects\characters\masterchief\masterchief_e3\masterchief_e3 "chief0" false anchor)

	(sleep 300)
	(render_exposure (+ e3_exposure 0) 10)
	(scenery_animation_start sign levels\solo\030_outskirts\e3\objects\sign_flood\sign_flood "wobble")
;	(print "wobble")
	(sleep 150)
	(scenery_animation_start sign levels\solo\030_outskirts\e3\objects\sign_flood\sign_flood "idle")
	(sleep 93)  ;add 43

;	(print "BINK: Cortana 1")
	(play_bink_movie cortana_01)
	(predict_bink_movie cortana_02)
;	(sound_looping_predict sound\e3_2006\e3_2006_2\e3_2006_2)
;	(print "SOUND: predict e32006_02")
	(sleep 43)	;delete
	(render_exposure (- e3_exposure 1) 6)

	(sleep 200)

;	(render_depth_of_field 0 .5 3 0)
;	(print "NOW!")	

	(sleep 444)	;subtract 5
;	(print "BINK: Cortana 2")
	(play_bink_movie cortana_02)
	(predict_bink_movie cortana_03)

	(sleep 158)	;add 5
	(render_depth_of_field 0 1.5 1 0)
	(render_exposure (- e3_exposure .7) 4)

	(object_create_anew hero_cruiser)
	(scenery_animation_start_relative hero_cruiser objects\vehicles\capital_ship\capital_ship "idle" anchor)
	(object_create_anew light_chief)
	(object_create_anew light_chief_fill)
	(sleep 30)
	(object_set_permutation chief "visor" cinematic)
	(texture_camera_set_object_marker chief reflector 110)
;	(print "visor!")
	(sleep 30)
	(render_exposure (- e3_exposure .5) 3.8)
	
	(sleep 155)	;add 35
;	(sound_looping_start sound\e3_2006\e3_2006_2\e3_2006_2 none 1)
;	(print "SOUND: e32006_02")
;	(print "BINK: Cortana 3")
	(play_bink_movie cortana_03)
	(predict_bink_movie logo_sequence)
	(sleep 83)	;subtract 35

	)

(script static void scene01
	(object_create_anew light_chief)
	(object_create_anew light_chief_fill)
	
	(camera_set_field_of_view 68 0)
	
	(wake lightning)
			
	(camera_set_animation_relative objects\characters\cinematic_camera\e3_2006\e3_2006 "camera01" none "e3_cutscene_anchor")
	(custom_animation_relative chief objects\characters\masterchief\masterchief_e3\masterchief_e3 "chief1" false anchor)

	(object_create_anew_containing prop_blast)
	
	(object_set_permutation chief "visor" cinematic)
	(texture_camera_set_object_marker chief reflector 110)
	
	(render_exposure (- e3_exposure .2) 10)
	(render_depth_of_field 0 .6 3 90)
	(set render_dof_blur 5)

	(object_create fleet)

	

	(object_create_anew hero_cruiser2)
	(object_create_anew hero_cruiser3)
	(scenery_animation_start_relative hero_cruiser objects\vehicles\capital_ship\capital_ship "cruiser1short_alt" anchor)
	(scenery_animation_start_relative hero_cruiser2 objects\vehicles\capital_ship\capital_ship "cruiser2short" anchor)
	(scenery_animation_start_relative hero_cruiser3 objects\vehicles\capital_ship\capital_ship "cruiser3short" anchor)
	(object_cinematic_visibility hero_cruiser 1)
	(object_cinematic_visibility hero_cruiser2 1)
	(object_cinematic_visibility hero_cruiser3 1)
	(cinematic_light_object hero_cruiser ships_prestorm 0 0)
	(cinematic_light_object hero_cruiser2 ships_instorm .9 0)
	(cinematic_light_object hero_cruiser3 ships_instorm .9 0)
	(sleep 30)
	
	(object_create_anew phantom)
	(object_create_anew b1)
	(object_create_anew b2)
	(object_create_anew b3)
	(object_create_anew b4)
	(scenery_animation_start_relative phantom objects\vehicles\phantom\animations\e3_2006\e3_2006 "phantom1" anchor)
	(scenery_animation_start_relative b1 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee01" anchor)
	(scenery_animation_start_relative b2 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee02" anchor)
	(scenery_animation_start_relative b3 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee03" anchor)
	(scenery_animation_start_relative b4 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee04" anchor)
	(object_cinematic_visibility phantom 1)
	(object_cinematic_visibility b1 1)
	(object_cinematic_visibility b2 1)
	(object_cinematic_visibility b3 1)
	(object_cinematic_visibility b4 1)
	(cinematic_light_object phantom banshees_prestorm .1 0)
	(cinematic_light_object b1 banshees_prestorm .1 0)
	(cinematic_light_object b2 banshees_prestorm .1 0)
	(cinematic_light_object b3 banshees_prestorm .1 0)
	(cinematic_light_object b4 banshees_prestorm .1 0)
	(sleep 30)
	
	(object_create_anew b6)
	(object_create_anew b7)
	(object_create_anew b11)
	(object_create_anew b12)
	(object_create_anew b13)
	(scenery_animation_start_relative b6 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee06" anchor)
	(scenery_animation_start_relative b7 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee07" anchor)
	(scenery_animation_start_relative b11 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee11" anchor)
	(scenery_animation_start_relative b12 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee12" anchor)
	(scenery_animation_start_relative b13 objects\vehicles\banshee\e3_2006\e3_2006 "1_banshee13" anchor)
	(object_cinematic_visibility b6 1)
	(object_cinematic_visibility b7 1)
	(object_cinematic_visibility b11 1)
	(object_cinematic_visibility b12 1)
	(object_cinematic_visibility b13 1)
	(cinematic_light_object b6 banshees_prestorm .1 0)
	(cinematic_light_object b7 banshees_prestorm .1 0)
	(cinematic_light_object b11 banshees_prestorm .1 0)
	(cinematic_light_object b12 banshees_prestorm .1 0)
	(cinematic_light_object b13 banshees_prestorm .1 0)


	(sleep 30)
	



	(cinematic_light_object rocks rocks .1 0)
	(cinematic_light_object ark ark 0 .5)
	(cinematic_light_object storm storm 0 1)

	(sleep 11)
;	(sound_looping_predict sound\e3_2006\e3_2006_3\e3_2006_3)
;	(print "SOUND: predict e32006_03")
	
	(sleep 168)

	(camera_set_field_of_view 110 0)

	)



(script static void scene02
;	add 118

	(custom_animation_relative chief objects\characters\masterchief\masterchief_e3\masterchief_e3 "mc_hack1" false anchor)
	
	(set render_dof 0)

	(render_exposure (+ e3_exposure 1) 0)

	(object_destroy light_chief)
	(object_destroy light_chief_fill)
	(object_create_anew light_chief_cliff_edge)

	(wake final_closeup)
	
	(wake birds)

;	(cinematic_lighting_initialize)
	(cinematic_light_object ark ark 0 .5)
	(cinematic_light_object storm storm 0 1)
	
	(sleep 1)
	(render_exposure e3_exposure 2)
	
	(sleep 117)
	
;	(sound_looping_start sound\e3_2006\e3_2006_3\e3_2006_3 none 1)
;	(print "SOUND: e32006_03")

	(sleep 419)
	(object_destroy_containing prop_blast)
	(device_set_position ark 1)
	(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\ark_open ark ark_opening)
	(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\petal_debris ark ark_opening)

	(sleep 60)

	(object_create_anew cliff_gust)
;	(print "FX: Creating Cliff Dust")

	(sleep 35)
	(scenery_animation_start clouds_ark levels\solo\030_outskirts\e3\objects\clouds_ark\clouds_ark "blast")
     (object_reset_time clouds_ark)
	(object_set_time_period_seconds clouds_ark 1)

	(sleep 26)
	(scenery_animation_start rocks levels\solo\030_outskirts\e3\objects\rockslide\rockslide "rockslide")
;	(print "CAMERA: shake")
	(sleep 10)

	
	(render_exposure (+ e3_exposure 2) 2)
	(sleep 40)
	(render_exposure (- e3_exposure .2) 3)	
	
	(sleep 60)
;	(print "destroy banshees")
	(object_destroy_containing phantom)
	(object_destroy b1)
	(object_destroy b2)
	(object_destroy b3)
	(object_destroy b4)
	(object_destroy b6)
	(object_destroy b7)
	(object_destroy b11)
	(object_destroy b12)
	(object_destroy b13)

	(sleep 110)
	(scenery_animation_start road levels\solo\030_outskirts\e3\objects\road_chunks\road_chunks "road_fall")
	(object_destroy cliff_gust)
	(object_destroy_containing atmosphere)

	(sleep 402)
	(sleep 20)
;	(print "CAMERA: begin over-exposure")
	(render_exposure (+ e3_exposure 7) .4)
	(sleep 62)	;add 4
	(fade_out 0 0 0 0)
	(sleep 4)
	(sleep 94)
	(render_exposure e3_exposure 0)

	(object_destroy light_chief_cliff_edge)

	(object_destroy hero_cruiser)
	(object_destroy hero_cruiser2)
	(object_destroy hero_cruiser3)

	(object_destroy fleet)

	
	(device_set_position ark 0)
	)
	
(script static void end
;	(sound_looping_start sound\e3_2006\e3_cortana\e3_cortana4\e3_cortana4 none 1)
;	(print "SOUND: this is the way the world ends")
;	(sleep 120)
	(sleep 75)
	
;	(print "BINK: logo_sequence")
	(play_bink_movie logo_sequence)
	(object_destroy chief)
	(object_destroy cliff_gust)
	(object_destroy chiefs_gun)
	(object_destroy rocks)
	(object_destroy road)
	(object_destroy godrays)
	(device_set_position ark 0)
	(sleep 550)
	

	)

;======================================================================

;======================================================================
;======================================================================

;======================================================================
;======================================================================

;======================================================================
(script dormant lightning
	
	(sleep 410)
	(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\lightning_bolt_01 storm lightning00)
	
	(sleep 125)
	(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\lightning_bolt_02 storm lightning02)

	(sleep 40)
	(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\lightning_bolt_00 storm lightning01)
	
	(sleep 130)
	(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\lightning_bolt_02 storm lightning02)
	

	

	)
	
(script dormant final_closeup

;	(camera_set_animation_relative objects\characters\cinematic_camera\e3_2006\e3_2006 "mc_hack1" none "e3_cutscene_anchor")

	(object_set_permutation chief "visor" base)
	(texture_camera_off)
	
;	(sleep 187)
	(sleep 120)
	(sleep 950)
	
	(object_set_permutation chief "visor" cinematic)
	(texture_camera_set_object_marker chief reflector 70)

	(camera_set_field_of_view 70 0)
	(camera_set_animation_relative objects\characters\cinematic_camera\e3_2006\e3_2006 "mc_hack2" none "e3_cutscene_anchor")
	(custom_animation_relative chief objects\characters\masterchief\masterchief_e3\masterchief_e3 "mc_hack2" false anchor)
	(render_depth_of_field 0 .5 1 0)
	
	(render_exposure (- e3_exposure .3) 0)
	(sleep 1)
	(render_exposure e3_exposure 2)
	
	(sleep 69)

	(object_set_permutation chief "visor" base)
	(texture_camera_off)
	
	(camera_set_field_of_view 110 0)
	(camera_set_animation_relative objects\characters\cinematic_camera\e3_2006\e3_2006 "mc_hack3" none "e3_cutscene_anchor")
	(custom_animation_relative chief objects\characters\masterchief\masterchief_e3\masterchief_e3 "mc_hack3" false anchor)
	(set render_dof 0)
	)
	
(script dormant birds
	(sleep 118)
	(sleep 150)
	(object_create_anew birds)
	(scenery_animation_start birds levels\solo\030_outskirts\e3\objects\flock\flock "fly")
	(sleep 250)
	(object_destroy birds)
	)
	
(script static void e32k6
	(debug_sounds_enable ambient_machinery 1)
	(scene00)
	(scene01)
	(scene02)

;	(sleep 90)
	
	(end)
	)
	
(global boolean end_test false)

(script static void cj1

;	(print "test")
	(camera_control on)
	(cinematic_start)
	(cinematic_skip_stop_internal)
	(set cinematic_letterbox_style 2)
	(object_create_anew chief)
	(object_create_anew chiefs_gun)
	(objects_attach chief "right hand" chiefs_gun "")
	(object_create_anew rocks)
	(object_create_anew hero_cruiser)

	(fade_in 0 0 0 0)

	(object_teleport (list_get (players) 0) "teleport_flag")
	
	(cinematic_lighting_initialize)
	(cinematic_light_object rocks rocks .1 0)
	(cinematic_light_object ark ark 0 .5)
	(cinematic_light_object storm storm 0 1)

	(camera_set_animation_relative objects\characters\cinematic_camera\e3_2006\e3_2006 "idle" none "e3_cutscene_anchor")

	(render_depth_of_field 0 .3 3 0)
	(set render_dof_blur 1)
	(render_exposure e3_exposure 0)

;	(time_code_reset)
;	(time_code_show 1)
;	(time_code_start 1)
	
	(object_create_anew light_chief)
	(object_create_anew light_chief_fill)

	(scene01)
	(scene02)

	(cinematic_stop)
	(object_teleport (list_get (players) 0) "teleport_back")
	(camera_control off)
	(fade_in 0 0 0 30)
	(time_code_show 0)
	
	(object_destroy rocks)
	)

(script static void steve

	(sleep_until
		(begin

;	(print "hi steve!")
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 2)

	(fade_in 0 0 0 0)

	(object_teleport (list_get (players) 0) "teleport_flag")
	
	(object_create_anew rocks)
	
	(cinematic_lighting_initialize)
	(cinematic_light_object ark ark 0 .5)
	(cinematic_light_object rocks rocks 0 .2)

;	(time_code_reset)
;	(time_code_show 1)
;	(time_code_start 1)
	
	(camera_set_animation_relative objects\characters\cinematic_camera\e3_2006\e3_2006 "steve" none "e3_cutscene_anchor")
	(scenery_animation_start rocks levels\solo\030_outskirts\e3\objects\rockslide\rockslide "idle")
	(camera_set_field_of_view 110 0)
	
	(object_create_anew cliff_gust)
;	(print "FX: Creating Cliff Dust")

	(sleep 61)
	(scenery_animation_start rocks levels\solo\030_outskirts\e3\objects\rockslide\rockslide "rockslide")
;	(print "CAMERA: shake")
	(sleep 10)
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_start 1 0)
	(player_effect_stop 5)
	(sleep 150)

	(time_code_show 0)

		end_test)
	)
)

(script static void cj2

;	(print "Sorry, I have to start you from cj1 in order for the scripts to work")
	(cj1)

	)

(script dormant test
	(sleep_until
		(begin
			(e32k6)
		end_test)
	)
)


(global boolean go_switcheroo false)
(global boolean go_looping_lightning false)
(global boolean go_ending_fade false)

(script static void third
		(set go_ending_fade true)
         	(player_action_test_reset)
         	(sleep_until
            		(player_action_test_cancel)
		1)
		
;		(cinematic_show_letterbox 0)
		(camera_set_mode 0 0)  
		(sleep 30)

)

(script static void flying
		(set go_ending_fade true)
         	(player_action_test_reset)
         	(sleep_until
            		(player_action_test_cancel)
		1)

		(camera_set_mode 0 2)
;		(cinematic_show_letterbox 1)
		(sleep 30)
)

(script continuous player_camera_switcheroo

            (sleep_until
                        go_switcheroo
            1)

            (third)
            (flying)
)

(script continuous looping_lightning

          (sleep_until
                    go_looping_lightning
         	1)
		
		(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\lightning_bolt_random storm lightning00)
		(sleep 750)
)

(script continuous ending_fade

          (sleep_until
                    go_ending_fade
         	1)
           
(sleep_until
	(begin
		(player_action_test_reset)
		(sleep 1) ; Maybe unnecessary, but probably wouldn’t hurt
		(and
			(player_action_test_grenade_trigger)
			(player_action_test_primary_trigger)
		)
	)
	1
)	
		(fade)
)

(script static void fade		
	(set go_switcheroo 0)
	(player_enable_input false)	
;	(print "begin fade")
	(render_exposure (- e3_exposure 12) 10)
	(sound_class_set_gain ambient_machinery 0 300)
	(sleep 280)
	(fade_out 0 0 0 20)
	
	
	(player_action_test_reset)
      (sleep_until
            (and
                  (player_action_test_accept)
                  (player_action_test_cancel)
            )
      1)


	(cinematic_show_letterbox 1)
	(camera_set_flying_cam_at_point 0 exit01)
	(render_exposure (- e3_exposure 8) 0)
	
	(sleep 30)
	
	(player_enable_input true)	
	(texture_camera_set_object_marker (list_get (players) 0) reflector 70)

	(sound_class_set_gain ambient_machinery 1 300)
	(fade_in 0 0 0 30)
	(render_exposure e3_exposure 10)

     (set go_switcheroo true)
)



(script static void trailer_only
	(cls)
	(time_code_show 0)
	(fade_out 0 0 0 0)
	
	(set render_screen_gamma e3_gamma)
	
	
	(player_enable_input false)	

	(player_action_test_reset)
    	(sleep_until
          (and
                 (player_action_test_accept)
                 (player_action_test_cancel)
           )
    	1)


	(e32k6)
	
	(player_enable_input false)	
	
	(time_code_show 0)
)

(script static void trailer_and_demo
	(cls)
	(time_code_show 0)
	(fade_out 0 0 0 0)

	(set render_screen_gamma e3_gamma)
	

	
	(player_enable_input false)	
	
	(player_action_test_reset)
    	(sleep_until
          (and
                 (player_action_test_accept)
                 (player_action_test_cancel)
           )
    	1)


	(e32k6)
	(cinematic_stop)
	(player_enable_input false)
	(hud_show off)
	(object_teleport (list_get (players) 0) "teleport_back")

	(camera_control off)
	
	(time_code_show 0)
	

	
;	(print "ready for input")

	(player_action_test_reset)
      (sleep_until
            (and
                  (player_action_test_accept)
                  (player_action_test_cancel)
            )
      1)


	(cinematic_show_letterbox 1)
	(camera_set_flying_cam_at_point 0 exit01)
	(render_exposure (- e3_exposure 8) 0)
	
	(sleep 30)
	
	(player_enable_input true)	
	(texture_camera_set_object_marker (list_get (players) 0) reflector 70)
	(set texture_camera_near_plane 0)

	(sound_class_set_gain ambient_machinery 1 300)
	(fade_in 0 0 0 30)
	(render_exposure e3_exposure 10)

     (set go_switcheroo true)
     (set go_looping_lightning true)
)

(script dormant standard
	(set display_framerate 0)
	(set terminal_render 0)
	(set e3_gamma 1.95)
	(sound_class_set_gain ambient_machinery 0 0)
	(fade_out 0 0 0 0)
	(cinematic_show_letterbox 1)
	(gui_test_screen demo_e3)
	(trailer_and_demo)
)

(script dormant briefing_light
	(set display_framerate 0)
	(set terminal_render 0)
	(set e3_gamma 2.1)
	(sound_class_set_gain ambient_machinery 0 0)
	(fade_out 0 0 0 0)
	(cinematic_show_letterbox 1)
	(gui_test_screen briefing_e3)
	(trailer_only)
)

(script dormant briefing_lighter
	(set display_framerate 0)
	(set terminal_render 0)
	(set e3_gamma 2.25)
	(sound_class_set_gain ambient_machinery 0 0)
	(fade_out 0 0 0 0)
	(cinematic_show_letterbox 1)
	(gui_test_screen briefing_e3)
	(trailer_only)
)

(script dormant briefing_lightest
	(set display_framerate 0)
	(set terminal_render 0)
	(set e3_gamma 2.5)
	(sound_class_set_gain ambient_machinery 0 0)
	(fade_out 0 0 0 0)
	(cinematic_show_letterbox 1)
	(gui_test_screen briefing_e3)
	(trailer_only)
)

(script dormant briefing_dark
	(set display_framerate 0)
	(set terminal_render 0)
	(set e3_gamma 1.8)
	(sound_class_set_gain ambient_machinery 0 0)
	(fade_out 0 0 0 0)
	(cinematic_show_letterbox 1)
	(gui_test_screen briefing_e3)
	(trailer_only)
)

(script dormant briefing_darker
	(set display_framerate 0)
	(set terminal_render 0)
	(set e3_gamma 1.7)
	(sound_class_set_gain ambient_machinery 0 0)
	(fade_out 0 0 0 0)
	(cinematic_show_letterbox 1)
	(gui_test_screen briefing_e3)
	(trailer_only)
)

(script dormant briefing_darkest
	(set display_framerate 0)
	(set terminal_render 0)
	(set e3_gamma 1.6)
	(sound_class_set_gain ambient_machinery 0 0)
	(fade_out 0 0 0 0)
	(cinematic_show_letterbox 1)
	(gui_test_screen briefing_e3)
	(trailer_only)
)

(script dormant briefing_standard
	(set display_framerate 0)
	(set terminal_render 0)
	(set e3_gamma 1.95)
	(sound_class_set_gain ambient_machinery 0 0)
	(fade_out 0 0 0 0)
	(cinematic_show_letterbox 1)
	(gui_test_screen briefing_e3)
	(trailer_only)
)
