;========== Tutorial Scripts ==========
(script continuous tutorial_ladder
	(sleep_until (volume_test_objects ladder_trigger (players)) 90)
	(show_hud_help_text 1)
	(hud_set_help_text ladder_1)
	(sleep_until (not (volume_test_objects ladder_trigger (players))) 90)
	(show_hud_help_text 0)
	)

(script static void test_looking_tech
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (sleep 15))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (sleep 15))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (sleep 15))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (sleep 15))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (sleep 15))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (sleep 15))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (sleep 15))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (sleep 15))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 20)) (begin ;(print "Sir, please look over here.")
																				(cond ((< .5 (real_random_range 0 1)) (begin (sound_impulse_start sound\dialog\a10\A10_101_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1)
																										    (sleep (sound_impulse_time sound\dialog\a10\A10_101_CryoTech))))
																					 (true (begin (sound_impulse_start sound\dialog\a10\A10_261_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1)
																										    (sleep (sound_impulse_time sound\dialog\a10\A10_261_CryoTech)))))
																				(sleep_until (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 15) 1)
																				))
	)

(script dormant tutorial_introduction
	(sound_impulse_start sound\dialog\a10\A10_011_CryoAssist none 1)
		(sleep (sound_impulse_time sound\dialog\a10\A10_011_CryoAssist))
	(sleep 45)
	(unit_open cryotube_1)
	(sleep 60)
	(ai_command_list cryo_tech/tech introduction_3);Leaning tech animation
	(sound_impulse_start sound\dialog\a10\A10_010_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Sorry for the quick thaw, sir.")
		(sleep (sound_impulse_time sound\dialog\a10\A10_010_CryoTech))
	(sound_impulse_start sound\dialog\a10\A10_020_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "The disorientation should pass quickly.") 
		(sleep (sound_impulse_time sound\dialog\a10\A10_020_CryoTech))

	(ai_command_list cryo_tech/asst introduction_4);Waving asst animation
	(sound_impulse_start sound\dialog\a10\A10_030_CryoAssist none 1); (print "Welcome back, sir!  We'll have you battle ready, stat.")
	(ai_command_list cryo_tech/tech introduction_5);Look at willy

	(sleep_until (or (= 0 (sound_impulse_time sound\dialog\a10\A10_030_CryoAssist))
				  (objects_can_see_object (players) (list_get (ai_actors cryo_tech/asst) 0) 25)) 1)
	(ai_command_list_advance cryo_tech/asst)
	(sleep (sound_impulse_time sound\dialog\a10\A10_030_CryoAssist))
	(sleep 5)
	(set mark_tutorial_introduction true)
	)

(script dormant tutorial_looking
	(ai_command_list cryo_tech/tech looking_2);Look at player
	(ai_command_list cryo_tech/asst looking_1);Go to console
	(show_hud_help_text 1)
	(hud_set_help_text tutorial_introduction_1);Self-Diagnostic Software Enabled
	(sleep 45)
	(sound_impulse_start sound\dialog\a10\A10_040_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Can you look around for me, sir?  I need to get a calibration reading for the diagnostics.")
	(player_action_test_reset)
	(enable_hud_help_flash 1)
	(if (player0_joystick_set_is_normal) (hud_set_help_text tutorial_looking_1);Use (Right Thumbstick) to look around
								  (hud_set_help_text tutorial_looking_1l));Use (Right Thumbstick) to look left and right|nUse (Left Thumbstick) to look up and down

	(sleep_until (and (player_action_test_look_relative_left) (player_action_test_look_relative_right)) 1)
	(sleep_until (player_action_test_look_relative_all_directions) 1 delay_prompt)
	(if (not (or (player_action_test_look_relative_up) (player_action_test_look_relative_down))) (if (player0_joystick_set_is_normal) (hud_set_help_text tutorial_looking_2)
								  																			(hud_set_help_text tutorial_looking_2l)))
	(sleep_until (player_action_test_look_relative_all_directions) 1)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	(sleep (sound_impulse_time sound\dialog\a10\A10_040_CryoTech))

	(sound_impulse_start sound\dialog\a10\A10_050_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Thanks sir.")
	(sleep (sound_impulse_time sound\dialog\a10\A10_050_CryoTech))
	(set mark_tutorial_looking true)
	)

(script dormant tutorial_hud_health
	(ai_command_list cryo_tech/tech action_1);Look at console
	(sound_impulse_start sound\dialog\a10\A10_051_CryoAssist none 1); (print "Ok, first we'll test your health monitors. Please, try not to move.")
	(sleep (sound_impulse_time sound\dialog\a10\A10_051_CryoAssist))
	(hud_show_health 1)
	(hud_blink_health 1)
	(unit_set_maximum_vitality (player0) 100 0)
	(unit_set_current_vitality (player0) 12.5 0)
	(sleep 45)
	(unit_set_current_vitality (player0) 25 0)
	(sleep 15)
	(unit_set_current_vitality (player0) 37.5 0)
	(sleep 15)
	(unit_set_current_vitality (player0) 50 0)
	(sleep 15)
	(unit_set_current_vitality (player0) 62.5 0)
	(sleep 15)
	(unit_set_current_vitality (player0) 75 0)
	(sleep 15)
	(unit_set_current_vitality (player0) 87.5 0)
	(sleep 15)
	(unit_set_current_vitality (player0) 100 0)
	(sleep 15)
	(hud_blink_health 0)

	(sound_impulse_start sound\dialog\a10\A10_052_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Vital signs read normal, no freezer burn.")
	(sleep (max 0 (- (sound_impulse_time sound\dialog\a10\A10_052_CryoTech) 30)))
	(set mark_tutorial_hud_health true)
	)

(script dormant tutorial_action
	(ai_command_list cryo_tech/tech action_2);Look at player
	(sleep 45)
	(sound_impulse_start sound\dialog\a10\A10_070_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Go ahead and climb out of your cryo-tube.")
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text tutorial_action_1);Press %action to exit the cryo-tube
	(player_enable_input 1)
	(player_action_test_reset)
	(sleep_until (player_action_test_action) 1)
	(player_action_test_reset)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)

   (if (mcc_mission_segment "cine2_exiting_cryo") (sleep 1))
   
	(fade_out 1 1 1 15)
	(sleep 30)
	(cinematic_start)
	(camera_control on)
	(camera_set tutorial_action_2 0)
	(camera_set tutorial_action_1 250)
	
	(object_beautify (player0) true)
	
	(fade_in 1 1 1 15)
	(sleep 15)
	
	(sound_looping_start sound\sinomatixx_foley\a10_cryoexit_foley none 1)
	
	(unit_exit_vehicle (player0))
	(sleep 170)

	(fade_out 1 1 1 15)
	(sleep 35)

	(object_teleport (player0) tutorial_exit_cryotube_flag)
	(camera_control off)
	(cinematic_stop)

	(sleep 30)
	(fade_in 1 1 1 15)
	(sleep 15)
	
	(object_beautify (player0) false)
	
	(player_camera_control 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_070_CryoTech))
	(set mark_tutorial_action true)
	(sleep 60)
	(unit_close cryotube_1)
	)

(script dormant tutorial_moving_1
	(test_looking_tech)
	(sound_impulse_start sound\dialog\a10\A10_080_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Why don't you try and walk off some of that cryo-sleep stiffness.  When you're ready join me over at the optical diagnostic station.")
	(sleep (sound_impulse_time sound\dialog\a10\A10_080_CryoTech))
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(if (player0_joystick_set_is_normal) (hud_set_help_text tutorial_moving_1);Use (Right Thumbstick) to look around
								  (hud_set_help_text tutorial_moving_1l));Use (Right Thumbstick) to look left and right|nUse (Left Thumbstick) to look up and down

	(ai_command_list cryo_tech/tech moving_1_2);Go to first station

	(sleep_until (= 2 (ai_command_list_status (ai_actors cryo_tech/tech))) 1)
	(ai_command_list_advance cryo_tech/tech)

	(sleep_until (or (volume_test_objects moving_1_trigger_1 (players))
				   (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 15)) 1)
	(ai_command_list cryo_tech/tech moving_1_3);Go to _ station

	(sleep_until (= 2 (ai_command_list_status (ai_actors cryo_tech/tech))) 1)
	(sleep_until (volume_test_objects moving_1_trigger_1 (players)) 1)

	(test_looking_tech)

	(if (not (volume_test_objects red_square (players))) (begin (sound_impulse_start sound\dialog\a10\A10_090_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Please stand on the red square, sir.")
													(sleep 60)
													(ai_command_list cryo_tech/tech red_square);Look at the red square
													(sleep (sound_impulse_time sound\dialog\a10\A10_090_CryoTech))
													(sleep_until (volume_test_objects red_square (players)) 1)
													))
	(set mark_tutorial_moving_1 true)
	)

(script dormant tutorial_looking_targeted
	(ai_command_list cryo_tech/tech looking_targeted_1)

	(test_looking_tech)

	(sound_impulse_start sound\dialog\a10\A10_130_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "We're going to test your targeting systems now.")
	(sleep (sound_impulse_time sound\dialog\a10\A10_130_CryoTech))
	
	(sound_impulse_start sound\dialog\a10\A10_140_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Please target the flashing panel by looking at it.  When you've successfully targetted it the panel will change color.")
	(sleep 60)
	(set test_looking_cycle 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_140_CryoTech))
	(ai_command_list cryo_tech/asst looking_targeted_2);Go to second console
	(sleep_until (= 0 test_looking_cycle) 1)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	(sound_impulse_start sound\dialog\a10\A10_150_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Thank you..")
	(sleep (sound_impulse_time sound\dialog\a10\A10_150_CryoTech))
	(set mark_tutorial_looking_targeted true)
	)

(script continuous test_looking_cycle_center
	(sleep_until test_center_panel 1)
	(object_destroy looking_panel_center_success)
	(object_create looking_panel_center)

	(sleep_until (or (not test_center_panel)
				  (objects_can_see_object (player0) looking_panel_center 5)) 1)
	(if test_center_panel (begin (object_destroy looking_panel_center)
						    (object_create looking_panel_center_success)
						    ))
	(set test_center_panel false)
	)

(script continuous test_looking_cycle_left
	(sleep_until test_left_panel 1)
	(object_destroy looking_panel_left_success)
	(object_create looking_panel_left)

	(sleep_until (or (not test_left_panel)
				  (objects_can_see_object (player0) looking_panel_left 5)) 1)
	(if test_left_panel (begin (object_destroy looking_panel_left)
						    (object_create looking_panel_left_success)
						    ))
	(set test_left_panel false)
	)

(script continuous test_looking_cycle_right
	(sleep_until test_right_panel 1)
	(object_destroy looking_panel_right_success)
	(object_create looking_panel_right)

	(sleep_until (or (not test_right_panel)
				  (objects_can_see_object (player0) looking_panel_right 5)) 1)
	(if test_right_panel (begin (object_destroy looking_panel_right)
						    (object_create looking_panel_right_success)
						    ))
	(set test_right_panel false)
	)

(script continuous test_looking_cycle_up
	(sleep_until test_up_panel 1)
	(object_destroy looking_panel_up_success)
	(object_create looking_panel_up)

	(sleep_until (or (not test_up_panel)
				  (objects_can_see_object (player0) looking_panel_up 5)) 1)
	(if test_up_panel (begin (object_destroy looking_panel_up)
						    (object_create looking_panel_up_success)
						    ))
	(set test_up_panel false)
	)

(script continuous test_looking_cycle_down
	(sleep_until test_down_panel 1)
	(object_destroy looking_panel_down_success)
	(object_create looking_panel_down)

	(sleep_until (or (not test_down_panel)
				  (objects_can_see_object (player0) looking_panel_down 5)) 1)
	(if test_down_panel (begin (object_destroy looking_panel_down)
						    (object_create looking_panel_down_success)
						    ))
	(set test_down_panel false)
	)

(script continuous test_looking_cycle
	(if mark_tutorial_looking_choose (sleep -1))
	(sleep_until (< 0 test_looking_cycle) 1)

	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text tutorial_looking_targeted_1);Stand on the red square

	(sleep_until (volume_test_objects red_square (players)) 1)
	(if (= 1 test_looking_cycle) (hud_set_help_text tutorial_looking_targeted_2);Look at the flashing panels
						    (hud_set_help_text tutorial_looking_targeted_3));Vertical looking is now inverted|nLook at the flashing panels
	(set test_center_panel true)
	(set test_up_panel true)
	(set test_down_panel true)
	(set test_left_panel true)
	(set test_right_panel true)

	(sleep_until (or (not (volume_test_objects red_square (players)))
				  (not (or test_center_panel test_up_panel test_down_panel test_left_panel test_right_panel))) 1)
	(if (volume_test_objects red_square (players)) (set test_looking_cycle 0)
										  (begin (set test_center_panel false)
										  	    (set test_up_panel false)
											    (set test_down_panel false)
											    (set test_left_panel false)
											    (set test_right_panel false)
											    ))
	)

(script dormant tutorial_looking_choose
	(sound_impulse_start sound\dialog\a10\A10_160_CryoAssist (list_get (ai_actors cryo_tech/asst) 1) 1); (print "Sir, I'm getting some calibration errors.  I'm gonna try inverting your vertical pitch.")
	(sleep 30)
	(ai_command_list cryo_tech/tech looking_inverted_1);Look at asst
	(sleep (sound_impulse_time sound\dialog\a10\A10_160_CryoAssist))
	(sound_impulse_start sound\dialog\a10\A10_170_CryoAssist (list_get (ai_actors cryo_tech/asst) 1) 1); (print "Try targetting the flashing lights again.")
	(ai_command_list_advance cryo_tech/tech)
	(set test_looking_choose true)
	(sleep (sound_impulse_time sound\dialog\a10\A10_170_CryoAssist))

	(sleep_until (not test_looking_choose) 1)
	(player_action_test_reset)

	(ai_command_list cryo_tech/tech looking_inverted_2);Look down then at player
	(if (player0_look_pitch_is_inverted) (sound_impulse_start sound\dialog\a10\A10_210_CryoAssist none 1)
								  (sound_impulse_start sound\dialog\a10\A10_220_CryoAssist none 1))
;	(if (player0_look_pitch_is_inverted) (print "Ok, I'll leave the pitch inverted, but if you want you can change it yourself later.")
;								  (print "Ok, I'll leave the pitch normal, but if you want you can change it yourself later."))
	(sleep (sound_impulse_time "sound\dialog\a10\A10_210_CryoAssist"))
	(sleep (sound_impulse_time "sound\dialog\a10\A10_220_CryoAssist"))
	(sleep 45)
	(display_scenario_help 2)
	(set mark_tutorial_looking_choose true)
	)

(script continuous test_looking_choose_cycle
	(if mark_tutorial_looking_choose (sleep -1))
	(sleep_until test_looking_choose 1)
	(player0_look_invert_pitch 1)

	(ai_command_list cryo_tech/tech looking_inverted_1);Look at asst
	(if global_first_run (begin (set test_looking_cycle 2)
						   (sleep_until (= 0 test_looking_cycle) 1)
						   )
					 (begin (sound_impulse_start sound\dialog\a10\A10_170_CryoAssist none 1); (print "Try looking up and down again.")
						   (show_hud_help_text 1)
						   (enable_hud_help_flash 1)
						   (hud_set_help_text tutorial_looking_choose_1);Verticle looking is inverted|nLook up and down
						   (player_action_test_reset)
						
						   (sleep_until (and (player_action_test_look_relative_up)
										 (player_action_test_look_relative_down)) 1 60)
						   (ai_command_list_advance cryo_tech/tech)
						   (sleep_until (and (player_action_test_look_relative_up)
										 (player_action_test_look_relative_down)) 1)
						   (enable_hud_help_flash 0)
						   (show_hud_help_text 0)
						   ))
	(sleep 5)
	(sleep (sound_impulse_time sound\dialog\a10\A10_170_CryoAssist))

	(ai_command_list cryo_tech/tech looking_inverted_2);Look down then at player
	(sound_impulse_start sound\dialog\a10\A10_180_CryoAssist none 1); (print "Is that better or should I switch it back?")
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text tutorial_looking_choose_2);Vertical looking is inverted|nPress %accept to leave it like it is|n|nPress %back to switch it back

	(player_action_test_reset)
	(sleep_until (or (player_action_test_accept) (player_action_test_back)) 1)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	(sleep 5)

	(sleep (sound_impulse_time sound\dialog\a10\A10_180_CryoAssist))
	(if (player_action_test_accept) (begin (set test_looking_choose false)
								    (sleep -1))
							  (player0_look_invert_pitch 0))
	(player_action_test_reset)
	(sleep_until test_looking_choose 30)

	(ai_command_list cryo_tech/tech looking_inverted_1);Look at asst
	(sound_impulse_start sound\dialog\a10\A10_190_CryoAssist none 1); (print "Ok, try looking up and down again, please.")
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text tutorial_looking_choose_3);Verticle looking is normal|nLook up and down
	(player_action_test_reset)
	
	(sleep_until (and (player_action_test_look_relative_up)
				   (player_action_test_look_relative_down)) 1 60)
	(ai_command_list_advance cryo_tech/tech)
	(sleep_until (and (player_action_test_look_relative_up)
				   (player_action_test_look_relative_down)) 1)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	(sleep 5)

	(sleep (sound_impulse_time sound\dialog\a10\A10_190_CryoAssist))
	(ai_command_list cryo_tech/tech looking_inverted_2);Look down then at player
	(sound_impulse_start sound\dialog\a10\A10_200_CryoAssist none 1); (print "Do you want me to leave it like that, or switch it again?")
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text tutorial_looking_choose_4);Vertical looking is normal|nPress %accept to leave it like it is|n|nPress %back to switch it back

	(player_action_test_reset)
	(sleep_until (or (player_action_test_accept) (player_action_test_back)) 1)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	(sleep 5)

	(sleep (sound_impulse_time sound\dialog\a10\A10_200_CryoAssist))
	(if (player_action_test_accept) (begin (set test_looking_choose false)
								    (sleep -1))
							  (player0_look_invert_pitch 1))
	(player_action_test_reset)
	(set global_first_run false)
	)

(script dormant tutorial_moving_2
	(sound_impulse_start sound\dialog\a10\A10_230_CryoAssist none 1); (print "I'm ready for the heads up display tests now.")
	(ai_command_list cryo_tech/asst moving_2_1);Go to console

	(sleep (sound_impulse_time sound\dialog\a10\A10_230_CryoAssist))
	(sound_impulse_start sound\dialog\a10\A10_240_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Please follow me to the HUD test station.")
	(sleep (sound_impulse_time sound\dialog\a10\A10_240_CryoTech))
	(sleep 45)
	(set global_intercom true)

	(sleep_until (or (volume_test_objects moving_2_trigger_1 (players))
				  (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/tech) 0) 15)) 1)
	(ai_command_list cryo_tech/tech moving_2_2);Go to second station
	(sleep (sound_impulse_time sound\dialog\a10\A10_240_CryoTech))

	(sleep_until (= 2 (ai_command_list_status (ai_actors cryo_tech/tech))) 1)

	(sleep_until (volume_test_objects moving_2_trigger_1 (players)) 1)

	(test_looking_tech)

	(if (not (volume_test_objects yellow_square (players))) (begin (sound_impulse_start sound\dialog\a10\A10_260_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Please stand on the yellow square, sir.")
													(sleep 60)
													(ai_command_list cryo_tech/tech yellow_square);Look at the yellow square
													(sleep (sound_impulse_time sound\dialog\a10\A10_260_CryoTech))
													))
	(set mark_tutorial_moving_2 true)
	)

(script dormant tutorial_hud_shield
	(sleep_until (volume_test_objects yellow_square (players)) 1)
	(player_enable_input 0)
	(sleep 15)
	(ai_command_list cryo_tech/tech hud_1)

	(sound_impulse_start sound\dialog\a10\A10_310_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Ok, bring his energy shields online, please.")
	(sleep (sound_impulse_time sound\dialog\a10\A10_310_CryoTech))
	(ai_command_list_advance cryo_tech/tech)
	(device_group_set shield_charge_power .2)
	(sleep 30)

	(hud_show_shield 1)
	(hud_blink_shield 1)
	(unit_set_maximum_vitality (player0) 100 75)
	(unit_set_current_vitality (player0) 100 0)
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text hud_shield_1);Energy Shields Charging
;shield length
	(sleep 150)
	(sound_impulse_start sound\dialog\a10\A10_320_CryoAssist none 1); (print "Shields are fully charged, sir.")
	(sleep (max 0 (- (sound_impulse_time sound\dialog\a10\A10_320_CryoAssist) 45)))
	(ai_command_list cryo_tech/tech hud_1)
	(sleep 45)
	(ai_command_list_advance cryo_tech/tech)
	(sleep 15)
	(sound_impulse_start sound\dialog\a10\A10_330_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1); (print "Ok, sir, go ahead and use the zapper to test your shield's automatic recharge.")
	(hud_set_help_text hud_shield_2); Energy Shields Charged|n|nPress %accept to continue with the shield test
	(player_action_test_reset)
	(sleep_until (player_action_test_accept) 1)
	(player_action_test_reset)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	(sound_looping_start "sound\sfx\weapons\plasma rifle\charging" none 1)
	(device_group_set shield_charge_power 1)
	(sleep 90)
	(sound_looping_stop "sound\sfx\weapons\plasma rifle\charging")
	(damage_new "levels\a10\devices\shield charge\zapper" tutorial_zapper_flag)
	(device_group_set shield_charge_power .2)
	(unit_set_maximum_vitality (player0) 100 0)
	(sleep 120)
	(unit_set_maximum_vitality (player0) 100 75)
	(unit_set_current_vitality (player0) 100 0)
	(hud_set_help_text hud_shield_3);Energy Shields Recharging
;shield length
	(sleep 150)
	(sleep (sound_impulse_time sound\dialog\a10\A10_330_CryoTech))
	(sound_impulse_start sound\dialog\a10\A10_340_CryoAssist none 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_340_CryoAssist))
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	(device_group_set shield_charge_power 0)
	(player_enable_input 1)
	(hud_blink_shield 0)
	(set mark_tutorial_hud_shield true)
	)

