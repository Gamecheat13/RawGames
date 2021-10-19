;==========  Boss Fight Globals ==========
(global short counter_boss_monitor_taunt 0)
(global short skip_boss_monitor_taunt 150)
(global ai johnson_boss_ai NONE)
(global ai monitor_boss_ai NONE)

;==========  Main Thread (Call from 120_HALO) ==========
(script static void boss
;The Monitor is mad at you
	(ai_dialogue_enable FALSE)
	(game_safe_to_respawn FALSE)

	(device_set_position_immediate control_room_door 0)
	(ai_allegiance human player)
	(ai_allegiance_break sentinel player)

;Create Monitor, make him invincible, and attach him to device machine
	(object_create_anew monitor_boss_device)
	(object_create_anew monitor_boss_idle_device)
	(ai_place monitor_boss_squad)
	(set monitor_boss_ai monitor_boss_squad)
	(object_set_scale (ai_get_object monitor_boss_squad) 1.75 0)
	(object_set_function_variable monitor_boss_ai angry 1 20)
	(object_cannot_take_damage (ai_get_object monitor_boss_squad))
	(object_cannot_take_damage monitor_boss_device)
	(objects_attach monitor_boss_device "attach_marker" monitor_boss_idle_device "")
	(objects_attach monitor_boss_idle_device "attach_marker" (ai_get_object monitor_boss_squad) "body")

	(vs_reserve monitor_boss_squad 0)
	(vs_enable_looking monitor_boss_ai TRUE)
	(vs_enable_targeting monitor_boss_ai FALSE)
	(vs_enable_moving monitor_boss_ai FALSE)
	(vs_shoot monitor_boss_ai FALSE)
	(vs_aim_player monitor_boss_ai TRUE)

;Create Johnson, put him on the ground
	(ai_place johnson_boss_squad)
		(set johnson_boss_ai johnson_boss_squad)
	(ai_disregard (ai_get_object johnson_boss_ai) TRUE)
	(ai_prefer_target (players) TRUE)

	(object_cannot_take_damage (ai_get_object johnson_boss_ai))
	(object_dynamic_simulation_disable (ai_get_object johnson_boss_ai) TRUE)

	(vs_reserve johnson_boss_squad 0)
	(vs_enable_looking johnson_boss_ai TRUE)
	(vs_enable_targeting johnson_boss_ai FALSE)
	(vs_enable_moving johnson_boss_ai FALSE)

;	(vs_custom_animation_loop johnson_boss_ai "objects\characters\marine\marine" "act_laser:idle_down" FALSE)
	(vs_posture_set johnson_boss_ai "act_laser1" TRUE)

;The action starts
	(print "------------------END CUTSCENE------------------")
	(unit_drop_support_weapon (player0))
	(unit_drop_support_weapon (player1))
	(unit_drop_support_weapon (player2))
	(unit_drop_support_weapon (player3))

	(object_can_take_damage (players))
	(damage_players "objects\characters\monitor\damage_effects\first_hit")
	(cinematic_fade_to_gameplay)

;Start the Monitor moving
	(device_set_position monitor_boss_device .8)

	(sleep_until (> (device_get_position monitor_boss_device) .2) 1)
	(vs_shoot monitor_boss_ai TRUE)
	(vs_enable_targeting monitor_boss_ai TRUE)

	(sleep_until (>= (device_get_position monitor_boss_device) .55) 1 (random_range 60 120))
	(begin
		(if (not (>= (device_get_position monitor_boss_device) .55))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_110_gsp" monitor_boss_ai 1)
				(sleep_until (>= (device_get_position monitor_boss_device) .55) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_110_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_110_gsp")
				(sleep_until (>= (device_get_position monitor_boss_device) .55) 1 (random_range 60 120))
			)
		)
		(if (not (>= (device_get_position monitor_boss_device) .55))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_120_gsp" monitor_boss_ai 1)
				(sleep_until (>= (device_get_position monitor_boss_device) .55) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_120_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_120_gsp")
				(sleep_until (>= (device_get_position monitor_boss_device) .55) 1 (random_range 60 120))
			)
		)
	)

	(sleep_until (>= (device_get_position monitor_boss_device) .55) 1)
	(vs_shoot monitor_boss_ai FALSE)
	(vs_enable_targeting monitor_boss_ai FALSE)
	(sleep_until (>= (device_get_position monitor_boss_device) .6) 1)
	(sound_impulse_start "sound\dialog\120_halo\mission\120ME_130_gsp" monitor_boss_ai 1)
	(sleep (- (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_120_gsp") 135))
	(print "lineover")
;	(vs_custom_animation_loop johnson_boss_ai "objects\characters\marine\marine" "act_laser:ready" TRUE)
	(vs_posture_set johnson_boss_ai "act_laser2" TRUE)
	(sleep 100)

	(sleep 35)
;	(vs_stop_custom_animation johnson_boss_ai)
;	(vs_custom_animation_loop johnson_boss_ai "objects\characters\marine\marine" "act_laser:idle_up" TRUE)
;	(vs_posture_set johnson_boss_ai "act_laser3" TRUE)

	(vs_enable_targeting johnson_boss_ai TRUE)
	(vs_shoot johnson_boss_ai TRUE monitor_boss_device)
	(print "linestart	")
	(sound_impulse_start "sound\dialog\120_halo\letterbox\120LB_250_jon" johnson_boss_ai 1)
	(sleep 85)

	(vs_enable_targeting johnson_boss_ai FALSE)
	(vs_shoot johnson_boss_ai FALSE)

	(device_set_position monitor_boss_device .9)
	(object_set_region_state (ai_get_object monitor_boss_squad) "" "minor damage")
	(vs_enable_targeting monitor_boss_ai FALSE)
	(vs_shoot monitor_boss_ai FALSE)

;	(vs_custom_animation_loop johnson_boss_ai "objects\characters\marine\marine" "act_laser:give" TRUE)
;	(sleep 48)
	(vs_posture_set johnson_boss_ai "act_laser3" TRUE)

;	(vs_custom_animation_loop johnson_boss_ai "objects\characters\marine\marine" "act_laser:give_idle" TRUE)

;	(vs_stop_custom_animation johnson_boss_ai)
;	(vs_custom_animation_loop johnson_boss_ai "objects\characters\marine\marine" "act_laser:idle_up" TRUE)
;	(vs_posture_set johnson_boss_ai "act_laser" TRUE)

	(sleep_until
		(or
			(and
				(> (objects_distance_to_object (players) (ai_get_object johnson_boss_ai)) 0)
				(< (objects_distance_to_object (players) (ai_get_object johnson_boss_ai)) 2)
			)
			(volume_test_players tv_boss_past_johnson)
		)
	1)

	(print "urk... take this...")


	(sleep_until
		(or
			(unit_has_weapon_readied (unit (player0)) "objects\weapons\support_high\spartan_laser\spartan_laser.weapon")
			(unit_has_weapon_readied (unit (player1)) "objects\weapons\support_high\spartan_laser\spartan_laser.weapon")
			(unit_has_weapon_readied (unit (player2)) "objects\weapons\support_high\spartan_laser\spartan_laser.weapon")
			(unit_has_weapon_readied (unit (player3)) "objects\weapons\support_high\spartan_laser\spartan_laser.weapon")
			(unit_has_weapon_readied (unit (player0)) "objects\weapons\support_high\spartan_laser\spartan_laser_overloaded.weapon")
			(unit_has_weapon_readied (unit (player1)) "objects\weapons\support_high\spartan_laser\spartan_laser_overloaded.weapon")
			(unit_has_weapon_readied (unit (player2)) "objects\weapons\support_high\spartan_laser\spartan_laser_overloaded.weapon")
			(unit_has_weapon_readied (unit (player3)) "objects\weapons\support_high\spartan_laser\spartan_laser_overloaded.weapon")
			(volume_test_players tv_boss_past_johnson)
		)
	1 180)

	(print "KICK HIS ASS")
	(sound_impulse_start "sound\dialog\120_halo\letterbox\120LB_260_jon" johnson_boss_ai 1)
		(sleep (- (sound_impulse_language_time "sound\dialog\120_halo\letterbox\120LB_260_jon") 10))

	(vs_posture_set johnson_boss_ai "act_laser4" TRUE)
	(sleep 15)

	(object_can_take_damage (ai_get_object johnson_boss_ai))
	(object_dynamic_simulation_disable (ai_get_object johnson_boss_ai) FALSE)
	(damage_object_effect "objects\weapons\damage_effects\johnson_dies_at_the_end" (ai_get_object johnson_boss_squad))

	(sleep_until (volume_test_players tv_boss_past_johnson) 1 90)

	(sleep_until
		(or
			(unit_has_weapon_readied (unit (player0)) "objects\weapons\support_high\spartan_laser\spartan_laser.weapon")
			(unit_has_weapon_readied (unit (player1)) "objects\weapons\support_high\spartan_laser\spartan_laser.weapon")
			(unit_has_weapon_readied (unit (player2)) "objects\weapons\support_high\spartan_laser\spartan_laser.weapon")
			(unit_has_weapon_readied (unit (player3)) "objects\weapons\support_high\spartan_laser\spartan_laser.weapon")
			(unit_has_weapon_readied (unit (player0)) "objects\weapons\support_high\spartan_laser\spartan_laser_overloaded.weapon")
			(unit_has_weapon_readied (unit (player1)) "objects\weapons\support_high\spartan_laser\spartan_laser_overloaded.weapon")
			(unit_has_weapon_readied (unit (player2)) "objects\weapons\support_high\spartan_laser\spartan_laser_overloaded.weapon")
			(unit_has_weapon_readied (unit (player3)) "objects\weapons\support_high\spartan_laser\spartan_laser_overloaded.weapon")
			(volume_test_players tv_boss_past_johnson)
		)
	1 180)

	(device_set_position monitor_boss_device 1)
	(object_can_take_damage monitor_boss_device)
	(vs_shoot monitor_boss_ai TRUE)
	(vs_enable_targeting monitor_boss_ai TRUE)

	(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 60 120))
	(begin_random
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_010_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_010_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_010_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_020_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_020_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_020_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_030_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_030_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_030_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_040_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_040_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_040_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
	)
	(if (not (< (object_get_shield monitor_boss_device) .2))
		(begin
			(print "KILL THE PLAYER")
		)
	)

	(sleep_until (< (object_get_shield monitor_boss_device) .2) 1)
	(object_set_region_state (ai_get_object monitor_boss_squad) "" "medium damage")
	(effect_new_on_object_marker "objects\characters\monitor\fx\boss\death\trans_damage" (ai_get_object monitor_boss_ai) "")
	(damage_players "objects\characters\monitor\damage_effects\spark_hit")
	(vs_shoot monitor_boss_ai FALSE)
	(vs_enable_targeting monitor_boss_ai FALSE)
	(device_set_power monitor_boss_idle_device 1)
	(sleep 20)
	(device_set_power monitor_boss_idle_device 0)

	(object_set_shield monitor_boss_device 1)

	(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 30 60))
	(vs_shoot monitor_boss_ai TRUE)
	(vs_enable_targeting monitor_boss_ai TRUE)
	(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 30 60))
	(begin_random
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_140_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_140_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_140_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_150_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_150_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_150_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_160_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_160_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_160_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
	)
	(if (not (< (object_get_shield monitor_boss_device) .2))
		(begin
			(print "KILL THE PLAYER")
		)
	)

	(sleep_until (< (object_get_shield monitor_boss_device) .2) 1)
	(object_set_region_state (ai_get_object monitor_boss_squad) "" "major damage")
	(effect_new_on_object_marker "objects\characters\monitor\fx\boss\death\trans_damage" (ai_get_object monitor_boss_ai) "")
	(damage_players "objects\characters\monitor\damage_effects\spark_hit")
	(vs_shoot monitor_boss_ai FALSE)
	(vs_enable_targeting monitor_boss_ai FALSE)
	(device_set_power monitor_boss_idle_device 1)
	(sleep 20)
	(device_set_power monitor_boss_idle_device 0)

	(object_set_shield monitor_boss_device 1)
	(print "Yer a dick!")
;	(sound_impulse_start  "sound\dialog\combat\sgt_johnson\01_alert\ordr_openfire" johnson_boss 1)

	(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 30 60))
	(vs_shoot monitor_boss_ai TRUE)
	(vs_enable_targeting monitor_boss_ai TRUE)
	(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 30 60))
	(begin_random
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_170_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_170_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_170_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_180_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_180_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_180_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_190_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_190_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_190_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
		(if (not (< (object_get_shield monitor_boss_device) .2))
			(begin
				(sound_impulse_start "sound\dialog\120_halo\mission\120ME_260_gsp" monitor_boss_ai 1)
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (sound_impulse_language_time "sound\dialog\120_halo\mission\120ME_260_gsp"))
				(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_260_gsp")
				(sleep_until (< (object_get_shield monitor_boss_device) .2) 1 (random_range 180 240))
			)
		)
	)
	(if (not (< (object_get_shield monitor_boss_device) .2))
		(begin
			(print "KILL THE PLAYER")
		)
	)

	(sleep_until (< (object_get_shield monitor_boss_device) .2) 1)
	(vs_shoot monitor_boss_ai FALSE)
	(vs_enable_targeting monitor_boss_ai FALSE)
	(print "(death shriek)")
	(sound_looping_start levels\solo\120_halo\music\120_music_12 NONE 1)

	(sound_impulse_start "sound\dialog\120_halo\mission\120ME_200_gsp" monitor_boss_ai 1)
	(effect_new_on_object_marker "objects\characters\monitor\fx\boss\death\trans_destroyed_delay" (ai_get_object monitor_boss_ai) "")

	(sleep 90)
	(device_set_power monitor_boss_idle_device 1)
	(sleep 30)

	(effect_new_on_object_marker "objects\characters\monitor\fx\boss\death\trans_destroyed" (ai_get_object monitor_boss_ai) "")
	(damage_players "objects\characters\monitor\damage_effects\spark_hit")
	(sleep 1)
	(object_destroy monitor_boss_device)
	(object_destroy (ai_get_object monitor_boss_ai))
	
	(sound_impulse_stop "sound\dialog\120_halo\mission\120ME_200_gsp")

	(sleep 180)

	(ai_prefer_target (players) FALSE)
	(game_safe_to_respawn TRUE)

	(campaign_metagame_award_points (player0) 300)
	(campaign_metagame_award_points (player1) 300)
	(campaign_metagame_award_points (player2) 300)
	(campaign_metagame_award_points (player3) 300)
	(ai_dialogue_enable TRUE)
	
	(print "------------------BEGIN CUTSCENE------------------")
)


(script static void test
	(ai_place johnson_boss_squad)
		(set johnson_boss_ai johnson_boss_squad)
	(print "compile is working")
	(vs_reserve johnson_boss_squad 0)
	(vs_enable_looking johnson_boss_ai TRUE)
	(vs_enable_targeting johnson_boss_ai FALSE)
	(vs_enable_moving johnson_boss_ai FALSE)

	(vs_posture_set johnson_boss_ai "act_laser3" TRUE)
	(sleep 90)
	(damage_object_effect "objects\weapons\damage_effects\johnson_dies_at_the_end" (ai_get_object johnson_boss_squad))
)