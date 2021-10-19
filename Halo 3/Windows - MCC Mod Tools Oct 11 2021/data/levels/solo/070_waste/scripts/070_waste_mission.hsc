;***************************************************************
******************** GENERAL SCRIPTING *************************
****************************************************************;
;------------------------------------------
; STARTUP
;------------------------------------------
(script static void start
	; fade out 
	(fade_out 0 0 0 0)
	
	; select insertion point 
     (cond
         ((= (game_insertion_point_get) 0) (ins_landing_zone))
         ((= (game_insertion_point_get) 1) (ins_alpha))
         ((= (game_insertion_point_get) 2) (ins_floor_1))
     )
)

(script startup mission_waste
	; fade to black 
	(fade_out 0 0 0 0)
	
	;Humans and players
	(ai_allegiance player human)
	(ai_allegiance human player)
	
	;Guilty spark is allied with everyone
	(ai_allegiance guilty player)
	(ai_allegiance guilty prophet)
	(ai_allegiance guilty human)
	(ai_allegiance guilty sentinel)
	(ai_allegiance guilty covenant)
	(ai_allegiance player guilty)
	(ai_allegiance prophet guilty)
	(ai_allegiance human guilty)
	(ai_allegiance sentinel guilty)
	(ai_allegiance covenant guilty)
	
	;Sentinels are allied to elites, humans and players
	;...until you shoot them
	(ai_allegiance sentinel human)
	(ai_allegiance human sentinel)
	(ai_allegiance sentinel player)
	(ai_allegiance player sentinel)
	(ai_allegiance sentinel covenant)
	(ai_allegiance covenant sentinel)
	
	;Elites are everybody's friends now
	(ai_allegiance player covenant)
	(ai_allegiance covenant player)
	(ai_allegiance human covenant)
	(ai_allegiance covenant human)

	;The game shall be paused
	(campaign_metagame_time_pause true)

	; the game can use flashlights 
	(game_can_use_flashlights true)
	
	;No firebomb grenade in the hud
	(chud_show_fire_grenades false)
	
	;Pelicans have a red light throughout the whole level
	(object_function_set 2 1)
		
	;No objective when starting the mission!
	(objectives_clear)

	(print_difficulty)
	
	;WAKE MAIN SCRIPTS
	;Clean everything behind the player
	(wake 070_cleanup)
	;Lock some doors behind
	(wake 070_monitor_progression)
	;Activate soft ceilings to limit cameras!
	(wake gs_camera_bounds)
	;Disable/Enable trigger volumes that would teleport coop players autocrapically
	(wake 070_manage_swap_volumes)
	;Force inactive AIs to find a path back
	(wake 070_force_active_ai)
	
	;Skullz!
	(wake 070_award_primary_skull)
	(wake 070_award_secondary_skull)
	
	; if game is allowed to start do this 
	(if (> (player_count) 0)

		; if game is allowed to start 
		(start)
		
		; if game is NOT allowed to start
		(begin
			(fade_in 0 0 0 0)
			(sleep_forever gs_camera_bounds)
			(gs_camera_bounds_off)
		)
	)
	
		;====
			; begin landing zone encounter (insertion 1) 
			(sleep_until (>= g_insertion_index 1))
			(if (<= g_insertion_index 1) (wake landing_zone))
		
		;====
		
			; begin bowl 1 encounter (insertion 2)
			(sleep_until	
				(or
					(and
						(volume_test_players vol_b1_cave_0)
						(or
							b_lz_pelican_0_arrived
							b_lz_pelican_1_arrived
						)
					)
					(>= g_insertion_index 2)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 2) (wake bowl_1))
			
			;In case certain commands stuck
			(player_disable_movement false)
			;The game shall not be paused
			(campaign_metagame_time_pause false)			
		;====
		
			; begin bowl 2 encounter (insertion 3)
			(sleep_until	
				(or
					(volume_test_players vol_b2_cave_0)
					(>= g_insertion_index 3)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 3) (wake bowl_2))
			
		;====	
		
			; begin forerunner passage encounter (insertion 4) 
			(sleep_until	
				(or
					(volume_test_players vol_fp_cave)
					(>= g_insertion_index 4)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 4) (wake forerunner_passage))
			
		;====
		
			; begin exploration encounter (insertion 5) 
			(sleep_until	
				(or
					(volume_test_players vol_ex_start)
					(>= g_insertion_index 5)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 5) (wake exploration))
			;Make sure the background scripting is active if we insert at that point
			(if (= g_insertion_index 5) (wake background_exploration))
			
		;====
		
			; begin sentinel defense (insertion 6) 
			(sleep_until	
				(or
					(volume_test_players vol_sd_begin)
					(volume_test_players vol_sd_begin_catch_all)
					(>= g_insertion_index 6)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 6) (wake sentinel_defense))
			;Make sure the background scripting is active if we insert at that point
			(if (= g_insertion_index 6) (wake background_exploration))
			
		;====
		
			; begin antiair wraiths (insertion 7)
			(sleep_until	
				(or
					(volume_test_players vol_aw_start)
					(>= g_insertion_index 7)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 7) (wake antiair_wraiths))
			;Make sure the background scripting is active if we insert at that point
			(if (= g_insertion_index 7) (wake background_exploration))
			
		;====
		
			; begin frigate landing (insertion 8) 
			(sleep_until	
				(or
					(and
						(<= (ai_living_count gr_cov_aw_aa_wraiths) 0)
						(<= (ai_living_count gr_cov_aw_wraiths_mortar) 0)
						(>= s_aw_progression 20)
					)
					(>= g_insertion_index 8)
				)
			1)
			;Timeout if the player can't find everyone to kill for 3 minutes
			(sleep_until	
				(or
					(and					
						(<= (ai_living_count gr_cov_aw_ghosts) 0)
						b_aw_spawned_ghosts
						(<= (ai_living_count cov_aw_fort_pack) 0)
						(<= (ai_living_count cov_aw_fort_turrets) 0)
					)
					(>= g_insertion_index 8)
				)
			1 5400)
			; wake encounter script 
			(if (<= g_insertion_index 8) (wake frigate_landing))
			
		;====
		
			; begin lead the army (insertion 9) 
			(sleep_until	
				(or
					(and
						b_la_can_start
						(volume_test_players vol_la_before_cave)
					)
					b_fl_chief_in_vehicle
					(>= g_insertion_index 9)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 9) (wake lead_the_army))
			
		;====
		
			; begin defend wall encounter (insertion 10) 
			(sleep_until	
				(or
					(volume_test_players vol_dw_after_trench)
					(>= g_insertion_index 10)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 10) (wake defend_wall))
			
		;====	
		
			; begin lightbridge encounter (insertion 11) 
			(sleep_until	
				(or
					(volume_test_players vol_lb_begin)
					(>= g_insertion_index 11)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 11) (wake lightbridge))
			
		;====
		
			; begin big battle encounter (insertion 12) 
			(sleep_until	
				(or
					(volume_test_players vol_bb_start)
					(>= g_insertion_index 12)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 12) (wake big_battle))
			
		;====
		
			; begin after big battle encounter (insertion 13) 
			(sleep_until	
				(or
					;Make sure we killed the scarab & some guys on the base before 
					;we actually send GS up
					(and 
						(<= (ai_task_count obj_abb_cov/defend_base) 7)
						(<= (ai_living_count cov_bb_scarab) 0)
						bb_scarab_spawned
						(>= s_bb_progression 80)
					)
					(>= g_insertion_index 13)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 13) (wake after_big_battle))
			
		;====
		
			; begin floor 1 encounter (insertion 14) 
			(sleep_until	
				(or
					b_abb_pelican_marines_moving
					(>= g_insertion_index 14)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 14) (wake floor_1))
			
			; If we teleported to that encounter, skip the waiting for AIs
			(if (= g_insertion_index 14) (set b_f1_start_now 1))
			
		;====
		
			; begin floor 2 encounter (insertion 15) 
			(sleep_until	
				(or
					(volume_test_players vol_f2_start)
					(>= g_insertion_index 15)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 15) (wake floor_2))
			;Make sure the background scripting is active if we insert at that point
			(if (= g_insertion_index 15) (wake background_shaft))
			
		;====
		
			; begin floor 3 encounter (insertion 16) 
			(sleep_until	
				(or
					(volume_test_players vol_f3_start)
					(>= g_insertion_index 16)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 16) (wake floor_3))
			;Make sure the background scripting is active if we insert at that point
			(if (= g_insertion_index 16) (wake background_shaft))
			
		;====
		
			; begin floor 4 encounter (insertion 17) 
			(sleep_until	
				(or
					(volume_test_players vol_f4_start)
					(>= g_insertion_index 17)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 17) (wake floor_4))
			;Make sure the background scripting is active if we insert at that point
			(if (= g_insertion_index 17) (wake background_shaft))
			
		;====
		
			; begin floor 5 encounter (insertion 18) 
			(sleep_until	
				(or
					;The player has to look outside in order to trigger that vignette, 
					;or he has to be already down the stairs
					(and
						(objects_can_see_flag (players) flg_f5_viewpoint 30)
						(volume_test_players vol_f5_start)
					)
					(volume_test_players vol_f5_stairs_right)
					(volume_test_players vol_f5_stairs_left)
					(>= g_insertion_index 18)
				)
			1)
			; wake encounter script 
			(if (<= g_insertion_index 18) (wake floor_5))
			;Make sure the background scripting is active if we insert at that point
			(if (= g_insertion_index 18) 
				(begin
					(wake background_shaft)
					(ai_place cov_f5_brt_chieftain)
					(sleep 1)
					(ai_teleport cov_f5_brt_chieftain pts_f5_chieftain_retreat/p1)
				)
			)
			
		;====
)

;------------------------------------------
; GLOBALS
;------------------------------------------
(global boolean debug true)
(global boolean b_debug true)
(global boolean b_dialogue true)
(global boolean b_cinematic true)
(global boolean b_gs_follow_player 0)
(global long s_gs_walkup_dist 3)
(global long s_gs_talking_dist 4)
(global long g_insertion_index 0)
(global ai_line g_gs_1st_line 070MH_450)
(global ai_line g_gs_2nd_line 070MK_150)
(global object obj_arbiter none)
(global object obj_guilty_spark none)
(global boolean g_null 0)
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
;Simple script used to kick out an AI from its current command script
(script command_script cs_end
	(sleep 1)
)

;Freezes an AI, just so that he stays there and looks around
(script command_script cs_do_nothing
	(cs_enable_looking true)
	(sleep_forever)
)

;Freezes an AI, just so that he looks around
(script command_script cs_do_nothing_move
	(cs_enable_looking true)
	(cs_enable_moving true)
	(sleep_forever)
)

;An AI only shoots
(script command_script cs_shoot_dont_move
	(cs_enable_looking true)
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_shoot true)
	(sleep_forever)
)

;Draw and end
(script command_script cs_draw_weapon
	(sleep (random_range 0 45))
	(cs_draw)
	(sleep 1)
)

(script command_script cs_run
	(cs_enable_looking true)
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_draw)
	(cs_movement_mode ai_movement_combat)
	(cs_abort_on_alert true)
	(sleep 600)
	(sleep_forever)
)

(script command_script cs_stay_in_turret
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_until (not (unit_in_vehicle ai_current_actor)))
)

(script command_script cs_fly_with_boost
	(cs_enable_looking true)
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_shoot true)
	(cs_vehicle_boost true)
	(sleep_forever)
)

(global boolean b_gs_said_1st_line 0)
(global boolean b_gs_said_2nd_line 0)

;Guilty Spark behavior - lead ahead, and every once in a while 
;come back to check on the player
(script command_script cs_guilty_spark_lead_player
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_dialogue true)
	
	(set b_gs_said_1st_line 0)
	(set b_gs_said_2nd_line 0)
	
	(sleep 300)
	(sleep_until
		(begin
			;(sleep 3600)
			(set b_gs_follow_player 1)
			;Try to reach the player for a certain amount of time
			(sleep_until 
				(AND
					(<= (objects_distance_to_object (players) ai_current_actor) s_gs_walkup_dist)
					(objects_can_see_object (players) ai_current_actor 40)
					(not b_playing_dialogue)
				)
			5 1200)
			(set b_gs_follow_player 0)
			;If GS was close to get to the player, acknowledge
			;the player and fly back to the objective
			(if (<= (objects_distance_to_object (players) ai_current_actor) s_gs_talking_dist)
				(begin
					(cs_face_player true)
					(cs_enable_moving false)
					(if (< (random_range 0 100) 50)
						(if (not b_gs_said_1st_line)
							(begin
								(cs_enable_dialogue false)
								(sleep 15)
								
								(if b_dialogue (print "GUILTY: g_gs_1st_line"))
								;(cs_play_line 070MH_450)
								(cs_play_line g_gs_1st_line)
								
								(set b_gs_said_1st_line 1)
								
								(cs_enable_dialogue true)
							)
							(sleep 60)
						)
						(if (not b_gs_said_2nd_line)
							(begin
								(cs_enable_dialogue false)
								(sleep 15)
								
								(if b_dialogue (print "GUILTY: g_gs_2nd_line"))
								;(cs_play_line 070MK_150)
								(cs_play_line g_gs_2nd_line)
								
								(set b_gs_said_2nd_line 1)
								
								(cs_enable_dialogue true)
							)
							(sleep 60)
						)
					)
					;(sleep 30)
					(cs_enable_moving true)
					(cs_face_player false)
				)
			)
			(sleep 600)
		0)
	)
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
	;(sleep_until (>= s_lz_progression 20))
	;(sleep_until (>= s_b1_progression 40))	
	;(sleep_until (>= s_b2_progression 20))
	;(sleep_until (>= s_fp_progression 20))
	;(sleep_until (>= s_ex_progression 60))
	;(sleep_until (>= s_aw_progression 30))
	;(sleep_until (>= s_la_progression 90))
	;(sleep_until (>= s_dw_progression 20))
	;(sleep_until (>= s_lb_progression 50))
	;(sleep_until (>= s_bb_progression 110))
	;(sleep_until (>= s_f1_progression 30))
	;(sleep_until (>= s_f2_progression 60))
	;(sleep_until (>= s_f3_p1_progression 40))
	;(sleep_until (>= s_f3_p2_progression 50))
	
(script dormant 070_cleanup
	(sleep_until (>= s_ex_progression 30) 10)
	(landing_zone_cleanup)
	(sleep 5)
	(bowl_1_cleanup)
	(sleep 5)
	(bowl_2_cleanup)
	(sleep 5)	
	(background_bowls_cleanup)
	
	(sleep_until
		(or
			b_fl_frigate_arrives
			(> s_la_progression 0)			
		)
	)
	;Add a pretty heavy recycle volume to get rid of ghost debris
	;that block the tank AIs
	(add_recycling_volume vol_la_recycle_cave 5 15)
	
	(sleep_until (> s_la_progression 0) 10)
	(forerunner_passage_cleanup)
	(sleep 5)
	(exploration_cleanup)
	(sleep 5)
	(sentinel_defense_cleanup)		
		
	(sleep_until (>= s_lb_progression 15) 10)
	(antiair_wraiths_cleanup)
	(sleep 5)
	(frigate_landing_cleanup)
	(sleep 5)
	(lead_the_army_cleanup)
	
	(sleep_until (>= s_lb_progression 15) 10)
	(defend_wall_cleanup)
	(sleep 5)
	(background_exploration_cleanup)
			
	(sleep_until (> s_bb_progression 50) 10)
	(lightbridge_cleanup)
		
	(sleep_until (> s_f1_progression 10) 10)
	(big_battle_cleanup)
	(sleep 5)
	(after_big_battle_cleanup)

	(sleep_until (> s_f3_p2_progression 0) 10)
	(floor_1_cleanup)
	(sleep 5)
	(floor_2_cleanup)
		
	(sleep_until 
		(and
			b_f5_combat_finished
			(= (current_zone_set_fully_active) 12)
		)
	10)
	(floor_3_cleanup)
	(sleep 5)
	(floor_4_cleanup)
)

(script dormant 070_monitor_progression
	(kill_volume_disable kill_volume_f5_right)
	(kill_volume_disable kill_volume_f5_left)
	(kill_volume_disable kill_volume_f5_back)
	
	(sleep_until (>= s_ex_progression 10) 10)
	
	(sleep_until (>= s_ex_progression 30) 10)
	(shut_door_forever_immediate fp_entrance_door)
	(sleep 1)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 5)
		(volume_teleport_players_not_inside vol_ex_teleport flg_ex_teleport)
	)	
	
	(sleep_until 
		(or
			(volume_test_players vol_sd_begin_catch_all)
			(>= s_ex_progression 55)
		)
	10)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 5)
		(begin
			(if (game_is_cooperative)
				(begin
					(teleport_players_in_vehicle vol_ex_teleport_3 flg_ex_teleport_3_0 flg_ex_teleport_3_1 flg_ex_teleport_3_2 flg_ex_teleport_3_3)
					(sleep 1)
					(volume_teleport_players_not_inside vol_ex_teleport_3 flg_ex_teleport_3)
				)
			)
			(ai_kill gr_cov_ex_p1)
			(ai_kill gr_cov_ex_p2)
		)
	)
	
	(sleep_until (>= s_ex_progression 65) 10)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 5)
		(begin
			(if (game_is_cooperative)
				(begin
					(teleport_players_in_vehicle vol_ex_teleport_2 flg_ex_teleport_2_0 flg_ex_teleport_2_1 flg_ex_teleport_2_2 flg_ex_teleport_2_3)
					(sleep 1)
					(volume_teleport_players_not_inside vol_ex_teleport_2 flg_ex_teleport_2)
				)
			)
			(ai_kill gr_cov_sd)
			(ai_kill gr_cov_ex_p3)
		)
	)
	
	(sleep_until 
		(or
			(>= s_la_progression 10)
			b_fl_frigate_arrives
		)
	10)
	;Disable access to the transition area
	(shut_door_forever_immediate fp_exit_door)
	
	(sleep_until (>= s_lb_progression 15) 10)
	(sleep_forever dw_manage_jitter_door)
	(shut_door_forever_immediate ex_wall_door)
	(sleep 1)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 11)
		(begin 
			(device_set_position_immediate lb_left_large_door 1)
			(volume_teleport_players_not_inside vol_lb_teleport flg_lb_teleport)
			(wake lb_teleport_allies)
			(sleep 150)		
			;Erase every squad behind - if they were not migrated, they are stuck behind
			(ai_disposable gr_allies_before_fl true)
			(ai_disposable gr_allies_la true)
			(ai_disposable gr_allies_dw true)
		)
	)
	
	(sleep_until (>= s_lb_progression 50) 10)
	(shut_door_forever_immediate lb_guardian_door)
	(sleep 1)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 11)
		(begin 
			(volume_teleport_players_not_inside vol_lb_teleport_2 flg_lb_teleport_2)
			;Erase everybody behind you - need to free perfs for the big battle
			(ai_erase gr_for_lb)
			(ai_erase allies_lb_warthog_0)
			;Again for perf reasons - braindead everyone while they're waiting to be teleported
			(ai_braindead allies_lb_scorpion_0 true)
			(ai_braindead allies_lb_scorpion_1 true)
			(ai_braindead allies_lb_scorpion_2 true)
		)
	)
	
	(sleep_until (>= s_bb_progression 10) 10)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 12)
		(begin 
			;Teleport allies in the big battle section
			(ai_teleport allies_bb_warthog_entrance_0 pts_bb_warthog_intro/p0)
			(ai_teleport allies_bb_warthog_entrance_1 pts_bb_warthog_intro/p1)		
		)
	)


	(sleep_until (>= s_bb_progression 30) 10)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 12)
		(begin
			(ai_braindead gr_marines false)			
			(bb_teleport_scorpions)
		)
	)
			
	(sleep_until (>= s_bb_progression 50) 10)
	(shut_door_forever_immediate bb_player_door)
	(sleep 1)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 12)
		(begin 
			(volume_teleport_players_not_inside vol_bb_all flg_bb_teleport_players)		
		)
	)
	
	(sleep_until (>= s_f1_progression 10) 10)
	(kill_volume_disable kill_volume_bb_0)
	(kill_volume_disable kill_volume_bb_1)
	
	(sleep_until (> s_f3_p1_progression 0) 10)
	(shut_door_forever_immediate f2_door)
	(sleep 1)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 16)
		(begin 
			;Teleport players
			(volume_teleport_players_not_inside vol_f2_all flg_f3_start_location_p0)
			;Also teleport AIs that were stuck on the other side of that door
			(wake f3_teleport_allies)
		)	
	)
	
	(sleep_until b_f3_p2_started 10)
	(reactivate_door f3_door_1)
	(device_set_never_appears_locked f3_door_2 false)
	(shut_door_forever_immediate f3_door_2)
	
	(sleep_until 
		(or
			(> s_f5_progression 0)
			b_f5_has_started
		)
	10)
	
	(shut_door_forever_immediate f3_door_outside)
	(device_set_never_appears_locked f3_door_outside false)
	(sleep 1)
	;Don't teleport anyone if player inserted later in the mission
	(if (<= g_insertion_index 17)
		(begin 
			;Teleport players
			(volume_teleport_players_not_inside vol_f5_teleport flg_f5_teleport)
		)		
	)	
	
	(sleep_until 
		(or
			(<= (ai_living_count obj_f5_cov) 4)
			b_f5_combat_finished
		)
	)
	;Teleport players
	(f5_teleport_players_not_outside)
	(sleep 1)
	(prepare_to_switch_to_zone_set 070_080)
	(sleep 60)
	(kill_volume_enable kill_volume_f5_right)
	(kill_volume_enable kill_volume_f5_left)
	(kill_volume_enable kill_volume_f5_back)
	(ai_erase_inactive gr_covenants 0)
	
	(sleep_until b_f5_combat_finished 1)
	(kill_volume_disable kill_volume_f5_right)
	(kill_volume_disable kill_volume_f5_left)
	(kill_volume_disable kill_volume_f5_back)
	(switch_zone_set 070_080)
)

(script dormant 070_manage_swap_volumes
	;Disable the lightbridge loading for now
	(zone_set_trigger_volume_enable zone_set:070_010_020:* false)
	(zone_set_trigger_volume_enable begin_zone_set:070_010_020:* false)
	;Same for the forerunner passage loading - it's already in memory. 
	(zone_set_trigger_volume_enable zone_set:070_005_010:* false)
	(zone_set_trigger_volume_enable begin_zone_set:070_005_010:* false)
	;Disable F4 for the first part of F3
	(zone_set_trigger_volume_enable begin_zone_set:070_060_070_080_071 false)
	(zone_set_trigger_volume_enable zone_set:070_060_070_080_071 false)
	;Disable the trigger volume that loads only BSP 010 - this is for the tank run
	(zone_set_trigger_volume_enable zone_set:070_010:* false)
	;Disable the last trigger volume switch
	(zone_set_trigger_volume_enable begin_zone_set:070_080 false)
	(zone_set_trigger_volume_enable zone_set:070_080 false)
	
	(sleep_until (>= s_b2_progression 30))
	(zone_set_trigger_volume_enable zone_set:070_000_005 false)
	
	(sleep_until (>= s_ex_progression 30))
	(zone_set_trigger_volume_enable zone_set:070_005_010:* true)
	(zone_set_trigger_volume_enable begin_zone_set:070_005_010:* true)
	(zone_set_trigger_volume_enable zone_set:070_000_005_010 false)
	(zone_set_trigger_volume_enable begin_zone_set:070_000_005_010 false)
	
	(sleep_until (>= s_la_progression 10) 10)
	;Enable the lightbridge loading
	(zone_set_trigger_volume_enable zone_set:070_010_020:* true)
	(zone_set_trigger_volume_enable begin_zone_set:070_010_020:* true)
	;Disable access to the transition area
	(zone_set_trigger_volume_enable zone_set:070_005_010:* false)
	(zone_set_trigger_volume_enable begin_zone_set:070_005_010:* false)
	;But enable access to the crashed pelican sites (and reload them in memory)
	(zone_set_trigger_volume_enable zone_set:070_010:* true)
	;Do not predict the frigate area anymore
	(zone_set_trigger_volume_enable begin_zone_set:070_010_011:* false)
	
	(sleep_until b_f3_p2_started 10)
	(zone_set_trigger_volume_enable zone_set:070_050_060_080_071 false)
	(zone_set_trigger_volume_enable begin_zone_set:070_050_060_080_071 false)
	(zone_set_trigger_volume_enable zone_set:070_060_070_080_071 true)
	(zone_set_trigger_volume_enable begin_zone_set:070_060_070_080_071 true)
	
	(prepare_to_switch_to_zone_set 070_060_070_080_071)
	
	;(sleep_until (> s_f5_progression 0) 10)
	;(zone_set_trigger_volume_enable begin_zone_set:070_080 true)
)

(script dormant 070_force_active_ai
	(sleep_until (>= s_ex_progression 10))
	(ai_force_active allies_ex_on_foot_0 true)
	
	(sleep_until (>= s_ex_progression 30))
	(ai_force_active gr_allies_ex true)
	
	(sleep_until (>= s_ex_progression 60))
	(ai_force_active allies_ex_on_foot_0 false)
	(ai_force_active gr_allies_ex false)
	
	(sleep_until (>= s_la_progression 30))
	(ai_force_active gr_allies_la true)
	;Force the pelican active forever, since we want that guy 
	;to delete himself anyway
	(ai_force_active allies_fl_pelican true)
	
	(sleep_until (>= s_la_progression 90))
	;If they didn't make it by that time, allow them to be inactive
	(ai_force_active gr_allies_la false)
)

(global short g_current_zone_set 100)
(global short g_current_active_zone_set 100)

(script static void (reactivate_door (device machine_door))
	(device_operates_automatically_set machine_door 1)
	(device_set_power machine_door 1)
)

(script continuous 070_unload_zone_set
	(sleep_until (!= (current_zone_set) g_current_zone_set) 1)
	
	(cond
		; 070_005_010 
		((= (current_zone_set) 3)	
			(begin
				(if b_debug (print "070_005_010 unload"))
			)
		)
		
		; 070_010_011 
		((= (current_zone_set) 4)
			(begin
				(if b_debug (print "070_010_011 unload"))
				(shut_door_forever_immediate fp_exit_door)
			)
		)
		
		; 070_010_020 
		((= (current_zone_set) 5)
			(begin
				(if b_debug (print "070_010_020 unload"))
				(shut_door_forever_immediate fp_exit_door)
				
				;The frigate is already in the sky,
				;Replace with low rez frigate
				(if b_fl_frigate_arrived
					(begin
						(fl_remove_frigate)
						(object_create fl_frigate_low_rez)
					)
				)
			)
		)
		
		; 070_010
		((= (current_zone_set) 6)	
			(begin
				(if b_debug (print "070_010 unload"))
				(shut_door_forever_immediate fp_exit_door)				
			)
		)
		
		; 070_020_030 
		((= (current_zone_set) 7)
			(begin
				(if b_debug (print "070_020_030 unload"))
				(shut_door_forever_immediate ex_wall_door)
			)
		)
		
		; 070_040_050_071 
		((= (current_zone_set) 9)	
			(begin
				(if b_debug (print "070_040_050_071 unload"))									
				(shut_door_forever_immediate f3_door_2)
			)
		)
		; 070_050_060_080_071 
		((= (current_zone_set) 10)	
			(begin
				(if b_debug (print "070_050_060_080_071 unload"))
				(shut_door_forever_immediate f2_entrance_door)
				(shut_door_forever_immediate f4_entrance_door)
			)
		)
		; 070_060_070_080_071 
		((= (current_zone_set) 11)
			(begin
				(if b_debug (print "070_060_070_080_071 unload"))
				(shut_door_forever_immediate f3_door_2)
			)
		)
		; 070_080
		((= (current_zone_set) 12)
			(begin
				(if b_debug (print "070_080 unload"))
				(shut_door_forever_immediate f4_door)
			)
		)
	)
	(set g_current_zone_set (current_zone_set))
)

(script continuous 070_load_zone_set
	(sleep_until (!= (current_zone_set_fully_active) g_current_active_zone_set) 1)
	
	(cond
		; 070_005_010 
		((= (current_zone_set_fully_active) 3)	
			(begin
				(if b_debug (print "070_005_010 load"))
				(reactivate_door fp_exit_door)
			)
		)
		
		; 070_010_011 
		((= (current_zone_set_fully_active) 4)
			(begin
				(if b_debug (print "070_010_011 load"))
				
				;The frigate is already in the sky, 
				;Replace with high rez frigate and elevators
				(if b_fl_frigate_arrived
					(begin
						(object_destroy fl_frigate_low_rez)
						(fl_create_frigate)
					)
				)
			)
		)
		
		; 070_010_020 
		((= (current_zone_set_fully_active) 5)
			(begin
				(if b_debug (print "070_010_020 load"))
			)
		)
		
		; 070_010 
		((= (current_zone_set_fully_active) 6)	
			(begin
				(if b_debug (print "070_010 load"))
				
				;Recreate every object in that space - they were 
				;probably unloaded from a recent zone set swap
				(object_destroy ex_crashed_pelican)
				(object_create ex_crashed_pelican)
				
				(object_destroy_folder crt_crashed_pelican)
				(object_create_folder crt_crashed_pelican)
			)
		)		
		
		; 070_020_030 
		((= (current_zone_set_fully_active) 7)	
			(begin
				(if b_debug (print "070_020_030 load"))
				(reactivate_door bb_player_door)
				(object_create_anew waterfall)
			)
		)
		
		; 070_040_050_071 
		((= (current_zone_set_fully_active) 9)	
			(begin
				(if b_debug (print "070_040_050_071 load"))
				(reactivate_door f2_entrance_door)
			)
		)
		; 070_050_060_080_071 
		((= (current_zone_set_fully_active) 10)	
			(begin
				(if b_debug (print "070_050_060_080_071 load"))
				(reactivate_door f2_stairway)
				(reactivate_door f3_door_2)
				(object_create_anew waterfall)
			)
		)
		; 070_060_070_080_071 
		((= (current_zone_set_fully_active) 11)	
			(begin
				(if b_debug (print "070_060_070_080_071 load"))					
				(reactivate_door f3_door_outside)
				(reactivate_door f4_entrance_door)
				(object_create_anew waterfall)
			)
		)
		; 070_080
		((= (current_zone_set_fully_active) 12)
			(begin
				(if b_debug (print "070_080 load"))
				(object_create_anew waterfall)
			)
		)
	)
	(set g_current_active_zone_set (current_zone_set_fully_active))
)

(script static void (kill_players_in_volume (trigger_volume vol_current))
	(if (volume_test_object vol_current (player0)) (unit_kill (player0)))
	(if (volume_test_object vol_current (player1)) (unit_kill (player1)))
	(if (volume_test_object vol_current (player2)) (unit_kill (player2)))
	(if (volume_test_object vol_current (player3)) (unit_kill (player3)))
)

(script static void (place_guilty_spark (ai ai_starting_location))
	(ai_place ai_starting_location)
	(sleep 1)
	(set obj_guilty_spark (ai_get_object ai_starting_location))
	(ai_cannot_die gr_guilty_spark true)
)

(script static void (place_arbiter (ai ai_starting_location))
	(if (not (game_is_cooperative))
		(begin
			(ai_place ai_starting_location)
			(sleep 1)
			(set obj_arbiter (ai_get_object ai_starting_location))
		)
	)
)

(script static void (migrate_arbiter (ai ai_from_squad) (ai ai_to_squad))
	(ai_resurrect obj_arbiter)
	(sleep 1)
	(ai_migrate ai_from_squad ai_to_squad)
)

(script static boolean player_in_a_vehicle
	(or
		(unit_in_vehicle (player0))
		(unit_in_vehicle (player1))
		(unit_in_vehicle (player2))
		(unit_in_vehicle (player3))
	)
)
(global object obj_player_vehicle none)
(script static void (get_player_vehicle (unit passed_player))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location allies_ex_warthog_1/warthog) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location allies_ex_warthog_1/warthog)))
	(if (vehicle_test_seat veh_mauler_0 "" passed_player) (set obj_player_vehicle veh_mauler_0))
	(if (vehicle_test_seat veh_mauler_1 "" passed_player) (set obj_player_vehicle veh_mauler_1))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_ex_search_brutes_0/chopper) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location cov_ex_search_brutes_0/chopper)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_ex_search_brutes_1/chopper) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location cov_ex_search_brutes_1/chopper)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_ex_search_brutes_2/driver) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location cov_ex_search_brutes_2/driver)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_ex_search_grunts_0/ghost) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location cov_ex_search_grunts_0/ghost)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_ex_search_grunts_1/ghost) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location cov_ex_search_grunts_1/ghost)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_ex_search_grunts_3/ghost) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location cov_ex_search_grunts_3/ghost)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location allies_ex_mongoose_0/mongoose_0) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location allies_ex_mongoose_0/mongoose_0)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location allies_ex_mongoose_1/mongoose_1) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location allies_ex_mongoose_1/mongoose_1)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_sd_chopper_0/chopper) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location cov_sd_chopper_0/chopper)))
	(if (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_sd_chopper_1/chopper) "" passed_player) (set obj_player_vehicle (ai_vehicle_get_from_starting_location cov_sd_chopper_1/chopper)))
)

(script static void (teleport_players_in_vehicle (trigger_volume vol_teleport) (cutscene_flag flg_player_0) (cutscene_flag flg_player_1) (cutscene_flag flg_player_2) (cutscene_flag flg_player_3))
	(if 	
		(and
			(not (volume_test_object vol_teleport (player0)))
			(unit_in_vehicle (player0))
		)
		(begin
			(get_player_vehicle (player0))
			(object_teleport obj_player_vehicle flg_player_0)
		)
	)
	(if 	
		(and
			(not (volume_test_object vol_teleport (player1)))
			(unit_in_vehicle (player1))
		)
		(begin
			(get_player_vehicle (player1))
			(object_teleport obj_player_vehicle flg_player_1)
		)
	)
	(if 	
		(and
			(not (volume_test_object vol_teleport (player2)))
			(unit_in_vehicle (player2))
		)
		(begin
			(get_player_vehicle (player2))
			(object_teleport obj_player_vehicle flg_player_2)
		)
	)
	(if 	
		(and
			(not (volume_test_object vol_teleport (player3)))
			(unit_in_vehicle (player3))
		)
		(begin
			(get_player_vehicle (player3))
			(object_teleport obj_player_vehicle flg_player_3)
		)
	)
)

(script static boolean player_in_a_vehicle_with_ai
	(or
		(and
			(unit_in_vehicle (player0))
			(> (ai_in_vehicle_count (ai_player_get_vehicle_squad (player0))) 0)
		)
		(and
			(unit_in_vehicle (player1))
			(> (ai_in_vehicle_count (ai_player_get_vehicle_squad (player1))) 0)
		)
		(and
			(unit_in_vehicle (player2))
			(> (ai_in_vehicle_count (ai_player_get_vehicle_squad (player2))) 0)
		)
		(and
			(unit_in_vehicle (player3))
			(> (ai_in_vehicle_count (ai_player_get_vehicle_squad (player3))) 0)
		)
	)
)

(global ai ai_return_squad none)
(script static ai get_ai_in_player_vehicle
	(if (player_in_a_vehicle_with_ai)
		(cond 
			((unit_in_vehicle (player0)) (set ai_return_squad (ai_player_get_vehicle_squad (player0))))
			((unit_in_vehicle (player1)) (set ai_return_squad (ai_player_get_vehicle_squad (player1))))
			((unit_in_vehicle (player2)) (set ai_return_squad (ai_player_get_vehicle_squad (player2))))
			((unit_in_vehicle (player3)) (set ai_return_squad (ai_player_get_vehicle_squad (player3))))
		)
	)
	ai_return_squad
)

;Pass through the list of ai and find one that is not in a vehicle
;If all AIs are in vehicles, return the same squad group again
(global object_list ol_unit_list (players))
(global object obj_current_unit none)
(global short s_list_count 0)
(global short s_list_index 0)
(script static ai (get_ai_not_in_vehicle (ai passed_squad_group))	
	;If we don't find any AI not in a vehicle, we'll return the given squad group
	(set ai_return_squad passed_squad_group)
	
	(set s_list_count 0)
	(set s_list_index 0)
	(set ol_unit_list passed_squad_group)
	(set s_list_count (list_count ol_unit_list))
	(sleep_until
		(begin
			(set obj_current_unit (unit (list_get ol_unit_list s_list_index)))
			(if (not (unit_in_vehicle (unit obj_current_unit)))
				(begin
					(set ai_return_squad (object_get_ai obj_current_unit))
					;Exit that loop - we found our AI
					(set s_list_index s_list_count)
				)
			)
			(set s_list_index (+ s_list_index 1))
			(> s_list_index s_list_count)
		)
	1)
	
	;Return the ai
	ai_return_squad
)

