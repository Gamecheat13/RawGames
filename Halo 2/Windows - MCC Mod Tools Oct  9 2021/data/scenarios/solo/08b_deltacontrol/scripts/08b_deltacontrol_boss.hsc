(global boolean blam FALSE)
; Use tick rate for iteration timers rather than hard coding 30. Value shouldn't flow into any sleep functions, as they expect legacy ticks
(global short tick_seconds (game_tick_rate))
(global short timer_boss_tartarus_recharge 0)
(global short timer_boss_johnson_fire 0)
(global boolean boss_tartarus_invincible FALSE)
(global short count_boss_cycle 1)
(global short counter_boss_johnson_prompt 0)
(global short skip_boss_johnson_prompt 1)
(global boolean boss_tartarus_berserk FALSE)
(global short timer_boss_tartarus_berserk 0)
(global short counter_boss_tartarus_taunt 0)
(global boolean mark_boss_first_cycle TRUE)
(global short timer_boss_reenforcements 0)
(global short boss_random_reenforcements 0)
(global boolean boss_respawn_brutes FALSE)
(global boolean boss_respawn_elites FALSE)
(global boolean boss_flavor_done FALSE)

(script command_script cs_boss_brutes_stunned
	(cs_force_combat_status 4)
	(cs_enable_moving 0)
	(cs_pause 1)
	(cs_abort_on_damage 1)
	(cs_pause 1)
)

(script command_script cs_boss_tartarus_stunned
	(cs_force_combat_status 4)
	(cs_enable_moving 0)
	(sleep_forever)
)

(script command_script cs_boss_tartarus_jump
	(cs_force_combat_status 4)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to boss/mid_land)
	(cs_face_player 1)
)

(script command_script cs_boss_tartarus_cheer
	(cs_enable_moving 0)
	(cs_enable_targeting 0)
	(cs_face_player 1)
	(sleep 60)
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\brute\brute" "combat:rifle:cheer" TRUE)
	(sleep 60)
)

(script command_script cs_boss_tartarus_taunt
	(cs_enable_moving 0)
	(cs_enable_targeting 0)
	(cs_face_player 1)
	(sleep 60)
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\brute\brute" "combat:rifle:taunt" TRUE)
	(sleep 60)
)

(script command_script cs_boss_tartarus_shakefist
	(cs_enable_moving 0)
	(cs_enable_targeting 0)
	(cs_face_player 1)
	(sleep 60)
	(custom_animation (ai_get_unit ai_current_actor) "objects\characters\brute\brute" "combat:rifle:shakefist" TRUE)
	(sleep 60)
)

(script command_script cs_boss_johnson_idle
	(cs_force_combat_status 4)
	(cs_enable_moving 0)
	(cs_enable_pathfinding_failsafe 1)
	(cs_go_to boss/ledge_perch)
	(cs_crouch 1)
	(cs_face_object 1 (ai_get_object boss_tartarus))
	(cs_aim_object 1 (ai_get_object boss_tartarus))
	(print "johnson idle")
	(sleep_forever)
)

(script command_script cs_boss_johnson_idle2
	(cs_force_combat_status 4)
	(cs_enable_moving 0)
	(cs_crouch 1)
	(cs_face_object 1 (ai_get_object boss_tartarus))
	(cs_aim_object 1 (ai_get_object boss_tartarus))
	(print "johnson idle2")
	(sleep_forever)
)

(script command_script cs_boss_johnson_shoot
	(cs_force_combat_status 4)
	(cs_enable_moving 0)
	(cs_crouch 1)
	(cs_face_object 1 (ai_get_object boss_tartarus))
	(cs_aim_object 1 (ai_get_object boss_tartarus))
	;(cs_shoot 1 (ai_get_object boss_tartarus))
	;(print "johnson shooting")
	;(sleep 45)
	;(print "johnson shoot - sleep done 45")
	
	(cs_shoot 1 (ai_get_object boss_tartarus))
	(print "shot 1")
	(sleep 5)
	(cs_shoot 0 (ai_get_object boss_tartarus))
	(sleep 11)
	(cs_shoot 1 (ai_get_object boss_tartarus))
	(print "shot 2")
	(sleep 5)
	(cs_shoot 0 (ai_get_object boss_tartarus))
	(sleep 11)
	(cs_shoot 1 (ai_get_object boss_tartarus))
	(print "shot 3")
	(sleep 15)
)

