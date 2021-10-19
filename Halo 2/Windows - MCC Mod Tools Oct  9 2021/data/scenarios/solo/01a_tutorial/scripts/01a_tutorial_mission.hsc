;	01b_SPACESTATION Mission Script

;=================================
;==========   Globals   ==========
;=================================
;Every global variable used in the mission script

	; Use tick rate for iteration timers rather than hard coding 30. Value shouldn't flow into any sleep functions, as they expect legacy ticks
	(global short tick_seconds (game_tick_rate))
	(global short global_random 0)
	(global short global_random_rumble 0)
	(global short global_random_bridge 0)
	(global short delay_prompt_blink (* 2 tick_seconds))
	(global short delay_prompt_short (* 8 tick_seconds))
	(global short delay_prompt_medium (* 16 tick_seconds))
	(global short delay_prompt_long (* 36 tick_seconds))
	(global short delay_prompt_drag (* 48 tick_seconds))
	(global short delay_prompt_final (* 60 tick_seconds))

	(global boolean mark_bsp0 FALSE)
	(global boolean mark_bsp1 FALSE)
	(global boolean mark_bsp2 FALSE)
	(global boolean mark_bsp3 FALSE)
	(global boolean mark_bsp4 FALSE)
	(global boolean mark_bsp5 FALSE)
	
	(global short counter_mindread_normal_success 0)
	(global short counter_mindread_invert_success 0)
	(global short counter_training_pitch_choose 0)
	(global short counter_prompt_looker_start 0)
	(global short counter_prompt_looker 0)
	(global short counter_prompt_start_spot 0)
	(global short counter_prompt_careful 0)
	(global short counter_prompt_zapper_lookatme 0)
	(global short counter_prompt_zapper_getin 0)
	(global short counter_prompt_zapper_button 0)
	(global short counter_prompt_elevator_plr 0)

	(global boolean mark_looker_light_left FALSE)
	(global boolean mark_looker_light_right FALSE)
	(global boolean mark_looker_light_top FALSE)
	(global boolean mark_looker_light_bottom FALSE)
	(global boolean mark_training_free FALSE)
	(global boolean mark_training_done FALSE)

	(global short timer_training_pitch_choose 0)
	(global short timer_prompt_looker_start 0)
	(global short timer_prompt_looker 0)
	(global short timer_prompt_start_spot 0)
	(global short timer_prompt_careful 0)
	(global short timer_prompt_zapper 0)
	(global short timer_prompt_zapper_lookatme 0)
	(global short timer_prompt_zapper_getin 0)
	(global short timer_prompt_zapper_button 0)
	(global short timer_prompt_elevator_plr 0)
	
	(global boolean mark_ice_cream FALSE)

;========== Checkpoint Scripts ==========
(script static void save_look_start
;	(game_save)
	(if (game_safe_to_save) (data_mine_set_mission_segment "01a_look_start"))
)

(script static void save_move_start
	(game_save)
	(if (game_safe_to_save) (data_mine_set_mission_segment "01a_move_start"))
)

(script static void save_shield_start
	(game_save)
	(if (game_safe_to_save) (data_mine_set_mission_segment "01a_shield_start"))
)

(script static void save_tram_start
	(game_save)
	(if (game_safe_to_save) (data_mine_set_mission_segment "01a_tram_start"))
)

;=====================================
;========== Command Scripts ==========
;=====================================
(script command_script cs_lookat_player
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_lookat_guns
	(cs_face_object 1 (ai_get_object guns))
	(sleep_forever)
)

(script command_script cs_johnson_glanceat_guns
	(cs_enable_looking 1)
	(cs_look_object 1 (ai_get_object guns))
	(sleep_forever)
)

(script command_script cs_lookat_johnson
	(cs_face_object 1 (ai_get_object johnson))
	(sleep_forever)
)

(script command_script cs_lookat_console_zapper
	(cs_look 1 guns_points/console_zapper)
	(sleep 45)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_lookat_console_toplight
	(cs_aim_object 1 looker_light_top_red)
	(sleep 45)
	(cs_face 1 guns_points/console_inhibitor)
	(sleep 30)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_lookat_console_bottomlight
	(cs_aim_object 1 looker_light_bottom_red)
	(sleep 45)
	(cs_face 1 guns_points/console_inhibitor)
	(sleep 30)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_lookat_console_inhibitor
	(cs_face 1 guns_points/console_inhibitor)
	(sleep 30)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_guns_start
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to guns_points/start)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_guns_zapper_halfway
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to guns_points/zapper_halfway)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_guns_zapper_wait
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to guns_points/zapper)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_guns_zapper
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to_and_face guns_points/zapper guns_points/zapper_face)
	(cs_face 1 guns_points/zapper_face)
	(sleep_forever)
)

(script command_script cs_guns_zapper_prompt
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_face_player 1)
	(sleep 90)
	(cs_face_player 0)
	(cs_go_to_and_face guns_points/zapper guns_points/zapper_face)
	(cs_face 1 guns_points/zapper_face)
	(sleep_forever)
)

(script command_script cs_johnson_start
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to johnson_points/start)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_johnson_elevator
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to johnson_points/elevator)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_johnson_elevator_face_guns
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to johnson_points/elevator)
	(cs_face_object 1 (ai_get_object guns))
	(sleep_forever)
)

(script command_script cs_guns_elevator
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to guns_points/elevator)
	(cs_face_player 1)
	(sleep_forever)
)

(script command_script cs_johnson_tram
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to_and_face johnson_points/tram johnson_points/earth)
	(cs_face 1 johnson_points/earth)
	(sleep_forever)
)
	
(script command_script cs_lookat_macgun
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_ignore_obstacles 1)
	(cs_go_to_and_face johnson_points/tram_2 johnson_points/macgun)
	(cs_face 1 johnson_points/macgun)
	(sleep_forever)
)

(script command_script cs_lookat_malta
	(cs_face 1 johnson_points/malta)
	(sleep_forever)
)

(script command_script cs_lookat_fleet
	(cs_face_object 1 inamberclad)
	(cs_look_object 1 inamberclad)
	(sleep_forever)
)

(script command_script cs_johnson_lookat_station
	(cs_face 1 johnson_points/station)
	(sleep_forever)
)

(script command_script cs_johnson_station
	(cs_force_combat_status 2)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to johnson_points/station)
	(cs_face_player 1)
	(sleep_forever)
)

;====================================
;========== Dialog Scripts ==========
;====================================

