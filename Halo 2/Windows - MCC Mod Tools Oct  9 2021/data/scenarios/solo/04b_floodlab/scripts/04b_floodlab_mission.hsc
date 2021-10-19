;04b_FLOODLAB!
;-------------------------------------------------------------------------------

(script stub void c04_intra0
	(print "hi, joe")
)
(script stub void c04_intra1
	(print "hi, joe")
)
(script stub void c04_outro1
	(print "hi, joe")
)
(script stub void c04_outro2
	(print "hi, joe")
)


;-------------------------------------------------------------------------------
;Global Scripts

;Before or after the cables are cut
(global boolean plummeting FALSE)

;Used to abort an AI out of a command script manually
(script command_script abort
	(cs_pause .1)
)

;Used to make an AI stand around and do nothing until alerted
(script command_script long_pause
	(cs_abort_on_alert TRUE)
	(sleep_forever)
)
(script command_script forever_pause
	(cs_pause -1)
)

;-------------------------------------------------------------------------------
;Chapter Titles

;"Juggernaut"
(script dormant 04b_title0
	(cinematic_fade_from_white_bars)
	(sleep 30)
	(cinematic_set_title title_1)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
	(game_save)
)

;"Hey, Watch This!"
(script dormant 04b_title1
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)
	(sleep 30)
	(cinematic_set_title title_2)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)

;"Dead or Alive…Actually, Just Dead."
(script dormant 04b_title2
	(hud_cinematic_fade 0 0.5)
	(cinematic_show_letterbox TRUE)
	(sleep 30)
	(cinematic_set_title title_3)
	(sleep 150)
	(hud_cinematic_fade 1 0.5)
	(cinematic_show_letterbox FALSE)
)


;-------------------------------------------------------------------------------
;Objectives

(script dormant objective_labs_set
            (sleep 30)
            (print "new objective set:")
            (print "Escape the infested labs.")
            (objectives_show_up_to 0)
)
(script dormant objective_labs_clear
            (print "objective complete:")
            (print "Escape the infested labs.")
            (objectives_finish_up_to 0)
)

(script dormant objective_control_set
            (sleep 30)
            (print "new objective set:")
            (print "Ascertain the Heretic Leader's whereabouts.")
            (objectives_show_up_to 1)
)
(script dormant objective_control_clear
            (print "objective complete:")
            (print "Ascertain the Heretic Leader's whereabouts.")
            (objectives_finish_up_to 1)
)

(script dormant objective_cables_set
            (sleep 30)
            (print "new objective set:")
            (print "Sever the tether holding the station aloft.")
            (objectives_show_up_to 2)
)
(script dormant objective_cables_clear
            (print "objective complete:")
            (print "Sever the tether holding the station aloft.")
            (objectives_finish_up_to 2)
)

(script dormant objective_dogfight_set
            (sleep 30)
            (print "new objective set:")
            (print "Pursue the Heretic Leader back to the hangar.")
            (objectives_show_up_to 3)
)
(script dormant objective_dogfight_clear
            (print "objective complete:")
            (print "Pursue the Heretic Leader back to the hangar.")
            (objectives_finish_up_to 3)
)

(script dormant objective_hl_set
            (sleep 30)
            (print "new objective set:")
            (print "Kill the Heretic Leader.")
            (objectives_show_up_to 4)
)
(script dormant objective_hl_clear
            (print "objective complete:")
            (print "Kill the Heretic Leader.")
            (objectives_finish_up_to 4)
)

;-------------------------------------------------------------------------------
;Music

(script dormant music_04b_01_start
	;after elite says "what is that?"
	(print "music 04b_01 start")
	(sound_looping_start "scenarios\solo\04b_floodlab\04b_music\04b_01" none 1.0)
)

(script dormant music_04b_01_stop
	;half way down elevator ride
	(print "music 04b_01 stop")
	(sound_looping_stop "scenarios\solo\04b_floodlab\04b_music\04b_01")
)

(script dormant music_04b_02_start
	;enter speciman storage silo
	(print "music 04b_02 start")
	(sound_looping_start "scenarios\solo\04b_floodlab\04b_music\04b_02" none 1.0)
)

(script dormant music_04b_02_stop
	;when elevator starts to move down
	(print "music 04b_02 stop")
	(sound_looping_stop "scenarios\solo\04b_floodlab\04b_music\04b_02")
)

(script dormant music_04b_03_start
	;at hall lab overlook to lab
	(print "music 04b_03 start")
	(sound_looping_start "scenarios\solo\04b_floodlab\04b_music\04b_03" none 1.0)
)

(script static void music_04b_03_start_alt
	;at 2nd wave in the lab
	;start of each subsequent wave
	(print "music 04b_03 start alt")
	(sound_looping_set_alternate "scenarios\solo\04b_floodlab\04b_music\04b_03" true)
)

(script static void music_04b_03_stop_alt
	;end of each wave
	(print "music 04b_03 stop alt")
	(sound_looping_set_alternate "scenarios\solo\04b_floodlab\04b_music\04b_03" false)
)

(script dormant music_04b_03_stop
	;end of lab encounter when door opens
	(print "music 04b_03 stop")
	(sound_looping_stop "scenarios\solo\04b_floodlab\04b_music\04b_03")
)

(script dormant music_04b_04_start
	;enter gas mine control room
	(print "music 04b_04 start")
	(sound_looping_start "scenarios\solo\04b_floodlab\04b_music\04b_04" none 1.0)
)

(script dormant music_04b_04_start_alt
	;at start of cine 04_intra1
	(print "music 04b_04 start alt")
	(sound_looping_set_alternate "scenarios\solo\04b_floodlab\04b_music\04b_04" true)
)

(script dormant music_04b_04_stop_alt
	;at end of cine 04_intra1
	(print "music 04b_04 stop alt")
	(sound_looping_set_alternate "scenarios\solo\04b_floodlab\04b_music\04b_04" false)
)

(script dormant music_04b_04_stop
	;when you push the elevator button
	(print "music 04b_04 stop")
	(sound_looping_stop "scenarios\solo\04b_floodlab\04b_music\04b_04")
)

(script dormant music_04b_05_start
	;when door opens and flood combat jump at you
	(print "music 04b_05 start")
	(sound_looping_start "scenarios\solo\04b_floodlab\04b_music\04b_05" none 1.0)
)

(script dormant music_04b_06_start
	;after you cut the 2nd cable
	(print "music 04b_06 start")
	(sound_looping_start "scenarios\solo\04b_floodlab\04b_music\04b_06" none 1.0)
)

(script dormant music_04b_07_start
	;after you cut the 3rd cable (stinger stops music)
	(print "music 04b_07 start")
	(sound_looping_start "scenarios\solo\04b_floodlab\04b_music\04b_07" none 1.0)
)

(script dormant music_04b_08_start
	;enter 1st dark hallway on chase to hangar
	(print "music 04b_08 start")
	(sound_looping_start "scenarios\solo\04b_floodlab\04b_music\04b_08" none 1.0)
)

(script dormant music_04b_08_start_alt
	;half way up the hallways
	(print "music 04b_08 start alt")
	(sound_looping_set_alternate "scenarios\solo\04b_floodlab\04b_music\04b_08" true)
)

(script dormant music_04b_08_stop
	;enter the room under the hangar
	(print "music 04b_08 stop")
	(sound_looping_stop "scenarios\solo\04b_floodlab\04b_music\04b_08")
)


;-------------------------------------------------------------------------------
;Kill Volumes

;so much simpler
(script dormant kill_volumes
	(kill_volume_disable kill_hangar_pit_01)
	(kill_volume_disable kill_hangar_pit_02)
	(kill_volume_disable kill_hangar_pit_03)
	(kill_volume_disable kill_hangar_pit_04)
	(kill_volume_disable kill_underhangar_pit_01)
	(kill_volume_disable kill_underhangar_pit_02)
	(kill_volume_disable kill_bottling_pit_01)
	(kill_volume_disable kill_bottling_pit_02)
;	(kill_volume_disable kill_cableroom_pit_01)
;	(kill_volume_disable kill_cableroom_pit_02)
;	(kill_volume_disable kill_cableroom_pit_03)

	(sleep_until (= (structure_bsp_index) 0))
	(kill_volume_disable kill_silo_pit)

	(sleep_until (= (structure_bsp_index) 2))
	(kill_volume_disable kill_wraparound)
;	(kill_volume_enable kill_cableroom_pit_01)
;	(kill_volume_enable kill_cableroom_pit_02)
;	(kill_volume_enable kill_cableroom_pit_03)

	(sleep_until (= (structure_bsp_index) 1))
;	(kill_volume_disable kill_cableroom_pit_01)
;	(kill_volume_disable kill_cableroom_pit_02)
;	(kill_volume_disable kill_cableroom_pit_03)
	(kill_volume_enable kill_bottling_pit_01)
	(kill_volume_enable kill_bottling_pit_02)

	(sleep_until
		(begin			
			(sleep_until (= (structure_bsp_index) 5))
			(kill_volume_disable kill_bottling_pit_01)
			(kill_volume_disable kill_bottling_pit_02)
			(kill_volume_enable kill_hangar_pit_01)
			(kill_volume_enable kill_hangar_pit_02)
			(kill_volume_enable kill_hangar_pit_03)
			(kill_volume_enable kill_hangar_pit_04)
			(kill_volume_enable kill_underhangar_pit_01)
			(kill_volume_enable kill_underhangar_pit_02)

			(sleep_until (= (structure_bsp_index) 1))
			(kill_volume_enable kill_bottling_pit_01)
			(kill_volume_enable kill_bottling_pit_02)
			(kill_volume_disable kill_hangar_pit_01)
			(kill_volume_disable kill_hangar_pit_02)
			(kill_volume_disable kill_hangar_pit_03)
			(kill_volume_disable kill_hangar_pit_04)
			(kill_volume_disable kill_underhangar_pit_01)
			(kill_volume_disable kill_underhangar_pit_02)
			
			FALSE
		)
	)
)

(script dormant cableroom_killer
	(sleep_until 
		(begin
			(if 
				(OR
;					(= (volume_test_object vol_cableroom_pit_01 (player0)) TRUE)
;					(= (volume_test_object vol_cableroom_pit_02 (player0)) TRUE)
;					(= (volume_test_object vol_cableroom_pit_03 (player0)) TRUE)
					(= (volume_test_object vol_croom_kill_new (player0)) TRUE)
					(= (volume_test_object vol_croom_kill_new_too (player0)) TRUE)
				)
					(unit_kill (unit (player0)))
			)
			(if 
				(OR
;					(= (volume_test_object vol_cableroom_pit_01 (player1)) TRUE)
;					(= (volume_test_object vol_cableroom_pit_02 (player1)) TRUE)
;					(= (volume_test_object vol_cableroom_pit_03 (player1)) TRUE)
					(= (volume_test_object vol_croom_kill_new (player1)) TRUE)
					(= (volume_test_object vol_croom_kill_new_too (player1)) TRUE)
				)
					(unit_kill (unit (player1)))
			)
			(= (structure_bsp_index) 1)
		)
	)
)
(script dormant cableroom_junk_killer
	(sleep_until 
		(begin
;			(sleep_until (> (list_count (volume_return_objects_by_type vol_croom_kill_new 2048)) 0))
;			(object_destroy (list_get (volume_return_objects_by_type vol_croom_kill_new 2048) 0))
			(sleep 90)
			(garbage_collect_now)
			(= (structure_bsp_index) 1)
		)
	)
)

;-------------------------------------------------------------------------------
;Initializing start of mission

;Sets up everything to match with the end of the intro
(script static void prep_return_from_intro
	(data_mine_set_mission_segment "04b_1_entry")
	(ai_place disposal_commander 1)
	(ai_cannot_die disposal_commander TRUE)
	(ai_place allies_elites_03a 1)
	(ai_place allies_elites_03b 1)
	(ai_place allies_grunts_03 2)
	
	(sleep 30)

	(object_teleport (player0) research_player0)
	(object_teleport (player1) research_player1)
)


;-------------------------------------------------------------------------------
;Arm 2 Entry

;Allies react to juggernaut slaughtering heretics
(script command_script juggernaut_gosh
	(cs_switch elite)
	(cs_abort_on_damage TRUE)
	(cs_enable_moving TRUE)
	(print "SPEC-OPS ELITE: 'By the Rings! What is that?!'")
	(cs_play_line 0550)
	(sleep 30)

	(cs_switch grunt)
	(cs_abort_on_damage TRUE)
	(cs_enable_moving TRUE)
	(print "SPEC-OPS GRUNT: (nervous grunts and whines)")
	(cs_play_line 0560)
	(sleep 30)
	
	(cs_switch elite)
	(print "SPEC-OPS ELITE: 'Quiet!'")
	(cs_play_line 0570)	
;)
;
;Allies react to juggernaut passing
;(script command_script juggernaut_whew
;	(cs_switch ally)
;	(cs_abort_on_damage TRUE)
	(cs_enable_moving TRUE)

	(sleep_until (= (ai_living_count disposal_entry_flood) 0) 30 300)
	(sleep 60)

	(print "SPEC-OPS ELITE: 'It's moved on.'")
	(cs_play_line 0580)
	(sleep 30)
	(print "SPEC-OPS ELITE: 'Quickly, before it returns! Let's find the heretic leader, and finish him off!'")
	(cs_play_line 0590)
)

;Gets the juggernaut out of there
(script command_script disposal_juggernaut_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to disposal_chamber/juggs)
	(ai_erase ai_current_actor)
)

;Overall script for the research arm entry
(script dormant arm_02_entry_start
	(sleep_until (= (volume_test_objects vol_juggernaut_preview (players)) TRUE))
	(ai_set_orders all_allies allies_disposal)
	(sound_class_set_gain unit_animation .5 1)

	;(ai_place disposal_entry_juggernaut 1)
	(ai_place disposal_entry_flood 4)
	(ai_cannot_die disposal_entry_flood TRUE)
	(ai_place disposal_entry_heretics 4)
	(units_set_maximum_vitality (ai_actors disposal_entry_heretics) 20 20)
	(units_set_current_vitality (ai_actors disposal_entry_heretics) 20 20)
	
	(sleep_until 
		(AND
			(= (volume_test_objects vol_juggernaut_preview (ai_actors allies_elites)) TRUE)
			(= (volume_test_objects vol_juggernaut_preview (ai_actors allies_grunts_03)) TRUE)
		)
	30 450)
	(sleep_until (ai_scene juggernaut_gosh_scene juggernaut_gosh all_allies) 30 450)
	(sleep 90)
	(wake music_04b_01_start)

	(sleep_until (= (ai_living_count disposal_entry_heretics) 0) 30 300)
	(ai_kill_silent disposal_entry_heretics)
	(cs_run_command_script disposal_entry_flood disposal_juggernaut_exit)
	(sound_class_set_gain unit_animation 1 1)
			
;	(sleep_until 
;		(AND
;			(= (ai_living_count disposal_entry_juggernaut) 0)
;			(=  FALSE)
;		)
;	)
;	(sleep_until (ai_scene juggernaut_whew_scene juggernaut_whew all_allies) 30 300)
)


;-------------------------------------------------------------------------------
;Disposal Chamber

;aborts allies out of juggernaut scripts if still playing
(script dormant juggernaut_abort
	(if 
		;(OR
			(cs_command_script_running all_allies juggernaut_gosh)
			;(cs_command_script_running all_allies juggernaut_whew)
		;)
			(cs_run_command_script all_allies abort)
			(sound_class_set_gain unit_animation 1 1)
	)
)

;Some variables to manage my holodrone scene
(global boolean holo_drone_arrived FALSE)
(global boolean hl_done_talking FALSE)
(global boolean done_shooting_holo FALSE)

;Flying in a temp holo probe
(script command_script holo_drone_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_shoot FALSE)
	(cs_fly_by disposal_chamber/p0)
	(cs_fly_by disposal_chamber/p1)
	(cs_fly_by disposal_chamber/p2)
	(cs_fly_by disposal_chamber/p3)
	(cs_fly_by disposal_chamber/p4)
	(cs_fly_to disposal_chamber/p5 .5)
	(set holo_drone_arrived TRUE)
	(sleep_forever)
)

;Tells when reaction over
(global boolean mess_react_01_go FALSE)
(global boolean mess_react_02_go FALSE)
(global boolean mess_react_01_done FALSE)
(global boolean mess_react_02_done FALSE)

;Allies react to the massacre in this room
(script command_script disposal_ally_comment_01
	(cs_switch so_elite)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(print "SPEC-OPS ELITE: 'What happened here?'")
	(cs_play_line 0010)
	(set mess_react_01_done TRUE)
)
(script command_script disposal_ally_comment_02
	(cs_switch grunt_01)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(print "SPEC-OPS GRUNT: 'Me have bad feeling 'bout this.'")
	(cs_play_line 0600)

	(cs_switch grunt_02)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(print "SPEC-OPS GRUNT: 'You always have bad feeling!'")
	(cs_play_line 0610)
	(sleep 10)
	(print "SPEC-OPS GRUNT: 'You had bad feeling about morning food-nipple!'")
	(cs_play_line 0620)
	
	(cs_switch elite_01)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(print "SPEC-OPS ELITE: 'Close your jaws, or I shall bind them shut!'")
	(cs_play_line 0630)
	(set mess_react_02_done TRUE)

	(cs_switch grunt_02)
	(cs_go_to_nearest disposal_grunts)
	
	(cs_switch grunt_01)
	(cs_go_to_nearest disposal_grunts)
)

;Tells when scenes are over
(global boolean holo_ally_01_go FALSE)
(global boolean holo_ally_02_go FALSE)
(global boolean holo_ally_03_go FALSE)
(global boolean holo_ally_01_done FALSE)
(global boolean holo_ally_02_done FALSE)
(global boolean holo_ally_03_done FALSE)

;makes everyone face the hologram
(script command_script hologram_face
;	(cs_start_approach holo_boy 3 20 20) 
;	(cs_aim_object TRUE holo_boy)
;	(sleep_until (= (list_count holo_boy) 0) 30 900)
;	(cs_aim_object FALSE holo_boy)
;	(cs_start_approach (list_get (ai_actors hl_hologram) 0) 3 20 20) 
	(cs_start_approach drone_spawn 3 20 20) 
	(cs_aim_object TRUE (list_get (ai_actors hl_hologram) 0))
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep_until (= (ai_living_count hl_hologram) 0) 30 900)
	(cs_aim_object FALSE (list_get (ai_actors hl_hologram) 0))
)

;The Hologram Scene(s)!
(script command_script hologram_ally_01
	(set holo_ally_01_go TRUE)
	(cs_switch so_grunt)
	(cs_aim_object TRUE (list_get (ai_actors hl_hologram) 0))
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE (list_get (ai_actors hl_hologram) 0))
	;(cs_shoot_point TRUE disposal_chamber/p6)
	(print "SPEC-OPS GRUNT: 'See! Heretic!'")
	(cs_play_line 0020)
	(sleep 60)
	
	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'Hold your fire! Hold your fire!'")
	(cs_play_line 0030)
	
	(cs_switch so_grunt)
	(cs_shoot FALSE)
	(set holo_ally_01_done TRUE)
)
(script command_script hologram_ally_02
	(set holo_ally_02_go TRUE)
	(cs_switch heretic_leader)
	(cs_face_player TRUE)
	(print "HERETIC LEADER: 'I wondered who the Prophets would send to silence me. An Arbiter. I'm flattered.'")
	(cs_play_line 0040)
	(set holo_ally_02_done TRUE)
)

(script command_script hologram_ally_03
	(set holo_ally_03_go TRUE)
	(cs_switch commander)
	(cs_start_approach drone_spawn 2 20 20) 
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(print "SPEC-OPS COMMANDER: 'He's using a holo-drone. He must be close!'")
	(cs_play_line 0050)
	(sleep 30)
	(print "SPEC-OPS COMMANDER: 'Come out. So we may kill you.'")
	(cs_play_line 0060)
	(cs_approach_stop)

	(cs_switch heretic_leader)
	(cs_face_object TRUE (list_get (ai_actors disposal_commander) 0))
	(print "HERETIC LEADER: 'Get in line.'")
	(cs_play_line 0070)

;	(sleep (ai_play_line_on_object holo_boy 0070))
	
	(cs_switch commander)
	(set holo_ally_03_done TRUE)
)
(script command_script hologram_ally_04
	(cs_switch so_elite)
	(print "SPEC-OPS ELITE: 'Leader...'")
	(cs_play_line 0080)

	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'Stand firm...the Flood is upon us.'")
	(cs_play_line 0090)
)

(script dormant revive_aware
	(sleep_until (> (ai_nonswarm_count disposal_infection) 0))
	(sound_impulse_start sound\dialog\combat\elite_loose\02_danger\warn_fldreanimate (list_get (ai_actors allies_elites_03a) 0) 1)
	(print "ally warns about reanimation")
)

;Ally reaction after combat finished
(script command_script disposal_after_react
	(cs_switch ally)
	(print "SPEC-OPS ELITE: 'Heretic fools! What have they done?!'")
	(cs_play_line 0640)
)

;The spec-ops commander is a pussy
(script command_script disposal_after_commander
	(cs_switch commander)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_go_to disposal_chamber/doorman)
	(cs_aim_player TRUE)
	(print "SPEC-OPS COMMANDER: 'Go, Arbiter! I'll follow when our reinforcements arrive!'")
	(cs_play_line 1500)
	(cs_aim_player FALSE)
	(cs_enable_dialogue TRUE)
	(sleep_until
		(begin
			(sleep_until (= (volume_test_objects vol_soc_post (ai_actors disposal_commander)) FALSE))
			(cs_start_to disposal_chamber/doorman)
			FALSE
		)
	)
)

(script dormant spec_ops_reborn
	(sleep_until
		(begin
			(sleep_until (= (volume_test_objects vol_soc_reborn (ai_actors disposal_commander)) TRUE))
			(effect_new_on_object_marker "effects\gameplay\coop_teleport" (list_get (ai_actors disposal_commander) 0) "")
			(sleep 30)
			(object_teleport (list_get (ai_actors disposal_commander) 0) soc_reborn)
			(= (structure_bsp_index) 0)
		)
	)
	(ai_erase disposal_commander)
)

;Fakes reanimation of the corpses by infection forms
(script static void disposal_infection_spawn
	(sleep_until (< (ai_swarm_count disposal_infection) 20) 30 300)
	(if (< (ai_swarm_count disposal_infection) 20)
		(ai_place disposal_infection_02 1)
	)

	(sleep_until (< (ai_swarm_count disposal_infection) 20) 30 300)
	(if (< (ai_swarm_count disposal_infection) 20)
		(ai_place disposal_infection_02 1)
	)

	(sleep_until (< (ai_swarm_count disposal_infection) 15) 30 300)
	(if (< (ai_swarm_count disposal_infection) 20)
		(ai_place disposal_infection_01 1)
	)

	(sleep_until (< (ai_swarm_count disposal_infection) 15) 30 300)
	(if (< (ai_swarm_count disposal_infection) 20)
		(ai_place disposal_infection_01 1)
	)
	
	(sleep_until (< (ai_swarm_count disposal_infection) 10) 30 300)
	(if (< (ai_swarm_count disposal_infection) 20)
		(ai_place disposal_infection_02 1)
	)

	(sleep_until (< (ai_swarm_count disposal_infection) 10) 30 300)
	(if (< (ai_swarm_count disposal_infection) 20)
		(ai_place disposal_infection_02 1)
	)

	(sleep_until (< (ai_swarm_count disposal_infection) 5) 30 300)
	(if (< (ai_swarm_count disposal_infection) 20)
		(ai_place disposal_infection_01 1)
	)

	(sleep_until (< (ai_swarm_count disposal_infection) 5) 30 300)
	(if (< (ai_swarm_count disposal_infection) 20)
		(ai_place disposal_infection_01 1)
	)
)

(script dormant holo_cannot_die
	(sleep_until (< (object_get_shield holo_boy) 1) 1)
	(object_set_shield_stun_infinite holo_boy)
	(object_set_shield holo_boy 0)
	(object_cannot_take_damage holo_boy)
)

