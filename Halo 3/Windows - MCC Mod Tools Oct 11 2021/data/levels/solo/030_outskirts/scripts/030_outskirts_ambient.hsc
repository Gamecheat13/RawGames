;=======================================================
;==========Global Ambient===============================
;=======================================================

(global boolean b_truth FALSE)
(global short s_truth_count 0)
(global short s_truth_limit 7)

(script static void gs_crash_truth_flicker
	(set b_truth FALSE)
	(set s_truth_count 0)
	(sleep_until
		(begin
			(object_hide crash_truth_biped FALSE)
			(object_hide crash_truth_throne FALSE)
			(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
				(sleep (random_range 4 15))
			(object_hide crash_truth_biped true)
			(object_hide crash_truth_throne true)
			(set s_truth_count (+ s_truth_count 1))
			(if (= s_truth_limit s_truth_count) (set b_truth TRUE))
		b_truth)
	(random_range 1 10))
)

(script static void gs_exit_truth_flicker
	(set b_truth FALSE)
	(set s_truth_count 0)
	(sleep_until
		(begin
			(object_hide exit_truth_biped FALSE)
			(object_hide exit_truth_throne FALSE)
			(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
				(sleep (random_range 4 15))
			(object_hide exit_truth_biped true)
			(object_hide exit_truth_throne true)
			(set s_truth_count (+ s_truth_count 1))
			(if (= s_truth_limit s_truth_count) (set b_truth TRUE))
		b_truth)
	(random_range 1 10))
)

;=======================================================
;==========Elevator Room Ambient========================
;=======================================================

(global ai act_sarge NONE)
(global ai act_doorman NONE)
(global ai act_blastdoor NONE)
(global ai act_question NONE)
(global ai act_mechanic NONE)
(global ai act_recruit_01 NONE)
(global ai act_recruit_02 NONE)
(global ai act_recruit_03 NONE)
(global ai act_cough_01 NONE)
(global ai act_cough_02 NONE)
(global ai act_cough_03 NONE)
(global ai act_cough_04 NONE)
(global ai act_cough_05 NONE)
(global ai act_cough_06 NONE)
(global ai act_cough_07 NONE)
(global ai act_cough_08 NONE)
(global ai act_response_01 NONE)
(global ai act_response_02 NONE)
(global ai act_response_03 NONE)
(global ai act_response_04 NONE)
(global ai act_response_05 NONE)

(global ai act_elev_rand01 NONE)
(global ai act_elev_chat_01a NONE)
(global ai act_elev_chat_01b NONE)
(global ai act_elev_medic_01 NONE)
(global ai act_elev_hurt_01 NONE)
(global ai act_elev_medic_02 NONE)
(global ai act_elev_hurt_02 NONE)
(global ai act_elev_gunlight_01 NONE)
(global ai act_elev_gunlight_02 NONE)
(global ai act_elev_gunlight_03 NONE)
(global ai act_elev_gunlight_04 NONE)
(global ai act_elev_gunlight_05 NONE)

(global boolean b_elev_doorman_started 0)
(global boolean b_elev_mountup 0)
(global boolean b_elev_door_impulse 0)
(global boolean b_elev_door_down 0)
(global boolean b_elev_lights_on 0)
(global boolean b_elev_sarge_start 0)
(global boolean b_elev_prompt 0)
(global boolean b_elev_blast_door 0)

(global short s_cough_spacing 0)
(global short s_elev_random 0)
(global short s_elev_flashlight 0)
(global short s_elev_flashlight_off 0)

(global real r_cough_mod 0.25)
(global real r_cough_vol 1.0)

;opening script for the timing of the start of the level
(script dormant sc_elev_opening

	(sv_elev_explosion_big)
	(sleep (random_range 20 45))
	
	(sleep 90)
	;(wake sc_elev_cough)
	;(sleep 60)
	
	(wake sc_elev_title1)
	
	(player_enable_input true)
	(player_camera_control true)	
	
	(print "calling the gun light script")
	(wake sc_elev_gunlights)		
	(wake sc_elev_initial_comment)
	
	(sleep 120)
	(wake 030_music_01_start)
	
	(player_action_test_reset)
	
	(sv_elev_explosion_small)
	(wake sc_elev_random_explosion)
	
	(sleep 90)
	
	;(wake sc_elev_brief01)
	(wake sc_elev_brief01_sound)	
	
	(sleep 600)
	
	(print "calling flashlight hint")
	(if 
		(or 
			(= (unit_in_vehicle (player0) ) 1)
			(= (unit_in_vehicle (player1) ) 1)
			(= (unit_in_vehicle (player2) ) 1)
			(= (unit_in_vehicle (player3) ) 1)
		)
		(print "empty")
		(player_training_activate_flashlight)
	)
	
)

;title bar script
(script dormant sc_elev_title1
	;(sleep 135)
	(sleep 75)
	(cinematic_fade_to_title_slow)
	(cinematic_set_title title_1)
	(cinematic_title_to_gameplay)
)

;splosion
(script static void sv_elev_explosion_big
	(player_effect_set_max_rotation 1 1 1)
	(player_effect_set_max_rumble 1 1)
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl2.sound" NONE 1)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion01)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion02)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion03)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion04)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion05)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion06)
	
	(player_effect_start 1 1)
	(sleep 30)
	(player_effect_stop 2)
)



;splosion
(script static void sv_elev_explosion_small
	(player_effect_set_max_rotation 1 1 1)
	(player_effect_set_max_rumble 1 1)
	(sound_impulse_start "sound\levels\020_base\base_scripted_expl2.sound" NONE 0.5)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion01)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion02)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion03)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion04)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion05)
	(effect_new "fx\scenery_fx\ceiling_dust\human_dust_fall_small_outskirts\human_dust_fall_small_outskirts.effect" elev_explosion06)
	
	(player_effect_start 0.75 1)
	(sleep 20)
	(player_effect_stop 1.5)
)

;randomly calls small explosions around
(script dormant sc_elev_random_explosion
	(sleep_until
		(begin
			(sleep (random_range 300 1500))
			(sv_elev_explosion_small)
		(>= s_cavern_obj_control 5) )
	)
)

;initial spawn script and vignette script calls
(script dormant sc_elev_init
	(sleep 10)
	(wake sc_elev_init_spawn)
	(wake sc_elev_hurt_spawn)
	(sleep 10)
	(wake sc_elev_door_open)

)

;setting states for objects
(script dormant sc_elev_set_states
	(object_set_region_state camera01 "" destroyed)
	(object_set_region_state camera02 "" destroyed)
)

;spawns the initial marines
(script dormant sc_elev_init_spawn
	(ai_place sq_elev_sarge)
	(ai_place sq_elev_mar)
	(sleep 1)	
	
	(ai_place sq_elev_doorman)	
	(ai_place sq_elev_mech)
	(sleep 1)
	(if (= (game_coop_player_count) 1)
		(begin
			(ai_place sq_elev_warthog1)
			(ai_place sq_elev_warthog2)			
		)
		(begin
			(ai_place sq_elev_warthog1)
			(ai_place sq_elev_warthog3)
		)
	)
	(sleep 1)

)	

;script to spawn the hurt marines
(script dormant sc_elev_hurt_spawn
	(ai_place sq_elev_hurt01)
	(ai_place sq_elev_hurt02)
	(sleep 1)
	(ai_place sq_elev_hurt03)
	(ai_place sq_elev_hurt04)
	(sleep 1)
	(ai_place sq_elev_hurt05)
)	

;script to control the gun lights for marines
(script dormant sc_elev_gunlights
	(print "in gunlights")
	
	(ai_set_weapon_up sq_elev_doorman/doorguy 1)
	(ai_set_weapon_up sq_elev_mech/mech 1)
	(ai_set_weapon_up sq_elev_mar/01 1)
	(ai_set_weapon_up sq_elev_mar/02 1)
	;(ai_set_weapon_up sq_elev_mar/03 1)
	
	;(object_set_function_variable (ai_get_object sq_elev_doorman/doorguy) "integrated_light_power" 1 0)
	(unit_set_integrated_flashlight (ai_get_unit sq_elev_doorman/doorguy) TRUE)
	(sleep (random_range 45 90) )
	
	;(object_set_function_variable (ai_get_object sq_elev_mech/mech) "flashlight_intensity" 1 0)
	(unit_set_integrated_flashlight (ai_get_unit sq_elev_mech/mech) TRUE)
	(sleep (random_range 30 45) )
	
	;(object_set_function_variable (ai_get_object sq_elev_mar/01) "flashlight_intensity" 1 0)
	(unit_set_integrated_flashlight (ai_get_unit sq_elev_mar/01) TRUE)
	(sleep (random_range 10 25) )
	
	;(object_set_function_variable (ai_get_object sq_elev_mar/02) "flashlight_intensity" 1 0)
	(unit_set_integrated_flashlight (ai_get_unit sq_elev_mar/02) TRUE)
	(sleep (random_range 10 45) )
	
	;(object_set_function_variable (ai_get_object sq_elev_mar/03) "flashlight_intensity" 1 0)
	;(unit_set_integrated_flashlight (ai_get_unit sq_elev_mar/03) TRUE)
	
	;*
	(set s_elev_flashlight (random_range 0 3) )
	(if (= s_elev_flashlight 0)
		(begin
			(object_set_function_variable (ai_get_object sq_elev_doorman/doorguy) "flashlight_intensity" 1 0)
			(sleep (random_range 45 90) )
			(object_set_function_variable (ai_get_object sq_elev_mech/mech) "flashlight_intensity" 1 0)
			(sleep (random_range 30 45) )
			(object_set_function_variable (ai_get_object sq_elev_mar/01) "flashlight_intensity" 1 0)
			(sleep (random_range 10 25) )
			(object_set_function_variable (ai_get_object sq_elev_mar/02) "flashlight_intensity" 1 0)
			(sleep (random_range 10 45) )
			(object_set_function_variable (ai_get_object sq_elev_mar/03) "flashlight_intensity" 1 0)	
		)
	)
	(if (= s_elev_flashlight 1)	
		(begin
			(object_set_function_variable (ai_get_object sq_elev_mech/mech) "flashlight_intensity" 1 0)
			(sleep (random_range 45 90) )
			(object_set_function_variable (ai_get_object sq_elev_doorman/doorguy) "flashlight_intensity" 1 0)
			(sleep (random_range 30 45) )
			(object_set_function_variable (ai_get_object sq_elev_mar/02) "flashlight_intensity" 1 0)
			(sleep (random_range 10 25) )
			(object_set_function_variable (ai_get_object sq_elev_mar/03) "flashlight_intensity" 1 0)
			(sleep (random_range 10 45) )
			(object_set_function_variable (ai_get_object sq_elev_mar/01) "flashlight_intensity" 1 0)
		)
	)
	(if (= s_elev_flashlight 2)	
		(begin
			(object_set_function_variable (ai_get_object sq_elev_mech/mech) "flashlight_intensity" 1 0)
			(sleep (random_range 45 90) )
			(object_set_function_variable (ai_get_object sq_elev_doorman/doorguy) "flashlight_intensity" 1 0)
			(sleep (random_range 30 45) )
			(object_set_function_variable (ai_get_object sq_elev_mar/03) "flashlight_intensity" 1 0)
			(sleep (random_range 10 25) )
			(object_set_function_variable (ai_get_object sq_elev_mar/01) "flashlight_intensity" 1 0)
			(sleep (random_range 10 45) )
			(object_set_function_variable (ai_get_object sq_elev_mar/02) "flashlight_intensity" 1 0)
		)
	)
	(if (= s_elev_flashlight 3)		
		(begin
			(object_set_function_variable (ai_get_object sq_elev_doorman/doorguy) "flashlight_intensity" 1 0)
			(sleep (random_range 45 90) )
			(object_set_function_variable (ai_get_object sq_elev_mech/mech) "flashlight_intensity" 1 0)
			(sleep (random_range 30 45) )
			(object_set_function_variable (ai_get_object sq_elev_mar/03) "flashlight_intensity" 1 0)
			(sleep (random_range 10 25) )
			(object_set_function_variable (ai_get_object sq_elev_mar/02) "flashlight_intensity" 1 0)
			(sleep (random_range 10 45) )
			(object_set_function_variable (ai_get_object sq_elev_mar/01) "flashlight_intensity" 1 0)
		)
	)
	*;
)

;script to turn off the gun lights
(script dormant sc_elev_gunlights_off
	(sleep (random_range 120 150) )
	(unit_set_integrated_flashlight (ai_get_unit sq_elev_doorman/doorguy) FALSE)
	(sleep (random_range 30 45) )
	(unit_set_integrated_flashlight (ai_get_unit sq_elev_mar/01) FALSE)
	(sleep (random_range 30 45) )
	(unit_set_integrated_flashlight (ai_get_unit sq_elev_mar/02) FALSE)
	;(sleep (random_range 30 45) )
	;(unit_set_integrated_flashlight (ai_get_unit sq_elev_mar/03) FALSE)
	(sleep (random_range 30 45) )
	(unit_set_integrated_flashlight (ai_get_unit sq_elev_mech/mech) FALSE)	
)

;second round of dialog in initial room
(script dormant sc_elev_second_dialog

	(sleep (random_range 45 75) )
	(wake sc_elev_random_comment)	
	(sleep 120)

	(begin_random
		(begin
			(sleep (random_range 45 60))
			(wake sc_elev_chatter_01)
		)
		(begin
			(sleep (random_range 45 60))
			(wake sc_elev_chatter_02)
		)
	)
)

;this is main script to get the door opened
(script dormant sc_elev_door_open
	(vs_cast sq_elev_sarge TRUE 10 "030MA_040")
	(set act_sarge (vs_role 1))
	(vs_cast sq_elev_doorman TRUE 10 "030VA_020")
	(set act_doorman (vs_role 1))
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(sleep 1)

	(vs_abort_on_damage TRUE)	
	(vs_enable_pathfinding_failsafe act_sarge TRUE)	
	(vs_movement_mode act_sarge 0)
	(vs_movement_mode act_doorman 1)	

	(sleep_until 
		(or
			(= b_elev_sarge_start 1) 
			(>= s_elevator_obj_control 3)
		)		
	1)
	
	(if (<= s_elevator_obj_control 2) ;previously tested (= b_elev_door 0)
		(begin
			(vs_go_to_and_face act_sarge TRUE elev_room_pts/p7 elev_room_pts/p8)
		)
	)
	
	(if (<= s_elevator_obj_control 2) ;previously tested (= b_elev_door 0)
		(begin	
			(vs_face act_sarge TRUE elev_room_pts/p8)
		)
	)		
		
	(if (<= s_elevator_obj_control 2) ;previously tested (= b_elev_door 0)
		(begin
			(vs_shoot_point act_sarge TRUE elev_room_pts/p17)
			(sleep 20)
		)
	)
	
	(vs_shoot_point act_sarge FALSE elev_room_pts/p17)
					
	(if (<= s_elevator_obj_control 2) ;previously tested (= b_elev_door 0)
		(begin
			(print "SARGE:  Settle down, Marines!")
			(vs_play_line act_sarge TRUE 030MA_040)
			(sleep 10)
		)
	)
	
	(if (<= s_elevator_obj_control 2) ;previously tested (= b_elev_door 0)
		(begin
			(print "SARGE:  Somebody hit the emergency power!")
			(vs_play_line act_sarge TRUE 030MA_050)
		)
	)

	;wakes the mechanic to run to the power generator
	(wake sc_elev_mech)

	;wakes the ambient dialog scripts
	(wake sc_elev_medic_01)
	(wake sc_elev_medic_02)
	
	(wake sc_elev_second_dialog)

	(sleep_until (>= s_elevator_obj_control 3) 1 450)

	(set b_elev_lights_on 1)
	(ai_set_weapon_up sq_elev_doorman 0)		
	(ai_set_weapon_up sq_elev_sarge 0)	
	
	;wakes the script to line everyone up
	(wake sc_elev_lineup)

)