(script static boolean prompt_looker_start
	(cond
		((= counter_prompt_looker_start 0)		(begin
											(print "Go ahead and look at each of the four lights, Chief.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3110_gun (ai_get_object guns) 1)
											(set timer_prompt_looker (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3110_gun)))
											(set timer_prompt_looker (+ timer_prompt_looker delay_prompt_short))
										))
		((= counter_prompt_looker_start 1)		(begin
											(print "Go ahead and target them one more time.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1360_gun (ai_get_object guns) 1)
											(set timer_prompt_looker (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1360_gun)))
											(set timer_prompt_looker (+ timer_prompt_looker delay_prompt_medium))
										))
		(TRUE							(set counter_prompt_looker_start 0))
	)
	(set counter_prompt_looker_start (+ counter_prompt_looker_start 1))
	FALSE
)
		
(script static boolean prompt_looker
	(cond
		((= counter_prompt_looker 0)		(begin
											(print "You have to look at each light until it turns green.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1310_gun (ai_get_object guns) 1)
											(set timer_prompt_looker (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1310_gun)))
											(set timer_prompt_looker (+ timer_prompt_looker delay_prompt_short))
										))
		((= counter_prompt_looker 1)		(begin
											(print "You gotta look at all the lights to complete the test.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1370_gun (ai_get_object guns) 1)
											(set timer_prompt_looker (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1370_gun)))
											(set timer_prompt_looker (+ timer_prompt_looker delay_prompt_short))
										))
		((= counter_prompt_looker 2)		(begin
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(print "Look at the lights, Chief, one by one.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1300_gun (ai_get_object guns) 1)
											(set timer_prompt_looker (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1300_gun)))
											(set timer_prompt_looker (+ timer_prompt_looker delay_prompt_medium))
										))
		((= counter_prompt_looker 3)		(begin
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(print "Please look at the lights again, son.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1350_gun (ai_get_object guns) 1)
											(set timer_prompt_looker (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1350_gun)))
											(set timer_prompt_looker (+ timer_prompt_looker delay_prompt_medium))
										))
		(TRUE							(set counter_prompt_looker 0))
	)
	(set counter_prompt_looker (+ counter_prompt_looker 1))
	FALSE
)

(script static boolean prompt_start_spot
	(cond
		((= counter_prompt_start_spot 0)		(begin
											(print "Go on, walk around, try it out.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0820_gun (ai_get_object guns) 1)
											(set timer_prompt_start_spot (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0820_gun)))
											(set timer_prompt_start_spot (+ timer_prompt_start_spot delay_prompt_short))
										))
		((= counter_prompt_start_spot 1)		(begin
											(unit_set_emotional_state (ai_get_unit guns) inquisitive .5 1)
											(print "Something wrong son?  Can't you move?")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0830_gun (ai_get_object guns) 1)
											(set timer_prompt_start_spot (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0830_gun)))
											(set timer_prompt_start_spot (+ timer_prompt_start_spot delay_prompt_medium))
											
;											(hud_set_training_text tutorial_movestick)
;											(hud_show_training_text 1)
										))
		((= counter_prompt_start_spot 2)		(begin
											(unit_set_emotional_state (ai_get_unit guns) inquisitive .5 1)
											(print "Inhibitors are definitely off. You should be able to walk around.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0840_gun (ai_get_object guns) 1)
											(set timer_prompt_start_spot (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0840_gun)))
											(set timer_prompt_start_spot (+ timer_prompt_start_spot delay_prompt_medium))

;											(hud_set_training_text tutorial_movestick)
;											(hud_show_training_text 1)
										))
		(TRUE							(set counter_prompt_start_spot 0))
	)
	(set counter_prompt_start_spot (+ counter_prompt_start_spot 1))
	FALSE
)

(script static boolean prompt_careful
	(cond
		((= counter_prompt_careful 0)			(begin
											(cs_run_command_script guns cs_lookat_player)
											(unit_set_emotional_state (ai_get_unit guns) scared .5 1)
											(sleep 8)
											(print "Hey! Take it easy!")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0850_gun (ai_get_object guns) 1)
											(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0850_gun))
											(sleep 30)
											(cs_run_command_script guns cs_guns_zapper_wait)
										))
		((= counter_prompt_careful 1)			(begin
											(cs_run_command_script guns cs_lookat_player)
											(unit_set_emotional_state (ai_get_unit guns) scared .5 1)
											(sleep 8)
											(print "Careful! You'll tear a tendon doing that!")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0860_gun (ai_get_object guns) 1)
											(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0860_gun))
											(sleep 30)
											(cs_run_command_script guns cs_guns_zapper_wait)
										))
		((= counter_prompt_careful 2)			(begin
											(cs_run_command_script guns cs_lookat_player)
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(sleep 8)
											(print "Fine. But don't come crying to me when your rip your leg out of its socket.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0870_gun (ai_get_object guns) 1)
											(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0870_gun))
											(sleep 30)
											(cs_run_command_script guns cs_guns_zapper_wait)
										))
		(TRUE							(set counter_prompt_careful 2))
	)
	(set timer_prompt_careful delay_prompt_blink)
	(set counter_prompt_careful (+ counter_prompt_careful 1))
	FALSE
)

(script static boolean prompt_zapper_lookatme
	(hud_show_training_text 0)
	(cond
		((= counter_prompt_zapper_lookatme 0)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(sleep 30)
											(print "Are you listening to me?.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3160_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3160_gun)))
											(set timer_prompt_zapper_lookatme (+ timer_prompt_zapper delay_prompt_short))
										))
		((= counter_prompt_zapper_lookatme 1)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(sleep 30)
											(print "Over here, Chief.  Focus.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3170_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3170_gun)))
											(set timer_prompt_zapper_lookatme (+ timer_prompt_zapper delay_prompt_short))
										))
		((= counter_prompt_zapper_lookatme 2)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(sleep 30)
											(print "It's considered respectful to look at someone when they are talking.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3180_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3180_gun)))
											(set timer_prompt_zapper_lookatme (+ timer_prompt_zapper delay_prompt_medium))
										))
		((= counter_prompt_zapper_lookatme 3)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) angry .5 1)
											(sleep 30)
											(print "This is important, you could at least look at me while I explain it.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3190_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3190_gun)))
											(set timer_prompt_zapper_lookatme (+ timer_prompt_zapper delay_prompt_medium))
										))
		((= counter_prompt_zapper_lookatme 4)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) angry .5 1)
											(sleep 30)
											(print "I'm talking to you, Chief.  Loot at me.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3200_gun (ai_get_object guns) 1)	
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3200_gun)))
											(set timer_prompt_zapper_lookatme (+ timer_prompt_zapper delay_prompt_long))
											(hud_set_training_text tutorial_zapper_lookatme)
											(hud_show_training_text 1)
										))
		((= counter_prompt_zapper_lookatme 5)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) angry .5 1)
											(sleep 30)
											(print "I know you Spartans think you know everything, but it couldn't hurt you to at least look this way.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3210_gun (ai_get_object guns) 1)	
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3210_gun)))
											(set timer_prompt_zapper_lookatme (+ timer_prompt_zapper delay_prompt_long))
											(hud_set_training_text tutorial_zapper_lookatme)
											(hud_show_training_text 1)
										))
		((= counter_prompt_zapper_lookatme 6)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) angry .5 1)
											(sleep 30)
											(print "Look, just because the brass kisses your ass, doesn't mean I will.  Look at me when I talk to you!")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3220_gun (ai_get_object guns) 1)	
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3220_gun)))
											(set timer_prompt_zapper_lookatme (+ timer_prompt_zapper delay_prompt_drag))
											(hud_set_training_text tutorial_zapper_lookatme)
											(hud_show_training_text 1)
										))
		(TRUE							(set counter_prompt_zapper_lookatme 3))
	)
	(set counter_prompt_zapper_lookatme (+ counter_prompt_zapper_lookatme 1))
	FALSE
)

