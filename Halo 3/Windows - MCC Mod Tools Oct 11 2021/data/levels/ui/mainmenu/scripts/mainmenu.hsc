;*
mainmenu.hsc
Copyright (c) Microsoft Corporation, 2007. All rights reserved.
Saturday February 10, 2007 3:30pm Stefan S.

Sleep in sweat, the mirror's cold. Seen my face, it's growing old.
*;

;---------- variables

;* ui location
	0 == main menu
	1 == campaign lobby
	2 == matchmaking lobby
	3 == custom games lobby
	4 == editor lobby
	5 == theater lobby
*;
(global short ui_location -1)
(global real mainmenu_offset 0)

;---------- local scripts

; sleep_ui - use this everywhere you would normally call sleep in this script file
; based on dmiller's clock script, sleep_ui works just
; like sleep, but is interrupted on a change in ui_location
; call w/ # of ticks to count-down
(global long wait_ticks 0)
(global short ui_location_clock_start -1)

(script static void (sleep_ui (long timer_ticks))
	(print "sleep ui script")
	(set ui_location_clock_start ui_location)
	(set wait_ticks 0)
	(sleep_until
		(begin
			(set wait_ticks (+ wait_ticks 1))
			(if (!= ui_location ui_location_clock_start)
				(set wait_ticks timer_ticks)
			)
			(>= wait_ticks timer_ticks)
		)
	1)
)

(script static void (set_ui_location (short location))
	(set ui_location location)
	; we now need to sleep 1 tick to allow sleep_ui to detect the location change so that its timer will be interrupted
	(sleep 1)
)

(script static void kill_camera_scripts
	(print "kill camera scripts")
	(kill_active_scripts)
	; stop any of our camera scripts which might be active
	(if (!= ui_location 0) (sleep_forever mainmenu_cam))
	(if (!= ui_location 1) (sleep_forever campaign_cam))
	(if (!= ui_location 2) (sleep_forever matchmaking_cam))
	(if (!= ui_location 3) (sleep_forever custom_cam))
	(if (!= ui_location 4) (sleep_forever editor_cam))
	(if (!= ui_location 5) (sleep_forever theater_cam))
)

; ---------- public scripts

(script startup mainmenu
	(print "mainmenu statup script")
	
	(wake appearance_characters)

	(wake sc_bridge_cruiser)
	; when we enter the UI scenario, the game will start faded to black, so we need to fade in
	; fade-in from A=0 R G B over N ticks (assuming ui is running @ 60hz as planned, this will be 0.5 seconds)
	; the very next thing we do is to initialize our UI location
	; initialize our ui location (initially, we are nowhere) 
	(fade_out 0 0 0 0)
	(set ui_location -1)
	(sleep_for_ticks 8)
	
	; set resolution of texture camera 
	(texture_camera_set_aspect_ratio 0.676)

	;this compensates for the 10 tick delay in camera swapping
	(fade_in 0 0 0 22)
	
	

;	(cinematic_light_object (ai_get_object appearance/chief) appearance 1 1)
;	(cinematic_light_object (ai_get_object appearance/elite) appearance 1 1)
;	(cinematic_light_object mp_chief1 custom_games 1 1)
;	(cinematic_light_object mp_chief2 custom_games 1 1)
;	(cinematic_light_object mp_chief3 custom_games 1 1)
;	(cinematic_light_object (ai_get_object custom/mc1) custom_games 1 1)
;	(cinematic_light_object (ai_get_object custom/mc2) custom_games 1 1)
;	(cinematic_light_object (ai_get_object custom/mc3) custom_games 1 1)
;	(cinematic_light_object editorifle editor 1 1)
;	(cinematic_light_object earth matchmaking 1 1)
;	(cinematic_light_object pelicampaign campaign 1 1)
	(camera_control on)

	; place and activate custom games characters 
	;(ai_place custom)
	;	(sleep  1)
	;(pvs_set_object (ai_get_object custom))
)
; =======================================================================================================================================================================
(script dormant appearance_characters
	(print "appearance characters [static script]")
	; place and activate appearance characters 
	(pvs_set_object chief)
	(pvs_set_object elite)
	(sleep 1)
	(objects_attach chief "right_hand" appearance_ar "")
	(objects_attach elite "right_hand_elite" apperance_pr "")
	(sleep 1)
	(custom_animation_loop chief objects\characters\masterchief\masterchief "ui:rifle:idle:var1" FALSE)
	(custom_animation_loop elite objects\characters\elite\elite "combat:pistol:idle:var0" FALSE)
	(texture_camera_enable_dynamic_lights 1)
)