;keeping this guy around, in case
(script dormant sc_elev_backup_for_door
	(if (> (object_get_health elev_room_bash_door) .2)
		(begin
			
			(if (> (object_get_health elev_room_bash_door) .2)
				(vs_go_to act_doorman TRUE elev_door/p7 1)
			)
			
			(if (> (object_get_health elev_room_bash_door) .2)
				(vs_go_to_and_face act_doorman TRUE elev_door/p0 elev_door/p6)	
			)
			
			(if 				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin			
					(vs_aim act_doorman TRUE elev_door/p1)
					(sleep (random_range 30 45))
				)
			)
			
			(if 				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin
					(vs_aim act_doorman TRUE elev_door/p2)
					(sleep (random_range 30 45))
				)
			)				
			
			(if  				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin
					(vs_aim act_doorman TRUE elev_door/p4)
					(sleep (random_range 30 45))
				)
			)

			(if  				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin			
					(vs_aim act_doorman TRUE elev_door/p1)
					(sleep (random_range 30 45))
				)
			)
			
			(if  				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin
					(vs_aim act_doorman TRUE elev_door/p2)
					(sleep (random_range 30 45))
				)
			)				
			
			(if  				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin
					(vs_aim act_doorman TRUE elev_door/p4)
					(sleep (random_range 30 45))
				)
			)

			(if  				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin			
					(vs_aim act_doorman TRUE elev_door/p1)
					(sleep (random_range 30 45))
				)
			)
			
			(if  				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin
					(vs_aim act_doorman TRUE elev_door/p2)
					(sleep (random_range 30 45))
				)
			)				
			
			(if  				
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_players tv_elev_door) 0)
				)
				(begin
					(vs_aim act_doorman TRUE elev_door/p4)
					(sleep (random_range 30 45))
				)
			)			
			
			(if (> (object_get_health elev_room_bash_door) .2)
				(begin
					(vs_aim act_doorman FALSE elev_door/p4)
					(sleep 10)
				)
			)
			
			(if (> (object_get_health elev_room_bash_door) .2)
				(set b_elev_doorman_started 1)
			)
						
			(if 
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_object tv_elev_check (ai_get_object sq_elev_doorman) ) 1)
				)
				(begin
					(print "in stuckdoor_enter")
					(vs_custom_animation act_doorman TRUE objects\characters\marine\marine_female\cinematics\vignettes\030va_stuckdoor\030va_stuckdoor "030va_stuckdoor_enter" TRUE elev_door/p0)
				)
			)
		
			(if 
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_object tv_elev_check1 (ai_get_object sq_elev_doorman) ) 1)
				)
				(begin
					(print "in stuckdoor_shove")
					(vs_custom_animation act_doorman TRUE objects\characters\marine\marine_female\cinematics\vignettes\030va_stuckdoor\030va_stuckdoor "030va_stuckdoor_shove" TRUE elev_door/p0)
				)
				(begin
					(print "in stuckdoor_exit")
					(vs_custom_animation act_doorman TRUE objects\characters\marine\marine_female\cinematics\vignettes\030va_stuckdoor\030va_stuckdoor "030va_stuckdoor_exit" TRUE elev_door/p0)
				)
			)
		
			(if 
				(and
					(> (object_get_health elev_room_bash_door) .2)
					(= (volume_test_object tv_elev_check1 (ai_get_object sq_elev_doorman) ) 1)
				)
				(begin
					(print "in stuckdoor_success")
					(vs_custom_animation act_doorman FALSE objects\characters\marine\marine_female\cinematics\vignettes\030va_stuckdoor\030va_stuckdoor "030va_stuckdoor_success" TRUE elev_door/p0)
					(sleep 25)			
					(set b_elev_door_impulse 1)
				)
				(begin
					(print "in stuckdoor_helped")
					(vs_custom_animation act_doorman TRUE objects\characters\marine\marine_female\cinematics\vignettes\030va_stuckdoor\030va_stuckdoor "030va_stuckdoor_helped" TRUE elev_door/p0)
				)		
			)												

			(vs_stop_custom_animation act_doorman)
			(ai_dialogue_enable TRUE)
		)
	)
	
	(if (= b_elev_door_down 0)
		(begin
			(vs_stop_custom_animation act_doorman)
			(vs_aim act_doorman FALSE elev_door/p4)
			(sleep 10)
		)
	)

	(if (= b_elev_doorman_started 1)
		(begin
			(if (< (object_get_health elev_room_bash_door) .2)
				(begin
					(ai_dialogue_enable FALSE)
					(print "MARINE:  Sure, after I got it started...")
					(vs_play_line act_doorman TRUE 030VA_050)
					(sleep 20)
	
					(set b_elev_lights_on 1)
					(ai_set_weapon_up sq_elev_doorman 0)		
					(ai_set_weapon_up sq_elev_sarge 0)	
					
					;wakes the script to line everyone up
					(wake sc_elev_lineup)
				)
				(begin
					(vs_custom_animation act_doorman FALSE objects\characters\marine\marine "combat:rifle:smash_right" TRUE) 
					(sleep 10)
					(vs_stop_custom_animation act_doorman)
					(set b_elev_door_impulse 1)
					(ai_dialogue_enable FALSE)
					(print "MARINE:  There it goes.")
					(vs_play_line act_doorman TRUE 030VA_060)
					(sleep 20)
	
					(set b_elev_lights_on 1)
					(ai_set_weapon_up sq_elev_doorman 0)		
					(ai_set_weapon_up sq_elev_sarge 0)	
					
					;wakes the script to line everyone up
					(wake sc_elev_lineup)
				)
			)
		)
	)
	(ai_dialogue_enable TRUE)
	
)

;script to give the swinging door an impulse to knock it over
(script dormant sc_elev_door_impulse
	(sleep_until
		(or
			(< (object_get_health elev_room_bash_door) .33)
			(= b_elev_door_impulse 1)
			(>= s_elevator_obj_control 2)
		)
	1)
		(object_set_velocity elev_room_bash_door -2 0 0)
		(sleep 5)
		(object_damage_damage_section elev_room_bash_door "door" 1000)
		(sleep 60)
		(set b_elev_door_down 1)
		
		;wakes the script to turn on the lights
		(wake sc_elev_lights1)
		
		;wakes the script to line everyone up
		(wake sc_elev_lineup)
)

;script for the mechanic
(script dormant sc_elev_mech
	(vs_cast sq_elev_mech TRUE 10 "030MA_060")
	(set act_mechanic (vs_role 1))
	(vs_set_cleanup_script gs_dialogue_cleanup)
	
	(vs_abort_on_damage TRUE)
	(vs_enable_pathfinding_failsafe act_mechanic TRUE)
	(vs_movement_mode act_mechanic 1)	
	
	(ai_dialogue_enable FALSE)
	(print "MARINE:  On it, sarge!")
	(vs_play_line act_mechanic FALSE 030MA_060)
	(ai_dialogue_enable TRUE)

	(vs_go_to act_mechanic FALSE elev_room_pts/p32 1)
	(vs_go_to act_mechanic FALSE elev_room_pts/p31 1)
	(vs_go_to_and_face act_mechanic FALSE elev_room_pts/p9 elev_room_pts/p10)	
	
	;sleep until a short is set in the sc_elev_sarge script or when player enters hallway
	(sleep_until (= b_elev_lights_on 1) 1)	
	
	(object_create generator_startup)
	(sleep 180)
	(wake sc_elev_lights1)
	(ai_set_weapon_up sq_elev_mech 0)	
)

;script to turn off the lights
(script dormant sc_elev_lights1
	(sleep (random_range 20 45) )
	;(set render_patchy_fog 1)
	(sleep (random_range 20 45) )
	(wake sc_elev_hoglights4)
	(sleep (random_range 20 45) )
	;(wake sc_elev_hoglights5)
	;(sleep (random_range 20 45) )
	(wake sc_elev_hanglights1)
)	
	
;script to turn on the lights around the hog(s)
(script dormant sc_elev_lights2	
	(sleep_until (>= s_elevator_obj_control 2) 1)		
		(wake sc_elev_hoglights1)
		(wake sc_elev_hoglights2)
		(sleep (random_range 60 120))
		(wake sc_elev_hanglights2)
)

;script to line up the troops in the warthog room
(script dormant sc_elev_lineup
	(vs_cast sq_elev_sarge FALSE 20 "030MB_010")
	(set act_sarge (vs_role 1))
	
	(vs_cast sq_elev_doorman FALSE 20 "030MB_120")
	(set act_recruit_01 (vs_role 1))
	
	(vs_cast sq_elev_mech TRUE 20 "030MB_120")
	(set act_mechanic (vs_role 1))
	
	(vs_cast sq_elev_mar FALSE 20 "030MB_020" "030MB_120" )
	(set act_question (vs_role 1))
	(set act_recruit_02 (vs_role 2))
	;(set act_recruit_03 (vs_role 3))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(sleep 1)		

	(vs_abort_on_damage TRUE)
	
	(vs_enable_pathfinding_failsafe act_sarge TRUE)
	(vs_enable_pathfinding_failsafe act_mechanic TRUE)
	(vs_enable_pathfinding_failsafe act_question TRUE)
	(vs_enable_pathfinding_failsafe act_recruit_01 TRUE)
	(vs_enable_pathfinding_failsafe act_recruit_02 TRUE)
	(vs_enable_pathfinding_failsafe act_recruit_03 TRUE)
	
	(vs_movement_mode act_sarge 0)
	(vs_movement_mode act_mechanic 1)
	(vs_movement_mode act_question 1)
	(vs_movement_mode act_recruit_01 1)
	(vs_movement_mode act_recruit_02 1)
	(vs_movement_mode act_recruit_03 1)
	
	(ai_set_weapon_up act_sarge 0)
	(ai_set_weapon_up act_mechanic 0)
	(ai_set_weapon_up act_question 0)
	(ai_set_weapon_up act_recruit_01 0)
	(ai_set_weapon_up act_recruit_02 0)
	(ai_set_weapon_up act_recruit_03 0)

	(vs_custom_animation act_sarge FALSE objects\characters\marine\marine "combat:rifle:signal_attack" TRUE)
	(vs_stop_custom_animation act_sarge)		

	(ai_dialogue_enable FALSE)
	(print "SARGE:  If you can walk, set your boots on the line!")
	(vs_play_line act_sarge FALSE 030MB_010)
	(vs_stow act_sarge)
	(ai_dialogue_enable TRUE)
					
	(if (= b_elev_mountup 0)
		(begin
			(vs_go_to_and_face act_sarge FALSE elev_room_pts/p11 elev_room_pts/p13)
			(vs_go_to_and_face act_question FALSE elev_room_pts/p0 elev_room_pts/p12)
			(vs_go_to_and_face act_mechanic FALSE elev_room_pts/p4 elev_room_pts/p12)
			(vs_go_to_and_face act_recruit_01 FALSE elev_room_pts/p1 elev_room_pts/p12)
			(vs_go_to_and_face act_recruit_02 FALSE elev_room_pts/p2 elev_room_pts/p12)
			(vs_go_to_and_face act_recruit_03 FALSE elev_room_pts/p3 elev_room_pts/p12)	
		)
	)
	(if (= b_elev_mountup 0)
		(sleep 60)
	)
	
	(sleep_until
		(or
			(AND
				(= (vs_running_atom act_question) FALSE)
				(= (vs_running_atom act_mechanic) FALSE)
				(= (vs_running_atom act_recruit_01) FALSE)
				(= (vs_running_atom act_recruit_02) FALSE)
				(= (vs_running_atom act_recruit_03) FALSE)
			)
			(= b_elev_mountup 1)
		)
	1)		
	
	(sleep_until (>= s_elevator_obj_control 3) 1)
		
	(if (= b_elev_mountup 0)
		(begin	
			(ai_dialogue_enable FALSE)
			(print "RADIO:  What's our situation, Sergeant?")
			(vs_play_line act_question TRUE 030MB_020)
			(ai_dialogue_enable TRUE)
		)
	)
	
	(if (= b_elev_mountup 0)
		(begin	
			(ai_dialogue_enable FALSE)
			(vs_face act_sarge FALSE elev_room_pts/p13)
			(print "MARINE:  Not sure.  Can't reach the commander.  We're too far underground...")
			(vs_play_line act_sarge TRUE 030MB_030)
			(ai_dialogue_enable TRUE)
		)
	)
	
	;sleeps until the player gets in a vehicle, hits the switch, or waits X seconds
	;*(if (= b_elev_mountup 0)
		(begin
			(sleep_until 
				(begin
					(vs_go_to_and_face act_sarge TRUE elev_room_pts/p5 elev_room_pts/p18)
					(vs_go_to_and_face act_sarge TRUE elev_room_pts/p11 elev_room_pts/p13)	
				(or
					(= (unit_in_vehicle (player0)) TRUE)
					(= (unit_in_vehicle (player1)) TRUE)
					(> (device_get_position cavern_entrance) 0)
				))
			1 300)	
		)
	)*;
	
	(sleep 120)
	
	;this script has sarge dialog regarding getting in the hogs
	(wake sc_elev_sarge_hogs)
	
	(vs_movement_mode act_sarge 1)
	(vs_release_all)
)

;script to open the blast door if the player does not
(script dormant sc_elev_blast_door	
	(sleep_until (= b_elev_blast_door 1) 1)

	(vs_cast sq_elev_mech FALSE 99 "030MB_150")
	(set act_blastdoor (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(wake sc_elev_blast_door_cancel)
	
	(if (= (device_get_position cavern_entrance) 0)
		(begin
			(sleep 60)
			(print "MARINE:  I'll get the door, Sir!")
			(vs_play_line act_blastdoor TRUE 030MB_150)
			
			(vs_go_to act_blastdoor TRUE elev_room_pts/p16 0)
			(sleep_until (= (volume_test_players tv_elev_nokill) 0) 1)

			(if (volume_test_object tv_elev_nokill act_blastdoor)
					(vs_custom_animation act_blastdoor FALSE objects\characters\marine\marine "combat:rifle:base_button" TRUE elev_room_pts/p16)
			)

			(sleep 30)
			(device_set_position cavern_entrance 1)
			(device_set_position cavern_entrance_but 1)
			(device_set_power cavern_entrance_switch_01 0)
			
			(ai_enter_squad_vehicles sg_all_allies)
		)
	)

	(set b_elev_prompt 1)
	(ai_dialogue_enable TRUE)
	(vs_release_all)
)

;script to pull the doorman out of his script when the player hits the door switch
(script dormant sc_elev_blast_door_cancel
	(sleep_until (> (device_get_position cavern_entrance) 0.5) 1)
		;(cs_run_command_script act_blastdoor cs_abort)
		(vs_cast sq_elev_mech FALSE 100 "")
		(set act_blastdoor (vs_role 1))
		(sleep 1)
		(vs_release_all)
)

;script for the sarge to call out when people get in the hogs
(script dormant sc_elev_sarge_hogs	
	(vs_cast sq_elev_sarge FALSE 40 "030MB_050")
	(set act_sarge (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
		
	(cond 
		((= (unit_in_vehicle (player0)) TRUE)
			(print "SARGE:  Chief's got the right idea!")
			(vs_play_line act_sarge TRUE 030MB_050)
			(sleep 15)
			
			(print "SARGE:  Let's mount up, get the hell out of these caves!")
			(vs_play_line act_sarge TRUE 030MB_060)
		)
		((= (unit_in_vehicle (player1)) TRUE)
			(print "SARGE:  Let's all mount up!")
			(vs_play_line act_sarge TRUE 030MB_070)
			(sleep 15)
			
			(print "SARGE:  Get the hell out of these caves!")
			(vs_play_line act_sarge TRUE 030MB_080)
		)
		((= (volume_test_object vol_who_pressed_it (player0)) TRUE)
			(print "SARGE:  Chief's got the right idea!")
			(vs_play_line act_sarge TRUE 030MB_050)
			(sleep 15)
			
			(print "SARGE:  Let's mount up, get the hell out of these caves!")
			(vs_play_line act_sarge TRUE 030MB_060)
		)
		((= (volume_test_object vol_who_pressed_it (player1)) TRUE)
			(print "SARGE:  Let's all mount up!")
			(vs_play_line act_sarge TRUE 030MB_070)
			(sleep 15)
			
			(print "SARGE:  Get the hell out of these caves!")
			(vs_play_line act_sarge TRUE 030MB_080)
		)
		(TRUE
			(print "SARGE: Let's mount up, get the hell out of these caves")
			(vs_play_line act_sarge TRUE 030MB_060)
		)
	)
	
	(wake 030_music_02_start)
	(ai_dialogue_enable TRUE)
	(vs_draw act_sarge)
	
	(wake sc_elev_load_up)
	(vs_release_all)
	(set b_elev_prompt 1)
)

;script to keep trying to get guys into vehicles
(script dormant sc_elev_load_up
	(vs_cast sq_elev_mar FALSE 80 "030MB_120" "030MB_120" )
	(set act_response_01 (vs_role 1))
	(set act_response_02 (vs_role 2))
	;(set act_response_03 (vs_role 3))
	(vs_cast sq_elev_mech FALSE 80 "030MB_120" )
	(set act_response_04 (vs_role 1))
	;(vs_cast sq_elev_doorman FALSE 80 "030MB_120" )
	;(set act_response_05 (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)

	(sleep 30)

	(ai_dialogue_enable FALSE)
	(print "MARINES:  Yessir!")
	(begin_random
		(sleep (random_range 1 3))
		(vs_play_line act_response_01 FALSE 030MB_120)
		(sleep (random_range 1 3))
		(vs_play_line act_response_02 FALSE 030MB_120)
		(sleep (random_range 1 3))
		(vs_play_line act_response_03 FALSE 030MB_120)
		(sleep (random_range 1 3))
		(vs_play_line act_response_04 FALSE 030MB_120)
		;(sleep (random_range 1 3))
		;(vs_play_line act_response_05 FALSE 030MB_120)
	)
	(sleep 30)
	(ai_dialogue_enable TRUE)
	
	(vs_release_all)
	
	(wake sc_elev_blast_door)
	(set b_elev_blast_door 1)

	(if (= (device_get_position cavern_entrance) 0) 
		(ai_enter_squad_vehicles sg_elev_mount)
		(ai_enter_squad_vehicles sg_all_allies)
	)
	
	(set b_elev_prompt 1)
	
	(sleep 150)
	
	(if (= (device_get_position cavern_entrance) 0) 
		(ai_enter_squad_vehicles sg_elev_mount)
		(ai_enter_squad_vehicles sg_all_allies)
	)	
)

;script to reserve the driver's seat in the hog, until the player gets in a passenger seat
(script dormant sc_elev_reserve_driver
	(print "reserving driver seat")
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" TRUE)
	(sleep_until 
		(or
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player0)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player1)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player2)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player3)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player0)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player1)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player2)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player3)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" (player0)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" (player1)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" (player2)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" (player3)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player0)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player1)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player2)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player3)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player0)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player1)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player2)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player3)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player0)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player1)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player2)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player3)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player0)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player1)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player2)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player3)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player0)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player1)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player2)) 
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player3)) 
			
		)
	)
		(print "un-reserving driver seat")
		(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" FALSE)
		(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" FALSE)
		(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" FALSE)
	
		(print "mount enter")
		(ai_enter_squad_vehicles sg_elev_mount)
		
		(sleep_until (= (device_get_position cavern_entrance) 1) )
		
		(print "all enter")
		(ai_enter_squad_vehicles sg_all_allies)
)

;script sleeps until allegiance broken, then gives all the wounded marines assault rifles
(script dormant sc_elev_betrayal
	(sleep_until (= (ai_allegiance_broken player human) 1) 5)
		
	(unit_add_equipment sq_elev_hurt01/hurt marine_ar TRUE TRUE)
	(unit_add_equipment sq_elev_hurt02/hurt marine_ar TRUE TRUE)
	(unit_add_equipment sq_elev_hurt03/hurt marine_ar TRUE TRUE)
	(unit_add_equipment sq_elev_hurt04/hurt marine_ar TRUE TRUE)
	(unit_add_equipment sq_elev_hurt05/01 marine_ar TRUE TRUE)
	(unit_add_equipment sq_elev_hurt05/02 marine_ar TRUE TRUE)
	(unit_add_equipment sq_elev_hurt05/03 marine_ar TRUE TRUE)
	(unit_add_equipment sq_elev_hurt05/04 marine_ar TRUE TRUE)
)

;moves the warthog out of the elevator if the player takes up a gunner role
(script dormant sc_elev_cavern_task
	(sleep_until
		(and
			(or
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" (player3))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player3))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_g" (player3))
				
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_d" (player3))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player3))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player3))								
				
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_d" (player3))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player3))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player3))				
			)
			(>= (device_get_position cavern_entrance) 0.3)
		)
	5)
	
	(if (= s_cavern_obj_control 0)
		(begin
			(ai_set_objective sg_allied_vehicles obj_cav_marine)
		)
	)
)

;moves the warthog out of the elevator if the player takes up a gunner role
(script dormant sc_elev_cavern_task_old
	(sleep_until
		(and
			(or
				(>= s_cavern_obj_control 1)
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_p" (player0))
				
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_p" (player3))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2) "warthog_g" (player3))
				
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player0))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player1))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player2))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_p" (player3))
				(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3) "warthog_g" (player3))				
			)
			(>= (device_get_position cavern_entrance) 0.3)
		)
	5)
	
	(if (= s_cavern_obj_control 0)
		(begin
			(ai_set_objective sg_allied_vehicles obj_cav_marine)
		)
	)
)