(script static boolean prompt_zapper_getin
	(hud_show_training_text 0)
	(cond
		((= counter_prompt_zapper_getin 0)	(begin
											(custom_animation (ai_get_unit guns) "objects\characters\marine\tutorial\tutorial" "l01_0900_jon" TRUE)
											(objectives_finish_up_to 0)
											(objectives_show_up_to 1)
											(sleep 10)
											(print "Step on in. I'll show you.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0900_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0900_gun)))
											(set timer_prompt_zapper_getin (+ timer_prompt_zapper delay_prompt_short))
										))
		((= counter_prompt_zapper_getin 1)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(sleep 30)
											(print "Step into the red sqaure, Chief, and we'll get started.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3230_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3230_gun)))
											(set timer_prompt_zapper_getin (+ timer_prompt_zapper delay_prompt_short))
										))
		((= counter_prompt_zapper_getin 2)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(sleep 30)
											(print "Chief? Stand in the red square.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3240_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3240_gun)))
											(set timer_prompt_zapper_getin (+ timer_prompt_zapper delay_prompt_medium))
										))
		((= counter_prompt_zapper_getin 3)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(sleep 30)
											(print "You have to stand in the red square before we can start the test.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3250_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3250_gun)))
											(set timer_prompt_zapper_getin (+ timer_prompt_zapper delay_prompt_medium))
										))
		((= counter_prompt_zapper_getin 4)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(sleep 30)
											(print "Go ahead and stand in the red sqaure.  It'll just take a minute.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3260_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3260_gun)))
											(set timer_prompt_zapper_getin (+ timer_prompt_zapper delay_prompt_long))
										))
		((= counter_prompt_zapper_getin 5)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(sleep 30)
											(print "Come on, son, step into the red square.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3270_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3270_gun)))
											(set timer_prompt_zapper_getin (+ timer_prompt_zapper delay_prompt_long))
											(hud_set_training_text tutorial_zapper_getin)
											(hud_show_training_text 1)
										))
		((= counter_prompt_zapper_getin 6)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(sleep 30)
											(print "Will you stop screwing around?  Stand in the red square!")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3280_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3280_gun)))
											(set timer_prompt_zapper_getin (+ timer_prompt_zapper delay_prompt_long))
											(hud_set_training_text tutorial_zapper_getin)
											(hud_show_training_text 1)
										))
		((= counter_prompt_zapper_getin 7)	(begin
											(cs_run_command_script guns cs_guns_zapper_prompt)
											(unit_set_emotional_state (ai_get_unit guns) angry .5 1)
											(sleep 30)
											(print "Stop bustin' my balls, and step in the damn square!")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3290_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3290_gun)))
											(set timer_prompt_zapper_getin (+ timer_prompt_zapper delay_prompt_drag))
											(hud_set_training_text tutorial_zapper_getin)
											(hud_show_training_text 1)
										))
		(TRUE							(set counter_prompt_zapper_getin 2))
	)
	(set counter_prompt_zapper_getin (+ counter_prompt_zapper_getin 1))
	FALSE
)