(script static boolean (player_notice_object (trigger_volume vol_test) (object obj_test))
	(or
		(and
			(volume_test_object vol_test (player0))
			(objects_can_see_object (player0) obj_test 30)
		)
		(and
			(volume_test_object vol_test (player1))
			(objects_can_see_object (player1) obj_test 30)
		)
		(and
			(volume_test_object vol_test (player2))
			(objects_can_see_object (player2) obj_test 30)
		)
		(and
			(volume_test_object vol_test (player3))
			(objects_can_see_object (player3) obj_test 30)
		)
	)
)

(script static boolean (player_notice_flag (trigger_volume vol_test) (cutscene_flag flg_test))
	(or
		(and
			(volume_test_object vol_test (player0))
			(objects_can_see_flag (player0) flg_test 30)
		)
		(and
			(volume_test_object vol_test (player1))
			(objects_can_see_flag (player1) flg_test 30)
		)
		(and
			(volume_test_object vol_test (player2))
			(objects_can_see_flag (player2) flg_test 30)
		)
		(and
			(volume_test_object vol_test (player3))
			(objects_can_see_flag (player3) flg_test 30)
		)
	)
)

(script static boolean any_player_dead
	(or
		(< (object_get_health (player0)) 0)
		(and
			(>= (game_coop_player_count) 2)
			(< (object_get_health (player1)) 0)
		)
		(and
			(>= (game_coop_player_count) 3)
			(< (object_get_health (player2)) 0)
		)
		(and
			(>= (game_coop_player_count) 4)
			(< (object_get_health (player3)) 0)
		)
	)
)

;*(global real s_min_dist_to_object 0)
(global real s_dist_to_object 0)
(script static ai (get_nearest_ai_from_object (ai passed_squad_group) (object passed_object))
	;If we don't find any AI near the vehicle, we'll return an empty squad
	(set ai_return_squad dummy_squad)

	(set s_min_dist_to_object (objects_distance_to_object (ai_actors passed_squad_group) passed_object))
	
	;Get rid of floating point errors
	(set s_min_dist_to_object (+ s_min_dist_to_object 0.1))
	
	(if (< s_min_dist_to_object 0)
		(if b_debug (print "get_nearest_ai_from_object: distance < 0"))
		(begin			
			(set s_list_count 0)
			(set s_list_index 0)
			(set ol_unit_list passed_squad_group)
			(set s_list_count (list_count ol_unit_list))
			(sleep_until
				(begin
					(set obj_current_unit (unit (list_get ol_unit_list s_list_index)))
					(set s_dist_to_object (objects_distance_to_object obj_current_unit passed_object))
					(if 
						(and
							(> s_dist_to_object 0)
							(<= s_dist_to_object s_min_dist_to_object)
						)
						(begin
							(if b_debug (print "Found an ai near the object"))
							(set ai_return_squad (object_get_ai obj_current_unit))
							;Exit that loop - we found our AI
							(set s_list_index s_list_count)
						)
					)
					(set s_list_index (+ s_list_index 1))
					(> s_list_index s_list_count)
				)
			1)
		)
	)
	
	;Return the ai
	ai_return_squad
)*;

(script static void objective_1_set
	(print "new objective set:")
	(print "Take out the Covenant AA defenses and gather your troops.")
	(objectives_show_up_to 0)
)

(script static void objective_1_clear
	(print "objective complete:")	
	(print "Take out the Covenant AA defenses and gather your troops.")
	(objectives_finish_up_to 0)
)

(script static void objective_2_set
	(print "new objective set:")
	(print "Make your way past the forerunner wall.")
	(objectives_show_up_to 1)
)

(script static void objective_2_clear
	(print "objective complete:")	
	(print "Make your way past the forerunner wall.")
	(objectives_finish_up_to 1)
)

(script static void objective_3_set
	(print "new objective set:")
	(print "Find the cartographer.")
	(objectives_show_up_to 2)
)

(script dormant objective_3_clear
	(sleep_until (>= s_f3_p1_progression 40))
	(print "objective complete:")
	(print "Find the cartographer.")
	(objectives_finish_up_to 2)
)

(script static void objective_4_set
	(print "new objective set:")
	(print "Get to the extraction point and pursue Truth.")
	(objectives_show_up_to 3)
)

(script static void objective_4_clear
	(print "objective complete:")	
	(print "Get to the extraction point and pursue Truth.")
	(objectives_finish_up_to 3)
)


;AI count - prints the number of ai alive
;*(script dormant print_ai_count
	(sleep_until
		(begin
			(if (< (ai_living_count gr_npc) 10)
				(print "ai_count < 10")
				(if (< (ai_living_count gr_npc) 20)
					(print "ai_count < 20")
					(if (< (ai_living_count gr_npc) 25)
						(print "ai_count < 25")
						(if (<= (ai_living_count gr_npc) 28)
							(print "ai_count <= 28")
							(print "ai_count > 28!!")
						)
					)
				)
			)		
		0)
	150)
)

(script dormant print_timer
	(sleep 30)
	(print "30...")
	(sleep 30)
	(print "60...")
	(sleep 30)
	(print "90...")
	(sleep 30)
	(print "120...")
	(sleep 30)
	(print "150...")
	(sleep 30)
	(print "180...")
	(sleep 30)
	(print "210...")
	(sleep 30)
	(print "240...")
	(sleep 30)
	(print "270...")
	(sleep 30)
	(print "300...")
	(sleep 30)
	(print "330...")
	(sleep 30)
	(print "360...")
	(sleep 30)
	(print "390...")
	(sleep 30)
	(print "420...")
	(sleep 30)
	(print "450...")
	(sleep 30)
	(print "480...")
	(sleep 30)
	(print "510...")
	(sleep 30)
	(print "540...")
	(sleep 30)
	(print "570...")
	(sleep 30)
	(print "600...")
	(sleep 30)
	(print "630...")
	(sleep 30)
	(print "660...")
	(sleep 30)
	(print "690...")
	(sleep 30)
	(print "720...")
	(sleep 30)
	(print "750...")
)*;

(script static void unlock_all_doors
	(device_set_power f3_door_1 1.0)
	(device_set_power f4_door 1.0)
	(device_set_power f5_door_high_left 1.0)
	(device_set_power f5_door_low_left 1.0)
)

(global real s_truth_count 0)

(script static void (070_truth_flicker (scenery sce_grav_throne) (scenery sce_truth))
	(set s_truth_count 0)
	(sleep_until
		(begin
			(object_hide sce_truth FALSE)
			(object_hide sce_grav_throne FALSE)
			(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
				(sleep (random_range 4 15))
			(object_hide sce_truth true)
			(object_hide sce_grav_throne true)
			(set s_truth_count (+ s_truth_count 1))		
			(>= s_truth_count 7)
		)
	(random_range 1 10))
)

;====================================================================================================================================================================================================
;=============================== CAMERA BOUNDS ======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_camera_bounds
                ; turn on all camera bounds 
                (gs_camera_bounds_on)
                
                ; bowls
                (sleep_until (>= s_b1_progression 10) 1)
                                (soft_ceiling_enable camera_bowl1 FALSE)
                (sleep_until (>= s_b2_progression 10) 1)
                                (soft_ceiling_enable camera_bowl2 FALSE)
                (sleep_until (>= s_b2_progression 40) 1)
                                (soft_ceiling_enable camera_fp1 FALSE)

                ; Exploration
                (wake gs_camera_bounds_sd)
                (sleep_until (>= s_fp_progression 20) 1)
                                (soft_ceiling_enable camera_ex1 FALSE)
                                (soft_ceiling_enable camera_la1 FALSE)
                (sleep_until (>= s_ex_progression 40) 1)
                                (soft_ceiling_enable camera_ex2 FALSE)
                                (soft_ceiling_enable camera_sd2 FALSE)
			
                ; AntiAir Wraiths
                (sleep_until (>= s_ex_progression 60) 1)
                                (soft_ceiling_enable camera_aw1 FALSE)
                                (soft_ceiling_enable camera_aw2 FALSE)
                (sleep_until (>= s_aw_progression 20) 1)
                                (soft_ceiling_enable camera_aw2 TRUE)
                                (soft_ceiling_enable camera_la1 TRUE)
                          
                ; leading the army
                (sleep_until (>= s_la_progression 20) 1)
                                (soft_ceiling_enable camera_aw2 FALSE)
                (sleep_until (>= s_la_progression 40) 1)
                                (soft_ceiling_enable camera_la1 FALSE)
                (sleep_until (>= s_la_progression 60) 1)
                                (soft_ceiling_enable camera_sd1 FALSE)                              
                (sleep_until (>= s_la_progression 90) 1)
                                (soft_ceiling_enable camera_sd2 TRUE)


                ; Big Battle
                (sleep_until (>= s_bb_progression 40) 1)
                                (soft_ceiling_enable camera_bb1 FALSE)
                (sleep_until (>= s_bb_progression 60) 1)
                                (soft_ceiling_enable camera_bb2 FALSE)
)

(script dormant gs_camera_bounds_sd
	;Sentinel Defense
      (sleep_until (>= s_sd_progression 10) 1)
                      (soft_ceiling_enable camera_sd1 FALSE)
                      (soft_ceiling_enable camera_sd2 TRUE)
      (sleep_until (>= s_ex_progression 55) 1)
                      (soft_ceiling_enable camera_sd2 FALSE)
                      (soft_ceiling_enable camera_sd1 TRUE)
)
                                
(script static void gs_camera_bounds_off                            
                (if b_debug (print "turn off camera bounds"))

                ;Bowls
                                (soft_ceiling_enable camera_bowl1 FALSE)
                                (soft_ceiling_enable camera_bowl2 FALSE)
                                (soft_ceiling_enable camera_fp1 FALSE)

                ; Exploration
                                (soft_ceiling_enable camera_ex1 FALSE)
                                (soft_ceiling_enable camera_la1 FALSE)
                                (soft_ceiling_enable camera_ex2 FALSE)
                                (soft_ceiling_enable camera_sd2 FALSE)
                                
                ;Sentinel Defense
                                (soft_ceiling_enable camera_sd1 FALSE)

                ; AntiAir Wraiths
                                (soft_ceiling_enable camera_aw1 FALSE)
                                (soft_ceiling_enable camera_aw2 FALSE)
                                
                ; leading the army
                                (soft_ceiling_enable camera_la1 FALSE)

                ; Big Battle
                                (soft_ceiling_enable camera_bb1 FALSE)
                                (soft_ceiling_enable camera_bb2 FALSE)
)                         

(script static void gs_camera_bounds_on                             
                (if b_debug (print "turn on camera bounds"))

                ; bowls
                                (soft_ceiling_enable camera_bowl1 TRUE)
                                (soft_ceiling_enable camera_bowl2 TRUE)
                                (soft_ceiling_enable camera_fp1 TRUE)

                ; Exploration
                                (soft_ceiling_enable camera_ex1 TRUE)
                                (soft_ceiling_enable camera_la1 TRUE)
                                (soft_ceiling_enable camera_ex2 TRUE)
                                (soft_ceiling_enable camera_sd2 TRUE)
                                
                ;Sentinel Defense
                                (soft_ceiling_enable camera_sd1 TRUE)

                ; AntiAir Wraiths
                                (soft_ceiling_enable camera_aw1 TRUE)
                                (soft_ceiling_enable camera_aw2 TRUE)
                                (soft_ceiling_enable camera_la1 TRUE)
                                

                ; Big Battle
                                (soft_ceiling_enable camera_bb1 TRUE)
                                (soft_ceiling_enable camera_bb2 TRUE)
)

;***************************************************************
********************** Landing Zone (LZ) ***********************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_lz_progression 0)
(global ai ai_fly_johnson allies_lz_johnson)
(global ai ai_fly_pelican_marines_0 allies_lz_marines_0)
(global ai ai_fly_pelican_marines_1 allies_lz_marines_0)
(global ai ai_fly_pelican_marines_2 allies_lz_marines_0)
(global ai ai_fly_pelican_commander allies_lz_marines_0)
(global boolean b_lz_pelican_0_arrived 0)
(global boolean b_lz_pelican_1_arrived 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant lz_player_progression
	(sleep_until (volume_test_players vol_lz_exit_intro) 10)
	(set s_lz_progression 10)
	(if b_debug (print "s_lz_progression = 10"))
	
	(sleep_until (volume_test_players vol_lz_middle_explore) 10)
	(set s_lz_progression 20)
	(if b_debug (print "s_lz_progression = 20"))	
	
	(sleep_until (volume_test_players vol_lz_end) 10)
	(set s_lz_progression 30)
	(if b_debug (print "s_lz_progression = 30"))	
	
	(sleep_until (volume_test_players vol_lz_near_cave) 10)
	(set s_lz_progression 40)
	(if b_debug (print "s_lz_progression = 40"))	
)

(script dormant landing_zone
	(if b_debug (print "Starting landing zone"))
	
	(data_mine_set_mission_segment "070_011_landing_zone")	
	
	;Wake threads
	(wake md_lz_exit_pelican_0)
	(wake md_lz_exit_pelican_1)
	(wake md_lz_pelican_arrives)
	(wake md_lz_odst_explore)
	(wake 070va_ark_arrival)		
	
	(sleep_until 
		(or
			b_lz_pelican_0_arrived
			b_lz_pelican_1_arrived
		)
	30 1800)
	(wake lz_player_progression)
)

(script static void landing_zone_cleanup
	(ai_disposable allies_lz_pelican_0 true)
	(ai_disposable allies_lz_johnson true)
	
	(sleep_forever lz_player_progression)
	(sleep_forever landing_zone)
	
	(set s_lz_progression 200)
	
	(add_recycling_volume vol_lz_recycle 0 5)
)

;***************************************************************
************************ Bowl 1 (B1) ***************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_b1_progression 0)
(global boolean b_b1_finished 0)
(global boolean b_b1_combat_started 0)
(global boolean b_b1_wake 0)
(global short s_b1_allies_progression 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_b1_reinf
	(cs_enable_moving false)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(sleep_until
		(or
			(< (ai_strength (ai_get_squad ai_current_actor)) 1)
			(>= s_b1_progression 40)
			(and
				(<= (ai_task_count obj_b1_cov/front) 0)
				(<= (ai_task_count obj_b1_cov/before_combat) 0)
			)
		)
	)
)

(script command_script cs_b1_chieftain_point
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_abort_on_alert true)
	
	(set b_b1_wake 1)
	
	(sleep 120)
	;(cs_action pts_b1_patrol/p22 ai_action_signal_move)
	;(cs_action pts_b1_patrol/p22 ai_action_point)
	(cs_action pts_b1_patrol/p22 ai_action_advance)
)

(script command_script cs_b1_wait_and_wake
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_abort_on_alert true)
	
	(sleep_until b_b1_wake 10)
	(sleep (random_range 30 60))
	(cs_force_combat_status ai_combat_status_active)
)

(script command_script cs_b1_get_in_turret_0
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(sleep_until b_b1_combat_started 10)
	
	(cs_go_to pts_b1_turrets/p9)
	
	(sleep_until (volume_test_object vol_b1_watchtower ai_current_actor))
	
	(ai_vehicle_enter ai_current_actor (object_get_turret b1_watchtower_pod 0))
)

(script command_script cs_b1_get_in_turret_1
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(sleep_until b_b1_combat_started 10)
	
	(cs_go_to pts_b1_turrets/p10)
	
	(sleep_until (volume_test_object vol_b1_watchtower ai_current_actor))
	
	(ai_vehicle_enter ai_current_actor (object_get_turret b1_watchtower_pod 1))
)

(script command_script cs_b1_stay_in_turret_0
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_until 
		(or
			(volume_test_players vol_b1_watchtower)
			(not (vehicle_test_seat (object_get_turret b1_watchtower_pod 0) "" ai_current_actor))
		)
	)
)

(script command_script cs_b1_stay_in_turret_1
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_until 
		(or
			(volume_test_players vol_b1_watchtower)
			(not (vehicle_test_seat (object_get_turret b1_watchtower_pod 1) "" ai_current_actor))
		)
	)
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant b1_stay_in_turret_0
	(sleep_until (vehicle_test_seat (object_get_turret b1_watchtower_pod 0) "" cov_b1_watchtower/0) 10)
	(cs_run_command_script cov_b1_watchtower/0 cs_b1_stay_in_turret_0)
)

(script dormant b1_stay_in_turret_1
	(sleep_until (vehicle_test_seat (object_get_turret b1_watchtower_pod 1) "" cov_b1_watchtower/1) 10)
	(cs_run_command_script cov_b1_watchtower/1 cs_b1_stay_in_turret_1)
)

(script dormant b1_allies_progression
	(sleep_until b_b1_combat_started)
	(sleep_until 
		(and
			(<= (ai_task_count obj_b1_cov/front) 0)
			(<= (ai_task_count obj_b1_cov/front_jackals_0) 0)
			(<= (ai_task_count obj_b1_cov/front_jackals_1) 0)
			(>= s_b1_progression 32)
		)
	)
	(set s_b1_allies_progression 1)
	(sleep_until 
		(and
			(<= (ai_task_count obj_b1_cov/brutes) 0)
			(>= s_b1_progression 32)
		)
	)
	(set s_b1_allies_progression 2)
	(sleep_until 
		(and
			(<= (ai_task_count obj_b1_cov/jackals) 0)
			(<= (ai_task_count obj_b1_cov/brutes) 0)
			(>= s_b1_progression 35)
		)
	)
	(set s_b1_allies_progression 3)
)

(script dormant b1_player_progression
	(sleep_until 
		(or
			(volume_test_players vol_b1_cave_0)
			(>= s_b1_progression 10)
		)
	10)
	(set s_b1_progression 10)
	(if b_debug (print "s_b1_progression = 10"))
	
	(sleep_until (volume_test_players vol_b1_cave_1) 10)
	(set s_b1_progression 20)
	(if b_debug (print "s_b1_progression = 20"))
	
	(sleep_until 
		(or
			(volume_test_players vol_b1_left)
			(volume_test_players vol_b1_rear)
		)
	10)
	(set s_b1_progression 30)
	(if b_debug (print "s_b1_progression = 30"))
	
	(sleep_until 
		(or
			(volume_test_players vol_b1_down)
			(volume_test_players vol_b1_rear)
		)
	10)
	(set s_b1_progression 32)
	(if b_debug (print "s_b1_progression = 32"))
	
	(sleep_until 
		(or
			(volume_test_players vol_b1_middle)
			(volume_test_players vol_b1_rear)
		)
	10)
	(set s_b1_progression 35)
	(if b_debug (print "s_b1_progression = 35"))
		
	(sleep_until (volume_test_players vol_b1_rear) 10)
	(set s_b1_progression 40)
	(if b_debug (print "s_b1_progression = 40"))
)

(script dormant bowl_1
	(if b_debug (print "Starting bowl 1"))
	
	;Wake threads
	(wake b1_player_progression)
	(wake b1_allies_progression)
	(wake b1_truth_halogram)
	(wake md_b2_allies_prepare)
	
	(sleep_until (>= s_b1_progression 10))
	;(ai_place cov_b1_turrets)
		
	(wake md_b1_allies_prepare)
	(wake md_b1_allies_next)
	
	;Make sure the Covenant don't see your hiding allies
	(ai_disregard (ai_actors gr_allies) true)
	(ai_disregard (ai_actors allies_lz_pelican_0) true)
	
	(sleep_until (>= s_lz_progression 30) 5)
	(game_save)
	(ai_place cov_b1_ini)
	(sleep 1)
	(ai_place cov_b1_ini_grunts_0)
	(sleep 1)
	(ai_place cov_b1_ini_brutes_0)
	(sleep 1)
	(ai_place cov_b1_ini_jackals_0)
	(sleep 1)
	(ai_place cov_b1_ini_jackals_1)
	(sleep 1)
	(ai_place cov_b1_ini_jackals_2)
	(sleep 1)
	(ai_place cov_b1_watchtower)
	
	; Migrate everybody before cleaning up the previous section	
	(data_mine_set_mission_segment "070_012_bowl_1")

	;Migrate squads...
	(ai_migrate allies_lz_marines_0 allies_b1_marines_0)
	(wake b1_stay_in_turret_0)
	(wake b1_stay_in_turret_1)
	
	(sleep 30)
	(sleep_until 
		(or
			(>= (ai_combat_status cov_b1_ini) ai_combat_status_active)
			(>= (ai_combat_status cov_b1_ini_jackals_0) ai_combat_status_active)
			(>= (ai_combat_status cov_b1_ini_jackals_1) ai_combat_status_active)
			(>= (ai_combat_status cov_b1_ini_jackals_2) ai_combat_status_active)
			(>= (ai_combat_status cov_b1_ini_brutes_0) ai_combat_status_active)
			(>= (ai_combat_status cov_b1_ini_grunts_0) ai_combat_status_active)
			(>= (ai_combat_status cov_b1_watchtower) ai_combat_status_active)
			(<= (ai_living_count cov_b1_ini) 0)
			(> s_b1_progression 30)
		)
	15 3600)
	

	(ai_disregard (ai_actors gr_allies) false)
	(ai_disregard (ai_actors allies_lz_pelican_0) false)
	(ai_enter_squad_vehicles cov_b1_turrets)
	(set b_b1_combat_started 1)
	
	(sleep_until 
		(or
			(<= (ai_task_count obj_b1_cov/front) 0)
			(>= s_b1_progression 40)
		)
	10)
	
	(if (< s_b1_progression 40)
		(ai_place cov_b1_wave_1)
	)	
	
	(sleep_until (<= (ai_living_count gr_cov_b1) 1))
	(sleep_until (<= (ai_living_count gr_cov_b1) 0) 30 1800)
	
	(set b_b1_finished 1)
)

(script static void bowl_1_cleanup
	(ai_disposable gr_cov_b1 true)
	
	(object_destroy_folder crt_b1)
	
	(sleep_forever b1_player_progression)
	(sleep_forever bowl_1)
	
	(set s_b1_progression 200)
	
	(add_recycling_volume vol_b1_recycle 0 5)
)

;***************************************************************
************************ Bowl 2 (B2) ***************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_b2_progression 0)
(global boolean b_b2_combat_started 0)
(global boolean b_b2_hunters_placed 0)
(global boolean b_b2_finished 0)
(global boolean b_b2_elites_charge 0)
(global boolean b_b2_hunters_dead 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(global vehicle b2_phantom NONE)
(global ai ai_b2_grunts_0 NONE)
(global ai ai_b2_grunts_1 NONE)
(script command_script cs_b2_phantom
	(set b2_phantom (ai_vehicle_get_from_starting_location cov_b2_phantom/pilot))
	;Unload the guys for the next encounter
	(cs_enable_moving false)
	(cs_enable_looking false)
	(cs_enable_targeting false)
	
	(ai_place cov_b2_grunts_0)
	(ai_place cov_b2_brutes_0)
	(sleep 1)
	(set ai_b2_grunts_0 cov_b2_grunts_0)
	(set ai_b2_grunts_1 cov_b2_brutes_0)
	(ai_vehicle_enter_immediate cov_b2_brutes_0 b2_phantom "phantom_p_rb")
	(ai_vehicle_enter_immediate cov_b2_grunts_0 b2_phantom "phantom_p_rf")
	
	(sleep_until 
		(or
			(>= s_b2_progression 20)
			(< (ai_strength ai_b2_grunts_0) 1)
			(< (ai_strength ai_b2_grunts_1) 1)
		)
	)
	(sleep_until 
		(and
			(>= s_b2_progression 25)
			(objects_can_see_object (players) (ai_get_object ai_current_actor) 30)
		)
	30 300)
	
	(vehicle_unload b2_phantom "phantom_p_rb")
	(sleep 15)
	(vehicle_unload b2_phantom "phantom_p_rf")
	(sleep 60)
	
	(sleep_until b_b2_combat_started 30 300)
	
	;Exit the scene!
	(cs_fly_to pts_b2_phantom/p1)
	(kill_players_in_volume vol_b2_kill_players)
	(cs_fly_to pts_b2_phantom/p2)
	(cs_fly_to pts_b2_phantom/p3)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_b2_phantom_bfg
	(cs_enable_pathfinding_failsafe true)	
	(cs_enable_moving false)
	(cs_enable_looking false)
	(cs_enable_targeting false)
	
	(object_create b2_bfg_neck)
	(objects_attach (ai_vehicle_get_from_starting_location cov_b2_phantom_bfg/pilot) "large_cargo" b2_bfg_neck "gun_joint")
	(object_set_phantom_power (ai_vehicle_get_from_starting_location cov_b2_phantom_bfg/pilot) true)
	
	(cs_vehicle_speed 0.3)
	(sleep_until 
		(begin
			(cs_fly_to pts_b2_phantom/p7 1)
			(cs_fly_to pts_b2_phantom/p8 1)
			(and
				(>= s_b2_progression 20)
				b_b2_combat_started
			)
		)
	)
	
	;(cs_face true pts_b2_phantom/p6)
	
	;(sleep (random_range 150 210))
	
	;(cs_face false pts_b2_phantom/p6)
	
	;Phantom knows about the fight - exit the scene!
	(cs_vehicle_speed 1)
	(cs_fly_to pts_b2_phantom/p6 1)
	(objects_detach (ai_vehicle_get_from_starting_location cov_b2_phantom_bfg/pilot) b2_bfg_neck)
	(object_set_phantom_power (ai_vehicle_get_from_starting_location cov_b2_phantom_bfg/pilot) false)
	(cs_fly_to pts_b2_phantom/p1)
	(kill_players_in_volume vol_b2_kill_players)
	(cs_fly_to pts_b2_phantom/p2)
	(cs_fly_to pts_b2_phantom/p3)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_b2_phantom_drop_hunters
	(cs_enable_pathfinding_failsafe TRUE)	
	(cs_fly_to pts_b2_phantom/p4)
	(cs_vehicle_boost true)
	(cs_fly_to pts_b2_phantom/p5)
	(cs_vehicle_boost false)
	(cs_fly_to_and_face pts_b2_phantom/p0 pts_b2_phantom/face_at 1)
	(set b_b2_hunters_placed 1)
	;HACK UNTIL WE GET HUNTERS IN PHANTOM
	(sleep 30)
	(ai_trickle_via_phantom cov_b2_hunter_phantom/pilot cov_b2_hunter_0)
	(ai_trickle_via_phantom cov_b2_hunter_phantom/pilot cov_b2_hunter_1)
	(sleep 45)
	(cs_fly_to pts_b2_phantom/p9)
	(cs_fly_to pts_b2_phantom/p1)
	(kill_players_in_volume vol_b2_kill_players)
	(cs_fly_to pts_b2_phantom/p2)
	(cs_fly_to pts_b2_phantom/p3)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_b2_reinf
	(cs_enable_moving false)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(sleep_until
		(or
			(< (ai_strength (ai_get_squad ai_current_actor)) 1)
			(>= s_b2_progression 27)
			b_b2_hunters_dead
		)
	)
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant b2_manage_reinf
	(sleep_until (= (current_zone_set_fully_active) 1) 10)
	(ai_place cov_b2_reinf)
	(ai_place cov_b2_reinf_grunts)
	
	(if (>= (game_difficulty_get_real) legendary)
		(ee_activate)
	)
)

(script dormant b2_manage_blindness
	(ai_set_blind cov_b2_grunts_0 true)
	(ai_set_blind cov_b2_brutes_0 true)
	(ai_set_blind cov_b2_jackals true)

	(player_action_test_reset)	
	(sleep_until
		(or
			b_b2_combat_started
			(>= s_b2_progression 26)
			(player_action_test_primary_trigger)
			(player_action_test_grenade_trigger)
		)
	1)
	
	(ai_set_blind cov_b2_grunts_0 false)
	(ai_set_blind cov_b2_brutes_0 false)
	(ai_set_blind cov_b2_jackals false)
)

(script dormant b2_player_progression
	(sleep_until (volume_test_players vol_b2_cave_0) 10)
	(set s_b2_progression 10)
	(if b_debug (print "s_b2_progression = 10"))
	
	;Start 070_music_01
	(set b_070_music_01 1)
	
	(sleep_until (volume_test_players vol_b2_cave_1) 10)
	(set s_b2_progression 20)
	(if b_debug (print "s_b2_progression = 20"))
	
	(sleep_until (volume_test_players vol_b2_cave_2) 10)
	(set s_b2_progression 25)
	(if b_debug (print "s_b2_progression = 25"))
	
	(sleep_until 
		(or
			(volume_test_players vol_b2_middle)
			(volume_test_players vol_b2_ramp_0)
		)
	10)
	(set s_b2_progression 26)
	(if b_debug (print "s_b2_progression = 26"))
	
	(sleep_until 
		(or
			(volume_test_players vol_b2_ramp_base)
			(volume_test_players vol_b2_ramp_0)
		)
	10)
	(set s_b2_progression 27)
	(if b_debug (print "s_b2_progression = 27"))
	
	(sleep_until (volume_test_players vol_b2_ramp_0) 10)
	(set s_b2_progression 30)
	(if b_debug (print "s_b2_progression = 30"))

	(sleep_until (volume_test_players vol_b2_ramp_1) 10)
	(set s_b2_progression 40)
	(if b_debug (print "s_b2_progression = 40"))
)

(script dormant bowl_2
	(if b_debug (print "Starting bowl 2"))
	(game_save)
	
	;Wake threads
	(wake b2_player_progression)
	(wake 070_music_01)
	(wake 070_music_02)
	(wake 070_music_03)
	(wake 070_music_04)
	(wake 070_music_05)

	; Migrate everybody before cleaning up the previous section	
	(data_mine_set_mission_segment "070_013_bowl_2")
	
	;Place enemies
	(ai_place cov_b2_snipers)
	(sleep 1)
	(ai_place cov_b2_phantom)
	(sleep 1)
	(ai_place cov_b2_phantom_bfg)
	(sleep 1)
	(ai_place cov_b2_pack)
	(sleep 1)
	(ai_place cov_b2_jackals)
	
	(cs_run_command_script (ai_get_turret_ai cov_b2_phantom 0) cs_do_nothing)
	(cs_run_command_script (ai_get_turret_ai cov_b2_phantom_bfg 0) cs_do_nothing)
	(ai_set_blind cov_b2_phantom true)
	(ai_set_blind cov_b2_phantom_bfg true)	
		
	;Migrate squads...
	(ai_migrate allies_b1_marines_0 allies_b2_marines_0)
	(ai_migrate allies_b1_intro_marine allies_b2_marines_0)
	(sleep 1)
	
	(object_cannot_die b2_bfg true)
	
	(wake md_b2_allies_next)
	(wake ba_gain_foothold)
	(wake b2_manage_reinf)
	(wake b2_manage_blindness)
	
	(sleep_until 
		(or
			(>= (ai_combat_status cov_b2_pack) ai_combat_status_active)
			(<= (ai_living_count cov_b2_pack) 0)
			(>= s_b2_progression 40)
		)
	)
	
	(set b_b2_combat_started 1)
	
	(ai_set_blind cov_b2_phantom false)
	(ai_set_blind cov_b2_phantom_bfg false)
	
	;Start 070_music_02
	(set b_070_music_02 1)
	
	(sleep_until 
		(or 
			(<= (ai_living_count gr_cov_b2_initial) 7)
			(>= s_b2_progression 27)
		)
	10)
	
	(sleep_until 
		(or 
			(and
				(<= (ai_living_count cov_b2_pack/brute) 0)
				(<= (ai_living_count cov_b2_grunts_0/brute) 0)
			)
			(<= (ai_living_count gr_cov_b2_initial) 6)
			(>= s_b2_progression 27)
		)
	)
	
	(set b_b2_elites_charge 1)
		
	(ai_place cov_b2_hunter_phantom)
	(sleep 1)
	(ai_cannot_die cov_b2_hunter_phantom/pilot true)
	(object_cannot_take_damage (ai_vehicle_get cov_b2_hunter_phantom/pilot))
	
	(sleep_until (game_safe_to_save) 30 450)
	(game_save)
		
	(sleep_until 
		(or
			b_b2_hunters_placed
			(<= (ai_living_count cov_b2_hunter_phantom) 0)
		)
	)
	
	;Stop 070_music_01
	(set b_070_music_01 0)
	;Start 070_music_02_alt
	(if debug (print "start music 070_02 alternate"))
	(sound_looping_set_alternate levels\solo\070_waste\music\070_music_02 TRUE)
	;Start 070_music_03
	(set b_070_music_03 1)
	
	(sleep 300)
	
	(sleep_until (<= (ai_living_count gr_cov_b2_hunters) 1) 10)
	;Start 070_music_04
	(set b_070_music_04 1)
	
	(sleep_until (<= (ai_living_count gr_cov_b2_hunters) 0))
	(set b_b2_hunters_dead 1)
	
	;Stop 070_music_03
	(set b_070_music_03 0)
	;Start 070_music_05
	(set b_070_music_05 1)
	
	(sleep_until (game_safe_to_save) 30 150)
	(game_save)
	
	(sleep_until (<= (ai_living_count gr_cov_b2) 2))
	(sleep_until (<= (ai_living_count gr_cov_b2) 0) 30 28800)
	(set b_b2_finished 1)
)

(script static void bowl_2_cleanup
	(ai_disposable gr_cov_b2 true)

	(object_destroy_folder crt_b2)
	(object_destroy_folder sce_bowls)
	
	(sleep_forever b2_player_progression)
	(sleep_forever bowl_2)
	
	(set s_b2_progression 200)

	(add_recycling_volume vol_b2_recycle 0 5)
)

;***************************************************************
****************** Forerunner Passage (FP) *********************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_fp_progression 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant fp_player_progression
	(sleep_until (volume_test_players vol_fp_entrance) 10)
	(set s_fp_progression 10)
	(if b_debug (print "s_fp_progression = 10"))

	(sleep_until (volume_test_players vol_fp_before_door) 10)
	(set s_fp_progression 15)
	(if b_debug (print "s_fp_progression = 15"))
	
	(sleep_until (volume_test_players vol_fp_front_door) 10)
	(set s_fp_progression 20)
	(if b_debug (print "s_fp_progression = 20"))
)

(script dormant forerunner_passage	
	(if b_debug (print "Starting forerunner passage"))
	(game_save)
	
	;Wake threads
	(wake background_exploration)
	(wake fp_player_progression)
	(wake md_fp_allies_next)
	
	;Create terminal
	(object_create fp_terminal)
	(objects_attach fp_terminal_base "forerunner_terminal" fp_terminal "")	

	; Migrate everybody before cleaning up the previous section	
	(data_mine_set_mission_segment "070_014_forerunner_passage")
	
	(sleep_until 
		(or
			b_b2_finished
			(>= s_fp_progression 15)
		)
	)
	
	;Migrate squads...
	(ai_migrate allies_b2_marines_0 allies_fp_marines_0)
	(sleep 1)
)

(script static void forerunner_passage_cleanup
	(object_destroy_folder crt_fp)

	(sleep_forever fp_player_progression)
	(sleep_forever forerunner_passage)
	
	(set s_fp_progression 200)
	
	(add_recycling_volume vol_fp_recycle 0 5)
)

;***************************************************************
********************** Exploration (EX) ************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_ex_progression 0)
(global boolean b_ex_p1_finished 0)
(global boolean b_ex_p1_has_started 0)
(global ai ai_gunner_brute cov_ex_pack/brute)
(global boolean b_ex_has_started 0)
(global boolean b_ex_part_2_finished 0)
(global boolean b_ex_mauler_charge 0)
(global boolean b_ex_cave_finished 0)
(global boolean b_ex_maulers_spawned 0)
(global short s_ex_nb_allies 0)
(global boolean b_ex_cave_dialog_finished 0)
(global vehicle veh_mauler_0 none)
(global vehicle veh_mauler_1 none)
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_ex_mauler
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_moving true)
	(cs_abort_on_vehicle_exit true)
	(cs_go_to pts_ex_mauler/p5)
	(object_set_velocity (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) 10)
	(cs_go_to pts_ex_mauler/p0)
	(if (not (volume_test_players vol_ex_near_entrance))
		(cs_go_to pts_ex_mauler/p2)
		(cs_go_to pts_ex_mauler/p1)
	)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) "mauler_d" true)
	(cs_abort_on_vehicle_exit false)
	(ai_vehicle_exit ai_current_actor)
	(sleep 120)
	(ai_migrate ai_current_actor cov_ex_pack_ini_0)
)

