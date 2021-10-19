;///////////////////////////////////////////////////////////////
;////////////////////// BACKGROUND EVENTS //////////////////////
;///////////////////////////////////////////////////////////////

;***************************************************************
*************************** Bowls ******************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant background_bowls
	(if b_debug (print "starting up background_bowls"))
	
	(sleep_until (>= s_b1_progression 30))
		
	(sleep_until
		(begin
			(begin_random
				(begin
					(amb_bowls_phantom_escort01)
					(sleep (random_range 900 1800))
				)
				(begin
					(amb_bowls_phantom_escort02)
					(sleep (random_range 900 1800))
				)
			)
			
			;Make sure the phantoms / banshees get deleted before spawning them again
			(sleep 1800)
			
			(begin_random
				(begin
					(amb_bowls_phantom_escort01)
					(sleep (random_range 900 1800))
				)
				(begin
					(amb_bowls_phantom_escort02)
					(sleep (random_range 900 1800))
				)
			)
		1)
	)
)

(script static void background_bowls_cleanup
	(sleep_forever background_bowls)
	
	(ai_disposable cov_amb_bowls_phantom01 true)
	(ai_disposable cov_amb_bowls_phantom02 true)
	(ai_disposable cov_amb_bowls_banshee01 true)
	(ai_disposable cov_amb_bowls_banshee02 true)
)

(script static void amb_bowls_phantom_escort01
	(ai_place cov_amb_bowls_phantom01)
	(ai_force_active cov_amb_bowls_phantom01 true)
	(cs_run_command_script (ai_get_turret_ai cov_amb_bowls_phantom01 0) cs_do_nothing)		
	(sleep 240)
	(ai_place cov_amb_bowls_banshee01 1)
	(ai_force_active cov_amb_bowls_banshee01 true)
	(ai_place cov_amb_bowls_banshee02 1)
	(ai_force_active cov_amb_bowls_banshee02 true)
)

(script static void amb_bowls_phantom_escort02
	(ai_place cov_amb_bowls_phantom02)
	(ai_force_active cov_amb_bowls_phantom02 true)
	(cs_run_command_script (ai_get_turret_ai cov_amb_bowls_phantom02 0) cs_do_nothing)		
	(sleep 90)
	(ai_place cov_amb_bowls_banshee03 1)
	(ai_force_active cov_amb_bowls_banshee03 true)	
	(ai_place cov_amb_bowls_banshee04 1)
	(ai_force_active cov_amb_bowls_banshee04 true)
)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_amb_bowls_phantom_0
	(cs_enable_pathfinding_failsafe TRUE) 
	(cs_enable_targeting false)
	(cs_enable_looking false)
	(cs_shoot false)
	(cs_fly_by pts_amb_bowls/p0 10)
	(cs_fly_by pts_amb_bowls/p1 10)
	(cs_fly_by pts_amb_bowls/p2 10)
	(cs_fly_by pts_amb_bowls/p3 10)
	(cs_fly_to pts_amb_bowls/p4 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_amb_bowls_phantom_1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting false)
	(cs_enable_looking false)
	(cs_shoot false)
	(cs_fly_by pts_amb_bowls/p2 10)
	(cs_fly_by pts_amb_bowls/p1 10)
;	(cs_fly_by pts_amb_bowls/p3 10)
	(cs_fly_by pts_amb_bowls/p0 10)
	(cs_fly_by pts_amb_bowls/p5 1)
	
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_amb_bowls_banshee_0
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting false)
	(cs_enable_looking false)
	(cs_shoot false)
	(cs_vehicle_boost TRUE)
	(cs_fly_by pts_amb_bowls/p0 10)
	(cs_fly_by pts_amb_bowls/p1 10)
	(cs_fly_by pts_amb_bowls/p2 10)
	(cs_fly_by pts_amb_bowls/p3 10)
	(cs_vehicle_boost false)
	(cs_fly_to pts_amb_bowls/p4 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_amb_bowls_banshee_1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting false)
	(cs_enable_looking false)
	(cs_shoot false)
	(cs_vehicle_boost TRUE)
	(cs_fly_by pts_amb_bowls/p2 10)
	(cs_fly_by pts_amb_bowls/p1 10)
	(cs_fly_by pts_amb_bowls/p0 10)
	(cs_vehicle_boost false)
	(cs_fly_by pts_amb_bowls/p6 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script boost
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting false)
	(cs_enable_looking false)
	(cs_shoot false)
	(cs_vehicle_boost TRUE)
	(sleep 200)
	(cs_enable_moving TRUE)
	(sleep_forever)
)