(script static boolean prompt_zapper_button
	(hud_show_training_text 0)
	(cond
		((= counter_prompt_zapper_button 0)	(begin
											(unit_set_emotional_state (ai_get_unit guns) angry 0 1)
											(unit_set_emotional_state (ai_get_unit guns) annoyed 0 1)
											(device_set_power zapper_control 1)
											(print "Your new armor's shields are extremely resilient - very efficient.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0880_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0880_gun)))
											(set timer_prompt_zapper_button (+ timer_prompt_zapper 0))
										))
		((= counter_prompt_zapper_button 1)	(begin
											(print "Much better than the Covenant tech we used for the Mark-five.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0890_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0890_gun)))
											(set timer_prompt_zapper_button (+ timer_prompt_zapper 0))
										))
		((= counter_prompt_zapper_button 2)	(begin
											(custom_animation (ai_get_unit guns) "objects\characters\marine\tutorial\tutorial" "l01_0910_jon" TRUE)
											(objectives_finish_up_to 1)
											(objectives_show_up_to 2)
											(sleep 10)
											(print "Go ahead and use the switch in front of you to start the shield test.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3300_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3300_gun)))
											(set timer_prompt_zapper_button (+ timer_prompt_zapper delay_prompt_short))
										))
		((= counter_prompt_zapper_button 3)	(begin
											(print "Just place your hand on the touchpad to activate the switch.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3310_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3310_gun)))
											(set timer_prompt_zapper_button (+ timer_prompt_zapper delay_prompt_medium))
										))
		((= counter_prompt_zapper_button 4)	(begin
											(print "Hit the switch, it won't hurt….much")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3340_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3340_gun)))
											(set timer_prompt_zapper_button (+ timer_prompt_zapper delay_prompt_medium))
										))
		((= counter_prompt_zapper_button 5)	(begin
											(print "Go ahead and use that switch in front of you.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3330_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3330_gun)))
											(set timer_prompt_zapper_button (+ timer_prompt_zapper delay_prompt_long))
											(hud_set_training_text tutorial_zapper_button)
											(hud_show_training_text 1)
										))
		((= counter_prompt_zapper_button 6)	(begin
											(print "The switch right in front of you will start the shield test.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3320_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3320_gun)))
											(set timer_prompt_zapper_button (+ timer_prompt_zapper delay_prompt_long))
											(hud_set_training_text tutorial_zapper_button)
											(hud_show_training_text 1)
										))
		((= counter_prompt_zapper_button 7)	(begin
											(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
											(print "It's a switch.  You press it.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3350_gun (ai_get_object guns) 1)
											(set timer_prompt_zapper (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3350_gun)))
											(set timer_prompt_zapper_button (+ timer_prompt_zapper delay_prompt_drag))
											(hud_set_training_text tutorial_zapper_button)
											(hud_show_training_text 1)
										))
		(TRUE							(set counter_prompt_zapper_button 2))
	)
	(set counter_prompt_zapper_button (+ counter_prompt_zapper_button 1))
	FALSE
)

(script static boolean prompt_elevator_plr
	(hud_show_training_text 0)
	(cond
		((= counter_prompt_elevator_plr 0)
										(begin
											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_short))
											(objectives_show_up_to 3)
										))
		((= counter_prompt_elevator_plr 1)		(begin
											(print "C'mon, Chief, they're ready for us on the bridge.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1640_jon (ai_get_object johnson) 1)
											(set timer_prompt_elevator_plr (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1640_jon)))
											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_short))
										))
		((= counter_prompt_elevator_plr 2)		(begin
											(print "Get on the lift, Cheif, we're gonna be late.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1650_jon (ai_get_object johnson) 1)
											(set timer_prompt_elevator_plr (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1650_jon)))											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_long))
											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_medium))
										))
		((= counter_prompt_elevator_plr 3)		(begin
											(unit_set_emotional_state (ai_get_unit johnson) annoyed .5 1)
											(print "I don't want to keep the brass waiting, Chief.")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1660_jon (ai_get_object johnson) 1)
											(set timer_prompt_elevator_plr (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1660_jon)))											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_long))
											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_medium))
										))
		((= counter_prompt_elevator_plr 4)		(begin
											(unit_set_emotional_state (ai_get_unit johnson) annoyed .5 1)
											(print "Fine. You can tell Lord Hood why we're late!")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1670_jon (ai_get_object johnson) 1)
											(set timer_prompt_elevator_plr (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1670_jon)))											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_long))
											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_long))
										))
		((= counter_prompt_elevator_plr 5)		(begin
											(unit_set_emotional_state (ai_get_unit johnson) angry .5 1)
											(print "Get your shiny green posterior on this elevator!")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1680_jon (ai_get_object johnson) 1)
											(set timer_prompt_elevator_plr (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1680_jon)))											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_long))
											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_long))
										))
		((= counter_prompt_elevator_plr 6)		(begin
											(unit_set_emotional_state (ai_get_unit johnson) angry .5 1)
											(print "Would it help if I said please?")
											(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1690_jon (ai_get_object johnson) 1)
											(set timer_prompt_elevator_plr (* (game_tick_rate_scalar) (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1690_jon)))											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_long))
											(set timer_prompt_elevator_plr (+ timer_prompt_elevator_plr delay_prompt_drag))
											(set mark_ice_cream TRUE)
										))
		(TRUE							(set counter_prompt_elevator_plr 0))
	)
	(set counter_prompt_elevator_plr (+ counter_prompt_elevator_plr 1))
	FALSE
)

;=====================================
;========== Mission Scripts ==========
;=====================================

;========== Setup Scripts ==========
(script static void training_setup
	;Set initial state
	(game_can_use_flashlights 0)
	(unit_set_maximum_vitality (player0) 30 1)
	(device_set_power zapper_control 0)
	(device_set_position_immediate elevator_tram 0)
	
	;Place guns
	(ai_place guns)
	(ai_cannot_die guns 1)
	(cs_run_command_script guns cs_guns_start)
)

(script startup icecream
	(sleep_until
		(and
			mark_ice_cream
			(difficulty_legendary)
		)
	1)
	(object_create cookiesncream)
	(sleep_until
		(or
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	1)
	(ice_cream_flavor_stock 14)
	(print "blam")
)

;========== Mindread Scripts ==========
(script static void test_mindread_up
	(object_create looker_light_top_red)

	(player_action_test_reset)
	(player_action_test_look_up_begin)
	(player_camera_control 1)
	(cs_run_command_script guns cs_lookat_console_toplight)
	(sleep_until
		(or
			(objects_can_see_object (players) looker_light_top_red 5)
			(player0_looking_up)
		)
	1 360)
	(if
		(not
			(or
				(objects_can_see_object (players) looker_light_top_red 5)
				(player0_looking_up)
			)
		)
								(begin
									(print "Go ahead and look at the top light, Chief.")
									(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3070_gun (ai_get_object guns) 1)
									(hud_set_training_text tutorial_look_up)
									(hud_show_training_text 1)
									(hud_enable_training 1)

								)
	)
	(cs_run_command_script guns cs_lookat_console_inhibitor)
	(sleep_until
		(or
			(objects_can_see_object (players) looker_light_top_red 5)
			(player0_looking_up)
		)
	1)

	(player_camera_control 0)
	(hud_enable_training 0)
	(hud_show_training_text 0)
	(object_destroy looker_light_top_red)

	(cond
		((not (player_action_test_lookstick_backward))				(begin
																(set counter_mindread_normal_success (+ counter_mindread_normal_success 1))
																(set counter_mindread_invert_success 0)
																(print "normal success")
															))
		((not (player_action_test_lookstick_forward))					(begin
																(set counter_mindread_invert_success (+ counter_mindread_invert_success 1))
																(set counter_mindread_normal_success 0)
																(print "invert success")
															))
		(TRUE												(begin
																(set counter_mindread_normal_success 0)
																(set counter_mindread_invert_success 0)
															))
	)
	(player_camera_control 0)
	(player_action_test_look_pitch_end)
	(player_action_test_reset)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3070_gun))
)
;=====================================
(script static void test_mindread_down
	(object_create looker_light_bottom_red)

	(player_action_test_reset)
	(player_action_test_look_down_begin)
	(player_camera_control 1)
	(cs_run_command_script guns cs_lookat_console_bottomlight)
	(sleep_until
		(or
			(objects_can_see_object (players) looker_light_bottom_red 3)
			(player0_looking_down)
		)
	1 360)
	(if
		(not
			(or
				(objects_can_see_object (players) looker_light_bottom_red 3)
				(player0_looking_down)
			)
		)
								(begin
									(print "Look at the bottom light, son.")
									(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3060_gun (ai_get_object guns) 1)
									(hud_set_training_text tutorial_look_down)
									(hud_show_training_text 1)
									(hud_enable_training 1)
								)
	)
	(cs_run_command_script guns cs_lookat_console_inhibitor)
	(sleep_until
		(or
			(objects_can_see_object (players) looker_light_bottom_red 3)
			(player0_looking_down)
		)
	1)

	(player_camera_control 0)
	(hud_enable_training 0)
	(hud_show_training_text 0)
	(object_destroy looker_light_bottom_red)

	(cond
		((not (player_action_test_lookstick_forward))				(begin
																(set counter_mindread_normal_success (+ counter_mindread_normal_success 1))
																(set counter_mindread_invert_success 0)
																(print "normal success")
															))
		((not (player_action_test_lookstick_backward))				(begin
																(set counter_mindread_invert_success (+ counter_mindread_invert_success 1))
																(set counter_mindread_normal_success 0)
																(print "invert success")
															))
		(TRUE												(begin
																(set counter_mindread_normal_success 0)
																(set counter_mindread_invert_success 0)
															))
	)
	(player_camera_control 0)
	(player_action_test_look_pitch_end)
	(player_action_test_reset)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3060_gun))
)
;========== Looker Scripts ==========
(script static void training_looker_lights_on
	(object_destroy looker_light_left_green)
	(object_create looker_light_left_red)
	(set mark_looker_light_left TRUE)
	(object_destroy looker_light_right_green)
	(object_create looker_light_right_red)
	(set mark_looker_light_right TRUE)
	(object_destroy looker_light_top_green)
	(object_create looker_light_top_red)
	(set mark_looker_light_top TRUE)
	(object_destroy looker_light_bottom_green)
	(object_create looker_light_bottom_red)
	(set mark_looker_light_bottom TRUE)
)