(script command_script cs_ex_mauler_1
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_moving true)
	(cs_abort_on_vehicle_exit true)
	(cs_go_to pts_ex_mauler/p5)
	(object_set_velocity (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver) 10)
	(cs_go_to pts_ex_mauler/p3)
)

(script command_script cs_ex_abandon_mauler
	;(ai_vehicle_enter_immediate ai_current_actor (ai_vehicle_get_from_starting_location cov_ex_mauler/driver))
	(sleep 1)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_abort_on_vehicle_exit true)
	
	(sleep_until (volume_test_object vol_ex_exit_mauler ai_current_actor) 30 600)
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) "mauler_p_l" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) "mauler_p_r" true)
	
	(if (<= (game_difficulty_get_real) normal)
		(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) "mauler_g" true)
	)
	
	(cs_abort_on_vehicle_exit false)
	
	;On legendary and heroic, keep the mauler gunner inside
	(if 	(or
			(<= (game_difficulty_get_real) normal)
			(not (vehicle_test_seat (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) "mauler_g" ai_current_actor))
		)
		(begin
			(ai_vehicle_exit ai_current_actor)
			(sleep 120)
			(ai_migrate ai_current_actor cov_ex_pack_ini_0)
		)
	)
)

(script command_script cs_ex_mauler_passenger_0
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_abort_on_vehicle_exit true)
	
	(sleep_until 
		(or
			(<= (ai_task_count obj_ex_cov/infantry) 4)
			(<= (ai_living_count cov_ex_mauler_1/gunner) 0)
			(<= (ai_living_count cov_ex_mauler_1/driver) 0)
		)
	)
	
	(sleep_until 
		(or
			(and
				(volume_test_object vol_ex_exit_mauler_large ai_current_actor)
				(<= (ai_task_count obj_ex_cov/infantry) 4)
			)
			(<= (ai_living_count cov_ex_mauler_1/gunner) 0)
			(<= (ai_living_count cov_ex_mauler_1/driver) 0)
		)
	30 3600)
	
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver) "mauler_p_l" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver) "mauler_p_r" true)
	(ai_vehicle_exit ai_current_actor)
	(sleep 15)
	(ai_migrate ai_current_actor cov_ex_pack_ini_0)
)

(script command_script cs_ex_knelt_marine
	(cs_crouch true)
	(sleep_until 
		(or
			b_ex_p1_has_started
			(>= s_ex_progression 10)
		)
	)
)

(script command_script cs_ex_enter_vehicle
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(sleep_until (>= s_ex_progression 35) 15)
	(cs_draw)
	(cs_abort_on_damage false)
	(cs_movement_mode ai_movement_combat)
	(ai_enter_squad_vehicles (ai_get_squad ai_current_actor))
)

(script command_script cs_ex_ghost_3
	(cs_stow)
	(cs_posture_set "act_examine_1" false)
	(cs_abort_on_damage true)
	(sleep_until 
		(or
			(>= s_ex_progression 40)
			(<= (ai_strength gr_cov_ex_p2) 0.75)
		)
	15)
	(cs_draw)
	(cs_abort_on_damage false)
	(cs_enable_targeting true)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_movement_mode ai_movement_combat)
	(ai_enter_squad_vehicles (ai_get_squad ai_current_actor))
)

(script command_script cs_ex_cave_ghost
	(cs_enable_moving false)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(sleep_until (>= s_ex_progression 65) 10 900)
)
;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant ex_manage_empty_chopper_0
	(ai_place cov_ex_empty_chopper_0)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_0/chopper) true)
	(sleep_until 
		(or
			(player_in_vehicle (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_0/chopper))
			(>= s_lb_progression 15)
		)
	150)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_0/chopper) false)
)

(script dormant ex_manage_empty_chopper_1
	(ai_place cov_ex_empty_chopper_1)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_1/chopper) true)
	(sleep_until 
		(or
			(player_in_vehicle (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_1/chopper))
			(>= s_lb_progression 15)
		)
	150)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_1/chopper) false)
)

(script dormant ex_manage_empty_chopper_2
	(ai_place cov_ex_empty_chopper_2)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_2/chopper) true)
	(sleep_until 
		(or
			(player_in_vehicle (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_2/chopper))
			(>= s_lb_progression 15)
		)
	150)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_empty_chopper_2/chopper) false)
)

(script dormant ex_manage_maulers
	(sleep_until b_ex_maulers_spawned)
	(sleep 300)
	
	(sleep_until 
		(or
			(player_in_a_vehicle)
			(and
				(<= (ai_task_count obj_ex_cov/infantry) 1)
				(<= (ai_living_count cov_ex_mauler) 0)
			)
		)
	30 1800)
	
	(if (not (player_in_a_vehicle))
		(sleep_until (player_in_a_vehicle) 30 150)
	)
	
	(sleep 90)
	
	(set b_ex_mauler_charge 1)
)

(script dormant ex_manage_vehicle_reservation
	;Cancel reservation only if the player is in a vehicle (that is not the turret)
	(sleep_until 
		(and
			b_ex_maulers_spawned
			(OR 
				(player_in_a_vehicle)
				(>= s_ex_progression 30)
				b_ex_p1_finished
				b_ex_part_2_finished
			)
		)
	)
		
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_ex_mongoose_0/mongoose_0) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_ex_mongoose_1/mongoose_1) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver) false)	
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_ex_warthog_0/warthog) false)	
	
	(sleep_until
		(or
			(>= s_ex_progression 35)
			b_ex_p1_finished
		)
	)
	;Unreserve maulers again, the brutes might have reserved them
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) false)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver) false)	
	(object_cannot_die (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) false)
)

(script dormant ex_marines_get_in_vehicle
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_ex_mongoose_0/mongoose_0) true)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_ex_mongoose_1/mongoose_1) true)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_ex_warthog_0/warthog) true)	
	
	(wake ex_manage_vehicle_reservation)
	
	(sleep_until (or b_ex_p1_finished b_ex_part_2_finished))
	
	(sleep 60)
	
	;Migrate all ennemy vehicles to your marines, so they want to use them
	(if (<= (ai_living_count cov_ex_mauler) 0)
		(ai_migrate cov_ex_mauler allies_ex_mongoose_0)
	)
	(if (<= (ai_living_count cov_ex_mauler_1) 0)
		(ai_migrate cov_ex_mauler_1 allies_ex_mongoose_0)
	)
	
	(sleep (random_range 30 90))
		
	;Try to enter vehicles until the player went in another area
	(sleep_until
		(begin
			(ai_enter_squad_vehicles gr_marines)
			(>= s_ex_progression 40)
		)
	210)
)

(script dormant ex_manage_crashed_phantom
	(sleep_until (>= s_ex_progression 40))
	(ai_place cov_ex_crashed_grunts)
	
	(sleep_until
		(or
			(>= s_ex_progression 45)
			(>= s_aw_progression 10)
		)
	)
	
	(ai_activity_abort cov_ex_crashed_grunts)
	(ai_enter_squad_vehicles cov_ex_crashed_grunts)
)

(script static boolean (ex_is_object_alive_in_volume (vehicle veh_current) (trigger_volume vol_current))
	(and
		(> (object_get_health veh_current) 0)
		(volume_test_object vol_current veh_current)
	)
)

(script dormant ex_cave
	(sleep_until (>= s_ex_progression 50))
	
	(ai_place cov_ex_trench_ghosts)
	
	(sleep_until (>= s_ex_progression 60))
	
	;Kill the vehicles at that time, so that they have fire FX on them
	;Only kill the warthog if the player has a group 
	;transport vehicle working in that area
	(if 
		(or
			(ex_is_object_alive_in_volume veh_mauler_0 vol_ex_later_half)
			(ex_is_object_alive_in_volume veh_mauler_1 vol_ex_later_half)
			(ex_is_object_alive_in_volume (ai_vehicle_get_from_starting_location allies_ex_warthog_1/warthog) vol_ex_later_half)
		)			
		(unit_kill ex_cave_warthog)
	)
	(sleep 1)
	(unit_kill ex_cave_mongoose)
	
	(wake md_ex_marines_cave)	
		
	(ai_place cov_ex_cave_jackals_0)
	(sleep 1)
	(ai_place cov_ex_cave_jackals_1)
	(sleep 1)
	(ai_place cov_ex_cave)
	(sleep 1)
	(ai_place cov_ex_cave_ghosts)
	(sleep 1)
	(ai_place allies_ex_cave_0)
	(sleep 1)
	(ai_place allies_ex_cave_1)
	(sleep 1)
	(ai_magically_see gr_cov_ex_cave allies_ex_cave_0)
	(ai_magically_see gr_cov_ex_cave allies_ex_cave_1)
	(ai_magically_see allies_ex_cave_0 gr_cov_ex_cave)
	(ai_magically_see allies_ex_cave_1 gr_cov_ex_cave)
	
	;Kill some allies if there is a lot of allies already
	(if (> (ai_living_count gr_marines) 7)
		(ai_kill allies_ex_cave_0/marine_0)
	)
	(if (> (ai_living_count gr_marines) 6)
		(ai_kill allies_ex_cave_1/marine_1)
	)
	
	(sleep_until 
		(or
			(<= (ai_living_count gr_cov_ex_cave_inf) 0)
			(>= s_aw_progression 10)
		)
	10)
	
	(set b_ex_cave_finished 1)
	
	(ai_set_objective cov_ex_cave_ghosts obj_aw_cov)
	
	(sleep_until 
		(begin
			(ai_migrate (ai_player_get_vehicle_squad (player0)) allies_aw_mongoose_0)
			(ai_migrate (ai_player_get_vehicle_squad (player1)) allies_aw_mongoose_0)
			(ai_migrate (ai_player_get_vehicle_squad (player2)) allies_aw_mongoose_0)
			(ai_migrate (ai_player_get_vehicle_squad (player3)) allies_aw_mongoose_0)
			(>= s_aw_progression 10)
		)
	)
	;Any guys not in a vehicle will get his own little squad
	(ai_migrate_infanty gr_marines allies_aw_infantry)
	
	;The rest advances bravely to battle
	(ai_migrate allies_ex_cave_0 allies_aw_mongoose_0)
	(ai_migrate allies_ex_cave_1 allies_aw_mongoose_0)
	(ai_migrate allies_ex_mongoose_0 allies_aw_mongoose_0)
	(ai_migrate allies_ex_mongoose_1 allies_aw_mongoose_1)
	(ai_migrate allies_ex_warthog_1 allies_aw_warthog_0)
	(ai_migrate allies_ex_warthog_0 allies_aw_warthog_0)
	
	(ai_erase_inactive gr_marines 0)
)

(script dormant ex_longsword_search
	(sleep_until 
		(or
			(>= s_ex_progression 27)
			b_ex_p1_finished
		)
	10)	
		
	(sleep_until (>= s_ex_progression 27) 10)
	(ai_place cov_ex_search_brutes_2)
	(sleep 1)
	(ai_place cov_ex_search_grunts_0)
	(sleep 1)
	(ai_place cov_ex_search_grunts_3)
	(sleep 1)
	(ai_place cov_ex_search_brutes_0)
	(sleep 1)
	(ai_place cov_ex_search_brutes_1)
	(sleep 1)
	(ai_place cov_ex_search_pack)
	(sleep 1)
	(ai_place allies_ex_warthog_1)
	
	(sleep_until (<= (ai_living_count gr_cov_ex_p2) 1) 90 1800)
	
	(sleep_until (<= (ai_living_count gr_cov_ex_p2) 2))
	
	(set b_ex_part_2_finished 1)
)

;Spawn other marines, just so that you've got allies in your vehicles
;Spawn when combat is almost over, and if you don't have a lot of allies
(script dormant ex_manage_marines_reinf
	(sleep_until
		(or
			(and
				(<= (ai_living_count gr_marines) 1)
				(<= (ai_living_count gr_cov_ex_p1) 3)
				b_ex_maulers_spawned
				(not (volume_test_players vol_fp_all))
			)
			(>= s_ex_progression 35)
		)
	)
	(if (< s_ex_progression 35)
		(ai_place allies_ex_marines_reinf)
	)
)

(script dormant ex_game_save
	(game_save)
	
	(sleep_until 
		(or 
			b_ex_maulers_spawned
			(>= s_ex_progression 30)
		)		
	)
	
	(if (< s_ex_progression 30)
		(game_save)
	)
	
	(sleep_until 
		(>= s_ex_progression 30)
	)
	(if b_ex_p1_finished
		(game_save)
	)
	
	(sleep_until 
		(or
			b_ex_part_2_finished
			(>= s_ex_progression 55)
		)
	)
	(if b_ex_part_2_finished
		(game_save)
	)
	
	(sleep_until
		(or
			(volume_test_players vol_ex_checkpoint_before_sd)
			(>= s_ex_progression 55)
			b_sd_finished
		)
	)
	(if (volume_test_players vol_ex_checkpoint_before_sd)
		(game_save)
	)
	
	(sleep_until
		(or
			(>= s_ex_progression 55)
			b_sd_finished
		)
	)
	(if b_sd_finished
		(game_save)
	)
	
	(sleep_until 
		(and
			(<= (ai_living_count cov_ex_trench_ghosts) 0)		
			(>= s_ex_progression 60)
		)
	)
	(game_save)
	
	(sleep_until 
		(or
			(>= s_aw_progression 10)
			(and
				b_ex_cave_dialog_finished
				(volume_test_players vol_ex_exit)
			)
		)
	)
	(sleep_until (game_safe_to_save) 30 300)
	
	(if (< s_aw_progression 20)
		(game_save)
	)
)

(script dormant ex_player_progression
	(sleep_until (volume_test_players vol_ex_out_cave) 10)
	(set s_ex_progression 10)
	(if b_debug (print "s_ex_progression = 10"))
	
	(sleep_until 
		(or
			(volume_test_players vol_ex_ground)
			(volume_test_players vol_ex_near_crash)
			(volume_test_players vol_ex_leaving_0)
			(volume_test_players vol_ex_leaving_2)
		)
	10)
	(set s_ex_progression 20)
	(if b_debug (print "s_ex_progression = 20"))
	
	(sleep_until 
		(or
			(volume_test_players vol_ex_near_crash)
			(volume_test_players vol_ex_leaving_0)
			(volume_test_players vol_ex_leaving_2)
		)
	10)
	(set s_ex_progression 25)
	(if b_debug (print "s_ex_progression = 25"))
	
	(sleep_until 
		(or
			(volume_test_players vol_ex_leaving_0)
			(volume_test_players vol_ex_leaving_2)
		)
	10)
	(set s_ex_progression 27)
	(if b_debug (print "s_ex_progression = 27"))
	
	(sleep_until 
		(or
			(volume_test_players vol_ex_leaving_1)
			(volume_test_players vol_ex_leaving_2)
		)
	10)
	(set s_ex_progression 30)
	(if b_debug (print "s_ex_progression = 30"))
	
	(sleep_until (volume_test_players vol_ex_part_2) 10)
	(set s_ex_progression 35)
	(if b_debug (print "s_ex_progression = 35"))
	
	(sleep_until (volume_test_players vol_ex_longsword) 10)
	(set s_ex_progression 40)
	(if b_debug (print "s_ex_progression = 40"))
	
	(sleep_until (volume_test_players vol_ex_after_longsword) 10)
	(set s_ex_progression 45)
	(if b_debug (print "s_ex_progression = 45"))
	
	(sleep_until (volume_test_players vol_ex_near_trench) 10)
	(set s_ex_progression 50)
	(if b_debug (print "s_ex_progression = 50"))	
	
	(sleep_until (volume_test_players vol_ex_mid_trench) 10)
	(set s_ex_progression 55)
	(if b_debug (print "s_ex_progression = 55"))
	
	;Stop 070_music_06
	(set b_070_music_06 0)

	(sleep_until (volume_test_players vol_ex_exit_trench) 10)
	(set s_ex_progression 60)
	(if b_debug (print "s_ex_progression = 60"))
	
	(sleep_until (volume_test_players vol_ex_after_trench) 10)
	(set s_ex_progression 65)
	(if b_debug (print "s_ex_progression = 65"))
	
	(sleep_until (volume_test_players vol_ex_exit) 10)
	(set s_ex_progression 70)
	(if b_debug (print "s_ex_progression = 70"))
)

(script dormant exploration
	(if b_debug (print "Starting exploration"))	
	
	(set b_ex_has_started 1)
	
	(ai_erase_inactive gr_marines 0)
	
	;Stop 070_music_02
	(set b_070_music_02 0)
	;Stop 070_music_03
	(set b_070_music_03 0)
	
	; Migrate everybody before cleaning up the previous section	
	(ai_migrate allies_fp_marines_0 allies_ex_on_foot_0)
	
	; Place guys
	(data_mine_set_mission_segment "070_020_exploration")
	(ai_place allies_ex_on_foot_1)
	(sleep 1)
	(ai_place allies_ex_on_foot_0/0)
	(sleep 1)
	(ai_place cov_ex_pack_ini_0)
	(sleep 1)
	(ai_place cov_ex_pack_ini_1)
	(sleep 1)
	;(unit_add_equipment (unit allies_dying_marine/0) injured_profile true false)
	(ai_place allies_ex_mongoose_0)
	(sleep 1)
	(ai_place allies_ex_mongoose_1)
	(sleep 1)
	
	(set s_ex_nb_allies (ai_living_count gr_marines))
	;Don't spawn more marines if the player has enough allies
	(if (< s_ex_nb_allies 4)
		(ai_place allies_ex_on_foot_0/1)
	)
	(if (< s_ex_nb_allies 3)
		(ai_place allies_ex_on_foot_0/2)
	)
	
	;Spawn a destroyed warthog for solo and 2 player coop, 
	;clean one for 3 & 4 players
	(if (>= (game_coop_player_count) 3)
		(begin
			(object_destroy ex_wrecked_warthog)
			(object_destroy ex_wrecked_warthog_tire_0)
			(object_destroy ex_wrecked_warthog_tire_1)
			(sleep 1)
			(ai_place allies_ex_warthog_0)
		)
		(begin
			;AI never use the wrecked warthog
			(ai_vehicle_reserve ex_wrecked_warthog true)
		)
	)
	
	;Wake threads
	(wake ex_player_progression)
	(wake ex_marines_get_in_vehicle)
	(wake ex_cave)
	(wake ex_longsword_search)
	(wake ex_manage_crashed_phantom)
	(wake ex_game_save)
	(wake md_ex_marines_intro)
	(wake md_ex_marines_thanks)
	(wake md_ex_allies_next)
	(wake md_ambiant_radio)
	(wake md_ambiant_brute_radio)
	(wake ex_manage_empty_chopper_0)
	(wake ex_manage_empty_chopper_1)
	(wake ex_manage_empty_chopper_2)
	(wake ex_manage_marines_reinf)
	(wake 070_music_06)
	
	(sleep_until 
		(or
			(>= s_ex_progression 27)
			(> (ai_combat_status gr_cov_ex_p1) ai_combat_status_active)
			(<= (ai_living_count gr_cov_ex_p1) 0)
			(player_in_vehicle (ai_vehicle_get_from_starting_location allies_ex_mongoose_0/mongoose_0))
			(player_in_vehicle (ai_vehicle_get_from_starting_location allies_ex_mongoose_1/mongoose_1))
		)
	)
	(set b_ex_p1_has_started 1)
		
	;Wait until you defeated everyone
	(sleep_until 
		(or
			(>= s_ex_progression 27)
			(<= (ai_living_count gr_cov_ex_p1) 0)
			(player_in_vehicle (ai_vehicle_get_from_starting_location allies_ex_mongoose_0/mongoose_0))
			(player_in_vehicle (ai_vehicle_get_from_starting_location allies_ex_mongoose_1/mongoose_1))
		)
	)
	
	;Wait a little bit more
	(sleep_until 
		(or
			(>= s_ex_progression 27)
			(player_in_vehicle (ai_vehicle_get_from_starting_location allies_ex_mongoose_0/mongoose_0))
			(player_in_vehicle (ai_vehicle_get_from_starting_location allies_ex_mongoose_1/mongoose_1))
		)
	30 450)	
	
	;Spawn the maulers!
	(ai_place cov_ex_mauler)
	(sleep 1)
	(set veh_mauler_0 (ai_vehicle_get_from_starting_location cov_ex_mauler/driver))
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) "mauler_p_l" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) "mauler_p_r" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) "mauler_d" true)
	(object_cannot_die (ai_vehicle_get_from_starting_location cov_ex_mauler/driver) true)
	
	(ai_place cov_ex_mauler_1)
	(sleep 1)
	(set veh_mauler_1 (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver))
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver) "mauler_p_l" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver) "mauler_p_r" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location cov_ex_mauler_1/driver) "mauler_d" true)
	
	(wake ex_manage_maulers)
	
	(set b_ex_maulers_spawned 1)
	
	(sleep_until (<= (ai_living_count gr_cov_ex_p1) 1))
	(sleep_until (<= (ai_living_count gr_cov_ex_p1) 0) 30 3600)
	
	(set b_ex_p1_finished 1)
	
	;Clean up guys that would be left behind, inactive
	(ai_erase_inactive gr_marines 0)
	
	(sleep_until (>= s_ex_progression 35) 30 3600)
	
	(if (< s_ex_progression 35)
		(begin
			(hud_activate_team_nav_point_flag player flg_ex_p1_next 0)
			(sleep_until (>= s_ex_progression 35))
			(hud_deactivate_team_nav_point_flag player flg_ex_p1_next)
		)
	)
)

(script static void exploration_cleanup	
	(ai_disposable gr_cov_ex true)
	
	(sleep_forever ex_player_progression)
	
	(set s_ex_progression 200)
	
	(add_recycling_volume vol_ex_recycle 20 5)
)

;***************************************************************
******************* Sentinel Defense (SD) **********************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_sd_progression 0)
(global boolean b_sd_grunts_flee 0)
(global boolean b_sd_more_sentinel_spawned 0)
(global boolean b_sd_warthog_can_go 0)
(global boolean b_sd_finished 0)
(global boolean b_sd_cartographer_hint 0)
(global boolean b_sd_sentinels_charge 0)
(global short s_sd_sentinel_count 2)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_sd_flee
	(cs_enable_moving TRUE)
	(cs_shoot FALSE)
	(cs_enable_looking FALSE)
	(cs_enable_targeting FALSE)
	
	(cs_movement_mode ai_movement_flee)
	(sleep (random_range 450	660))
)

(script command_script cs_sd_sentinel_cleanup
	(cs_enable_moving TRUE)
	(cs_abort_on_damage true)
	(sleep_forever)
)

(script command_script cs_sd_chopper_0
	(cs_posture_set "act_gaze_1" false)
	(sleep_until (>= s_sd_progression 10) 15)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location cov_sd_chopper_0/chopper))
	(cs_movement_mode ai_movement_combat)
	(cs_enable_moving true)
	(sleep_until (unit_in_vehicle ai_current_actor) 10 450)
	(cs_enable_moving false)
	(cs_abort_on_vehicle_exit true)
	(cs_vehicle_boost true)
	(sleep 120)
)

(script command_script cs_sd_chopper_1
	(cs_posture_set "act_gaze_1" false)
	(sleep_until (>= s_sd_progression 10) 15)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location cov_sd_chopper_1/chopper))
	(cs_movement_mode ai_movement_combat)
	(cs_enable_moving true)
	(sleep_until (unit_in_vehicle ai_current_actor) 10 450)
	(cs_enable_moving false)
	(cs_abort_on_vehicle_exit true)
	(cs_vehicle_boost true)
	(sleep 120)
)

(script command_script cs_sd_sentinel_migrate
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_pathfinding_failsafe true)
	
	(cs_fly_to pts_sd_sentinels/p0 2)
	(cs_vehicle_boost true)
	(cs_fly_to pts_sd_sentinels/p1 2)
	(cs_fly_to pts_sd_sentinels/p6 2)
	(cs_vehicle_boost false)
	(sleep (random_range 15 60))
	(cs_fly_to pts_sd_sentinels/p7 2)
	(cs_vehicle_boost true)
	(cs_fly_to pts_sd_sentinels/p2 2)
	(cs_fly_to pts_sd_sentinels/p3 2)
	(cs_vehicle_boost false)
	(cs_fly_to pts_sd_sentinels/p4 2)
	(cs_fly_to pts_sd_sentinels/p5 2)
)

(script command_script cs_sd_sentinel_exit
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_enable_pathfinding_failsafe true)
	(sleep_until (volume_test_object vol_ex_sentinel_exit ai_current_actor))
	
	(cs_fly_to pts_sd_sentinels/p8 2)
	(cs_fly_to pts_sd_sentinels/p9 2)
	(cs_fly_to pts_sd_sentinels/p10 2)
	(ai_erase ai_current_actor)
)

(script command_script cs_sd_johnson_pelican
	(cs_enable_pathfinding_failsafe true)
	(ai_place allies_sd_johnson)
	(sleep 1)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location allies_sd_johnson/johnson))
	(object_cannot_take_damage (ai_get_object allies_sd_johnson/johnson))
	(ai_cannot_die allies_sd_johnson true)
	
	(objects_attach (ai_vehicle_get_from_starting_location allies_sd_pelican/pilot) "machinegun_turret" (ai_vehicle_get_from_starting_location allies_sd_johnson/johnson) "")

	(cs_fly_to pts_sd_pelican/p0)
	(if (volume_test_players vol_sd_mid_bridge)
		(cs_fly_to_and_face pts_sd_pelican/p1 pts_sd_pelican/face_away_door 1)
		(cs_fly_to_and_face pts_sd_pelican/p2 pts_sd_pelican/face_at_sd)
	)
	
	(sleep_until b_sd_cartographer_hint)
	(cs_vehicle_speed 0.5)
	(cs_fly_to pts_sd_pelican/p3)
	(cs_vehicle_speed 1)
	(cs_fly_to pts_sd_pelican/p4)
	(cs_fly_to pts_sd_pelican/p5)
	(kill_players_in_volume vol_ex_kill_players)
	(cs_fly_to pts_sd_pelican/p6)
	(cs_fly_to pts_sd_pelican/p7)
	(ai_erase allies_sd_johnson)
	(ai_erase (ai_get_squad ai_current_actor))
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant sd_stop_sentinel_spawning
	(sleep_until 
		(or
			(ai_allegiance_broken player sentinel)
			(>= s_aw_progression 10)
		)
	)
	(if (ai_allegiance_broken player sentinel)
		(begin
			(wake md_sd_sentinels_attack)
		)
	)
	(sleep_forever sd_manage_sentinel_spawning)
)

(script dormant sd_manage_sentinel_spawning
	(wake sd_stop_sentinel_spawning)
	
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_3)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_4)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_5)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_3)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_4)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_5)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_6)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	
	(sleep_until 
		(or
			(>= s_sd_progression 30)
			b_sd_more_sentinel_spawned
		)
	)
	
	(ai_place for_sd_sentinels_3)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_4)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_5)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_6)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_3)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_4)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_5)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_6)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	
	;Spawn some more sentinels in case the player just made it up there
	(sleep_until b_sd_more_sentinel_spawned)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_3)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_4)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_5)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
	(sleep_until (< (ai_living_count gr_forerunner) s_sd_sentinel_count))
	(ai_place for_sd_sentinels_6)
	(sleep 60)
	(unit_close sd_emitter_0)
	(unit_close sd_emitter_1)
)

(script dormant sd_manage_sentinels
	(sleep_until 
		(or
			(>= s_aw_progression 10)
			(<= (ai_living_count gr_cov_sd_bridge) 0)
		)
	)
	
	(sleep (random_range 450 600))
	
	;Attack the AA wraith covenants
	(set b_sd_sentinels_charge 1)
)

(script dormant sd_manage_grunt_fear
	(sleep_until 
		(or
			b_sd_more_sentinel_spawned
			b_la_can_start
		)
	10)
	;(sleep 60)
	(set b_sd_grunts_flee 1)
	(cs_run_command_script gr_cov_sd_grunts cs_sd_flee)
	
	(sleep 900)
	(set b_sd_grunts_flee 0)
)

(script dormant sd_manage_warthog
	(sleep_until 
		(or
			b_la_can_start
			b_sd_more_sentinel_spawned
		)
	)
	(sleep_until 
		(or
			(<= (ai_task_count obj_sd_cov/choppers) 0)
			b_la_can_start
		)
	)
	(sleep_until 
		(or
			(<= (ai_task_count obj_sd_cov/bridge) 0)
			b_la_can_start
		)
	30 5200)
	(set b_sd_warthog_can_go 1)
)

(script dormant sd_player_progression
	(sleep_until (volume_test_players vol_sd_entrance) 10)
	(set s_sd_progression 10)
	(if b_debug (print "s_sd_progression = 10"))
	
	(sleep_until (volume_test_players vol_sd_middle) 10)
	(set s_sd_progression 20)
	(if b_debug (print "s_sd_progression = 20"))
	
	(sleep_until (volume_test_players vol_sd_bridge) 10)
	(set s_sd_progression 30)
	(if b_debug (print "s_sd_progression = 30"))
	
	(sleep_until (volume_test_players vol_sd_mid_bridge) 10)
	(set s_sd_progression 40)
	(if b_debug (print "s_sd_progression = 40"))
)

(script dormant sentinel_defense	
	(if b_debug (print "Starting sentinel defense"))

	; Migrate everybody before cleaning up the previous section	
	;(data_mine_set_mission_segment "070_021_sentinel_defense")
			
	;Spawn guys
	(ai_place cov_sd_turrets)
	(sleep 1)
	(ai_place cov_sd_pack)
	(sleep 1)
	(ai_place cov_sd_chopper_0)
	(sleep 1)
	(ai_place cov_sd_chopper_1)
	(sleep 1)
	(ai_place cov_sd_bridge_pack)
	(sleep 1)
	(ai_place cov_sd_flak)
	(sleep 1)
	
	;Wake threads
	(wake sd_player_progression)
	(wake sd_manage_grunt_fear)
	(wake sd_manage_warthog)
	(wake md_sd_sentinels_intro)
	(wake md_sd_allies_next)
	(wake md_sd_sentinels_clean)
	(wake sd_manage_sentinel_spawning)
	
	(sleep_until (>= s_sd_progression 10) 10)
	
	(ai_set_objective gr_cov_ex_p1 obj_sd_cov)
	(ai_set_objective gr_cov_ex_p2 obj_sd_cov)
	
	(sleep_until 
		(or
			(>= s_sd_progression 40)
			(and
				(>= s_sd_progression 30)
				(<= (ai_living_count cov_sd_pack) 0)
				(<= (ai_living_count cov_sd_flak) 0)
				(<= (ai_living_count cov_sd_chopper_0) 0)
				(<= (ai_living_count cov_sd_chopper_1) 0)
			)
		)
	10)
	
	;Spawn sentinels!
	(set b_sd_more_sentinel_spawned 1)
	(set s_sd_sentinel_count 4)
	
	(ai_migrate cov_sd_bridge_pack/0 cov_sd_grunts_0)
	(ai_migrate cov_sd_bridge_pack/1 cov_sd_grunts_0)
	(ai_migrate cov_sd_bridge_pack/2 cov_sd_grunts_0)
	(ai_migrate cov_sd_bridge_pack/3 cov_sd_grunts_0)
	(ai_migrate cov_sd_bridge_pack/4 cov_sd_grunts_0)
	(ai_migrate cov_sd_bridge_pack/5 cov_sd_grunts_0)
	(ai_migrate cov_sd_bridge_pack/6 cov_sd_grunts_0)
	(ai_migrate cov_sd_bridge_pack/7 cov_sd_grunts_0)
	
	(wake sd_manage_sentinels)
	
	(sleep_until (<= (ai_living_count gr_cov_sd) 2))
	(sleep_until (<= (ai_living_count gr_cov_sd) 0) 30 1200)
	
	(set b_sd_finished 1)
	
	;Stop 070_music_06
	(set b_070_music_06 0)
)

(script static void sentinel_defense_cleanup
	(sleep_forever sd_player_progression)
	(sleep_forever sentinel_defense)
	
	(ai_kill gr_cov_sd)
	(ai_kill gr_for_sd)
	(ai_disposable gr_cov_sd true)
	
	(set s_sd_progression 200)
	
	(add_recycling_volume vol_sd_recycle 10 5)
)

;***************************************************************
******************** Antiair Wraiths (AW) **********************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_aw_progression 0)
(global boolean b_aw_marines_advance 0)
(global boolean b_aw_wraith_advance 0)
(global boolean b_aw_aa_attacks_player 0)
(global boolean b_aw_spawned_ghosts 0)
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_aw_wraith_shoot_sky_0
	(cs_enable_moving true)
	
	(ai_prefer_target_ai ai_current_actor allies_aw_hornet true)	
	
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point true pts_aw_wraiths/p0)
				(cs_shoot_point true pts_aw_wraiths/p1)
				(cs_shoot_point true pts_aw_wraiths/p3)
				(cs_shoot_point true pts_aw_wraiths/p2)				
			)
			(and
				(>= s_aw_progression 30)
				(<= (object_get_health (ai_vehicle_get_from_starting_location cov_aw_wraith_1/driver)) 0.75)
			)
		)
	)
	
	(ai_prefer_target_ai ai_current_actor allies_aw_hornet false)
	(ai_set_targeting_group cov_aw_wraith_1/driver -1)
	(ai_set_targeting_group allies_aw_hornet/pilot -1)
	
	(set b_aw_aa_attacks_player 1)
)

(script command_script cs_aw_wraith_shoot_sky_1
	(cs_enable_moving true)
	
	(ai_prefer_target_ai ai_current_actor allies_aw_hornet true)
	
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point true pts_aw_wraiths/p0)
				(cs_shoot_point true pts_aw_wraiths/p1)
				(cs_shoot_point true pts_aw_wraiths/p3)
				(cs_shoot_point true pts_aw_wraiths/p2)				
			)
			(and
				(>= s_aw_progression 30)
				(<= (object_get_health (ai_vehicle_get_from_starting_location cov_aw_wraith_2/driver)) 0.75)
			)
		)
	)
	
	(ai_prefer_target_ai ai_current_actor allies_aw_hornet false)
	(ai_set_targeting_group cov_aw_wraith_2/driver -1)
	(ai_set_targeting_group allies_aw_hornet/pilot -1)
	
	(set b_aw_aa_attacks_player 1)
)

;*
(script command_script cs_aw_hornet	
	(cs_enable_pathfinding_failsafe true)
 	(cs_enable_moving true)
 	(cs_enable_looking false)
 	(cs_enable_targeting false)
 	(cs_fly_to pts_aw_hornet/p6)
 	(sleep_until
	  	(begin
	   		(begin_random
	   			(cs_shoot_point true pts_aw_hornet/p0)
	   			(cs_shoot_point true pts_aw_hornet/p1)
	   			(cs_shoot_point true pts_aw_hornet/p2)
	   			(cs_shoot_point true pts_aw_hornet/p3)
	   			(cs_shoot_point true pts_aw_hornet/p4)
	   			(cs_shoot_point true pts_aw_hornet/p5)
	   			(sleep (random_range 150 210))
	   			(sleep (random_range 150 210))
	   		)
	   		FALSE
	  	)
 	)
)

(script command_script cs_aw_hornet_exit
	(cs_enable_pathfinding_failsafe true)
	
	(cs_fly_to pts_aw_hornet/p6)
	(cs_fly_to pts_aw_hornet/p7)
	(ai_erase (ai_get_squad ai_current_actor))
)
*;
(script command_script cs_aw_stay_in_turret_0
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_until 
		(or
			(volume_test_players vol_aw_watchtower_0)
			(not (vehicle_test_seat (object_get_turret aw_cov_watch_pod_0 0) "" ai_current_actor))
		)
	)
)

(script command_script cs_aw_stay_in_turret_1
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_until 
		(or
			(volume_test_players vol_aw_watchtower_1)
			(not (vehicle_test_seat (object_get_turret aw_cov_watch_pod_1 0) "" ai_current_actor))
		)
	)
)


;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
;*(script dormant aw_manage_hornets
	(sleep_until
		(begin
			(sleep_until
				(or
					(<= (ai_living_count allies_aw_hornet) 0)
					b_fl_begins
				)
			)
			
			(if (not b_fl_begins)
				(begin
					(ai_place allies_aw_hornet)
					(sleep 1)
					(if (not b_aw_aa_attacks_player)
						(ai_set_targeting_group allies_aw_hornet/pilot 1)
					)
				)
			)
			
			b_fl_begins
		)
	)
	
	(cs_run_command_script allies_aw_hornet cs_aw_hornet_exit)
)*;