;redundancy check to get guys in warthogs if scripts fail
(script dormant sc_elev_enter_vehicles
	(sleep_until (>= s_elevator_obj_control 2) 5)
	(sleep_until 
		(or
			(> (device_get_position cavern_entrance) 0)
			(= (any_players_in_vehicle) TRUE)
		)
	5)
		(set b_elev_mountup 1)
		;this script calls sarge dialog to get in the hogs
		(wake sc_elev_sarge_hogs)
		(sleep 5)
		(ai_enter_squad_vehicles sg_elev_mount)
)

;warthog speed throttle
(script dormant sc_elev_warthog_throttle
	(sleep_until 
		(begin
			(if
				(and
					(= player_on_foot 0)
					(or
						(= (game_is_cooperative) FALSE)
						(< (game_difficulty_get) heroic)
						(= (campaign_metagame_enabled) FALSE)
					)
				)
				(begin
					(player_control_scale_all_input 1.0 0)
					(print "throttled back")
				)
			)
		(>= s_cavern_obj_control 7))
	)
	(print "throttled up")
	(player_control_scale_all_input 1.0 0)
)

;command script to abort the vignette scripts
(script command_script cs_abort
	(print "aborting")
	(sleep 1)
)

;script to turn on the lights over the hogs
(script dormant sc_elev_hoglights1
	(sleep 30)
	(object_destroy 000_hog_light_01_off)
	(object_create 000_hog_light_01)

)

(script dormant sc_elev_hoglights2
	(object_destroy 000_hog_light_02_off)
	(object_create 000_hog_light_02)

)

(script dormant sc_elev_hoglights3
	(object_destroy 000_hog_light_03_off)
	(object_create 000_hog_light_03)
	(sleep 3)
	(object_destroy 000_hog_light_03)
	(object_create 000_hog_light_03_off)
	(sleep 5)
	(object_destroy 000_hog_light_03_off)
	(object_create 000_hog_light_03)
	(sleep 2)
	(object_destroy 000_hog_light_03)
	(object_create 000_hog_light_03_off)
	(sleep 22)
	(object_destroy 000_hog_light_03_off)
	(object_create 000_hog_light_03)	
	(sleep_until
		(begin
			(sleep (random_range 60 300))
				(object_destroy 000_hog_light_03)
				(object_create 000_hog_light_03_off)
			(sleep (random_range 2 3))
				(object_destroy 000_hog_light_03_off)
				(object_create 000_hog_light_03)
			(sleep (random_range 5 7))
				(object_destroy 000_hog_light_03)
				(object_create 000_hog_light_03_off)
			(sleep (random_range 2 3))
				(object_destroy 000_hog_light_03_off)
				(object_create 000_hog_light_03)			
		0)
	)	
)

(script dormant sc_elev_hoglights4
	(object_destroy 000_hog_light_04_off)
	(object_create 000_hog_light_04)
	(sleep 3)
	(object_destroy 000_hog_light_04)
	(object_create 000_hog_light_04_off)
	(sleep 5)
	(object_destroy 000_hog_light_04_off)
	(object_create 000_hog_light_04)
	(sleep 2)
	(object_destroy 000_hog_light_04)
	(object_create 000_hog_light_04_off)
	(sleep 22)
	(object_destroy 000_hog_light_04_off)
	(object_create 000_hog_light_04)	
	(sleep_until
		(begin
			(sleep (random_range 60 300))
				(object_destroy 000_hog_light_04)
				(object_create 000_hog_light_04_off)
			(sleep (random_range 2 3))
				(object_destroy 000_hog_light_04_off)
				(object_create 000_hog_light_04)
			(sleep (random_range 5 7))
				(object_destroy 000_hog_light_04)
				(object_create 000_hog_light_04_off)
			(sleep (random_range 2 3))
				(object_destroy 000_hog_light_04_off)
				(object_create 000_hog_light_04)
			(sleep (random_range 10 13))
				(object_destroy 000_hog_light_04)
				(object_create 000_hog_light_04_off)
			(sleep (random_range 16 22))
				(object_destroy 000_hog_light_04_off)
				(object_create 000_hog_light_04)			
		0)
	)
)

;not used at the moment
(script dormant sc_elev_hoglights5
	(object_destroy 000_hog_light_05_off)
	(object_create 000_hog_light_05)
	(sleep 3)
	(object_destroy 000_hog_light_05)
	(object_create 000_hog_light_05_off)
	(sleep 5)
	(object_destroy 000_hog_light_05_off)
	(object_create 000_hog_light_05)
	(sleep 2)
	(object_destroy 000_hog_light_05)
	(object_create 000_hog_light_05_off)
	(sleep 22)
	(object_destroy 000_hog_light_05_off)
	(object_create 000_hog_light_05)	
)

(script dormant sc_elev_hanglights1
	(object_destroy 000_hanglight_01_off)
	(object_create 000_hanglight_01_on)
	(object_destroy 000_hanglight_02_off)
	(object_create 000_hanglight_02_on)
	(sleep 2)
	(wake sc_elev_hoglights3)
)

(script dormant sc_elev_hanglights2
	(object_destroy 000_hanglight_03_off)
	(object_create 000_hanglight_03_on)
	(object_destroy 000_hanglight_04_off)
	(object_create 000_hanglight_04_on)
)

;Scripts for marines coughing in the dark
(script dormant sc_elev_cough
	(vs_cast sq_elev_hurt01/hurt FALSE 0 "030MA_010" )
	(set act_cough_01 (vs_role 1))
	(vs_cast sq_elev_hurt02/hurt FALSE 0 "030MA_010" )
	(set act_cough_02 (vs_role 1))
	(vs_cast sq_elev_hurt03/hurt FALSE 0 "030MA_010" )
	(set act_cough_03 (vs_role 1))
	(vs_cast sq_elev_hurt04/hurt FALSE 0 "030MA_010" )
	(set act_cough_04 (vs_role 1))
	(vs_cast sq_elev_hurt05/01 FALSE 0 "030MA_010" )
	(set act_cough_05 (vs_role 1))
	(vs_cast sq_elev_hurt05/02 FALSE 0 "030MA_010" )
	(set act_cough_06 (vs_role 1))
	(vs_cast sq_elev_hurt05/03 FALSE 0 "030MA_010" )
	(set act_cough_07 (vs_role 1))
	(vs_cast sq_elev_hurt05/04 FALSE 0 "030MA_010" )
	(set act_cough_08 (vs_role 1))	

	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(if (= s_cavern_obj_control 0)
						(begin
							(print "cough hurt01")
							(vs_play_line act_cough_01 TRUE 030MA_010)
							(sleep s_cough_spacing)
							(set s_cough_spacing (+ s_cough_spacing (random_range 1 3)))
							(set r_cough_vol (* r_cough_vol 0.8 ) )
						)
					)
				)
				(begin
					(if (= s_cavern_obj_control 0)
						(begin
							(print "cough hurt02")
							(vs_play_line act_cough_02 TRUE 030MA_010)					
							(sleep  s_cough_spacing)
							(set s_cough_spacing (+ s_cough_spacing (random_range 1 3)))
							(set r_cough_vol (* r_cough_vol 0.9 ) )
						)
					)
				)
				(begin
					(if (= s_cavern_obj_control 0)
						(begin
							(print "cough hurt03")
							(vs_play_line act_cough_03 TRUE 030MA_010)
							(sleep  s_cough_spacing)
							(set s_cough_spacing (+ s_cough_spacing (random_range 1 3)))
							(set r_cough_vol (* r_cough_vol 0.7 ) )
						)
					)
				)
				(begin
					(if (= s_cavern_obj_control 0)
						(begin
							(print "cough hurt04")
							(vs_play_line act_cough_04 TRUE 030MA_010)
							(sleep  s_cough_spacing)
							(set s_cough_spacing (+ s_cough_spacing (random_range 1 3)))
							(set r_cough_vol (* r_cough_vol 0.8 ) )
						)
					)
				)
				(begin
					(if (= s_cavern_obj_control 0)
						(begin
							(print "cough hurt05")
							(vs_play_line act_cough_05 TRUE 030MA_010)
							(sleep  s_cough_spacing)
							(set s_cough_spacing (+ s_cough_spacing (random_range 1 3)))
							(set r_cough_vol (* r_cough_vol 0.9 ) )
						)
					)
				)
				(begin
					(if (= s_cavern_obj_control 0)
						(begin
							(print "cough hurt06")
							(vs_play_line act_cough_06 TRUE 030MA_010)
							(sleep  s_cough_spacing)
							(set s_cough_spacing (+ s_cough_spacing (random_range 1 3)))
							(set r_cough_vol (* r_cough_vol 0.7 ) )
						)
					)
				)
				(begin
					(if (= s_cavern_obj_control 0)
						(begin
							(print "cough hurt07")
							(vs_play_line act_cough_07 TRUE 030MA_010)
							(sleep  s_cough_spacing)
							(set s_cough_spacing (+ s_cough_spacing (random_range 1 3)))
							(set r_cough_vol (* r_cough_vol 0.8 ) )
						)
					)
				)
				(begin
					(if (= s_cavern_obj_control 0)
						(begin
							(print "cough hurt08")
							(vs_play_line act_cough_08 TRUE 030MA_010)
							(sleep  s_cough_spacing)
							(set s_cough_spacing (+ s_cough_spacing (random_range 1 3)))
							(set r_cough_vol (* r_cough_vol 0.9 ) )
						)
					)
				)
			)
			(or
				(<= r_cough_vol 0.1)
				(>= s_cavern_obj_control 1)
			)
		)
	)
	(print "coughing ended")
	(ai_dialogue_enable TRUE)
)

;initial comment
(script dormant sc_elev_initial_comment
	(sleep 90)	

	(vs_cast sq_elev_mar TRUE 0 "030MA_020" )
	(set act_elev_rand01 (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(print "MARINE:  What happened?")
	(vs_play_line act_elev_rand01 TRUE 030MA_020)
	(ai_dialogue_enable TRUE)

)	
	
;Random initial comment by a marine
(script dormant sc_elev_random_comment
	
	(vs_abort_on_damage TRUE)
	
	(set s_elev_random (random_range 0 4) )
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(if (= s_elev_random 1)
		(begin
			(vs_cast sq_elev_mar TRUE 0 "030MA_030" )
			(set act_elev_rand01 (vs_role 1))
			
			(print "MARINE:  Another bombing run?")
			(vs_play_line act_elev_rand01 TRUE 030MA_030)
		)
	)
	(if (= s_elev_random 2)
		(begin
			(vs_cast sq_elev_mar TRUE 0 "030MA_080" )
			(set act_elev_rand01 (vs_role 1))
			
			(print "MARINE:  Did we get everybody out sir?")
			(vs_play_line act_elev_rand01 TRUE 030MA_080)
		)
	)
	(if (= s_elev_random 3)
		(begin
			(vs_cast sq_elev_mar TRUE 0 "030MA_090" )
			(set act_elev_rand01 (vs_role 1))
			
			(print "MARINE:  Think the Brutes know where we are?")
			(vs_play_line act_elev_rand01 TRUE 030MA_090)
		)
	)
	(if (= s_elev_random 4)
		(begin
			(vs_cast sq_elev_mar TRUE 0 "030MA_110" )
			(set act_elev_rand01 (vs_role 1))
			
			(print "MARINE:  Stay still.  You're hurt.")
			(vs_play_line act_elev_rand01 TRUE 030MA_110)
		)
	)

	(ai_dialogue_enable TRUE)
	(sleep 1)
)

;Random chatter
(script dormant sc_elev_chatter_01
	(vs_cast sq_elev_mar TRUE 0 "030MA_100" "030MA_120")
	(set act_elev_chat_01a (vs_role 1))
	(set act_elev_chat_01b (vs_role 2))
	
	(vs_abort_on_damage TRUE)
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)

	(print "MARINE:  Brutes almost had me in the barracks.")
	(vs_play_line act_elev_chat_01a TRUE 030MA_080)

	(print "MARINE:  They rounded up the others.  I don't know what happened next.")
	(vs_play_line act_elev_chat_01b TRUE 030MA_090)
	(ai_dialogue_enable TRUE)

)

;random chatter
(script dormant sc_elev_chatter_02
	(vs_cast sq_elev_mar TRUE 0 "030MA_200" "030MA_210")
	(set act_elev_chat_01a (vs_role 1))
	(set act_elev_chat_01b (vs_role 2))
	
	(vs_abort_on_damage TRUE)
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(print "MARINE:  Anyone from Charlie-two?  I got separated...")
	(vs_play_line act_elev_chat_01a TRUE 030MA_200)
	
	(print "MARINE:  Nah, man, Alpha-six.  They're all gone too...")
	(vs_play_line act_elev_chat_01b TRUE 030MA_210)
	
	(ai_dialogue_enable TRUE)
)

;medic dialog if players gets close to hurt marines
(script dormant sc_elev_medic_01

	(sleep_until (volume_test_players tv_elev_medic01) 5)

	(vs_cast sq_elev_hurt01/medic TRUE 0 "030MA_130" )
	(set act_elev_medic_01 (vs_role 1))
	(vs_cast sq_elev_hurt01/hurt TRUE 0 "030MA_150" )
	(set act_elev_hurt_01 (vs_role 1))
	
	(vs_abort_on_damage TRUE)
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(print "MARINE:  There's swelling.  Could be a fracture.")
	(vs_play_line act_elev_medic_01 TRUE 030MA_130)
	
	(sleep 20)
	
	(print "MARINE:  Think you can stand?")
	(vs_play_line act_elev_medic_01 TRUE 030MA_140)	
	
	(sleep 30)
	
	(print "MARINE:  I don't know doc.")
	(vs_play_line act_elev_hurt_01 TRUE 030MA_150)
	
	(ai_dialogue_enable TRUE)
)

;medic dialog if players gets close to hurt marines
(script dormant sc_elev_medic_02

	(sleep_until (volume_test_players tv_elev_medic02) 5)

	(vs_cast sq_elev_hurt04/medic TRUE 0 "030MA_170" )
	(set act_elev_medic_02 (vs_role 1))
	(vs_cast sq_elev_hurt04/hurt TRUE 0 "030MA_160" )
	(set act_elev_hurt_02 (vs_role 1))
	
	(vs_abort_on_damage TRUE)
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(print "MARINE:  (groan) I got a broken rib!")
	(vs_play_line act_elev_hurt_02 TRUE 030MA_160)
	
	(print "MARINE:  You want to bleed out?")
	(vs_play_line act_elev_medic_02 TRUE 030MA_170)	
	
	(sleep 30)
	
	(print "MARINE:  No...")
	(vs_play_line act_elev_hurt_02 TRUE 030MA_180)
	
	(print "MARINE:  Then I gotta keep pressure on the wound!")
	(vs_play_line act_elev_medic_02 TRUE 030MA_190)		
	
	(ai_dialogue_enable TRUE)
)

;prompts player if they slack
(script dormant sc_elev_prompt01
	(sleep_until (= b_elev_prompt 1) 30 1800)
	
	(if (= b_elev_prompt 0)
		(begin
			(set b_elev_prompt 1)
		)
	)
	
	(sleep 900)
	
	(if (= s_cavern_obj_control 0) 
		(begin
			(vs_cast sg_all_allies TRUE 50 "030MB_090" )
			(set act_sarge (vs_role 1))	

			(vs_set_cleanup_script gs_dialogue_cleanup)
			(ai_dialogue_enable FALSE)
			(print "SARGE:  Caverns lead out onto the Savanna, Chief!")
			(vs_play_line act_sarge TRUE 030MB_090)
			(ai_dialogue_enable TRUE)
		)
	)
)

;prompts player if they slack
(script dormant sc_elev_prompt02
	(sleep_until (= b_elev_prompt 1) )
	(sleep 1800)

	(if (= s_cavern_obj_control 0) 
		(begin

			(vs_cast sg_all_allies TRUE 60 "030MB_100" )
			(set act_sarge (vs_role 1))	
		
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(ai_dialogue_enable FALSE)
			(print "SARGE:  Grab a 'Hog, and let's roll!")
			(vs_play_line act_sarge TRUE 030MB_100)
			(ai_dialogue_enable TRUE)
		)
	)	
)

;navpoint just in case
(script dormant sc_elev_navpoint
	(sleep_until (= b_elev_prompt 1) )
	(sleep 3600)
	
	(if (= s_cavern_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player elev_navpoint 0.55)
			(sleep_until (>= s_cavern_obj_control 1) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player elev_navpoint)
		)
	)
)

;navpoint just in case
(script dormant sc_elev_navpoint_door
	(sleep_until (>= s_elevator_obj_control 2) 30 3600)
	
	(if (> (object_get_health elev_room_bash_door) .2)
		(begin	
			(hud_activate_team_nav_point_flag player elev_navpoint2 0.55)
			(sleep_until (>= s_elevator_obj_control 2) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player elev_navpoint2)
		)
	)
)

;first briefing sound
(script dormant sc_elev_brief01_sound
	(ai_dialogue_enable FALSE)
	(vs_set_cleanup_script gs_dialogue_cleanup)
	
	(print "Chief, please respond!  (what is) your status, over?")
	(sleep (ai_play_line_on_object none 030BA_010) )
	
	(sleep 10)
	
	(print "If you can (hear me)...")
	(sleep (ai_play_line_on_object none 030BA_020) )
	
	(print "Find transport, head to (the town of Voi)!")
	(sleep (ai_play_line_on_object none 030BA_030) )
	
	(sleep 60)
	
	(game_save)
	(set b_elev_sarge_start 1)
	(wake objective_1_set)
	(ai_dialogue_enable TRUE)
		
)

;=======================================================
;==========Cavern Ambient===============================
;=======================================================
(global ai act_shooter1 NONE)
(global ai act_shooter2 NONE)
(global ai act_shooter3 NONE)
(global ai act_cav_prompt1 NONE)
(global ai act_cav_prompt2 NONE)
(global ai act_cav_dialog1 NONE)
(global ai act_cav_dialog2 NONE)
(global ai act_cav_dialog3 NONE)

(global boolean b_cav_prompt1 0)
(global boolean b_cav_prompt2 0)