;Overall script for the disposal chamber
(script dormant disposal_chamber_start
	(data_mine_set_mission_segment "04b_2_disposal_chamber")
	(game_save)
	(ai_renew all_allies)
	(wake juggernaut_abort)
	(wake music_04b_01_start)
		
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_disposal_bottom (players)) TRUE)
			(> (player_count) 0)
		)
	)
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_disposal_all (ai_actors all_allies)) TRUE)
			(> (player_count) 0)
		)
	30 300)
	(device_set_position disposal_entry_int 0)
	(ai_set_active_camo all_allies FALSE)
	(sleep 30)
	(sleep_until 
		(OR
			(ai_scene mess_react_01_scene disposal_ally_comment_01 allies_elites)
			(= (ai_living_count allies_elites) 0)
		)
	30 150)
	(sleep 5)
	(if (= mess_react_01_go TRUE)
		(sleep_until 
			(OR
				(= mess_react_01_done TRUE)
				(= (ai_living_count allies_elites) 0)
			)
		30 150)
	)
	(sleep 30)

	(sleep_until 
		(OR
			(ai_scene mess_react_02_scene disposal_ally_comment_02 all_allies)
			(< (ai_living_count allies_grunts_03) 2)
		)
	30 150)
	(sleep 90)

	;(ai_place holo_drone)
	;(ai_disregard (ai_actors holo_drone) TRUE)
	(ai_disregard (ai_actors all_allies) TRUE)
	;(object_cannot_take_damage (ai_actors holo_drone))
	;(cs_run_command_script holo_drone holo_drone_arrives)

	(device_set_position tennis_ball 1)
	(sleep 60)
	(effect_new_on_object_marker "effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_activate" tennis_ball "")
	(sleep_until (= (device_get_position tennis_ball) 1) 30 450)
	;(object_create holo_boy)
	;(wake holo_cannot_die)

	;(sleep_until (= holo_drone_arrived TRUE) 30 450)
	;(ai_erase holo_drone)
;	(effect_new_on_object_marker "effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_death" (list_get (ai_actors hl_hologram) 0) "")
	(effect_new_on_object_marker "effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_holo_on_cinematic" tennis_ball "light")
	(ai_place hl_hologram)
	(unit_impervious (ai_actors hl_hologram) TRUE)
	(ai_cannot_die hl_hologram TRUE)
	(cs_run_command_script hl_hologram forever_pause)
	(ai_disregard (ai_actors all_allies) TRUE)
	(ai_disregard (ai_actors hl_hologram) TRUE)
	(object_destroy tennis_ball)
	
;9/12	
	(object_dynamic_simulation_disable (list_get (ai_actors hl_hologram) 0) TRUE)
;	(object_cannot_take_damage (ai_actors hl_hologram))

	(cs_run_command_script all_allies hologram_face)
	(sleep_until 
		(OR 
			(ai_scene holo_grunt_react_scene hologram_ally_01 all_allies)
			(= (ai_living_count allies_grunts_03) 0)
			(= (ai_living_count disposal_commander) 0)
		)
	30 150)
	(sleep 5)
	(if (= holo_ally_01_go TRUE)
		(sleep_until 
			(OR
				(= holo_ally_01_done TRUE)
				(= (ai_living_count allies_grunts_03) 0)
				(= (ai_living_count disposal_commander) 0)
			)
		30 300)
	)
	
	(sleep_until
		(OR
			(ai_scene holo_main_hl_scene hologram_ally_02 hl_hologram)
			(= (ai_living_count hl_hologram) 0)
		)
	30 150)
	(sleep 5)
	(if (= holo_ally_02_go TRUE)
		(sleep_until 
			(OR
				(= holo_ally_02_done TRUE)
				(= (ai_living_count hl_hologram) 0)
			)
		30 300)
	)

	;(sleep (ai_play_line_on_object holo_boy 0040))

	(sleep_until
		(OR
			(ai_scene holo_main_react_scene hologram_ally_03 disposal_commander hl_hologram)
			(= (ai_living_count disposal_commander) 0)
			(= (ai_living_count hl_hologram) 0)
		)
	30 150)
	(sleep 5)
	(if (= holo_ally_03_go TRUE)
		(sleep_until 
			(OR
				(= holo_ally_03_done TRUE)
				(= (ai_living_count disposal_commander) 0)
				;(= (ai_living_count hl_hologram) 0)
			)
		30 450)
	)
	
	(unit_doesnt_drop_items (ai_actors hl_hologram))
	(ai_cannot_die hl_hologram FALSE)
	(ai_kill_silent hl_hologram)	
	(ai_disregard (ai_actors all_allies) FALSE)
	
	;(object_destroy holo_boy)
;	(object_create tennis_ball_crate)
	
	(game_save)
	(sleep 120)
	
	(ai_place disposal_infection_01 1)
	(sleep 30)
	(ai_place disposal_infection_01 1)
	(sleep 30)
	(ai_place disposal_infection_01 1)
	(sleep 30)
	(ai_place disposal_infection_01 1)

	(sleep_until 
		(OR
			(ai_scene holo_after_scene hologram_ally_04 all_allies)
			(= (ai_living_count disposal_commander) 0)
			(= (ai_living_count allies_elites) 0)
		)
	30 150)
	(wake revive_aware)
	(disposal_infection_spawn)

	(sleep_until 
		(AND 
			(< (ai_swarm_count disposal_infection) 30) 
			(= (ai_nonswarm_count disposal_infection) 0)
		)
	30 8000)
	(device_operates_automatically_set disposal_exit TRUE)
	(sleep_until 
		(OR
			(ai_scene disposal_post_scene disposal_after_react all_allies)
			(= (ai_living_count allies_elites) 0)
		)
	30 150)
	(sleep 150)
	
	(sleep_until (ai_scene disposal_comm_pussy_scene disposal_after_commander disposal_commander) 30 300)
	(wake spec_ops_reborn)
	(sleep 30)
	(game_save)
)


;-------------------------------------------------------------------------------
;Specimen Storage

;Dialogue responding to the Flood infesting this place
(script command_script silo_ally_comment
	(cs_switch ally)
	(print "SPEC-OPS ELITE: 'This place...it is filled with the Parasite!'")
	(cs_play_line 0650)
	(sleep 30)
	(print "SPEC-OPS ELITE: 'Not even Heretics would have come here had they known this!'")
	(cs_play_line 0660)
)

;Spec-ops commander whines about continuing
(script command_script silo_commander_whine
	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'I do not wish to stay here any longer than we have to, Arbiter!'")
	(cs_play_line 1230)
)
(script dormant silo_commander_reminder
	(sleep_until 
		(OR
			(= (volume_test_objects vol_leaving_silo (players)) TRUE)
			(= (ai_nonswarm_count silo_flood) 0)
		)
	)
	(if 
		(AND
			(= (volume_test_objects vol_leaving_silo (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(sleep_until (= (volume_test_objects vol_leaving_silo (players)) TRUE) 30 100)
				(if 
					(AND
						(= (volume_test_objects vol_leaving_silo (players)) FALSE)
						(> (player_count) 0)
					)
						(ai_scene silo_commander_scene silo_commander_whine all_allies)
				)
			)
	)
)

;Kills anything that falls into it
(global boolean silo_killer_power TRUE)
(script dormant silo_killer
	(sleep_until
		(begin
			(object_destroy (list_get (volume_return_objects kill_silo_pit) 0))
			(sleep 15)
			(= silo_killer_power FALSE)
		)
	)
)

;Scripts for controlling movement of elevator
(script static void silo_crane_01
	(device_set_overlay_track elev_silo crane_left)
	(device_animate_overlay elev_silo 1 30 1 1)
	(sleep 360)
	(object_destroy stop_01)
	(object_create_anew dummy_can)
	(objects_attach elev_silo can_entry dummy_can can_top)
	(sleep 285)
	(object_destroy dummy_can)
	(sleep 270)
)
(script static void silo_crane_02
	(device_set_overlay_track elev_silo crane_right)
	(device_animate_overlay elev_silo 1 30 1 1)
	(sleep 360)
	(object_destroy stop_02)
	(object_create_anew dummy_can)
	(objects_attach elev_silo can_entry dummy_can can_top)
	(sleep 285)
	(object_destroy dummy_can)
	(sleep 270)
)
(script static void silo_crane_03
	(device_set_overlay_track elev_silo crane_right)
	(device_animate_overlay elev_silo 1 30 1 1)
	(sleep 360)
	(object_destroy stop_03)
	(object_create_anew dummy_can)
	(objects_attach elev_silo can_entry dummy_can can_top)
	(sleep 285)
	(object_destroy dummy_can)
	(sleep 270)
)
(script static void silo_crane_04
	(device_set_overlay_track elev_silo crane_center)
	(device_animate_overlay elev_silo 1 18 1 1)
	(sleep 195)
	(object_destroy stop_04)
	(object_create_anew dummy_can)
	(objects_attach elev_silo can_entry dummy_can can_top)
	(sleep 255)
	(object_destroy dummy_can)
	(sleep 60)
)
(script static void silo_crane_05
	(device_set_overlay_track elev_silo crane_left)
	(device_animate_overlay elev_silo 1 30 1 1)
	(sleep 360)
	(object_destroy stop_05)
	(object_create_anew dummy_can)
	(objects_attach elev_silo can_entry dummy_can can_top)
	(sleep 285)
	(object_destroy dummy_can)
	(sleep 270)
)
(script static void silo_crane_06
	(device_set_overlay_track elev_silo crane_center)
	(device_animate_overlay elev_silo 1 18 1 1)
	(sleep 195)
	(object_destroy stop_06)
	(object_create_anew dummy_can)
	(objects_attach elev_silo can_entry dummy_can can_top)
	(sleep 255)
	(object_destroy dummy_can)
	(sleep 60)
)

(script static void silo_down_200
	(device_set_position_track elev_silo down_200 0)
	(device_animate_position elev_silo 1 5 1 1 FALSE)
)
(script static void silo_down_400
	(device_set_position_track elev_silo down_400 0)
	(device_animate_position elev_silo 1 10 1 1 FALSE)
)
(script static void silo_down_600
	(device_set_position_track elev_silo down_600 0)
	(device_animate_position elev_silo 1 15 1 1 FALSE)
)
(script static void silo_down_800
	(device_set_position_track elev_silo down_800 0)
	(device_animate_position elev_silo 1 20 1 1 FALSE)
)
(script static void silo_rot_90_plus
	(device_set_position_track elev_silo rot_90_clockwise 0)
	(device_animate_position elev_silo 1 5 1 1 FALSE)
)
(script static void silo_rot_90_minus
	(device_set_position_track elev_silo rot_90_counterclockwise 0)
	(device_animate_position elev_silo 1 5 1 1 FALSE)
)
(script static void silo_rot_180_plus
	(device_set_position_track elev_silo rot_180_clockwise 0)
	(device_animate_position elev_silo 1 10 1 1 FALSE)
)
(script static void silo_rot_180_minus
	(device_set_position_track elev_silo rot_180_counterclockwise 0)
	(device_animate_position elev_silo 1 10 1 1 FALSE)
)
(script static void silo_tray01
	(objects_attach elev_silo tray01 tray01 can_exit)
	(object_create can01)
	(objects_attach tray01 can_exit can01 can_base)
	(device_set_position tray01 1)
	(sleep_until (= (device_get_position tray01) 1) 30 900)
	(objects_detach tray01 can01)
	(device_set_position_immediate tray01 0)
	(object_destroy tray01)
)
(script static void silo_tray02
	(objects_attach elev_silo tray02 tray02 can_exit)
	(object_create can02)
	(objects_attach tray02 can_exit can02 can_base)
	(device_set_position tray02 1)
	(sleep_until (= (device_get_position tray02) 1) 30 300)
	(objects_detach tray02 can02)
	(device_set_position_immediate tray02 0)
	(object_destroy tray02)
)
(script static void silo_tray03
	(objects_attach elev_silo tray03 tray03 can_exit)
	(object_create can03)
	(objects_attach tray03 can_exit can03 can_base)
	(device_set_position tray03 1)
	(sleep_until (= (device_get_position tray03) 1) 30 300)
	(objects_detach tray03 can03)
	(device_set_position_immediate tray03 0)
	(object_destroy tray03)
)
(script static void silo_tray04
	(objects_attach elev_silo tray04 tray04 can_exit)
	(object_create can04)
	(objects_attach tray04 can_exit can04 can_base)
	(device_set_position tray04 1)
	(sleep_until (= (device_get_position tray04) 1) 30 300)
	(objects_detach tray04 can04)
	(device_set_position_immediate tray04 0)
	(object_destroy tray04)
)
(script static void silo_tray05
	(objects_attach elev_silo tray05 tray05 can_exit)
	(object_create can05)
	(objects_attach tray05 can_exit can05 can_base)
	(device_set_position tray05 1)
	(sleep_until (= (device_get_position tray05) 1) 30 300)
	(objects_detach tray05 can05)
	(device_set_position_immediate tray05 0)
	(object_destroy tray05)
)
(script static void silo_tray06
	(objects_attach elev_silo tray06 tray06 can_exit)
	(object_create can06)
	(objects_attach tray06 can_exit can06 can_base)
	(device_set_position tray06 1)
	(sleep_until (= (device_get_position tray06) 1) 30 300)
	(objects_detach tray06 can06)
	(device_set_position_immediate tray06 0)
	(object_destroy tray06)
)

;Makes the covers invincible
(script dormant silo_covers_invincible
	(object_cannot_take_damage cap_01_1)
	(object_cannot_take_damage cap_01_2)
	(object_cannot_take_damage cap_01_3)
	(object_cannot_take_damage cap_01_4)
	(object_cannot_take_damage cap_01_5)
	(object_cannot_take_damage cap_01_6)
	(object_cannot_take_damage cap_01_7)
	(object_cannot_take_damage cap_01_8)
	(object_cannot_take_damage cap_01_9)
	(object_cannot_take_damage cap_01_10)
	(object_cannot_take_damage cap_01_11)
	(object_cannot_take_damage cap_01_12)
	(object_cannot_take_damage cap_02_1)
	(object_cannot_take_damage cap_02_2)
	(object_cannot_take_damage cap_02_3)
	(object_cannot_take_damage cap_02_4)
	(object_cannot_take_damage cap_02_5)
	(object_cannot_take_damage cap_02_6)
	(object_cannot_take_damage cap_02_7)
	(object_cannot_take_damage cap_02_8)
	(object_cannot_take_damage cap_02_9)
	(object_cannot_take_damage cap_02_10)
	(object_cannot_take_damage cap_02_11)
	(object_cannot_take_damage cap_03_1)
	(object_cannot_take_damage cap_03_2)
	(object_cannot_take_damage cap_03_3)
	(object_cannot_take_damage cap_03_4)
	(object_cannot_take_damage cap_03_5)
	(object_cannot_take_damage cap_03_6)
	(object_cannot_take_damage cap_03_7)
	(object_cannot_take_damage cap_03_8)
	(object_cannot_take_damage cap_04_1)
	(object_cannot_take_damage cap_04_2)
	(object_cannot_take_damage cap_04_3)
	(object_cannot_take_damage cap_04_4)
	(object_cannot_take_damage cap_04_5)
	(object_cannot_take_damage cap_04_6)
	(object_cannot_take_damage cap_04_7)
	(object_cannot_take_damage cap_04_8)
	(object_cannot_take_damage cap_04_9)
	(object_cannot_take_damage cap_04_10)
	(object_cannot_take_damage cap_04_11)
	(object_cannot_take_damage cap_04_12)
)

;Tells when elevator is almost to the bottom
(global boolean silo_almost_there FALSE)

;Spawn count
(global short silo_sentinels_total 0)

;Keeps spawning sentinels
(script dormant silo_sentinel_spawner
	(sleep_until
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_living_count silo_sentinels_all) 2)
						(< silo_sentinels_total 4)
					)
					(begin
						(ai_place silo_sentinels_resupply/1)
						(set silo_sentinels_total (+ silo_sentinels_total 1))
					)
				)
				(if 
					(AND
						(< (ai_living_count silo_sentinels_all) 2)
						(< silo_sentinels_total 4)
					)
					(begin
						(ai_place silo_sentinels_resupply/2)
						(set silo_sentinels_total (+ silo_sentinels_total 1))
					)
				)
			)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_leaving_silo (players)) TRUE)
					(< (ai_living_count silo_sentinels_all) 2)
					(> silo_sentinels_total 3)
				)
			)	
			(> silo_sentinels_total 3)
		)
	30 4000)
	(sleep_until (= silo_sentinels_total 0))
	(sleep_until
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_living_count silo_sentinels_all) 2)
						(< silo_sentinels_total 4)
					)
					(begin
						(ai_place silo_sentinels_resupply/5)
						(set silo_sentinels_total (+ silo_sentinels_total 1))
					)
				)
				(if 
					(AND
						(< (ai_living_count silo_sentinels_all) 2)
						(< silo_sentinels_total 4)
					)
					(begin
						(ai_place silo_sentinels_resupply/6)
						(set silo_sentinels_total (+ silo_sentinels_total 1))
					)
				)
			)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_leaving_silo (players)) TRUE)
					(< (ai_living_count silo_sentinels_all) 2)
					(> silo_sentinels_total 3)
				)
			)	
			(OR
				(= (volume_test_objects vol_leaving_silo (players)) TRUE)
				(> silo_sentinels_total 3)
			)
		)
	30 4000)
)

;Spawn count
(global short silo_flood_total 0)
(global boolean silo_try_save FALSE)

(script dormant silo_saving
	(sleep_until
		(begin
			(sleep_until (= silo_try_save TRUE))
			(sleep_until
				(AND
					(game_safe_to_save)
					(= (volume_test_objects_all vol_silo_save (players)) TRUE)
					(> (player_count) 0)
				)
			)
			(game_save_immediate)
			(set silo_try_save FALSE)
			(= (volume_test_objects vol_leaving_silo (players)) TRUE)
		)
	)
)

;Keeps spawning flood in silo until you leave it
(script dormant silo_flood_spawner
	(if (difficulty_legendary)
		(set silo_flood_total 2)
	)
	(if (difficulty_heroic)
		(set silo_flood_total 1)
	)
	(sleep_until 
		(begin
			(ai_place silo_climbers_01 1)
			(ai_place silo_climbers_02 1)
			(sleep (random_range 30 60))
			(ai_place silo_climbers_01 1)
			(ai_place silo_climbers_02 1)
			(if (difficulty_heroic)
				(begin
					(sleep (random_range 30 60))
					(begin_random
						(ai_place silo_climbers_01 (- 1 (ai_living_count silo_climbers_02)))
						(ai_place silo_climbers_02 (- 1 (ai_living_count silo_climbers_01)))
					)
				)
			)
			(if (difficulty_legendary)
				(begin
					(sleep (random_range 30 60))
					(begin_random
						(ai_place silo_climbers_01 1)
						(ai_place silo_climbers_02 1)
					)
				)
			)
			(garbage_collect_now)	
			(set silo_try_save TRUE)

			(sleep_until 
				(OR 
					(= (volume_test_objects vol_leaving_silo (players)) TRUE) 
					(<= (+ (ai_nonswarm_count silo_flood) (ai_nonswarm_count silo_infection)) silo_flood_total)
				)
			)	
			(OR
				(= (volume_test_objects vol_leaving_silo (players)) TRUE)
				(= silo_almost_there TRUE)
			)
		)
	)
)

;Moves the elevator and its associated parts
(script dormant elev_go

	(silo_crane_01)
	(silo_tray01)
	(sleep 30)
	
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_specimen_storage (players)) TRUE)
			(> (player_count) 0)
		)
	)
	(print "down 400")
	
	(wake silo_saving)
	(wake music_04b_02_stop)
	
	(silo_down_400)
	(sleep 300)
	;(wake silo_infection_rain_01)
	
	(silo_rot_90_plus)
	(sleep 150)
	
	(silo_crane_02)
	(silo_tray02)
	(sleep 30)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_specimen_storage (players)) TRUE)
			(> (player_count) 0)
		)
	30 300)
	(print "down 600")
	(silo_down_600)
	(sleep 450)
	;(sleep_forever silo_infection_rain_01)
	;(set silo_sentinels_total 10)
	;(set silo_flood_total 10)
	;(wake silo_infection_rain_02)
	
	(silo_rot_90_minus)
	(sleep 150)

	(silo_crane_03)
	(silo_tray03)
	(sleep 30)
	
	(data_mine_set_mission_segment "04b_4_silo_mid")
	(set silo_try_save TRUE)

	;(wake silo_infection_rain_02)
	;(set silo_flood_total 0)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_specimen_storage (players)) TRUE)
			(> (player_count) 0)
		)
	30 300)
	(print "down 200")

	(wake music_04b_01_stop)

	(silo_down_200)
	(sleep 150)
	(ai_place silo_sentinels_below 4)

	(silo_rot_90_plus)
	(sleep 150)

	(silo_crane_04)
	(silo_tray04)
	(sleep 30)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_specimen_storage (players)) TRUE)
			(> (player_count) 0)
		)
	30 300)
	(print "down 800 - kill disabled")
	(kill_volume_disable kill_silo_toggle)
		
	(silo_down_800)
	(sleep 600)
	;(sleep_forever silo_infection_rain_02)
	;(wake silo_infection_rain_03)
	
	(silo_rot_180_minus)
	(sleep 300)
	
	(silo_crane_05)
	(silo_tray05)
	(sleep 30)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_specimen_storage (players)) TRUE)
			(> (player_count) 0)
		)
	30 300)
;	(set silo_sentinels_total 0)
	(print "down 400")
	(silo_down_400)
	(sleep 300)

	(silo_rot_90_plus)
	(sleep 150)

	(silo_crane_06)
	(silo_tray06)
	(sleep 30)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_specimen_storage (players)) TRUE)
			(> (player_count) 0)
		)
	30 300)
	(set silo_almost_there TRUE)
	(print "down 600")
	(silo_down_600)
	(sleep 300)
	;(sleep_forever silo_infection_rain_03)
	;(wake silo_infection_rain_04)
;	(set silo_almost_there TRUE)
	(sleep 150)
)

;Keeps spawning flood in hall until you enter it
(script dormant silo_hall_flood_spawner
	(ai_place silo_flood_halls 2)
	(sleep_until 
		(OR
			(= (volume_test_objects vol_leaving_silo (players)) TRUE)
			(= (ai_nonswarm_count silo_flood_halls) 0)
		)
	)
	(sleep_until (= (volume_test_objects vol_leaving_silo (players)) TRUE) 30 210)
	(if (= (volume_test_objects vol_leaving_silo (players)) TRUE)
		(sleep_forever)
	)
	(if 
		(AND
			(= (volume_test_objects vol_leaving_silo (players)) FALSE)
			(> (player_count) 0)
		)
			(ai_place silo_flood_halls 2)
	)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_leaving_silo (players)) TRUE)
			(= (ai_nonswarm_count silo_flood_halls) 0)
		)
	)
	(sleep_until (= (volume_test_objects vol_leaving_silo (players)) TRUE) 30 210)
	(if (= (volume_test_objects vol_leaving_silo (players)) TRUE)
		(sleep_forever)
	)

	(sleep_until 
		(begin
			(if 
				(AND
					(= (volume_test_objects vol_leaving_silo (players)) FALSE)
					(> (player_count) 0)
					(< (ai_living_count silo_flood_halls) 1)
				)	
					(ai_place silo_flood_halls 1)
			)
			(sleep_until (= (volume_test_objects vol_leaving_silo (players)) TRUE) 30 210)
			(sleep_until 
				(OR 
					(= (volume_test_objects vol_leaving_silo (players)) TRUE) 
					(< (ai_living_count silo_flood_halls) 1)
					(> (ai_spawn_count silo_flood_halls) 7)
				)
			)	
			(OR
				(= (volume_test_objects vol_leaving_silo (players)) TRUE)
				(> (ai_spawn_count silo_flood_halls) 7)
			)
		)
	)
)