(script dormant aw_manage_top_bunker
	(ai_prefer_target_ai gr_allies gr_cov_aw_bottom true)
	
	(sleep_until
		(or
			(and
				(<= (ai_living_count gr_cov_aw_ghosts) 0)
				b_aw_spawned_ghosts
				(<= (ai_task_count obj_aw_cov/bridge_front) 0)
			)
			(>= s_aw_progression 30)
		)
	)
	
	(ai_prefer_target_ai gr_allies gr_cov_aw_bottom false)
	(ai_enter_squad_vehicles cov_aw_fort_turrets)
	
	(sleep_until (>= s_aw_progression 30) 10)
	(ai_enter_squad_vehicles cov_aw_fort_turrets)
)

(script dormant aw_manage_save
	(sleep_until (not (volume_test_objects vol_aw_first_half (ai_actors gr_cov_aw))) 60)
	(game_save)
)

(script dormant aw_player_progression
	(sleep_until (volume_test_players vol_aw_cave) 10)
	(set s_aw_progression 10)
	(if b_debug (print "s_aw_progression = 10"))
	
	(sleep_until (volume_test_players vol_aw_middle) 10)
	(set s_aw_progression 20)
	(if b_debug (print "s_aw_progression = 20"))
	
	(sleep_until (volume_test_players vol_aw_pass_bridge) 10)
	(set s_aw_progression 30)
	(if b_debug (print "s_aw_progression = 30"))
)

(script dormant antiair_wraiths
	(if b_debug (print "Starting antiair wraiths"))

	(data_mine_set_mission_segment "070_022_antiair_wraiths")

	; Place guys
	(ai_place cov_aw_pack_bridge)
	(sleep 1)
	(ai_place cov_aw_wraith_1)
	(sleep 1)
	(ai_place cov_aw_wraith_2)
	(sleep 1)
	(ai_place cov_aw_wraith_0)
	(sleep 1)
	(ai_place cov_aw_watchtower_0)
	(sleep 1)
	(ai_place cov_aw_watchtower_1)
	(sleep 1)
	(ai_place cov_aw_fort_pack)
	(sleep 1)
	(ai_place cov_aw_fort_turrets)
	(sleep 1)
	(ai_place cov_aw_vehicle_turret)
	(sleep 1)
	(ai_place cov_aw_infantry_turret)
	
	(ai_vehicle_enter_immediate cov_aw_watchtower_0/0 (object_get_turret aw_cov_watch_pod_0 0))
	(ai_vehicle_enter_immediate cov_aw_watchtower_1/0 (object_get_turret aw_cov_watch_pod_1 0))
	
	;AA wraiths and hornets are in their own little world
	(ai_set_targeting_group cov_aw_wraith_1/driver 1)
	(ai_set_targeting_group cov_aw_wraith_2/driver 1)
		
	;Wake threads
	(wake aw_player_progression)
	(wake md_aw_aa_intro)
	(wake md_aw_aa_dead)
	;(wake aw_manage_hornets)
	(wake aw_manage_save)
	(wake aw_manage_top_bunker)
	(wake 070_music_065)
	
	(sleep_until
		(or
			(<= (ai_task_count obj_aw_cov/bridge_front) 0)
			(>= s_aw_progression 30)
		)
	5)
	(ai_place cov_aw_ghost_0)
	(sleep 1)
	(ai_place cov_aw_ghost_1)
	(set b_aw_spawned_ghosts 1)
	
	(sleep_until
		(and
			(<= (ai_living_count gr_cov_aw_ghosts) 0)
			(<= (ai_task_count obj_aw_cov/bridge_front) 0)
		)
	)		
	(sleep 150)
	(set b_aw_wraith_advance 1)
	
	(sleep_until (<= (ai_living_count cov_aw_wraith_0) 0))
	
	(set b_aw_marines_advance 1)
)

(script static void antiair_wraiths_cleanup	
	(ai_disposable gr_cov_aw true)
	
	(object_destroy_folder crt_aw)
	(object_destroy_folder sce_aw)
	
	(sleep_forever aw_player_progression)
	(sleep_forever antiair_wraiths)
	
	(set s_aw_progression 200)
	
	(add_recycling_volume vol_aw_recycle 0 5)
)

;***************************************************************
******************** Frigate Landing (FL) **********************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_fl_progression 0)
(global short s_fl_position 0)
(global boolean b_fl_begins 0)
(global boolean b_fl_frigate_arrives 0)
(global boolean b_fl_frigate_arrived 0)
(global boolean b_fl_chief_in_vehicle 0)
(global boolean b_fl_pelican_arrived 0)
(global boolean 070pa_dialog_done 0)
(global boolean b_fl_070bb_done 0)
(global boolean b_fl_pelican_unloaded 0)
(global boolean b_fl_briefing_finished 0)
(global boolean b_fl_frigate_unloading 0)
(global boolean b_fl_tanks_available 0)
(global boolean b_la_can_start 0)
(global short s_fl_list_index 0)
(global short s_fl_list_count 0)
(global unit obj_fl_current_unit none)
(global ai ai_fl_johnson allies_fl_johnson)
(global ai ai_fl_sergeant allies_fl_pelican_marines/sergeant)
(global ai ai_fl_pelican_marines_0 allies_fl_pelican_marines/marine_0)
(global ai ai_fl_pelican_marines_1 allies_fl_pelican_marines/marine_1)
(global ai ai_fl_pelican_marines_2 allies_fl_pelican_marines/marine_2)
(global vehicle obj_fl_scorpion_0 none)
(global vehicle obj_fl_scorpion_1 none)
(global vehicle obj_fl_scorpion_2 none)
(global vehicle obj_fl_warthog none)
(global object_list obj_fl_vehicles (players))
(global short s_fl_odst_turn 0)
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_fl_pelican_arrives
	(unit_open (ai_vehicle_get ai_current_actor))
	(cs_fly_to pts_fl_pelican/p0)
	(cs_fly_to pts_fl_pelican/p1)	
	(cs_fly_to pts_fl_pelican/p7)
	(cs_vehicle_boost false)
	(cs_vehicle_speed 0.5)
	(cs_fly_to_and_face pts_fl_pelican/p3 pts_fl_pelican/face_at0 1)
	(set b_fl_pelican_arrived 1)
	(sleep_forever)
)

(script command_script cs_fl_pelican_exits
	(cs_enable_pathfinding_failsafe true)
	(sleep_until b_fl_chief_in_vehicle)
	(unit_close (ai_vehicle_get ai_current_actor))
	(cs_fly_to pts_fl_pelican/p5)
	(kill_players_in_volume vol_la_kill_players)
	(cs_fly_to pts_fl_pelican/p6)
	(cs_fly_to pts_fl_pelican/p8)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_fl_get_to_pelican
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(sleep_until 
		(or
			(volume_test_object vol_aw_pass_bridge ai_current_actor)
			(>= s_la_progression 10)
		)
	15 1800)
	(sleep_until 
		(or
			(volume_test_object vol_aw_all ai_current_actor)
			(>= s_la_progression 10)
		)
	15)
	
	(unit_exit_vehicle ai_current_actor)
	
	(set s_fl_odst_turn (+ s_fl_odst_turn 1))
	
	(if (= s_fl_odst_turn 1)
		(begin
			(cs_action_at_player ai_action_wave)
			
			;Ciao!			
			(ai_play_line_at_player ai_current_actor 070MQ_060)
		)
	)
	
	(cond
		((= s_fl_odst_turn 1)
			(begin
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_l05" false)
				(sleep_until
					(begin
						(cs_go_to_vehicle (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_l05")
						b_fl_chief_in_vehicle
					)
				300)
			)
		)
		((= s_fl_odst_turn 2)
			(begin
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_r05" false)
				(sleep_until
					(begin
						(cs_go_to_vehicle (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_r05")
						b_fl_chief_in_vehicle
					)
				300)
			)
		)
		((= s_fl_odst_turn 3)
			(begin
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_l04" false)
				(sleep_until
					(begin
						(cs_go_to_vehicle (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_l04")
						b_fl_chief_in_vehicle
					)
				300)
			)
		)
		((= s_fl_odst_turn 4)
			(begin
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_r04" false)
				(sleep_until
					(begin
						(cs_go_to_vehicle (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_r04")
						b_fl_chief_in_vehicle
					)
				300)
			)
		)
	)
)

(script command_script cs_johnson_stay_in_turret
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(sleep_forever)
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script static void fl_create_frigate
	(object_create fl_frigate_scenery)
	(object_create fl_frigate_midshaft_scenery)
	(object_create fl_frigate_frontshaft_scenery)
	(object_create fl_frigate_backshaft_scenery)
	;(sleep 1)
	(objects_attach fl_frigate_scenery marker_backelevator01 fl_frigate_frontshaft_scenery marker_backelevator)
	(objects_attach fl_frigate_scenery marker_backelevator02 fl_frigate_midshaft_scenery marker_backelevator)
	(objects_attach fl_frigate_scenery marker_backelevator fl_frigate_backshaft_scenery marker_backelevator)
)

(script static void fl_replace_elevators
	(object_destroy fl_frigate_midshaft_scenery)
	(object_destroy fl_frigate_frontshaft_scenery)
	(object_destroy fl_frigate_backshaft_scenery)
		
	(object_create fl_frigate_midshaft)
	(object_create fl_frigate_frontshaft)
	(object_create fl_frigate_backshaft)
	(objects_attach fl_frigate_scenery marker_backelevator01 fl_frigate_frontshaft marker_backelevator)
	(objects_attach fl_frigate_scenery marker_backelevator02 fl_frigate_midshaft marker_backelevator)
	(objects_attach fl_frigate_scenery marker_backelevator fl_frigate_backshaft marker_backelevator)	
)

(script static void fl_remove_frigate
	(object_destroy fl_frigate_scenery)
	(object_destroy fl_frigate_midshaft_scenery)
	(object_destroy fl_frigate_frontshaft_scenery)
	(object_destroy fl_frigate_backshaft_scenery)
)

(script dormant fl_army_mount_up
	;wait until the tanks are there
	(sleep_until b_fl_frigate_unloading)
	(sleep_until b_fl_tanks_available 10 900)
	
	(unit_set_enterable_by_player obj_fl_scorpion_0 true)
	(unit_set_enterable_by_player obj_fl_scorpion_1 true)
	(unit_set_enterable_by_player obj_fl_scorpion_2 true)
	(unit_set_enterable_by_player obj_fl_warthog true)
	
	(sleep_until 
		(or
			(player_in_a_vehicle)			
			(>= s_la_progression 25)
		)
	30 900)	
	
	(wake fl_stop_briefing)
	
	;Wake everybody up
	(cs_run_command_script allies_fl_pelican_marines cs_draw_weapon)
	(cs_run_command_script gr_allies_before_fl cs_draw_weapon)	
	
	(sleep 90)
	
	;Make sure allies don't take the wraiths
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_aw_wraith_1/driver) true)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location cov_aw_wraith_2/driver) true)
	(ai_enter_squad_vehicles gr_allies)
	(ai_vehicle_reserve_seat obj_fl_scorpion_0 "scorpion_d" false)
	
	(sleep_until 
		(or
			(player_in_a_vehicle)
			(>= s_la_progression 25)
		)
	)
	
	(set b_fl_chief_in_vehicle 1)
)
;*
(script static void fl_destroy_vehicles
	;(set obj_fl_vehicles (volume_return_objects vol_fl_all 2))
	(sleep_until
		(begin
			(set s_fl_list_count (list_count (volume_return_objects_by_type vol_fl_all 2)))
			(set s_fl_list_index 0)
			(print "New cycle")
			(sleep_until
				(begin
					(set obj_fl_current_unit (unit (list_get (volume_return_objects_by_type vol_fl_all 2) s_fl_list_index)))
					(unit_kill obj_fl_current_unit)
					(set s_fl_list_index (+ s_fl_list_index 1))
					(> s_fl_list_index s_fl_list_count)
				)
			1)
			(<= (list_count_not_dead (volume_return_objects_by_type vol_fl_all 2)) 0)
		)
	5 90)
	
	(print "End of killing")
)
*;
(script static void fl_wake_vehicles
	(set obj_fl_vehicles (volume_return_objects_by_type vol_fl_up 2))
	(set s_fl_list_count (list_count obj_fl_vehicles))
	(set s_fl_list_index 0)
	(sleep_until
		(begin
			(set obj_fl_current_unit (unit (list_get obj_fl_vehicles s_fl_list_index)))
			(object_wake_physics obj_fl_current_unit)
			(set s_fl_list_index (+ s_fl_list_index 1))
			(> s_fl_list_index s_fl_list_count)
		)
	1)
)

(script dormant fl_curtain_fx
	(object_create dust_curtain_low01)
	(object_create dust_curtain_low02)
	(object_create dust_curtain_high01)
	(object_create dust_curtain_high02)
	(object_create dust_curtain_high03)
	(object_create dust_curtain_screenfx)
	
	(sleep 630)

	(object_destroy dust_curtain_low01)
	(object_destroy dust_curtain_low02)
	(object_destroy dust_curtain_high01)
	(object_destroy dust_curtain_high02)
	(object_destroy dust_curtain_high03)
	(object_destroy dust_curtain_screenfx)
)

(script dormant fl_circle_fx
	(object_create dust_landing_circle)
	
	(sleep 960)

	(object_destroy dust_landing_circle)
)

(script static void frigate_wind
	(sleep 360)
	
	;Make sure the vehicles gets affected by this wind
	(fl_wake_vehicles)
	;Small wind
	(object_create fl_frigate_wind)
	(device_set_position fl_frigate_wind 1)
	(player_effect_set_max_rotation 0 1 1)
	(player_effect_set_max_rumble 1 1)
     (player_effect_start 0.25 3)
	
	;Nobody dies from the frigate
	(ai_cannot_die gr_allies true)
	;(object_cannot_die (player0) true)
	;(object_cannot_die (player1) true)
	;(object_cannot_die (player2) true)
	;(object_cannot_die (player3) true)
	
	;Dust goes flying
	(wake fl_curtain_fx)
		
	(sleep 150)
	
	;Back to normal
	(object_destroy fl_frigate_wind)
	
	;Everybody can die again
	(ai_cannot_die gr_allies false)
	;(object_cannot_die (player0) false)
	;(object_cannot_die (player1) false)
	;(object_cannot_die (player2) false)
	;(object_cannot_die (player3) false)
	
	(frigate_push)
)

(script static void frigate_push
	;Armageddon!
	(object_create fl_frigate_push)
	(device_set_position fl_frigate_push 1)
	(player_effect_start 0.5 0.5)
	
	;Nobody dies from the frigate
	(ai_cannot_die gr_allies true)
	
	(sleep 8)
	
	;Everybody exit their vehicle
	(if (volume_test_object vol_aw_pass_bridge (player0))
		(unit_exit_vehicle (player0))
	)
	(if (volume_test_object vol_aw_pass_bridge (player1))
		(unit_exit_vehicle (player1))
	)
	(if (volume_test_object vol_aw_pass_bridge (player2))
		(unit_exit_vehicle (player2))
	)
	(if (volume_test_object vol_aw_pass_bridge (player3))
		(unit_exit_vehicle (player3))
	)
	
	;Back to normal
	(object_destroy fl_frigate_push)
	(player_effect_stop 3)	
	
	(sleep 30)
	
	;Destroy all enemies
	(ai_kill gr_covenants)	
	(sleep 120)
	
	;Everybody can die again
	(ai_cannot_die gr_allies false)
	
	;Frigate has landed
	(set b_fl_frigate_arrived 1)
	
	(add_recycling_volume vol_fl_right_clift 0 20)
)

(script static void fl_unload_frigate
	(fl_place_allies)

	;Open the frigate door
	(device_set_position fl_frigate_midshaft 0.755)
	(sleep 5)
	(device_set_position fl_frigate_frontshaft 0.82)
	(sleep 5)
	(device_set_position fl_frigate_backshaft 0.8)
	
	(set b_fl_frigate_unloading 1)
	
	(wake fl_circle_fx)	
	
	;disable the whole elevators area for pathfinding
	(object_create_folder sce_fl_pathfinding)
		
	;Garbage collect everything in the same area
	(add_recycling_volume vol_fl_tanks_on_ground 0 5)
)

(script static void fl_place_allies
	(ai_place allies_fl_warthog)
	(ai_place allies_fl_scorpion_0)
	(sleep 15)
	(ai_place allies_fl_scorpion_1)
	(sleep 10)
	(ai_place allies_fl_scorpion_2)
	(place_guilty_spark la_guilty_spark/guilty)
	
	(set obj_fl_scorpion_0 (ai_vehicle_get_from_starting_location allies_fl_scorpion_0/driver))
	(set obj_fl_scorpion_1 (ai_vehicle_get_from_starting_location allies_fl_scorpion_1/driver))
	(set obj_fl_scorpion_2 (ai_vehicle_get_from_starting_location allies_fl_scorpion_2/driver))
	(set obj_fl_warthog (ai_vehicle_get_from_starting_location allies_fl_warthog/driver))
)

(script dormant fl_place_pelican
	(ai_place allies_fl_pelican)
	(sleep 1)
	(ai_place allies_fl_pelican_marines)
	(ai_place allies_fl_johnson)
	(sleep 1)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location allies_fl_johnson/johnson))
	(object_cannot_take_damage (ai_get_object allies_fl_johnson/johnson))
	(ai_cannot_die allies_fl_johnson true)
	;HACK: convert the AI before assigning it to the variable, 
	;because we need to store a pointer to the actual AI,  
	;not to the starting location
	(set ai_fl_johnson (object_get_ai (ai_get_object allies_fl_johnson/johnson)))
	(set ai_fl_sergeant (object_get_ai (ai_get_object allies_fl_pelican_marines/sergeant)))
	(set ai_fl_pelican_marines_0 (object_get_ai (ai_get_object allies_fl_pelican_marines/marine_0)))
	(set ai_fl_pelican_marines_1 (object_get_ai (ai_get_object allies_fl_pelican_marines/marine_1)))
	(set ai_fl_pelican_marines_2 (object_get_ai (ai_get_object allies_fl_pelican_marines/marine_2)))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_l05" (ai_actors allies_fl_pelican_marines/sergeant))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_r03" (ai_actors allies_fl_pelican_marines/marine_0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_r04" (ai_actors allies_fl_pelican_marines/marine_1))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "pelican_p_l04" (ai_actors allies_fl_pelican_marines/marine_2))
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) true)
	
	(objects_attach (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) "machinegun_turret" (ai_vehicle_get_from_starting_location allies_fl_johnson/johnson) "")	
)

(script dormant fl_player_position
	(sleep_until
		(begin
			(if (volume_test_players vol_fl_entrance)
				(set s_fl_position 10)
				(if (volume_test_players vol_fl_bridge)
					(set s_fl_position 20)
					(if (volume_test_players vol_fl_down)
						(set s_fl_position 30)
						(if (volume_test_players vol_fl_up)
							(set s_fl_position 40)
							(set s_fl_position 0)
						)
					)
				)
			)
		(>= s_la_progression 10))
	)
)

(script dormant fl_player_progression
	(sleep_until (volume_test_players vol_aw_cave) 10)
	(set s_fl_progression 10)
	(if b_debug (print "s_fl_progression = 10"))
)

(script dormant frigate_landing
	(set b_fl_begins 1)
	(sleep_until (<= (ai_living_count gr_cov_aw) 1) 30 300)
	
	(if b_debug (print "Starting frigate landing"))
	(game_save)

	; Migrate everybody before cleaning up the previous section	
	(ai_migrate allies_aw_warthog_0 allies_fl_extra_warthog)
	(ai_migrate allies_aw_warthog_1 allies_fl_extra_warthog)
	(ai_migrate allies_aw_mongoose_0 allies_fl_extra_warthog)
	(ai_migrate allies_aw_mongoose_1 allies_fl_extra_warthog)
	
	(sleep 1)
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_fl_pelican/pilot) true)
	
	(data_mine_set_mission_segment "070_023_frigate_landing")
	
	;Wake threads
	(wake fl_player_progression)
	(wake fl_player_position)
	(wake md_fl_allies_wait)
	(wake fl_place_pelican)
	(wake 070_music_07)
	(wake 070_music_08)
	
	;Start 070_music_07
	(set b_070_music_07 1)
	
	(sleep 60)
	
	(wake 070pa_dialog)
			
	;sleep until the players can see the frigate landing spot
	(sleep_until 
		(and 
			(objects_can_see_flag (players) flg_fl_canyon 30)
			(volume_test_players vol_fl_up)
		)
	30 150)
	(sleep_until 
		(and 
			(objects_can_see_flag (players) flg_fl_canyon 30)
			(volume_test_players vol_fl_all)
		)
	30 300)
	
	;Make sure the players are in the frigate landing area
	(sleep_until (volume_test_players vol_fl_all) 10 3600)
	
	(if (not (volume_test_players vol_fl_all))
		(begin
			(hud_activate_team_nav_point_flag player flg_fl_frigate_landing 0)
			(sleep_until (volume_test_players vol_fl_all) 10)
			(hud_deactivate_team_nav_point_flag player flg_fl_frigate_landing)
		)
	)
	
	(volume_teleport_players_not_inside vol_fl_all flg_fl_teleport_players)
		
	;(sleep_until 070pa_dialog_done 30 60)
	
	;Start 070_music_08
	(set b_070_music_08 1)
	;Stop 070_music_07
	(set b_070_music_07 0)
	
	;Frigate arrives!
	(set b_fl_frigate_arrives 1)
	(wake 070pa_start)
	(frigate_wind)
	
	(sleep_until b_fl_frigate_arrived)
	
	(wake md_fl_allies_come_back)
	
	;Everybody goes to the frigate landing area
	(cs_run_command_script gr_allies_before_fl cs_fl_get_to_briefing)
	(sleep 1)
	;... but not the ODSTs
	(cs_run_command_script ai_fly_pelican_commander cs_fl_get_to_pelican)
	(sleep 1)
	(cs_run_command_script ai_fly_pelican_marines_0 cs_fl_get_to_pelican)
	(sleep 1)
	(cs_run_command_script ai_fly_pelican_marines_1 cs_fl_get_to_pelican)
	(sleep 1)
	(cs_run_command_script ai_fly_pelican_marines_2 cs_fl_get_to_pelican)	
	
	(sleep_until b_fl_pelican_arrived 30 300)
	
	(sleep_until (volume_test_players vol_fl_up) 10 3600)
	(if (not (volume_test_players vol_fl_up))
		(begin
			(hud_activate_team_nav_point_flag player flg_fl_frigate 0)
			(sleep_until (volume_test_players vol_fl_up) 10)
			(hud_deactivate_team_nav_point_flag player flg_fl_frigate)
		)
	)
	(volume_teleport_players_not_inside vol_fl_teleport_players flg_fl_teleport_players)
	
	;Prepare for the next encounter. If the players decide to exit the area 
	;without a vehicle at that point, the encounters will start anyway
	(set b_la_can_start 1)
	
	(wake md_fl_set_objective)
	(wake 070_chapter_forward)
	(wake fl_army_mount_up)
	(wake md_fl_marine_tank_intro)
	(wake vb_fg_sgt_briefing)
	
	; Unload the frigate and reveal the tanks!
	(wake 070bb_dialog)
	(fl_unload_frigate)
)

(script static void frigate_landing_cleanup	
	(ai_disposable allies_fl_pelican true)
	(ai_disposable allies_fl_johnson true)
	
	(sleep_forever fl_player_progression)
	(sleep_forever fl_player_position)
	(sleep_forever frigate_landing)
	
	(set s_fl_progression 200)
	(set b_fl_pelican_arrived 1)
	
	(add_recycling_volume vol_fl_recycle 0 5)
)

;***************************************************************
******************* Lead the Army (LA) *************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_la_progression 0)
(global boolean b_la_spawn_p1 0)
(global short s_la_teleport_count 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_la_wraith_shooting
	(cs_shoot true)
	(cs_enable_moving true)
	;(cs_enable_targeting true)
	(cs_force_combat_status 3)
	(cs_abort_on_damage true)
	
	(sleep_until
		(begin
			(begin_random
				(begin
					(cs_shoot_point true pts_la_wraith/p0)
					(sleep 90)
					;(cs_shoot false)
				)
				(begin
					(cs_shoot_point true pts_la_wraith/p1)
					(sleep 90)
					;(cs_shoot false)
				)
				(begin
					(cs_shoot_point true pts_la_wraith/p2)
					(sleep 90)
					;(cs_shoot false)
				)
				(begin
					(cs_shoot_point true pts_la_wraith/p3)
					(sleep 90)
					;(cs_shoot false)
				)
			)
		0)
	)
)

(script command_script cs_la_p2_phantom
	(cs_enable_pathfinding_failsafe true)	
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) TRUE)
	
	;Create the watchtower top with guys in it
	(ai_place cov_la_p2_1st_tower)
	(sleep 1)
	(object_create la_cov_watch_pod_0)
	(sleep 1)
	(ai_vehicle_enter_immediate cov_la_p2_1st_tower/0 (object_get_turret la_cov_watch_pod_0 1))
	(ai_vehicle_enter_immediate cov_la_p2_1st_tower/1 (object_get_turret la_cov_watch_pod_0 2))
	(sleep 1)
	(cs_run_command_script cov_la_p2_1st_tower cs_stay_in_turret)
	(objects_attach (ai_vehicle_get_from_starting_location cov_la_p2_phantom/pilot) "" la_cov_watch_pod_0 "")
	
	(cs_fly_to pts_la_p2_phantom/drop_pod)
	(sleep_until (objects_can_see_object (players) (ai_get_object ai_current_actor) 20) 30 150)
	(sleep 30)
	(objects_detach (ai_vehicle_get_from_starting_location cov_la_p2_phantom/pilot) la_cov_watch_pod_0 )
	(sleep 15)
	(object_set_phantom_power (ai_vehicle_get ai_current_actor) FALSE)
	(cs_vehicle_speed 0.6)
	(cs_fly_to pts_la_p2_phantom/p0 1)
	(ai_trickle_via_phantom cov_la_p2_phantom/pilot cov_la_p2_grunts_0)
	(cs_fly_to pts_la_p2_phantom/p1 1)
	(cs_face_player true)
	(sleep 300)
	(cs_face_player false)
	(cs_fly_to_and_face pts_la_p2_phantom/p2 pts_la_p2_phantom/face_at)
	(kill_players_in_volume vol_la_kill_players)
	(cs_fly_to pts_la_p2_phantom/p3)
	(ai_erase (ai_get_squad ai_current_actor))
	(sleep_forever)
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant la_manage_bridge_wraith
	(sleep_until (>= s_la_progression 40))
	(cs_run_command_script cov_la_p2_bridge_wraith cs_end)
)

(script dormant la_change_objective
	(sleep_until
		(or
			(>= s_la_progression 30)
			(and
				b_la_spawn_p1
				(<= (ai_living_count gr_cov_la_p1) 0)
			)
		)
	10)
	
	(sleep_until (>= s_la_progression 25))
	
	(if b_debug (print "LA: migrating warthogs to p2"))
	(ai_set_objective gr_allies_la_warthogs obj_la_p2_allies)
	;Migrate the players' squad only
	(ai_set_objective (ai_player_get_vehicle_squad (player0)) obj_la_p2_allies)
	(ai_set_objective (ai_player_get_vehicle_squad (player1)) obj_la_p2_allies)
	(ai_set_objective (ai_player_get_vehicle_squad (player2)) obj_la_p2_allies)
	(ai_set_objective (ai_player_get_vehicle_squad (player3)) obj_la_p2_allies)
	
	(sleep_until (>= s_la_progression 30))
	
	(if b_debug (print "LA: migrating allies to p2"))
	(ai_set_objective gr_allies_la obj_la_p2_allies)
	(ai_set_objective gr_guilty_spark obj_la_p2_gs)
)

(script dormant la_heal_warthog
	(sleep_until
		(begin
			(ai_renew allies_la_warthog_0)
			(>= s_la_progression 90)
		)
	600)
)

(script static void (la_teleport_manned_unit (unit current_vehicle) (point_reference pts_current) (trigger_volume vol_teleport_if_in) (trigger_volume vol_dont_teleport_if_in))
	(if (<= s_la_teleport_count (ai_get_point_count pts_current))
		(begin
			;If you're behind the player, but not too near him
			(if 
				(and
					(volume_test_object vol_teleport_if_in current_vehicle)
					(not (volume_test_object vol_dont_teleport_if_in current_vehicle))
				)
				(begin					
					(ai_teleport (object_get_ai (vehicle_driver current_vehicle)) (ai_point_set_get_point pts_current s_la_teleport_count))
					(set s_la_teleport_count (+ s_la_teleport_count 1))
				)
			)
		)
	)
)

