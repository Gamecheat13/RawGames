;========================================================================================
;================================== GLOBAL VARIABLES ====================================
;========================================================================================
(global boolean g_null FALSE)

(global boolean g_play_cinematics FALSE)
(global boolean g_player_training FALSE)
(global boolean debug TRUE)

; objective control global shorts
(global short g_sr01_obj_control 0)
(global short g_sr02_obj_control 0)
(global short g_gr01_obj_control 0)
(global short g_gr02_obj_control 0)
(global short g_bt01_obj_control 0)
(global short g_fc01_obj_control 0)
(global short g_bt02_obj_control 0)
(global short g_fc02_obj_control 0)


(script static void 080la_forest_intro
	(if debug (print "cinematic will go here"))
)


;========================================================================================
;========================================================================================
;=============================== FOREST MISSION SCRIPT ==================================
;========================================================================================
;========================================================================================
(script startup mission_main
	; fade to black 
	(fade_out 0 0 0 0)
	
	; hide the players 
	(object_hide (player0) TRUE)
	(object_hide (player1) TRUE)
	(object_hide (player2) TRUE)
	(object_hide (player3) TRUE)

	; set allegiances 
	(ai_allegiance covenant player)
	(ai_allegiance player covenant)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(ai_allegiance covenant human)
	(ai_allegiance human covenant)
	
	; the game can use flashlights 
	(game_can_use_flashlights TRUE)
	
	; turn on disc randomizers
	(wake amb_sr_discs_right)
	(wake amb_sr_discs_left)

	; Begin the mission if the player exists in the world 
	(if (> (player_count) 0 ) (start) (fade_in 0 0 0 0))
)

; get the party started!
(script static void start
	(wake mission_forest)
)

; this is the main mission thread 
(script dormant mission_forest
	(if debug (print "guardian forest"))
	
			; start intro cinematic 
			(if g_play_cinematics
				(begin
					(if (cinematic_skip_start)
						(begin
							(if debug (print "guardian forest intro"))
							(080la_forest_intro)
						)
					)
					(cinematic_skip_stop)
				)
				(if debug (print "cinematic turned off in scripting"))
			)

		; clean up all the cinematic bullshit!!!!!! 
		(cinematic_stop)
		(camera_control off)
		(fade_in 0 0 0 30)
	
		; unhide the players 
		(object_hide (player0) FALSE)
		(object_hide (player1) FALSE)
		(object_hide (player2) FALSE)
		(object_hide (player3) FALSE)
		(sleep 30)
		
	(if debug (print "begin sentinel room encounters"))
	(wake enc_sentinel_rooms)
)