(script static void campaign_characters
	(print "campaign characters [static script]")
	(object_create_containing campaign_)
		(sleep_ui 1)
	(pvs_set_object campaign_chief)
	(pvs_set_object campaign_aribter)
		(sleep_ui 1)
	(objects_attach campaign_chief "right_hand" campaign_ar "")
	(objects_attach campaign_aribter "right_hand_elite" campaign_pr "")
		(sleep_ui 1)
	(custom_animation_loop campaign_chief objects\characters\masterchief\masterchief "ui:rifle:idle:var2" FALSE)
	(custom_animation_loop campaign_aribter objects\characters\elite\elite "ui:pistol:idle:var1" FALSE)
	(texture_camera_enable_dynamic_lights 1)
)

(script static void custom_characters
	(print "campaign characters [static script]")
	(object_create_containing custom_)
		(sleep_ui 1)
	(pvs_set_object custom_chief_01)
	(pvs_set_object custom_elite_01)
		(sleep_ui 1)
	(objects_attach custom_chief_01 "right_hand" custom_ar_01 "")
	(objects_attach custom_elite_01 "right_hand_elite" custom_pr_01 "")
	(objects_attach custom_elite_01 "left_hand_elite" custom_pr_02 "")
		(sleep_ui 1)
	(custom_animation_loop custom_chief_01 objects\characters\masterchief\masterchief "ui:rifle:idle:var3" FALSE)
	(custom_animation_loop custom_elite_01 objects\characters\elite\elite "ui:dual:idle:var1" FALSE)
	(texture_camera_enable_dynamic_lights 1)
)
; =======================================================================================================================================================================
; this script is intended to be run by the main menu screen when it loads
(script static void mainmenu_cam
	(print "mainmenu camera")
	
	; update our ui location
	(sleep_ui 10)
	(set_ui_location 0)
	(kill_camera_scripts)
	
	; create/destroy bipeds/weapons
	(object_destroy_containing campaign_)
	(object_destroy_containing custom_)
	(object_destroy_containing editor_)
	(object_destroy cruiser3)
	(object_create_anew banshee1)
	(object_create_anew banshee2)

	; setup render stuff
	;(render_depth_of_field_enable 0)
	;(set render_postprocess_saturation  .5)
	;(set render_postprocess_red_filter .35)
	;(set render_postprocess_green_filter .4)
	;(set render_postprocess_blue_filter .6)

	(cinematic_light_object ark "" lighting_ark light_anchor)
	(cinematic_light_object storm "" lighting_storm light_anchor)
	(cinematic_light_object cruiser1 "" lighting_ships light_anchor)
	(cinematic_light_object cruiser2 "" lighting_ships light_anchor)
	(cinematic_light_object cruiser3 "" lighting_ships light_anchor)
	(cinematic_light_object cruiser4 "" lighting_ships light_anchor)
	(cinematic_light_object clouds_ark "" lighting_clouds light_anchor)
	(cinematic_lighting_rebuild_all)

	; animate appearance menu characters 
;	(appearance_characters) Deprecated

	; start our main menu camera looping (loops forever)
	(sleep_until
    	(begin_random
    		(begin
    			(print "mainmenu: camera track 1")
    			(camera_set_animation_relative_with_speed objects\characters\cinematic_camera\ui\main_menu\main_menu "camera_path_main1" none "xxxANCHORxxx" 0.5)
    			
    			(scenery_animation_start banshee1 objects\vehicles\banshee\cinematics\ui\mainmenu\mainmenu "cin_banshee1")
                (object_set_custom_animation_speed banshee1 0.5)
                (object_cinematic_visibility banshee1 TRUE)
                
                (scenery_animation_start banshee2 objects\vehicles\banshee\cinematics\ui\mainmenu\mainmenu "cin_banshee2")
                (object_set_custom_animation_speed banshee2 0.5)
                (object_cinematic_visibility banshee2 TRUE)

    			(sleep 1599)
    		    FALSE
    		)
    		(begin
    			(print "mainmenu: camera track 2")
    			(camera_set_animation_relative_with_speed objects\characters\cinematic_camera\ui\main_menu\main_menu "camera_path_main2" none "xxxANCHORxxx" 0.5)

    			(scenery_animation_start banshee1 objects\vehicles\banshee\cinematics\ui\mainmenu\mainmenu "cin_banshee3")
                (object_set_custom_animation_speed banshee1 0.5)
                (object_cinematic_visibility banshee1 TRUE)

                (scenery_animation_start banshee2 objects\vehicles\banshee\cinematics\ui\mainmenu\mainmenu "cin_banshee4")
                (object_set_custom_animation_speed banshee2 0.5)
                (object_cinematic_visibility banshee2 TRUE)

    			(sleep 1599)
    			FALSE
    		)
    		(begin
    			(print "mainmenu: camera track 3")
    			(camera_set_animation_relative_with_speed objects\characters\cinematic_camera\ui\main_menu\main_menu "camera_path_main3" none "xxxANCHORxxx" 0.5)

                (scenery_animation_start banshee1 objects\vehicles\banshee\cinematics\ui\mainmenu\mainmenu "cin_banshee5")
                (object_set_custom_animation_speed banshee1 0.5)
                (object_cinematic_visibility banshee1 TRUE)

                (scenery_animation_start banshee2 objects\vehicles\banshee\cinematics\ui\mainmenu\mainmenu "cin_banshee6")
                (object_set_custom_animation_speed banshee2 0.5)
                (object_cinematic_visibility banshee2 TRUE)

                ;*(scenery_animation_start cruiser4 objects\vehicles\cov_cruiser\cinematics\ui\mainmenu\mainmenu "cov_cruiser4")
                (object_set_custom_animation_speed cruiser4 0.5)
                (object_cinematic_visibility cruiser4 TRUE)*;

    			(sleep 1599)
    			FALSE
    		)
    	)
	1 )

;	(set mainmenu_offset (real_random_range 0 1))
	
	; done 
	(sleep_forever)
)