(script dormant tutorial_asst_kill
;		(object_type_predict "characters\elite")
;		(object_type_predict "weapons\plasma rifle")
;		(object_type_predict "effects\explosions\medium explosion")
	(sound_impulse_start sound\dialog\a10\A10_350_CaptKeyes none 1)
	(sleep 10)
	(ai_command_list cryo_tech/tech asst_kill_1)
	(ai_command_list cryo_tech/asst asst_kill_2)
	(sleep (sound_impulse_time sound\dialog\a10\A10_350_CaptKeyes))
	(sound_impulse_start sound\dialog\a10\A10_360_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\a10\A10_360_CryoTech) 20)))
	(sound_impulse_start sound\dialog\a10\A10_370_CaptKeyes none 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_370_CaptKeyes))
	(sound_impulse_start sound\dialog\a10\A10_380_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_380_CryoTech))
	(ai_command_list_advance cryo_tech/tech)
	(sleep 15)
	(ai_command_list_advance cryo_tech/asst)
	(sound_impulse_start sound\dialog\a10\A10_390_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_390_CryoTech))
	(ai_command_list_advance cryo_tech/tech)
	(sound_impulse_start sound\dialog\a10\A10_400_CryoAssist none 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_400_CryoAssist))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/asst) 0) 20)) (sound_impulse_start sound\dialog\a10\A10_410_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1))
	(sleep (sound_impulse_time sound\dialog\a10\A10_410_CryoTech))
	(if (not (objects_can_see_object (player0) (list_get (ai_actors cryo_tech/asst) 0) 20)) (sound_impulse_start sound\dialog\a10\A10_420_CryoAssist none 1))
	(sleep (max 0 (- (sound_impulse_time sound\dialog\a10\A10_420_CryoAssist) 30)))

	(sound_impulse_start sound\sfx\ambience\a10\doorpound none 1)
	(ai_command_list cryo_tech/asst asst_kill_3)
	(ai_command_list cryo_tech/tech asst_kill_4)
	(object_create asst_kill_light_1)
	(sleep (max 0 (- (sound_impulse_time sound\sfx\ambience\a10\doorpound) 60)))
	(sound_impulse_start sound\dialog\a10\A10_430_CryoAssist none 1)
	(ai_command_list cryo_tech/tech asst_kill_6)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\a10\A10_430_CryoAssist) 120)))

	(sound_impulse_start sound\sfx\ambience\a10\doorpound none 1)
	(sleep (max 0 (- (sound_impulse_time sound\sfx\ambience\a10\doorpound) 60)))
	(effect_new "effects\explosions\medium explosion" asst_kill_flag)
	(ai_place cryo_bane)
		(object_cannot_take_damage (ai_actors cryo_bane))
		(units_set_current_vitality (ai_actors cryo_bane) 1 0)
		(unit_doesnt_drop_items (ai_actors cryo_bane))
	(object_destroy cryo_door_1)
	(object_cannot_take_damage (ai_actors cryo_tech/asst))
	(ai_command_list cryo_tech/asst asst_kill_5)
	(ai_command_list cryo_bane asst_kill_8)
	(sleep 60)
	(sound_impulse_start sound\dialog\a10\A10_440_CryoAssist none 1)
	(object_can_take_damage (ai_actors cryo_tech/asst))
	(units_set_current_vitality (ai_actors cryo_tech/asst) 1 0)

	(sleep_until (= 0 (ai_living_count cryo_tech/asst)) 1 (sound_impulse_time sound\dialog\a10\A10_440_CryoAssist))
	(sound_impulse_stop sound\dialog\a10\a10_440_CryoAssist)
	(ai_kill cryo_tech/asst)
	(sound_impulse_start sound\dialog\a10\A10_449_CryoTech (list_get (ai_actors cryo_tech/tech) 0) 1)
	(sleep (sound_impulse_time sound\dialog\a10\A10_449_CryoTech))
	(set mark_tutorial_asst_kill true)
	(ai_command_list cryo_bane asst_kill_9)

	(sleep_until (objects_can_see_object (player0) (list_get (ai_actors cryo_bane) 0) 40) 1 15)
	(ai_command_list_advance cryo_bane)

	(sleep_until (= 2 (ai_command_list_status (ai_actors cryo_bane))) 1)
	(ai_erase cryo_bane)

	(sleep_until (volume_test_objects cryo_search_trigger_1 (players)) 5)
	(ai_place cryo_tech/asst)
	(ai_kill cryo_tech/asst)
	)