;guys shoot at points near exit gate to make battle seem chaotic
(script dormant sc_cav_firefight
	(vs_cast sq_cavern_mar1 TRUE 10 "" )
	(set act_shooter1 sq_cavern_mar1)
	
	(vs_cast sq_cavern_mar2 TRUE 10 "" )
	(set act_shooter2 sq_cavern_mar2)
	
	(vs_cast sq_cavern_mar3 TRUE 10 "" )
	(set act_shooter3 sq_cavern_mar3)

	(vs_abort_on_damage TRUE)
	(cs_shoot TRUE)
	
	(vs_enable_pathfinding_failsafe act_shooter1 TRUE)
	(vs_enable_pathfinding_failsafe act_shooter2 TRUE)
	(vs_enable_pathfinding_failsafe act_shooter3 TRUE)
	(vs_movement_mode act_shooter1 1)
	(vs_movement_mode act_shooter2 1)
	(vs_movement_mode act_shooter3 1)

	(vs_go_to act_shooter1 FALSE cavern_pts/p0 0.5)
	(vs_go_to act_shooter2 FALSE cavern_pts/p1 0.5)
	(vs_go_to act_shooter3 TRUE cavern_pts/p2 0.5)
	(sleep 60)
	(vs_face act_shooter1 TRUE cavern_pts/p3)
	(vs_face act_shooter2 TRUE cavern_pts/p3)
	(vs_face act_shooter3 TRUE cavern_pts/p3)
	(ai_set_weapon_up act_shooter1 1)	
	(ai_set_weapon_up act_shooter2 1)	
	(ai_set_weapon_up act_shooter3 1)		
	
	(sleep_until (>= s_drive_obj_control 1) 1)

	(ai_set_weapon_up act_shooter1 0)	
	(ai_set_weapon_up act_shooter2 0)	
	(ai_set_weapon_up act_shooter3 0)	
	
	(vs_release_all)
	(ai_enter_squad_vehicles sg_all_allies)
)

;script to send the jackals into fallback
(script dormant sc_cavern_jackal_fallback
	(sleep_until 
		(and
			(<= (ai_task_count obj_cav_cov/starting) 2) 
			(>= s_cavern_obj_control 8)
		)
	1)
		(ai_set_objective sq_drive_init01 obj_drive_cov)
)

;script to get the cameras to follow the player
(script dormant sc_cavern_camera_follow
	(vehicle_auto_turret cameraa tv_cav_camera 3000.0 0.0 0.0)
	(vehicle_auto_turret camerab tv_cav_camera 3000.0 0.0 0.0)
)

;script to announce their presence
(script dormant sc_cav_dialog1
	(vs_cast sg_allied_vehicles TRUE 10 "030MC_050")
	(set act_cav_dialog1 (vs_role 1))	
	
	(ai_dialogue_enable FALSE)
	(vs_abort_on_damage TRUE)	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	
		(sleep (random_range 30 45))	
	(print "SARGE:  Second squad?  We're comming through!")
	(vs_play_line act_cav_dialog1 FALSE 030MC_050)
		(sleep (random_range 30 45))
	
	(ai_dialogue_enable TRUE)
)	

;script to get a reaction from the marines
(script dormant sc_cav_dialog2
	(vs_cast sg_cavern_mar FALSE 10 "030MC_070" "030MC_080" )
	(set act_cav_dialog2 (vs_role 1))	
	(set act_cav_dialog3 (vs_role 2))	
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(vs_abort_on_damage TRUE)	
	(ai_dialogue_enable FALSE)
	
	(print "MARINE:  Go get 'em Chief!  Yeah!")
	(vs_play_line act_cav_dialog2 TRUE 030MC_070)

	(print "MARINE:  That's the way, sir!  Ooh-rah!")
	(vs_play_line act_cav_dialog3 TRUE 030MC_080)
	
	(ai_dialogue_enable TRUE)
)

;script to nudge the player
(script dormant sc_cav_prompt1	
	(sleep 1800)
	
	(vs_cast sg_allied_vehicles TRUE 0 "030MC_010")
	(vs_abort_on_damage TRUE)	
	(set act_cav_prompt1 (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(if 
		(and
			(= s_drive_obj_control 0)
			(or
				(= (unit_in_vehicle (player0)) TRUE)
				(= (unit_in_vehicle (player1)) TRUE)
				(= (unit_in_vehicle (player2)) TRUE)
				(= (unit_in_vehicle (player3)) TRUE)
			)
		)
			
		(begin
			(set b_cav_prompt1 (random_range 0 1) )
			(if (= b_cav_prompt1 0)
				(begin
					(print "SARGE:  Gun it chief!  All the way down this passage")
					(vs_play_line act_cav_prompt1 FALSE 030MC_010)
				)
			)
			(if (= b_cav_prompt1 1)
				(begin
					(print "SARGE:  Don't let up!  Gotta get clear of these caves!")
					(vs_play_line act_cav_prompt1 FALSE 030MC_020)
				)
			)
		)
	)
	
	(ai_dialogue_enable TRUE)
	(vs_release_all)
)

(script dormant sc_cav_prompt2
	(sleep 2700)
	
	(vs_cast sg_allied_vehicles TRUE 0 "030MC_010")
	(set act_cav_prompt2 (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(vs_abort_on_damage TRUE)	
	(ai_dialogue_enable FALSE)
	
	(if 
		(and
			(= s_drive_obj_control 0)
			(or
				(= (unit_in_vehicle (player0)) TRUE)
				(= (unit_in_vehicle (player1)) TRUE)
				(= (unit_in_vehicle (player2)) TRUE)
				(= (unit_in_vehicle (player3)) TRUE)
			)
		)
		
		(begin
			(set b_cav_prompt2 (random_range 0 1) )
			(if (= b_cav_prompt2 0)
				(begin
					(print "MARINE:  Pedal to the metal sir!  Gotta find the exit")
					(vs_play_line act_cav_prompt2 FALSE 030MC_010)
				)
			)
			(if (= b_cav_prompt2 1)
				(begin
					(print "MARINE: Keep going, sir!  Let's get clear of these caves!")
					(vs_play_line act_cav_prompt2 FALSE 030MC_020)
				)
			)
		)
	)
	
	(ai_dialogue_enable TRUE)
	(vs_release_all)
)

;navpoint just in case
(script dormant sc_cavern_navpoint
	(sleep 4500)
	
	(if (= s_drive_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player cavern_navpoint 0.55)
			(sleep_until (>= s_drive_obj_control 1) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player cavern_navpoint)
		)
	)
)

;=======================================================
;==========Drive Ambient================================
;=======================================================
(global ai act_marine_heckler NONE)
(global ai act_sarge_heckler NONE)
(global ai act_drive_tether01 NONE)
(global ai act_drive_tether02 NONE)

(global boolean b_heckler_random FALSE)

(global short s_drive_shoot1 0)

;script to set the objectives for the covenant to the drive objective
(script dormant sc_drive_objective_set
	(sleep_until
		(or
			(>= s_drive_obj_control 1)
			(>= (ai_body_count obj_cav_cov/main_gate) 4)
		)
	)
	(ai_set_objective sq_drive_init01 obj_drive_cov)
	(ai_set_objective sq_drive_init02 obj_drive_cov)
	(ai_set_objective sq_drive_init06 obj_drive_cov)
	(ai_set_objective sq_drive_init05 obj_drive_cov)
	(ai_set_objective sq_drive_init03 obj_drive_cov)
)

;Makes guys flee for 10 seconds
(script command_script cs_flee_10
	(cs_movement_mode ai_movement_flee)
	(cs_enable_moving TRUE)
	(cs_shoot FALSE)
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)	
	(sleep 300)
)

;makes guys flee for 30 seconds
(script command_script cs_flee_30
	(cs_movement_mode ai_movement_flee)
	(cs_enable_moving TRUE)
	(cs_shoot FALSE)
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)	
	(sleep 900)
)

;marine dialog when covenant starts fleeing
(script dormant sc_drive_flee_scene
	
	(sleep (random_range 30 60) )
	
	(vs_cast sg_allied_vehicles TRUE 0 "030MD_010")
	(set act_sarge_heckler (vs_role 1))
	
	(vs_cast sg_allied_vehicles TRUE 0 "030MD_030")
	(set act_marine_heckler (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(vs_abort_on_damage TRUE)	
	(ai_dialogue_enable FALSE)
	
	(begin_random
		(if (= b_heckler_random FALSE)
			(begin
				(vs_play_line act_sarge_heckler TRUE 030MD_010)
				(print "SARGE:  Conserve ammo!  Run 'em over!")
				(set b_heckler_random TRUE)
			)
		)
		(if (= b_heckler_random FALSE)
			(begin
				(vs_play_line act_sarge_heckler TRUE 030MD_020)
				(print "SARGE:  Don't leave any of 'em standing!")
				(set b_heckler_random TRUE)
			)
		)
		(if (= b_heckler_random FALSE)
			(begin
				(vs_play_line act_marine_heckler TRUE 030MD_030)
				(print "MARINE:  Suprise, crab face!!")
				(set b_heckler_random TRUE)
			)
		)
		(if (= b_heckler_random FALSE)
			(begin
				(vs_play_line act_marine_heckler TRUE 030MD_040)
				(print "MARINE:  Look at the little bastards run!")
				(set b_heckler_random TRUE)
			)
		)
	)
	(ai_dialogue_enable TRUE)
	(vs_release_all)
)

;script to save when the two snipers are killed
(script dormant sc_drive_sniper_save
	(sleep_until (= (ai_task_count obj_drive2_cov/jackals_front) 0) 5)
		(game_save)
)

;marine dialog regarding tether pieces
(script dormant sc_drive_dialog_tether

	(sleep_until 
		(and
			(= (ai_task_count obj_drive_cov/main_gate) 0)
			(= (volume_test_players tv_drive_vista) 1)
		)
	5)
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(sleep (random_range 30 60) )

	;(print "(whistles) Is this all from the base?")
	;(sleep  (ai_play_line_on_object none 030MD_050) )	
	
	;(print "No.  It's debris from the Tether...")
	;(sleep (ai_play_line_on_object none 030MD_060) )
	
	(print "New Mombasa's space-elevator?")
	(sleep (ai_play_line_on_object none 030MD_070) )
	
	(print "Yeah.  Collapsed when the city got glassed.")
	(sleep (ai_play_line_on_object none 030MD_080) )
	
	(print "But the Tether was thousands of kilometers high!")
	(sleep (ai_play_line_on_object none 030MD_090) )
	
	(print "Yeah, well now ti's just scattered all over the Savannah.")
	(sleep (ai_play_line_on_object none 030MD_100) )
	
	(print "Jesus...")
	(sleep (ai_play_line_on_object none 030MD_110) )
	(ai_dialogue_enable TRUE)

)

;marine dialog for mission update
(script dormant sc_drive_dialog_update

	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(sleep (random_range 15 30) )
	
	(print "Chief?  Still can't get the Commander.")
	(sleep (ai_play_line_on_object none 030MD_120) )
	
	(print "Comms are a mess.  Pelicans are scattered.")
	(sleep (ai_play_line_on_object none 030MD_130) )
	
	(print "Best thing now?  Get some distance between us and the base...")
	(sleep (ai_play_line_on_object none 030MD_140) )
	
	(print "Brutes are gonna be looking for survivors.")
	(sleep (ai_play_line_on_object none 030MD_150) )
	(ai_dialogue_enable TRUE)
)

;script to play the radio chatter on the first downed phantom
(script dormant sc_drive_brute_radio_01
	
	(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio drive_brute_radio_01 1)
	
	(sleep_until (= (ai_task_count obj_drive_cov/mg_front_gate) 0) )
	(ai_dialogue_enable FALSE)
	(if (< s_drive_obj_control 4)
		(begin
			(sleep (random_range 30 60))
			(sound_looping_stop sound\materials\gear\high_ground_radio\high_ground_radio)
			(sleep (random_range 20 40))
			(if b_debug (print "Chieftains!  Rally your packs!"))
			(sleep (ai_play_line_on_object drive_brute_radio_01 030MX_010) )
			(sleep (random_range 20 40))
			(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio drive_brute_radio_01 1)
		)
	)

	(if (< s_drive_obj_control 4)
		(begin
			(sleep (random_range 30 60))
			(sound_looping_stop sound\materials\gear\high_ground_radio\high_ground_radio)
			(sleep (random_range 20 40))
			(if b_debug (print "Kill all survivors!  Let none near the crater!"))
			(sleep (ai_play_line_on_object drive_brute_radio_01 030MX_020) )
			(sleep (random_range 20 40))
			(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio drive_brute_radio_01 1)
		)
	)

	(if (< s_drive_obj_control 4)
		(begin				
			(sleep (random_range 30 60))
			(sound_looping_stop sound\materials\gear\high_ground_radio\high_ground_radio)
			(sleep (random_range 20 40))
			(if b_debug (print "The Prophet will soon complete his blessed task!"))
			(sleep (ai_play_line_on_object drive_brute_radio_01 030MX_030) )
			(sleep (random_range 20 40))
			(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio drive_brute_radio_01 1)
		)
	)
	(ai_dialogue_enable TRUE)
)

;script to play the radio chatter on the first downed phantom
(script dormant sc_drive_brute_radio_02
	
	(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio drive_brute_radio_02 1)
	
	(sleep_until (= (ai_task_count obj_drive2_cov/main_gate) 0) )
	(ai_dialogue_enable FALSE)
	(if (= s_pond_obj_control 0)
		(begin
			(sleep (random_range 30 60))
			(sound_looping_stop sound\materials\gear\high_ground_radio\high_ground_radio)
			(sleep (random_range 20 40))
			(if b_debug (print "I see it, pack-brothers!  The holy relic!"))
			(sleep (ai_play_line_on_object drive_brute_radio_02 030MX_040) )
			(sleep (random_range 20 40))
			(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio drive_brute_radio_02 1)
		)
	)
	(if (= s_pond_obj_control 0)
		(begin
			(sleep (random_range 30 60))
			(sound_looping_stop sound\materials\gear\high_ground_radio\high_ground_radio)
			(sleep (random_range 20 40))
			(if b_debug (print "What fools!  To live so long on hallowed ground!"))
			(sleep (ai_play_line_on_object drive_brute_radio_02 030MX_050) )
			(sleep (random_range 20 40))
			(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio drive_brute_radio_02 1)
		)
	)
	(if (= s_pond_obj_control 0)
		(begin
			(sleep (random_range 30 60))
			(sound_looping_stop sound\materials\gear\high_ground_radio\high_ground_radio)
			(sleep (random_range 20 40))
			(if b_debug (print "Never knowing what lay beneath the surface!"))
			(sleep (ai_play_line_on_object drive_brute_radio_02 030MX_060) )
			(sleep (random_range 20 40))
			(sound_looping_start sound\materials\gear\high_ground_radio\high_ground_radio drive_brute_radio_02 1)
		)
	)
	(ai_dialogue_enable TRUE)
)

;navpoint just in case
(script dormant sc_drive_navpoint
	(sleep 4500)
	
	(if (= s_pond_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player drive_navpoint 0.55)
			(sleep_until (>= s_pond_obj_control 1) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player drive_navpoint)
		)
	)
)

;=======================================================
;==========Pond Ambient=================================
;=======================================================

(global ai act_pond_prompt01 NONE)

;command script for the inital phantom at the start
(script command_script cs_pond_phantom1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1)
	
	(cs_fly_to pond_ph/p0 0.5)
	
	(if (<= (game_difficulty_get) normal)
		(sleep_until (>= s_pond_obj_control 2) 1 480)
		(sleep_until (>= s_pond_obj_control 3) 1 480)
	)
		(sleep 120)
		(cs_vehicle_speed 0.5)
		(sleep 180)
		(cs_vehicle_speed 1)
		(cs_fly_to pond_ph/p1 1)
		(cs_fly_to pond_ph/p2 1)
		
		(cs_fly_to pond_ph/p3 1)
		(cs_fly_to pond_ph/p4 1)
		
		(ai_erase ai_current_squad)
)

;script to save game after pond enemies are killed
(script dormant sc_pond_gamesave
	(sleep_until (= (ai_task_count obj_pond_cov/forward_gate) 0) 5)
	
	(sleep_until (game_safe_to_save) 1 1200)
	
	(game_save)
	
	(sleep_until (= (ai_task_count obj_pond_cov/fallback_gate) 0) 5)	
	
	(sleep_until (game_safe_to_save) 1 1200)
	
	(game_save)

)

;Flavor dialog
(script dormant sc_pond_dialog

	(sleep_until
		(or
			(= (ai_task_count obj_pond_cov/fallback_gate) 0)
			(>= s_pond_obj_control 4)
		)
	)

	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)

	(sleep (random_range 20 60) )

	(print "I repeat: my convo's been hit!  I've ====")
	(sleep (ai_play_line_on_object none 030ME_070) )

	(print "We're on the Tsavo highway.  ==== east of Voi!")
	(sleep (ai_play_line_on_object none 030ME_080) )

	(print "Someone?  Anyone!  Please ====")
	(sleep (ai_play_line_on_object none 030ME_090) )
	
	(ai_dialogue_enable TRUE)
	
	(game_save)

)