;Overall script for the specimen storage chamber
(script dormant silo_start
	(sleep_until (= (volume_test_objects vol_silo_enter (players)) TRUE))
	(ai_disposable disposal_flood TRUE)
	(ai_disposable disposal_infection TRUE)
	(data_mine_set_mission_segment "04b_3_silo_start")
	(game_save)
	
	(kill_volume_enable kill_silo_toggle)

	(ai_renew all_allies)
	(ai_set_orders arm02_allies allies_silo)
	(ai_place silo_sentinels_initial 2)
	(ai_place silo_flood_initial 4)
	(wake silo_killer)
	
	(wake music_04b_02_start)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_specimen_storage (players)) TRUE)
			(> (player_count) 0)
		)
	)
	(wake elev_go)
	(wake silo_covers_invincible)
	(wake silo_flood_spawner)
	(wake silo_sentinel_spawner)
	(ai_set_orders arm02_allies allies_silo_lift)

	(sleep_until 
		(AND
			(= (ai_nonswarm_count silo_flood_initial) 0)
			(= (ai_nonswarm_count silo_sentinels_initial) 0)
		)
	30 4000)
	(ai_scene silo_ally_scene silo_ally_comment all_allies)

	(sleep_until 
		(OR
			(= silo_almost_there TRUE)
			(= (volume_test_objects vol_leaving_silo (players)) TRUE)
		)
	)
	(data_mine_set_mission_segment "04b_5_silo_end")
	(set silo_try_save TRUE)
	(wake silo_hall_flood_spawner)
;	(ai_place silo_heretics 2)
	(ai_set_orders silo_flood silo_all)
	(ai_place silo_sentinels_below 3)
	
	;(sleep_until (= (device_get_position elev_silo) 1))
	;(wake silo_commander_reminder)
)


;-------------------------------------------------------------------------------
;Corridor to Flood Lab

;Allies commenting on bodies
(script command_script halls2lab_ally_comment
	(cs_switch ally)
	(print "SPEC-OPS ELITE: 'We should have brought weapons to burn these bodies.'")
	(cs_play_line 1240)
	(sleep 30)
	(print "SPEC-OPS ELITE: 'Every one is a potential vessel for the Flood!'")
	(cs_play_line 1250)
)

;Overall script for the halls leading to the lab
(script dormant to_flood_lab
	(sleep_until (= (volume_test_objects vol_hall_to_lab (players)) TRUE))
	(ai_disposable silo_flood TRUE)
	(ai_disposable silo_infection TRUE)
	(ai_disposable silo_sentinels_all TRUE)
	(data_mine_set_mission_segment "04b_6_hall_to_lab")
	(game_save_no_timeout)
	(ai_renew all_allies)
	(ai_set_orders arm02_allies allies_lab_upper)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_hall_to_lab (ai_actors allies_elites)) TRUE)
			(= (ai_living_count allies_elites) 0)
		)
	)
	(ai_scene halls2lab_scene halls2lab_ally_comment all_allies)
)


;-------------------------------------------------------------------------------
;Flood Lab

;ice cream!!!
(script dormant famine_flavor
	(sleep_until 
		(OR
			(= (volume_test_objects vol_famine_01 (players)) TRUE)
			(= (volume_test_objects vol_famine_02 (players)) TRUE)
		)
	)
	(object_create famine)
	(ai_place famine_cf)
	(cs_run_command_script famine_cf forever_pause)
	(custom_animation_loop (unit (list_get (ai_actors famine_cf) 0)) objects\characters\floodcombat_elite\floodcombat_elite "combat:thrash_back:var0" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors famine_cf) 1)) objects\characters\floodcombat_elite\floodcombat_elite "combat:thrash_back:var1" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors famine_cf) 2)) objects\characters\floodcombat_elite\floodcombat_elite "combat:thrash_front:var0" TRUE)
	(custom_animation_loop (unit (list_get (ai_actors famine_cf) 3)) objects\characters\floodcombat_elite\floodcombat_elite "combat:thrash_front:var1" TRUE)

	(sleep_until 
		(OR
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\head_sp.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\head_sp.weapon")
		)
	)
	(ice_cream_flavor_stock 4)
)

(script command_script airlock_commander
	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'Bring the Phantoms close to the mine! We are not leaving until the leader of these heretics is dead!'")
	(cs_play_line 0110)
)

(script dormant airlock_commander_talk
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "PHANTOM PILOT: 'Leader! The storm is about to hit! We cannot maintain our position!'")
	(sleep (ai_play_line_on_object NONE 0100))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0100_scl))
	(print "SPEC-OPS COMMANDER: 'Bring the Phantoms close to the mine! We are not leaving until the leader of these heretics is dead!'")
	(sleep (ai_play_line_on_object NONE 0110))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0110_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Airlock BSP swap
(script dormant research_arm_bsp_swap
	(device_one_sided_set lab_exit_int TRUE)
	(device_set_never_appears_locked lab_exit_int TRUE)
	
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_research_arm_swap (ai_actors allies_elites)) TRUE)
			(> (player_count) 0)
		)
	30 300)
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_research_arm_swap (players)) TRUE)
			(> (player_count) 0)
			;(= (volume_test_objects_all vol_research_arm_swap (ai_actors disposal_commander)) TRUE)
			(<= (device_get_position lab_exit_int) 0)
		)
	)
	(device_operates_automatically_set lab_exit_int FALSE)
	(device_set_never_appears_locked lab_exit_int FALSE)

	(sleep_until
		(begin
			(if (= (volume_test_object trans_3,0 (list_get (ai_actors all_allies) 4)) FALSE)
				(object_destroy (list_get (ai_actors all_allies) 4))
			)
			(sleep 2)
			(if (= (volume_test_object trans_3,0 (list_get (ai_actors all_allies) 3)) FALSE)
				(object_destroy (list_get (ai_actors all_allies) 3))
			)
			(sleep 2)
			(if (= (volume_test_object trans_3,0 (list_get (ai_actors all_allies) 2)) FALSE)
				(object_destroy (list_get (ai_actors all_allies) 2))
			)
			(sleep 2)
			(if (= (volume_test_object trans_3,0 (list_get (ai_actors all_allies) 1)) FALSE)
				(object_destroy (list_get (ai_actors all_allies) 1))
			)
			(sleep 2)
			(if (= (volume_test_object trans_3,0 (list_get (ai_actors all_allies) 0)) FALSE)
				(object_destroy (list_get (ai_actors all_allies) 0))
			)
			(sleep 2)
			FALSE
		)
	30 60)

	(begin_random
		(begin
			(object_create gas01)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas02)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas03)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas04)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas05)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas06)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas07)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas08)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas09)
			(sleep (random_range 5 15))
		)
		(begin
			(object_create gas10)
			(sleep (random_range 5 15))
		)
	)
	(switch_bsp 0)
	(ai_set_orders all_allies allies_wraparound)
	
	(sleep_until (= (structure_bsp_index) 0))
	(wake airlock_commander_talk)
	(sleep 30)
	(begin_random
		(begin
			(object_destroy gas01)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas02)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas03)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas04)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas05)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas06)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas07)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas08)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas09)
			(sleep (random_range 5 15))
		)
		(begin
			(object_destroy gas10)
			(sleep (random_range 5 15))
		)
	)
	(sleep 30)
	(device_operates_automatically_set lab_exit_ext TRUE)
)

;Scripts carriers to blow barricades and heretics to retreat
(script dormant lab_barricades
	(sleep_until 
		(begin
			(begin_random
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_carriers_01/1)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_carriers_01/2)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_carriers_01/3)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_carriers_01/4)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_carriers_01/5)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_carriers_01/6)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_combatforms_01 1)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_combatforms_01 1)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_combatforms_01 1)
				)
			)
			(OR
				(< (ai_strength lab_heretics_01) .5)
				(= (volume_test_objects vol_lab_floor (players)) TRUE)
			)
		)
	)
;	(ai_set_orders lab_heretics_01 lab_heretic_stand_02)
;	(ai_set_orders lab_carriers_01 lab_barricade_breach_02)
	
	(sleep_until
		(begin
			(begin_random
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_carriers_02 1)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(ai_place lab_combatforms_02 1)
				)
			)
			(OR
				(= (ai_living_count lab_heretics_01) 0)
				(= (volume_test_objects vol_lab_floor (players)) TRUE)
			)
		)
	)
)

;Calling out heretics above
(script command_script lab_heretics_ally
	(cs_switch ally)
	(print "SPEC-OPS ELITE: 'Heretics!  Above!'")
	(cs_play_line 1270)
)
(script command_script lab_heretics_commander
	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'Heretics!  Above!'")
	(cs_play_line 1260)
)

;Calling out juggernaut
(script command_script lab_juggernaut_ally
	(cs_switch ally)
	(print "SPEC-OPS ELITE: 'It comes!  Prepare yourself, Arbiter!'")
	(cs_play_line 1290)
)
(script command_script lab_juggernaut_commander
	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'It comes!  Prepare yourself, Arbiter!'")
	(cs_play_line 1280)
)

;Juggernaut hint #1
(script command_script lab_jugg_hint1_ally
	(cs_switch ally)
	(print "SPEC-OPS ELITE: 'It shrugs off our every assault!  It must have a weak spot!'")
	(cs_play_line 1290)
)
(script command_script lab_jugg_hint1_commander
	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'It shrugs off our every assault!  It must have a weak spot!'")
	(cs_play_line 1280)
)

;Juggernaut hint #2
(script command_script lab_jugg_hint2_ally
	(cs_switch ally)
	(print "SPEC-OPS ELITE: 'The eye, Arbiter!  Aim for its eye!'")
	(cs_play_line 1290)
)
(script command_script lab_jugg_hint2_commander
	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'The eye, Arbiter!  Aim for its eye!'")
	(cs_play_line 1280)
)

(script command_script stay_shootin
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)

(script command_script lab_turret_man_R
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location lab_exit_turrets/r))
	(sleep_until (= (unit_in_vehicle (unit (ai_get_object ai_current_actor))) TRUE) 30 450)
	(if (= (unit_in_vehicle (unit (ai_get_object ai_current_actor))) TRUE)
		(begin
			(cs_set_behavior guard)
			(sleep_forever)
		)
	)
)
(script command_script lab_turret_man_L
	(cs_abort_on_damage TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location lab_exit_turrets/l))
	(sleep_until (= (unit_in_vehicle (unit (ai_get_object ai_current_actor))) TRUE) 30 450)
	(if (= (unit_in_vehicle (unit (ai_get_object ai_current_actor))) TRUE)
		(begin
			(cs_set_behavior guard)
			(sleep_forever)
		)
	)
)

(script dormant fuck_this_turret_shit
	(sleep 120)
	(ai_vehicle_enter lab_grunts_02 (ai_vehicle_get_from_starting_location lab_exit_turrets/r))
	(ai_vehicle_enter lab_grunts_02 (ai_vehicle_get_from_starting_location lab_exit_turrets/l))
)

(global short lab_flood_count 0)

(script dormant lab_wave_new_01
	(sleep_until
		(begin
			(if (< (ai_nonswarm_count lab_flood) 4)
				(begin
					(ai_place lab_carriers_02 1)
					(set lab_flood_count (+ lab_flood_count 1))
				)
			)
			(> lab_flood_count 5)
		)
	30 8000)
)
(script dormant lab_wave_new_02
	(sleep_until
		(begin
			(if (< (ai_nonswarm_count lab_flood) 4)
				(begin
					(ai_place lab_combatforms_02 1)
					(set lab_flood_count (+ lab_flood_count 1))
				)
			)
			FALSE
		)
	30 1800)
)

;Overall script for the lab
(script dormant flood_lab_start
	(sleep_until (= (volume_test_objects vol_lab_enter (players)) TRUE))
	(data_mine_set_mission_segment "04b_7_flood_lab_start")
	(game_save_no_timeout)
	
	(set silo_killer_power FALSE)

	(ai_place lab_heretics_01 1)
	(ai_place lab_turret_grunts_01 2)
	(ai_place lab_exit_turrets 2)
	(ai_place lab_carriers_01/init1)
	(ai_place lab_carriers_01/init2)
	(ai_place lab_carriers_01/init3)
;	(ai_place lab_carriers_01/init4)
	(wake lab_barricades)
	(if (difficulty_legendary)
		(wake famine_flavor)
	)
	
	(wake music_04b_03_start)
	
	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_lab_floor (players)) TRUE)
			(> (player_count) 0)
		)
	30 900)
	(if 
		(AND
			(= (volume_test_objects_all vol_lab_floor (players)) FALSE)
			(> (player_count) 0)
		)
			(begin_random
				(begin
					(ai_place lab_combatforms_02/r1)
					(sleep (random_range 5 45))
				)
				(begin
					(ai_place lab_combatforms_02/r2)
					(sleep (random_range 5 45))
				)
				(begin
					(ai_place lab_combatforms_02/r3)
					(sleep (random_range 5 45))
				)
				(begin
					(ai_place lab_combatforms_02/r4)
					(sleep (random_range 5 45))
				)
			)
	)

	(sleep_until 
		(AND
			(= (volume_test_objects_all vol_lab_floor (players)) TRUE)
			(> (player_count) 0)
		)
	)
	(game_save_no_timeout)
	(ai_set_orders arm02_allies allies_lab_lower)
	
	(sleep_until 
		(AND 
			(= (ai_nonswarm_count lab_flood) 0)
			(= (ai_living_count lab_heretics) 0) 
			(= (volume_test_objects_all vol_lab_floor (players)) TRUE)
			(> (player_count) 0)
		)
	30 8000)
	(data_mine_set_mission_segment "04b_8_flood_lab_mid_01")
	(game_save_no_timeout)
	(ai_place lab_heretics_above 3)
	(sleep 15)
	(ai_magically_see_object lab_heretics_above (player0))
	(ai_magically_see_object lab_heretics_above (player1))
	
	(sleep_until (= (objects_can_see_object (players) (list_get (ai_actors lab_heretics_above) 0) 60) TRUE) 30 450)
	(sleep_until
		(OR
			(= (ai_living_count allies_elites) 0)
			(ai_scene lab_heretic_ally_scene lab_heretics_ally all_allies)
		)
	30 300)

	(ai_place lab_combatforms_02/r2)
	(ai_place lab_carriers_02/r4)
	(ai_set_orders lab_flood lab_above)

	(sleep_until
		(begin
			(begin_random
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_combatforms_02/r1)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_combatforms_02/r2)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_combatforms_02/r3)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_combatforms_02/r4)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_combatforms_02/r5)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_carriers_02/r1)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_carriers_02/r2)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_carriers_02/r3)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_carriers_02/r4)
						(sleep (random_range 10 40))
					)
				)
				(if (< (ai_nonswarm_count lab_flood) 4)
					(begin
						(ai_place lab_carriers_02/r5)
						(sleep (random_range 10 40))
					)
				)
			)
			(OR
				(< (ai_living_count lab_heretics_above) 1)
				(AND
					(= (volume_test_objects_all vol_lab_floor (ai_actors lab_heretics_above)) TRUE)
					(> (player_count) 0)
				)
			)
		)
	30 4000)

	(game_save_no_timeout)
	(ai_set_orders lab_heretics_above lab_flood_all)
	(ai_set_orders lab_flood lab_flood_all)
	(ai_set_orders arm02_allies allies_lab_wagons)

;	(sleep_until
;		(OR
;			(= (ai_living_count lab_heretics_above) 0)
;			(ai_scene lab_jugg_ally_scene lab_juggernaut_ally all_allies)
;		)
;	30 300)
	
;	(sleep_until (< (ai_strength lab_juggernaut_above) .75))

	(sleep_until 
		(AND
			(< (ai_nonswarm_count lab_flood) 1) 
			(< (ai_living_count lab_heretics_above) 1)
		)
	30 2000)
	(game_save_no_timeout)
	
	(music_04b_03_start_alt)

	(set lab_flood_count 0)
	(wake lab_wave_new_02)	
	(sleep 1800)
	
	(sleep_until (< (ai_nonswarm_count lab_flood) 1) 30 3600)
	(sleep_until (= (ai_trigger_test "done_fighting" lab_flood) TRUE) 30 1800)	
	(data_mine_set_mission_segment "04b_9_flood_lab_mid_02")
	(game_save_no_timeout)

	(music_04b_03_stop_alt)

	(set lab_flood_count 0)
	(wake lab_wave_new_01)	
;	(sleep 1800)	
	
;	(sleep_until (< (ai_strength lab_juggernaut_above) .5))
;	(game_save)
;	(ai_place lab_infection_01 (- 5 (ai_nonswarm_count lab_flood)))
	
;	(sleep_until (< (ai_strength lab_juggernaut_above) .5))
;	(ai_place lab_combatforms_02 (- 4 (ai_nonswarm_count lab_combatforms_02)))

;	(sleep_until (< (ai_strength lab_juggernaut_above) .25))
;	(game_save)
;	(ai_place lab_carriers_02 (- 5 (ai_nonswarm_count lab_flood)))
	
;	(sleep_until (= (ai_living_count lab_juggernaut_above) 0))

;	(sleep_until (< (ai_nonswarm_count lab_flood) 1) 30 3600)
	(data_mine_set_mission_segment "04b_10_flood_lab_end")
;	(game_save)
	(sleep 90)
	(device_operates_automatically_set lab_exit_int TRUE)
	(ai_place lab_heretics_02 2)
	(ai_place lab_grunts_02 3)
;	(cs_run_command_script lab_grunts_02/r lab_turret_man_r)
;	(cs_run_command_script lab_grunts_02/l lab_turret_man_l)
	(ai_set_orders arm02_allies allies_lab_end)
	(wake fuck_this_turret_shit)
	
	(wake music_04b_03_stop)
	
	(sleep_until 
		(OR
			(= (ai_living_count lab_heretics) 0)
			(AND
				(= (volume_test_objects_all vol_research_arm_swap (players)) TRUE)
				(> (player_count) 0)
			)
		)
	)
	(game_save_no_timeout)
	(ai_set_orders all_allies allies_airlock)
	(wake research_arm_bsp_swap)
)	

;-------------------------------------------------------------------------------
;Bridge

(script dormant wind
	(sleep_until
		(begin
			(sleep_until
				(begin
					(sound_impulse_start sound\ambience\sound_scenery\gusty_wind\details\gusty_wind NONE 1)
					(sleep_until 
						(OR
							(= (volume_test_objects vol_control_enter (players)) TRUE)
							(= (structure_bsp_index) 2)
						)
					5 30)
					(player_effect_set_max_rotation (real_random_range .1 1) (real_random_range .1 1) 0)
					(player_effect_start (real_random_range .05 .2) (real_random_range .5 2))
					(player_effect_stop (real_random_range 3 5))
					(sleep_until 
						(OR
							(= (volume_test_objects vol_control_enter (players)) TRUE)
							(= (structure_bsp_index) 2)
						)
					5 (random_range 150 300))
					(OR
						(= (volume_test_objects vol_control_enter (players)) TRUE)
						(= (structure_bsp_index) 2)
					)
				)
			)
			(sleep_until 
				(OR
					(= (volume_test_objects vol_gusty (players)) TRUE)
					(= (structure_bsp_index) 2)
				)		
			5)
			(= (structure_bsp_index) 2)
		)
	)
)

;Phantom drops fresh allies
(script command_script bridge_phantom_arrives
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by airspace_bridge/ph0 5)
	(cs_vehicle_speed .5)
	(cs_fly_by airspace_bridge/ph1 2)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) TRUE)
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) "phantom_p_a03")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) "phantom_p_a02")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) "phantom_p_a01")
	(sleep 30)
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) "phantom_p_b01")
	(vehicle_unload (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) "phantom_p")

	(sleep_until (< (ai_living_count allied_phantom_02) 2))
	(sleep 60)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) FALSE)

	(cs_fly_by airspace_bridge/ph2 5)
	(cs_fly_by airspace_bridge/ph3 5)
	(cs_fly_by airspace_bridge/ph4 5)
	(cs_fly_to airspace_bridge/phx 2)
	(ai_erase allied_phantom_02)
)

;Loads and launches phantom
(script dormant bridge_phantom_go
	(ai_place allies_elites_04 (- 2 (ai_living_count allies_elites)))
	(ai_place allies_grunts_04 (- 2 (ai_living_count allies_grunts_03)))
	(ai_place allied_phantom_02)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) "phantom_p" (ai_actors allies_grunts_04))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) "phantom_p" (ai_actors allies_elites_04))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allied_phantom_02/pilot) TRUE)
	(cs_run_command_script allied_phantom_02/pilot bridge_phantom_arrives)
)

;Spec-ops commander talks about infestation
(script command_script bridge_commander_comment
	(cs_switch commander)
	(cs_start_approach_player 1 20 20)
	(print "SPEC-OPS COMMANDER: 'Arbiter, the Flood has spread throughout the station!'")
	(cs_play_line 0670)
	(print "SPEC-OPS COMMANDER: 'We don't have enough troops to manage such a large infestation!'")
	(cs_play_line 0680)
	(print "SPEC-OPS COMMANDER: 'Find the leader of these heretics! Kill him now!'")
	(cs_play_line 0672)
	(cs_approach_stop)
)

;Spec-ops commander reminds you to keep moving
(script command_script bridge_commander_reminder
	(cs_switch commander)
	(cs_start_approach_player 1 20 20)
	(print "SPEC-OPS COMMANDER: 'Onward! To the core of the station!'")
	(cs_play_line 1340)
	(cs_approach_stop)
)
(script dormant bridge_reminder
	(sleep_until (= (volume_test_objects vol_control_enter (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_control_enter (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "SPEC-OPS COMMANDER: 'Onward! To the core of the station!'")
				(sleep (ai_play_line_on_object NONE 1340))
				;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1340_soc))
				;(ai_scene bridge_comm_remind_scene bridge_commander_reminder disposal_commander)
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;To control spawning since you can go either way around the core
(global boolean bridge_final_gone FALSE)

;Spawn based on direction taken
(script dormant wraparound_right
	(sleep_until 
		(AND
			(= bridge_final_gone FALSE) 
			(= (volume_test_objects vol_wrap_right_01 (players)) TRUE)
		)
	)

;9/12

	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_heretics_R_02 2)
	)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_h_grunts_R_03 (- 4 (+ (ai_living_count bridge_h_grunts_init) (ai_living_count bridge_runners))))
	)

	(sleep_until 
		(AND
			(= bridge_final_gone FALSE) 
			(= (volume_test_objects vol_wrap_right_02 (players)) TRUE)
		)
	)
	(game_save)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_heretics_R_04 (- 2 (ai_living_count bridge_heretics_R_02)))
	)

	(sleep_until 
		(AND
			(= bridge_final_gone FALSE) 
			(= (volume_test_objects vol_wrap_right_03 (players)) TRUE)
		)
	)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_sentinels_R_05 3)
	)

	(sleep_until 
		(AND
			(= bridge_final_gone FALSE) 
			(= (volume_test_objects vol_wrap_final (players)) TRUE)
		)
	)
	(set bridge_final_gone TRUE)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_heretics_final (- 2 (+ (ai_living_count bridge_heretics_R_04) (ai_living_count bridge_heretics_L_04))))
	)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_h_grunts_final 2)
	)
)
(script dormant wraparound_left
	(sleep_until 
		(AND
			(= bridge_final_gone FALSE) 
			(= (volume_test_objects vol_wrap_left_01 (players)) TRUE)
		)
	)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_heretics_L_02 2)
	)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_h_grunts_L_03 (- 4 (+ (ai_living_count bridge_h_grunts_init) (ai_living_count bridge_runners))))
	)

	(sleep_until 
		(AND
			(= bridge_final_gone FALSE) 
			(= (volume_test_objects vol_wrap_left_02 (players)) TRUE)
		)
	)
	(game_save)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_heretics_L_04 (- 2 (ai_living_count bridge_heretics_L_02)))
	)
	
	(sleep_until 
		(AND
			(= bridge_final_gone FALSE) 
			(= (volume_test_objects vol_wrap_left_03 (players)) TRUE)
		)
	)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_sentinels_L_05 3)
	)

	(sleep_until 
		(AND 
			(= bridge_final_gone FALSE) 
			(= (volume_test_objects vol_wrap_final (players)) TRUE)
		)
	)
	(set bridge_final_gone TRUE)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_heretics_final (- 2 (+ (ai_living_count bridge_heretics_R_04) (ai_living_count bridge_heretics_L_04))))
	)
	(if (< (ai_nonswarm_count bridge_enemies) 8)
		(ai_place bridge_h_grunts_final 2)
	)
)