(script continuous tutorial_moving_jump
	(sleep_until test_moving_jump 30)
	(sleep_until (volume_test_objects moving_jump (players)) 5)
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text moving_jump_1);Press %jump to jump
	(sleep_until (not (volume_test_objects moving_jump (players))) 1)
	(if (volume_test_objects moving_jump_success (players)) (begin (set mark_tutorial_moving_jump true) (set test_moving_jump false) (show_hud_help_text 0) (sleep -1)))
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	)

(script continuous tutorial_moving_crouch
	(sleep_until test_moving_crouch 30)
	(sleep_until (volume_test_objects moving_crouch (players)) 5)
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text moving_crouch_1);Press and Hold %crouch to crouch
	(sleep_until (not (volume_test_objects moving_crouch (players))) 1)
	(if (volume_test_objects moving_crouch_success (players)) (begin (set mark_tutorial_moving_crouch true) (set test_moving_crouch false) (show_hud_help_text 0) (sleep -1)))
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	)

(script dormant tutorial_first_contact
	(device_set_position_immediate first_contact_door_1 0)
	(device_set_position_immediate first_contact_door_4 1)
;	(device_set_power first_contact_door_1 0)

	(sleep_until (volume_test_objects first_contact_trigger_1 (players)) 1)
	(object_create first_contact_flame_1)
	(object_create first_contact_flame_2)
	(object_create first_contact_corpse)
;	(sound_impulse_start sound\dialog\a10\A10_480_Crewman none 1); Nooooo!

	(sleep_until (and (volume_test_objects first_contact_trigger_1 (players))
				   (objects_can_see_object (players) first_contact_door_1 20)) 1)
	(device_operates_automatically_set first_contact_door_2 0)
	(device_set_position first_contact_door_2 0)
	(ai_place first_contact)	
		(object_cannot_take_damage (ai_actors first_contact))
		(units_set_current_vitality (ai_actors first_contact) 1 0)
		(unit_doesnt_drop_items (ai_actors first_contact))
		(ai_berserk first_contact 0)
	(ai_braindead first_contact 1)

	(ai_place first_contact_anti)
		(object_cannot_take_damage (ai_actors first_contact_anti))
		(units_set_current_vitality (ai_actors first_contact_anti) 1 0)
		(unit_doesnt_drop_items (ai_actors first_contact_anti))
	(device_set_power first_contact_door_1 1)

	(sleep_until (and (volume_test_objects first_contact_trigger_2 (players))
				   (objects_can_see_object (players) first_contact_door_1 15)) 1 delay_witness)
	(device_set_position first_contact_door_1 1)
	(object_create first_contact_light_1)
	(set play_music_a10_02 true)
	(set play_music_a10_01_alt true)

	(sleep_until (< .4 (device_get_position first_contact_door_1)) 1)
	(ai_command_list_advance first_contact_anti)

	(sleep_until (or (volume_test_objects first_contact_trigger_3 (players))
				  (= 1 (ai_command_list_status (ai_actors first_contact_anti/elite)))) 1)
	(ai_command_list_advance first_contact_anti)
	(device_operates_automatically_set first_contact_door_2 1)
	(ai_braindead first_contact 0)

	(sleep 30)
	(ai_try_to_fight first_contact_anti first_contact)
	(ai_magically_see_encounter first_contact first_contact_anti)
	(ai_playfight first_contact_anti 1)

	(sleep 60)
	(ai_defend first_contact_anti/anti)

	(sleep_until (volume_test_objects first_contact_trigger_4 (ai_actors first_contact_anti)) 1 90)
	(ai_try_to_fight_nothing first_contact_anti)
	
	(sleep_until (volume_test_objects first_contact_trigger_4 (ai_actors first_contact_anti)) 1)
	(ai_defend first_contact/marine)

	(sleep_until (objects_can_see_object (players) first_contact_door_3 25) 1 delay_witness)

	(sleep_until (and (volume_test_objects first_contact_trigger_4 (ai_actors first_contact_anti))
				   (not (volume_test_objects first_contact_trigger_6 (players)))) 1)
	(object_create first_contact_doora)
	(device_set_position first_contact_door_3 0)
	(sleep 60)
	(ai_conversation first_contact)
	(sleep_until (< 4 (ai_conversation_status first_contact)) 1)

;	(sleep 30)
;	(ai_migrate first_contact containment_1/search)
	)

