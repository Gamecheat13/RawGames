;*********************************************************************;
;040_voi Cinematics
;*********************************************************************;

;Placeholder for perspective of Ark opening until Rob swaps over.

(script dormant ark_sounds
	(sound_looping_start "sound\device_machines\ark_open_perspective\ark_open_perspective\ark_open_perspective" NONE 1)
	(sleep_until (= (device_get_position ark) 1) 1)
	(sound_looping_stop "sound\device_machines\ark_open_perspective\ark_open_perspective\ark_open_perspective")
)

(script dormant ark_opens_persp
	(perspective_start)
	(camera_set cam01 0)
	(device_set_position ark 1)
	(wake ark_sounds)
	(sleep 30)
	(camera_set cam02 210)
	(sleep 210)
	(sleep 60)
	(camera_set cam01 210)
	(sleep 210)
	(sleep 30)
	(perspective_stop)
)

;----------------------------------------------------------------------

;*********************************************************************;
;040pa_ARK_OPENS
;*********************************************************************;

;----------------------------------------------------------------------



(script dormant 040pa_ark_opens_sound
	(sound_looping_start "sound\device_machines\ark_open_perspective\ark_open_perspective\ark_open_perspective" NONE 1)
	(sleep_until (= (device_get_position ark) 1) 1)
	(sound_looping_stop "sound\device_machines\ark_open_perspective\ark_open_perspective\ark_open_perspective")
)


(script dormant 040pa_ark_opens_events
	(perspective_start)
	
	(object_create_anew per_chief)
	(object_create_anew per_b01)
	(object_create_anew per_b02)
	(object_create_anew per_b03)
	(object_create_anew per_b04)
	(object_create_anew per_b05)
	(object_create_anew per_b06)
	(object_create_anew per_b07)
	(object_create_anew per_b08)
	(object_create_anew per_cruiser01)
	(object_create_anew per_cruiser02)

	(camera_set_animation_relative objects\characters\cinematic_camera\040pa_ark_opens\040pa_ark_opens "ubercam_040pa" none "040pa_anchor")

	(custom_animation_relative per_chief objects\characters\masterchief\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "chief_040pa" false cin_anchor_040pa)
	(scenery_animation_start_relative per_b01 objects\vehicles\banshee\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "b01_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_b02 objects\vehicles\banshee\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "b02_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_b03 objects\vehicles\banshee\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "b03_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_b04 objects\vehicles\banshee\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "b04_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_b05 objects\vehicles\banshee\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "b05_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_b06 objects\vehicles\banshee\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "b06_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_b07 objects\vehicles\banshee\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "b07_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_b08 objects\vehicles\banshee\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "b08_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_cruiser01 objects\vehicles\capital_ship\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "cruiser01_040pa" cin_anchor_040pa)
	(scenery_animation_start_relative per_cruiser02 objects\vehicles\capital_ship\cinematics\perspectives\040pa_ark_opens\040pa_ark_opens "cruiser02_040pa" cin_anchor_040pa)
	
	(sleep 408)
	(device_set_position ark 1)
	
	(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\ark_open ark ark_opening)
	(effect_new_on_object_marker levels\solo\030_outskirts\e3\fx\petal_debris ark ark_opening)
	(wake 040pa_ark_opens_sound)

	(sleep (- 408 (camera_time)))
	(perspective_stop)


;	sleep until animations are hidden or play out
;	swap to looping animation for cruiser?

)

(script dormant 040pa_ark_opens

;header-----------------------------
	(player_disable_movement TRUE)
	(player_camera_control FALSE)

	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)	
	(fade_out 1 1 1 15) 
	(sleep 15) 
	
	(camera_control 1)
;end_header-------------------------



;events-----------------------------
	(wake 040pa_ark_opens_events)
;end_events-------------------------



;footer-----------------------------
	(fade_in 1 1 1 15)
	(sleep 15)

	(player_action_test_reset)
	(sleep_until 
		(OR
			(player_action_test_accept)
			(= perspective_running FALSE)
		)
	1)

	(cinematic_show_letterbox FALSE)	
	(fade_out 1 1 1 15) 
	(sleep 15)
	
	(object_destroy per_chief)

	(camera_control 0)

	(hud_cinematic_fade 1 0.5)
	(fade_in 1 1 1 15)
	(sleep 15)

	(player_disable_movement FALSE)
	(player_camera_control TRUE)
;end_footer--------------------------
)