;Overall script for exterior bridge and wraparound
(script dormant bridge_start
	(data_mine_set_mission_segment "04b_11_wraparound")
	(ai_disposable lab_flood TRUE)
	(ai_disposable lab_heretics TRUE)
	(game_save)
	(sleep 60)

	(ai_place bridge_runners 2)
	(ai_place bridge_h_grunts_init 3)
	(ai_place bridge_infection 3)
	(ai_place bridge_combatforms 1)
	(ai_place bridge_carriers 2)
		
;	(sleep_until (= (volume_test_objects vol_on_bridge (players)) TRUE))
;	(ai_place bridge_strafer)
;	(cs_run_command_script bridge_strafer banshee_bridge_strafe)

	(device_operates_automatically_set control_room_ext TRUE)

	(sleep_until (= (volume_test_objects vol_on_bridge (players)) TRUE) 30 150)
	(game_save)
	
	(wake wraparound_right)
	(wake wraparound_left)
	(ai_renew all_allies)
	(wake bridge_phantom_go)
	(wake bridge_reminder)
	(wake wind)

	(sleep_until (> (ai_living_count allied_phantom_02) 1))
	(sleep_until (< (ai_living_count allied_phantom_02) 2))
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'Arbiter, the Flood has spread throughout the station!'")
	(sleep (ai_play_line_on_object NONE 0670))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0670_soc))
	(print "SPEC-OPS COMMANDER: 'We don't have enough troops to manage such a large infestation!'")
	(sleep (ai_play_line_on_object NONE 0671))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0671_soc))
	(print "SPEC-OPS COMMANDER: 'Find the leader of these heretics! Kill him now!'")
	(sleep (ai_play_line_on_object NONE 0672))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0672_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(game_save_no_timeout)
)


;-------------------------------------------------------------------------------
;Control Room

(script dormant hl_killer
	(sleep_until 
		(begin
			(if 
				(= (volume_test_object vol_hl_killer (player0)) TRUE)
					(unit_kill (unit (player0)))
			)
			(if 
				(= (volume_test_object vol_hl_killer (player1)) TRUE)
					(unit_kill (unit (player1)))
			)
			(= (structure_bsp_index) 2)
		)
	1)
)

;hologram toggle
(script dormant hologram_toggle
	(sleep_until
		(begin
			(sleep_until (<= (objects_distance_to_flag (players) mine_holo) 5))
			(object_create_anew gasmine_hologram)
;			(object_clear_all_function_variables gasmine_hologram)
			(object_set_function_variable gasmine_hologram "holo_power" 0 0)
			(object_set_function_variable gasmine_hologram "holo_power" 1 30)
			(sleep 30)
			(sleep_until (> (objects_distance_to_flag (players) mine_holo) 5))
;			(object_clear_all_function_variables gasmine_hologram)
			(object_set_function_variable gasmine_hologram "holo_power" 1 0)
			(object_set_function_variable gasmine_hologram "holo_power" 0 30)
			(sleep 30)
			(object_destroy gasmine_hologram)
			FALSE
		)
	)
)

;Spec-ops commander reminds you if you're lagging
(script dormant control_commander_reminder
	(sleep_until (> (device_get_position elev_control_up) 0) 30 3600)
	(if (<= (device_get_position elev_control_up) 0)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "SPEC-OPS COMMANDER: 'Make your way up to the cable, Arbiter.'")
			(sleep (ai_play_line_on_object NONE 1350))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1350_soc))
			(print "SPEC-OPS COMMANDER: 'There should be an elevator above you!'")
			(sleep (ai_play_line_on_object NONE 1360))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1360_soc))
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)

;Allies point out heretic leader retreating ahead of you
(script command_script control_grunt_comment
	(cs_switch grunt)
	(print "SPEC-OPS GRUNT: 'Heretic boss! You see? You see?'")
	(cs_play_line 0700)
)
(script command_script control_elite_comment
	(cs_switch elite)
	(print "SPEC-OPS ELITE: 'There! The Heretic leader!'")
	(cs_play_line 0680)
)

;Scripts heretic leader to run into shelter foyer and lower shield
(script command_script heretic_leader_holes_up
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_force_combat_status 4)
	(cs_go_to control_room/p0)
	(cs_face_player TRUE)
	(device_set_position_immediate shield 0)
;	(cs_enable_targeting TRUE)
;	(cs_enable_moving TRUE)
;	(cs_shoot TRUE)
	(sleep_forever)
)

;any surviving grunts bug out
(script command_script sog_bug_out_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_go_to bridge/p3)
)
(script command_script sog_bug_out_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_go_to bridge/p4)
)
(script command_script sog_bug_out_03
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_go_to bridge/p5)
)
(script command_script sog_bug_out_04
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_go_to bridge/p6)
)

;Spec-ops boys' parting dialogue
(global boolean comm_farewell_done FALSE)
(global boolean soe_farewell_done FALSE)
(script command_script commander_farewell
	(cs_switch commander)
	(print "SPEC-OPS COMMANDER: 'Warriors, return to the landing-zone! The Arbiter will continue upward, cut this station loose, and scare the heretic from his hole!'")
	(cs_play_line 0120)
	(set comm_farewell_done TRUE)
	
	(sleep_until 
		(OR
			(= soe_farewell_done TRUE)
			(< (ai_living_count control_elites_cinematic) 2)
		)
	)
	(sleep 30)
	(cs_start_approach_player 2 20 20)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(if 
		(OR 
			(unit_has_weapon (unit (player0)) "objects\weapons\melee\energy_blade\energy_blade.weapon") 
			(unit_has_weapon (unit (player1)) "objects\weapons\melee\energy_blade\energy_blade.weapon")
		)
			(begin
				(print "SPEC-OPS COMMANDER: 'Keep your blade handy - I doubt the cable can withstand its bite.'")
				(cs_play_line 0140)
			)
			(begin
				(print "SPEC-OPS COMMANDER: 'Take my blade - I doubt the cable can withstand its bite.'")
				(cs_play_line 0130)
				(sleep_until 
					(OR
						(unit_has_weapon (unit (player0)) "objects\weapons\melee\energy_blade\energy_blade.weapon") 
						(unit_has_weapon (unit (player1)) "objects\weapons\melee\energy_blade\energy_blade.weapon")
						(= (volume_test_objects vol_control_middle (players)) TRUE)
					)
				30 900)
			)
	)
)
(script command_script spec_op_farewell
	(cs_switch ally01)
	(sleep_until (= comm_farewell_done TRUE))
	(sleep 30)
	(print "SPEC-OPS ELITE: 'May our Lords guide your hand!'")
	(cs_play_line 0150)
	(cs_enable_moving TRUE)

	(cs_switch ally02)
	(sleep 30)
	(print "SPEC-OPS ELITE: 'We shall not forget your sacrifice!'")
	(cs_play_line 0160)
	(set soe_farewell_done TRUE)
)

(script command_script soe_bug_out_01
	(sleep_until (= comm_farewell_done TRUE))
	(sleep 30)
	(print "SPEC-OPS ELITE: 'May our Lords guide your hand!'")
	(cs_play_line 0150)
)
(script command_script soe_bug_out_02
	(sleep_until (= comm_farewell_done TRUE))
	(sleep 120)
	(print "SPEC-OPS ELITE: 'We shall not forget your sacrifice!'")
	(cs_play_line 0160)
	(sleep 15)
	(set soe_farewell_done TRUE)
)

;tells when phantom ready for loading
(global boolean bug_out_phantom_here FALSE)

;Flies in phantom to pick guys up
(script command_script control_bug_out_flight
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by airspace_bridge/ph1too)
	(cs_vehicle_speed .5)
	(cs_fly_by airspace_bridge/ph2too)
	(cs_fly_to_and_face airspace_bridge/ph3too airspace_bridge/ph4too)
	(set bug_out_phantom_here TRUE)
	(object_create phantom_vol)
	(sleep_until (< (ai_living_count all_allies) 1))
	(cs_pause 1)
	(object_destroy phantom_vol)
	(cs_fly_by airspace_bridge/ph4too)
	(cs_vehicle_speed 1)
	(cs_fly_to airspace_bridge/phxtoo)
	(ai_erase allied_phantom_03)
)

(script command_script bug_out_pussy
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to bridge/grav)
	(cs_jump 0 1)
	;(cs_pause 1)
	(sleep_until (= (volume_test_objects vol_gusty (ai_get_object ai_current_actor)) FALSE) 1)
	(object_set_scale (ai_get_object ai_current_actor) .1 15)
	(sleep 15) 
	(ai_erase ai_current_actor)
)

;Picks up commander and friends
(script dormant control_bug_out
	(ai_place allied_phantom_03)
	(cs_run_command_script allied_phantom_03 control_bug_out_flight)
	(sleep_until (= bug_out_phantom_here TRUE))
	(cs_queue_command_script control_commander_cinematic bug_out_pussy)
	(sleep_until (< (ai_living_count control_commander_cinematic) 1))
	(cs_run_command_script control_elites_cinematic/elite01 bug_out_pussy)
	(sleep_until (< (ai_living_count control_elites_cinematic) 2))
	(cs_run_command_script control_elites_cinematic/elite02 bug_out_pussy)
	(sleep_until (< (ai_living_count control_elites_cinematic) 1))
	(cs_run_command_script allies_grunts_03 bug_out_pussy)
	(sleep_until (< (ai_living_count allies_grunts_03) 1))
	(cs_run_command_script allies_grunts_04 bug_out_pussy)
	(sleep_until (< (ai_living_count allies_grunts_04) 1))
)

(script dormant control_flood_spawn
	(sleep_until
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_nonswarm_count control_flood) 6)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(= (volume_test_objects vol_control_perimeter (players)) FALSE)
						(> (player_count) 0)
					)
						(begin
							(ai_place control_flood_wave_02_combat 1)
							;(sleep_until (= (volume_test_objects vol_control_perimeter (players)) TRUE) 30 (random_range 60 120))
						)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_flood) 6)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(= (volume_test_objects vol_control_perimeter (players)) FALSE)
						(> (player_count) 0)
					)
						(begin
							(ai_place control_flood_wave_02_combat 1)
							;(sleep_until (= (volume_test_objects vol_control_perimeter (players)) TRUE) 30 (random_range 60 120))
						)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_flood) 6)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(= (volume_test_objects vol_control_perimeter (players)) FALSE)
						(> (player_count) 0)
					)
						(begin
							(ai_place control_flood_wave_02_carriers 1)
							;(sleep_until (= (volume_test_objects vol_control_perimeter (players)) TRUE) 30 (random_range 60 120))
						)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_flood) 6)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(= (volume_test_objects vol_control_perimeter (players)) FALSE)
						(> (player_count) 0)
					)
						(begin
							(ai_place control_flood_wave_03_combat 1)
							;(sleep_until (= (volume_test_objects vol_control_perimeter (players)) TRUE) 30 (random_range 60 120))
						)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_flood) 6)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(= (volume_test_objects vol_control_perimeter (players)) FALSE)
						(> (player_count) 0)
					)
						(begin
							(ai_place control_flood_wave_03_combat 1)
							;(sleep_until (= (volume_test_objects vol_control_perimeter (players)) TRUE) 30 (random_range 60 120))
						)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_flood) 6)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(= (volume_test_objects vol_control_perimeter (players)) FALSE)
						(> (player_count) 0)
					)
						(begin
							(ai_place control_flood_wave_03_carriers 1)
							;(sleep_until (= (volume_test_objects vol_control_perimeter (players)) TRUE) 30 (random_range 60 120))
						)
				)
			)
			(OR
				(= (volume_test_objects vol_control_perimeter (players)) TRUE)
				(> (ai_spawn_count control_flood) 10)
			)
		)
	)
)

;Overall script for control room the first time through
(script dormant control_room_start
	(sleep_until (= (volume_test_objects vol_control_enter (players)) TRUE))
	(wake hl_killer)
	(ai_disposable bridge_flood TRUE)
	(ai_disposable bridge_heretics TRUE)
	(ai_disposable bridge_sentinels TRUE)
	(data_mine_set_mission_segment "04b_12_control_room_01")
	(game_save)

	(ai_migrate allies_elites allies_elites_04)
	(device_set_power control_up_switch_01 0)
	(device_set_position_immediate elev_control_up .041)
	(device_set_position_immediate shield 1)
	(device_set_position_immediate control_shield_door 1)
	(ai_renew all_allies)
	(ai_set_orders core_allies allies_control)

	(ai_place heretic_leader_control)
	(ai_cannot_die heretic_leader_control TRUE)
	(unit_impervious (ai_actors heretic_leader_control) TRUE)
	(ai_set_blind heretic_leader_control TRUE)
	(ai_set_deaf heretic_leader_control TRUE)
	(cs_run_command_script heretic_leader_control heretic_leader_holes_up)
	(ai_disregard (ai_actors heretic_leader_control) TRUE)

	(ai_place control_flood_wave_01_combat 4)
	(ai_place control_sentinels_wave_01 3)

	(wake music_04b_04_start)
	(wake hologram_toggle)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_control_enter (ai_actors allies_grunts_03)) TRUE)
			(= (volume_test_objects vol_control_enter (ai_actors allies_grunts_04)) TRUE)
			(= (volume_test_objects vol_control_enter (ai_actors allies_elites_04)) TRUE)
		)
	30 300)
	
	(sleep_until
		(OR
			(ai_scene control_grunt_scene control_grunt_comment all_allies)
			(ai_scene control_elite_scene control_elite_comment all_allies)
		)
	30 300)

	(sleep_until 
		(AND 
			(= (ai_nonswarm_count control_flood_wave_01_combat) 0) 
			(= (ai_living_count control_sentinels_wave_01) 0)
		)
	)
	(sleep 60)

	(wake music_04b_04_start_alt)

	(cinematic_fade_to_white)

	;(device_set_position_immediate elev_control_up 0)
	(ai_erase heretic_leader_control)
	(ai_erase all_enemies)
	(ai_erase disposal_commander)
	(ai_erase allies_elites)
	(ai_erase allies_elites_04)
	(object_teleport (player0) player0_hide)
	(object_teleport (player1) player1_hide)
	(sleep_forever hologram_toggle)
	(object_create_anew gasmine_hologram)
	(object_set_function_variable gasmine_hologram "holo_power" 1 0)
	
	(if (cinematic_skip_start)
		(begin
			(C04_intra1)
		)
	)
	(cinematic_skip_stop)

	(sound_suppress_ambience_update_on_revert)
	(sound_class_set_gain amb 0 0)
	(sleep 1)
	(sound_class_set_gain amb 1 15)

	(sleep 2)
	(object_teleport (player0) player0_control)
	(object_teleport (player1) player1_control)
	(device_set_position_immediate control_shield_door 0)
	(device_set_position_immediate shield 0)

	(ai_place control_elites_cinematic)
	(ai_place control_commander_cinematic)
	(ai_cannot_die control_commander_cinematic TRUE)
	(ai_set_orders all_allies allies_pickup)
	
	(device_set_power control_up_switch_01 1)
	(wake hologram_toggle)

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white)

	(wake music_04b_04_stop_alt)
	
	(wake objective_control_clear)
	(wake objective_cables_set)

	(ai_scene control_comm_scene commander_farewell all_allies)
	(cs_run_command_script control_elites_cinematic/elite01 soe_bug_out_01)
	(cs_run_command_script control_elites_cinematic/elite02 soe_bug_out_02)
;	(ai_scene control_allies_scene spec_op_farewell all_allies)
	;(cs_run_command_script allies_grunts_03/grunt01 sog_bug_out_01)
	;(cs_run_command_script allies_grunts_03/grunt02 sog_bug_out_02)
	;(cs_run_command_script allies_grunts_04/1 sog_bug_out_03)
	;(cs_run_command_script allies_grunts_04/2 sog_bug_out_04)

	(data_mine_set_mission_segment "04b_13_control_room_02")
	(game_save)
	;(ai_place control_infection 4)
	(wake control_commander_reminder)
	(wake control_bug_out)

	(sleep_until (= (volume_test_objects vol_control_middle (players)) TRUE) 30 1800)
	(wake control_flood_spawn)

	(sleep_until 
		(OR
			(>= (ai_combat_status control_flood) ai_combat_status_visible)
			(= (volume_test_objects vol_control_middle (players)) TRUE)
			(= (volume_test_objects vol_control_perimeter (players)) TRUE)
			(= (volume_test_objects vol_control_top (ai_actors control_flood)) TRUE)
		)
	)
	(wake music_04b_05_start)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_control_perimeter (players)) TRUE)
			(= (volume_test_objects vol_control_top (ai_actors control_flood)) TRUE)
		)
	)
	(device_set_position elev_control_up 0)
	(ai_place control_sentinels_wave_03 3)
	
;	(sleep_until (> (device_get_position elev_control_up) .14))
	(sleep_until (= (volume_test_objects vol_control_return (players)) TRUE))
	(wake music_04b_04_stop)
	(objects_predict cableroom)
)


;-------------------------------------------------------------------------------
;Cable Room

(global effect stress "effects\scenery\sparks\sparking_light")
(global effect boom "effects\scenarios\solo\alphagasgiant\wall_explosion")

(script dormant strain
	(sleep_until
		(begin
			(begin_random
				(begin
					(effect_new stress croom01)
;					(object_create_anew crap01)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom02)
;					(object_create_anew crap02)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom03)
;					(object_create_anew crap03)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom04)
;					(object_create_anew crap04)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom05)
;					(object_create_anew crap05)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom06)
;					(object_create_anew crap06)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom07)
;					(object_create_anew crap07)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom08)
;					(object_create_anew crap08)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom09)
;					(object_create_anew crap09)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom10)
;					(object_create_anew crap10)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom11)
;					(object_create_anew crap11)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new stress croom12)
;					(object_create_anew crap12)
					(sleep (random_range 5 30))
				)
			)
			(= (structure_bsp_index) 4)
		)
	)
)
(script dormant rip
			(begin_random
				(begin
					(effect_new boom tear01)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear02)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear03)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear04)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear05)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear06)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear07)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear08)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear09)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear10)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear11)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear12)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear13)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear14)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear15)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear16)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear17)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear18)
					(sleep (random_range 1 5))
				)
				(begin
					(effect_new boom tear19)
					(sleep (random_range 1 5))
				)
			)
)

(script command_script try_to_fix
	(cs_ignore_obstacles TRUE)
	(cs_approach croom_center 4 20 20)
	(unit_add_equipment (unit (ai_get_object ai_current_actor)) swap TRUE TRUE)
	(cs_shoot TRUE croom_center)
)

;For fucking with gravity
(global real gravity 0)

;Puts player in freefall and then brings gravity back over a few seconds
(script dormant grav_test
	(set gravity 0)
	(physics_set_gravity gravity)
	(sleep_until
		(begin
			(physics_set_gravity gravity)
			(set gravity (+ gravity .1))
			(> gravity .9)
		)
	)
	(set gravity 1.0)
	(physics_set_gravity gravity)
)

;Momentary camera shake for cutting first two cables
(script static void cam_shake
	(player_effect_set_max_rotation 0 2 2)
	(player_effect_start .5 0)
	(player_effect_stop 1.5)
)
(script static void cam_roll
	(player_effect_set_max_rotation .2 .2 .2)
	;(player_effect_set_max_translation 1 1 1)
	(player_effect_start .1 1)
)

;Ongoing shake for plummeting
(script dormant cam_shake_cont
	(player_effect_set_max_rotation 0 2 2)
	(player_effect_start .5 0)
	(sleep_until (= (volume_test_objects vol_going_down (players)) TRUE))
	(player_effect_start .45 0)
	(sleep 60)
	(player_effect_start .4 0)
	(sleep 60)
	(player_effect_start .35 0)
	(sleep 60)
	(player_effect_start .3 0)
	(sleep 60)
	(player_effect_start .25 0)
	(sleep 60)
	(player_effect_start .2 0)
	(sleep 60)
	(player_effect_start .15 0)
	(sleep 60)
	(player_effect_start .1 0)
	(sleep 60)
	(player_effect_start .05 0)
)

;9/11
(global boolean cables_cuttable TRUE)

;Makes cables uncuttable when animating room
(script dormant cable_invulnerable
	(sleep_until (= cables_cuttable FALSE) 1)
	(object_cannot_take_damage real_cable_a)
	(object_cannot_take_damage real_cable_b)
	(object_cannot_take_damage real_cable_c)

;	(sleep 30)
;	(sleep_until (= (device_get_position cableroom) 1))

	(sleep_until (= (device_get_position cableroom) 1))
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'That's one! By the Prophets! Look at the station list!'")
	(sleep (ai_play_line_on_object NONE 1380))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1380_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)

	(sleep_until 
		(AND
			(= cables_cuttable TRUE)
			(= (device_get_position cableroom) 1)
		)
	1)

	(object_can_take_damage real_cable_a)
	(object_can_take_damage real_cable_b)
	(object_can_take_damage real_cable_c)

	(sleep 5)

	(sleep_until (= cables_cuttable FALSE) 1)
	(object_cannot_take_damage real_cable_a)
	(object_cannot_take_damage real_cable_b)
	(object_cannot_take_damage real_cable_c)

	(sleep_until (= (device_get_position cableroom) 1))
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'One final cable Arbiter…'")
	(sleep (ai_play_line_on_object NONE 1400))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1400_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(sleep 30)
	(wake music_04b_06_start)

	(sleep_until 
		(AND
			(= cables_cuttable TRUE)
			(= (device_get_position cableroom) 1)
		)
	1)

	(object_can_take_damage real_cable_a)
	(object_can_take_damage real_cable_b)
	(object_can_take_damage real_cable_c)
)

;Destroys characters and objects sucked out the top
(global boolean in_cable_room FALSE)
(script dormant cableroom_suck_killer
	(sleep_until
		(begin
			(object_destroy (list_get (volume_return_objects vol_cableroom_suck_kill) 0))
			(sleep 5)
			(unit_kill (unit (list_get (volume_return_objects_by_type vol_cableroom_suck_kill 1) 0)))
			(sleep 5)
			(= in_cable_room FALSE)
		)
	5)
)

;Spawns debris around roof's torn edge
(script dormant cableroom_junk_spawn
	(sleep_until
		(begin
			(begin_random
				(begin
					(object_create_anew croom_junk_01)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_02)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_03)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_04)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_05)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_06)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_07)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_08)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_09)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_10)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_11)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_12)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_13)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_14)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_15)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_16)
					(sleep (random_range 20 60))
				)
				(begin
					(object_create_anew croom_junk_17)
					(sleep (random_range 20 60))
				)
			)
			(= in_cable_room FALSE)
		)
	)
)

(script dormant cable_nav_a
	(activate_team_nav_point_object default player cable_target_a 0)
	(sleep_until (<= (object_get_health real_cable_a) 0))
	(deactivate_team_nav_point_object player cable_target_a)	
)
(script dormant cable_nav_b
	(activate_team_nav_point_object default player cable_target_b 0)
	(sleep_until (<= (object_get_health real_cable_b) 0))
	(deactivate_team_nav_point_object player cable_target_b)	
)
(script dormant cable_nav_c
	(activate_team_nav_point_object default player cable_target_c 0)
	(sleep_until (<= (object_get_health real_cable_c) 0))
	(deactivate_team_nav_point_object player cable_target_c)	
)

;Reminder to cut cables
(script dormant cableroom_commander_reminder
	(sleep_until 
		(OR
			(<= (object_get_health real_cable_a) 0)
			(<= (object_get_health real_cable_b) 0)
			(<= (object_get_health real_cable_c) 0)
		)
	30 3600)
	(if
		(AND
			(> (object_get_health real_cable_a) 0)
			(> (object_get_health real_cable_b) 0)
			(> (object_get_health real_cable_c) 0)
		)
		(begin
			(ai_dialogue_enable FALSE)
			(sleep 60)
			(print "SPEC-OPS COMMANDER: 'Sever the cable at the points where it connect to the structure!'")
			(sleep (ai_play_line_on_object NONE 1370))
			;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1370_soc))
			(sleep 30)
			(wake cable_nav_a)
			(wake cable_nav_b)
			(wake cable_nav_c)
			(sleep 30)
			(ai_dialogue_enable TRUE)
		)
	)
)

;Makes all flood turn to look up at cables when stuck in ceiling
(script command_script cable_look
	(cs_face_object TRUE cableroom)
	(sleep_until (= plummeting TRUE))
)

;For enemy spawning
(global short croom_sen_total 0)
(global short croom_flood_total 0)
(global short croom_flood_desired 6)
(global short croom_sen_desired 4)

;For monitoring number of cables cut
(global short cable_var 0)

