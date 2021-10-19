;========== Cutscene Stubs ==========

;========== Global Variables ==========
;Every global variable used in the mission script

	(global long delay_blink (* 30 3))
	(global long delay_dawdle (* 30 10))
	(global long delay_tutorial (* 30 15))
	(global long delay_prompt (* 30 10))
	(global long delay_witness (* 30 5))
	(global long delay_wait (* 30 10))
	(global long delay_late (* 30 45))
	(global long delay_lost (* 30 60))

	(global boolean mark_bsp0 FALSE)
	(global boolean mark_bsp1 FALSE)
	(global boolean mark_bsp2 FALSE)
	(global boolean mark_bsp3 FALSE)
	(global boolean mark_bsp4 FALSE)
	(global boolean mark_bsp5 FALSE)
	
	(global boolean gbl_1st_waves FALSE)

;========== Music Scripts ==========

;========== Flavor Scripts ==========
;*
(script dormant title_training
	(cinematic_show_letterbox 1)
	(show_hud 0)
	(sleep 30)
	(cinematic_set_title training)
	(sleep 150)
	(show_hud 1)
	(cinematic_show_letterbox 0)
	)

(script dormant title_bridge
	(cinematic_show_letterbox 1)
	(show_hud 0)
	(sleep 30)
	(cinematic_set_title bridge)
	(sleep 150)
	(show_hud 1)
	(cinematic_show_letterbox 0)
	)

(script dormant title_escape
	(cinematic_show_letterbox 1)
	(show_hud 0)
	(sleep 30)
	(cinematic_set_title escape)
	(sleep 150)
	(show_hud 1)
	(cinematic_show_letterbox 0)
	)
*;