;Reminder script if you're taking too long to leave
(script dormant sc_pond_prompt_01

	(sleep_until (= (ai_task_count obj_pond_cov/pond_gate) 0) )
	
	(sleep 900)
	
	(if (< s_pond_obj_control 3)
		(begin
			(vs_cast sg_allied_vehicles TRUE 0 "030ME_050")
			(set act_pond_prompt01 (vs_role 1))
			
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(vs_abort_on_damage TRUE)	
			(ai_dialogue_enable FALSE)
			
			(print "MARINE: Up and around that damn, Sir!")
			(vs_play_line act_pond_prompt01 TRUE 030ME_050)
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
	
	(sleep 1800)
	
	(if (< s_pond_obj_control 3)
		(begin
			(vs_cast sg_allied_vehicles TRUE 0 "030ME_060")
			(set act_pond_prompt01 (vs_role 1))
			
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(vs_abort_on_damage TRUE)	
			(ai_dialogue_enable FALSE)
			
			(print "MARINE: Chief! Follow the ridge up and around the dam!")
			(vs_play_line act_pond_prompt01 TRUE 030ME_060)
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
	(wake sc_pond_navpoint01)
)

;navpoint just in case
(script dormant sc_pond_navpoint01
	(sleep 900)
	
	(if (<= s_pond_obj_control 2) 
		(begin	
			(hud_activate_team_nav_point_flag player pond_navpoint01 0.55)
			(sleep_until (>= s_pond_obj_control 4) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player pond_navpoint01)
		)
	)
)

;Reminder script if you're taking too long to leave
(script dormant sc_pond_prompt_02
	
	(sleep 900)
	
	(if (= s_crash_obj_control 0)
		(begin			
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(ai_dialogue_enable FALSE)
			
			(print "Tsavo highway's just ahead, Chief!")
			(sleep (ai_play_line_on_object none 030ME_100) )
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
	
	(sleep 1800)
	
	(if (= s_crash_obj_control 0)
		(begin
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(ai_dialogue_enable FALSE)
			(print "Let's see if we can find that convoy!")
			(sleep (ai_play_line_on_object none 030ME_110) )
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
	(wake sc_pond_navpoint02)
)

;navpoint just in case
(script dormant sc_pond_navpoint02
	(sleep 900)
	
	(if (= s_crash_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player pond_navpoint02 0.55)
			(sleep_until (>= s_crash_obj_control 1) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player pond_navpoint02)
		)
	)
)

;=======================================================
;==========Crash Ambient================================
;=======================================================

(global short s_crash_chopper 0)
(global short s_crash_bugger 0)

(global boolean b_crash_brute1 0)
(global boolean b_crash_nudge 0)
(global boolean b_crash_doomed 0)

(global ai act_crash_filler NONE)
(global ai act_crash_mombasa NONE)
(global ai act_crash_prompt NONE)

(global vehicle v_crash_doomed NONE)

;script to destroy shield
(script dormant sc_crash_shield_destroy
	(sleep_until (<= (object_get_health crash_generator) 0) 1)
	
	(object_destroy crash_shield)
	(print "shield is down")
)

;script for a mid encounter save
(script dormant sc_crash_mid_save
	(print "wake crash save")
	(sleep_until (= (ai_task_count obj_crash_cov/forward_gate) 0) 5)
		(print "trying to save")
		(sleep_until (game_safe_to_save) 1 1200)
		(game_save)
		
	(sleep_until (= (ai_task_count obj_crash_cov/third_gate) 0) 5)
		(print "trying to save")
		(sleep_until (game_safe_to_save) 1 1200)
		(game_save)		
)

;script causes the turret operators to jump out and run away
(script command_script cs_crash_turret
	(sleep_until
		(and
			(< (ai_task_count obj_crash_cov/main_gate) 6)
			(= b_crash_third 1)
		)
	)
	;(ai_vehicle_exit sq_crash_turret01)
	(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) TRUE)
	(cs_movement_mode ai_movement_flee)
	(cs_enable_moving TRUE)
	(cs_shoot FALSE)
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)
)

;chopper introduction
(script dormant sc_crash_chopper_intro
	(sleep_until (= (volume_test_players tv_crash_scene1) 1) 1)
		(ai_place sq_crash_doomed)
		(set v_crash_doomed (ai_vehicle_get_from_starting_location sq_crash_doomed/doomed))
		(sleep 1)
		(object_damage_damage_section (ai_vehicle_get_from_starting_location sq_crash_doomed/doomed) hull 0.75)
		(ai_place sq_crash_chopper01)
		(ai_place sq_crash_chopper02)
		(ai_disregard (ai_get_object sq_crash_doomed/doomed) TRUE)
		(sleep 180)
		(cs_run_command_script sq_crash_chopper01 cs_abort)
		(cs_run_command_script sq_crash_chopper02 cs_abort)
)

;command script to run choppers into the encounter
(script command_script cs_crash_choppers1
	(cs_abort_on_damage FALSE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_targeting FALSE)
	(cs_vehicle_speed 0.9)
	
	(cs_go_to crash_test/p0 0.5)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost 1)
	(cs_go_to crash_test/p4 1.0)
	(object_set_velocity v_crash_doomed 0 7 3)
	(cs_go_to crash_test/p1 10.0)
	(cs_vehicle_boost 0)
	(cs_ignore_obstacles FALSE)
)

;command script to run choppers into the encounter
(script command_script cs_crash_choppers2
	(cs_abort_on_damage FALSE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_targeting FALSE)
	(cs_vehicle_speed 0.9)
	
	(sleep 60)
	(cs_go_to crash_test/p2 0.5)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost 1)
	(cs_go_to crash_test/p3 10.0)
	(cs_vehicle_boost 0)
	(cs_ignore_obstacles FALSE)
)

;command script to run choppers into the encounter
(script command_script cs_crash_choppers1_old
	(cs_abort_on_damage FALSE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_targeting FALSE)
	(cs_vehicle_speed 1)
	
	(cs_go_to crash_chopper1/p0 0.5)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost 1)
	(cs_go_to crash_chopper1/p3 1.0)
	;(object_set_velocity o_crash_doomed 0 10 2)
	(set b_crash_doomed 1)
	(cs_vehicle_boost 0)
	(cs_ignore_obstacles FALSE)
)

;command script to run choppers into the encounter
(script command_script cs_crash_choppers2_old
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_vehicle_speed 1)
	;(sleep 45)
	(cs_go_to crash_chopper1/p5 0.5)
	(cs_go_to crash_chopper1/p6 0.5)
	(cs_vehicle_boost 1)
	(cs_go_to crash_chopper1/p8 1.0)
	(cs_vehicle_boost 0)
	(cs_ignore_obstacles FALSE)
)

;command script to run choppers into the encounter
(script command_script cs_crash_buggers
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)	
	
	(set s_crash_bugger (random_range 0 10) )
	(cond
		((= s_crash_bugger 0) 
			(cs_fly_to crash_bugger/p0 1.0)
		)
		((= s_crash_bugger 1) 
			(cs_fly_to crash_bugger/p1 1.0)
		)
		((= s_crash_bugger 2) 
			(cs_fly_to crash_bugger/p2 1.0)
		)
		((= s_crash_bugger 3) 
			(cs_fly_to crash_bugger/p3 1.0)
		)
		((= s_crash_bugger 4) 
			(cs_fly_to crash_bugger/p4 1.0)
		)
		((= s_crash_bugger 5) 
			(cs_fly_to crash_bugger/p5 1.0)
		)
		((= s_crash_bugger 6) 
			(cs_fly_to crash_bugger/p6 1.0)
		)
		((= s_crash_bugger 7) 
			(cs_fly_to crash_bugger/p7 1.0)
		)
		((= s_crash_bugger 8) 
			(cs_fly_to crash_bugger/p8 1.0)
		)
		((= s_crash_bugger 9) 
			(cs_fly_to crash_bugger/p9 1.0)
		)
		((= s_crash_bugger 10) 
			(cs_fly_to crash_bugger/p10 1.0)
		)
	)
	(set s_crash_bugger (random_range 0 4) )
	(cond
		((= s_crash_bugger 0) 
			(cs_fly_to crash_bugger/p11 1.0)
		)
		((= s_crash_bugger 1) 
			(cs_fly_to crash_bugger/p12 1.0) 
		)
		((= s_crash_bugger 2) 
			(cs_fly_to crash_bugger/p13 1.0)
		)
		((= s_crash_bugger 3) 
			(cs_fly_to crash_bugger/p14 1.0)
		)
		((= s_crash_bugger 4) 
			(cs_fly_to crash_bugger/p15 1.0)
		)
	)
)

;command script to shoot the warthog turret
(script command_script cs_crash_warthog_turret
	(cs_enable_pathfinding_failsafe TRUE)
	
	(cs_shoot_point TRUE crash_chopper1/p4)
	(sleep_until (= b_crash_doomed 1) 30 300)
)

;marine and covenant health renewal script
(script dormant sc_crash_health_renew
	(sleep_until
		(begin
			(ai_renew sq_crash_marines)
		(= (ai_task_count obj_crash_cov/initial_gate) 0) )
	30)
)

;script to wrangle the flocks
(script dormant sc_crash_flocks
	(sleep_until 
		(begin
			(flock_start crash_flock)
			(sleep (random_range 30 45))
			(flock_stop crash_flock)
			(sleep (random_range 210 300))
		0)
	)
)

(script dormant sc_crash_flocks2
	(sleep_until 
		(begin
			(flock_start crash_flock2)
			(sleep 30)
			(flock_stop crash_flock2)
			(sleep (random_range 60 90))
		0)
	)
)

;Dialog thanking the chief if the chief goes inside the building
(script dormant sc_crash_filler_dialog
	(sleep_until 
		(or
			(= (volume_test_players tv_crash_dialog01) 1)
			(= (volume_test_players tv_crash_dialog02) 1)
			(= (ai_task_count obj_crash_cov/initial_gate) 0)
		)
	)
	(if 
		(and
			(or
				(= (volume_test_objects tv_crash_dialog01 (ai_get_object sq_crash_marines) ) 1) 
				(= (volume_test_objects tv_crash_dialog02 (ai_get_object sq_crash_marines) ) 1) 
			)
			(>= (ai_task_count obj_crash_cov/initial_gate) 1)
		)
		(begin
			(vs_cast sq_crash_marines TRUE 0 "030MF_010")
			(set act_crash_filler (vs_role 1))
			
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(vs_abort_on_damage TRUE)	
			(ai_dialogue_enable FALSE)
			
			(print "MARINE: We were en route to Voi, Chief...")
			(vs_play_line act_crash_filler TRUE 030MF_010)
			
			(sleep (random_range 30 60) )
			
			(print "MARINE: Banshees jumped us, started strafing...")
			(vs_play_line act_crash_filler TRUE 030MF_020)
			
			(sleep (random_range 30 60) )
			
			(print "MARINE: Pretty much ruined our day.")
			(vs_play_line act_crash_filler TRUE 030MF_030)
		)
	)
	
	(ai_dialogue_enable TRUE)
	
	(vs_release_all)

)

;Dialog for the road to mombasa
(script dormant sc_crash_mombasa_dialog
	(sleep_until 
		(and
			(= (ai_task_count obj_crash_cov/forward_gate) 0)
			(= (ai_task_count obj_crash_cov/third_gate) 0)
			(= (volume_test_players tv_crash_dialog_mombasa) 1)
		)
	)
	
	(vs_cast sg_allied_vehicles TRUE 0 "030MF_320")
	(set act_crash_mombasa (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(vs_abort_on_damage TRUE)	
	(ai_dialogue_enable FALSE)
	
	(print "MARINE: That was the road to New Mombasa...")
	(vs_play_line act_crash_mombasa TRUE 030MF_320)
	
	(print "MARINE: Biggest city in Africa.  Millions of people.")
	(vs_play_line act_crash_mombasa TRUE 030MF_330)
	
	(print "MARINE: U.N. Says the evacuation was a success")
	(vs_play_line act_crash_mombasa TRUE 030MF_340)
	
	(print "MARINE: But I don't know... That's a big crater")
	(vs_play_line act_crash_mombasa TRUE 030MF_350)
	
	(print "MARINE: You were there Chief")
	(vs_play_line act_crash_mombasa TRUE 030MF_360)
	
	(print "MARINE: Think most of 'em made it out alive?")
	(vs_play_line act_crash_mombasa TRUE 030MF_370)		
	
	(ai_dialogue_enable TRUE)
	
	(vs_release_all)

)

;Dialog flavor for the marines at the crash site
(script dormant sc_crash_filler_dialog02
	(sleep_until 
		(and
			(= (ai_task_count obj_crash_cov/main_gate) 0)
			(>= (ai_task_count obj_crash_marine/third) 1)
			(= (volume_test_players tv_crash_oc3) 1)
		)
	)
	
	(vs_cast sg_crash_marines TRUE 0 "030MF_250")
	(set act_crash_filler (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(vs_abort_on_damage TRUE)	
	(ai_dialogue_enable FALSE)
	
	(print "MARINE: Marines in Voi really needed my supplies, Chief...")
	(vs_play_line act_crash_filler TRUE 030MF_250)
	
	(print "MARINE: But I'm sure they'll be plenty happy to see you!")
	(vs_play_line act_crash_filler TRUE 030MF_260)
	
	(print "MARINE: Head on through the tunnel!  Give those boys a hand!")
	(vs_play_line act_crash_filler TRUE 030MF_270)
	
	(ai_dialogue_enable TRUE)
	
	(vs_release_all)

)

;Reminder script if you're taking too long to leave
(script dormant sc_crash_prompt
	
	(sleep_until (<= (ai_task_count obj_crash_cov/non_bugger_gate) 2) 5)
	
	(sleep 1200)
	
	(if 
		(and
			(= s_bridge_obj_control 0)
			(> (object_get_health crash_generator) 0)
		)
		(begin				
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(ai_dialogue_enable FALSE)
			
			(print "Take down that barrier, Chief!")
			(sleep (ai_play_line_on_object none 030MF_120) )
			
			(print "Power source should be inside that tunnel!")
			(sleep (ai_play_line_on_object none 030MF_130) )
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
	
	(sleep 1800)
	
	(sleep_until
		(begin
			(if 
				(and
					(= s_bridge_obj_control 0)
					(> (object_get_health crash_generator) 0)
				)			
				(begin				
					(vs_set_cleanup_script gs_dialogue_cleanup)
					(ai_dialogue_enable FALSE)
					
					(print "Chief?  Barrier only works against vehicles...")
					(sleep (ai_play_line_on_object none 030MF_140) )
					
					(print "You should be able to walk right through")
					(sleep (ai_play_line_on_object none 030MF_150) )
					(vs_release_all)
					
					(sleep 1800)
				)
			)
			(if 
				(and
					(= s_bridge_obj_control 0)
					(> (object_get_health crash_generator) 0)
				)			
				(begin				
					(vs_set_cleanup_script gs_dialogue_cleanup)
					(ai_dialogue_enable FALSE)
					
					(print "Take down that barrier, Chief!")
					(sleep (ai_play_line_on_object none 030MF_160) )
							
					(print "Power source should be inside that tunnel!")
					(sleep (ai_play_line_on_object none 030MF_170) )
					(vs_release_all)
					
					(sleep 1800)
				)
			)
			(if 
				(and
					(= s_bridge_obj_control 0)
					(> (object_get_health crash_generator) 0)
				)			
				(begin				
					(vs_set_cleanup_script gs_dialogue_cleanup)
					(ai_dialogue_enable FALSE)
					
					(print "Take down that barrier, Chief!")
					(sleep (ai_play_line_on_object none 030MF_180) )
							
					(print "Power source should be inside that tunnel!")
					(sleep (ai_play_line_on_object none 030MF_190) )
					(vs_release_all)
					
					(sleep 1800)
				)
			)						
		(or
			(>= s_bridge_obj_control 1)
			(<= (object_get_health crash_generator) 0)
		))
	)

	(ai_dialogue_enable TRUE)
)

;navpoint just in case
(script dormant sc_crash_navpoint

	(sleep_until (<= (ai_task_count obj_crash_cov/non_bugger_gate) 2) 5)
	
	(sleep 2700)
	
	(if (= s_bridge_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player crash_navpoint 0.55)
			(sleep_until 
				(or
					(<= (object_get_health crash_generator) 0) 
					(= s_bridge_obj_control 1)
				)		
			1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player crash_navpoint)
		)
	)
)

;script for the truth hologram
(script dormant sc_crash_truth
	(object_create_anew crash_truth_biped)
	(object_create_anew crash_truth_throne)
	(object_create_anew crash_truth_battery)
	(objects_attach crash_truth_battery "attach_marker" crash_truth_biped "")
	(objects_attach crash_truth_biped "driver" crash_truth_throne "driver")
	
	
	(sleep_until (volume_test_players tv_crash_truth))
	(gs_crash_truth_flicker)
	(object_hide crash_truth_biped FALSE)
	(object_hide crash_truth_throne FALSE)
	(unit_limit_lipsync_to_mouth_only crash_truth_biped TRUE)
		(sleep 15)
		
	(if (> (object_get_health crash_truth_battery) 0)
		(begin
		    (custom_animation crash_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth3" TRUE)
			(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_030_pot crash_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_030_pot))
				(sleep 30)
		)
	)
	(if (> (object_get_health crash_truth_battery) 0)
		(begin
		    (custom_animation crash_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_b\030_truth_b.model_animation_graph "030_cin_truth2" TRUE)
			(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_040_pot crash_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_040_pot))
				(sleep 30)
		)
	)	
		
		
	;*(if (> (object_get_health crash_truth_battery) 0)
		(begin
		    (custom_animation crash_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth" TRUE)
			(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_060_pot crash_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_060_pot))
				(sleep 30)
		)
	)
	(if (> (object_get_health crash_truth_battery) 0)
		(begin	
		    (custom_animation crash_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth2" TRUE)
			(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_070_pot crash_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_070_pot))
				(sleep 30)
		)
	)
	(if (> (object_get_health crash_truth_battery) 0)
		(begin		
		    (custom_animation crash_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth3" TRUE)
			(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_030_pot crash_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_030_pot))
				(sleep 45)
		)
	)*;	
	(gs_crash_truth_flicker)
	(object_destroy crash_truth_biped)
	(object_destroy crash_truth_throne)
)

;start the music
(script dormant sc_crash_music
	(sleep_until 
		(or
			(<= (object_get_health crash_generator) 0)
			(>= s_bridge_obj_control 1)
		)
	)
		(wake 030_music_04_stop)
		(wake 030_music_05_start)

)

;=======================================================
;==========Bridge Ambient===============================
;=======================================================
(global boolean persp_over FALSE)
;(global boolean perspective_skipped FALSE)
(global boolean bridge_ark_random FALSE)

(global short s_bridge_vehicle_exit 0)

(global ai bridge_ark_commenter NONE)
(global ai act_bridge_getout NONE)

(global object o_bridge_veh_0 NONE)

;command script to exit vehicles
(script command_script cs_bridge_exit_vehicle
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_enable_moving true)	
	(cs_force_combat_status 3)
	(cs_vehicle_speed 2)
	
	(sleep_until (= (volume_test_object tv_bridge_oc5 ai_current_actor) 1) 5)
		(sleep (random_range 1 45) )
		(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) TRUE)
		(ai_vehicle_exit ai_current_actor)
)

;Dialog flavor telling the player to get out of the vehicle
(script dormant sc_bridge_dialog_getout
	(sleep_until (>= s_bridge_obj_control 5) 1)
	(vs_cast sg_allied_vehicles TRUE 0 "030MG_060")
	(set act_bridge_getout (vs_role 1))
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(vs_abort_on_damage TRUE)	
	(ai_dialogue_enable FALSE)
	
	(print "MARINE: Highway's wasted.  Gonna have to hoof it from here.")
	(vs_play_line act_bridge_getout TRUE 030MG_060)
	
	(ai_dialogue_enable TRUE)
	
	(vs_release_all)

)

;script to call the fly by cruiser
(script dormant sc_bridge_overhead_cruiser
	(sleep_until (>= s_bridge_obj_control 2) 1)
	
	(object_create_anew cruiser_flyover)
	(object_set_always_active cruiser_flyover TRUE)
	(object_cinematic_visibility cruiser_flyover TRUE)
	(sleep 1)

	(wake sc_bridge_rumble)
	(sleep 30)

	(scenery_animation_start cruiser_flyover objects\vehicles\cov_cruiser\cinematics\vignettes\030vc_cruiser_overhead\030vc_cruiser_overhead "cruiser")
	(object_set_custom_animation_speed cruiser_flyover 0.10)

)

;script to rumble the camera and controller when the cruiser flies overhead
(script dormant sc_bridge_rumble
	(player_effect_set_max_rotation 1 1 1)
	(player_effect_set_max_rumble 1 1)
	
	;(sleep 30)
	(print "rumble start")
	(player_effect_start 1 5)
	(sleep 120)
	(player_effect_stop 3)
	(print "rumble stop")
)

;title bar script
(script dormant sc_bridge_title2
	(chapter_start)
	(cinematic_set_title title_2)
		(sleep 150)
	(chapter_stop)
	
	; wake music script 
	(wake 030_music_05_stop)
)

;title bar script
(script dormant sc_bridge_title2_insertion
	(sleep 30)
	(cinematic_set_title title_2)	
	(cinematic_title_to_gameplay)
	
	; wake music script 
	(wake 030_music_05_stop)
)

;Flavor dialog
(script dormant sc_bridge_dialog01

	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(sleep (random_range 60 100) )

	(print "Commander? ==== ONI recon one-eleven...")
	(sleep (ai_play_line_on_object none 030ME_010) )

	(print "The cruisers above ====  They've found ====")
	(sleep (ai_play_line_on_object none 030ME_020) )

	(print "Say again, recon?  You're breaking up.")
	(sleep (ai_play_line_on_object none 030ME_030) )

	(print "There's something in the crater, ma'am!  Something beneath the storm!")
	(sleep (ai_play_line_on_object none 030ME_040) )
	(ai_dialogue_enable TRUE)
	

)

;second briefing sound
(script dormant sc_bridge_brief02_sound
		(if (>= (game_insertion_point_get) 1) (sleep 90) (sleep 30))
	(ai_dialogue_enable FALSE)
	(print "Master Chief?  Finally, a good connection!")
	(sleep (ai_play_line_on_object none 030BB_010))
		(sleep 10)
	
	(print "Truth has excavated a Forerunner artifact...")
	(sleep (ai_play_line_on_object none 030BB_020))
		(sleep 10)
	
	(print "We have to assume it's the Ark.!")
	(sleep (ai_play_line_on_object none 030BB_030))
		(sleep 30)
	
	(print "Keep pushing to the town of Voi, Chief...")
	(sleep (ai_play_line_on_object none 030MX_080))
		(sleep 10)
	
	(print "Re-Supply birds will meet you in the next valley!")
	(sleep (ai_play_line_on_object none 030MX_090))
		(sleep 30)

	(ai_dialogue_enable TRUE)
	
	(game_save)
	(wake objective_1_clear)
	(wake objective_2_set)
	
	(game_insertion_point_unlock 1)

)

;navpoint just in case
(script dormant sc_bridge_navpoint
	(sleep 2700)
	
	(if (= s_garage_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player bridge_navpoint 0.55)
			(sleep_until (>= s_garage_obj_control 1) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player bridge_navpoint)
		)
	)
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
	
	(sleep 5)
	(wake gs_cinematic_lights)
)

(script dormant sc_flock_test
	(wake sc_bridge_flocks)
	(wake sc_bridge_flocks2)
	(wake sc_bridge_flocks3)
)

;script to wrangle the flocks
(script dormant sc_bridge_flocks
	(sleep_until 
		(begin
			(flock_start bridge_flock)
			(sleep (random_range 15 45))
			(flock_stop bridge_flock)
			(sleep (random_range 450 540))
		0)
	)
)

(script dormant sc_bridge_flocks2
	(sleep_until 
		(begin
			(flock_start bridge_flock2)
			(sleep 30)
			(flock_stop bridge_flock2)
			(sleep (random_range 120 180))
		0)
	)
)

(script dormant sc_bridge_flocks3
	(sleep_until 
		(begin
			(flock_start bridge_flock3)
			(sleep (random_range 15 45))
			(flock_stop bridge_flock3)
			(sleep (random_range 500 750))
		0)
	)
)

;=======================================================
;==========Garage Ambient===============================
;=======================================================
(global ai act_garage_approach1 NONE)
(global ai act_garage_approach2 NONE)
(global ai act_garage_marine1 NONE)
(global ai act_garage_marine2 NONE)
(global ai act_garage_marine3 NONE)
(global ai act_garage_marine4 NONE)
(global ai act_garage_wraith_cry NONE)

(global boolean b_garage_gauss_down 0)
(global boolean b_garage_pelican 0)

(global vehicle v_garage_phantom0 NONE)
(global vehicle v_garage_phantom1 NONE)

;marine and covenant health renewal script
(script dormant sc_garage_health_renew
	(sleep_until
		(begin
			(ai_renew sq_garage_initial_mar)
		(or
			(= (volume_test_players tv_garage_near) TRUE) 
			(= s_tether_obj_control 1)	
		))
	30)
)

;marine and covenant health renewal script for guys at the start of the encounter
(script dormant sc_garage_health_renew2
	(sleep_until
		(begin
			(ai_renew sq_garage_initial_mar2)
			(ai_renew sq_garage_initial06)
			(ai_renew sq_garage_initial07)
		(>= s_garage_obj_control 1))
	30)
)

;script to have the chief shoot points
(script command_script cs_garage_chief_shoot
	(cs_abort_on_damage TRUE)
	(cs_force_combat_status 3)
	(cs_go_to garage_pts/p0)
	(sleep_until 
		(begin		
			(cs_shoot_point TRUE garage_pts/p1)
		(or
			(>= s_garage_obj_control 3)
			(>= (ai_task_count obj_garage_marine/ru_fourth) 1)
		))
	)
)

;moves the warthog into the tether encounter if the player takes up a gunner role
(script dormant sc_garage_player_not_driving
	(sleep_until
		(or
			(>= s_tether_obj_control 1)
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_garage_warthog1/driver) "warthog_g" (player0))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_garage_warthog1/driver) "warthog_p" (player0))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_garage_warthog2/driver) "warthog_g" (player0))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location sq_garage_warthog2/driver) "warthog_p" (player0))
		)
	5)
	
	(if (= s_tether_obj_control 0)
		(ai_set_objective sg_allied_vehicles obj_tether_marine)
	)
)