;Tracks when cables get cut
(script dormant cable_a_health
	(sleep_until (<= (object_get_health real_cable_a) 0) 1)

;9/11
			(set cables_cuttable FALSE)
;			(cable_invulnerable)

	(set cable_var (+ cable_var 1))
	(object_create_anew cable_nub_a)
	(objects_attach cableroom rot_a cable_nub_a cable_destroyed)
	(if (= cable_var 1)
		(begin
			(cam_shake)
			(device_set_position real_cable_a 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_01_quad "none" 1)
			(device_set_position_track cableroom cable_room_rot_5_bc 0)
			(device_animate_position cableroom 1 10 1 4 FALSE)
			;(ai_set_orders cable_flood cable_room_bc)
			;(ai_set_orders cable_sentinels cable_room_sentinels_bc)
			(set croom_flood_total (ai_nonswarm_count cable_flood))
			(set croom_sen_total (ai_living_count cable_sentinels))
			(game_save)
		)
	)
	(if (= cable_var 2)
		(begin
			(cam_shake)
			(device_set_position real_cable_a 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_02_quad "none" 1)
			(if (<= (object_get_health real_cable_b) 0)
				(begin
					(device_set_position_track cableroom cable_room_rot_ac2c 0)
					(device_animate_position cableroom 1 10 1 4 FALSE)
					;(ai_set_orders cable_flood cable_room_c)
					;(ai_set_orders cable_sentinels cable_room_sentinels_c)
					(set croom_flood_total (ai_nonswarm_count cable_flood))
					(set croom_sen_total (ai_living_count cable_sentinels))
				)
			)
			(if (<= (object_get_health real_cable_c) 0)
				(begin
					(device_set_position_track cableroom cable_room_rot_ab2b 0)
					(device_animate_position cableroom 1 10 1 4 FALSE)
					;(ai_set_orders cable_flood cable_room_b)
					;(ai_set_orders cable_sentinels cable_room_sentinels_b)
					(set croom_flood_total (ai_nonswarm_count cable_flood))
					(set croom_sen_total (ai_living_count cable_sentinels))
				)
			)
			(game_save)
		)
	)
	(if (= cable_var 3)
		(begin
			(cam_shake)
			(device_set_position real_cable_a 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_two "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_03_quad "none" 1)
			(device_set_position_track cableroom cable_room_rot_a_back 0)
			(device_animate_position cableroom 1 2 0 .5 FALSE)
			;(cs_run_command_script cable_room_sentinels try_to_fix)
			(ai_set_orders cable_sentinels cable_room_sentinels_end)
			(ai_set_blind cable_sentinels TRUE)
			(ai_set_blind cable_flood TRUE)
			(cs_run_command_script cable_flood cable_look)
			
;			(game_save)
			(wake music_04b_07_start)
			(wake strain)
			
			(sleep 400)
;			(objects_predict cableroom2)
			(object_type_predict_high scenarios\objects\solo\alphagasgiant\cable_room\cable_room) ; pbertone 9/23 
			(object_type_predict_high scenarios\objects\solo\alphagasgiant\cable_room_top\cable_room_top) ; pbertone 9/23 
			(sleep 20)	
			(objects_detach cableroom real_cable_a)
			(objects_detach cableroom real_cable_b)
			(objects_detach cableroom real_cable_c)
			(objects_detach cableroom elev_control_up)
			(objects_detach cableroom control_up_switch_02)
			(objects_detach cableroom cable_nub_a)
			(objects_detach cableroom cable_nub_b)
			(objects_detach cableroom cable_nub_c)
			
;			(fade_out 1 1 1 5) ; pbertone 9/22 
;			(sleep 5)
			
			(object_destroy cableroom)
			(switch_bsp 4)
			;(wake rip)
			(wake cam_shake_cont)
			(physics_disable_character_ground_adhesion_forces 1)
			(objects_attach cableroom_top rot_a real_cable_a "")
			(objects_attach cableroom_top rot_b real_cable_b "")
			(objects_attach cableroom_top rot_c real_cable_c "")
			(objects_attach cableroom2 elevator elev_control_up elev_top)
			(objects_attach cableroom2 "switch" control_up_switch_02 "")
			(objects_attach cableroom2 "anim" cable_nub_a "torn02")
			(objects_attach cableroom2 "anim" cable_nub_b "torn03")
			(objects_attach cableroom2 "anim" cable_nub_c "")
			(device_set_position_track cableroom2 cable_room_drop 0)
			(device_animate_position cableroom2 1 1 0 .5 FALSE)
			(device_set_position cableroom_top 1)
			;(sound_looping_start sound\ambience\alphagasgiant\interior_implode\interior_implode "none" 1)
			(wake cableroom_suck_killer)
			(wake cableroom_junk_spawn)
			(object_create suction)
			;(switch_bsp 4)
			(wake grav_test)
			(set plummeting TRUE)
			
;			(sleep 5)
;			(fade_in 1 1 1 15) ; pbertone 9/22 
		
			(cache_block_for_one_frame) ; pbertone 9/23 

			(sleep 150)
			(object_destroy cableroom_top)
		)
	)

;9/11
			(sleep 30)
			(set cables_cuttable TRUE)
;			(cable_invulnerable)
)
(script dormant cable_b_health
	(sleep_until (<= (object_get_health real_cable_b) 0) 1)

;9/11
			(set cables_cuttable FALSE)
;			(cable_invulnerable)

	(set cable_var (+ cable_var 1))
	(object_create_anew cable_nub_b)
	(objects_attach cableroom rot_b cable_nub_b cable_destroyed)
	(if (= cable_var 1)
		(begin
			(cam_shake)
			(device_set_position real_cable_b 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_01_quad "none" 1)
			(device_set_position_track cableroom cable_room_rot_5_ac 0)
			(device_animate_position cableroom 1 10 1 4 FALSE)
			;(ai_set_orders cable_flood cable_room_ac)
			;(ai_set_orders cable_sentinels cable_room_sentinels_ac)
			(set croom_flood_total (ai_nonswarm_count cable_flood))
			(set croom_sen_total (ai_living_count cable_sentinels))
			(game_save)
		)
	)
	(if (= cable_var 2)
		(begin
			(cam_shake)
			(device_set_position real_cable_b 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_02_quad "none" 1)
			(if (<= (object_get_health real_cable_a) 0)
				(begin
					(device_set_position_track cableroom cable_room_rot_bc2c 0)
					(device_animate_position cableroom 1 10 1 4 FALSE)
					;(ai_set_orders cable_flood cable_room_c)
					;(ai_set_orders cable_sentinels cable_room_sentinels_c)
					(set croom_flood_total (ai_nonswarm_count cable_flood))
					(set croom_sen_total (ai_living_count cable_sentinels))
				)
			)
			(if (<= (object_get_health real_cable_c) 0)
				(begin
					(device_set_position_track cableroom cable_room_rot_ab2a 0)
					(device_animate_position cableroom 1 10 1 4 FALSE)
					;(ai_set_orders cable_flood cable_room_a)
					;(ai_set_orders cable_sentinels cable_room_sentinels_a)
					(set croom_flood_total (ai_nonswarm_count cable_flood))
					(set croom_sen_total (ai_living_count cable_sentinels))
				)
			)
			(game_save)
		)
	)
	(if (= cable_var 3)
		(begin
			(cam_shake)
			(device_set_position real_cable_b 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_two "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_03_quad "none" 1)
			(device_set_position_track cableroom cable_room_rot_b_back 0)
			(device_animate_position cableroom 1 2 0 .5 FALSE)
			(cs_run_command_script cable_room_sentinels try_to_fix)
			(ai_set_orders cable_sentinels cable_room_sentinels_end)
			(ai_set_blind cable_sentinels TRUE)
			(ai_set_blind cable_flood TRUE)
			(cs_run_command_script cable_flood cable_look)

;			(game_save)
			(wake music_04b_07_start)
			(wake strain)

			(sleep 400)
;			(objects_predict cableroom2)
			(object_type_predict_high scenarios\objects\solo\alphagasgiant\cable_room\cable_room) ; pbertone 9/23 
			(object_type_predict_high scenarios\objects\solo\alphagasgiant\cable_room_top\cable_room_top) ; pbertone 9/23 
			(sleep 20)	
			(objects_detach cableroom real_cable_a)
			(objects_detach cableroom real_cable_b)
			(objects_detach cableroom real_cable_c)
			(objects_detach cableroom elev_control_up)
			(objects_detach cableroom control_up_switch_02)
			(objects_detach cableroom cable_nub_a)
			(objects_detach cableroom cable_nub_b)
			(objects_detach cableroom cable_nub_c)
			
;			(fade_out 1 1 1 5) ; pbertone 9/22 
;			(sleep 5)
			
			(object_destroy cableroom)
			(switch_bsp 4)
			;(wake rip)
			(wake cam_shake_cont)
			(physics_disable_character_ground_adhesion_forces 1)
			(objects_attach cableroom_top rot_a real_cable_a "")
			(objects_attach cableroom_top rot_b real_cable_b "")
			(objects_attach cableroom_top rot_c real_cable_c "")
			(objects_attach cableroom2 elevator elev_control_up elev_top)
			(objects_attach cableroom2 "switch" control_up_switch_02 "")
			(objects_attach cableroom2 "anim" cable_nub_a "torn02")
			(objects_attach cableroom2 "anim" cable_nub_b "torn03")
			(objects_attach cableroom2 "anim" cable_nub_c "")
			(device_set_position_track cableroom2 cable_room_drop 0)
			(device_animate_position cableroom2 1 1 0 .5 FALSE)
			(device_set_position cableroom_top 1)
			;(sound_looping_start sound\ambience\alphagasgiant\interior_implode\interior_implode "none" 1)
			(wake cableroom_suck_killer)
			(wake cableroom_junk_spawn)
			(object_create suction)
			;(switch_bsp 4)
			(wake grav_test)
			(set plummeting TRUE)
			
;			(sleep 5)
;			(fade_in 1 1 1 15) ; pbertone 9/22 
			
			(cache_block_for_one_frame) ; pbertone 9/23 

			(sleep 150)
			(object_destroy cableroom_top)
		)
	)

;9/11
			(sleep 30)
			(set cables_cuttable TRUE)
;			(cable_invulnerable)
)
(script dormant cable_c_health
	(sleep_until (<= (object_get_health real_cable_c) 0) 1)

;9/11
			(set cables_cuttable FALSE)
;			(cable_invulnerable)

	(set cable_var (+ cable_var 1))
	(object_create_anew cable_nub_c)
	(objects_attach cableroom rot_c cable_nub_c cable_destroyed)
	(if (= cable_var 1)
		(begin
			(cam_shake)
			(device_set_position real_cable_c 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_01_quad "none" 1)
			(device_set_position_track cableroom cable_room_rot_5_ab 0)
			(device_animate_position cableroom 1 10 1 4 FALSE)
			;(ai_set_orders cable_flood cable_room_ab)
			;(ai_set_orders cable_sentinels cable_room_sentinels_ab)
			(set croom_flood_total (ai_nonswarm_count cable_flood))
			(set croom_sen_total (ai_living_count cable_sentinels))
			(game_save)
		)
	)
	(if (= cable_var 2)
		(begin
			(cam_shake)
			(device_set_position real_cable_c 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_one "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_02_quad "none" 1)
			(if (<= (object_get_health real_cable_a) 0)
				(begin
					(device_set_position_track cableroom cable_room_rot_bc2b 0)
					(device_animate_position cableroom 1 10 1 4 FALSE)
					;(ai_set_orders cable_flood cable_room_b)
					;(ai_set_orders cable_sentinels cable_room_sentinels_b)
					(set croom_flood_total (ai_nonswarm_count cable_flood))
					(set croom_sen_total (ai_living_count cable_sentinels))
				)
			)
			(if (<= (object_get_health real_cable_b) 0)
				(begin
					(device_set_position_track cableroom cable_room_rot_ac2a 0)
					(device_animate_position cableroom 1 10 1 4 FALSE)
					;(ai_set_orders cable_flood cable_room_a)
					;(ai_set_orders cable_sentinels cable_room_sentinels_a)
					(set croom_flood_total (ai_nonswarm_count cable_flood))
					(set croom_sen_total (ai_living_count cable_sentinels))
				)
			)
			(game_save)
		)
	)
	(if (= cable_var 3)
		(begin
			(cam_shake)
			(device_set_position real_cable_c 1)
			(sound_impulse_start sound\ambience\alphagasgiant\cable_snaps\cable_snap_two "none" 1)
			(sound_looping_start sound_remastered\visual_effects\alphagas_cablelist\alphacable_swtnr_03_quad "none" 1)
			(device_set_position_track cableroom cable_room_rot_c_back 0)
			(device_animate_position cableroom 1 2 0 .5 FALSE)
			(cs_run_command_script cable_room_sentinels try_to_fix)
			(ai_set_orders cable_sentinels cable_room_sentinels_end)
			(ai_set_blind cable_sentinels TRUE)
			(ai_set_blind cable_flood TRUE)
			(cs_run_command_script cable_flood cable_look)

;			(game_save)
			(wake music_04b_07_start)
			(wake strain)

			(sleep 400)
;			(objects_predict cableroom2)
			(object_type_predict_high scenarios\objects\solo\alphagasgiant\cable_room\cable_room) ; pbertone 9/23 
			(object_type_predict_high scenarios\objects\solo\alphagasgiant\cable_room_top\cable_room_top) ; pbertone 9/23 
			(sleep 20)	
			(objects_detach cableroom real_cable_a)
			(objects_detach cableroom real_cable_b)
			(objects_detach cableroom real_cable_c)
			(objects_detach cableroom elev_control_up)
			(objects_detach cableroom control_up_switch_02)
			(objects_detach cableroom cable_nub_a)
			(objects_detach cableroom cable_nub_b)
			(objects_detach cableroom cable_nub_c)
			
;			(fade_out 1 1 1 5) ; pbertone 9/22 
;			(sleep 5)
			
			(object_destroy cableroom)
			(switch_bsp 4)
			;(wake rip)
			(wake cam_shake_cont)
			(physics_disable_character_ground_adhesion_forces 1)
			(objects_attach cableroom_top rot_a real_cable_a "")
			(objects_attach cableroom_top rot_b real_cable_b "")
			(objects_attach cableroom_top rot_c real_cable_c "")
			(objects_attach cableroom2 elevator elev_control_up elev_top)
			(objects_attach cableroom2 "switch" control_up_switch_02 "")
			(objects_attach cableroom2 "anim" cable_nub_a "torn02")
			(objects_attach cableroom2 "anim" cable_nub_b "torn03")
			(objects_attach cableroom2 "anim" cable_nub_c "")
			(device_set_position_track cableroom2 cable_room_drop 0)
			(device_animate_position cableroom2 1 1 0 .5 FALSE)
			(device_set_position cableroom_top 1)
			;(sound_looping_start sound\ambience\alphagasgiant\interior_implode\interior_implode "none" 1)
			(wake cableroom_suck_killer)
			(wake cableroom_junk_spawn)
			(object_create suction)
			;(switch_bsp 4)
			(wake grav_test)
			(set plummeting TRUE)
			
;			(sleep 5)
;			(fade_in 1 1 1 15) ; pbertone 9/22 
			
			(cache_block_for_one_frame) ; pbertone 9/23 

			(sleep 150)
			(object_destroy cableroom_top)
		)
	)

;9/11
			(sleep 30)
			(set cables_cuttable TRUE)
;			(cable_invulnerable)
)

;Infinitely spawns flood until the encounter is over
(script dormant cable_flood_spawner
	(if (difficulty_legendary)
		(set croom_flood_desired 10)
	)
	(if (difficulty_heroic)
		(set croom_flood_desired 8)
	)
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(AND
						(< croom_flood_total croom_flood_desired)
						(< (ai_nonswarm_count cable_flood) (/ croom_flood_desired 2))
					)
					(= plummeting TRUE)
					(> cable_var 0)
				)
			)
			(if 
				(AND
					(= plummeting FALSE)
					(< cable_var 1)
				)	
					(begin
						(ai_place cable_room_combatforms 1)
						(set croom_flood_total (+ croom_flood_total 1))
					)
			)
			(OR
				(= plummeting TRUE)
				(> cable_var 0)
				(>= croom_flood_total croom_flood_desired)
			)
		)
	)

	(sleep_until 
		(OR
			(> cable_var 0)
			(= plummeting TRUE)
		)
	)
	(if (= plummeting TRUE)
		(sleep_forever)
	)
	(set croom_flood_total 0)
	(if (difficulty_legendary)
		(set croom_flood_desired 12)
	)
	(if (difficulty_heroic)
		(set croom_flood_desired 10)
	)
	(if (difficulty_normal)
		(set croom_flood_desired 8)
	)
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(AND
						(< croom_flood_total croom_flood_desired)
						(< (ai_nonswarm_count cable_flood) (/ croom_flood_desired 2))
					)
					(= plummeting TRUE)
					(> cable_var 1)
				)
			)
			(if 
				(AND
					(= plummeting FALSE)
					(< cable_var 2)
				)	
					(begin
						(ai_place cable_room_combatforms 1)
						(set croom_flood_total (+ croom_flood_total 1))
					)
			)
			(OR
				(= plummeting TRUE)
				(> cable_var 1)
				(>= croom_flood_total croom_flood_desired)
			)
		)
	)

	(sleep_until 
		(OR
			(> cable_var 1)
			(= plummeting TRUE)
		)
	)
	(if (= plummeting TRUE)
		(sleep_forever)
	)
	(set croom_flood_total 0)
	(if (difficulty_legendary)
		(set croom_flood_desired 14)
	)
	(if (difficulty_heroic)
		(set croom_flood_desired 12)
	)
	(if (difficulty_normal)
		(set croom_flood_desired 10)
	)
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(AND
						(< croom_flood_total croom_flood_desired)
						(< (ai_nonswarm_count cable_flood) (/ croom_flood_desired 2))
					)
					(= plummeting TRUE)
					(> cable_var 2)
				)
			)
			(if 
				(AND
					(= plummeting FALSE)
					(< cable_var 3)
				)	
					(begin
						(ai_place cable_room_combatforms 1)
						(set croom_flood_total (+ croom_flood_total 1))
					)
			)
			(OR
				(= plummeting TRUE)
				(> cable_var 2)
				(>= croom_flood_total croom_flood_desired)
			)
		)
	)
)

;Infinitely spawns sentinels until the encounter is over
(script dormant cable_sentinel_spawner
	(if (difficulty_legendary)
		(set croom_sen_desired 8)
	)
	(if (difficulty_heroic)
		(set croom_sen_desired 6)
	)
	(sleep_until
		(begin
			(sleep_until
				(OR
					(AND
						(< (ai_living_count cable_sentinels) (/ croom_sen_desired 2))
						(< croom_sen_total croom_sen_desired)
					)
					(= plummeting TRUE)
					(> cable_var 0)
				)
			)
			(if 
				(AND
					(= plummeting FALSE)
					(< cable_var 1)
				)	
					(begin
						(ai_place cable_room_sentinels 1)
						(set croom_sen_total (+ croom_sen_total 1))
					)
			)
			(OR
				(= plummeting TRUE)
				(> cable_var 0)
				(>= croom_sen_total croom_sen_desired)
			)
		)
	)

	(sleep_until 
		(OR
			(> cable_var 0)
			(= plummeting TRUE)
		)
	)
	(if (= plummeting TRUE)
		(sleep_forever)
	)
	(set croom_sen_total 0)
	(if (difficulty_legendary)
		(set croom_sen_desired 6)
	)
	(if (difficulty_heroic)
		(set croom_sen_desired 4)
	)
	(sleep_until
		(begin
			(sleep_until
				(OR
					(AND
						(< (ai_living_count cable_sentinels) (/ croom_sen_desired 2))
						(< croom_sen_total croom_sen_desired)
					)
					(= plummeting TRUE)
					(> cable_var 1)
				)
			)
			(if 
				(AND
					(= plummeting FALSE)
					(< cable_var 2)
				)	
					(begin
						(ai_place cable_room_sentinels 1)
						(set croom_sen_total (+ croom_sen_total 1))
					)
			)
			(OR
				(= plummeting TRUE)
				(> cable_var 1)
				(>= croom_sen_total croom_sen_desired)
			)
		)
	)
	
	(sleep_until 
		(OR
			(> cable_var 1)
			(= plummeting TRUE)
		)
	)
	(if (= plummeting TRUE)
		(sleep_forever)
	)
	(set croom_sen_total 0)
	(if (difficulty_legendary)
		(set croom_sen_desired 4)
	)
	(if (difficulty_heroic)
		(set croom_sen_desired 4)
	)
	(sleep_until
		(begin
			(sleep_until
				(OR
					(AND
						(< (ai_living_count cable_sentinels) (/ croom_sen_desired 2))
						(< croom_sen_total croom_sen_desired)
					)
					(= plummeting TRUE)
					(> cable_var 2)
				)
			)
			(if 
				(AND
					(= plummeting FALSE)
					(< cable_var 3)
				)	
					(begin
						(ai_place cable_room_sentinels 1)
						(set croom_sen_total (+ croom_sen_total 1))
					)
			)
			(OR
				(= plummeting TRUE)
				(> cable_var 2)
				(>= croom_sen_total croom_sen_desired)
			)
		)
	)	
)

(script dormant croom_exit
	(sleep_until (= (volume_test_objects vol_going_down (players)) TRUE) 1)
	(sleep_forever cableroom_killer)
	(device_set_power control_up_switch_01 0)
	(device_set_power control_up_switch_02 0)
	(device_set_position elev_control_up .04195)

	(set in_cable_room FALSE)
)

;Overall script for cableroom
(script dormant cable_room_start
	(ai_disposable control_flood TRUE)
	(ai_disposable control_sentinels TRUE)
	(ai_erase_all)
	(sleep_forever wind)
	(data_mine_set_mission_segment "04b_14_cable_room")
;	(game_save)
	(object_cannot_take_damage (player0))
	(object_cannot_take_damage (player1))

	(objects_attach cableroom rot_a real_cable_a "")
	(objects_attach cableroom rot_b real_cable_b "")
	(objects_attach cableroom rot_c real_cable_c "")
	(objects_attach real_cable_a "cut_here" cable_target_a "")
	(objects_attach real_cable_b "cut_here" cable_target_b "")
	(objects_attach real_cable_c "cut_here" cable_target_c "")
	(objects_attach cableroom "switch" control_up_switch_02 "")

;9/12

;	(cinematic_lighting_set_primary_light 90 296 0.49 0.49 0.23)
;	(cinematic_lighting_set_secondary_light 90 216 0.52 0.43 0.17)
;	(cinematic_lighting_set_ambient_light 0.12 0.09 0.05)

	(cinematic_lighting_set_primary_light 28 118 0.419608 0.313726 0.247059)
	(cinematic_lighting_set_secondary_light -26 312 0.113725 0.0941177 0.0862745)
	(cinematic_lighting_set_ambient_light 0.0470588 0.0509804 0.054902)

	(object_uses_cinematic_lighting real_cable_a 1)
	(object_uses_cinematic_lighting real_cable_b 1)
	(object_uses_cinematic_lighting real_cable_c 1)

	(wake cable_a_health)
	(wake cable_b_health)
	(wake cable_c_health)
	
;9/11
	(wake cable_invulnerable)
	
	(wake cable_flood_spawner)
	(wake cable_sentinel_spawner)
		
	(device_set_power control_up_switch_02 0)
	(set in_cable_room TRUE)

	(wake 04b_title1)
	(ai_place cableroom_sentinels_init 3)
	(ai_place cableroom_flood_init 6)
	
	(sleep_until (> (device_get_position elev_control_up) .95))
	(object_can_take_damage (player0))
	(object_can_take_damage (player1))
	(wake cableroom_killer)
	(wake cableroom_junk_killer)
	(game_save_immediate)

	(sleep_until (= (device_get_position elev_control_up) 1))
	(objects_attach cableroom elevator elev_control_up elev_top)
	
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'All my Phantoms are in the air, Arbiter. Go ahead - cut the cable!'")
	(sleep (ai_play_line_on_object NONE 0170))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0170_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
	(wake cableroom_commander_reminder)

	(sleep_until (= plummeting TRUE))
	(wake croom_exit)

;9/11
	(wake objective_cables_clear)
	
	(sleep 30)
	(sleep_until (= (device_get_position cableroom2) 1))
	(objects_detach cableroom2 elev_control_up)
	(sleep 2)
	(device_set_position elev_control_up .99999)
	(sleep 2)
	(device_set_power control_up_switch_02 1)
	(sleep 90)
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'That did it! The station is in free-fall!'")
	(sleep (ai_play_line_on_object NONE 0180))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0180_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
		
	(wake objective_dogfight_set)
	(game_save)

	(ai_set_blind cable_flood FALSE)
	(ai_set_orders cable_flood cable_room_after)

;	(sleep_until (= (volume_test_objects vol_going_down (players)) TRUE) 1)
;	(sleep_forever cableroom_killer)
;	(device_set_power control_up_switch_01 0)
;	(device_set_power control_up_switch_02 0)
;	(device_set_position elev_control_up .04195)
;
;	(set in_cable_room FALSE)
)

