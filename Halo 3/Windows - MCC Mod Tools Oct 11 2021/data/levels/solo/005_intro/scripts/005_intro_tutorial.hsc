; =======================================================================================================================================================================
; =======================================================================================================================================================================
; LOOK TRAINING  
; =======================================================================================================================================================================
; =======================================================================================================================================================================

(global boolean g_pa_cortana_dialogue FALSE)

(global ai johnson NONE)
(global ai tech NONE)

; look training 
(script static void 005tr_look
	(fade_out 0 0 0 0)
	(if debug (print "training : look_training"))

	; get rid of cinematic junk while screen is black 
	(cinematic_stop)
	(camera_control OFF)
	
	;set player state / create objects 
	(object_teleport (player0) 010tr_location)
	(unit_add_equipment (player0) chief_pre_training true true)
	(player0_set_pitch pitch_angle 0)
	
		; set hud state 
		(chud_show_motion_sensor FALSE)
		(chud_show_shield FALSE)
		(chud_show_weapon_stats FALSE)
		(chud_show_grenades FALSE)
		(chud_show_spike_grenades FALSE)
		(chud_show_fire_grenades FALSE)

	; create pda and cigar 	
	(object_create_anew cin_pda)
	(object_create_anew cigar)

	; wake secondary threads 
	(wake recenter_view)
	
	; set controller look to normal 
	(controller_set_look_invert FALSE)
	
	; Place sq_marines/sarge 
	(if debug (print "placing training squad"))
	(ai_place sq_training)
	(sleep 5)
	
		; cast all the appropriate roles 
		(if debug (print "casting call..."))
	
		; cast the actors 
		(vs_cast sq_training/johnson TRUE 5 "010TA_170")
			(set johnson (vs_role 1))
		(vs_cast sq_training/tech TRUE 5 "010TA_010")
			(set tech (vs_role 1))

	(sleep 1)
	(if debug (print "stow weapons"))
	(vs_stow johnson)
	(vs_stow tech)
	
	; create and attach assault rifle to johnson 
	(object_create 010tr_ar)
		(sleep 5) ; allow the ai stow weapons 
	(objects_attach johnson "weapon_back" 010tr_ar "weapon_stow_anchor")

			; everyone starts in their idle 
			(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
			(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)
			(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" 010tr_cigar_anchor)
			(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" TRUE ps_cc/johnson)

	; allow ai to settle in place 
	(sleep 10)

	; set camera state 
	(player_camera_control FALSE)
	(player_disable_movement TRUE)
	(cinematic_show_letterbox_immediate FALSE)
	(player_control_fade_in_all_input 0)
	(chud_cinematic_fade 1 0.5)
	(fade_in 0 0 0 15)
		(sleep 20)

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
					(vs_play_line tech TRUE 010TA_210)
					(controller_set_look_invert FALSE)
				)
				(begin
					(hud_set_training_text tutorial_set_invert)
					(hud_show_training_text 1)
					(hud_enable_training 1)
					(if dialogue (print "MARINE TECH: Set to inverted."))
					(vs_play_line tech TRUE 010TA_220)										
					(controller_set_look_invert TRUE)
				)
			)
		
				(if dialogue (print "MARINE TECH: Change it if you want to."))
				(vs_play_line tech TRUE 010TA_340)
		
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
			(vs_play_line tech TRUE 010TA_200)
		)
	)

		; training is complete 
		(if dialogue (print "JOHNSON: Kick off the training wheels, Corporal"))
		(ai_play_line johnson 010TA_390)
		(sleep 15)

			; johnson and the tech look at the chief 
			(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_turn_johnson_to_chief" 010tr_pda_anchor)
			(vs_custom_animation tech FALSE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_turn_johnson_to_chief" TRUE ps_cc/tech)
			(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_chief" 010tr_cigar_anchor)
			(vs_custom_animation johnson TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_turn_to_chief" TRUE ps_cc/johnson)
		
			(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_turned_chief" 010tr_pda_anchor)
			(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_turned_chief" TRUE ps_cc/tech)
			(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" 010tr_cigar_anchor)
			(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_look_chief" TRUE ps_cc/johnson)
				(sleep 20)

			(scenery_animation_start_relative cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_cigar_up" 010tr_cigar_anchor)
			(vs_custom_animation johnson FALSE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_cigar_up" TRUE ps_cc/johnson)

		(if dialogue (print "JOHNSON: He's good to go."))
		(ai_play_line johnson 010TA_400)
;*
			(scenery_animation_start_relative_loop cigar objects\cinematics\human\cigar\cigar_good\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_cigar" 010tr_cigar_anchor)
			(vs_custom_animation_loop johnson objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "johnson_idle_cigar" TRUE ps_cc/johnson)
*;		
		(sleep 70)
;*
		(if dialogue (print "MARINE TECH: OK. Giving you complete mobility... "))
		(vs_play_line tech TRUE 010TA_410)
		(sleep 15)
*;
	; fade out  
	(fade_out 0 0 0 10)
		(sleep 10)
;*
	; add initial starting equipment / raise / lower weapon 
	(unit_add_equipment (player0) chief_initial TRUE TRUE)
		(sleep 1)
	(unit_raise_weapon (player0) -1)
		(sleep 1)
	(unit_lower_weapon (player0) 1)
		(sleep 1)
*;		
	; give player camera control 	
	(player_camera_control TRUE)

	; destroy props 
	(object_destroy cin_pda)
	(object_destroy cigar)

	; turn back on HUD elements 
	(chud_show_motion_sensor TRUE)
	(chud_show_shield TRUE)
	(chud_show_weapon_stats TRUE)
		(sleep 1)
	(vs_release sq_training)
		(sleep 1)
	(ai_erase_all)
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
	(player_action_test_look_up_begin 11 -25.5)
	(player_camera_control TRUE)
	
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

	(player_camera_control FALSE)
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
	(player_camera_control FALSE)
	(player_action_test_look_pitch_end)
	(player_action_test_reset)
)

; =======================================================================================================================================================================

(script static void test_mindread_down
	(player_action_test_reset)
	(player_action_test_look_down_begin 11 -25.5)
	(player_camera_control TRUE)
	(sleep_until (objects_can_see_object (players) cin_pda 5) 1 360)
	(if	(not (objects_can_see_object (players) cin_pda 5))
		(begin
			(hud_set_training_text tutorial_look_down)
			(hud_show_training_text 1)
			(hud_enable_training 1)
		)
	)
	(sleep_until (objects_can_see_object (players) cin_pda 5) 1)

	(player_camera_control FALSE)
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
	(player_camera_control FALSE)
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
		(vs_play_line tech FALSE 010TA_050)

	(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_mid_to_up" 010tr_pda_anchor)
	(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_mid_to_up" TRUE ps_cc/tech)
	
	(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_up" 010tr_pda_anchor)
	(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_up" TRUE ps_cc/tech)
	
		(test_mindread_up)

		(if dialogue (print "MARINE TECH: OK"))
		(vs_play_line tech FALSE 010TA_060)
			(sleep 5)
		(object_function_set 0 1)
		(sound_impulse_start sound\game_sfx\ui\pda_transition cin_pda 1)
			(sleep 30)
		(set g_recenter_view TRUE)
	
	(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_up_to_mid" 010tr_pda_anchor)
	(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_up_to_mid" TRUE ps_cc/tech)

	(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
	(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)

		(object_function_set 0 0)
		(sleep 30)
		(if dialogue (print "MARINE TECH: Now down here."))
		(vs_play_line tech FALSE 010TA_070)
				
	(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_mid_to_down" 010tr_pda_anchor)
	(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_mid_to_down" TRUE ps_cc/tech)
	
	(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_down" 010tr_pda_anchor)
	(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_down" TRUE ps_cc/tech)
	
		(test_mindread_down)

		(if dialogue (print "MARINE TECH: Good"))
		(vs_play_line tech FALSE 010TA_080)
			(sleep 5)
		(object_function_set 0 1)
		(sound_impulse_start sound\game_sfx\ui\pda_transition cin_pda 1)
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
			(vs_play_line tech TRUE 010TA_230)
	
			(if dialogue (print "JOHNSON: Make it quick."))
			(vs_play_line johnson TRUE 010TA_250)
			
			(if dialogue (print "MARINE TECH: One more time."))
			(vs_play_line tech FALSE 010TA_090)
	
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
			(vs_play_line tech FALSE 010TA_100)
			
		(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_mid_to_up" 010tr_pda_anchor)
		(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_mid_to_up" TRUE ps_cc/tech)
			
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_up" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_up" TRUE ps_cc/tech)
	
			(test_mindread_up)
	
			(if dialogue (print "MARINE TECH: Mmm-hmm"))
			(vs_play_line tech FALSE 010TA_110)			
				(sleep 5)
			(object_function_set 0 1)
			(sound_impulse_start sound\game_sfx\ui\pda_transition cin_pda 1)
				(sleep 30)
			(set g_recenter_view TRUE)
			
		(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_up_to_mid" 010tr_pda_anchor)
		(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_up_to_mid" TRUE ps_cc/tech)
	
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_mid" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_mid" TRUE ps_cc/tech)
	
			(object_function_set 0 0)
			(sleep 60)
			(if dialogue (print "MARINE TECH: And once more down low."))
			(vs_play_line tech FALSE 010TA_120)
			
		(scenery_animation_start_relative cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_mid_to_down" 010tr_pda_anchor)
		(vs_custom_animation tech TRUE objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_mid_to_down" TRUE ps_cc/tech)
		
		(scenery_animation_start_relative_loop cin_pda objects\cinematics\human\pda\cinematics\look_training\look_training "pda_idle_down" 010tr_pda_anchor)
		(vs_custom_animation_loop tech objects\characters\marine\cinematics\vignettes\0x0ve_look_training\0x0ve_look_training "tech_idle_down" TRUE ps_cc/tech)
		
			(test_mindread_down)
				(sleep 5)
			(object_function_set 0 1)
			(sound_impulse_start sound\game_sfx\ui\pda_transition cin_pda 1)
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

