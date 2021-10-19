;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)

(global boolean g_play_cinematics TRUE)
(global boolean g_player_training TRUE)

(global boolean debug TRUE)
(global boolean dialogue TRUE)

; insertion point index 
(global short g_insertion_index 0)

; objective control global shorts
(global short g_cc_obj_control 0)
(global short g_jw_obj_control 0)
(global short g_ta_obj_control 0)
(global short g_gc_obj_control 0)
(global short g_pa_obj_control 0)
(global short g_ss_obj_control 0)
(global short g_pb_obj_control 0)
(global short g_ba_obj_control 0)
(global short g_tb_obj_control 0)
(global short g_dam_obj_control 0)

; starting player pitch 
(global short g_player_start_pitch -16)

(global boolean g_null FALSE)


(global boolean g_playing_dialogue FALSE)

(global ai arbiter NONE)
(global ai tech NONE)
(global ai pilot_01 NONE)
(global ai pilot_02 NONE)
(global ai chieftain NONE)

(global ai johnson NONE)
(global ai joh_marine_01 NONE)
(global ai joh_marine_02 NONE)
(global ai joh_marine_03 NONE)

(global ai sarge NONE)
(global ai marine_01 NONE)
(global ai marine_02 NONE)
(global ai marine_03 NONE)
(global ai marine_04 NONE)

(global ai sarge_sv NONE)
(global ai marine_sv_01 NONE)
(global ai marine_sv_02 NONE)
(global ai marine_sv_03 NONE)

(global ai brute_01 NONE)
(global ai brute_02 NONE)

(global ai grunt_01 NONE)
(global ai grunt_02 NONE)
(global ai grunt_03 NONE)
(global ai grunt_04 NONE)

(global object cin_brute_guard NONE)
(global object dead_brute NONE)

;====================================================================================================================================================================================================


(script static void test_ss_banshee_ambush
    (switch_zone_set set_substation)
	(ai_place sq_ss_pelican_01)
	(ai_place sq_ss_pelican_02)
		(sleep 1)
	(set g_ss_pelican01_hit FALSE)
	(set g_ss_pelican02_hit FALSE)
	(vs_ss_banshee_ambush)
	
)

(global boolean g_ss_banshee_ambush FALSE)

(global vehicle ss_pelican_01 NONE)
(global vehicle ss_pelican_02 NONE)

(global vehicle ss_banshee_01 NONE)
(global vehicle ss_banshee_02 NONE)

(global boolean g_ss_kill_pelicans FALSE)
(global boolean g_ss_pelican01_hit FALSE)
(global boolean g_ss_pelican02_hit FALSE)