;script to call tell if the player is sniping
(script dormant sc_garage_sniping
	(sleep_until
		(begin
			(player_action_test_reset)
			(sleep 1)
			(OR
				(>= s_garage_obj_control 2)
				(AND
					(player_action_test_primary_trigger)
					(= (volume_test_players tv_garage_oc1) TRUE)
					(OR
						(unit_has_weapon_readied (unit (player0)) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon")
						(unit_has_weapon_readied (unit (player1)) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon")
					)
				)
			)
		)
	1)
	(set b_garage_sniping 1)
	
	(sleep_until (= (volume_test_players tv_garage_oc1) FALSE) 5)
		(set b_garage_sniping 0)	
)

;music for the garage
(script dormant sc_garage_music
	(sleep_until
		(or
			(= (unit_in_vehicle (player0)) TRUE)
			(= (unit_in_vehicle (player1)) TRUE)
			(= (unit_in_vehicle (player2)) TRUE)
			(= (unit_in_vehicle (player3)) TRUE)
			(>= s_tether_obj_control 2)
		)
	)
		(wake 030_music_06_start)
		(wake 030_music_056_stop)
		(wake 030_music_057_stop)
)

;end music at end of garage encounter
(script dormant sc_garage_music_end
	(sleep_until (= (ai_task_count obj_garage_cov/wraith_gate) 0) 1)
		(wake 030_music_055_stop)
)

;script to set the objectives for the ai vehicles to the next set of tasks
(script dormant sc_garage_objective
	(sleep_until (= (unit_in_vehicle (player0)) TRUE) 5)
		(ai_enter_squad_vehicles sg_all_allies)
		
	(sleep_until (>= s_tether_obj_control 1) )
		(ai_set_objective sg_all_allies obj_tether_marine)
		
)

;Sniper checkpoint
(script dormant sc_garage_sniper_checkpoint
	(sleep_until (= (volume_test_players tv_garage_checkpoint01) TRUE) 5)
	(sleep_until (= (volume_test_players tv_garage_checkpoint01) FALSE) 1)
	(game_save)
)

;mid encounter save attempt
(script dormant sc_garage_mid_save
	(sleep_until 
		(and
			(<= (ai_task_count obj_garage_cov/ag_forward_gate) 4)
			(<= (ai_task_count obj_garage_cov/ag_charge) 0)
		)
	5)
	
	(sleep_until (game_safe_to_save) 1 1200)
	(game_save)
)

;script dormant second save attempt
(script dormant sc_garage_mid_save2
	(sleep_until (<= (ai_task_count obj_garage_cov/initial_gate) 2) 5)
	(sleep_until (game_safe_to_save) 1 1200)
	
	(game_save)
)

;script dormant second save attempt
(script dormant sc_garage_mid_save3
	(sleep_until (game_safe_to_save) 1 1200)
	
	(game_save)
)

;first phantom command script with first wave of reinforcements
(script command_script cs_garage_phantom1
	(wake sc_garage_phantom_alive)

	(set v_garage_phantom0 (ai_vehicle_get_from_starting_location sq_garage_phantom1/pilot))
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	
	(game_save)	
	
	(sleep 120)
	
	(cs_fly_to garage_ph1/p0 1)	
	
	(cs_fly_to garage_ph1/p1 1)
	
	(cond 
		((= (game_difficulty_get_real) EASY)
			(ai_place sq_garage_second01)
			(ai_place sq_garage_second02)
		)
		((= (game_difficulty_get_real) NORMAL)
			(ai_place sq_garage_second01)
			(ai_place sq_garage_second02)
			;(ai_place sq_garage_second04)
		)
		((= (game_difficulty_get_real) HEROIC)
			(ai_place sq_garage_second01)
			(ai_place sq_garage_second02)
			(ai_place sq_garage_second03)
			;(ai_place sq_garage_second04)
		)
		((= (game_difficulty_get_real) LEGENDARY)
			(ai_place sq_garage_second01)
			(ai_place sq_garage_second02)
			(ai_place sq_garage_second03)
			;(ai_place sq_garage_second04)
		)
	)	

	(cs_fly_to garage_ph1/p2 1)

	(ai_vehicle_enter_immediate sq_garage_second01 v_garage_phantom0 "phantom_p_lf")	
	(ai_vehicle_enter_immediate sq_garage_second03 v_garage_phantom0 "phantom_p_rf")	
	(ai_vehicle_enter_immediate sq_garage_second02 v_garage_phantom0 "phantom_p_rb")
	
	;(ai_vehicle_enter_immediate sq_garage_second04 v_garage_phantom0 "phantom_p_lb")
	
	(unit_open v_garage_phantom0)	
		
	(cs_fly_to garage_ph1/p3 1)			
	
	(cs_vehicle_speed 0.5)
	;(cs_fly_to garage_ph1/p4 1)
	(cs_fly_to garage_ph1/p5 0.5)
	(cs_face TRUE garage_ph1/p6)
	
	(sleep 20)
	
	;script to attempt an additional save
	(wake sc_garage_mid_save)
	
	(sleep (random_range 10 20))
	(vehicle_unload v_garage_phantom0 "phantom_p_rf")
	(ai_set_objective sq_garage_second03 obj_garage_cov)
	(sleep (random_range 90 115))
	(vehicle_unload v_garage_phantom0 "phantom_p_lf")
	(ai_set_objective sq_garage_second01 obj_garage_cov)
	(sleep (random_range 30 75))
	(vehicle_unload v_garage_phantom0 "phantom_p_rb")
	(ai_set_objective sq_garage_second02 obj_garage_cov)
	(sleep (random_range 30 75))
	(vehicle_unload v_garage_phantom0 "phantom_p_lb")	
	;(ai_set_objective sq_garage_second04 obj_garage_cov)
	
	(sleep 120)
		
	(set s_garage_phantom 1)	
	(cs_vehicle_speed 1)
	
	(cs_fly_to garage_ph1/p7 1)
	(cs_fly_to garage_ph1/p8 1)
	(cs_fly_to garage_ph1/p9 1)
	(cs_fly_to garage_ph1/p10 1)
	(cs_fly_to garage_ph1/p11 1)
	(ai_erase ai_current_squad)
)

;tests to see if phantom is dead which calls the pelican drop off
(script dormant sc_garage_phantom_alive
	(sleep_until 
		(or
			(= (ai_living_count sq_garage_phantom1) 0)
			(<= (object_get_health v_garage_phantom0) 0)
		)
	)
		(set s_garage_phantom 1)
)

;first phantom command script with first wave of reinforcements
(script command_script cs_garage_phantom2
	(wake sc_garage_phantom_alive2)

	(set v_garage_phantom1 (ai_vehicle_get_from_starting_location sq_garage_phantom2/pilot))
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	
	(game_save)	
	
	(sleep 30)
	
	(cs_fly_to garage_ph1/p0 1)	
	
	(cs_fly_to garage_ph1/p1 1)
	
	(ai_place sq_garage_third01)
	(ai_place sq_garage_third03)
	(if	(or
			(>= (game_difficulty_get) legendary)
			(= (game_is_cooperative) TRUE)
		)
		(ai_place sq_garage_third02)
	)

	(cs_fly_to garage_ph1/p2 1)

	(ai_vehicle_enter_immediate sq_garage_third01 v_garage_phantom1 "phantom_p_lf")	
	(ai_vehicle_enter_immediate sq_garage_third02 v_garage_phantom1 "phantom_p_rf")
	(ai_vehicle_enter_immediate sq_garage_third03 v_garage_phantom1 "phantom_p_rb")
	
	(unit_open v_garage_phantom1)
		
	(cs_fly_to garage_ph1/p3 1)		
	
	(cs_vehicle_speed 0.5)
	(cs_fly_to garage_ph1/p5 0.5)
	(cs_face TRUE garage_ph1/p6)
	
	(sleep 20)
	
	(sleep (random_range 10 20))
	(vehicle_unload v_garage_phantom1 "phantom_p_rf")
	(ai_set_objective sq_garage_third02 obj_garage_cov)
	(sleep (random_range 90 115))
	(vehicle_unload v_garage_phantom1 "phantom_p_lf")
	(ai_set_objective sq_garage_third01 obj_garage_cov)
	(sleep (random_range 90 115))
	(vehicle_unload v_garage_phantom1 "phantom_p_rb")
	(ai_set_objective sq_garage_third03 obj_garage_cov)
	
	(sleep 120)
		
	(set s_garage_phantom 2)	
	(cs_vehicle_speed 1)
	
	(cs_fly_to garage_ph1/p7 1)
	(cs_fly_to garage_ph1/p8 1)
	(cs_fly_to garage_ph1/p9 1)
	(cs_fly_to garage_ph1/p10 1)
	(cs_fly_to garage_ph1/p11 1)
	(ai_erase ai_current_squad)
)

;tests to see if phantom is dead which calls the pelican drop off
(script dormant sc_garage_phantom_alive2
	(sleep_until 
		(or
			(= (ai_living_count sq_garage_phantom2) 0)
			(<= (object_get_health v_garage_phantom1) 0)
		)
	)
		(set s_garage_phantom 2)
)

;first pelican command script
(script command_script cs_garage_pelican1
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	(cs_fly_to garage_pelican1/p0 1)
	
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) TRUE)
	
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_g" TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_e" TRUE)
	
	(ai_place sq_garage_warthog1)
	(sleep 5)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_lc" (ai_vehicle_get_from_starting_location sq_garage_warthog1/driver))
		
	(ai_place sq_garage_marine02)
	(sleep 5)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p" (ai_actors sq_garage_marine02) )
	
	(cs_fly_to garage_pelican1/p1 1)
	
	;next script is a dialog call
	(wake sc_garage_pelican_inc)
		
	(cs_fly_to garage_pelican1/p2 1)
	(cs_fly_to garage_pelican1/p3 1)
	(cs_fly_to garage_pelican1/p5 1)
	(cs_fly_to_and_face garage_pelican1/p4 garage_pelican1/p9 1)
	(cs_vehicle_speed 0.5)
	
	;next script is a dialog call
	(wake sc_garage_pelican_drop)
	
	(sleep 60)
	(sleep_until (= (volume_test_players tv_garage_pelican1) FALSE) 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_lc")

	; wake music 
	(wake sc_garage_music)
	(sleep 30)
	
	
	(cs_face TRUE garage_pelican1/p10)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l01")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l01" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r01")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r01" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l02")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l02" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r02")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r02" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l03")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l03" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r03")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r03" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l04")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l04" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r04")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r04" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l05")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_l05" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r05")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican1/pilot) "pelican_p_r05" TRUE)
	(sleep 30)
	
	(ai_enter_squad_vehicles sg_all_allies)
	(cs_vehicle_speed 1)
	(cs_fly_to garage_pelican1/p5 1)
	
	(set b_garage_pelican 1)
	
	(cs_fly_to_and_face garage_pelican1/p6 garage_pelican1/p7 1)
	(sv_garage_kill_player)
	(cs_fly_to_and_face garage_pelican1/p7 garage_pelican1/p8 1)
	(cs_fly_to garage_pelican1/p8 1)
	(ai_erase ai_current_squad)
)