(script command_script cs_boss_miranda_nocrouch
	(cs_crouch 0)
	(sleep_forever)
)

(script static void boss_tartarus_taunt
	(cond
		((= counter_boss_tartarus_taunt 0)								(begin
																	(print "What? Is the mighty Arbiter afraid?!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_0980_tar (ai_get_object boss_tartarus) 1)
																))
		((= counter_boss_tartarus_taunt 1)								(begin
																	(print "You want revenge?! Well here I am! Come and take it!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_0990_tar (ai_get_object boss_tartarus) 1)
																))
		((= counter_boss_tartarus_taunt 2)								(begin
																	(print "Just like the rest of your kind - you are cowardly and weak!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_1000_tar (ai_get_object boss_tartarus) 1)
																))
		(TRUE													(set counter_boss_tartarus_taunt 0))
	)
	(set counter_boss_tartarus_taunt (+ counter_boss_tartarus_taunt 1))
)

(script static void boss_johnson_prompt
	(sleep 45)
	(cond
		((= counter_boss_johnson_prompt (* 1 skip_boss_johnson_prompt))		(begin
																	(print "Hey, Mohawk! How'd that feel?!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_2010_jon (ai_get_object boss_johnson) 1)
																))
		((= counter_boss_johnson_prompt (* 2 skip_boss_johnson_prompt))		(begin
																	(print "His shield is down! Let him have it!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_2020_jon (ai_get_object boss_johnson) 1)
																))
		((= counter_boss_johnson_prompt (* 3 skip_boss_johnson_prompt))		(begin
																	(print "There goes his shield!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_2030_jon (ai_get_object boss_johnson) 1)
																))
		((= counter_boss_johnson_prompt (* 4 skip_boss_johnson_prompt))		(begin
																	(print "Got his shield! Hit him now!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_2040_jon (ai_get_object boss_johnson) 1)
																))
		((= counter_boss_johnson_prompt (* 5 skip_boss_johnson_prompt))		(begin
																	(print "Quick! While his shield is down!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_2050_jon (ai_get_object boss_johnson) 1)
																))
		((= counter_boss_johnson_prompt (* 6 skip_boss_johnson_prompt))		(begin
																	(print "I can keep his shield down, but you're gonna have to finish the job!")
																	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_2060_jon (ai_get_object boss_johnson) 1)
																))
		((> counter_boss_johnson_prompt (* 8 skip_boss_johnson_prompt))		(begin
																	(set counter_boss_johnson_prompt 0)
																	(set skip_boss_johnson_prompt (+ skip_boss_johnson_prompt 1))
																))
	)
	(set counter_boss_johnson_prompt (+ counter_boss_johnson_prompt 1))
)

(script dormant boss_flavor
	(sleep (* 5 30))

	(sound_looping_start sound\ambience\deltacontolroom\boss\stage1 NONE 1)

	(sleep (* 5 30))

	(print "Charging sequence initiated! Primary generators coming on-line!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1040_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1040_gsp))

	(print "Well, shut them down!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1050_mir (ai_get_object boss_miranda) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1050_mir))

	(print "Apology. Protocol does allow me to interfere with any aspect of the sequence.")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1060_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1060_gsp))

	(print "Then how do I stop it?!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1120_mir (ai_get_object boss_miranda) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1120_mir))

	(print "Well…it will take some time to go over the proper procedures…")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1130_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1130_gsp))

	(print "Quit stalling!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1140_mir (ai_get_object boss_miranda) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1140_mir))

	(print "Under more controlled circumstances, I would suggest the Reclaimer simply remove the Index.")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1150_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1150_gsp))

	(print "That's it?! Johnson, I'm on it!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1160_mir (ai_get_object boss_miranda) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1160_mir))

	(print "Hang-tight, ma'am! Not until that Brute is dead!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1170_jon (ai_get_object boss_johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1170_jon))

	(set boss_flavor_done TRUE)

	(sleep (* 30 30))

	(set boss_flavor_done FALSE)
	(sound_looping_start sound\ambience\deltacontolroom\boss\stage2 NONE 1)

	(sleep (* 5 30))

	(print "Secondary generators charging! All systems are performing well within operational parameters!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1070_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1070_gsp))

	(print "You're telling me you can't stop the sequence?")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1080_mir (ai_get_object boss_miranda) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1080_mir))

	(print "Reclaimer, please understand: interrupting the wave-generation process will severely damage this installation.")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1090_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1090_gsp))

	(print "Give me a direct answer!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1100_mir (ai_get_object boss_miranda) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1100_mir))

	(print "I am but a Monitor. The Reclaimer can do what it likes.")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1110_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1110_gsp))

	(set boss_flavor_done TRUE)

	(sleep (* 30 30))

	(set boss_flavor_done FALSE)
	(sound_looping_start sound\ambience\deltacontolroom\boss\stage3 NONE 1)

	(sleep (* 5 30))

	(print "Power-generation phase complete! The installation is ready to fire! Starting final countdown…")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1180_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1180_gsp))

	(print "C'mon, Arbiter! Kick that guy's ass!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1190_jon (ai_get_object boss_johnson) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1190_jon))

	(print "And may I say, Reclaimers, it has been a pleasure to serve you both! Goodbye!")
	(sound_impulse_start sound\dialog\levels\08_controlroom\mission\L08_1200_gsp (ai_get_object boss_monitor) 1)
	(sleep (sound_impulse_language_time sound\dialog\levels\08_controlroom\mission\L08_1200_gsp))

	(set boss_flavor_done TRUE)
)

(script dormant boss_music
	(sound_looping_start scenarios\solo\08b_deltacontrol\08b_music\08b_11 NONE 1)

	(sleep_until (volume_test_objects tv_boss_platform (players)))
	(sound_looping_start scenarios\solo\08b_deltacontrol\08b_music\08b_12 NONE 1)

	(sleep_until (not mark_boss_first_cycle))
	(sound_looping_start scenarios\solo\08b_deltacontrol\08b_music\08b_13 NONE 1)
)

(script static short boss_tartarus_rateofrecharge
	(cond
		((difficulty_legendary)	(random_range (* 1 tick_seconds) (* 2 tick_seconds)))
		((difficulty_heroic)	(random_range (* 1 tick_seconds) (* 3 tick_seconds)))
		(TRUE				(random_range (* 2 tick_seconds) (* 3 tick_seconds)))
	)
)

(script static short boss_johnson_rateoffire
	(cond
		((difficulty_legendary)	(random_range (* 7 tick_seconds) (* 15 tick_seconds)))
		((difficulty_heroic)	(random_range (* 5 tick_seconds) (* 12 tick_seconds)))
		(TRUE				(random_range (* 4 tick_seconds) (* 10 tick_seconds)))
	)
)

(script static short boss_rateofreenforcement
	(cond
		((difficulty_legendary)	(random_range (* 30 tick_seconds) (* 60 tick_seconds)))
		((difficulty_heroic)	(random_range (* 30 tick_seconds) (* 60 tick_seconds)))
		(TRUE				(random_range (* 30 tick_seconds) (* 60 tick_seconds)))
	)
)

(script static void boss_tartarus_invincible_on
	(object_set_function_variable (ai_get_object boss_tartarus) "invincibility" 1 2)
	(object_set_shield (ai_get_object boss_tartarus) (/ 1 1000));object_set_shield multiplies the scale times the maximum vitality and then sets the current vitality scale to that giant number
	(set boss_tartarus_invincible TRUE)
)

(script static void boss_tartarus_invincible_off
	(object_set_function_variable (ai_get_object boss_tartarus) "invincibility" 0 0.1)
	(object_set_shield (ai_get_object boss_tartarus) (/ 0 1000));object_set_shield multiplies the scale times the maximum vitality and then sets the current vitality scale to that giant number
	(set boss_tartarus_invincible FALSE)
)

(script static void boss_tartarus_berserk_on
	(ai_berserk boss_tartarus 1)
	(set boss_tartarus_berserk TRUE)
	(print "BERSERK")
)

(script static void boss_tartarus_berserk_off
	(ai_berserk boss_tartarus 0)
	(set boss_tartarus_berserk FALSE)
)

(script static void boss_setup
	(switch_bsp 3)
	(ai_allegiance player human)
	(ai_allegiance player covenant)
	(ai_allegiance player sentinel)
	(ai_allegiance human covenant)
	(ai_allegiance human sentinel)
	(ai_allegiance covenant human)
	(ai_allegiance covenant sentinel)
	(ai_allegiance prophet sentinel)
	(sleep 1)
	(object_teleport (player0) boss_player0_flag)
	(object_teleport (player1) boss_player1_flag)
	(kill_volume_enable kill_e13_0)
	(device_set_position_immediate e13_rotors 0.625)
	(device_operates_automatically_set e12_door1 0)

;Set globals
	(cond
		((difficulty_legendary)	(set count_boss_cycle 4))
		((difficulty_heroic)	(set count_boss_cycle 3))
		(TRUE				(set count_boss_cycle 2))
	)
	(cond
		((difficulty_legendary)	(set skip_boss_johnson_prompt 6))
		((difficulty_heroic)	(set skip_boss_johnson_prompt 3))
		(TRUE				(set skip_boss_johnson_prompt 1))
	)

;Tartarus
	(ai_place boss_tartarus)
	(unit_impervious (ai_get_object boss_tartarus) 1)
	(ai_cannot_die boss_tartarus 1)
	(unit_only_takes_damage_from_players_team (ai_get_unit boss_tartarus) 1)
	(object_set_scale (ai_get_object boss_tartarus) 1.15 0)
	(boss_tartarus_invincible_on)
	(cond
		((difficulty_legendary)	(unit_set_maximum_vitality (ai_get_unit boss_tartarus) 400 1000))
		((difficulty_heroic)	(unit_set_maximum_vitality (ai_get_unit boss_tartarus) 350 1000))
		(TRUE				(unit_set_maximum_vitality (ai_get_unit boss_tartarus) 300 1000))
	)
	(unit_set_current_vitality (ai_get_unit boss_tartarus) 50 1000)
	(cs_run_command_script boss_tartarus cs_boss_tartarus_stunned)

;Miranda
	(ai_place boss_miranda)
	(unit_impervious (ai_actors boss_miranda) 1)
	(object_cannot_die (ai_get_object boss_miranda) 1)
	(cs_run_command_script boss_miranda cs_boss_miranda_nocrouch)
	(ai_disregard (ai_get_object boss_miranda) 1)

;Miranda
	(ai_place boss_monitor)
	(ai_cannot_die boss_monitor 1)
	(ai_disregard (ai_get_object boss_monitor) 1)

;Johnson
	(ai_place boss_johnson)
	(unit_impervious (ai_actors boss_johnson) 1)
	(object_cannot_die (ai_get_object boss_johnson) 1)
	(ai_disregard (ai_get_object boss_johnson) 1)

	(cinematic_lighting_set_primary_light 27 0 0.34902 0.333333 0.541176)
	(cinematic_lighting_set_secondary_light -26 154 0.639216 0.54902 0.505882)
	(cinematic_lighting_set_ambient_light 0.0823529 0.0784314 0.0588235)
	
	(object_uses_cinematic_lighting (ai_get_object boss_johnson) 1)

;Brutes
	(ai_place boss_brute_start)
	(cs_run_command_script boss_brute_start cs_boss_brutes_stunned)

;Elites
	(ai_place boss_elite_start)
	(game_save_immediate)
)

(script static void tartarus_boss_fight
	(cinematic_snap_to_white)
	(object_create_containing boss_object)
	(print "WAR!")
	(boss_setup)
	(wake boss_music)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white)

	(sleep 90)
	(units_set_current_vitality (ai_actors boss_brute_start) 30 0)
	(sleep 120)
	(sleep_until
		(not
			(or
				(and
					(> (device_get_position e13_rotors) 0.05)
					(< (device_get_position e13_rotors) 0.125)
				)
				(and
					(> (device_get_position e13_rotors) 0.3)
					(< (device_get_position e13_rotors) 0.375)
				)
				(and
					(> (device_get_position e13_rotors) 0.55)
					(< (device_get_position e13_rotors) 0.625)
				)
				(and
					(> (device_get_position e13_rotors) 0.8)
					(< (device_get_position e13_rotors) 0.875)
				)
			)
		)
	1)
	(cs_run_command_script boss_tartarus cs_boss_tartarus_jump)

	(sleep_until (= (ai_living_count boss_brute_start) 0) 1 (* 15 30))
	(ai_place boss_elite_reenforcements)

	(sleep_until (volume_test_objects tv_boss_platform (players)) 1 (* 30 30))
	(sleep (* 10 30))
	(unit_impervious (ai_get_object boss_tartarus) 0)

	(set timer_boss_johnson_fire (boss_johnson_rateoffire))
	(cs_run_command_script boss_johnson cs_boss_johnson_idle)
	(wake boss_flavor)
	(unit_set_current_vitality (ai_get_unit boss_tartarus) 50 1000)
	(sleep_until
		(cond
			((volume_test_objects kill_e13_0 (ai_get_object boss_miranda))						(begin
																						(ai_erase boss_miranda)
																						(ai_place boss_miranda)
																						(unit_impervious (ai_actors boss_miranda) 1)
																						(object_cannot_die (ai_get_object boss_miranda) 1)
																						FALSE
																					))
			((not (volume_test_objects tv_boss_ledge (ai_get_object boss_johnson)))				(begin
																						(ai_erase boss_johnson)
																						(ai_place boss_johnson)
																						(unit_impervious (ai_actors boss_johnson) 1)
																						(object_cannot_die (ai_get_object boss_johnson) 1)
																						FALSE
																					))
			((and
				(not (volume_test_objects tv_boss_platform (ai_get_object boss_tartarus)))
				(not (volume_test_objects tv_boss_ledge (ai_get_object boss_tartarus)))
				(> (player_count) 0)
			)																		(begin
																						(object_teleport (ai_get_object boss_tartarus) boss_tartarus_respawn_flag)
																						(sleep 90)
																						FALSE
																					))
			((ai_vitality_pinned boss_tartarus)											(begin
																						(set count_boss_cycle (- count_boss_cycle 1))
																						(print "CYCLE COMPLETE")
																						(cond
																							((not (> (player_count) 0))					FALSE)
																							((<= count_boss_cycle 0)						(begin
																																		(ai_cannot_die boss_tartarus 0)
																																		(ai_kill boss_tartarus)
																																		TRUE
																																	))
																							(TRUE									(begin
																																		(if
																																			mark_boss_first_cycle
																																			(begin
																																				(print "(growls in pain) A lucky hit! You will not land another!")
																																				(sound_impulse_start sound\dialog\levels\08_controlroom\mission\l08_1020_tar (ai_get_object boss_tartarus) 1)
																																				(set mark_boss_first_cycle FALSE)
																																			)
																																		)
																																		(cond
																																			((difficulty_legendary)	(unit_set_maximum_vitality (ai_get_unit boss_tartarus) 400 1000))
																																			((difficulty_heroic)	(unit_set_maximum_vitality (ai_get_unit boss_tartarus) 350 1000))
																																			(TRUE				(unit_set_maximum_vitality (ai_get_unit boss_tartarus) 300 1000))
																																		)
																																		(set boss_respawn_brutes TRUE)
																																		;(set boss_respawn_elites TRUE)
																																		(boss_tartarus_invincible_on)
																																		(begin_random
																																			(cs_run_command_script boss_tartarus cs_boss_tartarus_taunt)
																																			(cs_run_command_script boss_tartarus cs_boss_tartarus_cheer)
																																			(cs_run_command_script boss_tartarus cs_boss_tartarus_shakefist)
																																		)
																																		(sleep_until
																																			(and
																																				(not (cs_command_script_running boss_tartarus cs_boss_tartarus_taunt))
																																				(not (cs_command_script_running boss_tartarus cs_boss_tartarus_cheer))
																																				(not (cs_command_script_running boss_tartarus cs_boss_tartarus_shakefist))
																																			)
																																		1)
																																		(if (not (difficulty_normal)) (boss_tartarus_berserk_on))
																																		FALSE
																																	))
																						)
																					))
			((and
				(not (volume_test_objects tv_boss_platform (players)))
				(not (ai_vitality_pinned boss_tartarus))
				(> (player_count) 0)
			)																		(begin
																						(if boss_flavor_done (boss_tartarus_taunt))
																						(ai_magically_see_object boss_tartarus (player0))
																						(ai_magically_see_object boss_tartarus (player1))
																						(sleep_until (volume_test_objects tv_boss_platform (players)) 1 (* 15 30))
																						FALSE
																					))
			((> timer_boss_tartarus_recharge 0)											(begin
																						(set timer_boss_tartarus_recharge (- timer_boss_tartarus_recharge 1))
																						FALSE
																					))
			((not boss_tartarus_invincible)												(begin
																						(ai_magically_see_object boss_tartarus (player0))
																						(ai_magically_see_object boss_tartarus (player1))
																						(boss_tartarus_invincible_on)
																						FALSE
																					))
			((or
				(and
					(difficulty_legendary)
					(< (unit_get_shield (ai_get_unit boss_tartarus)) 0.9)
				)
				(and
					(difficulty_heroic)
					(< (unit_get_shield (ai_get_unit boss_tartarus)) 0.95)
				)
				(and
					(difficulty_normal)
					(< (unit_get_shield (ai_get_unit boss_tartarus)) 0.975)
				)
			)																		(begin
																						(ai_magically_see_object boss_tartarus (player0))
																						(ai_magically_see_object boss_tartarus (player1))
																						(boss_tartarus_invincible_off)
																						(if boss_flavor_done (boss_johnson_prompt))
																						(set timer_boss_tartarus_recharge (boss_tartarus_rateofrecharge))
																						FALSE
																					))
			((> timer_boss_tartarus_berserk 0)												(begin
																						(set timer_boss_tartarus_berserk (- timer_boss_tartarus_berserk 1))
																						FALSE
																					))
			(boss_tartarus_berserk														(begin
																						(ai_magically_see_object boss_tartarus (player0))
																						(ai_magically_see_object boss_tartarus (player1))
																						(boss_tartarus_berserk_off)
																						FALSE
																					))
			((and
				boss_respawn_brutes
				(<=
					(+
						(ai_living_count boss_elite_reenforcements)
						(ai_living_count boss_brute_reenforcements)
					)
					3
				)
			)																		(begin
																						(cond
																							((difficulty_legendary)		(set boss_random_reenforcements (random_range 3 10)))
																							((difficulty_heroic)		(set boss_random_reenforcements (random_range 3 7)))
																							(TRUE					(set boss_random_reenforcements (random_range 0 6)))
																						)
																						(cond
																							((> boss_random_reenforcements 7)		(ai_place boss_brute_reenforcements_many))
																							((> boss_random_reenforcements 3)		(ai_place boss_brute_reenforcements))
																						)
																						(set boss_respawn_brutes FALSE)
																					))
			((and
				boss_respawn_elites
				(<=
					(+
						(ai_living_count boss_elite_reenforcements)
						(ai_living_count boss_brute_reenforcements)
					)
					3
				)
			)																		(begin
																						(cond
																							((difficulty_legendary)		(set boss_random_reenforcements (random_range 3 10)))
																							((difficulty_heroic)		(set boss_random_reenforcements (random_range 3 7)))
																							(TRUE					(set boss_random_reenforcements (random_range 0 6)))
																						)
																						(cond
																							((< boss_random_reenforcements 3)		(ai_place boss_elite_reenforcements_many))
																							((< boss_random_reenforcements 7)		(ai_place boss_elite_reenforcements))
																						)
																						(set boss_respawn_elites FALSE)
																					))
			((> timer_boss_johnson_fire 0)												(begin
																						(set timer_boss_johnson_fire (- timer_boss_johnson_fire 1))
																						(if
																							(<=
																								(+
																									(ai_living_count boss_elite_reenforcements)
																									(ai_living_count boss_brute_reenforcements)
																								)
																								3
																							)
																							(set timer_boss_reenforcements (- timer_boss_reenforcements 1))
																						)
																						(if
																							(<= timer_boss_reenforcements 0)
																							(begin
																								(set boss_respawn_elites TRUE)
																								;(set boss_respawn_brutes TRUE)
																								(set timer_boss_reenforcements (boss_rateofreenforcement))
																								(print "Respawn!")
																							)
																						)
																						FALSE
																					))
			((objects_can_see_object (ai_get_object boss_johnson) (ai_get_object boss_tartarus) .25)	(begin
																						(ai_magically_see_object boss_tartarus (player0))
																						(ai_magically_see_object boss_tartarus (player1))
																						(print "FIRE")
																						(object_set_shield (ai_get_object boss_tartarus) (/ 1 1000));object_set_shield multiplies the scale times the maximum vitality and then sets the current vitality scale to that giant number
																						(cs_run_command_script boss_johnson cs_boss_johnson_shoot)
																						(cs_queue_command_script boss_johnson cs_boss_johnson_idle)
																						(set timer_boss_johnson_fire (boss_johnson_rateoffire))									
																						FALSE
																					))
			(TRUE																	(begin
																						(ai_magically_see_object boss_tartarus (player0))
																						(ai_magically_see_object boss_tartarus (player1))
																						FALSE
																					))
		)
	1)
	(ai_kill boss_tartarus)
	(print "NICE JOB!")
	(sleep_forever boss_flavor)

	(sleep (* 10 30))
	(if (= (player_count) 0) (sleep_forever))
	(cinematic_fade_to_white)
	(sleep 15)
	(ai_erase boss_elite_reenforcements)
	(ai_erase boss_tartarus)
	(ai_erase boss_brute_reenforcements)
	(ai_erase boss_miranda)
	(ai_erase boss_johnson)
	(ai_erase boss_monitor)
	(object_destroy_containing boss_object)
	(garbage_collect_now)
)
;*
(script static void test
;	(ai_place boss_tartarus)
;	(unit_impervious (ai_get_object boss_tartarus) 1)
;	(ai_cannot_die boss_tartarus 1)
;	(object_set_scale (ai_get_object boss_tartarus) 1.15 0)
;	(boss_tartarus_invincible_on)
;	(sleep 30)
;	(object_teleport (ai_get_object boss_tartarus) test_flag)
)
*;					