;====================================================================================================================================================================================================
;======================================= SENTINEL ROOMS =============================================================================================================================================
;====================================================================================================================================================================================================
(script dormant enc_sentinel_rooms

	; start in room 01
	(sleep_until (volume_test_players tv_sen_rm01_01) 1)
	(if debug (print "set objective control 1"))
	(set g_sr01_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_sen_rm01_02) 1)
	(if debug (print "set objective control 2"))
	(set g_sr01_obj_control 2)

	(sleep_until (volume_test_players tv_sen_rm01_03) 1)
	(if debug (print "set objective control 3"))
	(set g_sr01_obj_control 3)
	(game_save)

	(sleep_until (volume_test_players tv_sen_rm01_04) 1)
	(if debug (print "set objective control 4"))
	(set g_sr01_obj_control 4)

	(sleep_until (volume_test_players tv_sen_rm01_05) 1)
	(if debug (print "set objective control 5"))
	(set g_sr01_obj_control 5)

	(sleep_until (volume_test_players tv_sen_rm01_06) 1)
	(if debug (print "set objective control 6"))
	(set g_sr01_obj_control 6)

	(sleep_until (volume_test_players tv_sen_rm01_07) 1)
	(if debug (print "set objective control 7"))
	(set g_sr01_obj_control 7)
	(game_save)

	(sleep_until (volume_test_players tv_sen_rm01_08) 1)
	(if debug (print "set objective control 8"))
	(set g_sr01_obj_control 8)

	(sleep_until (volume_test_players tv_sen_rm01_09) 1)
	(if debug (print "set objective control 9"))
	(set g_sr01_obj_control 9)
	(game_save)

	; fly to room 02 
	(sleep_until (volume_test_players tv_sen_rm02_01) 1)
	(if debug (print "set objective control 1"))
	(set g_sr02_obj_control 1)
	(game_save)

	(sleep_until (volume_test_players tv_sen_rm02_02) 1)
	(if debug (print "set objective control 2"))
	(set g_sr02_obj_control 2)

	(sleep_until (volume_test_players tv_sen_rm02_03) 1)
	(if debug (print "set objective control 3"))
	(set g_sr02_obj_control 3)

	(sleep_until (volume_test_players tv_sen_rm02_04) 1)
	(if debug (print "set objective control 4"))
	(set g_sr02_obj_control 4)
	(game_save)

	(sleep_until (volume_test_players tv_sen_rm02_05) 1)
	(if debug (print "set objective control 5"))
	(set g_sr02_obj_control 5)

	(sleep_until (volume_test_players tv_sen_rm02_06) 1)
	(if debug (print "set objective control 6"))
	(set g_sr02_obj_control 6)

	(sleep_until (volume_test_players tv_sen_rm02_07) 1)
	(if debug (print "set objective control 7"))
	(set g_sr02_obj_control 7)
	(game_save)

	(sleep_until (volume_test_players tv_sen_rm02_08) 1)
	(if debug (print "set objective control 8"))
	(set g_sr02_obj_control 8)

	(sleep_until (volume_test_players tv_sen_rm02_09) 1)
	(if debug (print "set objective control 9"))
	(set g_sr02_obj_control 9)
	(game_save)

	(sleep_until (volume_test_players tv_sen_rm02_10) 1)
	(if debug (print "set objective control 10"))
	(set g_sr02_obj_control 10)

	(sleep_until (volume_test_players tv_sen_rm02_11) 1)
	(if debug (print "set objective control 11"))
	(set g_sr02_obj_control 11)
	(game_save)

)


;========================== sentinel room secondary scripts ==========================================================================================================================================

(script dormant amb_sr_discs_right
	(begin_random
		(begin
			(device_set_power core_disc_right_01 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_right_02 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_right_03 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_right_04 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_right_05 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_right_06 1)
			(sleep (random_range 30 90))
		)
	)
)

(script dormant amb_sr_discs_left
	(begin_random
		(begin
			(device_set_power core_disc_left_01 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_left_02 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_left_03 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_left_04 1)
			(sleep (random_range 30 90))
		)
		(begin
			(device_set_power core_disc_left_05 1)
			(sleep (random_range 30 90))
		)
	)
)
;*
(script static void test_emitters
	(wake ai_sr_a_aggressors)
	(wake ai_sr_b_aggressors)
	(wake ai_sr_c_aggressors)
	(wake ai_sr_d_aggressors)
)