(script static void training_looker_lights_off
	(object_destroy looker_light_left_green)
	(object_destroy looker_light_left_red)
	(object_destroy looker_light_right_green)
	(object_destroy looker_light_right_red)
	(object_destroy looker_light_top_green)
	(object_destroy looker_light_top_red)
	(object_destroy looker_light_bottom_green)
	(object_destroy looker_light_bottom_red)
)
;=====================================
(script static boolean test_all_lights_off
	(not (or mark_looker_light_left mark_looker_light_right mark_looker_light_top mark_looker_light_bottom))
)
;=====================================
(script static boolean training_pitch_choose
	(if
		(<= counter_training_pitch_choose 2)
		(begin
			(training_looker_lights_on)
			(prompt_looker_start)
			(sleep_until
				(cond
					((test_all_lights_off)									TRUE)
					((objects_can_see_object (players) looker_light_left_red 5)		(begin
																			(object_destroy looker_light_left_red)
																			(object_create_anew looker_light_left_green)
																			(set mark_looker_light_left FALSE)
																		))
					((objects_can_see_object (players) looker_light_right_red 5)	(begin
																			(object_destroy looker_light_right_red)
																			(object_create_anew looker_light_right_green)
																			(set mark_looker_light_right FALSE)
																		))
					((objects_can_see_object (players) looker_light_top_red 5)		(begin
																			(object_destroy looker_light_top_red)
																			(object_create_anew looker_light_top_green)
																			(set mark_looker_light_top FALSE)
																		))
					((objects_can_see_object (players) looker_light_bottom_red 5)	(begin
																			(object_destroy looker_light_bottom_red)
																			(object_create_anew looker_light_bottom_green)
																			(set mark_looker_light_bottom FALSE)
																		))
					((> timer_prompt_looker 0)								(begin
																			(set timer_prompt_looker (- timer_prompt_looker 1))
																			FALSE
																		))
					(TRUE												(prompt_looker))
				)
			1)
		)
	)

	(set counter_training_pitch_choose (+ counter_training_pitch_choose 1))
	(if
		(controller_get_look_invert)
		(begin
			(print "Should I leave it inverted, or put it back to normal?")
			(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1450_gun (ai_get_object guns) 1)
			(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1450_gun))
			(print "Press A to leave lookstick inverted, Press B to try it normal.")
			(hud_set_training_text tutorial_choose_invert)
		)
		(begin
			(print "Should I leave it normal, or put it back to inverted?")
			(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1470_gun (ai_get_object guns) 1)
			(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1470_gun))
			(print "Press A to leave lookstick normal, Press B to try it inverted.")
			(hud_set_training_text tutorial_choose_normal)
		)
	)
	(hud_show_training_text 1)
	(hud_enable_training 1)

	(player_action_test_reset)
	(sleep_until (or (player_action_test_accept) (player_action_test_cancel)) 1)

	(hud_enable_training 0)
	(hud_show_training_text 0)
	(if
		(player_action_test_accept)
		TRUE
		(begin
			(controller_set_look_invert (not (controller_get_look_invert)))
			(if
				(controller_get_look_invert)
				(begin
					(cs_run_command_script guns cs_lookat_console_inhibitor)
					(sleep 15)
					(print "Ok, now it's inverted.")
					(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1480_gun (ai_get_object guns) 1)
					(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1480_gun))
				)
				(begin
					(cs_run_command_script guns cs_lookat_console_inhibitor)
					(sleep 15)
					(print "Ok, now it's back to normal.")
					(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1460_gun (ai_get_object guns) 1)
					(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1460_gun))
				)
			)
			FALSE
		)
	)
)

(script static void training_pitch
	(if (>= counter_mindread_normal_success counter_mindread_invert_success) (controller_set_look_invert FALSE) (controller_set_look_invert TRUE))
	
	(print "Tracking looks sketchy, I'm going to run you through the full diagnostic.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3100_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3100_gun))

	(if
		(controller_get_look_invert)
		(begin
			(print "The diagnostic software set your targeting system to be inverted")
			(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3130_gun (ai_get_object guns) 1)
			(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3130_gun))
		)
		(begin
			(print "The diagnostic software set your targeting system to be normal")
			(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3120_gun (ai_get_object guns) 1)
			(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3120_gun))
		)
	)
	(sleep_until (training_pitch_choose) 1)
	(if
		(controller_get_look_invert)
		(begin
			(cs_run_command_script guns cs_lookat_console_inhibitor)
			(sleep 15)
			(hud_set_training_text tutorial_set_invert)
			(hud_show_training_text 1)
			(hud_enable_training 1)
			(print "I'll leave your targeting set to inverted.")
			(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1570_gun (ai_get_object guns) 1)
			(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1570_gun))
		)
		(begin
			(cs_run_command_script guns cs_lookat_console_inhibitor)
			(sleep 15)
			(hud_set_training_text tutorial_set_normal)
			(hud_show_training_text 1)
			(hud_enable_training 1)
			(print "I'll leave your targeting set to normal.")
			(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1560_gun (ai_get_object guns) 1)
			(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1560_gun))
		)
	)
	(print "If you change your mind, you can switch the setting anytime.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1580_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1580_gun))
	(hud_enable_training 0)
	(hud_show_training_text 0)
	)