(script dormant la_teleport_tanks
	(sleep_until 
		(or
			(and 
				(not (objects_can_see_flag (players) flg_la_before_cave 30))
				(not (volume_test_players vol_la_p1))
				(not (any_player_dead))
			)
			(>= s_lb_progression 10)
		)
	)
	
	(if (< s_lb_progression 10)
		(begin
			;Teleport tanks and warthog
			(set s_la_teleport_count 0)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank) pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_scorpion_0/driver) pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_scorpion_1/driver) pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_warthog_0/driver) pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_warthog_1/driver) pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
			(la_teleport_manned_unit obj_fl_scorpion_0 pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
			(la_teleport_manned_unit obj_fl_scorpion_1 pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
			(la_teleport_manned_unit obj_fl_scorpion_2 pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
			(la_teleport_manned_unit obj_fl_warthog pts_la_p1_teleport_ai vol_la_p1 vol_la_before_cave)
		)
	)
	
	(sleep_until 
		(or
			(and 
				(not (objects_can_see_flag (players) flg_la_after_cave 30))
				(not (volume_test_players vol_la_p1))
				(not (volume_test_players vol_la_p2_begin))
				(not (any_player_dead))
			)
			(>= s_lb_progression 10)
		)
	)
	
	(if (< s_lb_progression 10)
		(begin
			;Teleport tanks and warthog
			(set s_la_teleport_count 0)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank) pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_scorpion_0/driver) pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_scorpion_1/driver) pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_warthog_0/driver) pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
			(la_teleport_manned_unit (ai_vehicle_get_from_starting_location allies_la_warthog_1/driver) pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
			(la_teleport_manned_unit obj_fl_scorpion_0 pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
			(la_teleport_manned_unit obj_fl_scorpion_1 pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
			(la_teleport_manned_unit obj_fl_scorpion_2 pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
			(la_teleport_manned_unit obj_fl_warthog pts_la_p2_teleport_ai vol_la_teleport_if_in vol_la_trench)
		)
	)
)

(script dormant la_manage_checkpoints
	(game_save)
	
	;FIRST ENCOUNTER
	(sleep_until 
		(or
			(>= s_la_progression 30)
			(and
				(>= s_la_progression 20)
				(<= (ai_living_count gr_cov_la_p1) 0)
			)
		)
	)
	;Save only if playtest is not just zooming through encounters
	(if (< s_la_progression 30)
		(game_save)
	)
	;Show waypoint if player doesn't progress once everyone is dead
	(sleep_until (>= s_la_progression 30) 30 3600)
	(if (< s_la_progression 30)
		(begin
			(hud_activate_team_nav_point_flag player flg_la_next_0 0)
			(sleep_until (>= s_la_progression 30) 5)
			(hud_deactivate_team_nav_point_flag player flg_la_next_0)
		)
	)
	
	(sleep 30)
	
	;SECOND ENCOUNTER
	(sleep_until 
		(or
			(>= s_la_progression 50)
			(<= (ai_living_count gr_cov_la_p2_a) 0)
		)
	)
	;Save only if playtest is not just zooming through encounters
	(if (< s_la_progression 50)
		(begin
			(sleep_until (game_safe_to_save) 30 600)
			(game_save)
		)
	)
	
	;Show waypoint if player doesn't progress once everyone is dead
	(sleep_until (>= s_la_progression 50) 30 3600)
	(if (< s_la_progression 50)
		(begin
			(hud_activate_team_nav_point_flag player flg_la_next_1 0)
			(sleep_until (>= s_la_progression 50) 5)
			(hud_deactivate_team_nav_point_flag player flg_la_next_1)
		)
	)
	
	;THIRD ENCOUNTER
	(sleep_until 
		(or
			(>= s_la_progression 90)
			(<= (ai_living_count gr_cov_la_p2_b) 0)
		)
	)
	;Save only if playtest is not just zooming through encounters
	(if (< s_la_progression 90)
		(game_save)
	)
	
	;Show waypoint if player doesn't progress once everyone is dead
	(sleep_until (>= s_la_progression 90) 30 3600)
	(if (< s_la_progression 90)
		(begin
			(hud_activate_team_nav_point_flag player flg_la_next_2 0)
			(sleep_until (>= s_la_progression 90) 5)
			(hud_deactivate_team_nav_point_flag player flg_la_next_2)
		)
	)
)

(script dormant la_player_progression
	(sleep_until 
		(or
			(volume_test_players vol_la_going_down)
			(volume_test_players vol_la_bridge)
			(volume_test_players vol_la_before_cave)
		)
	10)
	(set s_la_progression 10)
	(if b_debug (print "s_la_progression = 10"))	
	
	(sleep_until 
		(or
			(volume_test_players vol_la_bridge)
			(volume_test_players vol_la_before_cave)
		)
	10)
	(set s_la_progression 20)
	(if b_debug (print "s_la_progression = 20"))
	
	(sleep_until (volume_test_players vol_la_recycle_cave) 10)
	(set s_la_progression 22)
	(if b_debug (print "s_la_progression = 22"))
	
	(sleep_until (volume_test_players vol_la_before_cave) 10)
	(set s_la_progression 25)
	(if b_debug (print "s_la_progression = 25"))
	
	(sleep_until (volume_test_players vol_la_cave) 10)
	(set s_la_progression 30)
	(if b_debug (print "s_la_progression = 30"))

	(sleep_until (volume_test_players vol_la_after_cave) 10)
	(set s_la_progression 35)
	(if b_debug (print "s_la_progression = 35"))
	
	(sleep_until (volume_test_players vol_la_before_trench) 10)
	(set s_la_progression 40)
	(if b_debug (print "s_la_progression = 40"))
	
	(sleep_until (volume_test_players vol_la_trench) 10)
	(set s_la_progression 50)
	(if b_debug (print "s_la_progression = 50"))
	
	(sleep_until (volume_test_players vol_la_mid_trench) 10)
	(set s_la_progression 60)
	(if b_debug (print "s_la_progression = 60"))
	
	(sleep_until (volume_test_players vol_la_trench_end_0) 10)
	(set s_la_progression 70)
	(if b_debug (print "s_la_progression = 70"))
	
	(sleep_until (volume_test_players vol_la_trench_end_1) 10)
	(set s_la_progression 80)
	(if b_debug (print "s_la_progression = 80"))
	
	(sleep_until (volume_test_players vol_la_trench_end_2) 10)
	(set s_la_progression 90)
	(if b_debug (print "s_la_progression = 90"))
)

(script dormant lead_the_army
	(if b_debug (print "Starting lead the army"))
	
	(wake la_manage_checkpoints)

	; Migrate everybody before cleaning up the previous section	
	(ai_migrate allies_fl_scorpion_0 allies_la_player_scorpion)
	(ai_migrate allies_fl_scorpion_1 allies_la_scorpion_0)
	(ai_migrate allies_fl_scorpion_2 allies_la_scorpion_1)
	(ai_migrate allies_fl_warthog allies_la_warthog_0)
	(ai_migrate allies_fl_extra_warthog allies_la_warthog_1)
		
	(data_mine_set_mission_segment "070_030_lead_the_army")

	; Place guys
	(ai_place cov_la_p1_ghosts_0)
	(sleep 1)
	(ai_place cov_la_p1_ghosts_1)
	(sleep 1)
	(ai_place cov_la_p1_mauler)	

	;Place objects
	(object_create la_cov_watch_base_0)
	(sleep 1)
	(object_create la_cov_watch_base_1)
	(sleep 1)
	(object_create la_cov_watch_pod_1)
	(sleep 1)
	(object_create la_battery_3)
	(sleep 1)
	(object_create la_battery_2)
	(sleep 1)
	(object_create la_battery_1)
	(sleep 1)
	(object_create la_barrier_0)
	(sleep 1)
	(object_create la_barrier_1)
	(sleep 1)
	(object_create la_barrier_2)
	(sleep 1)
	(object_create la_barrier_3)
	(sleep 1)
	(object_destroy ex_small_crate_0)
	(sleep 1)
	(object_destroy ex_space_crate_0)
	(sleep 1)
	(object_destroy ex_space_crate_1)
		
	;Wake threads
	(wake la_player_progression)
	(wake la_change_objective)
	(wake la_heal_warthog)
	(wake md_la_tank_advance)
	(wake md_la_gs_cautious)
	(wake la_teleport_tanks)
	
	(sleep_until 
		(or
			(player_in_a_vehicle)
			(>= s_la_progression 22)
		)
	10)
	
	(ai_vehicle_reserve (ai_vehicle_get_from_starting_location allies_la_player_scorpion/tank) false)
	
	;(sleep_until (>= s_la_progression 10))
	;(ai_place cov_la_p1_banshees)
	
	(sleep_until (>= s_la_progression 22) 10)
	(ai_place cov_la_p1_hunters)
	
	(sleep 30)
	
	(set b_la_spawn_p1 1)
	
	(sleep_until (>= s_la_progression 30))
	(ai_place cov_la_p2_phantom)
	;(sleep 1)
	;(ai_place cov_la_p2_banshees)
	;(sleep 1)	
	;(ai_place cov_la_p2_bridge_wraith)
	(sleep 1)
	(ai_place cov_la_p2_shade_0)
		
	(wake la_manage_bridge_wraith)
	
	(sleep_until (>= s_la_progression 40))
	(ai_place cov_la_p2_ghosts_0)
	(sleep 1)
	(ai_place cov_la_p2_ghosts_1)
	(sleep 1)
	(ai_place cov_la_p2_ghosts_2)
	(sleep 1)
	(ai_place cov_la_p2_trench_wraith)
	
	(sleep_until (>= s_la_progression 50))
	(ai_place cov_la_p2_grunts_1)
	(sleep 1)
	(ai_place cov_la_p2_jackals_1)
	(sleep 1)
	(ai_place cov_la_p2_grunt_tower)
	(sleep 1)
	(ai_vehicle_enter_immediate cov_la_p2_grunt_tower/0 (object_get_turret la_cov_watch_pod_1 0))
	(ai_vehicle_enter_immediate cov_la_p2_grunt_tower/1 (object_get_turret la_cov_watch_pod_1 2))
	(cs_run_command_script cov_la_p2_grunt_tower cs_stay_in_turret)
)

(script static void lead_the_army_cleanup
	(ai_disposable gr_cov_la true)
	
	(object_destroy_folder veh_la)
	(object_destroy_folder crt_la)
	(object_destroy_folder sce_la)
	(object_destroy_folder crt_crashed_pelican)
	
	(sleep_forever la_player_progression)
	(sleep_forever lead_the_army)
	
	(set s_la_progression 200)
	
	(add_recycling_volume vol_la_recycle 0 5)
)

;***************************************************************
*********************** Defend Wall (DW) ***********************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_dw_progression 0)
(global boolean b_dw_reinf_arrived 0)
(global boolean b_dw_combat_finished 0)
(global boolean b_dw_gs_open_door 0)
(global boolean b_dw_found_empty_vehicle 0)
(global short s_dw_list_index 0)
(global short s_dw_list_count 0)
(global unit obj_dw_current_unit none)
(global object_list ol_dw_vehicles (players))
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_dw_phantom
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot false)
	(cs_enable_targeting false)
	(cs_enable_looking true)
	(cs_fly_to pts_dw_phantom/p0)
	(sleep_until (objects_can_see_object (players) (ai_get_object ai_current_actor) 20) 30 300)
	(vehicle_unload (ai_vehicle_get_from_starting_location cov_dw_phantom/pilot) "phantom_lc")
	(sleep 60)
	(cs_fly_to pts_dw_phantom/p1)
	(kill_players_in_volume vol_dw_kill_players_0)
	(cs_fly_to pts_dw_phantom/p2)
	(cs_fly_to pts_dw_phantom/p3 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_dw_phantom_reinf
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot false)
	(cs_enable_targeting false)
	(cs_enable_looking true)
	(cs_fly_to pts_dw_phantom_reinf/p0)
	(cs_fly_to_and_face pts_dw_phantom_reinf/p1 pts_dw_phantom_reinf/face_at 1)
	;(sleep_until (objects_can_see_object (players) (ai_get_object ai_current_actor) 20) 30 300)
	(vehicle_unload (ai_vehicle_get_from_starting_location cov_dw_phantom_reinf/pilot) "phantom_lc")
	(sleep 30)
	(cs_fly_to_and_face pts_dw_phantom_reinf/p2 pts_dw_phantom_reinf/face_at 1)
	(ai_trickle_via_phantom cov_dw_phantom_reinf/pilot cov_dw_bridge_pack_0)
	(ai_trickle_via_phantom cov_dw_phantom_reinf/pilot cov_dw_bridge_pack_1)
	(ai_trickle_via_phantom cov_dw_phantom_reinf/pilot cov_dw_bridge_grunts)
	(cs_fly_to pts_dw_phantom_reinf/p0)
	(kill_players_in_volume vol_dw_kill_players_1)
	(cs_fly_to pts_dw_phantom_reinf/p3 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
;*(script dormant sb_manage_scarab_drop
	;Wait for the player to see the scarab drop
	(sleep_until (>= s_la_progression 70) 5)
	
	(sleep_until 
		(or
			(and
				(<= (ai_living_count cov_la_p2_trench_wraith) 0)
				(objects_can_see_flag (players) flg_sb_drop_start 15)
			)
			(>= s_la_progression 80)
		)
	5)
	(if (not (>= s_la_progression 80))
		(begin
			(wake sb_drop_scarab)
			(sleep_forever)
		)
	)
	
	(sleep_until 
		(or
			(objects_can_see_flag (players) flg_sb_drop_start 25)
			(>= s_la_progression 90)
		)
	5)
	(wake sb_drop_scarab)
)*;

(script dormant dw_manage_jitter_door	
	;Wait until the zone set is fully loaded
	(sleep_until (= (current_zone_set_fully_active) 5))
	
	(device_set_power ex_wall_door 1)
	(device_set_position_immediate ex_wall_door 0.2)
	(device_set_position ex_wall_door 1)
	(device_operates_automatically_set ex_wall_door 0)
	
	(object_create dw_door_spark_0)
	(object_create dw_door_spark_1)
	
	(sleep_until 
		(begin
			(sleep_until 
				(or
					(>= s_lb_progression 15)
					(= (device_get_position ex_wall_door) 1)
				)
			1)
			(device_set_position_immediate ex_wall_door 0.74)
			(device_set_position ex_wall_door 1)
			(sound_impulse_start "sound\device_machines\doors_lifts\waste_door_jitter_struggle.sound" ex_wall_door 1)
						
			(>= s_lb_progression 15)
		)
	)
)

(script dormant dw_manage_guilty
	(sleep_until (>= s_dw_progression 50) 15)
	
	(sleep_until b_dw_combat_finished 15)
	
	(wake md_dw_open_door)
	
	(sleep_until b_dw_gs_open_door 15 600)
	(wake dw_manage_jitter_door)
	
	(ai_migrate dw_guilty_spark lb_guilty_spark)
	(wake md_lb_open_door)
	
	(sleep_until (volume_test_players vol_lb_gs_open_door))
	
	(sleep_until b_lb_gs_open_door 15 900)
	(device_set_power lb_first_door 1)
)

(script dormant dw_manage_vehicles
	(sleep_until (>= s_lb_progression 5) 10)
	(sleep 210)
	;For every allied vehicle without a driver
	(set ol_dw_vehicles (volume_return_objects_by_type vol_dw_bridge 2))
	(set s_dw_list_count (list_count ol_dw_vehicles))
	(set s_dw_list_index 0)
	(sleep_until
		(begin
			(set obj_dw_current_unit (unit (list_get ol_dw_vehicles s_dw_list_index)))
			;Is there a gunner or passengers in the vehicle, that are part of the human team?
			(if (= (unit_get_team_index (vehicle_gunner obj_dw_current_unit)) 2)
				(begin
					(set obj_dw_current_unit (vehicle_gunner obj_dw_current_unit))
					(set b_dw_found_empty_vehicle 1)
				)
			)
			(if (= (unit_get_team_index (unit (list_get (vehicle_riders obj_dw_current_unit) 0))) 2)
				(begin				
					(set obj_dw_current_unit (unit (list_get (vehicle_riders obj_dw_current_unit) 0)))
					(set b_dw_found_empty_vehicle 1)
				)
			)
			
			;If yes, make them exit the vehicle,
			;And then tell them to re-enter their vehicles, 
			;so that they get reorganized properly
			(if (and b_dw_found_empty_vehicle (not (player_in_vehicle (object_get_ai obj_dw_current_unit))))
				(begin
					(ai_vehicle_exit (ai_get_squad (object_get_ai obj_dw_current_unit)))
					(sleep 60)
					(ai_enter_squad_vehicles (ai_get_squad (object_get_ai obj_dw_current_unit)))
				)
			)
			
			(set b_dw_found_empty_vehicle 0)
			(set s_dw_list_index (+ s_dw_list_index 1))
			(> s_dw_list_index s_dw_list_count)
		)
	1)
)

(script dormant dw_player_progression
	(sleep_until (volume_test_players vol_dw_after_trench) 10)
	(set s_dw_progression 10)
	(if b_debug (print "s_dw_progression = 10"))
	(sleep_until (volume_test_players vol_dw_entrance) 10)
	(set s_dw_progression 20)
	(if b_debug (print "s_dw_progression = 20"))
	(sleep_until (volume_test_players vol_dw_advance) 10)
	(set s_dw_progression 25)
	(if b_debug (print "s_dw_progression = 25"))
	(sleep_until (volume_test_players vol_dw_going_up) 10)
	(set s_dw_progression 30)
	(if b_debug (print "s_dw_progression = 30"))
	(sleep_until (volume_test_players vol_dw_bridge) 10)
	(set s_dw_progression 40)
	(if b_debug (print "s_dw_progression = 40"))
	(sleep_until (volume_test_players vol_dw_near_door) 10)
	(set s_dw_progression 50)
	(if b_debug (print "s_dw_progression = 50"))
	(sleep_until (volume_test_players vol_dw_almost_in) 10)
	(set s_dw_progression 60)
	(if b_debug (print "s_dw_progression = 60"))
)

(script dormant defend_wall	
	(if b_debug (print "Starting defend_wall"))
	(game_save)
	
	(object_create dw_battery_0)
	(object_create dw_battery_1)
	(sleep 1)
	(object_create dw_crate_0)
	(object_create dw_crate_1)
	(sleep 1)
	(object_create dw_instant_lover_0)
	(object_create dw_instant_lover_1)
	(sleep 1)
	(object_create dw_instant_lover_2)
	(object_create dw_instant_lover_3)
	(sleep 1)
	(object_destroy sd_barrier_0)
	(object_destroy sd_barrier_1)
	(object_destroy sd_barrier_2)
	(object_destroy sd_space_crate_0)
	(object_destroy sd_space_crate_1)
	
	(ai_migrate allies_la_player_scorpion allies_dw_player_scorpion)
	(ai_migrate allies_la_scorpion_0 allies_dw_scorpion_0)
	(ai_migrate allies_la_scorpion_1 allies_dw_scorpion_1)
	(ai_migrate allies_la_warthog_0 allies_dw_warthog_0)
	(ai_migrate allies_la_warthog_1 allies_dw_warthog_0)
	(ai_migrate la_guilty_spark dw_guilty_spark)
	(sleep 1)
	(ai_cannot_die gr_guilty_spark true)
	
	(ai_place cov_dw_phantom)
	(sleep 1)
	;(ai_place cov_dw_banshee_0)
	;(sleep 1)
	;(ai_place cov_dw_banshee_1)
	;(sleep 1)
	(ai_place cov_dw_wraith_0)
	(sleep 1)
	(ai_place cov_dw_wraith_1)
	(sleep 1)	
	(ai_place cov_dw_bridge_turrets)
	(sleep 1)
	(ai_place cov_dw_choppers_down)
	
	(vehicle_load_magic (ai_vehicle_get_from_starting_location cov_dw_phantom/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location cov_dw_wraith_0/driver))

	(wake dw_player_progression)
	(wake dw_manage_guilty)
	(wake md_dw_go_to_door)
	(wake 070_music_085)
	(wake 070_music_086)
	(data_mine_set_mission_segment "070_031_defend_wall")
	
	(sleep_until (>= s_dw_progression 25))
	(ai_place cov_dw_ghost_up_0)
	(sleep 1)
	(ai_place cov_dw_ghost_up_1)
	
	(sleep_until 
		(or
			(<= (ai_living_count gr_cov_dw_wraiths) 2)
			(>= s_dw_progression 20)
		)
	)
	(sleep 120)
	(ai_place cov_dw_phantom_reinf)
	(ai_place cov_dw_bridge_wraith)
	(sleep 1)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location cov_dw_phantom_reinf/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location cov_dw_bridge_wraith/driver))
	(set b_dw_reinf_arrived 1)
	
	(sleep_until 
		(or
			(<= (ai_living_count gr_cov_dw_wraiths) 0)
			(>= s_dw_progression 30)
		)
	)	

	;Guilty spark goes to the door now
	(cs_run_command_script gr_guilty_spark cs_end)
	(set b_gs_follow_player 0)

	;(sleep_until (<= (ai_living_count gr_cov_dw_banshee) 1))
	;(ai_place cov_dw_banshee_2)
	
	(sleep_until (<= (ai_living_count cov_dw_bridge_wraith/driver) 0))
	
	(sleep_until (<= (ai_living_count gr_cov_dw) 6))
	(sleep_until (<= (ai_living_count gr_cov_dw) 3) 30 900)
	(sleep_until (<= (ai_living_count gr_cov_dw) 1) 30 300)
	
	(wake md_dw_allies_next)
	(wake dw_manage_vehicles)	
	(set b_dw_combat_finished 1)
)

(script static void defend_wall_cleanup
	(ai_disposable gr_cov_dw true)

	(sleep_forever dw_player_progression)
	(sleep_forever defend_wall)
	
	(set s_dw_progression 200)
	
	(add_recycling_volume vol_dw_recycle 0 5)
)

;***************************************************************
********************** Lightbridge (LB) ************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_lb_progression 0)
(global boolean b_lb_lightbridge_on 0)
(global short s_lb_constructor_position 0)
(global short s_lb_teleport_count 0)
(global short s_lb_list_index 0)
(global short s_lb_list_count 0)
(global unit obj_lb_current_unit none)
(global object_list ol_lb_vehicles (players))
(global short s_lb_nb_tank 0)
(global short s_lb_sentinel_spawner 0)
(global boolean b_lb_gs_open_door 0)
(global boolean b_lb_constructors_exit 0)
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_lb_constructor_groove
	(sleep_until
		(begin
			(cs_enable_moving true)
			;(cs_face false pts_lb_constructors/face_at)
			(cs_shoot_point false (ai_nearest_point ai_current_actor pts_lb_constructors))
			(cs_shoot false)
			(sleep (random_range 150 210))
			(cs_enable_moving false)
			;(cs_face true pts_lb_constructors/face_at)	
			(cs_shoot_point true (ai_nearest_point ai_current_actor pts_lb_constructors))
			(sleep (random_range 150 210))
			
			b_lb_lightbridge_on
		)
	)
	
	(cs_enable_moving true)
	(cs_shoot_point false (ai_nearest_point ai_current_actor pts_lb_constructors))
	(cs_shoot false)
	
	(sleep_until (volume_test_object vol_lb_sentinel_disappear ai_current_actor))	
	(ai_erase ai_current_actor)
)

(script command_script cs_lb_sentinel_approach
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(ai_set_task (ai_get_squad ai_current_actor) obj_lb_for sentinels_follow)
	;Try to reach the player for a certain amount of time
	(sleep_until 
		(AND
			(<= (objects_distance_to_object (players) ai_current_actor) 3)
			(objects_can_see_object (players) ai_current_actor 40)
		)
	5 1200)
	;If the sentinel was near the player, acknowledge
	;the player and fly back to the objective
	(if (<= (objects_distance_to_object (players) ai_current_actor) 4)
		(begin
			(cs_face_player true)
			(cs_enable_moving false)
			(if b_dialogue (print "SENTINEL: NOISE"))
			(cs_play_sound "sound\characters\sentinel\sentinel_posing")
			(cs_enable_moving true)
			;(cs_face_player false)
		)
	)
	
	(sleep_until b_lb_gs_open_door)
	
	(cs_run_command_script ai_current_actor cs_lb_sentinel_groove)
)

(script command_script cs_lb_sentinel_groove
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_face_player false)
	
	(ai_set_task (ai_get_squad ai_current_actor) obj_lb_for sentinels_up)

	(sleep_until (volume_test_object vol_lb_center ai_current_actor) 30 600)
	(sleep (random_range 450 600))
	(ai_set_task (ai_get_squad ai_current_actor) obj_lb_for sentinels_down)
	
	(sleep_until (volume_test_object vol_lb_sentinel_disappear ai_current_actor))
	
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_lb_teleport_to_point
	(if (< s_lb_teleport_count (- (ai_get_point_count pts_lb_teleport_ai) 1))
		(begin
			(cs_teleport (ai_point_set_get_point pts_lb_teleport_ai s_lb_teleport_count) pts_lb_teleport_ai/face_at)
			(set s_lb_teleport_count (+ s_lb_teleport_count 1))
		)
	)
	;(cs_run_command_script ai_current_actor cs_lb_wait_for_lightbridge)	
)

(script command_script cs_lb_wait_for_lightbridge
	(cs_enable_looking true)
	(cs_enable_targeting true)
	
	(sleep_until b_lb_lightbridge_on)
)
;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant lb_manage_constructor_position
	(sleep_until
		(begin
			(begin_random
				(if (not b_lb_lightbridge_on)
					(begin
						(set s_lb_constructor_position 1)
						(sleep (random_range 210 300))
					)
				)
				(if (not b_lb_lightbridge_on)
					(begin
						(set s_lb_constructor_position 2)
						(sleep (random_range 210 300))
					)
				)
				(if (not b_lb_lightbridge_on)
					(begin
						(set s_lb_constructor_position 3)
						(sleep (random_range 210 300))
					)
				)
				(if (not b_lb_lightbridge_on)
					(begin
						(set s_lb_constructor_position 4)
						(sleep (random_range 210 300))
					)
				)											
			)
			b_lb_lightbridge_on
		)
	)
	
	(sleep 450)
	(set b_lb_constructors_exit 1)
)

(script dormant lb_stop_sentinel_spawning
	(sleep 120)
	(sleep_until 
		(or
			(ai_allegiance_broken player sentinel)
			(>= s_lb_progression 50)
		)
	1)
	(sleep_forever lb_manage_sentinel_spawning)
)

(script dormant lb_manage_sentinel_spawning
	(wake lb_stop_sentinel_spawning)
	(sleep_until
		(begin
			(sleep_until
				(and
					(volume_test_players vol_lb_spawn_sentinels)
					(<= (ai_living_count gr_for_lb_sentinels) 3)
				)
			)
			(cond 
				((= s_lb_sentinel_spawner 0) (ai_place for_lb_sentinel_0))
				((= s_lb_sentinel_spawner 1) (ai_place for_lb_sentinel_1))
				((= s_lb_sentinel_spawner 2) (ai_place for_lb_sentinel_2))
				((= s_lb_sentinel_spawner 3) (ai_place for_lb_sentinel_3))
				((= s_lb_sentinel_spawner 4) (ai_place for_lb_sentinel_4))
				((= s_lb_sentinel_spawner 5) (ai_place for_lb_sentinel_5))
				((= s_lb_sentinel_spawner 6) (ai_place for_lb_sentinel_6))
				((= s_lb_sentinel_spawner 7) (ai_place for_lb_sentinel_7))
			)
			(sleep 60)
			(unit_close lb_emitter_1)
			(unit_close lb_emitter_2)
			(set s_lb_sentinel_spawner (+ s_lb_sentinel_spawner 1))
			(if (= s_lb_sentinel_spawner 8)
				(set s_lb_sentinel_spawner 0)
			)
		0)
	300)
)

;Migrate only the squads that were teleported
(script static void (lb_migrate_units (ai migrate_from) (ai migrate_to) (trigger_volume passed_volume))
	(set s_list_count 0)
	(set s_list_index 0)
	(set ol_unit_list migrate_from)
	(set s_list_count (list_count ol_unit_list))
	(sleep_until
		(begin
			(set obj_current_unit (unit (list_get ol_unit_list s_list_index)))
			(if (volume_test_object passed_volume (unit obj_current_unit))
				(begin
					(ai_migrate (object_get_ai obj_current_unit) migrate_to)
				)
			)
			(set s_list_index (+ s_list_index 1))
			(> s_list_index s_list_count)
		)
	1)
)

(script dormant lb_teleport_allies
	;Teleport every allied vehicle with a driver
	(set ol_lb_vehicles (volume_return_objects_by_type vol_dw_teleport_allies 2))
	(set s_lb_list_count (list_count ol_lb_vehicles))
	(set s_lb_list_index 0)
	(set s_lb_nb_tank 0)
	(sleep_until
		(begin
			(set obj_lb_current_unit (unit (list_get ol_lb_vehicles s_lb_list_index)))
			;Is the driver in the human team?
			(if (= (unit_get_team_index (vehicle_driver obj_lb_current_unit)) 2)
				(begin
					(cs_run_command_script (object_get_ai (vehicle_driver obj_lb_current_unit)) cs_lb_teleport_to_point)
					(sleep 1)
					;Count the number of tanks we teleport
					(if
						(or
							(vehicle_test_seat_list (ai_vehicle_get (object_get_ai (vehicle_driver obj_lb_current_unit))) "scorpion_d" (ai_actors gr_allies))
							(vehicle_test_seat_list (ai_vehicle_get (object_get_ai (vehicle_driver obj_lb_current_unit))) "wraith_d" (ai_actors gr_allies))
						)
						(set s_lb_nb_tank (+ s_lb_nb_tank 1))
					)
				)
			)
			(set s_lb_list_index (+ s_lb_list_index 1))
			(> s_lb_list_index s_lb_list_count)
		)
	1)
	
	(sleep 1)
	
	;Migrate allies
	;Migrate only the squads that were teleported
	(lb_migrate_units allies_dw_player_scorpion allies_lb_scorpion_0 vol_lb_allies_wait)
	(lb_migrate_units allies_dw_scorpion_0 allies_lb_scorpion_1 vol_lb_allies_wait)
	(lb_migrate_units allies_dw_scorpion_1 allies_lb_scorpion_2 vol_lb_allies_wait)
	(lb_migrate_units allies_dw_warthog_0 allies_lb_warthog_2 vol_lb_allies_wait)
	
	;And spawn some new guys if there wasn't enough vehicle
	(set ol_lb_vehicles (volume_return_objects_by_type vol_lb_allies_wait 2))
	(set s_lb_list_count (list_count ol_lb_vehicles))
	
	(if 
		(and
			(< s_lb_nb_tank 3)
			(<= (ai_living_count allies_lb_scorpion_0) 0)
		)
		(begin
			(ai_place allies_lb_scorpion_0)
			(set s_lb_nb_tank (+ s_lb_nb_tank 1))
		)
	)
	(if 
		(and
			(< s_lb_nb_tank 3)
			(<= (ai_living_count allies_lb_scorpion_1) 0)
		)
		(begin
			(ai_place allies_lb_scorpion_1)
			(set s_lb_nb_tank (+ s_lb_nb_tank 1))
		)
	)
	(if 
		(and
			(< s_lb_nb_tank 3)
			(<= (ai_living_count allies_lb_scorpion_2) 0)
		)
		(begin
			(ai_place allies_lb_scorpion_2)
			(set s_lb_nb_tank (+ s_lb_nb_tank 1))
		)
	)
	
	;(if (< s_lb_nb_tank 3) (ai_place allies_lb_scorpion_0))
	;(if (< s_lb_nb_tank 2) (ai_place allies_lb_scorpion_1))
	;(if (< s_lb_nb_tank 1) (ai_place allies_lb_scorpion_2))
	
	(if (< (- s_lb_list_count s_lb_nb_tank) 3) (ai_place allies_lb_warthog_0))
	(if (< (- s_lb_list_count s_lb_nb_tank) 2) (ai_place allies_lb_warthog_1))
	(if (< (- s_lb_list_count s_lb_nb_tank) 1) (ai_place allies_lb_warthog_2))
)

(script dormant lb_manage_kill_volume
	(sleep_until
		(begin
			(kill_players_in_volume vol_lb_kill_volume)			
		(>= s_bb_progression 50))
	5)
)

(script dormant lb_manage_lightbridge
	(sleep_until (<= (device_get_position lb_lightbridge_switch) 0.9) 5 3600)
	(if (> (device_get_position lb_lightbridge_switch) 0.9)
		(begin
			(hud_activate_team_nav_point_flag player flg_lb_switch 0)		
			(sleep_until (<= (device_get_position lb_lightbridge_switch) 0.9) 5)
			(hud_deactivate_team_nav_point_flag player flg_lb_switch)
		)
	)
	
	(object_create lb_lightbridge)
	(device_set_position lb_lightbridge 1)
	(object_create lb_terminal)
	(objects_attach lb_terminal_base "forerunner_terminal" lb_terminal "")
	(device_set_power lb_terminal_base 1)
	
	(device_set_power lb_guardian_door 1)
	(device_set_position lb_guardian_door 1)
	(device_set_power lb_right_large_door 1)
	(device_set_position lb_right_large_door 1)
	(device_closes_automatically_set lb_right_large_door false)
	
	;Place back the halogram in place
	(device_operates_automatically_set lb_lightbridge_device 0)
	(device_set_position lb_lightbridge_device 0)
	
	(sleep_until (>= (device_get_position lb_lightbridge) 0.95) 30 300)
	(set b_lb_lightbridge_on 1)	
	
	(sleep_until (>= s_lb_progression 50) 30 3600)
	(if (< s_lb_progression 50)
		(begin
			(hud_activate_team_nav_point_flag player flg_lb_next 0)		
			(sleep_until (>= s_lb_progression 50))
			(hud_deactivate_team_nav_point_flag player flg_lb_next)
		)
	)
)

(script dormant lb_player_progression	
	(sleep_until (volume_test_players vol_lb_after_door) 10)
	(set s_lb_progression 5)
	(if b_debug (print "s_lb_progression = 5"))
	(sleep_until (volume_test_players vol_lb_entrance) 10)
	(set s_lb_progression 10)
	(if b_debug (print "s_lb_progression = 10"))
	(sleep_until (volume_test_players vol_lb_mid_entrance) 10)
	(set s_lb_progression 15)
	(if b_debug (print "s_lb_progression = 15"))	
	(sleep_until (volume_test_players vol_lb_switch_room) 10)
	(set s_lb_progression 20)
	(if b_debug (print "s_lb_progression = 20"))
	(sleep_until (volume_test_players vol_lb_near_guardian_room) 10)
	(set s_lb_progression 30)
	(if b_debug (print "s_lb_progression = 30"))
	(sleep_until (volume_test_players vol_lb_guardian_room) 10)
	(set s_lb_progression 40)
	(if b_debug (print "s_lb_progression = 40"))
	(sleep_until (volume_test_players vol_lb_final_room) 10)
	(set s_lb_progression 50)
	(if b_debug (print "s_lb_progression = 50"))
)

(script dormant lightbridge
	(if b_debug (print "Starting lightbridge"))
	(game_save)
		
	(wake lb_player_progression)	
	(wake md_lb_gs_go_to_switch)
	(wake md_lb_gs_next)
	(wake background_lightbridge)
	(wake bd_get_inside_shaft)
	(wake lb_manage_kill_volume)
	(wake 070_music_09)
	
	;Manage the lightbridge population
	(wake lb_manage_constructor_position)
	(wake lb_manage_sentinel_spawning)
	
	(data_mine_set_mission_segment "070_040_lightbridge")
	
	;Clear the objective to get through the forerunner wall
	(objective_2_clear)
	
	(ai_place for_lb_constructors)
	
	(sleep_until (>= s_lb_progression 10) 10)
	(ai_place for_lb_sentinel_intro)
	(sleep 60)
	(unit_close lb_emitter_0)
	
	(sleep_until (>= s_lb_progression 15) 10)	
	(wake lb_manage_lightbridge)
	;Stop 070_music_085
	(set b_070_music_085 0)
	;Stop 070_music_086
	(set b_070_music_086 0)
	;Start 070_music_09
	(set b_070_music_09 1)
	
	;Have GS guide you with interior distance values
	(set s_gs_walkup_dist 3)
	(set s_gs_talking_dist 4)
	(set g_gs_1st_line 070MH_450)
	(set g_gs_2nd_line 070MK_150)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
)

(script static void lightbridge_cleanup
	(ai_disposable gr_for_lb true)
	
	(object_destroy_folder veh_lb)

	(sleep_forever lb_player_progression)
	(sleep_forever lightbridge)
	
	(set s_lb_progression 200)
	
	(add_recycling_volume vol_lb_recycle 0 5)
)

;***************************************************************
********************* Big Battle (BB) **************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
;Progression of the player (cannot go backward i.e. from 3 to 2)
(global short s_bb_progression 0)
;Current position of the player (can go backward i.e. from 3 to 2)
(global short s_bb_position 0)
;That variable tells the thread that monitors the player progression
;to monitor from that new progression number from now on
(global short s_bb_skip_progression 0)
;When this variable is on, covenant vehicles don't shoot,
;so that we can save the game
(global boolean b_bb_trying_save 0)
;Determine if the player skipped the canyon part or not
(global boolean b_bb_player_went_canyon 0)
;Whether or not the guys in the rocks of the 3rd level are dropped yet
(global boolean b_bb_dropped_3rd_floor 0)
;Whether or not the guys in the cache are dropped yet
(global boolean b_bb_dropped_cache_defense 0)
;Should the ghosts be standing near the wraiths?
(global boolean b_bb_ghosts_escort_wraiths 0)
;Whether or not the wraith at the beginning of the level is dropped yet
(global boolean b_bb_wraith_dropped 0)
;Whether or not the warthog at the beginning has been spawned yet
(global boolean b_bb_warthog_spawned 0)
;Turns on when the scarab notices you!
(global boolean b_bb_scarab_battle_begun 0)
;Was the scarab spawned yet?
(global boolean bb_scarab_spawned 0)
;Was the first fake scarab created?
(global boolean b_bb_scarab_over_head_created 0)
;Variables necessary to go though an object list
(global short s_bb_list_index 0)
(global short s_bb_list_count 0)
(global unit obj_bb_current_unit none)
(global object_list ol_bb_vehicles (players))
;Save the scarab as an object
(global object obj_bb_scarab none)
;tells your allies when to advance
(global short s_bb_allies_progression 0)
(global boolean b_bb_shipmaster_dialog_finished 0)
(global boolean b_bb_phantom_retreat 0)


;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_bb_entrance_reinf_0
	(cs_shoot true)
	(cs_go_to pts_bb_entrance_reinf/p0)
	(cs_abort_on_damage true)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_face true pts_bb_entrance_reinf/face_at)
	(sleep_until (>= s_bb_progression 50))
)

(script command_script cs_bb_entrance_reinf_1
	(cs_shoot true)
	(cs_go_to pts_bb_entrance_reinf/p1)
	(cs_abort_on_damage true)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_face true pts_bb_entrance_reinf/face_at)
	(sleep_until (>= s_bb_progression 50))
)

(script command_script cs_bb_entrance_reinf_2
	(cs_shoot true)
	(cs_go_to pts_bb_entrance_reinf/p2)
	(cs_abort_on_damage true)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_face true pts_bb_entrance_reinf/face_at)
	(sleep_until (>= s_bb_progression 50))
)

(script command_script cs_bb_entrance_reinf_3
	(cs_shoot true)
	(cs_go_to pts_bb_entrance_reinf/p3)
	(cs_abort_on_damage true)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_face true pts_bb_entrance_reinf/face_at)
	(sleep_until (>= s_bb_progression 50))
)

(script command_script cs_bb_ghost_intro
	(cs_enable_moving true)
	(cs_vehicle_boost true)
	(cs_shoot true)
	(sleep 120)
)

(script command_script cs_bb_wraiths_shoot_rnd_move
	(cs_enable_moving true)
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_force_combat_status 3)
	(cs_abort_on_damage true)
	(sleep_until
		(begin
			(begin_random
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p6))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p7))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p8))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p9))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p10))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p11))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p12))
					(sleep 30)
					(cs_shoot false)
				)
			)
		0)
	)
)

;*(script command_script cs_bb_wraiths_shoot_rnd
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_force_combat_status 3)
	(cs_abort_on_damage true)
	(sleep_until
		(begin
			(begin_random
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p6))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p7))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p8))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p9))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p10))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p11))
					(sleep 30)
					(cs_shoot false)
				)
				(begin
					(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_wraiths/p12))
					(sleep 30)
					(cs_shoot false)
				)
			)
		0)
	)
)*;


(script command_script cs_bb_stay_alert
	(cs_enable_moving true)
	(cs_shoot true)
	(cs_enable_targeting true)
	(sleep_until
		(begin
			(cs_force_combat_status 3)
			(if b_bb_trying_save 
				(cs_shoot false)
				(cs_shoot true)
			)
		0)	
	30)
)

(script command_script cs_bb_tanks
	(cs_enable_moving true)
	(cs_shoot true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_vehicle_speed 0.3)
	(sleep_forever)
)

(script dormant bb_manage_intro_warthog
	;Place the warthog with his chasers
	(ai_place allies_bb_player_warthog)
	(sleep 1)
	(set b_bb_warthog_spawned 1)
	
	;Make sure the warthog doesn't attack the phantom
	;(ai_disregard (ai_actors cov_bb_front_phantom) true)
	;Warthog is invincible for now (we don't want him to die from the ghosts)
	(ai_cannot_die allies_bb_player_warthog true)
	(object_cannot_die (ai_vehicle_get_from_starting_location allies_bb_player_warthog/driver) true)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location allies_bb_player_warthog/driver))

	(sleep_until 
		(or
			(not (unit_in_vehicle allies_bb_player_warthog/driver))
			(<= (objects_distance_to_object (players) (ai_get_object allies_bb_player_warthog/driver)) 1.5)
		)
	1)
	
	(cs_run_command_script allies_bb_player_warthog/driver cs_end)
	(unit_exit_vehicle allies_bb_player_warthog/driver)
	
	;Wait until the driver has exited his vehicle
	(sleep_until (not (unit_in_vehicle allies_bb_player_warthog/driver)))
	
	(wake md_bb_marine_hop_in)
	(if b_debug (print "reserving the warthog driver seat"))
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location allies_bb_player_warthog/driver) "warthog_d" true)
	(sleep_until (player_in_a_vehicle) 30 600)
	(if b_debug (print "cancelling the warthog driver seat reservation"))
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location allies_bb_player_warthog/driver) "warthog_d" false)
)

(script command_script cs_bb_warthog
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_abort_on_vehicle_exit true)
	;(cs_ignore_obstacles true)
	(cs_go_to pts_bb_warthog/p0)
	;(cs_go_to pts_bb_warthog/p1)
	;(cs_go_to pts_bb_warthog/p2)
	;(cs_go_to pts_bb_warthog/p3)
	(cs_go_to pts_bb_warthog/p4)
	(cs_go_to pts_bb_warthog/p5)
	;Continue warthog ride only if the player is not in the way
	(if (<= s_bb_progression 10)
		(begin
			(cs_vehicle_speed 0.5)
			(cs_go_to pts_bb_warthog/p6)
			(cs_go_to pts_bb_warthog/p7)
		)
	)
	
	;Exit vehicle
	(unit_exit_vehicle ai_current_actor)
)

(script command_script cs_bb_warthog_gunner
	(cs_shoot false)
	(cs_abort_on_vehicle_exit true)
	;(cs_enable_targeting true)
	;(cs_enable_looking true)
	(sleep_until (not (volume_test_object vol_bb_canyon ai_current_actor)))
	(sleep (random_range 60 120))
	(ai_cannot_die ai_current_actor false)
	(ai_kill ai_current_actor)
)

(script command_script cs_bb_warthog_passenger
	(cs_shoot true)
	(cs_abort_on_vehicle_exit true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_enable_moving true)
	(sleep_until (not (unit_in_vehicle allies_bb_player_warthog/driver)))
	(unit_exit_vehicle ai_current_actor)
)

(script command_script cs_bb_ghost_retreat_0
	(cs_abort_on_vehicle_exit true)
	(cs_go_to pts_bb_ghosts/p0)
)

(script command_script cs_bb_ghost_retreat_1
	(cs_abort_on_vehicle_exit true)
	; Make that thing work only for a retreating behavior
	(if (not (volume_test_players vol_bb_canyon_middle))
		(cs_go_to pts_bb_ghosts/p1)
	)
)

