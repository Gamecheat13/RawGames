;*********************************************************************;
;030_outskirts Cinematics
;*********************************************************************;

;Placeholder for perspective on bridge
(script dormant sc_bridge_perspective
	(perspective_start)
	(camera_set cam_bridge 0)
	(sleep 30)
	(fade_in 0 0 0 15)
	
	(if (= (volume_test_object tv_bridge_oc5 (player0)) TRUE)
		(unit_exit_vehicle (unit (player0)))
	)
	(if (= (volume_test_object tv_bridge_oc5 (player1)) TRUE)
		(unit_exit_vehicle (unit (player1)))
	)
	(if (= (volume_test_object tv_bridge_oc5 (player2)) TRUE)
		(unit_exit_vehicle (unit (player2)))
	)
	(if (= (volume_test_object tv_bridge_oc5 (player3)) TRUE)
		(unit_exit_vehicle (unit (player3)))
	)
	
	(sleep 150)
	(fade_out 0 0 0 15)
	(sleep 15)
	(perspective_stop)
)

;ending cinematic
(script dormant sc_exit_ending_cinematic
	(data_mine_set_mission_segment "030la_Highway")
	(campaign_metagame_time_pause TRUE)
	(cinematic_fade_to_black)
	(game_award_level_complete_achievements)

	(sleep 1)

	(object_hide (player0) TRUE)
	(object_hide (player1) TRUE)
	(object_hide (player2) TRUE)
	(object_hide (player3) TRUE)
	
	(object_teleport (player0) player0_safelocation)
	(object_teleport (player1) player1_safelocation)
	(object_teleport (player2) player2_safelocation)
	(object_teleport (player3) player3_safelocation)

	(sleep 1)
	
	(if (cinematic_skip_start)
		(begin
			(print "end cinematic")
			(camera_control off)
			(camera_control on)
			(cinematic_start)
			(set cinematic_letterbox_style 2)
			(cinematic_show_letterbox_immediate 1)			
			(030la_highway)
		)
	)
	(cinematic_skip_stop)
	(cinematic_stop)	
	(sound_class_set_gain "" 0 0)
	(030la_highway_cleanup)	
			
	(player_enable_input TRUE)
	(player_camera_control TRUE)	
	
	(sleep 1)
	
	(end_mission)	

)