(script dormant ai_sr_a_aggressors
	(if debug (print "spawn from emitter 01"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_01)
		(sleep 30)
	(if debug (print "spawn from emitter 02"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_02)
		(sleep 30)
	(if debug (print "spawn from emitter 03"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_03)
		(sleep 30)
	(if debug (print "spawn from emitter 04"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_04)
		(sleep 30)
	(if debug (print "spawn from emitter 05"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_05)
		(sleep 30)
	(if debug (print "spawn from emitter 06"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_06)
		(sleep 30)
	(if debug (print "spawn from emitter 07"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_07)
		(sleep 30)
	(if debug (print "spawn from emitter 08"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_08)
		(sleep 120)
	(if debug (print "spawn from emitter 09"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_09)
		(sleep 30)
	(if debug (print "spawn from emitter 10"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_10)
		(sleep 30)
	(if debug (print "spawn from emitter 11"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_11)
		(sleep 30)
	(if debug (print "spawn from emitter 12"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_12)
		(sleep 30)
	(if debug (print "spawn from emitter 13"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_13)
		(sleep 30)
	(if debug (print "spawn from emitter 14"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_14)
		(sleep 30)
	(if debug (print "spawn from emitter 15"))
	(ai_place sq_sr_a_aggressors/sen_rm_a_15)
)

(script dormant ai_sr_b_aggressors
	(if debug (print "spawn from emitter 01"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_01)
		(sleep 30)
	(if debug (print "spawn from emitter 02"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_02)
		(sleep 30)
	(if debug (print "spawn from emitter 03"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_03)
		(sleep 30)
	(if debug (print "spawn from emitter 04"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_04)
		(sleep 30)
	(if debug (print "spawn from emitter 05"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_05)
		(sleep 30)
	(if debug (print "spawn from emitter 06"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_06)
		(sleep 30)
	(if debug (print "spawn from emitter 07"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_07)
		(sleep 30)
	(if debug (print "spawn from emitter 08"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_08)
		(sleep 120)
	(if debug (print "spawn from emitter 09"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_09)
		(sleep 30)
	(if debug (print "spawn from emitter 10"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_10)
		(sleep 30)
	(if debug (print "spawn from emitter 11"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_11)
		(sleep 30)
	(if debug (print "spawn from emitter 12"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_12)
		(sleep 30)
	(if debug (print "spawn from emitter 13"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_13)
		(sleep 30)
	(if debug (print "spawn from emitter 14"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_14)
		(sleep 30)
	(if debug (print "spawn from emitter 15"))
	(ai_place sq_sr_b_aggressors/sen_rm_b_15)
)

(script dormant ai_sr_c_aggressors
	(if debug (print "spawn from emitter 01"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_01)
		(sleep 30)
	(if debug (print "spawn from emitter 02"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_02)
		(sleep 30)
	(if debug (print "spawn from emitter 03"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_03)
		(sleep 30)
	(if debug (print "spawn from emitter 04"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_04)
		(sleep 30)
	(if debug (print "spawn from emitter 05"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_05)
		(sleep 30)
	(if debug (print "spawn from emitter 06"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_06)
		(sleep 30)
	(if debug (print "spawn from emitter 07"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_07)
		(sleep 30)
	(if debug (print "spawn from emitter 08"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_08)
		(sleep 120)
	(if debug (print "spawn from emitter 09"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_09)
		(sleep 30)
	(if debug (print "spawn from emitter 10"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_10)
		(sleep 30)
	(if debug (print "spawn from emitter 11"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_11)
		(sleep 30)
	(if debug (print "spawn from emitter 12"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_12)
		(sleep 30)
	(if debug (print "spawn from emitter 13"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_13)
		(sleep 30)
	(if debug (print "spawn from emitter 14"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_14)
		(sleep 30)
	(if debug (print "spawn from emitter 15"))
	(ai_place sq_sr_c_aggressors/sen_rm_c_15)
)

(script dormant ai_sr_d_aggressors
	(if debug (print "spawn from emitter 01"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_01)
		(sleep 30)
	(if debug (print "spawn from emitter 02"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_02)
		(sleep 30)
	(if debug (print "spawn from emitter 03"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_03)
		(sleep 30)
	(if debug (print "spawn from emitter 04"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_04)
		(sleep 30)
	(if debug (print "spawn from emitter 05"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_05)
		(sleep 30)
	(if debug (print "spawn from emitter 06"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_06)
		(sleep 30)
	(if debug (print "spawn from emitter 07"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_07)
		(sleep 30)
	(if debug (print "spawn from emitter 08"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_08)
		(sleep 120)
	(if debug (print "spawn from emitter 09"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_09)
		(sleep 30)
	(if debug (print "spawn from emitter 10"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_10)
		(sleep 30)
	(if debug (print "spawn from emitter 11"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_11)
		(sleep 30)
	(if debug (print "spawn from emitter 12"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_12)
		(sleep 30)
	(if debug (print "spawn from emitter 13"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_13)
		(sleep 30)
	(if debug (print "spawn from emitter 14"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_14)
		(sleep 30)
	(if debug (print "spawn from emitter 15"))
	(ai_place sq_sr_d_aggressors/sen_rm_d_15)
)
;*
=========================================================================================
================================== COMMENTS AND JUNK ====================================
=========================================================================================


Objects per frame		characters	vehicles	weapons	scenery	crates/garbage/items
						28			12		30		50		60



*;