(script static void vs_ss_banshee_ambush
		(sleep 10) ; so ai are spawned in the world 
		(ai_erase_all)
	(if debug (print "vignette : substation : banshee_ambush"))

	(set ss_pelican_01 (ai_vehicle_get_from_starting_location sq_ss_pelican_01/pilot))
	(set ss_pelican_02 (ai_vehicle_get_from_starting_location sq_ss_pelican_02/pilot))
		(sleep 1)

	(custom_animation_relative_loop ss_pelican_01 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican1_loop" FALSE ss_pelican_anchor)
	(custom_animation_relative_loop ss_pelican_02 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican2_loop" FALSE ss_pelican_anchor)
;*
	(sleep 90)
	

		(if dialogue (print "JOHNSON: Keep her steady"))
		(sleep 15)

		(if dialogue (print "JOHNSON: Got 'em right where I want em!"))
		(sleep 15)

			; stop music 04 
			;(set g_music_010_04 FALSE)

		(if dialogue (print "PILOT 01: Will do, Sergeant Major..."))
		(sleep 15)

		(if dialogue (print "PILOT 01: Light 'em up!"))
		(sleep 15)

	(sleep 90)
	
	(if (<= g_ss_obj_control 3) (sleep (random_range 30 90)))

		(if dialogue (print "PILOT 02: Hold on got a contact"))
		(sleep 15)
*;
		(ai_place sq_ss_banshees)
		(ai_force_active sq_ss_banshees TRUE)
		(sleep 1)

;*
		(if dialogue (print "PILOT 02: Banshees! Fast and low!"))
		(sleep 15)

		(if dialogue (print "PILOT 01: Break-off! Now!"))
*;		

		(sleep_until g_ss_pelican01_hit 1)
			(if debug (print "Pelican 01 hit animation"))
			(custom_animation_relative ss_pelican_01 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican1_1" FALSE ss_pelican_anchor)

;		(wake md_ss_pelican01_hit)
		
		(sleep_until g_ss_pelican02_hit 1)
			(if debug (print "Pelican 02 hit animation"))
			(custom_animation_relative ss_pelican_02 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican2_1" FALSE ss_pelican_anchor)

;*
		(if dialogue (print "PILOT 02: Lost a thruster! Hang on!"))
		(sleep 15)

		(if dialogue (print "JOHNSON: Get a hold of her!"))
		(sleep 10)

		(if dialogue (print "PILOT 02: Negative! We're going down!"))
		
*;
	(sleep (unit_get_custom_animation_time ss_pelican_01))
	
	(sleep 1)
	(if debug (print "erasing pelican 01"))
	(ai_erase sq_ss_pelican_01)


	(sleep (unit_get_custom_animation_time ss_pelican_02))
	(set g_ss_banshee_ambush TRUE)
	(sleep 1)
	(if debug (print "erasing pelican 02"))
	(ai_erase sq_ss_pelican_02)
)

(script dormant md_ss_pelican01_hit
	(if dialogue (print "PILOT 01: I'm hit! I'm hit!"))
	(sleep 15)

	(if dialogue (print "PILOT 01: Watch yourself!"))
	(sleep 5)

	(if dialogue (print "PILOT 01: (death scream)"))
)		

(script command_script cs_ss_banshee_01
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_banshee/b1_0)
	(cs_fly_by ps_ss_banshee/b1_1)
		(cs_vehicle_boost FALSE)
		(cs_shoot_point TRUE ps_ss_banshee/b1_shoot)
	(cs_fly_by ps_ss_banshee/b1_2)
		(cs_shoot_point FALSE ps_ss_banshee/b1_shoot)
			(sleep 1)
		(cs_shoot_point TRUE ps_ss_banshee/b1_shoot)
		(cs_shoot_secondary_trigger TRUE)
		(print "shoot banshee bomb")
		
		(sleep 35)
	(print "pelican 01 hit set true")
	(set g_ss_pelican01_hit TRUE)
		
	(cs_fly_by ps_ss_banshee/b1_3)
		(cs_shoot_point FALSE ps_ss_banshee/b1_shoot)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_banshee/b1_4 5)
	(cs_fly_by ps_ss_banshee/b1_5 5)
	(cs_fly_by ps_ss_banshee/b1_6 5)
	(cs_fly_by ps_ss_banshee/b1_7 5)
	(cs_fly_by ps_ss_banshee/b1_erase 2)
	(ai_erase ai_current_actor)
)
(script command_script cs_ss_banshee_02
	(sleep 45)
		(cs_enable_pathfinding_failsafe TRUE)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_banshee/b2_0)
	(cs_fly_by ps_ss_banshee/b2_1)
		(cs_vehicle_boost FALSE)
		(cs_shoot_point TRUE ps_ss_banshee/b2_shoot)
	(cs_fly_by ps_ss_banshee/b2_2)
		(cs_shoot_point FALSE ps_ss_banshee/b2_shoot)
			(sleep 1)
		(cs_shoot_point TRUE ps_ss_banshee/b2_shoot)
		(cs_shoot_secondary_trigger TRUE)
		(print "shoot banshee bomb")
		
		(sleep 50)
	(print "pelican 01 hit set true")
	(set g_ss_pelican02_hit TRUE)
		
	(cs_fly_by ps_ss_banshee/b2_3)
		(cs_shoot_point FALSE ps_ss_banshee/b2_shoot)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_ss_banshee/b2_4 5)
	(cs_fly_by ps_ss_banshee/b2_5 5)
	(cs_fly_by ps_ss_banshee/b2_6 5)
	(cs_fly_by ps_ss_banshee/b2_7 5)
	(cs_fly_by ps_ss_banshee/b2_erase 2)
	(ai_erase ai_current_actor)
)

(script static void test_ss_banshees
	(ai_place sq_ss_banshees/banshee01)
	(ai_place sq_ss_banshees/banshee02)
		(sleep 1)
	(set ss_banshee_01 (ai_vehicle_get_from_starting_location sq_ss_banshees/banshee01))
	(set ss_banshee_02 (ai_vehicle_get_from_starting_location sq_ss_banshees/banshee02))
)