(script command_script cs_bb_phantom_retreat
	(vehicle_unload (ai_vehicle_get_from_starting_location cov_bb_front_phantom/pilot) "phantom_lc")
	(sleep 60)
	(set b_bb_wraith_dropped 1)
	
	(ai_set_blind ai_current_actor false)
	(cs_fly_to pts_bb_front_phantom/p7)
)

(script command_script cs_bb_phantom_drop
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_fly_to pts_bb_front_phantom/p1)
	(ai_trickle_via_phantom cov_bb_front_phantom/pilot cov_bb_flak_cannon)
	(set b_bb_dropped_3rd_floor 1)
	(set b_bb_dropped_cache_defense 1)
	(cs_run_command_script ai_current_actor cs_bb_phantom_exit)
)

(script command_script cs_bb_phantom_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot false)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	
	(kill_players_in_volume vol_bb_kill_players)
	
	(object_set_phantom_power (ai_vehicle_get_from_starting_location cov_bb_front_phantom/pilot) FALSE)
	(cs_fly_to_and_face pts_bb_front_phantom/p2 pts_bb_front_phantom/p3)
	(cs_fly_to pts_bb_front_phantom/p3)
	(cs_fly_to pts_bb_front_phantom/p4)
	(ai_erase (ai_get_squad ai_current_actor))
)
;*
(script command_script cs_bb_scarab_shoot_random
	(sleep_until 
		(begin
			(cs_shoot false)
			(cs_go_to pts_bb_scarab/p0)
			(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_scarab/shoot_at_0))
			(sleep 30)
			(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_scarab/shoot_at_0))
			(sleep 30)
			(cs_shoot false)
			(cs_go_to pts_bb_scarab/p1)
			(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_scarab/shoot_at_1))
			(sleep 30)
			(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_scarab/shoot_at_1))
			(sleep 30)
		0)
	)
)
*;

;*
(script command_script cs_bb_scarab_shoot_sky
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_face true pts_bb_scarab/shoot_at_0)
	(sleep_until (objects_can_see_flag (ai_get_object ai_current_actor) flg_bb_sky 20) 30 300)
	
	(cs_shoot false)
	(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_scarab/shoot_at_0))
	(sleep 60)
	(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_scarab/shoot_at_0))
	(sleep 60)
	(cs_shoot false)
	(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_scarab/shoot_at_1))
	(sleep 60)
	(if (not b_bb_trying_save) (cs_shoot_point true pts_bb_scarab/shoot_at_1))
	(sleep 60)
)*;

(script command_script cs_bb_teleport_scorpion_0
	(cs_teleport pts_bb_scorpions/spawn_0 pts_bb_scorpions/face_at)
	(cs_move_in_direction -90 0.2 0)
	(cs_run_command_script ai_current_actor cs_bb_scorpion_dumb)
)

(script command_script cs_bb_teleport_scorpion_1
	(cs_teleport pts_bb_scorpions/spawn_1 pts_bb_scorpions/face_at)
	(cs_move_in_direction -90 0.3 0)
	(cs_run_command_script ai_current_actor cs_bb_scorpion_dumb)	
)

(script command_script cs_bb_teleport_scorpion_2
	(cs_teleport pts_bb_scorpions/spawn_2 pts_bb_scorpions/face_at)
	(cs_move_in_direction -90 0.3 0)
	(cs_run_command_script ai_current_actor cs_bb_scorpion_dumb)	
)

(script command_script cs_bb_scorpion_dumb
	;(cs_enable_pathfinding_failsafe true)
	;(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	
	;(cs_go_to pts_bb_scorpions/door 20)
	(sleep_until g_null)
)

(script command_script cs_bb_scarab_around_wall
	(cs_custom_animation "objects\giants\scarab\cinematics\vignettes\070vd_scarab_over_wall\070vd_scarab_over_wall" "070vd_scarab_around_wall" false)
	(set bb_scarab_spawned 1)
)

(script command_script cs_bb_canyon_turret
	(cs_enable_looking true)
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_abort_on_damage true)
	(sleep_until (>= s_bb_progression 50))
)


;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script static void bb_teleport_scorpions
	(device_set_position_immediate bb_scorpion_door 1)
	(sleep 1)
	(cs_run_command_script allies_bb_scorpion_0 cs_bb_teleport_scorpion_0)
	(cs_run_command_script allies_bb_scorpion_1 cs_bb_teleport_scorpion_1)
	(cs_run_command_script allies_bb_scorpion_2 cs_bb_teleport_scorpion_2)
	
	;Place the scorpions!
	;(if (<= (ai_in_vehicle_count allies_bb_scorpion_0) 0)
	;	(ai_place allies_bb_scorpion_0)
	;)
	;(if (<= (ai_in_vehicle_count allies_bb_scorpion_1) 0)
	;	(ai_place allies_bb_scorpion_1)
	;)
	;(if (<= (ai_in_vehicle_count allies_bb_scorpion_2) 0)
	;	(ai_place allies_bb_scorpion_2)
	;)
)

;Reserve / unreserve every vehicle in the Big battle space
(script static void (bb_reserve_all_vehicles (boolean b_reserve))
	(set ol_bb_vehicles (volume_return_objects_by_type vol_bb_bottom_floor 2))
	(set s_bb_list_count (list_count ol_bb_vehicles))
	(set s_bb_list_index 0)
	(sleep_until
		(begin
			(set obj_bb_current_unit (unit (list_get ol_bb_vehicles s_lb_list_index)))
			;Is the driver in the human team?
			(if (= (unit_get_team_index (vehicle_driver obj_bb_current_unit)) 2)
				(ai_vehicle_reserve (ai_vehicle_get (object_get_ai obj_bb_current_unit)) b_reserve)
			)
			(set s_bb_list_index (+ s_bb_list_index 1))
			(> s_bb_list_index s_bb_list_count)
		)
	1)

)

;Heal your allies every now and then so that they don't die right in the heat of the battle
(script dormant bb_heal_allies_warthog
	(sleep_until b_bb_warthog_spawned)
	(sleep_until
		(begin
			(ai_renew allies_bb_player_warthog)
			b_bb_scarab_battle_begun
		)
	150)
)

(script dormant bb_heal_allies_tanks
	(sleep_until
		(begin
			(ai_renew allies_bb_scorpion_0)
			(ai_renew allies_bb_scorpion_1)
			(ai_renew allies_bb_scorpion_2)
			b_bb_scarab_battle_begun
		)
	150)
)

(script dormant bb_wake_wraiths
	(sleep_until (>= s_bb_progression 40))
	(ai_place cov_bb_wraith_2)
	(cs_run_command_script cov_bb_wraith_0/driver cs_end)
	(cs_run_command_script cov_bb_wraith_1/driver cs_bb_wraiths_shoot_rnd_move)
	(cs_run_command_script cov_bb_wraith_2/driver cs_bb_wraiths_shoot_rnd_move)	
	(cs_run_command_script cov_bb_wraith_3/driver cs_bb_wraiths_shoot_rnd_move)	
	

	;Activate wraiths as soon as the player 
	;or the tanks are too close
	(sleep_until 
		(or
			(>= s_bb_progression 55)			
			(>= (ai_task_count obj_bb_allies/1st_floor) 1)
		)
	)	
	
	(cs_run_command_script cov_bb_wraith_0/driver cs_end)	
	(cs_run_command_script cov_bb_wraith_1/driver cs_end)
		
	(sleep_until 
		(OR
			(>= s_bb_progression 60)
			(>= (ai_task_count obj_bb_allies/2nd_floor) 1)
		)
	)
	(cs_run_command_script obj_bb_allies/3rd_floor cs_end)
	
	(cs_run_command_script cov_bb_wraith_2/driver cs_end)
	(cs_run_command_script cov_bb_wraith_3/driver cs_end)	
)

;Spawn the base defense guys...
(script dormant bb_manage_base_defense
	(sleep_until
		(and
			(or
				(object_model_target_destroyed bb_scarab "indirect_engine")
				(<= (ai_living_count cov_bb_scarab) 0)
			)
			bb_scarab_spawned
			(or
				(volume_test_players vol_abb_spawn_base)
				b_bb_shipmaster_dialog_finished
			)
		)
	)
	(data_mine_set_mission_segment "070_053_after_big_battle") 
	(ai_place cov_abb_base_grt_pack)	
	(sleep 1)
	(ai_place cov_abb_base_jck_0)
	(sleep 1)
	(ai_place cov_abb_base_jck_1)
	;Make sure the jackals do not attack the pelican
	(ai_disregard (ai_actors allies_abb_pelican) true)
	
	(sleep_until (>= s_abb_progression 2) 10)
	(ai_place cov_abb_base_jackals)
	(sleep 1)
	(ai_place cov_abb_base_brutes)
	(sleep 1)
	
	(sleep_until (>= s_abb_progression 5) 10)
	(ai_place cov_abb_base_jck_2)
	(sleep 1)
	(ai_place cov_abb_base_brt_middle)
	(sleep 1)
	(ai_place cov_abb_base_brt_top)
	
	;Make sure the jackals do not attack the pelican
	(ai_disregard (ai_actors allies_abb_pelican) true)
	
	(sleep_until b_abb_pelican_arrived 30 1800)
	(sleep 300)
	(ai_disregard (ai_actors allies_abb_pelican) false)
	(ai_disregard (ai_actors gr_marines) false)
)

(script dormant bb_manage_stop_scarab_battle
	(sleep_until 
		(and
			(or
				(object_model_target_destroyed bb_scarab "indirect_engine")
				(<= (ai_living_count cov_bb_scarab) 0)
			)			
			bb_scarab_spawned
		)
	)
	
	(sound_impulse_stop "sound\dialog\070_waste\mission\070MQ_010_pot.sound")
	(sound_impulse_stop "sound\dialog\070_waste\mission\070MQ_020_pot.sound")
	(sound_impulse_stop "sound\dialog\070_waste\mission\070MQ_030_pot.sound")
	
	(sleep_forever bb_manage_scarab_battle_reinf)
	;(sleep_forever bb_manage_scarab_battle)
	(sleep_forever md_bb_scarab_radio)
	(sleep_forever md_bb_scarab_hint_interior)
	(sleep_forever md_bb_scarab_hint)
	
	(sleep_until 
		(and
			(<= (ai_living_count cov_bb_scarab) 0)
			bb_scarab_spawned
		)
	)
	(ai_kill gr_cov_bb_scarab_troops)
)

(script dormant bb_manage_scarab_battle_reinf
	(sleep_until (<= (ai_living_count gr_allies_bb) 4))	
	(ai_place allies_bb_warthog_reinf_0)
	(sleep 1)
	(sleep_until (<= (ai_living_count gr_allies_bb) 4))
	(ai_place allies_bb_warthog_reinf_1)
	(sleep 1)
	(sleep_until (<= (ai_living_count gr_allies_bb) 4))
	(ai_place allies_bb_warthog_reinf_2)
)

;Spawn the guys on top of the scarab, and wake the scarab up
(script dormant bb_manage_scarab_battle
	(sleep_until 
		(and
			(>= s_bb_progression 80)
			bb_scarab_spawned
		)
	)
	(wake bb_manage_stop_scarab_battle)
	(wake bb_manage_scarab_battle_reinf)
	(wake md_bb_scarab_hint)
	;(wake bb_allies_friendly_fire)
	
	(sleep_until (not (unit_is_playing_custom_animation cov_bb_scarab)))
	
	(ai_place cov_bb_scarab_snipers)
	(sleep 1)
	(ai_place cov_bb_scarab_brt_pck_0)
	(sleep 30)
	(ai_place cov_bb_scarab_jackals_0)
	(sleep 1)
	(ai_place cov_bb_scarab_jackals_1)
	(sleep 1)
	(set b_bb_scarab_battle_begun 1)
	(if (>= (ai_living_count cov_bb_scarab) 1)
		(data_mine_set_mission_segment "070_052_big_battle_scarab")
	)
	
	;Make sure the tanks and warthog see the scarab (it's so big anyway...)
	(ai_magically_see gr_allies_bb_scorpion cov_bb_scarab)
	(ai_magically_see allies_bb_player_warthog cov_bb_scarab)
	;Scarab sees the scorpions
	(ai_magically_see cov_bb_scarab gr_allies_bb_scorpion)
	
	(sleep_until
		(or
			(>= (object_buckling_magnitude_get bb_scarab) 0.5)
			(object_model_target_destroyed bb_scarab "indirect_engine")
		)
	)
	
	;Start Scarab buckling
	(set s_070_music_10 (max s_070_music_10 4))
	
	(sleep_until (object_model_target_destroyed bb_scarab "indirect_engine") 10)
	;Scarab going to blow
	;Stop 070_music_10	
	(set s_070_music_10 (max s_070_music_10 5))
	
	(sleep_until (<= (ai_living_count cov_bb_scarab) 0) 10)
	;Start 070_music_11
	(set b_070_music_11 1)
	
	(if 
		(and
			b_ee_unlocked
			(>= (game_difficulty_get_real) legendary)
		)
		(ee_main)
	)
)

;Constantly resupply the ghosts
;Only use spawns that player didn't see before
(script dormant bb_resupply_ghosts
	(sleep_until 
		(and
			(>= s_bb_progression 50)
			(<= (ai_task_count obj_bb_cov/entrance_vehicle_1) 0)
		)
	)
	(set b_bb_ghosts_escort_wraiths 1)
	(sleep 15)
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 2))
	(if (< s_bb_progression 50) (ai_place cov_bb_ghosts_1st))
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 2))
	(if (< s_bb_progression 50) (ai_place cov_bb_ghosts_2nd_0))
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 2))
	(if (< s_bb_progression 50) (ai_place cov_bb_ghosts_2nd_1))
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 2))
	(if (< s_bb_progression 50) (ai_place cov_bb_ghosts_2nd_2))
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 2))
	(if (< s_bb_progression 60) (ai_place cov_bb_ghosts_3rd_0))
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 2))
	(if (< s_bb_progression 60) (ai_place cov_bb_ghosts_3rd_1))
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 2))
	(if (< s_bb_progression 60) (ai_place cov_bb_ghosts_3rd_2))
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 1))
	(sleep_until bb_scarab_spawned)
	(sleep_until 
		(and
			(not (objects_can_see_flag (players) flg_bb_ghost_spawn 90))
			(not (volume_test_players vol_bb_ghost_spawn))
		)
	15)
	(if (not (object_model_target_destroyed bb_scarab "indirect_engine")) (ai_place cov_bb_scarab_ghost_0))
	(sleep_until (<= (ai_living_count gr_cov_bb_ghosts) 1))
	(sleep_until 
		(and
			(not (objects_can_see_flag (players) flg_bb_ghost_spawn 90))
			(not (volume_test_players vol_bb_ghost_spawn))
		)
	15)
	(if (not (object_model_target_destroyed bb_scarab "indirect_engine")) (ai_place cov_bb_scarab_ghost_1))
)

;Determine if the player dropped down or went into the canyon
(script dormant bb_analyze_route
	(sleep_until
		(or
			(volume_test_players vol_bb_dropdown)
			(volume_test_players vol_bb_canyon)
		)
	)
	(if (volume_test_players vol_bb_canyon)
		(set b_bb_player_went_canyon true)
	)
	
	;Make sure that if a player ever goes in the dropdown, the 
	;progression system knows about it
	(sleep_until (volume_test_players vol_bb_dropdown))
	(set s_bb_skip_progression 40)
)

;*(script dormant bb_allies_friendly_fire
	(sleep_until
		(begin
			;If the player is inside the scarab
			(if (volume_test_players vol_bb_scarab)
				(begin
					;don't shoot the scarab!
					(ai_disregard (ai_actors cov_bb_scarab) true)
					;Shoot the scarab again when player jumps out of the scarab
					(sleep_until (not (volume_test_players vol_bb_scarab)) 30 5000)
					(ai_disregard (ai_actors cov_bb_scarab) false)
				)
			)
			(and
				(<= (ai_living_count cov_bb_scarab) 0)
				bb_scarab_spawned
			)
		)
	)
)*;
;*
(script dormant bb_spawn_scarab
	(sleep_until 
		(or
			(>= s_bb_progression 70)
			(>= (ai_task_count obj_bb_allies/3rd_floor) 1)
		)
	15)
	;(object_destroy bb_scarab)
	(sleep_forever bb_scarab_over_wall)
	(ai_place cov_bb_scarab)
	(sleep 1)
	(set obj_bb_scarab (ai_get_object cov_bb_scarab))	
	(wake md_bb_scarab_radio)
	
	(sleep 90)
	(wake 070vf_scarab_return)
)
*;
(script dormant bb_recycle_objects
	(sleep_until
		(begin
			(add_recycling_volume vol_bb_recycle 30 10)
			(> s_f1_progression 0)
		)
	(* 10 30))
)

(script dormant bb_allies_progression
	(sleep_until (not (= (ai_task_status  obj_bb_cov/canyon) ai_task_status_exhausted)))
	(set s_bb_allies_progression 10)
	
	(sleep_until (or (>= s_bb_progression 30) (player_in_a_vehicle)))
	(set s_bb_allies_progression 15)
	
	(sleep_until
		(and
			(>= s_bb_progression 40)
			(<= (ai_task_count obj_bb_cov/entrance) 1)
		)
	)
	(set s_bb_allies_progression 20)
	
	(sleep_until
		(and
			(>= s_bb_progression 50)
			(<= (ai_task_count obj_bb_cov/1st_floor) 0)
			(<= (ai_task_count obj_bb_cov/entrance) 1)
		)
	)
	(set s_bb_allies_progression 30)
	
	(sleep_until
		(and
			(>= s_bb_progression 60)
			(<= (ai_task_count obj_bb_cov/2nd_floor) 0)
			(<= (ai_task_count obj_bb_cov/1st_floor) 0)
		)
	)
	(set s_bb_allies_progression 40)
	
	(sleep_until
		(and
			(>= s_bb_progression 70)
			(<= (ai_task_count obj_bb_cov/3rd_floor) 2)
			(<= (ai_task_count obj_bb_cov/2nd_floor) 0)
			(<= (ai_task_count obj_bb_cov/1st_floor) 0)
		)
	)
	(set s_bb_allies_progression 50)
	
	(sleep_until
		(and
			(>= s_bb_progression 80) 
			bb_scarab_spawned 
			(<= (ai_living_count cov_bb_scarab) 0)
			(<= (ai_task_count obj_bb_cov/3rd_floor) 2)
			(<= (ai_task_count obj_bb_cov/2nd_floor) 0)
			(<= (ai_task_count obj_bb_cov/1st_floor) 0)
		)
	)
	(set s_bb_allies_progression 60)
)

(script dormant bb_player_position
	(sleep_until
		(begin
			(if (volume_test_players vol_bb_1st_floor) 
				(set s_bb_position 1)
				(if (volume_test_players vol_bb_2nd_floor) 
					(set s_bb_position 2)
					(if (volume_test_players vol_bb_bottom_floor)
						(set s_bb_position 3)
						(set s_bb_position 0)
					)
				)
			)
			(> s_f1_progression 0)
		)
	)
)

(script dormant bb_player_progression
	(sleep_until
		(or
			(volume_test_players vol_bb_vd_start)
			(>= s_bb_skip_progression 10)
		)
	 5)
	(set s_bb_progression 10)
	(if b_debug (print "s_bb_progression = 10"))

	(sleep_until
		(or
			(volume_test_players vol_bb_canyon_start)
			(>= s_bb_skip_progression 20)
		)
	 5)
	(set s_bb_progression 20)
	(if b_debug (print "s_bb_progression = 20"))
	
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_canyon)
			(>= s_bb_skip_progression 30)
		)
	5)
	(set s_bb_progression 30)
	(if b_debug (print "s_bb_progression = 30"))
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_canyon_middle)
			(>= s_bb_skip_progression 35)
		)
	5)
	(set s_bb_progression 35)
	(if b_debug (print "s_bb_progression = 35"))
		
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_canyon_end)
			(>= s_bb_skip_progression 40)
		)
	5)
	(set s_bb_progression 40)
	(if b_debug (print "s_bb_progression = 40"))
		
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_1st_floor_start)
			(and
				(volume_test_players vol_bb_canyon_end)
				(<= (ai_task_count obj_bb_cov/canyon) 1)
			)
			(>= s_bb_skip_progression 50)
		)
	5)
	(set s_bb_progression 50)
	(if b_debug (print "s_bb_progression = 50"))
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_1st_floor)
			(>= s_bb_skip_progression 55)
		)
	5)
	(set s_bb_progression 55)
	(if b_debug (print "s_bb_progression = 55"))
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_2nd_floor_start)
			(>= s_bb_skip_progression 60)
		)
	5)
	(set s_bb_progression 60)
	(if b_debug (print "s_bb_progression = 60"))
	
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_3rd_floor_start)
			(>= s_bb_skip_progression 70)
		)
	5)
	(set s_bb_progression 70)
	(if b_debug (print "s_bb_progression = 70"))
	
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_4th_floor_start)
			(>= s_bb_skip_progression 80)
		)
	5)
	(set s_bb_progression 80)
	(if b_debug (print "s_bb_progression = 80"))
	
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_base)
			(>= s_bb_skip_progression 90)
		)
	5)
	(set s_bb_progression 90)
	(if b_debug (print "s_bb_progression = 90"))
	
	
	(sleep_until 
		(or
			(volume_test_players vol_bb_base_back)
			(>= s_bb_skip_progression 100)
		)
	5)
	(set s_bb_progression 100)
	(if b_debug (print "s_bb_progression = 100"))
	
	
	(sleep_until 
		(or
			(volume_test_players vol_abb_pelican_lz)
			(>= s_bb_skip_progression 110)
		)
	5)
	(set s_bb_progression 110)
	(if b_debug (print "s_bb_progression = 110"))
)

(script dormant bb_game_save_entrance
	(sleep_until
		(begin
			(sleep_until (volume_test_players vol_bb_1st_floor_start))
			(set b_bb_trying_save 1)
			(if b_debug (print "trying to save..."))
			(sleep_until (game_safe_to_save) 10 150)
			(game_save)
			(sleep 90)
			(set b_bb_trying_save 0)
			(if b_debug (print "stopped trying to save..."))					
			(not (game_safe_to_save))
		)
	)
)

(script dormant bb_game_save_f1
	(sleep_until
		(begin
			(sleep_until (volume_test_players vol_bb_1st_floor))
			(sleep_until (not b_playing_dialogue) 30 150)
			(set b_bb_trying_save 1)
			(if b_debug (print "trying to save..."))
			(sleep_until (game_safe_to_save) 10 150)
			(game_save)
			(sleep 90)
			(set b_bb_trying_save 0)
			(if b_debug (print "stopped trying to save..."))					
			(not (game_safe_to_save))
		)
	)
)

(script dormant bb_game_save_f2
	(sleep_until
		(begin
			(sleep_until (volume_test_players vol_bb_2nd_floor))
			(sleep_until (not b_playing_dialogue) 30 150)
			(set b_bb_trying_save 1)
			(if b_debug (print "trying to save..."))
			(sleep_until (game_safe_to_save) 10 300)
			(game_save)
			(sleep 90)
			(set b_bb_trying_save 0)
			(if b_debug (print "stopped trying to save..."))					
			(not (game_safe_to_save))
		)
	)
)

(script dormant bb_game_save
	(sleep_until (player_in_a_vehicle) 30 900)
	(if (player_in_a_vehicle)
		(begin
			(sleep_until (not b_playing_dialogue) 30 150)
			(set b_bb_trying_save 1)
			(if b_debug (print "trying to save..."))
			(sleep_until (game_safe_to_save) 10 90)
			(game_save)
			(sleep 90)
			(set b_bb_trying_save 0)
			(if b_debug (print "stopped trying to save..."))
		)
	)

	(sleep_until (>= s_bb_progression 30))
	(if (not (volume_test_players vol_bb_dropdown))
		(begin
			(set b_bb_trying_save 1)
			(if b_debug (print "trying to save..."))
			(sleep_until (game_safe_to_save) 10 90)
			(game_save)
			(sleep 90)
			(set b_bb_trying_save 0)
			(if b_debug (print "stopped trying to save..."))
		)
	)

	(sleep_until 
		(AND
			(>= s_bb_progression 30)
			(<= (ai_task_count obj_bb_cov/canyon) 0)
		)
	10)
	(set b_bb_trying_save 1)
	(if b_debug (print "trying to save..."))
	(sleep_until (game_safe_to_save) 10 90)
	(game_save)
	(sleep 90)
	(set b_bb_trying_save 0)
	(if b_debug (print "stopped trying to save..."))
	
	(sleep_until (<= (ai_task_count obj_bb_cov/entrance_vehicle_1) 2))
	(wake bb_game_save_entrance)
	
	(sleep_until (< (ai_living_count gr_cov_bb_1st_floor) 1))
	(wake bb_game_save_f1)
	
	(sleep_until (< (ai_living_count gr_cov_bb_2nd_floor) 1))
	(wake bb_game_save_f2)
	
	(sleep_until (< (ai_living_count gr_cov_bb_3rd_floor) 1))
	(set b_bb_trying_save 1)
	(if b_debug (print "trying to save..."))
	(sleep_until (game_safe_to_save) 10 210)
	(game_save)
	(sleep 90)
	(set b_bb_trying_save 0)
	(if b_debug (print "stopped trying to save..."))
	
	(sleep_until 
		(and
			(<= (ai_living_count cov_bb_scarab) 0)
			bb_scarab_spawned
			(<= (ai_living_count gr_cov_bb_ghosts) 0)
		)
	)
	(sleep 90)
	(set b_bb_trying_save 1)
	(if b_debug (print "trying to save..."))
	(sleep_until (game_safe_to_save) 10 450)
	(game_save)
	(sleep 90)
	(set b_bb_trying_save 0)
	(if b_debug (print "stopped trying to save..."))
)

(script dormant big_battle
	(switch_zone_set 070_020_030)
	
	;(wake bb_manage_kill_vol)
	(wake bb_player_progression)
	(wake bb_player_position)
	(wake bb_manage_scarab_battle)
	(wake bb_game_save)
	(wake bb_resupply_ghosts)
	(wake bb_analyze_route)
	(wake 070VD_scarab_over_wall_intro)
	(wake bb_recycle_objects)
;	(wake bb_spawn_scarab)
	(wake bb_allies_progression)
	(wake 070_music_10)
	(wake 070_music_11)
		
	(data_mine_set_mission_segment "070_050_big_battle_canyon")
	
	;Migrate allies
	(ai_migrate allies_lb_warthog_1 allies_bb_warthog_entrance_0)
	(ai_migrate allies_lb_warthog_2 allies_bb_warthog_entrance_1)
	(ai_migrate allies_lb_scorpion_0 allies_bb_scorpion_0)
	(ai_migrate allies_lb_scorpion_1 allies_bb_scorpion_1)
	(ai_migrate allies_lb_scorpion_2 allies_bb_scorpion_2)
	
	;Place enemies	
	;Spawn a phantom that will prevent you from going too far down
	(ai_place cov_bb_front_phantom)
	(sleep 1)
	(ai_place cov_bb_wraith_0)
	(sleep 1)
	(ai_place cov_bb_wraith_1)
	(sleep 1)
	(ai_place cov_bb_wraith_3)
	(sleep 1)
	(ai_place cov_bb_choppers)
	(sleep 1)
	(ai_place cov_bb_empty_chopper)
	(sleep 1)
	(ai_place cov_bb_canyon_infantry)
	(sleep 1)
	(ai_force_active gr_cov_bb_entrance true)
	(ai_force_active cov_bb_wraith_1 true)
	
	;Attach the wraith on the phantom
	(vehicle_load_magic (ai_vehicle_get_from_starting_location cov_bb_front_phantom/pilot) "phantom_lc" (ai_vehicle_get_from_starting_location cov_bb_wraith_0/driver))
	
	(wake bb_wake_wraiths)
	(wake bb_heal_allies_warthog)
	
	(sleep_until 
		(or
			(>= (device_get_position bb_player_door) 0.22)
			(>= s_bb_progression 30)
		)
	5)
	
	;Start 070_music_10
	(set s_070_music_10 (max s_070_music_10 1))
		
	(sleep_until (>= s_bb_progression 30) 30 450)
	(set b_bb_phantom_retreat 1)
	(sleep_until (>= s_bb_progression 30))
	
	;Spawn some ghosts when the player enters the canyon
	(sleep 30)
	(if b_bb_player_went_canyon
		(begin
			(if b_debug (print "Spawning some ghosts to guide the player in canyon"))
			(if (<= (ai_living_count gr_cov_bb_canyon_vehicles) 1) (ai_place cov_bb_canyon_2))
			(sleep 1)
			(if (<= (ai_living_count gr_cov_bb_canyon_vehicles) 2) (ai_place cov_bb_canyon_3))
			;(sleep_until (>= s_bb_progression 30))
			;(if (<= (ai_living_count gr_cov_bb_canyon_vehicles) 1) (ai_place cov_bb_canyon_4))
			;(sleep 1)
			;(if (<= (ai_living_count gr_cov_bb_canyon_vehicles) 2) (ai_place cov_bb_canyon_5))
			;(sleep 1)
		)
		(if b_debug (print "Not spawning ghosts in canyon - player skipped that part"))
	)
	(if b_debug (print "allied Warthog can now die!"))
	(ai_cannot_die allies_bb_player_warthog false)
	(object_cannot_die (ai_vehicle_get_from_starting_location allies_bb_player_warthog/driver) false)
	(object_can_take_damage (ai_vehicle_get_from_starting_location allies_bb_player_warthog/driver))
	
	;Choppers!
	(ai_place cov_bb_entrance_reinf_0)
	(ai_place cov_bb_entrance_reinf_1)
	(sleep 1)	
		
	(sleep 1)
	(wake bb_heal_allies_tanks)
	
	(wake md_bb_marine_advance_0)
	(wake md_bb_marine_advance_1)
	(wake md_bb_marine_advance_2)
	(wake md_bb_marine_advance_3)
	(wake md_abb_scarab_dead)
	(wake md_abb_shipmaster_reward)

	;Make sure the tanks don't shoot the phantom
	(ai_disregard (ai_actors cov_bb_front_phantom) true)
	
	(sleep_until (>= s_bb_progression 50))
	(data_mine_set_mission_segment "070_051_big_battle_wraiths")	

	;Wait until the player advanced or until the second level covenants are dead
	(sleep_until 
		(OR
			(>= s_bb_progression 60)
			(<= (ai_task_count obj_bb_cov/2nd_floor) 1)
		)
	)
	;Place the 3rd level guys
	(sleep 1)
	(cs_run_command_script cov_bb_front_phantom/pilot cs_bb_phantom_drop)
	(sleep 1)
	(ai_place cov_bb_flak_cannon_reinf)
	
	;Wait until the player advanced or until the third level covenants are dead
	(sleep_until 
		(OR
			(>= s_bb_progression 70)
			(<= (ai_task_count obj_bb_cov/3rd_floor) 1)
		)
	)

	(wake bb_manage_base_defense)
)

(script static void big_battle_cleanup	
	(ai_disposable gr_cov_bb true)
	(ai_disposable allies_bb_scorpion_0 true)
	(ai_disposable allies_bb_scorpion_1 true)
	(ai_disposable allies_bb_scorpion_2 true)
	(ai_disposable allies_bb_player_warthog true)
	(ai_disposable allies_bb_warthog_entrance_0 true)
	(ai_disposable allies_bb_warthog_entrance_1 true)
	
	(object_destroy bb_scarab)
	(object_destroy_folder veh_bb)
	(object_destroy_folder crt_bb)

	(sleep_forever bb_player_progression)
	(sleep_forever bb_player_position)
;	(sleep_forever bb_manage_scarab_battle)
;	(sleep_forever bb_game_save)
;	(sleep_forever bb_resupply_ghosts)
;	(sleep_forever bb_analyze_route)
;	(sleep_forever 070VD_scarab_over_wall_intro)
;	(sleep_forever md_bb_marine_advance_0)
;	(sleep_forever md_bb_marine_advance_1)
;	(sleep_forever md_bb_marine_advance_2)
;	(sleep_forever md_bb_marine_advance_3)
;	(sleep_forever md_abb_scarab_dead)	
;	(sleep_forever bb_heal_allies_warthog)
;	(sleep_forever bb_heal_allies_tanks)
;	(sleep_forever bb_wake_wraiths)
;	(sleep_forever bb_manage_base_defense)
;	(sleep_forever bb_recycle_objects)
;	(sleep_forever bb_allies_friendly_fire)
	(sleep_forever big_battle)
	
	(set s_bb_progression 200)
	
	(add_recycling_volume vol_bb_recycle 0 5)
)

;***************************************************************
******************* After Big Battle (ABB) *************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global boolean b_abb_pelican_arrived 0)
(global ai ai_abb_arbiter allies_abb_arbiter)
(global ai ai_abb_johnson allies_abb_johnson)
(global ai ai_abb_pelican_marines_0 allies_abb_pelican_marines)
(global ai ai_abb_pelican_marines_1 allies_abb_pelican_marines)
(global short s_abb_progression 0)
(global boolean b_abb_start_abb_now 0)
(global boolean b_abb_gs_inside_shaft 0)
(global boolean b_abb_has_started 0)
(global boolean b_abb_pelican_marines_moving 0)
;(global object_list ol_abb_objects_in_the_way none)
(global short s_abb_loop_index 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------


;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
;Remove any vehicle in the way of the shaft entrance
;*
(script dormant abb_vehicle_blocker_fix
	(sleep_until (>= (list_count (volume_return_objects_by_type vol_abb_shaft_entrance 2050)) 0))
	(if b_debug (print "Vehicle or crate blocking the way"))
	(sleep_until (>= s_abb_progression 20))
	(sleep_until (not (player_in_a_vehicle)) 15)
	
	(if b_debug (print "Delete everything in the way!"))
	
		
	(set ol_abb_objects_in_the_way (volume_return_objects_by_type vol_abb_shaft_entrance 2050))
	
	;Destroy all objects near the doorway
	;Filter for crates and vehicles
	
	;Create a "for" loop to kill the objects
	(sleep_until 
		(begin
			(unit_kill (unit (list_get ol_abb_objects_in_the_way s_abb_loop_index)))
			(set s_abb_loop_index (+ s_abb_loop_index 1))
			(>= s_abb_loop_index (list_count ol_abb_objects_in_the_way))
		)
	)
	
	(sleep 60)
	;Wait until the player doesn't see
	;(sleep_until (not (objects_can_see_object (players) (volume_return_objects_by_type vol_abb_shaft_entrance 2050) 30)) 15 900)
	
	;Create a "for" loop to destroy the objects
	(set s_abb_loop_index 0)
	(sleep_until 
		(begin
			(object_destroy (list_get ol_abb_objects_in_the_way s_abb_loop_index))
			(set s_abb_loop_index (+ s_abb_loop_index 1))
			(>= s_abb_loop_index (list_count ol_abb_objects_in_the_way))
		)
	)
)
*;

(script dormant abb_gs_open_door
	;Wait for players to be near in the base
	(sleep_until 
		(or
			(volume_test_players vol_bb_base)
			(volume_test_players vol_bb_base_back)
		)
	)
	;Start teleporting GS if he's really far away
	(sleep_until 
		(begin
			;If GS is not on the base, teleport him upstairs only if nobody sees him
			(if 	(and
					(not (volume_test_object vol_abb_pelican_lz obj_guilty_spark))
					(not (objects_can_see_object (players) obj_guilty_spark 30))
				)
				(object_teleport gr_guilty_spark flg_abb_teleport_gs)
			)
			;Try to do that until the player reaches the second flight of stairs
			(volume_test_players vol_bb_base_back)
		)
	)
	
	;If GS is still not on the base top part, teleport him no matter what
	(if (not (volume_test_object vol_abb_pelican_lz obj_guilty_spark))
		(object_teleport gr_guilty_spark flg_abb_teleport_gs)
	)
	
	;GS works on the door
	(cs_run_command_script gr_guilty_spark cs_abb_guilty_spark_wait)
	
	;Now wait until the player is on top of the stairs
	(sleep_until (volume_test_players vol_abb_storm_in) 5)
	
	;Open the door when the same player that's on top is also seeing GS
	(sleep_until 
		(or
			(player_notice_object vol_abb_storm_in obj_guilty_spark)
			(volume_test_players vol_abb_shaft_entrance)
		)
	5)
	
	;Open the shaft door
	(device_set_power shaft_door 1.0)

	;Guilty spark works on the door inside the shaft
	(wake md_abb_gs_tries_to_close_door)
)

(script dormant abb_player_progression
	(sleep_until 
		(or
			(volume_test_players vol_abb_before_ramp)
			(volume_test_players vol_abb_near_base)
		)			
	15)
	(set s_abb_progression 2)
	(if b_debug (print "s_abb_progression = 2"))
	
	(sleep_until (volume_test_players vol_abb_before_ramp) 15)
	(set s_abb_progression 5)
	(if b_debug (print "s_abb_progression = 5"))	
	
	(sleep_until (volume_test_players vol_abb_halfway_ramp) 15)
	(set s_abb_progression 7)
	(if b_debug (print "s_abb_progression = 7"))		
	
	(sleep_until (volume_test_players vol_abb_pelican_lz) 15)
	(set s_abb_progression 10)
	(if b_debug (print "s_abb_progression = 10"))
	
	;Stop 070_music_11
	(set b_070_music_11 0)
	
	(sleep_until (volume_test_players vol_f1_start) 15)
	(set s_abb_progression 20)
	(if b_debug (print "s_abb_progression = 20"))	
)

(script static void start_after_big_battle
	(ai_disposable gr_covenants true)
	
	(switch_zone_set 070_030_040)
	(sleep 1)
	(object_teleport (player0) flg_after_sc_start_location)
	(object_teleport (player1) flg_after_sc_start_location)	
	(wake after_big_battle)
	(place_guilty_spark abb_guilty_spark/guilty)
	
	(sleep 1)
	
	;Give players BRs (not snipers)
	(unit_add_equipment (player0) br_profile TRUE TRUE)
	(unit_add_equipment (player1) br_profile TRUE TRUE)	
)

;Send the pelican in to drop the Arbiter and some marines
(script dormant after_big_battle
	(sleep 90)
	
	(set b_abb_has_started 1)	
	(switch_zone_set 070_030_040)
	(sleep 1)	
	(if b_debug (print "070_as_arbiter_arrives"))
	(ai_place allies_abb_pelican)
	(sleep 1)
	(ai_place allies_abb_johnson)
	(place_arbiter allies_abb_arbiter/arbiter)
	(ai_place allies_abb_pelican_marines)
	(sleep 1)
	(ai_cannot_die allies_abb_arbiter true)
	(ai_cannot_die allies_abb_johnson true)
	;HACK: convert the AI before assigning it to the variable, 
	;because we need to store a pointer to the actual AI,  
	;not to the starting location
	(set ai_abb_arbiter (object_get_ai (ai_get_object allies_abb_arbiter/arbiter)))
	(set ai_abb_johnson (object_get_ai (ai_get_object allies_abb_johnson/johnson)))
	(set ai_abb_pelican_marines_0 (object_get_ai (ai_get_object allies_abb_pelican_marines/0)))
	(set ai_abb_pelican_marines_1 (object_get_ai (ai_get_object allies_abb_pelican_marines/1)))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_abb_pelican/pilot) "pelican_e" (ai_actors allies_abb_johnson))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_abb_pelican/pilot) "pelican_p_r05" (ai_actors allies_abb_arbiter))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_abb_pelican/pilot) "pelican_p_r03" (ai_actors allies_abb_pelican_marines/0))
	(vehicle_load_magic (ai_vehicle_get_from_starting_location allies_abb_pelican/pilot) "pelican_p_r04" (ai_actors allies_abb_pelican_marines/1))
	(wake md_abb_jon_bring_arb)
	
	(wake abb_gs_open_door)
	
	(cs_run_command_script gr_guilty_spark cs_end)
	(set b_gs_follow_player 0)
	(ai_migrate bb_guilty_spark abb_guilty_spark)
	(sleep 1)
	(ai_cannot_die gr_guilty_spark true)
	
	(if b_debug (print "Guiding the player to go upstairs"))
	;Have GS guide you with exterior distance values
	;(set s_gs_walkup_dist 5)
	;(set s_gs_talking_dist 7)
	;(set g_gs_1st_line 070MI_720)
	;(set g_gs_2nd_line 070MI_730)
	;(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
	
	(wake abb_player_progression)
	(sleep_until (script_finished md_abb_jon_bring_arb) 10)
	;(wake abb_vehicle_blocker_fix)
	
	;Open the shaft door
	(device_set_power shaft_door 1.0)
)