;***************************************************************
*********************** Exploration ****************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant background_exploration
	(if b_debug (print "starting up background_exploration"))
	
	(flock_create flock_ex_banshee_right)
	(flock_create flock_ex_hornet_right)
	
	(sleep_until 
		(or
			(>= (device_get_position fp_exit_door) 0.01)
			(>= s_ex_progression 10)
		)
	10)
	
	(wake va_crashing_longsword)
	(sleep 30)
	
	;(ai_place cov_amb_ex_intro_banshees_0)
	;(ai_place cov_amb_ex_intro_banshees_1)
	
	(sleep_until (>= s_ex_progression 35))
	
	(flock_create flock_ex_banshee_over_right)
	(flock_create flock_ex_hornet_over_right)
	
	(sleep_until (>= s_ex_progression 40))
	;(ai_place cov_amb_ex_banshees_0)
	;(ai_place cov_amb_ex_banshees_1)
	
	(sleep_until 
		(and
			(>= s_ex_progression 60)
			(= (current_zone_set_fully_active) 4)
		)
	)
	(flock_create flock_aw_banshee)
	(flock_create flock_aw_hornet)
	
	(sleep_until 
		(or
			(>= s_aw_progression 30)
			b_fl_frigate_arrived
		)
	)
	(flock_stop flock_aw_banshee)

	(flock_create flock_ex_banshee_left)
	(flock_create flock_ex_hornet_left)
	(flock_create flock_ex_banshee_over_left)
	(flock_create flock_ex_hornet_over_left)	
)

(script static void background_exploration_cleanup
	(sleep_forever background_exploration)
	
	(flock_delete flock_ex_banshee_left)
	(flock_delete flock_ex_hornet_left)
	(flock_delete flock_ex_banshee_over_left)
	(flock_delete flock_ex_hornet_over_left)
	(flock_delete flock_ex_banshee_over_right)
	(flock_delete flock_ex_hornet_over_right)
	(flock_delete flock_ex_banshee_right)
	(flock_delete flock_ex_hornet_right)
	(flock_delete flock_aw_banshee)
	(flock_delete flock_aw_hornet)
)

;*(script dormant amb_ex_crashed_hornet
	(sleep_until (player_notice_flag vol_ex_sd_area flg_ex_crashing_longsword) 10 3600)
	
	(object_create ex_crashed_hornet)
	(sleep 1)
	(unit_set_enterable_by_player ex_crashed_hornet false)
	(object_set_velocity ex_crashed_hornet 17)
	(sleep 15)
	;(object_damage_damage_section ex_crashed_hornet hull 1)
)

(script dormant amb_ex_crashed_banshee
	(sleep_until (>= s_ex_progression 60) 5)
	
	(object_create ex_crashed_banshee)
	(sleep 1)
	(unit_set_enterable_by_player ex_crashed_banshee false)
	(object_set_velocity ex_crashed_banshee 19)
	(sleep 15)
	(object_damage_damage_section ex_crashed_banshee hull 1)
)
*;
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_amb_ex_intro_banshee_0
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_fly_to pts_amb_ex_intro_banshees/p0)
	(cs_fly_to pts_amb_ex_intro_banshees/p1)
	(cs_vehicle_boost false)
	(cs_fly_to pts_amb_ex_intro_banshees/p2)
	(cs_fly_to pts_amb_ex_intro_banshees/p3)
	(cs_fly_to pts_amb_ex_intro_banshees/p9)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_amb_ex_intro_banshee_1
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_fly_to pts_amb_ex_intro_banshees/p4)
	(cs_fly_to pts_amb_ex_intro_banshees/p5)
	(cs_vehicle_boost false)
	(cs_fly_to pts_amb_ex_intro_banshees/p6)
	(cs_fly_to pts_amb_ex_intro_banshees/p7)
	(cs_fly_to pts_amb_ex_intro_banshees/p8)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_amb_ex_banshee_0
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_fly_to pts_amb_ex_banshees/p0)
	(cs_fly_to pts_amb_ex_banshees/p2)
	(cs_fly_to pts_amb_ex_banshees/p4)
	(cs_fly_to pts_amb_ex_banshees/p6)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_amb_ex_banshee_1
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_boost true)
	(cs_fly_to pts_amb_ex_banshees/p1)
	(cs_fly_to pts_amb_ex_banshees/p3)
	(cs_fly_to pts_amb_ex_banshees/p5)
	(cs_fly_to pts_amb_ex_banshees/p7)
	(ai_erase (ai_get_squad ai_current_actor))
)

