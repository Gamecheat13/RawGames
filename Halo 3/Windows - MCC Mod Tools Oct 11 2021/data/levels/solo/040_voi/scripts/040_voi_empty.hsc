(global boolean g_longsword_go FALSE)

(script startup voi_empty
	(wake sc_bridge_cruiser)
	(wake gs_cinematic_lights)
	(sleep_forever)
)

;script to place and fly around the cruisers over the ark
(script dormant sc_bridge_cruiser
	(print "cruiser is awake")
	(object_create_anew ark_cruiser_01)
	(object_create_anew ark_cruiser_02)
	(sleep 1)
	(scenery_animation_start_loop ark_cruiser_01 objects\vehicles\cov_cruiser\cinematics\vignettes\030vb_excavation\030vb_excavation "cinematic_cov_cruiser")
	(object_set_custom_animation_speed ark_cruiser_01 0.009)
	(object_cinematic_visibility ark_cruiser_01 TRUE)
	(scenery_animation_start_at_frame_loop ark_cruiser_02 objects\vehicles\cov_cruiser\cinematics\vignettes\030vb_excavation\030vb_excavation "cinematic_cov_cruiser1" 10)
	(object_set_custom_animation_speed ark_cruiser_02 0.01)
	(object_cinematic_visibility ark_cruiser_02 TRUE)
)

(script dormant gs_cinematic_lights
	(cinematic_light_object ark "" lighting_ark light_anchor)
	(cinematic_light_object ark_cruiser_01 "" lighting_ships light_anchor)
	(cinematic_light_object ark_cruiser_02 "" lighting_ships light_anchor)
	(cinematic_light_object truth_ship "" lighting_ships light_anchor)
	(cinematic_light_object storm "" lighting_storm light_anchor)
	(cinematic_light_object clouds_ark "" lighting_clouds light_anchor)
	(cinematic_lighting_rebuild_all)
)  

(script dormant test_ark
	(sleep_until
		(begin
			(pvs_set_object ark)
			(device_set_position ark 1)
			(sleep_until (>= (device_get_position ark) 1) 1)
			(sleep (* 30 5))
			(device_set_position_immediate ark 0)
			FALSE
		)
	)
)

(script static void test_bfg
	; switch to correct zone set
	(switch_zone_set 070)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_bfg_player0)
	
	(wake BFG_go)
)

(script dormant BFG_go
	(object_create bfg_turret)
	(objects_attach bfg_base "turret" bfg_turret "")
	(device_set_position_track bfg_base position 0)
	(device_set_overlay_track bfg_base power)
	(device_set_position_track bfg_turret position 0)
	(device_set_overlay_track bfg_turret power)
	(device_animate_overlay bfg_base .4 0 0 0)
	(device_animate_overlay bfg_turret 0 0 0 0)
	(wake BFG_shoot)
)

(script dormant BFG_shoot
	(sleep_until
		(begin
			;shooting down the longsword
			;(sleep_until g_bfg_longsword 1)
			(print "BFG longsword GO!")
			(set g_longsword_go TRUE)
			;(vig_crashing_longsword)
			(device_animate_overlay bfg_base .4 1.5 .5 .5)
			(sleep 45)
			(BFG_fire)
			(sleep_until (not g_longsword_go) 1)
			FALSE
		)
	)
)

(script static void BFG_fire
	(print "BFG fire")
	;(sound_impulse_start sound\weapons\covy_gun_tower\c_gun_tower_charge bfg_base 3)
	(effect_new_on_object_marker "objects\levels\shared\bfg\fx\firing_fx\bfg_foot_dust.effect" bfg_base "fx_foot")
	(BFG_shoot_anim)
)

(script static void BFG_shoot_anim
	(print "BFG fire")
	(device_animate_overlay bfg_turret 1 3 0 0)
	(sleep 60)
	(BFG_vent)
	(print "vent done")
	(device_animate_overlay bfg_turret 0 0 0 0)
)

(script static void BFG_vent
	(device_animate_position bfg_base 1 .35 0.2 .5 TRUE)
	(sleep (random_range 20 40))
	;look around to keep it moving:
	(device_animate_overlay bfg_base (real_random_range .4 .43) (random_range 2 5) .5 .5)
	;(device_animate_overlay bfg_turret (random_range 0 1) (random_range 2 5) .1 .1)
	;call effects
	(if (volume_test_players vol_bfg_marine02)
		;if player is near the bfg
		(sleep 140)
		;if player is trying to kill bfg for afar- fuck that shit!
		(sleep 60)
	)
	;(device_set_position_track bfg_base position 0)
	(if (> (object_get_health bfg_base) 0)
		(device_animate_position bfg_base 0 1.2 0.25 1 true)
		;(device_animate_position bfg_base 0 1.2 0 1 true)
	)
)

(script continuous vig_crashing_longsword
	(sleep_until g_longsword_go 1)
	(sleep 30)
	(print "vignette:va_crashing_longsword")
	(object_create cin_longsword)
	(object_cinematic_visibility cin_longsword TRUE)
	(object_set_always_active cin_longsword TRUE)
	;(sleep 1)
	(ai_disregard cin_longsword TRUE)
	;(effect_new "fx\scenery_fx\explosions\human_explosion_huge\human_explosion_huge.effect" cin_longsword_explosion)
	(scenery_animation_start_relative cin_longsword objects\vehicles\longsword\cinematics\vignettes\040vc_crashing_longsword\040vc_crashing_longsword "040vc_crashing_longsword" cin_longsword_start)
	
	(sleep 110)
	;screen shake
	(print "boom")
	;(set game_speed 0)
	(player_effect_set_max_rotation 0 0.5 0.5)
	(player_effect_set_max_rumble 1 1)
	(player_effect_start 0.50 0.05)
	(sleep 20)
	(player_effect_stop 0.5)
	
	(sleep 100)
	;(wake br_ark_is_bad)
	(sleep 100)
	(object_destroy cin_longsword)
	
	;(sleep 40)
	;screen shake
	(print "boom")
	(player_effect_set_max_rotation 0 0.5 0.5)
	(player_effect_set_max_rumble 1 1)
	(player_effect_start 0.50 0.05)
	(sleep 20)
	(player_effect_stop 0.5)
	(set g_longsword_go FALSE)
)

(script static void objects
	(print "placing all objects")
	(object_create_folder scenery_intro)
	(object_create_folder crates_intro)
	(object_create_folder scenery_faa)
	(object_create_folder crates_faa)
	(object_create_folder scenery_laa)
	(object_create_folder crates_laa)
	(object_create_folder scenery_fab)
	(object_create_folder crates_fab)
	(object_create_folder scenery_lab)
	(object_create_folder crates_lab)
	(object_create_folder scenery_office)
	(object_create_folder crates_office)
	(object_create_folder scenery_ware)
	(object_create_folder crates_ware)
	(object_create_folder scenery_worker)
	(object_create_folder crates_worker)
)