(script dormant tutorial_weapon
	(sleep_until mark_weapon 1)
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text firing_1);Press %action to exit the cryo-tube
	(player_action_test_reset)
	(sleep_until (player_action_test_primary_trigger) 1)
	(sleep 15)
	(player_action_test_reset)
	(sleep_until (player_action_test_primary_trigger) 1)
	(sleep 15)
	(player_action_test_reset)
	(sleep_until (player_action_test_primary_trigger) 1)
	(sleep 15)
	(player_action_test_reset)
	(sleep_until (player_action_test_primary_trigger) 1)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	
	(sleep_until (or (and (= 0 (ai_living_count cafeteria_anti))
					  (volume_test_objects weapon_trigger (players)))
				  (volume_test_objects bsp1,2 (players))) 1)
	(sleep_until (volume_test_objects bsp1,2 (players)) 1 90)
	(display_scenario_help 0)
	)

(script continuous tutorial_light
	(sleep_until test_light)
	(sleep_until (or (volume_test_objects light_1 (players))
				  (volume_test_objects light_2 (players))) 30)
	(show_hud_help_text 1)
	(hud_set_help_text light_1);Press %integrated-light to use your flashlight
	(sleep_until (not (or (volume_test_objects light_1 (players))
					  (volume_test_objects light_2 (players)))) 1)
	(if (volume_test_objects light_success (players)) (begin (set mark_tutorial_light true) (set test_light false) (show_hud_help_text 0) (sleep -1)))
	(show_hud_help_text 0)
	)

