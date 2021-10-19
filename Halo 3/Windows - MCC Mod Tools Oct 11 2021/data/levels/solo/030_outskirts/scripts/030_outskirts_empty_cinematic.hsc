
;==============================================================
;==========Outskirts Mission Script============================
;==============================================================


(script static void ex_cruiser		

	(switch_zone_set de)
	(wake sc_bridge_cruiser)
)
			
;script to place and fly around the cruisers over the ark
(script dormant sc_bridge_cruiser
	(object_create_anew ark_cruiser_01)
	(object_set_always_active ark_cruiser_01 TRUE)
	(object_cinematic_visibility ark_cruiser_01 TRUE)
	(object_create_anew ark_cruiser_02)
	(object_set_always_active ark_cruiser_02 TRUE)
	(object_cinematic_visibility ark_cruiser_02 TRUE)
	(sleep 1)
	(scenery_animation_start_loop ark_cruiser_01 objects\vehicles\cov_cruiser\cinematics\vignettes\030vb_excavation\030vb_excavation "cinematic_cov_cruiser")
	(object_set_custom_animation_speed ark_cruiser_01 0.009)
	(object_cinematic_visibility ark_cruiser_01 TRUE)
	(scenery_animation_start_at_frame_loop ark_cruiser_02 objects\vehicles\cov_cruiser\cinematics\vignettes\030vb_excavation\030vb_excavation "cinematic_cov_cruiser1" 10)
	(object_set_custom_animation_speed ark_cruiser_02 0.01)
	(object_cinematic_visibility ark_cruiser_02 TRUE)	
)

(script static void overhead_cruiser
	(object_create_anew cruiser_flyover)
	(object_set_always_active cruiser_flyover TRUE)
	(object_cinematic_visibility cruiser_flyover TRUE)
	(sleep 1)

	;(wake sc_bridge_rumble)

	(scenery_animation_start cruiser_flyover objects\vehicles\cov_cruiser\cinematics\vignettes\030vc_cruiser_overhead\030vc_cruiser_overhead "cruiser")
	(object_set_custom_animation_speed cruiser_flyover 0.15)
)