;-------------------------------------------------------------------------------
;Control Room Return

(global effect gasleak "effects\scenarios\solo\alphagasgiant\gas_leak")

;9/12
(global effect big_boom "effects\scenarios\solo\alphagasgiant\wall_explosion")

;Commander updates you as you descend
(script dormant plummeting_control_commander
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'The Heretic Leader is on the move! Do not let him escape! We'll stay with you as long as we can! '")
	(sleep (ai_play_line_on_object NONE 0190))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0190_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;Respawns flood to wear down heretics
(script dormant control_return_flood_spawn
	(sleep_until 
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_middle_spawnroom) 0)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_02/mid01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_middle_spawnroom) 0)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_02/mid02)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_middle_spawnroom) 0)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_02/mid03)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_middle_spawnroom) 0)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_02/mid04)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_middle_spawnroom) 0)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_02/mid01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_middle_spawnroom) 0)
						(= (volume_test_objects vol_control_middle_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_02/mid02)
				)				
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_02/peri01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_02/peri02)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_02/peri03)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_02/peri04)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_02/peri01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_02/peri02)
				)
			)
			(OR
				(= (ai_living_count control_return_heretics) 0)
				(> (ai_spawn_count control_return_flood) 10)
				(= (volume_test_objects vol_control_return_perimeter (players)) TRUE)
			)
		)
	)
	(sleep_until 
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_03/peri01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_03/peri02)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_03/peri03)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_03/peri04)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_03/peri01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_peri_spawnroom) 0)
						(= (volume_test_objects vol_control_peri_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_03/peri02)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_03/bott01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_03/bott02)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_03/bott03)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_03/bott04)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_03/bott01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_03/bott02)
				)
			)
			(OR
				(= (ai_living_count control_return_heretics) 0)
				(> (ai_spawn_count control_return_flood) 10)
				(= (volume_test_objects vol_control_return_middle (players)) TRUE)
			)
		)
	)
	(sleep_until 
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_04/bott01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_04/bott02)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_04/bott03)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_04/bott04)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_04/bott01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_bottom_spawnroom) 0)
						(= (volume_test_objects vol_control_bottom_spawnroom (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_04/bott02)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_entry_int) 0)
						(= (volume_test_objects vol_control_entry_int (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_04/entry01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_entry_int) 0)
						(= (volume_test_objects vol_control_entry_int (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_04/entry02)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_entry_int) 0)
						(= (volume_test_objects vol_control_entry_int (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_04/entry03)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_entry_int) 0)
						(= (volume_test_objects vol_control_entry_int (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_flood_04/entry04)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_entry_int) 0)
						(= (volume_test_objects vol_control_entry_int (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_04/entry01)
				)
				(if 
					(AND
						(< (ai_nonswarm_count control_return_flood) 3)
						(= (device_get_position control_entry_int) 0)
						(= (volume_test_objects vol_control_entry_int (players)) FALSE)
						(> (player_count) 0)
					)
					(ai_place control_return_carriers_04/entry02)
				)
				
			)
			(OR
				(= (ai_living_count control_return_heretics) 0)
				(> (ai_spawn_count control_return_flood) 10)
				(= (volume_test_objects vol_power_core_enter (players)) TRUE)
			)
		)
	)
)

;Some heretic dialogue
(script command_script control_return_heretic
	(cs_switch heretic_01)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
;	(cs_abort_on_damage TRUE)
	(print "HERETIC ELITE 1: 'Our lives for the truth!'")
	(cs_play_line 0750)

	(cs_switch heretic_02)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
;	(cs_abort_on_damage TRUE)
	(print "HERETIC ELITE 2: 'The truth and the Covenant!'")
	(cs_play_line 0760)
)

;Overall script for control room return
(script dormant control_room_return
	(ai_disposable cable_flood TRUE)
	(ai_disposable cable_sentinels TRUE)
	(ai_disposable all_allies TRUE)
	(ai_erase_all)
	(device_set_position_immediate control_shield_door 1)
	(device_set_position_immediate shield 1)
	(device_operates_automatically_set control_room_ext FALSE)
	(device_operates_automatically_set control_entry_int FALSE)

	(data_mine_set_mission_segment "04b_15_control_return")
	
	(sleep_until 
		(OR
			(< (device_get_position elev_control_up) .05)
			(= (volume_test_objects vol_control_top (players)) TRUE)
		)
	)
	(game_save_immediate)
	
	(wake plummeting_control_commander)
	(ai_place control_return_sentinels_01 2)

	(ai_place control_return_heretics_01 1)
	(ai_place control_return_heretics_02 2)
	(ai_place control_return_h_grunts_02 2)
	(sleep 90)
	(ai_place control_return_flood_01 2)
	(ai_place control_return_carriers_01 2)
	(wake control_return_flood_spawn)
	
	(sleep_until 
		(OR
			(= (volume_test_objects vol_control_return_middle (players)) TRUE)
			(< (ai_living_count control_return_heretics) 3)
		)
	)
	(game_save)
	(ai_place control_return_heretics_03 (- 2 (ai_living_count control_return_heretics_02)))
	(ai_place control_return_h_grunts_03 (- 2 (ai_living_count control_return_h_grunts_02)))
	;(device_set_position_immediate elev_control_down .5)
	;(device_set_power control_down_switch_01 0)
	;(device_set_power control_down_switch_02 0)
	
	(sleep_until (= (volume_test_objects vol_near_shield (players)) TRUE))

	(sleep_until
		(OR
			(ai_scene control_return_scene control_return_heretic control_return_heretics)
			(= (ai_living_count control_return_heretics) 0)
		)
	30 150)
	
	(sleep_until (= (ai_living_count control_return_heretics) 0))
	(game_save)
	(ai_set_orders control_return_flood control_return_flood_win)		
)	

;-------------------------------------------------------------------------------
;Power Core

;Heretic comment
(script command_script power_core_heretic
	(cs_switch heretic_01)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
;	(cs_abort_on_damage TRUE)
	(print "HERETIC ELITE: 'The Oracle must be saved!'")
	(cs_play_line 0740)
)

;Commander checking in
(script dormant power_core_commander
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(sleep_until (game_safe_to_save))
	(print "SPEC-OPS COMMANDER: 'Are you still alive, Arbiter?'")
	(sleep (ai_play_line_on_object NONE 0770))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0770_soc))
	(print "SPEC-OPS COMMANDER: 'We're keeping pace as best we can.'")
	(sleep (ai_play_line_on_object NONE 0780))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0780_soc))
	(game_save)
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;heretic leader runs away
(script command_script hl_retreat_x
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to fake_cinematics/p4)
	(ai_erase heretic_leader_04)
)

;Overall script for power core
(script dormant power_core_start
	(sleep_until (= (volume_test_objects vol_power_core_enter (players)) TRUE))
	(ai_disposable control_return_flood TRUE)
	(ai_disposable control_return_sentinels TRUE)
	(ai_disposable control_return_heretics TRUE)
	(device_operates_automatically_set hl_ledge_ext TRUE)
	;(object_create hl_end_banshee)
	(data_mine_set_mission_segment "04b_16_power_core")
	
	(ai_set_orders control_return_flood power_core_flood_all)
	(ai_place power_core_combatforms 2)
	(ai_place power_core_carriers 1)

	(ai_place power_core_sentinels_01 2)
	(ai_place power_core_heretics_01 1)
	(ai_place power_core_h_grunts_01 2)
	
	(wake power_core_commander)

	(sleep_until 
		(OR
			(= (volume_test_objects vol_power_core_midway (players)) TRUE)
			(< (ai_living_count power_core_heretics) 2)
		)
	)
	;(ai_place heretic_leader_04)
	;(ai_cannot_die heretic_leader_04 TRUE)
	(object_create player0_fake_banshee)
	(object_create player1_fake_banshee)
	(object_create hl_fake_banshee)
	(object_cannot_take_damage player0_fake_banshee)
	(object_cannot_take_damage player1_fake_banshee)
	(object_cannot_take_damage hl_fake_banshee)
	(game_save)
	
	(sleep_until
		(OR
			(ai_scene power_core_scene power_core_heretic power_core_heretics)
			(= (volume_test_objects vol_power_core_bottom (players)) TRUE)
		)
	)
	
	(sleep_until (= (volume_test_objects vol_power_core_bottom (players)) TRUE))
	;(cs_run_command_script heretic_leader_04 hl_retreat_x)
	(if
		(OR
			(difficulty_normal)
			(difficulty_heroic)
		)
			(ai_place power_core_swords 1)
	)
	(if (difficulty_legendary)
		(ai_place power_core_swords 2)
	)
)

;-------------------------------------------------------------------------------
;Banshee Dogfight 2

(global short plummet_junk_total 0)
(script dormant plummet_killer
	(sleep_until
		(begin
			(object_destroy (list_get (volume_return_objects vol_cableroom_suck_kill) 0))
			(set plummet_junk_total (- plummet_junk_total 1))
			(sleep 5)
			(= (structure_bsp_index) 5)
		)
	5)
)

(script dormant plummet_fl
	(sleep_until
		(begin
			(sleep_until (= (volume_test_objects vol_plummet_fl (players)) TRUE))
			(begin_random
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl01)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl02)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl03)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl04)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl05)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl06)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl08)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl09)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl10)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl11)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl12)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl14)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl15)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl16)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl17)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl18)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl19)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl20)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl21)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl22)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl23)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl24)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl25)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl26)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl27)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl28)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl29)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl30)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl31)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fl32)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
			)
			(= (volume_test_objects vol_arm_01_return (players)) TRUE)
		)
	)
)
(script dormant plummet_fr
	(sleep_until
		(begin
			(sleep_until (= (volume_test_objects vol_plummet_fr (players)) TRUE))
			(begin_random
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr01)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr02)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr03)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr04)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr05)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr06)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr08)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr09)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr10)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr11)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr12)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr14)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr15)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr16)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr17)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr18)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr19)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr20)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr21)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr22)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr23)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr24)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr25)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr26)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr27)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr28)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr29)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr30)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr31)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew fr32)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
			)
			(= (volume_test_objects vol_arm_01_return (players)) TRUE)
		)
	)
)
(script dormant plummet_nr
	(sleep_until
		(begin
			(sleep_until (= (volume_test_objects vol_plummet_nr (players)) TRUE))
			(begin_random
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr01)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr02)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr03)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr04)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr05)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr06)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr08)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr09)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr10)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr11)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr12)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr14)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr15)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr16)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr17)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr18)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr19)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr20)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr21)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr22)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr23)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr24)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr25)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr26)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr27)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr28)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr29)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr30)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr31)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nr32)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
			)
			(= (volume_test_objects vol_arm_01_return (players)) TRUE)
		)
	)
)
(script dormant plummet_nl
	(sleep_until
		(begin
			(sleep_until (= (volume_test_objects vol_plummet_nl (players)) TRUE))
			(begin_random
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl01)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl02)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl03)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl04)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl05)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl06)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl08)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl09)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl10)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl11)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl12)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl14)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl15)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl16)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl17)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl18)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl19)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl20)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl21)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl22)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl23)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl24)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl25)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl26)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
				(begin_random
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl27)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl28)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl29)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl30)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl31)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
					(if (< plummet_junk_total 50)
						(begin
							(object_create_anew nl32)
							(set plummet_junk_total (+ plummet_junk_total 1))
							(sleep (random_range 5 15))
						)
					)
				)
			)
			(= (volume_test_objects vol_arm_01_return (players)) TRUE)
		)
	)
)



;Kills player if he falls out of banshee
(script dormant banshee_killer_00
	(sleep_until (= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d" (unit (player0))) FALSE))
	(unit_kill (unit (player0)))
)
(script dormant banshee_killer_01
	(sleep_until (= (vehicle_test_seat (ai_vehicle_get_from_starting_location ledge_banshees_02/left) "banshee_d" (unit (player1))) FALSE))
	(unit_kill (unit (player1)))
)

;my horrible cutscene stuff
(global boolean cinematic_shooting_done FALSE)
(script command_script dervish_chase_01
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to fake_cinematics/p1)
	(cs_shoot TRUE (list_get (ai_actors heretic_leader_04) 0))
	(sleep 60)
	(cs_shoot FALSE (list_get (ai_actors heretic_leader_04) 0))
	(cs_go_to fake_cinematics/p0)
	(cs_face TRUE fake_cinematics/p4)
	(cs_crouch TRUE)
	(sleep_until (= cinematic_shooting_done TRUE))
;	(sleep 15)
	(cs_crouch FALSE)
	(cs_face FALSE fake_cinematics/p1)
	(cs_go_to_vehicle player0_fake_banshee)
	(cs_fly_to airspace3/p1 1)
)

;Heretic leader flies away
(script command_script hl_retreat_04
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_go_to_vehicle hl_fake_banshee)
;	(cs_vehicle_speed .5)
	(cs_fly_to airspace3/p3 2)
;	(cs_enable_targeting TRUE)
;	(cs_shoot TRUE)
;	(cs_shoot_point TRUE airspace3/p4)
	(cs_shoot TRUE (list_get (ai_actors dervish_01) 0))
	(cs_fly_to airspace3/p5 2)
;	(cs_shoot_point FALSE airspace3/p4)
	(cs_shoot FALSE (list_get (ai_actors dervish_01) 0))
	(cs_fly_by airspace3/p6 2)
;	(set cinematic_shooting_done TRUE)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost TRUE)
	(cs_fly_by airspace3/p8 5)
	(set cinematic_shooting_done TRUE)
	(cs_fly_by airspace3/p2 5)
	(cs_fly_to airspace3/p0 5)
	;(ai_erase heretic_leader_04)
)

;gives fake dervish the right weapon
(global boolean banshee_sin_01_ready FALSE)
(script static void banshee_sin_01_weapon
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\rifle\plasma_rifle\plasma_rifle.weapon")
			(= banshee_sin_01_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_01) 0)) rifle TRUE TRUE)
				(set banshee_sin_01_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\rifle\covenant_carbine\covenant_carbine.weapon")
			(= banshee_sin_01_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_01) 0)) carbine TRUE TRUE)
				(set banshee_sin_01_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\rifle\beam_rifle\beam_rifle.weapon")
			(= banshee_sin_01_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_01) 0)) sniper TRUE TRUE)
				(set banshee_sin_01_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\pistol\needler\needler.weapon")
			(= banshee_sin_01_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_01) 0)) needler TRUE TRUE)
				(set banshee_sin_01_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\pistol\plasma_pistol\plasma_pistol.weapon")
			(= banshee_sin_01_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_01) 0)) pistol TRUE TRUE)
				(set banshee_sin_01_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\support_high\flak_cannon\flak_cannon.weapon")
			(= banshee_sin_01_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_01) 0)) flak TRUE TRUE)
				(set banshee_sin_01_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\characters\sentinel_aggressor\weapons\beam\sentinel_aggressor_beam.weapon")
			(= banshee_sin_01_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_01) 0)) beam TRUE TRUE)
				(set banshee_sin_01_ready TRUE)
			)
	)
)

(script static void banshee_sin_01
	(camera_control on)
	(cinematic_start_movie "floodlab_banshee_1")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	(camera_set cam00 0)
	(set cinematic_shooting_done FALSE)
	(ai_erase heretic_leader_04)
	(device_operates_automatically_set hl_ledge_ext TRUE)
	(device_set_position hl_ledge_ext 1)
	(object_create_anew player0_fake_banshee)
	(object_create_anew player1_fake_banshee)
	(object_create_anew hl_fake_banshee)
			
	(fade_in 1 1 1 15)
	
	(ai_place heretic_leader_04)
	(cs_run_command_script heretic_leader_04 hl_retreat_04)
	(camera_set cam01 150)	
	(sleep 150)
	(ai_place dervish_01)
	(banshee_sin_01_weapon)
	(cs_run_command_script dervish_01 dervish_chase_01)
	(camera_set cam05 120)
	(sleep 120)
	(camera_set cam06 60)
	(sleep 60)
;	(camera_set cam07 30)
;	(sleep 30)
	
	(sleep_until (= cinematic_shooting_done TRUE))
;	(sleep 15)
;	(camera_set cam02 45)
	(camera_set cam02 0)
;	(sleep 15)
	(camera_set cam03 90)
	
	(sleep_until (= (unit_in_vehicle (unit (list_get (ai_actors dervish_01) 0))) TRUE))
	(camera_set cam04 120)
	(sleep 90)
	
	(fade_out 1 1 1 15)
	(sleep 20)
	
	(ai_erase dervish_01)
	(ai_erase heretic_leader_04)
	(device_operates_automatically_set hl_ledge_ext FALSE)
	(device_set_position_immediate hl_ledge_ext 0)
	
	(sleep_until
		(AND
			(= (ai_living_count heretic_leader_04) 0)
			(= (ai_living_count dervish_01) 0)
		)
	)
)

;Commander telling you where he's going
(script dormant dogfight2_commander
	(ai_dialogue_enable FALSE)
	(sleep 60)
	(print "SPEC-OPS COMMANDER: 'What lunacy! He'll never escape this maelstrom in a Banshee!'")
	(sleep (ai_play_line_on_object NONE 0790))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_0790_soc))
	(sleep 30)
	(print "SPEC-OPS COMMANDER: 'Wait! The hangar! There was a Seraph fighter inside! Arbiter, you know what to do!'")
	(sleep (ai_play_line_on_object NONE 1410))
	;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1410_soc))
	(sleep 30)
	(ai_dialogue_enable TRUE)
)

;gets banshees on you faster
(script command_script boost_test
	(cs_vehicle_boost TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot TRUE)
	(cs_enable_moving TRUE)
	(sleep_until (< (objects_distance_to_object (players) (ai_get_object ai_current_actor)) 20))
	;(sleep_until (= (ai_trigger_test "banshee_close" ai_current_actor) TRUE))
)

;Overall script for second dogfight
(script dormant dogfight_secondtime_start
	(sleep_until (= (volume_test_objects vol_power_core_ledge (players)) TRUE))
	(ai_disposable power_core_flood TRUE)
	(ai_disposable power_core_sentinels TRUE)
	(ai_disposable power_core_heretics TRUE)
	
	(cinematic_fade_to_white)

	(ai_erase_all)
	(object_teleport (player0) player0_hide)
	(object_teleport (player1) player1_hide)

	(if (cinematic_skip_start)
		(begin
			(banshee_sin_01)
		)
	)
	(cinematic_skip_stop)
	
	(sleep 2)
	(wake plummet_killer)
	(wake plummet_fl)
	(wake plummet_nl)
	(wake plummet_fr)
	(wake plummet_nr)
	
	(sleep 5)
	(if (game_is_cooperative)
		(begin
			(object_destroy player0_fake_banshee)
			(object_destroy player1_fake_banshee)
			(object_destroy hl_fake_banshee)
			(object_teleport (player0) banshee_player0)
			(object_teleport (player1) banshee_player1)
			(ai_place ledge_banshees_02/left)
			(ai_place ledge_banshees_02/right)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location ledge_banshees_02/left) "banshee_d" (player1))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d" (player0))
			(physics_set_gravity -4)
			(physics_set_velocity_frame 0 0 3)
			(wake banshee_killer_00)
			(wake banshee_killer_01)
		)
		(begin
			(object_destroy player0_fake_banshee)
			(object_destroy player1_fake_banshee)
			(object_destroy hl_fake_banshee)
			(sleep 2)
			(object_teleport (player0) banshee_player0)
			(sleep 2)
			(ai_place ledge_banshees_02/right)
			(sleep 2)
			(vehicle_load_magic (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d" (player0))
			(sleep 2)
			(physics_set_gravity -4)			
			(physics_set_velocity_frame 0 0 3)
			(wake banshee_killer_00)
		)
	)

	;(sound_looping_stop sound\ambience\alphagasgiant\interior_implode\interior_implode)
	;(sound_looping_start sound\ambience\alphagasgiant\falling_exterior\falling_exterior NONE 1)
	(device_operates_automatically_set control_room_ext FALSE)
	(device_operates_automatically_set lab_exit_ext FALSE)
	(device_operates_automatically_set arm_02_entry_ext FALSE)
	(ai_place dogfighters_init 2)
	(activate_team_nav_point_flag default_red player he_went_here 0)

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white)

	(data_mine_set_mission_segment "04b_17_dogfight")
	(game_save_immediate)
	(wake dogfight2_commander)

	(sleep_until
		(begin
			(begin_random
				(if 
					(AND
						(< (ai_living_count dogfighters) 2)
						(= (objects_can_see_flag (players) dogfight_1 45) FALSE) 
					)
						(ai_place dogfighters_finale/1)
				)
				(if 
					(AND
						(< (ai_living_count dogfighters) 2)
						(= (objects_can_see_flag (players) dogfight_2 45) FALSE) 
					)
						(ai_place dogfighters_finale/2)
				)
				(if 
					(AND
						(< (ai_living_count dogfighters) 2)
						(= (objects_can_see_flag (players) dogfight_3 45) FALSE) 
					)
						(ai_place dogfighters_finale/3)
				)
				(if 
					(AND
						(< (ai_living_count dogfighters) 2)
						(= (objects_can_see_flag (players) dogfight_4 45) FALSE) 
					)
						(ai_place dogfighters_finale/4)
				)
				(if 
					(AND
						(< (ai_living_count dogfighters) 2)
						(= (objects_can_see_flag (players) dogfight_5 45) FALSE) 
					)
						(ai_place dogfighters_finale/5)
				)
				(if 
					(AND
						(< (ai_living_count dogfighters) 2)
						(= (objects_can_see_flag (players) dogfight_6 45) FALSE) 
					)
						(ai_place dogfighters_finale/6)
				)
			)
			(OR
				(= (volume_test_objects vol_arm_01_return (players)) TRUE)
				(> (ai_spawn_count dogfighters_finale) 3)
			)
		)
	)
)

;-------------------------------------------------------------------------------
;Bottling Plant Return

;my ugliness part 2

(script command_script dervish_chase_02
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to airspace3/p7)
	(sleep 15)
	(object_create_anew player_fake_banshee)
	(object_damage_damage_section player_fake_banshee "main" 2)
	(ai_erase dervish_02)
)

(script command_script dervish_recovery
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_custom_animation objects\characters\elite\elite "climb:unarmed:detach" 0 TRUE)
	(sleep (unit_get_custom_animation_time (unit (ai_get_object ai_current_actor))))
	;(cs_stop_custom_animation)
	(unit_stop_custom_animation (unit (ai_get_object ai_current_actor)))
	(cs_crouch TRUE)
;	(sleep 45)
	(cs_move_in_direction 0 .5 0)
	(cs_go_to fake_cinematics/p2)
	(cs_face TRUE fake_cinematics/p3)
	(cs_crouch FALSE)
	(sleep_forever)
)

;gives fake dervish the right weapon
(global boolean banshee_sin_02_ready FALSE)
(script static void banshee_sin_02_weapon
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\rifle\plasma_rifle\plasma_rifle.weapon")
			(= banshee_sin_02_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_03) 0)) rifle TRUE TRUE)
				(set banshee_sin_02_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\rifle\covenant_carbine\covenant_carbine.weapon")
			(= banshee_sin_02_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_03) 0)) carbine TRUE TRUE)
				(set banshee_sin_02_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\rifle\beam_rifle\beam_rifle.weapon")
			(= banshee_sin_02_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_03) 0)) sniper TRUE TRUE)
				(set banshee_sin_02_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\pistol\needler\needler.weapon")
			(= banshee_sin_02_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_03) 0)) needler TRUE TRUE)
				(set banshee_sin_02_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\pistol\plasma_pistol\plasma_pistol.weapon")
			(= banshee_sin_02_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_03) 0)) pistol TRUE TRUE)
				(set banshee_sin_02_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\weapons\support_high\flak_cannon\flak_cannon.weapon")
			(= banshee_sin_02_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_03) 0)) flak TRUE TRUE)
				(set banshee_sin_02_ready TRUE)
			)
	)
	(if 
		(AND
			(unit_has_weapon (unit (player0)) "objects\characters\sentinel_aggressor\weapons\beam\sentinel_aggressor_beam.weapon")
			(= banshee_sin_02_ready FALSE)
		)
			(begin
				(unit_add_equipment (unit (list_get (ai_actors dervish_03) 0)) beam TRUE TRUE)
				(set banshee_sin_02_ready TRUE)
			)
	)
)