(script dormant tutorial_motiontracker
;	(device_set_power motiontracker_door_1 0)
	(device_set_power motiontracker_door_2 0)
	(device_set_power motiontracker_door_3 0)

	(sleep_until (volume_test_objects motiontracker_1 (players)) 30)

	(ai_conversation motiontracker_1)
	(sleep_until (> (ai_conversation_status motiontracker_1) 4) 1)
	(hud_show_motion_sensor 1)
	(hud_blink_motion_sensor 0)

	(sleep_until (or (volume_test_objects motiontracker_2 (players))
				  (volume_test_objects motiontracker_3 (players))
				  (volume_test_objects motiontracker_4 (players))) 1)
	(if (volume_test_objects motiontracker_2 (players)) (begin (ai_conversation motiontracker_2)
												    (sleep_until (or (volume_test_objects motiontracker_3 (players))
				  												 (volume_test_objects motiontracker_4 (players))) 1)
				  								    (if (volume_test_objects motiontracker_3 (players)) (ai_conversation motiontracker_3))); (print "This is pretty close to them, let's look for a safer way out.")
											  (begin (ai_conversation motiontracker_3)
												    (sleep_until (or (volume_test_objects motiontracker_2 (players))
				  												 (volume_test_objects motiontracker_4 (players))) 1)
				  								    (if (volume_test_objects motiontracker_2 (players)) (ai_conversation motiontracker_2)))); (print "They're right outside, let's find another door.")
	(sleep_until (volume_test_objects motiontracker_4 (players)) 1)
	(ai_conversation motiontracker_4)
	(hud_blink_motion_sensor 0)
	(device_set_power motiontracker_door_1 1)
	)

