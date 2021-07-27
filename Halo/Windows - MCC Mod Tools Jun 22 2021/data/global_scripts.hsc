;matt's global scripts

(script static unit player0
  (unit (list_get (players) 0)))

(script static unit player1
  (unit (list_get (players) 1)))
  
(script static short player_count
  (list_count (players)))

(script static boolean cinematic_skip_start
	(cinematic_skip_start_internal)
	(game_save_totally_unsafe)
	(sleep_until (not (game_saving)) 1)
	(not (game_reverted)))

(script static void cinematic_skip_stop
	(cinematic_skip_stop_internal))

;USAGE:
;(if (cinematic_skip_start) (cinematic))
;(cinematic_skip_stop)

;jaime's global scripts
;========== Global Variables ==========
(global boolean global_dialog_on false)
(global boolean global_music_on false)
(global long global_delay_music (* 30 300))
(global long global_delay_music_alt (* 30 300))

;========== Misc Scripts ==========
(script static void script_dialog_start
	(sleep_until (not global_dialog_on))
	(set global_dialog_on true)
	(ai_dialogue_triggers off)
	)

(script static void script_dialog_stop
	(ai_dialogue_triggers on)
	(sleep 30)
	(set global_dialog_on false)
	)

;========== Damage Effect Scripts ==========

(script static void player_effect_impact
	(player_effect_set_max_translation .05 .05 .075)
	(player_effect_set_max_rotation 0 0 0)
	(player_effect_set_max_vibrate .4 1)
	(player_effect_start (real_random_range .7 .9) .1)
	)

(script static void player_effect_explosion
	(player_effect_set_max_translation .01 .01 .025)
	(player_effect_set_max_rotation .5 .5 1)
	(player_effect_set_max_vibrate .5 .4)
	(player_effect_start (real_random_range .7 .9) .1)
	)

(script static void player_effect_rumble
	(player_effect_set_max_translation .01 0 .02)
	(player_effect_set_max_rotation .1 .1 .2)
	(player_effect_set_max_vibrate .5 .3)
	(player_effect_start (real_random_range .7 .9) .5)
	)

(script static void player_effect_vibration
	(player_effect_set_max_translation .0075 .0075 .0125)
	(player_effect_set_max_rotation .01 .01 .05)
	(player_effect_set_max_vibrate .2 .5)
	(player_effect_start (real_random_range .7 .9) 1)
	)