(script static void test_ss_pelicans
	(ai_place sq_ss_pelican_01)
	(ai_place sq_ss_pelican_02)
		(sleep 1)
	(set ss_pelican_01 (ai_vehicle_get_from_starting_location sq_ss_pelican_01/pilot))
	(set ss_pelican_02 (ai_vehicle_get_from_starting_location sq_ss_pelican_02/pilot))
		(sleep 10)
	(unit_open ss_pelican_01)
	(unit_open ss_pelican_02)
	(vs_look pilot_01 TRUE ps_ss_pelican/pel01_look)
	(vs_look pilot_02 TRUE ps_ss_pelican/pel02_look)
	(vs_enable_moving pilot_01 TRUE)
	(vs_enable_moving pilot_02 TRUE)
	
	(custom_animation_relative_loop ss_pelican_01 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican1_loop" FALSE ss_pelican_anchor)
	(custom_animation_relative_loop ss_pelican_02 objects\vehicles\pelican\cinematics\vignettes\010vd_pelican_crash\010vd_pelican_crash "pelican2_loop" FALSE ss_pelican_anchor)
)


; =======================================================================================================================================================================
; =======================================================================================================================================================================
; LOOK TRAINING  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

;*
tech_down_to_mid 
tech_idle_down 
tech_idle_mid 
tech_idle_turned 
tech_idle_up 
tech_mid_to_down 
tech_mid_to_up 
tech_trans_in 
tech_turn_back 
tech_turn_to_johnson 
tech_up_to_mid 

pda_down_to_mid 
pda_idle_down 
pda_idle_mid 
pda_idle_up 
pda_mid_to_down 
pda_mid_to_up 
pda_trans_in 
pda_trans_out 
pda_turn_back 
pda_turn_idle 
pda_turn_to_johnson 
pda_up_to_mid 
*;

; look training 
(script static void 010tr_look
    (object_create_anew light_training)
	(fade_out 0 0 0 0)
	(if debug (print "training : look_training"))

	;Set initial state 
	(object_hide (player0) FALSE)
	(object_teleport (player0) 010tr_location)
	(player_camera_control FALSE)
	;(unit_add_equipment (player0) chief_pre_training true true)
	(object_create_anew cin_pda)
	(object_create_anew cigar)
	(player_disable_movement TRUE)

	; wake secondary threads 
	(wake recenter_view)
	
	; set controller to normal look 
	(controller_set_look_invert FALSE)
	
	; Place sq_marines/sarge 
	(if debug (print "placing training squad"))
	(ai_place sq_training)
	(sleep 5)
	
		; cast all the appropriate roles 
		(if debug (print "casting call..."))
	
		; cast the actors 
		(set johnson sq_training/johnson)
		(set tech sq_training/tech)
		
		(vs_reserve johnson 0)
		(vs_reserve tech 0)

	(sleep 1)
	(if debug (print "stow weapons"))
	(vs_stow johnson)
	(vs_stow tech)
	
	;(object_create 010tr_ar)
		(sleep 1)
	;(objects_attach johnson "weapon_back" 010tr_ar "weapon_stow_anchor")

	(player0_set_pitch pitch_angle 0)
	(chud_show_motion_sensor FALSE)
	(chud_show_shield FALSE)
	(chud_show_weapon_stats FALSE)
	(chud_show_grenades FALSE)
	(sleep 5) ; allow the ai stow weapons 

			; everyone starts in their idle 
			(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
			(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)
			(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" 010tr_cigar_anchor)
			(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" TRUE ps_cc/johnson)

	(sleep 10) ; allow ai to settle in place 
	(fade_in 0 0 0 15)
	(sleep 30)

	(training_pitch_choose)
	
		; reset pitch choose count variables 
		(set g_counter_mindread_normal 0)
		(set g_counter_mindread_invert 0)
	
	(if (not g_training_pitch_success) (training_pitch_choose_again))

	(if (not g_training_pitch_success)
		(begin
			(if
				(controller_get_look_invert)
				(begin
					(hud_set_training_text tutorial_set_normal)
					(hud_show_training_text 1)
					(hud_enable_training 1)
					(if dialogue (print "MARINE TECH: Set to normal."))
					;(vs_play_line tech TRUE 010TA_210)
					(controller_set_look_invert TRUE)
				)
				(begin
					(hud_set_training_text tutorial_set_invert)
					(hud_show_training_text 1)
					(hud_enable_training 1)
					(if dialogue (print "MARINE TECH: Set to inverted."))
					;(vs_play_line tech TRUE 010TA_220)										
				)
			)
		
				(if dialogue (print "MARINE TECH: Change it if you want to."))
				;(vs_play_line tech TRUE 010TA_340)
		
			(hud_enable_training 0)
			(hud_show_training_text 0)
		
			(set g_training_pitch_success TRUE)
		)
		(begin
		
			; johnson and the tech look at each other
			(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_turn_to_johnson" 010tr_pda_anchor)
			(vs_custom_animation tech FALSE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_turn_to_johnson" TRUE ps_cc/tech)
			(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_tech" 010tr_cigar_anchor)
			(vs_custom_animation johnson TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_tech" TRUE ps_cc/johnson)
		
			(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_turned_johnson" 010tr_pda_anchor)
			(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_turned_johnson" TRUE ps_cc/tech)
			(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_tech" 010tr_cigar_anchor)
			(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_tech" TRUE ps_cc/johnson)
		
			(if dialogue (print "MARINE TECH: Everything checks out."))
			;(vs_play_line tech TRUE 010TA_200)
		)
	)

		; training is complete 
		(if dialogue (print "JOHNSON: Kick off the training wheels, Corporal"))
		;(vs_play_line johnson FALSE 010TA_390)
		(sleep 45)

			; johnson and the tech look at the chief 
			(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_turn_johnson_to_chief" 010tr_pda_anchor)
			(vs_custom_animation tech FALSE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_turn_johnson_to_chief" TRUE ps_cc/tech)
			(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_chief" 010tr_cigar_anchor)
			(vs_custom_animation johnson TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_chief" TRUE ps_cc/johnson)
		
			(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_turned_chief" 010tr_pda_anchor)
			(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_turned_chief" TRUE ps_cc/tech)
			(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" 010tr_cigar_anchor)
			(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" TRUE ps_cc/johnson)

		(if dialogue (print "JOHNSON: He's good to go."))
		;(vs_play_line johnson TRUE 010TA_400)
		(sleep 15)

			(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_cigar_up" 010tr_cigar_anchor)
			(vs_custom_animation johnson TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_cigar_up" TRUE ps_cc/johnson)

			(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_cigar" 010tr_cigar_anchor)
			(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_cigar" TRUE ps_cc/johnson)

;*
		(if dialogue (print "MARINE TECH: OK. Giving you complete mobility... "))
		(vs_play_line tech TRUE 010TA_410)
		(sleep 15)
*;
	; cleanup 
	(fade_out 0 0 0 15)
	(sleep 20)
;	(chud_show FALSE)
	(object_destroy cin_pda)
	(object_destroy cigar)
	(object_hide (player0) TRUE)
	(if debug (print "erase"))
	(vs_release sq_training)
	(sleep 1)

	(chud_show_motion_sensor TRUE)
	(chud_show_shield TRUE)
	(chud_show_weapon_stats TRUE)

	(ai_erase_all)
	(object_destroy light_training)
)


(global short pitch_angle -14)
(global short pitch_delay 10)
(global short pitch_interpolate 30)
(global boolean g_recenter_view FALSE)
(global boolean g_end_recenter_view FALSE)

(script dormant recenter_view
	(sleep_until
		(begin
			(sleep_until g_recenter_view 1)
			(sleep pitch_delay)
			(if debug (print "recenter view"))
			(player0_set_pitch pitch_angle pitch_interpolate)
			(sleep 1)
			(set g_recenter_view FALSE)
		g_end_recenter_view)
	)
)


; =======================================================================================================================================================================
; ==========   Globals   ================================================================================================================================================
; =======================================================================================================================================================================
(global short g_counter_mindread_normal 0)
(global short g_counter_mindread_invert 0)
(global short g_counter_training_pitch 0)
(global boolean g_training_pitch_success FALSE)
	
; =======================================================================================================================================================================
; ========== Mindread Scripts ===========================================================================================================================================
; =======================================================================================================================================================================

(script static void test_mindread_up
	; reset the players controller 
	; gives the player control of the camera 
	(player_action_test_reset)
	(player_action_test_look_up_begin 14 -26)
	(player_camera_control 1)
	
	; sleep until the player is looking at the light or looking up (inadvertently past the light) 
	; this script can time out 
	(sleep_until (objects_can_see_object (players) cin_pda 5) 1 360)
	
	; if the script times out and the player is not at the light (or up) then remind the player to look up 
	(if	(not (objects_can_see_object (players) cin_pda 5))
		(begin
			(hud_set_training_text tutorial_look_up)
			(hud_show_training_text 1)
			(hud_enable_training 1)
		)
	)

	(sleep_until (objects_can_see_object (players) cin_pda 5) 1)

	(player_camera_control 0)
	(hud_enable_training 0)
	(hud_show_training_text 0)

	(cond
		((not (player_action_test_lookstick_backward))	(begin
													(set g_counter_mindread_normal (+ g_counter_mindread_normal 1))
													(set g_counter_mindread_invert 0)
													(if debug (print "normal success"))
												))
		((not (player_action_test_lookstick_forward))	(begin
													(set g_counter_mindread_invert (+ g_counter_mindread_invert 1))
													(set g_counter_mindread_normal 0)
													(if debug (print "invert success"))
												))
		(TRUE									(begin
													(set g_counter_mindread_normal 0)
													(set g_counter_mindread_invert 0)
												))
	)
	(player_camera_control 0)
	(player_action_test_look_pitch_end)
	(player_action_test_reset)
)

; =======================================================================================================================================================================

(script static void test_mindread_down
	(player_action_test_reset)
	(player_action_test_look_down_begin 14 -26)
	(player_camera_control 1)
	(sleep_until (objects_can_see_object (players) cin_pda 5) 1 360)
	(if	(not (objects_can_see_object (players) cin_pda 5))
		(begin
			(hud_set_training_text tutorial_look_down)
			(hud_show_training_text 1)
			(hud_enable_training 1)
		)
	)
	(sleep_until (objects_can_see_object (players) cin_pda 5) 1)

	(player_camera_control 0)
	(hud_enable_training 0)
	(hud_show_training_text 0)

	(cond
		((not (player_action_test_lookstick_forward))	(begin
													(set g_counter_mindread_normal (+ g_counter_mindread_normal 1))
													(set g_counter_mindread_invert 0)
													(if debug (print "normal success"))
												))
		((not (player_action_test_lookstick_backward))	(begin
													(set g_counter_mindread_invert (+ g_counter_mindread_invert 1))
													(set g_counter_mindread_normal 0)
													(if debug (print "invert success"))
												))
		(TRUE									(begin
													(set g_counter_mindread_normal 0)
													(set g_counter_mindread_invert 0)
												))
	)
	(player_camera_control 0)
	(player_action_test_look_pitch_end)
	(player_action_test_reset)
)


; =======================================================================================================================================================================

; called from inside a sleep_until statement (essentially looping it until it returns true)
(script static void training_pitch_choose
	; loop the animations here until the player sets his look parameters properly (max of 2 times) 

	(set g_counter_mindread_normal 0)
	(set g_counter_mindread_invert 0)
	
		(if dialogue (print "MARINE TECH: Up here?"))
		;(vs_play_line tech FALSE 010TA_050)

	(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_mid_to_up" 010tr_pda_anchor)
	(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_mid_to_up" TRUE ps_cc/tech)
	
	(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_up" 010tr_pda_anchor)
	(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_up" TRUE ps_cc/tech)
	
		(test_mindread_up)

		(if dialogue (print "MARINE TECH: OK"))
		;(vs_play_line tech FALSE 010TA_060)
		
		(object_function_set 0 1)
			(sleep 30)
		(set g_recenter_view TRUE)
	
	(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_up_to_mid" 010tr_pda_anchor)
	(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_up_to_mid" TRUE ps_cc/tech)

	(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
	(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)

		(object_function_set 0 0)
		(sleep 60)
		(if dialogue (print "MARINE TECH: Now down here."))
		;(vs_play_line tech FALSE 010TA_070)
				
	(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_mid_to_down" 010tr_pda_anchor)
	(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_mid_to_down" TRUE ps_cc/tech)
	
	(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_down" 010tr_pda_anchor)
	(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_down" TRUE ps_cc/tech)
	
		(test_mindread_down)

		(if dialogue (print "MARINE TECH: Good"))
		;(vs_play_line tech FALSE 010TA_080)

		(object_function_set 0 1)
			(sleep 30)
		(set g_recenter_view TRUE)
	
	(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_down_to_mid" 010tr_pda_anchor)
	(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_down_to_mid" TRUE ps_cc/tech)

	(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
	(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)

		(object_function_set 0 0)

	(cond
		; if invert success equals 2 then set preferences to inverted 
		((>= g_counter_mindread_invert 2)	(begin
										(if debug (print "set look to inverted"))
										(controller_set_look_invert TRUE)
										(set g_training_pitch_success TRUE)
									)
		)
		; set prefernces to normal if they are not set to inverted  
		((>= g_counter_mindread_normal 2)	(begin
										(if debug (print "set look to normal"))
										(controller_set_look_invert FALSE)
										(set g_training_pitch_success TRUE)
									)
		)
	)
)
		; ==== end first round === 
(script static void training_pitch_choose_again
		(sleep 15)
				
		; johnson and the tech look at each other
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_turn_to_johnson" 010tr_pda_anchor)
		(vs_custom_animation tech FALSE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_turn_to_johnson" TRUE ps_cc/tech)
		(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_tech" 010tr_cigar_anchor)
		(vs_custom_animation johnson TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_tech" TRUE ps_cc/johnson)
	
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_turned_johnson" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_turned_johnson" TRUE ps_cc/tech)
		(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_tech" 010tr_cigar_anchor)
		(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_tech" TRUE ps_cc/johnson)
			
			(if dialogue (print "MARINE TECH: Tracking looks off."))
			;(vs_play_line tech TRUE 010TA_230)
	
			(if dialogue (print "JOHNSON: Make it quick."))
			;(vs_play_line johnson TRUE 010TA_250)
			
			(if dialogue (print "MARINE TECH: One more time."))
			;(vs_play_line tech FALSE 010TA_090)
	
		; tech and johnson return to idle (tech down, johnson at chief) 
		(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_turn_back" 010tr_pda_anchor)
		(vs_custom_animation tech FALSE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_turn_back" TRUE ps_cc/tech)
		(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_chief" 010tr_cigar_anchor)
		(vs_custom_animation johnson TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_chief" TRUE ps_cc/johnson)

		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)
		(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" 010tr_cigar_anchor)
		(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" TRUE ps_cc/johnson)
		(sleep 30)


			(if dialogue (print "MARINE TECH: Again up top?"))
			;(vs_play_line tech FALSE 010TA_100)
			
		(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_mid_to_up" 010tr_pda_anchor)
		(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_mid_to_up" TRUE ps_cc/tech)
			
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_up" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_up" TRUE ps_cc/tech)
	
			(test_mindread_up)
	
			(if dialogue (print "MARINE TECH: Mmm-hmm"))
			;(vs_play_line tech FALSE 010TA_110)			
		
			(object_function_set 0 1)
				(sleep 30)
			(set g_recenter_view TRUE)
			
		(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_up_to_mid" 010tr_pda_anchor)
		(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_up_to_mid" TRUE ps_cc/tech)
	
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)
	
			(object_function_set 0 0)
			(sleep 60)
			(if dialogue (print "MARINE TECH: And once more down low."))
			;(vs_play_line tech FALSE 010TA_120)
			
		(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_mid_to_down" 010tr_pda_anchor)
		(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_mid_to_down" TRUE ps_cc/tech)
		
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_down" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_down" TRUE ps_cc/tech)
		
			(test_mindread_down)
	
			(object_function_set 0 1)
				(sleep 30)
			(set g_recenter_view TRUE)
			
		(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_down_to_mid" 010tr_pda_anchor)
		(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_down_to_mid" TRUE ps_cc/tech)
	
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)
				
			(object_function_set 0 0)
			(sleep 60)
	
		(cond
			; if invert success equals 2 then set preferences to inverted 
			((>= g_counter_mindread_invert 2)	(begin
											(if debug (print "set look to inverted"))
											(controller_set_look_invert TRUE)
											(set g_training_pitch_success TRUE)
										)
			)
			; set prefernces to normal if they are not set to inverted  
			((>= g_counter_mindread_normal 2)	(begin
											(if debug (print "set look to normal"))
											(controller_set_look_invert FALSE)
											(set g_training_pitch_success TRUE)
										)
			)
		)
	)

; =======================================================================================================================================================================

(script static boolean prompt_looker
	(if dialogue (print "chief look here"))
	(sleep 30)
	FALSE
)