(script continuous test_melee
	(sleep_until global_test_melee 10)
	(sleep_until (volume_test_objects melee_trigger_3 (players)) 5)
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text melee_1);Press %jump to jump
	(sleep_until (or (not global_test_melee)
				  (not (volume_test_objects melee_trigger_3 (players)))) 1)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	)

(script dormant tutorial_melee
	(object_destroy melee_door_1)
	(object_create melee_door_2)
	(device_set_position_immediate melee_door_2 .8325)

	(sleep_until (volume_test_objects melee_trigger_1 (players)) 1)
	(sleep_until (> (ai_conversation_status motiontracker_4) 4) 1 delay_dawdle)
	(sound_impulse_start sound\dialog\a10\A10_681_Cortana none 1)
	(sleep_until (or (= 1 (device_get_position melee_door_2))
				  (= 0 (sound_impulse_time sound\dialog\a10\A10_681_Cortana))) 1)
	(if (not (= 1 (device_get_position melee_door_2))) (sound_impulse_start sound\dialog\a10\A10_682_Cortana none 1))
	(sleep_until (or (= 1 (device_get_position melee_door_2))
				  (= 0 (sound_impulse_time sound\dialog\a10\A10_682_Cortana))) 1)
	(if (not (= 1 (device_get_position melee_door_2))) (set global_test_melee true))

	(sleep_until (= 1 (device_get_position melee_door_2)) 1)
	(sound_impulse_start "sound\sfx\impulse\impacts\a10_door_bash" melee_door_2 1)
	(set global_test_melee false)
	
	(sleep_until (volume_test_objects melee_trigger_2 (players)) 1 delay_blink)
	(display_scenario_help 1)
	(ai_place tunnel_anti/sucker_grunt)
	)