;=====================================
(script static void training_look

;GUNS INTRO
	(print "Well...  I guess it was all obsolete anyway.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0600_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0600_gun))

	(custom_animation (ai_get_unit guns) "objects\characters\marine\tutorial\tutorial" "l01_0610_jon" TRUE)
	(sleep 15)

	(print "Your new suit is a Mark VI, sent up from Songnam this morning.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0610_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0610_gun))

	(print "Try to take it easy until you get used to it.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0620_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0620_gun))

	(cs_run_command_script guns cs_lookat_console_inhibitor)
	(sleep 30)
	(print "Ok.  Let's test your targeting, first thing.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0630_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0630_gun))
	(objectives_show_up_to 0)
;MINDREAD
	(print "Please look at the top light.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3000_gun (ai_get_object guns) 1)
	(test_mindread_up)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3000_gun))
	(print "Good.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0650_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0650_gun))

	(print "Now look at the bottom light.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3010_gun (ai_get_object guns) 1)
	(test_mindread_down)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3010_gun))
	(print "Allright")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0670_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0670_gun))

	(print "Look at the top light again.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3020_gun (ai_get_object guns) 1)
	(test_mindread_up)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3020_gun))
	(print "That's it…")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0760_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0760_gun))

	(print "Now the bottom one.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3030_gun (ai_get_object guns) 1)
	(test_mindread_down)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3030_gun))

	(print "Ok.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0740_gun (ai_get_object guns) 1)
	(sleep 30)

	(player_camera_control 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0740_gun))

;SET PREF
	(cond
		((>= counter_mindread_normal_success 2)						(begin
																;(cs_run_command_script guns cs_lookat_console_inhibitor)
																(sleep 30)
																(print "Everything checks out.")
																(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0770_gun (ai_get_object guns) 1)
																(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0770_gun))
																(controller_set_look_invert FALSE)
															))
		((>= counter_mindread_invert_success 2)						(begin
																;(cs_run_command_script guns cs_lookat_console_inhibitor)
																(sleep 30)
																(print "Everything checks out.")
																(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0770_gun (ai_get_object guns) 1)
																(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0770_gun))
																(controller_set_look_invert TRUE)
															))
		(TRUE												(training_pitch))
	)
	(training_looker_lights_off)
)



;========== Training Move ==========

;=====================================
(script static void training_move
;MOVEMENT TRAINING
	(print "Stand-by. I'm going to offline the inhibitors…")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0790_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0790_gun))

	(device_set_position inhibitor 1)

	(player_disable_movement FALSE)
	(hud_enable_training 1)
	(cs_run_command_script guns cs_lookat_console_inhibitor)
	(sleep 30)

	(custom_animation (ai_get_unit guns) "objects\characters\marine\tutorial\tutorial" "l01_0800_jon" TRUE)
	(sleep 10)

	(print "Move around a little, get a feel for it.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0800_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0800_gun))

	(print "When you're ready, come and meet me by the zapper.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0810_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0810_gun))

	(cs_run_command_script guns cs_guns_zapper_halfway)
	(set timer_prompt_start_spot (+ timer_prompt_start_spot delay_prompt_short))
	(sleep_until
		(begin
			(cond
				((not (volume_test_objects tv_start_spot (players)))			TRUE)
				((> timer_prompt_start_spot 0)							(begin
																		(set timer_prompt_start_spot (- timer_prompt_start_spot 1))
																		FALSE
																	))
				(TRUE												(prompt_start_spot))
			)
		)
	1)
	(hud_show_training_text 0)
	(cs_run_command_script guns cs_guns_zapper_wait)
)

(script static void training_shield
	(sleep_until
		(begin
			(cond
				((< (objects_distance_to_flag (players) zapper_flag) 2.5)		TRUE)
				((> timer_prompt_careful 0)								(begin
																		(set timer_prompt_careful (- timer_prompt_careful 1))
																		FALSE
																	))
				((game_safe_to_save)									FALSE)
				(TRUE												(begin
																		(sleep 30)
																		(if (not (game_safe_to_save)) (prompt_careful))
																	))
			)
		)
	1)

	(sleep_until (< (objects_distance_to_flag (ai_get_object guns) zapper_flag) 1.5) 1)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object guns)) 2.5) 1) 
	(unit_set_emotional_state (ai_get_unit guns) inquisitive 0 1)
	(unit_set_emotional_state (ai_get_unit guns) angry 0 1)
	(unit_set_emotional_state (ai_get_unit guns) annoyed 0 1)
	(print "Pay attention because I'm only going to over this once.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3150_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3150_gun))

	(print "This station will test your recharging energy shields")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3140_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3140_gun))

	(cs_run_command_script guns cs_guns_zapper)

	(sleep_until
		(begin
			(cond
				((= (device_group_get zapper_control_group) 1)						TRUE)
				((> (objects_distance_to_object (players) (ai_get_object guns)) 2.5)	FALSE)
				((> timer_prompt_zapper 0)									(begin
																			(set timer_prompt_zapper (- timer_prompt_zapper 1))
																			FALSE
																		))
				((> timer_prompt_zapper_lookatme 0)							(begin
																			(set timer_prompt_zapper_lookatme (- timer_prompt_zapper_lookatme 1))
																			(set timer_prompt_zapper_getin (- timer_prompt_zapper_getin 1))
																			(set timer_prompt_zapper_button (- timer_prompt_zapper_button 1))
																			(if (objects_can_see_object (player0) (ai_get_object guns) 40) (begin (sleep 15) (set timer_prompt_zapper_lookatme 0)))
																			FALSE
																		))
				((> timer_prompt_zapper_getin 0)								(begin
																			(set timer_prompt_zapper_lookatme (- timer_prompt_zapper_lookatme 1))
																			(set timer_prompt_zapper_getin (- timer_prompt_zapper_getin 1))
																			(set timer_prompt_zapper_button (- timer_prompt_zapper_button 1))
																			(if (volume_test_objects tv_zapper (players)) (begin (sleep 15) (set timer_prompt_zapper_getin 0)))
																			FALSE
																		))
				((> timer_prompt_zapper_button 0)								(begin
																			(set timer_prompt_zapper_button (- timer_prompt_zapper_button 1))
																			(set timer_prompt_zapper_getin (- timer_prompt_zapper_getin 1))
																			(set timer_prompt_zapper_button (- timer_prompt_zapper_button 1))
																			(if (= (device_group_get zapper_control_group) 1) (begin (sleep 15) (set timer_prompt_zapper_button 0)))
																			FALSE
																		))
				((not (objects_can_see_object (player0) (ai_get_object guns) 40))	(prompt_zapper_lookatme))
				((not (volume_test_objects tv_zapper (players)))					(prompt_zapper_getin))
				(TRUE													(prompt_zapper_button))
			)
		)
	1)
	(objectives_finish_up_to 2)
	(device_set_power zapper 1)
	(device_set_power zapper_cage 1)
	(hud_show_training_text 0)
	(unit_set_maximum_vitality (player0) 30 70)