; this script is intended to be run by the campaign lobby ui screen when it loads
(script static void campaign_cam
	(print "campaign camera")
	
	; update our ui location
	(sleep_ui 10)
	(set_ui_location 1)
	(kill_camera_scripts)
	
	; create/destroy bipeds 
	(object_destroy_containing custom_)
	(object_destroy_containing editor_)
	(object_destroy cruiser3)
	(object_destroy banshee1)
	(object_destroy banshee2)

	; run characters script 
	(campaign_characters)

	; setup render stuff
	;(render_postprocess_color_tweaking_reset)
	(camera_set campaign_in 0)
	(sleep 0)
	(camera_set campaign 11)
	(sleep_ui 30)
	;(render_depth_of_field_enable 1)
	;(render_depth_of_field 0 5 5.6 0)
	;(set render_postprocess_saturation  .5)
	;(set render_postprocess_red_filter .2)
	;(set render_postprocess_green_filter .3)
	;(set render_postprocess_blue_filter .4)
	;then we make the camera slowly move around for a little bit...
	     
	(camera_set campaign_path_02 700)
	(sleep_ui 250)
	
	(camera_set campaign_path_03 700)
	(sleep_ui 250)
	
	(camera_set campaign_path_04 700)
	(sleep_ui 250)
	
	(camera_set campaign 700)
	(sleep_ui 250)
	
	; done
	(sleep_forever)
)

; this script is intended to be run by the matchmaking lobby ui screen when it loads
(script static void matchmaking_cam
	(print "matchmaking camera")

	; update our ui location
	(sleep_ui 10)
	(set_ui_location 2)
	(kill_camera_scripts)

	; create/destroy bipeds 
	(object_destroy_containing campaign_)
	(object_destroy_containing custom_)
	(object_destroy_containing editor_)
	(object_destroy cruiser3)
	(object_destroy banshee1)
	(object_destroy banshee2)

	; setup render stuff
	;(render_postprocess_color_tweaking_reset)
	(camera_set matchmaking_in 0)
	(sleep 0)
	(camera_set matchmaking 11)
	(sleep_ui 30)
	;(render_depth_of_field_enable 1)
	;(render_depth_of_field 0 3.2 3.4 0)
	;then we make the camera slowly move around for a little bit...
	     
	(camera_set mm_path_02 700)
	(sleep_ui 250)
	
	(camera_set mm_path_03 700)
	(sleep_ui 250)
	
	(camera_set mm_path_04 700)
	(sleep_ui 250)
	
	(camera_set matchmaking 700)
	(sleep_ui 250)
	
	; done
	(sleep_forever)
)