(script dormant tutorial_grenade
	(sleep_until (> (unit_get_total_grenade_count (player0)) 0) 1)
	(show_hud_help_text 1)
	(enable_hud_help_flash 1)
	(hud_set_help_text tutorial_grenade)
	(player_action_test_reset)
	(sleep_until (player_action_test_grenade_trigger) 1 delay_late)
	(enable_hud_help_flash 0)
	(show_hud_help_text 0)
	)

(script dormant tutorial_setup
	(ai_grenades 0)
	(ai_dialogue_triggers 0)

	(player_enable_input 0)
	(hud_show_crosshair 0)
	(hud_show_health 0)
	(hud_show_shield 0)
	(hud_show_motion_sensor 0)
	(unit_set_maximum_vitality (player0) 1 0)

	(ai_place cryo_tech/tech)
		(object_cannot_take_damage (ai_actors cryo_tech/tech))
		(units_set_current_vitality (ai_actors cryo_tech/tech) 1 0)
		(unit_doesnt_drop_items (ai_actors cryo_tech/tech))
	(ai_command_list cryo_tech/tech introduction_2)
	(ai_place cryo_tech/asst)
		(object_cannot_take_damage (ai_actors cryo_tech/asst))
		(units_set_current_vitality (ai_actors cryo_tech/asst) 1 0)
		(unit_doesnt_drop_items (ai_actors cryo_tech/asst))
	(ai_command_list cryo_tech/asst introduction_1)

	(object_create cryotube_1)
	(unit_enter_vehicle (player0) cryotube_1 "CT-driver")
	(object_create cryotube_1_steam_1)
	(object_create cryotube_1_steam_2)
	(wake title_training)

	(hud_set_objective_text dia_training)
	
	(cinematic_screen_effect_start 1)
	(cinematic_screen_effect_set_filter_desaturation_tint 1 1 1)
	(cinematic_screen_effect_set_filter 1 0 1 0 true 5)
	(cinematic_screen_effect_set_convolution 1 2 10 .001 5)
	(fade_in 1 1 1 30)
	
	(sleep 60)
	(wake tutorial_introduction)

	(sleep_until mark_tutorial_introduction 1 60)

	(object_destroy cryotube_1_steam_1)
	(sleep 5)
	(object_destroy cryotube_2_steam_1)
	(sleep 15)
	(object_destroy cryotube_1_steam_2)
	(sleep 5)
	(object_destroy cryotube_2_steam_2)
	
	(cinematic_screen_effect_stop)

	(sleep_until mark_tutorial_introduction 1)
	(wake tutorial_looking)
	(sleep_until mark_tutorial_looking 1)
	(wake tutorial_hud_health)
	(sleep_until mark_tutorial_hud_health 1)
	(wake tutorial_action)
	(sleep_until mark_tutorial_action 1)
	(hud_show_crosshair 1)

	(wake tutorial_moving_1)
	(sleep_until mark_tutorial_moving_1 1)
	(wake tutorial_looking_targeted)
	(sleep_until mark_tutorial_looking_targeted 1)
	(if (not (player0_look_pitch_is_inverted)) (begin (wake tutorial_looking_choose) (sleep_until mark_tutorial_looking_choose 1)))
	(game_save)
	
	(wake tutorial_moving_2)
	(sleep_until mark_tutorial_moving_2 1)
	(wake tutorial_hud_shield)
	(sleep_until mark_tutorial_hud_shield 1)
	(wake tutorial_asst_kill)
	(sleep_until mark_tutorial_asst_kill 1)
	(set test_moving_jump true)
	(set test_moving_crouch true)
	(set mark_tutorial_setup true)
	(wake tutorial_first_contact)
	
	(sleep_until mark_bridge_cutscene 1)
	(wake tutorial_weapon)
	(set test_light true)
	(wake tutorial_motiontracker)
	(wake tutorial_melee)
	(wake tutorial_grenade)
	)