;	(hud_show_shield TRUE)
	(cs_run_command_script guns cs_lookat_console_zapper)
	(sleep 90)
	(cs_run_command_script guns cs_lookat_console_zapper)
	(sleep 15)
;	run zapping animation
	(unit_set_current_vitality (player0) 30 0)
	(sleep 15)
	(print "Bingo!")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0940_gun (ai_get_object guns) 1)

	(sleep 30)
	(cs_run_command_script guns cs_lookat_console_zapper)
	(print "As you can see, they re-charge a lot faster.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0950_gun (ai_get_object guns) 1)
	(sleep 45)
	(ai_place johnson)
	(ai_cannot_die johnson 1)
	(cs_run_command_script johnson cs_johnson_elevator)

	(device_set_position door_elevator_tram_bot 1)
	(sleep_until (= (device_get_position door_elevator_tram_bot) 1) 1)

	(cs_run_command_script johnson cs_johnson_start)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0950_gun))
	(sleep 60);shield recharge time
	(device_set_power zapper 0)
	(device_set_power zapper_cage 0)
	(sleep 30)

	(custom_animation (ai_get_unit guns) "objects\characters\marine\tutorial\tutorial" "l01_0960_jon" TRUE)
	(print "If your shields go down, find some cover, wait for the meter to read fully-charged.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0960_gun (ai_get_object guns) 1)
	(sleep 45)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0960_gun))

;JOHNSON ARRIVES
	(print "That, or he can just hide behind me.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0970_jon (ai_get_object johnson) 1)
	(sleep 30)
	(cs_run_command_script guns cs_lookat_johnson)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0970_jon))
	(sleep 15)

	(cs_run_command_script johnson cs_johnson_glanceat_guns)
	(sleep_until (objects_can_see_object (player0) (ai_get_object johnson) 40) 1 90)
	(unit_set_emotional_state (ai_get_unit johnson) inquisitive .5 1)
	(print "You done with my boy here? I don't see any training-wheels…")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1000_jon (ai_get_object johnson) 1)
	(sleep (- (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1000_jon) 90))

	(cs_run_command_script johnson cs_lookat_player)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1000_jon))

	(print "His Armor's working fine.")
	(unit_set_emotional_state (ai_get_unit guns) annoyed .5 1)
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1010_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1010_gun))
	(sleep 15)
	(unit_set_emotional_state (ai_get_unit johnson) inquisitive 0 1)

	(cs_run_command_script guns cs_lookat_player)
	(sleep_until (objects_can_see_object (player0) (ai_get_object guns) 40) 1 90) 
	(print "You're free to go, son.  Just remember: take things slow.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_0980_gun (ai_get_object guns) 1)
	(sleep (- (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0980_gun) 60))

	(cs_run_command_script johnson cs_lookat_player)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_0980_gun))
)