;***************************************************************
************************** LIGHTBRIDGE *************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant background_lightbridge
	(if b_debug (print "starting up background_lightbridge"))
	
	(sleep_until (>= s_lb_progression 40))
	
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_set_max_rumble 1 1)
	(player_effect_start 0.3 0.05)
	(sleep 20)
	(player_effect_stop 0.4)
	
	(sleep 90)
	(if 
		(and
			(not b_bb_scarab_over_head_created)
			(<= s_lb_progression 50)
		)
		(begin
			(sound_impulse_start "sound\device_machines\scarab\scarab_steps" lb_scarab_sound_0 10)
			(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_dust_fall_large\human_dust_fall_large.effect" pts_lb_scarab_step/p0)
			(player_effect_set_max_rotation 0 1 1)
			(player_effect_set_max_rumble 1 1)
			(player_effect_start 0.3 0.05)
			(sleep 20)
			(player_effect_stop 0.4)		
		)
	)
	(sleep 120)
	
	(if 
		(and
			(not b_bb_scarab_over_head_created)
			(<= s_lb_progression 50)
		)
		(begin
			(sound_impulse_start "sound\device_machines\scarab\scarab_steps" lb_scarab_sound_0 10)
			(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_dust_fall_large\human_dust_fall_large.effect" pts_lb_scarab_step/p3)
			(player_effect_set_max_rotation 0 1 1)
			(player_effect_set_max_rumble 1 1)
			(player_effect_start 0.3 0.05)
			(sleep 20)
			(player_effect_stop 0.4)
		)
	)
	
	(sleep 120)
	(if (not b_bb_scarab_over_head_created)
		(begin
			(sound_impulse_start "sound\device_machines\scarab\scarab_steps" lb_scarab_sound_1 10)
			(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_dust_fall_large\human_dust_fall_large.effect" pts_lb_scarab_step/p1)
			(player_effect_set_max_rotation 0 1 1)
			(player_effect_set_max_rumble 1 1)
			(player_effect_start 0.3 0.05)
			(sleep 20)
			(player_effect_stop 0.4)		
		)
	)
	
	(sleep 120)
	(if (not b_bb_scarab_over_head_created)
		(begin
			(sound_impulse_start "sound\device_machines\scarab\scarab_steps" lb_scarab_sound_2 10)
			(effect_new_at_ai_point "fx\scenery_fx\ceiling_dust\human_dust_fall_large\human_dust_fall_large.effect" pts_lb_scarab_step/p2)
			(player_effect_set_max_rotation 0 1 1)
			(player_effect_set_max_rumble 1 1)
			(player_effect_start 0.3 0.05)
			(sleep 20)
			(player_effect_stop 0.4)		
		)
	)
)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------

;***************************************************************
************************** SHAFT *******************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant background_shaft
	(if b_debug (print "starting up background_shaft"))
	
	(sleep_until (> s_f4_progression 0))
	(flock_create flock_shaft_banshee)
	(flock_create flock_shaft_hornet)
	
	(sleep_until b_f5_combat_finished)
	;The hornets are winning the fight! (stop spawning banshees)
	(flock_stop flock_shaft_banshee)
)

(script static void background_shaft_cleanup
	(sleep_forever background_shaft)
	
	(flock_delete flock_shaft_banshee)
	(flock_delete flock_shaft_hornet)
)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------