(script static void after_big_battle_cleanup
	(ai_disposable gr_cov_bb true)
	(ai_disposable allies_abb_pelican true)
	(ai_disposable allies_abb_johnson true)
	(ai_erase_inactive gr_marines 0)

;	(sleep_forever md_abb_jon_bring_arb)	
;	(sleep_forever md_abb_gs_tries_to_close_door)
;	(sleep_forever abb_vehicle_blocker_fix)
	(sleep_forever abb_player_progression)
	(sleep_forever after_big_battle)
	
	(set s_abb_progression 200)
		
	(add_recycling_volume vol_bb_recycle 0 5)
)


;***************************************************************
********************** Floor 1 (F1) ****************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_f1_progression 0)
(global boolean b_f1_prepare_to_combat 0)
(global boolean b_f1_allies_wait 0)
(global boolean b_f1_start_now 0)
(global boolean b_f1_combat_started 0)
(global boolean b_f1_combat_finished 0)
(global boolean b_f1_ambiant_finished 0)
(global boolean b_f1_has_started 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant f1_player_progression
	(sleep_until (volume_test_players vol_f1_back) 15 1200)
	(set s_f1_progression 10)
	(if b_debug (print "s_f1_progression = 10"))
	(sleep_until (volume_test_players vol_f1_front) 15)
	(set s_f1_progression 20)
	(if b_debug (print "s_f1_progression = 20"))
	(sleep_until (volume_test_players vol_f1_stairway) 15)
	(set s_f1_progression 30)
	(if b_debug (print "s_f1_progression = 30"))
	
	;Start 070_music_12
	(set b_070_music_12 1)
)

(script dormant f1_close_door
	(device_set_power shaft_door 1.0)
	(device_closes_automatically_set shaft_door 1)
	(shut_door_forever shaft_door)
)

(script dormant floor_1
	;Wait for everybody plus the marines for a little while
	(sleep_until 
		(OR
			(AND
				(volume_test_players vol_f1_start_player)
				(or
					(game_is_cooperative)
					(volume_test_object vol_f1_start obj_arbiter)
				)
				(volume_test_object vol_f1_start allies_abb_pelican_marines)
				(volume_test_object vol_f1_start abb_guilty_spark)
			)
			b_f1_start_now
		)
	1 (* 10 30))

	;Then wait only for the arbiter, GS and one player
	(sleep_until 
		(OR
			(AND
				(volume_test_players vol_f1_start_player)
				(or
					(volume_test_object vol_f1_start obj_arbiter)
					(game_is_cooperative)
				)
				(volume_test_object vol_f1_start abb_guilty_spark)
			)
			b_f1_start_now
		)
	1 (* 10 30))
	
	(sleep_until (volume_test_players vol_f1_start_player) 1)
	
	;If that didn't work, teleport everybody inside the shaft!
	(if (not b_f1_start_now)
		(begin
			(if 
				(and
					(not (volume_test_object vol_f1_start obj_arbiter))
					(not (game_is_cooperative))
				)
				(object_teleport gr_arbiter flg_f1_teleport_ai_2)
			)
			(if (not (volume_test_object vol_f1_start abb_guilty_spark))
				(object_teleport gr_guilty_spark flg_f1_teleport_gs)
			)
			
			(if (not (volume_test_object vol_f1_start allies_abb_pelican_marines/0))
				(object_teleport allies_abb_pelican_marines/0 flg_f1_teleport_ai_0)
			)
			
			(if (not (volume_test_object vol_f1_start allies_abb_pelican_marines/1))
				(object_teleport allies_abb_pelican_marines/1 flg_f1_teleport_ai_1)
			)
		)
	)
	
	(set b_f1_has_started 1)
	(if b_debug (print "Starting floor 1"))
	(if b_debug (print "070_as_locked_in"))
	(if b_debug (print "070BE_FIND_THE_MAPROOM"))
	(wake f1_close_door)
	
	(cs_run_command_script gr_guilty_spark cs_end)
	(set b_gs_follow_player 0)
	(ai_migrate abb_guilty_spark f1_guilty_spark)
	(migrate_arbiter allies_abb_arbiter allies_f1_arbiter)	
	(ai_migrate allies_abb_pelican_marines allies_f1_mar)
	(sleep 1)
	(ai_cannot_die gr_guilty_spark true)
	(ai_renew allies_f1_mar)
	
	(wake vd_343_door_shocker)
	(wake 070_music_12)

	(if (!= g_insertion_index 14)
		(wake 070_chapter_real_men)
	)
	
	(sleep 150)
	(volume_teleport_players_not_inside vol_f1_start flg_f1_start_location_p0)
	
	(game_save)
	
	(prepare_to_switch_to_zone_set 070_040_050_071)
	
	(sleep_until 
		(or
			b_f1_ambiant_finished
			(script_finished vd_343_door_shocker)
		)
	30 3600)
	
	;let guilty do some door work before we open it
	(sleep_until (script_finished vd_stop_343_door_shocker) 30 300)
	
	(unit_add_equipment (unit obj_guilty_spark) no_weapon_profile true false)
	
	(switch_zone_set 070_040_050_071)
	(game_save)
	(data_mine_set_mission_segment "070_060_floor_1")
	(ai_place cov_f1_grt_pack)
	(sleep 15)
	
	(wake background_shaft)
	(wake f1_player_progression)
	(wake md_f1_after_f1)
	
	(device_set_power f1_entrance_door 1.0)
	
	(wake md_f1_sleeping_grunts)	
	
	(sleep_until 
		(or
			(<= (ai_living_count gr_cov_f1) 0)
			(> (ai_combat_status gr_cov_f1) ai_combat_status_active)
		)
	)
	
	(set b_f1_combat_started 1)

	(sleep_until (<= (ai_living_count gr_cov_f1) 0))
	(set b_f1_combat_finished 1)
)

(script static void floor_1_cleanup
	(ai_disposable gr_cov_f1 true)
	
	(object_destroy_folder crt_f1)
		
;	(sleep_forever f1_close_door)
;	(sleep_forever vd_343_door_shocker)
	(sleep_forever f1_player_progression)
	(sleep_forever floor_1)
	
	(set s_f1_progression 200)
	
	(add_recycling_volume vol_f1_recycle 0 5)
)

;***************************************************************
********************** Floor 2 (F2) ****************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global short s_f2_progression 0)
(global boolean b_f2_has_started 0)
(global boolean b_f2_combat_started 0)
(global boolean b_f2_gs_terminal 1)
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
;HACK 1st Playtest - teleport GS if he didn't follow you
(script dormant f2_teleport_gs
	(sleep_until (>= s_f2_progression 40) 15)
	;Teleport only if guilty spark is not with you at that point
	(if (not (volume_test_object vol_f2_all gr_guilty_spark))
		(begin
			(if b_debug (print "F2: teleporting GS"))
			;Teleport to a point when you can't see him
			;(sleep_until (not (objects_can_see_flag (players) flg_f2_teleport_gs 30)))
			;(object_teleport gr_guilty_spark flg_f2_teleport_gs)
			(ai_bring_forward obj_guilty_spark 4)
		)
		(if b_debug (print "F2: not teleporting GS"))
	)
)

(script dormant f2_manage_terminal
	(object_create f2_terminal)
	(objects_attach f2_terminal_base "forerunner_terminal" f2_terminal "")
)

(script dormant f2_player_progression
	(sleep_until (volume_test_players vol_f2_advance_0) 10)
	(set s_f2_progression 10)
	(if b_debug (print "s_f2_progression = 10"))
	(sleep_until (volume_test_players vol_f2_advance_1) 10)
	(set s_f2_progression 20)
	(if b_debug (print "s_f2_progression = 20"))
	(sleep_until (volume_test_players vol_f2_advance_2) 10)
	(set s_f2_progression 30)
	(if b_debug (print "s_f2_progression = 30"))
	(sleep_until (volume_test_players vol_f2_advance_3) 10)
	(set s_f2_progression 40)
	(if b_debug (print "s_f2_progression = 40"))
	(sleep_until (volume_test_players vol_f2_advance_4) 10)
	(set s_f2_progression 50)
	(if b_debug (print "s_f2_progression = 50"))
	(sleep_until (volume_test_players vol_f2_advance_5) 10)
	(set s_f2_progression 60)
	(if b_debug (print "s_f2_progression = 60"))
)

(script dormant floor_2
	(set b_f2_has_started 1)
	(if b_debug (print "Starting floor 2"))
	(game_save)

	; Migrate everybody before cleaning up the previous section
	(ai_migrate allies_f1_mar allies_f2_mar)
	(migrate_arbiter allies_f1_arbiter allies_f2_arbiter)	
	(sleep 1)
	(ai_renew allies_f2_mar)
	
	(ai_migrate f1_guilty_spark f2_guilty_spark)
	(sleep 1)
	(ai_cannot_die gr_guilty_spark true)
		
	; Place guys
	(data_mine_set_mission_segment "070_070_floor_2")
	(ai_place cov_f2_grt_pack)
	(sleep 1)
	
	(wake f2_player_progression)
	(wake f2_intro_stop_dialogs)
	(wake f2_teleport_gs)
	(wake f2_manage_terminal)
	(wake md_f2_gs_next)
)

(script static void floor_2_cleanup	
	(ai_disposable gr_cov_f2 true)
	
	(object_destroy_folder crt_f2)
	
	;(sleep_forever f2_intro_stop_dialogs)
	(sleep_forever f2_player_progression)
	(sleep_forever floor_2)
	
	(set s_f2_progression 200)
	
	(add_recycling_volume vol_f2_recycle 0 5)
)

;***************************************************************
********************** Floor 3 (F3) ****************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global boolean b_f3_combat_started 0)
(global boolean b_f3_grunts_wake_up 0)
(global short s_f3_marine_count 0)
(global short s_f3_p1_progression 0)
(global short s_f3_p2_progression 0)
(global boolean b_f3_p2_started 0)
(global boolean b_f3_p2_gs_guide 0)
(global boolean b_f3_has_started 0)
(global boolean b_f3_p1_int_combat_finished 0)
(global boolean b_f3_p2_combat_finished 0)
(global boolean b_f3_p2_take_combat_outside 0)
(global object_list ol_f3_p1_brutes (players))
(global boolean b_f3_objective_dialog_done 0)
;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_f3_banshee_0
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to pts_f3_banshee/p0)
	(cs_shoot_point true pts_f3_banshee/shoot_at_0)
	(cs_vehicle_speed 0.3)
	(cs_fly_to pts_f3_banshee/p1)
	(cs_shoot_point true pts_f3_banshee/shoot_at_1)
	(cs_vehicle_speed 0.2)
	(cs_fly_to pts_f3_banshee/p2)
	(cs_shoot false)
	(cs_vehicle_speed 0.8)
	(cs_fly_to pts_f3_banshee/p3)
)

(script command_script cs_f3_banshee_flyout
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_looking true)
	(cs_fly_to pts_f3_banshee/p4 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_f3_phantom_0
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face pts_f3_phantom/p0 pts_f3_phantom/face_1)
	(sleep_forever)
)

(script command_script cs_f3_phantom_exit
	(cs_enable_pathfinding_failsafe true)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face pts_f3_phantom/p0 pts_f3_phantom/face_1)
	(sleep_until 
		(or
			(<= (ai_living_count cov_f3_phantom/grunt_0) 0)
			(<= (ai_living_count cov_f3_phantom/grunt_1) 0)
			(>= s_f3_p2_progression 30)
		)
	30 600)
	
	(cs_fly_to_and_face pts_f3_phantom/p2 pts_f3_phantom/face_0 1)
	
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_looking true)
	(cs_vehicle_speed 0.8)
	(cs_fly_to pts_f3_phantom/p3 1)
	(kill_players_in_volume vol_f3_kill_players)
	(cs_fly_to pts_f3_phantom/p4 1)
	(cs_fly_to pts_f3_phantom/p5 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_f3_shoot_arbiter
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true (ai_get_object allies_f3_arbiter))
	(sleep_forever)
)

;*
(script command_script cs_f3_vtol
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_looking true)
	(cs_vehicle_speed 0.5)
	(cs_fly_to pts_f3_vtol/p0)
	(cs_vehicle_speed 0.3)
	(print "VTOL MARINE: Get inside guys, I'll deal with theses!")
	;(cs_run_command_script allies_f3_arbiter cs_f3_arbiter_flyout)
	;(cs_run_command_script cov_f3_phantom cs_f3_phantom_flyout)
	;(cs_run_command_script cov_f3_banshee_1 cs_f3_banshee_flyout)
	(cs_fly_to pts_f3_vtol/p1)
	(cs_fly_to pts_f3_vtol/p2)
	(ai_erase (ai_get_squad ai_current_actor))
)
*;

(script command_script cs_f3_flank_right
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_go_to pts_f3_marine_0/right)
)

(script command_script cs_f3_flank_left
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_go_to pts_f3_marine_0/left)
)

(script command_script cs_f3_p1_go_to_banshee_0
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot false)
	(cs_enable_looking true)
	(cs_enable_targeting false)
	(cs_go_to pts_f3_p1_banshee/p0)
	(sleep_until (>= s_f3_p1_progression 25) 5)
)

(script command_script cs_f3_p1_go_to_banshee_1
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot false)
	(cs_enable_looking true)
	(cs_enable_targeting false)
	(cs_go_to pts_f3_p1_banshee/p1)
	(sleep_until (>= s_f3_p1_progression 25) 5)
)

(script command_script cs_f3_p1_get_in_banshee_0
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot false)
	(cs_enable_looking false)
	(cs_enable_targeting false)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location cov_f3_banshees/banshee_0))
	(sleep_until (unit_in_vehicle ai_current_actor) 5)
	(cs_abort_on_vehicle_exit true)
	
	(cs_fly_to pts_f3_p1_banshee/fly_0)
	(cs_fly_to pts_f3_p1_banshee/fly_1)
	(cs_fly_to pts_f3_p1_banshee/fly_2)
	(object_destroy (ai_vehicle_get ai_current_actor))
	(ai_erase ai_current_actor)
)

(script command_script cs_f3_p1_get_in_banshee_1
	(cs_enable_pathfinding_failsafe true)
	(cs_shoot false)
	(cs_enable_looking false)
	(cs_enable_targeting false)
	(cs_go_to_vehicle (ai_vehicle_get_from_starting_location cov_f3_banshees/banshee_1))
	(sleep_until (unit_in_vehicle ai_current_actor) 5)	
	(cs_abort_on_vehicle_exit true)
	
	(cs_fly_to pts_f3_p1_banshee/fly_3)
	(cs_fly_to pts_f3_p1_banshee/fly_4)
	(cs_fly_to pts_f3_p1_banshee/fly_5)
	(object_destroy (ai_vehicle_get ai_current_actor))
	(ai_erase ai_current_actor)
)

(script command_script cs_f3_p1_intro_brute
	(cs_enable_pathfinding_failsafe true)
	(cs_draw)
	(sleep_until (>= (device_get_position f3_door_2) 0.1) 30 600)
	
	(sound_impulse_start "sound\dialog\combat\brute2\03_strike\charge" ai_current_actor 1)
	(cs_custom_animation "objects\characters\brute\brute" "armored:rifle:shakefist:var1" true)
	(sleep (unit_get_custom_animation_time ai_current_actor))
	(cs_stop_custom_animation)
)


;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant f3_manage_kill_volumes
	(sleep_until
		(begin
			(kill_players_in_volume vol_kill_f3_0)
			(kill_players_in_volume vol_kill_f3_1)
			(kill_players_in_volume vol_kill_f3_2)
			(kill_players_in_volume vol_kill_f3_3)
			
			;Only kill players before they progress to the end of floor 4
			(if (< s_f4_progression 30)
				(begin
					(kill_players_in_volume vol_kill_f3_4)
					(kill_players_in_volume vol_kill_f3_5)			
				)
			)
		0)
	10)
)

(script dormant f3_take_combat_outside
	(sleep_until (>= s_f3_p2_progression 30) 30 1800)
	(if (not (>= s_f3_p2_progression 30))
		(begin
			(set b_f3_p2_take_combat_outside 1)
			(ai_set_objective cov_f3_p2_pack obj_f3_p2_cov_outside)
			(ai_set_objective gr_marines obj_f3_p2_allies_outside)
			(sleep_until
				(or
					(>= s_f3_p2_progression 30)
					(<= (ai_strength cov_f3_p2_pack) 0.75)
					(<= (ai_living_count cov_f3_p2_pack) 3)
				)
			)
			(ai_set_objective cov_f3_p2_pack obj_f3_cov_p2)						
		)
	)
	
	(sleep_until (>= s_f3_p2_progression 30))
	(ai_set_objective gr_marines obj_f3_allies_part_2)
)

(script dormant f3_p2_disregard_marines
	(ai_disregard (ai_get_object allies_f3_mar_wasted) true)
	(ai_disregard (ai_get_object allies_f3_marine) true)
	(sleep_until 
		(or
			(>= s_f3_p2_progression 20)
			b_f3_p2_take_combat_outside
		)
	5)
	(ai_disregard (ai_get_object allies_f3_mar_wasted) false)
	(ai_disregard (ai_get_object allies_f3_marine) false)
)

;HACK 1st Playtest - teleport GS if he didn't follow you
(script dormant f3_teleport_gs
	(sleep_until (>= s_f3_p1_progression 10) 15)
	;Teleport only if guilty spark is not with you at that point
	(if (not 
			(or
				(volume_test_object vol_f3_all gr_guilty_spark)
				(volume_test_object vol_f3_stairway gr_guilty_spark)
			)
		)
		(begin
			(if b_debug (print "F3: teleporting GS"))
			;Teleport to a point when you can't see him
			;(sleep_until (not (objects_can_see_flag (players) flg_f3_teleport_gs 30)))
			;(object_teleport gr_guilty_spark flg_f3_teleport_gs)
			(ai_bring_forward obj_guilty_spark 4)
		)
		(if b_debug (print "F3: not teleporting GS"))
	)
)

(script dormant f3_teleport_allies
	;Marine 0
	(if (not
			(or
				(volume_test_object vol_f2_all allies_f2_mar/0)
				(volume_test_object vol_f3_all allies_f2_mar/0)
				(volume_test_object vol_f2_all allies_f3_p1_mar_0)
				(volume_test_object vol_f3_all allies_f3_p1_mar_0)
			)
		)
		(begin
			(if b_debug (print "F3: teleporting marine 0"))
			(sleep_until (not (objects_can_see_flag (players) flg_f2_teleport_ai_0 30)))
			(object_teleport allies_f2_mar/0 flg_f2_teleport_ai_0)
			(object_teleport allies_f3_p1_mar_0 flg_f2_teleport_ai_0)
		)
		(if b_debug (print "F3: not teleporting marine 0"))
	)
	
	;Marine 1
	(if (not
			(or
				(volume_test_object vol_f2_all allies_f2_mar/1)
				(volume_test_object vol_f3_all allies_f2_mar/1)
				(volume_test_object vol_f2_all allies_f3_p1_mar_1)
				(volume_test_object vol_f3_all allies_f3_p1_mar_1)
			)
		)
		(begin
			(if b_debug (print "F3: teleporting marine 1"))
			(sleep_until (not (objects_can_see_flag (players) flg_f2_teleport_ai_1 30)))
			(object_teleport allies_f2_mar/1 flg_f2_teleport_ai_1)
			(object_teleport allies_f3_p1_mar_1 flg_f2_teleport_ai_1)
		)
		(if b_debug (print "F3: not teleporting marine 1"))
	)
	
	;Arbiter
	(if 
		(and
			(not (game_is_cooperative))
			(not
				(or
					(volume_test_object vol_f2_all obj_arbiter)
					(volume_test_object vol_f3_all obj_arbiter)
				)
			)
		)
		(begin
			(if b_debug (print "F3: teleporting arbiter"))
			;(sleep_until (not (objects_can_see_flag (players) flg_f2_teleport_ai_2 30)))
			(ai_bring_forward obj_arbiter 4)
		)
		(if b_debug (print "F3: not teleporting arbiter"))
	)
)
;*
(script dormant f3_p1_man_banshee_0
	(sleep_until (>= s_f3_p1_progression 25) 1)
	
	(if b_debug (print "Banshee 0: place a new brute"))
	(ai_place cov_f3_banshee_pilot_0)
	
	(sleep 1)
	(ai_cannot_die cov_f3_banshee_pilot_0 true)
	(cs_run_command_script cov_f3_banshee_pilot_0 cs_f3_p1_get_in_banshee_0)
	
	(sleep_until (unit_in_vehicle cov_f3_banshee_pilot_0/pilot) 5 150)
	(ai_vehicle_enter_immediate cov_f3_banshee_pilot_0 (ai_vehicle_get_from_starting_location cov_f3_banshees/banshee_0))
	
	(ai_cannot_die cov_f3_banshee_pilot_0 false)
	
	(sleep_until 
		(or
			(unit_in_vehicle cov_f3_banshee_pilot_0/pilot)
			(<= (ai_living_count cov_f3_banshee_pilot_0) 0)
		)
	5 150)
	
	;Couldn't get to the banshee?
	(if (not (unit_in_vehicle cov_f3_banshee_pilot_0/pilot))
		(begin
			(cs_run_command_script cov_f3_banshee_pilot_0 cs_end)
		)
	)
)

(script dormant f3_p1_man_banshee_1
	(sleep_until (>= s_f3_p1_progression 25))
	
	(if b_debug (print "Banshee 1: place a new brute"))
	(ai_place cov_f3_banshee_pilot_1)
	
	(sleep 1)
	(ai_cannot_die cov_f3_banshee_pilot_1 true)
	(cs_run_command_script cov_f3_banshee_pilot_1 cs_f3_p1_get_in_banshee_1)
	
	(sleep_until (unit_in_vehicle cov_f3_banshee_pilot_1/pilot) 5 150)
	(ai_vehicle_enter_immediate cov_f3_banshee_pilot_1 (ai_vehicle_get_from_starting_location cov_f3_banshees/banshee_1))
	
	(ai_cannot_die cov_f3_banshee_pilot_1 false)
	
	(sleep_until 
		(or
			(unit_in_vehicle cov_f3_banshee_pilot_1/pilot)
			(<= (ai_living_count cov_f3_banshee_pilot_1) 0)
		)
	5 150)
	
	;Couldn't get to the banshee?
	(if (not (unit_in_vehicle cov_f3_banshee_pilot_1/pilot))
		(begin
			(cs_run_command_script cov_f3_banshee_pilot_1 cs_end)
		)
	)
)
*;
(script dormant f3_p1_migrate_allies
	(sleep_until (>= s_f3_p1_progression 10) 5)

	(ai_migrate f2_guilty_spark f3_p1_guilty_spark)
	; Migrate everybody before cleaning up the previous section
	(ai_migrate allies_f2_mar/0 allies_f3_p1_mar_0)
	(ai_migrate allies_f2_mar/1 allies_f3_p1_mar_1)
	(migrate_arbiter allies_f2_arbiter allies_f3_arbiter_follow)
	(sleep 1)
	(ai_cannot_die gr_guilty_spark true)
	(ai_renew allies_f3_p1_mar_0)
	(ai_renew allies_f3_p1_mar_1)
	
	(sleep_until (>= s_f3_p1_progression 30) 5)
	(ai_set_objective f3_p1_guilty_spark obj_f3_gs_outside)
)

(script dormant f3_p2_manage_reinf
	(sleep_until 
		(or
			(volume_test_players vol_f3_p2_spawn_reinf_0)
			(volume_test_players vol_f3_p2_spawn_reinf_1)
			(<= (ai_living_count cov_f3_p2_pack) 0)
			(>= s_f3_p2_progression 50)
		)
	15)
	(ai_place cov_f3_p2_reinf)
)

(script dormant f3_p1_player_progression
	(sleep_until (volume_test_players vol_f3_p1_advance_0) 5)
	(set s_f3_p1_progression 5)
	(if b_debug (print "s_f3_p1_progression = 5"))
	(sleep_until (volume_test_players vol_f3_p1_advance_1) 5)
	(set s_f3_p1_progression 10)
	(if b_debug (print "s_f3_p1_progression = 10"))
	(sleep_until (volume_test_players vol_f3_p1_advance_2) 5)
	(set s_f3_p1_progression 15)
	(if b_debug (print "s_f3_p1_progression = 15"))
	(sleep_until (volume_test_players vol_f3_p1_advance_3) 5)
	(set s_f3_p1_progression 17)
	(if b_debug (print "s_f3_p1_progression = 17"))
	(sleep_until (volume_test_players vol_f3_p1_advance_4) 5)
	(set s_f3_p1_progression 20)
	(if b_debug (print "s_f3_p1_progression = 20"))
	(sleep_until (volume_test_players vol_f3_p1_advance_4_5) 5)
	(set s_f3_p1_progression 25)
	(if b_debug (print "s_f3_p1_progression = 25"))
	(sleep_until (volume_test_players vol_f3_p1_advance_5) 5)
	(set s_f3_p1_progression 30)
	(if b_debug (print "s_f3_p1_progression = 30"))
	(sleep_until (volume_test_players vol_f3_p1_advance_6) 5)
	(set s_f3_p1_progression 40)
	(if b_debug (print "s_f3_p1_progression = 40"))
)


(script dormant f3_p2_player_progression
	(sleep_until (volume_test_players vol_f3_p2_advance_1) 5)
	(set s_f3_p2_progression 10)
	(if b_debug (print "s_f3_p2_progression = 10"))
	(sleep_until (volume_test_players vol_f3_p2_advance_2) 5)
	(set s_f3_p2_progression 20)
	(if b_debug (print "s_f3_p2_progression = 20"))
	(sleep_until (volume_test_players vol_f3_p2_advance_3) 10)
	(set s_f3_p2_progression 30)
	(if b_debug (print "s_f3_p2_progression = 30"))
	(sleep_until (volume_test_players vol_f3_p2_advance_4) 10)
	(set s_f3_p2_progression 40)
	
	(chud_show_arbiter_ai_navpoint false)
	
	(if b_debug (print "s_f3_p2_progression = 40"))
	(sleep_until (volume_test_players vol_f3_p2_advance_5) 10)
	(set s_f3_p2_progression 50)
	(if b_debug (print "s_f3_p2_progression = 50"))
)

(script dormant f3_070LC_after
	(if b_debug (print "070_as_dogfight"))	
	(set b_f3_p2_started 1)
	(game_save)
	(wake f3_p1_stop)	
	(wake 070_evac_objective)
	(wake f3_take_combat_outside)
			
	(data_mine_set_mission_segment "070_081_floor_3_2")
	
	(place_guilty_spark f3_p2_guilty_spark/guilty)	
	(ai_place cov_f3_phantom)
	(sleep 1)	
	(ai_cannot_die gr_guilty_spark true)
	
	(ai_set_objective obj_f3_cov_p1 obj_f3_cov_p2)
	
	(wake f3_p2_player_progression)
	(wake md_f3_gs_secret_dialog)
	(wake md_f3_jon_next)
	(wake f3_p2_manage_reinf)
	
	;Place the arbiter if the game is SP
	(if (game_is_cooperative)
		(begin
			;Otherwise tell GS to guide the player right away
			(set b_f3_p2_gs_guide 1)
			(cs_run_command_script cov_f3_phantom/pilot cs_f3_phantom_exit)
			(cs_run_command_script cov_f3_phantom/grunt_0 cs_end)
			(cs_run_command_script cov_f3_phantom/grunt_1 cs_end)
		)
		(begin
			(place_arbiter allies_f3_arbiter/arbiter)			
			(ai_cannot_die allies_f3_arbiter true)
			(wake md_f3_arb_boards_banshee)
			;Everybody attack the arbiter!
			(ai_prefer_target (ai_get_object allies_f3_arbiter) true)
			(ai_place cov_f3_banshee_0)
			(sleep 1)
			(cs_run_command_script (ai_get_turret_ai cov_f3_phantom 0) cs_f3_shoot_arbiter)
			(ai_cannot_die cov_f3_banshee_0 true)
		)		
	)
		
	;If we have only one marine, place him as the guiding marine
	(if (= s_f3_marine_count 1)
		(begin
			(ai_migrate allies_f3_p1_mar_0 allies_f3_marine)
			(ai_migrate allies_f3_p1_mar_1 allies_f3_marine)
			(ai_teleport allies_f3_marine pts_f3_marine_0/start)			
			(sleep 1)
			(wake md_f3_marines_ambushed)
		)
	)
	;Place the wasted marine only if we had at least two marine alive before
	(if (>= s_f3_marine_count 2)
		(begin
			(ai_migrate allies_f3_p1_mar_0 allies_f3_marine)			
			(ai_teleport allies_f3_marine pts_f3_marine_0/start)			
			(sleep 1)
			(wake md_f3_marines_ambushed)
		
			(ai_migrate allies_f3_p1_mar_1 allies_f3_mar_wasted)
			(ai_teleport allies_f3_mar_wasted pts_f3_marine_1/start)
			(sleep 1)
			(ai_disregard (ai_get_object allies_f3_mar_wasted) true)
			(wake md_f3_marine_stuck)
		)
	)
	
	
	(ai_prefer_target (ai_get_object allies_f3_arbiter) false)
	(ai_place cov_f3_p2_pack)
	(ai_place cov_f3_p2_brute)	
	(wake f3_p2_disregard_marines)
	
	(cinematic_fade_to_gameplay)	
	
	(sleep_until (>= s_f3_p2_progression 20) 5)

	(cs_run_command_script gr_guilty_spark cs_end)
	(ai_set_objective f3_p2_guilty_spark obj_f3_gs_inside)
	
	(sleep 10)
	(set b_f3_combat_started true)
	(game_save)
	
	(sleep_until (<= (ai_living_count gr_cov_f3) 0))
	(set b_f3_p2_combat_finished 1)
	;Have GS guide you with interior distance values
	(set s_gs_walkup_dist 3)
	(set s_gs_talking_dist 4)
	(set g_gs_1st_line 070MH_450)
	(set g_gs_2nd_line 070MK_150)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
	
	(sleep_until (>= s_f3_p2_progression 50) 30 3600)
	(if (< s_f3_p2_progression 50)
		(begin
			(hud_activate_team_nav_point_flag player flg_f3_p2_next 0)
			(sleep_until (>= s_f3_p2_progression 50))
			(hud_deactivate_team_nav_point_flag player flg_f3_p2_next)
		)
	)
)

(script dormant floor_3
	(set b_f3_has_started 1)
	(if b_debug (print "Starting floor 3"))
	(game_save)
	
	(device_operates_automatically_set f3_door_2 0)
	
	(ai_place cov_f3_brt_pack)
	(sleep 1)
	(ai_place cov_f3_jck_right_0)
	(ai_place cov_f3_jck_right_1)
	(sleep 1)
	(ai_place cov_f3_jck_left)
	;(sleep 1)
	;(ai_place cov_f3_banshees)
	
	(wake f3_manage_kill_volumes)
	(wake f3_p1_player_progression)
	(wake f3_070LC_start)
	(wake md_f3_gs_hit_switch)
	(wake objective_3_clear)
	(wake f3_teleport_gs)
	(wake f3_p1_migrate_allies)
	;(wake f3_p1_man_banshee_0)
	;(wake f3_p1_man_banshee_1)
	
	(data_mine_set_mission_segment "070_080_floor_3_1")
		
	(sleep_until (>= s_f3_p1_progression 5) 10 450)
	(device_operates_automatically_set f3_door_2 1)
	
	(sleep_until (not (volume_test_objects vol_f3_interior (ai_actors gr_cov_f3))))
	(set b_f3_p1_int_combat_finished 1)
)

(script dormant f3_p1_stop
	(vs_release guilty_spark)
	(vs_release arbiter)
	(vs_release marine_01)
	(vs_release marine_02)
	(sleep_forever md_f3_gs_hit_switch)
)

(script static void floor_3_cleanup
	(ai_disposable gr_cov_f3 true)
	(ai_disposable allies_f3_arbiter_follow true)
	(ai_disposable allies_f3_p1_mar_0 true)
	(ai_disposable allies_f3_p1_mar_1 true)	
	(ai_disposable allies_f3_arbiter true)
	(ai_disposable allies_f3_marine true)
	(ai_disposable allies_f3_mar_wasted true)
	
;	(sleep_forever f3_070LC_start)
;	(sleep_forever md_f3_gs_hit_switch)

	(sleep_forever f3_p1_player_progression)
	(sleep_forever f3_p2_player_progression)
	(sleep_forever f3_070LC_after)
	(sleep_forever floor_3)
	
	(set s_f3_p1_progression 200)
	(set s_f3_p2_progression 200)
	
	(add_recycling_volume vol_f3_recycle 0 5)
)

