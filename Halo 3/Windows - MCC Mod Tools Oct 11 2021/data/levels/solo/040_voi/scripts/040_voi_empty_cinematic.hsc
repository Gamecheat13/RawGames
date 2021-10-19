

(script static void test_longsword_crash
    (switch_zone_set bfg)
    ;(wake vig_crashing_longsword)
    (test_bfg)
    
)

(script static void test_scarab_footsteps
    (switch_zone_set fab_lakeb)
    
    (sleep_until
        (begin
        	(ai_place scarab)
        	(vs_custom_animation scarab/driver01 FALSE objects\giants\scarab\cinematics\perspectives\040pb_scarab_intro\040pb_scarab_intro "040pb_scarab_intro_1" FALSE)
        	(sleep (unit_get_custom_animation_time (ai_get_unit scarab/driver01)))
        	(vs_stop_custom_animation scarab/driver01)
        	(ai_force_active scarab/driver01 TRUE)
        	(sleep 90)
        	FALSE
        )
    )
)