;second pelican command script
(script command_script cs_garage_pelican2
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_g" TRUE)
	
	(ai_place sq_garage_warthog2)
	(sleep 5)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_lc" (ai_vehicle_get_from_starting_location sq_garage_warthog2/driver))
	
	(ai_place sq_garage_marine03)
	(sleep 5)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p" (ai_actors sq_garage_marine03) )	
	
	(cs_fly_to garage_pelican2/p0 1)	
	(cs_fly_to garage_pelican2/p1 1)
	(cs_fly_to garage_pelican2/p2 1)
	(cs_fly_to garage_pelican2/p3 1)
	(cs_fly_to garage_pelican2/p4 1)
	
	(sleep_until 
		(or
			(= b_garage_pelican 1)
			(= (object_get_health (ai_get_object sq_garage_pelican1/pilot)) 0)			
		)
	)
	
	(cs_fly_to garage_pelican2/p5 1)
	(cs_fly_to_and_face garage_pelican2/p6 garage_pelican2/p7 1)
	(cs_vehicle_speed 0.5)
	
	(sleep 60)
	(sleep_until (= (volume_test_players tv_garage_pelican2) FALSE) 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_lc")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_lc" TRUE)
	(sleep 30)
	(cs_face TRUE garage_pelican2/p12)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l01")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l01" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r01")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r01" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l02")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l02" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r02")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r02" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l03")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l03" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r03")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r03" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l04")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l04" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r04")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r04" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l05")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_l05" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r05")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_p_r05" TRUE)
	(sleep 120)	
	
	(ai_enter_squad_vehicles sg_all_allies)
	(cs_vehicle_speed 1)
	
	(cs_fly_to_and_face garage_pelican2/p13 garage_pelican2/p8 1)
	(sv_garage_kill_player)
	(cs_fly_to_and_face garage_pelican2/p8 garage_pelican2/p9 1)
	
	;boolean to get the wraith active
	(set b_tether_wraith_awake 1)
	
	(cs_fly_to_and_face garage_pelican2/p9 garage_pelican2/p10 1)
	(cs_fly_to_and_face garage_pelican2/p10 garage_pelican2/p11 1)
	(cs_fly_to garage_pelican2/p11 1)
	(ai_erase ai_current_squad)
)

;second pelican command script
(script command_script cs_garage_pelican3
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location sq_garage_pelican3/pilot) TRUE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_g" TRUE)
	
	(ai_place sq_garage_warthog3)
	(sleep 5)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_garage_pelican3/pilot) "pelican_lc" (ai_vehicle_get_from_starting_location sq_garage_warthog3/driver))
		
	(cs_fly_to garage_pelican3/p0 1)	
	(cs_fly_to garage_pelican3/p1 1)
	(cs_fly_to garage_pelican3/p2 1)
	(cs_fly_to garage_pelican3/p3 1)
	(cs_fly_to garage_pelican3/p4 1)
	
	(cs_fly_to garage_pelican3/p5 1)
	(cs_fly_to_and_face garage_pelican3/p6 garage_pelican3/p7 1)
	(cs_vehicle_speed 0.5)
	
	(sleep 30)
	(sleep_until (= (volume_test_players tv_garage_pelican2) FALSE) 5)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_garage_pelican3/pilot) "pelican_lc")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_garage_pelican2/pilot) "pelican_lc" TRUE)
	(sleep 30)	
	
	(ai_enter_squad_vehicles sg_all_allies)
	(cs_vehicle_speed 1)
	
	(cs_fly_to_and_face garage_pelican3/p13 garage_pelican3/p8 1)
	(sv_garage_kill_player)
	(cs_fly_to_and_face garage_pelican3/p8 garage_pelican3/p9 1)
	
	;boolean to get the wraith active
	(set b_tether_wraith_awake 1)
	
	(cs_fly_to_and_face garage_pelican3/p9 garage_pelican3/p10 1)
	(cs_fly_to_and_face garage_pelican3/p10 garage_pelican3/p11 1)
	(cs_fly_to garage_pelican3/p11 1)
	(ai_erase ai_current_squad)
)


;script to kill the player that rides on a pelican
(script static void sv_garage_kill_player
	(if (volume_test_object tv_garage_pelican_kill (player0)) (unit_kill (player0)))
	(if (volume_test_object tv_garage_pelican_kill (player1)) (unit_kill (player1)))
	(if (volume_test_object tv_garage_pelican_kill (player2)) (unit_kill (player2)))
	(if (volume_test_object tv_garage_pelican_kill (player3)) (unit_kill (player3)))
)


;Marines happy to see the chief
(script dormant sc_garage_chatter01
	(sleep_until (= (volume_test_players tv_garage_near) TRUE) )
	
	(vs_cast sg_garage_mar TRUE 50 "030MH_010")
	(set act_garage_approach1 (vs_role 1))
	
	(vs_cast sg_garage_mar FALSE 50 "030MH_020" "030MH_020" "030MH_020" "030MH_020")
	(set act_garage_marine1 (vs_role 1))
	(set act_garage_marine2 (vs_role 2))
	(set act_garage_marine3 (vs_role 3))
	(set act_garage_marine4 (vs_role 4))	
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
    	(vs_abort_on_damage TRUE)	
   	(ai_dialogue_enable FALSE)
	
	(print "MARINE:  We got reinforcements, marines!")
	(vs_play_line act_garage_approach1 TRUE 030MH_010)
	(sleep 10)

	(print "MARINE:  Ooh-Rah!  Alright!   Hell yeah!")
	(vs_play_line act_garage_marine1 FALSE 030MH_020)
	(sleep (random_range 1 3))
	(vs_play_line act_garage_marine2 FALSE 030MH_020)
	(sleep (random_range 1 3))
	(vs_play_line act_garage_marine3 FALSE 030MH_020)
	(sleep (random_range 1 3))
	(vs_play_line act_garage_marine4 FALSE 030MH_020)
	(sleep (random_range 1 3))
	(sleep 10)
	
	(ai_dialogue_enable TRUE)

	(vs_release_all)
)

;Marine chatter during lull in encounte
(script dormant sc_garage_chatter02
	(sleep_until 
		(and
			(= (volume_test_players tv_garage_near) TRUE)
			(script_finished sc_garage_chatter01)
		) 
	)
	(ai_dialogue_enable FALSE)	
	(sleep (random_range 150 210) )

	(print "MARINE:  Sir! Recon spotted Covenant armor ahead!")
	(sleep (ai_play_line_on_object none 030MH_030) )
	(sleep 10)

	(print "MARINE:  Pelican are inbound with heave weapons...")
	(sleep (ai_play_line_on_object none 030MH_040) )
	(sleep 10)

	(print "MARINE:  We need to hold out until they arrive!")
	(sleep (ai_play_line_on_object none 030MH_050) )
	(sleep 10)
	(ai_dialogue_enable TRUE)

	(vs_release_all)
)

;Marine chatter to keep player in garage
(script dormant sc_garage_chatter03
	(sleep_until
		(and
			(< (ai_task_count obj_garage_cov/main_gate) 3)
			(= (volume_test_players tv_tether_oc1) TRUE)
			(= b_garage_gauss_down 0)
		)
	)	
	(ai_dialogue_enable FALSE)
	(print "MARINE:  You got hostile armor ahead, Chief!")
	(sleep (ai_play_line_on_object NONE 030MH_060))
	(sleep 10)
	
	(print "MARINE:  I rounded up a few re-supply birds....")
	(sleep (ai_play_line_on_object NONE 030MH_070))
	(sleep 10)
	
	(print "MARINE:  Advise you maintain position until they arrive!")
	(sleep (ai_play_line_on_object NONE 030MH_080))
	(ai_dialogue_enable TRUE)
)

;Marine chatter about incomming pelicans
(script dormant sc_garage_pelican_inc
	(if (> (ai_living_count sq_garage_initial_mar/02) 0)
		(begin		
			(vs_cast sg_garage_mar TRUE 60 "030MH_010")
			(set act_garage_approach1 (vs_role 1))
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(vs_abort_on_damage TRUE)	
			(ai_dialogue_enable FALSE)		
		
			(print "MARINE:  Pelicans comming in!")
			(vs_play_line act_garage_approach1 TRUE 030MH_090)
			(sleep 10)
			
			(print "Johnson: Brutes have plenty of armor between here and Voi, Chief.")
			(sleep (ai_play_line_on_object NONE 030MX_140))
			(sleep 10)
			
			(print "Johnson: But this Warthog should help you punch on through!")
			(sleep (ai_play_line_on_object NONE 030MX_150))				
			(ai_dialogue_enable TRUE)
			
		)
		(begin
			(print "Johnson: Watch it now!  Pelican coming in!")
			(sleep (ai_play_line_on_object NONE 030MX_130))
			(sleep 10)
			
			(print "Johnson: Brutes have plenty of armor between here and Voi, Chief.")
			(sleep (ai_play_line_on_object NONE 030MX_140))
			(sleep 10)
			
			(print "Johnson: But this Warthog should help you punch on through!")
			(sleep (ai_play_line_on_object NONE 030MX_150))	
		)
	)

	(vs_release_all)
)

;Marine chatter about incomming wraiths
(script dormant sc_garage_wraith_inc

	(sleep_until (= s_garage_wraith 2) 1)

	
	(vs_cast sg_all_allies TRUE 50 "030MH_160")
	(set act_garage_wraith_cry (vs_role 1))
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(vs_abort_on_damage TRUE)	
	(ai_dialogue_enable FALSE)
	
	(begin_random
		(begin
			(print "MARINE:  Wraith!  Get to cover!")
			(vs_play_line act_garage_wraith_cry TRUE 030MH_160)
			(sleep 10)
			(vs_release_all)
			(sleep_forever)
		)
		(begin
			(print "MARINE:  Wraith!  Watch yourself, Chief!")
			(vs_play_line act_garage_wraith_cry TRUE 030MH_170)
			(sleep 10)
			(vs_release_all)
			(sleep_forever)
		)
	)
	
	(ai_dialogue_enable TRUE)
	(vs_release_all)
	(wake sc_garage_wraith_nasty)
)

;Marine chatter about nasty nasty wraiths
(script dormant sc_garage_wraith_nasty

	(sleep (random_range 120 160) )

	(vs_cast sg_all_allies TRUE 50 "030MH_180")
	(set act_garage_wraith_cry (vs_role 1))
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(vs_abort_on_damage TRUE)	
	(ai_dialogue_enable FALSE)
	
	(if (> (ai_task_count obj_garage_cov/main_gate) 0)
		(print "MARINE:  Damn tank will kills us all if we let it!")
		(vs_play_line act_garage_wraith_cry TRUE 030MH_180)
	)
	(ai_dialogue_enable TRUE)

	(vs_release_all)
	
	(sleep (random_range 120 160) )
	
	(vs_cast sg_all_allies FALSE 5 "030MH_200")
	(set act_garage_marine1 (vs_role 1))
	
	(ai_dialogue_enable FALSE)

	(if (> (ai_task_count obj_garage_cov/main_gate) 0)
		(print "MARINE:  You wanna live, Chief, you best kill that Wraith!")
		(vs_play_line act_garage_wraith_cry TRUE 030MH_200)
	)
	(ai_dialogue_enable TRUE)

	(vs_release_all)
)

;Radio chatter calling out pelicans inbound
(script dormant sc_garage_pelican_drop	
	(set b_garage_gauss_down 1)
)

;navpoint just in case
(script dormant sc_garage_navpoint
	(sleep_until 
		(and
			(= (ai_task_count obj_garage_cov/wraith_gate) 0) 
			(= s_garage_wraith 2)
		)
	)
	(sleep 2700)
	
	(if (= s_tether_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player garage_navpoint 0.55)
			(sleep_until (>= s_tether_obj_control 1) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player garage_navpoint)
		)
	)
)

;==============================================================
;==========Tether==============================================
;==============================================================

(global ai act_tether_prompt NONE)