(script static void banshee_sin_02
	(camera_control on)
	(cinematic_start_movie "floodlab_banshee_2")
	(cinematic_start)
	(set cinematic_letterbox_style 1)
	(camera_set_field_of_view 60 0)
	(camera_set end00 0)
	(device_set_position_immediate banshee_ledge_access_01 1)
	(object_create_containing "banshee_gas_0")
	(ai_place dervish_02)
	(cs_run_command_script dervish_02 dervish_chase_02)

	(fade_in 1 1 1 15)
	(camera_set end01 120)
	
	(sleep_until (= (ai_living_count dervish_02) 0))
	(sleep 60)
	(ai_place dervish_03)
	(banshee_sin_02_weapon)
	(object_hide (list_get (ai_actors dervish_03) 0) TRUE)
	(object_teleport (list_get (ai_actors dervish_03) 0) dervish_sticks_landing)
	(cs_run_command_script dervish_03 dervish_recovery)
	(sleep 5)
	(object_hide (list_get (ai_actors dervish_03) 0) FALSE)
	;(device_operates_automatically_set banshee_ledge_access_01 TRUE)

	(camera_set end02 60)
	(sleep 60)			
	(camera_set end03 60)
	(sleep 60)			
	(camera_set end04 60)
	(sleep 60)			
	
	(fade_out 1 1 1 15)
	(sleep 20)
	
	(ai_erase dervish_03)
	(device_set_position_immediate banshee_ledge_access_01 0)
)

;9/12

;respawns sentinels once
(script dormant bottling_return_s_respawner
	(sleep_until (< (ai_living_count bottling_return_sentinels_03) 2))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_sentinels_03 1)
	)
	(sleep (random_range 5 45))

	(sleep_until (< (ai_living_count bottling_return_sentinels_03) 2))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_sentinels_03 1)
	)
	(sleep (random_range 5 45))

	(sleep_until (< (ai_living_count bottling_return_sentinels_03) 2))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_sentinels_03 1)
	)
)

;respawns combatforms once
(script dormant bottling_return_cf_respawner
	(sleep_until (< (ai_nonswarm_count bottling_return_combatforms_03) 2))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_combatforms_04 1)
	)
	(sleep (random_range 5 45))

	(sleep_until (< (ai_nonswarm_count bottling_return_combatforms_03) 2))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_combatforms_04 1)
	)
	(sleep (random_range 5 45))

	(sleep_until (< (ai_nonswarm_count bottling_return_combatforms_03) 2))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_combatforms_04 1)
	)
)

;respawns carriers once
(script dormant bottling_return_ca_respawner
	(sleep_until (< (ai_nonswarm_count bottling_return_carriers_03) 1))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_carriers_04 1)
	)
	(sleep (random_range 5 45))

	(sleep_until (< (ai_nonswarm_count bottling_return_carriers_03) 1))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_carriers_04 1)
	)
	(sleep (random_range 5 45))

	(sleep_until (< (ai_nonswarm_count bottling_return_carriers_03) 1))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_carriers_04 1)
	)
)

;Commander update
(script dormant bottling_return_commander
	(sleep_until (= (volume_test_objects vol_bottling_enter (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_bottling_enter (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "SPEC-OPS COMMANDER: 'The Heretic-Leader has already landed! Up to the hangar, Arbiter! Quickly now!'")
				(sleep (ai_play_line_on_object NONE 1420))
				;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1420_soc))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

(script dormant bottling_fx_01
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 175) 20))
			(begin_random
				(begin
					(effect_new gasleak 174)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 175)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 176)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 177)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 178)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 179)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 180)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 181)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 182)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 183)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 184)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 174)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 175)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 176)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 177)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 178)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 179)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 180)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 181)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 182)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 183)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 184)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant bottling_fx_02
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 197) 20))
			(begin_random
				(begin
					(effect_new gasleak 185)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 186)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 187)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 188)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 189)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 190)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 191)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 192)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 193)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 194)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 195)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 196)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 197)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 198)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 185)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 186)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 187)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 188)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 189)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 190)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 191)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 192)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 193)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 194)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 195)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 196)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 197)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 198)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant bottling_fx_03
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 201) 20))
			(begin_random
				(begin
					(effect_new gasleak 199)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 200)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 201)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 202)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 203)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 204)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 205)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 206)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 207)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 208)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 209)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 210)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 211)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 212)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 199)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 200)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 201)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 202)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 203)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 204)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 205)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 206)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 207)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 208)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 209)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 210)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 211)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 212)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant bottling_fx_04
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 227) 20))
			(begin_random
				(begin
					(effect_new gasleak 213)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 214)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 215)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 216)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 217)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 218)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 219)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 220)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 221)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 222)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 223)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 224)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 225)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 226)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 227)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 213)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 214)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 215)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 216)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 217)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 218)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 219)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 220)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 221)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 222)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 223)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 224)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 225)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 226)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 227)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant bottling_fx_05
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 242) 20))
			(begin_random
				(begin
					(effect_new gasleak 228)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 229)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 230)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 231)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 232)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 233)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 234)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 235)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 236)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 237)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 238)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 239)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 240)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 241)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 242)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 228)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 229)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 230)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 231)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 232)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 233)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 234)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 235)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 236)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 237)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 238)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 239)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 240)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 241)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 242)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)

(script command_script panic_bottling
	(cs_ignore_obstacles TRUE)
	(cs_enable_moving TRUE)
	(cs_movement_mode 3)
	(sleep_until (= (volume_test_object vol_bottling_enter (ai_get_object ai_current_actor)) TRUE))
)

;Overall script for bottling plant return
(script dormant bottling_secondtime_start
	(ai_disposable dogfighters TRUE)
	(cinematic_fade_to_white)

	(ai_erase_all)
	(if (game_is_cooperative)
		(begin
			(sleep_forever banshee_killer_00)
			(sleep_forever banshee_killer_01)
			(physics_set_gravity 1.0)
			(physics_set_velocity_frame 0 0 0)
			(vehicle_unload (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d")
			(vehicle_unload (ai_vehicle_get_from_starting_location ledge_banshees_02/left) "banshee_d")
			(object_teleport (player0) player0_hide)
			(object_teleport (player1) player1_hide)
			(object_destroy (ai_vehicle_get_from_starting_location ledge_banshees_02/right))			
			(object_destroy (ai_vehicle_get_from_starting_location ledge_banshees_02/left))			
		)
		(begin
			(sleep_forever banshee_killer_00)
			(physics_set_gravity 1.0)
			(physics_set_velocity_frame 0 0 0)
			(vehicle_unload (ai_vehicle_get_from_starting_location ledge_banshees_02/right) "banshee_d")
			(object_teleport (player0) player0_hide)
			(object_destroy (ai_vehicle_get_from_starting_location ledge_banshees_02/right))			
		)
	)

	(if (cinematic_skip_start)
		(begin
			(banshee_sin_02)
		)
	)
	(cinematic_skip_stop)

	(sleep 2)
	(device_operates_automatically_set banshee_ledge_access_01 FALSE)
	(device_set_position_immediate banshee_ledge_access_01 0)
	(deactivate_team_nav_point_flag player he_went_here)
	;(sound_looping_start sound\ambience\alphagasgiant\interior_implode\interior_implode NONE 1)
	;(sound_looping_stop sound\ambience\alphagasgiant\falling_exterior\falling_exterior)
	(object_destroy_containing "banshee_gas_0")

	(object_teleport (player0) bottling_return_player0)
	(object_teleport (player1) bottling_return_player1)
	
	(wake bottling_fx_01)
	(wake bottling_fx_02)
	(wake bottling_fx_03)
	(wake bottling_fx_04)
	(wake bottling_fx_05)

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white)

	(data_mine_set_mission_segment "04b_18_bottling_return_01")
	(game_save_immediate)
	
	(wake 04b_title2)
	
	(ai_place bottling_return_sentinels_01 2)
	(ai_place bottling_return_flood_01 4)
	(wake bottling_return_commander)
	
	(sleep_until 
		(AND
			(= (volume_test_objects vol_bottling_return_01r (players)) FALSE)
			(> (player_count) 0)
		)
	)
	(ai_place bait_bottling_01 1)
	;(cs_run_command_script bait_bottling_01 panic_bottling)
	
	(sleep_until 
		(OR 
			(< (ai_nonswarm_count bottling_return_flood_01) 2) 
			(= (volume_test_objects vol_bottling_return_02 (players)) TRUE)
		)
	)
	(game_save)

;9/12

	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_combatforms_02 (- 3 (ai_nonswarm_count bottling_return_flood_01)))
	)
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_carriers_02 3)
	)
	
	(sleep_until (= (volume_test_objects vol_bottling_mid03 (players)) TRUE))
	(data_mine_set_mission_segment "04b_19_bottling_return_02")
	(game_save)
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_sentinels_02 3)
	)
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_combatforms_03 3)
	)
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bottling_return_carriers_03 2)
	)
	(wake bottling_return_s_respawner)
	(wake bottling_return_cf_respawner)
	(wake bottling_return_ca_respawner)

	(sleep_until (= (volume_test_objects vol_bottling_mid02 (players)) TRUE))
	(if (< (ai_living_count bottling_plant_enemies) 8)
		(ai_place bait_bottling_02 1)
	)
	;(cs_run_command_script bait_bottling_02 panic_bottling)
	
	(sleep_until 
		(OR
			(= (structure_bsp_index) 5)
			(AND
				(= (ai_nonswarm_count bottling_return_flood) 0)
				(= (ai_nonswarm_count bottling_return_flood) 0)
			)
		)
	)
	(game_save)
	
	(sleep_until (= (structure_bsp_index) 5))
	(sleep_forever bottling_return_s_respawner)
	(sleep_forever bottling_return_cf_respawner)
	(sleep_forever bottling_return_ca_respawner)
)

;-------------------------------------------------------------------------------
;Corridors to Under Hangar Return

(script dormant halls_up_01
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 7) 20))
			(begin_random
				(begin
					(effect_new gasleak 1)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 2)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 3)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 4)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 5)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 6)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 7)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 8)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 9)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 1)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 2)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 3)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 4)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 5)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 6)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 7)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 8)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 9)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant halls_up_02
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 19) 20))
			(begin_random
				(begin
					(effect_new gasleak 10)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 11)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 12)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 13)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 14)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 15)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 16)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 17)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 18)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 19)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 20)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 21)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 22)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 23)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 10)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 11)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 12)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 13)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 14)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 15)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 16)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 17)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 18)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 19)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 20)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 21)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 22)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 23)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant halls_up_03
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 24) 20))
			(begin_random
				(begin
					(effect_new gasleak 24)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 25)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 26)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 27)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 28)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 29)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 30)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 31)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 32)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 33)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 34)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 35)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 36)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 37)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 38)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 24)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 25)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 26)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 27)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 28)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 29)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 30)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 31)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 32)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 33)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 34)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 35)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 36)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 37)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 38)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant halls_up_04
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 47) 20))
			(begin_random
				(begin
					(effect_new gasleak 39)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 40)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 41)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 42)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 43)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 44)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 45)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 46)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 47)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 48)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 49)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 50)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 51)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 52)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 53)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 39)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 40)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 41)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 42)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 43)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 44)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 45)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 46)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 47)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 48)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 49)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 50)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 51)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 52)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 53)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant halls_up_05
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 58) 20))
			(begin_random
				(begin
					(effect_new gasleak 54)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 55)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 56)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 57)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 58)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 59)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 60)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 61)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 62)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 63)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 64)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 65)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 66)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 67)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 68)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 54)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 55)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 56)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 57)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 58)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 59)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 60)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 61)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 62)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 63)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 64)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 65)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 66)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 67)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 68)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant halls_up_06
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 69) 20))
			(begin_random
				(begin
					(effect_new gasleak 69)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 70)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 72)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 73)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 74)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 75)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 76)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 77)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 78)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 79)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 80)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 81)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 82)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 83)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 69)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 70)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 71)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 72)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 73)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 74)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 75)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 76)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 77)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 78)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 79)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 80)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 81)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 82)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 83)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 84)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant halls_up_07
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 85) 20))
			(begin_random
				(begin
					(effect_new gasleak 85)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 86)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 87)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 88)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 89)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 90)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 92)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 93)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 94)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 95)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 96)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 98)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 99)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 100)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 85)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 86)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 87)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 88)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 89)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 90)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 91)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 92)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 93)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 94)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 95)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 96)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 97)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 98)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 99)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 100)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)

(script command_script panic_halls
	(cs_enable_moving TRUE)
	(cs_movement_mode 3)
	(sleep_until (= (volume_test_object vol_bottling_enter (ai_get_object ai_current_actor)) TRUE))
)

;Overall script for halls to underhangar from bottling plant
(script dormant to_underhangar_secondtime
	(sleep_until (= (volume_test_objects vol_bottling_enter (players)) TRUE))
	(ai_disposable bottling_return_flood TRUE)
	(ai_disposable bottling_return_sentinels TRUE)
	(wake music_04b_08_start)
	(wake halls_up_01)
	(wake halls_up_02)
	(wake halls_up_03)
	(wake halls_up_04)
	(wake halls_up_05)
	(wake halls_up_06)
	(wake halls_up_07)

	(sleep_until (= (structure_bsp_index) 5))
	(data_mine_set_mission_segment "04b_20_halls_to_under_01")
	(game_save)
	(ai_place second_hall_infection_01 4)
	(ai_place bait_hall_01 1)
	;(cs_run_command_script bait_hall_01 panic_halls)
	
	(sleep_until 
		(begin
			(sleep_until (= (volume_test_objects vol_2nd_hall_02 (players)) TRUE) 30 150)
			(if 
				(AND
					(< (ai_nonswarm_count second_hall_flood) 2)
					(= (device_get_position hall2_spawn_01) 0)
					(= (volume_test_objects vol_hall2_spawn_01 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place second_hall_flood_01 1)			
			)
			(OR
				(= (volume_test_objects vol_2nd_hall_02 (players)) TRUE)
				(= (ai_spawn_count second_hall_flood_01) 4)
			)
		)
	)
	(data_mine_set_mission_segment "04b_21_halls_to_under_02")
	(game_save)
	(ai_place second_hall_carriers 2)
	(ai_place bait_hall_02 1)
	;(cs_run_command_script bait_hall_02 panic_halls)

	(sleep_until 
		(begin
			(sleep_until (= (volume_test_objects vol_2nd_hall_01 (players)) TRUE) 30 150)
			(if 
				(AND
					(< (ai_nonswarm_count second_hall_flood) 2)
					(= (device_get_position hall2_spawn_02) 0)
					(= (volume_test_objects vol_hall2_spawn_02 (players)) FALSE)
					(> (player_count) 0)
				)	
					(ai_place second_hall_flood_02 1)			
			)
			(OR
				(= (volume_test_objects vol_2nd_hall_01 (players)) TRUE)
				(= (ai_spawn_count second_hall_flood_02) 4)
			)
		)
	)
	
	(sleep_until (= (volume_test_objects vol_2nd_hall_01 (players)) TRUE))
	(wake music_04b_08_start_alt)
	
	(data_mine_set_mission_segment "04b_22_halls_to_under_03")
	(game_save)
;	(ai_place second_hall_infection_02 5)
	(ai_place bait_hall_03 1)
	;(cs_run_command_script bait_hall_03 panic_halls)

	(sleep_until 
		(begin
			(sleep_until (= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE) 30 150)
			(if 
				(AND
					(< (ai_nonswarm_count second_hall_flood) 2)
					(= (device_get_position hall2_spawn_03) 0)
					(= (volume_test_objects vol_hall2_spawn_03 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place second_hall_flood_03 1)			
			)
			(OR
				(= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE)
				(= (ai_spawn_count second_hall_flood_03) 4)
			)
		)
	)
)

;-------------------------------------------------------------------------------
;Under Hangar Return

(script dormant underhangar_fx_01
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 251) 20))
			(begin_random
				(begin
					(effect_new gasleak 243)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 244)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 245)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 246)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 247)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 248)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 249)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 250)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 251)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 252)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 253)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 254)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 243)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 244)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 245)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 246)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 247)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 248)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 249)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 250)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 251)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 252)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 253)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 254)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)
(script dormant underhangar_fx_02
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 255) 20))
			(begin_random
				(begin
					(effect_new gasleak 255)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 256)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 257)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 258)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 259)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 260)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 261)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 262)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 263)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 264)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 265)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 266)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 267)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 268)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 269)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 255)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 256)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 257)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 258)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 259)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 260)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 261)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 262)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 263)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 264)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 265)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 266)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 267)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 268)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 269)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)

;Final commander update
(script dormant underhangar_return_commander
	(sleep_until (= (volume_test_objects vol_underhangar_from_top (players)) TRUE) 30 8000)
	(if 
		(AND
			(= (volume_test_objects vol_underhangar_from_top (players)) FALSE)
			(> (player_count) 0)
		)
			(begin
				(ai_dialogue_enable FALSE)
				(sleep 60)
				(print "SPEC-OPS COMMANDER: 'You're almost there!  Keep going!'")
				(sleep (ai_play_line_on_object NONE 1430))
				;(sleep (sound_impulse_language_time sound\dialog\levels\04_gasgiant\mission\l04_1430_soc))
				(sleep 30)
				(ai_dialogue_enable TRUE)
			)
	)
)

;Overall script for underhangar return
(script dormant underhangar_secondtime_start
	(sleep_until (= (volume_test_objects vol_underhangar_from_bottom (players)) TRUE))
	(ai_disposable second_hall_flood TRUE)
	(data_mine_set_mission_segment "04b_23_underhangar_return")
	(game_save)
	(wake underhangar_return_commander)
	(wake underhangar_fx_01)
	(wake underhangar_fx_02)
	
	(ai_place underhangar_heretics_01 1)
	(ai_place underhangar_h_grunts_01 2)
	(ai_place underhangar_heretics_02 1)
	(ai_place underhangar_heretics_03 1)
	
	(ai_place underhangar_carriers_02 1)
	(ai_place underhangar_carriers_init 1)
	(ai_place underhangar_combatforms_init 2)

	(sleep_until (= (volume_test_objects vol_underhangar_music (players)) TRUE))
	(wake music_04b_08_stop)
	
	(sleep_until
		(begin
			(if 
				(AND
					(< (ai_nonswarm_count underhangar_carriers_02) 1)
					(= (device_get_position underhangar_spawn_02) 0)
					(= (volume_test_objects vol_underhangar_spawn_02 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place underhangar_carriers_02 1)
 			)
			(if 
				(AND
					(< (ai_nonswarm_count underhangar_return_flood) 2)
					(= (device_get_position underhangar_spawn_01) 0)
					(= (volume_test_objects vol_underhangar_spawn_01 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place underhangar_return_flood_01 1)
 			)
			(if 
				(AND
					(< (ai_nonswarm_count underhangar_return_flood) 2)
					(= (volume_test_objects vol_underhangar_shaft_01 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place underhangar_return_flood_02 1)
 			)
			(if 
				(AND
					(< (ai_nonswarm_count underhangar_return_flood) 2)
					(= (volume_test_objects vol_underhangar_shaft_02 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place underhangar_return_flood_03 1)
 			)
 					
			(OR
				(= (volume_test_objects vol_underhangar_return_01 (players)) TRUE)
				(<= (ai_strength underhangar_heretics_01) .25)
				(= (ai_spawn_count underhangar_return_flood) 20)
			)
		)
	)
	(game_save)
	(ai_place underhangar_h_grunts_02 (- 2 (ai_living_count underhangar_h_grunts_01)))
	
	(sleep_until
		(begin
			(if 
				(AND
					(< (ai_nonswarm_count underhangar_return_flood) 2)
					(= (device_get_position underhangar_spawn_02) 0)
					(= (volume_test_objects vol_underhangar_spawn_02 (players)) FALSE)
					(> (player_count) 0)
				)
					(ai_place underhangar_return_flood_04 1)
 			)
			(OR
				(= (volume_test_objects vol_underhangar_return_02 (players)) TRUE)
				(= (ai_living_count underhangar_heretics_02) 0)
				(= (ai_spawn_count underhangar_return_flood_04) 20)
			)
		)
	)
	(game_save)
	(ai_place underhangar_heretics_03 (- 2 (ai_living_count underhangar_return_heretics)))
	(ai_place underhangar_h_grunts_03 (- 2 (ai_living_count underhangar_h_grunts_02)))
)

;-------------------------------------------------------------------------------
;Corridors to Hangar Return

(script dormant other_hall_fx
	(sleep_until
		(begin
			(sleep_until (< (objects_distance_to_flag (players) 270) 20))
			(begin_random
				(begin
					(effect_new gasleak 270)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 271)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 272)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 273)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 274)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 275)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 276)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 277)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 278)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 279)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 280)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 281)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 282)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 283)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new gasleak 284)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 270)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 271)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 272)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 273)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 274)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 275)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 276)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 277)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 278)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 279)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 280)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 281)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 282)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 283)
					(sleep (random_range 5 30))
				)
				(begin
					(effect_new boom 284)
					(sleep (random_range 5 30))
				)
			)
			FALSE
		)
	)
)

;Overall script for halls from underhangar back to hangar
(script dormant to_hangar_secondtime
	(sleep_until (= (volume_test_objects vol_underhangar_from_top (players)) TRUE))
	(ai_disposable underhangar_return_flood TRUE)
	(ai_disposable underhangar_return_heretics TRUE)
	(wake other_hall_fx)
;9/12
;	(game_save)
)

;-------------------------------------------------------------------------------
;Hangar Return Boss Battle

(script dormant hangar_fx
	(sleep_until
		(begin
			(begin_random
				(begin_random
					(begin
						(effect_new big_boom 294)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 295)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 285)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 286)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 306)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 307)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 289)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 290)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 285)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 288)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 307)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 308)
						(sleep (random_range 5 30))
					)
				)
				(begin_random
					(begin
						(effect_new big_boom 291)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 292)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 293)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 303)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 304)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 294)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 295)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 296)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 291)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 292)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 293)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 294)
						(sleep (random_range 5 30))
					)
				)
				(begin_random
					(begin
						(effect_new big_boom 297)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 298)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 299)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 300)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 301)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 302)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 289)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 290)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 299)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 286)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 287)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 300)
						(sleep (random_range 5 30))
					)
				)
				(begin_random
					(begin
						(effect_new big_boom 303)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 304)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 305)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 297)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 298)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 308)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 287)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new big_boom 288)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 303)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 304)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 305)
						(sleep (random_range 5 30))
					)
					(begin
						(effect_new boom 306)
						(sleep (random_range 5 30))
					)
				)
			)
			FALSE
		)
	)
)

(script command_script hack
	(cs_enable_moving TRUE)
	(cs_set_behavior guard)
	(sleep_forever)
)

(global boolean monitor_done_talking TRUE)
(global boolean monitor_available TRUE)
(global boolean boss_done_talking TRUE)

