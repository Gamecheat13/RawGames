(global boolean start01 FALSE)
(global boolean start02 FALSE)


(script static void test_scarab_orbital

    (sleep_until
        (begin
            (wake anim1)
            (wake anim2)
            (set start01 TRUE)
            (set start02 TRUE)
            (sleep 600)
            FALSE
        )
    )

)

(script dormant ring_cin_inf_spawn
	(sleep 60)
	(vs_swarm_to ring_cin_inf01 FALSE ring01_pts/cin_swarm01 1)
	(sleep 110)
	(vs_swarm_to ring_cin_inf01 FALSE ring01_pts/cin_swarm02 1)
	(sleep 160)
)


(script continuous anim1
    (sleep_until start01)
	(ai_place crater_cov_scarab01)
	(vs_custom_animation crater_cov_scarab01/driver01 FALSE objects\giants\scarab\cinematics\perspectives\100pb_scarab_orbital\100pb_scarab_orbital "100pb_cin_scarab_b_1" FALSE)
	(sleep (unit_get_custom_animation_time (ai_get_unit crater_cov_scarab01/driver01)))
	(vs_stop_custom_animation crater_cov_scarab01/driver01)
	(ai_force_active crater_cov_scarab01/driver01 TRUE)
	;if scorpion is still alive try and kill it
	;(if (> (object_get_health (ai_vehicle_get_from_starting_location tank_marines_scorpion/scorpion01)) 0)
	;	(cs_run_command_script crater_cov_scarab01 scarab_tank_kill_cs)
	;)
	(sleep 30)
	(ai_erase crater_cov_scarab01)
	(set start01 FALSE)
	;(ai_place crater_cov_brutes01)
)

(script continuous anim2
    (sleep_until start02)
	(ai_place crater_cov_scarab02)
	(vs_custom_animation crater_cov_scarab02/driver01 FALSE objects\giants\scarab\cinematics\perspectives\100pb_scarab_orbital\100pb_scarab_orbital "100pb_cin_scarab_a_1" FALSE)
	(sleep (unit_get_custom_animation_time (ai_get_unit crater_cov_scarab02/driver01)))
	(vs_stop_custom_animation crater_cov_scarab02/driver01)
	(ai_force_active crater_cov_scarab02/driver01 TRUE)
	(sleep 30)
	(ai_erase crater_cov_scarab02)
	(set start02 FALSE)
	;(ai_place crater_cov_brutes02)
)


(global boolean startit FALSE)

(script static void fx_test_first_tower_loop
    (sleep_until
        (begin
            (fx_test_first_tower)
            FALSE
        )
    )
)

(script static void fx_test_first_tower

    (switch_zone_set set_cell_a_int02)
    (device_set_power beam_diag_left 1)
	(device_set_power beam_vert_left 1)
	(device_set_power beam_vert_left_crater 1)
	(device_set_power beam_diag_mid 1)
	(device_set_power beam_vert_mid 1)
	(device_set_power beam_vert_mid_crater 1)

	(device_set_power tower1_switch 1)
	(sleep 1)
	(device_set_position tower1_switch 1)
	;(sleep_until (> (device_get_position tower1_switch) 0) 1)
	(device_operates_automatically_set tower1_holo FALSE)
	(device_set_position tower1_holo 0)
	
	(wake md_locka_tower1_done_fx_test)
	(set startit TRUE)
	
	(perspective_start)
	(object_hide (player0) TRUE)
	(object_hide (player1) TRUE)
	(object_hide (player2) TRUE)
	(object_hide (player3) TRUE)
	(100pa_first_tower)
	(object_hide (player0) FALSE)
	(object_hide (player1) FALSE)
	(object_hide (player2) FALSE)
	(object_hide (player3) FALSE)
	(perspective_stop)
)

(script continuous md_locka_tower1_done_fx_test
	;(if debug (print "mission dialogue:locka:tower1:done"))
	(sleep_until startit)

	(sleep 1)
		(sleep 90)
		(print "Left Beam: OFF")
		(effect_new_on_object_marker "levels\solo\100_citadel\fx\beam_deactivation\beam_deactivation_small.effect" beam_deactivation_1 "")
		(device_set_power beam_diag_left 0)
		(device_set_power beam_vert_left 0)
		(device_set_power beam_vert_left_crater 0)
		(sleep 30)
		(print "MIRANDA (radio): Good work, Chief! That's one!")
		(sleep 90)
		;(sleep (ai_play_line_on_object NONE 100PA_010))
		(sleep 10)
		
		(if (= (game_is_cooperative) FALSE)
			(begin
				(print "MIRANDA (radio): The Arbiter should be just about to")
				(sleep 75)
				;(sleep (ai_play_line_on_object NONE 100PA_020))
			)
			(begin		
				(print "MIRANDA (radio): The Elites should be just about to")
				(sleep 75)
				;(sleep (ai_play_line_on_object NONE 100PA_030))
			)
		)
		
		(print "Mid Beam: OFF")
		(effect_new_on_object_marker "levels\solo\100_citadel\fx\beam_deactivation\beam_deactivation_large.effect" beam_deactivation_2 "")
		(device_set_power beam_diag_mid 0)
		(device_set_power beam_vert_mid 0)
		(device_set_power beam_vert_mid_crater 0)
		
		(print "MIRANDA (radio): That's two! It's all up to Johnson's team now.")
		(sleep 90)
		;(sleep (ai_play_line_on_object NONE 100PA_040))
		(sleep 40)

		(print "MIRANDA (radio): Get back outside, Chief. Wait for transport!")
		;(sleep (ai_play_line_on_object NONE 100PA_050))
		
		;(cinematic_set_chud_objective obj_1)
		(sleep (random_range 60 100))
		;(wake md_locka_joh_update)
		
	(set startit FALSE)
)