;Reminder script if you're taking too long to leave
(script dormant sc_tether_prompt
	
	(sleep_until (= (ai_task_count obj_tether_cov/main_gate) 0) 5)
	
	(sleep 900)
	
	(if (= s_round_obj_control 0)
		(begin
			(vs_cast sg_allied_vehicles TRUE 0 "030MJ_030")
			(set act_tether_prompt (vs_role 1))	
				
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(vs_abort_on_damage TRUE)	
			(ai_dialogue_enable FALSE)
			
			(print "We're getting close to Voi!  Keep going!")
			(vs_play_line act_tether_prompt TRUE 030MJ_030)
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
	
	(sleep 1800)
	
	(if (= s_bridge_obj_control 0)
		(begin
			(vs_cast sg_crash_marines TRUE 0 "030MJ_060")
			(set act_tether_prompt (vs_role 1))	
				
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(vs_abort_on_damage TRUE)	
			(ai_dialogue_enable FALSE)
			
			(print "Pedal to the metal, Chief!  Just a few more klicks!")
			(vs_play_line act_tether_prompt TRUE 030MJ_060)
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
)

;navpoint just in case
(script dormant sc_tether_navpoint
	(sleep_until (= (ai_task_count obj_tether_cov/mg_no_sniper) 0) )
	(sleep 1800)
	
	(if (= s_round_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player tether_navpoint 0.55)
			(sleep_until (>= s_round_obj_control 1) 1)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player tether_navpoint)
		)
	)
)

;==============================================================
;==========Round===============================================
;==============================================================

(global ai act_round_holdout NONE)
(global ai act_round_prompt NONE)
(global ai act_round_vista1 NONE)
(global ai act_round_vista2 NONE)

(global short s_round_left_right 0)
(global short s_round_rock_list_count 0)

(global vehicle v_round_phantom1 NONE)
(global vehicle v_round_wraith NONE)
(global vehicle v_round_chopper1 NONE)
(global vehicle v_round_chopper2 NONE)
(global vehicle v_round_chopper3 NONE)
(global vehicle v_round_chopper4 NONE)
(global vehicle v_round_phantom2 NONE)
(global vehicle v_round_phantom3 NONE)

(global object_list ol_round_rock_kill (players))

;script to get a save game when enemies fall back
(script dormant sc_round_fallback_save
	(sleep_until (<= (ai_task_count obj_round_cov/main_gate) 3) 5)
	
	(sleep_until (game_safe_to_save) 1 1200)
	
	(game_save)
	
	(sleep_until (<= (ai_task_count obj_round_cov/main_gate) 3) 5)
	
	(sleep_until (game_safe_to_save) 1 1200)
	
	(game_save)
)

;script dormant second save attempt
(script dormant sc_round_mid_save
	(sleep_until (<= (ai_task_count obj_round_cov/main_gate) 6) 5)
	(sleep_until (game_safe_to_save) 1 1200)
	
	(game_save)
)

;script to get the marines before the jump to get in some hogs
(script dormant sc_round_holdout_hogs
	(sleep_until (= (ai_task_count obj_round_cov_hold/hold_gate) 0) )
		(ai_enter_squad_vehicles sg_all_allies)
		(game_save)
)

;round phantom with chopper drop off
(script command_script cs_round_phantom1

	(set v_round_phantom1 (ai_vehicle_get_from_starting_location sq_round_phantom01/pilot))
	
	(ai_place sq_round_wraith01)
	(sleep 1)
	(set v_round_wraith (ai_vehicle_get_from_starting_location sq_round_wraith01/pilot))
	
	(sleep 1)
	(vehicle_load_magic v_round_phantom1 "phantom_lc" v_round_wraith)
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	
	(cs_fly_to round_ph1/p0 1)	
	
	(game_save)
		
	(cs_fly_to round_ph1/p1 1)
	(cs_fly_to round_ph1/p2 1)	
	
	(unit_open v_round_phantom1)	
		
	(cs_fly_to round_ph1/p3 1)	
	(cs_fly_to round_ph1/drop 1)
	
	(vehicle_unload v_round_phantom1 "phantom_lc")
	
	(cs_fly_to round_ph1/p4 1)
	(cs_fly_to round_ph1/p5 1)
	(cs_fly_to round_ph1/p6 1)
	(cs_fly_to round_ph1/p7 1)
	(cs_fly_to round_ph1/p8 1)
	
	(game_save)	
	
	(ai_erase ai_current_squad)
)

;round phantom with chopper drop off
(script command_script cs_round_phantom2

	(set v_round_phantom2 (ai_vehicle_get_from_starting_location sq_round_phantom02/pilot))
	
	(ai_place sq_round_chopper01)
	(sleep 1)
	(set v_round_chopper1 (ai_vehicle_get_from_starting_location sq_round_chopper01/01))
	(set v_round_chopper2 (ai_vehicle_get_from_starting_location sq_round_chopper01/02))
	
	(sleep 1)
	(vehicle_load_magic v_round_phantom2 "phantom_sc01" v_round_chopper1)
	(vehicle_load_magic v_round_phantom2 "phantom_sc02" v_round_chopper2)
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	
	(cs_vehicle_speed 2)
	
	(cs_fly_to round_ph2/p0 1)
	
	(game_save)
			
	(cs_fly_to round_ph2/p1 1)
	
	(cs_vehicle_speed 1)
	
	(cs_fly_to round_ph2/p2 1)	
	
	(unit_open v_round_phantom2)	
		
	(cs_fly_to round_ph2/p3 1)	
	
	(vehicle_unload v_round_phantom2 "phantom_sc01")
	
	(cs_fly_to round_ph2/p4 1)
	
	(vehicle_unload v_round_phantom2 "phantom_sc02")
	
	(cs_fly_to round_ph2/p5 1)
	(cs_fly_to round_ph2/p6 1)
	(cs_fly_to round_ph2/p7 1)
	(cs_fly_to round_ph2/p8 1)
	
	(game_save)	
	
	(ai_erase ai_current_squad)
)

;round phantom with chopper drop off
(script command_script cs_round_phantom3

	(set v_round_phantom3 (ai_vehicle_get_from_starting_location sq_round_phantom03/pilot))
	
	(ai_place sq_round_chopper02)
	(sleep 1)
	(set v_round_chopper3 (ai_vehicle_get_from_starting_location sq_round_chopper02/01))
	(set v_round_chopper4 (ai_vehicle_get_from_starting_location sq_round_chopper02/02))
	
	(sleep 1)
	(vehicle_load_magic v_round_phantom3 "phantom_sc01" v_round_chopper3)
	(vehicle_load_magic v_round_phantom3 "phantom_sc02" v_round_chopper4)
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	
	(cs_fly_to round_ph3/p0 1)
	
	(game_save)	
			
	(cs_fly_to round_ph3/p1 1)
	(cs_fly_to round_ph3/p2 1)	
	
	(unit_open v_round_phantom3)	
		
	(cs_fly_to round_ph3/p3 1)	
	
	(vehicle_unload v_round_phantom3 "phantom_sc01")
	
	(cs_fly_to round_ph3/p4 1)
	
	(vehicle_unload v_round_phantom3 "phantom_sc02")
	
	(cs_fly_to round_ph3/p5 1)
	(cs_fly_to round_ph3/p6 1)
	(cs_fly_to round_ph3/p7 1)
	
	(game_save)	
	
	(ai_erase ai_current_squad)
)

;kills all dudes under the rock that blocks your path
(script dormant sc_round_rock_kill
	(set ol_round_rock_kill (volume_return_objects_by_type tv_round_rock_kill 3)) 
	(sleep_until	
		(begin
			(unit_kill (unit (list_get ol_round_rock_kill s_round_rock_list_count)))
			(set s_round_rock_list_count (+ s_round_rock_list_count 1))
		(>= s_round_rock_list_count (list_count ol_round_rock_kill)))
	)
)

;music 06 stop script
(script dormant sc_round_music_stop
	(sleep_until 
		(or
			(= (ai_task_count obj_round_cov/main_gate) 0)
			(>= s_exit_obj_control 1)
		)
	)
	(wake 030_music_06_stop)
	(wake 030_music_07_start)
)

;Marines happy to see the chief
(script dormant sc_round_holdout_dialog
	(sleep_until (= (ai_task_count obj_round_cov_hold/hold_gate) 0) )
	
	(sleep (random_range 60 120))
	
	(vs_cast sq_round_marine01 FALSE 50 "030MX_160")
	(set act_round_holdout (vs_role 1))
	
	(if (< (ai_living_count act_round_holdout) 1)
		(begin
			(vs_cast sq_round_warthog01 FALSE 50 "030MX_160")
			(set act_round_holdout (vs_role 1))
		)
	)
	
	(vs_abort_on_damage TRUE)	
	
	(print "MARINE:  Wraiths, Master Chief!  Circling that hill!")
	(vs_play_line act_round_holdout TRUE 030MX_160)
	(sleep 10)

	(print "MARINE:  Brute choppers too, so stay sharp!")
	(vs_play_line act_round_holdout TRUE 030MX_170)
	(sleep 10)
	
	(wake 030_music_06_start_alt)

	(vs_release_all)
)

;marine dialog regarding tether pieces
(script dormant sc_round_dialog_storm

	(sleep_until 
		(and
			(= (ai_task_count obj_round_cov/main_gate) 0)
			(or
				(= (volume_test_players tv_round_vista1) 1)
				(= (volume_test_players tv_round_vista2) 1)
			)
		)
	5)
	
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	(begin_random
		(begin		
			(print "Look at the size of that thing... Wonder how old it is?")
			(sleep (ai_play_line_on_object none 030MJ_010) )
			
			(print "Dunno... But I do know that ain't a normal storm...")
			(sleep (ai_play_line_on_object none 030MJ_020) )
			
			(ai_dialogue_enable TRUE)			
			(sleep_forever)
		)
		(begin
			(print "Commander?  I can see most of it now...")
			(sleep (ai_play_line_on_object none 030MG_010) )
		
			(print "Readings are all over the EM spectrum!")
			(sleep (ai_play_line_on_object none 030MG_020) )
		
			(print "Roger that, recon.  Shutter your gear, pull back...")
			(sleep (ai_play_line_on_object none 030MG_030) )
		
			(print "I'll continue monitoring from kilo two three.")
			(sleep (ai_play_line_on_object none 030MG_040) )
			
			(ai_dialogue_enable TRUE)			
			(sleep_forever)
		)
	)
	
	(ai_dialogue_enable TRUE)

)

;Reminder script if you're taking too long to leave
(script dormant sc_round_prompt
	
	(sleep_until (= (ai_task_count obj_round_cov/main_gate) 0) 5)
	
	(sleep 900)
	
	(if (= s_exit_obj_control 0)
		(begin
			(vs_cast sg_allied_vehicles TRUE 0 "030MK_010")
			(set act_round_prompt (vs_role 1))	
				
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(vs_abort_on_damage TRUE)	
			(ai_dialogue_enable FALSE)
			
			(print "Head for high ground!  Gotta keep rolling!")
			(vs_play_line act_tether_prompt TRUE 030MK_010)
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
	
	(sleep 1800)
	
	(if (= s_exit_obj_control 0)
		(begin
			(vs_cast sg_crash_marines TRUE 0 "030MK_030")
			(set act_round_prompt (vs_role 1))	
				
			(vs_set_cleanup_script gs_dialogue_cleanup)
			(vs_abort_on_damage TRUE)	
			(ai_dialogue_enable FALSE)
			
			(print "Head on up the hill!  Push to Voi!")
			(vs_play_line act_tether_prompt TRUE 030MK_030)
			(vs_release_all)
		)
	)

	(ai_dialogue_enable TRUE)
)

;navpoint just in case
(script dormant sc_round_navpoint
	(sleep_until (= (ai_task_count obj_round_cov/main_gate) 0) )
	(sleep 1800)
	
	(if (= s_exit_obj_control 0) 
		(begin	
			(hud_activate_team_nav_point_flag player round_navpoint 0.55)
			(sleep_until 
				(or
					(<= (objects_distance_to_flag (players) round_navpoint) 5) 
					(>= s_round_obj_control 4)
				)		
			)
			(sleep 1)
			(hud_deactivate_team_nav_point_flag player round_navpoint)			
		)
	)
)

;==============================================================
;==========Exit================================================
;==============================================================

(global boolean b_exit_player_driving 0)
(global boolean b_exit_pelican 0)
(global boolean b_exit_brute 0)
(global boolean b_exit_truth_speaks 0)

(global short s_exit_generator_dialog 0)

(global ai act_exit_prompt NONE)
(global ai act_exit_brute01 NONE)
(global ai act_exit_brute02 NONE)

;command script to fly the pelican
(script command_script cs_exit_pelican01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot TRUE)
	
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) TRUE)
	
	(cs_fly_to exit_pel01/p0 0.5)
	(cs_fly_to exit_pel01/p1 0.5)
	(cs_fly_to exit_pel01/p2 0.5)
	(cs_fly_to exit_pel01/p3 0.5)
	(cs_fly_to exit_pel01/p8 0.5)
	(sleep_until (= (volume_test_players tv_exit_pelican_dropoff) 0) 5)
	
	(cs_fly_to exit_pel01/p4 0.5)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l01")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l01" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r01")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r01" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l02")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l02" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r02")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r02" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l03")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l03" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r03")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r03" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l04")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l04" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r04")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r04" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l05")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_l05" TRUE)
	(sleep 15)
	(vehicle_unload (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r05")
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p_r05" TRUE)
	(sleep 120)
	
	(cs_fly_to exit_pel01/p5 0.5)
	(cs_fly_to exit_pel01/p6 0.5)
	
	(sv_exit_kill_player)
	
	(cs_fly_to exit_pel01/p7 0.5)
	
	(set b_exit_pelican 0)
	
	(ai_erase ai_current_squad)
)

;script to destroy shield
(script dormant sc_exit_shield_destroy
	(sleep_until (<= (object_get_health exit_generator) 0) 1)
	
	(object_destroy exit_shield)
	(print "shield is down")
	(wake 030_music_09_stop)
	(wake 030_music_10_stop)
)

;script to kill the player that rides on a pelican
(script static void sv_exit_kill_player
	(if (volume_test_object tv_exit_pelican_kill (player0)) (unit_kill (player0)))
	(if (volume_test_object tv_exit_pelican_kill (player1)) (unit_kill (player1)))
	(if (volume_test_object tv_exit_pelican_kill (player2)) (unit_kill (player2)))
	(if (volume_test_object tv_exit_pelican_kill (player3)) (unit_kill (player3)))
)

;script to get a save game when enemies fall back
(script dormant sc_exit_fallback_save
	
	(sleep_until (<= (ai_task_count obj_exit_cov/main_gate) 6) )
	
	(sleep_until (= (volume_test_players tv_exit_oc4) 1) 5)
	
	(game_save)
	
)

;script to get a save game when infantry guys are dead
(script dormant sc_exit_infantry_save	
	(sleep_until (= (ai_task_count obj_exit_cov/forward_gate) 0) )
	
	(game_save)
	
)

;script to wrangle the flocks
(script dormant sc_exit_flocks
	(sleep_until 
		(begin
			(flock_start exit_flock)
			(sleep (random_range 30 45))
			(flock_stop exit_flock)
			(sleep (random_range 210 300))
		0)
	)
)

(script dormant sc_exit_flocks2
	(sleep_until 
		(begin
			(flock_start exit_flock2)
			(sleep 30)
			(flock_stop exit_flock2)
			(sleep (random_range 60 90))
		0)
	)
)

(script dormant sc_exit_flocks3
	(sleep_until 
		(begin
			(flock_start exit_flock3)
			(sleep (random_range 30 45))
			(flock_stop exit_flock3)
			(sleep (random_range 210 300))
		0)
	)
)

;command script to get ai out of vehicle
(script command_script cs_exit_exit_vehicle
	(if 
		(or
			(= (vehicle_test_seat (ai_vehicle_get (ai_player_get_vehicle_squad (player0))) "warthog_d" (player0)) 1)
			(= (vehicle_test_seat (ai_vehicle_get (ai_player_get_vehicle_squad (player1))) "warthog_d" (player1)) 1)
			(= (vehicle_test_seat (ai_vehicle_get (ai_player_get_vehicle_squad (player2))) "warthog_d" (player2)) 1)
			(= (vehicle_test_seat (ai_vehicle_get (ai_player_get_vehicle_squad (player3))) "warthog_d" (player3)) 1)
		)
		(begin
			(print "no one driving")
		)
		(begin 
			(ai_vehicle_exit ai_current_actor)
		)
	)
)

;command script to get ai out of vehicle
(script command_script cs_exit_forced_exit
	(ai_vehicle_exit ai_current_actor)

)

;script to end the music mid encounter
(script dormant sc_exit_music_stop
	(sleep_until 
		(or
			(= b_exit_truth_speaks 1)
			(>= s_exit_obj_control 5)
		)
	)
	
	(wake 030_music_07_stop)
)

;script to start music tracks 09 and 10
(script dormant sc_exit_music09_start
	(sleep_until (= (ai_task_count obj_exit_cov/sg_forward_gate) 0) 1)
		(wake 030_music_09_start)
	(sleep_until 
		(or
			(> (ai_task_count obj_exit_cov/sg_fallback) 0) 
			(= (ai_task_count obj_exit_cov/second_gate) 0) 
		)
	1)
		(wake 030_music_10_start)
)

;script to start the music at the end of the encounter
(script dormant sc_exit_music_start
	(sleep_until
		(begin
			(player_action_test_reset)
			(sleep 1)
			(or
				(>= s_exit_obj_control 5)
				(AND
					(player_action_test_primary_trigger)
					(OR
						(unit_has_weapon_readied (unit (player0)) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon")
						(unit_has_weapon_readied (unit (player1)) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon")
						(unit_has_weapon_readied (unit (player2)) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon")
						(unit_has_weapon_readied (unit (player3)) "objects\weapons\rifle\sniper_rifle\sniper_rifle.weapon")
						(unit_has_weapon_readied (unit (player0)) "objects\weapons\rifle\beam_rifle\beam_rifle.weapon")
						(unit_has_weapon_readied (unit (player1)) "objects\weapons\rifle\beam_rifle\beam_rifle.weapon")
						(unit_has_weapon_readied (unit (player2)) "objects\weapons\rifle\beam_rifle\beam_rifle.weapon")
						(unit_has_weapon_readied (unit (player3)) "objects\weapons\rifle\beam_rifle\beam_rifle.weapon")
					)
				)
			)
		)
	1)
	
	(wake 030_music_08_start)
)

;script to end 08 music
(script dormant sc_exit_music08_end
	(sleep_until (= (ai_task_count obj_exit_cov/second_gate) 0) 1)
		(wake 030_music_08_stop)
)

;Reminder script if you're taking too long to leave
(script dormant sc_exit_prompt
	
	(sleep_until 
		(and
			(<= (ai_task_count obj_exit_cov/second_gate) 2)
			(= (volume_test_object tv_exit_enemy_check (ai_get_object sg_exit_cov) ) 0)
			(= (volume_test_object tv_exit_enemy_check2 (ai_get_object sg_exit_cov) ) 0)
			(= (ai_living_count sq_exit_shade01) 0)		
		)
	)
	
	(sleep 1200)
		
	(vs_set_cleanup_script gs_dialogue_cleanup)
	(ai_dialogue_enable FALSE)
	
	(if (> (object_get_health exit_generator) 0)
		(begin	
			(print "Take down that barrier, Chief!")
			(sleep (ai_play_line_on_object none 030ML_040) )
		)
	)

	(ai_dialogue_enable TRUE)
	(vs_release_all)
	
	(sleep 1800)
	
	(sleep_until
		(begin
			(if (> (object_get_health exit_generator) 0)
				(begin				
					(vs_set_cleanup_script gs_dialogue_cleanup)
					(ai_dialogue_enable FALSE)
					
					(set s_exit_generator_dialog (random_range 0 3))
					
					(cond
						((= s_exit_generator_dialog 0)
							(if (> (object_get_health exit_generator) 0)
								(begin
									(print "Take down that barrier, Chief!")
									(sleep (ai_play_line_on_object none 030ML_040) )
									(vs_release_all)
								)
							)
						)
						((= s_exit_generator_dialog 1)
							(if (> (object_get_health exit_generator) 0)
								(begin					
									(print "Power source is in the tunnel!")
									(sleep (ai_play_line_on_object none 030ML_050) )
									(vs_release_all)
								)
							)
						)
						((= s_exit_generator_dialog 2)
							(if (> (object_get_health exit_generator) 0)
								(begin
									(print "Chief, take down that barrier!")
									(sleep (ai_play_line_on_object none 030ML_060) )
									(vs_release_all)
								)
							)
						)
						((= s_exit_generator_dialog 0)
							(if (> (object_get_health exit_generator) 0)
								(begin
									(print "Check the tunnel for the power-source")
									(sleep (ai_play_line_on_object none 030ML_070) )	
									(vs_release_all)
								)
							)
						)
					)									
					
					(sleep 1800)
				)
			)
		(<= (object_get_health exit_generator) 0))
	)

	(ai_dialogue_enable TRUE)
)

;brute dialog to protect the barrier
(script dormant sc_exit_brute_flavor_01
	(sleep_until (>= (ai_task_count obj_exit_cov/fg_jg_front) 1) )
	
	(vs_cast sg_exit_cov_front TRUE 50 "030MX_210")
	(set act_exit_brute01 (vs_role 1))
	
	(set b_exit_brute (random_range 0 1) )
	
	(cond
		((= b_exit_brute 0)
			(print "BRUTE:  Give your lives for the Prophet!")
			(vs_play_line act_exit_brute01 TRUE 030MX_210)
			(sleep 10)
		)
		((= b_exit_brute 1)
			(print "BRUTE:  The demon must not pass!")
			(vs_play_line act_exit_brute01 TRUE 030MX_220)
			(sleep 10)
		)
	)
	(vs_release_all)
)

;johnson dialog leading to exit encounter
(script dormant sc_exit_johnson_flavor
	(sleep (random_range 10 30) )
	
	(ai_dialogue_enable FALSE)
	
	(print "Johnson: Chief!  The gate to Voi is dead ahead!")
	(sleep (ai_play_line_on_object NONE 030MX_180))				


	(print "Johnson: Smash the Brute blockade!  Open her up!")
	(sleep (ai_play_line_on_object NONE 030MX_190))
					
	(ai_dialogue_enable TRUE)

)

;brute dialog to protect the barrier
(script dormant sc_exit_brute_flavor_02
	(sleep_until (>= (ai_task_count obj_exit_cov/sg_fallback) 1) )
	
	(vs_cast sq_exit_brute06/01 TRUE 50 "030MX_200")
	(set act_exit_brute02 (vs_role 1))

;	(vs_abort_on_damage TRUE)

	(print "BRUTE:  Guard the entrance, pack-brothers!")
	(vs_play_line act_exit_brute02 TRUE 030MX_200)
	(sleep 10)

	(vs_release_all)
)

;navpoint just in case
(script dormant sc_exit_navpoint
	(sleep_until 
		(and
			(= (volume_test_object tv_exit_enemy_check (ai_get_object sg_exit_cov) ) 0)
			(= (volume_test_object tv_exit_enemy_check2 (ai_get_object sg_exit_cov) ) 0)
			(= (ai_living_count sq_exit_shade01) 0)		
		)
	)
	(sleep 1800)
	
	(hud_activate_team_nav_point_flag player exit_navpoint 0.55)
	(sleep_until (<= (object_get_health exit_generator) 0) 1)
	(sleep 1)
	(hud_deactivate_team_nav_point_flag player exit_navpoint)

)

;script for the truth hologram
(script dormant sc_exit_truth
	(object_create_anew exit_truth_biped)
	(object_create_anew exit_truth_throne)
	(object_create_anew exit_truth_battery)
	;(object_cannot_take_damage exit_truth_battery)
	(objects_attach exit_truth_battery "attach_marker" exit_truth_biped "")
	(objects_attach exit_truth_biped "driver" exit_truth_throne "driver")
	
	(sleep_until (volume_test_players tv_exit_truth))
	(gs_exit_truth_flicker)
	(object_hide exit_truth_biped FALSE)
	(object_hide exit_truth_throne FALSE)
	(unit_limit_lipsync_to_mouth_only exit_truth_biped TRUE)
		(sleep 15)
		(print "stopping music")
	(set b_exit_truth_speaks 1)
	(if (> (object_get_health exit_truth_battery) 0)
		(begin	
			(custom_animation exit_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth" TRUE)			
		    	(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_060_pot exit_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_060_pot))
				(sleep 30)
		)
	)
	(if (> (object_get_health exit_truth_battery) 0)
		(begin		
			(custom_animation exit_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth2" TRUE)
		    	(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_070_pot exit_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_070_pot))
				(sleep 30)
		)
	)
	(if (> (object_get_health exit_truth_battery) 0)
		(begin		
			(custom_animation exit_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_b\030_truth_b.model_animation_graph "030_cin_truth" TRUE)
		    	(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_080_pot exit_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_080_pot))
				(sleep 30)
		)
	)		
	
	;*(if (> (object_get_health exit_truth_battery) 0)
		(begin
		    (custom_animation exit_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth" TRUE)
			(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_080_pot exit_truth_biped 1)			    
			;(scenery_animation_start exit_truth objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth")
			(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_080_pot))
			(sleep 30)
		)
	)
	(if (> (object_get_health exit_truth_battery) 0)
		(begin	
		    (custom_animation exit_truth_biped objects\characters\truth\cinematics\truth_holos\030_truth_a\030_truth_a.model_animation_graph "030_cin_truth2" TRUE)
			(sound_impulse_start sound\dialog\030_outskirts\mission\030mz_040_pot exit_truth_biped 1)
				(sleep (sound_impulse_language_time sound\dialog\030_outskirts\mission\030mz_040_pot))
				(sleep 45)
		)
	)*;
	(gs_exit_truth_flicker)
	(object_destroy exit_truth_biped)
	(object_destroy exit_truth_throne)
)