;Heretic leader boss mission dialogue
(script command_script hl_boss_chat_01
	(set boss_done_talking FALSE)
	(sleep_until (= monitor_done_talking TRUE))
	(cs_suppress_dialogue_global TRUE)
	(sleep 60)
	(print "HERETIC LEADER: 'How did the Prophets buy your loyalty, Arbiter?'")
	(cs_play_line 0800)
	(sleep 15)
	(print "HERETIC LEADER: 'With a new command? A new fleet?'")
	(cs_play_line 0810)
	(sleep 30)
	(print "HERETIC LEADER: 'Or was it the promise? Their Great Journey!'")
	(cs_play_line 0820)
	(cs_suppress_dialogue_global FALSE)
	(set boss_done_talking TRUE)
)
(script command_script hl_boss_chat_02
	(set boss_done_talking FALSE)
	(sleep_until (= monitor_done_talking TRUE))
	(cs_suppress_dialogue_global TRUE)
	(sleep 60)
	(print "HERETIC LEADER: 'Look around you, Arbiter…'")
	(cs_play_line 0830)
	(sleep 15)
	(print "HERETIC LEADER: 'This facility, and dozens like it, devoted to the study of the Parasite!'")
	(cs_play_line 0840)
	(sleep 15)
	(print "HERETIC LEADER: 'But where are the weapons, Arbiter?  What was the result?'")
	(cs_play_line 0850)
	(sleep 30)
	(print "HERETIC LEADER: 'All that time and effort, and the best the Forerunners could do was put these foul creatures on ice!'")
	(cs_play_line 0860)
	(cs_suppress_dialogue_global FALSE)
	(set boss_done_talking TRUE)
)
(script command_script hl_boss_chat_03
	(set boss_done_talking FALSE)
	(sleep_until (= monitor_done_talking TRUE))
	(cs_suppress_dialogue_global TRUE)
	(sleep 60)
	(print "HERETIC LEADER: 'And now, where are these gods the Prophets would have us worship?'")
	(cs_play_line 0870)
	(sleep 30)
	(print "HERETIC LEADER: 'Transcended? (laughs) Hardly.'")
	(cs_play_line 0880)
	(sleep 60)
	(print "HERETIC LEADER: 'Come, Arbiter. Let me show you where they went!'")
	(cs_play_line 0890)
	(cs_suppress_dialogue_global FALSE)
	(set boss_done_talking TRUE)
)

;Monitor mission dialogue
(script command_script monitor_chat_01
	(set monitor_available FALSE)
	(set monitor_done_talking FALSE)
	(cs_suppress_dialogue_global TRUE)
	(cs_switch monitor)
	(sleep 60)
	(cs_start_approach_player 3 50 50)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(print "343 GUILTY SPARK: 'This mining-facility predates Instalation Alpha by several hundred years.'")
	(cs_play_line 0900)
	(print "343 GUILTY SPARK: 'It was retrofitted to research possible offensive and defensive measures against the Flood.'")
	(cs_play_line 0910)
	(print "343 GUILTY SPARK: 'Indeed, I designed and oversaw the construction of this facilitiy's various outbreak management systems.'")
	(cs_play_line 0920)
	(cs_approach_stop)
	(cs_suppress_dialogue_global FALSE)
	(set monitor_done_talking TRUE)
	(set monitor_available TRUE)
)
(script command_script monitor_chat_02
	(set monitor_available FALSE)
	(set monitor_done_talking FALSE)
	(cs_suppress_dialogue_global TRUE)
	(cs_switch monitor)
	(sleep 60)
	(cs_start_approach_player 3 50 50) 
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(print "343 GUILTY SPARK: 'The tether connecting the mine to the high-altitude suspension-grid was the primary failsafe.'")
	(cs_play_line 0930)
	(print "343 GUILTY SPARK: 'I'm glad that someone was aware of the necessary protocols and severed the tether locally.'")
	(cs_play_line 0940)
	(cs_approach_stop)
	(cs_suppress_dialogue_global FALSE)
	(set monitor_done_talking TRUE)
	(set monitor_available TRUE)
)
(script command_script monitor_chat_03
	(set monitor_available FALSE)
	(set monitor_done_talking FALSE)
	(cs_suppress_dialogue_global TRUE)
	(cs_switch monitor)
	(sleep 60)
	(cs_start_approach_player 3 50 50) 
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(print "343 GUILTY SPARK: 'The Flood will not survive once this mine descends into the liquid hydrogen core of the planet.'")
	(cs_play_line 0950)
	(sleep 15)
	(print "343 GUILTY SPARK: 'Then again, neither will we. What a pity.'")
	(cs_play_line 0960)
	(cs_approach_stop)
	(cs_suppress_dialogue_global FALSE)
	(set monitor_done_talking TRUE)
	(set monitor_available TRUE)
)

(script dormant monitor_chatting
	(sleep 1800)
	(sleep_until (= boss_done_talking TRUE))
	(cs_run_command_script monitor monitor_chat_01)
	
	(sleep_until (= monitor_done_talking TRUE))
	(sleep 3600)
	
	(sleep_until (= boss_done_talking TRUE))
	(cs_run_command_script monitor monitor_chat_02)

	(sleep_until (= monitor_done_talking TRUE))
	(sleep 3600)
	
	(sleep_until (= boss_done_talking TRUE))
	(cs_run_command_script monitor monitor_chat_03)
)

(script command_script monitor_flit_01
	(cs_fly_to monitor_wander/p0)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_02
	(cs_fly_to monitor_wander/p1)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_03
	(cs_fly_to monitor_wander/p2)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_04
	(cs_fly_to monitor_wander/p3)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_05
	(cs_fly_to monitor_wander/p4)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_06
	(cs_fly_to monitor_wander/p5)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_07
	(cs_fly_to monitor_wander/p6)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_08
	(cs_fly_to monitor_wander/p7)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_09
	(cs_fly_to monitor_wander/p8)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_10
	(cs_fly_to monitor_wander/p9)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_11
	(cs_fly_to monitor_wander/p10)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_12
	(cs_fly_to monitor_wander/p11)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_13
	(cs_fly_to monitor_wander/p12)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_14
	(cs_fly_to monitor_wander/p13)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_15
	(cs_fly_to monitor_wander/p14)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_16
	(cs_fly_to monitor_wander/p15)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_17
	(cs_fly_to monitor_wander/p16)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_18
	(cs_fly_to monitor_wander/p17)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_19
	(cs_fly_to monitor_wander/p18)
	(set monitor_available TRUE)
)
(script command_script monitor_flit_20
	(cs_fly_to monitor_wander/p19)
	(set monitor_available TRUE)
)

(script dormant monitor_flitting
	(sleep_until
		(begin
			(begin_random
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_01)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_02)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_03)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_04)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_05)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_06)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_07)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_08)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_09)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_10)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_11)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_12)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_13)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_14)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_15)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_16)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_17)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_18)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_19)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
				(if (= monitor_available TRUE)
					(begin
						(cs_run_command_script monitor monitor_flit_20)
						(sleep 5)
						(sleep_until (= monitor_available TRUE))
					)
				)
			)
			FALSE
		)
	)
)

(global boolean final_hl_boss_dead FALSE)
(global object heretic_leader none)

(global boolean more_hl_orders FALSE)
(global boolean more_holo1_orders FALSE)
(global boolean more_holo2_orders FALSE)

;9/11
;*
(global short boss_fight_f_total 0)
(global short boss_fight_s_total 0)

(script dormant boss_fight_cf_spawner_01
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count boss_fight_combatforms) 2))
			(ai_place boss_fight_combatforms 1)
			(set boss_fight_f_total (+ boss_fight_f_total 1))
			(= final_hl_boss_dead TRUE)
		)
	)
)
(script dormant boss_fight_s_spawner_01
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count boss_fight_sentinels) 3))
			(ai_place boss_fight_sentinels 1)
			(set boss_fight_s_total (+ boss_fight_s_total 1))
			(= final_hl_boss_dead TRUE)
		)
	)
)

(script dormant boss_fight_cf_spawner_02
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count boss_fight_combatforms) 3))
			(ai_place boss_fight_combatforms 1)
			(set boss_fight_f_total (+ boss_fight_f_total 1))
			(= final_hl_boss_dead TRUE)
		)
	)
)
(script dormant boss_fight_s_spawner_02
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count boss_fight_sentinels) 2))
			(ai_place boss_fight_sentinels 1)
			(set boss_fight_s_total (+ boss_fight_s_total 1))
			(= final_hl_boss_dead TRUE)
		)
	)
)

(script dormant boss_fight_cf_spawner_03
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count boss_fight_combatforms) 4))
			(ai_place boss_fight_combatforms 1)
			(set boss_fight_f_total (+ boss_fight_f_total 1))
			(= final_hl_boss_dead TRUE)
		)
	)
)
(script dormant boss_fight_s_spawner_03
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count boss_fight_sentinels) 1))
			(ai_place boss_fight_sentinels 1)
			(set boss_fight_s_total (+ boss_fight_s_total 1))
			(= final_hl_boss_dead TRUE)
		)
	)
)

(script dormant boss_fight_cf_hobbled
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count boss_fight_combatforms) 2))
			(ai_place boss_fight_combatforms 1)
			(set boss_fight_f_total (+ boss_fight_f_total 1))
			(= final_hl_boss_dead TRUE)
		)
	)
)
(script dormant boss_fight_s_hobbled
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count boss_fight_sentinels) 2))
			(ai_place boss_fight_sentinels 1)
			(set boss_fight_s_total (+ boss_fight_s_total 1))
			(= final_hl_boss_dead TRUE)
		)
	)
)
*;

(script static void boss_fight_deletion
	(sleep_until
		(OR
			(= (volume_test_objects vol_boss_delete_R (ai_actors hl_boss_random)) TRUE)
			(= (volume_test_objects vol_boss_delete_L (ai_actors hl_boss_random)) TRUE)
			(= (volume_test_objects vol_boss_delete_c1 (ai_actors hl_boss_random)) TRUE)
			(= (volume_test_objects vol_boss_delete_c2 (ai_actors hl_boss_random)) TRUE)
		)
	30 900)
	(if
		(AND
			(= (volume_test_objects vol_boss_delete_R (ai_actors hl_boss_random)) FALSE)
			(= (volume_test_objects vol_boss_delete_L (ai_actors hl_boss_random)) FALSE)
			(= (volume_test_objects vol_boss_delete_c1 (ai_actors hl_boss_random)) FALSE)
			(= (volume_test_objects vol_boss_delete_c2 (ai_actors hl_boss_random)) FALSE)
		)
			(begin
				(effect_new_on_object_marker "effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_death" (list_get (ai_actors hl_boss_random) 0) "")
				(object_set_scale (list_get (ai_actors hl_boss_random) 0) .1 30)
				(sleep 30)
			)
	)
	(ai_erase hl_boss_random)
)

(global object holo1 none)
(global object holo2 none)
(global object holo3 none)
(global object holo4 none)
(global effect holo_death "effects\scenarios\objects\solo\alphagasgiant\holo_drone\drone_death")
(global boolean holo_drones_nuke FALSE)

(script dormant holo1_deleteme
	(sleep_until
		(begin
			(sleep_until 
				(OR
					(= (ai_living_count hl_boss_holo_random_01) 0)
					(= holo_drones_nuke TRUE)
				)
			)
			(object_set_scale holo1 .1 30)
			(effect_new_on_object_marker holo_death holo1 "body")
			(sleep 15)
			(object_destroy holo1)
			FALSE
		)
	)
)
(script dormant holo2_deleteme
	(sleep_until (= (ai_living_count hl_boss_holo_random_01) 1))
	(object_set_scale holo2 .1 30)
	(effect_new_on_object_marker holo_death holo2 "body")
	(sleep 15)
	(object_destroy holo2)
)
(script dormant holo3_deleteme
	(sleep_until (= (ai_living_count hl_boss_holo_random_03) 2))
	(object_set_scale holo3 .1 30)
	(effect_new_on_object_marker holo_death holo3 "body")
	(sleep 15)
	(object_destroy holo3)
)
(script dormant holo4_deleteme
	(sleep_until (= (ai_living_count hl_boss_holo_random_01) 3))
	(object_set_scale holo4 .1 30)
	(effect_new_on_object_marker holo_death holo4 "body")
	(sleep 15)
	(object_destroy holo4)
)

(global short hl_times_dead 0)
(global short hl_lives_total 0)
(global short hl_drone_total 2)

(script static void hl_respawner
	(if (difficulty_legendary)
		(set hl_lives_total 3)
	)
	(if (difficulty_heroic)
		(set hl_lives_total 1)
	)

	(sleep_until
		(begin
			(sleep_until (<= (object_get_shield (list_get (ai_actors hl_boss_random) 0)) 0))
			(if (< hl_times_dead hl_lives_total)
				(begin
					(ai_set_orders hl_boss_random hole_up)
					(cs_run_command_script hl_boss_random hack)
					(ai_kill holo_drones)
					(boss_fight_deletion)
					(set hl_times_dead (+ hl_times_dead 1))
		
			;		(sleep_until (= monitor_done_talking TRUE))
			;		(set boss_done_talking FALSE)
			;		(sleep 60)
					(ai_place hl_boss_random 1)
					(ai_cannot_die hl_boss_random TRUE)
					(set heretic_leader (list_get (ai_actors hl_boss_random) 0))
					(if (= hl_times_dead hl_lives_total)
						(ai_cannot_die boss_fight_heretic_leader FALSE)
						(ai_cannot_die boss_fight_heretic_leader TRUE)
					)
					(if (= hl_times_dead 1)
						(cs_run_command_script hl_boss_random hl_boss_chat_01)
					)
					(if (= hl_times_dead 2)
						(cs_run_command_script hl_boss_random hl_boss_chat_02)
					)
					(if (= hl_times_dead 3)
						(cs_run_command_script hl_boss_random hl_boss_chat_03)
					)
					(sleep 60)
		
					(sleep_until (= boss_done_talking TRUE))
					(game_save)
					(begin_random
						(if (< (ai_living_count holo_drones) hl_drone_total)
							(ai_place hl_boss_holo_random_01 1)
						)
						(if (< (ai_living_count holo_drones) hl_drone_total)
							(ai_place hl_boss_holo_random_02 1)
						)
						(if (< (ai_living_count holo_drones) hl_drone_total)
							(ai_place hl_boss_holo_random_03 1)
						)
						(if (< (ai_living_count holo_drones) hl_drone_total)
							(ai_place hl_boss_holo_random_04 1)
						)
					)
					(set hl_drone_total (+ hl_drone_total 1))
					(ai_set_orders hl_boss_random boss_fight_hl_center)
					(ai_set_orders hl_boss_holo_random_01 boss_fight_hl_center)
					(ai_set_orders hl_boss_holo_random_02 boss_fight_hl_center)
					(ai_set_orders hl_boss_holo_random_03 boss_fight_hl_center)
					(ai_set_orders hl_boss_holo_random_04 boss_fight_hl_center)
				)
			)			
			(= hl_times_dead hl_lives_total)
		)
	)
)

;weapon respawning
(script dormant toys
	(sleep_until
		(begin
			(begin_random
				(begin
					(sleep 600)
					(object_create_anew toy01)
				)
				(begin
					(sleep 600)
					(object_create_anew toy02)
				)
				(begin
					(sleep 600)
					(object_create_anew toy03)
				)
				(begin
					(sleep 600)
					(object_create_anew toy04)
				)
				(begin
					(sleep 600)
					(object_create_anew toy05)
				)
				(begin
					(sleep 600)
					(object_create_anew toy06)
				)
				(begin
					(sleep 600)
					(object_create_anew toy07)
				)
				(begin
					(sleep 600)
					(object_create_anew toy08)
				)
				(begin
					(sleep 600)
					(object_create_anew toy09)
				)
				(begin
					(sleep 600)
					(object_create_anew toy10)
				)
				(begin
					(sleep 600)
					(object_create_anew toy11)
				)
				(begin
					(sleep 600)
					(object_create_anew toy12)
				)
				(begin
					(sleep 600)
					(object_create_anew toy13)
				)
				(begin
					(sleep 600)
					(object_create_anew toy14)
				)
				(begin
					(sleep 600)
					(object_create_anew toy15)
				)
				(begin
					(sleep 600)
					(object_create_anew toy16)
				)
				(begin
					(sleep 600)
					(object_create_anew toy17)
				)
				(begin
					(sleep 600)
					(object_create_anew toy18)
				)
			)
			FALSE
		)
	)
)

;Overall script for hangar boss fight
(script dormant hangar_secondtime_start
	(sleep_until 
		(AND 
			(= plummeting TRUE) 
			(= (volume_test_objects vol_hangar_reenter (players)) TRUE)
		)
	)

	(device_operates_automatically_set hangar_exit TRUE)

;9/12
;	(game_save)

	(ai_place heretic_leader_hangar)
	(cs_run_command_script heretic_leader_hangar long_pause)
	(ai_cannot_die heretic_leader_hangar TRUE)

	(sleep_until 
		(AND 
			(= plummeting TRUE) 
			(= (volume_test_objects vol_hangar_cutscene_start (players)) TRUE)
		)
	)

	(cinematic_fade_to_white)

;9/11
	(sleep_forever other_hall_fx)
	(sleep_forever underhangar_fx_01)
	(sleep_forever underhangar_fx_02)
	(sleep_forever bottling_fx_01)
	(sleep_forever bottling_fx_02)
	(sleep_forever bottling_fx_03)
	(sleep_forever bottling_fx_04)
	(sleep_forever bottling_fx_05)
	(sleep_forever halls_up_01)
	(sleep_forever halls_up_02)
	(sleep_forever halls_up_03)
	(sleep_forever halls_up_04)
	(sleep_forever halls_up_05)
	(sleep_forever halls_up_06)
	(sleep_forever halls_up_07)
	
	(ai_erase_all)
	(object_teleport (player0) player0_hide2)
	(object_teleport (player1) player1_hide2)

	(if (cinematic_skip_start)
		(begin
			(C04_outro1)
		)
	)
	(cinematic_skip_stop)

	(sound_suppress_ambience_update_on_revert)
	(sound_class_set_gain amb 0 0)
	(sleep 1)
	(sound_class_set_gain amb 1 15)

	(sleep 2)
	(object_teleport (player0) player0_hangar)
	(object_teleport (player1) player1_hangar)

	(wake hangar_fx)
	(ai_place monitor)
	(ai_place boss_fight_heretic_leader)
	(ai_migrate boss_fight_heretic_leader hl_boss_random)
	(ai_cannot_die hl_boss_random TRUE)

	(ai_place boss_fight_hl_hologram_01)
	(ai_migrate boss_fight_hl_hologram_01 hl_boss_holo_random_01)

	(ai_place boss_fight_hl_hologram_02)
	(ai_migrate boss_fight_hl_hologram_02 hl_boss_holo_random_02)
	
	(device_operates_automatically_set hangar_exit FALSE)
	(wake toys)

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(cinematic_fade_from_white)

	(wake objective_dogfight_clear)
	(wake objective_hl_set)
	(data_mine_set_mission_segment "04b_24_boss_fight_01")
	(game_save_immediate)

	(wake monitor_chatting)
	(wake monitor_flitting)

	(hl_respawner)

	(ai_cannot_die hl_boss_random FALSE)
	
	(sleep_until (= (ai_living_count hl_boss_random) 0))
 
	(set final_hl_boss_dead TRUE)
	(ai_kill_silent holo_drones)
	(set holo_drones_nuke TRUE)
	
	(sleep 120)
	
	(if (<= (player_count) 0)
		(sleep_forever)
	)

	(cinematic_fade_to_white)
			
	(object_teleport (player0) player0_hide2)
	(object_teleport (player1) player1_hide2)
			
	(object_destroy heretic_leader)
	(ai_erase monitor)
	(ai_kill_silent all_enemies)
			
	(if (cinematic_skip_start)
		(begin
			(C04_outro2)
		)
	)
	(cinematic_skip_stop)

	(sleep 2)
	(playtest_mission)
	(sleep 2)
	(game_won)
)


;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------
;-------------------------------------------------------------------------------

;Sleeping old stuff once past

(script static void sleep_intro
	(sleep_forever arm_02_entry_start)
)

(script static void sleep_disposal
	(sleep_forever disposal_chamber_start)
	(sleep_forever disposal_infection_spawn)
	(sleep_forever spec_ops_reborn)
)

(script static void sleep_silo
	(sleep_forever silo_start)
	(sleep_forever silo_hall_flood_spawner)
	(sleep_forever elev_go)
	(sleep_forever to_flood_lab)
	(sleep_forever silo_commander_reminder)
	(sleep_forever silo_killer)
	(sleep_forever silo_sentinel_spawner)
	(sleep_forever silo_flood_spawner)
	(sleep_forever silo_saving)
)

(script static void sleep_lab
	(sleep_forever to_flood_lab)
	(sleep_forever flood_lab_start)
	(sleep_forever lab_barricades)
	(sleep_forever lab_wave_new_01)
	(sleep_forever lab_wave_new_02)
	(sleep_forever famine_flavor)
)

(script static void sleep_wraparound
	(sleep_forever bridge_start)
	(sleep_forever bridge_phantom_arrives)
	(sleep_forever bridge_reminder)
	(sleep_forever wraparound_right)
	(sleep_forever wraparound_left)
	(sleep_forever research_arm_bsp_swap)
)

(script static void sleep_control
	(sleep_forever control_room_start)
	(sleep_forever control_commander_reminder)
	(sleep_forever control_bug_out)
	(sleep_forever control_flood_spawn)
	(sleep_forever wind)
	(sleep_forever hologram_toggle)
	(sleep_forever hl_killer)
)

(script static void sleep_cableroom
	(sleep_forever cable_room_start)
	(sleep_forever cable_a_health)
	(sleep_forever cable_b_health)
	(sleep_forever cable_c_health)
	(sleep_forever cable_nav_a)
	(sleep_forever cable_nav_b)
	(sleep_forever cable_nav_c)
	(sleep_forever cable_sentinel_spawner)
	(sleep_forever cable_flood_spawner)
	(sleep_forever grav_test)
	(sleep_forever cable_invulnerable)
	(sleep_forever cableroom_suck_killer)
	(sleep_forever cableroom_junk_spawn)
	(sleep_forever cableroom_commander_reminder)
	(sleep_forever cableroom_killer)
	(sleep_forever cableroom_junk_killer)
	(sleep_forever croom_exit)
)

(script static void sleep_control_return
	(sleep_forever control_room_return)
	(sleep_forever control_return_flood_spawn)
)

(script static void sleep_powercore
	(sleep_forever power_core_start)
)

(script static void sleep_dogfight
	(sleep_forever dogfight_secondtime_start)
	(sleep_forever banshee_killer_00)
	(sleep_forever banshee_killer_01)
)

(script static void sleep_bottling_return
	(sleep_forever bottling_secondtime_start)
	(sleep_forever bottling_return_s_respawner)
	(sleep_forever bottling_return_cf_respawner)
	(sleep_forever bottling_return_ca_respawner)
	(sleep_forever to_underhangar_secondtime)
	(sleep_forever bottling_return_commander)
)

(script static void sleep_underhangar_return
	(sleep_forever underhangar_secondtime_start)
	(sleep_forever to_hangar_secondtime)
	(sleep_forever underhangar_return_commander)
)


;Startup scripts
(script startup mission	

;Cutscene stuff

	(cinematic_snap_to_white)
	(if (= (volume_test_objects vol_arm_02_lz (players)) TRUE)
		(begin
			(sound_suppress_ambience_update_on_revert) ; pbertone 9/24 
			
			(if (cinematic_skip_start)
				(begin
					(C04_intra0)
				)
			)
			(cinematic_skip_stop)

		)
	)

	(sleep 2)
	(switch_bsp 3)	
	(sleep 2)
	
;Mission stuff

	(ai_allegiance player covenant)
	(ai_allegiance heretic sentinel)

	(ai_allegiance player prophet)
	(ai_allegiance heretic prophet)
	(ai_allegiance sentinel prophet)
	(objectives_clear)
		
	(prep_return_from_intro)

	(camera_control off)
	(sleep 1)
	(cache_block_for_one_frame)
	(sleep 1)
	(wake 04b_title0)
	(wake objective_labs_set)
	(wake kill_volumes)
	
	(wake arm_02_entry_start)
	
	(sleep_until (= (volume_test_objects vol_disposal_enter (players)) TRUE))
	(wake disposal_chamber_start)
	(wake silo_start)
	(wake to_flood_lab)
	(wake flood_lab_start)
	(sleep_intro)
	
	(sleep_until (= (structure_bsp_index) 0))
	(wake bridge_start)
	(wake control_room_start)
	(sleep_disposal)
	(sleep_silo)
	(sleep_lab)
	(wake objective_labs_clear)
	(wake objective_control_set)
	
	(sleep_until (= (structure_bsp_index) 2))
	(wake cable_room_start)
	(sleep_wraparound)
	(sleep_control)
	
	(sleep_until (= (structure_bsp_index) 1))
	(wake control_room_return)
	(wake power_core_start)
	(wake dogfight_secondtime_start)
	(sleep_cableroom)
	
	(sleep_until (= (volume_test_objects vol_arm_01_return (players)) TRUE) 1)
	(wake bottling_secondtime_start)
	(wake to_underhangar_secondtime)
	(wake underhangar_secondtime_start)
	(wake to_hangar_secondtime)
	(wake hangar_secondtime_start)
	(sleep_control_return)
	(sleep_powercore)
	(sleep_dogfight)
)