; this script is intended to be run by the custom games lobby ui screen when it loads
(script static void custom_cam
	(print "custom camera")

	; update our ui location
	(sleep_ui 10)
	(set_ui_location 3)
	(kill_camera_scripts)

	; create/destroy bipeds 
	(object_create_containing custom_)
	(object_destroy_containing editor_)
	(object_destroy cruiser3)
	(object_destroy banshee1)
	(object_destroy banshee2)

	; run characters script 
	(custom_characters)

	; setup render stuff
	;(render_postprocess_color_tweaking_reset)
	(camera_set custom_in 0)
	(sleep 0)
	(camera_set custom_games 11)
	(sleep_ui 30)
	;(render_depth_of_field_enable 1)
	;(render_depth_of_field 0 0.2 1.2 0)
	;(set render_postprocess_saturation  .5)
	;(set render_postprocess_red_filter .2)
	;(set render_postprocess_green_filter .3)
	;(set render_postprocess_blue_filter .4)
	;then we make the camera slowly move around for a little bit...
	     
	(camera_set custom_path_02 700)
	(sleep_ui 250)
	
	(camera_set custom_path_03 700)
	(sleep_ui 250)
	
	(camera_set custom_path_04 700)
	(sleep_ui 250)
	
	(camera_set custom_games 700)
	(sleep_ui 250)

	; done
	(sleep_forever)
)

(script static void editor_characters
	(object_create_anew_containing editor_)
		(sleep 1)
	
	; animate the monitor 
	(scenery_animation_start_loop editor_monitor levels\ui\mainmenu\objects\monitor_cheap\monitor_cheap "ui:idle:var1")
)

; this script is intended to be run by the editor lobby ui screen when it loads
(script static void editor_cam
	(print "editor camera")
		
	; update our ui location
	(sleep_ui 10)
	(set_ui_location 4)
	(kill_camera_scripts)
	
	; create/destroy bipeds 
	(object_destroy_containing campaign_)
	(object_destroy_containing custom_)
	(object_destroy banshee1)
	(object_destroy banshee2)
	
	; run characters script 
	(editor_characters)

	; setup render stuff
	;(render_postprocess_color_tweaking_reset)
	(camera_set editor_in 0)
	(sleep 0)
	(camera_set editor 11)
	(sleep_ui 30)
	;(render_depth_of_field_enable 1)
	;(render_depth_of_field 0 .08 .09 0)
	;then we make the camera slowly move around for a little bit...
	
	(camera_set editor_path_02 500)
	(sleep_ui 250)
	
	(camera_set editor_path_03 700)
	(sleep_ui 250)
	
	(camera_set editor_path_04 700)
	(sleep_ui 250)
	
	(camera_set editor 700)
	(sleep_ui 250)
	
	; done
	(sleep_forever)
)

; this script is intended to be run by the theater lobby ui screen when it loads
(script static void theater_cam
	(print "theater camera")

	; update our ui location
	(sleep_ui 10)
	(set_ui_location 5)
	(kill_camera_scripts)
	
	; create/destroy bipeds 
	(object_destroy_containing campaign_)
	(object_destroy_containing custom_)
	(object_destroy_containing editor_)
	(object_destroy banshee1)
	(object_destroy banshee2)

	; Create the cruiser and light it
	(object_create cruiser3)
	(cinematic_light_object cruiser3 "" lighting_ships light_anchor)
	(cinematic_lighting_rebuild_all)

	; setup render stuff
	;(render_postprocess_color_tweaking_reset)
	(camera_set theater_in 0)
	(sleep 0)
	(camera_set theater 11)
	(sleep_ui 30)
	;(render_depth_of_field_enable 1)
	;(render_depth_of_field 0 2.0 1.0 0)
	;(set render_postprocess_saturation  .5)
	;(set render_postprocess_red_filter .2)
	;(set render_postprocess_green_filter .3)
	;(set render_postprocess_blue_filter .4)
	;then we make the camera slowly move around for a little bit...
	
	(camera_set theater_path_02 700)
	(sleep_ui 250)
	
	(camera_set theater_path_03 700)
	(sleep_ui 250)
	
	(camera_set theater_path_04 700)
	(sleep_ui 250)
	
	(camera_set theater 700)
	(sleep_ui 250)

	; done
	(sleep_forever)
)

;script to place and fly around the cruisers over the ark
(script dormant sc_bridge_cruiser
	(print "cruiser is awake")
	;(object_create_anew cruiser1)
	;(object_create_anew cruiser2)
	;(sleep 1)
	(scenery_animation_start_loop cruiser1 objects\vehicles\cov_cruiser\cinematics\vignettes\030vb_excavation\030vb_excavation "cinematic_cov_cruiser")
	(object_set_custom_animation_speed cruiser1 0.009)
	(object_cinematic_visibility cruiser1 TRUE)
	(scenery_animation_start_at_frame_loop cruiser2 objects\vehicles\cov_cruiser\cinematics\vignettes\030vb_excavation\030vb_excavation "cinematic_cov_cruiser1" (random_range 35 40))
	(object_set_custom_animation_speed cruiser2 0.01)
	(object_cinematic_visibility cruiser2 TRUE)
)