;***************************************************************
********************** Floor 4 (F4) ****************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global boolean b_f4_enable_right 0)
(global boolean b_f4_enable_left 0)
(global boolean b_f4_enable_top 0)
(global short b_f4_timer_right 0)
(global short b_f4_timer_left 0)
(global short b_f4_timer_max 6)
(global boolean b_f4_fight_finished 0)
(global boolean b_f4_has_started 0)
(global short s_f4_progression 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_f4_brute_ambush_right
	(cs_shoot true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_face true pts_f4_brutes/throw_at_right)
	(sleep 10)
	(cs_grenade pts_f4_brutes/throw_at_right 1)
	(sleep 90)
)

(script command_script cs_f4_brute_ambush_left
	(cs_shoot true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	;(cs_face true pts_f4_brutes/throw_at_left)
	(cs_go_to pts_f4_brutes/p7)
	(sleep 10)
	(cs_grenade pts_f4_brutes/throw_at_left 1)
	(sleep 90)
)

(script command_script cs_f4_brute_chieftain
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_dialogue true)
	(sleep_until
		(or
			(<= (unit_get_health (unit ai_current_actor)) 0.9)
			(>= s_f4_progression 20)
			(and
				(>= s_f4_progression 15)
				(objects_can_see_object (players) (unit ai_current_actor) 30)
			)
		)
	5 300)
	
	(ai_play_line_at_player ai_current_actor 070MQ_100)
	
	(cs_custom_animation "objects\characters\brute\brute" "armored:rifle:shakefist:var1" true)
	(sleep (unit_get_custom_animation_time ai_current_actor))
	(cs_stop_custom_animation)
	
	(cs_movement_mode ai_movement_combat)
	(cs_go_to pts_f5_chieftain_retreat/p0)
	(cs_go_to_and_face pts_f5_chieftain_retreat/p1 pts_f5_chieftain_retreat/face_at)
	
	(cs_stow)
	(cs_posture_set "act_cheering_1" false)
	(sleep_until (<= (unit_get_health (unit ai_current_actor)) 0.85))
	(cs_go_to pts_f5_chieftain_retreat/p2)
	(sleep_forever)
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant f4_manage_jackals
	(sleep_until 
		(or
			(<= (ai_living_count cov_f4_brt_ambush) 0)
			(>= s_f5_progression 10)
		)
	)
	
	;If player progressed too far already, retreat
	(if (>= s_f5_progression 10)
		(begin
			(ai_set_objective gr_cov_f4 obj_f5_cov)
			(ai_set_objective cov_f4_brt_ambush obj_f5_cov)
		)
		;...otherwise, lead the player to the doorway
		(begin
			(ai_set_objective gr_cov_f4_jackals obj_f4_cov)
		)
	)
)

(script dormant f4_enable_top
	(sleep_until
		(begin
			; Make sure the player is on the second floor for a certain time
			(sleep_until
				(begin
					(sleep_until (volume_test_players vol_f4_2nd_floor))
					(sleep 300)
					(volume_test_players vol_f4_2nd_floor)
				)
			)
			(set b_f4_enable_top 1)
			
			; Then disable the top floor if player stays on the 1st floor
			(sleep_until
				(begin
					(sleep_until (volume_test_players vol_f4_1st_floor))
					(sleep 300)
					(volume_test_players vol_f4_1st_floor)
				)
			)
			(set b_f4_enable_top 0)
		0)
	)
)

(script dormant f4_disable_areas
	(sleep_until 
		(begin
			(if (volume_test_players vol_f4_right)
				(set b_f4_timer_right (min (+ 1 b_f4_timer_right) b_f4_timer_max))
				(set b_f4_timer_right (max (- b_f4_timer_right 1) 0))
			)
			(if (volume_test_players vol_f4_left)
				(set b_f4_timer_left (min (+ 1 b_f4_timer_left) b_f4_timer_max))
				(set b_f4_timer_left (max (- b_f4_timer_left 1) 0))
			)
			; If the player is in the right zone for a certain 
			; amount of time, disable that area
			(if (= b_f4_timer_right b_f4_timer_max)
				(begin
					(set b_f4_enable_right false)
					;(print "DISabling right side...")
				)
				(begin
					; Re-enable the area if the player was in the
					; other space for a shorter while
					(if (> b_f4_timer_left 2)
						(begin
							(set b_f4_enable_right true)
							(if b_debug (print "Enabling right side..."))
						)
					)
				)
			)
			; If the player is in the left zone for a certain 
			; amount of time, disable that area			
			(if (= b_f4_timer_left b_f4_timer_max)
				(begin
					(set b_f4_enable_left false)
					;(print "DISabling left side...")
				)
				(begin
					; Re-enable the area if the player was in the
					; other space for a shorter while
					(if (> b_f4_timer_right 2)
						(begin
							(set b_f4_enable_left true)
							;(print "Enabling left side...")
						)
					)
				)
			)
			; Do this until the brutes are dead
			(< (ai_living_count cov_f4_brt_ambush) 1)
		)
	30)
)
;*
;Wait until the player enters the room and throw a grenade at him
(script dormant f4_ambush
	(sleep_until 
		(OR
			(volume_test_players vol_f4_ambush_right)
			(volume_test_players vol_f4_ambush_left)
			(NOT (= (ai_task_status obj_f4_cov/prepare_for_combat) ai_task_status_occupied))
		)
	10 3600)
	(if (volume_test_players vol_f4_ambush_right)	
		(cs_run_command_script cov_f4_brt_ambush/chieftain cs_f4_brute_ambush_right)
	)
	(if (volume_test_players vol_f4_ambush_left)	
		(cs_run_command_script cov_f4_brt_ambush/chieftain cs_f4_brute_ambush_left)
	)	
)
*;

;HACK 1st Playtest - teleport GS if he didn't follow you
(script dormant f4_teleport_gs
	(sleep_until (volume_test_players vol_f4_right) 5)
	;Teleport only if guilty spark is not with you at that point
	(if (not 
			(or
				(volume_test_object vol_f4_all gr_guilty_spark)
				(volume_test_object vol_f4_stairway gr_guilty_spark)
			)
		)
		(begin
			(if b_debug (print "F4: teleporting GS"))
			;Teleport to a point when you can't see him
			;(sleep_until (not (objects_can_see_flag (players) flg_f4_teleport_gs 30)))
			;(object_teleport gr_guilty_spark flg_f4_teleport_gs)
			(ai_bring_forward obj_guilty_spark 4)
		)
		(if b_debug (print "F4: not teleporting GS"))
	)
)

(script dormant f4_place_ai
	(sleep_until (= (current_zone_set_fully_active) 11) 1)
	(ai_place cov_f4_brt_ambush)
	(sleep 1)
	(ai_place cov_f5_brt_chieftain)
	(sleep 1)
	(ai_place cov_f4_jackals_1)
	(sleep 1)
	(ai_set_active_camo cov_f4_brt_ambush/0 true)
	(ai_set_active_camo cov_f4_brt_ambush/1 true)
	(ai_set_active_camo cov_f4_brt_ambush/2 true)
	(ai_set_active_camo cov_f4_brt_ambush/3 true)

	(unit_set_active_camo cov_f4_brt_ambush/0 true 0)
	(unit_set_active_camo cov_f4_brt_ambush/1 true 0)
	(unit_set_active_camo cov_f4_brt_ambush/2 true 0)
	(unit_set_active_camo cov_f4_brt_ambush/3 true 0)
	
	(wake f4_manage_jackals)
)

(script dormant f4_player_progression
	(sleep_until (volume_test_players vol_f4_start) 10)
	(set s_f4_progression 10)
	(if b_debug (print "s_f4_progression = 10"))
	
	(sleep_until (volume_test_players vol_f4_after_start) 10)
	(set s_f4_progression 15)
	(if b_debug (print "s_f4_progression = 15"))
	
	;Start 070_music_13
	(set b_070_music_13 1)
	
	(sleep_until 
		(or
			(volume_test_players vol_f4_advance_0)
			(volume_test_players vol_f4_1st_floor)
		)
	10)
	(set s_f4_progression 20)
	(if b_debug (print "s_f4_progression = 20"))
	
	(sleep_until (volume_test_players vol_f4_advance_1) 10)
	(set s_f4_progression 30)
	(if b_debug (print "s_f4_progression = 30"))
)

(script dormant floor_4
	(set b_f4_has_started 1)
	(if b_debug (print "Starting floor 4"))
	(if b_debug (print "070_as_ambush"))
	(game_save)
	
	(data_mine_set_mission_segment "070_090_floor_4_1")
	
	(ai_migrate allies_f3_marine allies_f4_marines)
	(ai_migrate allies_f3_mar_wasted allies_f4_marines)
	
	(cs_run_command_script gr_guilty_spark cs_end)
	(set b_gs_follow_player 0)
	(ai_migrate f3_p2_guilty_spark f4_guilty_spark)
	(sleep 1)
	(ai_cannot_die gr_guilty_spark true)
	
	(wake f4_teleport_gs)
	(wake f4_player_progression)
	(wake f4_place_ai)
	(wake 070_music_13)
	
	(sleep_until (= (current_zone_set_fully_active) 11) 1)
	
	(sleep_until 
		(or
			(> (ai_combat_status gr_cov_f4) 3)
			(<= (ai_living_count gr_cov_f4) 0)
		)
	30 3600)

	(wake f4_disable_areas)
	(wake f4_enable_top)
	
	(sleep_until (<= (ai_living_count gr_cov_f4) 0))
	
	(set b_f4_fight_finished 1)
	
	(game_save)
	
	;Have GS guide you with interior distance values
	(set s_gs_walkup_dist 3)
	(set s_gs_talking_dist 4)
	(set g_gs_1st_line 070MM_050)
	(set g_gs_2nd_line 070MM_060)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
	
	(sleep_until b_f5_has_started 30 3600)
	(if (not b_f5_has_started)
		(begin
			(hud_activate_team_nav_point_flag player flg_f4_next 0)
			(sleep_until b_f5_has_started)
			(hud_deactivate_team_nav_point_flag player flg_f4_next)
		)
	)
)

(script static void floor_4_cleanup
	(ai_disposable gr_cov_f4 true)
	
	(object_destroy_folder crt_f4)
	
;	(sleep_forever f4_disable_areas)
;	(sleep_forever f4_enable_top)
	(sleep_forever f4_player_progression)
	(sleep_forever floor_4)
	
	(set s_f4_progression 200)
	
	(add_recycling_volume vol_f4_recycle 0 5)
)

;***************************************************************
********************** Floor 5 (F5) ****************************
****************************************************************;
;------------------------------------------
; GLOBALS
;------------------------------------------
(global boolean b_f5_pelican_arrived 0)
(global boolean b_f5_has_started 0)
(global boolean b_f5_combat_finished 0)
(global boolean b_f5_chieftain_charge 0)
(global boolean b_f5_stop_cheering 0)
(global short s_f5_progression 0)
(global short s_f5_jetpack_action 0)

;------------------------------------------
; COMMAND SCRIPTS
;------------------------------------------
(script command_script cs_f5_pelican
	(cs_enable_pathfinding_failsafe true)
	(cs_fly_to pts_f5_pelican/p0)
	(cs_fly_to pts_f5_pelican/p1)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face pts_f5_pelican/p2 pts_f5_pelican/face)
	(set b_f5_pelican_arrived true)
	(unit_open (ai_vehicle_get ai_current_actor))
	(cs_vehicle_speed 0.2)
	(cs_fly_to_and_face pts_f5_pelican/p3 pts_f5_pelican/face 1)
	(sleep_forever)
)

(script command_script cs_f5_banshee_intro
	(cs_enable_looking true)
	(cs_fly_to pts_f5_banshee/p0 1)
	(cs_fly_to pts_f5_banshee/p1 1)
	(cs_fly_to pts_f5_banshee/p2 1)
	(cs_fly_to pts_f5_banshee/p3 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_f5_vtol_intro
	(cs_enable_pathfinding_failsafe true)
	(cs_enable_looking true)
	(cs_fly_to pts_f5_vtol_intro/p0 1)
	(cs_vehicle_speed 0.7)
	(cs_fly_to pts_f5_vtol_intro/p1)
	(sleep 90)
	(cs_fly_to pts_f5_vtol_intro/p2 1)
	(cs_fly_to pts_f5_vtol_intro/p3 1)
	(ai_erase (ai_get_squad ai_current_actor))
)

(script command_script cs_f5_banshee
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(cs_aim_player true)
	(cs_shoot true)
	(ai_prefer_target (players) true)
	
	(sleep_until 
		(begin
			(cs_shoot true)
			(sleep 15)
			(cs_shoot false)
			(sleep 120)
		0)
	15)
)

(script command_script cs_f5_gs
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_enable_targeting true)
	(sleep_until (volume_test_players vol_f5_viewpoint) 5)
	(sleep_until 
		(or
			(volume_test_players vol_f5_stairs_left)
			(volume_test_players vol_f5_stairs_right)
		)
	5 900)
	
	(cs_enable_moving false)

	(cs_fly_to pts_f5_gs/left_0)
	(sleep 30)
	(cs_fly_to pts_f5_gs/left_1)
	(sleep 30)
	(cs_fly_to pts_f5_gs/left_2)
)

(script command_script cs_f5_cheer_0
	(cs_abort_on_damage true)
	(cs_stow)
	(cs_enable_dialogue true)
	(cs_posture_set "act_guard_2" false)
	(sleep_forever)
)

(script command_script cs_f5_cheer_1
	(cs_abort_on_damage true)
	(cs_stow)
	(cs_enable_dialogue true)
	(cs_posture_set "act_kneel_1" false)
	(sleep_forever)
)

(script command_script cs_f5_cheer_2
	(cs_abort_on_damage true)
	(cs_stow)
	(cs_enable_dialogue true)
	(cs_posture_set "act_gaze_1" false)
	(sleep_forever)
)

(script command_script cs_f5_cheer_3
	(cs_abort_on_damage true)
	(cs_stow)
	(cs_enable_dialogue true)
	(cs_posture_set "act_guard_3" false)
	(sleep_forever)
)

(script command_script cs_f5_cheer_4
	(cs_abort_on_damage true)
	(cs_stow)
	(cs_enable_dialogue true)
	(cs_posture_set "act_guard_4" false)
	(sleep_forever)
)

(script command_script cs_f5_cheer_5
	(cs_abort_on_damage true)
	(cs_stow)
	(cs_enable_dialogue true)
	(cs_posture_set "act_guard_3" false)
	(sleep_forever)
)

(script command_script cs_f5_chieftain
	(cs_abort_on_damage true)
	(cs_movement_mode ai_movement_combat)
	(cs_enable_dialogue true)
	
	(sleep_until 
		(or
			(>= s_f5_progression 15)
			b_f5_stop_cheering
		)
	5)
	
	(cs_go_to pts_f5_brutes/p0)	
	(cs_face_player true)
	(if (< s_f5_progression 20)
		(begin
			(sleep 30)
			(cs_posture_set "act_kneel_1" false)
			
			(sleep_until b_f5_stop_cheering 5 90)
		)
	)
	
	(sleep_until 
		(or
			(>= s_f5_progression 20)
			b_f5_stop_cheering
		)
	5)
	
	(cs_posture_exit)
	(cs_face_player true)
	(cs_draw)
	(sleep 30)
	(ai_play_line_at_player ai_current_actor 070MQ_090)
	(cs_action_at_player ai_action_advance)	
	(sleep_until 
		(or
			(>= s_f5_progression 30)
			b_f5_stop_cheering
		)
	5)
)

(script command_script cs_f5_cheering_brute
	(cs_abort_on_damage true)
	(cs_movement_mode ai_movement_combat)
	(cs_face_player true)
	(cs_enable_dialogue true)
	(unit_only_takes_damage_from_players_team (unit ai_current_actor) true)
	;(cs_face true pts_f5_brutes/face_at)
	(sleep (random_range 0 60))
	(cs_go_to_and_posture (ai_nearest_point ai_current_actor pts_f5_jetpack) "act_cheering_1")
	(sleep (random_range 0 60))
	(sleep_until
		(begin
			(begin_random
				(if (and (not b_f5_stop_cheering) (>= (objects_distance_to_object (players) ai_current_actor) 5))
					(begin
						(cs_stow)
						(cs_face_object true cov_f5_brt_chieftain)						
						(cs_posture_set "act_cheering_1" false)
						;(cs_action_at_object cov_f5_brt_chieftain ai_action_cheer)
						(sleep_until b_f5_stop_cheering 5 (random_range 30 120))
					)
				)
				(if (and (not b_f5_stop_cheering) (>= (objects_distance_to_object (players) ai_current_actor) 5))
					(begin
						(cs_stow)
						(cs_face_player true)						
						(cs_posture_set "act_guard_1" false)
						;(cs_action_at_object cov_f5_brt_chieftain ai_action_cheer)
						(sleep_until b_f5_stop_cheering 5 (random_range 30 120))
					)
				)
				(if (and (not b_f5_stop_cheering) (>= (objects_distance_to_object (players) ai_current_actor) 5))
					(begin
						(cs_stow)
						(cs_face_player true)						
						(cs_posture_set "act_guard_2" false)
						;(cs_action_at_object cov_f5_brt_chieftain ai_action_cheer)
						(sleep_until b_f5_stop_cheering 5 (random_range 30 120))
					)
				)
				(if (and (not b_f5_stop_cheering) (>= (objects_distance_to_object (players) ai_current_actor) 5))
					(begin
						(cs_stow)
						(cs_face_player true)
						(cs_posture_set "act_guard_3" false)
						;(cs_action_at_object cov_f5_brt_chieftain ai_action_cheer)
						(sleep_until b_f5_stop_cheering 5 (random_range 30 120))
					)
				)
				(if (and (not b_f5_stop_cheering) (>= (objects_distance_to_object (players) ai_current_actor) 5))
					(begin
						(cs_stow)
						(cs_face_player true)
						(cs_posture_set "act_guard_4" false)
						;(cs_action_at_object cov_f5_brt_chieftain ai_action_cheer)
						(sleep_until b_f5_stop_cheering 5 (random_range 30 120))
					)
				)
				(if (and (not b_f5_stop_cheering) (< (objects_distance_to_object (players) ai_current_actor) 5))
					(begin
						(if (< (objects_distance_to_object (players) ai_current_actor) 1.5)
							(set b_f5_stop_cheering 1)
						)
						(cs_posture_exit)
						(cs_face_player true)						
						(cs_draw)
						(cs_action_at_player ai_action_taunt)
						(sleep_until b_f5_stop_cheering 5 (random_range 30 120))
					)
				)
			)
			b_f5_stop_cheering
		)
	1)
	
	(cs_posture_exit)
	(cs_draw)
	
	(set s_f5_jetpack_action (+ s_f5_jetpack_action 1))
	
	(cond
		((= s_f5_jetpack_action 1) 
			(begin
				(cs_action_at_player ai_action_advance)
				(if 
					(or 
						(game_is_cooperative)
						(>= (ai_living_count gr_marines) 0)
					)
					(ai_play_line ai_current_actor 070MQ_070)
				)
			)
		)
		((= s_f5_jetpack_action 2) 
			(begin
				(cs_action_at_player ai_action_berserk)
				(ai_play_line ai_current_actor 070MQ_080)
			)
		)
		((= s_f5_jetpack_action 3) (cs_action_at_player ai_action_shakefist))
		((= s_f5_jetpack_action 4) (cs_action_at_player ai_action_signal_attack))
		((= s_f5_jetpack_action 5) (cs_action_at_player ai_action_signal_move))
		((= s_f5_jetpack_action 6) (cs_action_at_player ai_action_shakefist))
     )
)

;------------------------------------------
; DORMANT SCRIPTS
;------------------------------------------
(script dormant f5_manage_cheering_brutes
	(sleep_until (>= s_f5_progression 15) 5)
	
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_0/0) true)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_1/1) true)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_2/2) true)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_3/3) true)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_4/4) true)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_5/5) true)
	
	(ai_prefer_target_ai gr_marines cov_f5_brt_chieftain true)
	
	(cs_run_command_script gr_cov_f5_jetpack cs_f5_cheering_brute)
	
	(sleep 1)
	
	(sleep_until 
		(or
			(<= (ai_living_count cov_f5_brt_chieftain) 0)
			(not (cs_command_script_running cov_f5_jetpack_0/0 cs_f5_cheering_brute))
			(not (cs_command_script_running cov_f5_jetpack_1/1 cs_f5_cheering_brute))
			(not (cs_command_script_running cov_f5_jetpack_2/2 cs_f5_cheering_brute))
			(not (cs_command_script_running cov_f5_jetpack_3/3 cs_f5_cheering_brute))
			(not (cs_command_script_running cov_f5_jetpack_4/4 cs_f5_cheering_brute))
			(not (cs_command_script_running cov_f5_jetpack_5/5 cs_f5_cheering_brute))
		)
	)
	
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_0/0) false)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_1/1) false)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_2/2) false)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_3/3) false)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_4/4) false)
	(unit_only_takes_damage_from_players_team (unit cov_f5_jetpack_5/5) false)
	
	(ai_prefer_target_ai gr_marines cov_f5_brt_chieftain false)
	
	(set b_f5_stop_cheering 1)
	
	(sleep 120)
	
	(cs_run_command_script cov_f5_jetpack_0 cs_end)
	(sleep (random_range 0 15))
	(cs_run_command_script cov_f5_jetpack_4 cs_end)
	(sleep (random_range 0 15))
	(cs_run_command_script cov_f5_jetpack_5 cs_end)
	(cs_run_command_script cov_f5_jetpack_3 cs_end)
	(sleep (random_range 0 15))
	(cs_run_command_script cov_f5_jetpack_2 cs_end)
	(sleep (random_range 0 15))
	(cs_run_command_script cov_f5_jetpack_1 cs_end)
)

(script dormant f5_stop_chieftain_run
	(sleep_until 
		(or
			(<= (objects_distance_to_object (players) cov_f5_brt_chieftain) 2)
			(<= (ai_living_count cov_f5_brt_chieftain/chieftain) 0)
			b_f5_stop_cheering
			b_f5_chieftain_charge
		)
	)
	
	(sleep_forever f5_manage_chieftain)
	(cs_run_command_script cov_f5_brt_chieftain cs_end)
	(set b_f5_chieftain_charge 1)	
)

(script dormant f5_manage_chieftain
	(wake f5_stop_chieftain_run)
	
	(sleep_until (>= s_f5_progression 15) 5)
	(cs_run_command_script cov_f5_brt_chieftain cs_f5_chieftain)
	
	(sleep_until 
		(begin
			(or
				(<= (ai_living_count cov_f5_brt_chieftain/chieftain) 0)
				b_f5_stop_cheering
				(>= s_f5_progression 30)
				(not (cs_command_script_running cov_f5_brt_chieftain/chieftain cs_f5_chieftain))
				(<= (object_get_health f5_holo_generator) 0.9)
			)
		)
	30 3600)
	(set b_f5_chieftain_charge 1)
)

(script dormant f5_manage_allies
	(sleep_until
		(or
			(>= s_f5_progression 15)
			(and
				b_f4_fight_finished
				(>= s_f5_progression 10)
			)
		)
	)
	(ai_migrate allies_f4_marines allies_f5_marines)
)

;HACK 1st Playtest - teleport GS if he didn't follow you
(script dormant f5_teleport_gs
	(sleep_until (volume_test_players vol_f5_viewpoint) 5)
	;Teleport only if guilty spark is not with you at that point
	(if (not (volume_test_object vol_f5_outside gr_guilty_spark))
		(begin
			(if b_debug (print "F5: teleporting GS"))
			;Teleport to a point when you can't see him
			;(sleep_until (not (objects_can_see_flag (players) flg_f5_teleport_gs 30)))
			;(object_teleport gr_guilty_spark flg_f5_teleport_gs)
			(ai_bring_forward obj_guilty_spark 4)
		)
		(if b_debug (print "F5: not teleporting GS"))
	)
)

;HACK 1st Playtest - teleport GS if he didn't follow you
(script dormant f5_teleport_gs_2
	(sleep_until (<= (ai_task_count obj_f5_cov/jetpack_brutes) 0))
	;Teleport only if guilty spark is inside the stairways at that point
	(if (or
			(volume_test_object vol_f5_viewpoint gr_guilty_spark)
			(volume_test_object vol_f5_stairs_left gr_guilty_spark)
			(volume_test_object vol_f5_stairs_right gr_guilty_spark)
		)
		(begin
			(if b_debug (print "F5 - 2: teleporting GS"))
			;Teleport to a point when you can't see him
			;(sleep_until (not (objects_can_see_flag (players) flg_f5_teleport_gs_2 30)))
			;(object_teleport gr_guilty_spark flg_f5_teleport_gs_2)
			(ai_bring_forward obj_guilty_spark 4)
		)
		(if b_debug (print "F5 - 2: not teleporting GS"))
	)
)

(script static void f5_teleport_players_not_outside
	(if
		(not
			(or
				(volume_test_object vol_f5_outside (player0))
				(volume_test_object vol_f5_outside_left (player0))
				(volume_test_object vol_f5_outside_right (player0))
			)
		)
		(object_teleport (player0) flg_f5_start_location_p0)
	)
	(if
		(not
			(or
				(volume_test_object vol_f5_outside (player1))
				(volume_test_object vol_f5_outside_left (player1))
				(volume_test_object vol_f5_outside_right (player1))
			)
		)
		(object_teleport (player1) flg_f5_start_location_p1)
	)
	(if
		(not
			(or
				(volume_test_object vol_f5_outside (player2))
				(volume_test_object vol_f5_outside_left (player2))
				(volume_test_object vol_f5_outside_right (player2))
			)
		)
		(object_teleport (player2) flg_f5_start_location_p2)
	)
	(if
		(not
			(or
				(volume_test_object vol_f5_outside (player3))
				(volume_test_object vol_f5_outside_left (player3))
				(volume_test_object vol_f5_outside_right (player3))
			)
		)
		(object_teleport (player3) flg_f5_start_location_p3)
	)
)

(script dormant f5_player_progression
	(sleep_until 
		(or
			(volume_test_players vol_f5_stairs_right)
			(volume_test_players vol_f5_stairs_left)
			(volume_test_players vol_f5_outside_no_stairs)
		)
	10)
	(set s_f5_progression 10)
	(if b_debug (print "s_f5_progression = 10"))
	
	(sleep_until 
		(or
			(volume_test_players vol_f5_mc_high_left)
			(volume_test_players vol_f5_mc_high_right)
			(volume_test_players vol_f5_outside_no_stairs)
		)
	10)
	(set s_f5_progression 15)
	(if b_debug (print "s_f5_progression = 15"))
	
	(sleep_until 
		(or
			(volume_test_players vol_f5_near_ring)
			(volume_test_players vol_f5_pass_truth)
		)
	10)
	
	(set s_f5_progression 20)
	(if b_debug (print "s_f5_progression = 20"))	
	
	(sleep_until 
		(or
			(volume_test_players vol_f5_challenge_ring)
			(volume_test_players vol_f5_pass_truth)
		)
	10)
	(set s_f5_progression 30)
	(if b_debug (print "s_f5_progression = 30"))
)

(script dormant floor_5	
	(set b_f5_has_started 1)	
	(if b_debug (print "Starting floor 5"))
	(game_save_no_timeout)
	
	(data_mine_set_mission_segment "070_100_floor_5_1")
		
	(cs_run_command_script gr_guilty_spark cs_end)
	(set b_gs_follow_player 0)	
	(ai_migrate f4_guilty_spark f5_guilty_spark)
	(sleep 1)
	(ai_cannot_die gr_guilty_spark true)
	(cs_run_command_script gr_guilty_spark cs_f5_gs)
	
	(wake f5_teleport_gs)
	(wake f5_player_progression)
	(wake f5_manage_allies)
	
	(ai_place gr_cov_f5_jetpack)
	(sleep 1)
	
	(wake f5_truth_halogram)
	(wake f5_manage_chieftain)
	(wake f5_manage_cheering_brutes)
	(wake f5_teleport_gs_2)
	(wake md_f5_jon_pelican_eta)
	(wake 070_music_14)
	(wake 070_music_15)
	
	(sleep_until b_f5_chieftain_charge)
	;Stop 070_music_13
	(set b_070_music_13 0)
	;Start 070_music_14
	(set b_070_music_14 1)
	;Start 070_music_15
	(set b_070_music_15 1)
	
	(game_save)
	
	(sleep_until (<= (ai_living_count cov_f5_brt_chieftain) 0))
	;Start music F5 01
	;(set b_070_music_f5_01 1)
	
	(sleep_until (<= (ai_living_count obj_f5_cov) 4))
	
	(ai_place cov_f5_snipers_right)
	(sleep 1)
	(sleep_until (<= (ai_living_count obj_f5_cov) 2))
	(sleep_until (<= (ai_living_count obj_f5_cov) 0) 30 3600)
	(ai_kill_silent obj_f5_cov)
	
	;Stop 070_music_14
	(set b_070_music_14 0)
	
	;Have GS guide you with exterior distance values
	(set s_gs_walkup_dist 4)
	(set s_gs_talking_dist 6)
	(set g_gs_1st_line 070MM_310)
	(set g_gs_2nd_line 070MM_320)
	(cs_run_command_script gr_guilty_spark cs_guilty_spark_lead_player)
	(set b_f5_combat_finished 1)
	
	(sleep 30)
	
	(sleep_until (= (current_zone_set_fully_active) 12) 1)
	
	(sleep 30)
	
	(ai_place allies_f5_pelican)
	;Stop music F5 01
	;(set b_070_music_f5_01 0)
	;Start music F5 02
	;(set b_070_music_f5_02 1)
		
	(sleep_until b_f5_pelican_arrived)
	
	;*(sleep_until 
		(or
			(vehicle_test_seat (ai_vehicle_get_from_starting_location allies_f5_pelican/pilot) "" (player0))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location allies_f5_pelican/pilot) "" (player1))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location allies_f5_pelican/pilot) "" (player2))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location allies_f5_pelican/pilot) "" (player3))
		)
	10 900)*;
	(sleep_until (volume_test_players vol_f5_near_pelican) 10 900)
	(if (not (volume_test_players vol_f5_near_pelican))
		(hud_activate_team_nav_point_flag player flg_f5_pelican 0)
	)
	
	;*
	(sleep_until 
		(or
			(vehicle_test_seat (ai_vehicle_get_from_starting_location allies_f5_pelican/pilot) "" (player0))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location allies_f5_pelican/pilot) "" (player1))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location allies_f5_pelican/pilot) "" (player2))
			(vehicle_test_seat (ai_vehicle_get_from_starting_location allies_f5_pelican/pilot) "" (player3))
		)
	5)
	*;
	(sleep_until (volume_test_players vol_f5_near_pelican) 10)	
	
	(sound_looping_start sound\cinematics\070_waste\070ld_pelican_pickup\070ld_pelican_glue\070ld_pelican_glue f5_pelican_location 1)
	(sound_class_set_gain veh 0 60)
		
	(wake f5_070LD_start)
		
	(hud_deactivate_team_nav_point_flag player flg_f5_pelican)
)

;*
(script static void floor_5_cleanup
	(ai_disposable gr_cov_f5 true)
	(ai_disposable allies_f5_vtol_intro true)
	
	;(object_destroy_folder veh_f5)
	(object_destroy_folder crt_f5)
	
	(sleep_forever f5_player_progression)
	(sleep_forever floor_5)
	
	(set s_f5_progression 200)
	
	(background_shaft_cleanup)
)
*;
;===========================================================================================================
;======================================== EE ===============================================================
;===========================================================================================================
(global boolean b_ee_unlocked 0)
(script static void ee_3_a
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p0)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p1)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p2)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p3)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p4)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p5)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p6)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p7)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p8)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p9)
)

(script static void ee_3_b
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p20)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p21)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p22)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p23)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p24)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p25)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p26)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p27)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p28)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_banshee\fx\destruction" pts_ee_343/p29)
)

(script static void ee_4
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p10)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p19)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p12)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p16)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p18)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p17)	
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p13)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p14)	
	
)

(script static void ee_2
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p10)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p30)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p19)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p18)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p17)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p16)	
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p12)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p31)
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p15)	
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p11)	
	(sleep 1)
	(effect_new_at_ai_point "objects\characters\ambient_life\lod_hornet\fx\destruction" pts_ee_343/p14)		
)

(script static void ee_activate
	(sleep_until
		(or
			(and
				(<= (object_get_health crystal_00) 0.1)
				(<= (object_get_health crystal_01) 0.1)
				(<= (object_get_health crystal_02) 0.1)
				(<= (object_get_health crystal_03) 0.1)
				(<= (object_get_health crystal_04) 0.1)	
			)
			b_ex_p1_has_started
		)
	1800)
	(sleep_until
		(or
			(and
				(<= (object_get_health crystal_05) 0.1)
				(<= (object_get_health crystal_06) 0.1)
				(<= (object_get_health crystal_07) 0.1)
				(<= (object_get_health crystal_08) 0.1)
				(<= (object_get_health crystal_09) 0.1)	
			)
			b_ex_p1_has_started
		)
	1800)
	(sleep_until
		(or
			(and
				(<= (object_get_health crystal_10) 0.1)
				(<= (object_get_health crystal_11) 0.1)
				(<= (object_get_health crystal_12) 0.1)
				(<= (object_get_health crystal_13) 0.1)
				(<= (object_get_health crystal_14) 0.1)	
			)
			b_ex_p1_has_started
		)
	1800)
	(sleep_until
		(or
			(and
				(<= (object_get_health crystal_15) 0.1)
				(<= (object_get_health crystal_16) 0.1)
				(<= (object_get_health crystal_17) 0.1)
				(<= (object_get_health crystal_18) 0.1)
				(<= (object_get_health crystal_19) 0.1)		
			)
			b_ex_p1_has_started
		)
	1800)
	(sleep_until
		(or
			(and
				(<= (object_get_health crystal_20) 0.1)
				(<= (object_get_health crystal_21) 0.1)
				(<= (object_get_health crystal_22) 0.1)
				(<= (object_get_health crystal_23) 0.1)
				(<= (object_get_health crystal_24) 0.1)	
			)
			b_ex_p1_has_started
		)
	1800)
	(sleep_until
		(or
			(and
				(<= (object_get_health crystal_25) 0.1)
				(<= (object_get_health crystal_26) 0.1)
				(<= (object_get_health crystal_27) 0.1)
				(<= (object_get_health crystal_28) 0.1)
				(<= (object_get_health crystal_29) 0.1)	
			)
			b_ex_p1_has_started
		)
	1800)
	(sleep_until
		(or
			(and
				(<= (object_get_health crystal_30) 0.1)
				(<= (object_get_health crystal_31) 0.1)
				(<= (object_get_health crystal_32) 0.1)
				(<= (object_get_health crystal_33) 0.1)
				(<= (object_get_health crystal_34) 0.1)	
			)
			b_ex_p1_has_started
		)
	1800)
	
	(if (not b_ex_p1_has_started)
		(set b_ee_unlocked 1)
	)
)

(script static void ee_main
	(sleep_until
		(begin
			(sleep (random_range 900 1800))
			(ee_3_a)
			(sleep 10)
			(ee_4)
			(sleep 10)
			(ee_3_b)
			
			(sleep 30)
			
			(ee_3_a)
			(sleep 10)
			(ee_4)
			(sleep 10)
			(ee_3_b)
			
			(sleep 10)
			(ee_2)
			(sleep 10)
			
			(ee_3_a)
			(sleep 10)
			(ee_4)
			(sleep 10)
			(ee_3_b)
						
			b_f1_has_started
		)	
	)
)

;===========================================================================================================
;============================== AWARD SKULLS ===============================================================
;===========================================================================================================

(script dormant 070_award_primary_skull
    (if (award_skull)
        (begin
            (object_create skull_famine)

            (sleep_until 
                (or
                    (unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
                    (unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
                    (unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
                    (unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
                )
            5)
            
            (if b_debug (print "award famine skull"))
            (campaign_metagame_award_primary_skull (player0) 5)
            (campaign_metagame_award_primary_skull (player1) 5)
            (campaign_metagame_award_primary_skull (player2) 5)
            (campaign_metagame_award_primary_skull (player3) 5)
        )
    )
)



(script dormant 070_award_secondary_skull
    (if (award_skull)
        (begin
            (object_create skull_cowbell)

            (sleep_until 
                (or
                    (unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
                    (unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
                    (unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
                    (unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
                )
            5)
            
            (if b_debug (print "award cowbell skull"))
            (campaign_metagame_award_secondary_skull (player0) 2)
            (campaign_metagame_award_secondary_skull (player1) 2)
            (campaign_metagame_award_secondary_skull (player2) 2)
            (campaign_metagame_award_secondary_skull (player3) 2)
        )
    )
)