;========== Training Done ==========
(script dormant training_done_tram
	(ai_place atr1_mar)
	(ai_place mid_mar)
	(device_set_position_immediate door_tram_2 1)

	(sleep_until (>= (device_get_position tram) 0.25) 1)
	(device_set_position door_tram_2 0)
	(sleep 30)
	(ai_erase atr1_mar)

	(sleep_until (>= (device_get_position tram) 0.45) 1)
	(device_set_position door_tram_3 1)
	(ai_place atr2_mar)

	(sleep_until (>= (device_get_position tram) 0.55) 1)
	(device_set_position door_tram_3 0)
	(sleep 30)
	(ai_erase mid_mar)

	(sleep_until (>= (device_get_position tram) 0.75) 1)
	(device_set_position door_tram_4 1)

	(object_create_anew tram_marine_1)
	(object_create_anew tram_marine_2)
	(object_create_anew tram_marine_3)
	(object_create_anew tram_marine_4)
	(object_create_anew tram_marine_5)
	(object_create_anew tram_marine_6)
	(object_create_anew tram_marine_7)

	(custom_animation_loop tram_marine_1 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(custom_animation_loop tram_marine_2 objects\characters\marine\x02\x02 "marine_fist_loop" false)
	(custom_animation_loop tram_marine_3 objects\characters\marine\x02\x02 "marine_clapping_loop" false)
	(sleep 5)
	(custom_animation_loop tram_marine_6 objects\characters\marine\x02\x02 "marine_whistle_loop" false)
	(custom_animation_loop tram_marine_5 objects\characters\marine\x02\x02 "marine_fist_loop" false)
	(custom_animation_loop tram_marine_4 objects\characters\marine\x02\x02 "marine_clapping_loop" false)
	(sleep 5)
	(custom_animation_loop tram_marine_7 objects\characters\marine\x02\x02 "marine_whistle_loop" false)

	(sleep_until (>= (device_get_position tram) 0.9) 1)
	(device_set_position door_tram_4 0)
	(sleep 30)
	(ai_erase atr2_mar)
)

(script static void training_done
	(device_set_position_immediate tram 0)
	(cs_run_command_script johnson cs_lookat_guns)

	(print "Don't worry, I'll hold his hand.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1040_jon (ai_get_object johnson) 1)
	(sleep (- (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_1040_jon) 30))
	(cs_run_command_script johnson cs_johnson_elevator)
	(sleep 15)

	(cs_run_command_script guns cs_guns_elevator)
	
	(sleep 15)
	(sleep_until (volume_test_objects_all tv_elevator_tram_bot (ai_get_object johnson)) 1 (* 30 30))
	(if (not (volume_test_objects_all tv_elevator_tram_bot (ai_get_object johnson))) (object_teleport (ai_get_object johnson) tram_flag))
	(sleep_until
		(cond
			((volume_test_objects_all tv_elevator_tram_bot (players))	TRUE)
			((> timer_prompt_elevator_plr 0)						(begin
																(set timer_prompt_elevator_plr (- timer_prompt_elevator_plr 1))
																FALSE
															))
			(TRUE											(prompt_elevator_plr))
		)
	 1)

	(objectives_finish_up_to 3)
	(object_create wall_elevator_tram_bot)
	(set mark_training_done TRUE)
	(sleep_until (< (objects_distance_to_flag (ai_get_object guns) tram_flag) 2.5) 1 210)

	(cs_run_command_script johnson cs_johnson_elevator_face_guns)
	(print "So Johnson, when you gonna tell me how you made it back home in one piece?")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3360_gun (ai_get_object guns) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\l01_3360_gun))

	(print "Sorry, Guns.  It's classified.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0990_jon (ai_get_object johnson) 1)
	(sleep (- (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0990_jon) 0))
;	(device_set_position door_elevator_tram_bot 0)
	(unit_set_emotional_state (ai_get_unit guns) angry .5 1)
	(sleep 5)

	(print "(Humphs) My ass! Well you can forget about those adjustments to your A2's scope! And you're sure as hell not getting one of the new M7s!")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_3370_gun (ai_get_object guns) 1)
	(sleep 30)
	(sleep (random_range 25 75))
	(device_set_position elevator_tram 1)
	(device_set_position door_elevator_tram_bot 0)

	(sleep_until (= (device_get_position door_elevator_tram_bot) 0) 1)
	(sound_impulse_stop sound\dialog\levels\01_spacestation\mission\l01_3370_gun)
	(sleep 10)
	(print "Well he's in a particularly fine mood. Maybe Lord Hood forgot to give him an invitation.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\l01_1810_jon (ai_get_object johnson) 1)
)

(script static void training_tram
	(wake training_done_tram)

	(sleep_until (= (device_get_position elevator_tram) 1) 1)
	(objectives_show_up_to 4)
	(cs_run_command_script johnson cs_johnson_tram)

	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_1810_jon))
	(sleep_until
		(and
			(volume_test_objects_all tv_tram (players))
			(volume_test_objects tv_tram (ai_get_object johnson))
		)
	1)

	(object_destroy_containing wall_platform)
	(object_create wall_tram)
	(sleep_until (not (cs_command_script_running johnson cs_johnson_tram)) 1 150)

	(objectives_finish_up_to 4)
	(custom_animation (ai_get_unit johnson) "objects\characters\marine\tutorial\tutorial" "l01_0010_jon" TRUE)
	(sleep 10)

	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_1810_jon))
	(print "Earth. Haven't seen it in years.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0010_jon (ai_get_object johnson) 1)
	(sleep (- (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0010_jon) 30))

	(sound_looping_start "scenarios\solo\01a_tutorial\01a_music\01a_01" NONE 1); backrhodes

	(device_set_position elevator_tram 0)
	(device_set_position tram 1)

	(sleep_until (>= (device_get_position tram) 0.08) 1)
	(sleep 30)

	(custom_animation (ai_get_unit johnson) "objects\characters\marine\tutorial\tutorial" "l01_0020_jon" TRUE)
	(print "When I shipped out for basic, the orbital defense grid was all theory and politics.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0020_jon (ai_get_object johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0020_jon))

	(sleep_until (>= (device_get_position tram) 0.175) 1)
	(cs_run_command_script johnson cs_lookat_macgun)

	(print "Now look. The Cairo is just one of three-hundred geo-sync platforms.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0021_jon (ai_get_object johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0021_jon))

	(sleep_until (>= (device_get_position tram) 0.275) 1)

	(custom_animation (ai_get_unit johnson) "objects\characters\marine\tutorial\tutorial" "l01_0030_jon" TRUE)
	(sleep 10)
	(print "That MAC-gun can put a round clean through a Covenant capital-ship.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0030_jon (ai_get_object johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0030_jon))

	(sleep_until (>= (device_get_position tram) 0.415) 1)
	(cs_run_command_script johnson cs_lookat_malta)
	(sleep 45)

	(sleep 45)

	(custom_animation (ai_get_unit johnson) "objects\characters\marine\tutorial\tutorial" "l01_0040_jon" TRUE)
	(print "With coordinated fire from the Athens and the Malta, nothing's getting past this battle-cluster in one piece.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0040_jon (ai_get_object johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0040_jon))
	(sleep 15)
;	(cs_run_command_script johnson cs_lookat_fleet)

	(sleep_until (>= (device_get_position tram) 0.7) 1)
	(custom_animation (ai_get_unit johnson) "objects\characters\marine\tutorial\tutorial" "l01_0050_jon" TRUE)
	(print "Ships have been arriving all morning.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0050_jon (ai_get_object johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0050_jon))
	(sound_looping_stop "scenarios\solo\01a_tutorial\01a_music\01a_01"); backrhodes

	(sleep_until (>= (device_get_position tram) 0.75) 1)
	(sleep 30)
	(custom_animation (ai_get_unit johnson) "objects\characters\marine\tutorial\tutorial" "l01_0051_jon" TRUE)
	(print "Nobody's saying much, but I'll bet something big's about to happen.")
	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0051_jon (ai_get_object johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\01_spacestation\mission\L01_0051_jon))

	(cs_run_command_script johnson cs_johnson_lookat_station)

	(sleep_until (>= (device_get_position tram) .975) 1)
;	(print "Let's go...")
;	(sound_impulse_start sound\dialog\levels\01_spacestation\mission\L01_0010_jon (ai_get_object johnson) 0)
	(sleep 30)
	(cs_run_command_script johnson cs_johnson_station)

;	(sleep_until (= (device_get_position tram) 1) 1)
	(sleep_until (not (volume_test_objects_all tv_station (players))) 1 150)
)


;=====================================
;========== Mission Scripts ==========
;=====================================

(script static void start_mission
	(sleep 10)
	(print "01a TUTORIAL")
	(print "Designer - Jaime")
	(print "Env. Artists - Paul, Dave")
)

(script dormant training_fade
	(player_disable_movement TRUE)
	(player_camera_control FALSE)

	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox false)
)

;=====================================
(script startup mission_01a
	(player_disable_movement TRUE)
	(player_camera_control FALSE)
	(if (game_is_cooperative) (game_won))
	(objectives_clear)
	(ai_allegiance player human)
	(fade_out 1 1 1 0)

	(hud_enable_training 0)
	(ai_dialogue_enable 0)
	(start_mission)

	(training_setup)
;	(save_look_start)
	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(objects_predict_high (ai_get_object guns))
	(sleep 2)
	(cinematic_fade_from_white_bars)
	(wake training_fade)

	(training_look)
	
;	(save_move_start)

	(hud_enable_training 1)
	(training_move)

;	(save_shield_start)

	(training_shield)

	(save_tram_start)

	(training_done)

	(training_tram)

	(print "YOU WIN!")
	(sound_class_set_gain "" 0 15)
;	(cinematic_fade_to_white)
	(loading_screen_fade_to_white)
	(hud_enable_training 1)
	(ai_dialogue_enable 1)
	(game_won)
)