
(script static void 070pa_loop
    (switch_zone_set bsp_011)
    
    (sleep_until
        (begin
            (070pa_start)
            FALSE
        )
    )

)

(script static void 070pa_start
	;*(perspective_start)
	(camera_control on)
	(cinematic_start)
	(set cinematic_letterbox_style 2)
	(cinematic_show_letterbox_immediate TRUE)
	(070pa_frigate_lands)
	(fl_create_frigate)
	(cinematic_stop)
	(camera_control off)
	(perspective_stop)*;
	
	
	(fl_destroy_frigate)
	(fl_create_frigate)
	(object_set_always_active fl_frigate_scenery TRUE)
	(scenery_animation_start fl_frigate_scenery "objects\cinematics\human\frigate\frigate\cinematics\perspectives\070pa_frigate_lands\070pa_frigate_lands" "070pa_cin_frigate_1")
	(sleep (min (scenery_get_animation_time fl_frigate_scenery) 900))
	(fl_replace_elevators)
)

(script static void fl_create_frigate
	(object_create fl_frigate_scenery)
	(object_create fl_frigate_midshaft_scenery)
	(object_create fl_frigate_frontshaft_scenery)
	(object_create fl_frigate_backshaft_scenery)
	;(sleep 1)
	(objects_attach fl_frigate_scenery marker_backelevator01 fl_frigate_frontshaft_scenery marker_backelevator)
	(objects_attach fl_frigate_scenery marker_backelevator02 fl_frigate_midshaft_scenery marker_backelevator)
	(objects_attach fl_frigate_scenery marker_backelevator fl_frigate_backshaft_scenery marker_backelevator)
)

(script static void fl_replace_elevators
	(object_destroy fl_frigate_midshaft_scenery)
	(object_destroy fl_frigate_frontshaft_scenery)
	(object_destroy fl_frigate_backshaft_scenery)
		
	(object_create fl_frigate_midshaft)
	(object_create fl_frigate_frontshaft)
	(object_create fl_frigate_backshaft)
	(objects_attach fl_frigate_scenery marker_backelevator01 fl_frigate_frontshaft marker_backelevator)
	(objects_attach fl_frigate_scenery marker_backelevator02 fl_frigate_midshaft marker_backelevator)
	(objects_attach fl_frigate_scenery marker_backelevator fl_frigate_backshaft marker_backelevator)	
)

(script static void fl_destroy_frigate
	(object_destroy fl_frigate_scenery)
	(object_destroy fl_frigate_midshaft_scenery)
	(object_destroy fl_frigate_frontshaft_scenery)
	(object_destroy fl_frigate_backshaft_scenery)

	(object_destroy fl_frigate_midshaft_scenery)
	(object_destroy fl_frigate_frontshaft_scenery)
	(object_destroy fl_frigate_backshaft_scenery)
		
	(object_destroy fl_frigate_midshaft)
	(object_destroy fl_frigate_frontshaft)
	(object_destroy fl_frigate_backshaft)
)

(script static void sound_test_cruiser
	(sleep_until
	    (begin
		     (object_create_anew abb_cruiser)
			(object_cinematic_visibility abb_cruiser true)
			(scenery_animation_start abb_cruiser objects\vehicles\cov_cruiser\cinematics\vignettes\070_shipmaster_arrives\070_shipmaster_arrives "070_shipmaster_arrives")
        0)
    600)
	
)

(script static void fx_test_crashing_longsword
	;(if b_debug (print "vignette:ex:va_crashing_longsword"))
	(switch_zone_set bsp_010)
	
	
	(sleep_until
	    (begin
	        (object_create_anew cin_longsword)
	        (object_set_always_active cin_longsword TRUE)
        	(sleep 1)
        	(ai_disregard cin_longsword true)
        	(scenery_animation_start_relative cin_longsword objects\vehicles\longsword\cinematics\vignettes\070vc_crashing_longsword\070vc_crashing_longsword "070vc_crashing_longsword" 070va_anchor)
        	(sleep 120)
        	(object_destroy cin_longsword)
        	
        	(player_effect_set_max_rotation 0 0.5 0.5)
        	(player_effect_set_max_rumble 1 1)
        	(player_effect_start 0.50 0.05)
        	(sleep 20)
        	(player_effect_stop 0.5)
        	(sleep 90)
            FALSE
        )
    )
)


(script static void fx_test_scarab_around_wall

    (sleep_until
        (begin
            (ai_place cov_bb_scarab)
            (sleep 600)
            (ai_erase cov_bb_scarab)
            ;(sleep 600)
            FALSE
        )
    )
)

(script command_script cs_bb_scarab_around_wall
	(cs_custom_animation "objects\giants\scarab\cinematics\vignettes\070vd_scarab_over_wall\070vd_scarab_over_wall" "070vd_scarab_around_wall" false)
	;(set bb_scarab_spawned 1)
)

(script static void fx_test_scarab_over_wall
    (sleep_until
        (begin
        	(object_create bb_scarab)
        	(sleep 1)
        	;(set b_bb_scarab_over_head_created 1)
        	(object_cannot_take_damage bb_scarab)
        	(object_cannot_die bb_scarab true)
        	(custom_animation bb_scarab "objects\giants\scarab\cinematics\vignettes\070vd_scarab_over_wall\070vd_scarab_over_wall" "070vd_scarab_over_wall" false)
        	(sleep_until (not (unit_is_playing_custom_animation bb_scarab)) 1)
        	(object_cannot_die bb_scarab false)
        	(object_destroy bb_scarab)
        	FALSE
        )
    )
)


(script static void fx_test_shipmaster_arrives
    (switch_zone_set 070_030_040)
    (sleep_until 
        (begin
        	(object_create_anew abb_capital_ship)
        	(object_cinematic_visibility abb_capital_ship true)
        	(scenery_animation_start abb_capital_ship objects\vehicles\cov_capital_ship\cinematics\vignette\070_shipmaster_arrives\070_shipmaster_arrives "070_shipmaster_arrives")
        	(sleep (scenery_get_animation_time abb_capital_ship))
        	(scenery_animation_start_loop abb_capital_ship objects\vehicles\cov_capital_ship\cinematics\vignette\070_shipmaster_arrives\070_shipmaster_arrives "070_shipmaster_idle")
        	(sleep 150)
        	(object_destroy abb_capital_ship)
        	FALSE
        )
    )
)